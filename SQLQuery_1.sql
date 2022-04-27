-- create tables

CREATE TABLE EMPLOYEE (
    EMP_ID CHAR(9) NOT NULL, 
    F_NAME VARCHAR(15) NOT NULL,
    L_NAME VARCHAR(15) NOT NULL,
    SSN CHAR(9),
    B_DATE DATE,
    SEX CHAR,
    ADDRESS VARCHAR(30),
    JOB_ID CHAR(9),
    SALARY DECIMAL(10,2),
    MANAGER_ID CHAR(9),
    DEP_ID CHAR(9) NOT NULL,
    PRIMARY KEY (EMP_ID)
);


 CREATE TABLE JOB_HISTORY (
    EMPL_ID CHAR(9) NOT NULL, 
    START_DATE DATE,
    JOBS_ID CHAR(9) NOT NULL,
    DEPT_ID CHAR(9),
    PRIMARY KEY (EMPL_ID,JOBS_ID));
 
CREATE TABLE JOBS (
    JOB_IDENT CHAR(9) NOT NULL, 
    JOB_TITLE VARCHAR(15) ,
    MIN_SALARY DECIMAL(10,2),
    MAX_SALARY DECIMAL(10,2),
    PRIMARY KEY (JOB_IDENT));


CREATE TABLE DEPARTMENTS (
    DEPT_ID_DEP CHAR(9) NOT NULL, 
    DEP_NAME VARCHAR(15) ,
    MANAGER_ID CHAR(9),
    LOC_ID CHAR(9),
    PRIMARY KEY (DEPT_ID_DEP));


CREATE TABLE LOCATIONS (
    LOCT_ID CHAR(9) NOT NULL,
    DEP_ID_LOC CHAR(9) NOT NULL,
    PRIMARY KEY (LOCT_ID,DEP_ID_LOC));

---------------------------------------------

--Insert values into tables            
INSERT INTO EMPLOYEE
VALUES( 
   'E1001', 'John', 'Thomas', '123456', '01/09/1976','M','5631 Rice, OakPark,IL', 
   '100',100000,'30001','2' 
);

INSERT INTO EMPLOYEE
VALUES 
   ('E1002','Alice','James','123457','07/31/1972','F','980 Berry ln, Elgin, IL','200',80000,'30002','5'),
    ('E1003','Steve','Wells','123458','08/10/1980','M','291 Springs, Gary,IL','300',50000,'30002','5'),
    ('E1004','Santosh','Kumar','123459','07/20/1985','M','511 Aurora Av, Aurora,IL','400',60000,'30004','5'),
    ('E1005','Ahmed','Hussain','123410','01/04/1981','M','216 Oak Tree, Geneva,IL','500',70000,'30001','2'),
    ('E1006','Nancy','Allen','123411','02/06/1978','F','111 Green Pl, Elgin,IL','600',90000,'30001','2'),
    ('E1007','Mary','Thomas','123412','05/05/1975','F','100 Rose Pl, Gary,IL','650',65000,'30003','7'),
    ('E1008','Bharath','Gupta','123413','05/06/1985','M','145 Berry Ln, Naperville,IL','660',65000,'30003','7'),
    ('E1009','Andrea','Jones','123414','07/09/1990','F','120 Fall Creek, Gary,IL','234',70000,'30003','7'),
    ('E1010','Ann','Jacob','123415','03/30/1982','F','111 Britany Springs,Elgin,IL','220',70000,'30004','5');


INSERT INTO JOB_HISTORY
VALUES
    ('E1001','08/01/2000','100','2'),
    ('E1002','08/01/2001','200','5'),
    ('E1003','08/16/2001','300','5'),
    ('E1004','08/16/2000','400','5'),
    ('E1005','05/30/2000','500','2'),
    ('E1006','08/16/2001','600','2'),
    ('E1007','05/30/2002','650','7'),
    ('E1008','05/06/2010','660','7'),
    ('E1009','08/16/2016','234','7'),
    ('E1010','08/16/2016','220','5');


ALTER TABLE JOBS
ALTER COLUMN JOB_TITLE VARCHAR(30);


