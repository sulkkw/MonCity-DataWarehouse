/* 
Members: Ko Ko Win, Muhammad Musthafa Althaf

ERRORS: 
1) invalid foreign key (facultyid) exist in moncity.passenger 
2) duplicates record in moncity.booking
3)  invalid foreign key (errorcode) exist in moncity.passenger 
4) null value in moncity.caraccident primary key (accidentid)
5) 1 record has negative value for maintenancecost in moncity.maintenancecost
*/

-- drop tables
DROP TABLE faculty CASCADE CONSTRAINTS; 
DROP TABLE researchcenter CASCADE CONSTRAINTS; 
DROP TABLE passenger CASCADE CONSTRAINTS; 
DROP TABLE error CASCADE CONSTRAINTS; 
DROP TABLE maintenancetype CASCADE CONSTRAINTS; 
DROP TABLE booking CASCADE CONSTRAINTS; 
DROP TABLE accidentinfo CASCADE CONSTRAINTS; 
DROP TABLE car  CASCADE CONSTRAINTS; 
DROP TABLE maintenance CASCADE CONSTRAINTS; 
DROP TABLE caraccident CASCADE CONSTRAINTS; 
DROP TABLE maintenanceteam CASCADE CONSTRAINTS; 
DROP TABLE belongto  CASCADE CONSTRAINTS; 



-- Creating local tables 
----------------FACULTY (No Error) ------------------
SELECT
    *
FROM
    moncity.faculty;

CREATE TABLE faculty AS 
SELECT * FROM moncity.faculty;


-------------------RESEARCHCENTER (No Error) ------------
SELECT
    *
FROM
    moncity.researchcenter;

CREATE TABLE researchcenter AS 
SELECT * FROM moncity.researchcenter;

------------------------PASSENGER (1 Error)------------------------
/*
Invalid facultyid in row 143
*/
desc moncity.passenger;
select * from moncity.passenger;
-- check for null values 
SELECT DISTINCT
    *
FROM
    moncity.passenger
WHERE
    PASSENGERID IS NULL OR FACULTYID IS NULL;
-- check for duplicate values 
SELECT PASSENGERID,FACULTYID,count(*) from moncity.passenger
GROUP BY
    PASSENGERID,FACULTYID
HAVING
    COUNT(*) > 1;

-- detect error 
SELECT * 
FROM moncity.passenger 
WHERE facultyid NOT IN (SELECT facultyid FROM moncity.faculty);

-- create table and fix error
CREATE TABLE passenger AS 
SELECT * FROM moncity.passenger
WHERE facultyid IN (SELECT facultyid FROM moncity.faculty);

select * from passenger;

------------------------ERROR (No Error)---------------------
desc moncity.error; 

CREATE TABLE error AS 
SELECT * FROM moncity.error;

------------------------MAINTENANCETYPE (No Error)-------------
desc moncity.maintenancetype;

select * from moncity.maintenancetype;

CREATE TABLE maintenancetype AS 
SELECT * FROM moncity.maintenancetype;


--------------------------BOOKING (1 Error)-----------------------
desc moncity.booking;

SELECT * FROM moncity.booking;

-- Check for duplicate data
SELECT Count(*) FROM  moncity.booking; -- 10001

SELECT Count(DISTINCT bookingid) FROM  moncity.booking; -- 10000

-- FIND DUPLICATE VALUE (T1218)
SELECT bookingid,registrationno,count(*) from moncity.booking
GROUP BY
     bookingid,registrationno
HAVING
    COUNT(*) > 1;

-- CHECK THE DUPLICATE RECORD 
SELECT * FROM moncity.booking WHERE bookingid = 'T1218';

--FIX ERROR 
CREATE TABLE booking AS 
SELECT DISTINCT * FROM moncity.booking;

SELECT * FROM booking;

-------------------------ACCIDENTINFO (2 Errors)-----------------
/* Invalid  foreign key error code (Error010)  exist which was not present in parent table*/
select * from moncity.accidentinfo;

-- ERROR DETECT
SELECT * 
FROM moncity.accidentinfo
WHERE errorcode NOT IN (SELECT errorcode FROM moncity.error);

-- FIX ERROR 
CREATE TABLE accidentinfo AS 
SELECT * 
FROM moncity.accidentinfo WHERE errorcode  IN (SELECT errorcode FROM moncity.error);


---Check for Null values 
SELECT * FROM accidentinfo WHERE accidentid IS NULL; 

--Fix error 
DELETE FROM accidentinfo 
WHERE accidentid IS NULL;


SELECT * FROM accidentinfo WHERE accidentid IS NULL; 

SELECT * FROM accidentinfo;


-------------------------CAR (No Error)-----------------
--CHECKING FOR ERRORS
SELECT * FROM moncity.car;

--CREATE NEW TABLE
CREATE TABLE car AS
SELECT * 
FROM moncity.car;

select * from car;

-------------------------MAINTENANCE (1 Error)-----------------


-- FINDING ERROR
SELECT * 
FROM moncity.maintenance
WHERE maintenancecost <= 0;

-- FIXING THE ERROR
CREATE TABLE maintenance AS 
SELECT * 
FROM moncity.maintenance
WHERE maintenancecost > 0;

SELECT * FROM maintenance;


-------------------------CARACCIDENT (No Error)-----------------

--CHECKING FOR ERRORS
SELECT * 
FROM
(SELECT accidentid, registrationno, count(*) AS NUM_OF_UNIQUEROWS
FROM moncity.caraccident
GROUP BY accidentid, registrationno)
WHERE NUM_OF_UNIQUEROWS > 1 OR accidentid IS NULL OR registrationno IS NULL;

--NO NULL VALUES OR DUPLICATE VALUES

--CREATE TABLE
CREATE TABLE caraccident AS
SELECT * 
FROM moncity.caraccident;

SELECT * FROM caraccident;


-------------------------MAINTENANCETEAM (No Error)-----------------
--no errors
SELECT * FROM moncity.maintenanceteam;

-- CREATE TABLE 
CREATE TABLE maintenanceteam AS
SELECT * 
FROM moncity.maintenanceteam;

SELECT * FROM maintenanceteam;


-------------------------BELONGTO (No Error)-----------------
--no errors
SELECT * FROM moncity.belongto;

-- CREATE TABLE
CREATE TABLE belongto AS
SELECT * 
FROM moncity.belongto;

SELECT * FROM belongto;

select * from moncity.accidentinfo;