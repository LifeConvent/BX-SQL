/*
  ps:每个保全项规则都可能不一样，参考需求文档：
  https://10.1.40.1/svn/P1新核心业务系统群/P102核心业务系统/03需求分析/03.05保全子系统/业务需求V0.3.0
*/

select a.policy_id,a.policy_code,a.BUSI_PRD_ID,a.BUSI_PROD_CODE
from dev_pas.t_Contract_Busi_Prod a
where 1=1
/*
基础条件为绝大多数保全项的条件，包含但不限于下列5个
1.基础条件：保单已回执（保单回执日期不为空）
*/
and (SELECT ACKNOWLEDGE_DATE from dev_pas.T_POLICY_ACKNOWLEDGEMENT where a.POLICY_ID=POLICY_ID) is not null
/*
2.基础条件：保单有效（保单状态为有效）
*/
and (select LIABILITY_STATE from dev_pas.t_Contract_Master where a.policy_id=policy_id)='1'
/*
3。基础条件：保单存在可以受理某保全项的险种（产品保全项配对表能同时关联到保全项和产品）
*/
and exists(select 1 from dev_pds.t_Business_Product_Service where a.busi_prd_id=business_prd_id and service_code='RL')
/*
4.基础条件：险种有效（险种状态为有效）
*/
and a.liability_state='1' 
/*
5.基础条件：保单未挂起（业务锁记录表中没有该保单数据）
*/
and not exists(select 1 from dev_pas.T_LOCK_POLICY where policy_id=a.policy_id)
/*
6.具体条件：某些保全项只能操作指定领取责任（例如领取日期变更只能操作1103祝寿金,领取年龄变更只能操作1106养老年金,且需要在领取起期之前申请）
*/
and exists(select 1 from dev_pas.T_PAY_PLAN where busi_item_id=a.BUSI_ITEM_ID and liab_id='1103' and BEGIN_DATE>sysdate)
/*
7.具体条件：某些贷款保全操作需要保单为贷款状态（保单存在有效的贷款账户且余额大于0）
*/
and exists(select 1 from dev_pas.t_Policy_Account where policy_id=a.policy_id and account_type=4 and INTEREST_CAPITAL>0 and POLICY_ACCOUNT_STATUS='1')

;
select * from dev_pds.T_LIABILITY;
select * from dev_pas.T_POLICY_ACCOUNT_TYPE;

/************************************    查询保单做过的保全项记录  ***********************************/
select 
c.accept_status||(select status_desc from dev_pas.t_Accept_Status where accept_status=c.ACCEPT_STATUS) as accept,
b.service_code||(select service_name from dev_pas.T_SERVICE where service_code=b.SERVICE_CODE) as service,
a.service_type||(select type_name from dev_pas.T_SERVICE_TYPE where service_type=a.SERVICE_TYPE) as srv_type,
a.CHANGE_ID,a.APPLY_CODE,c.ACCEPT_CODE,c.ACCEPT_ID,b.POLICY_CODE,b.POLICY_ID,a.APPLY_NAME,a.APPLY_TIME,a.INSERT_TIME,c.UPDATE_TIME,a.INSERT_BY,c.UPDATE_BY,a.TRY_CALC_NO,b.POLICY_CHG_ID
from dev_pas.T_CS_APPLICATION a left join dev_pas.T_CS_POLICY_CHANGE b on a.CHANGE_ID=b.CHANGE_ID left join dev_pas.T_CS_ACCEPT_CHANGE c on a.CHANGE_ID=c.CHANGE_ID 
where 1=1 
  and a.CHANGE_ID in(select change_id from dev_pas.T_CS_POLICY_CHANGE where 1=1
      and POLICY_CODE = '886463762360'  
    --  AND SERVICE_CODE='RF' 
    --  and INSERT_TIME between sysdate-4 and sysdate
  )
