-- fastfood, TAX 테이블,데이터 생성 --
SELECT *
FROM fastfood ;

-- 실습1. 프렌차이즈 도시발전수 쿼리 작성하기
--순위 시도 시군구 도시발전지수 kfc건수 맥도날드 버거킹 롯데리아
--1               4.5       3      4      5      6
--2               
--3

SELECT a.sido, a.sigungu, a.cnt, b.cnt, ROUND(a.cnt/b.cnt) di
FROM
(SELECT sido, sigungu , COUNT(*) cnt
FROM fastfood
WHERE gb IN('KFC', '맥도날드', '버거킹') 
GROUP BY sido, sigungu )a,

(SELECT sido, sigungu, COUNT(*) cnt
FROM fastfood
WHERE gb = '롯데리아' 
GROUP BY sido, sigungu)b
WHERE a.sido = b.sido
AND a.sigungu = b.sigungu
ORDER BY di DESC;
---------------------------------------------------------
또다른 방법1.

SELECT sido, sigungu, 
        ROUND((NVL(SUM(DECODE(gb, 'KFC', cnt)),0)  +
        NVL(SUM(DECODE(gb, '버거킹', cnt)),0)  +
        NVL(SUM(DECODE(gb, '맥도날드', cnt)),0)) /
           NVL(SUM(DECODE(gb, '롯데리아', cnt)),1),2) di
FROM
(SELECT sido, sigungu, gb, COUNT(*) cnt
FROM fastfood
WHERE gb IN('KFC', '롯데리아', '버거킹', '맥도날드') 
GROUP BY sido, sigungu, gb)
GROUP BY sido, sigungu
ORDER BY di DESC;
