-- Pivot the Occupation column in OCCUPATIONS so that each Name is sorted alphabetically and displayed underneath its corresponding Occupation. The output column headers should be Doctor, Professor, Singer, and Actor, respectively.

-- Note: Print NULL when there are no more names corresponding to an occupation.

-- Input Format

-- The OCCUPATIONS table is described as follows:



-- Occupation will only contain one of the following values: Doctor, Professor, Singer or Actor.

-- Sample Input



-- Sample Output

-- Jenny    Ashley     Meera  Jane
-- Samantha Christeen  Priya  Julia
-- NULL     Ketty      NULL   Maria
-- Explanation

-- The first column is an alphabetically ordered list of Doctor names.
-- The second column is an alphabetically ordered list of Professor names.
-- The third column is an alphabetically ordered list of Singer names.
-- The fourth column is an alphabetically ordered list of Actor names.
-- The empty cell data for columns with less than the maximum number of names per occupation (in this case, the Professor and Actor columns) are fille

WITH cte
     AS (SELECT NAME,
                occupation,
                CASE
                  WHEN occupation = 'Doctor' THEN NAME
                END                AS Doctor,
                CASE
                  WHEN occupation = 'Professor' THEN NAME
                END                AS Professor,
                CASE
                  WHEN occupation = 'Singer' THEN NAME
                END                AS Singer,
                CASE
                  WHEN occupation = 'Actor' THEN NAME
                END                AS Actor,
                Row_number()
                  OVER (
                    partition BY occupation
                    ORDER BY NAME) ROW_NUM
         FROM   occupations
         ORDER  BY row_num,
                   NAME)
SELECT Max(doctor)    AS Doctor,
       Max(professor) AS Professor,
       Max(singer)    AS Singer,
       Max(actor)     AS Actor
FROM   cte
GROUP  BY row_num
ORDER  BY row_num; 
