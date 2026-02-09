USE LMSDATABASE;

/*Intermediate SQL Queries
1.List all users who are enrolled in more than three courses.
2.Find courses that currently have no enrollments.
3.Display each course along with the total number of enrolled users.
4.Identify users who enrolled in a course but never accessed any lesson.
5.Fetch lessons that have never been accessed by any user.
6.Show the last activity timestamp for each user.
7.List users who submitted an assessment but scored less than 50 percent of the maximum score.
8.Find assessments that have not received any submissions.
9.Display the highest score achieved for each assessment.
10.Identify users who are enrolled in a course but have an inactive enrollment status.
*/

--1.List all users who are enrolled in more than three courses.

/*Why LEFT JOIN : LEFT JOIN is used to ensure all users are included, even if they have zero related courses.
Count courses per user without losing users who have no matching rows in Courses*/
SELECT 
	u.user_id,
	u.name,
	u.email,
	COUNT(c.course_id) AS Total_Courses
FROM lms.Users u
LEFT JOIN lms.Courses c
ON u.user_id = c.user_id
GROUP BY 
	u.user_id,
	u.name,
	u.email
HAVING COUNT(c.course_id) > 3;


--2.Find courses that currently have no enrollments.

/*Why LEFT JOIN : LEFT JOIN keeps all courses and tries to match enrollments.
If a course has no enrolled users, the enrollment columns become NULL.
Assumptions : A course may or may not have enrollments.*/
SELECT 
	c.course_id,
	c.title,
	e.enrollment_id,
	e.course_id
FROM lms.Courses c
LEFT JOIN lms.Enrollments e
ON c.course_id = e.course_id
WHERE e.course_id IS NULL;

--3.Display each course along with the total number of enrolled us

/*WHY LEFT JOIN : LEFT JOIN preserves courses that have no enrolled users.
For such courses, enrollment columns become NULL.*/
SELECT 
	DISTINCT c.title,
	COUNT(e.enrollment_id) AS Total_Users
FROM lms.Courses c
LEFT JOIN lms.Enrollments e
ON c.course_id = e.course_id
GROUP BY c.title;

--4.Identify users who enrolled in a course but never accessed any lesson.

/*Why INNER JOIN : INNER JOIN ensures considers only enrolled users, excludes users with no enrollments.
LEFT JOIN keeps the user–course enrollment even if the course has no lessons.
LEFT JOIN with user_acivity checks whether the specific user accessed any lesson of the enrolled course.*/
SELECT DISTINCT
    u.user_id,
    u.name,
    u.email,
    e.course_id
FROM lms.Users u
JOIN lms.Enrollments e
ON u.user_id = e.user_id
LEFT JOIN lms.Lessons l
ON e.course_id = l.course_id
LEFT JOIN lms.UserActivity ua
ON ua.lesson_id = l.lesson_id
AND ua.user_id = u.user_id
WHERE ua.activity_id IS NULL;

--5.Fetch lessons that have never been accessed by any user.

/* WHY LEFT JOIN : LEFT JOIN preserves lessons even when no matching activity record exists.
WHERE ua.lesson_id IS NULL : identifies lessons that have never been accessed by any user.*/

SELECT 
	l.lesson_id,
	l.course_id,
	l.title
FROM lms.Lessons l
LEFT JOIN lms.UserActivity ua
ON l.lesson_id = ua.lesson_id
WHERE ua.lesson_id IS NULL;

--6.Show the last activity timestamp for each user.

/* Why INNER JOIN : INNER JOIN ensures that only users with activity records are included.
MAX(timestamp) identifies the latest activity for each user.*/

SELECT 
	u.user_id,
	MAX(ua.timestamp) AS Last_Activity
FROM lms.Users u
JOIN lms.UserActivity ua
ON u.user_id = ua.user_id
GROUP BY u.user_id;

--7.List users who submitted an assessment but scored less than 50 percent of the maximum score.

/* Why INNER JOIN : INNER JOIN ensures only users with actual submissions are included.
JOIN with Assessments : Access the total_marks of each user
WHERE s.score < (a.total_marks * 0.5) : Filters the users who have score less than 50% oftotal marks*/

SELECT 
	u.user_id,
	u.name,
	u.email,
	s.submission_id,
	s.score ,
	a.total_marks
FROM lms.Users u
JOIN lms.AssessmentSubmission s
ON u.user_id = s.user_id
JOIN lms.Assesments a
ON a.assessment_id = s.assessment_id
WHERE s.score < (a.total_marks * 0.5);

--8.Find assessments that have not received any submissions.

/*Why LEFT JOIN : LEFT JOIN ensures all assessments are considered, including those that may never have been attempted.
WHERE s.assessment_id IS NULL : Filters the assessments that have no submissions*/
SELECT 
	a.assessment_id,
	a.course_id,
	a.title,
	a.total_marks
FROM lms.Assesments a
LEFT JOIN lms.AssessmentSubmission s
ON a.assessment_id = s.assessment_id
WHERE s.assessment_id IS NULL ;

--9.Display the highest score achieved for each assessment.

--MAX(score) : returns the highest score for each assessment
SELECT 
	assessment_id,
	MAX(score) AS Highest_score
FROM lms.AssessmentSubmission
GROUP BY assessment_id
ORDER BY assessment_id;

--10.Identify users who are enrolled in a course but have an inactive enrollment status.

/*Why INNER JOIN : INNER JOIN returns only the users who are enrolled in a course
WHERE e.status = 'inactive' : Filters users who's status is inactive*/
SELECT 
	u.user_id,
	u.name,
	u.email,
	e.enrollment_id,
	e.status
FROM lms.Users u
JOIN lms.Enrollments e
ON e.user_id = u.user_id
WHERE e.status = 'inactive';


