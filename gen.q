\l init.q
gen:{[x] r:`sym`side`volume`broker!(x?.cfg.symlist;x?`B`S;10*x?100;x?.cfg.brokerlist);r[`price]:.cfg.pricelist[r`sym]*.95+10?.10;:r}
