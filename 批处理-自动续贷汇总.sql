SELECT COUNT(1) AS 批处理笔数,
       SUM(T.CAPITAL_BALANCE) AS 续贷本金,
       SUM(T.INTEREST) AS 还款利息
  FROM (SELECT CM.POLICY_CODE,
               CB.BUSI_PROD_CODE,
               CPAS.CAPITAL_BALANCE AS CAPITAL_BALANCE,
               MAX(CASE
                     WHEN CPAS.OPERATION_TYPE = 2 THEN
                      CPAS.INTEREST_SUM
                     ELSE
                      0
                   END) AS INTEREST,
               MAX(CASE
                     WHEN CPASR.TIME_PERIDO_CODE IN (1, 3) THEN
                      CPASR.LOAN_RATE
                     ELSE
                      0
                   END) AS 续贷正常利率,
               MAX(CASE
                     WHEN CPASR.TIME_PERIDO_CODE = 2 THEN
                      CPASR.LOAN_RATE
                     ELSE
                      0
                   END) AS 续贷逾期利率
          FROM APP___PAS__DBUSER.T_CS_POLICY_ACCOUNT_STREAM@BINGXING_168_15 CPAS
          JOIN APP___PAS__DBUSER.T_CONTRACT_MASTER@BINGXING_168_15 CM
            ON CM.POLICY_ID = CPAS.POLICY_ID
          JOIN APP___PAS__DBUSER.T_CONTRACT_BUSI_PROD@BINGXING_168_15 CB
            ON CPAS.POLICY_ID = CB.POLICY_ID
           AND CPAS.BUSI_ITEM_ID = CB.BUSI_ITEM_ID
          JOIN APP___PAS__DBUSER.T_CS_POLICY_ACCOUNT_TRANS_LIST@BINGXING_168_15 CPATL
            ON CPATL.CHANGE_ID = CPAS.CHANGE_ID
           AND CPATL.ACCOUNT_ID = CPATL.ACCOUNT_ID
           AND CPATL.OLD_NEW = 1
           AND CPATL.OPERATION_TYPE = 1
           AND CPATL.TRANS_CODE = 35
          LEFT JOIN APP___PAS__DBUSER.T_C_POLICY_ACCOUNT_STREAM_RATE@BINGXING_168_15 CPASR
            ON CPASR.CHANGE_ID = CPAS.CHANGE_ID
           AND CPASR.STREAM_ID = CPAS.STREAM_ID
           AND CPASR.OLD_NEW = 1
           AND CPASR.OPERATION_TYPE = 1
           AND CPAS.OPERATION_TYPE = 1
         WHERE 1 = 1
           AND CPAS.OLD_NEW = 1
           AND CPAS.OPERATION_TYPE IN (1, 2)
           AND EXISTS (SELECT 1
                  FROM APP___PAS__DBUSER.T_CS_ACCEPT_CHANGE@BINGXING_168_15 CAT
                 WHERE 1 = 1
                   AND CAT.ACCEPT_TIME = Trunc(SYSDATE) - 1
                   AND CAT.ORGAN_CODE LIKE '8647%' --受理机构
                   AND CAT.SERVICE_CODE IN ('RL') --续贷
                   AND CAT.ACCEPT_STATUS IN (13, 18) --12撤销 13待生效 18生效
                   AND CAT.INSERT_BY = 43 --批处理
                   AND CAT.CHANGE_ID = CPAS.CHANGE_ID)
         GROUP BY CPAS.CHANGE_ID,
                  CM.POLICY_CODE,
                  CB.BUSI_PROD_CODE,
                  CPAS.CAPITAL_BALANCE) T;


         
