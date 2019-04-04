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

create function id_table(@idno integer)
returns @projects1 table
(projectid CHAR(8) NOT NULL,
  deptcode CHAR(5),
  description VARCHAR(200),
  startdate DATE, 
  enddate DATE,
  revenue NUMERIC(12, 2)
  )
  as
  begin
	insert into @projects1
	select projects.projectid,deptcode,description,startdate,enddate,revenue from projects
	join workson on projects.projectid=workson.projectid
	where workson.employeeid=@idno
	return;
end;

select * from dbo.id_table(3);

create function fibo(@x integer)
returns integer
as begin
	declare 
	@z integer
	--begin
	if(@x=0)
		set @z=0;
	else if(@x=1)
		set @z=1;
	else
		set @z=dbo.fibo(@x-1)+dbo.fibo(@x-2);
	return @z;
	end;

select dbo.fibo(11);

DECLARE INFO_EMP CURSOR
FOR SELECT * FROM employees WHERE LEN(lastname)=8 AND lastname LIKE '%WARE'

DECLARE
@employeeid NUMERIC(9) ,
@firstname VARCHAR(10),
@lastname VARCHAR(20),
@deptcode CHAR(5),
@salary NUMERIC(9, 2);

OPEN INFO_EMP;
FETCH INFO_EMP INTO @employeeid,@firstname,@lastname,@deptcode,@salary;
WHILE @@FETCH_STATUS=0
	BEGIN 
	PRINT(CAST(@employeeid AS VARCHAR)+' '+@firstname+' '+@lastname+' '+cast(@deptcode as varchar)+' '+cast(@salary as varchar));
	FETCH INFO_EMP INTO @employeeid,@firstname,@lastname,@deptcode,@salary;
	END
CLOSE INFO_EMP;

DEALLOCATE INFO_EMP_ACTNG
DECLARE INFO_EMP_ACTNG CURSOR
FOR SELECT employeeid,lastname FROM employees WHERE salary<30000 AND deptcode='ACTNG';

DECLARE
@employeeid1 NUMERIC(9) ,
@lastname1 VARCHAR(20);

OPEN INFO_EMP_ACTNG;
FETCH INFO_EMP_ACTNG INTO @employeeid1,@lastname1;
WHILE @@FETCH_STATUS=0
	BEGIN
	PRINT(CAST(@EMPLOYEEID1 AS VARCHAR)+'    '+@LASTNAME1);
	FETCH INFO_EMP_ACTNG INTO @employeeid1,@lastname1;
	END
CLOSE INFO_EMP_ACTNG;


DECLARE NAME_CONSULT CURSOR
FOR SELECT FIRSTNAME+' '+LASTNAME AS NAME FROM employees E JOIN workson W ON W.employeeid=E.employeeid
JOIN departments D ON D.code=E.deptcode
WHERE projectid='ADT4MFIA' AND assignedtime>0.2 AND D.name='CONSULTING';

DECLARE
@NAME VARCHAR(50);

OPEN NAME_CONSULT;
FETCH NAME_CONSULT INTO @NAME;
WHILE @@FETCH_STATUS=0
	BEGIN
	PRINT(@NAME);
	FETCH NAME_CONSULT INTO @NAME;
	END
CLOSE NAME_CONSULT;

DECLARE NAME_ACCNT CURSOR 
FOR SELECT DISTINCT E1.FIRSTNAME+' '+E1.LASTNAME AS NAME FROM employees E1 CROSS JOIN employees E2
WHERE E1.SALARY>E2.salary AND E2.deptcode='ACCNT'

DECLARE
@NAME1 VARCHAR(50);

OPEN NAME_ACCNT;
FETCH NAME_ACCNT INTO @NAME1;
WHILE @@FETCH_STATUS=0
	BEGIN
	PRINT(@NAME1);
	FETCH NAME_ACCNT INTO  @NAME1;
	END
CLOSE NAME_ACCNT

create type books as table
(title varchar(50), author varchar(50), subject varchar(100), book_id int);
--Modifying and viewing the user defined table type
begin
declare @book1 dbo.books;
declare @book2 dbo.books;
insert into @book1(title , author,subject,book_id) values ('T-SQL for dummies' , 'Vighnesh Hegde' , 'Database Systems' , 123456);
insert into @book2(title , author,subject,book_id) values ('Advanced T-SQL' , 'Anmol Naugaria' , 'Database Systems' , 654321);
select * from @book1;
select * from @book2;
end;

























