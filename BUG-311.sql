
/*********************************************************** 新核心 *******************************************************/
--AppBaseAmnt 首期客户投保金额
select SUM(INITIAL_AMOUNT) as amount from APP___PAS__DBUSER.T_CONTRACT_PRODUCT@BINGXING_168_15 A WHERE 1=1 AND A.POLICY_CODE='881218843908';

--BonusCount
SELECT COUNT(1) FROM APP___PAS__DBUSER.T_BONUS_ALLOCATE@BINGXING_168_15 A WHERE 1 = 1 AND A.BONUS_ALLOT in (1,2) AND A.POLICY_CODE='886727341381';
/*1 年度分红
2 基本保额特别年度红利
总记录数=年度分红次数取得+基本保额特别年度红利次数取得*/

--SumBaseSBonusAmnt 本保额特殊红利保额合计
SELECT SUM(NVL(BONUS_SA,0)) as BONUS_SA FROM APP___PAS__DBUSER.T_BONUS_ALLOCATE@BINGXING_168_15 A WHERE 1 = 1 AND A.BONUS_ALLOT in (6) AND A.POLICY_CODE='886727341381';
--累计红利保额特别年度红利 6

--SumBonusAmnt 年度累计红利保额合计
SELECT SUM(NVL(BONUS_SA,0)) as BONUS_SA FROM APP___PAS__DBUSER.T_BONUS_ALLOCATE@BINGXING_168_15 A WHERE 1 = 1 AND A.BONUS_ALLOT in (1) AND A.POLICY_CODE='881229544392';
--AND A.ALLOCATE_DATE BETWEEN to_date('','yyyy-MM-DD') AND to_date('','yyyy-MM-DD');
--年度红利 1

--SumSBonusAmnt 累计红利保额特殊红利保额合计
SELECT SUM(NVL(BONUS_SA,0)) as BONUS_SA FROM APP___PAS__DBUSER.T_BONUS_ALLOCATE@BINGXING_168_15 A WHERE 1 = 1 AND A.BONUS_ALLOT in (6) AND A.POLICY_CODE='881229544392';
--累计红利保额特别年度红利 6

--totalbonusinterest
select NVL(sum(REISSUE_INTEREST),0) as TotalBonusInterest from APP___PAS__DBUSER.t_bonus_allocate@BINGXING_168_15 A where 1=1;

--SBonusNo
SELECT COUNT(1) FROM APP___PAS__DBUSER.T_BONUS_ALLOCATE@BINGXING_168_15 A WHERE 1 = 1 AND A.BONUS_ALLOT in ('2') AND A.POLICY_CODE='881229544392';

--YBonusNo
SELECT COUNT(1) FROM APP___PAS__DBUSER.T_BONUS_ALLOCATE@BINGXING_168_15 A WHERE 1 = 1 AND A.BONUS_ALLOT in ('1') AND A.POLICY_CODE='881229544392';
/*********************************************************** 老核心 *******************************************************/
  select (select sum(BaseAmnt) from LOEngBonusPol where ContNo='881229544392'
         and FiscalYear in(select min(FiscalYear)from LOEngBonusPol where ContNo='881229544392')) 投保时初始保额  from dual;
  
  --SumBonusAmnt      
  select (select sum(b.BonusAmnt)from  LOEngBonusPol b where b.ContNo='881229544392' and b.BonusType='1') 年度累计红利保额  from dual;
  
  select (select sum(b.BonusAmnt)from LOEngBonusPol b where b.ContNo='881229544392'  and b.BonusType='2') 基本保额特殊红利保额合计  from dual;
  
  select (select sum(b.BonusAmnt)from LOEngBonusPol b where b.ContNo='881229544392'  and b.BonusType='3') 累计红利保额特殊红利保额合计  from dual;
  --YBonusNo
  select (select count(1)from LOEngBonusPol where ContNo='881229544392' and BonusType='1') 年度分红次数  from dual;
  --SBonusNo
  select (select count(1)from LOEngBonusPol where ContNo='881229544392' and BonusType='2') 特殊分红次数  from dual;
  
  select (select count(*)from LOEngBonusPol where ContNo='881229544392' and BonusType in('1','2')) 总记录数  from dual;
      
         
   select sum(Amnt) from lis.Lcduty where ContNo = '881218843908' and makedate in (select min(makedate) from lis.Lcduty
        where ContNo = '881218843908');
         
         

新核心查询
select SUM(amount),SUM(bonus_sa) from dev_pas.t_contract_product@BINGXING_168_15 a where  a.policy_code= '884266318068';  --基本保额和红利保额
select * from dev_pas.T_BONUS_ALLOCATE@BINGXING_168_15 t where t.policy_code='884266318068' --分红详细信息表
老核心查询
 select AMNT from lcpol a  where a.contno ='884266318068';  --基本保额
select sum(b.BonusAmnt)from  LOEngBonusPol b where b.ContNo='884266318068';--累计红利保额
select * from LOEngBonusPol where ContNo='884266318068'; --保单英式红利表（与新核心分红详细表一致）