SELECT COUNT(1), --笔数
       SUM(SUMMONEY), --续贷本金
       SUM(INTEREST) --还款利息. （若已还款，取实际还款利息；若未还款，取预计还款利息）
  FROM (SELECT A.CONTNO, --保单号,
               C.RISKCODE, --险种代码
               A.SUMMONEY, --续贷本金
               NVL(B.RETURNINTEREST, A.PREINTEREST) AS INTEREST --还款利息. （若已还款，取实际还款利息；若未还款，取预计还款利息）
          FROM LIS.LOLOAN A
          LEFT JOIN LIS.LORETURNLOAN B
            ON A.CONTNO = B.CONTNO
           AND A.POLNO = B.POLNO
           AND A.EDORNO = B.LOANNO --原批单号
          LEFT JOIN LIS.LCPOL C
            ON A.POLNO = C.POLNO
         WHERE A.AUTORL = '1' --自动续贷
           AND EXISTS (SELECT 1
                  FROM LIS.LPEDORITEM M
                 WHERE A.CONTNO = M.CONTNO
                   AND A.EDORNO = M.EDORNO
                   AND M.EDORTYPE = 'RL' --保单贷款续贷
                   AND M.EDORSTATE = '0' --确认生效
                   AND M.EDORVALIDATE = TRUNC(SYSDATE) - 1)
           AND EXISTS (SELECT 1
                  FROM LIS.LCCONT N
                 WHERE A.CONTNO = N.CONTNO
                   AND N.APPFLAG IN ('1', '4') --承包和终止保单
                   AND N.CONTTYPE = '1' --个单
                   AND N.MANAGECOM LIKE '8647%'));


           
/*********************************************************************  明细 ***********************************************************/
--CREATE TABLE TMP_NCS_1027 AS
DELETE FROM TMP_NCS_1027;
COMMIT;
INSERT INTO TMP_NCS_1027
SELECT CM.POLICY_CODE,
       CB.BUSI_PROD_CODE,
       CPAS.CAPITAL_BALANCE AS CAPITAL_BALANCE,
       MAX(CASE
             WHEN CPAS.OPERATION_TYPE = 2 THEN
              CPAS.INTEREST_SUM
             ELSE
              0
           END) AS INTEREST_SUM,
       MAX(CASE
             WHEN CPASR.TIME_PERIDO_CODE IN (1, 3) THEN
              CPASR.LOAN_RATE
             ELSE
              0
           END) AS LOAN_RATE,
       MAX(CASE
             WHEN CPASR.TIME_PERIDO_CODE = 2 THEN
              CPASR.LOAN_RATE
             ELSE
              0
           END) AS OVER_LOAN_RATE
  FROM APP___PAS__DBUSER.T_CS_POLICY_ACCOUNT_STREAM@BINGXING_168_15 CPAS
  JOIN APP___PAS__DBUSER.T_CONTRACT_MASTER@BINGXING_168_15 CM
    ON CM.POLICY_ID = CPAS.POLICY_ID
  JOIN APP___PAS__DBUSER.T_CONTRACT_BUSI_PROD@BINGXING_168_15 CB
    ON CPAS.POLICY_ID = CB.POLICY_ID
   AND CPAS.BUSI_ITEM_ID = CB.BUSI_ITEM_ID
  JOIN APP___PAS__DBUSER.T_CS_POLICY_ACCOUNT_TRANS_LIST@BINGXING_168_15 CPATL
    ON CPATL.CHANGE_ID = CPAS.CHANGE_ID
   AND CPATL.ACCOUNT_ID = CPATL.ACCOUNT_ID
   AND CPATL.OLD_NEW = 1
   AND CPATL.OPERATION_TYPE = 1
   AND CPATL.TRANS_CODE = 35
  LEFT JOIN APP___PAS__DBUSER.T_C_POLICY_ACCOUNT_STREAM_RATE@BINGXING_168_15 CPASR
    ON CPASR.CHANGE_ID = CPAS.CHANGE_ID
   AND CPASR.STREAM_ID = CPAS.STREAM_ID
   AND CPASR.OLD_NEW = 1
   AND CPASR.OPERATION_TYPE = 1
   AND CPAS.OPERATION_TYPE = 1
 WHERE CPAS.OLD_NEW = 1
   AND CPAS.OPERATION_TYPE IN (1, 2)
   AND EXISTS (SELECT 1
          FROM APP___PAS__DBUSER.T_CS_ACCEPT_CHANGE@BINGXING_168_15 CAT
         WHERE 1 = 1
           AND CAT.ACCEPT_TIME = Trunc(SYSDATE) - 1
           AND CAT.ORGAN_CODE LIKE '8647%' --受理机构
           AND CAT.SERVICE_CODE IN ('RL') --续贷
           AND CAT.ACCEPT_STATUS IN (13, 18) --12撤销 13待生效 18生效
              -- AND CAT.INSERT_BY = 322776 --批处理
           AND CAT.CHANGE_ID = CPAS.CHANGE_ID)
 GROUP BY CPAS.CHANGE_ID,
          CM.POLICY_CODE,
          CB.BUSI_PROD_CODE,
          CPAS.CAPITAL_BALANCE;
