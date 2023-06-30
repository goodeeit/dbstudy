/*
    1:M 관계
    1. 2개의 테이블을 관계 짓는 가장 대표적인 관계이다.
    2. 1    :   M
       PK   :   FK
       부모 :   자식
    3. 반드시 부모 테이블을 먼저 만들고, 자식 테이블은 나중에 만들어야 한다.
    4. 반드시 자식 테이블을 먼저 지우고, 부모 테이블은 나중에 지워야 한다.
*/

/*
    삭제 옵션
    1. ON DELETE CASCADE  : 외래키가 참조하는 기본키 값이 삭제되면 외래키도 함께 삭제한다.
    2. ON DELETE SET NULL : 외래키가 참조하는 기본키 값이 삭제되면 외래키를 NULL로 처리한다.
*/


-- 자식 먼저 지우기
DROP TABLE STUDENT_T;

-- 부모 나중에 지우기
DROP TABLE SCHOOL_T;


-- 부모 먼저 만들기
CREATE TABLE SCHOOL_T (
    SCH_CODE NUMBER            NOT NULL
  , SCH_NAME VARCHAR2(10 BYTE) NOT NULL
  , CONSTRAINT PK_SCH PRIMARY KEY(SCH_CODE)  -- 제약조건의 이름은 PK_SCH, SCH_CODE에 PRIMARY KEY 지정
);

-- 자식 나중에 만들기
CREATE TABLE STUDENT_T (
    STU_NO   NUMBER NOT NULL
  , SCH_CODE NUMBER
  , STU_NAME VARCHAR2(10 BYTE) NOT NULL
  , CONSTRAINT PK_STU PRIMARY KEY(STU_NO)  -- 제약조건의 이름은 PK_STU, STU_NO에 PRIMARY KEY 지정
  , CONSTRAINT FK_SCH_STU FOREIGN KEY(SCH_CODE) REFERENCES SCHOOL_T(SCH_CODE) ON DELETE CASCADE  -- 제약조건의 이름은 FK_SCH_STU, SCH_CODE는 SCHOOL_T 테이블의 SCH_CODE를 참조한다.
);