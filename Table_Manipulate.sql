--SP to use cursor(s)
--It shows how many courses the student has enrolled in some semester.
CREATE PROCEDURE NumberOfCourse(@stdentid AS INT,
							@year AS SMALLINT,
							@semester AS VARCHAR(50))
AS
	BEGIN
		DECLARE @number INT,
				@total INT = 0

		DECLARE number CURSOR
		FOR SELECT A.StudentID FROM EnrolledStudents AS A
					LEFT OUTER JOIN CourseSchedule AS B ON A.CRN = B.CRN
					LEFT OUTER JOIN Semesters AS C ON B.CourseSemester = C.SemestersID
					LEFT OUTER JOIN Semester AS D ON C.Semester = D.SemesterID
						WHERE A.StudentID = @stdentid AND C.Year = @year AND D.Text = @semester

		OPEN number

		FETCH NEXT FROM number INTO @number
	
		WHILE @@FETCH_STATUS = 0
			BEGIN
				IF  @number IS NOT NULL
					BEGIN
						SET @total = @total + 1
					END;
				FETCH NEXT FROM number INTO @number
			END;

		CLOSE number;
		DEALLOCATE number;

		PRINT @total
	END;
--Execution
--CASE 1
EXEC NumberOfCourse @stdentid = 6, @year = 2019 , @semester = 'Combined Summer Session'
--CASE 2
EXEC NumberOfCourse @stdentid = 8, @year = 2018 , @semester = 'Fall'
--Test
SELECT A.StudentID, C.Year, D.Text AS Semester, COUNT(A.StudentID) AS 'Number Of Courses' FROM EnrolledStudents AS A
LEFT OUTER JOIN CourseSchedule AS B ON A.CRN = B.CRN
LEFT OUTER JOIN Semesters AS C ON B.CourseSemester = C.SemestersID
LEFT OUTER JOIN Semester AS D ON C.Semester = D.SemesterID
GROUP BY A.StudentID, C.Year, D.Text 
ORDER BY A.StudentID






--SP to update data in a table (perform validation)
--It is used to increase staffs’ salary by 10%
CREATE PROCEDURE SalaryRaise (@employeeid AS INT) 
AS
	DECLARE @jobtype VARCHAR(20),
			@maxpay INT,
			@oldsalary INT,
			@newsalary INT;
	SELECT @jobtype = (SELECT Text FROM Employees AS A
						LEFT OUTER JOIN EmployeeJob AS B ON A.EmployeeID = B.EmployeeID
						LEFT OUTER JOIN Job AS C ON B.JobID = C.JobID
						LEFT OUTER JOIN JobType AS E  ON C.JobType = E.JobTypeID
						WHERE A.EmployeeID = @employeeid)
	SELECT @maxpay = (SELECT MaxPay FROM  Employees AS A
						LEFT OUTER JOIN EmployeeJob AS B ON A.EmployeeID = B.EmployeeID
						LEFT OUTER JOIN Job AS C ON B.JobID = C.JobID
						WHERE A.EmployeeID = @employeeid)
	SELECT @oldsalary = (SELECT AnnualSalary FROM  Employees
						WHERE EmployeeID = @employeeid)
	SET @newsalary = @oldsalary * 1.1
	IF @jobtype = 'Staff'
		BEGIN
			IF @newsalary <= @maxpay
				BEGIN
					UPDATE Employees
						SET AnnualSalary = @newsalary
						WHERE EmployeeID = @employeeid
				END;
			ELSE
				BEGIN
					UPDATE Employees
						SET AnnualSalary = @maxpay
						WHERE EmployeeID = @employeeid
				END;
		END;
	ELSE
		BEGIN
			PRINT 'This salary raise is just for staff, not for faculty.'
		END;
