/* Create dateURL dataset */
	
*Calculating difference between raw date value and report number;
	%let first_day=21jan2020;
	%let first_date=%sysfunc(inputn(&first_day,anydtdte9.));
	%let report_calc=%eval(&first_date-1);

*Create sitrep and date variable;
	data dateURL;
		do sitrep = 1 to 100;
			date = sitrep + &report_calc;
			output;
		end;
		format date date.;
	run;

*Create URL variable;
	%macro url_variable (first,last,url_end);
		%let f_date=%sysfunc(inputn(&first,anydtdte9.));
		%let l_date=%sysfunc(inputn(&last,anydtdte9.));
		
		data dateURL;
			set dateURL;
			length url $160;
			if date in (&f_date:&l_date) then
				url = cats("https://www.who.int/docs/default-source/coronaviruse/situation-reports/",put(date,yymmddn.),"-sitrep-",put(sitrep,3.),"&url_end.");
		run;
	%mend url_variable;
	
	%url_variable(21jan2020,25jan2020,-2019-ncov.pdf);
	%url_variable(26jan2020,27jan2020,-2019--ncov.pdf);
	%url_variable(28jan2020,28jan2020,-ncov-cleared.pdf);
	%url_variable(29jan2020,29jan2020,-ncov-v2.pdf);
	%url_variable(30jan2020,12feb2020,-ncov.pdf);
	%url_variable(02feb2020,02feb2020,-ncov-v3.pdf);
	%url_variable(13feb2020,29apr2020,-covid-19.pdf);
	%url_variable(03apr2020,03apr2020,-covid-19-mp.pdf);
	%url_variable(17apr2020,17apr2020,-covid-191b6cccd94f8b4f219377bff55719a6ed.pdf);
	

/* Merge dateURL into all data structures and save to library */
	proc sort data=txt_fullstring; by sitrep; run;
	data sitreps.txt_fullstring;
		merge dateURL txt_fullstring;
		by sitrep;
	run;
		
	proc sort data=sitreps.txt_headers_alias; by sitrep; run;
	data sitreps.txt_headers;
		merge dateURL sitreps.txt_headers_alias;
		by sitrep;
	run;

	proc sort data=txt_sentences; by sitrep; run;
	data sitreps.txt_sentences;
		merge dateURL txt_sentences;
		by sitrep;
	run;
	
	proc sort data=txt_100words; by sitrep; run;
	data sitreps.txt_100words;
		merge dateURL txt_100words;
		by sitrep;
	run;

	proc sort data=txt_1word; by sitrep; run;
	data sitreps.txt_1word;
		merge dateURL txt_1word;
		by sitrep;
	run;