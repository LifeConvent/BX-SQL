/*
  ps:每个保全项规则都可能不一样，参考需求文档：
  https://10.1.40.1/svn/P1新核心业务系统群/P102核心业务系统/03需求分析/03.05保全子系统/业务需求V0.3.0
*/

select a.policy_id,a.policy_code,a.BUSI_PRD_ID,a.BUSI_PROD_CODE,
B.DC_INDI,
B.LAPSE_DATE,
B.EXPIRY_DATE,
B.SUSPEND_DATE,
A.MATURITY_DATE 满期日,
B.ISSUE_DATE,
(SELECT TC.CUSTOMER_BIRTHDAY FROM dev_pas.T_CUSTOMER TC WHERE CUSTOMER_ID = D.CUSTOMER_ID) BIRDATE,
to_number(to_char(b.ISSUE_DATE,'yyyy')) - (SELECT to_number(to_char(TC.CUSTOMER_BIRTHDAY,'yyyy')) FROM dev_pas.T_CUSTOMER TC WHERE CUSTOMER_ID = D.CUSTOMER_ID) AS 投保年龄, --投保年龄
(SELECT TCP.PAY_YEAR FROM DEV_PAS.T_CONTRACT_PRODUCT TCP WHERE TCP.POLICY_ID = a.policy_id AND ROWNUM = 1) AS 领取年期--交至年龄

from dev_pas.t_Contract_Busi_Prod a
LEFT JOIN dev_pas.t_Contract_Master B
ON a.policy_id=B.policy_id
LEFT JOIN dev_pas.T_INSURED_LIST C
ON a.policy_id=C.policy_id
LEFT JOIN dev_pas.T_POLICY_HOLDER D
ON a.policy_id=D.policy_id
where 1=1
/*
基础条件为绝大多数保全项的条件，包含但不限于下列5个
1.基础条件：保单已回执（保单回执日期不为空）
*/
and (SELECT ACKNOWLEDGE_DATE/*回执日期*/ from dev_pas.T_POLICY_ACKNOWLEDGEMENT where a.POLICY_ID=POLICY_ID) is not null
/*
2.基础条件：保单有效（保单状态为有效）
*/
and (select LIABILITY_STATE/*状态*/ from dev_pas.t_Contract_Master where a.policy_id=policy_id)='1'--1-有效 2-中止 4-失效
/*中止原因
and (select LAPSE_CAUSE from dev_pas.t_Contract_Master where a.policy_id=policy_id)='6'--6-贷款中止*/

/*
3。基础条件：保单存在可以受理某保全项的险种（产品保全项配对表能同时关联到保全项和产品）

and exists(select 1 from dev_pbs.t_Business_Product_Service where a.busi_prd_id=business_prd_id and service_code='XX')*/
/*
4.基础条件：险种有效（险种状态为有效）

and a.liability_state='1' */
/*
5.基础条件：保单未挂起、未冻结（业务锁记录表中没有该保单数据）
*/
and not exists(select 1 from dev_pas.T_LOCK_POLICY/*业务所记录表-lock_service_id-92冻结*/ where policy_id=a.policy_id)
/*不处于银行划款期间
and a.policy_id IN (SELECT POLICY_ID
  FROM DEV_PAS.T_PAYER_ACCOUNT
 WHERE PAY_MODE = '32'
   AND POLICY_ID IN
       (SELECT POLICY_ID
          FROM DEV_PAS.T_CONTRACT_EXTEND
         WHERE EXTRACTION_DUE_DATE = DATE '2018-5-30'))*/
/*保单不存在未结案的理赔       
and a.policy_id IN (SELECT F.POLICY_ID from dev_clm.t_claim_case E,dev_clm.t_Claim_Adjust_Busi F WHERE E.CASE_ID = F.CASE_ID AND E.CASE_STATUS IN ('80','90','99'))
*/ 
/*保单存在未结案的理赔 
and a.policy_id IN (SELECT F.POLICY_ID from dev_clm.t_claim_case E,dev_clm.t_Claim_Adjust_Busi F WHERE E.CASE_ID = F.CASE_ID AND E.CASE_STATUS NOT IN ('80','90','99'))
*/
 /*保单不为质押第三方止付 */
