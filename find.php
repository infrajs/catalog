<?php

use infrajs\view\View;
use infrajs\ans\Ans;
use infrajs\load\Load;
use infrajs\config\Config;
use akiyatkin\showcase\Showcase;

$ans=array();
$conf = Showcase::$conf;
if (isset($_GET['seo'])){
	if(empty($_GET['link'])){
	    return Ans::err($ans,'Wrong parameters');
	}
	$link = $_GET['link'];
	$link = $link.'/find';
	$ans['canonical'] = View::getPath().$link;
	return Ans::ans($ans);
}
$ans = Load::loadJSON('-showcase/api/search');

$ans['breadcrumbs']=array();

$ans['breadcrumbs'][]=array('href'=>'','title'=>$conf['title']);

$ans['breadcrumbs'][]=array('active'=>true, 'href'=>'find','title'=>'Поиск');
return Ans::ret($ans);
