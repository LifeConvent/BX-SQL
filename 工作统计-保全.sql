
/******************************************************************************************************************************************** 
                                                                 �º���SQL   
 ********************************************************************************************************************************************/

--drop table TMP_NCS_2001;
DELETE FROM TMP_NCS_2001;
COMMIT;
INSERT INTO TMP_NCS_2001
--CREATE TABLE  TMP_NCS_2001  AS
SELECT B.USER_NAME,B.POLICY_CODE,B.BUSINESS_CODE,SUM(GETMONEY) AS GETMONEY FROM 
(SELECT B.USER_NAME,TCPA.POLICY_CODE,TCPA.BUSINESS_CODE,CASE 
   WHEN TCPA.ARAP_FLAG='2' THEN -TCPA.FEE_AMOUNT ELSE TCPA.FEE_AMOUNT END AS GETMONEY
    FROM DEV_PAS.T_CS_PREM_ARAP@BINGXING_168_15 TCPA
    LEFT JOIN DEV_PAS.T_CS_ACCEPT_CHANGE@BINGXING_168_15 TCAC
    ON TCAC.ACCEPT_CODE = TCPA.BUSINESS_CODE
    --ARAP_FLAG 1-�շ� 2-����
        LEFT JOIN DEV_PAS.T_CS_APPLICATION@BINGXING_168_15 TCA
        ON TCA.CHANGE_ID = TCAC.CHANGE_ID
        JOIN DEV_PAS.T_UDMP_USER@BINGXING_168_15 B
        ON TCA.INSERT_BY = B.USER_ID
    WHERE 1=1
        AND TCPA.DERIV_TYPE = '004'
        AND TCPA.ORGAN_CODE LIKE '8647%'
        AND TCPA.BUSI_APPLY_DATE = date'2018-06-27'        --ҵ������ʱ��
        AND B.REAL_NAME NOT IN ('�����»�','�ƶ���ȫ','�绰������ϯ','��վ�û�')
         AND TCAC.ACCEPT_STATUS<>12
   UNION
   SELECT B.USER_NAME,TCCM.POLICY_CODE,TCAC.ACCEPT_CODE AS BUSINESS_CODE,0 AS GETMONEY-- ��0����
        FROM DEV_PAS.T_CS_ACCEPT_CHANGE@BINGXING_168_15 TCAC
        LEFT JOIN DEV_PAS.T_CS_CONTRACT_MASTER@BINGXING_168_15 TCCM
        ON TCCM.CHANGE_ID = TCAC.CHANGE_ID
        LEFT JOIN DEV_PAS.T_CS_APPLICATION@BINGXING_168_15 TCA
        ON TCA.CHANGE_ID = TCAC.CHANGE_ID
        JOIN DEV_PAS.T_UDMP_USER@BINGXING_168_15 B
        ON TCA.INSERT_BY = B.USER_ID
            WHERE TCA.APPLY_TIME = DATE '2018-06-27' --ʱ��
            AND TCCM.ORGAN_CODE LIKE '8647%'
            AND B.REAL_NAME NOT IN ('�����»�','�ƶ���ȫ','�绰������ϯ','��վ�û�')
            AND TCAC.ACCEPT_STATUS<>12
   ) B WHERE 1=1
GROUP BY B.USER_NAME,B.POLICY_CODE,B.BUSINESS_CODE
ORDER BY B.POLICY_CODE;
COMMIT;

/******************************************************************************************************************************************** 
                                                           ��ȫ�º��Ĳ�����
 ********************************************************************************************************************************************/
