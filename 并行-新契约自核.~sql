/*-----------------------------------------------------------------------------------------------------------------
//////////////////////////////////////////--老核心指标--/////////////////////////////////////////////////////
-----------------------------------------------------------------------------------------------------------------*/
SELECT 
       (CASE WHEN ROWNUM = 1 THEN 
             (SELECT COUNT(DISTINCT T.CONTNO)
                   FROM LIS.LCUWSUB T
                   LEFT JOIN LIS.LCPOL T1
                    ON T.POLNO = T1.POLNO --保单号
                    AND T.PROPOSALNO = T1.PROPOSALNO --投保单号
                   WHERE 1 = 1
                   AND T.AUTOUWFLAG = '1' --自核
                   AND T.STATE = '9' --9 - 标准承保
                   AND T.UWNO = '1'
                   AND EXISTS (SELECT 1
                                FROM LIS.LCCONT A
                               WHERE T.CONTNO = A.CONTNO
                                 AND A.CONTTYPE = '1'
                                 AND A.APPFLAG = '1') -- 1-承保
                   AND T.MAKEDATE = DATE '2015-12-31' --入机日期
                   AND T.MANAGECOM LIKE '8647%' --机构
             )
        END) 自核通过件数,
       (CASE WHEN ROWNUM = 1 THEN 
             (SELECT COUNT(DISTINCT T.CONTNO)
                 FROM LIS.LCUWSUB T
                 LEFT JOIN LIS.LCPOL T1
                  ON T.POLNO = T1.POLNO --保单号
                  AND T.PROPOSALNO = T1.PROPOSALNO --投保单号
                 WHERE 1 = 1
                 AND T.AUTOUWFLAG = '1' --自核
                 AND T.STATE = '5' --5 - 未通过自动核保
                 AND T.UWNO = '1'
                 AND EXISTS (SELECT 1
                              FROM LIS.LCCONT A
                             WHERE T.CONTNO = A.CONTNO
                               AND A.CONTTYPE = '1'
                               AND A.APPFLAG = '1') -- 1-承保
                 AND T.MAKEDATE = DATE '2015-12-31' --入机时间
                 AND T.MANAGECOM LIKE '8647%') --机构
        END) 自核不通过件数
       FROM LIS.LCPOL
WHERE ROWNUM = 1;  

SELECT T.MAKEDATE 统计日期,
       T.MANAGECOM 管理机构,
       T.CONTNO 保单号,
       T.PROPOSALNO 投保单号,
       T.STATE 自核结论,
       (CASE T.STATE WHEN '9' THEN '通过' WHEN '5' THEN '不通过' ELSE '其他' END) 自核状态
     FROM LIS.LCUWSUB T
     LEFT JOIN LIS.LCPOL T1
      ON T.POLNO = T1.POLNO --保单号
      AND T.PROPOSALNO = T1.PROPOSALNO --投保单号
     WHERE 1 = 1
     AND T.AUTOUWFLAG = '1' --自核
     AND T.UWNO = '1'
     AND T.MAKEDATE = DATE '2015-12-31' --入机时间
     AND EXISTS (SELECT 1
                  FROM LIS.LCCONT A
                 WHERE T.CONTNO = A.CONTNO
                   AND A.CONTTYPE = '1'
                   AND A.APPFLAG = '1') -- 1-承保
     AND T.MANAGECOM LIKE '8647%' --机构
ORDER BY T.CONTNO;
/*-----------------------------------------------------------------------------------------------------------------
//////////////////////////////////////////--新核心指标--/////////////////////////////////////////////////////
-----------------------------------------------------------------------------------------------------------------*/
SELECT 
       (CASE WHEN ROWNUM = 1 THEN 
             (SELECT COUNT(TCM.POLICY_ID)
                 FROM T_CONTRACT_MASTER TCM
                    LEFT JOIN T_PROPOSAL_PROCESS A
                    ON A.POLICY_ID = TCM.POLICY_ID
                 WHERE 1 = 1
                 AND A.PROCESS_STEP = '17'
                 AND TCM.ORGAN_CODE LIKE '8647%' --机构
                 AND A.UPDATE_TIME = DATE '2017-12-12') --更新记录日期
        END) 自核通过件数,
       (CASE WHEN ROWNUM = 1 THEN 
             (SELECT COUNT(TCM.POLICY_ID)
                 FROM T_CONTRACT_MASTER TCM
                    LEFT JOIN T_PROPOSAL_PROCESS A
                    ON A.POLICY_ID = TCM.POLICY_ID
                 WHERE 1 = 1
                 AND A.PROCESS_STEP = '18'
                 AND TCM.ORGAN_CODE LIKE '8647%' --机构
                 AND A.UPDATE_TIME = DATE '2017-12-12') --更新记录日期
        END) 自核不通过件数
       FROM T_CONTRACT_MASTER
WHERE ROWNUM = 1;  

SELECT A.UPDATE_TIME 统计日期,
       TCM.ORGAN_CODE 管理机构,
       TCM.POLICY_CODE 保单号,
       A.APPLY_CODE 投保单号,
       A.PROCESS_STEP 自核结论,
       (CASE A.PROCESS_STEP WHEN '17' THEN '通过' WHEN '18' THEN '不通过' ELSE '其他' END) 自核状态
       FROM T_CONTRACT_MASTER TCM
            LEFT JOIN T_PROPOSAL_PROCESS A
            ON A.POLICY_ID = TCM.POLICY_ID
       WHERE 1 = 1
            AND TCM.ORGAN_CODE LIKE '8647%' --机构
            AND A.UPDATE_TIME = DATE '2017-12-12' --更新记录日期
ORDER BY TCM.POLICY_CODE;
