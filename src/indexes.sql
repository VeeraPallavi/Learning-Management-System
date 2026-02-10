
USE LMSDATABASE;
/*
Section 3: Performance and Optimization
21.Suggest appropriate indexes for improving performance of:
	Course dashboards
	User activity analytics
22.Identify potential performance bottlenecks in queries involving user activity.
23.Explain how you would optimize queries when the user_activity table grows to millions of rows.
24.Describe scenarios where materialized views would be useful for this schema.
25.Explain how partitioning could be applied to user_activity.
*/

/*21.Suggest appropriate indexes for improving performance of:
Course dashboards
User activity analytics*/

--Indexes for improving performance of Course dashboards
CREATE NONCLUSTERED INDEX idx_enrollments 
ON lms.Enrollments (user_id, course_id);

CREATE NONCLUSTERED INDEX idx_lessons
ON lms.Lessons(course_id,lesson_id);

CREATE NONCLUSTERED INDEX idx_Assessments
ON lms.Assesments(course_id,assessment_id);

CREATE NONCLUSTERED INDEX idx_AssesmentSubmission
ON lms.AssessmentSubmission(assessment_id, user_id);

--Indexes for improving performance of User activity analytics
CREATE NONCLUSTERED INDEX idx_UserActivity
ON lms.UserActivity(user_id,lesson_id);


--22.Identify potential performance bottlenecks in queries involving user activity.
/*User activity data usually grows very fast because every action performed by a user is stored.
User activity queries can be slow mainly because the data is large, joins create too many rows, and aggregation operations are heavy.
Without proper indexing and early filtering, performance will degrade as data grows.*/


--23.Explain how you would optimize queries when the user_activity table grows to millions of rows.
/*When the user_activity table grows to millions of rows, performance issues arises if queries continue to read the raw data directly.
When the user_activity table grows very large, optimization focuses on indexing, early filtering, reducing unnecessary joins and aggregations, 
and using pre-aggregated data instead of raw activity logs. */


--24.Describe scenarios where materialized views would be useful for this schema.
/*Materialized views are useful in this LMS schema for dashboards, engagement analytics, completion tracking,
and reporting scenarios where complex queries are run repeatedly on large datasets and real-time data is not required.*/


--25.Explain how partitioning could be applied to user_activity.
/*The user_activity table grows very quickly because it stores every action performed by users. 
As the table reaches millions of rows, querying and maintaining it becomes slower.
Partitioning helps by logically splitting the table into smaller, manageable pieces while keeping it as a single table for queries.*/