and a.policy_id NOT IN (SELECT E.POLICY_ID from dev_pas.t_Cs_Policy_Change E WHERE E.SERVICE_CODE= 'BL')
 /*做过减保
and a.policy_id IN (SELECT E.POLICY_ID from dev_pas.t_Cs_Policy_Change E WHERE E.SERVICE_CODE= 'PT')*/
 /*做过部分领取
and a.policy_id IN (SELECT E.POLICY_ID from dev_pas.t_Cs_Policy_Change E WHERE E.SERVICE_CODE= 'PG')*/
 /*做过多次部分领取
and a.policy_id IN (SELECT TEMP.POLICY_ID FROM (SELECT E.POLICY_ID,COUNT(1) AS TOTAL from dev_pas.t_Cs_Policy_Change E WHERE E.SERVICE_CODE= 'PG' GROUP BY E.POLICY_ID) TEMP WHERE TEMP.TOTAL=2)
*//*做过保单贷款
and a.policy_id IN (SELECT E.POLICY_ID from dev_pas.t_Cs_Policy_Change E WHERE E.SERVICE_CODE= 'LN')*/
/*没做过贷款清偿
and a.policy_id NOT IN (SELECT E.POLICY_ID from dev_pas.t_Cs_Policy_Change E WHERE E.SERVICE_CODE= 'RF')*/
/*贷款未清偿
and a.policy_id IN (SELECT POLICY_ID from dev_pas.T_CS_POLICY_ACCOUNT_STREAM WHERE REGULAR_REPAY = 0)*/
/*未发生给付
and a.policy_id NOT IN (SELECT E.POLICY_ID from dev_pas.t_Cs_Policy_Change E WHERE E.SERVICE_CODE= 'AG')*/
/* 投被保人关系为本人 
and C.RELATION_TO_PH ='00'*/
/* 投保人、受益人关系为本人 
and (SELECT TCCB.CUSTOMER_ID FROM dev_pas.T_CS_CONTRACT_BENE TCCB WHERE TCCB.Policy_Id = a.policy_id AND TCCB.SHARE_ORDER = 1) = D.CUSTOMER_ID
and (SELECT TCCB.DESIGNATION FROM dev_pas.T_CS_CONTRACT_BENE TCCB WHERE TCCB.Policy_Id = a.policy_id AND ROWNUM = 1) = '00'*/
/*被保人没死了*/
and (SELECT DEATH_DATE FROM dev_pas.T_CUSTOMER WHERE CUSTOMER_ID = C.CUSTOMER_ID) IS NULL
/*投保人没死了*/
and (SELECT DEATH_DATE FROM dev_pas.T_CUSTOMER WHERE CUSTOMER_ID = D.CUSTOMER_ID) IS NULL
--AND a.policy_code LIKE '88%'
/* 险种号*/
and BUSI_PROD_CODE LIKE '00618%' 
and ROWNUM <100 
/* 做过健康加费
and a.policy_id IN (SELECT A.POLICY_ID FROM DEV_PAS.T_EXTRA_PREM A WHERE A.EXTRA_TYPE = '1' GROUP BY A.POLICY_ID)--健康加费  */
/*当期保费已交
and a.policy_code IN (SELECT TP.POLICY_CODE FROM dev_pas.T_PREM TP WHERE TP.FINISH_TIME > TP.DUE_TIME GROUP BY TP.POLICY_CODE)*/
/** 趸交 *
and a.policy_id IN (SELECT TCP.POLICY_ID FROM DEV_PAS.T_CONTRACT_PRODUCT TCP WHERE TCP.CHARGE_PERIOD = '3') --1-一次交 2-年交 3-交至确定年龄 6-月交*/
/** 领取年期 **/
and a.policy_id IN (SELECT TCP.POLICY_ID FROM DEV_PAS.T_CONTRACT_PRODUCT TCP WHERE TCP.PAY_YEAR IN (50,55) )
/** 保障年期类型 **/
and a.policy_id IN (SELECT TCP.POLICY_ID FROM DEV_PAS.T_CONTRACT_PRODUCT TCP WHERE TCP.COVERAGE_PERIOD = 'A') --A-岁
/** 保障年期 *
and a.policy_id IN (SELECT TCP.POLICY_ID FROM DEV_PAS.T_CONTRACT_PRODUCT TCP WHERE TCP.COVERAGE_YEAR = 60 )*/
/* 交费年期 
and a.policy_id IN (SELECT TCP.POLICY_ID FROM DEV_PAS.T_CONTRACT_PRODUCT TCP WHERE TCP.CHARGE_YEAR = 20) --期缴*/
/*投保时年龄
and to_char(ADD_MONTHS((SELECT TC.CUSTOMER_BIRTHDAY FROM dev_pas.T_CUSTOMER TC WHERE CUSTOMER_ID = D.CUSTOMER_ID),70 * 12),'yyyy') = to_char(b.ISSUE_DATE,'yyyy')
*/
and  to_number(to_char(b.ISSUE_DATE,'yyyy')) - (SELECT to_number(to_char(TC.CUSTOMER_BIRTHDAY,'yyyy')) FROM dev_pas.T_CUSTOMER TC WHERE CUSTOMER_ID = D.CUSTOMER_ID) IN (48,49,50) --投保时59岁
/*保单已退保
and B.EXPIRY_DATE IS NOT NULL*/
/*保单已失效
and B.LAPSE_DATE IS NOT NULL*/
/*投保月份>生效月份
and (SELECT to_char(TC.CUSTOMER_BIRTHDAY,'mm') FROM dev_pas.T_CUSTOMER TC WHERE CUSTOMER_ID = D.CUSTOMER_ID) < to_char(b.ISSUE_DATE,'mm')*/
ORDER BY b.ISSUE_DATE DESC

