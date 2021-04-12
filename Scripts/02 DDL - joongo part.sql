DROP TABLE MEMBER CASCADE CONSTRAINTS; /* 멤버 */
DROP TABLE DONGNE1 CASCADE CONSTRAINTS; /* 중고동네_1차 */
DROP TABLE DONGNE2 CASCADE CONSTRAINTS; /* 중고동네_2차 */
DROP TABLE JOONGO_IMAGE CASCADE CONSTRAINTS; /* 중고_이미지 */
DROP TABLE JOONGO_SALE CASCADE CONSTRAINTS; /* 중고판매글 */
DROP TABLE JOONGO_COMMENT CASCADE CONSTRAINTS; /* 중고댓글 */
DROP TABLE JOONGO_HEART CASCADE CONSTRAINTS; /* 중고_찜 */
DROP TABLE JOONGO_REVIEW CASCADE CONSTRAINTS; /* 중고리뷰 */
DROP TABLE JOONGO_CHAT_MSG CASCADE CONSTRAINTS; /* 중고_채팅_메시지 */
DROP TABLE JOONGO_CHAT CASCADE CONSTRAINTS; /* 중고_대화 */
DROP TABLE JOONGO_MYSALE CASCADE CONSTRAINTS; /* 중고_판매내역 */
DROP TABLE JOONGO_MYBUY CASCADE CONSTRAINTS; /* 중고_구매내역 */
DROP TABLE grade CASCADE CONSTRAINTS; /* 등급 */
DROP TABLE notice CASCADE CONSTRAINTS; /* 공지사항 */

--재설정

/* 멤버 */
CREATE TABLE MEMBER (
	id VARCHAR2(20) NOT NULL , /* 회원아이디 */
	pwd VARCHAR2(255) NOT NULL, /* 비밀번호 */
	name VARCHAR2(36) NOT NULL, /* 이름 */
	nickname VARCHAR2(36) NOT NULL, /* 닉네임 */
	email VARCHAR2(50) NOT NULL, /* 이메일 */
	phone VARCHAR2(20) NOT NULL, /* 연락처 */
	grade char(1) DEFAULT 'W', /* 등급 */
	dongne1 number(12) NOT NULL, /* 시 */
	dongne2 number(12) NOT NULL, /* 군구 */
	profile_pic VARCHAR2(300) DEFAULT 'images/default_user_image.png', /* 프로필사진 */
	profile_text VARCHAR2(600),/* 프로필소개 */
	regdate DATE DEFAULT sysdate, /* 가입일 */
	birthday DATE, 
	zipcode NUMBER(10),
	address1 varchar2(255),
	address2 varchar2(255),
	use_yn char(1) DEFAULT 'y'
)SEGMENT CREATION IMMEDIATE;

ALTER TABLE MEMBER ADD UNIQUE (email);
ALTER TABLE MEMBER ADD UNIQUE (phone);
ALTER TABLE MEMBER ADD CONSTRAINT PK_MEMBER PRIMARY KEY (id);
	

/* 중고동네_1차 */
CREATE TABLE DONGNE1 (
	id NUMBER(12) NOT NULL, /* 동네1차아이디 */
	name VARCHAR2(36) NOT NULL /* 동네1차이름 */
)SEGMENT CREATION IMMEDIATE;

ALTER TABLE DONGNE1
ADD CONSTRAINT PK_DONGNE1 PRIMARY KEY (id);

/* 중고동네_2차 */
CREATE TABLE DONGNE2 (
	id NUMBER(12) NOT NULL, /* 동네2차아이디 */
	dongne1_id NUMBER(12) NOT NULL, /* 동네1차 아이디 */
	name VARCHAR2(36) NOT NULL /* 동네2차이름 */
)SEGMENT CREATION IMMEDIATE;

ALTER TABLE DONGNE2
ADD CONSTRAINT PK_DONGNE2 PRIMARY KEY (id);
	



