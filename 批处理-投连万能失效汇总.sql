SELECT   COUNT(1) AS 批处理笔数
  FROM (SELECT TCBP.POLICY_CODE,
               TCBP.BUSI_PROD_CODE,
               TCBP.LIABILITY_STATE,
               TCBP.LAPSE_CAUSE
          FROM DEV_PAS.T_CONTRACT_BUSI_PROD@BINGXING_168_15 TCBP,
               DEV_PAS.T_BUSINESS_PRODUCT@BINGXING_168_15   TBP,
               DEV_PAS.T_CONTRACT_MASTER@BINGXING_168_15    TCM
         WHERE TCBP.LAPSE_CAUSE = '1'
           AND TBP.BUSINESS_PRD_ID = TCBP.BUSI_PRD_ID
           AND ((TBP.PRODUCT_CATEGORY1 = '20003') OR
               (TBP.PRODUCT_CATEGORY1 = '20004'))
           AND TCBP.LAPSE_CAUSE = '1'
           AND TCBP.LIABILITY_STATE = '4'
           AND TCM.POLICY_ID = TCBP.POLICY_ID
           AND TCBP.LAPSE_DATE = TRUNC(SYSDATE)-1
           AND TCM.ORGAN_CODE LIKE '8647%');
                             
SELECT  /*+ parallel(110) */ COUNT(L.POLNO) AS 老核心保单险种失效件数
  FROM LIS.LCCONTSTATE L,LIS.LCPOL LC
 WHERE L.STARTDATE = TRUNC(SYSDATE)-1
   AND L.STATETYPE = 'Available'
   AND L.CONTNO=LC.CONTNO
   AND L.POLNO=LC.POLNO
   AND L.STATE = '1'
   AND EXISTS (SELECT /*+ parallel(50) */ 1
          FROM LIS.LCCONT
         WHERE CONTNO = L.CONTNO
           AND CONTTYPE = '1' --个单
           AND CARDFLAG <> '3' --非卡单
           AND APPFLAG IN ('1', '4') --承包与终止的保单
           AND SUBSTR(MANAGECOM, 1, 4) = '8647') --机构
           AND LC.RISKCODE IN (SELECT/*+ parallel(50) */  RISKCODE
                            FROM LMRISKAPP
                           WHERE INVESTFLAG = 'Y'
                             AND RISKPROP IN ('I', 'Y', 'T', 'E'));

/************************************************* 明细  *************************************************************/                             
--CREATE TABLE  TMP_NCS_1013  AS
DELETE FROM TMP_NCS_1013;
COMMIT;
INSERT INTO TMP_NCS_1013
SELECT   TCBP.POLICY_CODE, --保单号
       TCBP.BUSI_PROD_CODE, --产品编码
       TCBP.LIABILITY_STATE, --险种状态
       TCBP.LAPSE_CAUSE --失效原因
  FROM DEV_PAS.T_CONTRACT_BUSI_PROD@BINGXING_168_15 TCBP,
       DEV_PAS.T_BUSINESS_PRODUCT@BINGXING_168_15   TBP,
       DEV_PAS.T_CONTRACT_MASTER@BINGXING_168_15    TCM
 WHERE TCBP.LAPSE_CAUSE = '1'
   AND TBP.BUSINESS_PRD_ID = TCBP.BUSI_PRD_ID
   AND ((TBP.PRODUCT_CATEGORY1 = '20003') OR
       (TBP.PRODUCT_CATEGORY1 = '20004'))
   AND TCBP.LAPSE_CAUSE = '1'
   AND TCBP.LIABILITY_STATE = '4'
   AND TCBP.LAPSE_DATE = TRUNC(SYSDATE)-1
   AND TCM.POLICY_ID = TCBP.POLICY_ID
   AND TCM.ORGAN_CODE LIKE '8647%';
COMMIT;

--CREATE TABLE  TMP_LIS_1013  AS
DELETE FROM TMP_LIS_1013;
COMMIT;
INSERT INTO TMP_LIS_1013
SELECT    L.CONTNO,--保单号
       LC.RISKCODE,--产品编码
       LC.APPFLAG,--险种状态
       '失效' AS RESON--失效原因
  FROM LIS.LCCONTSTATE L,LIS.LCPOL LC
 WHERE L.STARTDATE = TRUNC(SYSDATE)-1
   AND L.STATETYPE = 'Available'
   AND L.CONTNO=LC.CONTNO
   AND L.POLNO=LC.POLNO
   AND L.STATE = '1'
   AND EXISTS (SELECT /*+ parallel(50) */ 1
          FROM LIS.LCCONT
         WHERE CONTNO = L.CONTNO
           AND CONTTYPE = '1' --个单
           AND CARDFLAG <> '3' --非卡单
           AND APPFLAG IN ('1', '4') --承包与终止的保单
           AND SUBSTR(MANAGECOM, 1, 4) = '8647') --机构
           AND LC.RISKCODE IN (SELECT/*+ parallel(50) */ RISKCODE
                            FROM LMRISKAPP
                           WHERE INVESTFLAG = 'Y'
                             AND RISKPROP IN ('I', 'Y', 'T', 'E'));
COMMIT;


SELECT   CASE
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
       T1.APPFLAG AS 老核心效力状态,
       T1.RESON AS 老核心终止原因,
       T2.LIABILITY_STATE AS 新核心效力状态,
       T2.LAPSE_CAUSE AS 新核心终止原因,
       CASE
         WHEN TRIM(T1.CONTNO) <> TRIM(T2.POLICY_CODE) THEN
           'N'
          ELSE
           'Y'
        END AS 差异
   FROM TMP_LIS_1013 T1
   FULL JOIN TMP_NCS_1013 T2
     ON TRIM(T1.CONTNO) = TRIM(T2.POLICY_CODE)
    AND TRIM(T2.BUSI_PROD_CODE) = TRIM(T1.RISKCODE)
  ORDER BY TRIM(T1.CONTNO);