(SELECT TP.POLICY_CODE FROM dev_pas.T_PREM TP WHERE TP.FINISH_TIME > TP.DUE_TIME GROUP BY TP.POLICY_CODE)
SELECT * FROM dev_pas.t_Contract_Busi_Prod WHERE BUSI_PROD_CODE LIKE '00233%'
/************************************************************** 通用保全项受理条件 ******************************************************************/
select a.policy_id,a.policy_code,a.BUSI_PRD_ID,a.BUSI_PROD_CODE,B.DC_INDI,B.ISSUE_DATE
from dev_pas.t_Contract_Busi_Prod a
LEFT JOIN dev_pas.t_Contract_Master B
ON a.policy_id=B.policy_id
where 1=1
and (SELECT ACKNOWLEDGE_DATE/*回执日期*/ from dev_pas.T_POLICY_ACKNOWLEDGEMENT where a.POLICY_ID=POLICY_ID) is not null
and (select LIABILITY_STATE/*状态*/ from dev_pas.t_Contract_Master where a.policy_id=policy_id)='1'
and not exists(select 1 from dev_pas.T_LOCK_POLICY/*业务所记录表-lock_service_id-92冻结*/ where policy_id=a.policy_id)
--AND a.policy_code LIKE '88%'
--AND a.policy_code = '88%'
and ROWNUM <1000
ORDER BY b.ISSUE_DATE DESC;
/************************************************************** 通用保全项受理条件 ******************************************************************/

/************************************************************** 老核心-豁免责任 ******************************************************************/
--保单存在投保人豁免责任，但投被保险人为同一人:880069419178   880073384939
SELECT CONTNO FROM LCINSURED
WHERE  (INSUREDNO,CONTNO)  IN (SELECT APPNTNO,CONTNO FROM LLExempt WHERE FreeEndDate > DATE '2018-5-23' AND FreeFlag = '1')
AND CONTNO IN (SELECT A.CONTNO FROM LCPOL A WHERE A.RISKCODE IN ('00540000','00541000','00552000','00553000','00554000'))
;
--保单不存在投保人豁免责任
SELECT A.CONTNO FROM LLExempt A
WHERE A.FreeFlag = '0'   --不免交
AND A.CONTNO IN 
(SELECT CONTNO 
FROM LCPOL
WHERE APPFLAG = '1'
AND CONTNO NOT IN (SELECT CONTNO FROM LCCONTHANGUPSTATE)
AND CONTNO NOT IN (SELECT CONTNO FROM LCINSUREACCSTATE WHERE STATETYPE = 'FROZEN' AND STATE = '0')
AND CONTNO IN (SELECT A.CONTNO FROM LCPOL A WHERE A.RISKCODE IN ('00540000','00541000','00552000','00553000','00554000'))
GROUP BY CONTNO
)
GROUP BY A.CONTNO    
/************************************************************** 老核心-豁免责任 ******************************************************************/

/************************************************************** 新核心-豁免责任 ******************************************************************/
dev_pas.T_CONTRACT_PRODUCT/*保单险种责任表*/IS_WAIVED/*是否已豁免*/WAIVER_START/*豁免开始日期*/WAIVER_END/*豁免结束日期*/POLICY_CODE POLICY_ID
(SELECT TCP.POLICY_ID FROM dev_pas.T_CONTRACT_PRODUCT TCP
WHERE TCP.IS_WAIVED='1'/*是*/)
(SELECT TCP.POLICY_ID FROM dev_pas.T_CONTRACT_PRODUCT TCP
WHERE TCP.IS_WAIVED='0'/*否*/)
(SELECT TCP.WAIVER_END/*结束日期*/ FROM dev_pas.T_CONTRACT_PRODUCT TCP WHERE POLICY_ID = TCP.POLICY_ID
WHERE TCP.IS_WAIVED='1'/*否*/)
TCP.WAIVER_START
TCP.WAIVER_END
LEFT JOIN dev_pas.T_CONTRACT_PRODUCT TCP
ON TCP.POLICY_ID = POLICY_ID
WHERE TCP.IS_WAIVED='1'/*是*/
AND TCP.IS_WAIVED='0'/*否*/
/************************************************************** 新核心-豁免责任 ******************************************************************/

/************************************************************** 红双喜D款（609）******************************************************************/
SELECT CONTNO,CVALIDATE FROM LIS.LCPOL
WHERE CONTTYPE = '1'
AND APPFLAG = '1'
AND RenewCount >= 1
AND CONTNO IN (
SELECT CONTNO FROM LIS.LCPOL 
WHERE RISKCODE = '00609000'
--保全项条件
AND CONTNO IN 
(SELECT CONTNO 
FROM LCPOL
WHERE APPFLAG = '1'
AND CONTNO NOT IN (SELECT CONTNO FROM LCCONTHANGUPSTATE)
AND CONTNO NOT IN (SELECT CONTNO FROM LCINSUREACCSTATE WHERE STATETYPE = 'FROZEN' AND STATE = '0')
AND MANAGECOM LIKE '8647%')
GROUP BY CONTNO
HAVING COUNT(1) > 1)
/************************************************************** 红双喜D款（609）******************************************************************/
--9. 针对年度调整红利，记录红利分配的记录，包括变更记录以及红利分配的明细记录 ??
--11. 取消已经参与清算的应领未领  : QD010526101000147
SELECT CONTNO FROM LJSGETDRAW
WHERE  FEEFINATYPE = 'YF'
AND CONTNO IN (
SELECT CONTNO FROM LOENGBONUSPOL)
AND CONTNO IN 
--保全项条件
(SELECT CONTNO 
FROM LCPOL
WHERE APPFLAG = '1'
AND CONTNO NOT IN (SELECT CONTNO FROM LCCONTHANGUPSTATE)
AND CONTNO NOT IN (SELECT CONTNO FROM LCINSUREACCSTATE WHERE STATETYPE = 'FROZEN' AND STATE = '0')
AND MANAGECOM LIKE '8647%');
/**************************************************************** 可做保全的保额分红产品保单 ***********************************************************/
SELECT CONTNO FROM LCPOL 
WHERE APPFLAG = '1'
AND RISKCODE IN (SELECT RISKCODE FROM LIS.LMRISKAPP WHERE BonusFlag = '2')
AND MANAGECOM LIKE '8647%'
AND CONTNO IN 
--保全项条件
(SELECT CONTNO 
FROM LCPOL
WHERE APPFLAG = '1'
AND CONTNO NOT IN (SELECT CONTNO FROM LCCONTHANGUPSTATE)
AND CONTNO NOT IN (SELECT CONTNO FROM LCINSUREACCSTATE WHERE STATETYPE = 'FROZEN' AND STATE = '0')
AND MANAGECOM LIKE '8647%');
/**************************************************************** 可做保全的保额分红产品保单 ***********************************************************/