--Execution
--he is a fuluty
EXEC SalaryRaise @employeeid = 1
--his new salary will exceed max pay
EXEC SalaryRaise @employeeid = 4
--success
EXEC SalaryRaise @employeeid = 5
--Test
SELECT A.EmployeeID, D.Text AS 'Job Type', A.AnnualSalary, C.MaxPay, C.MinPay FROM Employees AS A
LEFT OUTER JOIN EmployeeJob AS B ON A.EmployeeID = B.EmployeeID
LEFT OUTER JOIN Job AS C ON B.JobID = C.JobID
LEFT OUTER JOIN JobType AS D ON C.JobType = D.JobTypeID





--SP to delete data from a table
--delete course(s) in some semester
CREATE PROCEDURE CourseDelete(@stdentid AS INT,
							@coursecode AS CHAR(3),
							@coursenumber AS INT,
							@year AS SMALLINT,
							@semester AS VARCHAR(50))
AS
	DECLARE @number INT,
			@CRN INT
	SELECT @number = (SELECT COUNT(A.StudentID) FROM EnrolledStudents AS A
						LEFT OUTER JOIN CourseSchedule AS B ON A.CRN = B.CRN
						LEFT OUTER JOIN Semesters AS C ON B.CourseSemester = C.SemestersID
						LEFT OUTER JOIN Semester AS D ON C.Semester = D.SemesterID
							WHERE A.StudentID = @stdentid AND C.Year = @year AND D.Text = @semester
							GROUP BY A.StudentID, C.Year, D.Text)
	SELECT @CRN = (SELECT A.CRN FROM EnrolledStudents AS A
						LEFT OUTER JOIN CourseSchedule AS B ON A.CRN = B.CRN
						LEFT OUTER JOIN Semesters AS C ON B.CourseSemester = C.SemestersID
						LEFT OUTER JOIN Semester AS D ON C.Semester = D.SemesterID
						WHERE B.CourseCode = @coursecode AND B.CoursenNumber = @coursenumber AND C.Year = @year AND D.Text = @semester)
	IF @number IS NULL
		BEGIN
			PRINT 'You have not enroll any course in this semester.'
		END;
	ELSE
		BEGIN
			IF @number < 3
				BEGIN
					PRINT 'You should choose at least three courses per semester, so you cannot delete this course.'
				END;
			ELSE
				BEGIN
					DELETE FROM EnrolledStudents
						WHERE StudentID = @stdentid AND CRN = @CRN
				END;
		END;
--Execution
--NO COURSE IN THIS SEMESTER
EXEC CourseDelete @stdentid = 8, @coursecode = 'ECN', @coursenumber = 342, @year = 2018 , @semester = 'Spring'
--CANNOT DELETE BECAUSE OF THE RULE
EXEC CourseDelete @stdentid = 8, @coursecode = 'ECN', @coursenumber = 342, @year = 2018 , @semester = 'Fall'
--DELETE SUCCESSFULLY
EXEC CourseDelete @stdentid = 6, @coursecode = 'ECN', @coursenumber = 343, @year = 2019 , @semester = 'Combined Summer Session'
--Test
--the number of course
SELECT A.StudentID, C.Year, D.Text AS Semester, COUNT(A.StudentID) AS 'Number Of Courses' FROM EnrolledStudents AS A
LEFT OUTER JOIN CourseSchedule AS B ON A.CRN = B.CRN
LEFT OUTER JOIN Semesters AS C ON B.CourseSemester = C.SemestersID
LEFT OUTER JOIN Semester AS D ON C.Semester = D.SemesterID
GROUP BY A.StudentID, C.Year, D.Text 
ORDER BY A.StudentID
--the name of course
SELECT A.StudentID, C.Year, D.Text AS Semester, B.CourseCode, B.CoursenNumber FROM EnrolledStudents AS A
LEFT OUTER JOIN CourseSchedule AS B ON A.CRN = B.CRN
LEFT OUTER JOIN Semesters AS C ON B.CourseSemester = C.SemestersID
LEFT OUTER JOIN Semester AS D ON C.Semester = D.SemesterID 
ORDER BY A.StudentID




