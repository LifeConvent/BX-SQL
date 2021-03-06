SELECT   COUNT(1) AS 批处理笔数, SUM(FEE_AMOUNT) AS 应领发放金额
  FROM (SELECT TPP.POLICY_CODE,-- 保单号
               TPP.BUSI_PROD_CODE, -- 产品编码
               TPD.FEE_AMOUNT, -- 应领发放金额
               TPP.SURVIVAL_MODE -- 领取方式
          FROM DEV_PAS.T_CONTRACT_MASTER@BINGXING_168_15  TCM,
               DEV_PAS.T_PAY_PLAN@BINGXING_168_15         TPP,
               DEV_PAS.T_PAY_DUE@BINGXING_168_15          TPD
         WHERE TCM.ORGAN_CODE LIKE '8647%'
           AND TPP.POLICY_ID = TCM.POLICY_ID
           AND TPP.PLAN_ID = TPD.PLAN_ID
           AND TPP.PAY_PLAN_TYPE = '8'
           AND TPD.PAY_DUE_DATE = TRUNC(SYSDATE)-1);

SELECT   COUNT(*) AS 老核心批处理笔数,
       NVL(SUM(A.GETMONEY), 0) AS 老核心应领发放金额
  FROM LIS.LPEDORITEM M,
       LIS.LPGET G,
       LIS.LPEDORAPP M1,
       LIS.LCPOL L2,
       LIS.LJSGETDRAW A,
       (select d.code, d.codename
          from lis.ldcode d
         where d.CodeType = 'edorgetpayform') ld
 WHERE M.EDORTYPE = 'AZ'
   AND G.EDORNO = M.EDORNO
   AND G.EDORTYPE = M.EDORTYPE
   AND M1.EDORACCEPTNO = M.EDORACCEPTNO
   AND L2.CONTNO = G.CONTNO
   AND L2.POLNO = G.POLNO
   AND A.CONTNO = G.CONTNO
   AND A.POLNO = G.POLNO
   AND A.DUTYCODE = G.DUTYCODE
   AND A.GETDUTYCODE = G.GETDUTYCODE
   AND A.GETDATE = TRUNC(SYSDATE)-1
   AND LD.CODE(+) = M1.GETFORM
   AND EXISTS (SELECT 1
          FROM LIS.LCCONT
         WHERE CONTNO = M.CONTNO
           AND CONTTYPE = '1' --个单
           AND CARDFLAG <> '3' --非卡单
           AND APPFLAG IN ('1', '4') --承包与终止的保单
           AND SUBSTR(MANAGECOM, 1, 4) = '8647');

/*********************************************************** 明细 ********************************************************/
--CREATE TABLE TMP_NCS_1014  AS
DELETE FROM TMP_NCS_1014;
COMMIT;
INSERT INTO TMP_NCS_1014
SELECT   TPP.POLICY_CODE,-- 保单号
       TPP.BUSI_PROD_CODE, -- 产品编码
       TPD.FEE_AMOUNT, -- 应领发放金额
       TPP.SURVIVAL_MODE -- 领取方式
  FROM DEV_PAS.T_CONTRACT_MASTER@BINGXING_168_15 TCM,
       DEV_PAS.T_PAY_PLAN@BINGXING_168_15        TPP,
       DEV_PAS.T_PAY_DUE@BINGXING_168_15         TPD
 WHERE TCM.ORGAN_CODE LIKE '8647%'
   AND TPP.POLICY_ID = TCM.POLICY_ID
   AND TPP.PLAN_ID = TPD.PLAN_ID
   AND TPP.PAY_PLAN_TYPE = '8'
   AND TPD.PAY_DUE_DATE = TRUNC(SYSDATE)-1;
COMMIT; 

