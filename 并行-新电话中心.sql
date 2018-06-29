       

/*************************************  新核心新电话中心统计  **************************************/  
SELECT 
       (CASE WHEN ROWNUM = 1 THEN 
             (SELECT COUNT(DISTINCT TCM.POLICY_CODE) 
                 FROM APP___PAS__DBUSER.T_CONTRACT_MASTER TCM
                 LEFT JOIN APP___NB__DBUSER.T_CONTRACT_CALL TCC
                      ON TCM.APPLY_CODE = TCC.APPLY_CODE
                 WHERE 1=1 
                 AND TCC.CALL_SOURCE = '1' --承保回访
                 AND TCM.CHANNEL_TYPE = '05' --电话直销
                 AND TO_CHAR(TCM.ISSUE_DATE, 'YYYY-MM-DD') = '2012-01-16' --承保日期
                 AND TCM.ORGAN_CODE LIKE '8647%')  --管理机构
        END) 电话中心承保回访件数,
       (CASE WHEN ROWNUM = 1 THEN 
             (SELECT COUNT(DISTINCT TRAIL.POLICY_CODE)  
                 FROM APP___NB__DBUSER.T_PROPOSAL_PROCESS TRAIL
                 LEFT JOIN APP___PAS__DBUSER.T_CONTRACT_MASTER TCM
                      ON TCM.POLICY_CODE = TRAIL.POLICY_CODE
                      WHERE 1 = 1
                       AND TRAIL.PROCESS_STEP = '251' --电话中心请求打印
                       AND TCM.ORGAN_CODE LIKE '8647%' --管理机构
                       AND TO_CHAR(TRAIL.START_TIME, 'YYYY-MM-DD') = '2012-01-16') --流程开始时间
        END) 电话中心打印申请件数
       FROM APP___NB__DBUSER.T_PROPOSAL_PROCESS TRAIL
WHERE ROWNUM = 1;     

/*************************************  --------------------  **************************************/
SELECT * FROM APP___NB__DBUSER.T_CONTRACT_CALL TCC
       WHERE TCC.CALL_STATUS = 1 --回访成功
       AND TCC.CALL_TYPE = 1 --电话回访
       AND TCC.CALL_SOURCE = '1'; --承保回访
       
SELECT * FROM APP___NB__DBUSER.T_PROPOSAL_PROCESS TRAIL WHERE TRAIL.PROCESS_STEP = '251' --电话中心请求打印
            ON TCM.POLICY_CODE = TRAIL.POLICY_CODE
            AND TRAIL.PROCESS_STEP = '251' --电话中心请求打印

/*************************************  新核心新电话中心详细  **************************************/

/****** 电话中心承保SQL+打印申请SQL ******/
SELECT TCM.ORGAN_CODE 机构,
       TCM.APPLY_CODE 投保单号,
       TCM.POLICY_CODE 保单号,
       TO_CHAR(TCM.ISSUE_DATE, 'YYYY-MM-DD') 承保日期,/*承保日期字符*/
       (CASE TCM.CHANNEL_TYPE WHEN '05' THEN '电话直销' ELSE '其他' END) 销售渠道,
       (CASE TCC.CALL_STATUS
           WHEN 1 THEN '成功'
           WHEN 2 THEN '失败'
           ELSE '无'
        END) 回访状态, 
       --TCC.CALL_STATUS 回访状态码值, --回访状态码值
       --TCC.CALL_SOURCE 回访来源,
       (CASE
           WHEN TO_CHAR(TCC.CALL_TYPE) IS NOT NULL THEN TO_CHAR(TCC.CALL_TYPE)
           ELSE '无'
        END) 回访方式,
       (CASE TRAIL.PROCESS_STEP
           WHEN '251' THEN '是'
           ELSE '否'
        END) 是否电话中心打印申请,
       (CASE TRAIL.PROCESS_STEP
           WHEN '251' THEN TO_CHAR(TRAIL.START_TIME, 'YYYY-MM-DD')
           ELSE '无'
        END) 打印申请日期
       FROM DEV_PAS.T_CONTRACT_MASTER TCM
       LEFT JOIN APP___NB__DBUSER.T_CONTRACT_CALL TCC
          ON TCM.APPLY_CODE = TCC.APPLY_CODE
       LEFT JOIN APP___NB__DBUSER.T_PROPOSAL_PROCESS TRAIL
          ON TCM.POLICY_CODE = TRAIL.POLICY_CODE
       WHERE 1=1 
       --AND TCC.CALL_TYPE = 1 --电话回访
       AND TCM.ORGAN_CODE LIKE '8647%' --管理机构
       AND ((
           TCC.CALL_SOURCE = '1' --承保回访
           AND TCM.CHANNEL_TYPE = '05' --电话直销
           AND TO_CHAR(TCM.ISSUE_DATE, 'YYYY-MM-DD') = '2012-01-16' --承保日期
       )
       OR (
          TRAIL.PROCESS_STEP = '251' --电话中心请求打印
          AND TO_CHAR(TRAIL.START_TIME, 'YYYY-MM-DD') = '2012-01-16' --电话打印申请日期
       ))
