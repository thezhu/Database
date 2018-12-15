CREATE TABLE StudentStatus(
	StatusID	INT	PRIMARY KEY IDENTITY(1,1),
	Text	VARCHAR(50) NOT NULL
);
INSERT INTO StudentStatus (Text)
	VALUES('Active'),
		  ('Suspended'),
		  ('In-active');
SELECT * FROM StudentStatus



CREATE TABLE StudentType(
	TypeID	INT	PRIMARY KEY IDENTITY(1,1),
	Text	VARCHAR(50) NOT NULL
);
INSERT INTO StudentType (Text)
	VALUES('Freshmen'),
		  ('Continue'),
		  ('Re-admitted'),
		  ('New graduate'),
		  ('Continue graduate');
SELECT * FROM StudentType



CREATE TABLE StudentLevel(
	LevelID	INT	PRIMARY KEY IDENTITY(1,1),
	Text	VARCHAR(50) NOT NULL
);
INSERT INTO StudentLevel (Text)
	VALUES('Undergraduate'),
		  ('Graduate');
SELECT * FROM StudentLevel;



CREATE TABLE College(
	CollegeID	INT	PRIMARY KEY IDENTITY(1,1),
	CollegeName	VARCHAR(100) NOT NULL
);
INSERT INTO College (CollegeName)
	VALUES('School of Architecture'),
		  ('The College of Arts and Sciences'),
		  ('School of Education'),
		  ('The College of Engineering and Computer Science'),
		  ('The David B. Falk College of Sport and Human Dynamics'),
		  ('School of Information Studies'),
		  ('College of Law'),
		  ('The Martin J. Whitman School of Management'),
		  ('Maxwell School of Citizenship and Public Affairs'),
		  ('S. I. Newhouse School of Public Communications');
SELECT * FROM College



CREATE TABLE Major (
	MajorID	INT	PRIMARY KEY IDENTITY(1,1)	,
	College	INT	REFERENCES College(CollegeID),
	StudyTitle	VARCHAR(100) NOT NULL 
);
INSERT INTO Major (College, StudyTitle)
	VALUES (1, 'Architecture'),
		   (2,'African American Studies'),
		   (3,'Clinical Mental Health Counseling'),
		   (4,'Computer Science'),
		   (5,'Food Studies'),
		   (6,'Applied Data Science'),
		   (7,'International Human Rights Law'),
		   (8,'Finance'),
		   (9,'Anthropology '),
		   (10,'Advertising');
SELECT * FROM Major



CREATE TABLE JobType(
	JobTypeID	INT	PRIMARY KEY IDENTITY(1,1),
	Text	VARCHAR(20) NOT NULL
);
INSERT INTO JobType(Text)
	VALUES('Faculty'),
		  ('Staff');
SELECT * FROM JobType



CREATE TABLE Job (
	JobID	INT	PRIMARY KEY IDENTITY(1,1),
	JobTitle VARCHAR(20) NOT NULL,
	JobDescription VARCHAR(2000) NOT NULL,
	JobType INT REFERENCES JobType(JobTypeID),
	MaxPay INT NOT NULL,
	MinPay INT NOT NULL
);
INSERT INTO Job VALUES ('Professor','Professors should have the terminal', 1, 300000, 200000);
INSERT INTO Job VALUES ('Associate Professor', 'Associate Professors should have the terminal ', 1, 250000, 150000);
INSERT INTO Job VALUES ('Asst Professor', 'Assistant Professors appointed to tenure track positions should have the termi', 1, 200000, 100000);
INSERT INTO Job VALUES ('Senior Instructor', 'The rank of Senior Instructor permits higher recognition and s', 1, 150000, 100000);
INSERT INTO Job VALUES ('Predisent', 'Chief executive officer of the University', 2, 200000, 100000);
INSERT INTO Job VALUES ('Vice Predisent', 'Executive officer for one of major coordi', 2, 200000, 100000);
INSERT INTO Job VALUES ('Chancellor', 'Chancellors are the chief academic and administrative ', 2, 200000, 100000);
INSERT INTO Job VALUES ('Dean', 'Deans are the principal administrative officers for a college or school.', 2, 200000, 100000);
SELECT * FROM Job



