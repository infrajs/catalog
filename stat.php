<?php
namespace infrajs\catalog;

use infrajs\excel\Xlsx;
use infrajs\load\Load;
use infrajs\ans\Ans;
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

$data=Load::loadJSON('~catalog_stat.json');
if (!$data) {
	$data=array('users' => array(),'cat_id' => 0,'time' => time());//100 10 user list array('val'=>$val,'time'=>time())
}

if (!$submit) {
	$ans['text']=Load::loadTEXT('-doc/get.php?'+$conf['dir'].'/articals/stat');
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
$id=infra_view_getCookie('cat_id');
$time=infra_view_getCookie('cat_time');
if (!$time||!$id||$time!=$data['time']) {
	$id=++$data['cat_id'];
	infra_view_setCookie('cat_id', $id);
	infra_view_setCookie('cat_time', $data['time']);
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

if (sizeof($user['list'])>10) {
	$user['list']=array_slice($user['list'], 0, 10);
}
array_unshift($data['users'], $user);

if (sizeof($data['users'])>100) {
	$data['users']=array_slice($data['users'], 0, 50);
}
file_put_contents(Path::resolve('~catalog_stat.json'), Load::json_encode($data));
$ans['data']=$data;

return Ans::ret($ans);
