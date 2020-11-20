/* Prepare data structure for proc autoreg */

*Lag covid stats with relevance;
*Lag covid stats with # words;

proc sort data=sitreps.texttopics_long; by topic header_alias; run;
proc autoreg data=sitreps.texttopics_long;
	by topic header_alias;
	model territories = relevance;
run;

proc autoreg data=sitreps.texttopics_long;
	where topic = "risk assessment" and header_alias = "Recommendations and Advice for the Public";
	by topic header_alias;
	model territories = relevance;
run;

proc autoreg data=sitreps.texttopics_long;
	where topic = "risk assessment" and header_alias = "Recommendations and Advice for the Public";
	by topic header_alias;
	model deaths_worldwide = relevance / nlag=30;
run;