CREATE TABLE Country (
	CountryID	INT	PRIMARY KEY IDENTITY(1,1),
	Text	VARCHAR(50) NOT NULL
);
INSERT INTO Country (Text)
	VALUES('The United States'),
		  ('Canada'),
		  ('England'),
		  ('France'),
		  ('China'),
		  ('South Korea'),
		  ('Japan'),
		  ('India'),
		  ('Netherland'),
		  ('Iceland');
SELECT * FROM Country



CREATE TABLE State (
	StateID	INT	PRIMARY KEY IDENTITY(1,1),
	Text	VARCHAR(50) NOT NULL
);
INSERT INTO State (Text)
	VALUES('Alabama'),
		  ('Arizona'),
		  ('Connecticut'),
		  ('California'),
		  ('Florida'),
		  ('Hawaii'),
		  ('Iowa'),
		  ('Massachusetts'),
		  ('New York'),
		  ('Texas');
SELECT * FROM State



CREATE TABLE MailAddress (
	AddressID	INT	PRIMARY KEY IDENTITY(1,1),
	Street1 TEXT NOT NULL,
	Street2 TEXT,
	Apartment TEXT,
	City VARCHAR(50) NOT NULL,
	State INT REFERENCES State(StateID),
	Country INT REFERENCES Country(CountryID),
	ZipCode INT NOT NULL
);
INSERT INTO MailAddress (Street1, Street2, Apartment, City, State, Country, ZipCode)
	VALUES('25 campus street', NULL, NULL, 'Syracuse', 9, 1, 13205),
		  ('144 fgqcqw street', 'fw block', NULL, 'New York', 9, 1, 14235),
		  ('49 brighton avenue', NULL, 'APT 330', 'Ames', 7, 1, 63923),
		  ('235 commenwealth road', NULL, NULL, 'Brighton', 2, 1, 35235),
		  ('25 main street', 'fe road', 'APT 5', 'San Francisco', 4, 1, 24522);
SELECT * FROM MailAddress



CREATE TABLE Gender(
	GenderID	INT	PRIMARY KEY IDENTITY(1,1),
	Text	VARCHAR(100) NOT NULL
);
INSERT INTO Gender (Text)
	VALUES('Female'),
	      ('Male'),
		  ('Do not want to answer');
SELECT * FROM Gender



CREATE TABLE Ethnicity(
	EthnicityID	INT	PRIMARY KEY IDENTITY(1,1),
	Text	VARCHAR(20) NOT NULL
);
INSERT INTO Ethnicity (Text)
	VALUES('Asian'),
	      ('Africa'),
		  ('North America'),
		  ('South America'),
		  ('Oceania'),
		  ('Europe');
SELECT * FROM Ethnicity



CREATE TABLE CoverType(
	CoverTypeID	INT	PRIMARY KEY IDENTITY(1,1),
	Text	VARCHAR(50) NOT NULL
);
INSERT INTO CoverType (Text)
	VALUES('Employee only'),
	      ('Employee with children only'),
		  ('Employee with spouse only'),
		  ('Employee with family');
SELECT * FROM CoverType



CREATE TABLE InsuranceType(
	InsuranceTypeID	INT	PRIMARY KEY IDENTITY(1,1),
	Text	VARCHAR(50) NOT NULL
);
INSERT INTO InsuranceType(Text)
	VALUES('Health'),
	      ('Vision'),
		  ('Dental');
SELECT * FROM InsuranceType



