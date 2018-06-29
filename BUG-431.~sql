
/********************************************************** 新核心 **************************************************************/
  SELECT (SELECT POLICY_CODE
          FROM APP___PAS__DBUSER.T_CONTRACT_MASTER
         WHERE POLICY_ID = A.POLICY_ID) AS POLICY_CODE,
       (SELECT CUSTOMER_NAME
          FROM APP___PAS__DBUSER.T_CUSTOMER
         WHERE CUSTOMER_ID = (SELECT CUSTOMER_ID
                                FROM APP___PAS__DBUSER.T_INSURED_LIST
                               WHERE POLICY_ID = A.POLICY_ID
                                 AND ROWNUM = 1)) AS CUSTOMER_NAME,
       (SELECT CUSTOMER_NAME
          FROM APP___PAS__DBUSER.T_CUSTOMER
         WHERE CUSTOMER_ID = (SELECT CUSTOMER_ID
                                FROM APP___PAS__DBUSER.T_POLICY_HOLDER
                               WHERE POLICY_ID = A.POLICY_ID)) AS CUSTOMER_NAME1,
       A.CREATE_DATE AS CREATE_DATE,
       B.STATUS_DESC,
       A.INTEREST_CAPITAL AS INTEREST_CAPITAL,/*本息和 两位小数*/
       A.ACCOUNT_ID AS ACCOUNT_ID,
       (SELECT max（TRANS_TIME）
          FROM APP___PAS__DBUSER.T_POLICY_ACCOUNT_TRANS_LIST B
         WHERE ACCOUNT_ID = A.ACCOUNT_ID) AS TRANS_TIME,
       A.BALANCE_DATE AS BALANCE_DATE,
       (SELECT c.busi_prod_code
  FROM APP___PAS__DBUSER.t_contract_busi_prod c
 where c.master_busi_item_id is null
   and a.policy_id = c.policy_id)as busi_prod_code FROM
 APP___PAS__DBUSER.T_POLICY_ACCOUNT A,
 APP___PAS__DBUSER.T_POLICY_ACCOUNT_STATUS B
 WHERE A.ACCOUNT_TYPE = 11
   AND A.POLICY_ACCOUNT_STATUS = B.STATUS_CODE
   AND A.POLICY_ID = (SELECT POLICY_ID
                        FROM APP___PAS__DBUSER.T_CONTRACT_MASTER
                       WHERE POLICY_CODE = '')
                       
/********************************************************** 老核心 **************************************************************/                       
select trim(a.contno),'','',a.accfounddate,'','',trim(a.insuaccno),a.ModifyDate,a.baladate ,trim(a.polno) from lcinsureacc a where a.ContNo = ''

select insuredname,appntname from lccont where contno = ''

--查询账户状态
select distinct case when state = '0' and statetype = 'Frozen' and not exists  
(select '1' from LCInsureAccState  where contNo = '' and state = '1'  and statetype = 'Logout') then '正常' when state = '1' and statetype = 'Frozen' and not exists 
(select '1'   from  LCInsureAccState  where contNo = '' and state = '1'  and statetype = 'Logout') then  '冻结' 
when exists  (select '1'  from LCInsureAccState  where contNo = '' and state = '1'  and statetype = 'Logout')  then '注销'  end  from LCInsureAccState 
where contNo = '' and  enddate is null

--账户金额
select sum(insuaccbala + nvl((select sum(money)  from lcinsureacctrace   where contno = ''
and paydate > (case when exists  (select 'Y'  from lcinsureacctrace  where polno = ''
and insuaccno = ''
           and moneytype = 'LX') then date 'mResult[i][SEQ_BALADATE]' 
           else(to_date( 'mResult[i][SEQ_BALADATE]','yyyy-mm-dd') - 1) end)), 0))
            from Lcinsureacc where contno = ''
