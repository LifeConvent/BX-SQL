SELECT COUNT(1) 自动垫交笔数
  FROM DEV_PAS.T_CONTRACT_BUSI_PROD  TCBP,
       DEV_PAS.T_CONTRACT_PRODUCT    TCP
 WHERE 1 = 1
   AND TCBP.APL_PERMIT = 1 --自垫
   AND TCBP.LIABILITY_STATE = 1 --效力状态
   AND TCP.BUSI_ITEM_ID = TCBP.BUSI_ITEM_ID
   AND TCP.ORGAN_CODE LIKE '8647%' --机构编号
   AND TCBP.VALIDATE_DATE = DATE '2017-12-26' --生效日期
   
   
   CREATE TABLE  APP___PAS__DBUSER.TMP_NCS_1000_GB  AS
--DELETE FROM TMP_NCS_1000_GB;
--COMMIT;
--INSERT INTO TMP_NCS_1000_GB
SELECT TCBP.POLICY_CODE     AS POLICY_CODE,
       TCBP.LIABILITY_STATE AS LIABILITY_STATE,
       TCBP.APL_PERMIT AS APL_PERMIT
  FROM DEV_PAS.T_CONTRACT_BUSI_PROD    TCBP,
       DEV_PAS.T_CONTRACT_PRODUCT      TCP
 WHERE 1 = 1
   AND TCBP.APL_PERMIT = 1 --自垫
   AND TCBP.LIABILITY_STATE = 1 --效力状态
   AND TCP.BUSI_ITEM_ID = TCBP.BUSI_ITEM_ID
   AND TCP.ORGAN_CODE LIKE '8647%' --机构编号
   AND TCBP.VALIDATE_DATE = DATE '2017-12-26' --生效日期
