-- 1. Modify the query to show data from Spain

SELECT name, DAY(whn), confirmed, deaths, recovered
  FROM covid
 WHERE name = 'Spain'
    AND MONTH(whn) = 3 AND YEAR(whn) = 2020
 ORDER BY whn;

-- 2. Modify the query to show confirmed for the day before.

SELECT name, DAY(whn), confirmed,
   LAG(confirmed, 1) OVER (PARTITION BY name ORDER BY confirmed) AS dbf
  FROM covid
 WHERE name = 'Italy'
    AND MONTH(whn) = 3 AND YEAR(whn) = 2020
 ORDER BY whn;

-- 3. Show the number of new cases for each day, for Italy, for March.

SELECT name, DAY(whn), confirmed - LAG(confirmed, 1) OVER (PARTITION BY name ORDER BY whn)
  FROM covid
 WHERE name = 'Italy' AND MONTH(whn) = 3 AND YEAR (whn) = 2020
 ORDER BY whn;

-- 4. Show the number of new cases in Italy for each week in 2020 - show Monday only.

SELECT name, DATE_FORMAT (whn,'%Y-%m-%d'), confirmed - LAG(confirmed, 1) OVER (PARTITION BY name ORDER BY whn)
  FROM covid
 WHERE name = 'Italy'
    AND WEEKDAY(whn) = 0 AND YEAR(whn) = 2020
 ORDER BY whn;

