<?php

namespace infrajs\catalog;

use infrajs\nostore\Nostore;
use infrajs\excel\Xlsx;
use infrajs\view\View;
use infrajs\path\Path;
use infrajs\ans\Ans;
use infrajs\config\Config;

//Nostoer::on();

$orig_val=Path::toutf(strip_tags($_GET['val']));
$orig_art=Path::toutf(strip_tags($_GET['art']));
$val=mb_strtolower($orig_val);
$art=mb_strtolower($orig_art);


$args=array($val,$art);
$ans=array();

$pos=Catalog::cache('position', function($val, $art){
	$data=Catalog::init(); // список всей продукции
	return Xlsx::runPoss($data, function (&$pos, $i, &$group) use (&$val, &$art) {
		if (mb_strtolower($pos['producer'])!==$val) return;
		if (mb_strtolower($pos['article'])!==$art) return;
		return $pos;
	});
}, $args, isset($_GET['re']));



if(isset($_GET['seo'])) {
	if(!$pos){
		return Ans::err($ans,'Position not found');
	}
	$link=$_GET['seo'];
	$link=$link.'/'.$pos['producer'].'/'.$pos['article'];
	$ans['external']='-catalog/seo.json';
	$ans['canonical']=View::getPath().'?'.$link;
	return Ans::ans($ans);
}

$ans=array(//Оригинальные значения
	'val'=>$val,
	'prod'=>$prod,
	'art'=>$art
);
$ans['breadcrumbs']=array();//Путь где я нахожусь
$conf=Config::get();
$ans['breadcrumbs'][]=array('title'=>$conf['catalog']['title']);

if ($pos) {
	
	$ans['result']=1;
	
	$ans['path']=$pos['path'];
	
	$pos=Catalog::getPos($pos);
	
	$ans['pos']=$pos;
	array_map(function($p) use (&$ans){
			$ans['breadcrumbs'][]=array('title'=>$p,'add'=>'group::group.'.$p.':1');
	}, $pos['path']);
	$ans['breadcrumbs'][]=array('add'=>'producer::producer.'.$orig_val.':1', 'title'=>$orig_val);
	$ans['breadcrumbs'][]=array('title'=>$orig_art);
	return Ans::ret($ans);
} else {
	$ans['breadcrumbs'][]=array('href'=>'producers','title'=>'Производители');
	$ans['breadcrumbs'][]=array('href'=>'','title'=>$orig_val,'add'=>'producer::producer.'.$orig_val.':1');
	$ans['breadcrumbs'][]=array('title'=>$orig_art);
	return Ans::err($ans);
}