CREATE TABLE PersonalInformation(
	PersonID	INT	PRIMARY KEY IDENTITY(1,1),
	NTID CHAR(9) NOT NULL,
	Password VARCHAR(50) NOT NULL,
	SSN CHAR(9) UNIQUE,
	FirstName VARCHAR(50) NOT NULL,
	LastName VARCHAR(50) NOT NULL,
	DataOfBirth DATE,
	Gender INT REFERENCES Gender(GenderID),
	Ethnicity INT REFERENCES Ethnicity (EthnicityID),
	EmailAddress VARCHAR(100),
	HomeAddress INT REFERENCES MailAddress(AddressID),
	MailAddress INT REFERENCES MailAddress(AddressID),
	CellPhone CHAR(10)
);
--begin modification
DELETE FROM PersonalInformation;
DBCC CHECKIDENT (PersonalInformation, RESEED, 0);
--end modification

INSERT INTO PersonalInformation(NTID, Password, SSN, FirstName, LastName , DataOfBirth, Gender, Ethnicity , EmailAddress, HomeAddress, MailAddress, CellPhone)
	VALUES('543657547', 'Hedwig', '534645645', 'Jan','Brady', '1965-05-31', 1, 5, 'jb@hw.edu', 5, 5, '5363756262'),
		  ('867246532', 'GRTW3G', '463586489', 'Jackson','Adler', '1974-12-19', 1, 4, 'ja@hw.edu', 1, 1, '5316546456'),
		  ('264756345', 'HEr64', '765824653', 'Andrew','Carson', '1979-07-13', 2, 2, 'ac@hw.edu', 1, 1, '7456425452'),
		  ('534645765', 'aG4T5', '645785362', 'Steve','Cohen', '1990-08-25', 2, 3, 'sc@hw.edu', 2, 2, '6345763444'),
		  ('624623666', 'HHERT', '845623524', 'Thompson','Anderson', '1990-09-26', 1, 6, 'ta@hw.edu', 3, 3, '6463446751'),
		  ('575613332', 'ADw46', '452526456', 'Harry','Potter', '1990-03-03', 1, 2, 'hp@hw.edu', 1, 1, '3155150423'),
	      ('256646457', 'Scabbers', '643562616', 'Ron','Weasley', '1997-02-24', 1, 1, 'rw@hw.edu', 3, 3, '5365663726'),
		  ('643662436', 'Crookshanks', '000000000', 'Hermione','Granger', '1996-11-03', 2, 3, 'hg@hw.edu', 2, 2, '6234667745'),
		  ('795695206', 'moon', '645765835', 'Remus','Lupin', '1994-03-18', 2, 2, 'rl@hw.edu', 5, 5, '2745676575'),
		  ('627635803', 'BuckBeak', '264548426', 'Filius','Flitwick', '1996-08-09', 2, 5, 'ff@hw.edu', 4, 4, '9567354623');
SELECT * FROM PersonalInformation



CREATE TABLE Student(
	StudentID	INT NOT NULL,
	StudentStatus INT REFERENCES StudentStatus(StatusID),
	StudentType INT REFERENCES StudentType(TypeID),
	StudentLevel INT REFERENCES StudentLevel(LevelID),
	PRIMARY KEY (StudentID),
	FOREIGN KEY(StudentID) REFERENCES PersonalInformation(PersonID)
);
INSERT INTO Student(StudentID, StudentStatus, StudentType, StudentLevel)
	VALUES(6, 3, 5, 2),
		  (7, 3, 5, 2),
		  (8, 2, 4, 1),
		  (9, 2, 2, 1),
		  (10, 3, 1, 2);
SELECT * FROM Student;



CREATE TABLE StudentMajor(
	StudentID INT NOT NULL,
	MajorID INT NOT NULL,
	IsMajor CHAR(1) NOT NULL,
	PRIMARY KEY (StudentID, MajorID),
	FOREIGN KEY (StudentID) REFERENCES Student(StudentID),
	FOREIGN KEY (MajorID) REFERENCES Major(MajorID)
);
INSERT INTO StudentMajor(StudentID, MajorID, IsMajor)
	VALUES(6, 4, 'Y'),
		(7,3, 'Y'),
		(8,6, 'N'),
		(9,1, 'N'),
		(10,2, 'Y');
SELECT * FROM StudentMajor;



