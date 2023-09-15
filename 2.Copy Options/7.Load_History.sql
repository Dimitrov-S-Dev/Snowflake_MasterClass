---- Query load history within a database ----

USE COPY_DB;

SELECT * FROM information_schema.load_history;

-- Query load history globally from SNOWFLAKE database --

SELECT * FROM snowflake.account_usage.load_history;


// Filter on specific table & schema
SELECT * FROM snowflake.account_usage.load_history
  WHERE schema_name='PUBLIC' AND
  TABLE_NAME = 'ORDERS';


// Filter on specific table & schema
SELECT * FROM snowflake.account_usage.load_history
  WHERE schema_name='PUBLIC' AND
  TABLE_NAME ='ORDERS' AND
  error_count > 0;


// Filter on specific table & schema
SELECT * FROM snowflake.account_usage.load_history
WHERE DATE(LAST_LOAD_TIME) <= DATEADD(days,-1,CURRENT_DATE);
