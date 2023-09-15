---- VALIDATION_MODE ----
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

LIST @aws_stage_copy;


 //Load data using copy command
COPY INTO COPY_DB.PUBLIC.ORDERS
    FROM @aws_stage_copy
    FILE_FORMAT = (type = csv field_delimiter=',' skip_header=1)
    PATTERN ='.*Order.*'
    VALIDATION_MODE = RETURN_ERRORS;

SELECT * FROM ORDERS;

COPY INTO COPY_DB.PUBLIC.ORDERS
    FROM @aws_stage_copy
    FILE_FORMAT = (type = csv field_delimiter=',' skip_header=1)
    PATTERN = '.*Order.*'
   VALIDATION_MODE = RETURN_5_ROWS ;



--- Use files with errors ---

CREATE OR REPLACE STAGE aws_stage_copy
    url ='s3://snowflakebucket-copyoption/returnfailed/';

LIST @aws_stage_copy;

-- show all errors --
COPY INTO public.orders
    FROM @aws_stage_copy
    FILE_FORMAT = (type=csv field_delimiter=',' skip_header=1)
    PATTERN = '.*Order.*'
    VALIDATION_MODE = return_errors;

-- validate first n rows --
COPY INTO public.orders
    FROM @aws_stage_copy
    FILE_FORMAT = (type=csv field_delimiter=',' skip_header=1)
    PATTERN = '.*error.*'
    VALIDATION_MODE = return_1_rows;
