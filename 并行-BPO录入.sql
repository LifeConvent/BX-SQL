SELECT * FROM APP___NB__DBUSER.T_BPO_ENTRY_DETAIL; --BPO录入明细 APPLY_CODE POLICY_ID SEND_DATE SEND_STATE RECEIVE_DATE
SELECT * FROM APP___NB__DBUSER.T_ISSUE_LIST; --问题件列表
SELECT * FROM APP___NB__DBUSER.T_ISSUE_STATUS; --回访问题件处理状态表 码表
SELECT * FROM APP___NB__DBUSER.T_ISSUE_CLASS; --问题件分类表 码表
SELECT * FROM APP___NB__DBUSER.T_ISSUE_SOURCE; --问题件来源表 码表
SELECT * FROM APP___NB__DBUSER.T_SEND_STATE; --发送状态 码表
SELECT * FROM APP___NB__DBUSER.T_RECEIVE_STATE; --返回状态 码表
SELECT * FROM APP___NB__DBUSER.T_OPER_ISSUE; --操作员问题件标记 码表



/*************************************  新核心新BPO录入详细  **************************************/
SELECT TCM.POLICY_CODE 保单号,
       TBED.APPLY_CODE 投保单号,
       A.PROCESS_STEP 自核结论,
       (CASE A.PROCESS_STEP WHEN '17' THEN '通过' WHEN '18' THEN '不通过' ELSE '其他' END) 自核状态,
       (CASE TBED.SEND_STATE WHEN '0' THEN '失败' WHEN '1' THEN '成功' ELSE '其他' END) 发送状态,
       (CASE TBED.RECEIVE_STATE WHEN '3' THEN '失败' WHEN '2' THEN '成功' ELSE '其他' END) 接收状态,
       (CASE TIL.ISSUE_SOURCE WHEN '07' THEN '是' ELSE '否' END) 是否问题件
       --TIL.ISSUE_STATE 问题件状态
       FROM APP___NB__DBUSER.T_BPO_ENTRY_DETAIL TBED
            LEFT JOIN APP___NB__DBUSER.T_ISSUE_LIST TIL
            ON TIL.APPLY_CODE = TBED.APPLY_CODE
            LEFT JOIN APP___NB__DBUSER.T_PROPOSAL_PROCESS A
            ON A.POLICY_ID = TBED.POLICY_ID
            LEFT JOIN DEV_PAS.T_CONTRACT_MASTER TCM
            ON A.POLICY_ID = TCM.POLICY_ID
       WHERE 1 = 1
       AND ((TBED.SEND_STATE = '1' AND TBED.SEND_DATE = DATE '2017-12-12')--发送成功日期
        OR (TBED.RECEIVE_DATE = '1' AND TBED.RECEIVE_DATE = DATE '2017-12-12'))--接收成功日期
       AND TIL.ISSUE_ORGAN LIKE '8647%' --问题件所在机构
       AND TBED.ORGAN_CODE LIKE '8647%'
ORDER BY TCM.POLICY_CODE;


