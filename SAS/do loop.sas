DATA array1;
INPUT id w1-w5 ;
ARRAY score[5] w1-w5;
/*i will be equal to 6 at the end.*/
do i=1 to dim(score);
		if score[i]=9 then score[i]='.';
end;
datalines;
101 4 3 2 5 9
102 3 4 9 2 2
103 5 5 3 1 1
104 2 9 9 1 3
105 9 3 9 3 9
;
run;

/*i equal to 5 at the end*/
data A;
do i = 1 to 5;
   y = i**2; /* values are 1, 4, 9, 16, 25 */
   output;
end;
run;

data A;
i = 1;
do until (i>5);
   y = i**2; /* values are 1, 4, 9, 16, 25 */
   output;
   i+1;
end;
run;

data A;
i = 1;
do while (i<=5);
   y = i**2; /* values are 1, 4, 9, 16, 25 */
   output;
   i+1;
end;
run;



data A;
flag = 0;
do i=1 to 10 until(flag=1);
   y = i**2; /* values are 1, 4, 9, 16, 25 */
   f = 2*i+3;
   output;
   if f>15 then flag=1;
end;
run;

data A;
Exit=10;
x = 20;
do i=1 to exit;
	y=x*normal(0);
if y>25 then i=exit;	
*if y is greater than 25, then SAS stop executing the loop;
output;
end; 
run;
