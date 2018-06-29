SELECT COUNT(1) 条数
  FROM DEV_PAS.T_DOCUMENT T
  WHERE T.TEMPLATE_CODE = 'PAS_00002'
    AND T.STATUS = '2'
    AND T.ORGAN_CODE LIKE '8647%'
    AND T.SEND_TIME = DATE '2017-10-11'; --发放日期
    
SELECT T.POLICY_CODE,T.STATUS,T.DOCUMENT_NAME,T.SEND_TIME
  FROM DEV_PAS.T_DOCUMENT T
  WHERE T.TEMPLATE_CODE = 'PAS_00002'
    AND T.STATUS = '2'
    AND T.ORGAN_CODE LIKE '8647%'
    AND T.SEND_TIME = DATE '2017-10-11'; --发放日期

    SELECT COUNT(1) 条数
          FROM LIS.LOPRTMANAGER A
         INNER JOIN LIS.LCCONT B
            ON A.OTHERNO = B.CONTNO
         WHERE 1=1
           AND B.CONTTYPE = '1'
           AND (B.APPFLAG IN ('1', '4') OR
               (B.APPFLAG = '0' AND
               B.UWFLAG NOT IN ('0', '4', '5', '9', 'Z')))
           AND A.CODE = 'BQ10'
           AND A.STATEFLAG IN ('1', '2');
           AND A.MANAGECOM LIKE '8647%'
           AND A.MAKEDATE = DATE '2000-01-01'
           
       SELECT B.CONTNO,A.MAKEDATE,A.STATEFLAG,
       (CASE 
              WHEN A.CODE = 'BQ10' THEN 'PAS_00002'
                ELSE A.CODE 
        END) AS TEMPLATE_CODE
          FROM LIS.LOPRTMANAGER A
         INNER JOIN LIS.LCCONT B
            ON A.OTHERNO = B.CONTNO
         WHERE 1=1
           AND B.CONTTYPE = '1'
           AND (B.APPFLAG IN ('1', '4') OR
               (B.APPFLAG = '0' AND
               B.UWFLAG NOT IN ('0', '4', '5', '9', 'Z')))
           AND A.CODE = 'BQ10'
           AND A.STATEFLAG IN ('1', '2');
           AND A.MANAGECOM LIKE '8647%'
           AND A.MAKEDATE = DATE '2000-01-01'
           
       SELECT TRIM(T2.POLICY_CODE) AS POLICY_CODE,
       TRIM(T1.CONTNO) AS CONTNO,
       (CASE
         WHEN T2.SEND_TIME = T1.MAKEDATE
              AND T2.TEMPLATE_CODE = T1.TEMPLATE_CODE THEN
          '否'
         ELSE
          '是'
       END) AS RESULT1
        FROM TMP_LIS_1009_GB T1
        FULL JOIN TMP_NCS_1009_GB@DB_185 T2
          ON TRIM(T1.CONTNO) = TRIM(T2.POLICY_CODE)
       ORDER BY T2.POLICY_CODE;
