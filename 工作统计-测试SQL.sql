
SELECT * FROM LIS.LLBALANCE A WHERE A.CLMNO='90000034953';  
SELECT * FROM LIS.LLBALANCE A WHERE A.CLMNO='90013830628'; 
SELECT TRIM(T1.CLMNO) as CLMNO,T1.CONTNO AS CONTNO,SUM(T1.PAY) AS GETMONEY1
              FROM LIS.LLBALANCE T1
              WHERE TRIM(T1.CLMNO) IN ( SELECT V.BUSINESS_CODE FROM TMP_NCS_2000 V)
            GROUP BY TRIM(T1.CLMNO),T1.CONTNO;
            
            
SELECT * FROM dev_clm.T_PREM_ARAP@BINGXING_168_15 A WHERE A.BUSINESS_CODE = '90013830628'
