    
         SELECT DISTINCT TCD.UNIT_NUMBER,
                TCD.BUSINESS_CODE,
                TCD.PAY_MODE,
                (SELECT SUM(FEE_AMOUNT) FROM APP___CAP__DBUSER.T_CASH_DETAIL/*ʵ�ո���ϸ��*/ WHERE UNIT_NUMBER=TCD.UNIT_NUMBER) FEE_AMOUNT,
                TCD.PAYEE_NAME AS PAYEE_NAME,
                TCD.CERTI_CODE AS CERTI_CODE,
                TCD.ARAP_BANK_CODE,
                TCD.ARAP_BANK_ACCOUNT,
                NVL(TCD.DUE_TIME,TCD.INSERT_TIME) DUE_TIME,
                TCD.FINISH_TIME
           FROM APP___CAP__DBUSER.T_CASH_DETAIL TCD
          WHERE TCD.BUSINESS_CODE = '90013413743'
            AND TCD.ARAP_FLAG='2'   
            AND TCD.DERIV_TYPE = '' --ҵ����Դ


/*-----------------------------------------------------------------------------------------------------------------
//////////////////////////////////////////--�Ϻ���--/////////////////////////////////////////////////////
-----------------------------------------------------------------------------------------------------------------*/   
 select ActuGetNo, OtherNO, OtherNoType,PayMode, SumGetMoney,Drawer,DrawerID,BankCode,BankAccNo,ShouldDate,EnterAccDate 
     from ljaget  where otherno = '90013413743'