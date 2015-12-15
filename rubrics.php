<?php

namespace infrajs\catalog;
use infrajs\excel\Xlsx;
use infrajs\load\Load;
use infrajs\ans\Ans;


if (!is_file('vendor/autoload.php')) {
	chdir('../../../');
	require_once('vendor/autoload.php');
}


$ans=array();

$fd=Catalog::initMark($ans);
//На главной странице каталога показываются

$data=Load::loadJSON('-catalog/search.php?m='.$ans['m']);

$ans['childs']=$data['childs'];

return Ans::ret($ans);
