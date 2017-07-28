<?php
namespace infrajs\catalog;

use infrajs\excel\Xlsx;
use infrajs\load\Load;
use infrajs\ans\Ans;
use infrajs\path\Path;
use infrajs\nostore\Nostore;
use infrajs\view\View;

$ans=array();
if(isset($_GET['seo'])){
	if(empty($_GET['link'])){
	    return Ans::err($ans,'Wrong parameters');
	}
	$link=$_GET['link'];
	$link=$link.'/stat';
	$ans['external']='-catalog/seo.json';
	$ans['canonical']=View::getPath().$link;
	return Ans::ans($ans);
}
$ans['menu']=Load::loadJSON('-catalog/menu.json');
$submit=!empty($_GET['submit']); // сбор статистики

$conf=Catalog::$conf;
$ans['breadcrumbs'][]=array('href'=>'','title'=>$conf['title'],'add'=>'group');
$ans['breadcrumbs'][]=array('href'=>'stat','title'=>'Статистика поиска');

$data = Load::loadJSON('~catalog-stat.json');
if (!$data) {
	$data=array('users' => array(),'cat_id' => 0,'time' => time());//100 10 user list array('val'=>$val,'time'=>time())
}

if (!$submit) {
	$ans['text']=Load::loadTEXT('-doc/get.php?src='.$conf['dir'].'/articles/stat');
	$ans['stat']=$data;
	return Ans::ret($ans);
}


$val=strip_tags(@$_GET['val']);
if (!$val) {
	return Ans::err($ans, 'Incorrect parameters');
}
//header('Cache-Controll: no-store');
Nostore::on();
$val=Path::encode($val);
$val=Path::toutf($val);
$id = View::getCookie('cat_id');
$time = View::getCookie('cat_time');
if (!$time||!$id||$time!=$data['time']) {
	$id=++$data['cat_id'];
	View::setCookie('cat_id', $id);
	View::setCookie('cat_time', $data['time']);
}
$ans['cat_id']=$id;
$ans['cat_time']=$time;

$user=array('cat_id'=>$id,'list'=>array(),'time'=>time());
foreach ($data['users'] as $k => $v) {
	if ($v['cat_id']==$id) {
		$user=$v;
		unset($data['users'][$k]);
		break;
	}
}
$data['users']=array_values($data['users']);

foreach ($user['list'] as $k => $v) {
	if ($v['val']==$val) {
		unset($user['list'][$k]);
		break;
	}
}
$user['list']=array_values($user['list']);
$search=Load::loadJSON('-catalog/search.php?val='.$val);
array_unshift($user['list'], array('val' => $val,'time' => time(),'count' => $search['count']));


$count = 20;
if (sizeof($user['list'])>$count) {
	$user['list']=array_slice($user['list'], 0, $count);
}
array_unshift($data['users'], $user);

$count = 1000;
if (sizeof($data['users']) > $count) {
	$data['users']=array_slice($data['users'], 0, $count);
}

file_put_contents(Path::resolve('~catalog-stat.json'), Load::json_encode($data));
$ans['data'] = $data;

return Ans::ret($ans);
