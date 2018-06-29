SELECT 
      PA.UNIT_NUMBER, PA.BUSI_PROD_CODE, PA.PAY_MODE, PA.FEE_STATUS, 
      (SELECT PRODUCT_NAME_SYS FROM APP___PAS__DBUSER.T_BUSINESS_PRODUCT WHERE PRODUCT_CODE_SYS=PA.BUSI_PROD_CODE) riskname, 
      (SELECT PAY_LOCATION FROM APP___PAS__DBUSER.T_PAYER_ACCOUNT WHERE POLICY_ID=
              (SELECT POLICY_ID FROM APP___PAS__DBUSER.T_CONTRACT_MASTER WHERE POLICY_CODE=PA.POLICY_CODE)) salechnl,
      PA.FINISH_TIME, PA.FEE_AMOUNT, PA.PAID_COUNT,
      (SELECT MAX(FINISH_TIME) FROM APP___PAS__DBUSER.T_PREM_ARAP 
        WHERE PA.POLICY_CODE=POLICY_CODE AND PA.UNIT_NUMBER=UNIT_NUMBER) senddate,
      PA.FUNDS_RTN_CODE, PA.INSERT_TIME, PA.DUE_TIME,
      (SELECT BANK_RET_NAME FROM APP___PAS__DBUSER.T_BANK_RET_CONF WHERE BANK_RET_CODE=PA.FUNDS_RTN_CODE) codename, 
      (SELECT STATUS_NAME FROM APP___PAS__DBUSER.T_FEE_STATUS WHERE STATUS_CODE=PA.FEE_STATUS) fee_status_name 
      FROM APP___PAS__DBUSER.T_PREM_ARAP PA
      WHERE PA.POLICY_CODE='886491176690' AND PA.DERIV_TYPE='003'/*续保*/ AND PA.FEE_TYPE IN
        ('G003100000'/*新契约保费确认*/,'G003010000'/*续期保费确认*/,'G003020100'/*续期净投资额-基本保费*/,
        'G003020200'/*续期净投资额-额外保费*/,'G003030100'/*初始费用-基本保费*/,'G003040100'/*买入卖出差价-基本保费*/,'G003040200'/*买入卖出差价-额外保费*/);
        
        SELECT * FROM T_DERIVATION_TYPE
        SELECT * FROM APP___PAS__DBUSER.T_PREM_ARAP PA WHERE PA.FINISH_TIME IS NULL ORDER BY PA.UNIT_NUMBER
        SELECT PA.DERIV_TYPE FROM APP___PAS__DBUSER.T_PREM_ARAP PA

  15801231068

3104702243889
      
        Select Ljapayperson.Getnoticeno 交费收据号码,Ljapayperson.Riskcode Riskcode,
          Ljapayperson.Lastpaytodate Lastpaytodate,Ljapayperson.Sumactupaymoney 应缴金额,Ljapayperson.Paycount Paycount,
          Ljapay.bankcode 银行代码 From Ljapayperson Ljapayperson, Ljapay Ljapay 
            Where 1=1 and Ljapayperson.Contno = '886491176690' and Ljapay.Othernotype In ('2', '3', '8','15') and Ljapayperson.Getnoticeno<>'000000'
          and Ljapay.Getnoticeno = Ljapayperson.Getnoticeno
           union
             Select Ljspayperson.Getnoticeno 交费收据号码,Ljspayperson.Riskcode Riskcode,
            Ljspayperson.Lastpaytodate Lastpaytodate,Ljspayperson.Sumactupaymoney 应缴金额,Ljspayperson.Paycount Paycount, 
           Ljspay.bankcode 银行代码 From Ljspayperson Ljspayperson, Ljspay Ljspay 
            Where 1=1 and Ljspayperson.Contno = '886491176690' and Ljspay.Othernotype In ('2', '3', '8','15') and Ljspayperson.Getnoticeno<>'000000' 
            
             Select * From Ljapayperson Ljapayperson
            Where 1=1 and Ljapayperson.Getnoticeno = '3104702243889' 
