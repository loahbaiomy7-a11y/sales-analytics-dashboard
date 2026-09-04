USE AdventureWorksAnalytics;
GO

CREATE VIEW vw_FactSales
AS
SELECT
    h.SalesOrderID,
    h.CustomerID,
    h.OrderDate,
    h.DueDate,
    h.ShipDate,
    h.Status,
    d.SalesOrderDetailID,
    d.ProductID,
    d.OrderQty,
    d.UnitPrice,
    d.UnitPriceDiscount,
    d.LineTotal,

    h.SubTotal,
    h.TaxAmt,
    h.Freight,
    h.TotalDue
FROM AdventureWorksLT2025.SalesLT.SalesOrderHeader h
INNER JOIN AdventureWorksLT2025.SalesLT.SalesOrderDetail d
    ON h.SalesOrderID = d.SalesOrderID;
GO


CREATE VIEW vw_DimProduct
AS
SELECT
    ProductID,
    Name,
    ProductNumber,
    Color,
    Size,
    Weight,
    StandardCost,
    ListPrice,
    ProductCategoryID,
    ProductModelID
FROM AdventureWorksLT2025.SalesLT.Product;
GO

CREATE VIEW vw_DimCategory
AS
SELECT
    ProductCategoryID,
    ParentProductCategoryID,
    Name AS CategoryName
FROM AdventureWorksLT2025.SalesLT.ProductCategory;
GO

CREATE VIEW vw_DimProductModel
AS
SELECT
    ProductModelID,
    Name AS ModelName
FROM AdventureWorksLT2025.SalesLT.ProductModel;
GO

CREATE TABLE DimDate
(
    DateKey INT PRIMARY KEY,
    FullDate DATE,
    Year INT,
    QuarterNumber INT,
    MonthNumber INT,
    MonthName VARCHAR(20),
    DayNumber INT
);
GO


DECLARE @StartDate DATE = '2008-06-01';
DECLARE @EndDate DATE = '2008-06-13';

WHILE @StartDate <= @EndDate
BEGIN

    INSERT INTO DimDate
    (
        DateKey,
        FullDate,
        Year,
        QuarterNumber,
        MonthNumber,
        MonthName,
        DayNumber
    )
    VALUES
    (
        YEAR(@StartDate) * 10000
        + MONTH(@StartDate) * 100
        + DAY(@StartDate),

        @StartDate,

        YEAR(@StartDate),

        DATEPART(QUARTER, @StartDate),

        MONTH(@StartDate),

        DATENAME(MONTH, @StartDate),

        DAY(@StartDate)
    );

    SET @StartDate = DATEADD(DAY, 1, @StartDate);

END;
GO


SELECT
    SUM(LineTotal) AS TotalRevenue
FROM vw_FactSales;



   SELECT top 10
    p.Name,
    SUM(f.[LineTotal]) AS TotalSales
FROM vw_FactSales f
INNER JOIN vw_DimProduct p
    ON f.ProductID = p.ProductID
GROUP BY p.Name
ORDER BY 2 DESC;



    
    SELECT TOP 5
   SUM(f.[LineTotal]*100)AS TotalSales,
c.CategoryName 
FROM vw_DimCategory c           
INNER JOIN vw_DimProduct p
ON  p.ProductCategoryID=c.ProductCategoryID
INNER JOIN vw_FactSales f
ON f.ProductID=p.ProductID
GROUP BY c.CategoryName
ORDER BY TotalSales DESC;


SELECT 
COUNT(DISTINCT CustomerID )AS Totalcustomers
FROM vw_FactSales;


SELECT 
COUNT(DISTINCT ProductID ) AS TotalProducts
FROM vw_DimProduct;

SELECT 
COUNT(DISTINCT SalesOrderID) AS TotalOrders
FROM vw_FactSales;

SELECT 
SUM(LineTotal) AS TotalSales
FROM vw_FactSales;

    SELECT TOP 10
    c.FullName,
  SUM(f.[LineTotal]) AS TotalSales
  FROM vw_FactSales f
  INNER JOIN vw_DimCustomer c
  ON f.CustomerID = c.CustomerID
  GROUP BY  c.FullName
  ORDER BY 2 DESC;


SELECT TOP 5
    c.CategoryName,
    CONCAT(
        CAST(
            SUM(f.LineTotal) * 100.0 /
            SUM(SUM(f.LineTotal)) OVER ()
            AS DECIMAL(5,2)
        ),
        '%'
    ) AS SalesPercentage
FROM vw_DimCategory c
INNER JOIN vw_DimProduct p
    ON p.ProductCategoryID = c.ProductCategoryID
INNER JOIN vw_FactSales f
    ON f.ProductID = p.ProductID
GROUP BY c.CategoryName
ORDER BY
    SUM(f.LineTotal) * 100.0 /
    SUM(SUM(f.LineTotal)) OVER () DESC;
  