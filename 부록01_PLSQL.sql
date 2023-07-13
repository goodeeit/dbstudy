/*
    기초데이터 준비
    1. HR 계정의 EMPLOYEES 테이블을 GD 계정으로 복사해서 사용한다.
    2. 테이블을 복사해도 기본키/외래키 제약 조건은 복사가 되지 않는다. 필요하면 제약조건을 추가해야 한다.
*/

-- 테이블 복사
DROP TABLE EMPLOYEES;
CREATE TABLE EMPLOYEES AS (
    SELECT *
      FROM HR.EMPLOYEES
);
-- 기본키 제약 조건 추가
ALTER TABLE EMPLOYEES ADD CONSTRAINT PK_EMP PRIMARY KEY(EMPLOYEE_ID);



/*
    PL/SQL
    1. 오라클 문법이다.
    2. 프로그래밍이 가능한 SQL문 작성 방법이다.
    3. 프로시저, 사용자 함수 등의 기반이 되는 언어이다.
    4. 항상 블록을 잡고 실행한다.
    5. 형식
        [DECLARE 변수 선언]
        BEGIN
            실행문
        END;
*/

/*
    변수 선언하기
    1. 값을 저장할 때 대입 연산자(:=)를 사용한다.
    2. 타입을 선언하는 방식
        1) 스칼라 변수 : 타입을 직접 지정한다.
        2) 참조 변수   : 특정 칼럼의 타입을 그대로 사용한다.
*/

/*
    서버 메시지 출력하기
    1. 기본적으로 서버 메시지는 출력되지 않는다.
    2. 서버 메시지 출력을 위해서 최초 1회 아래 쿼리문을 실행한다.
        SET SERVEROUTPUT ON;
    3. 서버 메시지 출력하는 방법
        DBMS_OUTPUT.PUT_LINE(출력할내용);
*/

-- 서버 메시지 출력 ON
SET SERVEROUTPUT ON;

-- Hello World 출력하기
BEGIN
    DBMS_OUTPUT.PUT_LINE('Hello World');
END;



-- 스칼라 변수(직접 타입을 명시하는 방법)
DECLARE
    NAME VARCHAR2(20 BYTE);
    AGE NUMBER(3);
BEGIN
    NAME := 'tom';
    AGE := 30;
    DBMS_OUTPUT.PUT_LINE('이름은 ' || NAME || '입니다.');
    DBMS_OUTPUT.PUT_LINE('나이는 ' || AGE || '살입니다.');
END;



-- 참조 변수(특정 칼럼의 타입을 명시)
DECLARE
    EMPLOYEEID EMPLOYEES.EMPLOYEE_ID%TYPE;
    FIRSTNAME  EMPLOYEES.FIRST_NAME%TYPE;
    LASTNAME   EMPLOYEES.LAST_NAME%TYPE;
BEGIN
    SELECT EMPLOYEE_ID, FIRST_NAME, LAST_NAME
      INTO EMPLOYEEID, FIRSTNAME, LASTNAME
      FROM EMPLOYEES
     WHERE EMPLOYEE_ID = 100;
    DBMS_OUTPUT.PUT_LINE(EMPLOYEEID || ', ' || FIRSTNAME || ', ' || LASTNAME);
END;



/*
    IF 구문
    
    IF 조건식1 THEN
        실행문1
    ELSIF 조건식2 THEN
        실행문2
    ...
    ELSE
        실행문N
    END IF;
*/

-- 1. 스칼라 변수를 이용한 IF문 처리하기
DECLARE
    SCORE NUMBER(3);
    GRADE VARCHAR2(1 BYTE);
BEGIN
    SCORE := 50;  -- 임의의 점수 저장
    IF SCORE >= 90 THEN
        GRADE := 'A';
    ELSIF SCORE >= 80 THEN
        GRADE := 'B';
    ELSIF SCORE >= 70 THEN
        GRADE := 'C';
    ELSIF SCORE >= 60 THEN
        GRADE := 'D';
    ELSE
        GRADE := 'F';
    END IF;
    DBMS_OUTPUT.PUT_LINE(SCORE || '점은 ' || GRADE || '학점입니다.');
