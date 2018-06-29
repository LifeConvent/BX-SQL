SELECT /*+PARALLEL(40)*/COUNT(DISTINCT A.EdorAppNo) ��ȫ�������
                FROM LIS.LPEDORITEM A
                WHERE A.EdorAppDate =  TRUNC(SYSDATE) -1 --��ȫ����ʱ��
                AND A.MANAGECOM LIKE '8647%'--�������
                AND A.EdorState<>'7'
                AND A.CONTNO IN (
                      SELECT CONTNO FROM LIS.LCCONT
                      WHERE CONTTYPE = '1' 
                      AND APPFLAG IN ('1','4')
                      );
SELECT /*+PARALLEL(40)*/COUNT(DISTINCT A.EdorAcceptNo) ��ȫ��Ч����
                FROM LIS.LPEDORITEM A
                WHERE A.EdorValiDate = TRUNC(SYSDATE) -1 --��ȫ��Чʱ��
                AND A.MANAGECOM LIKE '8647%'--�������
                AND A.EdorState<>'7'
                  AND A.CONTNO IN (
                        SELECT CONTNO FROM LIS.LCCONT
                        WHERE CONTTYPE = '1' 
                        AND APPFLAG IN ('1','4')
                  );
SELECT /*+PARALLEL(40)*/COUNT(*) ��ȫ�Զ����˳ɹ�����
                  FROM LIS.LPEdorItem A
                  JOIN LIS.LPEdorAutoApproveResult B/*�Զ����˽��*/
                     ON TRIM(A.EdorAcceptNo) = TRIM(B.AppNo)
                WHERE 1 = 1
                  AND B.Status IN ('V01','V03') --�ɹ�
                  AND A.EdorState<>'7'
                  AND A.ManageCom LIKE '8647%'
                  AND A.ApproveDate = TRUNC(SYSDATE) -1 ; --��������
