-- Count the total number of applications in the dateset

SELECT COUNT(id) AS Total_Applications FROM bank_loan_db.bank_loan;

-- Adding a new Column 'ConvertedDate' to the dataset

ALTER TABLE bank_loan
ADD COLUMN ConvertedDate DATE;

-- Converting the date values in the 'issue_date' column to a valid date format and adding the resulting values in the 'ConvertedDate' column.

UPDATE bank_loan
SET ConvertedDate = CASE
    WHEN issue_date LIKE '__/__/____' THEN STR_TO_DATE(issue_date, '%d/%m/%Y') -- DD/MM/YYYY
    WHEN issue_date LIKE '__-__-____' THEN STR_TO_DATE(issue_date, '%d-%m-%Y') -- DD-MM-YYYY
    WHEN issue_date LIKE '____-__-__' THEN STR_TO_DATE(issue_date, '%Y-%m-%d') -- YYYY-MM-DD
    ELSE NULL
END;

-- Verifying the changes made

SELECT *
FROM bank_loan;

-- Dropping the 'issue_date' column with the date values in text format

ALTER TABLE bank_loan
DROP COLUMN issue_date;

-- Renaming the 'ConvertedDate' column to 'issue_date'.

ALTER TABLE bank_loan
CHANGE COLUMN ConvertedDate issue_date DATE;

-- Counting the total applications received in Decemeber 2021

SELECT COUNT(id)  AS MTD_Total_Loan_Applications FROM bank_loan
WHERE MONTH(issue_date) = 12 AND YEAR(issue_date) = 2021;

SELECT COUNT(id) AS PMTD_Total_Loan_Application FROM bank_loan
WHERE MONTH(issue_date) = 11;

-- Converting the columns 'last_credit_pull_date' and 'last_payment_date' from text to date format.

ALTER TABLE bank_loan
ADD COLUMN Converted_last_credit_pull_date DATE;

ALTER TABLE bank_loan
ADD COLUMN Converted_last_payment_date DATE;

UPDATE bank_loan
SET Converted_last_credit_pull_date = CASE
    WHEN last_credit_pull_date LIKE '__/__/____' THEN STR_TO_DATE(last_credit_pull_date, '%d/%m/%Y') -- DD/MM/YYYY
    WHEN last_credit_pull_date LIKE '__-__-____' THEN STR_TO_DATE(last_credit_pull_date, '%d-%m-%Y') -- DD-MM-YYYY
    WHEN last_credit_pull_date LIKE '____-__-__' THEN STR_TO_DATE(last_credit_pull_date, '%Y-%m-%d') -- YYYY-MM-DD
    ELSE NULL
END;

-- Adding another column 'Converted_last_payment_date' to copying the values from 'last_payment_date' as date.

UPDATE bank_loan
SET Converted_last_payment_date = CASE
    WHEN last_payment_date LIKE '__/__/____' THEN STR_TO_DATE(last_payment_date, '%d/%m/%Y') -- DD/MM/YYYY
    WHEN last_payment_date LIKE '__-__-____' THEN STR_TO_DATE(last_payment_date, '%d-%m-%Y') -- DD-MM-YYYY
    WHEN last_payment_date LIKE '____-__-__' THEN STR_TO_DATE(last_payment_date, '%Y-%m-%d') -- YYYY-MM-DD
    ELSE NULL
END;

-- Dropping the original 'last_credit_pull_date' and 'last_payment_date'

ALTER TABLE bank_loan
DROP COLUMN last_credit_pull_date;

ALTER TABLE bank_loan
DROP COLUMN last_payment_date;

-- Adding new column 'Converted_next_payment_date' and copying values from 'next_payment_date' as date values.

ALTER TABLE bank_loan
ADD COLUMN Converted_next_payment_date DATE;

UPDATE bank_loan
SET Converted_next_payment_date = CASE
    WHEN next_payment_date LIKE '__/__/____' THEN STR_TO_DATE(next_payment_date, '%d/%m/%Y') -- DD/MM/YYYY
    WHEN next_payment_date LIKE '__-__-____' THEN STR_TO_DATE(next_payment_date, '%d-%m-%Y') -- DD-MM-YYYY
    WHEN next_payment_date LIKE '____-__-__' THEN STR_TO_DATE(next_payment_date, '%Y-%m-%d') -- YYYY-MM-DD
    ELSE NULL
