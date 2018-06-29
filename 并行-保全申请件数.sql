/*-----------------------------------------------------------------------------------------------------------------
//////////////////////////////////////////--�Ϻ���ָ��--/////////////////////////////////////////////////////
-----------------------------------------------------------------------------------------------------------------*/
--ͳ��
SELECT COUNT(DISTINCT A.EdorAppNo/*��ȫ�����*/) AS ��ȫ�������
FROM LIS.LPEDORITEM A /*�Ϻ���.���ձ�ȫ��Ŀ��*/
WHERE TO_CHAR(A.EdorAppDate,'YYYYMMDD') = '20151231'
AND A.MANAGECOM LIKE '8647%'
AND A.CONTNO IN (
      SELECT CONTNO FROM LIS.LCCONT/*�Ϻ���.���˱�����*/ 
      WHERE CONTTYPE = '1' 
      AND APPFLAG IN ('1','4')
);
--��ϸ
SELECT EdorAppDate ͳ������,MANAGECOM �������,EdorAppNo �����,EDORACCEPTNO �����,EdorType ��ȫ��
FROM LIS.LPEDORITEM /*�Ϻ���.���ձ�ȫ��Ŀ��*/
WHERE CONTNO/*��ͬ����*/ IN (
      SELECT CONTNO/*��ͬ����-������*/ FROM LIS.LCCONT/*�Ϻ���.���˱�����*/ 
      WHERE CONTTYPE/*�ܵ�����*/ = '1' 
      AND APPFLAG/*Ͷ����/������־*/ IN ('1','4')
)
AND MANAGECOM/*�����������*/ LIKE '8647%'
AND TO_CHAR(EdorAppDate/*������Ч����*/,'YYYYMMDD') = '20151231'
ORDER BY EdorAppNo;
/*-----------------------------------------------------------------------------------------------------------------
//////////////////////////////////////////--�º���ָ��--/////////////////////////////////////////////////////
-----------------------------------------------------------------------------------------------------------------*/
--ͳ��
SELECT COUNT(DISTINCT TCA.APPLY_CODE) AS ��ȫ�������
FROM APP___PAS__DBUSER.T_CS_ACCEPT_CHANGE TCAC 
LEFT JOIN APP___PAS__DBUSER.T_CS_APPLICATION/*��ȫ�����*/ TCA
     ON TCAC.CHANGE_ID = TCA.CHANGE_ID
WHERE TO_CHAR(TCA.APPLY_TIME, 'YYYYMMDD') = '20151231' --��Ч����
AND TCAC.ORGAN_CODE LIKE '8647%'; --����
--��ϸ
SELECT TCA.APPLY_TIME ͳ������,TCAC.ORGAN_CODE �������,TCA.APPLY_CODE �����,TCAC.ACCEPT_CODE �����,TCAC.SERVICE_CODE ��ȫ��
FROM APP___PAS__DBUSER.T_CS_ACCEPT_CHANGE TCAC 
LEFT JOIN APP___PAS__DBUSER.T_CS_APPLICATION/*��ȫ�����*/ TCA
     ON TCAC.CHANGE_ID = TCA.CHANGE_ID
WHERE TO_CHAR(TCA.APPLY_TIME, 'YYYYMMDD') = '20151231' --��Ч����
AND TCAC.ORGAN_CODE LIKE '8647%' --����
ORDER BY TCA.APPLY_CODE;
