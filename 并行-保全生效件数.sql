/*-----------------------------------------------------------------------------------------------------------------
//////////////////////////////////////////--老核心指标--/////////////////////////////////////////////////////
-----------------------------------------------------------------------------------------------------------------*/
--统计
SELECT COUNT(DISTINCT A.EdorAcceptNo/*保全受理号*/) AS 保全生效件数
FROM LIS.LPEDORITEM A /*老核心.个险保全项目表*/
WHERE TO_CHAR(A.EdorValiDate,'YYYYMMDD') = '20151231'
AND A.MANAGECOM LIKE '8647%'
AND A.CONTNO IN (
      SELECT CONTNO FROM LIS.LCCONT/*老核心.个人保单表*/ 
      WHERE CONTTYPE = '1' 
      AND APPFLAG IN ('1','4')
);
--明细
SELECT L.VALIDATE_TIME 统计日期,MANAGECOM 管理机构,EDORACCEPTNO 受理号,EdorType 保全项
FROM LIS.LPEDORITEM /*老核心.个险保全项目表*/
WHERE CONTNO/*合同号码*/ IN (
      SELECT CONTNO/*合同号码-保单号*/ FROM LIS.LCCONT/*老核心.个人保单表*/ 
      WHERE CONTTYPE/*总单类型*/ = '1' 
      AND APPFLAG/*投保单/保单标志*/ IN ('1','4')
)
AND MANAGECOM/*管理机构编码*/ LIKE '8647%'
AND TO_CHAR(EDORVALIDATE/*批改生效日期*/,'YYYYMMDD') = '20151231'
ORDER BY EDORACCEPTNO;
/*-----------------------------------------------------------------------------------------------------------------
//////////////////////////////////////////--新核心指标--/////////////////////////////////////////////////////
-----------------------------------------------------------------------------------------------------------------*/
--统计
SELECT COUNT(DISTINCT L.ACCEPT_CODE) AS 保全生效件数
FROM T_CS_ACCEPT_CHANGE L
WHERE TO_CHAR(L.VALIDATE_TIME, 'YYYYMMDD') = '20151231' --生效日期
AND L.ORGAN_CODE LIKE '8647%'; --机构
--明细
SELECT L.VALIDATE_TIME 统计时间,L.ORGAN_CODE 管理机构,L.ACCEPT_CODE 受理号,L.SERVICE_CODE 保全项
FROM T_CS_ACCEPT_CHANGE L
WHERE TO_CHAR(L.VALIDATE_TIME, 'YYYYMMDD') = '20151231' --生效日期
AND L.ORGAN_CODE LIKE '8647%' --机构
ORDER BY L.ACCEPT_CODE;
