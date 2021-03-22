DROP TABLE AUTHORITIES CASCADE CONSTRAINTS;

CREATE TABLE AUTHORITIES (
    USERNAME VARCHAR2(20) NOT NULL,
    AUTHORITY VARCHAR2(128) NOT NULL
);

ALTER TABLE AUTHORITIES ADD CONSTRAINT AUTHORITIES_UNIQUE UNIQUE (USERNAME, AUTHORITY);
ALTER TABLE AUTHORITIES ADD CONSTRAINT AUTHORITIES_FK1 FOREIGN KEY (USERNAME) REFERENCES MEMBER (ID) ENABLE;



-- 어드민 계정 권한 주기
INSERT INTO authorities(username, AUTHORITY) values('test', 'ADMIN');

-- 일반 회원들 권한 주기
INSERT INTO authorities(username, AUTHORITY)
SELECT id, 'USER' FROM MEMBER WHERE id NOT IN('test');

/*
DELETE AUTHORITIES ;
SELECT
	username, authority
FROM authorities
WHERE username = 'chattest1'
*/

SELECT * FROM MEMBER;
