/*
    프로시저(Procedure)
    1. 여러 쿼리문을 한 번에 수행할 수 있다.
    2. "EXECUTE 프로시저명()" 형식으로 실행할 수 있다. (프로시저 호출)
    3. 형식
        CREATE [OR REPLACE] PROCEDURE 프로시저명
        AS             -- IS를 사용해도 무방
            변수 선언  -- 생략 가능
        BEGIN
            프로시저본문
        [EXCEPTION 예외처리]
        END;
*/



-- 서버 메시지 출력 ON
SET SERVEROUTPUT ON;



-- 프로시저 정의(프로시저 만들기)
CREATE OR REPLACE PROCEDURE MY_PROC_01
AS
    NAME VARCHAR2(20 BYTE);
BEGIN
    NAME := 'tom';
    DBMS_OUTPUT.PUT_LINE(NAME || '님 환영합니다.');
END;

-- 프로시저 호출(프로시저 실행하기)
EXECUTE MY_PROC_01();



-- 사원번호가 100인 사원의 이름을 출력하는 프로시저
CREATE OR REPLACE PROCEDURE MY_PROC_02
IS
    FIRSTNAME EMPLOYEES.FIRST_NAME%TYPE;
    LASTNAME  EMPLOYEES.LAST_NAME%TYPE;
BEGIN
    SELECT FIRST_NAME, LAST_NAME
      INTO FIRSTNAME, LASTNAME
      FROM EMPLOYEES
     WHERE EMPLOYEE_ID = 100;
    DBMS_OUTPUT.PUT_LINE(FIRSTNAME || ' ' || LASTNAME);
END;

EXECUTE MY_PROC_02();


-- 프로시저로 값을 전달하기
-- 사원번호를 전달하면 해당 사원의 이름을 출력하는 프로시저
CREATE OR REPLACE PROCEDURE MY_PROC_03(EMPLOYEEID IN EMPLOYEES.EMPLOYEE_ID%TYPE)  -- 프로시저로 전달된 인수를 저장하는 입력 파라미터
IS
    FIRSTNAME EMPLOYEES.FIRST_NAME%TYPE;
    LASTNAME  EMPLOYEES.LAST_NAME%TYPE;
BEGIN
    SELECT FIRST_NAME, LAST_NAME
      INTO FIRSTNAME, LASTNAME
      FROM EMPLOYEES
     WHERE EMPLOYEE_ID = EMPLOYEEID;
    DBMS_OUTPUT.PUT_LINE(FIRSTNAME || ' ' || LASTNAME);
END;

EXECUTE MY_PROC_03(206);  -- 프로시저로 전달하는 인수 206



-- 프로시저로부터 값을 받아오는 방법
-- 사원번호가 100인 사원의 이름을 받아오는 프로시저
CREATE OR REPLACE PROCEDURE MY_PROC_04(FNAME OUT EMPLOYEES.FIRST_NAME%TYPE, LNAME OUT EMPLOYEES.LAST_NAME%TYPE)  -- FNAME, LNAME은 프로시저 외부로 값을 반환하는 출력 파라미터
AS
BEGIN
    SELECT FIRST_NAME, LAST_NAME
      INTO FNAME, LNAME
      FROM EMPLOYEES
     WHERE EMPLOYEE_ID = 100;
END;

DECLARE
    FIRSTNAME EMPLOYEES.FIRST_NAME%TYPE;
    LASTNAME  EMPLOYEES.LAST_NAME%TYPE;
BEGIN
    MY_PROC_04(FIRSTNAME, LASTNAME);  -- FIRSTNAME, LASTNAME 변수에 결과를 저장해 달라. PLSQL에서 직접 프로시저를 호출할 땐 EXECUTE를 생략한다.
    DBMS_OUTPUT.PUT_LINE(FIRSTNAME || ' ' || LASTNAME);
END;



-- 프로시저 실습하기 기초 데이터 
-- 테이블 삭제하기
DROP TABLE BUY_T;
DROP TABLE CUST_T;
DROP TABLE PROD_T;

--  시퀀스 삭제하기
DROP SEQUENCE BUY_SEQ;

