USE LMSDATABASE;

--Insert data into the table Users
BULK INSERT lms.Users
FROM 'C:\Users\palla\OneDrive\Desktop\SQL_PROJECT\datasets\Users.csv'
WITH (
    FIRSTROW = 2,              -- skip header
    FIELDTERMINATOR = ',',     -- CSV separator
    ROWTERMINATOR = '0x0a',      -- line break
    TABLOCK
);

--Insert data into the table Courses
BULK INSERT lms.Courses
FROM 'C:\Users\palla\OneDrive\Desktop\SQL_PROJECT\datasets\Courses.csv'
WITH (
    FIRSTROW = 2,             
    FIELDTERMINATOR = ',',     
    ROWTERMINATOR = '0x0a',      
    TABLOCK
);

--Insert data into the table lessons
BULK INSERT lms.Lessons
FROM 'C:\Users\palla\OneDrive\Desktop\SQL_PROJECT\datasets\Lessons.csv'
WITH (
    FIRSTROW = 2,              
    FIELDTERMINATOR = ',',     
    ROWTERMINATOR = '0x0a',     
    TABLOCK
);

--Insert data into the table Enrollments
BULK INSERT lms.Enrollments
FROM 'C:\Users\palla\OneDrive\Desktop\SQL_PROJECT\datasets\Enrollements.csv'
WITH (
    FIRSTROW = 2,              
    FIELDTERMINATOR = ',',     
    ROWTERMINATOR = '0x0a',    
    TABLOCK
);

--Insert data into the table UserActivity
BULK INSERT lms.UserActivity
FROM 'C:\Users\palla\OneDrive\Desktop\SQL_PROJECT\datasets\User_Activity.csv'
WITH (
    FIRSTROW = 2,              
    FIELDTERMINATOR = ',',     
    ROWTERMINATOR = '0x0a',     
    TABLOCK
);

--Insert data into the table Assessments
BULK INSERT lms.Assesments
FROM 'C:\Users\palla\OneDrive\Desktop\SQL_PROJECT\datasets\Assessments.csv'
WITH (
    FIRSTROW = 2,             
    FIELDTERMINATOR = ',',     
    ROWTERMINATOR = '0x0a',     
    TABLOCK
);

--Insert data into the table AssessmentSubmission
BULK INSERT lms.AssessmentSubmission
FROM 'C:\Users\palla\OneDrive\Desktop\SQL_PROJECT\datasets\Assessment_Submission.csv'
WITH (
    FIRSTROW = 2,             
    FIELDTERMINATOR = ',',     
    ROWTERMINATOR = '0x0a',      
    TABLOCK
);


SELECT * FROM lms.Users;

SELECT * FROM lms.Courses;

SELECT * FROM lms.Lessons;

SELECT * FROM lms.Enrollments;

SELECT * FROM lms.UserActivity;

SELECT * FROM lms.Assesments;

SELECT * FROM lms.AssessmentSubmission;