/*SELECT * FROM DEV_PAS.T_CS_PREM_ARAP@BINGXING_168_15 TCPA WHERE TCPA.POLICY_CODE = '887332886380';--Ӧ��Ӧ����¼����ȫ��
SELECT * FROM DEV_PAS.T_PREM_ARAP@BINGXING_168_15 TCPA WHERE TCPA.POLICY_CODE = '887332886380';--Ӧ��Ӧ��
SELECT * FROM DEV_CAP.T_CASH_DETAIL@BINGXING_168_15 WHERE POLICY_CODE = '887332886380';--ʵ����ϸ���ո��ѣ�
SELECT * FROM DEV_PAS.T_CS_ACCEPT_CHANGE@BINGXING_168_15 TCAC WHERE  TCAC.ACCEPT_CODE IN ('6120180626011886')   INSERT_BY=22856 AND TO_CHAR(INSERT_TIME,'YYYYMMDD') = '20180625';
SELECT * FROM DEV_PAS.T_CS_APPLICATION@BINGXING_168_15 TCA WHERE TCA.CHANGE_ID = 165200;
SELECT * FROM DEV_PAS.T_UDMP_USER@BINGXING_168_15 B WHERE B.USER_ID = '21389';
SELECT * FROM DEV_PAS.T_CS_ACCEPT_CHANGE@BINGXING_168_15 TCAC WHERE TO_CHAR(TCAC.ACCEPT_TIME,'YYYYMMDD') =  '20180620'
            AND TCAC.ORGAN_CODE LIKE '8647%';
--DROP TABLE TMP_NCS_2001;
--COMMIT;

SELECT B.USER_NAME,TCAC.ACCEPT_CODE,TCA.INSERT_TIME FROM DEV_PAS.T_CS_ACCEPT_CHANGE@BINGXING_168_15 TCAC 
        LEFT JOIN DEV_PAS.T_CS_APPLICATION@BINGXING_168_15 TCA
        ON TCA.CHANGE_ID = TCAC.CHANGE_ID
        LEFT JOIN DEV_PAS.T_UDMP_USER@BINGXING_168_15 B
        ON TCA.INSERT_BY = B.USER_ID
WHERE  TCAC.ACCEPT_CODE IN ('z612018062716505701','z612018062716493401','z612018062716490701','z612018062716508301')*/



/******************************************************************************************************************************************** 
                                                               �Ϻ���SQL   
 ********************************************************************************************************************************************/
 --DROP TABLE TMP_LIS_2001;
--COMMIT;
DELETE FROM TMP_LIS_2001;
COMMIT;
INSERT INTO TMP_LIS_2001
--CREATE TABLE  TMP_LIS_2001  AS
select /*+PARALLEL(80)*/ m.contno,
       m.edoracceptno,m.operator,
       SUM(m.GETMONEY+m.GETINTEREST) AS getmoney
  from lis.lpedoritem m
where 1=1 
   --AND m.edorappdate = date'2018-06-27'                   --��Ч����
   AND TRIM(m.edoracceptno) IN (SELECT DISTINCT TCAC.ACCEPT_CODE FROM DEV_PAS.T_CS_ACCEPT_CHANGE@BINGXING_168_15 TCAC
        LEFT JOIN DEV_PAS.T_CS_APPLICATION@BINGXING_168_15 TCA
        ON TCA.CHANGE_ID = TCAC.CHANGE_ID
            WHERE TCA.APPLY_TIME = date '2018-06-27' AND TCAC.ACCEPT_CODE NOT LIKE 'z%')
   and exists (select 1
          from lis.lccont t
         where t.conttype = '1'
           and t.appflag in ('1', '4')
           and t.managecom like '8647%'
           and t.contno = m.contno)
GROUP BY m.contno,m.edoracceptno,m.operator
ORDER BY m.contno;
COMMIT;



/********************************************************************************************************************************************
                                                               ������ϸ  
 ********************************************************************************************************************************************/
--SELECT * FROM TMP_NCS_2001 T2;
--SELECT * FROM TMP_LIS_2001 T1;
SELECT T2.USER_NAME ����Ա,
       T2.POLICY_CODE AS ������,
       T2.BUSINESS_CODE AS �º��ı�ȫ�����,
       T1.EDORACCEPTNO AS �Ϻ��ı�ȫ�����,
       NVL(T2.GETMONEY, 0) AS �º��Ĳ��˷ѽ��,
       NVL(T1.GETMONEY, 0) AS �Ϻ��Ĳ��˷ѽ��,
       (CASE 
          WHEN NVL(T2.GETMONEY, 0) = NVL(T1.GETMONEY, 0) THEN '�� ' 
          ELSE '�� '             
        END) AS �Ƿ�һ��
  FROM TMP_NCS_2001 T2
  LEFT JOIN TMP_LIS_2001 T1
   ON T2.POLICY_CODE = TRIM(T1.CONTNO)
   --AND TRIM(T2.BUSINESS_CODE) = TRIM(T1.EDORACCEPTNO)
ORDER BY T2.POLICY_CODE;