CREATE TABLE Employees(
	EmployeeID INT NOT NULL,
	AnnualSalary INT,
	PRIMARY KEY (EmployeeID),
	FOREIGN KEY (EmployeeID) REFERENCES PersonalInformation(PersonID)
);
INSERT INTO Employees
	VALUES(1, 300000),
		  (2, 200000),
		  (3, 100000),
		  (4, 200000),
		  (5, 100000);
SELECT * FROM Employees;



CREATE TABLE EmployeeJob(
	EmployeeID INT NOT NULL,
	JobID INT NOT NULL,
	PRIMARY KEY (EmployeeID, JobID),
	FOREIGN KEY (EmployeeID) REFERENCES PersonalInformation(PersonID),
	FOREIGN KEY (JobID) REFERENCES Job(JobID)
);
INSERT INTO EmployeeJob(EmployeeID, JobID)
	VALUES(1, 1),
		  (2, 3),
		  (3, 4),
		  (4, 6),
		  (5, 7);
SELECT * FROM EmployeeJob;



CREATE TABLE Benefits(
	EmployeeID INT NOT NULL,
	CoverTypeID INT NOT NULL,
	InsuranceTypeID INT NOT NULL,
	PRIMARY KEY (EmployeeID, CoverTypeID, InsuranceTypeID),
	FOREIGN KEY (EmployeeID) REFERENCES PersonalInformation(PersonID),
	FOREIGN KEY (CoverTypeID) REFERENCES CoverType(CoverTypeID),
	FOREIGN KEY (InsuranceTypeID) REFERENCES InsuranceType(InsuranceTypeID),
	EmployeePremiumAmount INT,
	EmployerPremiumAmount INT
);
INSERT INTO Benefits(EmployeeID, CoverTypeID, InsuranceTypeID, EmployeePremiumAmount, EmployerPremiumAmount)
	VALUES(1, 1, 1, 100, 313),
		  (2, 2, 2, 200, 523),
		  (3, 3, 1, 100, 131),
		  (4, 4, 3, 340, 313),
		  (5, 1, 3, 130, 422);
SELECT * FROM Benefits;



CREATE TABLE RoomType(
	RoomTypeID	INT	PRIMARY KEY IDENTITY(1,1),
	Text	VARCHAR(50) NOT NULL
);
INSERT INTO RoomType(Text)
	VALUES('Computer Lab'),
		  ('Reading Room'),
	      ('Lecture Room'),
		  ('Chemistry Laboratory'),
		  ('Auditorium');
SELECT * FROM RoomType;


CREATE TABLE RoomEquipment(
	RoomEquipmentID	INT	PRIMARY KEY IDENTITY(1,1),
	Text	VARCHAR(50) NOT NULL
);
INSERT INTO RoomEquipment(Text)
	VALUES('Computer'),
		  ('White Board'),
	      ('Projector'),
		  ('Document Camera'),
		  ('Control System'),
		  ('Blu-ray');
SELECT * FROM RoomEquipment;



CREATE TABLE Building(
	BuildingID	INT	PRIMARY KEY IDENTITY(1,1),
	Text	VARCHAR(50) NOT NULL
);
INSERT INTO Building(Text)
	VALUES('Life Sciences Complex'),
		  ('Lyman Hall'),
	      ('Slocum Hall'),
		  ('Link Hall'),
		  ('Crouse Hall'),
		  ('Eggers Hall'),
		  ('Tollwy Hall'),
		  ('Browne Hall'),
		  ('Watson Hall'),
		  ('Smith Hall');
SELECT * FROM Building;



CREATE TABLE ClassRoom(
	ClassRoomID	INT	PRIMARY KEY IDENTITY(1,1),
	Building INT REFERENCES Building(BuildingID),
	Level VARCHAR(10) NOT NULL,
	RoomNumber VARCHAR(10) NOT NULL,
	RoomType INT REFERENCES RoomType(RoomTypeID),
	RoomEquipment INT REFERENCES RoomEquipment(RoomEquipmentID),
	RoomCapacity INT NOT NULL
);
INSERT INTO ClassRoom(Building, Level, RoomNumber, RoomType, RoomEquipment, RoomCapacity)
	VALUES(3, '3', '378', 3, 2, 30),
		  (4, '1', '104', 2, 3, 100),
		  (8, '2', '205', 4, 1, 45),
		  (10, '1', '203', 5, 6, 40),
		  (10, '1', '203', 5, 5, 40),
		  (1, '3', '349', 1, 4, 80);
