/*-----------------------------------------------------------------------------------------------------------------
//////////////////////////////////////////--老核心指标--/////////////////////////////////////////////////////
-----------------------------------------------------------------------------------------------------------------*/
--统计
select (CASE WHEN sum(A.Getmoney)IS NOT NULL THEN sum(A.Getmoney) ELSE 0 END) AS 保全应收付金额
       from  Ljsgetendorse A/*批改补退费*/,Lpedoritem B/*个险保全项目*/
       where EXISTS (SELECT 1 FROM Edoraccept_Scope WHERE B.Edoracceptno = Edoracceptno)
       AND  A.Endorsementno = B.Edorno(+)
       AND A.ManageCom LIKE '8647%'
       AND TO_CHAR(A.GetDate,'YYYYMMDD') = '20151231';--补退费时间
       
--明细
select A.GetDate 统计日期,A.ManageCom 管理机构,A.ContNo 保单号,A.Getmoney 金额,A.GetFlag 补退费标志/*补退费标志0-补1-退*/
       from  Ljsgetendorse A/*批改补退费*/,Lpedoritem B/*个险保全项目*/
       where EXISTS (SELECT 1 FROM Edoraccept_Scope WHERE B.Edoracceptno = Edoracceptno)
       AND  A.Endorsementno = B.Edorno(+)
       AND A.ManageCom LIKE '8647%'
       AND TO_CHAR(A.GetDate,'YYYYMMDD') = '20151231'--补退费时间
ORDER BY A.ContNo;
/*-----------------------------------------------------------------------------------------------------------------
//////////////////////////////////////////--新核心指标--/////////////////////////////////////////////////////
-----------------------------------------------------------------------------------------------------------------*/
--统计
select (CASE WHEN sum(TCPA.FEE_AMOUNT) IS NOT NULL THEN sum(TCPA.FEE_AMOUNT) ELSE 0 END) AS 保全应收付金额
       from T_CS_PREM_ARAP TCPA
WHERE TCPA.ORGAN_CODE LIKE '8647%'
AND TO_CHAR(TCPA.FINISH_TIME, 'YYYYMMDD') = '20151231';--收付费业务核销时间

--明细
select TCPA.POLICY_CODE 保单号,TCPA.ORGAN_CODE 管理机构,TCPA.FEE_AMOUNT 金额,TCPA.FEE_TYPE 补退费标志/*补退费类型32-退41-收*/
       from T_CS_PREM_ARAP TCPA
WHERE TCPA.ORGAN_CODE LIKE '8647%'
AND TO_CHAR(TCPA.FINISH_TIME, 'YYYYMMDD') = '20151231'--收付费业务核销时间
ORDER BY TCPA.POLICY_CODE;
