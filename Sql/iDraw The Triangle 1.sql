-- P(R) represents a pattern drawn by Julia in R rows. The following pattern represents P(5):

-- * * * * * 
-- * * * * 
-- * * * 
-- * * 
-- *
-- Write a query to print the pattern P(20).

SELECT SYS_CONNECT_BY_PATH(NULL, '* ') FROM DUAL 
CONNECT BY ROWNUM <= 20 ORDER BY 1 DESC;