/* 중고판매글 */
CREATE TABLE JOONGO_SALE (
	id NUMBER(12) NOT NULL, /* 중고판매글아이디 */
	mem_id VARCHAR2(20) NOT NULL, /* 회원아이디 */
	dog_cate VARCHAR2(1), /* 개카테고리 */
	cat_cate VARCHAR2(1), /* 고양이카테고리 */
	title VARCHAR2(1500) NOT NULL, /* 제목 */
	content VARCHAR2(4000), /* 내용 */
	price NUMBER(10) NOT NULL, /* 가격 */
	dongne1_id NUMBER(12) NOT NULL, /* 동네1차아이디 */
	dongne2_id NUMBER(12) NOT NULL, /* 동네2차아이디 */
	buy_mem_id VARCHAR2(20), /* 구매자 아이디 */
	sale_state varchar2(30) DEFAULT '판매중' NOT NULL, /* 판매상태 */
	regdate DATE NOT NULL, /* 작성일시 */
	hits NUMBER(12) NOT NULL, /* 조회수 */
	heart_count NUMBER(12) DEFAULT 0/* 찜수 */
)SEGMENT CREATION IMMEDIATE;

ALTER TABLE JOONGO_SALE
ADD CONSTRAINT PK_JOONGO_SALE PRIMARY KEY (id);
	
/* 중고_이미지 */
CREATE TABLE JOONGO_IMAGE (
	id NUMBER(12) NOT NULL, /* 이미지아이디 */
	sale_id NUMBER(12) NOT NULL, /* 판매글 */
	image_name VARCHAR2(255) NOT NULL, /* 파일이름 */
	thum_name varchar2(255)
)SEGMENT CREATION IMMEDIATE;

ALTER TABLE JOONGO_IMAGE
ADD CONSTRAINT PK_JOONGO_IMAGE PRIMARY KEY (id);



/* 중고댓글 */
CREATE TABLE JOONGO_COMMENT (
	id NUMBER(12) NOT NULL, /* 새 컬럼 */
	sale_id NUMBER(12) NOT NULL, /* 글 아이디 */
	mem_id VARCHAR2(20) NOT NULL, /* 회원아이디 */
	origin_id NUMBER(12), /* 원댓ID */
	tag_mem_id VARCHAR2(20), /* 사용자태그 대상 */
	content VARCHAR2(4000) NOT NULL, /* 내용 */
	regdate DATE DEFAULT sysdate /* 등록일시 */
)SEGMENT CREATION IMMEDIATE;

ALTER TABLE JOONGO_COMMENT
ADD CONSTRAINT PK_JOONGO_COMMENT PRIMARY KEY (id);

/* 중고_찜 */
CREATE TABLE JOONGO_HEART (
	id NUMBER(12) NOT NULL, /* 찜아이디 */
	mem_id VARCHAR2(20) NOT NULL, /* 멤버아이디 */
	sale_id NUMBER(12) NOT NULL, /* 하트를 누른 글 */
	regdate DATE NOT NULL /* 등록일 */
)SEGMENT CREATION IMMEDIATE;

ALTER TABLE JOONGO_HEART
ADD CONSTRAINT PK_JOONGO_HEART PRIMARY KEY (id);

/* 중고리뷰 */
CREATE TABLE JOONGO_REVIEW (
	id NUMBER(12) NOT NULL, /* 리뷰글아이디 */
	sale_id NUMBER(12) NOT NULL, /* 중고판매글아이디 */
	writer VARCHAR2(20) NOT NULL, /* 회원아이디 */
	rating NUMBER(2,1) NOT NULL, /* 평점 */
	content VARCHAR2(1500), /* 내용 */
	regdate DATE DEFAULT SYSDATE /* 작성일 */
)SEGMENT CREATION IMMEDIATE;

ALTER TABLE JOONGO_REVIEW
ADD CONSTRAINT PK_JOONGO_REVIEW PRIMARY KEY (id);



/* 중고_구매내역 */
CREATE TABLE JOONGO_MYBUY (
	mem_id VARCHAR2(20) NOT NULL, /* 구매자 아이디 */
	sale_id NUMBER(12) NOT NULL /* 구매상품 아이디 */
)SEGMENT CREATION IMMEDIATE;