SELECT * FROM ClassRoom;



CREATE TABLE Semester(
	SemesterID	INT	PRIMARY KEY IDENTITY(1,1),
	Text	VARCHAR(50) NOT NULL
);
INSERT INTO Semester(Text)
	VALUES('Fall'),
		  ('Spring'),
	      ('Summer Session I'),
		  ('Summer Session II'),
		  ('Combined Summer Session');
SELECT * FROM Semester;



CREATE TABLE Semesters(
	SemestersID	INT	PRIMARY KEY IDENTITY(1,1),
	Semester INT REFERENCES Semester(SemesterID),
	Year SMALLINT NOT NULL,
	BeginDate Date NOT NULL,
	EndDate Date NOT NULL
);
INSERT INTO Semesters(Semester, Year, BeginDate, EndDate)
	VALUES(1, 2018, '2018-08-28', '2018-12-15'),
		  (2, 2019, '2019-01-13', '2019-05-10'),
	      (3, 2019, '2019-05-13', '2019-06-30'),
		  (4, 2019, '2019-07-01', '2019-08-25'),
		  (5, 2019, '2019-05-13', '2019-08-25');
SELECT * FROM Semesters;



CREATE TABLE CourseDepartment(
	CourseDepartmentID	INT	PRIMARY KEY IDENTITY(1,1),
	Text	VARCHAR(50) NOT NULL
);
INSERT INTO CourseDepartment(Text)
	VALUES('Accounting'),
		  ('Art'),
	      ('Chemistry'),
		  ('Communication Sciences and Disorders'),
		  ('Drama'),
		  ('Economics'),
		  ('Exercise Science'),
		  ('Geography'),
		  ('History'),
		  ('Computer Science');
SELECT * FROM CourseDepartment;

--begin modification
DELETE FROM CourseDepartment;
DBCC CHECKIDENT (CourseDepartment, RESEED, 0);
--end modification

CREATE TABLE CourseInformation(
	CourseCode	CHAR(3)	NOT NULL,
	CoursenNumber	INT	NOT NULL,
	CourseTitle VARCHAR(50)	NOT NULL,
	CourseLevel INT REFERENCES StudentLevel(LevelID),
	CourseDepartment INT REFERENCES CourseDepartment(CourseDepartmentID),
	CourseDescription VARCHAR(200),
	HoureCredit INT NOT NULL,
	PRIMARY KEY (CourseCode, CoursenNumber)
);

--begin modification
DELETE FROM CourseInformation;
DELETE FROM CourseTime;
DELETE FROM  CourseEmployee;
DELETE FROM EnrolledStudents;
DELETE FROM CourseSchedule;
DELETE FROM Prerequisities;
--end modification


INSERT INTO CourseInformation(CourseCode, CoursenNumber, CourseTitle, CourseLevel, CourseDepartment, CourseDescription, HoureCredit)
	VALUES('CSE', 581, 'Intro to Database', 2, 10, 'cover foundational aspects of database systems and it’s components', 3),
	('CSE', 101, 'Intro to Computer Science', 1, 10, 'Introduction of basic computer science concept', 3),
	('CIS', 400, 'Pricinple of Computer Science', 1, 10, 'Pricinple of computer science', 3),
	('CIS', 657, 'Operating System', 2, 10, 'Introduction of operating system with lab projects', 3),
	('ACC', 151, 'Intro to Financial Accounting', 1, 1, 'Financial accounting concepts that aid entrepreneurs, managers, investors, and creditors', 3),
	('VID', 312, 'Intro to art media', 1, 2, 'Use as a medium for making art. Production and post-production skills are refined.', 3),
	('ECN', 661, 'Economics of Development', 2, 6, 'Economic development in international settings. ', 3),
	('ECN', 342, 'Micro Economics', 2, 6, 'Economic theory in micro field', 3),
	('ECN', 343, 'Macro Economics', 2, 6, 'Economic theory in macro field', 3),
	('GEO', 554, 'Environmental Ideas', 2, 8, 'Environmental Ideas in latest development', 3);
