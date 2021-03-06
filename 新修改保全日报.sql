
/******************************************************************************************************************************************** 
                                                                 新核心-申请-金额-SQL   
 ********************************************************************************************************************************************/
SELECT C.NEW_CODE_NAME,T.GETMONEY 新核心申请金额 FROM
(SELECT TRIM(TCA.SERVICE_TYPE) AS SERVICE_TYPE,SUM(GETMONEY) AS GETMONEY FROM 
(SELECT TCAC.CHANGE_ID,B.REAL_NAME,TCPA.POLICY_CODE,TCPA.BUSINESS_CODE,TCAC.SERVICE_CODE,CASE 
   WHEN TCPA.ARAP_FLAG='2' THEN -TCPA.FEE_AMOUNT ELSE TCPA.FEE_AMOUNT END AS GETMONEY
    FROM DEV_PAS.T_CS_PREM_ARAP@BINGXING_168_15 TCPA
    LEFT JOIN DEV_PAS.T_CS_ACCEPT_CHANGE@BINGXING_168_15 TCAC
    ON TCAC.ACCEPT_CODE = TCPA.BUSINESS_CODE
    LEFT JOIN DEV_PAS.T_UDMP_USER@BINGXING_168_15 B
    ON TCAC.INSERT_BY = B.USER_ID
    WHERE 1=1
        AND TCPA.DERIV_TYPE = '004'
        AND TCPA.ORGAN_CODE LIKE '8647%'
        AND TCAC.ACCEPT_STATUS NOT IN ('1','2','3','12','19','20','21','24','25')
        AND Trunc(TCPA.BUSI_APPLY_DATE) = Trunc(SYSDATE)-1 --业务申请时间
   UNION
   SELECT TCAC.CHANGE_ID,B.REAL_NAME,TCCM.POLICY_CODE,TCAC.ACCEPT_CODE AS BUSINESS_CODE,TCAC.SERVICE_CODE,0 AS GETMONEY
        FROM DEV_PAS.T_CS_ACCEPT_CHANGE@BINGXING_168_15 TCAC
        LEFT JOIN DEV_PAS.T_CS_CONTRACT_MASTER@BINGXING_168_15 TCCM
        ON TCCM.CHANGE_ID = TCAC.CHANGE_ID
        AND OLD_NEW = '1'
        LEFT JOIN DEV_PAS.T_CS_APPLICATION@BINGXING_168_15 TCA
        ON TCA.CHANGE_ID = TCAC.CHANGE_ID
        LEFT JOIN DEV_PAS.T_UDMP_USER@BINGXING_168_15 B
        ON TCAC.INSERT_BY = B.USER_ID
            WHERE Trunc(TCA.APPLY_TIME) = Trunc(SYSDATE)-1 --申请时间
            AND TCCM.ORGAN_CODE LIKE '8647%'
        AND TCAC.ACCEPT_STATUS NOT IN ('1','2','3','12','19','20','21','24','25')
   ) B 
    LEFT JOIN T_CS_APPLICATION@BINGXING_168_15  TCA
         ON TCA.CHANGE_ID = B.CHANGE_ID
WHERE 1=1
    GROUP BY TRIM(TCA.SERVICE_TYPE)
    ORDER BY TRIM(TCA.SERVICE_TYPE)) T,T_CODEMAPPING C WHERE
    TRIM(C.NEW_CODE) = T.SERVICE_TYPE AND C.REMARK IS NULL AND C.CODETYPE='SERVICE_TYPE'
ORDER BY C.NEW_CODE;


/******************************************************************************************************************************************** 
                                                                 新核心-申请-计数-SQL   
 ********************************************************************************************************************************************/
