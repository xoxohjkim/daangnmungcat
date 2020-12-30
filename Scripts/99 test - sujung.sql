SELECT ID, MEM_ID, DOG_CATE, CAT_CATE, TITLE, CONTENT, PRICE, DONGNE1_ID, DONGNE2_ID, BUY_MEM_ID, SALE_STATE, REGDATE, REDATE, HITS, CHAT_COUNT, HEART_COUNT FROM JOONGO_SALE;

SELECT js.ID, MEM_ID, DOG_CATE, CAT_CATE, TITLE, CONTENT, PRICE, d1.ID AS DONGNE1ID, d1.NAME AS DONGNE1NAME, d2.ID AS DONGNE2ID, d2.NAME AS DONGNE2NAME, BUY_MEM_ID, SALE_STATE, REGDATE, REDATE, HITS, CHAT_COUNT, HEART_COUNT 
 FROM JOONGO_SALE js LEFT JOIN DONGNE1 d1 ON js.DONGNE1_ID = d1.ID LEFT JOIN DONGNE2 d2 ON js.DONGNE2_ID = d2.ID;

SELECT js.ID, MEM_ID, DOG_CATE, CAT_CATE, TITLE, CONTENT, PRICE, d1.ID AS DONGNE1ID, d1.NAME AS DONGNE1NAME, d2.ID AS DONGNE2ID, d2.NAME AS DONGNE2NAME, BUY_MEM_ID, SALE_STATE, REGDATE, REDATE, HITS, CHAT_COUNT, HEART_COUNT 
 FROM JOONGO_SALE js LEFT JOIN DONGNE1 d1 ON js.DONGNE1_ID = d1.ID LEFT JOIN DONGNE2 d2 ON js.DONGNE2_ID = d2.ID WHERE d1.NAME = '부산광역시' AND d2.NAME = '동구';

SELECT ID FROM DONGNE1 WHERE NAME = '부산광역시';

SELECT rownum, js.*
  FROM JOONGO_SALE js 
 WHERE rownum BETWEEN 1 AND 5
 ORDER BY rownum desc;
 
SELECT rownum, js.ID, MEM_ID, DOG_CATE, CAT_CATE, TITLE, CONTENT, PRICE, d1.ID AS DONGNE1ID, d1.NAME AS DONGNE1NAME, d2.ID AS DONGNE2ID, d2.NAME AS DONGNE2NAME, BUY_MEM_ID, SALE_STATE, REGDATE, REDATE, HITS, CHAT_COUNT, HEART_COUNT 
  FROM JOONGO_SALE js LEFT JOIN DONGNE1 d1 ON js.DONGNE1_ID = d1.ID LEFT JOIN DONGNE2 d2 ON js.DONGNE2_ID = d2.ID
  --WHERE rownum BETWEEN 1 AND 5
  ORDER BY js.ID;
 
SELECT a.*
  FROM (SELECT rownum AS rnum, b.*
  		FROM (SELECT js.ID, MEM_ID, DOG_CATE, CAT_CATE, TITLE, CONTENT, PRICE, d1.ID AS DONGNE1ID, d1.NAME AS DONGNE1NAME, d2.ID AS DONGNE2ID, d2.NAME AS DONGNE2NAME, BUY_MEM_ID, SALE_STATE, REGDATE, REDATE, HITS, CHAT_COUNT, HEART_COUNT 
  FROM JOONGO_SALE js LEFT JOIN DONGNE1 d1 ON js.DONGNE1_ID = d1.ID LEFT JOIN DONGNE2 d2 ON js.DONGNE2_ID = d2.ID WHERE d1.name = '서울특별시' AND d2.NAME = '종로구' ORDER BY js.id desc) b) a
 WHERE a.rnum BETWEEN 1 AND 10
ORDER BY a.rnum;
  
SELECT count(a.id)
  FROM (SELECT rownum AS rnum, b.*
  		FROM (SELECT js.ID, MEM_ID, DOG_CATE, CAT_CATE, TITLE, CONTENT, PRICE, d1.ID AS DONGNE1ID, d1.NAME AS DONGNE1NAME, d2.ID AS DONGNE2ID, d2.NAME AS DONGNE2NAME, BUY_MEM_ID, SALE_STATE, REGDATE, REDATE, HITS, CHAT_COUNT, HEART_COUNT 
  FROM JOONGO_SALE js LEFT JOIN DONGNE1 d1 ON js.DONGNE1_ID = d1.ID LEFT JOIN DONGNE2 d2 ON js.DONGNE2_ID = d2.ID ORDER BY js.id desc) b) a;

select *
 from ALL_TAB_COLUMNS
 where TABLE_NAME = 'JOONGO_SALE';