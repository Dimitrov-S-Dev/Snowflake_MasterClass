---- SIZE_LIMIT ----

// Prepare database & table
CREATE OR REPLACE DATABASE COPY_DB;

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


// List files in stage
LIST @aws_stage_copy;


//Load data using copy command
COPY INTO COPY_DB.PUBLIC.ORDERS
    FROM @aws_stage_copy
    FILE_FORMAT = (type = csv field_delimiter=',' skip_header=1)
    PATTERN = '.*Order.*'
    SIZE_LIMIT=20000;
