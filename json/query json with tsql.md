# Querying JSON with T-SQL

## JSON Fields in SQL Server

> Use nvarchar(max) data type 
- To store JSON documents
- Up to 2 GB in size
> If your JSON < 8 KB
- Recommendation is NVARCHAR(4000) 
> Can enforce proper formatting
- CHECK (ISJSON(<col>)=1)
> Many functions available to work with JSON

## Exploring the Table That Contains JSON Fields

``` sql
    /* Retrieves a scalar value */
    JSON_VALUE(jsonData, '$.employee.birth')
    /* Retrieves a JSON object */
    JSON_QUERY(jsonData, '$.employee.address')
``` 

> Querying JSON documents

- JSON_VALUE ( expression , path )
- - Retrieve a scalar value, like numbers or text
- JSON_QUERY ( expression , path )
- - Returns an object, an array or another JSON document

Format Query Results as JSON with FOR JSON

> For JSON PATH : Define the structure of your JSON string
> For JSON AUTO : Structure of your JSON string created automatically

Converting Structured Data into JSON with FOR JSON PATH

## SQL JSON Functions

> JSON_VALUE() 
> JSON_QUERY()
> JSON_MODIFY() 
> ISJSON()

``` sql
SELECT 
    JSON_VALUE(Post_json, '$.Post.Title') AS jsonTitle,
FROM Posts
WHERE
    JSON_VALUE(Post_json, '$.Post.Title’) LIKE ‘%machine learning%'
```

**JSON_QUERY ( expression , path )**

- Extracts an object or an array from a JSON string
  - An array of objects or another JSON document
- Returns JSON fragment of type nvarchar(MAX)

``` sql
SELECT 
    JSON_VALUE(Post_json, '$.Post.Id') AS jsonId,
    JSON_QUERY(Post_json, '$.Post.Author') AS jsonAuthor
FROM Posts
```

**JSON_MODIFY ( expression , path , newValue )**

Updates the value of an attribute within a JSON document
Returns the updated value of the expression as properly formatted JSON text

``` sql
    UPDATE Posts
    SET jsonData = JSON_MODIFY(jsonData,'$.OwnerUserId', '63')
    WHERE JSON_VALUE(jsonData, '$.Id') = '9';
```

**ISJSON ( expression )**

Tests whether a string contains valid JSON

Returns 1 if the string contains valid JSON
- Otherwise, returns 0

``` sql
SELECT JSON_VALUE(jsonData, '$.Title'), jsonData
FROM Posts
WHERE 
    ISJSON(jsonData) > 0 AND 
    JSON_VALUE(jsonData, '$.Title') LIKE '%c#%';
```

## Importing and Parsing JSON

- Importing JSON Files from Disk using OPENROWSET
- Importing JSON Objects Directly from a String using OPENJSON
  
> OPENROWSET

- Function used for reading data from many sources
- - BULK IMPORT
- - Read JSON files from disk or network
- Returns a table with a single column
- - Bulk
- - Load entire file content as a text value
  
> OPENJSON
- Function used to parse JSON text
- - Returns objects and properties
- - As rows and columns
- Rowset view over a JSON document
- Explicitly specify columns 
- - Paths used to populate each column
- Use OPENJSON in the FROM clause
- - Returns a set of rows
- - Like a table, view, or table-valued function
  
> Lax & Strict Mode
``` sql
    /* Will raise an error because Post.Badges does not exist */
    JSON_VALUE(Post_json, 'strict$.Post.Badges')

    /* Will not raise an error even though Comments does not exist */
    JSON_VALUE(Post_json, 'lax$.Post.Comments')
```

- Used in PATH to indicate how to handle missing properties
- Strict requires the property to be available in the JSON text or an error is raised
- Lax will not raise an error if the property is not available 
  - Default mode is lax
