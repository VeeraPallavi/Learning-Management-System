USE LMSDATABASE;

/*Section 6: Database Design and Architecture
36.Propose schema changes to support course completion certificates.
37.Describe how you would track video progress efficiently at scale.
38.Discuss normalization versus denormalization trade-offs for user activity data.
39.Design a reporting-friendly schema for analytics dashboards.
40.Explain how this schema should evolve to support millions of users.
*/

--36.Propose schema changes to support course completion certificates.
CREATE TABLE lms.CourseCompletion (
	certificat_id INT PRIMARY KEY,
	user_id INT,
	course_id INT,
	issued_date DATETIME2,
	certificate_url VARCHAR(200)
	FOREIGN KEY (user_id) REFERENCES lms.Users (user_id),
	FOREIGN KEY (course_id) REFERENCES lms.Courses (course_id),
	CONSTRAINT cc_unique_user
	UNIQUE(user_id, course_id)
);

--37.Describe how you would track video progress efficiently at scale.
--Create VideoProgress Table
CREATE TABLE VideoProgress (
    ProgressID INT IDENTITY(1,1) PRIMARY KEY,
    UserID INT NOT NULL,
    LessonID INT NOT NULL,
    ProgressPercent DECIMAL(5,2)
    CHECK (ProgressPercent BETWEEN 0 AND 100),
    LastUpdated DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (UserID) REFERENCES lms.Users(user_id),
	FOREIGN KEY (LessonID) REFERENCES lms.Lessons(lesson_id),
    CONSTRAINT UQ_User_Lesson UNIQUE (UserID, LessonID)
);

--Create index for performance
CREATE NONCLUSTERED INDEX idx_videoprogress_user_lesson
ON VideoProgress (UserID, LessonID);

--INSERT values into VideoProgress table 
INSERT INTO VideoProgress (UserID, LessonID, ProgressPercent)
VALUES (1, 11, 30.00);

--update the values of VideoProgress table
UPDATE VideoProgress
SET ProgressPercent = 75.50,
    LastUpdated = GETDATE()
WHERE UserID = 1
  AND LessonID = 11;

--View All Lesson Progress for a User 
SELECT 
    VP.ProgressPercent,
    VP.LastUpdated
FROM VideoProgress VP
JOIN lms.Lessons L ON VP.LessonID = L.lesson_id
WHERE VP.UserID = 1;