SELECT A.POLICY_CODE,A.POLICY_ID,A.BUSI_ITEM_ID,A.BUSI_PROD_CODE,A.BUSI_PRD_ID,A.OLD_POL_NO,
      (SELECT PRODUCT_NAME_SYS FROM APP___PAS__DBUSER.T_BUSINESS_PRODUCT 
        WHERE BUSINESS_PRD_ID=A.BUSI_PRD_ID) AS product_name_sys,
      (SELECT PRODUCT_ABBR_NAME FROM APP___PAS__DBUSER.T_BUSINESS_PRODUCT 
        WHERE BUSINESS_PRD_ID=A.BUSI_PRD_ID) AS product_abbr_name,
      (SELECT CUSTOMER_ID FROM APP___PAS__DBUSER.T_INSURED_LIST WHERE LIST_ID=
              (SELECT INSURED_ID FROM APP___PAS__DBUSER.T_BENEFIT_INSURED WHERE 
                POLICY_CODE=A.POLICY_CODE AND BUSI_ITEM_ID=A.BUSI_ITEM_ID AND ORDER_ID=1)) AS insured_id
      FROM APP___PAS__DBUSER.T_CONTRACT_BUSI_PROD A 
      WHERE 1=1 AND A.POLICY_CODE='QD070421501000012' ;
      
SELECT * FROM APP___PAS__DBUSER.T_INSURED_LIST WHERE POLICY_CODE = 'QD070421501000012' AND CUSTOMER_ID IN (1000003688867,6000000463782,1000003688868,6000000463783);
      
/*SELECT A.CUSTOMER_ID,A.CUSTOMER_NAME, A.CUSTOMER_LEVEL, A.NATION_CODE, A.DEATH_DATE, A.JOB_NATURE, A.REMARK, A.CUST_PWD, 
      A.WECHAT_NO, A.OFFEN_USE_TEL, A.UN_CUSTOMER_CODE, A.CUST_CERT_END_DATE, A.QQ, A.OLD_CUSTOMER_ID, 
      A.MOBILE_TEL, A.CUSTOMER_BIRTHDAY, A.IS_PARENT, A.COUNTRY_CODE, A.FAX_TEL, A.JOB_CODE, 
      A.OFFICE_TEL, A.SMOKING_FLAG, A.MARRIAGE_STATUS, A.EDUCATION, A.CUSTOMER_ID_CODE, 
      A.CUSTOMER_GENDER, A.OTHER, A.COMPANY_NAME, A.JOB_TITLE, A.CUSTOMER_HEIGHT, A.HEALTH_STATUS, 
      A.CUSTOMER_CERTI_CODE, A.RETIRED_FLAG, A.DRUNK_FLAG, A.MARRIAGE_DATE, A.BLACKLIST_FLAG, A.DRIVER_LICENSE_TYPE, 
      A.HOUSEKEEPER_FLAG, A.EMAIL, A.ANNUAL_INCOME, A.CUSTOMER_CERT_TYPE, A.HOUSE_TEL, A.JOB_KIND, A.TAX_RESIDENT_TYPE, 
      A.CUSTOMER_WEIGHT, A.RELIGION_CODE, A.CUST_CERT_STAR_DATE, A.SYN_MDM_FLAG, A.CUSTOMER_VIP, A.LIVE_STATUS,A.CUSTOMER_RISK_LEVEL,A.COMM_METHOD,A.SOCI_SECU,A.IS_SUBSCRIPTION_EMAIL,A.RESIDENT_TYPE FROM APP___PAS__DBUSER.T_CUSTOMER A WHERE 1 = 1  ]]>
    AND A.CUSTOMER_ID = 6000000053671--insured_id*/
    
/****************** 无结果时无领取数据 *****************/    
SELECT DISTINCT PD.POLICY_CODE,PD.BUSI_ITEM_ID,PD.BUSI_PROD_CODE,PD.PRODUCT_CODE,
      PP.PAY_PLAN_TYPE,PD.FEE_AMOUNT,PD.PAY_DUE_DATE,PP.LIAB_CODE,
      (SELECT LIAB_NAME FROM APP___PAS__DBUSER.T_LIABILITY WHERE LIAB_ID=PD.LIAB_ID) liab_name 
      FROM APP___PAS__DBUSER.T_PAY_DUE PD 
      LEFT JOIN APP___PAS__DBUSER.T_PAY_PLAN PP ON PP.PLAN_ID=PD.PLAN_ID 
      WHERE 1=1
      AND PP.POLICY_CODE='QD070421501000012'
      AND PP.BUSI_ITEM_ID IN ('1000013719773','6000002671074','1000013767227','6000002718502')
      AND PD.PAY_DUE_DATE <= TRUNC(SYSDATE) 
      AND PD.FEE_STATUS='00'
      AND NOT EXISTS(SELECT 1 FROM APP___CAP__DBUSER.T_CASH_DETAIL WHERE UNIT_NUMBER=PD.UNIT_NUMBER AND FEE_STATUS='01')
    
/*-----------------------------------------------------------------------------------------------------------------
//////////////////////////////////////////--老核心--/////////////////////////////////////////////////////
-----------------------------------------------------------------------------------------------------------------*/        
select a.contno,a.polno,a.riskcode,a.InsuredNo,
                    (select riskname from lmrisk where riskcode=a.riskcode) riskname
                    from lcpol a where a.contno='QD070421501000012'        

/*********** 无结果时无领取信息 ***********/
  select distinct (select distinct GetDutyName
                            from LMDutyGetAlive where GetDutyCode = b.GetDutyCode 
                            and GetDutyKind = b.GetDutyKind),b.getdate,b.GetMoney,
                            b.DutyCode,nvl((select decode(GetType1,'0','满期金','1','年金','未知') 
                            from LMDutyGet where GetDutyCode = b.GetDutyCode),'无记录') 
                           from LJSGetDraw b where b.PolNo IN ('210470002415999','210470002416000','210470010764027','210470010893422') 
                            and b.contno='881149927495'
                            and b.GetDate <= TRUNC(SYSDATE) 
                            and not exists (select 'V' from LCContState 
                            where PolNo = B.PolNo and StateType = 'Available' 
                            and State = '1' and EndDate is null and StartDate < b.GetDate) 
                            and not exists (select 'B' from LCContState 
                            where PolNo = b.PolNo and StateType = 'Terminate' 
                            and StateReason in ('05', '06') and State = '1' 
                            and EndDate is null and StartDate < b.GetDate)
                            
                            
