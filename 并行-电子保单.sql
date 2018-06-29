SELECT * FROM LIS.LCELECTRONICPOLICY --���ӱ����� ��������=ǩ������
SELECT * FROM LIS.LCECONTSENDHISTORY --��ʷ�켣��
SELECT * FROM LIS.LCEPSENDERROR --������Ϣ��


/*************************************  �Ϻ��ĵ��ӱ���ͳ��  ************************************/
SELECT 
       (CASE WHEN ROWNUM = 1 THEN 
             (SELECT COUNT(A.CONTNO)  
                 FROM LIS.LCELECTRONICPOLICY A --�����ӡ
                 LEFT JOIN LIS.LCPOL B
                 ON A.CONTNO = B.CONTNO 
                 WHERE 1=1
                   AND B.CONTTYPE = '1'
                   AND A.MANAGECOM LIKE '8647%' --�������
                   AND A.SENDDATE = DATE '2017-12-26') --��������
        END) ���ӱ������ż���,
        (CASE WHEN ROWNUM = 1 THEN 
            (SELECT COUNT(A.CONTNO) 
               FROM LIS.LCELECTRONICPOLICY A --�����ӡ
               LEFT JOIN LIS.LCPOL B
               ON A.CONTNO = B.CONTNO 
               WHERE 1=1
                 AND B.CONTTYPE = '1'
                 AND A.LSSUEDATE IS NOT NULL --ǩ�ճɹ�
                 AND A.MANAGECOM LIKE '8647%' --�������
                 AND A.SENDDATE = DATE '2017-12-26') --��������
        END) ���ӱ����ش�����
       FROM LIS.LCELECTRONICPOLICY A
WHERE ROWNUM = 1;
         
         --(OR A.RECEIVESIGNDATE = DATE '2017-12-26') --�ش�����
/*************************************  �Ϻ��ĵ��ӱ�����ϸ  ************************************/
SELECT A.CONTNO ������,
       B.PRTNO Ͷ������,
       --A.MANAGECOM �������,
       --(CASE A.RECEIVEFLAG
           --WHEN '0' THEN 'δ����'
           --WHEN '1' THEN '�ѽ���'
        --END) ����״̬,
       --A.RECEIVEFLAG/*0-δ���� 1-�ѽ���*/ ����״̬��,
       A.SENDDATE ��������,
       A.RECEIVESIGNDATE �ش�����,
       --A.LSSUEDATE ǩ������
       FROM LIS.LCELECTRONICPOLICY A --�����ӡ
       LEFT JOIN LIS.LCPOL B
       ON A.CONTNO = B.CONTNO 
       WHERE 1=1
         AND B.CONTTYPE = '1'
         AND A.MANAGECOM LIKE '8647%' --�������
         AND A.SENDDATE = DATE '2017-12-26' --��������
   ORDER BY A.CONTNO
         
         
                       --AND TPP.PRINT_STATUS IN ('3','4','5') -- 3-����ӡ��4-�Ѵ�ӡ��5-�����ش�
                       --AND BPO_PRINT_DATE = DATE '2017-04-27' --��ӡ����
                       --AND TPD.RECEIVE_DATE = DATE '2017-04-27' --��������
                         --AND TPP.PRINT_STATUS IN ('3','4','5') -- 3-����ӡ��4-�Ѵ�ӡ��5-�����ش�
                         --AND BPO_PRINT_DATE = DATE '2018-04-09' --��ӡ����
                         --AND TPD.RECEIVE_DATE = DATE '2018-04-09' --��������
/*************************************  �º���BPO�Ƶ�����  ************************************/
SELECT 
       (CASE WHEN ROWNUM = 1 THEN 
             (SELECT COUNT(TPP.POLICY_CODE)
                 FROM APP___NB__DBUSER.T_POLICY_PRINT TPP
                 LEFT JOIN APP___NB__DBUSER.T_PRINT_DETAIL TPD
                      ON TPP.POLICY_CODE = TPD.POLICY_CODE
                 LEFT JOIN APP___NB__DBUSER.T_POLICY_PRINT_APPLY TPPA
                      ON TPP.PRINT_ID = TPPA.PRINT_ID
                 WHERE 1 = 1 
                       AND TPP.PRINT_TYPE = '2' --�����ӡ 1-�����ӡ��2-�����Ƶ�
                       AND TPD.SEND_DATE = DATE '2017-04-27' --��������
                       AND TPP.PRINT_ORG LIKE '8647%') --��ӡ����
        END) ��ӡ�������,
       (CASE WHEN ROWNUM = 1 THEN 
             (SELECT COUNT(TPP.POLICY_CODE)
                   FROM APP___NB__DBUSER.T_POLICY_PRINT TPP
                   LEFT JOIN APP___NB__DBUSER.T_PRINT_DETAIL TPD
                        ON TPP.POLICY_CODE = TPD.POLICY_CODE
                   LEFT JOIN APP___NB__DBUSER.T_POLICY_PRINT_APPLY TPPA
                        ON TPP.PRINT_ID = TPPA.PRINT_ID
                   WHERE 1 = 1 
                         AND TPP.PRINT_TYPE = '2' --�����ӡ 1-�����ӡ��2-�����Ƶ�
                         AND TPPA.APPLY_STATUS = '03' -- 03-��ӡ�ɹ�
                         AND TPD.SEND_DATE = DATE '2018-04-09' --��������
                         AND TPP.PRINT_ORG LIKE '8647%') --��ӡ����
        END) ��ӡ�ɹ�����
       FROM APP___NB__DBUSER.T_POLICY_PRINT TPP
WHERE ROWNUM = 1;


             --AND (TPP.PRINT_STATUS IN ('3','4','5') -- 3-����ӡ��4-�Ѵ�ӡ��5-�����ش�)
             --AND (PRINT_TIME = DATE '2011-07-25' --��ӡ����
             --OR TPD.RECEIVE_DATE = DATE '2011-07-25' --��������
/*************************************  �º���BPO�Ƶ���ϸ  **************************************/
SELECT TPP.POLICY_CODE ������,
       TPP.APPLY_CODE Ͷ������,
       --(CASE TPP.PRINT_TYPE
          -- WHEN '1' THEN '�����ӡ'
          -- WHEN '2' THEN '�����Ƶ�'
        --END) ��ӡ����,
       --TPP.PRINT_TYPE ��ӡ������ֵ,
       --TPP.PRINT_STATUS ��ӡ״̬��ֵ,
       --TPP.PRINT_TIME ��ӡʱ��,
       --TPP.BPO_PRINT_DATE �����ӡʱ��,
       TPD.SEND_DATE ��������,
       TPD.RECEIVE_DATE ��������,
       --PRINT_TIMES/*��ӡ����*/ ��ӡ����,
       (CASE TPPA.APPLY_STATUS
           WHEN '04' THEN 'ʧ��'
           WHEN '03' THEN '�ɹ�'
        END) ��ӡ����״̬,
       TPPA.APPLY_STATUS ��ӡ����״̬��ֵ
       FROM APP___NB__DBUSER.T_POLICY_PRINT TPP
       LEFT JOIN APP___NB__DBUSER.T_PRINT_DETAIL TPD
            ON TPP.POLICY_CODE = TPD.POLICY_CODE
       LEFT JOIN APP___NB__DBUSER.T_POLICY_PRINT_APPLY TPPA
            ON TPP.PRINT_ID = TPPA.PRINT_ID
       WHERE 1 = 1 
             AND TPP.PRINT_TYPE = '2' --�����ӡ 1-�����ӡ��2-�����Ƶ�
             AND TPD.SEND_DATE = DATE '2011-07-25' --��������
             AND TPP.PRINT_ORG LIKE '8647%'
ORDER BY TPP.POLICY_CODE