SELECT C.NEW_CODE_NAME,T.SUM 新核心申请计数 FROM
(SELECT TRIM(TCA.SERVICE_TYPE) AS SERVICE_TYPE,COUNT(DISTINCT B.CHANGE_ID) AS SUM FROM 
(SELECT TCAC.CHANGE_ID,B.REAL_NAME,TCPA.POLICY_CODE,TCPA.BUSINESS_CODE,TCAC.SERVICE_CODE
    FROM DEV_PAS.T_CS_PREM_ARAP@BINGXING_168_15 TCPA
    LEFT JOIN DEV_PAS.T_CS_ACCEPT_CHANGE@BINGXING_168_15 TCAC
    ON TCAC.ACCEPT_CODE = TCPA.BUSINESS_CODE
    LEFT JOIN DEV_PAS.T_UDMP_USER@BINGXING_168_15 B
    ON TCAC.INSERT_BY = B.USER_ID
    WHERE 1=1
        AND TCPA.DERIV_TYPE = '004'
        AND TCPA.ORGAN_CODE LIKE '8647%'
        AND TCAC.ACCEPT_STATUS NOT IN ('1','2','3','12','19','20','21','24','25')
        AND Trunc(TCPA.BUSI_APPLY_DATE) = Trunc(SYSDATE)-1 --业务申请时间
   UNION
   SELECT TCAC.CHANGE_ID,B.REAL_NAME,TCCM.POLICY_CODE,TCAC.ACCEPT_CODE AS BUSINESS_CODE,TCAC.SERVICE_CODE
        FROM DEV_PAS.T_CS_APPLICATION@BINGXING_168_15 TCA
        LEFT JOIN DEV_PAS.T_CS_ACCEPT_CHANGE@BINGXING_168_15 TCAC
        ON TCA.CHANGE_ID = TCAC.CHANGE_ID
        LEFT JOIN DEV_PAS.T_CS_CONTRACT_MASTER@BINGXING_168_15 TCCM
        ON TCCM.CHANGE_ID = TCAC.CHANGE_ID
        AND OLD_NEW = '1'
        LEFT JOIN DEV_PAS.T_UDMP_USER@BINGXING_168_15 B
        ON TCAC.INSERT_BY = B.USER_ID
            WHERE Trunc(TCA.APPLY_TIME) = Trunc(SYSDATE)-1 --申请时间
            AND TCCM.ORGAN_CODE LIKE '8647%'
            AND TCAC.ACCEPT_STATUS NOT IN ('1','2','3','12','19','20','21','24','25')
   ) B 
    LEFT JOIN T_CS_APPLICATION@BINGXING_168_15  TCA
         ON TCA.CHANGE_ID = B.CHANGE_ID
WHERE 1=1
    GROUP BY TRIM(TCA.SERVICE_TYPE)
    ORDER BY TRIM(TCA.SERVICE_TYPE)) T,T_CODEMAPPING C WHERE
    TRIM(C.NEW_CODE) = T.SERVICE_TYPE AND C.REMARK IS NULL AND C.CODETYPE='SERVICE_TYPE'
ORDER BY C.NEW_CODE;


/******************************************************************************************************************************************** 
                                                               老核心-申请-金额-SQL  
 ********************************************************************************************************************************************/
select /*+PARALLEL(80)*/C.NEW_CODE_NAME,T.getmoney 老核心申请金额 FROM T_CODEMAPPING C,
(select TRIM(n.AppType) AS AppType,SUM(m.GETMONEY)AS getmoney
  from LIS.LPEdorApp n
  LEFT JOIN lis.lpedoritem m
  ON m.EdorAcceptNo = n.EdorAcceptNo
where n.EdorAppDate = Trunc(SYSDATE)-1--申请日期
   and exists (select 1
          from lis.lccont t
         where t.conttype = '1'
           and t.appflag in ('1', '4')
           and t.managecom like '8647%' 
           and t.contno = m.contno)
   AND m.EdorState NOT IN ('7','b','0','1','2')
GROUP BY TRIM(n.AppType)
ORDER BY TRIM(n.AppType)) T 
WHERE TRIM(C.OLD_CODE) = T.AppType AND C.REMARK IS NULL AND C.CODETYPE='SERVICE_TYPE'
ORDER BY C.NEW_CODE;


/******************************************************************************************************************************************** 
                                                               老核心-申请-计数-SQL  
 ********************************************************************************************************************************************/
select /*+PARALLEL(80)*/C.NEW_CODE_NAME,T.SUM 老核心申请计数 FROM T_CODEMAPPING C,
(select TRIM(n.AppType) AS AppType,COUNT(DISTINCT m.EdorAcceptNo) AS SUM
  from LIS.LPEdorApp n
  LEFT JOIN lis.lpedoritem m
  ON m.EdorAcceptNo = n.EdorAcceptNo
where n.EdorAppDate = Trunc(SYSDATE)-1--申请日期
   and exists (select 1
          from lis.lccont t
         where t.conttype = '1'
           and t.appflag in ('1', '4')
           and t.managecom like '8647%' 
           and t.contno = m.contno)
   AND m.EdorState NOT IN ('7','b','0','1','2')
GROUP BY TRIM(n.AppType)
ORDER BY TRIM(n.AppType)) T 
WHERE TRIM(C.OLD_CODE) = T.AppType AND C.REMARK IS NULL AND C.CODETYPE='SERVICE_TYPE'
ORDER BY C.NEW_CODE;

