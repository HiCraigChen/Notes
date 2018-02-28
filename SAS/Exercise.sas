/*Exercise1*/

/*Input Data*/
Data a1;
infile 'H:\SAS\Billionaires.txt' firstobs=14 missover;
input wealth age region$;
run;

/*Figure out data type*/
proc contents data=a1;
run;

/*Sort Data*/
Proc sort data=a1 output=o1;
by region descending wealth;
run;

/*Print out data*/
proc print data=a1(obs=20);
run; 

/*Print dollar sign*/
proc print data=a1(obs=20);
format wealth dollar7.1;
run;

/*Sort data with different regions*/
proc sort data=a1;
by region; /*We have to sort data first, or will get error.*/
proc print;
var wealth age;
by region;
run;

/*Frequency Table*/
Proc FREQ;
TABLE region;
run;

/*Frequency Table with 2 variables*/
Proc FREQ data=a1;
table wealth*region /chisq;
run;

/*Keep and Drop*/
data wealth;
set a1;
keep wealth;
/*Drop age region;*/
run;

/*Correlation between variables*/
Proc corr;
var wealth age;
run;

/*Variable Mean*/
proc means data=a1;
var age;
run;

/*Variables with different regions*/
proc means data=a1;
/*by region;*/
class region;
var wealth;
run;

/*Output*/
proc means;
var wealth age;
class region;
output out=stats MEAN=mwealth mage STD=sdwealth;
run;

proc means data=a1 sum;
var wealth age;
class region;
output out=stats2 MEAN=mwealth mage STD=sdwealth sdage MIN=minwealth minage Max=maxwealth maxage;
run;


/*Seperate data into two parts*/
data a2;
set a1;
if region='E' or region='U';

/*Ttest*/
Proc ttest data=a2;
var wealth;
class region;
run;

/*Seperate data into different regions*/
data A E M O U;
drop region;
set a1;
if region eq "A" then output A;
if region eq "E" then output E;
if region eq "M" then output M;
if region eq "O" then output O;
if region eq "U" then output U;
run;

/*Seperate data into different regions*/
Data A E M O U;
drop region;
set a1;
select(region);
when("A") output A;
when("E") output E;
when("M") output M;
when("O") output O;
when("U") output U;
otherwise;end;
run;

/*Cumulative*/
data a3;
set a1;
retain CumWealth 0;
CumWealth = CumWealth + wealth;
run;

data a3;
set a1;
CumWealth + wealth;
run;

data a4;
set a1;
keep region CumWealth;
by region;
if first.region then CumWealth=0;
Cumwealth+wealth;
if last.region then output;
run;


/*Plot*/
proc gchart data=a1;
hbar wealth;
vbar wealth;
pie wealth;
run;

/*Merge data*/
data merged;
set a1 a2;
run;

/*Permanent Dataset*/
libname lib 'H:\SAS';
data lib.billion;
set a1;
run;

/*Output file*/
data test;
set a1;
file 'h:\billion.txt';
put wealth age region$;
run;