select * from dev_pas.T_LOCK_SERVICE_DEF l where l.lock_service_name like '%冻结%';
select * from dev_pas.t_Lock_Policy lp where lp.lock_service_id=82;
select * from dev_pas.t_Contract_Master A where A.ISSUE_DATE IS NOT NULL AND ROWNUM<100 ORDER BY A.POLICY_CODE DESC

/****************************************************************** 老核心保全项条件 ****************************************************************/
--保全项条件
AND CONTNO IN 
(SELECT CONTNO 
FROM LCPOL
WHERE APPFLAG = '1'/*有效-承保*/
AND CONTNO NOT IN (SELECT CONTNO FROM LCCONTHANGUPSTATE)/*保单挂起状态表*/
AND CONTNO NOT IN (SELECT CONTNO FROM LCINSUREACCSTATE/*保单账户状态表*/ WHERE STATETYPE = 'FROZEN' /*状态类型-冻结*/AND STATE = '0')
);
/****************************************************************** 老核心保全项条件 ****************************************************************/

POLICY_CODE dev_pas.T_CS_PREM_ARAP/*保全应收应付*/PAY_END_DATE/*宽限期止期*/

/************************************************ 40637  有预约变更的（如预约减少）要做协议退保 *********************************************/
SELECT LCPOLOTHER.CONTNO, -- 保单号
         LCPOL.RISKCODE, -- 产品编码
         LCDUTY.DUTYCODE, -- 责任组编码
         TO_NUMBER(LCPOLOTHER.P4) AS AMOUNT, -- 预约生效后的基本保额
         LCPOL.CVALIDATE,
         LCPOLOTHER.P2,
         LCPOL.INSUREDAPPAGE
         --ADD_MONTHS(LCPOL.CVALIDATE,(LCPOLOTHER.P2 - LCPOL.INSUREDAPPAGE) * 12) AS DATE
    FROM LCPOLOTHER
    LEFT JOIN LCCONT
      ON LCPOLOTHER.CONTNO = LCCONT.CONTNO
    LEFT JOIN LIS.LCPOL
      ON LCPOLOTHER.CONTNO = LCPOL.CONTNO
     AND LCPOLOTHER.POLNO = LCPOL.POLNO
    LEFT JOIN LIS.LCDUTY
      ON LCPOLOTHER.POLNO = LCDUTY.POLNO
  WHERE LCPOLOTHER.P1 IS NOT NULL
     AND LCPOLOTHER.P2 IS NOT NULL
     AND LCPOLOTHER.P3 IS NOT NULL
     AND LCPOLOTHER.P4 IS NOT NULL
     AND LCPOL.RISKCODE = '00909000'
     AND LCPOL.APPFLAG = '1'
     AND LCCONT.MANAGECOM LIKE '8647%'  --机构
     --AND ADD_MONTHS(LCPOL.CVALIDATE,
                   -- (LCPOLOTHER.P2 - LCPOL.INSUREDAPPAGE) * 12) = TRUNC(SYSDATE); --统计日期 = 客户约定年龄的保单生效日
/************************************************** 40637  有预约变更的（如预约减少）要做协议退保 ********************************************/

/************************************************* 40639 有红利历史的有效保单，期间过两年 ****************************************************************/
SELECT * FROM LOENGBONUSPOL
WHERE POLNO IN (SELECT POLNO FROM LCPOL WHERE APPFLAG = '1' AND MANAGECOM LIKE '8647%')
SELECT E.POLICY_ID from dev_pas.t_Cs_Policy_Change E WHERE E.SERVICE_CODE= 'BL')
/*********************************************** 40639 有红利历史的有效保单，期间过两年 ****************************************************************/

/********************************************** 41598、41599 在宽限期内，续期保费未交纳，应收记录已经生成 : 881311046827 *************************************/
SELECT CONTNO,PAYDATE,LASTPAYTODATE FROM LJSPAYPERSON
WHERE TRUNC(SYSDATE) < PAYDATE
AND TRUNC(SYSDATE) < LASTPAYTODATE
AND PAYCOUNT > 1
/********************************************** 41598、41599 在宽限期内，续期保费未交纳，应收记录已经生成 : 881311046827 *******************************************/

