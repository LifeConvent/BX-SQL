/*-----------------------------------------------------------------------------------------------------------------
//////////////////////////////////////////--�º���ָ��--/////////////////////////////////////////////////////
-----------------------------------------------------------------------------------------------------------------*/
--�����������
SELECT SUBSTR(TRIM(L.ORGAN_CODE), 1, 4) AS ORGAN_CODE,B.SERVICE_CODE,B.SERVICE_NAME,COUNT(DISTINCT L.ACCEPT_CODE) AS SUM
       FROM T_CS_ACCEPT_CHANGE L
        INNER JOIN T_SERVICE B
        ON L.SERVICE_CODE = B.SERVICE_CODE
       WHERE TO_CHAR(L.VALIDATE_TIME, 'YYYYMMDD') <= '20151231'/*��ȫ��Чʱ��*/
       AND SUBSTR(TRIM(L.ORGAN_CODE), 1, 4) = '8651'
GROUP BY SUBSTR(TRIM(L.ORGAN_CODE), 1, 4),B.SERVICE_CODE,B.SERVICE_NAME
ORDER BY SUBSTR(TRIM(L.ORGAN_CODE), 1, 4),B.SERVICE_CODE,B.SERVICE_NAME;
--�����������
SELECT SUBSTR(TRIM(L.ORGAN_CODE), 1, 6) AS ORGAN_CODE,B.SERVICE_CODE,B.SERVICE_NAME,COUNT(DISTINCT L.ACCEPT_CODE) AS SUM
       FROM T_CS_ACCEPT_CHANGE L
        INNER JOIN T_SERVICE B
        ON L.SERVICE_CODE = B.SERVICE_CODE
       WHERE TO_CHAR(L.VALIDATE_TIME, 'YYYYMMDD') <= '20151231'/*��ȫ��Чʱ��*/
       AND SUBSTR(TRIM(L.ORGAN_CODE), 1, 6) IN
       (SELECT ORGAN_CODE
          FROM T_UDMP_ORG_REL
         WHERE ORGAN_GRADE = '03' --�����������
           AND UPORGAN_CODE = '8651')
GROUP BY SUBSTR(TRIM(L.ORGAN_CODE), 1, 6),B.SERVICE_CODE,B.SERVICE_NAME
ORDER BY SUBSTR(TRIM(L.ORGAN_CODE), 1, 6),B.SERVICE_CODE,B.SERVICE_NAME;
