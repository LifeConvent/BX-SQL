/*-----------------------------------------------------------------------------------------------------------------
//////////////////////////////////////////--�Ϻ���ָ��--/////////////////////////////////////////////////////
-----------------------------------------------------------------------------------------------------------------*/
--ͳ��
SELECT COUNT(DISTINCT A.EdorAcceptNo/*��ȫ�����*/) AS ��ȫ��Ч����
FROM LIS.LPEDORITEM A /*�Ϻ���.���ձ�ȫ��Ŀ��*/
WHERE TO_CHAR(A.EdorValiDate,'YYYYMMDD') = '20151231'
AND A.MANAGECOM LIKE '8647%'
AND A.CONTNO IN (
      SELECT CONTNO FROM LIS.LCCONT/*�Ϻ���.���˱�����*/ 
      WHERE CONTTYPE = '1' 
      AND APPFLAG IN ('1','4')
);
--��ϸ
SELECT L.VALIDATE_TIME ͳ������,MANAGECOM �������,EDORACCEPTNO �����,EdorType ��ȫ��
FROM LIS.LPEDORITEM /*�Ϻ���.���ձ�ȫ��Ŀ��*/
WHERE CONTNO/*��ͬ����*/ IN (
      SELECT CONTNO/*��ͬ����-������*/ FROM LIS.LCCONT/*�Ϻ���.���˱�����*/ 
      WHERE CONTTYPE/*�ܵ�����*/ = '1' 
      AND APPFLAG/*Ͷ����/������־*/ IN ('1','4')
)
AND MANAGECOM/*�����������*/ LIKE '8647%'
AND TO_CHAR(EDORVALIDATE/*������Ч����*/,'YYYYMMDD') = '20151231'
ORDER BY EDORACCEPTNO;
/*-----------------------------------------------------------------------------------------------------------------
//////////////////////////////////////////--�º���ָ��--/////////////////////////////////////////////////////
-----------------------------------------------------------------------------------------------------------------*/
--ͳ��
SELECT COUNT(DISTINCT L.ACCEPT_CODE) AS ��ȫ��Ч����
FROM T_CS_ACCEPT_CHANGE L
WHERE TO_CHAR(L.VALIDATE_TIME, 'YYYYMMDD') = '20151231' --��Ч����
AND L.ORGAN_CODE LIKE '8647%'; --����
--��ϸ
SELECT L.VALIDATE_TIME ͳ��ʱ��,L.ORGAN_CODE �������,L.ACCEPT_CODE �����,L.SERVICE_CODE ��ȫ��
FROM T_CS_ACCEPT_CHANGE L
WHERE TO_CHAR(L.VALIDATE_TIME, 'YYYYMMDD') = '20151231' --��Ч����
AND L.ORGAN_CODE LIKE '8647%' --����
ORDER BY L.ACCEPT_CODE;
