// CREATE dimension time table
create or replace TABLE "LENDX_SANDBOX"."LENDX_DW"."DIM_TIME" (
	DIMENSION_KEY NUMBER(38,0),
	CALENDARDATE DATE,
	CALENDARDATESTRING VARCHAR(50),
	CALENDARDATEALT VARCHAR(50),
	CALENDARYEAR NUMBER(38,0),
	CALENDARYEARDESC VARCHAR(50),
	CALENDARQUARTER NUMBER(38,0),
	CALENDARQUARTERDESC VARCHAR(50),
	CALENDARQUARTERYEAR NUMBER(38,0),
	MONTHNUMBEROFYEAR NUMBER(38,0),
	MONTHYEAR NUMBER(38,0),
	MONTHNAME VARCHAR(50),
	MONTHYEARDESC VARCHAR(50),
	MONTHYEARALT VARCHAR(50),
	DAYNUMBEROFMONTH NUMBER(38,0),
	NUMBEROFDAYSINMONTH NUMBER(38,0),
	DAYNUMBEROFYEAR NUMBER(38,0),
	WEEKNUMBERYEAR NUMBER(38,0),
	WEEKYEAR NUMBER(38,0),
	ISOWEEKNUMBEROFYEAR NUMBER(38,0),
	ISOWEEKYEAR NUMBER(38,0),
	WEEKDAY NUMBER(38,0),
	WEEKDAYNAME VARCHAR(50),
	ISWEEKDAYFLAG NUMBER(38,0),
	ISWEEKDAYDESC VARCHAR(50)
);

//Set the start date and number of years to produce
SET STARTDATE  = '2010-01-01'      ; //Start date
SET NUMBERDAYS= (Select TRUNC(100 * 365.25))   ; //Calculate number of days (40 yrs here, adjust to your need! )
// Show variables;   //Verify the set values in variables

//Set the following parameters to force ISO
//alter session set weekstart=1,weekofyearpolicy=1;

INSERT INTO "LENDX_SANDBOX"."LENDX_DW"."DIM_TIME_LOAN_APPROVED"
           ( DIMENSION_KEY
			,CALENDARDATE
            ,CALENDARDATESTRING
			,CALENDARDATEALT
			,CALENDARYEAR
			,CALENDARYEARDESC
			,CALENDARQUARTER
			,CALENDARQUARTERDESC
			,CALENDARQUARTERYEAR
			,MONTHNUMBEROFYEAR
			,MONTHYEAR
			,MONTHNAME
			,MONTHYEARDESC
			,MONTHYEARALT
			,DAYNUMBEROFMONTH
			,NUMBEROFDAYSINMONTH
			,DAYNUMBEROFYEAR
			,WEEKNUMBERYEAR
			,WEEKYEAR
			,ISOWEEKNUMBEROFYEAR
			,ISOWEEKYEAR
			,WEEKDAY
			,WEEKDAYNAME
			,ISWEEKDAYFLAG
			,ISWEEKDAYDESC

)

WITH DATERANGE AS (
  //Generates the date records per number of days required
  //  NUMBERte: used rownumber to enforce producing gap free result of the sequence and the dateadd just to make sure the startdate is included in the resultset
select DATEADD(DAY,(row_number() over (order by seq4()) -1),$STARTDATE) AS STARTDATE
    from table(generator(rowcount => $NUMBERDAYS))
)
SELECT
   TO_CHAR(STARTDATE,'YYYYMMDD')                                   AS DIMENSION_KEY
  ,TO_CHAR(STARTDATE,'YYYY-MM-DD')                                 AS CALENDARDATE
  ,TO_CHAR(STARTDATE,'DD-MON-YY')                                  AS CALENDARDATESTRING
  ,TO_CHAR(STARTDATE,'DD/MM/YYYY')                                 AS CALENDARDATEALT
  ,YEAR(STARTDATE)                                                 AS CALENDARYEAR
  ,'CY '||YEAR(STARTDATE)                                          AS CALENDARYEARDESC
  ,QUARTER(STARTDATE)                                              AS CALENDARQUARTER
  ,'QTR '||QUARTER(STARTDATE)                                      AS CALENDARQUARTERDESC
  ,YEAR(STARTDATE)||QUARTER(STARTDATE)                            AS CALENDARQUARTERYEAR
  ,MONTH(STARTDATE)                                                AS MONTHNUMBEROFYEAR
  ,YEAR(STARTDATE)||LPAD(MONTH(STARTDATE),2,'0')                  AS MONTHYEAR
  ,TO_CHAR(STARTDATE,'MMMM')                                       AS MONTHNAME
  ,TO_CHAR(STARTDATE,'MON-YY')                                     AS MONTHYEARDESC
  ,TO_CHAR(STARTDATE,'MON-YY')                                     AS MONTHYEARALT
  ,DAYOFMONTH(STARTDATE)                                           AS DAYNUMBEROFMONTH
  ,DAYOFMONTH(LAST_DAY(STARTDATE,'month'))                         AS NUMBEROFDAYSINMONTH
  ,DAYOFYEAR(STARTDATE)                                            AS DAYNUMBEROFYEAR
  ,WEEKOFYEAR(STARTDATE)                                           AS WEEKNUMBERYEAR
  ,YEAR(STARTDATE)||LPAD(WEEKOFYEAR(STARTDATE),2,'0')             AS WEEKYEAR
  ,WEEKISO(STARTDATE)                                              AS ISOWEEKNUMBEROFYEAR
  ,YEAR(STARTDATE)||LPAD(WEEKISO(STARTDATE),2,'0')                AS ISOWEEKYEAR
  ,DAYOFWEEK(STARTDATE)                                            AS WEEKDAY
  ,DECODE(DAYNAME(STARTDATE),
    'Mon','Monday','Tue','Tuesday',
    'Wed','Wednesday','Thu','Thursday',
    'Fri','Friday','Sat','Saturday',
          'Sun','Sunday')                                           AS WEEKDAYNAME
  ,IFF(DAYOFWEEK(STARTDATE) between 1 and 5,1,0)                   AS ISWEEKDAYFLAG
  ,IFF(DAYOFWEEK(STARTDATE) between 1 and 5,'Weekday','Weekend')   AS ISWEEKDAYDESC
    FROM DATERANGE DG;
