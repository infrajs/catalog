<?php
/**
 * Блок "filters"
 */

namespace infrajs\catalog;

use infrajs\excel\Xlsx;
use infrajs\config\Config;
use infrajs\path\Path;
use infrajs\sequence\Sequence;
use infrajs\ans\Ans;

$ans = array();

$md = Catalog::initMark($ans);

$args = array(Catalog::nocache($md));
$res = Catalog::cache('filters.php filter list', function ($md) {
	$conf = Config::get('catalog');
	$ans = array();
	$params = Catalog::getParams($md['group']);
	

	
	$poss = Catalog::getPoss($md['group']);
	//Поиск
	$count=sizeof($poss);//Позиций в группе
	$res=Catalog::search($md);
	$poss=$res['list'];
	$search=sizeof($poss);//Позиций найдено
	//ПОСЧИТАЛИ FILTER со всеми md

	foreach($params as $k=>$prop){
		if($prop['more']){
			foreach($poss as &$pos){
				if(!Xlsx::isSpecified($pos['more'][$prop['posid']]))continue;
				$r=false;
				if ($prop['separator']) {
					$arval=explode($prop['separator'], $pos[$prop['posid']]);
				} else {
					$arval=array($pos[$prop['posid']]);
				}
				foreach($arval as $value){
					$idi=Path::encode($value);
					$id=mb_strtolower($idi);
					if (!Xlsx::isSpecified($id)) continue;
					$r=true;
					$params[$k]['option'][$idi]['search']++;
				}
				if ($r)	$params[$k]['search']++;
			}
		}else{
			foreach($poss as &$pos){
				if(!Xlsx::isSpecified($pos[$prop['posid']]))continue;
				
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
			$mymd=$md;
		
			$mymd['more'] = array_diff_key($md['more'], array_flip(array($prop['mdid'])));

			$res = Catalog::search($mymd);
			$poss = $res['list'];

			foreach ($poss as &$pos){
				
				if (preg_match("/[:]/", $pos['more'][$prop['posid']])) continue;

				if (!Xlsx::isSpecified($pos['more'][$prop['posid']])) continue;

				$r=false;
				if ($prop['separator']) {
					$arval=explode($prop['separator'], $pos['more'][$prop['posid']]);
				} else {
					$arval=array($pos['more'][$prop['posid']]);
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
	foreach($params as $k => $v){
		if ($v['more']) {
			$right = array('more', $v['mdid']);    
			$add = 'more.';
		}else{
			$right = array($v['mdid']);    
			$add = '';
			
		}
		$showhard = Sequence::get($md, $right);
		if (!is_array($conf['filtershowhard'])) $conf['filtershowhard'] = array($conf['filtershowhard']);
		if (in_array($v['mdid'], $conf['filtershowhard'])) {
			$showhard = true;
		}
		
		

		$opt = Catalog::option($params[$k]['option'], $count, $search, $showhard);
		
		if (!$opt) {
			unset($params[$k]);
		} else {
			$params[$k]['option']=$opt;
		}
	}
				
		
				
	
	$ans['params'] = $params;
	//$ans['params']=$params;
	$ans['search'] = $search;//Позиций найдено
	$ans['count'] = $count;//Позиций в группе
	$ans['template'] = array();

	foreach ($params as $param){
		$block = array();
		
		if ($param['more']) {
			$right = array('more', $param['mdid']);    
			$add = 'more.';
		}else{
			$right = array($param['mdid']);    
			$add='';
		}
		
		$mymd = Sequence::get($md, $right);
		if (!$mymd) $mymd = array();
		
		
		$paramid = Sequence::short(array(Catalog::urlencode($param['mdid'])));
		$block['checked'] = !!$mymd['yes'];
		
		
		if($block['checked']){
			$block['add'] = $add.$paramid.'.yes=';
		} else {
			$block['add'] = $add.$paramid.'.yes=1';  
		}
		
		$block['title'] = $param['title'];
		$block['type'] = $param['option']['type'];
		$block['filter'] = $param['filter'];
		$block['search'] = $param['search'];
		$block['count'] = $param['count'];
		$block['row'] = array();

		if ($param['option']['nocount']){
			$row = array(
				'title' => 'Не указано',
				'filter' => $param['nofilter']
			);
			$row['checked'] = !!$mymd['no'];
			if ($row['checked']) {
				$row['add'] = $add.$paramid.'.no=';
			} else {
				$row['add'] = $add.$paramid.'.no=1';    
			}
			$block['row'][] = $row;
		}
		
		if ($block['type'] == 'string') {
			foreach ($param['option']['values'] as $value) {
				$row = array(
					'title' => $value['title'],
					'filter' => $value['filter']
				);
				$row['checked']=!!$mymd[$value['id']];
				$valueid=Sequence::short(array(Catalog::urlencode($value['id'])));
				if($row['checked']){
					$row['add'] = $add.$paramid.'.'.$valueid.'=';
				} else {
					$row['add'] = $add.$paramid.'.'.$valueid.'=1';
				}
				
				$block['row'][] = $row;
			}
		}
		if ($conf['filteroneitem'] || sizeof($block['row'])>1) $ans['template'][] = $block;
	}
	return $ans;
}, $args, isset($_GET['re']));
$ans = array_merge($ans, $res);

return Ans::ret($ans);
