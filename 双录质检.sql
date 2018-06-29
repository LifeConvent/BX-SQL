select * from dev_nb.t_bank;
select * from dev_nb.t_bank_orgen_rel;

-- :双录质检险种配置表  -----------************
select * from APP___NB__DBUSER.T_DRQ_PRODUCT
select * from APP___NB__DBUSER.T_DRQ_PRODUCT;
concat(goods,'') 
select ('00'||product_code||'000') as hehe from APP___NB__DBUSER.T_DRQ_PRODUCT
-- 将 product_code 前后拼接 00productCode000
--update APP___NB__DBUSER.T_DRQ_PRODUCT set product_code = ('00'||product_code||'000');



-- 外包质检上传批处理查询 可执行的任务
SELECT DISTINCT A.BPO_COMP FROM DEV_NB.T_NB_QT_TASK A WHERE A.QA_TYPE = '6' AND A.BPO_COMP IS NOT NULL
-- 质检事后表
select * from dev_nb.T_NB_QT_TASK where bpo_comp is not null;

--双录质检险种配置表  product_type 险种类型：0-普通产品，1-分红产品，2-健康险产品
select * from APP___NB__DBUSER.T_DRQ_PRODUCT D
-- 投保单主表
select a.* from dev_nb.T_NB_CONTRACT_MASTER a where a.apply_code = '22180116000001' --drq_falg;

select * from dev_nb.T_NB_CONTRACT_MASTER a where a.apply_code in ('22180116000002','22180116000003')
-- 投保单状态码表
select * from dev_nb.t_proposal_status 

select * from dev_nb.t_nb_contract_master where organ_code like '8651%'  order by update_time desc;




SELECT A.PRODUCT_CODE, A.PRODUCT_NAME, A.IS_VALID, A.PRODUCT_TYPE FROM APP___NB__DBUSER.T_DRQ_PRODUCT A WHERE 1 = 1 
and a.product_code ='626'
AND A.IS_VALID = 1
-- 产品业务表
select * from dev_nb.t_business_product;

select * from dev_nb.t_proposal_step where step_code = '180';

update APP___NB__DBUSER.t_proposal_step set step_name = '' where step_code = '180'

select * from dev_nb.T_NB_CONTRACT_MASTER a where a.drq_flag ='';
--质检任务表
select * from dev_nb.t_nb_qt_task a where a.apply_code in ('22180131000001','22180116000003');
--记录双录质检影像回传信息
select * from  APP___NB__DBUSER.T_DRQ_CHECK_INFO

select * from dev_nb.t_nb_qt_batch
BPO_comp
--质检状态
select * from dev_nb.T_NB_QT_TASK_STATUS;

--质检任务配置表
select * from dev_nb.t_qa_config where qa_type = '6' for update;
-- 修改qa_type = '6'


--质检任务表(事后)
select * from dev_nb.t_nb_qt_task a where a.apply_code = ''

 docu_flag a.task_id = '1679631' for update;
-- 质检状态码表
select * from dev_nb.t_qt_status;
-- 质检不通过原因
select * from dev_nb.T_DRQ_N_RESULT where  ;
-- 记录双录质检不通过原因详细信息  码表
select * from dev_nb.t_drq_resion



select * from dev_nb.t_nb_qt_task a where a.docu_flag != 0 and a.qt_status = 1   apply_code = '20180130101030' for update;


select * from dev_nb.t_nb_qt_task a where a.apply_code = '20180130101030' for update;















SELECT A.BPO_COMP, A.QT_USER, A.ENTRY_TYPE, A.CREATE_TIME, A.TASK_ID, A.QT_TIME, A.QA_TYPE, A.APPLY_CODE, A.QT_RESULT, A.CHANNEL_TYPE, A.QT_COMMENTS, A.AGENT_LEVEL, A.POLICY_ID, A.QT_ERROR_COUNT, A.QT_HOLDER_INDI, A.QT_INSURED_INDI, A.QT_VERIFY_INDI, A.QT_TOOLTIP, A.QT_ELEMENT_TOTAL, A.BANK_BRANCH_CODE, A.card_code, A.QT_CRITERIA_ID, A.POLICY_CODE, A.BATCH_ID, A.BANK_CODE, A.QT_STATUS, A.RISK_DEFECT_INDI, A.ORGAN_CODE, A.CUSTOMER_LEVEL, A.FIELD_ERROR_RATE, A.BILL_ERROR_RATE FROM APP___NB__DBUSER.T_NB_QT_TASK A WHERE ROWNUM <= 1000 
AND A.QT_STATUS = ? AND A.DOCU_FLAG != ? ORDER BY A.TASK_ID


