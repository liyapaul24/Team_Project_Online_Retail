/* Imported two CSV files (2009-2010 and 2010-2011)into database, combined them using an SQL query. Use UNION ALL to include all rows (even duplicates) for data completeness.
 */

CREATE TABLE combined_table AS
SELECT * FROM online_retail_2009_2010
UNION ALL
SELECT * FROM online_retail_2010_2011;

/* To find duplicates where all columns are the same. By grouping by all columns and counting the occurrences, we can effectively identify duplicates where all column values are the same.
 */

SELECT *, COUNT(*) AS count
FROM combined_table
GROUP BY Invoice, StockCode, Description, Quantity, InvoiceDate, Price, &quot;Customer ID&quot;, Country
HAVING COUNT(*) &gt; 1;

/* This creates a new table with unique rows from the original table. */ 
/* Creating a new table with distinct records instead of deleting duplicates directly, provides a safer, more flexible, and reversible approach.  */

CREATE TABLE distinct_records AS
SELECT DISTINCT *
FROM combined_table;

/* To identify missing values in the Customer ID column (or any column) in the dataset */

SELECT 
    COUNT(*) AS TotalRecords,
    SUM(CASE WHEN Invoice IS NULL THEN 1 ELSE 0 END) AS MissingInvoice,
    SUM(CASE WHEN StockCode IS NULL THEN 1 ELSE 0 END) AS MissingStockCode,
    SUM(CASE WHEN Description IS NULL THEN 1 ELSE 0 END) AS MissingDescription,
    SUM(CASE WHEN Quantity IS NULL THEN 1 ELSE 0 END) AS MissingQuantity,
    SUM(CASE WHEN InvoiceDate IS NULL THEN 1 ELSE 0 END) AS MissingInvoiceDate,
    SUM(CASE WHEN Price IS NULL THEN 1 ELSE 0 END) AS MissingPrice,
    SUM(CASE WHEN &quot;Customer ID&quot; IS NULL THEN 1 ELSE 0 END) AS MissingCustomerID,
    SUM(CASE WHEN Country IS NULL THEN 1 ELSE 0 END) AS MissingCountry
FROM distinct_records;

/* Returned total records=1033036, missing description=4275, missing customer ID=235151 */

/* For Description (replace null with unknown): */

UPDATE distinct_records
SET Description = 'unknown'
WHERE Description IS NULL;

/* For Customer ID (replace null with unknown): */

UPDATE distinct_records
SET &quot;Customer ID&quot; = 'unknown'
WHERE &quot;Customer ID&quot; IS NULL;

