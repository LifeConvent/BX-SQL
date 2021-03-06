SELECT 
       (CASE WHEN ROWNUM = 1 THEN 
             (SELECT COUNT(DISTINCT L.ACCEPT_CODE) AS 保全生效件数
                FROM APP___PAS__DBUSER.T_CS_ACCEPT_CHANGE L
                WHERE TO_CHAR(L.VALIDATE_TIME, 'YYYYMMDD') = '20151231' --生效日期
                AND L.ORGAN_CODE LIKE '8647%') --机构
        END) 保全生效件数,
        (CASE WHEN ROWNUM = 1 THEN 
            (SELECT COUNT(DISTINCT TCA.APPLY_CODE) AS 保全申请件数
                FROM APP___PAS__DBUSER.T_CS_ACCEPT_CHANGE TCAC 
                LEFT JOIN APP___PAS__DBUSER.T_CS_APPLICATION TCA
                     ON TCAC.CHANGE_ID = TCA.CHANGE_ID
                WHERE TO_CHAR(TCA.APPLY_TIME, 'YYYYMMDD') = '20151231' --申请日期
                AND TCAC.ORGAN_CODE LIKE '8647%') --机构
        END) 保全申请件数,
        (CASE WHEN ROWNUM = 1 THEN 
            (select (CASE WHEN sum(TCPA.FEE_AMOUNT) IS NOT NULL THEN sum(TCPA.FEE_AMOUNT) ELSE 0 END)
                       from APP___PAS__DBUSER.T_CS_PREM_ARAP TCPA
                WHERE TCPA.ORGAN_CODE LIKE '8647%'
                AND TO_CHAR(TCPA.FINISH_TIME, 'YYYYMMDD') = '20151231')--收付费业务核销时间
        END) 保全应收付金额,
        (CASE WHEN ROWNUM = 1 THEN 
            (SELECT COUNT(1)  FROM 
                (select C.ACCEPT_ID
                   FROM dev_pas.t_cs_remark c 
                      LEFT JOIN DEV_PAS.T_CS_ACCEPT_CHANGE TCAC
                      ON c.accept_id = TCAC.accept_id 
                   where c.curr_process_point = '13' 
                      and c.remark_type = '3' 
                      AND TO_CHAR(c.UPDATE_TIME,'YYYYMMDD') = '20180510' --统计日期
                      AND TCAC.ORGAN_CODE LIKE '8647%'
                 GROUP BY C.ACCEPT_ID))
        END) 自动复核通过件数
       FROM APP___PAS__DBUSER.T_CS_PREM_ARAP
WHERE ROWNUM = 1;
 

SELECT 
       (CASE WHEN ROWNUM = 1 THEN 
             (SELECT COUNT(DISTINCT A.EdorAcceptNo) 
                FROM LIS.LPEDORITEM A
                WHERE TO_CHAR(A.EdorValiDate,'YYYYMMDD') = '20151231'--保全生效时间
                AND A.MANAGECOM LIKE '8647%'--管理机构
                  AND A.CONTNO IN (
                        SELECT CONTNO FROM LIS.LCCONT
                        WHERE CONTTYPE = '1' 
                        AND APPFLAG IN ('1','4')
                  ))
        END) 保全生效件数,
        (CASE WHEN ROWNUM = 1 THEN 
            (SELECT COUNT(DISTINCT A.EdorAppNo) 
                FROM LIS.LPEDORITEM A
                WHERE TO_CHAR(A.EdorAppDate,'YYYYMMDD') = '20151231'--保全申请时间
                AND A.MANAGECOM LIKE '8647%'--管理机构
                AND A.CONTNO IN (
                      SELECT CONTNO FROM LIS.LCCONT
                      WHERE CONTTYPE = '1' 
                      AND APPFLAG IN ('1','4')
                      ))
        END) 保全申请件数,
        (CASE WHEN ROWNUM = 1 THEN 
            (select (CASE WHEN sum(A.Getmoney)IS NOT NULL THEN sum(A.Getmoney) ELSE 0 END)
               from  LIS.Ljsgetendorse A,LIS.Lpedoritem B
               where EXISTS (SELECT 1 FROM Edoraccept_Scope WHERE B.Edoracceptno = Edoracceptno)
               AND  A.Endorsementno = B.Edorno(+)
               AND A.ManageCom LIKE '8647%'--管理机构
               AND TO_CHAR(A.GetDate,'YYYYMMDD') = '20151231')--补退费时间
        END) 保全应收付金额
       FROM LIS.Ljsgetendorse
WHERE ROWNUM = 1;
