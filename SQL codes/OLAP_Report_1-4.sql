/*
OLAP Reports 1-4 
Members: KoKoWin, Mohammed Musthafa


*/


-- 3.1 

-- (REPORT 1) 
SELECT f.FACULTYID,
m.MONTH, 
to_char(sum(TOTAL_BOOKING), '999,999,999') AS Total_Bookings, 
to_char(sum(sum(TOTAL_BOOKING)) over 
    (
    PARTITION by f.FACULTYID
    ORDER BY f.FACULTYID, m.MONTH
    rows unbounded preceding), '999,999,999' ) AS Cumulative_Bookings
FROM booking_fact_2 b, month_dim_2 m, faculty_dim_2 f 
WHERE b.MONTH = m.MONTH 
AND b.FACULTYID = f.FACULTYID
and f.FACULTYID in ('FIT') 
GROUP BY f.FACULTYID, m.MONTH;

-- REPORT 2 
SELECT 
    DECODE(GROUPING(t.TEAMID), 1, 'All Teams', t.TEAMID) AS Team_ID, 
    DECODE(GROUPING(c.CARBODYTYPE), 1, 'All Car Body Types', c.CARBODYTYPE) AS Car_Body_Type, 
    SUM(m.TOTAL_MAINTENANCE_RECORDS) AS Total_Number_Of_Maintenance,
    SUM(m.TOTAL_MAINTENANCE_COST) AS Total_Maintenance_Cost 
FROM maintenance_fact_2 m, carbodytype_dim_2 c, team_dim_2 t 
WHERE m.BODYTYPEID = c.BODYTYPEID
AND m.TEAMID = t.TEAMID
AND t.TEAMID IN ('T002', 'T003')
GROUP BY CUBE(t.TEAMID, c.CARBODYTYPE);


-- REPORT 3
SELECT *
FROM 
    (SELECT
        af.ERRORCODE,
        cd.REGISTRATIONNO,
        cd.CARBODYTYPE,
        SUM(af.TOTAL_ACCIDENT) AS Total_Number_Of_Accidents,
        DENSE_RANK() OVER (PARTITION BY af.ERRORCODE ORDER BY SUM(af.TOTAL_ACCIDENT) DESC) AS RANK
    FROM 
        accident_fact_2 af, accident_dim_2 ad, car_accident_bridge_2 cab, car_dim_2 cd
    WHERE
        af.ACCIDENTID = ad.ACCIDENTID 
    AND ad.ACCIDENTID = cab.ACCIDENTID
    AND cab.REGISTRATIONNO = cd.REGISTRATIONNO
    GROUP BY af.ERRORCODE, cd.REGISTRATIONNO, cd.CARBODYTYPE)
WHERE RANK <= 3;

-- REPORT 4

SELECT 
    DECODE(GROUPING(c.CARBODYTYPE), 0, 'People Mover', c.CARBODYTYPE) AS Car_Body_Type,
    DECODE(GROUPING(p.CATEGORYID), 1, 'All Age Groups', p.CATEGORYID) AS Age_groups,
    DECODE(GROUPING(f.FACULTYID), 1, 'All Faculties', f.FACULTYID) AS All_Faculties,
    SUM(b.total_booking) AS Total_Number_Of_Bookings
FROM booking_fact_2 b, carbodytype_dim_2 c, faculty_dim_2 f, passengerage_dim_2 p
WHERE b.BODYTYPEID = c.BODYTYPEID
AND c.CARBODYTYPE IN 'People Mover'
AND p.CATEGORYID = b.CATEGORYID
AND f.FACULTYID = b.FACULTYID
AND c.CARBODYTYPE IS NOT NULL
GROUP BY c.CARBODYTYPE, CUBE(p.CATEGORYID, f.FACULTYID);


