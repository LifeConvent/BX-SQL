--服务地址，保单库
select * from dev_pas.t_udmp_service_env;

-- FTP 地址配置表
select * from dev_nb.t_bpo_path_cfg for update;

--- 业务员  设置业务员销售资格  保单库 10.1.81.75 
-- 将 t_agent 的 agent_channel 改为 03
select * from APP___pas__DBUSER.t_agent a where a.agent_organ_code like '8621%' order by a.update_timestamp desc;
select * from APP___pas__DBUSER.t_agent a where a.agent_status = '1' and 
a.agent_organ_code = '86210001' and a.agent_code = '38018318' for update ;
-- update APP___pas__DBUSER.t_agent set agent_status = 1 ,agent_channel = '03' where agent_code = '38018318';
commit;
select * from dev_nb.t_bpo_entry_config a order by a.insert_time desc; where a.organ_code = ''

select * from dev_nb.t_image_scan a where 

-- 将 t_agent_license 的state 改为 1  license_type = 6
select * from APP___pas__DBUSER.t_Agent_License where agent_code = '38018318' for update;

-- update APP___pas__DBUSER.t_agent_license set state = 1 where agent_code = '38018318';
commit;

select * from APP___pas__DBUSER.t_agent a where a.agent_code = '36785462';
select * from APP___PAS__DBUSER.t_agent a where a.agent_code = '38020342';

update APP___pas__DBUSER.t_agent set agent_mobile = '18310186005' where agent_code = '38020342'


38020342

select * from APP___pas__DBUSER.t_agent_license A WHERE A.AGENT_CODE = '01222725';

select * from dev_nb.t_nb_contract_master where apply_code ='20180324184900'
 
BPO 业务员 38442520

update APP___pas__DBUSER.t_agent set agent_status = 1 ,agent_channel = '03' where agent_code = '38442520';

select * from APP___pas__DBUSER.t_Agent_License where agent_code = '38442520' for update;
update APP___pas__DBUSER.t_agent_license set state = 1 where agent_code = '38442520';
commit;

select * from APP___PAS__DBUSER.t_agent a where a.agent_code = '15200873';
select * from APP___pas__DBUSER.t_agent_license where agent_code = '37197484';

select * from APP___PAS__DBUSER.T_udmp_org_rel

-- 管理机构表
select * from APP___PAS__DBUSER.T_udmp_org where organ_name like '%天山%'
select * from APP___PAS__DBUSER.T_udmp_org where organ_code like '8649%'
select * from APP___PAS__DBUSER.T_udmp_org where organ_code = '86400006'
select * from APP___pas__DBUSER.t_agent a where a.agent_organ_code = '86240503'
86240503


86400006

-- 投保单主表
select * from dev_nb.T_NB_CONTRACT_MASTER where apply_code = '33180308000003'

-- 外包商配置表
select * from dev_nb.t_bpo_org where org_type = '0';


-- 保单责任信息表
select * from dev_nb.t_nb_contract_product where apply_code = '22180205000015';
select * from dev_nb.t_nb_contract_product_other where apply_code = '22180205000015';
-- uat  开发业务员 38364481


select * from dev_nb.T_NB_CONTRACT_MASTER where apply_code = '22180205000015';
15200873

select * from dev_nb.t_bpo_entry_detail where apply_code = '22180414000001';

select * from dev_pas.t_customer a where a.customer_name = '李欣' and a.customer_certi_code  = '110101201311010029'


22180410000003




for update;
-- 产品代码
select * from app___nb__dbuser.t_product_life
36785462
      
select * from dev_nb.t_bpo_entry_detail t where t.apply_code = '20180412111004'
select * from dev_nb.T_NB_INSURED_LIST where apply_code = '20180201110003'
select * from APP___NB__DBUSER.T_COUNTRY
select * from dev_nb.t_customer where customer_id = '77482'
77482

select * from dev_pas.t_lock_policy a where a.policy_id = '1213';
select * from dev_pas.t_contract_master a where a.policy_id = '1213';




SELECT A.SUBMIT_CHANNEL,A.POLICY_CODE,A.UW_COMPLETE_TIME,A.issue_date,A.APPOINT_VALIDATE,A.Apply_Date,a.proposal_status,a.apply_code,A.MEDIA_TYPE,a.policy_id from APP___NB__DBUSER.t_NB_CONTRACT_MASTER A 
 			WHERE 1 = 1  AND A.APPLY_CODE = '20180414100110' #{apply_code}
      



    
select * from     APP___NB__DBUSER.T_PRE_AUDIT_MASTER  a where a.apply_code = '22180207000001'

select * from dev_nb.t_udmp_user where user_id = '11111111'

--  初审主表
select a.* from APP___NB__DBUSER.T_PRE_AUDIT_MASTER a where a.apply_code = '22180313000003'

