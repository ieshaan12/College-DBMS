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
-------------------------- FIRST EXCERCISE
/*1
Select firstname,lastname from employees;
*/
/*2
select * from projects where revenue>40000;
*/
/*3
select deptcode from projects where revenue between 100000 and 150000;
*/
/*4
select projectid from projects where startdate<='1-07-2004'
*/
/*5
select * from departments where subdeptof IS NULL;
*/
/*6
SELECT PROJECTID, DESCRIPTION FROM PROJECTS WHERE deptcode IN('ACCNT','CNSLT','HDWRE') 
*/
/*7
SELECT * FROM employees WHERE LASTNAME like '%ware' and lastname like '________';
*/
/*8
select employeeid, lastname from employees where deptcode='ACTNG' AND SALARY<30000;
*/
/*9
SELECT * FROM PROJECTS WHERE startdate>GETDATE() OR startdate IS NULL;
*/
/*10
SELECT PROJECTID FROM projects WHERE deptcode='ACTNG' OR enddate IS NULL AND revenue>50000
 */
 -----------------------------SECOND EXCERCISE
 /*1
 SELECT firstname+' '+lastname AS NAME FROM EMPLOYEES;
 */
 /*2
 SELECT DISTINCT DEPTCODE FROM PROJECTS;
*/
/*3
SELECT PROJECTID,dATEDIFF(dAY,startdate,enddate) AS DURATION FROM projects;-- WHERE startdate IS NOT NULL AND enddate IS NOT NULL;
*/
/*4
SELECT PROJECTID, CASE
WHEN ENDDATE IS NULL THEN DATEDIFF(DAY,STARTDATE,GETDATE())
WHEN ENDDATE IS NOT NULL THEN DATEDIFF(DAY,STARTDATE,ENDDATE)
END AS DURATION FROM projects;
*/
/*5
SELECT PROJECTID,REVENUE/DATEDIFF(DAY,STARTDATE,ENDDATE) AS avgRev from projects where enddate is not null;
*/
/*6
select distinct year(startdate) from projects;
*/ 
/* 7 DOOOOOOOOOOO
select projectid from workson where ;
*/
/*8
select employeeid,
case 
when assignedtime<0.33 then 'part-time'
when assignedtime>=0.33 and assignedtime<0.67 then 'split-time'
when assignedtime>0.67 then 'full-time'
end as employement
from workson;
*/
/*9
select Upper(SUBSTRING(description,1,3)+'-'+deptcode) as Abbr from projects;
*/
/*10
select projectid, year(startdate) from projects order by year(startdate);
*/
/*11
--Update employees set salary=1.05*salary;
select lastname,salary  from employees where salary>50000;
*/
/*12
--Update employees set salary=1.10*salary;
select employeeid,firstname,lastname,salary as 'next year' from employees
*/
/*13
select deptcode, firstname+' '+lastname as 'name' from employees
order by deptcode,lastname,firstname;
*/
--select firstname+' '+lastname as name from employees where deptcode=(select code from departments where name='Consulting');

--select distinct firstname+' '+lastname as name from employees e,workson w where e.deptcode=(select code from departments where name='Consulting')
--and w.employeeid=e.employeeid and w.projectid='ADT4MFIA' and w.assignedtime>0.2;

--select sum(assignedtime)/(select sum(assignedtime) from workson)*100 from workson group by employeeid having employeeid=(select employeeid from employees where firstname+' '+lastname='Abe Advice');
--select name from departments where code not in (select deptcode from projects);
--select firstname+' '+lastname as name from employees where salary>(select avg(salary) from employees where deptcode=(select code from departments where name='Accounting'));
--select description from projects where projectid in (select projectid from workson where assignedtime>0.7);
--SELECT DESCRIPTION FROM PROJECTS
--WHERE PROJECTID IN(
--SELECT W1.PROJECTID
--FROM WORKSON W1
--WHERE (W1.ASSIGNEDTIME/(SELECT SUM(W.ASSIGNEDTIME)
--FROM WORKSON W
--WHERE W.EMPLOYEEID = W1.EMPLOYEEID
--GROUP BY W.EMPLOYEEID)>.7));
--select firstname+' '+lastname as name from employees where salary>any(select (salary) from employees where deptcode=(select code from departments where name='Accounting'));

--select min(salary) from employees where salary>all(select (salary) from employees where deptcode=(select code from departments where name='Accounting'));
--select firstname+' '+lastname as name from employees where deptcode=(select code from departments where name='Accounting') and salary=(select max(salary) from employees where deptcode=(select code from departments where name='Accounting'));
------------select e.employeeid,sum(w.assignedtime) from employees e,workson w,projects p where e.employeeid=w.employeeid  and w.assignedtime>0.5 and w.projectid=p.projectid and p.deptcode <> e.deptcode group by e.employeeid;

--select distinct d.code from departments d,employees e,projects p,workson w where e.deptcode=d.code ;

--SELECT D.NAME FROM DEPARTMENTS D WHERE EXISTS (SELECT E.FIRSTNAME FROM EMPLOYEES E WHERE E.DEPTCODE = D.CODE AND NOT EXISTS ((SELECT PROJECTID FROM PROJECTS P1 WHERE P1.DEPTCODE = D.CODE) EXCEPT (SELECT P.PROJECTID FROM PROJECTS P, WORKSON W WHERE W.EMPLOYEEID = E.EMPLOYEEID AND W.PROJECTID = P.PROJECTID)));

--select firstname+' '+lastname as name from employees where deptcode=(select code from departments where name='Accounting') ;















































