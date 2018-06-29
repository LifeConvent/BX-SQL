SELECT * FROM LIS.LCELECTRONICPOLICY --电子保单表 发送日期=签发日期
SELECT * FROM LIS.LCECONTSENDHISTORY --历史轨迹表
SELECT * FROM LIS.LCEPSENDERROR --错误信息表


/*************************************  老核心电子保单统计  ************************************/
SELECT 
       (CASE WHEN ROWNUM = 1 THEN 
             (SELECT COUNT(A.CONTNO)  
                 FROM LIS.LCELECTRONICPOLICY A --外包打印
                 LEFT JOIN LIS.LCPOL B
                 ON A.CONTNO = B.CONTNO 
                 WHERE 1=1
                   AND B.CONTTYPE = '1'
                   AND A.MANAGECOM LIKE '8647%' --管理机构
                   AND A.SENDDATE = DATE '2017-12-26') --发送日期
        END) 电子保单发放件数,
        (CASE WHEN ROWNUM = 1 THEN 
            (SELECT COUNT(A.CONTNO) 
               FROM LIS.LCELECTRONICPOLICY A --外包打印
               LEFT JOIN LIS.LCPOL B
               ON A.CONTNO = B.CONTNO 
               WHERE 1=1
                 AND B.CONTTYPE = '1'
                 AND A.LSSUEDATE IS NOT NULL --签收成功
                 AND A.MANAGECOM LIKE '8647%' --管理机构
                 AND A.SENDDATE = DATE '2017-12-26') --发送日期
        END) 电子保单回传件数
       FROM LIS.LCELECTRONICPOLICY A
WHERE ROWNUM = 1;
         
         --(OR A.RECEIVESIGNDATE = DATE '2017-12-26') --回传日期
/*************************************  老核心电子保单详细  ************************************/
SELECT A.CONTNO 保单号,
       B.PRTNO 投保单号,
       --A.MANAGECOM 管理机构,
       --(CASE A.RECEIVEFLAG
           --WHEN '0' THEN '未接收'
           --WHEN '1' THEN '已接收'
        --END) 接受状态,
       --A.RECEIVEFLAG/*0-未接收 1-已接收*/ 接受状态码,
       A.SENDDATE 发送日期,
       A.RECEIVESIGNDATE 回传日期,
       --A.LSSUEDATE 签发日期
       FROM LIS.LCELECTRONICPOLICY A --外包打印
       LEFT JOIN LIS.LCPOL B
       ON A.CONTNO = B.CONTNO 
       WHERE 1=1
         AND B.CONTTYPE = '1'
         AND A.MANAGECOM LIKE '8647%' --管理机构
         AND A.SENDDATE = DATE '2017-12-26' --发送日期
   ORDER BY A.CONTNO
         
         
                       --AND TPP.PRINT_STATUS IN ('3','4','5') -- 3-待打印、4-已打印、5-申请重打
                       --AND BPO_PRINT_DATE = DATE '2017-04-27' --打印日期
                       --AND TPD.RECEIVE_DATE = DATE '2017-04-27' --返回日期
                         --AND TPP.PRINT_STATUS IN ('3','4','5') -- 3-待打印、4-已打印、5-申请重打
                         --AND BPO_PRINT_DATE = DATE '2018-04-09' --打印日期
                         --AND TPD.RECEIVE_DATE = DATE '2018-04-09' --返回日期
/*************************************  新核心BPO制单计数  ************************************/
SELECT 
       (CASE WHEN ROWNUM = 1 THEN 
             (SELECT COUNT(TPP.POLICY_CODE)
                 FROM APP___NB__DBUSER.T_POLICY_PRINT TPP
                 LEFT JOIN APP___NB__DBUSER.T_PRINT_DETAIL TPD
                      ON TPP.POLICY_CODE = TPD.POLICY_CODE
                 LEFT JOIN APP___NB__DBUSER.T_POLICY_PRINT_APPLY TPPA
                      ON TPP.PRINT_ID = TPPA.PRINT_ID
                 WHERE 1 = 1 
                       AND TPP.PRINT_TYPE = '2' --外包打印 1-外包打印、2-电子制单
                       AND TPD.SEND_DATE = DATE '2017-04-27' --发送日期
                       AND TPP.PRINT_ORG LIKE '8647%') --打印机构
        END) 打印任务件数,
       (CASE WHEN ROWNUM = 1 THEN 
             (SELECT COUNT(TPP.POLICY_CODE)
                   FROM APP___NB__DBUSER.T_POLICY_PRINT TPP
                   LEFT JOIN APP___NB__DBUSER.T_PRINT_DETAIL TPD
                        ON TPP.POLICY_CODE = TPD.POLICY_CODE
                   LEFT JOIN APP___NB__DBUSER.T_POLICY_PRINT_APPLY TPPA
                        ON TPP.PRINT_ID = TPPA.PRINT_ID
                   WHERE 1 = 1 
                         AND TPP.PRINT_TYPE = '2' --外包打印 1-外包打印、2-电子制单
                         AND TPPA.APPLY_STATUS = '03' -- 03-打印成功
                         AND TPD.SEND_DATE = DATE '2018-04-09' --发送日期
                         AND TPP.PRINT_ORG LIKE '8647%') --打印机构
        END) 打印成功件数
       FROM APP___NB__DBUSER.T_POLICY_PRINT TPP
WHERE ROWNUM = 1;


             --AND (TPP.PRINT_STATUS IN ('3','4','5') -- 3-待打印、4-已打印、5-申请重打)
             --AND (PRINT_TIME = DATE '2011-07-25' --打印日期
             --OR TPD.RECEIVE_DATE = DATE '2011-07-25' --返回日期
/*************************************  新核心BPO制单详细  **************************************/
SELECT TPP.POLICY_CODE 保单号,
       TPP.APPLY_CODE 投保单号,
       --(CASE TPP.PRINT_TYPE
          -- WHEN '1' THEN '外包打印'
          -- WHEN '2' THEN '电子制单'
        --END) 打印类型,
       --TPP.PRINT_TYPE 打印类型码值,
       --TPP.PRINT_STATUS 打印状态码值,
       --TPP.PRINT_TIME 打印时间,
       --TPP.BPO_PRINT_DATE 外包打印时间,
       TPD.SEND_DATE 发送日期,
       TPD.RECEIVE_DATE 返回日期,
       --PRINT_TIMES/*打印次数*/ 打印次数,
       (CASE TPPA.APPLY_STATUS
           WHEN '04' THEN '失败'
           WHEN '03' THEN '成功'
        END) 打印申请状态,
       TPPA.APPLY_STATUS 打印申请状态码值
       FROM APP___NB__DBUSER.T_POLICY_PRINT TPP
       LEFT JOIN APP___NB__DBUSER.T_PRINT_DETAIL TPD
            ON TPP.POLICY_CODE = TPD.POLICY_CODE
       LEFT JOIN APP___NB__DBUSER.T_POLICY_PRINT_APPLY TPPA
            ON TPP.PRINT_ID = TPPA.PRINT_ID
       WHERE 1 = 1 
             AND TPP.PRINT_TYPE = '2' --外包打印 1-外包打印、2-电子制单
             AND TPD.SEND_DATE = DATE '2011-07-25' --发送日期
             AND TPP.PRINT_ORG LIKE '8647%'
ORDER BY TPP.POLICY_CODE
