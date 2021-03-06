 
     SELECT COUNT(1) AS 投连失效总数
        FROM ( SELECT DISTINCT (B.POLICY_CODE)
           FROM DEV_PAS.T_CONTRACT_MASTER B
           JOIN DEV_PAS.T_CONTRACT_BUSI_PROD TCBP
             ON TCBP.POLICY_ID = B.POLICY_ID
          WHERE 1 = 1
                AND TCBP.LIABILITY_STATE = '4' --险种状态
                AND TCBP.LAPSE_CAUSE = '2' --终止原因 投连
                AND TCBP.LAPSE_DATE = DATE '2017-12-31' --交易产生时间
                AND B.ORGAN_CODE LIKE '8647%' --机构代码
          GROUP BY B.POLICY_CODE )
          
          
       CREATE TABLE  TMP_NCS_1002_GB  AS
      --DELETE FROM TMP_NCS_1002_GB;
      --COMMIT;
      --INSERT INTO TMP_NCS_1002_GB
       SELECT DISTINCT (B.POLICY_CODE),TCBP.LIABILITY_STATE,TCBP.LAPSE_CAUSE
           FROM DEV_PAS.T_CONTRACT_MASTER B
           JOIN DEV_PAS.T_CONTRACT_BUSI_PROD TCBP
             ON TCBP.POLICY_ID = B.POLICY_ID
             WHERE 1 = 1
                AND TCBP.LIABILITY_STATE = '4' --险种状态
                AND TCBP.LAPSE_CAUSE = '2' --终止原因 投连
                AND TCBP.LAPSE_DATE = DATE '2017-12-31' --交易产生时间
                AND B.ORGAN_CODE LIKE '8647%' --机构代码
       ORDER BY B.POLICY_CODE
       
       
SELECT COUNT(1)
  FROM (SELECT T1.CONTNO,
               T2.MANAGECOM,
               T1.RISKCODE,
               A.STATETYPE,
               A.STATE,
               A.STARTDATE
          FROM LIS.LCINSUREACCFEETRACE T1 --管理费履历表
          LEFT JOIN LIS.LCCONT T2
            ON T1.CONTNO = T2.CONTNO
          LEFT JOIN LIS.LCCONTSTATE A
            ON T1.CONTNO = A.CONTNO
         WHERE 1 = 1
           AND T2.CONTTYPE = '1'
           AND T2.MANAGECOM LIKE '8647%' --机构代码
           AND T1.RISKCODE IN (SELECT RISKCODE
                                 FROM LIS.LMRISKAPP
                                WHERE RISKPROP IN ('I', 'Y')
                                  AND INVESTFLAG = 'Y')
           AND A.STATETYPE = 'Available'
           AND A.STATE = '1'              
           AND A.STARTDATE = DATE'2017-12-26'
         GROUP BY T1.CONTNO,
                  T2.MANAGECOM
         ORDER BY T1.CONTNO) T
         
        CREATE TABLE  TMP_LIS_1002_GB  AS
        --DELETE FROM TMP_LIS_1002_GB;
        --COMMIT;
        --INSERT INTO TMP_LIS_1002_GB
        SELECT T1.CONTNO,
               T2.MANAGECOM,
               T1.RISKCODE,
               A.STATETYPE,
               A.STATE,
               A.STARTDATE
          FROM LIS.LCINSUREACCFEETRACE T1 --管理费履历表
          LEFT JOIN LIS.LCCONT T2
            ON T1.CONTNO = T2.CONTNO
          LEFT JOIN LIS.LCCONTSTATE A
            ON T1.CONTNO = A.CONTNO
         WHERE 1 = 1
           AND T2.CONTTYPE = '1'
           AND T2.MANAGECOM LIKE '8647%' --机构代码
           AND T1.RISKCODE IN (SELECT RISKCODE
                                 FROM LIS.LMRISKAPP
                                WHERE RISKPROP IN ('I', 'Y')
                                  AND INVESTFLAG = 'Y')
           AND A.STATETYPE = 'Available'
           AND A.STATE = '1'              
           AND A.STARTDATE = DATE'2017-12-26'
         GROUP BY T1.CONTNO,
                  T2.MANAGECOM
         ORDER BY T1.CONTNO
         
         
     SELECT TRIM(T2.POLICY_CODE) AS POLICY_CODE,
       TRIM(T1.CONTNO) AS CONTNO,
        (CASE
         WHEN T2.LIABILITY_STATE = '4' AND T1.STATE = '1' THEN
          '否'
         ELSE
          '是'
       END) AS RESULT1
     FROM TMP_LIS_1002_GB T1
      FULL JOIN TMP_NCS_1002_GB@DB_185 T2
        ON TRIM(T1.CONTNO) = TRIM(T2.POLICY_CODE)
     ORDER BY T2.POLICY_CODE;

     