--记录双录质检影像回传信息
select * from APP___NB__DBUSER.T_DRQ_CHECK_INFO 

select * from dev_nb.t_nb_contract_master where apply_code = '20180130101030' for update; organ_code like '8651%'  order by update_time desc;
20180126012345
document_no  
 a.QA_type = '6'
select count(*) from dev_nb.t_nb_qt_task;

SELECT DISTINCT A.BPO_COMP FROM DEV_NB.T_NB_QT_TASK A WHERE A.QA_TYPE = '6'

SELECT * FROM (SELECT DISTINCT A.BPO_COMP FROM DEV_NB.T_NB_QT_TASK A WHERE A.QA_TYPE = '6') WHERE ROWNUM < 2000

select * from dev_nb.t_nb_qt_task where qa_type is null for update;
select * from dev_nb.t_nb_qt_task where qa_type is null for update;

select distinct bpo_comp from dev_nb.t_nb_qt_task where QA_type is null;





T_NB_CONTRACT_BUSI_PROD 解释:投保单险种信息表
T_NB_CONTRACT_PRODUCT 解释:保单责任层信息表

--投保单险种信息表
select * from dev_nb.T_NB_CONTRACT_BUSI_PROD;
--保单责任层信息表
select * from dev_nb.T_NB_CONTRACT_PRODUCT;
-- 解释:业务产品 
select * from dev_nb.T_BUSINESS_PRODUCT a where a.product_code_sys = '00417000'

       <RiskCode>00417000</RiskCode> product_code
      <!--险种八位代码-->
      <RiskName>惠添宝年金保险</RiskName> product_name_std;
      <!--险种全称-->
      <PayYears>1000</PayYears>prem_freq
      <!--交费方式-->
      <PayIntv>0</PayIntv>charge_year
      <!--交费期间-->
      <Years>20</Years>coverage_year;
      <!--保险期间-->
      <Prem>5000.0</Prem>total_prem_af
      <!--保险费(有可选责任的险种，保险费加和)-->
      
select a.product_name_std code from app___nb__dbuser.T_BUSINESS_PRODUCT a

select a.product_code,a.prem_freq,a.charge_year,a.coverage_year, a.total_prem_af 
from app___nb__dbuser.T_NB_CONTRACT_PRODUCT a;

select * from app___nb__dbuser.T_NB_CONTRACT_PRODUCT

contractProduct

select * from app___nb__dbuser.T_NB_CONTRACT_PRODUCT
(item_id, product_id, product_code, bonus_mode_code, apply_code, busi_item_id, policy_code, prod_pkg_plan_code, policy_id, amount, unit, count_way, benefit_level, validate_date, expiry_date, liability_state, charge_period, charge_year, coverage_period, coverage_year, pay_period, pay_year, prem_freq, decision_code, std_prem_af, extra_prem_af, total_prem_af, health_service_flag, insert_by, insert_time, insert_timestamp, update_by, update_time, update_timestamp, initial_discnt_prem_af, initial_extra_prem_af, is_gift, renewal_extra_prem_af, renewal_discnted_prem_af, paidup_date, interest_mode, deductible_franchise, payout_rate, additional_prem_af, append_prem_af, is_waived, waiver_start, waiver_end, master_item_id, master_product_code, master_product_id, pay_freq, annu_pay_type, pay_age, uw_complete_desc) in ((1000108673364, 379, '238000', null, '086510164900', 1000071403533, 'NJA10327011001335', null, 1000018789803, 10000.00, 0.00, '1', null, to_date('28-06-2006', 'dd-mm-yyyy'), to_date('28-06-2007', 'dd-mm-yyyy'), 0, '2', 1, 'Y', 1, '1', 0, 1, '10', 260.00, 0.00, 260.00, 0, 900010020, to_date('30-06-2006', 'dd-mm-yyyy'), to_date('30-06-2006 15:15:36', 'dd-mm-yyyy hh24:mi:ss'), 900010020, to_date('30-06-2006', 'dd-mm-yyyy'), to_date('30-06-2006 15:15:44', 'dd-mm-yyyy hh24:mi:ss'), 0.00, 0.00, null, 0.00, 0.00, to_date('28-06-2007', 'dd-mm-yyyy'), null, 0.00, 0.000000, 0.00, 0.00, 1, null, null, null, null, null, null, null, null, null))
where c.product_name_std is not null;

