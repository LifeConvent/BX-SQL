/*-----------------------------------------------------------------------------------------------------------------
//////////////////////////////////////////--新核心指标--/////////////////////////////////////////////////////
-----------------------------------------------------------------------------------------------------------------*/
--二级管理机构
SELECT SUBSTR(TRIM(A.ORGAN_CODE), 1, 4) AS ORGAN_CODE,B.BUSI_PROD_CODE,COUNT(A.POLICY_CODE) AS SUM
  FROM T_CONTRACT_MASTER A
  INNER JOIN T_CONTRACT_BUSI_PROD B/*保单险种责任表*/
        ON A.POLICY_CODE = B.POLICY_CODE
  INNER JOIN RISKCODE_KPI
        ON B.BUSI_PROD_CODE = RISKCODE_KPI.RISKCODE
  WHERE B.VALIDATE_DATE <= DATE '2015-12-31'/*险种生效日期*/
        AND SUBSTR(TRIM(A.ORGAN_CODE), 1, 4) IN
       (SELECT ORGAN_CODE
          FROM T_UDMP_ORG_REL
         WHERE ORGAN_GRADE = '02'
           AND ORGAN_CODE = '8651')
 GROUP BY SUBSTR(TRIM(A.ORGAN_CODE), 1, 4), B.BUSI_PROD_CODE
 ORDER BY SUBSTR(TRIM(A.ORGAN_CODE), 1, 4), B.BUSI_PROD_CODE;
 --三级管理机构
 SELECT SUBSTR(TRIM(A.ORGAN_CODE), 1, 6) AS ORGAN_CODE,B.BUSI_PROD_CODE,COUNT(A.POLICY_CODE) AS SUM
  FROM T_CONTRACT_MASTER A
  INNER JOIN T_CONTRACT_BUSI_PROD B/*保单险种责任表*/
        ON A.POLICY_CODE = B.POLICY_CODE
  INNER JOIN RISKCODE_KPI
        ON B.BUSI_PROD_CODE = RISKCODE_KPI.RISKCODE
  WHERE B.VALIDATE_DATE <= DATE '2015-12-31'/*险种生效日期*/
        AND SUBSTR(TRIM(A.ORGAN_CODE), 1, 6) IN
       (SELECT ORGAN_CODE
          FROM T_UDMP_ORG_REL
         WHERE ORGAN_GRADE = '03'
           AND UPORGAN_CODE = '8651')
 GROUP BY SUBSTR(TRIM(A.ORGAN_CODE), 1, 6), B.BUSI_PROD_CODE
 ORDER BY SUBSTR(TRIM(A.ORGAN_CODE), 1, 6), B.BUSI_PROD_CODE;
