    SELECT DISTINCT DUE.PAY_ID,DUE.UNIT_NUMBER,DUE.BUSI_ITEM_ID,DUE.BUSI_PROD_CODE,
      DUE.FEE_AMOUNT,DUE.PAY_DUE_DATE,DUE.FEE_STATUS,DUE.SURVIVAL_MODE,DUE.PLAN_ID,DUE.SURVIVAL_INVEST_FLAG
     /* (SELECT LIAB_CODE FROM APP___PAS__DBUSER.T_PAY_PLAN WHERE PLAN_ID=DUE.PLAN_ID) liab_code,
      (SELECT SURVIVAL_W_MODE FROM APP___PAS__DBUSER.T_PAY_PLAN WHERE PLAN_ID=DUE.PLAN_ID) AS survival_w_mode,
      (SELECT FUNDS_RTN_CODE FROM APP___PAS__DBUSER.T_PREM WHERE DUE.UNIT_NUMBER=UNIT_NUMBER 
        AND DUE.POLICY_CODE=POLICY_CODE AND DUE.BUSI_PROD_CODE=BUSI_PROD_CODE AND ROWNUM=1) AS bank_succ_flag, 
      (SELECT PAYREFNO FROM APP___CAP__DBUSER.T_CASH_DETAIL WHERE UNIT_NUMBER=DUE.UNIT_NUMBER AND ROWNUM=1) AS payrefno,
            (SELECT FINISH_TIME FROM APP___CAP__DBUSER.T_PREM_ARAP WHERE UNIT_NUMBER=DUE.UNIT_NUMBER AND ROWNUM=1) AS finish_time,
            (SELECT FEE_AMOUNT FROM APP___CAP__DBUSER.T_PREM_ARAP WHERE UNIT_NUMBER=DUE.UNIT_NUMBER AND ROWNUM=1) AS fee_amount2
    */  FROM APP___PAS__DBUSER.T_PAY_DUE DUE 
      WHERE DUE.POLICY_CODE = '886516711117'

      SELECT A.PRIMARY_SALES_CHANNEL, A.SINGLE_JOINT_LIFE, A.COVER_PERIOD_TYPE, A.PRODUCT_CATEGORY4, A.BUSINESS_PRD_ID, A.PRODUCT_CATEGORY3, A.PRODUCT_CODE_ORIGINAL, 
      A.PRODUCT_CATEGORY2, A.PRODUCT_CATEGORY1, A.PRODUCT_NAME_SYS, A.PRODUCT_ABBR_NAME, A.PRODUCT_STATIC_CODE, A.INSURED_COUNT_MAX, A.INSURED_COUNT_MIN, 
      A.PRODUCT_DESC, A.RELEASE_DATE, A.PREMIUM_RATE_LAYER, A.PREMIUM_CURRENCY, A.PRODUCT_NAME_STD, A.PRODUCT_CODE_STD, A.RENEW_OPTION, 
      A.PRODUCT_CATEGORY, A.SCHEDULE_RATE, A.PRODUCT_CODE_SYS,A.RENEWAL_MAX_AGE FROM APP___PAS__DBUSER.T_BUSINESS_PRODUCT A WHERE 1 = 1 
    AND A.PRODUCT_CODE_SYS = '00652000'
      
--查询对应老核心险种责任名称      
select * from dev_pas.T_CODE_MAPPER a where a.CODETYPE='DUTY_CODE' and a.FROM_MODLE='PAS' and a.NEW_CODE='690000003'

SELECT * FROM lySendToBank
SELECT * FROM APP___CAP__DBUSER.T_BANK_TEXT_DETAIL

SELECT * FROM APP___PAS__DBUSER.T_CONTRACT_MASTER


