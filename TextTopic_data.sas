
/* Importing SITREP text data created in Python */
libname sitreps 'C:\Users\lafede\Documents\COVID sitreps\TextData';

*Importing data with one long string for each report;
filename topics "C:\Users\lafede\Documents\COVID sitreps\TextData\texttopics.xlsx";
proc import datafile=topics replace
	dbms=xlsx
	out=texttopics;
	getnames=yes;
run;

proc sort data=texttopics; by sitrep 'Situation Report'n date url header_alias header cases_worldwide deaths_worldwide territories; run;

proc transpose data=texttopics out=texttopics_long;
	by sitrep 'Situation Report'n date url header_alias header cases_worldwide deaths_worldwide territories; 
run;

data sitreps.texttopics_long;
	set texttopics_long;
	_LABEL_=substr(_LABEL_,12);
	if _LABEL_='+cluster, sporadic, +pend, +case, community' then _NAME_= "case geography";
	else if _LABEL_='+death, +confirm, new, total, china' then _NAME_= "counting cases";
	else if _LABEL_='+prevent, +event, +care, +identify, +reduce' then _NAME_= "prevention";
	else if _LABEL_='+protocol, +early, isolation, +impact, epidemiological' then _NAME_= "epidemiological";
	else if _LABEL_='+spread, protection, +area, +measure, +risk' then _NAME_= "risk assessment";
	else if _LABEL_='+symptom, probable, respiratory, suspect, or' then _NAME_= "medical aspects";
	else if _LABEL_='care, +health care setting, infection prevention, +setting, prevention' then _NAME_= "healthcare";
	else if _LABEL_='local, +transmission, +cluster, imported, +pend' then _NAME_= "case origin";
	else if _LABEL_='report, situation, coronavirus, data, coronavirus disease' then _NAME_= "report info";
	rename _LABEL_=topic_words 
			COL1=relevance
			_NAME_=topic;
run;