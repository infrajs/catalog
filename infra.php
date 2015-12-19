<?php
namespace infrajs\catalog;
use infrajs\ans\Ans;
use infrajs\path\Path;
use infrajs\cache\Cache;
use infrajs\infra\Infra;

if (!is_file('vendor/autoload.php')) {
	chdir('../../../');
	require_once('vendor/autoload.php');
}

$conf=&Config::get('catalog');
Catalog::$conf=array_merge(Catalog::$conf, $conf);
$conf=Catalog::$conf;