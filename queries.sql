-- Part 2 - SQL Queries

-- 1. list all active students
SELECT student_id, full_name, email, batch_id, admission_date
FROM students
WHERE enrollment_status = 'Active';

-- 2. find students whose email is missing or invalid
SELECT *
FROM students
WHERE email IS NULL OR email NOT LIKE '%@%.%';

-- 3. list all problems with difficulty Easy or Medium
SELECT *
FROM problems
WHERE difficulty = 'Easy' OR difficulty = 'Medium';

-- 4. display latest 20 submissions based on submitted time
SELECT *
FROM submissions
ORDER BY submitted_at DESC
LIMIT 20;

-- 5. find submissions where status is not successful
SELECT *
FROM submissions
WHERE status != 'Accepted';

-- Joins

-- 6. display each submission with student name, problem title, language, status, score and time
SELECT st.full_name, p.title, s.language, s.status, s.score, s.submitted_at
FROM submissions s
JOIN students st ON s.student_id = st.student_id
JOIN problems p ON s.problem_id = p.problem_id;

-- 7. display all students and their enrollments including students not enrolled in any course
SELECT st.full_name, st.email, e.course_id, e.enrollment_status
FROM students st
LEFT JOIN enrollments e ON st.student_id = e.student_id;

-- 8. display all courses with number of enrolled students
SELECT c.course_title, COUNT(e.student_id) as total_students
FROM courses c
LEFT JOIN enrollments e ON c.course_id = e.course_id
GROUP BY c.course_id;

-- 9. display test case results for each submission including problem title and student name
SELECT st.full_name, p.title, s.submission_id, tc.case_no, tr.result_status, tr.awarded_points
FROM test_results tr
JOIN submissions s ON tr.submission_id = s.submission_id
JOIN students st ON s.student_id = st.student_id
JOIN problems p ON s.problem_id = p.problem_id
JOIN test_cases tc ON tr.test_case_id = tc.test_case_id;

-- 10. find students enrolled in a course but never submitted any solution for that course
SELECT st.full_name, e.course_id
FROM enrollments e
JOIN students st ON e.student_id = st.student_id
WHERE NOT EXISTS (
    SELECT 1 FROM submissions s
    JOIN problems p ON s.problem_id = p.problem_id
    WHERE s.student_id = e.student_id
    AND p.course_id = e.course_id
);

-- Aggregation and HAVING

-- 11. count submissions by status
SELECT status, COUNT(*) as total
FROM submissions
GROUP BY status;

-- 12. calculate average score per problem
SELECT p.title, AVG(s.score) as avg_score
FROM submissions s
JOIN problems p ON s.problem_id = p.problem_id
GROUP BY s.problem_id, p.title;

-- 13. find students with more than 10 submissions
SELECT st.full_name, COUNT(s.submission_id) as total_submissions
FROM submissions s
JOIN students st ON s.student_id = st.student_id
GROUP BY s.student_id, st.full_name
HAVING COUNT(s.submission_id) > 10;

-- 14. find problems where success rate is below 40 percent
SELECT p.title,
COUNT(s.submission_id) as total,
SUM(CASE WHEN s.status = 'Accepted' THEN 1 ELSE 0 END) as accepted,
ROUND(SUM(CASE WHEN s.status = 'Accepted' THEN 1.0 ELSE 0 END) / COUNT(*) * 100, 2) as success_rate
FROM submissions s
JOIN problems p ON s.problem_id = p.problem_id
GROUP BY s.problem_id, p.title
HAVING ROUND(SUM(CASE WHEN s.status = 'Accepted' THEN 1.0 ELSE 0 END) / COUNT(*) * 100, 2) < 40;

-- 15. find top 10 most attempted problems
SELECT p.title, COUNT(s.submission_id) as attempts
FROM submissions s
JOIN problems p ON s.problem_id = p.problem_id
GROUP BY s.problem_id, p.title
ORDER BY attempts DESC
LIMIT 10;

-- Subqueries and Set Logic

-- 16. find students whose average score is greater than overall average score
SELECT st.full_name, AVG(s.score) as avg_score
FROM submissions s
JOIN students st ON s.student_id = st.student_id
GROUP BY st.full_name,s.student_id
HAVING AVG(s.score) > (SELECT AVG(score) FROM submissions);

-- 17. find problems that have never been attempted
SELECT problem_id, title
FROM problems
WHERE problem_id NOT IN (
    SELECT DISTINCT problem_id FROM submissions
);

-- 18. find students who enrolled but never submitted any solution
SELECT full_name, student_id
FROM students
WHERE student_id IN (SELECT student_id FROM enrollments)
AND student_id NOT IN (SELECT DISTINCT student_id FROM submissions);

-- 19. find students who submitted in both Python and Java
SELECT DISTINCT student_id
FROM submissions
WHERE language = 'Python'
AND student_id IN (
    SELECT DISTINCT student_id
    FROM submissions
    WHERE language = 'Java'
);

-- 20. find second highest score for a selected problem
SELECT MAX(score) as second_highest_score
FROM submissions
WHERE score < (SELECT MAX(score) FROM submissions)
AND problem_id = (SELECT problem_id FROM problems LIMIT 1);