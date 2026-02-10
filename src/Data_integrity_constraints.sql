USE LMSDATABASE;

/*Section 4: Data Integrity and Constraints
26.Propose constraints to ensure a user cannot submit the same assessment more than once.
27.Ensure that assessment scores do not exceed the defined maximum score.
28.Prevent users from enrolling in courses that have no lessons.
29.Ensure that only instructors can create courses.
30.Describe a safe strategy for deleting courses while preserving historical data.
*/

--26.Propose constraints to ensure a user cannot submit the same assessment more than once.

/* In order to ensure one submission, the system must prevent duplicate submissions at the database level, not just in application logic.
Why UNIQUE CONSTRAINT : Each submission is uniquely identified by the combination of user and assessment*/
ALTER TABLE lms.AssessmentSubmission
ADD CONSTRAINT uq_unique_submission
UNIQUE(user_id, assessment_id);

--27.Ensure that assessment scores do not exceed the defined maximum score.
CREATE TRIGGER trg_validate_score
ON lms.AssessmentSubmission
AFTER INSERT, UPDATE
AS 
BEGIN
	--Checks if the assessment score exceeds the maximum score 
	IF EXISTS(
		SELECT 1
		FROM inserted i
		JOIN lms.Assesments a
		ON i.assessment_id = a.assessment_id 
		WHERE (i.score > a.total_marks)
	)
	BEGIN
		RAISERROR('Assessment score should not exceed the maximum score', 16, 1);
		ROLLBACK TRANSACTION
	END
END;

--28.Prevent users from enrolling in courses that have no lessons.
CREATE TRIGGER tgr_enrolling_courses
ON lms.Enrollments
AFTER INSERT 
AS 
BEGIN
	--checks if the user has enrolled in courses that has no lessons
	IF EXISTS(
		SELECT 1 
		FROM inserted i 
		WHERE NOT EXISTS(
			SELECT 1
			FROM lms.Lessons l 
			WHERE l.course_id = i.course_id
		)
	)
	BEGIN 
		RAISERROR('Cannot enroll in courses where there are no lessons', 16,1);
		ROLLBACK TRANSACTION;
	END;
END;

--29.Ensure that only instructors can create courses.
CREATE TRIGGER tgr_instructor_course
ON lms.Courses
AFTER INSERT 
AS 
BEGIN
	--checks only istructors can create courses
	IF EXISTS(
		SELECT 1
		FROM inserted i 
		JOIN lms.Users u
		ON i.user_id = u.user_id
		WHERE u.role != 'instructor'
	)
	BEGIN 
		RAISERROR('Only instructors can create courses',16,1);
		ROLLBACK TRANSACTION;
	END
END;

--30.Describe a safe strategy for deleting courses while preserving historical data.
/*Courses are often referenced by enrollments, user activity, assessments, and submissions
Physically deleting a course can break historical reports and analytics.
So we can do soft delete that add we can add the status column in the course table where we can update whether the courses are available or not*/
ALTER TABLE lms.Courses
ADD course_status VARCHAR(10) NOT NULL DEFAULT 'ACTIVE';

UPDATE lms.Courses
SET status = 'Inactive'
WHERE course_id = 10;

CREATE TRIGGER tgr_deleted_course
ON lms.Courses
AFTER INSERT 
AS 
BEGIN
	IF EXISTS(
		SELECT 1 
		FROM inserted i
		JOIN lms.Courses c
		ON c.course_id = i.course_id
		WHERE c.status = 'Inactive'
	)
	BEGIN 
		RAISERROR('Cannot enroll in a deleted course',16,1);
		ROLLBACK TRANSACTION;
	END
END;



