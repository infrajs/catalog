<?php

$ans=array();
if(isset($_GET['seo'])){
	if(empty($_GET['link'])){
	    return Ans::err($ans,'Wrong parameters');
	}
	$link=$_GET['link'];
	$link=$link.'/find';
	$ans['external']='*catalog/seo.json';
	$ans['canonical']=infra_view_getPath().'?'.$link;
	return infra_ans($ans);
}
$ans=Load::loadJSON('*catalog/search.php');

$ans['breadcrumbs']=array();
$conf=Infra::config();
$ans['breadcrumbs'][]=array('href'=>'','title'=>$conf['catalog']['title']);
$menu=Load::loadJSON('*catalog/menu.json');
$ans['breadcrumbs'][]=array('href'=>'find','title'=>$menu['find']['title']);
$ans['menu']=$menu;
return Ans::ret($ans);
