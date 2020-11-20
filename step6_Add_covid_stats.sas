/* Import COVID Dataset */

filename covid_n 'C:\Users\lafede\Documents\COVID sitreps\covid_numbers.csv';
proc import datafile=covid_n replace
	dbms=csv
	out=covid_nums;
	getnames=yes;
run;

proc sort data=sitreps.txt_1word_clean; by sitrep; run;
data sitreps.words_stats_1;
	merge sitreps.txt_1word_clean covid_nums(drop=date); 
	by sitrep;
run;

data sitreps.txt_sentences_stats;
	merge sitreps.txt_sentences covid_nums(drop=date);
	by sitrep;
run;

data sitreps.txt_100words_stats;
	merge sitreps.txt_100words covid_nums(drop=date);
	by sitrep;
run;