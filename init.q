// init vairables
\d .cfg

// variables
symlist:asc `GE`BMW`UL`DIS`NFLX`SNY`M`V`AAPL`TSLA`AMZN`PG
idlist:symlist!count[symlist]#0
pricelist:symlist!1890 2500 250 105 50 15 455 75 45 235 50 135f
brokerlist:asc `CITI`CS`BAML`JPM`MS`VECTO`UBS`SCB`RBS`GBM
baseid:0

// schemas
orders:([]time:`timestamp$();sym:`symbol$();oid:`long$();side:`symbol$();exch:`symbol$();price:`float$();volume:`long$();broker:`symbol$());
trades:([]time:`timestamp$();sym:`symbol$();tID:`long$();bID:`long$();sID:`long$();exch:`symbol$();price:`float$();volume:`long$())
\d .