END;

-- Dropping the original column 'next_payment_date'

ALTER TABLE bank_loan
DROP COLUMN next_payment_date;

-- Renaming the 'Converted_next_paymetn_date' to 'next_payment_date'

ALTER TABLE bank_loan
CHANGE COLUMN Converted_next_payment_date next_payment_date DATE;

-- Verifying the results

SELECT *
FROM bank_loan;

-- Summing the total funded amount (loan disbursed by the bank)

SELECT SUM(loan_amount) AS Total_Funded_Amount FROM bank_loan;

-- Calculating the funded amount for MTD (Month = 12, Year = 2021)

SELECT SUM(loan_amount) AS MTD_Total_Funded_Amount FROM bank_loan
WHERE MONTH(issue_date) = 12 AND YEAR(issue_date) = 2021;

-- Calculating the funded amount for Previous MTD (Month = 11, Year = 2021)

SELECT SUM(loan_amount) AS PMTD_Total_Funded_Amount FROM bank_loan
WHERE MONTH(issue_date) = 11 AND YEAR(issue_date) = 2021;

-- Calculating the total amount received from the borrowers

SELECT SUM(total_payment) AS Total_Amount_Received
FROM bank_loan;

-- Calculating the total amount received in the month = 12 of 2021

SELECT SUM(total_payment) AS MTD_Total_Amount_Received FROM bank_loan
WHERE MONTH(issue_date) = 12 AND YEAR(issue_date) = 2021;


-- Calculating the total amount received in the previous month = 12 of 2021 (PMTD)

SELECT SUM(total_payment) AS PMTD_Total_Amount_Received FROM bank_loan
WHERE MONTH(issue_date) = 11 AND YEAR(issue_date) = 2021;

-- Now calculating the average intrust rate

SELECT AVG(int_rate) AS Avg_Int_Rate FROM bank_loan;

-- Calculating MTD Average Interest rate

SELECT AVG(int_rate) AS MTD_Avg_Int_Rate FROM bank_loan
WHERE MONTH(issue_date) = 12 AND YEAR(issue_date) = 2021;

-- Calculating PMTD Average Interest Rate

SELECT AVG(int_rate) AS PMTD_Avg_Int_Rate FROM bank_loan
WHERE MONTH(issue_date) = 11 AND YEAR(issue_date) = 2021;


-- Calculating Avg DTI (Debt To Income Ratio) 

SELECT AVG(dti)*100 AS Avg_DTI FROM bank_loan;

-- MTD Avg DTI

SELECT AVG(dti)*100 AS MTD_Avg_DTI FROM bank_loan
WHERE MONTH(issue_date) = 12 AND YEAR(issue_date) = 2021;


-- PMTD Avg DTI

SELECT AVG(dti)*100 AS PMTD_Avg_DTI FROM bank_loan
WHERE MONTH(issue_date) = 11 AND YEAR(issue_date) = 2021;

-- Good Loan Issued
-- Calculating Good Loan Percentage

SELECT
	(COUNT(CASE WHEN loan_status = 'Fully Paid' OR
    loan_status = 'Current' THEN id END) *100) /
            COUNT(id) AS Good_Loan_Percentage
FROM bank_loan;

-- Calculating total count of good loan applications

SELECT COUNT(id) AS Good_Loan_Applications
FROM bank_loan
WHERE loan_status = 'Fully Paid' OR loan_status = 'Current';

-- Calculating the Good Loan Funded Amount

SELECT SUM(loan_amount) AS Good_Loan_Funded_Amount
FROM bank_loan
WHERE loan_status = 'Fully Paid' OR loan_status = 'Current';

-- Calculating Good Loan Amount Received

SELECT SUM(total_payment) AS Good_Loan_Amount_Received
FROM bank_loan
WHERE loan_status = 'Fully Paid' OR loan_status = 'Current';


-- Bad Loan Issued
-- Calculating Bad Loan Percentage

