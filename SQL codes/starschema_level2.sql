/* 
Members: Ko Ko Win, Mohamed Musthafa Mohamed Altaf 

Star Schema Level 2 Implementation

*/


-- Drop dimension & fact tables
DROP TABLE faculty_dim_2;

DROP TABLE month_dim_2;

DROP TABLE passengerage_dim_2;

DROP TABLE carbodytype_dim_2;

DROP TABLE booking_tempfact_2;

DROP TABLE booking_fact_2;

DROP TABLE errorcode_dim_2;

DROP TABLE accidentzone_dim_2;

DROP TABLE cardamageseverity_dim_2;

DROP TABLE car_dim_2;

DROP TABLE car_accident_bridge_2;

DROP TABLE accident_dim_2;

DROP TABLE accident_fact_2;

DROP TABLE accident_temp_fact_2;

DROP TABLE maintenancetype_dim_2;

DROP TABLE team_dim_2;

DROP TABLE teamresearch_bridge_2;

DROP TABLE researchcenter_dim_2;

DROP TABLE maintenance_temp_fact_2;

DROP TABLE maintenance_fact_2;



-- FacultyDIM
CREATE TABLE faculty_dim_2 AS 
SELECT FACULTYID, FACULTYNAME 
FROM FACULTY; 

-- MonthDIM
CREATE TABLE month_dim_2 AS 
SELECT DISTINCT to_char(BOOKINGDATE, 'MM') AS MONTH 
FROM BOOKING
ORDER BY MONTH asc;

-- PassengerAgeDIM
CREATE TABLE passengerage_dim_2 (CATEGORYID NUMBER , CATEGORYNAME VARCHAR(20));

INSERT INTO passengerage_dim_2 VALUES (1, 'Young Adults'); 
INSERT INTO passengerage_dim_2 VALUES (2, 'Middle Aged Adults'); 
INSERT INTO passengerage_dim_2 VALUES (3, 'Old Aged Adults'); 

-- CarBodyTypeDIM
CREATE TABLE carbodytype_dim_2 AS
SELECT DISTINCT CARBODYTYPE, NUMSEATS
FROM CAR;

ALTER TABLE carbodytype_dim_2
ADD (BODYTYPEID NUMBER);

UPDATE carbodytype_dim_2
SET BODYTYPEID = 1
WHERE CARBODYTYPE = 'Bus';

UPDATE carbodytype_dim_2
SET BODYTYPEID = 2
WHERE CARBODYTYPE = 'Mini Bus';

UPDATE carbodytype_dim_2
SET BODYTYPEID = 3
WHERE CARBODYTYPE = 'People Mover';

------ Booking Fact Level 2

-- Booking Temp Fact
CREATE TABLE booking_tempfact_2 AS 
SELECT p.PASSENGERID , 
p.PASSENGERAGE, 
b.BOOKINGID, 
to_char(b.BOOKINGDATE, 'MM') AS MONTH,
f.FACULTYID , 
c.REGISTRATIONNO ,
c.CARBODYTYPE
FROM PASSENGER p, FACULTY f, BOOKING b, CAR c 
WHERE p.facultyid = f.facultyid 
AND b.passengerid = p.passengerid 
AND b.registrationno = c.registrationno ;

ALTER TABLE booking_tempfact_2
ADD (CATEGORYID NUMBER);

UPDATE booking_tempfact_2
SET CATEGORYID = 1
WHERE PASSENGERAGE >= 18 AND PASSENGERAGE <= 35;
 
UPDATE booking_tempfact_2
SET CATEGORYID = 2
WHERE PASSENGERAGE >= 36 AND PASSENGERAGE <= 59;

UPDATE booking_tempfact_2
SET CATEGORYID = 3
WHERE PASSENGERAGE >= 60;

ALTER TABLE booking_tempfact_2
ADD(BODYTYPEID NUMBER);

UPDATE booking_tempfact_2
SET BODYTYPEID = 1
WHERE CARBODYTYPE = 'Bus';

UPDATE booking_tempfact_2
SET BODYTYPEID = 2
WHERE CARBODYTYPE = 'Mini Bus';

UPDATE booking_tempfact_2
SET BODYTYPEID = 3
WHERE CARBODYTYPE = 'People Mover';

