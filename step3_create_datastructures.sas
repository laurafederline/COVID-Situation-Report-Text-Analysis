/* Create data structure for each unit of observation */

proc sort data=sitreps.txt_headers_alias; by sitrep; run;

/* Create txt_sentences data structure by seperating each string by sentences */

data txt_sentences;
  set sitreps.txt_headers_alias;
  by sitrep;
  do i=1 to countw(text,'.');
     text_sentence=scan(text,i,'.');
     if trimn(text_sentence) ne "" then output;
  end;
  drop text;
  rename i=sentence_num;
run;

/* Create txt_100words data structure by seperating each string every 100 words 
	'call scan' : https://www.pharmasug.org/proceedings/2014/CC/PharmaSUG-2014-CC25.pdf */

data txt_100words;
	set sitreps.txt_headers_alias;
  	by sitrep;
	start_pos = 1;
	do i=1 to ceil(countw(text,' ')/100);
		if i ne ceil(countw(text,' ')/100) then do;
			call scan (text,i*100+1,end_pos,len,' ');
			text_100words = substr(text,start_pos,end_pos-start_pos);
			start_pos = end_pos;
		end;
		else do;
			text_100words = substr(text,start_pos);
		end;
   		output;
	end;
  	drop text start_pos end_pos len;
  	rename i=section_num;
run;


/* Create txt_1word data structure by assigning each word to its own row */

data txt_1word;
	set sitreps.txt_headers_alias;
	by sitrep;
	text=tranwrd(text,"/", " ");
	do i=1 to countw(text,' ');
    	text_1word=trimn(scan(text,i,' '));
  		if text_1word ne "" then output;
  	end;
  	drop text i;
run;

/* Reducing lengths of new string variables */
proc sql noprint;
	select max(length(text_sentence)) into :sentlength from txt_sentences;
	select max(length(text_100words)) into :word100length from txt_100words;
	select max(length(text_1word)) into :word1length from txt_1word;
quit;

data txt_sentences;
	length text_sentence $&sentlength.;
	set txt_sentences;
	uqid=_n_;
run;

data txt_100words;
	length text_100words $&word100length.;
	set txt_100words;
	uqid=_n_;
run;

data txt_1word;
	length text_1word $&word1length.;
	set txt_1word;
run;