/* ​​​​​​​Match similar headers with header alias */

*See what headers exist and for what reports;
proc freq data=sitreps.txt_headers;
	tables header;
run;

proc sort data=sitreps.txt_headers; by header sitrep; run;
proc print data=sitreps.txt_headers;
	var header sitrep;
run;

*Create aliases to group headers (most common header used for alias);
data alias;
	length header_alias $41;
	set txt_headers;
	if header in ('HIGHLIGHTS','SUMMARY')
		then header_alias = 'Highlights';
	else if header in ('RECOMMENDATIONS AND ADVICE','RECOMMENDATIONS AND ADVICE FOR THE PUBLIC')
		then header_alias = 'Recommendations and Advice for the Public';
	else if header in ('SITUATION IN FOCUS','SUBJECT IN FOCUS','TECHNICAL FOCUS')
		then header_alias = 'Subject in Focus';
	else header_alias = propcase(header);
run;

proc print data=alias;
	var header header_alias;
run;

data sitreps.txt_headers_alias;
	set alias;
run;