/* 중고_판매내역 */
CREATE TABLE JOONGO_MYSALE (
	mem_id VARCHAR2(20) NOT NULL, /* 판매자아이디 */
	sale_id NUMBER(12) NOT NULL /* 판매상품 아이디 */
)SEGMENT CREATION IMMEDIATE;



/* 중고_대화 */
CREATE TABLE JOONGO_CHAT (
	id NUMBER(12) NOT NULL, /* 채팅방아이디 */
	sale_id NUMBER(12) NOT NULL, /* 판매글 */
	sale_mem_id VARCHAR2(20), /* 판매자 아이디 */
	buy_mem_id VARCHAR2(20) NOT NULL, /* 구매자 아이디 */
	regdate DATE DEFAULT SYSDATE, /* 채팅시작일자 */
	latest_date DATE DEFAULT SYSDATE /* 최근채팅일자 */
)SEGMENT CREATION IMMEDIATE;

ALTER TABLE JOONGO_CHAT
ADD CONSTRAINT PK_JOONGO_CHAT PRIMARY KEY (id);

/* 중고_채팅_메시지 */
CREATE TABLE JOONGO_CHAT_MSG (
	id NUMBER(12) NOT NULL, /* 메시지 아이디 */
	chat_id NUMBER(12) NOT NULL, /* 채팅방 아이디 */
	mem_id VARCHAR2(20) NOT NULL, /* 메시지 작성자 */
	content VARCHAR2(1500), /* 내용 */
	regdate DATE NOT NULL, /* 발송일시 */
	read_yn VARCHAR2(1) NOT NULL, /* 읽음여부 */
	image VARCHAR2(255) /* 사진 */
)SEGMENT CREATION IMMEDIATE;

ALTER TABLE JOONGO_CHAT_MSG
ADD CONSTRAINT PK_JOONGO_CHAT_MSG PRIMARY KEY (id);


/*등급*/
CREATE TABLE grade(
	code char(1) NOT NULL, 
	name varchar2(20) NOT NULL
);

ALTER TABLE grade
ADD CONSTRAINT PK_GRADE PRIMARY KEY (code);

/*공지시항*/
CREATE TABLE notice(
	id NUMBER(12) NOT NULL,  /* 번호 */
	title VARCHAR2(50), /* 제목 */
	contents VARCHAR2(2000), /* 내용 */
	regdate DATE NOT NULL, /* 등록일*/
	notice_yn char(1) DEFAULT 'n', /*공지여부*/
	notice_file varchar2(1000),	/*첨부파일 경로*/
	writer VARCHAR2(20) NOT NULL,
	hits NUMBER DEFAULT 0
);

ALTER TABLE notice
ADD CONSTRAINT PK_notice PRIMARY KEY (id);

ALTER TABLE MEMBER
	ADD
		CONSTRAINT FK_GRADE_TO_MEMBER
		FOREIGN KEY (
			grade
		)
		REFERENCES grade (
			code
		);



ALTER TABLE JOONGO_COMMENT
	ADD
		CONSTRAINT FK_MEMBER_TO_JOONGO_COMMENT
		FOREIGN KEY (
			mem_id
		)
		REFERENCES MEMBER (
			id
		);

ALTER TABLE JOONGO_COMMENT
	ADD
		CONSTRAINT FK_JNG_COMMENT_TO_JNG_CMNT
		FOREIGN KEY (
			origin_id
		)
		REFERENCES JOONGO_COMMENT (
			id
		);

ALTER TABLE JOONGO_COMMENT
	ADD
		CONSTRAINT FK_MEMBER_TO_JOONGO_COMMENT2
		FOREIGN KEY (
			tag_mem_id
		)
		REFERENCES MEMBER (
			id
		);

