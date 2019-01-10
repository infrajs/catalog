<?php

namespace infrajs\catalog;
use infrajs\excel\Xlsx;
use infrajs\path\Path;
use infrajs\ans\Ans;
use infrajs\load\Load;
use infrajs\view\View;
use infrajs\nostore\Nostore;
use infrajs\config\Config;
use infrajs\rubrics\Rubrics;
use akiyatkin\boo\Cache;
use infrajs\once\Once;

$ans = array();

$val = Ans::GET('val');
$val = Path::encode(Path::toutf(strip_tags($val)));
$md = Catalog::initMark($ans);

if(isset($_GET['seo'])){
	$link = $_GET['seo'];
	
	if($md['group']){
		foreach($md['group'] as $val => $one) break;
		$link = $link.'/'.$val;
	} else if($md['producer']){
		foreach($md['producer'] as $val => $one) break;
		$link = $link.'/'.$val;
	} else if($md['search']){
		$val = $md['search'];
		$link = $link.'/'.$val;
	}

	unset($ans['md']);
	unset($ans['m']);

	if ($val) {
		$seofile = '~catalog/articles/'.$val.'.json';
		if (Path::theme($seofile)) {
			$ans['external']  =  '~catalog/articles/'.$val.'.json';
		} else {
			$ans['external']  =  '~catalog/seo.json';
			$ans['title']  =  $val;
		}
	} else {
		$ans['external']  =  '~catalog/seo.json';
	}
	$ans['canonical']  =  View::getPath().$link;
	return Ans::ans($ans);
}


//Nostore::on():
if (isset($_GET['p'])) {
	$ans['page'] = (int)$_GET['p'];
	if ($ans['page']<1) $ans['page'] = 1;
} else {
	$ans['page'] = 1;
}




