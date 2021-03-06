

               --AND (A.PRINTDATE = DATE '2017-12-26' --打印日期
               --OR A.RECEIVEDATE = DATE '2017-12-26') --回传日期

/*************************************  老核心BPO制单统计  ************************************/
SELECT 
       (CASE WHEN ROWNUM = 1 THEN 
             (SELECT COUNT(A.CONTNO)
                 FROM LIS.LCOUTSOURCECONTPRINT A --外包打印
                 LEFT JOIN LIS.LCOUTSOURCESTAMP C
                 ON A.CONTNO = C.CONTNO
                 WHERE 1=1
                   AND C.STATE = '1' -- 1-正常使用
                   AND A.CONTNO IN (SELECT CONTNO
                                      FROM LIS.LCPOL B
                                     WHERE B.CONTTYPE = '1'
                                       AND B.MANAGECOM LIKE '8647%') --管理机构
                   AND C.SealDate = DATE '2017-12-26' --红章印制日期
                   AND A.SENDOUTDATE= DATE '2017-12-26') --发送日期
        END) 红章发放件数,
        (CASE WHEN ROWNUM = 1 THEN 
             (SELECT COUNT(A.CONTNO)
                 FROM LIS.LCOUTSOURCECONTPRINT A --外包打印
                 LEFT JOIN LIS.LCOUTSOURCESTAMP C
                 ON A.CONTNO = C.CONTNO
                 WHERE 1=1
                   AND C.STATE = '2' -- 2-作废
                   AND A.CONTNO IN (SELECT CONTNO
                                      FROM LIS.LCPOL B
                                     WHERE B.CONTTYPE = '1'
                                       AND B.MANAGECOM LIKE '8647%') --管理机构
                   AND C.SealDate = DATE '2017-12-26' --红章印制日期
                   AND A.SENDOUTDATE= DATE '2017-12-26') --发送日期
        END) 红章作废件数,
       (CASE WHEN ROWNUM = 1 THEN 
             (SELECT COUNT(A.CONTNO)
                 FROM LIS.LCOUTSOURCECONTPRINT A --外包打印
                 WHERE 1=1
                   AND A.CONTNO IN (SELECT CONTNO
                                      FROM LIS.LCPOL B
                                     WHERE B.CONTTYPE = '1'
                                       AND B.MANAGECOM LIKE '8647%') --管理机构
                   AND A.SENDOUTDATE= DATE '2017-12-26') --发送日期
        END) 打印任务件数,
       (CASE WHEN ROWNUM = 1 THEN 
             (SELECT COUNT(A.CONTNO) 打印成功件数
             FROM LIS.LCOUTSOURCECONTPRINT A --外包打印
             WHERE 1=1
               AND A.CONTNO IN (SELECT CONTNO
                                  FROM LIS.LCPOL B
                                 WHERE B.CONTTYPE = '1'
                                   AND B.MANAGECOM LIKE '8647%') --管理机构
                   AND A.SENDOUTDATE= DATE '2017-12-26' --发送日期
               AND A.STATE = '1')
        END) 打印成功件数
       FROM LIS.LCOUTSOURCECONTPRINT A
WHERE ROWNUM = 1;

/*************************************  老核心BPO制单详细  ************************************/
SELECT A.MANAGECOM 机构,
       A.CONTNO 保单号,
       (CASE C.STATE
           WHEN '0' THEN '未使用'
           WHEN '1' THEN '正常使用'
           WHEN '2' THEN '作废'
           WHEN '3' THEN '丢失'
        END) 红章状态,
       C.STATE 红章状态码值, -- 0-未使用、1-正常使用、2-作废、3-丢失
       C.PRINTDATE 打印日期,
       A.SENDOUTDATE 发送日期,
       A.RECEIVEDATE 返回日期,
       C.SEALDATE 红章发放日期--, --印制日期
       --C.INVALIDDATE 核销作废日期, --核销作废
       /*(CASE A.STATE
           WHEN '1' THEN '成功'
           WHEN '0' THEN '失败'
           WHEN '-1' THEN '待打印'
        END) 打印状态,
       A.STATE 打印状态码值/*1打印成功,0打印失败,-1待打印*/
       FROM LIS.LCOUTSOURCECONTPRINT A --外包打印
       LEFT JOIN LIS.LCOUTSOURCESTAMP C
       ON A.CONTNO = C.CONTNO
       WHERE 1=1
         AND A.CONTNO IN (SELECT CONTNO
                            FROM LIS.LCPOL B
                           WHERE B.CONTTYPE = '1'
                             AND B.MANAGECOM LIKE '8647%')
         AND (A.SENDOUTDATE= DATE '2017-12-26' --发送日期
         OR C.SEALDATE = DATE '2017-12-26') --红章发放日期 显示红章信息
         ORDER BY A.CONTNO;
        

                   --AND TOS.PRINTDATE = DATE '2011-07-25' --打印日期
                       --AND TPP.PRINT_STATUS IN ('3','4','5') -- 3-待打印、4-已打印、5-申请重打
                         --AND TPP.PRINT_STATUS IN ('3','4','5') -- 3-待打印、4-已打印、5-申请重打
                         /*(OR TPD.SEND_DATE = DATE '2011-07-25' --保单打印轨迹*发送日期
                         OR TPD.RECEIVE_DATE = DATE '2011-07-25') --保单打印轨迹*返回日期*/
