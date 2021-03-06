SELECT Dd.Clmno               赔案号,
       F1.Contno              保单号,
       F1.Riskcode            险种代码,
       f.Accdate              出险日期,
       A2.Accdate             事故日期,
       Dd.Endcasedate         结案日期,
       A3.Feeoperationtype    业务类型,
       A3.Subfeeoperationtype 子业务类型,
       A3.Feefinatype         财务类型,
       A4.Defotype            伤残类型,
       A4.Defograde           伤残级别,
       A4.Defocode            伤残代码,
       A4.Deformityrate       残疾给付比例,
      A4.Realrate            实际给付比例,
       A5.Operationtype       手术类型,
       A5.Operationcode       手术代码,
       f.Seriousdiscode       重大疾病代码,
       A7.Tabfeemoney         账单金额,
       A8.Standpay            理算金额,
       A7.Socpay              社保给付,
       A7.Othpay              第三方给付,
       A8.Realpay             核赔赔付金额,
       A8.Givetype            赔付结论
  FROM Lis.Llclaim Dd
  LEFT JOIN Lis.Llcase f
    ON Dd.Clmno = f.Caseno
  LEFT JOIN Lis.Llclaimpolicy F1
    ON Dd.Clmno = F1.Clmno
  LEFT JOIN Lis.Llcaserela A1
    ON Dd.Clmno = A1.Caseno
  LEFT JOIN Lis.Llaccident A2
    ON A1.Caserelano = A2.Accno
  LEFT JOIN Lis.Llbalance A3
    ON Dd.Clmno = A3.Clmno
  LEFT JOIN Lis.Llcaseinfo A4
    ON Dd.Clmno = A4.Clmno
  LEFT JOIN Lloperation A5
    ON Dd.Clmno = A5.Clmno
  LEFT JOIN Lis.Llclaimdutykind A7
    ON Dd.Clmno = A7.Clmno
  LEFT JOIN Lis.Llclaimdetail A8
    ON Dd.Clmno = A8.Clmno
WHERE Dd.Mngcom LIKE '8647%'
   AND Dd.Endcasedate = Trunc(SYSDATE)
   and Dd.clmstate in ('50','60')
   and exists (select 1 from lis.lccont ggg where ggg.conttype='1' and ggg.contno=f1.contno)
