/*Healthcare data anaylsis sql project*/

--Checking records in database

SELECT *
FROM HealthDatabase..healthcare;

--Q1. How many patient records are stored in the database?

SELECT COUNT(*) AS Total_Patient_Records
FROM HealthDatabase..healthcare;

--Q2. What is the average age of patients in the database?

SELECT AVG(Age) AS Patients_Average_Age
FROM HealthDatabase..healthcare;

--Q3. What is the average age of patients admitted to each hospital?

SELECT Hospital_Name,AVG(Age) AS Patients_Average_Age
FROM HealthDatabase..healthcare
GROUP BY Hospital_Name;

--Q4. How many patients of each gender have been admitted to the hospital?

SELECT Gender,COUNT(*) AS Number_of_Patients
FROM HealthDatabase..healthcare
GROUP BY Gender;

--Q5. What is the total billing amount for all admissions in the database?

SELECT SUM(Billing_Amount) AS Total_Billing_Amount
FROM HealthDatabase..healthcare;

--Q6. What is the average billing amount per patient for each hospital?

SELECT Hospital_Name,AVG(Billing_Amount) AS Average_Billing_Amount_Per_Patient
FROM HealthDatabase..healthcare
GROUP BY Hospital_Name;

--Q7. How does the average billing amount vary depending on the admission type and medical condition?

SELECT Admission_Type,Medical_Condition,AVG(Billing_Amount) AS Average_Billing_Amount
FROM HealthDatabase..healthcare
GROUP BY Admission_Type,Medical_Condition
ORDER BY Admission_Type,Medical_Condition;

--Q8. What is the distribution of blood types among the patient population?

SELECT Blood_Type,COUNT(*) AS Number_of_Patients
FROM HealthDatabase..healthcare
GROUP BY Blood_Type
ORDER BY Blood_Type;

--Q9. What is the most common blood type among patients in the database?

SELECT TOP(1) Blood_Type,COUNT(*) AS Number_of_Patients
FROM HealthDatabase..healthcare
GROUP BY Blood_Type
ORDER BY Number_of_Patients DESC;

--Q10. How many patients have been diagnosed with diabetes?

SELECT COUNT(*) AS Patients_With_Diabetes
FROM HealthDatabase..healthcare
WHERE Medical_Condition = 'Diabetes';

--Q11. What is the most common blood type among patients with a specific medical condition?

SELECT TOP(1) Blood_Type,COUNT(*) AS Number_of_Patients
FROM HealthDatabase..healthcare
WHERE Medical_Condition = 'Diabetes'
GROUP BY Blood_Type
ORDER BY Number_of_Patients DESC;

--Q12. What is the distribution of test results for patients with a specific medical condition?

SELECT Test_Results,COUNT(*) Test_Result_count
FROM HealthDatabase..healthcare
WHERE Medical_Condition = 'Diabetes'
GROUP BY Test_Results;

--Q13. What is the average age of patients admitted to each hospital for a specific medical condition?

SELECT Hospital_Name,AVG(Age) As Patients_Average_Age
FROM HealthDatabase..healthcare
WHERE Medical_Condition = 'Diabetes'
GROUP BY Hospital_Name;

--Q14. What is the most common diagnosis among patients in the database?

SELECT TOP(1) Medical_Condition,COUNT(*) AS Number_of_Patients
FROM HealthDatabase..healthcare
GROUP BY Medical_Condition
ORDER BY Number_of_Patients DESC;

--Q15. Which insurance provider covers the highest number of patients?

SELECT TOP(1) Insurance_Provider,COUNT(*) AS Number_of_Patients
FROM HealthDatabase..healthcare
GROUP BY Insurance_Provider;

--Q16. How does the average length of stay vary depending on the insurance provider?

SELECT Insurance_Provider,AVG(DATEDIFF(DAY,Date_of_Admission,Discharge_Date)) AS Average_Length_of_Stay
FROM HealthDatabase..healthcare
GROUP BY Insurance_Provider;

--Q17. How many patients were admitted as emergencies vs elective cases?

SELECT Admission_Type,COUNT(*) AS Number_of_Patients
FROM HealthDatabase..healthcare
WHERE Admission_Type IN('Emergency','Elective')
GROUP BY Admission_Type;

--Q18. How does the billing amount vary based on the admission type (emergency vs elective)?

SELECT Admission_Type,AVG(Billing_Amount) AS Average_Billing_Amount
FROM HealthDatabase..healthcare
WHERE Admission_Type IN('Emergency','Elective')
GROUP BY Admission_Type;

--Q19. What is the distribution of discharge dates for patients in the database?

SELECT Discharge_Date,COUNT(*) AS Number_of_patients
FROM HealthDatabase..healthcare
GROUP BY Discharge_Date
ORDER BY Discharge_Date;

