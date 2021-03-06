select A.GetDate 统计日期,A.ManageCom 管理机构,A.ContNo 保单号,A.Getmoney 金额,A.GetFlag 补退费标志/*补退费标志0-补1-退*/
       from  Ljsgetendorse A/*批改补退费*/,Lpedoritem B/*个险保全项目*/
       where EXISTS (SELECT 1 FROM Edoraccept_Scope WHERE B.Edoracceptno = Edoracceptno)
       AND  A.Endorsementno = B.Edorno(+)
       AND A.ManageCom LIKE '8647%'
       AND TO_CHAR(A.GetDate,'YYYYMMDD') = '20151231'--补退费时间
ORDER BY A.ContNo;
  
--明细
select TCPA.POLICY_CODE 保单号,TCPA.ORGAN_CODE 管理机构,TCPA.FEE_AMOUNT 金额,TCPA.FEE_TYPE 补退费标志/*补退费类型32-退41-收*/
       from T_CS_PREM_ARAP TCPA
WHERE TCPA.ORGAN_CODE LIKE '8647%'
AND TO_CHAR(TCPA.FINISH_TIME, 'YYYYMMDD') = '20151231'--收付费业务核销时间
ORDER BY TCPA.POLICY_CODE;
SUM(TCPA.FEE_AMOUNT) 金额
  
--老核心明细
select A.ContNo 保单号,B.EdorAcceptNo 保全受理号,A.Getmoney 老核心金额,A.GetFlag 补退费标志/*补退费标志0-补1-退*/
    from  Ljagetendorse A/*批改补退费*/
       LEFT JOIN Lpedoritem B/*个险保全项目*/
         ON A.Endorsementno = B.Edorno
       LEFT JOIN DEV_PAS.T_CS_PREM_ARAP@BINGXING_168_15 TCPA
         ON TRIM(TCPA.BUSINESS_CODE) = TRIM(B.EdorAcceptNo) --保全受理号
            AND TCPA.DERIV_TYPE = '004'
            AND A.RiskCode = TCPA.BUSI_PROD_CODE
            --AND TCPA.ORGAN_CODE LIKE '8647%'
            --AND TO_CHAR(TCPA.FINISH_TIME, 'YYYYMMDD') =  TO_CHAR(TRUNC(SYSDATE)-1, 'YYYYMMDD')--收付费业务核销时间
    where EXISTS (SELECT 1 FROM Edoraccept_Scope WHERE B.Edoracceptno = Edoracceptno)
       AND A.ManageCom LIKE '8647%'
       --AND TO_CHAR(A.GetDate,'YYYYMMDD') = TO_CHAR(TRUNC(SYSDATE)-1, 'YYYYMMDD')--补退费时间
ORDER BY A.ContNo;

/******************************************************   新核心-保全  ***************************************/

CREATE TABLE  TMP_NCS_2001  AS
--DELETE FROM TMP_NCS_2001;
--COMMIT;
--INSERT INTO TMP_NCS_2001
SELECT TCPA.POLICY_CODE,TCPA.BUSINESS_CODE,SUM(TCPA.FEE_AMOUNT) AS GETMONEY
FROM DEV_PAS.T_CS_PREM_ARAP@BINGXING_168_15 TCPA
WHERE 1=1
    AND TCPA.DERIV_TYPE = '004'
    AND TCPA.ORGAN_CODE LIKE '8647%'
    AND TO_CHAR(TCPA.FINISH_TIME, 'YYYYMMDD') = '20151231'--收付费业务核销时间
GROUP BY TCPA.POLICY_CODE,TCPA.ORGAN_CODE,TCPA.BUSINESS_CODE
ORDER BY TCPA.POLICY_CODE;
COMMIT;

CREATE TABLE  TMP_LIS_2001  AS
--DELETE FROM TMP_LIS_2001;
--COMMIT;
--INSERT INTO TMP_LIS_2001
select /*+PARALLEL(80)*/ep.contno,ep.edoracceptno,b.money as GETMONEY   
from lis.lpedoritem ep,
(select g.otherno as acceptno,-g.sumgetmoney as money ,g.confdate from lis.ljaget g where g.othernotype='10' and g.confdate=date'2017-10-24'
union all select p.otherno as acceptno,p.sumactupaymoney as money, p.confdate from lis.ljapay p where p.othernotype='10' and p.confdate=date'2017-10-24') b
where EXISTS (SELECT 1 FROM Edoraccept_Scope WHERE ep.Edoracceptno = Edoracceptno)
  AND b.acceptno=ep.edoracceptno
  AND ep.managecom LIKE '8647%'
ORDER BY ep.contno;
COMMIT;

SELECT NVL(TRIM(T2.POLICY_CODE),TRIM(T1.CONTNO)) AS 保单号,
       NVL(TRIM(T2.BUSINESS_CODE),TRIM(T1.edoracceptno)) AS 保全受理号,
       NVL(T2.GETMONEY, 0) AS 新核心补退费金额,
       NVL(T1.GETMONEY, 0) AS 老核心补退费金额,
       (CASE NVL(T2.GETMONEY, 0) - NVL(T1.GETMONEY, 0)
          WHEN 0 THEN '否' 
          ELSE '是'              
        END) AS 是否一致
  FROM TMP_LIS_2001 T1
  FULL JOIN TMP_NCS_2001 T2
    ON TRIM(T1.CONTNO) = TRIM(T2.POLICY_CODE)
