DECLARE @sql NVARCHAR(MAX) = N'';
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

--1
SELECT FIRSTNAME+' '+LASTNAME AS NAME FROM employees WHERE deptcode IN
(SELECT deptcode FROM departments WHERE name='CONSULTING')
--2
SELECT SUM(ASSIGNEDTIME* 100) FROM WORKSON WHERE employeeid IN(
SELECT employeeid FROM employees WHERE lastname='ADVICE' AND firstname='ABE')
--3
SELECT NAME FROM DEPARTMENTS WHERE CODE NOT IN(
SELECT DEPTCODE FROM PROJECTS)
--4
SELECT FIRSTNAME,LASTNAME FROM EMPLOYEES WHERE SALARY>(
SELECT AVG(SALARY) FROM employees)
--5
SELECT DESCRIPTION FROM PROJECTS WHERE projectid IN(
SELECT PROJECTID FROM WORKSON WHERE assignedtime>0.7)
--6
SELECT FIRSTNAME,LASTNAME FROM EMPLOYEES WHERE SALARY>(
SELECT MAX(SALARY) FROM EMPLOYEES WHERE deptcode IN
(SELECT CODE FROM DEPARTMENTS WHERE NAME='ACCOUNTING'))
--7
SELECT MIN(SALARY) FROM EMPLOYEES WHERE SALARY>(
SELECT MAX(SALARY) FROM EMPLOYEES WHERE deptcode IN
(SELECT CODE FROM DEPARTMENTS WHERE NAME='ACCOUNTING'))
--8
SELECT FIRSTNAME,LASTNAME FROM EMPLOYEES WHERE SALARY=(
SELECT MAX(SALARY) FROM employees WHERE deptcode IN
(SELECT CODE FROM DEPARTMENTS WHERE NAME='ACCOUNTING'))
AND deptcode IN (SELECT CODE FROM DEPARTMENTS WHERE NAME='ACCOUNTING')

--EXERCISE 2
--1
SELECT E.FIRSTNAME,E.LASTNAME FROM EMPLOYEES E JOIN WORKSON W ON
W.employeeid=E.employeeid JOIN PROJECTS P ON P.PROJECTID=W.PROJECTID
JOIN DEPARTMENTS D ON D.CODE=E.DEPTCODE WHERE D.NAME='CONSULTING' AND 
P.PROJECTID='ADT4MFIA' AND W.ASSIGNEDTIME>0.2
--2
SELECT D.NAME FROM DEPARTMENTS D WHERE NOT EXISTS (
SELECT E.FIRSTNAME FROM EMPLOYEES E WHERE E.DEPTCODE = D.CODE
EXCEPT
SELECT E.FIRSTNAME FROM EMPLOYEES E WHERE E.DEPTCODE = D.CODE AND
NOT EXISTS ((SELECT PROJECTID FROM PROJECTS P1 WHERE
P1.DEPTCODE = D.CODE) EXCEPT (SELECT P.PROJECTID FROM
PROJECTS P, WORKSON W WHERE W.EMPLOYEEID = E.EMPLOYEEID AND
W.PROJECTID = P.PROJECTID))
);
































