select (select STATUS_DESC from dev_pas.T_ACCEPT_STATUS where ACCEPT_STATUS=a.ACCEPT_STATUS) 
from dev_pas.T_CS_ACCEPT_CHANGE a where a.ACCEPT_CODE='';

select * from dev_pas.T_ACCEPT_STATUS --保全受理状态描述 
select * from dev_pas.t_cs_remark c where c.accept_id = 1000001045065;

select * from dev_pas.t_cs_remark c where c.curr_process_point = '13';
select * from dev_pas.t_cs_remark c where c.curr_process_point = '13' and c.remark_type = '3'
SELECT COUNT(1) FROM (select ACCEPT_ID from dev_pas.t_cs_remark c where c.curr_process_point = '13' and c.remark_type = '3' AND TO_CHAR(UPDATE_TIME,'YYYY-MM-DD') = '2018-05-10' GROUP BY ACCEPT_ID);

select ACCEPT_ID from dev_pas.t_cs_remark c WHERE TO_CHAR(UPDATE_TIME,'YYYY-MM-DD') = '2018-05-10' GROUP BY ACCEPT_ID;
select * from dev_pas.t_cs_remark c WHERE TO_CHAR(UPDATE_TIME,'YYYY-MM-DD') = '2018-05-10' AND c.ACCEPT_ID IS NULL

LPPol ApproveFlag --复核状态 1-未通过 0-通过

T_CS_ACCEPT_CHANGE /*受理变更表*/ ACCEPT_ID --主键 ACCEPT_CODE ACCEPT_STATUS REVIEW_TIME
SELECT * FROM DEV_PAS.T_CS_ACCEPT_CHANGE WHERE ACCEPT_ID = 10077

SELECT c.* FROM DEV_PAS.T_CS_ACCEPT_CHANGE TCAC
  LEFT JOIN dev_pas.t_cs_remark c 
  ON c.accept_id = TCAC.accept_id 
 WHERE 1 = 1 
  AND TCAC.REVIEW_TIME = DATE '2018-05-28'
  AND TCAC.ORGAN_CODE LIKE '8647%'
  AND c.curr_process_point = '13' and c.remark_type = '3' --自核通过
  
SELECT COUNT(1) 自动复核总件数 FROM 
(SELECT C.ACCEPT_ID 
   FROM dev_pas.t_cs_remark c 
      LEFT JOIN DEV_PAS.T_CS_ACCEPT_CHANGE TCAC
      ON c.accept_id = TCAC.accept_id 
   WHERE 1 = 1 
      AND TCAC.REVIEW_TIME = DATE '2018-05-10'
      AND TCAC.ORGAN_CODE LIKE '8647%'
 GROUP BY C.ACCEPT_ID);
 
SELECT COUNT(1) 自动复核通过件数 FROM 
(select C.ACCEPT_ID
   FROM dev_pas.t_cs_remark c 
      LEFT JOIN DEV_PAS.T_CS_ACCEPT_CHANGE TCAC
      ON c.accept_id = TCAC.accept_id 
   where c.curr_process_point = '13' 
      and c.remark_type = '3' 
      AND TO_CHAR(c.UPDATE_TIME,'YYYY-MM-DD') = '2018-05-10' --统计日期
      AND TCAC.ORGAN_CODE LIKE '8647%'
 GROUP BY C.ACCEPT_ID);
 
SELECT COUNT(*) 
  FROM LIS.Policy_BOM A
   LEFT JOIN LIS.LPEdorAutoApproveResult B/*自动复核结果*/
     ON A.AppNo = B.AppNo
     AND A.SerialNo = B.SerialNo
WHERE 1 = 1
  AND B.Status IN ('V01','V03') --成功
  AND A.CompanyCode LIKE '8647%'
  AND A.ValidateDate = '2018-05-10 00:00:00';

SELECT COUNT(*)
FROM LIS.Policy_BOM A
  LEFT JOIN LIS.LPEdorAutoApproveResult B/*自动复核结果*/
     ON A.AppNo = B.AppNo
     AND A.SerialNo = B.SerialNo
WHERE 1 = 1
    AND B.Status = 'V02' --失败
    AND A.CompanyCode LIKE '8647%'
  AND A.ValidateDate = '2018-05-10 00:00:00';

