# Swiggy SQL Data Analysis Project

## 📌 Project Overview
This project is an end-to-end SQL data analysis case study based on Swiggy food delivery data.  
The objective is to transform raw transactional data into meaningful business insights using
data cleaning, dimensional modeling (star schema), KPI analysis, and deep-dive SQL queries.

The project closely follows real-world analytics workflows used by data analytics teams
in food-tech and e-commerce companies.

---

## 🎯 Business Objectives
- Clean and standardize raw Swiggy order data
- Remove duplicate and inconsistent records
- Design a scalable star schema data model
- Track key business KPIs such as revenue, orders, and ratings
- Analyze customer behavior, city performance, and food trends
- Enable BI-ready data for dashboards and reporting

---

## 🛠 Tools & Technologies Used
- SQL (MySQL)
- JupyterLab (Python for large-scale duplicate removal)
- Relational Data Modeling
- Star Schema Design
- Business Intelligence–ready structure

---

## 🧹 Data Cleaning & Preparation
Key data cleaning steps performed:
- Converted column names to snake_case for SQL best practices
- Checked and validated NULL values across all columns
- Identified and handled blank/empty string values
- Detected duplicate records using multi-column matching
- Removed duplicates using ROW_NUMBER() logic via JupyterLab

---

## 🧱 Data Modeling (Star Schema)
The project uses a star schema for analytical efficiency.

### Dimension Tables
- dim_date
- dim_location
- dim_restaurant
- dim_category
- dim_dish

### Fact Table
- fact_swiggy_orders

This structure improves query performance and supports BI tools like Power BI or Tableau.

---

## 📊 Key Performance Indicators (KPIs)
- Total Orders
- Total Revenue (INR Millions)
- Average Dish Price
- Average Customer Rating

---

## 📈 Business Analysis Performed

### Time-Based Analysis
- Monthly order trends
- Monthly revenue trends
- Quarterly order performance
- Orders by day of week

### Location-Based Analysis
- Top 10 cities by order volume
- Top 10 cities by total revenue
- State-wise revenue contribution

### Restaurant & Food Analysis
- Top restaurants by order volume
- Top restaurants by revenue
- Top food categories by demand
- Most ordered dishes
- Cuisine performance with average ratings

### Customer Spending Insights
- Price range segmentation (Under ₹100 to ₹500+)
- Order distribution by spending buckets

### Rating Analysis
- Distribution of customer ratings (1–5)
- Quality and satisfaction assessment

---

## 📌 Key Insights
- A small number of cities contribute a large share of total revenue
- Certain restaurants dominate both order volume and revenue
- Mid-range pricing categories generate the highest order volumes
- Highly rated cuisines also tend to show stronger repeat demand

---

## 🚀 How This Project Can Be Used
- Portfolio project for Data Analyst roles
- SQL interview discussion case study
- Foundation for Power BI or Tableau dashboards
- Academic or practical analytics submission

---

## 👤 Author
**Hritik Mishra**  
Aspiring Data Analyst  
Skills: SQL | Data Analysis | Data Modeling | Data Pipeline

---

## 📌 Note
This project is built for educational and portfolio purposes using publicly available or
sample data. It demonstrates SQL proficiency and analytical thinking aligned with
industry standards.