INSERT INTO JOBS
VALUES
('100','Sr. Architect',60000,100000),
('200','Sr. Software Developer',60000,80000),
('300','Jr.Software Developer',40000,60000),
('400','Jr.Software Developer',40000,60000),
('500','Jr. Architect',50000,70000),
('600','Lead Architect',70000,100000),
('650','Jr. Designer',60000,70000),
('660','Jr. Designer',60000,70000),
('234','Sr. Designer',70000,90000),
('220','Sr. Designer',70000,90000);


SELECT * FROM EMPLOYEE;


INSERT INTO DEPARTMENTS
VALUES
    ('2','Architect Group','30001','L0001'),
    ('5','Software Group','30002','L0002'),
    ('7','Design Team','30003','L0003');


INSERT INTO LOCATIONS
VALUES
('L0001','2'),
('L0002','5'),
('L0003','7');

-----------------------------------------------

DELETE FROM EMPLOYEE
WHERE EMP_ID=NULL;



SELECT * FROM EMPLOYEE;

-------------------------------------------------------------------------

-- retrieve SALARIES > AVERAGE SALARIES from EMPLOYEE table
SELECT EMP_ID, F_NAME, L_NAME, SALARY FROM EMPLOYEE
WHERE SALARY >
    (SELECT AVG(SALARY) FROM EMPLOYEE);

--------------------------------------------------------------------------

-- return the number of employees, SUM, and AVERAGE SALARY per dept

SELECT COUNT(*) AS 'NO OF EMPLOYEES', DEP_ID, SUM(SALARY) AS 'SUM OF SALARY', AVG(SALARY) AS 'AVG SALARY/DEPT'
FROM EMPLOYEE
GROUP BY DEP_ID;

---------------------------------------------------------------------------
SELECT E.EMP_ID, E.F_NAME, E.L_NAME, E.SSN, JH.JOBS_ID, E.MANAGER_ID, E.SALARY, JH.DEPT_ID
FROM EMPLOYEE AS E INNER JOIN JOB_HISTORY AS JH 
ON E.EMP_ID = JH.EMPL_ID
ORDER BY E.EMP_ID;

----------------------------------------------------------------------------
-- SELECT COUNT(*) AS 'NO OF EMPLOYEES', E.DEP_ID, DEPT.DEP_NAME, 
-- (SELECT E.DEP_ID, SUM(SALARY) AS 'SUM OF SALARY', AVG(SALARY) AS 'AVG SALARY/DEPT' FROM EMPLOYEE GROUP BY E.DEP_ID)
-- FROM EMPLOYEE AS E
-- INNER JOIN DEPARTMENTS AS DEPT 
-- ON E.DEP_ID = DEPT.DEPT_ID_DEP;
-- GROUP BY E.DEP_ID;

----------------------------------------------------------------------------

SELECT DEP_ID, SUM(SALARY) AS 'SUM OF SALARY', AVG(SALARY) AS 'AVG SALARY/DEPT' 
FROM EMPLOYEE GROUP BY DEP_ID;

------------------------------------------------------------------------------
SELECT F_NAME, L_NAME, DEP_ID, (SELECT  DEPT_ID FROM JOB_HISTORY 
        WHERE EMPLOYEE.JOB_ID = JOB_HISTORY.JOBS_ID)
FROM EMPLOYEE;
-----------------------------------------------------------
--wrong outputs
SELECT F_NAME, L_NAME, DEP_ID, (SELECT  DEPT_ID FROM JOB_HISTORY 
        WHERE JOB_HISTORY.JOBS_ID = 100)
FROM EMPLOYEE; 
--------------------------------------------------------------
--correct outputs
SELECT F_NAME, L_NAME, DEP_ID FROM EMPLOYEE
WHERE EXISTS (SELECT  * FROM JOB_HISTORY 
        WHERE EMPLOYEE.JOB_ID = 100);

----------------------------------------------------------
SELECT F_NAME, L_NAME, DEP_ID, JOB_ID FROM EMPLOYEE
WHERE EXISTS (SELECT  * FROM JOB_HISTORY 
        WHERE EMPLOYEE.JOB_ID = JOB_HISTORY.JOBS_ID);

