# Vehicle Sale Data Analysis Project
This project helps stakeholders identify market trends and pricing opportunities and explores a large dataset of used vehicle listings to uncover pattern in vehicle pricing, condition, seller behavior, and market trends. It demonstrates end-to-end data analysis skills using **Microsoft SQL Server** for data cleaning and exploration, and **Power BI** for dashboard visualizations.
---
## Dataset Overview
-	**Size:** 558838 rows
-	**Columns (Selected):**
-	`Year`
-	`Make`, `Model`, `Trim`
-	`Body`, `Transmission`
-	`Vin`, `State`
-	`Color`, `Interior`
-	`Seller`
-	`MMR` (Expected Price)
-	`SellingPrice`
-	`SaleDate`
---
## Project Goals
-	Clean and prepare the dataset for analysis.
-	Explore pricing trends across time, brands, and vehicle conditions.
-	Evaluate how mileage and condition affect resale price.
-	Compare market value (`MMR`) to actual selling price.
-	Build an interactive Power BI for key insights.
---
## Tools and Technology
-**SQL Server Management Studio(SSMS)**: Data cleaning, transformation, and analysis.
-**Power BI**: Visualization and dashboard reporting.
--**Power Query**: Data shaping for Power BI visuals.
---



## Key Steps
### 1. Data Cleaning (SQL Server)
-	Converted `Odometer`, `Sellingprice`, `MMR`, `Year` from `VARCHAR` to `INT`
-	Converted string-based data to SQL `Date` type.
-	Replaced nulls/blanks in key columns like `Make`, `Model`, `Color`, `Seller` with `’Unkown’`
-	Trimmed and Standardized text data
-	Remove duplicates and filtered invalid rows
### 2. Exploratory Data Analysis (SQL)
-	Used `CTEs`, `GROUP BY`, and `CASE` to aggregate and compare insights 
-	Sample queries:
- Top 5 car brands by sale volume
- Average price by make/model
- How mileage affects price
- Condition vs pricing behavior
- State-wise pricing comparison
- MMR vs actual selling price analysis
###3. Visualization (Power BI)
-	**Bar Charts**: Top 5 brands, average price by state
-	**Line Charts**: Yearly pricing trends
-	**Cards**: KPIs like total cars sold, average price, highest sale
-	**Gauges**: Average selling price vs goal
-	**Filters and Slicers**: Interactive brand, state, and condition selection
---
## Key Insights
-	**Ford**, **Chevrolet**, **Nissan**, **Toyota**, and **Dodge** were the top-selling brands
-	**High mileage** leads to noticeable price drop, especially beyond 100,000 miles
-	Vehicles in **excellent conditions** sold up to 18% higher than average
-	Some sellers priced consistently below MMR, possibly signaling urgency
-	States like **Ontario**, and **Tennessee** had the highest average prices
## Skills Highlighted
-	SQL (Data cleaning, grouping, type conversion)
-	Power BI dash boarding and visualization
-	Data storytelling and business insight generation
-	Real-world dataset handling and problem-solving

## Conclusion
This project gave me hands-on experience in;
-	Managing and querying large dataset with SQL.
-	Creating impactful visual dashboards in Power BI.
-	Uncovering real-world business insights in the automotive industry.

## Future Enhancement
-	Add machine learning predictions (e.g., price estimator based on features)
-	Web scraping for live car listings
-	Drill-down dashboard by VIN or Region
## Contact
For collaboration, questions, or feedbacks:
alexanderotto17@gmail.com
LinkedIn Profile (https://www.linkedin.com/in/alexander-otto-bende
>”Data is the new oil and this project drills into the automotive market to refine insights that drive smarter decisions.”

