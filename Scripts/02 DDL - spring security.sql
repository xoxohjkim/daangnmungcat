CREATE TABLE AUTHORITIES (
    USERNAME VARCHAR2(20) NOT NULL,
    AUTHORITY VARCHAR2(128) NOT NULL
);

ALTER TABLE AUTHORITIES ADD CONSTRAINT AUTHORITIES_UNIQUE UNIQUE (USERNAME, AUTHORITY);
ALTER TABLE AUTHORITIES ADD CONSTRAINT AUTHORITIES_FK1 FOREIGN KEY (USERNAME) REFERENCES MEMBER (ID) ENABLE;

INSERT INTO authorities(username, AUTHORITY) values('chattest1', 'USER');
INSERT INTO authorities(username, AUTHORITY) values('test', 'ADMIN');

DELETE AUTHORITIES ;
SELECT
	username, authority
FROM authorities
WHERE username = 'chattest1'