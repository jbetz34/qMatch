.cfg.baseid:0;
process:{x[`srcTime`exch]:count[x`sym]#'(.z.P;`NYSE);.cfg.baseid: last x[`oid]:.cfg.baseid + 1 +til count [x`sym];flip x}
