/* Downloading WHO Situational Reports 1-100 to local drive 
Data downloaded Wednesday, May 13, 2020 */

%let path=C:\Users\lafede\Documents\COVID sitreps\RawPDFs;
libname pdfs "&path";


/* Downloading all 100 by looping through URL clusters (PDF naming convention changes overtime) */

	*Calculating difference between raw date value and report number;
	%let first_day=21jan2020;
	%let first_date=%sysfunc(inputn(&first_day,anydtdte9.));
	%let report_calc=%eval(&first_date-1);

	*URLs differ by the date, report number, and the ending. This macro loops through date clusters with same URL ending.;
	%macro url_download (first,last,url_end);
		%let f_date=%sysfunc(inputn(&first,anydtdte9.));
		%let l_date=%sysfunc(inputn(&last,anydtdte9.));
		%do i=&f_date %to &l_date;
			data _null_;
				call symput('date',put(&i,yymmddn.));
			run;
			%let rep_num=%eval(&i-&report_calc);
			%let rep_url=%sysfunc(
			cats(https://www.who.int/docs/default-source/coronaviruse/situation-reports/,&date,-sitrep-,&rep_num,&url_end));
			
			filename sitrp&rep_num. url "&rep_url";
			data _null_;
			   n=-1;
			   infile sitrp&rep_num. recfm=s nbyte=n length=len;
			   input;
			   file "&path.\sitrep&rep_num..pdf" recfm=n;
			   put _infile_ $varying32767. len;
			run;
		%end;
	%mend url_download;

	%url_download(21jan2020,25jan2020,-2019-ncov.pdf);
	%url_download(26jan2020,27jan2020,-2019--ncov.pdf);
	%url_download(28jan2020,28jan2020,-ncov-cleared.pdf);
	%url_download(29jan2020,29jan2020,-ncov-v2.pdf);
	%url_download(30jan2020,12feb2020,-ncov.pdf);
	%url_download(02feb2020,02feb2020,-ncov-v3.pdf);
	%url_download(13feb2020,29apr2020,-covid-19.pdf);
	%url_download(03apr2020,03apr2020,-covid-19-mp.pdf);
	%url_download(17apr2020,17apr2020,-covid-191b6cccd94f8b4f219377bff55719a6ed.pdf);


/* Base Code (just reading 1st sitrep) */
	filename sitrep1 url 'https://www.who.int/docs/default-source/coronaviruse/situation-reports/20200121-sitrep-1-2019-ncov.pdf';
	
	data _null_;
	   n=-1;
	   infile sitrep1 recfm=s nbyte=n length=len;
	   input;
	   file "&path.\sitrep1.pdf" recfm=n;
	   put _infile_ $varying32767. len;
	run;
