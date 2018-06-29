SELECT   COUNT(1) AS ���������
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
                             
SELECT  /*+ parallel(110) */ COUNT(L.POLNO) AS �Ϻ��ı�������ʧЧ����
  FROM LIS.LCCONTSTATE L,LIS.LCPOL LC
 WHERE L.STARTDATE = TRUNC(SYSDATE)-1
   AND L.STATETYPE = 'Available'
   AND L.CONTNO=LC.CONTNO
   AND L.POLNO=LC.POLNO
   AND L.STATE = '1'
   AND EXISTS (SELECT /*+ parallel(50) */ 1
          FROM LIS.LCCONT
         WHERE CONTNO = L.CONTNO
           AND CONTTYPE = '1' --����
           AND CARDFLAG <> '3' --�ǿ���
           AND APPFLAG IN ('1', '4') --�а�����ֹ�ı���
           AND SUBSTR(MANAGECOM, 1, 4) = '8647') --����
           AND LC.RISKCODE IN (SELECT/*+ parallel(50) */  RISKCODE
                            FROM LMRISKAPP
                           WHERE INVESTFLAG = 'Y'
                             AND RISKPROP IN ('I', 'Y', 'T', 'E'));

/************************************************* ��ϸ  *************************************************************/                             
--CREATE TABLE  TMP_NCS_1013  AS
DELETE FROM TMP_NCS_1013;
COMMIT;
INSERT INTO TMP_NCS_1013
SELECT   TCBP.POLICY_CODE, --������
       TCBP.BUSI_PROD_CODE, --��Ʒ����
       TCBP.LIABILITY_STATE, --����״̬
       TCBP.LAPSE_CAUSE --ʧЧԭ��
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
SELECT    L.CONTNO,--������
       LC.RISKCODE,--��Ʒ����
       LC.APPFLAG,--����״̬
       'ʧЧ' AS RESON--ʧЧԭ��
  FROM LIS.LCCONTSTATE L,LIS.LCPOL LC
 WHERE L.STARTDATE = TRUNC(SYSDATE)-1
   AND L.STATETYPE = 'Available'
   AND L.CONTNO=LC.CONTNO
   AND L.POLNO=LC.POLNO
   AND L.STATE = '1'
   AND EXISTS (SELECT /*+ parallel(50) */ 1
          FROM LIS.LCCONT
         WHERE CONTNO = L.CONTNO
           AND CONTTYPE = '1' --����
           AND CARDFLAG <> '3' --�ǿ���
           AND APPFLAG IN ('1', '4') --�а�����ֹ�ı���
           AND SUBSTR(MANAGECOM, 1, 4) = '8647') --����
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
       END AS ������,
       CASE
         WHEN TRIM(T1.RISKCODE) = TRIM(T2.BUSI_PROD_CODE) THEN
          TRIM(T1.RISKCODE)
         WHEN TRIM(T1.RISKCODE) IS NULL THEN
          TRIM(T2.BUSI_PROD_CODE)
         ELSE
          TRIM(T1.RISKCODE)
       END AS ��Ʒ����,
       T1.APPFLAG AS �Ϻ���Ч��״̬,
       T1.RESON AS �Ϻ�����ֹԭ��,
       T2.LIABILITY_STATE AS �º���Ч��״̬,
       T2.LAPSE_CAUSE AS �º�����ֹԭ��,
       CASE
         WHEN TRIM(T1.CONTNO) <> TRIM(T2.POLICY_CODE) THEN
           'N'
          ELSE
           'Y'
        END AS ����
   FROM TMP_LIS_1013 T1
   FULL JOIN TMP_NCS_1013 T2
     ON TRIM(T1.CONTNO) = TRIM(T2.POLICY_CODE)
    AND TRIM(T2.BUSI_PROD_CODE) = TRIM(T1.RISKCODE)
  ORDER BY TRIM(T1.CONTNO);