ALTER TABLE JOONGO_COMMENT
	ADD
		CONSTRAINT FK_JNG_SALE_TO_JOONGO_CMNT
		FOREIGN KEY (
			sale_id
		)
		REFERENCES JOONGO_SALE (
			id
		);

ALTER TABLE JOONGO_MYSALE
	ADD
		CONSTRAINT FK_MEMBER_TO_JOONGO_MYSALE
		FOREIGN KEY (
			mem_id
		)
		REFERENCES MEMBER (
			id
		);

ALTER TABLE JOONGO_MYSALE
	ADD
		CONSTRAINT FK_JNG_SALE_TO_JOONGO_MSL
		FOREIGN KEY (
			sale_id
		)
		REFERENCES JOONGO_SALE (
			id
		);

ALTER TABLE JOONGO_SALE
	ADD
		CONSTRAINT FK_MEMBER_TO_JOONGO_SALE
		FOREIGN KEY (
			mem_id
		)
		REFERENCES MEMBER (
			id
		);

ALTER TABLE JOONGO_SALE
	ADD
		CONSTRAINT FK_DONGNE2_TO_JOONGO_SALE
		FOREIGN KEY (
			dongne2_id
		)
		REFERENCES DONGNE2 (
			id
		);

ALTER TABLE JOONGO_CHAT
	ADD
		CONSTRAINT FK_JOONGO_SALE_TO_JOONGO_CHAT
		FOREIGN KEY (
			sale_id
		)
		REFERENCES JOONGO_SALE (
			id
		);

ALTER TABLE JOONGO_CHAT
	ADD
		CONSTRAINT FK_MEMBER_TO_JOONGO_CHAT2
		FOREIGN KEY (
			buy_mem_id
		)
		REFERENCES MEMBER (
			id
		);

ALTER TABLE DONGNE2
	ADD
		CONSTRAINT FK_DONGNE1_TO_DONGNE2
		FOREIGN KEY (
			dongne1_id
		)
		REFERENCES DONGNE1 (
			id
		);

ALTER TABLE JOONGO_MYBUY
	ADD
		CONSTRAINT FK_MEMBER_TO_JOONGO_MYBUY
		FOREIGN KEY (
			mem_id
		)
		REFERENCES MEMBER (
			id
		);

ALTER TABLE JOONGO_MYBUY
	ADD
		CONSTRAINT FK_JOONGO_SALE_TO_JOONGO_MYBUY
		FOREIGN KEY (
			sale_id
		)
		REFERENCES JOONGO_SALE (
			id
		);

ALTER TABLE JOONGO_IMAGE
	ADD
		CONSTRAINT FK_JOONGO_SALE_TO_JOONGO_IMAGE
		FOREIGN KEY (
			sale_id
		)
		REFERENCES JOONGO_SALE (
			id
		);

ALTER TABLE JOONGO_CHAT_MSG
	ADD
		CONSTRAINT FK_JNG_CHAT_TO_JNG_CHT_MSG
		FOREIGN KEY (
			chat_id
		)
		REFERENCES JOONGO_CHAT (
			id
		)
	ON DELETE CASCADE;

ALTER TABLE JOONGO_HEART
	ADD
		CONSTRAINT FK_MEMBER_TO_JOONGO_HEART
		FOREIGN KEY (
			mem_id
		)
		REFERENCES MEMBER (
			id
		);

ALTER TABLE JOONGO_HEART
	ADD
		CONSTRAINT FK_JOONGO_SALE_TO_JOONGO_HEART
		FOREIGN KEY (
			sale_id
		)
		REFERENCES JOONGO_SALE (
			id
		);

ALTER TABLE JOONGO_REVIEW
	ADD
		CONSTRAINT FK_JNG_SALE_TO_JOONGO_RVW
		FOREIGN KEY (
			sale_id
		)
		REFERENCES JOONGO_SALE (
			id
		);

ALTER TABLE JOONGO_REVIEW
	ADD
		CONSTRAINT FK_MEMBER_TO_JOONGO_REVIEW
		FOREIGN KEY (
			writer
		)
		REFERENCES MEMBER (
			id
		);