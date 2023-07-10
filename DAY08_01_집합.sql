/*
    집합
    1. 2개 이상의 테이블을 한 번에 조회하는 방식 중 하나이다.
    2. 모든 SELECT 절의 칼럼 순서와 타입이 일치해야 한다.
    3. 집합연산자
        1) UNION     : 합집합, 중복 값은 한 번만 조회
        2) UNION ALL : 합집합, 중복 값도 그대로 조회
        3) INTERSECT : 교집합, 중복 값은 한 번만 조회
        4) MINUS     : 차집합, 첫 번째 SELECT 결과에서 두 번째 SELECT 결과를 뺀다.
    4. 형식
        SELECT 칼럼1, 칼럼2, ...
          FROM 테이블1
         집합연산자
        SELECT 칼럼1, 칼럼2, ...
          FROM 테이블2
        [ORDER BY 정렬]
*/

-- 합집합

SELECT 1, 2
  FROM DUAL
 UNION
SELECT 3, 4
  FROM DUAL;

SELECT 1, 2
  FROM DUAL
 UNION      -- 중복을 제거한 합집합
SELECT 1, 2
  FROM DUAL;

SELECT 1, 2
  FROM DUAL
 UNION ALL  -- 중복을 그대로 조회하는 합집합
SELECT 1, 2
  FROM DUAL;

-- 사원 테이블과 부서 테이블에 존재하는 모든 부서번호를 조회하기
SELECT DEPARTMENT_ID
  FROM DEPARTMENTS
 UNION
SELECT DEPARTMENT_ID
  FROM EMPLOYEES;

SELECT DEPARTMENT_ID
  FROM DEPARTMENTS
 UNION ALL
SELECT DEPARTMENT_ID
  FROM EMPLOYEES;


-- 사원 테이블과 부서 테이블에 모두 존재하는 부서번호 조회하기
-- (사원들이 근무 중인 부서번호만 조회하기)
SELECT DEPARTMENT_ID
  FROM DEPARTMENTS
INTERSECT
SELECT DEPARTMENT_ID
  FROM EMPLOYEES;


-- 부서 테이블에 존재하지만 사원 테이블에 존재하지 않는 부서번호 조회하기
-- (유령부서 조회하기)
SELECT DEPARTMENT _ID
  FROM DEPARTMENTS
 MINUS
SELECT DEPARTMENT_ID
  FROM EMPLOYEES;



-- 활용1. WITH문과 재귀 쿼리
WITH MY_SUBQUERY(N, TOTAL) AS (     -- N, TOTAL은 MY_SUBQUERY의 칼럼을 의미한다.
    SELECT 1, 1                     -- N=1, TOTAL=1을 의미하는 초기화 서브쿼리
      FROM DUAL
     UNION ALL
    SELECT N + 1, TOTAL + (N + 1)   -- N = N + 1, TOTAL = TOTAL + (N + 1) 방식으로 반복해서 처리되는 부분
      FROM MY_SUBQUERY
     WHERE N < 10
)
SELECT N, TOTAL FROM MY_SUBQUERY;



-- 활용2. WITH문과 재귀 쿼리를 활용한 사원의 레벨 표시하기
-- MANAGER가 몇 명인가에 따른 LVL 표시하기
-- MANAGER가 0명이다 : LVL = 1
-- MANAGER가 1명이다 : LVL = 2
WITH MY_SUBQUERY(LVL, EMPLOYEE_ID, FIRST_NAME, LAST_NAME, MANAGER_ID) AS (
    -- 초기값(LVL = 1)을 지정하는 서브쿼리
    SELECT 1, EMPLOYEE_ID, FIRST_NAME, LAST_NAME, MANAGER_ID
      FROM EMPLOYEES
     WHERE MANAGER_ID IS NULL
     UNION ALL
    -- 반복해서 호출되는 서브쿼리
    SELECT M.LVL + 1 AS LVL, E.EMPLOYEE_ID, E.FIRST_NAME, E.LAST_NAME, E.MANAGER_ID
      FROM EMPLOYEES E INNER JOIN MY_SUBQUERY M
        ON E.MANAGER_ID = M.EMPLOYEE_ID
)
SELECT LVL, EMPLOYEE_ID, FIRST_NAME, LAST_NAME, MANAGER_ID
  FROM MY_SUBQUERY;