select t.* from APP___pas__DBUSER.t_customer t where t.customer_risk_level = 'A'

select t.* from dev_nb.t_customer t where t.customer_risk_level = 'A'


--  BPO  分配外包商 配置表
select * from dev_nb.t_bpo_org where org_type = '0';


-- 
select * from dev_nb.t_nb_contract_master a where a.apply_code = '20180302920002'
-- 投保人信息表
select * from dev_nb.t_nb_policy_holder a where a.apply_code = '03120180317022'

select * from dev_nb.t_address a where a.address_id = '79658'

select * from dev_nb.t_customer a where a.customer_id = '79730'

select * from APP___pas__DBUSER.t_policy_holder a where a.customer_id in ('77786','77834','77844');
 .apply_code = '03120180317022'
select t.* from APP___pas__DBUSER.t_customer t where t.mobile_tel = '15901230059'
-- 转保单表
select * from dev_nb.t_issue_transfer a where a.apply_code = '20182018040402';

in ('03120180317011','03120180317022','03120180317033');

03120180317011     03120180317022   03120180317033
select * from dev_nb.t_bankpolicyexc_log a where a.apply_code = 'EUA03090300000000250'

--  受益人信息表
select * from dev_nb.t_nb_contract_bene a where a.apply_code = 'EUA03090300000000250'
 

SELECT A.* FROM APP___NB__DBUSER.T_PRE_AUDIT_MASTER A where A.Apply_Code = '99998888777006';



--  下拉显示配置表
select * from dev_nb.t_udmp_code where table_name = 'APP___NB__DBUSER.T_CUSTOMER_RISK_LEVEL'
--  风险等级码表
select * from  APP___NB__DBUSER.T_CUSTOMER_RISK_LEVEL






-- T_ISSUE_CLASS-问题件分类表、
select * from dev_nb.T_ISSUE_CLASS;
-- T_ISSUE_SOURCE-问题件来源表
select * from dev_nb.T_ISSUE_SOURCE;
-- T_CUSTOMER_LEVEL-客户等级表
select * from dev_nb.T_CUSTOMER_LEVEL;
      
      
-- FTP  外包商路径配置信息表
select * from APP___NB__DBUSER.T_BPO_PATH_CFG

-- 投保单状态
select * from APP___NB__DBUSER.T_PROPOSAL_STATUS a where a.proposal_status = '14'  a.status_desc like '%%';
-- 操作履历投保单状态
select * from APP___NB__DBUSER.t_proposal_step  a where a.operating_desc  a.step_desc like '%待录入%'
open
select step_code,step_desc from APP___NB__DBUSER.t_proposal_step where rownum<2 order by step_code desc;
select step_code,step_desc from APP___NB__DBUSER.t_proposal_step  order by step_code desc;






--  客户信息表
select * from APP___NB__DBUSER.t_customer tc where tc.customer_id = '80121'
select * from APP___NB__DBUSER.t_customer tc where tc.customer_name = '李海'

select * from APP___NB__DBUSER.t_blacklist_customer d where d.customer_name = '李海'
  

select * from dev_nb.t_bpo_entry_detail a where a.apply_code in ('20180416111101','20180416111102','20180416111103','20180416111104')
select * from dev_nb.t_bpo_entry_detail a where a.bpo_id in ('78','79','80','101')



update app___nb__dbuser.t_bpo_entry_detail set is_valid = '0' where bpo_id in ('78','79','80','101')
--  投保单状态表
select * from APP___NB__DBUSER.T_PROPOSAL_STATUS a  where a.status_desc like '%%'
-- 投保单主表
select * from dev_nb.t_nb_contract_master  a where a.proposal_status = '13'

select * from APP___pas__DBUSER.t_Contract_Master 

82356

-- 操作员 用户信息表
select * from dev_nb.t_udmp_user a where a.real_name like '%SYS%'


-- 外包商 录入配置
select * from APP___NB__DBUSER.T_BPO_ENTRY_CONFIG where Billcard_Code = 'UN009'
--  机构
select * from APP___NB__DBUSER.T_BPO_ORG  a

BpoAction/findTaskDistLog

BpoTaskLogVO
-- 码表
select * from dev_nb.t_issue_sign ;
select * from dev_nb.t_receive_state;
select * from dev_nb.t_send_state;


--  银行账户信息
select * from dev_nb.T_BANK_ACCOUNT;
--  通知书状态表
select * from dev_nb.t_document_status a 
--  通知书定义表
select * from dev_nb.t_document_template  a where a.template_code = 'NBS_00007'
-- 通知书主表
select * from dev_nb.t_document a where a.buss_code = '33180308000001'


