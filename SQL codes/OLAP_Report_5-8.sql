/*
OLAP Reports 5-8
Members: KoKoWin, Mohammed Musthafa


*/


--3.2

-- REPORT 5 
SELECT p.CATEGORYNAME,  c.CARBODYTYPE, 
              SUM(b.TOTAL_BOOKING) AS Total_Bookings
FROM booking_fact_2 b, passengerage_dim_2 p,  carbodytype_dim_2 c
WHERE b.CATEGORYID = p.CATEGORYID
AND b.BODYTYPEID = c.BODYTYPEID 
GROUP BY ROLLUP( p.CATEGORYNAME, c.CARBODYTYPE);



-- REPORT 6
SELECT f.FACULTYID, c.CARBODYTYPE, SUM(b.TOTAL_BOOKING) AS Total_Booking 
FROM booking_fact_2 b, carbodytype_dim_2 c, faculty_dim_2 f
WHERE b.BODYTYPEID = c.BODYTYPEID
AND b.FACULTYID = f.FACULTYID
GROUP BY  f.FACULTYID, ROLLUP(c.CARBODYTYPE)
ORDER BY f.FACULTYID, c.CARBODYTYPE;


-- 3.3

-- REPORT 7 
SELECT m.MONTH,
            to_char(SUM(b.TOTAL_BOOKING), '999,999,999') AS Total_Bookings,
            to_char(AVG(SUM(b.TOTAL_BOOKING))
            over( order by m.MONTH rows 2 preceding), '999,999,999' ) AS Moving_Aggregate
FROM booking_fact_2 b, faculty_dim_2 f, month_dim_2 m
WHERE b.MONTH = m.MONTH
AND b.FACULTYID = f.FACULTYID 
AND f.FACULTYID IN ('SCI')
GROUP BY m.MONTH ;


-- REPORT 8
SELECT 
    c.CARBODYTYPE,
    m.TEAMID,
    TO_CHAR (SUM(SUM(m.TOTAL_MAINTENANCE_COST)) OVER(ORDER BY m.TEAMID, c.CARBODYTYPE ROWS UNBOUNDED PRECEDING),'9,999,999,999') AS CUM_MAINTENANCE_COST
FROM maintenance_fact_2 m, carbodytype_dim_2 c
WHERE m.BODYTYPEID = c.BODYTYPEID
GROUP BY c.CARBODYTYPE, m.TEAMID;
