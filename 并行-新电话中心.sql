       

/*************************************  �º����µ绰����ͳ��  **************************************/  
SELECT 
       (CASE WHEN ROWNUM = 1 THEN 
             (SELECT COUNT(DISTINCT TCM.POLICY_CODE) 
                 FROM APP___PAS__DBUSER.T_CONTRACT_MASTER TCM
                 LEFT JOIN APP___NB__DBUSER.T_CONTRACT_CALL TCC
                      ON TCM.APPLY_CODE = TCC.APPLY_CODE
                 WHERE 1=1 
                 AND TCC.CALL_SOURCE = '1' --�б��ط�
                 AND TCM.CHANNEL_TYPE = '05' --�绰ֱ��
                 AND TO_CHAR(TCM.ISSUE_DATE, 'YYYY-MM-DD') = '2012-01-16' --�б�����
                 AND TCM.ORGAN_CODE LIKE '8647%')  --�������
        END) �绰���ĳб��طü���,
       (CASE WHEN ROWNUM = 1 THEN 
             (SELECT COUNT(DISTINCT TRAIL.POLICY_CODE)  
                 FROM APP___NB__DBUSER.T_PROPOSAL_PROCESS TRAIL
                 LEFT JOIN APP___PAS__DBUSER.T_CONTRACT_MASTER TCM
                      ON TCM.POLICY_CODE = TRAIL.POLICY_CODE
                      WHERE 1 = 1
                       AND TRAIL.PROCESS_STEP = '251' --�绰���������ӡ
                       AND TCM.ORGAN_CODE LIKE '8647%' --�������
                       AND TO_CHAR(TRAIL.START_TIME, 'YYYY-MM-DD') = '2012-01-16') --���̿�ʼʱ��
        END) �绰���Ĵ�ӡ�������
       FROM APP___NB__DBUSER.T_PROPOSAL_PROCESS TRAIL
WHERE ROWNUM = 1;     

/*************************************  --------------------  **************************************/
SELECT * FROM APP___NB__DBUSER.T_CONTRACT_CALL TCC
       WHERE TCC.CALL_STATUS = 1 --�طóɹ�
       AND TCC.CALL_TYPE = 1 --�绰�ط�
       AND TCC.CALL_SOURCE = '1'; --�б��ط�
       
SELECT * FROM APP___NB__DBUSER.T_PROPOSAL_PROCESS TRAIL WHERE TRAIL.PROCESS_STEP = '251' --�绰���������ӡ
            ON TCM.POLICY_CODE = TRAIL.POLICY_CODE
            AND TRAIL.PROCESS_STEP = '251' --�绰���������ӡ

/*************************************  �º����µ绰������ϸ  **************************************/

/****** �绰���ĳб�SQL+��ӡ����SQL ******/
SELECT TCM.ORGAN_CODE ����,
       TCM.APPLY_CODE Ͷ������,
       TCM.POLICY_CODE ������,
       TO_CHAR(TCM.ISSUE_DATE, 'YYYY-MM-DD') �б�����,/*�б������ַ�*/
       (CASE TCM.CHANNEL_TYPE WHEN '05' THEN '�绰ֱ��' ELSE '����' END) ��������,
       (CASE TCC.CALL_STATUS
           WHEN 1 THEN '�ɹ�'
           WHEN 2 THEN 'ʧ��'
           ELSE '��'
        END) �ط�״̬, 
       --TCC.CALL_STATUS �ط�״̬��ֵ, --�ط�״̬��ֵ
       --TCC.CALL_SOURCE �ط���Դ,
       (CASE
           WHEN TO_CHAR(TCC.CALL_TYPE) IS NOT NULL THEN TO_CHAR(TCC.CALL_TYPE)
           ELSE '��'
        END) �ط÷�ʽ,
       (CASE TRAIL.PROCESS_STEP
           WHEN '251' THEN '��'
           ELSE '��'
        END) �Ƿ�绰���Ĵ�ӡ����,
       (CASE TRAIL.PROCESS_STEP
           WHEN '251' THEN TO_CHAR(TRAIL.START_TIME, 'YYYY-MM-DD')
           ELSE '��'
        END) ��ӡ��������
       FROM DEV_PAS.T_CONTRACT_MASTER TCM
       LEFT JOIN APP___NB__DBUSER.T_CONTRACT_CALL TCC
          ON TCM.APPLY_CODE = TCC.APPLY_CODE
       LEFT JOIN APP___NB__DBUSER.T_PROPOSAL_PROCESS TRAIL
          ON TCM.POLICY_CODE = TRAIL.POLICY_CODE
       WHERE 1=1 
       --AND TCC.CALL_TYPE = 1 --�绰�ط�
       AND TCM.ORGAN_CODE LIKE '8647%' --�������
       AND ((
           TCC.CALL_SOURCE = '1' --�б��ط�
           AND TCM.CHANNEL_TYPE = '05' --�绰ֱ��
           AND TO_CHAR(TCM.ISSUE_DATE, 'YYYY-MM-DD') = '2012-01-16' --�б�����
       )
       OR (
          TRAIL.PROCESS_STEP = '251' --�绰���������ӡ
          AND TO_CHAR(TRAIL.START_TIME, 'YYYY-MM-DD') = '2012-01-16' --�绰��ӡ��������
       ))
