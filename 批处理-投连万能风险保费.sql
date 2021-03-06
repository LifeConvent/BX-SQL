SELECT/*+PARALLEL(110)*/ COUNT(DISTINCT(B.POLICY_CODE)) AS 扣费保单数,
       SUM(A.TRANS_AMOUNT) 扣费总金额
  FROM DEV_PAS.T_FUND_TRANS@BINGXING_168_15 A
  JOIN DEV_PAS.T_CONTRACT_MASTER@BINGXING_168_15 B
    ON A.POLICY_ID = B.POLICY_ID
  JOIN DEV_PAS.T_TRANSACTION_CODE@BINGXING_168_15 TC
    ON TC.TRANS_CODE = A.TRANS_CODE
 WHERE 1 = 1
   AND A.DEAL_TIME = TRUNC(SYSDATE)-1 --交易产生时间
   AND B.ORGAN_CODE LIKE '8647%'
    --03指风险保费
   AND A.TRANS_CODE IN (03);
   
SELECT/*+PARALLEL(110)*/ COUNT(1) AS 批处理笔数, SUM(FEE_AMOUNT) AS 批处理金额
  FROM (SELECT T1.CONTNO,
               T2.MANAGECOM,
               T1.FEECODE,
               T3.PAYINSUACCNAME,
               T1.PAYDATE,
               SUM(T1.FEE) FEE_AMOUNT
          FROM LIS.LCINSUREACCFEETRACE T1
          LEFT JOIN LIS.LCCONT T2
            ON T1.CONTNO = T2.CONTNO
         INNER JOIN LIS.LMRISKFEE T3
            ON T1.FEECODE = T3.FEECODE
         WHERE 1 = 1
           AND T2.CONTTYPE = '1'
           AND T2.MANAGECOM LIKE '8647%'
           AND T1.PAYDATE = TRUNC(SYSDATE)-1
           AND T1.RISKCODE IN (SELECT RISKCODE
                                 FROM LIS.LMRISKAPP
                                WHERE RISKPROP IN ('I', 'Y')
                                  AND INVESTFLAG = 'Y')
           AND (T3.PAYINSUACCNAME LIKE '%保障成本%' 
                 OR T3.PAYINSUACCNAME LIKE '%风险%')
         GROUP BY T1.CONTNO,
                  T2.MANAGECOM,
                  T1.FEECODE,
                  T3.PAYINSUACCNAME,
                  T1.PAYDATE
         ORDER BY T1.CONTNO) T;
         
/*********************************************************** 明细 **********************************************************/
--CREATE TABLE  TMP_NCS_1025 AS
DELETE FROM TMP_NCS_1025;
COMMIT;
INSERT INTO TMP_NCS_1025
SELECT/*+PARALLEL(110)*/ DISTINCT (B.POLICY_CODE), --保单号
                A.TRANS_AMOUNT --金额
  FROM DEV_PAS.T_FUND_TRANS@BINGXING_168_15 A
  JOIN DEV_PAS.T_CONTRACT_MASTER@BINGXING_168_15 B
    ON A.POLICY_ID = B.POLICY_ID
  JOIN DEV_PAS.T_TRANSACTION_CODE@BINGXING_168_15 TC
    ON TC.TRANS_CODE = A.TRANS_CODE
 WHERE 1 = 1
   AND A.DEAL_TIME = TRUNC(SYSDATE)-1 --交易产生时间
   AND B.ORGAN_CODE LIKE '8647%' --机构代码
   AND A.TRANS_CODE IN (03) --02, 03, 04, 41
 ORDER BY B.POLICY_CODE;
COMMIT;


--CREATE TABLE  TMP_LIS_1025  AS
DELETE FROM TMP_LIS_1025;
COMMIT;
INSERT INTO TMP_LIS_1025
SELECT/*+PARALLEL(110)*/ T1.CONTNO AS CONTNO,
       T2.MANAGECOM AS MANAGECOM,
       T1.FEECODE AS FEECODE,
       T3.PAYINSUACCNAME AS PAYINSUACCNAME,
       T1.PAYDATE AS PAYDATE,
       SUM(T1.FEE) AS FEE
  FROM LIS.LCINSUREACCFEETRACE T1
  LEFT JOIN LIS.LCCONT T2
    ON T1.CONTNO = T2.CONTNO
 INNER JOIN LIS.LMRISKFEE T3
    ON T1.FEECODE = T3.FEECODE
 WHERE 1 = 1
   AND T2.CONTTYPE = '1'
   AND T2.MANAGECOM LIKE '8647%'
   AND T1.PAYDATE = TRUNC(SYSDATE)-1
   AND T1.RISKCODE IN (SELECT RISKCODE
                         FROM LIS.LMRISKAPP
                        WHERE RISKPROP IN ('I', 'Y')
                          AND INVESTFLAG = 'Y')
   AND (T3.PAYINSUACCNAME LIKE '%保障成本%' 
         OR T3.PAYINSUACCNAME LIKE '%风险%')
 GROUP BY T1.CONTNO,
          T2.MANAGECOM,
          T1.FEECODE,
          T3.PAYINSUACCNAME,
          T1.PAYDATE
 ORDER BY T1.CONTNO;
COMMIT;

SELECT/*+PARALLEL(110)*/ NVL(TRIM(T2.POLICY_CODE),TRIM(T1.CONTNO)) AS 保单号,
       NVL(T2.TRANS_AMOUNT,0) AS 新核心,
       NVL(T1.FEE,0) AS 老核心,
       NVL(T2.TRANS_AMOUNT,0) - NVL(T1.FEE,0) AS 差异
 FROM TMP_LIS_1025 T1
  FULL JOIN TMP_NCS_1025 T2
    ON TRIM(T1.CONTNO) = TRIM(T2.POLICY_CODE)
 ORDER BY T2.POLICY_CODE;



