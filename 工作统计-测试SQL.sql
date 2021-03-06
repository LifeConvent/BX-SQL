
/********************************************************    保全测试脚本    ************************************************************/8
--老核心信息查询
SELECT * FROM LIS.LLBALANCE A WHERE A.CLMNO='90000034953';  
SELECT * FROM LIS.LLBALANCE A WHERE A.CLMNO='90013830628'; 
SELECT TRIM(T1.CLMNO) as CLMNO,T1.CONTNO AS CONTNO,SUM(T1.PAY) AS GETMONEY1
              FROM LIS.LLBALANCE T1
              WHERE TRIM(T1.CLMNO) IN ( SELECT V.BUSINESS_CODE FROM TMP_NCS_2000 V)
            GROUP BY TRIM(T1.CLMNO),T1.CONTNO;
            
--理赔收付费信息查询            
SELECT * FROM dev_clm.T_PREM_ARAP@BINGXING_168_15 A WHERE A.BUSINESS_CODE = '90013756949';
--理赔赔案信息查询
SELECT * FROM DEV_CLM.T_CLAIM_CASE@BINGXING_168_15 C WHERE C.CASE_NO = '90013756949';


/********************************************************    保全测试脚本    ************************************************************/8
--保全老核心查询
SELECT * FROM LIS.lpedoritem A WHERE A.EDORACCEPTNO ='6120180629022554'
