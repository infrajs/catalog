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
	$arlist = Catalog::$conf['filgroups'];

	$ar = array();
	if (isset($arlist[$group])) {
		$ar = $arlist[$group];
	} else {
		if (!$group) $group = Catalog::$conf['title'];
		$group = Catalog::getGroup($group);
		if (!$group) $group = Catalog::getGroup(Catalog::$conf['title']);
		for ($i = sizeof($group['path'])-1; $i >= 0; $i--) {
			$g = $group['path'][$i];
			if (isset($arlist[$g])) {
				$ar = $arlist[$g];
				break;
			}
		}
		if (!$ar && isset($arlist[Catalog::$conf['title']])) {
			$ar = $arlist[Catalog::$conf['title']];
		} 
	}
	
	

	

	$list = array();
	
	if ($ar) {
		$params = Catalog::getParams($md['group']);
		Catalog::calcParams($params, $md);

		foreach ($ar as $name) {
			if (!isset($params[$name])) continue;
			$list[$name] = $params[$name];
		}

		//foreach ($list as &$opt) {
		//	ksort($opt['option']);
		//}
	}
	$ans['list'] = $list;
	return Ans::ret($ans);
});