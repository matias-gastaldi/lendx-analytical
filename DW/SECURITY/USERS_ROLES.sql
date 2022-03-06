*********************************************************************************************
Set up TASKADMIN role
*********************************************************************************************
use role securityadmin;
create role taskadmin;
-- Set the active role to ACCOUNTADMIN before granting the EXECUTE TASK privilege to TASKADMIN
use role accountadmin;
grant execute task on account to role taskadmin;

-- Set the active role to SECURITYADMIN to show that this role can grant a role to another role 
use role securityadmin;
grant role taskadmin to role sysadmin;


*********************************************************************************************
GRANT SELECT TO ALL TABLES FOR THE STG AND RAW SCHEMAS TO SYSADMIN
IMPORANT! do not run this script in a Production env. 
*********************************************************************************************
use role securityadmin;
grant usage 
  on database "LENDX_SANDBOX"
  to role SYSADMIN;

grant usage on schema "LENDX_SANDBOX"."LENDX_STG"
  to role SYSADMIN;
  
grant usage on schema "LENDX_SANDBOX"."MAMBU_LENDX_SANDBOX_RAW"
  to role SYSADMIN;

grant select
  on all tables in schema "LENDX_SANDBOX"."LENDX_STG"
  to role SYSADMIN;
  
grant select
  on all tables in schema "LENDX_SANDBOX"."MAMBU_LENDX_SANDBOX_RAW"
  to role SYSADMIN;