/********************************************** 41591 客户不满足变更后的保障计划标准（保障计划约定变更） ****************************************/
--保单号：887400858972  被保人号：3220084230
SELECT *
  FROM LIS.LPEDORITEM
 WHERE EDORTYPE = 'XX'
   AND EDORSTATE <> '0'
   AND APPROVEFLAG = '3'
   AND CONTNO IN (SELECT CONTNO
                    FROM LIS.LCCONT
                    WHERE CONTTYPE = '1'
                     AND APPFLAG = '1'); 
/******************************************* 41591 客户不满足变更后的保障计划标准（保障计划约定变更）*********************************************/
                     
/****************************** 保单处于最大续保年度和最大续保年龄的前一年 : 保单号：880373915507   被保人号：0028097470 ********************************/
SELECT T1.CONTNO,T1.RISKCODE,T1.INSUREDNO,T2.MAXINSUREDAGE,T1.INSUREDAPPAGE
FROM LIS.LCPOL T1
INNER JOIN LIS.LMRISKAPP T2
ON T1.RISKCODE = T2.RISKCODE
WHERE T2.RISKCODE IN (SELECT RISKCODE FROM LIS.LMRISK WHERE RNEWFLAG = 'Y') --续保标志
AND T2.RISKPROP IN ('I','Y','T') --险种性质
AND T2.MAXINSUREDAGE <> '999'
AND T2.MAXINSUREDAGE - T1.INSUREDAPPAGE <=1 --最大被保人年龄、被保人投保年龄
AND T1.APPFLAG = '1'
AND T2.RISKCODE IN ('00540000','00541000','00552000','00553000','00554000')
AND MANAGECOM LIKE '8647%';
/****************************** 保单处于最大续保年度和最大续保年龄的前一年 ********************************/

SELECT A.POLICY_ID FROM DEV_PAS.T_EXTRA_PREM A WHERE A.EXTRA_TYPE = '1' GROUP BY A.POLICY_ID--健康加费 

SELECT A.POLICY_ID FROM DEV_PAS.T_EXTRA_PREM A WHERE A.EXTRA_TYPE = '2' --职业加费 

SELECT TCP.POLICY_ID FROM DEV_PAS.T_CONTRACT_PRODUCT TCP WHERE TCP.CHARGE_PERIOD = '1' --一次交

SELECT CHARGE_YEAR/*缴费期间*/,PREM_FREQ FROM DEV_PAS.T_CONTRACT_PRODUCT TCP 

/****************************** 10199-原交费期限为15年，保单年度<=10，有健康加费 -234产品（无数据） ********************************/
SELECT /*+PARALLEL(100)*/ * FROM LIS.LJAPAYPERSON
WHERE RISKCODE = '00234000'
AND PAYPLANCODE LIKE '00000%'
--AND MANAGECOM LIKE '8647%'
AND POLNO IN (SELECT POLNO FROM LIS.LCPOL WHERE CONTTYPE = '1' AND APPFLAG = '1' AND PAYYEARS = 15)
ORDER BY MAKEDATE DESC;
/****************************** 10199-原交费期限为15年，保单年度<=10，有健康加费 -234产品（无数据） ********************************/
 
/******************************************* 10158-在第T保单年度贷款中止、交费方式为一次交清、做过健康加费(233)(没数据) *********************************************/
 SELECT /*+PARALLEL(100)*/  T1.*
FROM LIS.LCCONTSTATE T1
INNER JOIN LIS.LCPOL T2
ON T1.POLNO = T2.POLNO
WHERE T1.STATETYPE = 'Loan'
   AND T1.STATE = '0'
   AND T1.STATEREASON = '06'
   AND T2.PAYINTV = '0'
   AND T2.RISKCODE = '00233000'
   AND (T1.STARTDATE - T2.CVALIDATE) < 365
   AND T1.POLNO IN (SELECT /*+PARALLEL(100)*/  POLNO FROM LIS.LCPREM WHERE PAYPLANCODE LIKE '00000%');
/******************************************* 10158-在第T保单年度贷款中止、交费方式为一次交清、做过健康加费(233)(没数据) *********************************************/
  
SELECT CValiDate FROM LIS.LCPOL WHERE CONTNO = 'TJ030022341001023'
/******************************************* --10215-生存至满七十周岁的合同生效对应日且未曾发生234的两项保险金给付、做过健康加费、减保（234）（TJ030022341001023）*********************************************/
SELECT /*+PARALLEL(100)*/
*
  FROM LIS.LPEDORITEM
WHERE EDORTYPE = 'PT'
   AND POLNO IN (SELECT /*+PARALLEL(100)*/
                  POLNO
                   FROM LIS.LJAPAYPERSON
                  WHERE RISKCODE = '00234000'
                    AND PAYPLANCODE LIKE '00000%')
   AND /*+PARALLEL(100)*/
       POLNO IN (SELECT POLNO
                   FROM LIS.LCPOL
                  WHERE CONTTYPE = '1'
                    AND APPFLAG = '1');
