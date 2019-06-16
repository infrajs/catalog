<?php

use infrajs\ans\Ans;
use infrajs\each\Each;
use infrajs\catalog\Catalog;

$ans = array();
$ans['tplsm'] = array();


Each::exec(Catalog::$conf['filterstpl'], function &(&$val) use (&$ans) {
	$ans['tplsm'][] = $val;
	$r = null;
	return $r;
});

return Ans::ans($ans);