ORDER BY TCM.APPLY_CODE
/****** 电话中心承保SQL *****
SELECT TCM.POLICY_CODE 保单号,
       TCM.APPLY_CODE 投保单号,
       TO_CHAR(TCM.ISSUE_DATE, 'YYYY-MM-DD') 承保日期,承保日期
       TCM.CHANNEL_TYPE 销售渠道,
       --TCM.ORGAN_CODE 管理机构,
       (CASE TCC.CALL_STATUS
           WHEN 1 THEN '成功'
           WHEN 2 THEN '失败'
           ELSE '无'
        END) 回访状态,
       --TCC.CALL_STATUS 回访状态码值, --回访状态码值
       (CASE
           WHEN TCC.CALL_TYPE IS NOT NULL THEN TCC.CALL_TYPE
           ELSE '否'
        END) 回访方式
       --TCC.CALL_SOURCE 回访来源
       FROM DEV_PAS.T_CONTRACT_MASTER TCM
       LEFT JOIN APP___NB__DBUSER.T_CONTRACT_CALL TCC
            ON TCM.APPLY_CODE = TCC.APPLY_CODE
       WHERE 1=1 
       --AND TCC.CALL_TYPE = 1 --电话回访
       AND TCC.CALL_SOURCE = '1' --承保回访
       AND TCM.CHANNEL_TYPE = '05' --电话直销
       AND TO_CHAR(TCM.ISSUE_DATE, 'YYYY-MM-DD') = '2012-01-16'
       AND TCM.ORGAN_CODE LIKE '8647%'; --管理机构*/
/****** 打印申请SQL *****
SELECT  TRAIL.POLICY_ID 保单ID,
        TRAIL.POLICY_CODE 保单号,
        TRAIL.APPLY_CODE 投保单号
       FROM APP___NB__DBUSER.T_PROPOSAL_PROCESS TRAIL
       LEFT JOIN DEV_PAS.T_CONTRACT_MASTER TCM
          ON TCM.POLICY_CODE = TRAIL.POLICY_CODE
       WHERE 1 = 1
          AND TRAIL.PROCESS_STEP = '251' --电话中心请求打印
          AND TCM.ORGAN_CODE LIKE '8647%' --管理机构
          AND TO_CHAR(TRAIL.START_TIME, 'YYYY-MM-DD') = '2012-01-16'; --流程开始时间
          --AND TO_CHAR(TRAIL.END_TIME, 'YYYY-MM-DD') = '2012-01-16' --打印机构*/
          
          
SELECT * FROM APP___NB__DBUSER.T_CONTRACT_CALL --保单电话回访信息表
SELECT * FROM APP___NB__DBUSER.T_PROPOSAL_PROCESS --投保单状态轨迹表
SELECT * FROM APP___NB__DBUSER.T_BIZ_CALL --管理电话服务主表
/*************************************  ---------------------  **************************************/
SELECT * FROM LIS.LGCALLBACK --电话回访任务表
SELECT * FROM LIS.LACUSTOMERHFINFO --回访数据同步信息表
SELECT * FROM LIS.LZCARDTRACK --单证轨迹表 销售渠道
SELECT * FROM LIS.LCCONT --个人保单表
/*************************************  老核心新电话中心统计  **************************************/