/******************************************* 未曾发生234的两项保险金给付、做过健康加费、减保 *********************************************/
 
/******************************************* 10168-已到满期日，做过健康加费、减保（233）（无数据）*********************************************/
SELECT /*+PARALLEL(100)*/ *
  FROM LIS.LPEDORITEM
WHERE EDORTYPE = 'PT'
   AND POLNO IN (SELECT /*+PARALLEL(100)*/
                  POLNO
                   FROM LIS.LJAPAYPERSON
                  WHERE RISKCODE = '00233000'
                    AND PAYPLANCODE LIKE '00000%')
   AND /*+PARALLEL(100)*/
       POLNO IN (SELECT POLNO
                   FROM LIS.LCPOL
                  WHERE CONTTYPE = '1'
                    AND APPFLAG = '4');
/******************************************* 10168-已到满期日，做过健康加费、减保（233）（无数据）*********************************************/
 
/******************************************* 10171-过宽限期后未交保费（233）*********************************************/  
SELECT /*+PARALLEL(100)*/ *
  FROM LJSPAYPERSON
WHERE RISKCODE = '00233000'
   AND TRUNC(SYSDATE) > PAYDATE
   AND POLNO IN (SE)
   ORDER BY PAYDATE DESC;
(SELECT CONTNO
FROM LIS.LCPOL
WHERE APPFLAG = '1'/*有效-承保*/
AND CONTNO NOT IN (SELECT CONTNO FROM LCCONTHANGUPSTATE)/*保单挂起状态表*/
AND CONTNO NOT IN (SELECT CONTNO FROM LCINSUREACCSTATE/*保单账户状态表*/ WHERE STATETYPE = 'FROZEN' /*状态类型-冻结*/AND STATE = '0')
AND CONTNO = 'NJ010022331000270'
)
/******************************************* 10171-过宽限期后未交保费（233）*********************************************/ 
 
/******************************************* 10169-有多给付的生存金（233、234产品）*********************************************/
SELECT /*+PARALLEL(100)*/  POLNO,COUNT(1)
FROM LIS.LJAGETDRAW
WHERE RISKCODE IN ('00233000','00234000')
AND FEEFINATYPE = 'YF'
AND POLNO IN (SELECT /*+PARALLEL(100)*/  POLNO FROM LIS.LCPOL WHERE CONTTYPE = '1' AND APPFLAG = '1')
GROUP BY POLNO
HAVING COUNT(1) > 1 ;

SELECT /*+PARALLEL(100)*/  POLNO,COUNT(1)
FROM LJAGETDRAW B --投保人号 APPNTNO 投保人号 InsuredNo
WHERE B.FEEFINATYPE = 'YF'
AND B.POLNO IN (SELECT /*+PARALLEL(100)*/  POLNO FROM LCPOL WHERE CONTTYPE = '1' AND APPFLAG = '1')
AND (SELECT A.RelationToAppnt FROM LCInsured A WHERE A.InsuredNo = B.InsuredNo AND A.CONTNO = B.CONTNO AND A.AppntNo = B.AppntNo ) = '00'
AND (SELECT A.RelationToInsured FROM LCBnf A WHERE A.InsuredNo = B.InsuredNo AND A.CONTNO = B.CONTNO AND A.PolNo = B.PolNo AND A.BnfNo = 1) = '00'
GROUP BY B.POLNO
HAVING COUNT(1) > 1 ;
 
SELECT /*+PARALLEL(100)*/  POLNO,COUNT(1)
SELECT *
FROM LJAGETDRAW
--WHERE RISKCODE IN ('00233000','00234000')
WHERE FEEFINATYPE = 'YF'
AND POLNO IN (SELECT /*+PARALLEL(100)*/  POLNO FROM LCPOL WHERE CONTTYPE = '1' AND APPFLAG = '1')
AND RISKCODE LIKE '00146%'
;
SELECT * FROM LCGET WHERE GETDUTYCODE = '234040'
/******************************************* 10169-有多给付的生存金（233、234产品）*********************************************/

/******************************************* 10165-交费方式为年交、尚未交纳第3期保费(233)(附带生效日)  NJ010022331000130 *********************************************/
SELECT /*+PARALLEL(100)*/  T2.*
FROM LIS.LCPOL T1
INNER JOIN LIS.LJSPAYPERSON T2
ON T1.POLNO = T2.POLNO
WHERE T2.RISKCODE = '00233000'
AND T2.PAYINTV = 12
AND T2.LASTPAYTODATE - T1.CVALIDATE = 1095

SELECT /*+PARALLEL(100)*/   * FROM LIS.LJAPAYPERSON WHERE CONTNO = 'NJ010022331000130'
/******************************************* 交费方式为年交、尚未交纳第3期保费(233) *********************************************/
 
 
/******************************************* 10209-1.交费方式为期交 2.年交保费交费结束以后 3.做过健康加费、职业加费（234） BJ010022341003131 *********************************************/
SELECT /*+PARALLEL(100)*/   *
FROM LIS.LJAPAYPERSON
WHERE PAYCOUNT > 1
AND PAYINTV > 0
AND PAYPLANCODE LIKE '00000%'
AND PAYTYPE <> 'ZC'
AND RISKCODE = '00234000'
AND MANAGECOM LIKE '8647%'