select distinct a.product_code from app___nb__dbuser.T_NB_CONTRACT_PRODUCT a
select distinct b.product_code from app___nb__dbuser.T_NB_CONTRACT_BUSI_PROD b where b.product_code in (select distinct a.product_code from app___nb__dbuser.T_NB_CONTRACT_PRODUCT a)
select * from 
select * from app___nb__dbuser.T_NB_CONTRACT_BUSI_PROD

select * from dev_nb.T_BUSINESS_PRODUCT a where a.product_code_sys = '00417000';
select * from dev_nb.T_NB_CONTRACT_PRODUCT;

select * from dev_nb.T_NB_CONTRACT_BUSI_PROD


select * from APP___NB__DBUSER.T_NB_CONTRACT_PRODUCT A 
select * from APP___NB__DBUSER.T_NB_CONTRACT_BUSI_PROD B
select * from APP___NB__DBUSER.T_BUSINESS_PRODUCT C


--解释:双录质检险种配置表
select * from dev_nb.T_DRQ_PRODUCT d where d.product_type;
select * from dev_nb.T_NB_CONTRACT_PRODUCT;
select * from APP___NB__DBUSER.T_BUSINESS_PRODUCT c where c.product_category = '10001'--主险 ;
select * from dev_nb.T_NB_CONTRACT_PRODUCT a 
left join dev_nb.T_DRQ_PRODUCT b on a.product_id = b.product_code
where b.product_code is not null
;



select * from APP___NB__DBUSER.T_DRQ_CHECK_INFO;
select * from dev_nb.T_DRQ_CHECK_INFO

销售渠道  channel_type == 03  为银行  投保单主表

select * from dev_nb.T_NB_CONTRACT_MASTER a where a.submit_channel = '1'



-- 查询可使用 抽取配置
select * from dev_nb.t_qa_config where QA_CFG_STATUS = 0 AND qa_type = '6' ;
-- 配置抽取比例
-- update dev_nb.t_qa_config set qa_type = '6' , rate = 1 where qa_cfg_id = '1719';
commit;
select * from dev_nb.t_qa_config a where a.qa_cfg_id = '1719' for update;
-- 外包商
select * from APP___NB__DBUSER.T_BPO_ORG where org_type = 0
1000000000026 信雅达
66180206000001
select * from dev_nb.t_nb_contract_master a where a.apply_code = '22180131000003'  and a.drq_flag = 1 ;


select * from dev_nb.T_DRQ_CHECK_INFO ;


select * from dev_nb.t_nb_qt_task a where a.apply_code =  '66180206000002' and a.qt_status = 1 and a.docu_flag = 0 ;
select * from dev_nb.t_nb_qt_task a where a.apply_code =  '66180206000002' for update;
SELECT to_char(USER_ID) AS TABLE_COL ,AGENT_NAME AS VALUE FROM APP___NB__DBUSER.T_UDMP_USER 
select * from APP___NB__DBUSER.T_UDMP_USER 
 for update;










 organ_code like '8651%'  order by update_time desc;
 
 

select * from  APP___NB__DBUSER.T_PRE_AUDIT_MASTER a where 



--  双录质检资料上传联调

SELECT DISTINCT A.BPO_COMP FROM DEV_NB.T_NB_QT_TASK A WHERE A.QA_TYPE = '6' AND A.BPO_COMP IS NOT NULL

select * from DEV_NB.T_NB_QT_TASK a where a.apply_code = '66180206000002'  for update;

