select * from app___nb__dbuser.t_proposal_process a where a.process_step = '17' ;--自核通过
select * from app___nb__dbuser.t_proposal_process a where a.process_step = '18' ;--自核不通过
-- 投保单状态
select * from APP___NB__DBUSER.T_PROPOSAL_STATUS a;
-- 操作履历投保单状态
select * from APP___NB__DBUSER.t_proposal_step  a;
