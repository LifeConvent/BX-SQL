/*-----------------------------------------------------------------------------------------------------------------
//////////////////////////////////////////--�Ϻ���ָ��--/////////////////////////////////////////////////////
-----------------------------------------------------------------------------------------------------------------*/
SELECT 
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

SELECT T.MAKEDATE ͳ������,
       T.MANAGECOM �������,
       T.CONTNO ������,
       T.PROPOSALNO Ͷ������,
       T.STATE �Ժ˽���,
       (CASE T.STATE WHEN '9' THEN 'ͨ��' WHEN '5' THEN '��ͨ��' ELSE '����' END) �Ժ�״̬
     FROM LIS.LCUWSUB T
     LEFT JOIN LIS.LCPOL T1
      ON T.POLNO = T1.POLNO --������
      AND T.PROPOSALNO = T1.PROPOSALNO --Ͷ������
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
ORDER BY T.CONTNO;
/*-----------------------------------------------------------------------------------------------------------------
//////////////////////////////////////////--�º���ָ��--/////////////////////////////////////////////////////
-----------------------------------------------------------------------------------------------------------------*/
SELECT 
       (CASE WHEN ROWNUM = 1 THEN 
             (SELECT COUNT(TCM.POLICY_ID)
                 FROM T_CONTRACT_MASTER TCM
                    LEFT JOIN T_PROPOSAL_PROCESS A
                    ON A.POLICY_ID = TCM.POLICY_ID
                 WHERE 1 = 1
                 AND A.PROCESS_STEP = '17'
                 AND TCM.ORGAN_CODE LIKE '8647%' --����
                 AND A.UPDATE_TIME = DATE '2017-12-12') --���¼�¼����
        END) �Ժ�ͨ������,
       (CASE WHEN ROWNUM = 1 THEN 
             (SELECT COUNT(TCM.POLICY_ID)
                 FROM T_CONTRACT_MASTER TCM
                    LEFT JOIN T_PROPOSAL_PROCESS A
                    ON A.POLICY_ID = TCM.POLICY_ID
                 WHERE 1 = 1
                 AND A.PROCESS_STEP = '18'
                 AND TCM.ORGAN_CODE LIKE '8647%' --����
                 AND A.UPDATE_TIME = DATE '2017-12-12') --���¼�¼����
        END) �Ժ˲�ͨ������
       FROM T_CONTRACT_MASTER
WHERE ROWNUM = 1;  

SELECT A.UPDATE_TIME ͳ������,
       TCM.ORGAN_CODE �������,
       TCM.POLICY_CODE ������,
       A.APPLY_CODE Ͷ������,
       A.PROCESS_STEP �Ժ˽���,
       (CASE A.PROCESS_STEP WHEN '17' THEN 'ͨ��' WHEN '18' THEN '��ͨ��' ELSE '����' END) �Ժ�״̬
       FROM T_CONTRACT_MASTER TCM
            LEFT JOIN T_PROPOSAL_PROCESS A
            ON A.POLICY_ID = TCM.POLICY_ID
       WHERE 1 = 1
            AND TCM.ORGAN_CODE LIKE '8647%' --����
            AND A.UPDATE_TIME = DATE '2017-12-12' --���¼�¼����
ORDER BY TCM.POLICY_CODE;
