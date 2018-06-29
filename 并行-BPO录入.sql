SELECT * FROM APP___NB__DBUSER.T_BPO_ENTRY_DETAIL; --BPO¼����ϸ APPLY_CODE POLICY_ID SEND_DATE SEND_STATE RECEIVE_DATE
SELECT * FROM APP___NB__DBUSER.T_ISSUE_LIST; --������б�
SELECT * FROM APP___NB__DBUSER.T_ISSUE_STATUS; --�ط����������״̬�� ���
SELECT * FROM APP___NB__DBUSER.T_ISSUE_CLASS; --���������� ���
SELECT * FROM APP___NB__DBUSER.T_ISSUE_SOURCE; --�������Դ�� ���
SELECT * FROM APP___NB__DBUSER.T_SEND_STATE; --����״̬ ���
SELECT * FROM APP___NB__DBUSER.T_RECEIVE_STATE; --����״̬ ���
SELECT * FROM APP___NB__DBUSER.T_OPER_ISSUE; --����Ա�������� ���



/*************************************  �º�����BPO¼����ϸ  **************************************/
SELECT TCM.POLICY_CODE ������,
       TBED.APPLY_CODE Ͷ������,
       A.PROCESS_STEP �Ժ˽���,
       (CASE A.PROCESS_STEP WHEN '17' THEN 'ͨ��' WHEN '18' THEN '��ͨ��' ELSE '����' END) �Ժ�״̬,
       (CASE TBED.SEND_STATE WHEN '0' THEN 'ʧ��' WHEN '1' THEN '�ɹ�' ELSE '����' END) ����״̬,
       (CASE TBED.RECEIVE_STATE WHEN '3' THEN 'ʧ��' WHEN '2' THEN '�ɹ�' ELSE '����' END) ����״̬,
       (CASE TIL.ISSUE_SOURCE WHEN '07' THEN '��' ELSE '��' END) �Ƿ������
       --TIL.ISSUE_STATE �����״̬
       FROM APP___NB__DBUSER.T_BPO_ENTRY_DETAIL TBED
            LEFT JOIN APP___NB__DBUSER.T_ISSUE_LIST TIL
            ON TIL.APPLY_CODE = TBED.APPLY_CODE
            LEFT JOIN APP___NB__DBUSER.T_PROPOSAL_PROCESS A
            ON A.POLICY_ID = TBED.POLICY_ID
            LEFT JOIN DEV_PAS.T_CONTRACT_MASTER TCM
            ON A.POLICY_ID = TCM.POLICY_ID
       WHERE 1 = 1
       AND ((TBED.SEND_STATE = '1' AND TBED.SEND_DATE = DATE '2017-12-12')--���ͳɹ�����
        OR (TBED.RECEIVE_DATE = '1' AND TBED.RECEIVE_DATE = DATE '2017-12-12'))--���ճɹ�����
       AND TIL.ISSUE_ORGAN LIKE '8647%' --��������ڻ���
       AND TBED.ORGAN_CODE LIKE '8647%'
ORDER BY TCM.POLICY_CODE;


