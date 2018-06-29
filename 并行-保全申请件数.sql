/*-----------------------------------------------------------------------------------------------------------------
//////////////////////////////////////////--老核心指标--/////////////////////////////////////////////////////
-----------------------------------------------------------------------------------------------------------------*/
--统计
SELECT COUNT(DISTINCT A.EdorAppNo/*保全受理号*/) AS 保全申请件数
FROM LIS.LPEDORITEM A /*老核心.个险保全项目表*/
WHERE TO_CHAR(A.EdorAppDate,'YYYYMMDD') = '20151231'
AND A.MANAGECOM LIKE '8647%'
AND A.CONTNO IN (
      SELECT CONTNO FROM LIS.LCCONT/*老核心.个人保单表*/ 
      WHERE CONTTYPE = '1' 
      AND APPFLAG IN ('1','4')
);
--明细
SELECT EdorAppDate 统计日期,MANAGECOM 管理机构,EdorAppNo 申请号,EDORACCEPTNO 受理号,EdorType 保全项
FROM LIS.LPEDORITEM /*老核心.个险保全项目表*/
WHERE CONTNO/*合同号码*/ IN (
      SELECT CONTNO/*合同号码-保单号*/ FROM LIS.LCCONT/*老核心.个人保单表*/ 
      WHERE CONTTYPE/*总单类型*/ = '1' 
      AND APPFLAG/*投保单/保单标志*/ IN ('1','4')
)
AND MANAGECOM/*管理机构编码*/ LIKE '8647%'
AND TO_CHAR(EdorAppDate/*批改生效日期*/,'YYYYMMDD') = '20151231'
ORDER BY EdorAppNo;
/*-----------------------------------------------------------------------------------------------------------------
//////////////////////////////////////////--新核心指标--/////////////////////////////////////////////////////
-----------------------------------------------------------------------------------------------------------------*/
--统计
SELECT COUNT(DISTINCT TCA.APPLY_CODE) AS 保全申请件数
FROM APP___PAS__DBUSER.T_CS_ACCEPT_CHANGE TCAC 
LEFT JOIN APP___PAS__DBUSER.T_CS_APPLICATION/*保全申请表*/ TCA
     ON TCAC.CHANGE_ID = TCA.CHANGE_ID
WHERE TO_CHAR(TCA.APPLY_TIME, 'YYYYMMDD') = '20151231' --生效日期
AND TCAC.ORGAN_CODE LIKE '8647%'; --机构
--明细
SELECT TCA.APPLY_TIME 统计日期,TCAC.ORGAN_CODE 管理机构,TCA.APPLY_CODE 申请号,TCAC.ACCEPT_CODE 受理号,TCAC.SERVICE_CODE 保全项
FROM APP___PAS__DBUSER.T_CS_ACCEPT_CHANGE TCAC 
LEFT JOIN APP___PAS__DBUSER.T_CS_APPLICATION/*保全申请表*/ TCA
     ON TCAC.CHANGE_ID = TCA.CHANGE_ID
WHERE TO_CHAR(TCA.APPLY_TIME, 'YYYYMMDD') = '20151231' --生效日期
AND TCAC.ORGAN_CODE LIKE '8647%' --机构
ORDER BY TCA.APPLY_CODE;
