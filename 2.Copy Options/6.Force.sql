---- FORCE ----

CREATE OR REPLACE TABLE  COPY_DB.PUBLIC.ORDERS (
    ORDER_ID VARCHAR(30),
    AMOUNT VARCHAR(30),
    PROFIT INT,
    QUANTITY INT,
    CATEGORY VARCHAR(30),
    SUBCATEGORY VARCHAR(30));

// Prepare stage object
CREATE OR REPLACE STAGE aws_stage_copy
    url='s3://snowflakebucket-copyoption/size/';

LIST @aws_stage_copy;


 //Load data using copy command
COPY INTO COPY_DB.PUBLIC.ORDERS
    FROM @aws_stage_copy
    FILE_FORMAT = (type = csv field_delimiter=',' skip_header=1)
    PATTERN = '.*Order.*';

// Not possible to load file that have been loaded and data has not been modified
COPY INTO COPY_DB.PUBLIC.ORDERS
    FROM @aws_stage_copy
    FILE_FORMAT = (type = csv field_delimiter=',' skip_header=1)
    PATTERN = '.*Order.*';

SELECT * FROM ORDERS;

// Using the FORCE option

COPY INTO COPY_DB.PUBLIC.ORDERS
    FROM @aws_stage_copy
    FILE_FORMAT = (type = csv field_delimiter=',' skip_header=1)
    PATTERN = '.*Order.*'
    FORCE = TRUE;-- DUPLICATES !!!
