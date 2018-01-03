<?php

use infrajs\ans\Ans;
use infrajs\each\Each;
use infrajs\config\Config;

$ans = array();
$ans['tplsm'] = array();


foreach (Config::$conf as $name => $ext) {
	Each::exec($ext['catalog-filter'], function &(&$val) use (&$ans, $name) {
		$ans['tplsm'][] = '-'.$name.'/'.$val;
		$r = null;
		return $r;
	});
}

return Ans::ans($ans);