SELECT * FROM CourseInformation;


CREATE TABLE Prerequisities(
	ParentCode CHAR(3) NOT NULL,
	ParentNumber INT NOT NULL,
	ChildCode CHAR(3) NOT NULL,
	ChildNumber INT NOT NULL,
	PRIMARY KEY (ParentCode, ParentNumber, ChildCode, ChildNumber),
	FOREIGN KEY (ParentCode, ParentNumber) REFERENCES CourseInformation(CourseCode, CoursenNumber),
	FOREIGN KEY (ChildCode, ChildNumber) REFERENCES CourseInformation(CourseCode, CoursenNumber),
);
INSERT INTO Prerequisities(ParentCode, ParentNumber, ChildCode, ChildNumber)
	VALUES('CSE', 101, 'CSE', 581),
		  ('CSE', 101, 'CIS', 400),
		  ('CIS', 400, 'CIS', 657),
		  ('ECN', 342, 'ECN', 661),
		  ('ECN', 343, 'ECN', 661);
SELECT * FROM Prerequisities;



CREATE TABLE CourseSchedule(
	CRN CHAR(5) PRIMARY KEY,
	CourseSemester INT REFERENCES Semesters(SemestersID),
	CourseCode CHAR(3),
	CoursenNumber INT,
	FOREIGN KEY (CourseCode, CoursenNumber) REFERENCES CourseInformation(CourseCode, CoursenNumber),
	CourseSection INT NOT NULL,
	ClassRoom INT REFERENCES ClassRoom(ClassRoomID)
);
INSERT INTO CourseSchedule(CRN, CourseSemester, CourseCode, CoursenNumber, CourseSection, ClassRoom)
	VALUES('14342', 5, 'ECN', 661, 3, 6),
		('52763', 4, 'CSE', 581,  1, 2),
		('14275', 3, 'CIS', 400, 1, 3),
		('84562', 2, 'VID', 312, 1, 1),
		('68363', 2, 'ECN', 343, 2, 4),
		('87653', 1, 'ECN', 342, 2, 4),
		('74526', 1, 'CSE', 101, 2, 6);
SELECT * FROM CourseSchedule;


CREATE TABLE CourseEmployee(
	EmployeeID INT NOT NULL,
	CRN CHAR(5) NOT NULL,
	PRIMARY KEY (EmployeeID, CRN),
	FOREIGN KEY (EmployeeID) REFERENCES Employees(EmployeeID),
	FOREIGN KEY (CRN) REFERENCES CourseSchedule(CRN)
);
INSERT INTO CourseEmployee (EmployeeID, CRN)
	VALUES(1, '14342'),
		(2, '52763'),
		(3, '87653'),
		(4, '68363'),
		(5,'14275'),
		(5,'52763');
SELECT * FROM CourseEmployee;



CREATE TABLE CourseTime(
	CourseTimeID INT PRIMARY KEY IDENTITY(1,1),
	CRN CHAR(5)  REFERENCES CourseSchedule(CRN),
	DayOfWeek VARCHAR(10) NOT NULL,
	StartHour INT NOT NULL,
	StartMinute INT NOT NULL,
	EndHour INT NOT NULL,
	EndMinute INT NOT NULL
);
INSERT INTO CourseTime(CRN, DayOfWeek, StartHour, StartMinute, EndHour, EndMinute)
	VALUES('14342', 'Monday', 8, 0, 9, 20),
		('52763', 'Tuesday', 9, 30, 10, 50),
		('14275', 'Wednesday', 12, 0, 13, 20),
		('84562', 'Thusday', 14, 0, 15, 20),
		('68363', 'Friday', 17, 15, 18, 30),
		('87653', 'Monday', 9, 30, 12, 30),
		('74526', 'Wednesday', 8, 0, 9, 20);