ORDER BY T2.POLICY_CODE;

/*****************************************   差异明细  *****************************************/
SELECT NVL(TRIM(T2.POLICY_CODE),TRIM(T1.CONTNO)) AS 保单号,
       NVL(TRIM(T2.BUSINESS_CODE),TRIM(T1.CLMNO)) AS 赔案号,
       NVL(T2.GETMONEY, 0) AS 新核心赔付金额,
       NVL(T1.GETMONEY, 0) AS 老核心赔付金额,
       (CASE NVL(T2.GETMONEY, 0) - NVL(T1.GETMONEY, 0)
          WHEN 0 THEN '否' 
          ELSE '是'              
        END) AS 是否一致
  FROM TMP_LIS_2000 T1
  FULL JOIN TMP_NCS_2000 T2
    ON TRIM(T1.CONTNO) = TRIM(T2.POLICY_CODE)
ORDER BY T2.POLICY_CODE;



--CREATE TABLE  TMP_NCS_2000  AS
DELETE FROM TMP_NCS_2000;
COMMIT;
INSERT INTO TMP_NCS_2000
  SELECT A.POLICY_CODE,A.BUSINESS_CODE,SUM(A.FEE_AMOUNT) AS GETMONEY
    FROM DEV_CLM.T_PREM_ARAP@BINGXING_168_15 A
      WHERE A.DERIV_TYPE = '005' --理赔来源
        AND A.ARAP_FLAG = '2' --付费
        AND A.ORGAN_CODE LIKE '%8647%'
        AND A.DUE_TIME = TRUNC(SYSDATE)
        AND A.BUSINESS_CODE IN
            (SELECT CASE_NO
            FROM DEV_CLM.T_CLAIM_CASE@BINGXING_168_15
            WHERE APPROVE_ORGAN LIKE '%8647%'
            AND ORGAN_CODE LIKE '%8647%'
            AND APPROVE_DECISION = '1'
            AND APPROVE_TIME = TRUNC(SYSDATE) -1
            )
  GROUP BY A.POLICY_CODE,A.BUSINESS_CODE
  ORDER BY A.POLICY_CODE;
COMMIT;

--CREATE TABLE  TMP_LIS_2000  AS
DELETE FROM TMP_LIS_2000;
COMMIT;
INSERT INTO TMP_LIS_2000 
  SELECT D.CONTNO,D.CLMNO,SUM(D.PAY) AS GETMONEY
    FROM LIS.LLBALANCE D
   INNER JOIN LIS.LLREPORT C
      ON D.CLMNO = C.RPTNO
   WHERE D.MAKEDATE = TRUNC(SYSDATE) - 2
     AND D.MANAGECOM LIKE '8647%'
   GROUP BY D.CONTNO,D.CLMNO
   ORDER BY D.CONTNO;
COMMIT;
 
SELECT NVL(TRIM(T2.POLICY_CODE),TRIM(T1.CONTNO)) AS 保单号,
       NVL(TRIM(T2.BUSINESS_CODE),TRIM(T1.CLMNO)) AS 赔案号,
       NVL(T2.GETMONEY, 0) AS 新核心赔付金额,
       NVL(T1.GETMONEY, 0) AS 老核心赔付金额,
       (CASE NVL(T2.GETMONEY, 0) - NVL(T1.GETMONEY, 0)
          WHEN 0 THEN '否' 
          ELSE '是'              
        END) AS 是否一致
  FROM TMP_LIS_2000 T1
  FULL JOIN TMP_NCS_2000 T2
    ON TRIM(T1.CONTNO) = TRIM(T2.POLICY_CODE)
ORDER BY T2.POLICY_CODE;


























select A.*,A.GetDate 统计日期,A.ManageCom 管理机构,A.ContNo 保单号,A.Getmoney 金额,A.GetFlag 补退费标志,a.feeoperationtype,a.feefinatype/*补退费标志0-补1-退*/
       from  Ljagetendorse A/*批改补退费*/,Lpedoritem B/*个险保全项目*/
       where EXISTS (SELECT 1 FROM Edoraccept_Scope WHERE B.Edoracceptno = Edoracceptno)
       AND  A.Endorsementno = B.Edorno(+)
       AND  B.EdorAcceptNo = '6120060504000073';
select * from lis.ljapayperson p where p.contno='QD010327011000800';
select * from lis.Ljapay p where  p.othernotype=10 and p.otherno='6120180604049567';

select * from lis.ljaget c where c.othernotype='2'

select * from lis.lpedoritem p where  p.edorvalidate>date'2018-01-01' and p.edorstate='6' ;

select * from lis.ljagetendorse a where a.endorsementno='6120180604049567';
