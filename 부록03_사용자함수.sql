/*
    사용자 함수(FUNCTION)
    1. 함수를 사용자가 만들어서 사용할 수 있다.
    2. 사용자 함수 호출은 대부분 SELECT 문에서 이루어진다.
    3. 형식
        CREATE [OR REPLACE] FUNCTION 함수명[(파라미터)]
        RETURN 반환타입
        AS  -- IS도 가능
            [변수 선언]
        BEGIN
            함수본문
            [RETURN 반환값]
        [EXCEPTION 예외처리]
        END;
*/



-- 내장 함수 ABS 분석하기
SELECT ABS(-5)
  FROM DUAL;

-- 함수명   : ABS
-- 파라미터 : -5를 저장하는 변수
-- 반환타입 : NUMBER
-- 반환값   : 파라미터의 절대값 5



-- 사용자 함수 MY_ABS 정의
CREATE OR REPLACE FUNCTION MY_ABS(N NUMBER)
RETURN NUMBER  -- 반환타입은 NUMBER, VARCHAR2처럼 크기 지정을 하지 않는다.
AS
    RES NUMBER;  -- 절대값 결과 저장할 변수
BEGIN
    IF N < 0 THEN
        RES := N * -1;
    ELSE
        RES := N;
    END IF;
    RETURN RES;  -- 절대값 결과를 반환
END;

-- 사용자 함수 MY_ABS 호출
SELECT MY_ABS(-5)
  FROM DUAL;



-- 사원번호를 전달하면 해당 사원의 FULL_NAME을 반환하는 사용자 함수
CREATE OR REPLACE FUNCTION GET_NAME(EMPLOYEEID EMPLOYEES.EMPLOYEE_ID%TYPE)
RETURN VARCHAR2
AS
    FIRSTNAME EMPLOYEES.FIRST_NAME%TYPE;
    LASTNAME  EMPLOYEES.LAST_NAME%TYPE;
BEGIN
    SELECT FIRST_NAME, LAST_NAME
      INTO FIRSTNAME, LASTNAME
      FROM EMPLOYEES
     WHERE EMPLOYEE_ID = EMPLOYEEID;
    RETURN FIRSTNAME || ' ' || LASTNAME;
EXCEPTION
    WHEN OTHERS THEN
        RETURN 'NO_NAME';  -- 문제가 발생하면 'NO_NAME' 반환
END;

SELECT EMPLOYEE_ID
     , GET_NAME(EMPLOYEE_ID) AS FULL_NAME
  FROM EMPLOYEES;



-- HR 계정으로 접속을 바꿔서 처리
-- HR 계정에 사용자 함수를 만들어 두고 싶지 않아서,
-- WITH 문으로 사용자 함수를 만들고 곧바로 사용해 보기

WITH
    FUNCTION GET_DEPT_NAME(DEPTID DEPARTMENTS.DEPARTMENT_ID%TYPE)
    RETURN VARCHAR2
    AS
        DEPTNAME DEPARTMENTS.DEPARTMENT_NAME%TYPE;  -- 결과(부서명)를 저장할 변수
    BEGIN
        SELECT DEPARTMENT_NAME INTO DEPTNAME
          FROM DEPARTMENTS
         WHERE DEPARTMENT_ID = DEPTID;
        RETURN DEPTNAME;
    END;
SELECT EMPLOYEE_ID
     , GET_DEPT_NAME(DEPARTMENT_ID) AS DEPT_NAME
  FROM EMPLOYEES;
