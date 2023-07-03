/*
    DML
    1. Data Manipulation Language
    2. 데이터(행, Row)를 조작(삽입, 수정, 삭제)하는 언어이다.
    3. 트랜잭션 대상이다.(작업이 완료되면 COMMIT, 작업을 취소하려면 ROLLBACK이 필요한다.)
        1) COMMIT   : 작업을 저장한다. COMMIT이 완료된 작업은 ROLLBACK으로 취소할 수 없다.
        2) ROLLBACK : 작업을 취소한다. COMMIT 이후 작업을 취소한다.
    4. 종류
        1) 삽입 : INSERT INTO VALUES
        2) 수정 : UPDATE SET WHERE
        3) 삭제 : DELETE FROM WHERE
*/

-- 참고.
-- 자격증에서는 DML의 범주를 INSERT,UPDATE,DELETE + SELECT로 보기도 한다.

-- 테이블 삭제
DROP TABLE EMPLOYEE_T;
DROP TABLE DEPARTMENT_T;

-- DEPARTMENT_T 테이블 생성
CREATE TABLE DEPARTMENT_T (
    DEPT_NO   NUMBER            NOT NULL
  , DEPT_NAME VARCHAR2(15 BYTE) NOT NULL
  , LOCATION  VARCHAR2(15 BYTE) NOT NULL
  , CONSTRAINT PK_DEPART PRIMARY KEY(DEPT_NO)
);

-- EMPLOYEE_T 테이블 생성
CREATE TABLE EMPLOYEE_T (
    EMP_NO    NUMBER            NOT NULL
  , NAME      VARCHAR2(20 BYTE) NOT NULL
  , DEPART    NUMBER            NULL
  , POSITION  VARCHAR2(20 BYTE) NULL
  , GENDER    CHAR(2 BYTE)      NULL
  , HIRE_DATE DATE              NULL
  , SALARY    NUMBER            NULL
  , CONSTRAINT PK_EMPLOYEE PRIMARY KEY(EMP_NO)
  , CONSTRAINT FK_DEPART_EMP FOREIGN KEY(DEPART) REFERENCES DEPARTMENT_T(DEPT_NO) ON DELETE SET NULL
);

-- 부서번호를 생성하는 시퀀스 만들기
/*
CREATE SEQUENCE DEPT_SEQ
    INCREMENT BY 1  -- 1씩 증가하는 번호를 만든다.(디폴트)
    START WITH 1    -- 1부터 번호를 만든다.(디폴트)
    NOMAXVALUE      -- 번호의 상한선이 없다.(디폴트)
    NOMINVALUE      -- 번호의 하한선이 없다.(디폴트)
    NOCYCLE         -- 번호 순환이 없다.(디폴트)
    CACHE 20        -- 20개씩 번호를 미리 만들어 둔다.(디폴트)
    NOORDER         -- 번호를 순서대로 사용하지 않는다.(디폴트) - 번호를 순서대로 사용하는 ORDER 옵션으로 바꿔서 시퀀스를 생성한다.
;
*/
DROP SEQUENCE DEPT_SEQ;
CREATE SEQUENCE DEPT_SEQ ORDER;

INSERT INTO DEPARTMENT_T(DEPT_NO, DEPT_NAME, LOCATION) VALUES(DEPT_SEQ.NEXTVAL, '영업부', '대구');
INSERT INTO DEPARTMENT_T(DEPT_NO, DEPT_NAME, LOCATION) VALUES(DEPT_SEQ.NEXTVAL, '인사부', '서울');
INSERT INTO DEPARTMENT_T(DEPT_NO, DEPT_NAME, LOCATION) VALUES(DEPT_SEQ.NEXTVAL, '총무부', '대구');
INSERT INTO DEPARTMENT_T(DEPT_NO, DEPT_NAME, LOCATION) VALUES(DEPT_SEQ.NEXTVAL, '기획부', '서울');
COMMIT;


-- 사원번호를 생성하는 시퀀스
DROP SEQUENCE EMP_SEQ;
CREATE SEQUENCE EMP_SEQ
    START WITH 1001
    ORDER;

-- 사원 데이터 입력
INSERT INTO EMPLOYEE_T VALUES(EMP_SEQ.NEXTVAL, '구창민', 1, '과장', 'M', '95-05-01', 5000000);  -- 날짜는 하이픈(-) 또는 슬래시(/)로 구분
INSERT INTO EMPLOYEE_T VALUES(EMP_SEQ.NEXTVAL, '김민서', 1, '사원', 'M', '17-09-01', 2500000);  -- 날짜는 하이픈(-) 또는 슬래시(/)로 구분
INSERT INTO EMPLOYEE_T VALUES(EMP_SEQ.NEXTVAL, '이은영', 2, '부장', 'F', '90/09/01', 5500000);  -- 날짜는 하이픈(-) 또는 슬래시(/)로 구분
INSERT INTO EMPLOYEE_T VALUES(EMP_SEQ.NEXTVAL, '한성일', 2, '과장', 'M', '93/04/01', 5000000);  -- 날짜는 하이픈(-) 또는 슬래시(/)로 구분
COMMIT;
