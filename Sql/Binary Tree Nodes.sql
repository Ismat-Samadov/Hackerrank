-- You are given a table, BST, containing two columns: N and P, where N represents the value of a node in Binary Tree, and P is the parent of N.



-- Write a query to find the node type of Binary Tree ordered by the value of the node. Output one of the following for each node:

-- Root: If node is root node.
-- Leaf: If node is leaf node.
-- Inner: If node is neither root nor leaf node.
-- Sample Input



-- Sample Output

-- 1 Leaf
-- 2 Inner
-- 3 Leaf
-- 5 Root
-- 6 Leaf
-- 8 Inner
-- 9 Leaf

-- Explanation

-- The Binary Tree below illustrates the sample:



-- 10
-- /*
-- 11
-- Enter your query here.
-- 12
-- Please append a semicolon ";" at the end of the query and enter your query in a single line to avoid error.
-- 13
-- */
-- Line: 1 Col: 1
-- Run Code Submit CodeUpload Code as File
-- BlogScoring
SELECT n,
       CASE
         WHEN p IS NULL THEN 'Root'
         WHEN (SELECT Count(*)
               FROM   bst
               WHERE  p = A.n) > 0 THEN 'Inner'
         ELSE 'Leaf'
       END AS Types
FROM   bst A
ORDER  BY n; 