/*************************************  新核心新BPO录入统计  **************************************/    
SELECT 
       (CASE WHEN ROWNUM = 1 THEN 
             (SELECT COUNT(TBED.POLICY_ID)  
                 FROM APP___NB__DBUSER.T_BPO_ENTRY_DETAIL TBED
                 WHERE 1 = 1
                 AND TBED.SEND_STATE = '1' --发送成功
                 AND TBED.ORGAN_CODE LIKE '8647%' --机构
                 AND TBED.SEND_DATE = DATE '2017-12-12') --发送日期
        END) 外包录入件数,
       (CASE WHEN ROWNUM = 1 THEN 
             (SELECT COUNT(TBED.POLICY_ID) 
                 FROM APP___NB__DBUSER.T_BPO_ENTRY_DETAIL TBED
                 WHERE 1 = 1
                 AND TBED.RECEIVE_STATE = '2' --接收成功
                 AND TBED.ORGAN_CODE LIKE '8647%' --机构
                 AND TBED.RECEIVE_DATE = DATE '2017-12-12') --返回日期
        END) 外包回传件数,
       (CASE WHEN ROWNUM = 1 THEN 
             (SELECT COUNT(TBED.POLICY_ID) 
                 FROM APP___NB__DBUSER.T_BPO_ENTRY_DETAIL TBED
                      LEFT JOIN APP___NB__DBUSER.T_ISSUE_LIST TIL
                      ON TIL.APPLY_CODE = TBED.APPLY_CODE
                 WHERE 1 = 1
                 AND TIL.ISSUE_SOURCE = '07' --BPO问题件
                 AND TIL.ISSUE_ORGAN LIKE '8647%' --问题件所在机构
                 AND TBED.ORGAN_CODE LIKE '8647%' --保单管理机构
                 AND TIL.INPUT_DATE = DATE '2017-12-12') --输入日期
        END) 问题件件数,
       (CASE WHEN ROWNUM = 1 THEN 
             (SELECT COUNT(TBED.POLICY_ID)
                 FROM APP___NB__DBUSER.T_BPO_ENTRY_DETAIL TBED
                 LEFT JOIN APP___NB__DBUSER.T_PROPOSAL_PROCESS A
                 ON A.POLICY_ID = TBED.POLICY_ID
                 WHERE 1 = 1
                 AND A.PROCESS_STEP = '17' --自核通过
                 --AND TBED.SEND_STATE = '1' --发送成功
                 AND TBED.ORGAN_CODE LIKE '8647%' --机构
                 AND TBED.SEND_DATE = DATE '2017-12-12') --发送日期
        END) 自核通过件数,
       (CASE WHEN ROWNUM = 1 THEN 
             (SELECT COUNT(TBED.POLICY_ID)
                 FROM APP___NB__DBUSER.T_BPO_ENTRY_DETAIL TBED
                 LEFT JOIN APP___NB__DBUSER.T_PROPOSAL_PROCESS A
                 ON A.POLICY_ID = TBED.POLICY_ID
                 WHERE 1 = 1
                 AND A.PROCESS_STEP = '18' --自核不通过
                 --AND TBED.SEND_STATE = '1' --发送成功
                 AND TBED.ORGAN_CODE LIKE '8647%' --机构
                 AND TBED.SEND_DATE = DATE '2017-12-12') --发送日期
        END) 自核不通过件数
       FROM APP___NB__DBUSER.T_BPO_ENTRY_DETAIL TBED
WHERE ROWNUM = 1;  

