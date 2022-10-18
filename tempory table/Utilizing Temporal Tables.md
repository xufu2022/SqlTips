# Utilizing Temporal Tables

> Temporal Table
-   Database feature
    - Introduced in ANSI SQL 2011
-   Provides information about data in a table
    - At any point in time
    - Instead of what’s available now
-   Like a window into your data’s past
-   Critical feature to audit SQL Server data

> Benefits of Using Temporal Tables

-   Auditing data changes and performing data forensics
-   Reconstructing the state of the data at any point in time
-   Calculating trends over time
-   Maintaining a slowly changing dimension for decision support applications
-   Recovering from accidental data loss

System Versioned Tables


| **Temporal Table** | **History Table**|
|:-------------------|------------------|
| Keeps the current data | Keeps previous values of the data |
| Just like your normal tables | With an entry per each change |
| With a few additional fields | Each change having a period of validity |
| Period columns | Used to retrieve value of a row for a period |
| Period of validity | Changes are stored automatically |


|**Selecting Data from Temporal Tables**||
|:-------------------|------------------|
|   AS            |  OF AS OF <datetime> |
|   FROM TO       |  FROM <startdatetime> TO <enddatetime> |
|   BETWEEN       |  BETWEEN <startdatetime> AND <enddatetime> |
|   CONTAINED IN  |  CONTAINED IN (<startdatetime> , <enddatetime> |
|   ALL           |  ALL |
