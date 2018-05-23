<?php
use infrajs\catalog\Catalog;
use infrajs\ans\Ans;
use infrajs\path\Path;
use infrajs\rest\Rest;


return Rest::get( function (){
	$ans = array();
	$val = Ans::GET('val');
	$val = Path::toutf(strip_tags($val));
	if ($val) {
		$group = Catalog::getGroup($val);
		if (!isset($_GET['m'])) $_GET['m'] = '';
		if ($group) {
			$_GET['m'].=':group::.'.$val.'=1';
		} else {
			$producer = Catalog::getProducer($val);
			if ($producer) {
				$_GET['m'].=':producer::.'.$val.'=1';
			} else {
				$_GET['m'].=':search='.$val;
			}
		}
	}
	$md = Catalog::initMark($ans);

	$ans['filgroups'] = Catalog::$conf['filgroups'];
	return Ans::ret($ans);
});