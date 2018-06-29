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
      WHERE PA.POLICY_CODE='886491176690' AND PA.DERIV_TYPE='003'/*����*/ AND PA.FEE_TYPE IN
        ('G003100000'/*����Լ����ȷ��*/,'G003010000'/*���ڱ���ȷ��*/,'G003020100'/*���ھ�Ͷ�ʶ�-��������*/,
        'G003020200'/*���ھ�Ͷ�ʶ�-���Ᵽ��*/,'G003030100'/*��ʼ����-��������*/,'G003040100'/*�����������-��������*/,'G003040200'/*�����������-���Ᵽ��*/);
        
        SELECT * FROM T_DERIVATION_TYPE
        SELECT * FROM APP___PAS__DBUSER.T_PREM_ARAP PA WHERE PA.FINISH_TIME IS NULL ORDER BY PA.UNIT_NUMBER
        SELECT PA.DERIV_TYPE FROM APP___PAS__DBUSER.T_PREM_ARAP PA

  15801231068

3104702243889
      
        Select Ljapayperson.Getnoticeno �����վݺ���,Ljapayperson.Riskcode Riskcode,
          Ljapayperson.Lastpaytodate Lastpaytodate,Ljapayperson.Sumactupaymoney Ӧ�ɽ��,Ljapayperson.Paycount Paycount,
          Ljapay.bankcode ���д��� From Ljapayperson Ljapayperson, Ljapay Ljapay 
            Where 1=1 and Ljapayperson.Contno = '886491176690' and Ljapay.Othernotype In ('2', '3', '8','15') and Ljapayperson.Getnoticeno<>'000000'
          and Ljapay.Getnoticeno = Ljapayperson.Getnoticeno
           union
             Select Ljspayperson.Getnoticeno �����վݺ���,Ljspayperson.Riskcode Riskcode,
            Ljspayperson.Lastpaytodate Lastpaytodate,Ljspayperson.Sumactupaymoney Ӧ�ɽ��,Ljspayperson.Paycount Paycount, 
           Ljspay.bankcode ���д��� From Ljspayperson Ljspayperson, Ljspay Ljspay 
            Where 1=1 and Ljspayperson.Contno = '886491176690' and Ljspay.Othernotype In ('2', '3', '8','15') and Ljspayperson.Getnoticeno<>'000000' 
            
             Select * From Ljapayperson Ljapayperson
            Where 1=1 and Ljapayperson.Getnoticeno = '3104702243889' 
