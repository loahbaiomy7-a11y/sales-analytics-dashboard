# Sales Analytics Dashboard

A small end-to-end data analytics project: cleaning raw AdventureWorks data in SQL Server, modeling it into a star schema (fact & dimension tables), and building an interactive Power BI dashboard.

## 🛠️ Tools Used
- **SQL Server** – Data cleaning, view creation, fact/dimension modeling
- **Power BI** – Data modeling (relationships) and dashboard visualization

## 📊 Project Steps
1. Imported raw data from Microsoft's AdventureWorksLT sample database
2. Cleaned and transformed data using SQL views
3. Built a star schema:
   - **Fact table:** `vw_FactSales` (sales order details)
   - **Dimension tables:** `vw_DimProduct`, `vw_DimCategory`, `vw_DimProductModel`, `DimDate`
4. Loaded the model into Power BI and created relationships
5. Built an interactive dashboard with KPIs, charts, and a detail table

## 📈 Dashboard Highlights
- Total Customers, Total Products, Total Orders, Total Sales (KPI cards)
- Sales by Category (bar chart & pie chart)
- Top Products by Sales
- Total Sales by Customer
- Detailed sales table with filters

## 📁 Project Structure

- **sql/** → SQL scripts (views, fact/dim tables)
- **powerbi/** → Power BI dashboard file (.pbix)
- **screenshots/** → Dashboard screenshots

## 📷 Screenshots
![Dashboard](screenshots/Screenshot%202026-09-04%20201141.png)