$args = array($md, $ans['page']);
$page = $ans['page'];
//'найденные позиции'
$ans  =  Catalog::cache(function ($md, $page) use($ans) {
	$re = false;
	if ($ans['page'] !=  1) $re  =  true;
	if ($md['more']) $re  =  true;//Не сохраняем когда есть фильтры more
	if ($re) {
		Cache::ignore();
	}
	//1
	$ans['is'] = ''; //group producer search Что было найдено по запросу val (Отдельный файл is:change)
	$ans['descr'] = '';//абзац текста в начале страницы';
	$ans['text'] = ''; //большая статья снизу всего
	$ans['name'] = ''; //заголовок длинный и человеческий
	$ans['breadcrumbs'] = array();//Путь где я нахожусь
	//$ans['val'] = $val;//Заголовок страницы
	//$ans['title'] = $val;//Что именно было найдено название для FS
	$ans['filters'] = array();//Данные для формирования интерфейса фильтрации, опции и тп
	$ans['groups'] = array();
	$ans['producers'] = array();
	$ans['numbers'] = array(); //Данные для построения интерфейса постраничной разбивки
	$ans['list'] = array(); //Массив позиций
	Catalog::search($md, $ans);
	$conf = Catalog::$conf;
	if (empty($conf['alwaysshowposs'])) {
		if (sizeof($ans['childs']) > 0) $ans['list'] = array();
	}
	
	if ($conf['showgroupsalways'] && sizeof($ans['childs']) == 0) { 
		// Если нет влжоенных групп, показываем группы с предыдущего уровня
		if ($md['group']) {
			foreach($md['group'] as $g => $one) break;
			$g = Catalog::getGroup($g);

			$newmd = $md;
			$newmd['group'] = array();
			if (sizeof($g['path'])>1) {
				$newg = $g['path'][sizeof($g['path'])-2];
				
				$newmd['group'][$newg] = 1;
			}
			$newans = array();
			Catalog::search($newmd, $newans);
			$ans['childs'] = $newans['childs'];
			
		}
	}

	//BREADCRUMBS TITLE
	if(!$md['group'] && $md['producer'] && sizeof($md['producer'])  ==  1) { //ПРОИЗВОДИТЕЛЬ
		if ($md['producer']) foreach ($md['producer'] as $producer  =>  $v) break;
		else $producer = false;
		//is!, descr!, text!, name!, breadcrumbs!
		$ans['is'] = 'producer';
		$name = Catalog::getProducer($producer);
		
		$ans['name'] = $name;
		$ans['title'] = $name;
		$conf = Config::get('catalog');
		$ans['breadcrumbs'][] = array('title' => $conf['title'], 'add' => 'producer:');
		$menu = Load::loadJSON('-catalog/menu.json');
		$ans['breadcrumbs'][] = array('href' => 'producers','title' => $menu['producers']['title']);
		$ans['breadcrumbs'][] = array('href' => $name,'title' => $name);
		$ans['breadcrumbs'][sizeof($ans['breadcrumbs'])-1]['active']  =  true;
	} else if (!$md['group'] && $md['search']) {
		$ans['is'] = 'search';
		$ans['name'] = $md['search'];
		$ans['title'] = Path::encode($md['search'], true);
		$ans['breadcrumbs'][] = array('title' => $conf['title'], 'add' => 'search:');
		$menu = Load::loadJSON('-catalog/menu.json');
		$ans['breadcrumbs'][] = array('href' => 'find','title' => $menu['find']['title']);
		$ans['breadcrumbs'][] = array('title' => $ans['name']);
		$ans['breadcrumbs'][sizeof($ans['breadcrumbs'])-1]['active']  =  true;
	} else {
		//is!, descr!, text!, name!, breadcrumbs!, title
		if ($md['group']) foreach ($md['group'] as $group  =>  $v) break;
		else $group = false;
		$group = Catalog::getGroup($group);
		$ans['is'] = 'group';	
		$ans['breadcrumbs'][] = array('href' => '','title' => $conf['title'], 'add' => 'group:');
		array_map(function ($p) use (&$ans) {
			$group = Catalog::getGroup($p);
			$ans['breadcrumbs'][] = array('href' => $p,'title' => $group['name']);
		}, $group['path']);
		if (sizeof($ans['breadcrumbs']) == 1) {
			array_unshift($ans['breadcrumbs'],array('main' => true,"title" => "Главная","nomark" => true));
		}
		$ans['name'] = $group['name'];//имя группы длинное
		$ans['descr']  =  isset($group['descr']['Описание группы']) ? $group['descr']['Описание группы'] : '';
		$ans['title'] = $group['title'];
		
		
		
		if (!$group['path']) {
			if (sizeof($ans['filters'])) { //Если есть выбранные фильтры, ссылка на каталог сбрасывает выбор
				$ans['breadcrumbs'][sizeof($ans['breadcrumbs'])-1]['href'] = '';
				$ans['breadcrumbs'][sizeof($ans['breadcrumbs'])-1]['add'] = false;
				$ans['breadcrumbs'][sizeof($ans['breadcrumbs'])-1]['nomark'] = true;
			} else {
				$ans['breadcrumbs'][sizeof($ans['breadcrumbs'])-1]['active'] =  true;
			}
			//$ans['breadcrumbs'][] = array('href' => 'producers','title' => 'Производители');
		} else {
			$ans['breadcrumbs'][sizeof($ans['breadcrumbs'])-1]['active'] =  true;	
		}
	}
	Cache::setTitle($ans['title']);
	
	Catalog::sort($ans['list'], $md);

	//Numbers
	$pages = ceil(sizeof($ans['list'])/$md['count']);
	if ($pages<$page) {
		$page = $pages;
	}
	/*echo '<pre>';
	print_r($ans);
	exit;*/
	$ans['numbers'] = Catalog::numbers($page, $pages, 11);
	$ans['list'] = array_slice($ans['list'], ($page-1)*$md['count'], $md['count']);

	//Text
	
	$src  =  Rubrics::find($conf['dir'].'articles/', $ans['title']);

	if ($src) {
		$ans['textinfo']  =  Rubrics::info($src); 
		$ans['text']  =  Load::loadTEXT('-doc/get.php?src='.$src);//Изменение текста не отражается как изменение каталога, должно быть вне кэша
	}
	
	foreach ($ans['list'] as $k => $pos){
		$pos = Catalog::getPos($pos);
		$group = Catalog::getGroup($pos['group']);
		$pos['descr']  =  $group['descr'];
		unset($pos['texts']);
		unset($pos['files']);
		$ans['list'][$k] = $pos;
	}
	return $ans;
}, $args);


return Ans::ret($ans);
