-- get the originator dimension_key based on an originator encoded_key

create or replace function LENDX_SANDBOX.LENDX_DW.GET_ORIGINATOR_KEY ( encoded_key VARCHAR)
  returns VARCHAR
  as 
  $$
    SELECT COALESCE(MAX(DIMENSION_KEY),'NotFoundValue')
        FROM LENDX_SANDBOX.LENDX_DW.DIM_ORIGINATOR
        WHERE DIMENSION_KEY = MD5(encoded_key)
  $$
  ;

-- get the borrower dimension_key based on an borrower encoded_key

create or replace function LENDX_SANDBOX.LENDX_DW.GET_BORROWER_KEY (encoded_key VARCHAR)
  returns VARCHAR
  as 
  $$
    SELECT COALESCE(MAX(DIMENSION_KEY),'NotFoundValue')
        FROM LENDX_SANDBOX.LENDX_DW.DIM_BORROWER
        WHERE DIMENSION_KEY = MD5(encoded_key)
  $$
  ;


-- get the loan product dimension_key based on a loan product encoded_key

create or replace function LENDX_SANDBOX.LENDX_DW.GET_LOAN_PRODUCT_KEY (encoded_key VARCHAR)
  returns VARCHAR
  as 
  $$
    SELECT COALESCE(MAX(DIMENSION_KEY),'NotFoundValue')
        FROM LENDX_SANDBOX.LENDX_DW.DIM_LOAN_PRODUCT
        WHERE DIMENSION_KEY = MD5(encoded_key)
  $$
  ;
  
  
  
-- get the loan account fact_key based on a encoded_key

create or replace function LENDX_SANDBOX.LENDX_DW.GET_LOAN_ACCOUNT_KEY (encoded_key VARCHAR)
  returns VARCHAR
  as 
  $$
    SELECT MAX(acc.FACT_KEY)
		FROM LENDX_SANDBOX.LENDX_DW.FACT_LOAN_ACCOUNTS acc
		WHERE  acc.ENCODED_KEY = encoded_key
  $$
  ;

