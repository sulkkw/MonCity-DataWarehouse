/* 
Members: Ko Ko Win, Mohamed Musthafa Mohamed Altaf 

Star Schema Level 0 Implementation

*/

-- Drop dimension & fact tables
DROP TABLE car_dim_0;

DROP TABLE accident_temp_fact_0;

DROP TABLE accident_fact_0;

DROP TABLE maintenance_fact_0;

DROP TABLE booking_dim_0;

DROP TABLE passenger_dim_0;

DROP TABLE passenger_faculty_temp;

DROP TABLE booking_fact_0;



--Car Dimension
CREATE TABLE car_dim_0 AS SELECT * FROM CAR; 

------ Accident Fact Level 0

-- Accident Temp Fact Table
CREATE TABLE accident_temp_fact_0 AS 
SELECT 
A.ACCIDENTID, 
A.ACCIDENTZONE, 
A.CAR_DAMAGE_SEVERITY, 
E.ERRORCODE, 
COUNT(A.ACCIDENTID) AS TOTAL_ACCIDENT 
FROM ACCIDENTINFO A, ERROR E 
WHERE A.ERRORCODE = E.ERRORCODE 
GROUP BY A.ACCIDENTID, A.ACCIDENTZONE, A.CAR_DAMAGE_SEVERITY, E.ERRORCODE;

ALTER TABLE accident_temp_fact_0 
    ADD(ZONEID NUMBER); 

UPDATE accident_temp_fact_0 
SET ZONEID = 1 
WHERE ACCIDENTZONE = 'ZoneA' ;  

UPDATE accident_temp_fact_0 
SET ZONEID = 2 
WHERE ACCIDENTZONE = 'ZoneB' ;  

UPDATE accident_temp_fact_0 
SET ZONEID = 3 
WHERE ACCIDENTZONE = 'ZoneC' ;  

UPDATE accident_temp_fact_0 
SET ZONEID = 4 
WHERE ACCIDENTZONE = 'ZoneD' ;  

ALTER TABLE accident_temp_fact_0
    ADD(SEVERITYID NUMBER); 


UPDATE accident_temp_fact_0
SET SEVERITYID = 1 
WHERE CAR_DAMAGE_SEVERITY = 'No damage'; 

UPDATE accident_temp_fact_0
SET SEVERITYID = 2 
WHERE CAR_DAMAGE_SEVERITY = 'Very minor damage'; 

UPDATE accident_temp_fact_0
SET SEVERITYID = 3 
WHERE CAR_DAMAGE_SEVERITY = 'Minor damage'; 

UPDATE accident_temp_fact_0
SET SEVERITYID = 4 
WHERE CAR_DAMAGE_SEVERITY = 'Moderate damage'; 

UPDATE accident_temp_fact_0
SET SEVERITYID = 5 
WHERE CAR_DAMAGE_SEVERITY = 'Severe damage'; 

--Accident Fact Table
CREATE TABLE accident_fact_0 AS 
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

------ Maintenance Fact Level 0

-- Maintenance Fact Table
CREATE TABLE maintenance_fact_0 AS 
SELECT mty.MAINTENANCETYPE, 
                c.REGISTRATIONNO, 
                mt.TEAMID, 
                COUNT(MAINTENANCEID) AS total_maintenance_records,
                SUM(m.MAINTENANCECOST) AS total_maintenance_cost 
FROM MAINTENANCETYPE mty, 
            CAR c, 
            MAINTENANCETEAM mt, 
            MAINTENANCE m 
WHERE mty.MAINTENANCETYPE = m.MAINTENANCETYPE
                AND c.REGISTRATIONNO = m.REGISTRATIONNO
                AND mt.TEAMID = m.TEAMID
GROUP BY  mty.MAINTENANCETYPE, 
                    c.REGISTRATIONNO, 
                    mt.TEAMID;

SELECT * FROM maintenance_fact_0;


------ Booking Fact Level 0

-- BookingDIM
CREATE TABLE booking_dim_0 AS
SELECT  BOOKINGID, BOOKINGDATE 
FROM BOOKING;


-- PassengerDIM
CREATE TABLE passenger_dim_0 AS
SELECT PASSENGERID, PASSENGERNAME, PASSENGERAGE
FROM PASSENGER;



-- Booking fact Table
CREATE TABLE passenger_faculty_temp AS
SELECT p.PASSENGERID, p.PASSENGERNAME, p.PASSENGERAGE, f.FACULTYID
FROM PASSENGER p, FACULTY f
WHERE p.FACULTYID = f.FACULTYID;


-- BookingFact
CREATE TABLE booking_fact_0 AS
SELECT b.BOOKINGID,  c.REGISTRATIONNO, pf.PASSENGERID, pf.FACULTYID, COUNT(bk.BOOKINGID) AS total_booking
FROM booking_dim_0 b, passenger_faculty_temp pf, car_dim_0 c, BOOKING bk
WHERE b.BOOKINGID = bk.BOOKINGID AND pf.PASSENGERID = bk.PASSENGERID AND c.REGISTRATIONNO = bk.REGISTRATIONNO
GROUP BY b.BOOKINGID, pf.PASSENGERID, c.REGISTRATIONNO, pf.FACULTYID; 

SELECT * FROM accident_temp_fact_0;

SELECT * FROM accident_fact_0;

select * from booking_dim_0;

select * from passenger_dim_0;

select * from passenger_faculty_temp;

SELECT * FROM booking_fact_0;






