-- BookingFact
CREATE TABLE booking_fact_2 AS 
SELECT 
MONTH, 
BODYTYPEID,
CATEGORYID,
FACULTYID,
Count(*) AS total_booking 
FROM booking_tempfact_2 
GROUP BY 
MONTH, 
BODYTYPEID,
CATEGORYID,
FACULTYID
ORDER BY MONTH ASC;


-----------------------ACCIDENT ------------------------------

-- ErrorCodeDIM
CREATE TABLE errorcode_dim_2 AS 
SELECT * FROM error; 

-- AccidentZoneDIM
CREATE TABLE accidentzone_dim_2(ZONEID NUMBER, ACCIDENTZONE VARCHAR(20));

INSERT INTO accidentzone_dim_2 VALUES(1, 'ZoneA'); 
INSERT INTO accidentzone_dim_2 VALUES(2, 'ZoneB'); 
INSERT INTO accidentzone_dim_2 VALUES(3, 'ZoneC'); 
INSERT INTO accidentzone_dim_2 VALUES(4, 'ZoneD'); 



-- CarDamageSeverityDIM 
CREATE TABLE cardamageseverity_dim_2(SEVERITYID NUMBER, SEVERITYDESC VARCHAR(20)); 

INSERT INTO cardamageseverity_dim_2 VALUES(1, 'No damage'); 
INSERT INTO cardamageseverity_dim_2 VALUES(2, 'Very minor damage'); 
INSERT INTO cardamageseverity_dim_2 VALUES(3, 'Minor damage'); 
INSERT INTO cardamageseverity_dim_2 VALUES(4, 'Moderate damage'); 
INSERT INTO cardamageseverity_dim_2 VALUES(5, 'Severe damage'); 

-- CarDIM
CREATE TABLE car_dim_2 AS SELECT * FROM CAR; 

-- CarAccidentBridge 
CREATE TABLE car_accident_bridge_2 AS SELECT * FROM CARACCIDENT;

-- AccidentDIM
CREATE TABLE accident_dim_2 AS 
SELECT A.ACCIDENTID, 
ROUND(1.0/COUNT(CA.REGISTRATIONNO),2) WeightFactor, 
LISTAGG(CA.REGISTRATIONNO, '_') WITHIN GROUP(ORDER BY CA.REGISTRATIONNO) AS RegistrationNoGroupList
FROM ACCIDENTINFO A, CARACCIDENT CA 
WHERE A.ACCIDENTID = CA.ACCIDENTID 
GROUP BY A.ACCIDENTID; 

-- ACCIDENT Temp FACT TABLE 
CREATE TABLE accident_temp_fact_2 AS 
SELECT 
A.ACCIDENTID, 
A.ACCIDENTZONE, 
A.CAR_DAMAGE_SEVERITY, 
E.ERRORCODE, 
COUNT(A.ACCIDENTID) AS TOTAL_ACCIDENT 
FROM ACCIDENTINFO A, ERROR E 
WHERE A.ERRORCODE = E.ERRORCODE 
GROUP BY A.ACCIDENTID, A.ACCIDENTZONE, A.CAR_DAMAGE_SEVERITY, E.ERRORCODE;

ALTER TABLE accident_temp_fact_2 
    ADD(ZONEID NUMBER); 

UPDATE accident_temp_fact_2 
SET ZONEID = 1 
WHERE ACCIDENTZONE = 'ZoneA' ;  

UPDATE accident_temp_fact_2 
SET ZONEID = 2 
WHERE ACCIDENTZONE = 'ZoneB' ;  

UPDATE accident_temp_fact_2 
SET ZONEID = 3 
WHERE ACCIDENTZONE = 'ZoneC' ;  

UPDATE accident_temp_fact_2 
SET ZONEID = 4 
WHERE ACCIDENTZONE = 'ZoneD' ;  

ALTER TABLE accident_temp_fact_2
    ADD(SEVERITYID NUMBER); 


UPDATE accident_temp_fact_2
SET SEVERITYID = 1 
WHERE CAR_DAMAGE_SEVERITY = 'No damage'; 

UPDATE accident_temp_fact_2
SET SEVERITYID = 2 
WHERE CAR_DAMAGE_SEVERITY = 'Very minor damage'; 

UPDATE accident_temp_fact_2
SET SEVERITYID = 3 
WHERE CAR_DAMAGE_SEVERITY = 'Minor damage'; 

