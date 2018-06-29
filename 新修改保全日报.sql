
/******************************************************************************************************************************************** 
                                                                 新核心SQL   
 ********************************************************************************************************************************************/
SELECT C.NEW_CODE_NAME,T.GETMONEY,T.SUM FROM
(SELECT TRIM(TCA.SERVICE_TYPE) AS SERVICE_TYPE,SUM(GETMONEY) AS GETMONEY,COUNT(DISTINCT B.CHANGE_ID) AS SUM FROM 
(SELECT TCAC.CHANGE_ID,B.REAL_NAME,TCPA.POLICY_CODE,TCPA.BUSINESS_CODE,TCAC.SERVICE_CODE,CASE 
   WHEN TCPA.ARAP_FLAG='2' THEN -TCPA.FEE_AMOUNT ELSE TCPA.FEE_AMOUNT END AS GETMONEY
    FROM DEV_PAS.T_CS_PREM_ARAP@BINGXING_168_15 TCPA
    LEFT JOIN DEV_PAS.T_CS_ACCEPT_CHANGE@BINGXING_168_15 TCAC
    ON TCAC.ACCEPT_CODE = TCPA.BUSINESS_CODE
    JOIN DEV_PAS.T_UDMP_USER@BINGXING_168_15 B
    ON TCAC.INSERT_BY = B.USER_ID
    WHERE 1=1
        AND TCPA.DERIV_TYPE = '004'
        AND TCPA.ORGAN_CODE LIKE '8647%'
        AND TCAC.ACCEPT_STATUS<>12
        AND TCPA.BUSI_APPLY_DATE = Trunc(SYSDATE)-1 --业务申请时间
   UNION
   SELECT TCAC.CHANGE_ID,B.REAL_NAME,TCCM.POLICY_CODE,TCAC.ACCEPT_CODE AS BUSINESS_CODE,TCAC.SERVICE_CODE,0 AS GETMONEY-- 按0处理
        FROM DEV_PAS.T_CS_ACCEPT_CHANGE@BINGXING_168_15 TCAC
        LEFT JOIN DEV_PAS.T_CS_CONTRACT_MASTER@BINGXING_168_15 TCCM
        ON TCCM.CHANGE_ID = TCAC.CHANGE_ID
        JOIN DEV_PAS.T_UDMP_USER@BINGXING_168_15 B
        ON TCAC.INSERT_BY = B.USER_ID
            WHERE (TCAC.ACCEPT_TIME = Trunc(SYSDATE)-1 --受理时间
                  OR TCAC.VALIDATE_TIME = Trunc(SYSDATE)-1) --生效时间
            AND TCCM.ORGAN_CODE LIKE '8647%'
            AND TCAC.ACCEPT_STATUS<>12
   ) B 
    LEFT JOIN T_CS_APPLICATION@BINGXING_168_15  TCA
         ON TCA.CHANGE_ID = B.CHANGE_ID
WHERE 1=1
    GROUP BY TRIM(TCA.SERVICE_TYPE)
    ORDER BY TRIM(TCA.SERVICE_TYPE)) T,T_CODEMAPPING C WHERE
    TRIM(C.NEW_CODE) = T.SERVICE_TYPE AND C.REMARK IS NULL AND C.CODETYPE='SERVICE_TYPE'
ORDER BY C.NEW_CODE;


/******************************************************************************************************************************************** 
                                                               老核心SQL   
 ********************************************************************************************************************************************/
/*drop table TMP_NCS_2001;
DELETE FROM TMP_NCS_2001;
COMMIT;
INSERT INTO TMP_NCS_2001*/
--CREATE TABLE  TMP_LIS_T_SERVICE_TYPE  AS
--SELECT * FROM DEV_PAS.T_SERVICE_TYPE@BINGXING_168_15; COMMIT;
--SELECT * FROM T_CODEMAPPING WHERE CODETYPE='SERVICE_TYPE' AND REMARK IS NULL

select /*+PARALLEL(80)*/C.NEW_CODE_NAME,T.getmoney,T.SUM FROM T_CODEMAPPING C,
(select TRIM(n.AppType) AS AppType,SUM(m.GETMONEY+m.GETINTEREST)AS getmoney,COUNT(DISTINCT m.EdorAcceptNo) AS SUM
  from lis.lpedoritem m
  LEFT JOIN LIS.LPEdorApp n
  ON M.EdorAcceptNo = n.EdorAcceptNo
where (m.edorappdate = Trunc(SYSDATE)-1 OR M.EdorValiDate = Trunc(SYSDATE)-1) --日期
   and exists (select 1
          from lis.lccont t
         where t.conttype = '1'
           and t.appflag in ('1', '4')
           and t.managecom like '8647%' 
           and t.contno = m.contno)
   AND m.EdorState<>'7'
GROUP BY TRIM(n.AppType)
ORDER BY TRIM(n.AppType)) T 
WHERE TRIM(C.OLD_CODE) = T.AppType AND C.REMARK IS NULL AND C.CODETYPE='SERVICE_TYPE'
ORDER BY C.NEW_CODE;

