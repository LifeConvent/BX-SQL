                SELECT B.Status,A.ApplyDate,C.CompanyCode 
                  FROM LIS.Endorse_BOM A
                   LEFT JOIN LIS.LPEdorAutoApproveResult B/*�Զ����˽��*/
                     ON A.AppNo = B.AppNo
                     AND A.SerialNo = B.SerialNo
                   LEFT JOIN LIS.Policy_BOM C
                     ON B.AppNo = C.AppNo
                     AND B.SerialNo = C.SerialNo
                  WHERE 1=1
                  AND B.Status IN ('V01','V03') --�ɹ�
                  AND A.ApplyDate = '2014-07-14 00:00:00' --�������ڣ�ֻ���޸����ڣ�
                  AND C.CompanyCode LIKE '8647%'; --�������
                  
                 
               /*  SELECT * 
                  FROM LIS.Policy_BOM A
                   LEFT JOIN LIS.LPEdorAutoApproveResult B
                     ON A.AppNo = B.AppNo
                     AND A.SerialNo = B.SerialNo;*/
                     
                     
                 SELECT B.Status
                  FROM LIS.LPEdorItem A
                   LEFT JOIN LIS.LPEdorAutoApproveResult B/*�Զ����˽��*/
                     ON A.EdorAcceptNo = B.AppNo;
