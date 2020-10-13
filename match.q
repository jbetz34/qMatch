\c 2000 2000
// init vairables
symlist:asc `GE`BMW`UL`DIS`NFLX`SNY`M`V`AAPL`TSLA`AMZN`PG
idlist:symlist!count[symlist]#0
pricelist:symlist!1890 2500 250 105 50 15 455 75 45 235 50 135f
brokerlist:asc `CITI`CS`BAML`JPM`MS`VECTO`UBS`SCB`RBS`GBM

// data storage
ob:os:()!()
orders:([]time:`timestamp$();sym:`symbol$();oid:`long$();side:`symbol$();exch:`symbol$();price:`float$();volume:`long$();broker:`symbol$())
trades:([]time:`timestamp$();sym:`symbol$();tID:`long$();bID:`long$();sID:`long$();exch:`symbol$();price:`float$();volume:`long$())

// generate random order from params
// price within 5% of pricelist
gen:{[sym;side;n] o:([]time:.z.P+til n;sym:n#sym;oid:idlist[sym]+1+til n;side:n#side;exch:n#`NYSE;price:pricelist[sym]+pricelist[sym]*@[n?.05;(neg first 1?n+1)?n;neg];volume:10*n?100;broker:n?brokerlist);idlist[sym]:last o[`oid];:o}

rgen:{gen ./: flip (x?symlist;x?`B`S;x#1)};
match:{`orders upsert r:raze findTrades each x;r}

// add records to proper book and sorts
// takes one record at a time
addToBook:{[x;s]sort:(`S`B!(asc;desc))s;book:(`S`B!(`os;`ob))s;{@[y;key x;,;value x]}[;book]?[x;enlist (=;`side;enlist s);`sym;(!;`oid;(enlist;(,;`price;`volume)))];@[book;x`sym;sort];x}

// reset all tables and books
/reset:{.[;();:;()]each `ob`os;idlist[symlist]:0;.[;();0#]each `trades`orders;}

// takes records and executes trades if possible
// only takes one record at a time
// returns orders that are not trades
findTrades:{[r] .debug.r:r;
		$[(r[`sym] in key os)&`B=r[`side];
			$[r[`price]>=os[r`sym;1;0];execTrade[r;os[r`sym]];addToBook[;`B] enlist r];
		  (r[`sym] in key ob)&`S=r[`side];
			$[r[`price]<=ob[r`sym;1;0];execTrade[r;ob[r`sym]];addToBook[;`S] enlist r];
		  :addToBook[;r[`side]] enlist r]
 }

// TO DO - splitting of the order volume
// Remove top order from book
execTrade:{[x;o] 
	.debug.x:x;
	 book:(`B`S!`os`ob)x`side;
	c:$[`B=x`side;`bID`sID`tID`price;`sID`bID`tID`price];
	
	// add oid from opposite side
	// assign the tid
	x[c]:(x[`oid];first key o;1+exec 0|max tID from trades;value[o][0;0]);

	// add to trades table
	`trades upsert cols[trades]#x;

	// delete matching order from book
	// compare volume to the volume on book
	// if book is bigger, delete previous order from book and add a new order decremented volume
	// if incoming is bigger, delete previous order from book, decrement incoming order 
	// if order matches, delete both
	// either way, new order should be run through findTrades
	
	// if book is bigger
	//
	//$[1=count o;

	// if they match volume
	$[1=count o;book set (value book)_x`sym;@[book;x`sym;_;first key o]];

	// adjust last trade price dict
	pricelist[x`sym]:x`price;

	// return empty record
	:0#enlist cols[orders]#x
 }