ORDER BY TCM.APPLY_CODE
/****** �绰���ĳб�SQL *****
SELECT TCM.POLICY_CODE ������,
       TCM.APPLY_CODE Ͷ������,
       TO_CHAR(TCM.ISSUE_DATE, 'YYYY-MM-DD') �б�����,�б�����
       TCM.CHANNEL_TYPE ��������,
       --TCM.ORGAN_CODE �������,
       (CASE TCC.CALL_STATUS
           WHEN 1 THEN '�ɹ�'
           WHEN 2 THEN 'ʧ��'
           ELSE '��'
        END) �ط�״̬,
       --TCC.CALL_STATUS �ط�״̬��ֵ, --�ط�״̬��ֵ
       (CASE
           WHEN TCC.CALL_TYPE IS NOT NULL THEN TCC.CALL_TYPE
           ELSE '��'
        END) �ط÷�ʽ
       --TCC.CALL_SOURCE �ط���Դ
       FROM DEV_PAS.T_CONTRACT_MASTER TCM
       LEFT JOIN APP___NB__DBUSER.T_CONTRACT_CALL TCC
            ON TCM.APPLY_CODE = TCC.APPLY_CODE
       WHERE 1=1 
       --AND TCC.CALL_TYPE = 1 --�绰�ط�
       AND TCC.CALL_SOURCE = '1' --�б��ط�
       AND TCM.CHANNEL_TYPE = '05' --�绰ֱ��
       AND TO_CHAR(TCM.ISSUE_DATE, 'YYYY-MM-DD') = '2012-01-16'
       AND TCM.ORGAN_CODE LIKE '8647%'; --�������*/
/****** ��ӡ����SQL *****
SELECT  TRAIL.POLICY_ID ����ID,
        TRAIL.POLICY_CODE ������,
        TRAIL.APPLY_CODE Ͷ������
       FROM APP___NB__DBUSER.T_PROPOSAL_PROCESS TRAIL
       LEFT JOIN DEV_PAS.T_CONTRACT_MASTER TCM
          ON TCM.POLICY_CODE = TRAIL.POLICY_CODE
       WHERE 1 = 1
          AND TRAIL.PROCESS_STEP = '251' --�绰���������ӡ
          AND TCM.ORGAN_CODE LIKE '8647%' --�������
          AND TO_CHAR(TRAIL.START_TIME, 'YYYY-MM-DD') = '2012-01-16'; --���̿�ʼʱ��
          --AND TO_CHAR(TRAIL.END_TIME, 'YYYY-MM-DD') = '2012-01-16' --��ӡ����*/
          
          
SELECT * FROM APP___NB__DBUSER.T_CONTRACT_CALL --�����绰�ط���Ϣ��
SELECT * FROM APP___NB__DBUSER.T_PROPOSAL_PROCESS --Ͷ����״̬�켣��
SELECT * FROM APP___NB__DBUSER.T_BIZ_CALL --����绰��������
/*************************************  ---------------------  **************************************/
SELECT * FROM LIS.LGCALLBACK --�绰�ط������
SELECT * FROM LIS.LACUSTOMERHFINFO --�ط�����ͬ����Ϣ��
SELECT * FROM LIS.LZCARDTRACK --��֤�켣�� ��������
SELECT * FROM LIS.LCCONT --���˱�����
/*************************************  �Ϻ����µ绰����ͳ��  **************************************/