--  投保单主表
select * from dev_nb.T_NB_CONTRACT_MASTER where apply_code = '99998888777006'
-- BPO 录入明细表
select * from dev_nb.t_bpo_entry_detail a where a.apply_code = '20180313120002';
--  影像扫描  表
select * from dev_nb.t_image_scan a where a.buss_code = '22180308000003'
--  BPO 操作履历表
select * from APP___NB__DBUSER.T_BPO_TASK_LOG a order by a.insert_time;


select * from dev_nb.t_bpo_entry_detail a where a.apply_code = '22180313000001' order by a.insert_time desc;








--   查询黑名单用户
select case
         when (select case
                        when (select count(*)
                                from APP___UW__DBUSER.t_blacklist_review tc
                               where 1 = 1
                                 AND tc.CUSTOMER_ID = 80331) = 0 then
                         0
                        else
                         (select case
                                   when tc.status = '3' then
                                    0
                                   else
                                    1
                                 
                                 end flag
                            from APP___uw__DBUSER.t_blacklist_review tc
                           where 1 = 1
                             AND tc.CUSTOMER_ID = 80331)
                      
                      end flag
                 from dual) = 1 then
          1
         when exists (select 1
                 from APP___UW__DBUSER.t_blacklist_country c
                where c.country_code in
                      (select tc.country_code
                         from APP___UW__DBUSER.t_customer tc
                        where 1 = 1
                          AND tc.CUSTOMER_ID = 80331)
                  and c.blacklist_country_type is not null) then
          1
         when exists (select 1
                 from APP___UW__DBUSER.t_blacklist_company b
                where b.company_name in
                      (select tc.company_name
                         from APP___UW__DBUSER.t_customer tc
                        where 1 = 1
                          AND tc.CUSTOMER_ID = 80331)) then
          1
         when exists
          (select 1
                 from APP___UW__DBUSER.t_blacklist_customer d
                where (d.customer_name, d.customer_birthday, d.customer_gender,
                       d.customer_cert_type, d.customer_certi_code) in
                      (select tc.customer_name,
                              to_char(tc.customer_birthday, 'yyyy-MM-dd'),
                              tc.customer_gender,
                              tc.customer_cert_type,
                              tc.customer_certi_code
                         from APP___UW__DBUSER.t_customer tc
                        where 1 = 1
                          AND tc.CUSTOMER_ID = 80331)) then
          1
         else
          0
       end flag
  from dual;
  
select * from APP___NB__DBUSER.t_Customer a where a.customer_id = '80331'




select * from  APP___NB__DBUSER.T_PAY_MODE a where a.code in ('','','','','')


select * from APP___NB__DBUSER.T_BANK a where a.IS_BANK_DISK = '0' order by a.bank_code;
select * from APP___NB__DBUSER.T_BANK a where a.IS_BANK_DISK = '1' order by a.bank_code;

APP___NB__DBUSER.T_PAY_MODE

select * from dev_nb.T_PRE_AUDIT_MASTER a where a.bank_agent_code = ''

select * from dev_nb.t_nb_contract_master



 SELECT  A.LIST_ID,A.DATA_NAME,A.COPIES_NUM, A.DATA_CATEGORY, A.IS_VALID FROM APP___NB__DBUSER.T_INSURE_DOC_CFG   A 
 
 select * from APP___NB__DBUSER.T_INSURE_DOC_CFG 
ORDER BY A.LIST_ID       

insert into APP___NB__DBUSER.T_INSURE_DOC_CFG (LIST_ID, DATA_NAME, COPIES_NUM, DATA_CATEGORY, IS_VALID, INSERT_TIME, INSERT_TIMESTAMP, UPDATE_BY, UPDATE_TIME, UPDATE_TIMESTAMP)
values (1, '投保单', 1, '原件', 1, to_date('17-06-2015', 'dd-mm-yyyy'), to_date('17-06-2015 19:04:15', 'dd-mm-yyyy hh24:mi:ss'), 3242, to_date('17-06-2015', 'dd-mm-yyyy'), to_date('17-06-2015 19:04:15', 'dd-mm-yyyy hh24:mi:ss'));
-- 风险保额表
select * from dev_nb.t_ilog_rule_config;
-- 查询方式码表
select * from dev_nb.t_rule_cal_type;


select * from dev_nb.


select * from dev_nb.t_udmp_module a where a.module_name like '%保单打印%'
select * from dev_nb.t_udmp_module a where a.module_name like '%保单签收机构管理维护%'
select * from dev_nb.t_udmp_module a where a.module_name  = '保单签收机构申请';








select * from dev_nb.t_udmp_module a where a.module_name  in('保单打印','保单签收机构管理维护','保单签收机构申请');









queryall/queryall_psw@10.1.95.42:1521/uatpasdb


select * from APP___nb__DBUSER.t_Agent a where a.agent_code = '01249408'


15201626341

select * from dev_nb.t_nb_contract_master a where a.apply_code = '22180328000006'
