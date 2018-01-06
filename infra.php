<?php
use infrajs\event\Event;
use infrajs\sequence\Sequence;
use infrajs\catalog\Catalog;
/*
	Файл нужно переопределить в конкретном проекте для конфигурирования каталога
*/

Event::$classes['Catalog'] = function (&$obj) { //Объект это группа или опция фильтра
	return $obj['title'];
};
Event::handler('Catalog.option', function (&$param) {
	$block = array();

	$conf = Catalog::$conf;

	$paramid = $param['id'];
	$mymd = $param['mymd'];
	
	$block['checked'] = !empty($mymd['yes']);
	
	
	$add = ($param['more'])? 'more.' : '';
	if($block['checked']){ //Все указанные
		$block['add'] = $add.$paramid.'.yes=';
	} else {
		$block['add'] = $add.$paramid.'.yes=1';  
	}
	
	$block['title'] = $param['title'];
	$block['id'] = $param['id'];
	$block['path'] = $param['path'];
	$block['type'] = $param['option']['type'];
	$block['filter'] = $param['filter'];
	$block['layout'] = 'default';
	$block['search'] = $param['search'];
	$block['count'] = $param['count'];
	$block['row'] = array();
	
	$block['omit'] = array(); //пропущено
	if ($param['option']['nocount']){  //Все не указанные
		$row = array(
			'title' => 'Не указано',
			'filter' => $param['nofilter']
		);
		$row['checked'] = !empty($mymd['no']);
		if ($row['checked']) {
			$row['add'] = $add.$paramid.'.no=';
		} else {
			$row['add'] = $add.$paramid.'.no=1';    
		}
		$block['omit'] = $row;
		$block['row'][] = $row;
	}
	
	//if (in_array($block['type'], array('string','number'))) {
	if (sizeof($param['option']['values']) <= $conf['foldwhen']) {
		foreach ($param['option']['values'] as $value) {
			$row = array(
				'title' => $value['title'],
				'filter' => $value['filter']
			);
			$row['checked'] = !empty($mymd[$value['id']]);
			$valueid = Sequence::short(array(Catalog::urlencode($value['id'])));
			if($row['checked']){
				$row['add'] = $add.$paramid.'.'.$valueid.'=';
			} else {
				$row['add'] = $add.$paramid.'.'.$valueid.'=1';
			}
			
			$block['row'][] = $row;
		}
	}
	//}
	$param['block'] = $block;
}, 'Catalog');


Catalog::add('count', function () {
	return 10;
}, function (&$val) {
	$val = (int) $val;
	if ($val < 1 || $val > 1000) return false;
	return true;
});
Catalog::add('reverse', function () {
	return false;
}, function (&$val) {
	$val = !!$val;
	return true;
});
Catalog::add('sort', function () {
	return '';
}, function ($val) {
	return in_array($val, array('name', 'art', 'group', 'change', 'cost'));
});

Catalog::add('producer', function () {
	return array();
}, function (&$val) {
	if (!is_array($val)) return false;
	$val = array_filter($val);
	$producers = array_keys($val);
	$producers = array_filter($producers, function (&$value) {
		if (in_array($value,array('yes', 'no'))) return true;
		if (Catalog::getProducer($value)) return true;
		return false;
	});
	$val = array_fill_keys($producers, 1);
	return !!$val;
});

Catalog::add('group', function () {
	return array();
}, function (&$val) {
	if (!is_array($val)){
		$s = $val;
		$val = array();
		$val[$s] = 1;
	}
	$val = array_filter($val);
	$values = array_keys($val);
	$values = array_filter($values, function (&$value) {
		if(in_array($value,array('yes', 'no'))) return true;
		if(!$value)return false;
		if(!Catalog::getGroup($value))return false;
		return true;
	});
	$val = array_fill_keys($values, 1);
	return !!$val;
});

Catalog::add('search', function () {
	return '';
}, function ($val) {
	return is_string($val);
});

Catalog::add('cost', function () {
	return array();
}, function (&$val) {
	if (!is_array($val)) return false;
	$val = array_filter($val);//Удаляет false значения
	$values = array_keys($val);
	$values = array_filter($values, function (&$value) {
		if (in_array($value, array('yes', 'no'))) return true;
		if (!$value) return false;
		return true;
	});
	$mm = isset($val['minmax']);
	if ($mm) $minmax = $val['minmax'];
	$val = array_fill_keys($values, 1);
	if ($mm) $val['minmax'] = $minmax;
	return !!$val;
});
Catalog::add('more', function () {
	return array();
}, function (&$val) {
	if (!is_array($val)) return;
	foreach($val as $k => $v){
		if (!is_array($v)) {
			unset($val[$k]);
		} else {
			foreach($v as $kk => $vv){		
				if (!$vv) unset($val[$k][$kk]);
			}
			if (!$val[$k]) unset($val[$k]);
		}		
	}
	return !!$val;
});