--CREATE TABLE  TMP_LIS_1014  AS
DELETE FROM TMP_LIS_1014;
COMMIT;
INSERT INTO TMP_LIS_1014
 SELECT   A.CONTNO, --保单
           L2.RISKCODE, --产品
           LD.CODENAME,--领取方式
           SUM(A.GETMONEY)  AS GETMONEY--应发金额         
      FROM LIS.LPEDORITEM M,
           LIS.LPGET      G,
           LIS.LPEDORAPP  M1,
           LIS.LCPOL      L2,
           LIS.LJSGETDRAW A,
           (select d.code,d.codename from lis.ldcode d where  d.CodeType = 'edorgetpayform') ld
     WHERE M.EDORTYPE = 'AZ'
       AND G.EDORNO = M.EDORNO
       AND G.EDORTYPE = M.EDORTYPE
      AND M1.EDORACCEPTNO = M.EDORACCEPTNO
       AND L2.CONTNO = G.CONTNO
       AND L2.POLNO = G.POLNO
       AND A.CONTNO = G.CONTNO
       AND A.POLNO = G.POLNO
       AND A.DUTYCODE = G.DUTYCODE
       AND A.GETDUTYCODE = G.GETDUTYCODE
       AND A.GETDATE=TRUNC(SYSDATE)-1
       AND LD.CODE(+)=M1.GETFORM
       AND EXISTS (SELECT 1
              FROM LIS.LCCONT
             WHERE CONTNO = M.CONTNO
               AND CONTTYPE = '1' --个单
               AND CARDFLAG <> '3' --非卡单
               AND APPFLAG IN ('1', '4') --承包与终止的保单
               AND SUBSTR(MANAGECOM, 1, 4) = '8647') --青岛机构
               GROUP BY A.CONTNO, --保单
           L2.RISKCODE, --产品
           LD.CODENAME;
COMMIT;


SELECT  CASE
         WHEN TRIM(T1.CONTNO) = TRIM(T2.POLICY_CODE) THEN
          TRIM(T1.CONTNO)
         WHEN TRIM(T1.CONTNO) IS NULL THEN
          TRIM(T2.POLICY_CODE)
         ELSE
          TRIM(T1.CONTNO)
       END AS 保单号,
       CASE
         WHEN TRIM(T1.RISKCODE) = TRIM(T2.BUSI_PROD_CODE) THEN
          TRIM(T1.RISKCODE)
         WHEN TRIM(T1.RISKCODE) IS NULL THEN
          TRIM(T2.BUSI_PROD_CODE)
         ELSE
          TRIM(T1.RISKCODE)
       END AS 产品编码,
       SUM(T1.GETMONEY) AS 老核心应领发放金额,
       TRIM(T1.CODENAME) AS 老核心领取方式,
       SUM(T2.FEE_AMOUNT) AS 新核心应领发放金额,
       TRIM(T2.SURVIVAL_MODE) AS 新核心领取方式,
       SUM(T1.GETMONEY - T2.FEE_AMOUNT) AS 差异金额,
       CASE
         WHEN TRIM(T1.CODENAME) <> TRIM(T2.SURVIVAL_MODE) THEN
          'N'
         ELSE
          'Y'
       END AS 差异领取方式
  FROM TMP_LIS_1014 T1
  FULL JOIN TMP_NCS_1014 T2
    ON TRIM(T1.CONTNO) = TRIM(T2.POLICY_CODE)
   AND TRIM(T2.BUSI_PROD_CODE) = TRIM(T1.RISKCODE)
 GROUP BY CASE
         WHEN TRIM(T1.CONTNO) = TRIM(T2.POLICY_CODE) THEN
          TRIM(T1.CONTNO)
         WHEN TRIM(T1.CONTNO) IS NULL THEN
          TRIM(T2.POLICY_CODE)
         ELSE
          TRIM(T1.CONTNO)
       END ,
       CASE
         WHEN TRIM(T1.RISKCODE) = TRIM(T2.BUSI_PROD_CODE) THEN
          TRIM(T1.RISKCODE)
         WHEN TRIM(T1.RISKCODE) IS NULL THEN
          TRIM(T2.BUSI_PROD_CODE)
         ELSE
          TRIM(T1.RISKCODE)
       END ,
       
       TRIM(T1.CODENAME),
      
       TRIM(T2.SURVIVAL_MODE) ,
      
       CASE
         WHEN TRIM(T1.CODENAME) <> TRIM(T2.SURVIVAL_MODE) THEN
          'N'
         ELSE
          'Y'
       END;