/*************************************  �º�����BPO¼��ͳ��  **************************************/    
SELECT 
       (CASE WHEN ROWNUM = 1 THEN 
             (SELECT COUNT(TBED.POLICY_ID)  
                 FROM APP___NB__DBUSER.T_BPO_ENTRY_DETAIL TBED
                 WHERE 1 = 1
                 AND TBED.SEND_STATE = '1' --���ͳɹ�
                 AND TBED.ORGAN_CODE LIKE '8647%' --����
                 AND TBED.SEND_DATE = DATE '2017-12-12') --��������
        END) ���¼�����,
       (CASE WHEN ROWNUM = 1 THEN 
             (SELECT COUNT(TBED.POLICY_ID) 
                 FROM APP___NB__DBUSER.T_BPO_ENTRY_DETAIL TBED
                 WHERE 1 = 1
                 AND TBED.RECEIVE_STATE = '2' --���ճɹ�
                 AND TBED.ORGAN_CODE LIKE '8647%' --����
                 AND TBED.RECEIVE_DATE = DATE '2017-12-12') --��������
        END) ����ش�����,
       (CASE WHEN ROWNUM = 1 THEN 
             (SELECT COUNT(TBED.POLICY_ID) 
                 FROM APP___NB__DBUSER.T_BPO_ENTRY_DETAIL TBED
                      LEFT JOIN APP___NB__DBUSER.T_ISSUE_LIST TIL
                      ON TIL.APPLY_CODE = TBED.APPLY_CODE
                 WHERE 1 = 1
                 AND TIL.ISSUE_SOURCE = '07' --BPO�����
                 AND TIL.ISSUE_ORGAN LIKE '8647%' --��������ڻ���
                 AND TBED.ORGAN_CODE LIKE '8647%' --�����������
                 AND TIL.INPUT_DATE = DATE '2017-12-12') --��������
        END) ���������,
       (CASE WHEN ROWNUM = 1 THEN 
             (SELECT COUNT(TBED.POLICY_ID)
                 FROM APP___NB__DBUSER.T_BPO_ENTRY_DETAIL TBED
                 LEFT JOIN APP___NB__DBUSER.T_PROPOSAL_PROCESS A
                 ON A.POLICY_ID = TBED.POLICY_ID
                 WHERE 1 = 1
                 AND A.PROCESS_STEP = '17' --�Ժ�ͨ��
                 --AND TBED.SEND_STATE = '1' --���ͳɹ�
                 AND TBED.ORGAN_CODE LIKE '8647%' --����
                 AND TBED.SEND_DATE = DATE '2017-12-12') --��������
        END) �Ժ�ͨ������,
       (CASE WHEN ROWNUM = 1 THEN 
             (SELECT COUNT(TBED.POLICY_ID)
                 FROM APP___NB__DBUSER.T_BPO_ENTRY_DETAIL TBED
                 LEFT JOIN APP___NB__DBUSER.T_PROPOSAL_PROCESS A
                 ON A.POLICY_ID = TBED.POLICY_ID
                 WHERE 1 = 1
                 AND A.PROCESS_STEP = '18' --�Ժ˲�ͨ��
                 --AND TBED.SEND_STATE = '1' --���ͳɹ�
                 AND TBED.ORGAN_CODE LIKE '8647%' --����
                 AND TBED.SEND_DATE = DATE '2017-12-12') --��������
        END) �Ժ˲�ͨ������
       FROM APP___NB__DBUSER.T_BPO_ENTRY_DETAIL TBED
WHERE ROWNUM = 1;  

