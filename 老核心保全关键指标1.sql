SELECT /*+PARALLEL(40)*/COUNT(DISTINCT A.EdorAppNo) 保全申请件数
                FROM LIS.LPEDORITEM A
                WHERE A.EdorAppDate =  TRUNC(SYSDATE) -1 --保全申请时间
                AND A.MANAGECOM LIKE '8647%'--管理机构
                AND A.EdorState<>'7'
                AND A.CONTNO IN (
                      SELECT CONTNO FROM LIS.LCCONT
                      WHERE CONTTYPE = '1' 
                      AND APPFLAG IN ('1','4')
                      );
SELECT /*+PARALLEL(40)*/COUNT(DISTINCT A.EdorAcceptNo) 保全生效件数
                FROM LIS.LPEDORITEM A
                WHERE A.EdorValiDate = TRUNC(SYSDATE) -1 --保全生效时间
                AND A.MANAGECOM LIKE '8647%'--管理机构
                AND A.EdorState<>'7'
                  AND A.CONTNO IN (
                        SELECT CONTNO FROM LIS.LCCONT
                        WHERE CONTTYPE = '1' 
                        AND APPFLAG IN ('1','4')
                  );
SELECT /*+PARALLEL(40)*/COUNT(*) 保全自动复核成功件数
                  FROM LIS.LPEdorItem A
                  JOIN LIS.LPEdorAutoApproveResult B/*自动复核结果*/
                     ON TRIM(A.EdorAcceptNo) = TRIM(B.AppNo)
                WHERE 1 = 1
                  AND B.Status IN ('V01','V03') --成功
                  AND A.EdorState<>'7'
                  AND A.ManageCom LIKE '8647%'
                  AND A.ApproveDate = TRUNC(SYSDATE) -1 ; --复核日期
