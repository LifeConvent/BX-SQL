select AC.ACCEPT_CODE as EdorAcceptNo,
           (select PRODUCT_ABBR_NAME from APP___PAS__DBUSER.T_BUSINESS_PRODUCT 
             WHERE BUSINESS_PRD_ID = (select BUSI_PRD_ID from APP___PAS__DBUSER.T_CONTRACT_BUSI_PROD 
             WHERE POLICY_ID=PC.POLICY_ID AND MASTER_BUSI_ITEM_ID IS NULL)) as RiskName,
           (select BUSI_PROD_CODE from APP___PAS__DBUSER.T_CONTRACT_BUSI_PROD 
             WHERE POLICY_ID=PC.POLICY_ID AND MASTER_BUSI_ITEM_ID IS NULL) as RiskCode,
           PC.SERVICE_CODE as EdorType,
           (SELECT SERVICE_NAME FROM APP___PAS__DBUSER.T_SERVICE WHERE SERVICE_CODE=PC.SERVICE_CODE) as EdorTypeName,
           PC.APPLY_TIME as EdorAppDate,
           (select TCA.APPLY_NAME
              from APP___PAS__DBUSER.T_CS_APPLICATION TCA
             WHERE TCA.CHANGE_ID = PC.CHANGE_ID) as EdorAppName,
           (select TCA.Service_Type
              from APP___PAS__DBUSER.T_CS_APPLICATION TCA
             WHERE TCA.CHANGE_ID = PC.CHANGE_ID) as AppType,
           PC.VALIDATE_TIME as EdorValiDate,
           AC.ACCEPT_STATUS as EdorState,
           AC.FINISH_TIME as ConfDate
      from APP___PAS__DBUSER.T_CS_POLICY_CHANGE      PC,
           APP___PAS__DBUSER.T_CS_ACCEPT_CHANGE      AC
      WHERE AC.CHANGE_ID=PC.CHANGE_ID(+)
      and PC.POLICY_CODE = '886938728517'
      
      
Select Lpedoritem.Edoracceptno 保全受理号, 
             Lpedoritem.Edortype 批改类型, 
            Lpedoritem.Edorappdate 申请日期, 
             nvl(Lpedorapp.Edorappname,'N/A') 申请人, 
            Lpedorapp.Apptype 申请方式, 
            lpedoritem.edorvalidate 生效日期, 
             lpedoritem.edorstate 批改状态 , 
            (Select ConfDate From Lpedormain Where Edoracceptno = Lpedoritem.Edoracceptno and EDORNO=Lpedoritem.Edorno and Contno = Lpedoritem.Contno) 确认生效日期  
             From Lpedoritem Lpedoritem, Lpedorapp Lpedorapp 
             Where Lpedorapp.Edoracceptno = Lpedoritem.Edoracceptno And Lpedoritem.Contno = '886938728509'
             
      Select Lpedoritem.Edoracceptno 保全受理号, 
             Lpedoritem.Edortype 批改类型, 
            Lpedoritem.Edorappdate 申请日期, 
          --   nvl(Lpedorapp.Edorappname,'N/A') 申请人, 
           -- Lpedorapp.Apptype 申请方式, 
            lpedoritem.edorvalidate 生效日期, 
             lpedoritem.edorstate 批改状态  
            --(Select ConfDate From LIS.Lpedormain Where Edoracceptno = Lpedoritem.Edoracceptno and EDORNO=Lpedoritem.Edorno and Contno = Lpedoritem.Contno) 确认生效日期  
             From LIS.Lpedoritem Lpedoritem--, LIS.Lpedorapp Lpedorapp 
             Where Lpedoritem.Contno = '886938728509'
             
select * from lis.LOBEdorItem b where b.contno='886350734936';             
             
select *
      from APP___PAS__DBUSER.T_CS_POLICY_CHANGE      PC,
           APP___PAS__DBUSER.T_CS_ACCEPT_CHANGE      AC
      WHERE AC.ACCEPT_ID=PC.ACCEPT_ID(+)
      and PC.POLICY_CODE = '886938728509'
      
      select *
      from APP___PAS__DBUSER.T_CS_POLICY_CHANGE      PC
      WHERE PC.POLICY_CODE = '886938728509'
      
      select *
      from APP___PAS__DBUSER.T_CS_ACCEPT_CHANGE      AC
      WHERE AC.POLICY_ID = '6000000340194'
