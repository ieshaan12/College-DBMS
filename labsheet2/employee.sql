/*DECLARE @sql NVARCHAR(MAX) = N'';
SELECT @sql += N'
ALTER TABLE ' + QUOTENAME(OBJECT_SCHEMA_NAME(parent_object_id))
    + '.' + QUOTENAME(OBJECT_NAME(parent_object_id)) + 
    ' DROP CONSTRAINT ' + QUOTENAME(name) + ';'
FROM sys.foreign_keys;
EXEC sp_executesql @sql;EXEC sp_msforeachtable @Command1 = "DROP TABLE ?"


CREATE TABLE employees (
employeeid NUMERIC(9) NOT NULL,
firstname VARCHAR(10),
lastname VARCHAR(20),
deptcode CHAR(5),
salary NUMERIC(9, 2),
  PRIMARY KEY(employeeid)
);


CREATE TABLE departments (
  code CHAR(5) NOT NULL,
  name VARCHAR(30),
  managerid NUMERIC(9),
  subdeptof CHAR(5),
  PRIMARY KEY(code),
  FOREIGN KEY(managerid) REFERENCES employees(employeeid),
  FOREIGN KEY(subdeptof) REFERENCES departments(code)
);

ALTER TABLE employees ADD FOREIGN KEY (deptcode) REFERENCES departments(code);

CREATE TABLE projects (
  projectid CHAR(8) NOT NULL,
  deptcode CHAR(5),
  description VARCHAR(200),
  startdate DATE DEFAULT GETDATE(),
  enddate DATE,
  revenue NUMERIC(12, 2),
  PRIMARY KEY(projectid),
  FOREIGN KEY(deptcode) REFERENCES departments(code)
);

CREATE TABLE workson (
  employeeid NUMERIC(9) NOT NULL,
  projectid CHAR(8) NOT NULL,
  assignedtime DECIMAL(3,2),
  PRIMARY KEY(employeeid, projectid),
  FOREIGN KEY(employeeid) REFERENCES employees(employeeid),
  FOREIGN KEY(projectid) REFERENCES projects(projectid)
);

INSERT INTO departments VALUES ('ADMIN', 'Administration', NULL, NULL);
INSERT INTO departments VALUES ('ACCNT', 'Accounting', NULL, 'ADMIN');
INSERT INTO departments VALUES ('CNSLT', 'Consulting', NULL, 'ADMIN');
INSERT INTO departments VALUES ('HDWRE', 'Hardware', NULL, 'CNSLT');

INSERT INTO employees VALUES (1, 'Al', 'Betheleader', 'ADMIN', 70000);
INSERT INTO employees VALUES (2, 'PI', 'Rsquared', 'ACCNT', 40000);
INSERT INTO employees VALUES (3, 'Harry', 'Hardware', 'HDWRE', 50000);
INSERT INTO employees VALUES (4, 'Sussie', 'Software', 'CNSLT', 60000);
INSERT INTO employees VALUES (5, 'Abe', 'Advice', 'CNSLT', 30000);
INSERT INTO employees VALUES (6, 'Hardly', 'Aware', NULL, 65000);

UPDATE departments SET managerid = 1 WHERE code = 'ADMIN';
UPDATE departments SET managerid = 2 WHERE code = 'ACCNT';
UPDATE departments SET managerid = 3 WHERE code = 'HDWRE';
UPDATE departments SET managerid = 4 WHERE code = 'CNSLT';

INSERT INTO projects VALUES ('EMPHAPPY', 'ADMIN', 'Employee Moral', '14-MAR-2002', '30-NOV-2003', 0);
INSERT INTO projects VALUES ('ROBOSPSE', 'CNSLT', 'Robotic Spouse', '14-MAR-2002', NULL, 200000);
INSERT INTO projects VALUES ('ADT4MFIA', 'ACCNT', 'Mofia Audit', '03-JUL-2003', '30-NOV-2004', 100000);
INSERT INTO PROJECTS VALUES ('DNLDCLNT', 'CNSLT', 'Download Client', '03-FEB-2005', NULL, 15000);

INSERT INTO workson VALUES (2, 'ADT4MFIA', 0.60);
INSERT INTO workson VALUES (3, 'ROBOSPSE', 0.75);
INSERT INTO workson VALUES (4, 'ROBOSPSE', 0.75);
INSERT INTO workson VALUES (5, 'ROBOSPSE', 0.50);
INSERT INTO workson VALUES (5, 'ADT4MFIA', 0.60);
INSERT INTO workson VALUES (3, 'DNLDCLNT', 0.25);
*/

--EXERCISE 1, LAB2
--1
--SELECT firstname+' '+lastname from employees;
--2
--select * from projects where revenue>40000;
--3
--select deptcode from projects where revenue between 100000 and 150000;
--4
--select projectid from projects where startdate> '1-JUL-2004'; 
--5
--select name from departments where subdeptof is null;
--6
--select projectid,description from projects where deptcode in ('ACCNT','CNSLT','HDWRE');
--7
--SELECT * FROM EMPLOYEES WHERE LASTNAME like '________' AND LASTNAME LIKE '%ware';
--8
--select employeeid,lastname from employees where deptcode='ACTNG' AND SALARY<30000;
--9
--SELECT * FROM PROJECTS WHERE STARTDATE>GETDATE() AND REVENUE>0;
--10
--SELECT PROJECTID FROM PROJECTS WHERE ENDDATE IS NULL AND REVENUE>50000 OR DEPTCODE='ACTNG';

--EXCERCISE2,LAB2
--1
--select firstname+ ' '+lastname as name from employees;
--2
--select distinct deptcode from projects;
--3
--select projectid,datediff(month,enddate,startdate) as duration from projects --where enddate is not null;
--4
/*
select projectid,
CASE
WHEN ENDDATE IS NULL THEN DATEDIFF(DAY,STARTDATE,GETDATE())
WHEN ENDDATE IS NOT NULL THEN DATEDIFF(DAY,STARTDATE,ENDDATE)
END
AS DURATION FROM PROJECTS;
*/
--5
--SELECT PROJECTID,REVENUE/(DATEDIFF(DAY,STARTDATE,ENDDATE)) FROM PROJECTS WHERE ENDDATE IS NOT NULL;
--6
--SELECT DISTINCT YEAR(STARTDATE) FROM PROJECTS;
--7
--SELECT  EMPLOYEEID FROM WORKSON WHERE ASSIGNEDTIME>20;
--8
/*
SELECT EMPLOYEEID,
CASE
WHEN ASSIGNEDTIME<0.33 THEN 'PART TIME'
WHEN ASSIGNEDTIME>=0.33 AND ASSIGNEDTIME<0.67 THEN 'SPLIT TIME'
WHEN ASSIGNEDTIME>=0.67 THEN 'FULLTIME'
END
FROM WORKSON;
*/
--9
--SELECT uPPER( SUBSTRING(DESCRIPTION,1,3)+'-'+DEPTCODE) FROM PROJECTS;
--10
--SELECT PROJECTID, Year(STARTDATE) from projects order by year(startdate);
--11
--select lastname,salary*1.05 from employees where salary>(50000/1.05);
--12
--select employeeid,firstname,lastname,salary*1.1 as 'next year' from employees where deptcode='HDWRE';
--13
--SELECT deptcode,firstname+' '+lastname from employees order by deptcode,lastname,firstname;






























