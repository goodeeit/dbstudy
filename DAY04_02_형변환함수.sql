/*
    DUAL 테이블
    1. DUMMY 칼럼 1개를 가지고 있는 테이블이다.
    2. 'X' 값을 가지고 있다.
    3. FROM절이 필요 없는 SELECT문을 사용할 때 DUAL 테이블을 이용한다.
*/


-- 데이터타입변환 : 숫자, 날짜, 문자 등의 데이터타입을 바꿈


/*
    1. 문자 -> 숫자로 변환하기
        TO_NUMBER(문자)    
*/
SELECT TO_NUMBER('123')
  FROM DUAL;


/*
    2. 숫자 -> 문자로 변환하기
        TO_CHAR(숫자, [형식])
*/
SELECT TO_CHAR(1234)
     , TO_CHAR(1234, '999999')  -- '  1234'
     , TO_CHAR(1234, '000000')  -- '001234'
     , TO_CHAR(1234, '9,999')   -- '1,234'
     , TO_CHAR(12345, '9,999')  -- '######' 숫자는 5자리인데, 형식은 4자리만 지정되었다.
     , TO_CHAR(12345, '99,999') -- '12,345'
  FROM DUAL;


/*
    3. 날짜 -> 문자로 변환하기
        TO_CHAR(날짜, [형식])
        
        * 날짜/시간 형식
        1) YY   : 년도 2자리
        2) YYYY : 년도 4자리
        3) MM   : 월 2자리(01~12)
        4) DD   : 일 2자리(01~31)
        5) AM   : 오전 / 오후
        6) HH   : 12시각(01~12)
        7) HH24 : 24시간(00~23)
        8) MI   : 분(00~59)
        9) SS   : 초(00~59)
*/
SELECT TO_CHAR(HIRE_DATE, 'YYYY-MM-DD')
  FROM EMPLOYEES;

/*
    4. 문자 -> 날짜로 변환하기
        TO_DATE(문자, [형식])
*/

-- 현재 날짜와 시간
SELECT SYSDATE       -- '23/07/04'
     , SYSTIMESTAMP  -- '23/07/04 14:46:44.303000000 +09:00'
  FROM DUAL;

-- 현재 날짜와 시간 - 형식 지정
SELECT TO_CHAR(SYSDATE,      'YYYY-MM-DD AM HH:MI:SS')
     , TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS')
  FROM DUAL;

-- 문자로 된 날짜/시간을 실제 날짜/시간 타입으로 변환하기
SELECT TO_DATE('23/07/04')              -- '년/월/일' 형식으로 해석
     , TO_DATE('23/07/04', 'DD/MM/YY')  -- '일/월/년' 형식으로 해석
  FROM DUAL;

-- 예제 데이터 작성
DROP TABLE EXAMPLE_T;
CREATE TABLE EXAMPLE_T (
    DT1 DATE
  , DT2 TIMESTAMP
);
INSERT INTO EXAMPLE_T(DT1, DT2) VALUES(SYSDATE, SYSTIMESTAMP);
COMMIT;

-- DT1이 '23/07/04'인 데이터를 조회하기(안 됨)
SELECT *
  FROM EXAMPLE_T
 WHERE DT1 = '23/07/04';

-- DT1이 '23/07/04'인 데이터를 조회하기(안 됨)
SELECT *
  FROM EXAMPLE_T
 WHERE DT1 = TO_DATE('23/07/04', 'YY/MM/DD');

-- DT1이 '23/07/04'인 데이터를 조회하기(됨)
SELECT *
  FROM EXAMPLE_T
 WHERE TO_DATE(DT1, 'YY/MM/DD') = TO_DATE('23/07/04', 'YY/MM/DD');
