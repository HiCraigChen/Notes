/*Exercise#1*/


libname cc 'H:\SAS';
DATA a2;
INFILE 'H:\SAS\Billionaires.txt' firstobs=14 missover;
INPUT wealth age region$;
RUN;


PROC SORT DATA=a2 output=o1;
by region DESCENDING wealth;
RUN;


PROC FREQ; 
TABLE region; 
RUN;

PROC corr; 
var wealth age;
run;

PROC MEANS data=a2; 
var age;
run;


PROC MEANS data=a2; 
CLASS region;
var wealth;
run;

data a3;
set a2; 
if region='E' or region='U';
Proc ttest data=a3; 
var wealth; 
class region;
run;

PROC GCHART data=a2;
HBAR wealth;
vbar wealth;
pie wealth;
run;


data cc.; 
set a2; 
run;

file 'h:\billion.txt';
put wealth age region$;
run;