--Q20. How many patients were prescribed medication upon discharge, and what are the most commonly prescribed medications?

SELECT COUNT(DISTINCT Patient_Name) AS Patients_with_Medication_Upon_Discharge
FROM HealthDatabase..healthcare;

--most commonly prescribed medications

SELECT TOP(1) Medication,COUNT(*) AS Prescription_Count
FROM HealthDatabase..healthcare
GROUP BY Medication
ORDER BY Prescription_Count DESC;

--Q21. Which doctor has admitted the highest number of patients?

SELECT TOP(1) Doctor_Name,COUNT(DISTINCT Patient_Name) AS Number_of_patients
FROM HealthDatabase..healthcare
GROUP BY Doctor_Name
ORDER BY Number_of_patients DESC;

--Q22. Which doctor has the highest average billing amount per patient?

SELECT TOP(1) Doctor_Name,AVG(Billing_Amount) Average_Billing_Amount_Per_Patient
FROM HealthDatabase..healthcare
GROUP BY Doctor_Name
ORDER BY Average_Billing_Amount_Per_Patient DESC;

--Q23. How many patients were admitted to each room number during a specific time period?

SELECT Room_Number,COUNT(*) AS Number_of_Patients_Admitted
FROM HealthDatabase..healthcare
WHERE Date_of_Admission >= '2022-10-30' AND Date_of_Admission <= '2023-10-30'
GROUP BY Room_Number;

--Q24. What is the average length of stay in the hospital for patients with different medical conditions?

SELECT Medical_Condition,AVG(DATEDIFF(DAY,Date_of_Admission,Discharge_Date)) AS Average_Length_of_Stay
FROM HealthDatabase..healthcare
GROUP BY Medical_Condition;

--Q25. What is the trend in the average length of stay over time for each hospital?

SELECT Hospital_Name,YEAR(Date_of_Admission) AS Admission_Year,MONTH(Date_of_Admission) AS Admission_Month,AVG(DATEDIFF(DAY,Date_of_Admission,Discharge_Date)) Average_Length_of_Stay
FROM HealthDatabase..healthcare
GROUP BY Hospital_Name,YEAR(Date_of_Admission),MONTH(Date_of_Admission)
ORDER BY Hospital_Name,Admission_Year,Admission_Month;

--Q26. What is the distribution of room occupancy rates for each hospital?

SELECT Hospital_Name,Room_Number,(COUNT(*) * 100.0)/COUNT(Room_Number) AS Occupancy_Rate
FROM HealthDatabase..healthcare
GROUP BY Hospital_Name,Room_Number;

--Q27. What is the average number of medications prescribed per patient for each medical condition?

SELECT Medical_Condition,AVG(CASE WHEN Medication IS NOT NULL THEN 1 ELSE 0 END) AS Prescribed_Mediactions_Per_Patient
FROM HealthDatabase..healthcare
GROUP BY Medical_Condition;

--Q28. What percentage of patients had abnormal test results during their admission?

SELECT 
	COUNT(DISTINCT Patient_Name) AS Total_Patients,
	SUM(CASE WHEN Test_Results = 'Abnormal' THEN 1 ELSE 0 END) AS Patients_With_Abnormal_Test_Result,
	(SUM(CASE WHEN Test_Results = 'Abnormal' THEN 1 ELSE 0 END)/CAST(COUNT(DISTINCT Patient_Name) AS FLOAT)) * 100 AS Percentage_Abnormal_Test_Result
FROM HealthDatabase..healthcare;

--Q29. Which hospital has the highest percentage of patients admitted as emergencies?

SELECT TOP(1) Hospital_Name,
		(Emeregency_Admissions * 100.0)/Total_Admisssions AS Percentage_of_Emergency_Admissions
FROM (SELECT
		Hospital_Name,
		SUM(CASE WHEN Admission_Type = 'Emergency' THEN 1 ELSE 0 END) AS Emeregency_Admissions,
		COUNT(*) AS Total_Admisssions
	 FROM HealthDatabase..healthcare
	 GROUP BY Hospital_Name) AS hc
ORDER BY Percentage_of_Emergency_Admissions DESC;

--Q30. How many patients with a specific medical condition were readmitted within 30 days of discharge?

SELECT COUNT(DISTINCT t1.Patient_Name) AS Patients_Readmitted
FROM HealthDatabase..healthcare t1
JOIN HealthDatabase..healthcare t2
	ON t1.Patient_Name = t2.Patient_Name
WHERE t1.Medical_Condition = 'Diabetes'
AND t2.Medical_Condition = 'Diabetes'
AND DATEDIFF(Day,t1.Discharge_Date,t2.Date_of_Admission) BETWEEN 1 AND 30;
