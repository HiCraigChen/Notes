
/* question 1 */

LIBNAME q2 'H:\Predictive_analytics\HW3';

DATA vac;
SET q2.vacation;
RUN;

PROC REG;
TITLE 'First Regression';
MODEL miles=income age kids/vif stb;
RUN;

PROC MODEL DATA=vac;
TITLE 'White Test';
PARMS b0 b1 b2 b3;
miles=b0+b1*income+ b2*age+ b3*kids;
FIT miles / white out=resid1 outresid;
RUN;


PROC MODEL DATA=vac;
TITLE 'Weights';
PARMS b0 b1 b2 b3;
income_inv=1/income;
miles=b0+ b1*income+ b2*age+ b3*kids;
FIT miles / white;
weight income_inv;
RUN;

DATA vac2;SET vac;
m=miles/income;
a=age/income;
k=kids/income;
i=1/income;
RUN;

PROC MODEL DATA=vac2;
TITLE 'Correction'
PARMS b0 b1 b2 b3;
m=b1+ b2*a+ b3*k+ b0*i;
FIT m / white;
RUN;


/* Question 2 */

DATA sales_forecast;
INPUT week sales;
datalines;
1 160
2 390
3 800
4 995
5 1250
6 1630
7 1750
8 2000
9 2250
10 2500
;
RUN;

proc print;
run;

DATA sales;
SET sales_forecast;
lags = Lag(sales);
cumd + lags;
sqrdl = cumd*cumd;
RUN;

proc print;
run;

PROC REG DATA = sales OUTEST=coeff1;
MODEL sales = cumd sqrdl;
RUN;

PROC PRINT data=coeff1;
RUN;

DATA a2;
SET coeff1;
m = (- cumd - sqrt((cumd * cumd) - (4 * Intercept * sqrdl)))/(2 *sqrdl);
p = Intercept / m;
q = p + cumd;
t = log(q/p)* (1/(p+q));
s = m *(p+q) *(p+q) / (4*q);
RUN;

proc print;	
run;

/* Forecasting Sales with p =0.0179 ,q = 0.3743 and m = 23386.2164*/  

DATA sales_pred;
SET sales_forecast;
/*KEEP week sales sales_p;*/
retain cumd 0 ;
retain sales_p;
p = 0.0179;
q = 0.3743;
m = 23386.2164;
if week = 1 then sales_p = (p+((q/m)* 0))* (m - 0);
if week>1 then 
do;
	cumd = cumd + sales_p;
	sales_p = (p+((q/m)* cumd))* (m - cumd);
end;
RUN;

proc print;
run;

legend1 order=('Sales' 'Predicted Sales') label=none frame; 
axis1 label = ('Sales');
axis2 label = ('Week');
PROC GPLOT data=sales_pred;
symbol1 interpol=join value=dot;
PLOT sales*week sales_p*week /overlay legend=legend1 vaxis=axis1 haxis=axis2;
run;


/* question 3 */


data tooth;
input   brand$ scent$ soft$	oz	pr	s1	s2	s3	s4	s5;
 datalines;	 	 	 	  	 	 	 	 	 
complete	fresh	n	48	4.99	1	3	3	2	2
complete	fresh	y	32	2.99	1	3	3	5	5
complete	lemon	n	32	2.99	1	2	7	5	1
complete	lemon	y	64	3.99	1	9	5	8	1
complete	U	n	64	3.99	1	9	7	8	7
complete	U	y	48	4.99	1	3	3	2	3
Smile	fresh	n	64	2.99	1	9	9	9	6
Smile	fresh	y	48	3.99	1	7	7	6	5
Smile	lemon	n	48	3.99	1	7	7	6	1
Smile	lemon	y	32	4.99	1	1	1	1	1
Smile	U	n	32	4.99	1	1	3	1	2
Smile	U	y	64	2.99	1	9	3	9	9
Wave	fresh	n	32	3.99	7	1	7	4	5
Wave	fresh	y	64	4.99	5	5	3	3	2
Wave	lemon	n	64	4.99	5	5	5	3	1
Wave	lemon	y	48	2.99	9	9	5	7	1
Wave	U	n	48	2.99	9	9	5	7	7
Wave	U	y	32	3.99	7	1	5	4	5
Wave	lemon	n	64	2.99	8	9	6	9	3
Smile	lemon	n	32	4.99	2	1	3	2	1
Smile	fresh	y	48	2.99	2	8	4	5	5
complete	U	y	32	2.99	2	4	2	5	6
complete	lemon	y	48	3.99	2	6	6	6	1

run;