-- 제품 테이블 구성하기
CREATE TABLE PROD_T (
    P_CODE NUMBER NOT NULL
  , P_NAME VARCHAR2(20 BYTE)
  , P_PRICE NUMBER
  , P_STOCK NUMBER
  , CONSTRAINT PK_PROD PRIMARY KEY(P_CODE)
);
INSERT INTO PROD_T(P_CODE, P_NAME, P_PRICE, P_STOCK) VALUES(1000, '홈런볼', 1000, 100);
INSERT INTO PROD_T(P_CODE, P_NAME, P_PRICE, P_STOCK) VALUES(1001, '맛동산', 2000, 100);
COMMIT;

-- 고객 테이블 구성하기
CREATE TABLE CUST_T (
    C_NO NUMBER NOT NULL
  , C_NAME VARCHAR2(20 BYTE)
  , C_POINT NUMBER
  , CONSTRAINT PK_CUST PRIMARY KEY(C_NO)
);
INSERT INTO CUST_T(C_NO, C_NAME, C_POINT) VALUES(1, '정숙', 0);
INSERT INTO CUST_T(C_NO, C_NAME, C_POINT) VALUES(2, '상철', 0);
COMMIT;

-- 구매 테이블 & 구매 시퀀스 구성하기
CREATE TABLE BUY_T (
    B_NO NUMBER NOT NULL
  , C_NO NUMBER NOT NULL
  , P_CODE NUMBER
  , B_AMOUNT NUMBER
  , CONSTRAINT PK_BUY PRIMARY KEY(B_NO)
  , CONSTRAINT FK_PROD_BUY FOREIGN KEY(P_CODE) REFERENCES PROD_T(P_CODE) ON DELETE SET NULL
  , CONSTRAINT FK_CUST_BUY FOREIGN KEY(C_NO) REFERENCES CUST_T(C_NO) ON DELETE CASCADE
);
CREATE SEQUENCE BUY_SEQ ORDER;


/*
    프로시저 실습하기
    
    1. BUY_PROC 프로시저를 작성한다.
    2. 처리할 일
        1) 제품 테이블의 재고를 수정한다.
        2) 고객 테이블의 포인트를 수정한다.
        3) 주문 테이블에 주문내역을 삽입한다.
    3. 프로시저 호출 예시
        BUY_PROC(1, 1000, 10);  고객번호 1이 제품코드 1000을 10개 구매하였다.
*/

CREATE OR REPLACE PROCEDURE BUY_PROC(
  /* 고객번호 */   CNO IN CUST_T.C_NO%TYPE
  /* 제품코드 */ , PCODE IN PROD_T.P_CODE%TYPE
  /* 구매수량 */ , AMOUNT IN BUY_T.B_AMOUNT%TYPE
)
AS
BEGIN
    
    -- 1) 제품 테이블의 재고를 수정한다.
    UPDATE PROD_T
       SET P_STOCK = P_STOCK - AMOUNT
     WHERE P_CODE = PCODE;
    
    -- 2) 고객 테이블의 포인트를 수정한다. (구매액(가격 * 구매수량)의 10%, 소수 이하 올림 처리)
    UPDATE CUST_T
       SET C_POINT = C_POINT + CEIL((SELECT P_PRICE FROM PROD_T WHERE P_CODE = PCODE) * AMOUNT * 0.1)
     WHERE C_NO = CNO;
    
    -- 3) 주문 테이블에 주문내역을 삽입한다.
    INSERT INTO BUY_T(
        B_NO
      , C_NO
      , P_CODE
      , B_AMOUNT
    ) VALUES (
        BUY_SEQ.NEXTVAL
      , CNO
      , PCODE
      , AMOUNT
    );

    -- 4) 커밋
    COMMIT;

EXCEPTION

    WHEN OTHERS THEN  -- 모든 예외 처리
        
        -- 예외 사유 출력
        DBMS_OUTPUT.PUT_LINE(SQLERRM || '(' || SQLCODE || ')');
        
        -- 작업 수행 취소
        ROLLBACK;
        
END;


BEGIN
    BUY_PROC(1, 1000, 10);
END;