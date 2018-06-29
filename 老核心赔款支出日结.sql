--老核心赔款支出日结
select distinct j.riskcode, sum(j.pay), j.opconfirmdate, j.managecom
  from ljagetclaim j
 where 1 = 1
   and substr(j.riskcode, 3, 3) in
       (select riskcode
          from lirisktype
         where risktype1 not in ('1', '3', '8'))
   and ((j.feefinatype = 'PK' and j.feeoperationtype = 'A') or
       (j.feefinatype = 'EF' and j.feeoperationtype = 'C05' and
       (exists (select p.polno
                    from llclaimpolicy p
                   where p.clmno = j.otherno
                     and p.polno = j.polno
                     and p.givetype = '0'))))
   and j.managecom like '86510005%'
   and j.opconfirmdate between date'2016-08-12' and date'2016-08-12'
   and exists (select 'X'
          from llregister
         where j.otherno = llregister.rgtno
           and llregister.rgtobj = '1')
 group by j.riskcode, j.opconfirmdate, j.managecom;