/*
SELECT COUNT(TBED.POLICY_ID) 外包录入件数 
       FROM APP___NB__DBUSER.T_BPO_ENTRY_DETAIL TBED
       WHERE 1 = 1
       AND TBED.SEND_STATE = '1' --发送成功
       AND TBED.ORGAN_CODE LIKE '8647%' --机构
       AND TBED.SEND_DATE = DATE '2017-12-12'; --发送日期
       
SELECT COUNT(TBED.POLICY_ID) 外包回传件数 
       FROM APP___NB__DBUSER.T_BPO_ENTRY_DETAIL TBED
       WHERE 1 = 1
       AND TBED.RECEIVE_STATE = '2' --接收成功
       AND TBED.ORGAN_CODE LIKE '8647%' --机构
       AND TBED.RECEIVE_DATE = DATE '2017-12-12'; --返回日期
       
SELECT COUNT(TBED.POLICY_ID) 问题件件数 
       FROM APP___NB__DBUSER.T_BPO_ENTRY_DETAIL TBED
            LEFT JOIN APP___NB__DBUSER.T_ISSUE_LIST TIL
            ON TIL.APPLY_CODE = TBED.APPLY_CODE
       WHERE 1 = 1
       AND TIL.ISSUE_SOURCE = '07' --BPO问题件
       AND TIL.ISSUE_ORGAN LIKE '8647%' --问题件所在机构
       AND TBED.ORGAN_CODE LIKE '8647%' --保单管理机构
       AND TIL.INPUT_DATE = DATE '2017-12-12'; --输入日期

SELECT COUNT(TBED.POLICY_ID) 自核通过件数 
       FROM APP___NB__DBUSER.T_BPO_ENTRY_DETAIL TBED
       LEFT JOIN APP___NB__DBUSER.T_PROPOSAL_PROCESS A
       ON A.POLICY_ID = TBED.POLICY_ID
       WHERE 1 = 1
       AND A.PROCESS_STEP = '17' --自核通过
       --AND TBED.SEND_STATE = '1' --发送成功
       AND TBED.ORGAN_CODE LIKE '8647%' --机构
       AND TBED.SEND_DATE = DATE '2017-12-12'; --发送日期
       
SELECT COUNT(TBED.POLICY_ID) 自核不通过件数
       FROM APP___NB__DBUSER.T_BPO_ENTRY_DETAIL TBED
       LEFT JOIN APP___NB__DBUSER.T_PROPOSAL_PROCESS A
       ON A.POLICY_ID = TBED.POLICY_ID
       WHERE 1 = 1
       AND A.PROCESS_STEP = '18' --自核不通过
       --AND TBED.SEND_STATE = '1' --发送成功
       AND TBED.ORGAN_CODE LIKE '8647%' --机构
       AND TBED.SEND_DATE = DATE '2017-12-12'; --发送日期
 */ 

SELECT * FROM LIS.LCUWSUB --个人合同核保轨迹表 PASSFLAG AUTOUWFLAG
SELECT * FROM LIS.LCPOL --险种表 UWFLAG UWDATE 
SELECT * FROM LIS.LOPRTMANAGER --打印管理表 CODE-打印类型
SELECT * FROM LIS.LCOUTSOURCECONTPRINT --外包打印保单表
SELECT * FROM LIS.LCISSUEPOL --问题件表
SELECT * 
       FROM LIS.LCCONT A
       WHERE 1 = 1
       AND A.SIGNDATE = DATE '2015-12-31' --签单日期
       AND A.SIGNCOM LIKE '9647%' --签单机构

/*************************************  老核心BPO录入详细  **************************************/ 
SELECT T.CONTNO 保单号,
       T.PROPOSALNO 投保单号,
       T.STATE 自核结论,
       (CASE T.STATE WHEN '9' THEN '通过' WHEN '5' THEN '不通过' ELSE '其他' END) 自核状态,
       (CASE WHEN TO_CHAR(BPO.SENDOUTDATE,'YYYY-MM-DD') IS NOT NULL THEN '成功' ELSE '失败' END) 发送状态,
       (CASE WHEN TO_CHAR(BPO.RECEIVEDATE,'YYYY-MM-DD') IS NOT NULL THEN '成功' ELSE '失败' END) 接收状态,
       (CASE ISS.BACKOBJ WHEN 'BPO' THEN '是' ELSE '否' END) 是否问题件
     FROM LIS.LCUWSUB T
     LEFT JOIN LIS.LCPOL T1
      ON T.POLNO = T1.POLNO --保单号
      AND T.PROPOSALNO = T1.PROPOSALNO --投保单号
     LEFT JOIN LIS.BPOMISSIONSTATE BPO
      ON T.PROPOSALNO = BPO.BUSSNO --投保单号
      AND BPO.BUSSNOTYPE = 'TB' --新契约
     LEFT JOIN LIS.LCISSUEPOL ISS
      ON T.PROPOSALNO = ISS.CONTNO --投保单号
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
ORDER BY T.CONTNO


