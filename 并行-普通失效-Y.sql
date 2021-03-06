 SELECT COUNT(1) 笔数 
  FROM DEV_PAS.T_CONTRACT_BUSI_PROD TBP
  JOIN DEV_PAS.T_CONTRACT_MASTER TCM
    ON TBP.POLICY_CODE = TCM.POLICY_CODE
 WHERE TBP.LIABILITY_STATE = 4  
   AND TCM.ORGAN_CODE LIKE '8647%'
   AND TBP.LAPSE_DATE = DATE '2018-1-3'  --失效日期
   AND TBP.LAPSE_CAUSE = '1'
   
 SELECT TBP.POLICY_CODE,TBP.LAPSE_DATE,TBP.BUSI_PROD_CODE
  FROM DEV_PAS.T_CONTRACT_BUSI_PROD TBP
  JOIN DEV_PAS.T_CONTRACT_MASTER TCM
    ON TBP.POLICY_CODE = TCM.POLICY_CODE
 WHERE TBP.LIABILITY_STATE = 4  
   AND TCM.ORGAN_CODE LIKE '8647%'
   AND TBP.LAPSE_DATE = DATE '2018-1-3'  --失效日期
   AND TBP.LAPSE_CAUSE = '1'
 ORDER BY TBP.POLICY_CODE

SELECT COUNT(1) 笔数 
   FROM LIS.LCPOL A
  INNER JOIN LIS.LCCONT C
     ON A.CONTNO = C.CONTNO
   LEFT JOIN LIS.LCCONTSTATE B
     ON A.CONTNO = B.CONTNO
    AND A.POLNO = B.POLNO
  WHERE C.MANAGECOM LIKE '8647%'
    AND B.MAKEDATE = DATE '2018-12-28'  --失效日期
    AND B.STATETYPE = 'AVAILABLE'
    AND B.STATE = '1'
    AND A.CONTTYPE = '1'
    AND EXISTS
  (SELECT 1 FROM LIS.LJSPAYPERSON E WHERE A.CONTNO = E.CONTNO)--是否存在应收数据
  
 SELECT C.CONTNO, A.RISKCODE, B.STARTDATE, A.MANAGECOM
   FROM LIS.LCPOL A
  INNER JOIN LIS.LCCONT C
     ON A.CONTNO = C.CONTNO
   LEFT JOIN LIS.LCCONTSTATE B
     ON A.CONTNO = B.CONTNO
    AND A.POLNO = B.POLNO
  WHERE C.MANAGECOM LIKE '8647%'
    AND B.MAKEDATE= DATE '2018-12-28'  --失效日期
    AND B.STATETYPE = 'AVAILABLE'
    AND B.STATE = '1'
    AND A.CONTTYPE = '1'
    AND EXISTS
  (SELECT 1 FROM LIS.LJSPAYPERSON E WHERE A.CONTNO = E.CONTNO)
  ORDER BY C.CONTNO
  
