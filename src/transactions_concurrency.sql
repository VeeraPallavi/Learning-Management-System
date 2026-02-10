USE LMSDATABASE;

/*Section 5: Transactions and Concurrency
31.Design a transaction flow for enrolling a user into a course.
32.Explain how to handle concurrent assessment submissions safely.
33.Describe how partial failures should be handled during assessment submission.
34.Recommend suitable transaction isolation levels for enrollments and submissions.
35.Explain how phantom reads could affect analytics queries and how to prevent them.
*/

--31.Design a transaction flow for enrolling a user into a course.
BEGIN TRY
    BEGIN TRANSACTION;

    -- 1. Validate user exists
    IF NOT EXISTS (
        SELECT 1 
        FROM lms.Users 
        WHERE user_id = @user_id
    )
    BEGIN
        RAISERROR ('User does not exist.', 16, 1);
        ROLLBACK TRANSACTION;
    END;
    -- 2. Validate course exists and is active
    IF NOT EXISTS (
        SELECT 1 
        FROM lms.Courses 
        WHERE course_id = @course_id
    )
    BEGIN
        RAISERROR ('Course does not exist.', 16, 1);
        ROLLBACK TRANSACTION;
    END;

    -- 3. Ensure course has at least one lesson
    IF NOT EXISTS (
        SELECT 1
        FROM lms.Lessons
        WHERE course_id = @course_id
    )
    BEGIN
        RAISERROR ('Cannot enroll in a course with no lessons.', 16, 1);
        ROLLBACK TRANSACTION;
        RETURN;
    END;
    COMMIT TRANSACTION;
END TRY
BEGIN CATCH
    ROLLBACK TRANSACTION;

END CATCH;

--32.Explain how to handle concurrent assessment submissions safely.
/*Concurrent assessment submissions are handled safely by using database constraints, transactions so that only one valid submission is accepted.*/
ALTER TABLE lms.AssessmentSubmission
ADD CONSTRAINT uq_user_assessment
UNIQUE (user_id, assessment_id);

BEGIN TRANSACTION 
    --Safe Insert
    INSERT INTO lms.AssessmentSubmission(assessment_id, user_id, score, submitted_at)
       VALUES (@AssessmentId, @UserId, @Score, GETDATE());

    COMMIT TRANSACTION


--33.Describe how partial failures should be handled during assessment submission.
BEGIN TRY
    BEGIN TRANSACTION
        --Insert Values into AssssmentSubmission
        INSERT INTO lms.AssessmentSubmission(assessment_id, user_id, score, submitted_at) 
            VALUES(@AssessmentId, @UserId, @Score, GETDATE());

        -- Record the activity in UserActivity
         INSERT INTO lms.UserActivity (user_id, lesson_id, activity_type, timestamp)
             VALUES (@UserId, @LessonId, 'completed', GETDATE());
       
       --If both inserts succeed, commit the transaction
       COMMIT TRANSACTION;
    END
END TRY
BEGIN CATCH

    -- If any error occurs, rollback the transaction
    ROLLBACK TRANSACTION;

END CATCH;


