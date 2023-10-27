-- Julia conducted a  days of learning SQL contest. The start date of the contest was March 01, 2016 and the end date was March 15, 2016.

-- Write a query to print total number of unique hackers who made at least  submission each day (starting on the first day of the contest), and find the hacker_id and name of the hacker who made maximum number of submissions each day. If more than one such hacker has a maximum number of submissions, print the lowest hacker_id. The query should print this information for each day of the contest, sorted by the date.

-- Input Format

-- The following tables hold contest data:

-- Hackers: The hacker_id is the id of the hacker, and name is the name of the hacker.

-- Submissions: The submission_date is the date of the submission, submission_id is the id of the submission, hacker_id is the id of the hacker who made the submission, and score is the score of the submission. 

-- Sample Input

-- For the following sample input, assume that the end date of the contest was March 06, 2016.

-- Hackers Table:  Submissions Table: 

-- Sample Output

-- 2016-03-01 4 20703 Angela
-- 2016-03-02 2 79722 Michael
-- 2016-03-03 2 20703 Angela
-- 2016-03-04 2 20703 Angela
-- 2016-03-05 1 36396 Frank
-- 2016-03-06 1 20703 Angela
-- Explanation

-- On March 01, 2016 hackers , , , and  made submissions. There are  unique hackers who made at least one submission each day. As each hacker made one submission,  is considered to be the hacker who made maximum number of submissions on this day. The name of the hacker is Angela.

-- On March 02, 2016 hackers , , and  made submissions. Now  and  were the only ones to submit every day, so there are  unique hackers who made at least one submission each day.  made  submissions, and name of the hacker is Michael.

-- On March 03, 2016 hackers , , and  made submissions. Now  and  were the only ones, so there are  unique hackers who made at least one submission each day. As each hacker made one submission so  is considered to be the hacker who made maximum number of submissions on this day. The name of the hacker is Angela.

-- On March 04, 2016 hackers , , , and  made submissions. Now  and  only submitted each day, so there are  unique hackers who made at least one submission each day. As each hacker made one submission so  is considered to be the hacker who made maximum number of submissions on this day. The name of the hacker is Angela.

-- On March 05, 2016 hackers , ,  and  made submissions. Now  only submitted each day, so there is only  unique hacker who made at least one submission each day.  made  submissions and name of the hacker is Frank.

-- On March 06, 2016 only  made submission, so there is only  unique hacker who made at least one submission each day.  made  submission and name of the hacker is Angela.
WITH submissionsperday AS (
    SELECT
        s.submission_date,
        h.hacker_id,
        h.name,
        COUNT(s.submission_id) AS submissions_count
    FROM
        submissions   s
        JOIN hackers       h ON s.hacker_id = h.hacker_id
    GROUP BY
        s.submission_date,
        h.hacker_id,
        h.name
), rankedsubmissions AS (
    SELECT
        submission_date,
        hacker_id,
        RANK() OVER(
            PARTITION BY submission_date
            ORDER BY
                submissions_count DESC, hacker_id
        ) AS rank
    FROM
        submissionsperday
), daywiserank AS (
    SELECT
        submission_date,
        hacker_id,
        DENSE_RANK() OVER(
            ORDER BY
                submission_date
        ) AS day_rank
    FROM
        submissions
), hackercounttilldate AS (
    SELECT
        s.submission_date,
        s.hacker_id,
        CASE
            WHEN s.submission_date = DATE '2016-03-01' THEN
                1
            ELSE
                1 + (
                    SELECT
                        COUNT(DISTINCT s1.submission_date)
                    FROM
                        submissions s1
                    WHERE
                        s1.hacker_id = s.hacker_id
                        AND s1.submission_date < s.submission_date
                )
        END AS prev_count,
        r.day_rank
    FROM
        daywiserank   r
        JOIN submissions   s ON r.submission_date = s.submission_date
                              AND r.hacker_id = s.hacker_id
), hackersubmissionseachday AS (
    SELECT
        submission_date,
        COUNT(DISTINCT hacker_id) AS hacker_count
    FROM
        hackercounttilldate
    WHERE
        prev_count = day_rank
    GROUP BY
        submission_date
)
SELECT
    hse.submission_date,
    hse.hacker_count AS unique_hackers_count,
    rs.hacker_id,
    h.name
FROM
    hackersubmissionseachday   hse
    JOIN rankedsubmissions          rs ON hse.submission_date = rs.submission_date
                                 AND rs.rank = 1
    JOIN hackers                    h ON rs.hacker_id = h.hacker_id;