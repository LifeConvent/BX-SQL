SELECT COUNT(1) ������ֹ����
        FROM (SELECT A.POLICY_CODE,A.EXPIRY_DATE,A.MATURITY_DATE
              FROM DEV_PAS.T_CONTRACT_PRODUCT A 
              WHERE A.LIABILITY_STATE = 3
                    AND A.END_CAUSE = '01'
                    AND A.ORGAN_CODE LIKE '8647%'
                    AND A.EXPIRY_DATE = DATE '2006-03-08' --��ֹ����
              ORDER BY A.EXPIRY_DATE)
              
          SELECT A.POLICY_CODE,A.EXPIRY_DATE,A.MATURITY_DATE
              FROM DEV_PAS.T_CONTRACT_PRODUCT A 
              WHERE A.LIABILITY_STATE = 3
                    AND A.END_CAUSE = '01'
                    AND A.ORGAN_CODE LIKE '8647%'
                    AND A.EXPIRY_DATE = DATE '2006-03-08' --��ֹ����
              ORDER BY A.EXPIRY_DATE
              
         
              
         SELECT COUNT(1) ������ֹ����
          FROM LCCONTSTATE A
         WHERE 1=1
           AND A.STATETYPE = 'TERMINATE'
           AND A.STATE = '1'
           AND A.STATEREASON = '01' --������ֹ
           AND A.ContNo IN (SELECT CONTNO
                      FROM LIS.LCPOL B
                     WHERE B.CONTTYPE = '1'
                       AND B.MANAGECOM LIKE '8647%')
           AND A.STARTDATE = DATE '2006-03-08'
                       
         SELECT A.ContNo,A.STARTDATE
          FROM LCCONTSTATE A
         WHERE 1=1
           AND A.STATETYPE = 'TERMINATE'
           AND A.STATE = '1'
           AND A.STATEREASON = '01' --������ֹ
           AND A.ContNo IN (SELECT CONTNO
                      FROM LIS.LCPOL B
                     WHERE B.CONTTYPE = '1'
                       AND B.MANAGECOM LIKE '8647%')
           AND A.STARTDATE = DATE '2006-03-08'
           
       SELECT TRIM(T2.POLICY_CODE) AS POLICY_CODE,
              TRIM(T1.CONTNO) AS CONTNO,
             (CASE
               WHEN T2.EXPIRY_DATE = T1.STARTDATE THEN
                '��'
               ELSE
                '��'
             END) AS RESULT1
       FROM TMP_LIS_1007_GB T1
       FULL JOIN TMP_NCS_1007_GB@DB_185 T2
            ON TRIM(T1.CONTNO) = TRIM(T2.POLICY_CODE)
       ORDER BY T2.POLICY_CODE;
