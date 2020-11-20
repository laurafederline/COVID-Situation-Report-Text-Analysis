/* Create 100 word data structure to do text analysis on odd vs. even days*/

data test;
	set sitreps.txt_100words_stats;
	if mod(sitrep,2)=1 then odd=1;
	else odd=0;
run;

/* Mark 60% of the data to do text analysis on only subset */
*Source: https://www.sas.com/content/dam/SAS/en_ca/User%20Group%20Presentations/Hamilton-User-Group/Ardizzi-RandomSampling-Fall2015.pdf;
/* proc sql; */
/* 	create table txt_60pct as */
/* 	select * */
/* 	from test */
/* 	where ranuni(0)<0.6; */
/* quit; */

data sitreps.test_100words;
	set test;
	if ranuni(0)<0.6 then pct_60=1;
	else pct_60=0;
run;

proc freq data=sitreps.test_100words;
	tables pct_60;
run;