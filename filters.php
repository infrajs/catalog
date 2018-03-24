<?php
/**
 * Блок "filters"
 */
use infrajs\once\Once;
use infrajs\excel\Xlsx;
use infrajs\config\Config;
use infrajs\path\Path;
use infrajs\sequence\Sequence;
use infrajs\ans\Ans;
use akiyatkin\boo\Cache;
use infrajs\nostore\Nostore;
use infrajs\event\Event;
use infrajs\access\Access;
use infrajs\catalog\Catalog;

$ans = array();

$md = Catalog::initMark($ans);

$args = array(Catalog::nocache($md));
$res = Catalog::cache( function ($md) {
	if ($md['more']) {
		//Не сохраняем когда есть фильтры more
		Cache::ignore();
	}
	$conf = Config::get('catalog');
	//$ans = array();
	$params = Catalog::getParams($md['group']);

	$poss = Catalog::getPoss($md['group']);
	//Поиск
	$count = sizeof($poss);//Позиций в группе
	
	$res = Catalog::search($md);
	
	$poss = $res['list'];
	$search = sizeof($poss);//Позиций найдено
	//ПОСЧИТАЛИ FILTER со всеми md
	
	//echo '<pre>';
	//print_r($params);
	
	foreach ($params as $k=>$prop) {
		if ($prop['more']){
			foreach ($poss as &$pos) {
				if (!isset($pos['more'][$prop['posid']]) || !Xlsx::isSpecified($pos['more'][$prop['posid']])) continue;
				$r=false;
				if ($prop['separator']) {
					$arval=explode($prop['separator'], $pos['more'][$prop['posid']]);
				} else {
					$arval=array($pos['more'][$prop['posid']]);
				}
				
				
				foreach ($arval as $value) {
					$idi = Path::encode($value);
					$id = mb_strtolower($idi);
					if (!Xlsx::isSpecified($id)) continue;
					$r = true;
					$params[$k]['option'][$idi]['search']++;
				}

				if ($r)	$params[$k]['search']++;
			}
		}else{
			foreach($poss as &$pos){
				if (!isset($pos[$prop['posid']]) || !Xlsx::isSpecified($pos[$prop['posid']])) continue;
				
				$r=false;
				if($prop['separator']){
					$arval=explode($prop['separator'], $pos[$prop['posid']]);
					$arname=explode($prop['separator'], $pos[$prop['posname']]);
				}else{
					$arval=array($pos[$prop['posid']]);
					$arname=array($pos[$prop['posname']]);
				}

				foreach($arval as $i => $value){
					$idi=Path::encode($value);
					$id=mb_strtolower($idi);

					if (!Xlsx::isSpecified($id)) continue;
					$r=true;
					$params[$k]['option'][$idi]['search']++;
				}
				if ($r)	$params[$k]['search']++;//Позиций с этим параметром
			}
		}

		$params[$k]['nosearch'] = sizeof($poss) - $params[$k]['search'];
	}
	
	//ПОСЧИТАЛИ FILTER как если бы не было выбрано в этой группе md
	foreach ($params as $k => $prop) {

		if ($prop['more']) {
			$mymd = $md;
		
			$mymd['more'] = array_diff_key($md['more'], array_flip(array($prop['mdid'])));
			
			$res = Catalog::search($mymd);
			$poss = $res['list'];
			
			foreach ($poss as &$pos){
				if (!isset($pos['more'][$prop['posid']])) continue;
				if (preg_match("/[:]/", $pos['more'][$prop['posid']])) continue;
				if (!Xlsx::isSpecified($pos['more'][$prop['posid']])) continue;

				$r=false;
				if ($prop['separator']) {
					$arval = explode($prop['separator'], $pos['more'][$prop['posid']]);
				} else {
					$arval = array($pos['more'][$prop['posid']]);
				}
				foreach($arval as $value){
					$idi=Path::encode($value);
					$id=mb_strtolower($idi);
					if (!Xlsx::isSpecified($id)) continue;
					$r=true;
					$params[$k]['option'][$idi]['filter']++;
				}
				if ($r)	$params[$k]['filter']++;
			}
		} else {
			$mymd = array_diff_key($md, array_flip(array($prop['mdid'])));

			$res = Catalog::search($mymd);
			$poss = $res['list'];
			foreach($poss as &$pos){
				if(!isset($pos[$prop['posid']])) continue;
				if (preg_match("/[:]/", $pos[$prop['posid']])) continue;
				if (!Xlsx::isSpecified($pos[$prop['posid']])) continue;

				$r=false;
				if ($prop['separator']) {
					$arval=explode($prop['separator'], $pos[$prop['posid']]);
				} else {
					$arval=array($pos[$prop['posid']]);
				}
				
				foreach ($arval as $i => $value) {
					$idi = Path::encode($value);
					$id = mb_strtolower($idi);
					if (!Xlsx::isSpecified($id)) continue;
					$r=true;
					$params[$k]['option'][$idi]['filter']++;
				}
				if ($r)	$params[$k]['filter']++;//Позиций с этим параметром
			}
		}
		//У скольки позиций в выборке у которых этот параметр не указан
		$params[$k]['nofilter']=sizeof($poss)-$params[$k]['filter'];//
	}
	
	/*
		$params промежуточный массив со всеми возможными занчениями каждого параметра
		каждое значение характеризуется
		count - сколько всего в группе позиций с указанным параметром
		search - сколько всего найдено с md
		filter - сколько найдено если данный параметр не указана в md
	*/
	
	//ДОБАВИЛИ option values
	if (!is_array($conf['filtershowhard'])) $conf['filtershowhard'] = array($conf['filtershowhard']);


	//if (Access::debug()) {
	//	$ans['debug'] = $params;
	//}
	//$ans['params']=$params;
	$ans['search'] = $search;//Позиций найдено
	$ans['count'] = $count;//Позиций в группе

	foreach ($params as $k => $param) {
		if ($param['more']) {
			$right = array('more', $param['mdid']);    
			$add = 'more.';
		}else{
			$right = array($param['mdid']);    
			$add = '';
		}
		$showhard = Sequence::get($md, $right);
		if (in_array($param['mdid'], $conf['filtershowhard'])) {
			$showhard = true;
		}
		$opt = Catalog::option($params[$k]['option'], $count, $search, $showhard);
		
		if (!$opt) {
			unset($params[$k]);
			continue;
		}
		/*if (!$conf['filteroneitem'] || sizeof($opt['values']) < 2) {
			unset($params[$k]);
			continue;
		}*/
		$params[$k]['option'] = $opt;
		
		if ($param['more']) {
			$right = array('more', $params[$k]['mdid']);    
		}else{
			$right = array($params[$k]['mdid']);    
		}
		$md = Catalog::initMark();
		$mymd = Sequence::get($md, $right);
		if (!$mymd) $mymd = array();
		$params[$k]['id'] = Sequence::short(array(Catalog::urlencode($params[$k]['mdid'])));
		$params[$k]['mymd'] = $mymd;

		if ($param['more']) {
			$params[$k]['path'] = 'more.'.$params[$k]['id'];
		} else {
			$params[$k]['path'] = $params[$k]['id'];
		}

		Event::fire('Catalog.option', $params[$k]); //В обработке события должно появится свойство template с данными для шаблона

		$ans['blocks'][] = $params[$k]['block'];
	}
	return $ans;
}, $args);
$ans = array_merge($ans, $res);


return Ans::ret($ans);
