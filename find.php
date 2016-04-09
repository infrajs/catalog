<?php

use infrajs\view\View;
use infrajs\ans\Ans;
use infrajs\load\Load;
use infrajs\config\Config;

$ans=array();
if(isset($_GET['seo'])){
	if(empty($_GET['link'])){
	    return Ans::err($ans,'Wrong parameters');
	}
	$link=$_GET['link'];
	$link=$link.'/find';
	$ans['external']='-catalog/seo.json';
	$ans['canonical']=View::getPath().$link;
	return Ans::ans($ans);
}
$ans=Load::loadJSON('-catalog/search.php');

$ans['breadcrumbs']=array();
$conf=Config::get('catalog');
$ans['breadcrumbs'][]=array('href'=>'','title'=>$conf['title']);
$menu=Load::loadJSON('-catalog/menu.json');
$ans['breadcrumbs'][]=array('href'=>'find','title'=>$menu['find']['title']);
$ans['menu']=$menu;
return Ans::ret($ans);