/*************************************  老核心BPO统计  **************************************/ 
SELECT 
       (CASE WHEN ROWNUM = 1 THEN 
             (SELECT COUNT(DISTINCT BPO.BUSSNO) 外包录入件数 
                FROM LIS.BPOMISSIONSTATE BPO
                LEFT JOIN LIS.LCISSUEPOL ISS
                ON BPO.BUSSNO = ISS.CONTNO --投保单号
                WHERE 1 = 1
                  AND BPO.BUSSNOTYPE = 'TB' --新契约
                  AND BPO.MANAGECOM LIKE '8647%' --机构
                  AND BPO.SENDOUTDATE = DATE '2015-12-31' --发送日期
             )
        END) 外包录入件数,
       (CASE WHEN ROWNUM = 1 THEN 
             (SELECT COUNT(DISTINCT BPO.BUSSNO) 外包回传件数 
                FROM LIS.BPOMISSIONSTATE BPO
                LEFT JOIN LIS.LCISSUEPOL ISS
                ON BPO.BUSSNO = ISS.CONTNO --投保单号
                WHERE 1 = 1
                  AND BPO.BUSSNOTYPE = 'TB' --新契约
                  AND BPO.MANAGECOM LIKE '8647%' --机构
                  AND BPO.RECEIVEDATE = DATE '2015-12-31' --接收日期
             )
        END) 外包回传件数,
       (CASE WHEN ROWNUM = 1 THEN 
             (SELECT COUNT(DISTINCT BPO.BUSSNO)
                FROM LIS.BPOMISSIONSTATE BPO
                LEFT JOIN LIS.LCISSUEPOL ISS
                ON BPO.BUSSNO = ISS.CONTNO --投保单号
                WHERE 1 = 1
                  AND BPO.BUSSNOTYPE = 'TB' --新契约
                  AND BPO.MANAGECOM LIKE '8647%' --机构
                  AND BPO.RECEIVEDATE = DATE '2015-12-31' --接收日期    
                  AND ISS.BACKOBJ = 'BPO' --BPO问题件
             )
        END) 问题件件数,
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

SELECT COUNT(DISTINCT T.CONTNO) AS 自核未通过件数
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
     AND T.MANAGECOM LIKE '8647%' --机构
     
SELECT COUNT(DISTINCT T.CONTNO) AS 自核通过件数
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

--STATE 码值 发送接收成功

SELECT COUNT(DISTINCT BPO.BUSSNO) 外包录入件数 
  FROM LIS.BPOMISSIONSTATE BPO
  LEFT JOIN LIS.LCISSUEPOL ISS
  ON BPO.BUSSNO = ISS.CONTNO --投保单号
  WHERE 1 = 1
    AND BPO.BUSSNOTYPE = 'TB' --新契约
    AND BPO.MANAGECOM LIKE '8647%' --机构
    AND BPO.SENDOUTDATE = DATE '2015-12-31' --发送日期
    
SELECT COUNT(DISTINCT BPO.BUSSNO) 外包回传件数 
  FROM LIS.BPOMISSIONSTATE BPO
  LEFT JOIN LIS.LCISSUEPOL ISS
  ON BPO.BUSSNO = ISS.CONTNO --投保单号
  WHERE 1 = 1
    AND BPO.BUSSNOTYPE = 'TB' --新契约
    AND BPO.MANAGECOM LIKE '8647%' --机构
    AND BPO.RECEIVEDATE = DATE '2015-12-31' --接收日期
    
SELECT COUNT(DISTINCT BPO.BUSSNO) 问题件件数 
  FROM LIS.BPOMISSIONSTATE BPO
  LEFT JOIN LIS.LCISSUEPOL ISS
  ON BPO.BUSSNO = ISS.CONTNO --投保单号
  WHERE 1 = 1
    AND BPO.BUSSNOTYPE = 'TB' --新契约
    AND BPO.MANAGECOM LIKE '8647%' --机构
    AND BPO.RECEIVEDATE = DATE '2015-12-31' --接收日期    
    AND ISS.BACKOBJ = 'BPO' --BPO问题件