DROP PROCEDURE CourseDelete
INSERT INTO EnrolledStudents
VALUES (6, 57457, 1, 91, 87);
SELECT * FROM EnrolledStudents

--(5% bonus point) 1 SP of your own choice, performing a business action .
--successful, change print to update
--drop courses after the midertem exam
CREATE PROCEDURE CourseDrop(@studentid AS INT,
							@coursecode AS CHAR(3),
							@coursenumber AS INT,
							@year AS SMALLINT,
							@semester AS VARCHAR(50))
AS
DECLARE @midtern AS INT,
		@enrollstatus AS INT,
		@CRN AS INT
SELECT @midtern  = (SELECT MidternGrade FROM EnrolledStudents AS A
					LEFT OUTER JOIN CourseSchedule AS B ON A.CRN = B.CRN
					LEFT OUTER JOIN Semesters AS C ON B.CourseSemester = C.SemestersID
					LEFT OUTER JOIN Semester AS D ON C.Semester = D.SemesterID
					WHERE A.StudentID = @studentid AND B.CourseCode = @coursecode AND B.CoursenNumber = @coursenumber AND C.Year = @year AND D.Text = @semester)
SELECT @enrollstatus  = (SELECT EnrollmentStatus FROM EnrolledStudents AS A
					LEFT OUTER JOIN CourseSchedule AS B ON A.CRN = B.CRN
					LEFT OUTER JOIN Semesters AS C ON B.CourseSemester = C.SemestersID
					LEFT OUTER JOIN Semester AS D ON C.Semester = D.SemesterID
					WHERE A.StudentID = @studentid AND B.CourseCode = @coursecode AND B.CoursenNumber = @coursenumber AND C.Year = @year AND D.Text = @semester)
SELECT @CRN = (SELECT A.CRN FROM EnrolledStudents AS A
					LEFT OUTER JOIN CourseSchedule AS B ON A.CRN = B.CRN
					LEFT OUTER JOIN Semesters AS C ON B.CourseSemester = C.SemestersID
					LEFT OUTER JOIN Semester AS D ON C.Semester = D.SemesterID
					WHERE B.CourseCode = @coursecode AND B.CoursenNumber = @coursenumber AND C.Year = @year AND D.Text = @semester)

IF @midtern IS NULL OR @enrollstatus = 2
	BEGIN
		PRINT 'This student did not enroll in this course.'
	END;
ELSE
IF @midtern < 70
	BEGIN
		IF @enrollstatus = 1
			BEGIN
				UPDATE EnrolledStudents
					SET EnrollmentStatus = 2
					WHERE CRN = @CRN
			END;
		ELSE
			BEGIN
				PRINT 'You just audit this course. But I believe that you can do better.'
			END;
	END
ELSE
	BEGIN
		PRINT 'Congradulaitons. Your performed well in this course.'
	END;
--Execution
--NOT ENROLL
EXEC CourseDrop @studentid = 9, @coursecode = 'ECN', @coursenumber = 343, @year = 2019, @semester = 'Fall'
--AUDIT THIS COURSE
EXEC CourseDrop @studentid = 10, @coursecode = 'CIS', @coursenumber = 400, @year = 2019, @semester = 'Summer Session I'
-- great than 70
EXEC CourseDrop @studentid = 6, @coursecode = 'VID', @coursenumber = 312, @year = 2019, @semester = 'Combined Summer Session'
--DROP
EXEC CourseDrop @studentid = 9, @coursecode = 'ECN', @coursenumber = 343, @year = 2019, @semester = 'Spring'
--Test
SELECT A.StudentID, B.CourseCode, B.CoursenNumber, C.Year, D.Text AS Semester , A.MidternGrade, E.Text AS EnrollmentStatus 
		FROM EnrolledStudents AS A
		LEFT OUTER JOIN CourseSchedule AS B ON A.CRN = B.CRN
		LEFT OUTER JOIN Semesters AS C ON B.CourseSemester = C.SemestersID
		LEFT OUTER JOIN Semester AS D ON C.Semester = D.SemesterID
		LEFT OUTER JOIN EnrollmentStatus AS E ON A.EnrollmentStatus = E.EnrollmentStatusID