SELECT * FROM JOB_HISTORY;
SELECT * FROM EMPLOYEE;

------------------------------------------------------------------
SELECT DEP_ID, SUM(SALARY) AS 'SUM OF SALARY', AVG(SALARY) AS 'AVG SALARY/DEPT' 
FROM EMPLOYEE GROUP BY DEP_ID
HAVING AVG(SALARY) > 70000;

------------------------------------------------------------
-- retrieve all employees's f_name, l_name, dept_id, salary where the job_id is 2 in the job_history table
SELECT F_NAME, L_NAME, DEP_ID, SALARY
FROM EMPLOYEE
WHERE DEP_ID = ALL (SELECT DEPT_ID
FROM JOB_HISTORY
WHERE DEPT_ID = 2);

----------------------------------------------------------------
--joining the records from EMPLOYEE TABLE and job history using UNION
SELECT EMP_ID, DEP_ID
FROM EMPLOYEE 
WHERE DEP_ID = 2
UNION 
SELECT EMPL_ID, DEPT_ID
FROM JOB_HISTORY WHERE DEPT_ID = 5
ORDER BY EMP_ID

--------------------------------------
-- joining employee, job_history and jobs tables
SELECT e.EMP_ID, e.F_NAME, e.L_NAME, e.SSN, jh.START_DATE, jh.JOBS_ID, jh.DEPT_ID, j.JOB_TITLE, j.MIN_SALARY, j.MAX_SALARY
FROM EMPLOYEE AS e
INNER JOIN JOB_HISTORY AS jh
ON e.EMP_ID = jh.EMPL_ID
INNER JOIN JOBS AS j
ON jh.JOBS_ID = j.JOB_IDENT

---------------------
SELECT e.DEP_ID, SUM(j.MIN_SALARY) AS SUM_MIN_SALARY, SUM(j.MAX_SALARY) AS SUM_MAX_SALARY
FROM EMPLOYEE AS e
LEFT JOIN JOBS AS j
ON e.JOB_ID = j.JOB_IDENT
GROUP BY e.DEP_ID

-------------------------------
-- SELECT e.DEP_ID, e.EMP_ID, jh.START_DATE
-- FROM EMPLOYEE AS e JOIN JOB_HISTORY AS jh
-- USING(JOBS_ID)
--GROUP BY e.DEP_ID

-------------------------------------
--compare each employee's salary to the average salary in their respecive depts
SELECT F_NAME, L_NAME, EMP_ID, EMPLOYEE.DEP_ID, SALARY, SUBTABLE.MINSAL, SUBTABLE.MAXSAL, SUBTABLE.AVGSAL
FROM EMPLOYEE
INNER JOIN
(SELECT DEP_ID, MAX(SALARY) MAXSAL, MIN(SALARY) MINSAL, AVG(SALARY) AVGSAL
FROM EMPLOYEE
GROUP BY DEP_ID) SUBTABLE
ON EMPLOYEE.DEP_ID = SUBTABLE.DEP_ID

------------------------------------------
-- retrieve employees' details from employee table and jobs table, then compare each employee's salary with the average salary in each dept.
SELECT F_NAME, L_NAME, EMP_ID, EMPLOYEE.DEP_ID, JOB_TITLE, SALARY, MIN_SALARY, MAX_SALARY, SUBTABLE.AVG_SAL
FROM EMPLOYEE
LEFT JOIN JOBS ON
EMPLOYEE.JOB_ID = JOBS.JOB_IDENT
INNER JOIN
(SELECT DEP_ID, AVG(SALARY) AVG_SAL
FROM EMPLOYEE
GROUP BY DEP_ID) SUBTABLE
ON EMPLOYEE.DEP_ID = SUBTABLE.DEP_ID

-----------------------------------------------
-- retrieve the number of employees in each dept
SELECT DISTINCT(DEP_NAME), 
COUNT(EMP_ID) OVER (PARTITION BY E.DEP_ID) "NO OF EMPLOYEES"
FROM EMPLOYEE E
RIGHT JOIN DEPARTMENTS D
ON D.DEPT_ID_DEP = E.DEP_ID
ORDER BY "NO OF EMPLOYEES" DESC