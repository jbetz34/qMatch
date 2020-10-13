findTrades:{[r] 
		$[(r[`sym] in key ob)&`B=r[`side];
			$[r[`price]>=ob[r`sym;1];`execTrades;r]
		  (r[`sym] in key os)&`S=r[`side];
			$[r[`price]<=os[r`sym;1];`execTrades;r]
 }
			
