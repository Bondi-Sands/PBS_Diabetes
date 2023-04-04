SELECT *
FROM DiabetesPBS..[jul-2018-to-dec-2022]
ORDER BY 2

SELECT *
FROM DiabetesPBS..[pbs-item-drug-map]
ORDER BY 1

--CREATE TABLE DIABETES_JUL18_DEC22

CREATE TABLE DIABETES_JUL18_DEC22
(
SUPPLY_DATE DATE,
DRUG_NAME VARCHAR(MAX),
SCRIPT_TYPE VARCHAR(MAX),
PRESCRIPTIONS INTEGER,
PATIENT_NET_CONTRIB DECIMAL,
GOVT_CONTRIB DECIMAL,
TOTAL_COST DECIMAL,
RETAIL_MARKUP DECIMAL,
FORM_STRENGTH VARCHAR(MAX),
);

INSERT INTO DIABETES_JUL18_DEC22
(SUPPLY_DATE, DRUG_NAME, PRESCRIPTIONS, SCRIPT_TYPE, PATIENT_NET_CONTRIB, GOVT_CONTRIB, TOTAL_COST, RETAIL_MARKUP, FORM_STRENGTH)
SELECT SUPPLY_DATE, DRUG_NAME, PRESCRIPTIONS, SCRIPT_TYPE, PATIENT_NET_CONTRIB, GOVT_CONTRIB, TOTAL_COST, RETAIL_MARKUP, FORM_STRENGTH
FROM DiabetesPBS..[pbs-item-drug-map] AS PBS
INNER JOIN DiabetesPBS..[jul-2018-to-dec-2022] AS JUL18_DEC22
ON PBS.ITEM_CODE = JUL18_DEC22.ITEM_CODE
WHERE DRUG_NAME LIKE '%METFORMIN%' OR DRUG_NAME LIKE '%INSULIN%' OR DRUG_NAME LIKE '%SEMAGLUTIDE%'
ORDER BY 1;

SELECT *
FROM DIABETES_JUL18_DEC22

--CHECKING FOR NULL VALUES

SELECT * 
FROM DIABETES_JUL18_DEC22
WHERE TOTAL_COST IS NULL

--DATA CLEANING

ALTER TABLE DIABETES_JUL18_DEC22
ADD FORM VARCHAR(50)

UPDATE DIABETES_JUL18_DEC22
SET FORM =
	CASE
		WHEN FORM_STRENGTH LIKE '%Injection%' THEN 'Injection'
		WHEN FORM_STRENGTH LIKE '%Tablet%' THEN 'Tablet'
	END
WHERE FORM_STRENGTH LIKE '%Injection%' OR FORM_STRENGTH LIKE '%Tablet%'


ALTER TABLE DIABETES_JUL18_DEC22
ADD [DRUG_CLASS] VARCHAR(max)

