# SQL Reasoning

## 1. LEFT JOIN instead of INNER JOIN

Query 7 uses LEFT JOIN between students and enrollments.
I used LEFT JOIN because some students are not enrolled in any course.INNER JOIN would hide those students completely.LEFT JOIN shows all students and puts NULL where there is no course.

## 2. HAVING instead of WHERE

Query 13 finds students with more than 10 submissions.
I used HAVING because COUNT is calculated after grouping.WHERE runs before grouping so it cannot use COUNT.HAVING runs after grouping so it works with COUNT.

## 3. Subquery helped solve the problem

Query 16 finds students whose average score is above overall average.
I used a subquery to first calculate the overall average.Then I compared each student average against that number.Without subquery I would have to run two separate queries.

## 4. Duplicate records can be misleading

Query 19 finds students who submitted in both Python and Java.
If same student submitted Python twice they could appear twice.This would make the count look bigger than it actually is.I used DISTINCT to make sure each student appears only once.

## 5. Edge case I thought about

Query 10 finds students enrolled in a course but never submitted.
A student might have submitted for another course but not this one.If I only checked student_id they would be wrongly excluded.So I checked both student_id and course_id together using NOT EXISTS.