COMMIT;


--CREATE TABLE  TMP_LIS_1027  AS
DELETE FROM TMP_LIS_1027;
COMMIT;
INSERT INTO TMP_LIS_1027
SELECT A.CONTNO, --保单号,
       C.RISKCODE,--险种代码
       A.SUMMONEY, --续贷本金
       NVL(B.RETURNINTEREST, A.PREINTEREST) AS INTEREST, --还款利息. （若已还款，取实际还款利息；若未还款，取预计还款利息）
       A.INTERESTRATE, --续贷正常利率
       A.LOANOVERRATE --续贷逾期利率
  FROM LIS.LOLOAN A
  LEFT JOIN LIS.LORETURNLOAN B
    ON A.CONTNO = B.CONTNO
   AND A.POLNO = B.POLNO
   AND A.EDORNO = B.LOANNO --原批单号
  LEFT JOIN LIS.LCPOL C
    ON A.POLNO = C.POLNO
 WHERE A.AUTORL = '1' --自动续贷
   AND EXISTS (SELECT 1
          FROM LIS.LPEDORITEM M
         WHERE A.CONTNO = M.CONTNO
           AND A.EDORNO = M.EDORNO
           AND M.EDORTYPE = 'RL' --保单贷款续贷
           AND M.EDORSTATE = '0' --确认生效
           AND M.EDORVALIDATE = TRUNC(SYSDATE) - 1)
   AND EXISTS (SELECT 1
          FROM LIS.LCCONT N
         WHERE A.CONTNO = N.CONTNO
           AND N.APPFLAG IN ('1', '4') --承包和终止保单
           AND N.CONTTYPE = '1' --个单
           AND N.MANAGECOM LIKE '8647%');
COMMIT;
    
    SELECT NVL(A.POLICY_CODE, B.CONTNO) AS 保单号,
       NVL(A.BUSI_PROD_CODE, B.RISKCODE) AS 险种代码,
       A.CAPITAL_BALANCE AS 新核心续贷本金,
       B.SUMMONEY AS 老核心续贷本金,
       A.INTEREST_SUM AS 新核心还款利息,
       B.INTEREST AS 老核心还款利息,
       A.LOAN_RATE AS 新核心续贷正常利率,
       B.INTERESTRATE AS 老核心续贷正常利率,
       A.OVER_LOAN_RATE AS 新核心续贷逾期利率,
       B.LOANOVERRATE AS 老核心续贷逾期利率,
       A.CAPITAL_BALANCE - B.SUMMONEY AS 续贷本金差异,
       A.INTEREST_SUM - B.INTEREST AS 还款利息差异,
       CASE
         WHEN A.LOAN_RATE = B.INTERESTRATE THEN
          'Y'
         ELSE
          'N'
       END AS 续贷正常利率差异,
       
       CASE
         WHEN A.OVER_LOAN_RATE = B.LOANOVERRATE THEN
          'Y'
         ELSE
          'N'
       END AS 续贷逾期利率差异
  FROM TMP_NCS_1027 A
  FULL JOIN TMP_LIS_1027 B
    ON TRIM(A.POLICY_CODE) = TRIM(B.CONTNO);







