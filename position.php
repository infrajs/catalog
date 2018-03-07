<?php

namespace infrajs\catalog;

use infrajs\nostore\Nostore;
use infrajs\excel\Xlsx;
use infrajs\view\View;
use infrajs\path\Path;
use infrajs\load\Load;
use infrajs\ans\Ans;
use infrajs\config\Config;

//Nostoer::on();

$orig_val = Path::toutf(strip_tags(Ans::GET('val')));
$orig_art = Path::toutf(strip_tags(Ans::GET('art')));
$val = mb_strtolower($orig_val);
$art = mb_strtolower($orig_art);


$args = array($val, $art);
$ans = array();

//'поиск позиции',
$pos = Catalog::cache( function ($val, $art) {
	$data = Catalog::init(); // список всей продукции
	return Xlsx::runPoss($data, function &(&$pos, $i, &$group) use (&$val, &$art) {
		$r = null;
		if (mb_strtolower($pos['producer'])!==$val) return $r;
		if (mb_strtolower($pos['article'])!==$art) return $r;
		return $pos;
	});
}, $args);



if (isset($_GET['seo'])) {
	if (!$pos) return Ans::err($ans,'Position not found');
	$link = $_GET['seo'];
	$link = $link.'/'.urlencode($pos['producer']).'/'.urlencode($pos['article']);
	$ans['external']='-catalog/seo.json';
	$ans['title'] = $pos['Производитель'].' '.$pos['Артикул'];
	if(!empty($pos['Наименование'])) $ans['title'] = $pos['Наименование'].' '.$ans['title'];
	$ans['canonical']=View::getPath().$link;
	
	$seo = Load::loadJSON('~'.$link.'/seo.json');
	if ($seo) {
		$ans = array_merge($ans, $seo);
	}
	return Ans::ans($ans);
}

$ans = array(
	'val'=>$val,
	'art'=>$art
);
$ans['breadcrumbs']=array();//Путь где я нахожусь
$conf = Config::get('catalog');
$ans['breadcrumbs'][]=array('title'=>$conf['title']);


$active = $orig_art;

if ($pos) {

	$group = Catalog::getGroup($pos['group']);
	if (isset($group['descr']['Артикул']) && $group['descr']['Артикул'] == 'Скрытый') {
		$active = $pos['Наименование'];		
	}
	
	$ans['path']=$pos['path'];
	$pos = Catalog::getPos($pos);
	$pos['descr']=$group['descr'];
	
	$ans['pos']=$pos;
	array_map(function($p) use (&$ans){
		$ans['breadcrumbs'][]=array('title'=>$p,'add'=>'group::group.'.$p.'=1');
	}, $pos['path']);
	$ans['breadcrumbs'][]=array('add'=>'producer::producer.'.$orig_val.'=1', 'title'=>$orig_val);
	$ans['breadcrumbs'][]=array('active'=>true, 'title'=>$active);
	return Ans::ret($ans);
} else {
	$ans['breadcrumbs'][]=array('href'=>'producers','title'=>'Производители');
	$ans['breadcrumbs'][]=array('href'=>'','title'=>$orig_val,'add'=>'producer::producer.'.$orig_val.'=1');
	$ans['breadcrumbs'][]=array('active'=>true, 'title'=>$active);
	return Ans::err($ans);
}