/*
SELECT COUNT(TBED.POLICY_ID) ���¼����� 
       FROM APP___NB__DBUSER.T_BPO_ENTRY_DETAIL TBED
       WHERE 1 = 1
       AND TBED.SEND_STATE = '1' --���ͳɹ�
       AND TBED.ORGAN_CODE LIKE '8647%' --����
       AND TBED.SEND_DATE = DATE '2017-12-12'; --��������
       
SELECT COUNT(TBED.POLICY_ID) ����ش����� 
       FROM APP___NB__DBUSER.T_BPO_ENTRY_DETAIL TBED
       WHERE 1 = 1
       AND TBED.RECEIVE_STATE = '2' --���ճɹ�
       AND TBED.ORGAN_CODE LIKE '8647%' --����
       AND TBED.RECEIVE_DATE = DATE '2017-12-12'; --��������
       
SELECT COUNT(TBED.POLICY_ID) ��������� 
       FROM APP___NB__DBUSER.T_BPO_ENTRY_DETAIL TBED
            LEFT JOIN APP___NB__DBUSER.T_ISSUE_LIST TIL
            ON TIL.APPLY_CODE = TBED.APPLY_CODE
       WHERE 1 = 1
       AND TIL.ISSUE_SOURCE = '07' --BPO�����
       AND TIL.ISSUE_ORGAN LIKE '8647%' --��������ڻ���
       AND TBED.ORGAN_CODE LIKE '8647%' --�����������
       AND TIL.INPUT_DATE = DATE '2017-12-12'; --��������

SELECT COUNT(TBED.POLICY_ID) �Ժ�ͨ������ 
       FROM APP___NB__DBUSER.T_BPO_ENTRY_DETAIL TBED
       LEFT JOIN APP___NB__DBUSER.T_PROPOSAL_PROCESS A
       ON A.POLICY_ID = TBED.POLICY_ID
       WHERE 1 = 1
       AND A.PROCESS_STEP = '17' --�Ժ�ͨ��
       --AND TBED.SEND_STATE = '1' --���ͳɹ�
       AND TBED.ORGAN_CODE LIKE '8647%' --����
       AND TBED.SEND_DATE = DATE '2017-12-12'; --��������
       
SELECT COUNT(TBED.POLICY_ID) �Ժ˲�ͨ������
       FROM APP___NB__DBUSER.T_BPO_ENTRY_DETAIL TBED
       LEFT JOIN APP___NB__DBUSER.T_PROPOSAL_PROCESS A
       ON A.POLICY_ID = TBED.POLICY_ID
       WHERE 1 = 1
       AND A.PROCESS_STEP = '18' --�Ժ˲�ͨ��
       --AND TBED.SEND_STATE = '1' --���ͳɹ�
       AND TBED.ORGAN_CODE LIKE '8647%' --����
       AND TBED.SEND_DATE = DATE '2017-12-12'; --��������
 */ 

SELECT * FROM LIS.LCUWSUB --���˺�ͬ�˱��켣�� PASSFLAG AUTOUWFLAG
SELECT * FROM LIS.LCPOL --���ֱ� UWFLAG UWDATE 
SELECT * FROM LIS.LOPRTMANAGER --��ӡ����� CODE-��ӡ����
SELECT * FROM LIS.LCOUTSOURCECONTPRINT --�����ӡ������
SELECT * FROM LIS.LCISSUEPOL --�������
SELECT * 
       FROM LIS.LCCONT A
       WHERE 1 = 1
       AND A.SIGNDATE = DATE '2015-12-31' --ǩ������
       AND A.SIGNCOM LIKE '9647%' --ǩ������

/*************************************  �Ϻ���BPO¼����ϸ  **************************************/ 
SELECT T.CONTNO ������,
       T.PROPOSALNO Ͷ������,
       T.STATE �Ժ˽���,
       (CASE T.STATE WHEN '9' THEN 'ͨ��' WHEN '5' THEN '��ͨ��' ELSE '����' END) �Ժ�״̬,
       (CASE WHEN TO_CHAR(BPO.SENDOUTDATE,'YYYY-MM-DD') IS NOT NULL THEN '�ɹ�' ELSE 'ʧ��' END) ����״̬,
       (CASE WHEN TO_CHAR(BPO.RECEIVEDATE,'YYYY-MM-DD') IS NOT NULL THEN '�ɹ�' ELSE 'ʧ��' END) ����״̬,
       (CASE ISS.BACKOBJ WHEN 'BPO' THEN '��' ELSE '��' END) �Ƿ������
     FROM LIS.LCUWSUB T
     LEFT JOIN LIS.LCPOL T1
      ON T.POLNO = T1.POLNO --������
      AND T.PROPOSALNO = T1.PROPOSALNO --Ͷ������
     LEFT JOIN LIS.BPOMISSIONSTATE BPO
      ON T.PROPOSALNO = BPO.BUSSNO --Ͷ������
      AND BPO.BUSSNOTYPE = 'TB' --����Լ
     LEFT JOIN LIS.LCISSUEPOL ISS
      ON T.PROPOSALNO = ISS.CONTNO --Ͷ������
     WHERE 1 = 1
     AND T.AUTOUWFLAG = '1' --�Ժ�
     AND T.UWNO = '1'
     AND T.MAKEDATE = DATE '2015-12-31' --���ʱ��
     AND EXISTS (SELECT 1
                  FROM LIS.LCCONT A
                 WHERE T.CONTNO = A.CONTNO
                   AND A.CONTTYPE = '1'
                   AND A.APPFLAG = '1') -- 1-�б�
     AND T.MANAGECOM LIKE '8647%' --����
ORDER BY T.CONTNO


/*************************************  �Ϻ���BPOͳ��  **************************************/ 
SELECT 
       (CASE WHEN ROWNUM = 1 THEN 
             (SELECT COUNT(DISTINCT BPO.BUSSNO) ���¼����� 
                FROM LIS.BPOMISSIONSTATE BPO
                LEFT JOIN LIS.LCISSUEPOL ISS
                ON BPO.BUSSNO = ISS.CONTNO --Ͷ������
                WHERE 1 = 1
                  AND BPO.BUSSNOTYPE = 'TB' --����Լ
                  AND BPO.MANAGECOM LIKE '8647%' --����
                  AND BPO.SENDOUTDATE = DATE '2015-12-31' --��������
             )
        END) ���¼�����,
       (CASE WHEN ROWNUM = 1 THEN 
             (SELECT COUNT(DISTINCT BPO.BUSSNO) ����ش����� 
                FROM LIS.BPOMISSIONSTATE BPO
                LEFT JOIN LIS.LCISSUEPOL ISS
                ON BPO.BUSSNO = ISS.CONTNO --Ͷ������
                WHERE 1 = 1
                  AND BPO.BUSSNOTYPE = 'TB' --����Լ
                  AND BPO.MANAGECOM LIKE '8647%' --����
                  AND BPO.RECEIVEDATE = DATE '2015-12-31' --��������
             )
        END) ����ش�����,
       (CASE WHEN ROWNUM = 1 THEN 
             (SELECT COUNT(DISTINCT BPO.BUSSNO)
                FROM LIS.BPOMISSIONSTATE BPO
                LEFT JOIN LIS.LCISSUEPOL ISS
                ON BPO.BUSSNO = ISS.CONTNO --Ͷ������
                WHERE 1 = 1
                  AND BPO.BUSSNOTYPE = 'TB' --����Լ
                  AND BPO.MANAGECOM LIKE '8647%' --����
                  AND BPO.RECEIVEDATE = DATE '2015-12-31' --��������    
                  AND ISS.BACKOBJ = 'BPO' --BPO�����
             )
        END) ���������,
       (CASE WHEN ROWNUM = 1 THEN 
             (SELECT COUNT(DISTINCT T.CONTNO)
                   FROM LIS.LCUWSUB T
                   LEFT JOIN LIS.LCPOL T1
                    ON T.POLNO = T1.POLNO --������
                    AND T.PROPOSALNO = T1.PROPOSALNO --Ͷ������
                   WHERE 1 = 1
                   AND T.AUTOUWFLAG = '1' --�Ժ�
                   AND T.STATE = '9' --9 - ��׼�б�
                   AND T.UWNO = '1'
                   AND EXISTS (SELECT 1
                                FROM LIS.LCCONT A
                               WHERE T.CONTNO = A.CONTNO
                                 AND A.CONTTYPE = '1'
                                 AND A.APPFLAG = '1') -- 1-�б�
                   AND T.MAKEDATE = DATE '2015-12-31' --�������
                   AND T.MANAGECOM LIKE '8647%' --����
             )
        END) �Ժ�ͨ������,
       (CASE WHEN ROWNUM = 1 THEN 
             (SELECT COUNT(DISTINCT T.CONTNO)
                 FROM LIS.LCUWSUB T
                 LEFT JOIN LIS.LCPOL T1
                  ON T.POLNO = T1.POLNO --������
                  AND T.PROPOSALNO = T1.PROPOSALNO --Ͷ������
                 WHERE 1 = 1
                 AND T.AUTOUWFLAG = '1' --�Ժ�
                 AND T.STATE = '5' --5 - δͨ���Զ��˱�
                 AND T.UWNO = '1'
                 AND EXISTS (SELECT 1
                              FROM LIS.LCCONT A
                             WHERE T.CONTNO = A.CONTNO
                               AND A.CONTTYPE = '1'
                               AND A.APPFLAG = '1') -- 1-�б�
                 AND T.MAKEDATE = DATE '2015-12-31' --���ʱ��
                 AND T.MANAGECOM LIKE '8647%') --����
        END) �Ժ˲�ͨ������
       FROM LIS.LCPOL