/******************************************************************************************************************************************** 
                                                               新核心-生效-金额-SQL  
 ********************************************************************************************************************************************/
SELECT C.NEW_CODE_NAME,T.GETMONEY 新核心生效金额 FROM
(SELECT TRIM(TCA.SERVICE_TYPE) AS SERVICE_TYPE,SUM(GETMONEY) AS GETMONEY FROM 
(SELECT TCAC.CHANGE_ID,B.REAL_NAME,TCPA.POLICY_CODE,TCPA.BUSINESS_CODE,TCAC.SERVICE_CODE,CASE 
   WHEN TCPA.ARAP_FLAG='2' THEN -TCPA.FEE_AMOUNT ELSE TCPA.FEE_AMOUNT END AS GETMONEY
    FROM DEV_PAS.T_CS_PREM_ARAP@BINGXING_168_15 TCPA
    LEFT JOIN DEV_PAS.T_CS_ACCEPT_CHANGE@BINGXING_168_15 TCAC
    ON TCAC.ACCEPT_CODE = TCPA.BUSINESS_CODE
    LEFT JOIN DEV_PAS.T_UDMP_USER@BINGXING_168_15 B
    ON TCAC.INSERT_BY = B.USER_ID
    WHERE 1=1
        AND TCPA.DERIV_TYPE = '004'
        AND TCPA.ORGAN_CODE LIKE '8647%'
        AND TCAC.ACCEPT_STATUS NOT IN ('1','2','3','12','19','20','21','24','25')
        AND Trunc(TCAC.VALIDATE_TIME) = Trunc(SYSDATE)-1 --生效时间
   UNION
   SELECT TCAC.CHANGE_ID,B.REAL_NAME,TCCM.POLICY_CODE,TCAC.ACCEPT_CODE AS BUSINESS_CODE,TCAC.SERVICE_CODE,0 AS GETMONEY
        FROM DEV_PAS.T_CS_ACCEPT_CHANGE@BINGXING_168_15 TCAC
        LEFT JOIN DEV_PAS.T_CS_CONTRACT_MASTER@BINGXING_168_15 TCCM
        ON TCCM.CHANGE_ID = TCAC.CHANGE_ID
        AND OLD_NEW = '1'
        LEFT JOIN DEV_PAS.T_CS_APPLICATION@BINGXING_168_15 TCA
        ON TCA.CHANGE_ID = TCAC.CHANGE_ID
        LEFT JOIN DEV_PAS.T_UDMP_USER@BINGXING_168_15 B
        ON TCAC.INSERT_BY = B.USER_ID
            WHERE Trunc(TCAC.VALIDATE_TIME) = Trunc(SYSDATE)-1 --生效时间
            AND TCCM.ORGAN_CODE LIKE '8647%'
        AND TCAC.ACCEPT_STATUS NOT IN ('1','2','3','12','19','20','21','24','25')
   ) B 
    LEFT JOIN T_CS_APPLICATION@BINGXING_168_15  TCA
         ON TCA.CHANGE_ID = B.CHANGE_ID
WHERE 1=1
    GROUP BY TRIM(TCA.SERVICE_TYPE)
    ORDER BY TRIM(TCA.SERVICE_TYPE)) T,T_CODEMAPPING C WHERE
    TRIM(C.NEW_CODE) = T.SERVICE_TYPE AND C.REMARK IS NULL AND C.CODETYPE='SERVICE_TYPE'
ORDER BY C.NEW_CODE;


/******************************************************************************************************************************************** 
                                                                 新核心-生效-计数-SQL   
 ********************************************************************************************************************************************/
