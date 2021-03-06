SELECT COUNT(TCP.ITEM_ID) AS 批处理笔数,
       SUM(TBA.BONUS_CV) AS 年度红利保额现价,
       SUM(TBA.ORIGIN_BONUS_CV) AS 分红前现价,
       SUM(TBA.TOTAL_BONUS_CV) AS 分红后现价
  FROM DEV_PAS.T_CONTRACT_PRODUCT@BINGXING_168_15 TCP
  LEFT JOIN DEV_PAS.T_BONUS_ALLOCATE@BINGXING_168_15 TBA
    ON TCP.ITEM_ID = TBA.ITEM_ID
 WHERE TCP.POLICY_ID = TBA.POLICY_ID
   AND TBA.BONUS_ALLOT = '1'
   AND TCP.ORGAN_CODE LIKE '8647%'
   AND TBA.ALLOCATE_DUE_DATE = TRUNC(SYSDATE) - 1;



SELECT COUNT(T1.DUTYCODE) AS 批处理笔数,
       SUM(T2.BASEAMNTCV) AS 年度红利保额现价,
       SUM(T2.LASTYEARCV) AS 分红前现价,
       SUM(T2.SUMBONUSAMNTCV) AS 分红后现价
  FROM LIS.LOENGBONUSPOL T1
  JOIN LIS.BONUSDATA T2
    ON T1.POLNO = T2.POLNO
   AND T1.FISCALYEAR = T2.FISCALYEAR
  LEFT JOIN LIS.LCCONT T3
    ON T1.CONTNO = T3.CONTNO
 WHERE T3.CONTTYPE = '1'
   AND T3.APPFLAG IN ('1', '4')
   AND T3.MANAGECOM LIKE '8647%'
   AND T1.DISPATCHTYPE <> '2'
   AND T1.SDISPATCHDATE = TRUNC(SYSDATE)-1;



   
/********************************************************  明细 ****************************************************/

DELETE FROM TMP_NCS_1021;
COMMIT;
INSERT INTO TMP_NCS_1021
--CREATE TABLE  TMP_NCS_1021 AS
SELECT TBA.POLICY_CODE AS POLICY_CODE,--保单号
       TCP.PRODUCT_CODE AS PRODUCT_CODE,--责任组代码
       TO_CHAR(TBA.ALLOCATE_DUE_DATE, 'yyyy') - 1 AS FISCALYEAR,--会计年度
       TBA.BONUS_RATE AS BONUS_RATE,--红利率
       TBA.BONUS_CV AS BONUS_CV,--年度红利保额现价
       TBA.ORIGIN_BONUS_CV AS ORIGIN_BONUS_CV,--分红前现价
       TBA.TOTAL_BONUS_CV AS TOTAL_BONUS_CV,--分红后现价
       TBA.RATE_RELEASE_DATE AS RATE_RELEASE_DATE,--红利公布日
       TBA.ALLOCATE_DUE_DATE AS ALLOCATE_DUE_DATE--红利应分配日期
  FROM DEV_PAS.T_CONTRACT_PRODUCT@BINGXING_168_15 TCP
  LEFT JOIN DEV_PAS.T_BONUS_ALLOCATE@BINGXING_168_15 TBA
    ON TCP.ITEM_ID = TBA.ITEM_ID
 WHERE TCP.POLICY_ID = TBA.POLICY_ID
   AND TBA.BONUS_ALLOT = '1'
   AND TCP.ORGAN_CODE LIKE '8647%'
   AND TBA.ALLOCATE_DUE_DATE = TRUNC(SYSDATE)-1;
COMMIT;


DELETE FROM TMP_LIS_1021;
COMMIT;
INSERT INTO TMP_LIS_1021
--CREATE TABLE  TMP_LIS_1021  AS
SELECT TRIM(T1.CONTNO) AS CONTNO,
       T1.DUTYCODE AS DUTYCODE,
       TRIM(T1.FISCALYEAR) AS FISCALYEAR,
       T1.BONUSRATE AS BONUSRATE,
       T2.BASEAMNTCV AS BASEAMNTCV,
       T2.LASTYEARCV AS LASTYEARCV,
       T2.SUMBONUSAMNTCV AS SUMBONUSAMNTCV,
       T1.BONUSMAKEDATE AS BONUSMAKEDATE,
       T1.SDISPATCHDATE AS SDISPATCHDATE
  FROM LIS.LOENGBONUSPOL T1
  JOIN LIS.BONUSDATA T2
    ON T1.POLNO = T2.POLNO
   AND T1.FISCALYEAR = T2.FISCALYEAR
  LEFT JOIN LIS.LCCONT T3
    ON T1.CONTNO = T3.CONTNO
 WHERE T3.CONTTYPE = '1'
   AND T3.APPFLAG IN ('1', '4')
   AND T3.MANAGECOM LIKE '8647%'
   AND T1.DISPATCHTYPE <> '2'
   AND T1.SDISPATCHDATE = TRUNC(SYSDATE)-1;
COMMIT;


SELECT NVL(TRIM(T2.POLICY_CODE), TRIM(T1.CONTNO)) AS 保单号,
       NVL(T2.PRODUCT_CODE, TRIM(T1.DUTYCODE)) AS 责任组代码,
       NVL(TRIM(T1.FISCALYEAR), T2.FISCALYEAR) AS 会计年度,
       NVL(TRIM(T1.BONUSRATE), T2.BONUS_RATE) AS 红利率,
       NVL(T2.BONUS_CV, 0) AS 新核心年度红利保额现价,
       NVL(T1.BASEAMNTCV, 0) AS 老核心年度红利保额现价,
       NVL(T2.ORIGIN_BONUS_CV, 0) AS 新核心分红前现价,
       NVL(T1.LASTYEARCV, 0) AS 老核心分红前现价,
       NVL(T2.TOTAL_BONUS_CV, 0) AS 新核心分红后现价,
       NVL(T1.SUMBONUSAMNTCV, 0) AS 老核心分红后现价,
       T1.BONUSMAKEDATE AS 红利公布日,
       T1.SDISPATCHDATE AS 红利应分配日期,
       NVL(T2.BONUS_CV, 0) - NVL(T1.BASEAMNTCV, 0) AS 年度红利保额现价,
       NVL(T2.ORIGIN_BONUS_CV, 0) - NVL(T1.LASTYEARCV, 0) AS 分红前现价,
       NVL(T2.TOTAL_BONUS_CV, 0) - NVL(T1.SUMBONUSAMNTCV, 0) AS 分红后现价
  FROM TMP_LIS_1021 T1
  FULL JOIN TMP_NCS_1021 T2
    ON TRIM(T1.CONTNO) = TRIM(T2.POLICY_CODE)
 ORDER BY T2.POLICY_CODE;







