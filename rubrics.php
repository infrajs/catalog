<?php
use infrajs\excel\Xlsx;
use infrajs\load\Load;
use infrajs\ans\Ans;
use infrajs\catalog\Catalog;
use infrajs\router\Router;


$ans=array();

$fd=Catalog::initMark($ans);
//На главной странице каталога показываются

$data = Load::loadJSON('-catalog/search.php?m='.$ans['m']);

$ans['childs']=$data['childs'];

return Ans::ret($ans);
