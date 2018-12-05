<?php
use infrajs\catalog\Catalog;
use infrajs\ans\Ans;
use infrajs\rest\Rest;
use infrajs\load\Load;


return Rest::get( function () {
	$ans = array();
	$md = Catalog::initMark($ans);

	$group = '';
	foreach ($md['group'] as $group => $one) break;
	$ar = Catalog::$conf['filgroups'];

	if (isset($ar[$group])) {
		$ar = $ar[$group];
	} else {
		$ar = array();
	}

	$list = array();
	
	if ($ar) {
		$params = Catalog::getParams($md['group']);
		Catalog::calcParams($params, $md);

		foreach ($ar as $name) {
			if (!isset($params[$name])) continue;
			$list[$name] = $params[$name];
		}
		foreach ($list as &$opt) {
			ksort($opt['option']);
		}
	}
	$ans['list'] = $list;
	return Ans::ret($ans);
});