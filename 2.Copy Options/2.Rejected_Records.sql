-- Rejected Records

---- 1) Saving rejected files after VALIDATION_MODE ----

CREATE OR REPLACE TABLE  COPY_DB.PUBLIC.ORDERS (
    ORDER_ID VARCHAR(30),
    AMOUNT VARCHAR(30),
    PROFIT INT,
    QUANTITY INT,
    CATEGORY VARCHAR(30),
    SUBCATEGORY VARCHAR(30));


COPY INTO COPY_DB.PUBLIC.ORDERS
    FROM @aws_stage_copy
    FILE_FORMAT = (type = csv field_delimiter=',' skip_header=1)
    PATTERN = '.*Order.*'
    VALIDATION_MODE = RETURN_ERRORS;


// Storing rejected /failed results in a table
CREATE OR REPLACE TABLE rejected AS
SELECT rejected_record FROM TABLE(result_scan(last_query_id()));



-- Adding additional records --
INSERT INTO rejected
SELECT rejected_record FROM TABLE(result_scan(last_query_id()));

SELECT * FROM rejected;

---- 2) Saving rejected files without VALIDATION_MODE ----

COPY INTO COPY_DB.PUBLIC.ORDERS
    FROM @aws_stage_copy
    FILE_FORMAT = (type = csv field_delimiter=',' skip_header=1)
    PATTERN ='.*Order.*'
    ON_ERROR=CONTINUE;


SELECT * FROM TABLE(validate(orders, job_id => '_last'));


---- 3) Working with rejected records ----

SELECT rejected_record FROM rejected;

CREATE OR REPLACE TABLE rejected_values AS
SELECT
SPLIT_PART(rejected_record,',',1) as ORDER_ID,
SPLIT_PART(rejected_record,',',2) as AMOUNT,
SPLIT_PART(rejected_record,',',3) as PROFIT,
SPLIT_PART(rejected_record,',',4) as QUATNTITY,
SPLIT_PART(rejected_record,',',5) as CATEGORY,
SPLIT_PART(rejected_record,',',6) as SUBCATEGORY
FROM rejected;


SELECT * FROM rejected_values;
