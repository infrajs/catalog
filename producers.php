<?php
/**
 * Выводит список производителей с количеством позиций
 */
namespace infrajs\catalog;

use infrajs\excel\Xlsx;
use infrajs\load\Load;
use infrajs\ans\Ans;
use infrajs\view\View;

$ans=array();
if(isset($_GET['seo'])){
	if(empty($_GET['link'])){
	    return Ans::err($ans,'Wrong parameters');
	}
	$link=$_GET['link'];
	$link=$link.'/producers';
	$ans['external']='-catalog/seo.json';
	$ans['canonical']=View::getPath().$link;
	return Ans::ans($ans);
}
$fd=Catalog::initMark($ans);

if (isset($_GET['lim'])) {
	$lim = $_GET['lim'];
} else {
	$lim='0,20';
}
$p = explode(',', $lim);
if(sizeof($p)!=2){
	return Ans::err($ans, 'Is wrong paramter lim');
}
$start = (int)$p[0];
$count = (int)$p[1];
$args=array($start, $count);
$list=Catalog::cache('producers.php', function ($start, $count) {
	$ans=array();

	$data=Catalog::init();
	$prods=array();
	Xlsx::runPoss($data, function (&$pos) use (&$prods) {
		@$prods[$pos['producer']]++;
	});
	arsort($prods, SORT_NUMERIC);
	$prods=array_slice($prods, $start, $count);
	return $prods;
},$args,isset($_GET['re']));
$ans['menu']=Load::loadJSON('-catalog/menu.json');
$ans['list']=$list;

$conf=Catalog::$conf;
$ans['breadcrumbs'][]=array('href'=>'','title'=>$conf['title'],'add'=>'group');
$ans['breadcrumbs'][]=array('href'=>'producers','title'=>'Производители');

return Ans::ret($ans);
