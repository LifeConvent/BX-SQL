/******************************************************************************************************************************************** 
                                                               老核心SQL   
 ********************************************************************************************************************************************/

--DROP TABLE TMP_LIS_2000_NO_TIME
DELETE FROM TMP_LIS_2000_NO_TIME;
COMMIT;
INSERT INTO TMP_LIS_2000_NO_TIME
--CREATE TABLE  TMP_LIS_2000_NO_TIME  AS
SELECT T1.OPERATOR,T1.CONTNO,T1.CLMNO,SUM(T1.PAY) AS GETMONEY
  FROM LIS.LLClaim T2
    JOIN LIS.LLBALANCE T1
    ON T1.ClmNo = T2.ClmNo
  WHERE T1.MANAGECOM LIKE '8647%'
    AND T1.CONTNO IN (SELECT CONTNO FROM LIS.LCCONT WHERE CONTTYPE = '1')
    --AND T2.EndCaseDate = date '2018-06-26' --结案日期
    AND TRIM(T1.CLMNO) IN (
        SELECT DISTINCT C.CASE_NO FROM DEV_CLM.T_CLAIM_CASE@BINGXING_168_15 C
        WHERE C.APPLY_DATE = date '2018-06-26') --申请日期
GROUP BY T1.OPERATOR,T1.CONTNO,T1.CLMNO
ORDER BY T1.ContNo;
COMMIT;
--DROP TABLE TMP_NCS_2000;
--COMMIT;


/*
SELECT * FROM LIS.LLBALANCE A WHERE A.CLMNO='90013833408';  --合同号同一个，POLNO区分具体险种的金额 RISKCODE 区分具体金额
SELECT A.POLICY_CODE,A.BUSINESS_CODE,A.BUSI_PROD_CODE,SUM(A.FEE_AMOUNT) FROM dev_clm.T_PREM_ARAP@BINGXING_168_15 A WHERE 1=1
       GROUP BY A.POLICY_CODE,A.BUSINESS_CODE,A.BUSI_PROD_CODE; --业务号、保单号无关联关系
*/

/******************************************************************************************************************************************** 
                                                                 新核心SQL   
 ********************************************************************************************************************************************/
DELETE FROM TMP_NCS_2000_NO_TIME;
COMMIT;
INSERT INTO TMP_NCS_2000_NO_TIME
--CREATE TABLE  TMP_NCS_2000_NO_TIME  AS
SELECT T.USER_NAME,T.POLICY_CODE,T.BUSINESS_CODE,SUM(T.GETMONEY) AS GETMONEY FROM
(SELECT NVL(B.USER_NAME,'系统用户') AS USER_NAME,A.POLICY_CODE,A.BUSINESS_CODE,A.FEE_AMOUNT AS GETMONEY 
    FROM dev_clm.T_PREM_ARAP@BINGXING_168_15 A 
    LEFT JOIN DEV_CLM.T_CLAIM_CASE@BINGXING_168_15 C
      ON C.CASE_NO = A.BUSINESS_CODE
    LEFT JOIN DEV_CLM.T_UDMP_USER@BINGXING_168_15 B
    ON C.INSERT_BY = B.USER_ID
      WHERE A.DERIV_TYPE = '005' --理赔来源
        AND A.ARAP_FLAG = '2' --付费
        AND A.ORGAN_CODE LIKE '8647%'
        AND A.AUDIT_DATE = date '2018-06-26' --收付费时间
  --GROUP BY B.USER_NAME,A.POLICY_CODE,A.BUSINESS_CODE
UNION
SELECT NVL(B.USER_NAME,'系统用户') AS USER_NAME,D.POLICY_CODE,C.CASE_NO AS BUSINESS_CODE,0 AS GETMONEY  
    FROM DEV_CLM.T_CLAIM_CASE@BINGXING_168_15 C
    LEFT JOIN DEV_CLM.T_CONTRACT_MASTER@BINGXING_168_15 D
    ON C.CASE_ID = D.CASE_ID
        JOIN DEV_PAS.T_UDMP_USER@BINGXING_168_15 B
        ON C.INSERT_BY = B.USER_ID
    WHERE C.APPLY_DATE = date '2018-06-26' --报案时间
    AND D.ORGAN_CODE LIKE '8647%' 
    --GROUP BY B.USER_NAME,D.POLICY_CODE,C.CASE_NO
  --ORDER BY D.POLICY_CODE
  ) T
GROUP BY T.USER_NAME,T.POLICY_CODE,T.BUSINESS_CODE
 ORDER BY T.POLICY_CODE;
COMMIT;

/*
DELETE FROM TMP_NCS_2000;
COMMIT;
INSERT INTO TMP_NCS_2000
--CREATE TABLE  TMP_NCS_2000  AS
SELECT T.REAL_NAME,T.POLICY_CODE,T.BUSINESS_CODE,SUM(T.GETMONEY) AS GETMONEY FROM 
(SELECT B.REAL_NAME,A.POLICY_CODE,A.BUSINESS_CODE,CASE 
   WHEN A.ARAP_FLAG='2' THEN -A.FEE_AMOUNT ELSE A.FEE_AMOUNT END AS GETMONEY
    FROM dev_clm.T_PREM_ARAP@BINGXING_168_15 A
    JOIN DEV_PAS.T_UDMP_USER@BINGXING_168_15 B
    ON A.INSERT_BY = B.USER_ID
      WHERE A.DERIV_TYPE = '005' --理赔来源
       -- AND A.ARAP_FLAG = '2' --付费
        AND A.ORGAN_CODE LIKE '8647%' ) T
        --AND A.INSERT_TIME = TRUNC(SYSDATE)-1 --收付费时间
  GROUP BY T.REAL_NAME,T.POLICY_CODE,T.BUSINESS_CODE
  ORDER BY T.POLICY_CODE;
COMMIT;*/



/********************************************************************************************************************************************
                                                               差异明细  
 ********************************************************************************************************************************************/
--SELECT * FROM TMP_NCS_2000_NO_TIME T2;
--SELECT * FROM TMP_LIS_2000_NO_TIME T1;
SELECT T2.USER_NAME 操作员,
       NVL(TRIM(T2.POLICY_CODE),TRIM(T1.CONTNO)) AS 保单号,
       NVL(TRIM(T2.BUSINESS_CODE),TRIM(T1.CLMNO)) AS 赔案号,
       NVL(T2.GETMONEY, 0) AS 新核心赔付金额,
       NVL(T1.GETMONEY, 0) AS 老核心赔付金额,
       (CASE 
          WHEN NVL(T2.GETMONEY, 0) = NVL(T1.GETMONEY, 0) THEN '是 ' 
          ELSE '否 '              
        END) AS 是否一致
  FROM TMP_NCS_2000_NO_TIME T2
  LEFT JOIN TMP_LIS_2000_NO_TIME T1
    ON TRIM(T1.CLMNO) = TRIM(T2.BUSINESS_CODE) AND TRIM(T1.CONTNO) = TRIM(T2.POLICY_CODE)
ORDER BY T2.POLICY_CODE;
