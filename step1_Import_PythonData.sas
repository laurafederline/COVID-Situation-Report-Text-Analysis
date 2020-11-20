/* Importing SITREP text data created in Python */
libname sitreps 'C:\Users\lafede\Documents\COVID sitreps\TextData';

*Importing data with one long string for each report;
filename full_str 'C:/Users/lafede/Documents/COVID sitreps/TextData/text_fullstring.xlsx';
proc import datafile=full_str replace
	dbms=xlsx
	out=txt_fullstring;
	getnames=yes;
run;

*Importing data with text sections;
filename sect_str 'C:/Users/lafede/Documents/COVID sitreps/TextData/text_sections.xlsx';
proc import datafile=sect_str replace
	dbms=xlsx
	out=txt_headers;
	getnames=yes;
run;