<?php

use infrajs\path\Path;
use infrajs\ans\Ans;
use infrajs\load\Load;
use infrajs\rubrics\Rubrics;
use infrajs\access\Access;
use infrajs\router\Router;
use infrajs\rest\Rest;
use infrajs\catalog\Catalog;

if (!is_file('vendor/autoload.php')) {
	chdir(explode('vendor'.DIRECTORY_SEPARATOR, __DIR__)[0]);
	require_once('vendor/autoload.php');
	Router::init();
}

$ans = Rest::get( 'pos', function ($query, $prod = false, $art = false) {

	$ans = array();
	$ans['producer'] = $prod;
	$ans['article'] = $art;
	$ans['data'] = false;
	$list = Catalog::getPoss();
	if (!$prod) {
		$ans['data'] = $list;
		return $ans;
	}

	$poss = array();
	foreach ($list as $k => $pos) {
		if($pos['producer'] == $prod) $poss[] = $list[$k];
	}
	if (!$art) {
		$ans['data'] = $poss;
		return $ans;	
	}
	foreach ($poss as $k => $pos) {
		if ($pos['article'] == $art) {
			$ans['data'] = Catalog::getPos($poss[$k]);
			break;
		}
	}
	return $ans;
});

if ($ans) return Ans::ret($ans);


$data = Catalog::init();

$ans = array();
$ans['data'] = $data;

return Ans::ret($ans);