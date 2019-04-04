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

drop view rsp;
--exercise 1
--1
create view rsp as
select w.employeeid,e.firstname,e.lastname,w.assignedtime from
employees e join workson w on w.employeeid=e.employeeid join projects p on w.projectid=p.projectid
where p.description='Robotic spouse'

select * from rsp
--2
select distinct(v2.firstname),v2.lastname from rsp v1 cross join rsp v2 where v1.assignedtime<v2.assignedtime
--3
DROP VIEW E_DEPT
CREATE VIEW E_DEPT AS
SELECT FIRSTNAME,LASTNAME,deptcode FROM EMPLOYEES;

SELECT * FROM E_DEPT
--4
SELECT FIRSTNAME,LASTNAME FROM E_DEPT WHERE deptcode='CNSLT'
--5
CREATE VIEW ABE_PROJ AS
SELECT P.PROJECTID,P.DESCRIPTION,P.DEPTCODE,P.STARTDATE,P.ENDDATE,W.ASSIGNEDTIME FROM
EMPLOYEES E JOIN WORKSON W ON W.employeeid=E.employeeid JOIN projects P ON P.projectid=W.projectid
WHERE E.firstname='ABE' AND E.lastname='ADVICE'

SELECT * FROM ABE_PROJ
--6
SELECT SUM(ASSIGNEDTIME) FROM ABE_PROJ
--7
CREATE VIEW E_SAL AS
SELECT FIRSTNAME,LASTNAME,EMPLOYEEID,SALARY FROM employees

SELECT * FROM E_SAL;
UPDATE E_SAL SET salary=salary*1.10;
SELECT * FROM E_SAL;


SELECT right(REPLICATE('a', 5) + 'abc', 4);

SELECT REPLACE(REPLACE('Unit Number#2', '#', '_'), ' ', '_');

SELECT sysdatetime();


SELECT CONVERT(VARCHAR(10), GETDATE(), 105) AS [dd/mm/yyyy];

































