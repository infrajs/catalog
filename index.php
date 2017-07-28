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
	if(!$prod) $ans['list'] = Catalog::getPoss();
	return $ans;
});
if ($ans) return Ans::ret($ans);


$data = Catalog::init();

$ans = array();
$ans['data'] = $data;

return Ans::ret($ans);