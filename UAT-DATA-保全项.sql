/*
  ps:ÿ����ȫ����򶼿��ܲ�һ�����ο������ĵ���
  https://10.1.40.1/svn/P1�º���ҵ��ϵͳȺ/P102����ҵ��ϵͳ/03�������/03.05��ȫ��ϵͳ/ҵ������V0.3.0
*/

select a.policy_id,a.policy_code,a.BUSI_PRD_ID,a.BUSI_PROD_CODE
from dev_pas.t_Contract_Busi_Prod a
where 1=1
/*
��������Ϊ���������ȫ�������������������������5��
1.���������������ѻ�ִ��������ִ���ڲ�Ϊ�գ�
*/
and (SELECT ACKNOWLEDGE_DATE from dev_pas.T_POLICY_ACKNOWLEDGEMENT where a.POLICY_ID=POLICY_ID) is not null
/*
2.����������������Ч������״̬Ϊ��Ч��
*/
and (select LIABILITY_STATE from dev_pas.t_Contract_Master where a.policy_id=policy_id)='1'
/*
3�������������������ڿ�������ĳ��ȫ������֣���Ʒ��ȫ����Ա���ͬʱ��������ȫ��Ͳ�Ʒ��
*/
and exists(select 1 from dev_pds.t_Business_Product_Service where a.busi_prd_id=business_prd_id and service_code='RL')
/*
4.����������������Ч������״̬Ϊ��Ч��
*/
and a.liability_state='1' 
/*
5.��������������δ����ҵ������¼����û�иñ������ݣ�
*/
and not exists(select 1 from dev_pas.T_LOCK_POLICY where policy_id=a.policy_id)
/*
6.����������ĳЩ��ȫ��ֻ�ܲ���ָ����ȡ���Σ�������ȡ���ڱ��ֻ�ܲ���1103ף�ٽ�,��ȡ������ֻ�ܲ���1106�������,����Ҫ����ȡ����֮ǰ���룩
*/
and exists(select 1 from dev_pas.T_PAY_PLAN where busi_item_id=a.BUSI_ITEM_ID and liab_id='1103' and BEGIN_DATE>sysdate)
/*
7.����������ĳЩ���ȫ������Ҫ����Ϊ����״̬������������Ч�Ĵ����˻���������0��
*/
and exists(select 1 from dev_pas.t_Policy_Account where policy_id=a.policy_id and account_type=4 and INTEREST_CAPITAL>0 and POLICY_ACCOUNT_STATUS='1')

;
select * from dev_pds.T_LIABILITY;
select * from dev_pas.T_POLICY_ACCOUNT_TYPE;

/************************************    ��ѯ���������ı�ȫ���¼  ***********************************/
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