WHERE ROWNUM = 1;  

SELECT COUNT(DISTINCT T.CONTNO) AS �Ժ�δͨ������
     FROM LIS.LCUWSUB T
     LEFT JOIN LIS.LCPOL T1
      ON T.POLNO = T1.POLNO --������
      AND T.PROPOSALNO = T1.PROPOSALNO --Ͷ������
     WHERE 1 = 1
     AND T.AUTOUWFLAG = '1' --�Ժ�
     AND T.STATE = '5' --5 - δͨ���Զ��˱�
     AND T.UWNO = '1'
     AND EXISTS (SELECT 1
                  FROM LIS.LCCONT A
                 WHERE T.CONTNO = A.CONTNO
                   AND A.CONTTYPE = '1'
                   AND A.APPFLAG = '1') -- 1-�б�
     AND T.MAKEDATE = DATE '2015-12-31' --���ʱ��
     AND T.MANAGECOM LIKE '8647%' --����
     
SELECT COUNT(DISTINCT T.CONTNO) AS �Ժ�ͨ������
     FROM LIS.LCUWSUB T
     LEFT JOIN LIS.LCPOL T1
      ON T.POLNO = T1.POLNO --������
      AND T.PROPOSALNO = T1.PROPOSALNO --Ͷ������
     WHERE 1 = 1
     AND T.AUTOUWFLAG = '1' --�Ժ�
     AND T.STATE = '9' --9 - ��׼�б�
     AND T.UWNO = '1'
     AND EXISTS (SELECT 1
                  FROM LIS.LCCONT A
                 WHERE T.CONTNO = A.CONTNO
                   AND A.CONTTYPE = '1'
                   AND A.APPFLAG = '1') -- 1-�б�
     AND T.MAKEDATE = DATE '2015-12-31' --�������
     AND T.MANAGECOM LIKE '8647%' --����

--STATE ��ֵ ���ͽ��ճɹ�

SELECT COUNT(DISTINCT BPO.BUSSNO) ���¼����� 
  FROM LIS.BPOMISSIONSTATE BPO
  LEFT JOIN LIS.LCISSUEPOL ISS
  ON BPO.BUSSNO = ISS.CONTNO --Ͷ������
  WHERE 1 = 1
    AND BPO.BUSSNOTYPE = 'TB' --����Լ
    AND BPO.MANAGECOM LIKE '8647%' --����
    AND BPO.SENDOUTDATE = DATE '2015-12-31' --��������
    
SELECT COUNT(DISTINCT BPO.BUSSNO) ����ش����� 
  FROM LIS.BPOMISSIONSTATE BPO
  LEFT JOIN LIS.LCISSUEPOL ISS
  ON BPO.BUSSNO = ISS.CONTNO --Ͷ������
  WHERE 1 = 1
    AND BPO.BUSSNOTYPE = 'TB' --����Լ
    AND BPO.MANAGECOM LIKE '8647%' --����
    AND BPO.RECEIVEDATE = DATE '2015-12-31' --��������
    
SELECT COUNT(DISTINCT BPO.BUSSNO) ��������� 
  FROM LIS.BPOMISSIONSTATE BPO
  LEFT JOIN LIS.LCISSUEPOL ISS
  ON BPO.BUSSNO = ISS.CONTNO --Ͷ������
  WHERE 1 = 1
    AND BPO.BUSSNOTYPE = 'TB' --����Լ
    AND BPO.MANAGECOM LIKE '8647%' --����
    AND BPO.RECEIVEDATE = DATE '2015-12-31' --��������    
    AND ISS.BACKOBJ = 'BPO' --BPO�����
