  /* 验证保单能否申请保全 */
    select ContNo,AppntName from lccont where contno = '880095908301' and appflag in ( '1', '4');
    
   select missionid,submissionid from lwmission where  activityid = '0000000092' and missionprop1 = '';--mEdorAcceptNo
   
   --个人保单批改信息
		SELECT EdorNo,EdorType,ContNo,InsuredNo,polno FROM lpedoritem WHERE EdorAcceptNo=''
		
    
    SELECT A.REMARK, A.ACCEPT_NO, A.LOAN_FLAG, A.MAX_LOAN_RATIO, A.ORGAN_CODE, 
			A.CFG_ID, A.LOAN_STATUS, A.POLICY_ID,A.POLICY_CODE,A.UPDATE_BY,A.UPDATE_TIME,A.BUSI_ITEM_ID FROM APP___PAS__DBUSER.T_LOAN_POLICY_CFG A WHERE
      A.LOAN_STATUS = '01'  AND A.LOAN_FLAG = 1
       AND A.POLICY_ID = '6000000459859'
      AND A.BUSI_ITEM_ID = '6000002266546'
	  ORDER BY A.CFG_ID 
		
  SELECT * FROM APP___PAS__DBUSER.T_CONTRACT_PRODUCT WHERE POLICY_CODE='887518140610'