SELECT /*+PARALLEL(100)*/   * FROM LIS.LJAPAYPERSON WHERE CONTNO = 'BJ010022341003131'
(SELECT CONTNO
FROM LIS.LCPOL
WHERE APPFLAG = '1'/*有效-承保*/
AND CONTNO NOT IN (SELECT CONTNO FROM LCCONTHANGUPSTATE)/*保单挂起状态表*/
AND CONTNO NOT IN (SELECT CONTNO FROM LCINSUREACCSTATE/*保单账户状态表*/ WHERE STATETYPE = 'FROZEN' /*状态类型-冻结*/AND STATE = '0')
AND CONTNO = 'BJ010022341003131'
)
/******************************************* 1.期交 2.年交保费交费结束后 3.做过健康加费、职业加费（234） BJ010022341003131 *********************************************/
 
 
/*******************************************10207-交费方式为年交、当期保费已交、做过健康加费（附生效日）（234）*********************************************/
SELECT /*+PARALLEL(100)*/  T2.CONTNO,T2.PayDate 缴费日期,T2.CurPayToDate 现交至,T1.CValiDate 生效日期
FROM LCPOL T1
INNER JOIN LJAPAYPERSON T2
ON T1.POLNO = T2.POLNO
WHERE T2.RISKCODE = '00233000'
AND PAYPLANCODE LIKE '00000%'--健康加费
AND T2.PAYINTV = 12 --年交
AND T1.CONTNO IN 
(SELECT CONTNO 
FROM LCPOL
WHERE APPFLAG = '1'/*有效-承保*/
AND CONTNO NOT IN (SELECT CONTNO FROM LCCONTHANGUPSTATE)/*保单挂起状态表*/
AND CONTNO NOT IN (SELECT CONTNO FROM LCINSUREACCSTATE/*保单账户状态表*/ WHERE STATETYPE = 'FROZEN' /*状态类型-冻结*/AND STATE = '0')
)
ORDER BY CONTNO;
/*******************************************10207-交费方式为年交、当期保费已交、做过健康加费（附生效日）（234）*********************************************/

/****************************** 交费期限为15年，保单年度， -521产品 ********************************/
SELECT /*+PARALLEL(100)*/ CONTNO,COUNT(1) FROM LJAPAYPERSON
WHERE RISKCODE = '00909000'
AND POLNO IN (SELECT POLNO FROM LCPOL WHERE CONTTYPE = '1' AND APPFLAG = '1' /*AND PAYYEARS = 5缴费期间*/)
GROUP BY CONTNO
HAVING COUNT(1) = 0 ;

SELECT /*+PARALLEL(100)*/ CONTNO,COUNT(1) FROM LJSPAYPERSON
WHERE RISKCODE = '00909000'
AND POLNO IN (SELECT POLNO FROM LCPOL WHERE CONTTYPE = '1' AND APPFLAG = '1' /*AND PAYYEARS = 5缴费期间*/)
GROUP BY CONTNO
HAVING COUNT(1) = 0 ;

SELECT /*+PARALLEL(100)*/ CONTNO,COUNT(1) FROM LIS.LJAPAYPERSON
WHERE RISKCODE = '00515000'
AND POLNO IN (SELECT POLNO FROM LIS.LCPOL WHERE CONTTYPE = '1' AND APPFLAG = '1' AND PAYYEARS = 10/*缴费期间*/)
--AND PAYINTV/*缴费间隔*/ > 0 --期交
GROUP BY CONTNO
HAVING COUNT(1) > 0 ;

SELECT /*+PARALLEL(100)*/ * FROM LJSPAYPERSON WHERE CONTNO = '886666931739';
/****************************** 交费期限为15年，保单年度， -521产品 ********************************/
/*
T_CS_CONTRACT_PRODUCT 险种责任表 BONUS_MODE 红利领取方式 
1;抵交保费
2;累积生息
3;交清增额保险
4;现金领取
5;一年定期寿险
6;增额交清
7;转指定险种
9;其他*/

select TPP.POLICY_CODE from dev_pas.T_PAY_PLAN tpp where tpp.liab_name like '%养老%' AND PAY_NUM > 0

select TPP.POLICY_CODE,TPP.BUSI_PROD_CODE,TPP.LIAB_NAME 保障责任名称,TPP.PAY_DUE_DATE 下次应领日期,TPP.PAY_NUM 当前实领次数,
       TPP.BEGIN_DATE 给付开始日期,TPP.END_DATE 给付结束日期,TPP.PAY_STATUS 给付状态 
  from dev_pas.T_PAY_PLAN tpp 
 where tpp.liab_name like '%养老%'
   --AND TPP.End_Date < (SYSDATE)
   --AND TPP.End_Date > DATE '2017-01-01'
   --and tpp.pay_due_date < (sysdate)
   AND PAY_NUM > 0
   AND tpp.POLICY_CODE IN (select a.policy_code
from dev_pas.t_Contract_Busi_Prod a
LEFT JOIN dev_pas.T_INSURED_LIST C
ON a.policy_id=C.policy_id
where 1=1
and (SELECT ACKNOWLEDGE_DATE/*回执日期*/ from dev_pas.T_POLICY_ACKNOWLEDGEMENT where a.POLICY_ID=POLICY_ID) is not null
and (select LIABILITY_STATE/*状态*/ from dev_pas.t_Contract_Master where a.policy_id=policy_id)='1'--1-有效 2-中止 4-失效
and not exists(select 1 from dev_pas.T_LOCK_POLICY/*业务所记录表-lock_service_id-92冻结*/ where policy_id=a.policy_id)
and C.RELATION_TO_PH ='00'
and (SELECT TCCB.DESIGNATION FROM dev_pas.T_CS_CONTRACT_BENE TCCB WHERE TCCB.Policy_Id = a.policy_id AND ROWNUM = 1) = '00'
)
   
-- 给付状态： 1;待处理 2;处理中 3;取消 4;终止

/*************************************** 存在生存金给付、投被保人受益人为同一人 超级慢****************************************/
 select TPP.POLICY_CODE,TPP.BUSI_PROD_CODE,TPP.LIAB_NAME 保障责任名称,TPP.PAY_DUE_DATE 下次应领日期,TPP.PAY_NUM 当前实领次数,
       TPP.BEGIN_DATE 给付开始日期,TPP.END_DATE 给付结束日期,TPP.PAY_STATUS 给付状态
from dev_pas.t_Contract_Busi_Prod a
LEFT JOIN dev_pas.T_INSURED_LIST C
ON a.policy_id=C.policy_id
LEFT JOIN dev_pas.T_PAY_PLAN tpp 
ON a.policy_id=tpp.policy_id
where 1=1
and (SELECT ACKNOWLEDGE_DATE/*回执日期*/ from dev_pas.T_POLICY_ACKNOWLEDGEMENT where a.POLICY_ID=POLICY_ID) is not null
and (select LIABILITY_STATE/*状态*/ from dev_pas.t_Contract_Master where a.policy_id=policy_id)='1'--1-有效 2-中止 4-失效
and not exists(select 1 from dev_pas.T_LOCK_POLICY/*业务所记录表-lock_service_id-92冻结*/ where policy_id=a.policy_id)
and C.RELATION_TO_PH ='00'
and (SELECT TCCB.DESIGNATION FROM dev_pas.T_CS_CONTRACT_BENE TCCB WHERE TCCB.Policy_Id = a.policy_id AND ROWNUM = 1) = '00'
and tpp.liab_name like '养老%'
AND PAY_NUM > 1
AND ROWNUM <100
/*************************************** 存在生存金给付、投被保人受益人为同一人 ****************************************/
SELECT /*+PARALLEL(100)*/  POLNO,COUNT(1)
FROM LJAGETDRAW B --投保人号 APPNTNO 投保人号 InsuredNo
WHERE B.FEEFINATYPE = 'YF'
AND B.POLNO IN (SELECT /*+PARALLEL(100)*/  POLNO FROM LCPOL WHERE CONTTYPE = '1' AND APPFLAG = '1')
--AND (SELECT A.RelationToAppnt FROM LCInsured A WHERE A.InsuredNo = B.InsuredNo AND A.CONTNO = B.CONTNO AND A.AppntNo = B.AppntNo ) = '00'
--AND (SELECT A.RelationToInsured FROM LCBnf A WHERE A.InsuredNo = B.InsuredNo AND A.CONTNO = B.CONTNO AND A.PolNo = B.PolNo AND A.BnfNo = 1) = '00'
GROUP BY B.POLNO
HAVING COUNT(1) > 1 ;

SELECT * FROM LJAGETDRAW B WHERE POLNO = '';
/*************************************** 存在生存金给付、投被保人受益人为同一人 ****************************************/
SELECT * FROM LPEdorItem
WHERE 1=1
AND EdorType = 'LN'
AND ContNo IN 
(SELECT CONTNO 
FROM LCPOL
WHERE APPFLAG = '1'/*有效-承保*/
AND CONTNO NOT IN (SELECT CONTNO FROM LCCONTHANGUPSTATE)/*保单挂起状态表*/
AND CONTNO NOT IN (SELECT CONTNO FROM LCINSUREACCSTATE/*保单账户状态表*/ WHERE STATETYPE = 'FROZEN' /*状态类型-冻结*/AND STATE = '0')
);

SELECT OTHERNO FROM LPEdorApp

/****************************  附加指定险种的有效保单 例子 652为主险 *********************************************/
 select * from dev_pas.t_contract_master tcm where tcm.policy_id in(
     select tbp.policy_id 
       from dev_pas.t_contract_busi_prod tbp,dev_pas.t_contract_busi_prod tbp0--,dev_pas.t_contract_busi_prod tbp1 
       where 1=1
         and tbp0.busi_prod_code='00388000'
         and tbp.busi_prod_code='00909000' 
         and tbp.master_busi_item_id=tbp0.busi_item_id 
         --and tbp1.busi_prod_code='00786000'
         --and tbp1.master_busi_item_id=tbp0.busi_item_id
     ) and tcm.liability_state=1 
/****************************  附加指定险种的有效保单 例子 652为主险 *********************************************/


SELECT * FROM dev_pas.t_Contract_Master B WHERE B.Organ_Code LIKE '8622%'
