-- 1. Show all tables in the database

SELECT name 
FROM sqlite_master 
WHERE type='table';



-- 2. View the schema of each table

PRAGMA table_info(Person);
PRAGMA table_info(HealthRecord);
PRAGMA table_info(EmploymentRecord);



-- 3. Display first 20 people

SELECT * 
FROM Person
LIMIT 20;



-- 4. INNER JOIN:
--    Show each person with their health records
--    Demonstrates foreign key: HealthRecord.person_id → Person.person_id

SELECT 
    p.person_id,
    p.full_name,
    p.gender,
    h.record_id,
    h.calories,
    h.blood_pressure,
    h.checkup_date
FROM Person p
JOIN HealthRecord h 
    ON p.person_id = h.person_id
ORDER BY p.person_id
LIMIT 30;



-- 5. LEFT JOIN:
--    Show all people + employment info if available
--    Demonstrates realistic missing employment data

SELECT
    p.person_id,
    p.full_name,
    p.employee_status,
    e.employer,
    e.years_exp
FROM Person p
LEFT JOIN EmploymentRecord e
    ON p.person_id = e.person_id
ORDER BY p.person_id
LIMIT 30;



-- 6. FULL RELATIONAL QUERY (3-table join):
--    Person + EmploymentRecord + HealthRecord
--    Demonstrates referential integrity across all tables

SELECT 
    p.person_id,
    p.full_name,
    e.employer,
    e.years_exp,
    h.calories,
    h.blood_pressure,
    h.checkup_date
FROM Person p
LEFT JOIN EmploymentRecord e
    ON p.person_id = e.person_id
LEFT JOIN HealthRecord h
    ON p.person_id = h.person_id
ORDER BY p.person_id
LIMIT 40;



-- 7. GROUP BY:
--    Count how many health records each person has
--    Shows one-to-many relationship

SELECT 
    p.person_id,
    p.full_name,
    COUNT(h.record_id) AS total_health_checks
FROM Person p
LEFT JOIN HealthRecord h
    ON p.person_id = h.person_id
GROUP BY p.person_id
ORDER BY total_health_checks DESC
LIMIT 30;



-- 8. AGGREGATION:
--    Average calories by gender

SELECT 
    p.gender,
    AVG(h.calories) AS avg_calories
FROM Person p
JOIN HealthRecord h
    ON p.person_id = h.person_id
GROUP BY p.gender;



-- 9. FILTERING:
--    Find all diabetic patients + their latest health check

SELECT 
    p.person_id,
    p.full_name,
    p.diabetes,
    h.blood_pressure,
    h.calories,
    h.checkup_date
FROM Person p
JOIN HealthRecord h 
    ON p.person_id = h.person_id
WHERE p.diabetes = 'Yes'
ORDER BY h.checkup_date DESC
LIMIT 30;



-- 10. COMPOSITE KEY VALIDATION:
--     Check if any duplicate (record_id, person_id) exists
--     Should return ZERO rows

SELECT 
    record_id, 
    person_id,
    COUNT(*)
FROM HealthRecord
GROUP BY record_id, person_id
HAVING COUNT(*) > 1;



-- 11. PEOPLE WITH MISSING EMPLOYMENT RECORDS

SELECT 
    p.person_id,
    p.full_name,
    p.employee_status
FROM Person p
LEFT JOIN EmploymentRecord e
    ON p.person_id = e.person_id
WHERE e.emp_record_id IS NULL;



-- 12. Derived BMI category (computed via SQL)

SELECT
    person_id,
    full_name,
    bmi,
    CASE
        WHEN bmi IS NULL THEN 'Unknown'
        WHEN bmi < 18.5 THEN 'Underweight'
        WHEN bmi < 25 THEN 'Normal'
        WHEN bmi < 30 THEN 'Overweight'
        ELSE 'Obese'
    END AS bmi_category
FROM Person
LIMIT 20;



-- 13. People With Abnormally High Blood Pressure

SELECT
    p.person_id,
    p.full_name,
    h.blood_pressure
FROM Person p
JOIN HealthRecord h
    ON p.person_id = h.person_id
WHERE CAST(substr(h.blood_pressure, 1, instr(h.blood_pressure, '/') - 1) AS INT) > 140;



-- 14. Compare Average BMI Between Employed vs Unemployed

SELECT
    employee_status,
    ROUND(AVG(bmi), 2) AS avg_bmi
FROM Person
GROUP BY employee_status;



-- 15. Find the Most Experienced Employees

SELECT
    p.person_id,
    p.full_name,
    e.employer,
    e.years_exp
FROM Person p
JOIN EmploymentRecord e
    ON p.person_id = e.person_id
ORDER BY e.years_exp DESC
LIMIT 20;
