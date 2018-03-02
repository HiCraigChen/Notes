data cars;
infile 'H:\SAS\HW2\93cars.dat';
input Horsepower 69-71 MidrangePrice 43-46;
input;
run;

proc corr; 
var Horsepower MidrangePrice;
run;


data carsRegression;
infile 'H:\SAS\HW2\93cars.dat';
input MidPri 43-46 CityMPG 53-54 Airbag 59-59 HP 69-71;
input ManualT 6-6 Domestic 42-42;
label MidPri = 'Midrange Price'
CityMPG = 'City MPG'
Airbag = 'Air Bags standard'
HP = 'Horsepower'
ManualT = 'Manual Transmission'
Domestic = 'Domestic';
run;

proc reg data=Carsregression;
model MidPri = CityMPG Airbag HP ManualT Domestic;
run;


proc glmmod data=Carsregression outdesign=GLMDesign outparm=GLMParm;
   class Airbag;
   model MidPri = CityMPG Airbag HP ManualT Domestic;
run;
 
proc print data=GLMDesign; run;
proc print data=GLMParm; run;


ods graphics off;
/* regression analysis by using dummy variables */
proc reg data=GLMDesign;
   DummyVars: model MidPri = COL2-COL8; /* dummy variables except intercept */
   ods select ParameterEstimates;
quit;
 
/* same analysis by using the CLASS statement */
proc glm data=Carsregression;
   class Airbag;              /* generates dummy variables internally */
   model MidPri = CityMPG Airbag HP ManualT Domestic / solution;
   ods select ParameterEstimates;
quit;

proc reg data=GLMDesign;
model MidPri = COL2-COL8;
run;


data SquaredReg;
set GLMDesign;
HPsq=COL6*COL6;
MPGsq = COL2*COL2;
run;

proc reg data=Squaredreg;
model MidPri = COL2-COL8 HPsq;
run;

data SquaredRegMPG;
set GLMDesign;
MPGsq = COL2*COL2;
run;

proc reg data=SquaredregMPG;
model MidPri = COL2-COL8 MPGsq;
run;


data MVcarsRegression;
infile 'H:\SAS\HW2\93cars.dat';
input MidPri 43-46 CityMPG 53-54 Airbag 59-59 HP 69-71 Type$ 30-36 EZ 65-67;
input ManualT 6-6 Domestic 42-42 LC 34-35;
label MidPri = 'Midrange Price'
CityMPG = 'City MPG'
Airbag = 'Air Bags standard'
HP = 'Horsepower'
ManualT = 'Manual Transmission'
Domestic = 'Domestic'
LC = 'Luggage Capacity'
Type = 'Type'
EZ = 'Engine Size';
run;


proc glmmod data=MVcarsRegression outdesign=GLMDesignMV outparm=GLMParmMV;
   class Airbag Type;
   model MidPri = CityMPG Airbag HP ManualT Domestic LC Type EZ;
run;
 
proc print data=GLMDesignMV; run;
proc print data=GLMParmMV; run;

proc reg data=GLMDesignMV;
model MidPri = COL2-COL8 COL15;
run;



data MVcarsRegression;
infile 'H:\SAS\HW2\93cars.dat';
input MidPri 43-46 CityMPG 53-54 Airbag 59-59 HP 69-71 EZ 65-67 NC 63-63 MaxPrice 48-51 RPM 73-76;
input ManualT 6-6 Domestic 42-42 LC 34-35 Fuel 8-11 Passenger 13-13 Rear 29-32;
label MidPri = 'Midrange Price'
CityMPG = 'City MPG'
Airbag = 'Air Bags standard'
HP = 'Horsepower'
ManualT = 'Manual Transmission'
Domestic = 'Domestic'
LC = 'Luggage Capacity'
EZ = 'Engine Size'
NC = 'Number of Cylinders'
MaxPrice = 'Max Price'
Rear = 'Rear Seat Room'
RPM = 'RPM'
Fuel = 'Feul tank capacity'
Passenger = 'Passenger capacity';
run;


proc glmmod data=MVcarsRegression outdesign=GLMDesignMV outparm=GLMParmMV;
   class Airbag;
   model MidPri = CityMPG Airbag HP ManualT Domestic RPM Fuel Passenger Rear;
run;

proc reg data=GLMDesignMV;
model MidPri = COL2-COL8 COL11;
run;


222222222

data diamond;
infile 'H:\SAS\HW2\diamond data.dat' firstobs=2 missover;
input Cut$ Color$ Clarity$ carat price;
run;


proc glmmod data=diamond outdesign=GLMDesignDM outparm=GLMParmDM;
   class Cut Color Clarity;
   model price = Cut Color Clarity carat;
run;

proc reg data=GLMDesignDM nopoint outset=reg_Data;
Price_Predict: model price = COL2-COL12;
run;

proc print data=reg_Data;
run;

data sampleDummy;
input Price Col2-Col12;
datalines;
0 0 1 0 0 1 0 0 0 1 0 0.75
;;;
run;


proc score data=sampleDummy score=reg_Data out=Scored type=parms;
var price;
run;

proc print data=Scored;
run;

data sample;
input Cut$ Color$ Clarity$ carat price;
datalines;
Good D VVS1 0.75 0
;;;
run;

proc glmmod data=sample outdesign=GLMDesignsample outparm=GLMParmsample;
   class Cut Color Clarity;
   model Price = Cut Color Clarity carat;
run;

proc score data=GLMDesignDM score=sample out=NewPred type=parms nostd predict;
var Cut Color Clarity carat;
run;




proc freq data=Diamond;
tables Color*Clarity / chisq measures;
weight price;
run;



proc anova data = Diamond;
      class Clarity;
	  model price=clarity;
   run;


proc ttest data= Diamond;
class Clarity;
var price;
run;

proc glm data=Diamond;
class Clarity;
model Price =Clarity;
lsmeans Clarity /pdiff;
run;
