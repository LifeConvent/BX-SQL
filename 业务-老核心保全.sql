select/*+PARALLEL(80)*/ m.contno,
       m.edoracceptno,
       m.getmoney
  from lis.lpedoritem m,
       lis.lcpol p,
       lis.lpedorapp a,
       (select s.endorsementno,
               s.contno,
               '000000' as polno,
               s.feeoperationtype,
               s.feefinatype,
              s.getconfirmdate  GetDate,
               sum(s.getmoney) as getmoney
          from lis.ljagetendorse s
         where exists (select 1
                  from lis.lccont t
                 where t.conttype = '1'
                   and t.appflag in ('1', '4')
                   and t.managecom like '8647%'
                   and t.contno = s.contno)
         group by s.endorsementno,
                  s.contno,
                  s.feeoperationtype,
                  s.getconfirmdate,
                  s.feefinatype) s1
where m.edorstate = '0'
   and p.polno(+) = m.polno
   and a.edoracceptno = m.edoracceptno
   and s1.endorsementno(+) = m.edorno
   and s1.contno(+) = m.contno
   and s1.polno(+) = m.polno
   and s1.feeoperationtype(+) = m.edortype
   and m.edorvalidate = date '2018-6-20'
   and exists (select 1
          from lis.lccont t
         where t.conttype = '1'
           and t.appflag in ('1', '4')
           and t.managecom like '8647%'
           and t.contno = m.contno)
  and m.polno='000000'
  union all
  select/*+PARALLEL(80)*/ m.contno, --保单号
       m.edoracceptno, --保全受理号
       m.getmoney --赔付金额（保全项目表）
  from lis.lpedoritem m,
       lis.lcpol p,
       lis.lpedorapp a,
       (select s.endorsementno,
               s.contno,
               s.polno,
               s.feeoperationtype,
               s.feefinatype,
              s.getconfirmdate  GetDate,
               sum(s.getmoney) as getmoney
          from lis.ljagetendorse s
         where exists (select 1
                  from lis.lccont t
                 where t.conttype = '1'
                   and t.appflag in ('1', '4')
                   and t.managecom like '8647%'
                   and t.contno = s.contno)
         group by s.endorsementno,
                  s.contno,
         s.polno,
                  s.feeoperationtype,
                  s.getconfirmdate,
                  s.feefinatype) s1
where m.edorstate = '0'
   and p.polno(+) = m.polno
   and a.edoracceptno = m.edoracceptno
   and s1.endorsementno(+) = m.edorno
   and s1.contno(+) = m.contno
   and s1.polno (+)= m.polno
   and s1.feeoperationtype(+) = m.edortype
   and m.edorvalidate = date '2018-6-20'
   and exists (select 1
          from lis.lccont t
         where t.conttype = '1'
           and t.appflag in ('1', '4')
        and t.managecom like '8647%'
           and t.contno = m.contno)
  and m.polno!='000000'