END;

-- 2. 참조 변수를 이용한 IF문 처리
DECLARE
    EMPLOYEEID EMPLOYEES.EMPLOYEE_ID%TYPE;
    SAL        EMPLOYEES.SALARY%TYPE;
BEGIN
    EMPLOYEEID := 150;  -- 임의의 사원번호 저장
    SELECT SALARY
      INTO SAL
      FROM EMPLOYEES
     WHERE EMPLOYEE_ID = EMPLOYEEID;
    IF SAL >= 10000 THEN
        DBMS_OUTPUT.PUT_LINE('고액연봉');
    ELSE
        DBMS_OUTPUT.PUT_LINE('보통연봉');
    END IF;
END;



/*
    CASE 구문
    
    CASE
        WHEN 조건식1 THEN
            실행문1
        WHEN 조건식2 THEN
            실행문2
        ...
        ELSE
            실행문N
    END CASE;
*/

-- 연봉이 가장 높은 사원의 PHONE_NUMBER에 따라 다음을 출력
-- 011 : MOBILE
-- 515 : EAST
-- 590 : WEST
-- 603 : SOUTH
-- 650 : NORTH
DECLARE
    PHONENUMBER EMPLOYEES.PHONE_NUMBER%TYPE;
    MESSAGE     VARCHAR2(6 BYTE);
BEGIN
    SELECT SUBSTR(PHONE_NUMBER, 1, 3)
      INTO PHONENUMBER
      FROM EMPLOYEES
     WHERE SALARY = (SELECT MAX(SALARY)
                       FROM EMPLOYEES);
    CASE
        WHEN PHONENUMBER = '011' THEN
            MESSAGE := 'MOBILE';
        WHEN PHONENUMBER = '515' THEN
            MESSAGE := 'EAST';
        WHEN PHONENUMBER = '590' THEN
            MESSAGE := 'WEST';
        WHEN PHONENUMBER = '603' THEN
            MESSAGE := 'SOUTH';
        WHEN PHONENUMBER = '650' THEN
            MESSAGE := 'NORTH';
    END CASE;
    DBMS_OUTPUT.PUT_LINE(MESSAGE);
END;



/*
    WHILE 구문
    
    WHILE 조건식 LOOP
        실행문
    END LOOP;
*/

-- 1 ~ 5 출력하기
DECLARE
    N NUMBER(1);
BEGIN
    N := 1;
    WHILE N <= 5 LOOP
        DBMS_OUTPUT.PUT_LINE(N);
        N := N + 1;
    END LOOP;
END;

-- 사원번호가 100~109 사이의 사원번호, 사원명 출력하기
DECLARE
    EMPLOYEEID EMPLOYEES.EMPLOYEE_ID%TYPE;
    FIRSTNAME  EMPLOYEES.FIRST_NAME%TYPE;
    LASTNAME   EMPLOYEES.LAST_NAME%TYPE;
BEGIN
    EMPLOYEEID := 100;
    WHILE EMPLOYEEID <= 109 LOOP
        SELECT FIRST_NAME, LAST_NAME
          INTO FIRSTNAME, LASTNAME
          FROM EMPLOYEES
         WHERE EMPLOYEE_ID = EMPLOYEEID;
        DBMS_OUTPUT.PUT_LINE(FIRSTNAME || ' ' || LASTNAME);
        EMPLOYEEID := EMPLOYEEID + 1;
    END LOOP;
END;



/*
    FOR 구문
    
    FOR 변수 IN 시작값..종료값 LOOP
        실행문
    END LOOP;
*/

-- 1 ~ 5 출력하기
DECLARE
    N NUMBER(1);
BEGIN
    FOR N IN 1..5 LOOP
        DBMS_OUTPUT.PUT_LINE(N);
    END LOOP;
