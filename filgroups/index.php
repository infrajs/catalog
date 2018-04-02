<?php
use infrajs\catalog\Catalog;
use infrajs\ans\Ans;
use infrajs\rest\Rest;


return Rest::get( function (){
	$ans = array();
	$md = Catalog::initMark($ans);
	$ans['filgroups'] = Catalog::$conf['filgroups'];
	return Ans::ret($ans);
});