SELECT 
       (CASE WHEN ROWNUM = 1 THEN 
             (SELECT COUNT(DISTINCT A.CONTNO)
                 FROM LIS.LCCONT A
                 LEFT JOIN LIS.LACUSTOMERHFINFO B
                 ON A.CONTNO = B.CONTNO
                 WHERE 1 = 1
                 AND A.SELLTYPE = '12' --电话直销
                 AND B.CALLRESULT = '1' --回访成功
                 AND A.CONTNO IN (SELECT CONTNO
                                     FROM LIS.LCPOL B
                                     WHERE B.CONTTYPE = '1'
                                     AND B.MANAGECOM LIKE '8647%') --管理机构
                 AND A.SIGNDATE = DATE '2015-12-31') --签单日期
                 --AND B.CALLDATE = DATE '2015-12-31' --回访日期
        END) 承保回访件数,
       (CASE WHEN ROWNUM = 1 THEN 
             (SELECT COUNT(DISTINCT A.CONTNO) 
                 FROM LIS.LCCONT A
                 LEFT JOIN LIS.LCCYBERBANKPOLICY B
                 ON A.CONTNO = B.CONTNO
                 WHERE 1 = 1
                 AND A.CONTNO IN (SELECT CONTNO
                                     FROM LIS.LCPOL B
                                     WHERE B.CONTTYPE = '1'
                                     AND B.MANAGECOM LIKE '8647%') --管理机构
                 AND B.APPLYDATE = DATE '2015-12-31') --申请日期   
                 --AND B.STATE = '0' --打印成功 
        END) 电话中心打印申请件数
       FROM LIS.LCCONT A
WHERE ROWNUM = 1;  

SELECT COUNT(DISTINCT A.CONTNO) 电话中心承保回访件数 
       FROM LIS.LCCONT A
       LEFT JOIN LIS.LACUSTOMERHFINFO B
       ON A.CONTNO = B.CONTNO
       WHERE 1 = 1
       AND A.SELLTYPE = '12' --电话直销
       AND B.CALLRESULT = '1' --回访成功
       AND A.CONTNO IN (SELECT CONTNO
                           FROM LIS.LCPOL B
                           WHERE B.CONTTYPE = '1'
                           AND B.MANAGECOM LIKE '8647%') --管理机构
       AND A.SIGNDATE = DATE '2015-12-31' --签单日期
       --AND B.CALLDATE = DATE '2015-12-31' --回访日期
       
SELECT COUNT(DISTINCT A.CONTNO) 电话中心打印申请件数 
       FROM LIS.LCCONT A
       LEFT JOIN LIS.LCCYBERBANKPOLICY B
       ON A.CONTNO = B.CONTNO
       WHERE 1 = 1
       AND A.CONTNO IN (SELECT CONTNO
                           FROM LIS.LCPOL B
                           WHERE B.CONTTYPE = '1'
                           AND B.MANAGECOM LIKE '8647%') --管理机构
       AND B.APPLYDATE = DATE '2015-12-31' --申请日期   
       --AND B.STATE = '0' --打印成功   
       

/*************************************  老核心新电话中心详细  **************************************/
SELECT A.MANAGECOM 机构,
       A.CONTNO 保单号,
       A.PRTNO 投保单号,
       A.SIGNDATE 承保日期,
       (CASE A.SELLTYPE WHEN '12' THEN '电话直销' ELSE '其他' END) 销售渠道,
       (CASE B.CALLRESULT
           WHEN '0' THEN '成功'
           WHEN '1' THEN '失败'
           ELSE '无'
        END) 回访状态,
       (CASE
           WHEN B.CALLTYPE IS NOT NULL THEN B.CALLTYPE
           ELSE '无'
        END) 回访方式,
       (CASE
           WHEN C.STATE IS NOT NULL THEN '是'
           ELSE '否'
        END) 是否电话中心打印申请,
       (CASE
           WHEN C.STATE IS NOT NULL THEN TO_CHAR(C.APPLYDATE, 'YYYY-MM-DD')
           ELSE '无'
        END) 打印申请日期
       --C.STATE 打印状态
       FROM LIS.LCCONT A
       LEFT JOIN LIS.LACUSTOMERHFINFO B
       ON A.CONTNO = B.CONTNO
       LEFT JOIN LIS.LCCYBERBANKPOLICY C
       ON A.CONTNO = C.CONTNO
         WHERE 1 = 1
               AND A.SELLTYPE = '12' --电话直销
               AND (C.APPLYDATE = DATE '2010-10-25' --打印申请日期
               OR A.SIGNDATE = DATE '2010-10-25') --签单日期
               AND A.CONTNO IN (SELECT CONTNO
                                  FROM LIS.LCPOL B
                                 WHERE B.CONTTYPE = '1'
                                   AND B.MANAGECOM LIKE '8647%') --管理机构
ORDER BY A.CONTNO
                                   
                                   
                             