-- 质检状态码表
select * from dev_nb.t_qt_status;
select * from DEV_NB.T_NB_QT_TASK a where a.bpo_comp = '1000000000026' and a.qa_type = '6' and a.qt_status = '1'
select * from DEV_NB.T_NB_QT_TASK a where a.apply_code = '66180206000002' 


SELECT DISTINCT A.BPO_COMP FROM DEV_NB.T_NB_QT_TASK A WHERE A.Apply_Code = '66180206000002' A.QA_TYPE = '6' AND A.BPO_COMP IS NOT NULL

select a.* from dev_nb.T_NB_CONTRACT_MASTER a where a.apply_code = '66180206000002' for update;


SELECT A.BPO_COMP,
       A.QT_USER,
       A.ENTRY_TYPE,
       A.CREATE_TIME,
       A.TASK_ID,
       A.QT_TIME,
       A.QA_TYPE,
       A.APPLY_CODE,     
       A.QT_RESULT,
      A.CHANNEL_TYPE,
       A.QT_COMMENTS,
       A.AGENT_LEVEL,
       A.POLICY_ID,
       A.QT_ERROR_COUNT,
       A.QT_HOLDER_INDI,
       A.QT_INSURED_INDI,
       A.QT_VERIFY_INDI,   
       A.QT_TOOLTIP,
       A.QT_ELEMENT_TOTAL,
       A.BANK_BRANCH_CODE, 
       A.card_code,
       A.QT_CRITERIA_ID,
       A.POLICY_CODE,
       A.BATCH_ID,
       A.BANK_CODE,
       A.QT_STATUS,
       A.RISK_DEFECT_INDI,
       A.ORGAN_CODE,
       A.CUSTOMER_LEVEL,
       A.FIELD_ERROR_RATE,
       A.BILL_ERROR_RATE
  FROM APP___NB__DBUSER.T_NB_QT_TASK A  WHERE ROWNUM <=  1000  ]]>
    <!-- <include refid="请添加查询条件" /> -->
    <if test=" qa_type  != null "><![CDATA[ AND A.QA_TYPE = #{qa_type} ]]></if>
    <if test=" qt_status  != null "><![CDATA[ AND A.QT_STATUS = #{qt_status} ]]></if>
    <if test=" qt_result  != null "><![CDATA[ AND A.QT_RESULT != #{qt_result} ]]></if>
    <if test=" docu_flag  != null "><![CDATA[ AND A.DOCU_FLAG = #{docu_flag} ]]></if>
    <![CDATA[ ORDER BY A.TASK_ID      ]]> 
    
    





SELECT A.ITEM_ID,
       A.PRODUCT_ID,
       A.BONUS_MODE_CODE,
       A.APPLY_CODE,
       A.BUSI_ITEM_ID,
       A.POLICY_CODE,
       A.PROD_PKG_PLAN_CODE,
       A.POLICY_ID,
       A.AMOUNT,
       A.UNIT,
       A.COUNT_WAY,
       A.BENEFIT_LEVEL,
       A.VALIDATE_DATE,
       A.EXPIRY_DATE,
       A.LIABILITY_STATE,
       A.CHARGE_PERIOD,
       A.CHARGE_YEAR,
       A.COVERAGE_PERIOD,
       A.COVERAGE_YEAR,
       A.PAY_PERIOD,
       A.PAY_YEAR,
       A.PREM_FREQ,
       A.DECISION_CODE,
       A.STD_PREM_AF,
       A.EXTRA_PREM_AF,
       A.TOTAL_PREM_AF,
       A.HEALTH_SERVICE_FLAG,
       A.INSERT_BY,
       A.INSERT_TIME,
       A.INSERT_TIMESTAMP,
       A.UPDATE_BY,
       A.UPDATE_TIME,
       A.UPDATE_TIMESTAMP,
       A.INITIAL_DISCNT_PREM_AF,
       A.INITIAL_EXTRA_PREM_AF,
       A.IS_GIFT,
       A.RENEWAL_EXTRA_PREM_AF,
       A.RENEWAL_DISCNTED_PREM_AF,
       A.PAIDUP_DATE,
       A.INTEREST_MODE,
       A.DEDUCTIBLE_FRANCHISE,
       A.PAYOUT_RATE,
       A.ADDITIONAL_PREM_AF,
       A.APPEND_PREM_AF,
       A.IS_WAIVED,
       A.WAIVER_START,
       A.WAIVER_END,
       A.MASTER_ITEM_ID,
       A.MASTER_PRODUCT_CODE,
       A.MASTER_PRODUCT_ID,
       A.PAY_FREQ,
       A.ANNU_PAY_TYPE,
       A.PAY_AGE,
       A.UW_COMPLETE_DESC,
       B.PRODUCT_CODE,
       C.PRODUCT_NAME_STD ,
       C.Product_Category,
       D.Product_Type
  FROM APP___NB__DBUSER.T_NB_CONTRACT_PRODUCT A
  LEFT JOIN APP___NB__DBUSER.T_NB_CONTRACT_BUSI_PROD B  ON A.APPLY_CODE = B.APPLY_CODE and A.BUSI_ITEM_ID = B.BUSI_ITEM_ID
  LEFT JOIN APP___NB__DBUSER.T_BUSINESS_PRODUCT C ON B.PRODUCT_CODE = C.PRODUCT_CODE_SYS 
  left join APP___NB__DBUSER.T_DRQ_PRODUCT D on C.Product_Code_Sys = D.Product_Code
 WHERE 1 = 1
 
 and A.Apply_Code = '66180206000002'
   
select * FROM APP___NB__DBUSER.T_NB_CONTRACT_PRODUCT A where A.Apply_Code = '66180206000002';
select * FROM APP___NB__DBUSER.T_NB_CONTRACT_BUSI_PROD B where B.Apply_Code = '66180206000002';
select * FROM APP___NB__DBUSER.T_BUSINESS_PRODUCT C where C.Product_Code_Sys in ('00411000','00534000');


select a.service_bank from dev_nb.T_NB_CONTRACT_MASTER a where a.apply_code = '66180206000002' --drq_falg;

select * from DEV_NB.T_NB_QT_TASK a where a.apply_code = '22180208000001' 

1
00280207000001
1
02300000000005


select * from dev_nb.t_nb_contract_master a where a.apply_code in ('00280207000001','02300000000005');
select * from dev_nb.t_nb_contract_master a where a.organ_code = '86210001'. apply_code in ('00280207000001','02300000000005');
select * from dev_nb.T_DRQ_CHECK_INFO ;
select * from DEV_NB.T_NB_QT_TASK a where a.apply_code = '22180208000001' 



        
        
SELECT DISTINCT A.BPO_COMP FROM DEV_NB.T_NB_QT_TASK A WHERE A.QA_TYPE = '6' AND A.BPO_COMP IS NOT NULL

select * from DEV_NB.T_NB_QT_TASK a where a.apply_code = '22180208000001' for update;

select * from dev_nb.t_nb_contract_master a where a.apply_code = '00280207000001' for update;

select * from dev_nb.t_Udmp_User where real_name like 'SYS%'






-- 1 录双录质检保单 业务员要用 银行代理的  agent_channel = 03
select * from APP___NB__DBUSER.T_DRQ_PRODUCT;

-- 2 配置抽取比例
select * from dev_nb.t_qa_config where QA_CFG_STATUS = 0 AND qa_type = '6' ;
-- update dev_nb.t_qa_config set qa_type = '6' , rate = 1 ,bpo_comp = '1000000000026' where qa_cfg_id = '1719';
commit;

-- 3 执行  双录质检  批处理  需往10.1.96.71  /nb/ncivcs/upload 放ncivcs-2018-01-31-160002.txt文件
select * from dev_nb.T_DRQ_CHECK_INFO ;

-- 4 执行  双录质检任务抽取  批处理
select * from DEV_NB.T_NB_QT_TASK a where a.apply_code in ( '22180208000001','22180208000002')
--  码表
select * from dev_nb.t_qt_status;
-- 5 执行  外包质检资料上传 批处理  将qt_status 0 改为 3
select * from DEV_NB.T_NB_QT_TASK a where a.apply_code in ( '22180208000001','22180208000002')

      
      
select * from  APP___NB__DBUSER.T_PRE_AUDIT_MASTER where audit_organ_code = '86'