END;



/*
    EXIT : 반복문(WHILE, FOR) 종료하기
    CONTINUE : 반복문의 시작부터 다시 실행하기
*/
-- 1부터 누적하기. 누적 결과가 100을 넘어가면 그만 누적하고 출력하기
DECLARE
    N NUMBER;
    TOTAL NUMBER;
BEGIN
    -- 초깃값
    N := 1;
    TOTAL := 0;
    -- 무한루프(끝내고 싶을 때 EXIT를 적어줌)
    WHILE TRUE LOOP
        IF TOTAL > 100 THEN
            EXIT;
        END IF;
        TOTAL := TOTAL + N;
        N := N + 1;
    END LOOP;
    -- 결과 확인
    DBMS_OUTPUT.PUT_LINE(N || ', ' || TOTAL);
END;

-- 1부터 누적하기. 3의 배수는 제외하고 누적하기. 누적 결과가 100이 넘어가면 그만 누적하고 결과 출력하기.
DECLARE
    N NUMBER;
    TOTAL NUMBER;
    MODULAR NUMBER;
BEGIN
    -- 초깃값
    N := 0;
    TOTAL := 0;
    MODULAR := 0;
    -- 무한루프
    WHILE TRUE LOOP
        -- N의 증가
        N := N + 1;
        -- 누적 결과가 100이 넘어가면 그만 누적하기
        IF TOTAL > 100 THEN
            EXIT;
        END IF;
        -- 3의 배수는 누적에서 제외하기
        SELECT MOD(N, 3) INTO MODULAR  -- 3으로 나눈 나머지를 MODULAR 변수에 저장
          FROM DUAL;
        IF MODULAR = 0 THEN
            CONTINUE;  -- WHILE TRUE LOOP문의 첫 실행문으로 되돌아가서 실행하시오.
        END IF;
        -- 누적
        TOTAL := TOTAL + N;
    END LOOP;
    -- 결과 확인
    DBMS_OUTPUT.PUT_LINE(N || ', ' || TOTAL);
END;



/*
    예외처리 구문
    
    EXCEPTION
        WHEN 예외종류1 THEN
            예외처리1
        WHEN 예외종류2 THEN
            예외처리2
        ...
        WHEN OTHERS THEN
            예외처리N
*/

-- 데이터를 찾지 못하는 경우의 예외 : NO_DATA_FOUND
DECLARE
    EMPLOYEEID EMPLOYEES.EMPLOYEE_ID%TYPE;
    FIRSTNAME  EMPLOYEES.FIRST_NAME%TYPE;
BEGIN
    EMPLOYEEID := 0;
    SELECT FIRST_NAME INTO FIRSTNAME
      FROM EMPLOYEES
     WHERE EMPLOYEE_ID = EMPLOYEEID;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE(EMPLOYEEID || '번 사원은 없습니다.');
END;

-- 데이터가 너무 많은 경우 : TOO_MANY_ROWS
DECLARE
    FIRSTNAME EMPLOYEES.FIRST_NAME%TYPE;
BEGIN
    SELECT FIRST_NAME INTO FIRSTNAME
      FROM EMPLOYEES
     WHERE EMPLOYEE_ID BETWEEN 100 AND 206;
EXCEPTION
    WHEN TOO_MANY_ROWS THEN
        DBMS_OUTPUT.PUT_LINE('결과가 너무 많다.');
END;

-- 모든 예외를 처리하는 방법 : OTHERS
DECLARE
    FIRSTNAME EMPLOYEES.FIRST_NAME%TYPE;
BEGIN
    SELECT FIRST_NAME INTO FIRSTNAME
      FROM EMPLOYEES
     WHERE EMPLOYEE_ID BETWEEN 100 AND 206;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE(SQLCODE);  -- 예외코드
        DBMS_OUTPUT.PUT_LINE(SQLERRM);  -- 예외메시지
END;