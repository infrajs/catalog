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


$menu = [
	"producers"=>[
		"title"=>"Производители",
		"descr"=>"Производители представленные на сайте"
	],
	"stat"=>[
		"title"=>"Статистика",
		"descr"=>"Статистика поиска по каталогу"
	],
	"find"=>[
		"title"=>"Поиск",
		"descr"=>"Поиск по каталогу. Поисковая фраза разбивается по словам и будет найдены все товарные позиции которые содержат указанные слова в любом порядке."
	]
];

$ans['breadcrumbs'][]=array('active'=>true, 'href'=>'find','title'=>$menu['find']['title']);
$ans['menu']=$menu;
return Ans::ret($ans);