/*************************************  新核心BPO制单计数  ************************************/
SELECT 
       (CASE WHEN ROWNUM = 1 THEN 
             (SELECT COUNT(TOS.POLICY_CODE)
                 FROM APP___NB__DBUSER.T_OUTSOURCE_STAMP TOS --外包打印
                 WHERE 1=1
                   AND TOS.STATE = '1' -- 1-正常使用
                   AND TOS.USEORGAN_CODE LIKE '8647%' --管理机构
                   AND TOS.SEALDATE = DATE '2011-07-25') --印制日期
        END) 红章发放件数,
        (CASE WHEN ROWNUM = 1 THEN 
              (SELECT COUNT(TOS.POLICY_CODE)
                 FROM APP___NB__DBUSER.T_OUTSOURCE_STAMP TOS --外包打印
                 WHERE 1=1
                   AND TOS.STATE = '2' -- 2-作废
                   AND TOS.USEORGAN_CODE LIKE '8647%' --管理机构
                   AND TOS.SEALDATE = DATE '2011-07-25') --印制日期
        END) 红章作废件数,
       (CASE WHEN ROWNUM = 1 THEN 
             (SELECT COUNT(TPP.POLICY_CODE)
                 FROM APP___NB__DBUSER.T_POLICY_PRINT_APPLY TPPA
                 LEFT JOIN APP___NB__DBUSER.T_POLICY_PRINT TPP
                      ON TPP.PRINT_ID = TPPA.PRINT_ID
                 LEFT JOIN APP___NB__DBUSER.T_PRINT_DETAIL TPD
                      ON TPPA.APPLY_ID = TPD.APPLY_ID
                      AND TPPA.PRINT_ID = TPD.PRINT_ID 
                 WHERE 1 = 1 
                       AND TPP.PRINT_TYPE = '1' --外包打印 1-外包打印、2-电子制单
                       AND TPD.SEND_DATE = DATE '2011-07-25' --发送日期
                       AND TPP.PRINT_ORG LIKE '8647%') --打印机构
        END) 打印任务件数,
       (CASE WHEN ROWNUM = 1 THEN 
             (SELECT COUNT(TPP.POLICY_CODE)
                   FROM APP___NB__DBUSER.T_POLICY_PRINT_APPLY TPPA
                   LEFT JOIN APP___NB__DBUSER.T_POLICY_PRINT TPP
                        ON TPP.PRINT_ID = TPPA.PRINT_ID
                   LEFT JOIN APP___NB__DBUSER.T_PRINT_DETAIL TPD
                        ON TPPA.APPLY_ID = TPD.APPLY_ID
                        AND TPPA.PRINT_ID = TPD.PRINT_ID 
                   WHERE 1 = 1 
                         AND TPP.PRINT_TYPE = '1' --外包打印 1-外包打印、2-电子制单
                         AND TPPA.APPLY_STATUS = '03' -- 03-打印成功
                         AND TPP.BPO_PRINT_DATE = DATE '2011-07-25' --保单打印件主表*外包打印日期
                         AND TPP.PRINT_ORG LIKE '8647%') --打印机构
        END) 打印成功件数
       FROM APP___NB__DBUSER.T_POLICY_PRINT TPP
WHERE ROWNUM = 1;

/*************************************  新核心BPO制单详细  ************************************/
SELECT TPP.PRINT_ORG 机构,
       TPP.POLICY_CODE 保单号,
       (CASE TOS.STATE
           WHEN '01' THEN '未使用'
           WHEN '02' THEN '正常'
           WHEN '03' THEN '作废'
           WHEN '04' THEN '丢失'
        END) 红章状态,
       TOS.STATE 红章状态码值,
       TPP.BPO_PRINT_DATE 外包打印日期,
       TPD.SEND_DATE 发送日期,
       TPD.RECEIVE_DATE 返回日期,
       TOS.SEALDATE 红章印制日期--,
       --TPP.PRINT_TIME 打印时间,
       --PRINT_TIMES/*打印次数*/ 打印次数,
       /*(CASE TPPA.APPLY_STATUS
           WHEN '04' THEN '失败'
           WHEN '03' THEN '成功'
        END) 打印申请状态,
       TPPA.APPLY_STATUS 打印申请状态码值,
       TPP.PRINT_STATUS 打印状态码值,
       TPP.APPLY_CODE 投保单号*/
       FROM APP___NB__DBUSER.T_POLICY_PRINT TPP
       LEFT JOIN APP___NB__DBUSER.T_PRINT_DETAIL TPD
            ON TPP.POLICY_CODE = TPD.POLICY_CODE
       LEFT JOIN APP___NB__DBUSER.T_OUTSOURCE_STAMP TOS
            ON TPP.POLICY_CODE = TOS.POLICY_CODE
       LEFT JOIN APP___NB__DBUSER.T_POLICY_PRINT_APPLY TPPA
            ON TPP.PRINT_ID = TPPA.PRINT_ID
       WHERE 1 = 1 
             AND TPP.PRINT_TYPE = '1' --外包打印 1-外包打印、2-电子制单
             AND (PRINT_TIME = DATE '2011-07-25' --打印日期
             OR TOS.SEALDATE = DATE '2011-07-25') --红章印制日期
             AND TPP.PRINT_ORG LIKE '8647%'
       ORDER BY TPP.POLICY_CODE;

/*************************************  新、老核心差异比较  ************************************/

             --AND (TPP.PRINT_STATUS IN ('3','4','5') -- 3-待打印、4-已打印、5-申请重打)
             /*OR (TPD.RECEIVE_DATE = DATE '2011-07-25') --返回日期
             OR TPD.SEND_DATE = DATE '2011-07-25' --发送日期*/