--Create 1 Function which can be executed by “Graders”. Not the function you did for the lab.
--show the grade detail of some course 
CREATE FUNCTION CourseGradeDetail(@CRN AS INT)
RETURNS TABLE
AS
RETURN
SELECT A.CRN, B.CourseCode, B.CoursenNumber, C.Year, D.Text AS Semester, MAX(A.MidternGrade) AS 'MAX MIDTERN', MIN(A.MidternGrade) AS 'MIN MIDTERN',  AVG(A.MidternGrade) AS 'AVG MIDTERN',MAX(A.FinalGrade) AS 'MAX FINAL', MIN(A.FinalGrade) AS 'MIN FINAL', AVG(A.FinalGrade) AS 'AVG FINAL'
FROM (EnrolledStudents AS A
	LEFT OUTER JOIN CourseSchedule AS B ON B.CRN = A.CRN)
	LEFT OUTER JOIN Semesters AS C ON B.CourseSemester = C.SemestersID
	LEFT OUTER JOIN Semester AS D ON C.Semester = D.SemesterID
WHERE A.EnrollmentStatus != 2 AND  A.CRN = @CRN
GROUP BY A.CRN, B.CourseCode, B.CoursenNumber, C.Year, D.Text

--Execution
SELECT * FROM  CourseGradeDetail(52763)
SELECT * FROM  CourseGradeDetail(32552)

--Test
SELECT B.CRN, A.StudentID, C.Year, D.Text AS Semester , A.MidternGrade, A.FinalGrade, E.Text AS EnrollmentStatus 
		FROM EnrolledStudents AS A
		LEFT OUTER JOIN CourseSchedule AS B ON A.CRN = B.CRN
		LEFT OUTER JOIN Semesters AS C ON B.CourseSemester = C.SemestersID
		LEFT OUTER JOIN Semester AS D ON C.Semester = D.SemesterID
		LEFT OUTER JOIN EnrollmentStatus AS E ON A.EnrollmentStatus = E.EnrollmentStatusID
		ORDER BY B.CRN







--create a view (named as “Benefits”)]that shows every employee’s name, ID, benefit’s type,
 --benefit coverage, employee premium and employer premium.
CREATE VIEW EmployeeBenefitsDetails AS
SELECT a.EmployeeID AS ID, b.LastName + ' ' + b.FirstName AS 'Name', e.Text AS 'Benifit Type', d.Text AS 'Cover Type', c.EmployeePremiumAmount AS 'Employee Premium', c.EmployerPremiumAmount AS 'Employer Premium'
	FROM (((Employees a
			LEFT OUTER JOIN PersonalInformation b ON a.EmployeeID = b.PersonID)
			LEFT OUTER JOIN Benefits c ON a.EmployeeID = c.EmployeeID)
			LEFT OUTER JOIN CoverType d ON c.CoverTypeID = d.CoverTypeID)
			LEFT OUTER JOIN InsuranceType e ON c.InsuranceTypeID = e.InsuranceTypeID;

SELECT * FROM EmployeeBenefitsDetails;







--Grant
GRANT EXECUTE ON czhu13.NumberOfCourse TO YLI41;
GRANT EXECUTE ON czhu13.CourseDelete TO YLI41;
GRANT EXECUTE ON czhu13.CourseDrop TO YLI41;
GRANT EXECUTE ON czhu13.SalaryRaise TO YLI41;
GRANT SELECT ON czhu13.CourseGradeDetail TO YLI41;
GRANT SELECT ON czhu13.EmployeeBenefitsDetails TO YLI41;