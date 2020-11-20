/* Further structuring 1word dataset */

/* Stripping words of numbers and symbols, and making all letters lowercase */
	data txt_1word_clean;
		set sitreps.txt_1word;
		if find(text_1word,"@") =  0;
		txt_1word_clean = compress(lowcase(text_1word),"","ka");
		drop text_1word;
		if txt_1word_clean^="";
	run;


/* Remove common English words */
	/* common words 
		https://gist.github.com/deekayen/4148741 */
	data common_words;
		input txt_1word_clean $;
		datalines;
	the
	of
	to
	and
	a
	in
	is
	it
	you
	that
	he
	was
	for
	on
	are
	with
	as
	I
	his
	they
	be
	at
	one
	have
	this
	from
	or
	had
	by
	not
	word
	but
	what
	some
	we
	can
	out
	other
	were
	all
	there
	when
	up
	use
	your
	how
	said
	an
	each
	she
	which
	do
	their
	time
	if
	will
	way
	about
	many
	then
	them
	write
	would
	like
	so
	these
	her
	long
	make
	thing
	see
	him
	two
	has
	look
	more
	day
	could
	go
	come
	did
	number
	sound
	no
	most
	people
	my
	over
	know
	water
	than
	call
	first
	who
	may
	down
	side
	been
	now
	find
	here
	from
	see
	has
	can
	are
	;
	run;
	
	data common_words;
		set common_words;
		txt_1word_clean = compress(lowcase(txt_1word_clean),"","ka");
		if txt_1word_clean^="";
	run;
	
	/* Remove top words from text_1word_clean dataset */
	proc sort data=common_words; by txt_1word_clean; run;
	proc sort data=work.txt_1word_clean; by txt_1word_clean; run;
	data sitreps.txt_1word_clean;
		merge txt_1word_clean (in=a) common_words (in=b); 
		by txt_1word_clean;
		if b=0;
		*if not b then output test;
	run;

/* Remove words with length < 2 */
data sitreps.txt_1word_clean;
	set sitreps.txt_1word_clean;
	if length(txt_1word_clean) > 2;
run;

/* Add freq and freq % variables */

proc freq data=sitreps.txt_1word_clean;
	tables txt_1word_clean / out=total_freq;
run;

proc freq data=sitreps.txt_1word_clean;
	by sitrep;
	tables txt_1word_clean / out=total_freq;
run;


data txt_freqs;
	set sitreps.txt_1word_clean;
	one=1;
run;

ods select none;
ods output summary = sitrep_freq;
proc means data = txt_freqs n completetypes;	
  class sitrep header_alias txt_1word_clean;
  freq one;
  var one;
run;


ods select none;;
proc freq data=sitrep_freq;
	by sitrep;
	table txt_1word_clean /list out=sitrep_freqp;
	weight one_N /zeros;
run;

data sitreps.txt_freqs;
	set sitrep_freqp;
run;






