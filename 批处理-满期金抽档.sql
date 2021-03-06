SELECT COUNT(1) AS 笔数, SUM(TPP.INSTALMENT_AMOUNT) AS 金额
  FROM DEV_PAS.T_PAY_PLAN@BINGXING_168_15        TPP,
       DEV_PAS.T_CONTRACT_MASTER@BINGXING_168_15 TCM
 WHERE TPP.POLICY_ID = TCM.POLICY_ID
   AND TCM.ORGAN_CODE LIKE '8647%'
   AND TPP.PAY_PLAN_TYPE = '4' --满期金给付类型
   AND TCM.LIABILITY_STATE <> '3' --不为终止状态（此条件没有索引）
   AND TPP.PAY_STATUS = '2'
   AND TPP.PAY_DUE_DATE = TRUNC(SYSDATE)-1 + 45;

   
SELECT COUNT(1) AS 笔数, SUM(T1.GETMONEY) AS 金额
  FROM LIS.LJSGETDRAW T1
  LEFT JOIN LIS.LMDUTYGET T2
    ON T1.GETDUTYCODE = T2.GETDUTYCODE
  LEFT JOIN LIS.LCCONT T3
    ON T1.CONTNO = T3.CONTNO
 WHERE T3.CONTTYPE = '1'
   AND T3.APPFLAG IN ('1')
   AND T3.MANAGECOM LIKE '8647%'
   AND T2.GETTYPE1 IN ('0') --0：代表满期金； 1代表生存金
   AND T1.GETDATE = TRUNC(SYSDATE)-1+45;

   
/******************************************************************** 明细 ************************************************************************/

DELETE FROM TMP_NCS_1004;
COMMIT;
INSERT INTO TMP_NCS_1004
--CREATE TABLE  TMP_NCS_1004  AS
SELECT DISTINCT TPP.POLICY_CODE AS POLICY_CODE,--保单号
                SUM(TPP.INSTALMENT_AMOUNT) AS INSTALMENT_AMOUNT--满期金金额
  FROM DEV_PAS.T_PAY_PLAN@BINGXING_168_15 TPP, DEV_PAS.T_CONTRACT_MASTER@BINGXING_168_15 TCM
 WHERE TPP.POLICY_ID = TCM.POLICY_ID
   AND TCM.ORGAN_CODE LIKE '8647%'
   AND TPP.PAY_PLAN_TYPE = '4' --满期金给付类型
   AND TCM.LIABILITY_STATE <> '3' --不为终止状态（此条件没有索引）
   AND TPP.PAY_STATUS = '2'
   AND TPP.PAY_DUE_DATE = TRUNC(SYSDATE)-1 + 45
 GROUP BY TPP.POLICY_CODE
 ORDER BY TPP.POLICY_CODE;
COMMIT;


DELETE FROM TMP_LIS_1004;
COMMIT;
INSERT INTO TMP_LIS_1004 
--CREATE TABLE  TMP_LIS_1004 AS
SELECT T1.CONTNO AS CONTNO, SUM(T1.GETMONEY) AS GETMONEY
  FROM LIS.LJSGETDRAW T1
  LEFT JOIN LIS.LMDUTYGET T2
    ON T1.GETDUTYCODE = T2.GETDUTYCODE
  LEFT JOIN LIS.LCCONT T3
    ON T1.CONTNO = T3.CONTNO
 WHERE T3.CONTTYPE = '1'
   AND T3.APPFLAG IN ('1')
   AND T3.MANAGECOM LIKE '8647%'
   AND T2.GETTYPE1 IN ('0') --0：代表满期金； 1代表生存金
   AND T1.GETDATE = TRUNC(SYSDATE)-1+45
 GROUP BY T1.CONTNO
 ORDER BY T1.CONTNO;
COMMIT;


SELECT  NVL(TRIM(T2.POLICY_CODE), TRIM(T1.CONTNO)) AS 保单号,
       NVL(T2.INSTALMENT_AMOUNT, 0) AS 新核心满期金,
       NVL(T1.GETMONEY, 0) AS 老核心满期金,
       NVL(T2.INSTALMENT_AMOUNT, 0) - NVL(T1.GETMONEY, 0) AS 差异值
  FROM TMP_LIS_1004 T1
  FULL JOIN TMP_NCS_1004 T2
    ON TRIM(T1.CONTNO) = TRIM(T2.POLICY_CODE)
 ORDER BY NVL(TRIM(T2.POLICY_CODE), TRIM(T1.CONTNO));