proc print;
run;
/*creating dummy variables*/
data tooth;
set tooth;
dummy_smile=0;
dummy_complete=0;
dummy_fresh=0;
dummy_lemon=0;
dummy_softner=0;
dummy_pr_3=0;
dummy_pr_4=0;
dummy_oz_48=0;
dummy_oz_64=0;
run;
data tooth;
set tooth;
if pr=3.99 then dummy_pr_3=1;
if pr=4.99 then dummy_pr_4=1;
if oz=48 then dummy_oz_48=1;
if oz=64 then dummy_oz_64=1;
if brand='complete' then dummy_complete=1 ;
if brand='Smile' then dummy_smile=1 ;
if scent='fresh' then dummy_fresh=1;
if scent='lemon' then dummy_lemon=1 ;
if soft='y' then dummy_softner=1;
run;
proc print;
run;
/*Many regression */
/*Method 1*/

proc reg data=tooth outest=coeff;
   model s1 s2 s3 s4 s5 = dummy_pr_3
						  dummy_pr_4
                          dummy_oz_48
                          dummy_oz_64 
						  dummy_complete
                          dummy_smile 
                          dummy_fresh
						  dummy_lemon
						  dummy_softner;
   run;

data Regtooth;
set coeff;
c_w = dummy_complete;
s_w = dummy_smile;
c_s_w = 0;
wave = (c_s_w - s_w - c_w)/3;
complete = wave + c_w;
smile = wave + s_w;

pr_3_pr_2 = dummy_pr_3;
pr_4_pr_2 = dummy_pr_4;
PR2_3_4 = 0;
pr_2 = (PR2_3_4 - pr_3_pr_2 - pr_4_pr_2)/3;
pr_3 = pr_2 + pr_3_pr_2;
pr_4 = pr_2 + pr_4_pr_2;

oz_48_32 = dummy_oz_48;
oz_64_32 = dummy_oz_64;
oz_32_48_64 = 0;
oz_32 = (oz_32_48_64 - oz_48_32 - oz_64_32)/3;
oz_48 = oz_32 + oz_48_32;
oz_64 = oz_32 + oz_64_32;

f_u = dummy_fresh;
l_u = dummy_lemon;
f_l_u = 0;
Unscented = (f_l_u - f_u - l_u)/3;
fresh = Unscented + f_u;
lemon = Unscented + l_u;

s_minus_n = dummy_softner;
s_n = 0;
softner = (s_n + s_minus_n)/2;
Not_softner = -softner;
run;


data Part_worth;
set Regtooth;
keep wave complete smile pr_2 pr_3 pr_4 oz_32 oz_48 oz_64 Unscented fresh lemon softner Not_softner;
run;

data Part_worth;
   set Part_worth;
   array x{} numeric;    /* x[1] is 1st var,...,x[4] is 4th var */
   /min =mix(of wave complete smile);       /* min value for this observation */
   /max =max(of wave complete smile);       /* max value for this observation */
   max_min_Brand = max(of wave complete smile) - min(of wave complete smile);
   max_min_Scent = max(of Unscented fresh lemon) - min(of Unscented fresh lemon);
   max_min_softener = max(of softner Not_softner) - min(of softner Not_softner);
   max_min_price = max(of pr_2 pr_3 pr_4) - min(of pr_2 pr_3 pr_4);
   max_min_size = max(of oz_32 oz_48 oz_64) - min(of oz_32 oz_48 oz_64); 
   sumofU = max_min_Brand + max_min_Scent + max_min_softener + max_min_price + max_min_size;
   importanceBrand = max_min_Brand/sumofU;
   importanceScent = max_min_Scent/sumofU;
   importanceSoftener = max_min_softener/sumofU;
   importancePrice = max_min_price/sumofU;
   importanceSize = max_min_size/sumofU;
run;
data value;
set Part_worth;
/*complete	lemon	y	64	2.99*/
Product1= complete+lemon+softner+oz_64+pr_2;
/*Smile	fresh	y	48	2.99*/
Product2= smile+fresh+softner+oz_48+pr_2;
/*Smile	u	y	48	3.99*/
Product3= smile+unscented+softner+oz_48+pr_3;
/*Wave	u	y	48	2.99*/
Product4= unscented+Wave+softner+oz_48+pr_2;
/*Smile	u	n	48	2.99*/
Product5= Smile+unscented+NOt_softner+oz_48+pr_2;
run;
data prob;
set value;
Prob1=exp(product1)/(exp(Product1)+exp(product2)+exp(Product3)+exp(Product4)+exp(product5));
Prob2=exp(product2)/(exp(Product1)+exp(product2)+exp(Product3)+exp(Product4)+exp(product5));
Prob3=exp(product3)/(exp(Product1)+exp(product2)+exp(Product3)+exp(Product4)+exp(product5));
Prob4=exp(product4)/(exp(Product1)+exp(product2)+exp(Product3)+exp(Product4)+exp(product5));
Prob5=exp(product5)/(exp(Product1)+exp(product2)+exp(Product3)+exp(Product4)+exp(product5));
run;
proc print;
run;
