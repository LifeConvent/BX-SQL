
/*********************************************************** �º��� *******************************************************/
--AppBaseAmnt ���ڿͻ�Ͷ�����
select SUM(INITIAL_AMOUNT) as amount from APP___PAS__DBUSER.T_CONTRACT_PRODUCT@BINGXING_168_15 A WHERE 1=1 AND A.POLICY_CODE='881218843908';

--BonusCount
SELECT COUNT(1) FROM APP___PAS__DBUSER.T_BONUS_ALLOCATE@BINGXING_168_15 A WHERE 1 = 1 AND A.BONUS_ALLOT in (1,2) AND A.POLICY_CODE='886727341381';
/*1 ��ȷֺ�
2 ���������ر���Ⱥ���
�ܼ�¼��=��ȷֺ����ȡ��+���������ر���Ⱥ�������ȡ��*/

--SumBaseSBonusAmnt �����������������ϼ�
SELECT SUM(NVL(BONUS_SA,0)) as BONUS_SA FROM APP___PAS__DBUSER.T_BONUS_ALLOCATE@BINGXING_168_15 A WHERE 1 = 1 AND A.BONUS_ALLOT in (6) AND A.POLICY_CODE='886727341381';
--�ۼƺ��������ر���Ⱥ��� 6

--SumBonusAmnt ����ۼƺ�������ϼ�
SELECT SUM(NVL(BONUS_SA,0)) as BONUS_SA FROM APP___PAS__DBUSER.T_BONUS_ALLOCATE@BINGXING_168_15 A WHERE 1 = 1 AND A.BONUS_ALLOT in (1) AND A.POLICY_CODE='881229544392';
--AND A.ALLOCATE_DATE BETWEEN to_date('','yyyy-MM-DD') AND to_date('','yyyy-MM-DD');
--��Ⱥ��� 1

--SumSBonusAmnt �ۼƺ������������������ϼ�
SELECT SUM(NVL(BONUS_SA,0)) as BONUS_SA FROM APP___PAS__DBUSER.T_BONUS_ALLOCATE@BINGXING_168_15 A WHERE 1 = 1 AND A.BONUS_ALLOT in (6) AND A.POLICY_CODE='881229544392';
--�ۼƺ��������ر���Ⱥ��� 6

--totalbonusinterest
select NVL(sum(REISSUE_INTEREST),0) as TotalBonusInterest from APP___PAS__DBUSER.t_bonus_allocate@BINGXING_168_15 A where 1=1;

--SBonusNo
SELECT COUNT(1) FROM APP___PAS__DBUSER.T_BONUS_ALLOCATE@BINGXING_168_15 A WHERE 1 = 1 AND A.BONUS_ALLOT in ('2') AND A.POLICY_CODE='881229544392';

--YBonusNo
SELECT COUNT(1) FROM APP___PAS__DBUSER.T_BONUS_ALLOCATE@BINGXING_168_15 A WHERE 1 = 1 AND A.BONUS_ALLOT in ('1') AND A.POLICY_CODE='881229544392';
/*********************************************************** �Ϻ��� *******************************************************/
  select (select sum(BaseAmnt) from LOEngBonusPol where ContNo='881229544392'
         and FiscalYear in(select min(FiscalYear)from LOEngBonusPol where ContNo='881229544392')) Ͷ��ʱ��ʼ����  from dual;
  
  --SumBonusAmnt      
  select (select sum(b.BonusAmnt)from  LOEngBonusPol b where b.ContNo='881229544392' and b.BonusType='1') ����ۼƺ�������  from dual;
  
  select (select sum(b.BonusAmnt)from LOEngBonusPol b where b.ContNo='881229544392'  and b.BonusType='2') �������������������ϼ�  from dual;
  
  select (select sum(b.BonusAmnt)from LOEngBonusPol b where b.ContNo='881229544392'  and b.BonusType='3') �ۼƺ������������������ϼ�  from dual;
  --YBonusNo
  select (select count(1)from LOEngBonusPol where ContNo='881229544392' and BonusType='1') ��ȷֺ����  from dual;
  --SBonusNo
  select (select count(1)from LOEngBonusPol where ContNo='881229544392' and BonusType='2') ����ֺ����  from dual;
  
  select (select count(*)from LOEngBonusPol where ContNo='881229544392' and BonusType in('1','2')) �ܼ�¼��  from dual;
      
         
   select sum(Amnt) from lis.Lcduty where ContNo = '881218843908' and makedate in (select min(makedate) from lis.Lcduty
        where ContNo = '881218843908');
         
         

�º��Ĳ�ѯ
select SUM(amount),SUM(bonus_sa) from dev_pas.t_contract_product@BINGXING_168_15 a where  a.policy_code= '884266318068';  --��������ͺ�������
select * from dev_pas.T_BONUS_ALLOCATE@BINGXING_168_15 t where t.policy_code='884266318068' --�ֺ���ϸ��Ϣ��
�Ϻ��Ĳ�ѯ
 select AMNT from lcpol a  where a.contno ='884266318068';  --��������
select sum(b.BonusAmnt)from  LOEngBonusPol b where b.ContNo='884266318068';--�ۼƺ�������
select * from LOEngBonusPol where ContNo='884266318068'; --����Ӣʽ�����������º��ķֺ���ϸ��һ�£