SELECT * FROM CourseTime;

--begin modification
DBCC CHECKIDENT (CourseTime, RESEED, 0);
--end modification

CREATE TABLE EnrollmentStatus(
	EnrollmentStatusID	INT	PRIMARY KEY IDENTITY(1,1),
	Text	VARCHAR(50) NOT NULL
);
INSERT INTO EnrollmentStatus(Text)
	VALUES('Enrolled'),
		('Dropped'),
		('Audit');
SELECT * FROM EnrollmentStatus;



CREATE TABLE EnrolledStudents(
	StudentID INT NOT NULL,
	CRN CHAR(5) NOT NULL,
	EnrollmentStatus INT REFERENCES EnrollmentStatus(EnrollmentStatusID),
	MidternGrade INT,
	FinalGrade INT,
	PRIMARY KEY (StudentID, CRN),
	FOREIGN KEY (StudentID) REFERENCES Student(StudentID),
	FOREIGN KEY (CRN) REFERENCES CourseSchedule(CRN),
);
INSERT INTO EnrolledStudents(StudentID, CRN, EnrollmentStatus, MidternGrade, FinalGrade)
	VALUES(6, '14342', 1, 80, 85),
		(7, '52763', 1, 99, 87),
		(8, '87653', 2, 78, 90),
		(9, '68363', 1, 56, 67),
		(10,'14275', 3, 64, 78),
		(6,'52763', 1, 72, 73);
SELECT * FROM EnrolledStudents;
DELETE FROM EnrolledStudents;


GRANT SELECT ON czhu13.StudentStatus TO YLI41;
GRANT SELECT ON czhu13.StudentType TO YLI41;
GRANT SELECT ON czhu13.StudentLevel TO YLI41;
GRANT SELECT ON czhu13.College TO YLI41;
GRANT SELECT ON czhu13.Major TO YLI41;
GRANT SELECT ON czhu13.JobType TO YLI41;
GRANT SELECT ON czhu13.Job TO YLI41;
GRANT SELECT ON czhu13.Country TO YLI41;
GRANT SELECT ON czhu13.State TO YLI41;
GRANT SELECT ON czhu13.MailAddress TO YLI41;
GRANT SELECT ON czhu13.Gender TO YLI41;
GRANT SELECT ON czhu13.Ethnicity TO YLI41;
GRANT SELECT ON czhu13.CoverType TO YLI41;
GRANT SELECT ON czhu13.InsuranceType TO YLI41;
GRANT SELECT ON czhu13.PersonalInformation TO YLI41;
GRANT SELECT ON czhu13.Student TO YLI41;
GRANT SELECT ON czhu13.StudentMajor TO YLI41;
GRANT SELECT ON czhu13.Employees TO YLI41;
GRANT SELECT ON czhu13.EmployeeJob TO YLI41;
GRANT SELECT ON czhu13.Benefits TO YLI41;
GRANT SELECT ON czhu13.RoomType TO YLI41;
GRANT SELECT ON czhu13.RoomEquipment TO YLI41;
GRANT SELECT ON czhu13.Building TO YLI41;
GRANT SELECT ON czhu13.ClassRoom TO YLI41;
GRANT SELECT ON czhu13.Semester TO YLI41;
GRANT SELECT ON czhu13.Semesters TO YLI41;
GRANT SELECT ON czhu13.CourseDepartment TO YLI41;
GRANT SELECT ON czhu13.CourseInformation TO YLI41;
GRANT SELECT ON czhu13.Prerequisities TO YLI41;
GRANT SELECT ON czhu13.CourseSchedule TO YLI41;
GRANT SELECT ON czhu13.CourseEmployee TO YLI41;
GRANT SELECT ON czhu13.CourseTime TO YLI41;
GRANT SELECT ON czhu13.EnrollmentStatus TO YLI41;
GRANT SELECT ON czhu13.EnrolledStudents TO YLI41;
