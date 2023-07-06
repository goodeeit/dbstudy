/*
    SELECT 문의 실행 순서
    
    SELECT 칼럼       5
      FROM 테이블     1
     WHERE 조건       2
     GROUP BY 그룹    3
    HAVING 그룹조건   4
     ORDER BY 정렬    6
*/

-- 사원 테이블에서 부서별 사원수를 조회하시오.
-- 가능
SELECT DEPARTMENT_ID, COUNT(*)  -- 3
  FROM EMPLOYEES                -- 1
 GROUP BY DEPARTMENT_ID;        -- 2
 
-- 불가능
SELECT DEPARTMENT_ID AS DEPT_ID, COUNT(*)  -- 3
  FROM EMPLOYEES                           -- 1
 GROUP BY DEPT_ID;                         -- 2 (GROUP BY 절이 실행되는 순서에서는 DEPT_ID가 존재하지 않기 때문에 오류가 발생)


-- 사원 테이블에서 부서별 연봉 평균과 사원수를 조회하시오. 부서별 사원수가 2명 이상인 부서만 조회하시오.
-- 불가능
SELECT DEPARTMENT_ID         AS 부서번호
     , ROUND(AVG(SALARY), 2) AS 평균연봉
     , COUNT(*)              AS 사원수    -- 4
  FROM EMPLOYEES                          -- 1
 GROUP BY DEPARTMENT_ID                   -- 2
HAVING 사원수 >= 2                        -- 3 (HAVING 절이 실행되는 순서에서는 "사원수"가 존재하지 않기 때문에 오류가 발생)
 ORDER BY DEPARTMENT_ID;                  -- 5

-- 가능
SELECT DEPARTMENT_ID         AS 부서번호
     , ROUND(AVG(SALARY), 2) AS 평균연봉
     , COUNT(*)              AS 사원수    -- 4
  FROM EMPLOYEES                          -- 1
 GROUP BY DEPARTMENT_ID                   -- 2
HAVING COUNT(*) >= 2                      -- 3
 ORDER BY 부서번호;                       -- 5 (ORDER BY 절이 실행되기 직전인 SELECT 절에서 "부서번호" 별명이 지정되었기 때문에 사용 가능)