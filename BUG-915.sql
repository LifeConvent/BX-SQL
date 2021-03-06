select d.job_code as occupationcode,
              trim(d.JOB_KIND) as occupationtype,
              (select j.job_uw_level from APP___PAS__DBUSER.t_Job_Code j where j.job_code = d.job_code) as occupationtype1,
              c.busi_item_id,
              c.old_pol_no,c.BUSI_PROD_CODE,
              (select pro.product_name_sys
                 from APP___PAS__DBUSER.T_business_product pro
                where pro.business_prd_id = c.busi_prd_id
                  and rownum = 1) as riskcodename,
              (select sum(cp.amount)
                    from APP___PAS__DBUSER.T_contract_product cp
                where exists (select 1
                         from APP___PAS__DBUSER.T_benefit_insured bi
                        where cp.busi_item_id = bi.busi_item_id
                          and bi.insured_id = i.list_id
                          and bi.policy_id = i.policy_id)
                  and cp.policy_id = i.policy_id and cp.busi_item_id = c.busi_item_id) as amnt,
              (select sum(cp.unit)
                 from APP___PAS__DBUSER.T_contract_product cp
                where cp.busi_item_id = c.busi_item_id  and cp.policy_id = i.policy_id ) as unit,
              (select sum(cp.total_prem_af)
                 from APP___PAS__DBUSER.T_contract_product cp
                where cp.busi_item_id = c.busi_item_id   and cp.policy_id = i.policy_id) as prem,
              (select sum(cp.STD_prem_af)
                    from APP___PAS__DBUSER.T_contract_product cp
                   where cp.busi_item_id = c.busi_item_id   and cp.policy_id = i.policy_id) as prem1,
              (select sum(cp.initial_extra_prem_af)
                 from APP___PAS__DBUSER.T_contract_product cp
                where cp.busi_item_id = c.busi_item_id   and cp.policy_id = i.policy_id) as occaddprem,
              (select l.counter_way
                 from 
                      APP___PAS__DBUSER.t_product_life l
                where c.busi_prd_id = l.business_prd_id
                  and rownum = 1) countway
         from APP___PAS__DBUSER.t_Benefit_Insured    a,
              APP___PAS__DBUSER.t_Insured_List       i,
              APP___PAS__DBUSER.t_Contract_Busi_Prod c,
              APP___PAS__DBUSER.T_CUSTOMER d
        where a.insured_id = i.list_id
          and a.busi_item_id = c.busi_item_id
          and i.policy_code ='885163520490' and d.customer_id=i.customer_id
         
   and i.customer_id  = ''


/*-----------------------------------------------------------------------------------------------------------------
//////////////////////////////////////////--�Ϻ���--/////////////////////////////////////////////////////
-----------------------------------------------------------------------------------------------------------------*/   
 Select distinct w.occupationcode ,
 (select trim(OccupationName) from LDOccupation where occupationcode=w.occupationcode),
    w.occupationtype,
    --(select trim(codename) from ldcode where codetype='occupationtype' and code=w.occupationtype),
     a.polno, 
      m.riskname, 
     (case when u.amntflag = 1 then a.amnt else a.mult end), 
      a.prem - nvl((Select  Sum(prem)  From lcprem c Where payplantype = '02' and c.ContNo = a.contno and c.polno = a.polno  ), 0), 
      nvl((Select  Sum(prem)  From lcprem c Where payplantype = '02' and c.ContNo = a.contno and c.polno = a.polno  ), 0) 
      From lcpol a Left Join lmrisk m  on m.riskcode = a.riskcode 
      left join lcduty b on b.polno = a.polno 
       left join lmduty u on trim(u.dutycode) = substr(b.dutycode, 1, 6) 
       left join lcinsured w  on  w.INSUREDNO=a.insuredno and w.contno = a.contno 
      Where a.ContNo ='885163520490' 
       and a.appflag in ('1','9') 
        
         and a.insuredno ='' 
