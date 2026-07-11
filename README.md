# Healthcare Claims Cost Analysis
An end-to-end healthcare analysis project using **MySQL** and **Power BI** to identify healthcare spending patterns, high-cost claim types, cost-driving procedures, diagnoses, and members.

---

## Project Overview
Healthcare insurers process thousands of claims everyday. Understanding where healthcare spending is concentrated helps improve financial planning, identify high-cost services, and support better decision-making.
In this project, I analyzed a synthetic healthcare claims dataset to uncover the main drivers of healthcare expenditure and presented the findings in an interactive Power BI dashboard.

---

## Business Questions
This project answers the following questions:
- Which claim types are the most expensive?
- Which CPT procedures drive the highest spending?
- Which diagnoses contribute most to healthcare costs?
- Which members account for the largest share of total costs?
- How do billed amounts compare with paid amounts?
- Which healthcare services should management focus on to control costs?

---

## Tools & Technologies
- MySQL
- Power BI

  ---

  ## Dashboard Features

  ### Executive Summary
  - Total Paid Amount
  - Total Billed Amount
  - Number of Claims
  - Number of Members
  - Claim Type Cost Breakdown
  - Key Business Insights
 
### Procedure & Diagnosis Analysis
- Top 10 CPT codes
- Top 10 ICD codes
- Cost Drivers

### Member Analysis
- Top 10 Highest-Cost Members
- Claim Type Breakdown by Member
- Interactive Filter

  ## Key Insights
  - Inpatient claims account for the highest healthcare expenditure.
  - Emergency claims are the second-largest contributor to total paid costs.
  - Pharmacy claims contribute the least expenditure.
  - The top 10 highest-cost members are primarily driven by inpatient claims.
  - The billed versus paid comparison highlights reimbursement patterns across healthcare services.

 ## SQL Techniques Used
 - Data Cleaning
 - Aggregate Functions
 - GROUP BY
 - ORDER BY
 - Common Table Expressions (CTEs)
 - Window Functions (ROW_NUMBER)
 - CASE Statements
 - Ranking
 - Filtering

## Power BI Features
- KPI Cards
- Clustered Bar Charts
- Interactive Filters
- Data Labels
- Business Insight Cards
- Multi-page Dashboard

  ## Repository Contents
  **[health_care_claims_analysis.sql](https://github.com/user-attachments/files/29931107/health_care_claims_analysis.sql)** - SQL scripts used for data cleaning and analysis.
  **Healthcare Claims Dashboard.pbix** - Interactive Power BI dashboard
  **Images/** - Screenshots of the dashboard





  ## Dashboard Preview

  ### Executive Summary
  !<img width="772" height="496" alt="Executive_Summary" src="https://github.com/user-attachments/assets/a5a3f8ee-6ac1-4b5f-a9b8-b5b99b772e1c" />

  ### CPT & ICD Analysis
  !<img width="757" height="497" alt="BilledVsPaidAmount_icd_cpt_analysis" src="https://github.com/user-attachments/assets/1dbefea4-c1cf-43e9-bac2-ded12bf9c943" />

  ### Member Analysis
  !<img width="755" height="499" alt="Member_Level_Analysis" src="https://github.com/user-attachments/assets/f7c94537-6f09-44ac-81b4-e3421d671ba8" />