UPDATE accident_temp_fact_2
SET SEVERITYID = 4 
WHERE CAR_DAMAGE_SEVERITY = 'Moderate damage'; 

UPDATE accident_temp_fact_2
SET SEVERITYID = 5 
WHERE CAR_DAMAGE_SEVERITY = 'Severe damage'; 

--AccidentFact
CREATE TABLE accident_fact_2 AS 
SELECT ZONEID , 
SEVERITYID, 
ERRORCODE, 
ACCIDENTID, 
COUNT(*) AS TOTAL_ACCIDENT
FROM accident_temp_fact_2
GROUP BY ZONEID, 
SEVERITYID, 
ERRORCODE, 
ACCIDENTID; 


-- MaintenanceTypeDIM
CREATE TABLE maintenancetype_dim_2 AS
SELECT *
FROM MAINTENANCETYPE;

-- ResearchTypeDIM
CREATE TABLE researchcenter_dim_2 AS
SELECT CENTERID, CENTERNAME
FROM RESEARCHCENTER;

-- TeamResearch Bridge table
CREATE TABLE teamresearch_bridge_2 AS
SELECT *
FROM BELONGTO;

-- TeamDIM
CREATE TABLE team_dim_2 AS
SELECT m.TEAMID, m.TEAMLEADER, 1/count(CENTERID) AS WeightFactor, LISTAGG(b.CENTERID, '_') Within Group (Order By b.CENTERID) AS CenterGroupList
FROM maintenanceteam m, belongto b
WHERE m.TEAMID = b.TEAMID
GROUP BY m.TEAMID, m.TEAMLEADER;

--MaintenanceTempFact
CREATE TABLE maintenance_temp_fact_2 AS
SELECT mt.MAINTENANCETYPE, t.TEAMID, m.REGISTRATIONNO, c.CARBODYTYPE, m.MAINTENANCEID , m.MAINTENANCECOST
FROM maintenancetype_dim_2 mt, maintenance m, team_dim_2 t, CAR c
WHERE m.TEAMID = t.TEAMID AND m.MAINTENANCETYPE = mt.MAINTENANCETYPE AND c.REGISTRATIONNO = m.REGISTRATIONNO
GROUP BY mt.MAINTENANCETYPE, t.TEAMID, m.REGISTRATIONNO, c.CARBODYTYPE, m.MAINTENANCEID , m.MAINTENANCECOST;

ALTER TABLE maintenance_temp_fact_2
ADD(BODYTYPEID NUMBER);

UPDATE maintenance_temp_fact_2
SET BODYTYPEID = 1
WHERE CARBODYTYPE = 'Bus';

UPDATE maintenance_temp_fact_2
SET BODYTYPEID = 2
WHERE CARBODYTYPE = 'Mini Bus';

UPDATE maintenance_temp_fact_2
SET BODYTYPEID = 3
WHERE CARBODYTYPE = 'People Mover';

-- Maintenance Fact Table
CREATE TABLE maintenance_fact_2 AS
SELECT MAINTENANCETYPE, BODYTYPEID, TEAMID, count(MAINTENANCEID) AS total_maintenance_records, SUM(MAINTENANCECOST) AS total_maintenance_cost
FROM maintenance_temp_fact_2 
GROUP BY MAINTENANCETYPE, BODYTYPEID, TEAMID;



SELECT * FROM faculty_dim_2;

SELECT * FROM month_dim_2;

SELECT * FROM passengerage_dim_2;

SELECT * FROM carbodytype_dim_2;

SELECT * FROM booking_tempfact_2;

SELECT * FROM booking_fact_2;

SELECT * FROM errorcode_dim_2;

SELECT * FROM accidentzone_dim_2;

SELECT * FROM cardamageseverity_dim_2;

SELECT * FROM car_dim_2;

SELECT * FROM car_accident_bridge_2;

SELECT * FROM accident_dim_2;

SELECT * FROM accident_temp_fact_2;

SELECT * FROM accident_fact_2;

SELECT * FROM maintenancetype_dim_2;

SELECT * FROM team_dim_2;

SELECT * FROM teamresearch_bridge_2;

SELECT * FROM researchcenter_dim_2;

SELECT * FROM maintenance_temp_fact_2;

SELECT * FROM maintenance_fact_2;














