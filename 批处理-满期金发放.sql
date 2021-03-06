SELECT COUNT(1) AS 笔数, SUM(A.FEE_AMOUNT) AS 金额
  FROM DEV_PAS.T_PAY_DUE@BINGXING_168_15 A --满期金给付应领表
  JOIN DEV_PAS.T_CONTRACT_MASTER@BINGXING_168_15 D --保单主表
    ON A.POLICY_ID = D.POLICY_ID
  JOIN DEV_PAS.T_PAY_PLAN@BINGXING_168_15 DD --满期金给付计划表
    ON A.PLAN_ID = DD.PLAN_ID
 WHERE 1 = 1
   AND DD.PAY_PLAN_TYPE = '4' --满期金给付类型
   AND D.ORGAN_CODE LIKE '8647%' --青岛分公司
   AND A.PAY_DUE_DATE = TRUNC(SYSDATE)-1
   AND A.FEE_STATUS = '00'
 ORDER BY A.POLICY_CODE DESC;

 
SELECT 
  COUNT(1) AS 笔数，SUM(T1.GETMONEY) AS 金额
  FROM(SELECT /*+ parallel(50) */
           T1.CONTNO, T1.GETMONEY
          FROM LIS.LJAGETDRAW T1
          LEFT JOIN LIS.LMDUTYGET T2
            ON T1.GETDUTYCODE = T2.GETDUTYCODE
          LEFT JOIN LIS.LCCONT T3
            ON T1.CONTNO = T3.CONTNO
          LEFT JOIN LIS.LJSGETDRAW T4
            ON T3.CONTNO = T4.CONTNO
         WHERE T3.CONTTYPE = '1'
           AND T3.APPFLAG IN ('1', '4') --
           AND T3.MANAGECOM LIKE '8647%'
           AND T2.GETTYPE1 IN ('0') --0：代表满期金； 1代表生存金
           AND T1.GETDATE = TRUNC(SYSDATE)-1
        UNION ALL
        SELECT  /*+ parallel(50) */
          T1.CONTNO, T1.GETMONEY
          FROM LIS.LJSGETDRAW T1
          LEFT JOIN LIS.LMDUTYGET T2
            ON T1.GETDUTYCODE = T2.GETDUTYCODE
          LEFT JOIN LIS.LCCONT T3
            ON T1.CONTNO = T3.CONTNO
          LEFT JOIN LIS.LJSGETDRAW T4
            ON T3.CONTNO = T4.CONTNO
         WHERE T3.CONTTYPE = '1'
           AND T3.APPFLAG IN ('1', '4')
           AND T3.MANAGECOM LIKE '8647%'
           AND T2.GETTYPE1 IN ('0') --0：代表满期金； 1代表生存金
           AND T1.GETDATE = TRUNC(SYSDATE)-1) T1 ;

           
/*************************************************************  明细  *********************************************************/
DELETE FROM TMP_NCS_1005;
COMMIT;
INSERT INTO TMP_NCS_1005
--CREATE TABLE  TMP_NCS_1005  AS
SELECT A.POLICY_CODE,--保单号
 A.FEE_AMOUNT--满期金金额
  FROM DEV_PAS.T_PAY_DUE@BINGXING_168_15 A --满期金给付应领表
  JOIN DEV_PAS.T_CONTRACT_MASTER@BINGXING_168_15 D --保单主表
    ON A.POLICY_ID = D.POLICY_ID
  JOIN DEV_PAS.T_PAY_PLAN@BINGXING_168_15 DD --满期金给付计划表
    ON A.PLAN_ID = DD.PLAN_ID
 WHERE 1 = 1
   AND DD.PAY_PLAN_TYPE = '4' --满期金给付类型
   AND D.ORGAN_CODE LIKE '8647%' --青岛分公司
   AND A.PAY_DUE_DATE = TRUNC(SYSDATE)-1
   AND A.FEE_STATUS = '00'
 ORDER BY A.POLICY_CODE DESC;
COMMIT;


DELETE FROM TMP_LIS_1005 ;
COMMIT;
INSERT INTO TMP_LIS_1005  
--CREATE TABLE  TMP_LIS_1005  AS
SELECT T.CONTNO, SUM(T.GETMONEY) GETMONEY
  FROM (SELECT T1.CONTNO, T1.GETMONEY
          FROM LIS.LJAGETDRAW T1
          LEFT JOIN LIS.LMDUTYGET T2
            ON T1.GETDUTYCODE = T2.GETDUTYCODE
          LEFT JOIN LIS.LCCONT T3
            ON T1.CONTNO = T3.CONTNO
          LEFT JOIN LIS.LJSGETDRAW T4
            ON T3.CONTNO = T4.CONTNO
         WHERE T3.CONTTYPE = '1'
           AND T3.APPFLAG IN ('1', '4') --
           AND T3.MANAGECOM LIKE '8647%'
           AND T2.GETTYPE1 IN ('0') --0：代表满期金； 1代表生存金
           AND T1.GETDATE = TRUNC(SYSDATE) - 1
        UNION ALL
        SELECT T1.CONTNO, T1.GETMONEY
          FROM LIS.LJSGETDRAW T1
          LEFT JOIN LIS.LMDUTYGET T2
            ON T1.GETDUTYCODE = T2.GETDUTYCODE
          LEFT JOIN LIS.LCCONT T3
            ON T1.CONTNO = T3.CONTNO
          LEFT JOIN LIS.LJSGETDRAW T4
            ON T3.CONTNO = T4.CONTNO
         WHERE T3.CONTTYPE = '1'
           AND T3.APPFLAG IN ('1', '4')
           AND T3.MANAGECOM LIKE '8647%'
           AND T2.GETTYPE1 IN ('0') --0：代表满期金； 1代表生存金
           AND T1.GETDATE = TRUNC(SYSDATE) - 1) T
 GROUP BY T.CONTNO;
COMMIT;


SELECT NVL(TRIM(T2.POLICY_CODE), TRIM(T1.CONTNO)) AS 新核心保单号,
       NVL(T2.FEE_AMOUNT, 0) AS 新核心满期金,
       NVL(T1.GETMONEY, 0) AS 老核心满期金,
       NVL(T2.FEE_AMOUNT, 0) - NVL(T1.GETMONEY, 0) AS 差异值
  FROM TMP_LIS_1005 T1
  FULL JOIN TMP_NCS_1005 T2
    ON TRIM(T1.CONTNO) = TRIM(T2.POLICY_CODE)
 ORDER BY T2.POLICY_CODE;