SELECT
	(COUNT(CASE WHEN loan_status = 'Charged off' THEN id END) *100) /
	COUNT(id) AS Bad_Loan_Percentage
FROM bank_loan;

-- Calculating total count of good loan applications

SELECT COUNT(id) AS Bad_Loan_Applications
FROM bank_loan
WHERE loan_status = 'Charged off';

-- Calculating the Good Loan Funded Amount

SELECT SUM(loan_amount) AS Bad_Loan_Funded_Amount
FROM bank_loan
WHERE loan_status = 'Charged off';

-- Calculating Good Loan Amount Received

SELECT SUM(total_payment) AS Bad_Loan_Amount_Received
FROM bank_loan
WHERE loan_status = 'Charged off';

-- Calculating the Loan Status

SELECT
	loan_status,
    COUNT(id) AS LoanCount,
    SUM(total_payment) AS Total_Amount_Received,
    SUM(loan_amount) AS Total_Funded_Amount,
    AVG(int_rate * 100) AS Interest_Rate,
    AVG(dti * 100) AS DTI
FROM
	bank_loan
GROUP BY loan_status;

-- Calculating the MTD Loan Status

SELECT
	loan_status,
    SUM(total_payment) AS MTD_Total_Amount_Received,
    SUM(loan_amount) AS MTD_Total_Funded_Amount
FROM
	bank_loan
WHERE MONTH(issue_date) = 12
GROUP BY loan_status;

-- BANK LOAN REPORT | OVERVIEW - MONTH

SELECT
	MONTH(issue_date) AS Month_Number,
    MONTHNAME(issue_date) AS Month_name,
    COUNT(id) AS Total_Loan_Applications,
    SUM(loan_amount) AS Total_Funded_Amount,
    SUM(total_payment) AS Total_Amount_Received
FROM bank_loan
GROUP BY MONTH(issue_date), MONTHNAME(issue_date)
ORDER BY MONTH(issue_date);


-- BANK LOAN REPORT | OVERVIEW - STATE

SELECT
	address_state AS State,
    COUNT(id) AS Total_Loan_Applications,
    SUM(loan_amount) AS Total_Funded_Amount,
    SUM(total_payment) AS Total_Amount_Received
FROM bank_loan
GROUP BY address_state
ORDER BY address_state;

-- BANK LOAN REPORT | OVERVIEW - TERM

SELECT
	term AS Term,
    COUNT(id) AS Total_Loan_Applications,
    SUM(loan_amount) AS Total_Funded_Amount,
    SUM(total_payment) AS Total_Amount_Received
FROM bank_loan
GROUP BY term
ORDER BY term;

-- BANK LOAN REPORT | OVERVIEW - EMPLOYEE LENGTH

SELECT
	emp_length AS Employee_Length,
    COUNT(id) AS Total_Loan_Applications,
    SUM(loan_amount) AS Total_Funded_Amount,
    SUM(total_payment) AS Total_Amount_Received
FROM bank_loan
GROUP BY emp_length;

-- BANK LOAN REPORT | OVERVIEW - PURPOSE OF LOAN

SELECT
	purpose AS PURPOSE,
	COUNT(id) AS Total_Loan_Applications,
    SUM(loan_amount) AS Total_Funded_Amount,
    SUM(total_payment) AS Total_Amount_Received
FROM bank_loan
GROUP BY purpose
ORDER BY purpose;

-- BANK LOAN REPORT | OVERVIEW - HOME OWNERSHIP

SELECT home_ownership AS HOME_OWNERSHIP,
	COUNT(id) AS Total_Loan_Applications,
	SUM(loan_amount) AS Total_Funded_Amount,
	SUM(total_payment) AS Total_Amount_Received
FROM bank_loan
GROUP BY home_ownership
ORDER BY home_ownership;

-- See the results when we hit the Grade A in the filters for dashboards

SELECT home_ownership AS HOME_OWNERSHIP,
	COUNT(id) AS Total_Loan_Applications,
	SUM(loan_amount) AS Total_Funded_Amount,
	SUM(total_payment) AS Total_Amount_Received
FROM bank_loan
WHERE grade = 'A'
GROUP BY home_ownership
ORDER BY home_ownership;