SELECT C.NEW_CODE_NAME,T.SUM 新核心生效计数 FROM
(SELECT TRIM(TCA.SERVICE_TYPE) AS SERVICE_TYPE,COUNT(DISTINCT B.CHANGE_ID) AS SUM FROM 
(SELECT TCAC.CHANGE_ID,B.REAL_NAME,TCPA.POLICY_CODE,TCPA.BUSINESS_CODE,TCAC.SERVICE_CODE
    FROM DEV_PAS.T_CS_PREM_ARAP@BINGXING_168_15 TCPA
    LEFT JOIN DEV_PAS.T_CS_ACCEPT_CHANGE@BINGXING_168_15 TCAC
    ON TCAC.ACCEPT_CODE = TCPA.BUSINESS_CODE
    LEFT JOIN DEV_PAS.T_UDMP_USER@BINGXING_168_15 B
    ON TCAC.INSERT_BY = B.USER_ID
    WHERE 1=1
        AND TCPA.DERIV_TYPE = '004'
        AND TCPA.ORGAN_CODE LIKE '8647%'
        AND TCAC.ACCEPT_STATUS NOT IN ('1','2','3','12','19','20','21','24','25')
        --AND Trunc(TCPA.BUSI_APPLY_DATE) = Trunc(SYSDATE)-1 --业务申请时间
        AND Trunc(TCAC.VALIDATE_TIME) = Trunc(SYSDATE)-1 --生效时间
   UNION
   SELECT TCAC.CHANGE_ID,B.REAL_NAME,TCCM.POLICY_CODE,TCAC.ACCEPT_CODE AS BUSINESS_CODE,TCAC.SERVICE_CODE
        FROM DEV_PAS.T_CS_APPLICATION@BINGXING_168_15 TCA
        LEFT JOIN DEV_PAS.T_CS_ACCEPT_CHANGE@BINGXING_168_15 TCAC
        ON TCA.CHANGE_ID = TCAC.CHANGE_ID
        LEFT JOIN DEV_PAS.T_CS_CONTRACT_MASTER@BINGXING_168_15 TCCM
        ON TCCM.CHANGE_ID = TCAC.CHANGE_ID
        AND OLD_NEW = '1'
        LEFT JOIN DEV_PAS.T_UDMP_USER@BINGXING_168_15 B
        ON TCAC.INSERT_BY = B.USER_ID
            WHERE Trunc(TCAC.VALIDATE_TIME) = Trunc(SYSDATE)-1 --生效时间
            AND TCCM.ORGAN_CODE LIKE '8647%'
            AND TCAC.ACCEPT_STATUS NOT IN ('1','2','3','12','19','20','21','24','25')
   ) B 
    LEFT JOIN T_CS_APPLICATION@BINGXING_168_15  TCA
         ON TCA.CHANGE_ID = B.CHANGE_ID
WHERE 1=1
    GROUP BY TRIM(TCA.SERVICE_TYPE)
    ORDER BY TRIM(TCA.SERVICE_TYPE)) T,T_CODEMAPPING C WHERE
    TRIM(C.NEW_CODE) = T.SERVICE_TYPE AND C.REMARK IS NULL AND C.CODETYPE='SERVICE_TYPE'
ORDER BY C.NEW_CODE;


/******************************************************************************************************************************************** 
                                                               老核心-生效-金额-SQL  
 ********************************************************************************************************************************************/
select /*+PARALLEL(80)*/C.NEW_CODE_NAME,T.getmoney 老核心生效金额 FROM T_CODEMAPPING C,
(select TRIM(n.AppType) AS AppType,SUM(m.GETMONEY)AS getmoney
  from lis.lpedoritem m
  LEFT JOIN LIS.LPEdorApp n
  ON m.EdorAcceptNo = n.EdorAcceptNo
where m.EdorValiDate = Trunc(SYSDATE)-1--生效日期
   and exists (select 1
          from lis.lccont t
         where t.conttype = '1'
           and t.appflag in ('1', '4')
           and t.managecom like '8647%' 
           and t.contno = m.contno)
   AND m.EdorState NOT IN ('7','b','0','1','2')
GROUP BY TRIM(n.AppType)
ORDER BY TRIM(n.AppType)) T 
WHERE TRIM(C.OLD_CODE) = T.AppType AND C.REMARK IS NULL AND C.CODETYPE='SERVICE_TYPE'
ORDER BY C.NEW_CODE;


/******************************************************************************************************************************************** 
                                                               老核心-生效-计数-SQL  
 ********************************************************************************************************************************************/
select /*+PARALLEL(80)*/C.NEW_CODE_NAME,T.SUM 老核心生效计数 FROM T_CODEMAPPING C,
(select TRIM(n.AppType) AS AppType,COUNT(DISTINCT m.EdorAcceptNo) AS SUM
  from lis.lpedoritem m
  LEFT JOIN LIS.LPEdorApp n
  ON m.EdorAcceptNo = n.EdorAcceptNo
where m.EdorValiDate = Trunc(SYSDATE)-1--生效日期
   and exists (select 1
          from lis.lccont t
         where t.conttype = '1'
           and t.appflag in ('1', '4')
           and t.managecom like '8647%' 
           and t.contno = m.contno)
   AND m.EdorState NOT IN ('7','b','0','1','2')
GROUP BY TRIM(n.AppType)
ORDER BY TRIM(n.AppType)) T 
WHERE TRIM(C.OLD_CODE) = T.AppType AND C.REMARK IS NULL AND C.CODETYPE='SERVICE_TYPE'
ORDER BY C.NEW_CODE;