SELECT 
       (CASE WHEN ROWNUM = 1 THEN 
             (SELECT COUNT(DISTINCT A.CONTNO)
                 FROM LIS.LCCONT A
                 LEFT JOIN LIS.LACUSTOMERHFINFO B
                 ON A.CONTNO = B.CONTNO
                 WHERE 1 = 1
                 AND A.SELLTYPE = '12' --�绰ֱ��
                 AND B.CALLRESULT = '1' --�طóɹ�
                 AND A.CONTNO IN (SELECT CONTNO
                                     FROM LIS.LCPOL B
                                     WHERE B.CONTTYPE = '1'
                                     AND B.MANAGECOM LIKE '8647%') --�������
                 AND A.SIGNDATE = DATE '2015-12-31') --ǩ������
                 --AND B.CALLDATE = DATE '2015-12-31' --�ط�����
        END) �б��طü���,
       (CASE WHEN ROWNUM = 1 THEN 
             (SELECT COUNT(DISTINCT A.CONTNO) 
                 FROM LIS.LCCONT A
                 LEFT JOIN LIS.LCCYBERBANKPOLICY B
                 ON A.CONTNO = B.CONTNO
                 WHERE 1 = 1
                 AND A.CONTNO IN (SELECT CONTNO
                                     FROM LIS.LCPOL B
                                     WHERE B.CONTTYPE = '1'
                                     AND B.MANAGECOM LIKE '8647%') --�������
                 AND B.APPLYDATE = DATE '2015-12-31') --��������   
                 --AND B.STATE = '0' --��ӡ�ɹ� 
        END) �绰���Ĵ�ӡ�������
       FROM LIS.LCCONT A
WHERE ROWNUM = 1;  

SELECT COUNT(DISTINCT A.CONTNO) �绰���ĳб��طü��� 
       FROM LIS.LCCONT A
       LEFT JOIN LIS.LACUSTOMERHFINFO B
       ON A.CONTNO = B.CONTNO
       WHERE 1 = 1
       AND A.SELLTYPE = '12' --�绰ֱ��
       AND B.CALLRESULT = '1' --�طóɹ�
       AND A.CONTNO IN (SELECT CONTNO
                           FROM LIS.LCPOL B
                           WHERE B.CONTTYPE = '1'
                           AND B.MANAGECOM LIKE '8647%') --�������
       AND A.SIGNDATE = DATE '2015-12-31' --ǩ������
       --AND B.CALLDATE = DATE '2015-12-31' --�ط�����
       
SELECT COUNT(DISTINCT A.CONTNO) �绰���Ĵ�ӡ������� 
       FROM LIS.LCCONT A
       LEFT JOIN LIS.LCCYBERBANKPOLICY B
       ON A.CONTNO = B.CONTNO
       WHERE 1 = 1
       AND A.CONTNO IN (SELECT CONTNO
                           FROM LIS.LCPOL B
                           WHERE B.CONTTYPE = '1'
                           AND B.MANAGECOM LIKE '8647%') --�������
       AND B.APPLYDATE = DATE '2015-12-31' --��������   
       --AND B.STATE = '0' --��ӡ�ɹ�   
       

/*************************************  �Ϻ����µ绰������ϸ  **************************************/
SELECT A.MANAGECOM ����,
       A.CONTNO ������,
       A.PRTNO Ͷ������,
       A.SIGNDATE �б�����,
       (CASE A.SELLTYPE WHEN '12' THEN '�绰ֱ��' ELSE '����' END) ��������,
       (CASE B.CALLRESULT
           WHEN '0' THEN '�ɹ�'
           WHEN '1' THEN 'ʧ��'
           ELSE '��'
        END) �ط�״̬,
       (CASE
           WHEN B.CALLTYPE IS NOT NULL THEN B.CALLTYPE
           ELSE '��'
        END) �ط÷�ʽ,
       (CASE
           WHEN C.STATE IS NOT NULL THEN '��'
           ELSE '��'
        END) �Ƿ�绰���Ĵ�ӡ����,
       (CASE
           WHEN C.STATE IS NOT NULL THEN TO_CHAR(C.APPLYDATE, 'YYYY-MM-DD')
           ELSE '��'
        END) ��ӡ��������
       --C.STATE ��ӡ״̬
       FROM LIS.LCCONT A
       LEFT JOIN LIS.LACUSTOMERHFINFO B
       ON A.CONTNO = B.CONTNO
       LEFT JOIN LIS.LCCYBERBANKPOLICY C
       ON A.CONTNO = C.CONTNO
         WHERE 1 = 1
               AND A.SELLTYPE = '12' --�绰ֱ��
               AND (C.APPLYDATE = DATE '2010-10-25' --��ӡ��������
               OR A.SIGNDATE = DATE '2010-10-25') --ǩ������
               AND A.CONTNO IN (SELECT CONTNO
                                  FROM LIS.LCPOL B
                                 WHERE B.CONTTYPE = '1'
                                   AND B.MANAGECOM LIKE '8647%') --�������
ORDER BY A.CONTNO
                                   
                                   
                             
