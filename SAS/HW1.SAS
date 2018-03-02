libname hw1 'H:\SAS\HW1';

data loan;
set hw1.small_loan;
run;

proc means data=loan; 
var loan_amnt int_rate annual_inc;
run;

proc corr; 
var loan_amnt int_rate annual_inc;
run;

proc means data=loan;
var loan_amnt int_rate annual_inc; 
class grade;
run; 

proc means data=loan;
var loan_amnt int_rate annual_inc; 
class home_ownership;
run; 

proc gchart data=loan;
Hbar loan_amnt;
vbar int_rate;
run;

data loan_own;
set Loan;
if home_ownership='RENT' or home_ownership='OWN';
run;

proc ttest data=loan_own;
class home_ownership;
var int_rate; 
run;

proc ttest data=loan_own;
class home_ownership;
var loan_amnt; 
run;

proc anova data = loan;
      class grade;
    model int_rate=grade;
   run;

ods graphics on;
title 'Data';
proc corr data=loan plots=matrix(histogram);
   var loan_amnt int_rate installment annual_inc total_rec_prncp total_rec_int total_rec_late_fee;
run;
ods graphics off;


proc corr data=loan plots=matrix(histogram); 
run;


proc sgplot data = loan;  *STARTS THE PROC;
 scatter x = loan_amnt y = int_rate; *CREATES A PLOT, NOTE THE USE OF X = AND Y =;
run;


proc sgplot  data = loan;
  scatter x = loan_amnt y = int_rate/  markerattrs = (size = 2 symbol = circlefilled);
run;


proc template;
 define statgraph fancybox;
 begingraph;
   entrytitle "Box plot w/histogram";
   layout lattice/rows = 1 columns = 1 order = columnmajor rowweights = (1. 0);
      columnaxes;
          columnaxis /griddisplay = on;
          columnaxis /label = 'label' griddisplay = on;
     endcolumnaxes;
        boxplot x = grade y = int_rate;
 endlayout;
endgraph;
end;
run;
proc sgrender data = loan template = fancybox;
run;