UPDATE DIABETES_JUL18_DEC22
SET [DRUG_CLASS] =
	CASE
		WHEN DRUG_NAME LIKE 'INSULIN ASPART' THEN 'FAST-ACTING INSULIN ANALOG'
		WHEN DRUG_NAME LIKE 'INSULIN GLULISINE' THEN 'FAST-ACTING INSULIN ANALOG'
		WHEN DRUG_NAME LIKE 'INSULIN LISPRO' THEN 'FAST-ACTING INSULIN ANALOG'
		WHEN DRUG_NAME LIKE 'INSULIN GLARINE' THEN 'LONG-ACTING INSULIN ANALOG'
		WHEN DRUG_NAME LIKE 'INSULIN DETEMIR' THEN 'LONG-ACTING INSULIN ANALOG'
		WHEN DRUG_NAME LIKE 'INSULIN DEGLUDEC' THEN 'LONG-ACTING INSULIN ANALOG'
		WHEN DRUG_NAME LIKE 'INSULIN ISOPHANE BOVINE' THEN 'INTERMEDIATE-ACTING BOVINE INSULIN'
		WHEN DRUG_NAME LIKE 'INSULIN ISOPHANE HUMAN' THEN 'INTERMEDIATE-ACTING INSULIN (NPH)'
		WHEN DRUG_NAME LIKE 'INSULIN NEUTRAL HUMAN' THEN 'FAST-ACTING HUMAN INSULIN'
		WHEN DRUG_NAME LIKE 'INSULIN NEUTRAL BOVINE' THEN 'FAST-ACTING BOVINE INSULIN'
		WHEN DRUG_NAME LIKE '%INSULIN ACID%' THEN 'INTERMEDIATE-ACTING BOVINE INSULIN'
		WHEN DRUG_NAME LIKE 'INSULIN ZINC SUSPENSION (LENTE)' THEN 'INTERMEDIATE-ACTING INSULIN'
		WHEN DRUG_NAME LIKE 'INSULIN ZINC SUSPENSION (CRYSTALLINE) (ULTRALENTE)' THEN 'INTERMEDIATE-ACTING INSULIN'
		WHEN DRUG_NAME LIKE 'INSULIN GLARGINE' THEN 'LONG-ACTING INSULIN'
		WHEN DRUG_NAME LIKE 'INSULIN PROTAMINE ZINC' THEN 'INTERMEDIATE-ACTING INSULIN'
		WHEN DRUG_NAME LIKE 'INSULIN NEUTRAL HUMAN + INSULIN ISOPHANE HUMAN' THEN 'FAST & INTERMEDIATE ACTING INSULIN'
		WHEN DRUG_NAME LIKE 'INSULIN LISPRO + INSULIN LISPRO PROTAMINE' THEN 'FAST & INTERMEDIATE ACTING PREMIXED INSULIN ANALOG'
		WHEN DRUG_NAME LIKE 'INSULIN ASPART + INSULIN ASPART PROTAMINE' THEN 'FAST & INTERMEDIATE ACTING INSULIN ANALOG'
		WHEN DRUG_NAME LIKE 'INSULIN DEGLUDEC + INSULIN ASPART' THEN 'FAST & LONG ACTING INSULIN ANALOG'
		WHEN DRUG_NAME LIKE 'METFORMIN' THEN 'BIGUANIDES'
		WHEN DRUG_NAME LIKE 'SEMAGLUTIDE' THEN ' GLUCAGON-LIKE PEPTIDE (GLP-1) RECEPTOR AGONISTS'
		WHEN DRUG_NAME LIKE '%ALOGLIPTIN + METFORMIN%' 
						OR DRUG_NAME LIKE '%SAXAGLIPTIN + METFORMIN%'
						OR DRUG_NAME LIKE '%SITAGLIPTIN + METFORMIN%'
						OR DRUG_NAME LIKE '%VILDAGLIPTIN + METFORMIN%'		
							THEN 'DIPEPTIDYL PEPTIDASE-4 (DPP-4) INHIBITOR + BIGUANIDE'
		WHEN DRUG_NAME LIKE '%DAPAGLIFLOZIN + METFORMIN%'
					OR DRUG_NAME LIKE'%EMPAGLIFLOZIN + METFORMIN%'
					OR DRUG_NAME LIKE '%ERTUGLIFLOZIN + METFORMIN%'
							THEN 'SODIUM-GLUCOSE COTRANSPORTER-2 (SGLT2) INHIBITOR + BIGUANIDE'
		WHEN DRUG_NAME LIKE '%LINAGLIPTIN + METFORMIN%'	
					OR DRUG_NAME LIKE '%ROSIGLITAZONE + METFORMIN%'
						THEN 'THIAZOLIDINEDIONE (TZD) + BIGUANIDE'
		WHEN DRUG_NAME LIKE '%METFORMIN + GLIBENCLAMIDE%' THEN 'BIGUANIDE + SULFONYLUREA'
				
	END

WHERE DRUG_NAME LIKE '%INSULIN%' OR DRUG_NAME LIKE '%METFORMIN%' OR DRUG_NAME LIKE '%SEMAGLUTIDE%' ;

ALTER TABLE DIABETES_JUL18_DEC22 
ADD [DOSAGE] VARCHAR(max);

UPDATE DIABETES_JUL18_DEC22 
SET [DOSAGE] = SUBSTRING(FORM_STRENGTH, PATINDEX('%[0-9]%', FORM_STRENGTH), LEN(FORM_STRENGTH));

	--REVIEW

SELECT *
FROM DIABETES_JUL18_DEC22





