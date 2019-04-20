<?php
use akiyatkin\showcase\Showcase;
use akiyatkin\showcase\Data;
use infrajs\catalog\Catalog;
use infrajs\ans\Ans;
use infrajs\rest\Rest;
use infrajs\load\Load;


return Rest::get( function () {
	$ans = array();

	$md = Showcase::initMark($ans);

	$group = '';
	foreach ($md['group'] as $group => $one) break;
	$arlist = Catalog::$conf['filgroups'];
	
	$ar = array();
	
	if (!$group) $group = Catalog::$conf['title'];
	$group = Showcase::getGroup($group);
	if (!$group) $group = Showcase::getGroup();
	
	for ($i = sizeof($group['path'])-1; $i >= 0; $i--) {
		$g = $group['path'][$i];
		if (isset($arlist[$g])) {
			if (isset($ar[$g])) $ar += $arlist[$g];
			else $ar = $arlist[$g];
			break;
		}

	}

	if (!$ar && isset($arlist[Showcase::$conf['title']])) {
		$ar = $arlist[Showcase::$conf['title']];
	}
	$params = [];
	$columns = Showcase::getColumns();
	foreach ($ar as $prop_nick) {
		$row = Data::fetch('SELECT prop_id, prop from showcase_props where prop_nick = ?',[$prop_nick]);
		if(!$row) continue;
		list($prop_id, $prop) = array_values($row);
		
		if(!$prop_id) continue;
		$type = Data::checkType($prop_nick);
		if ($type == 'value') {
			$options = Data::all('SELECT v.value, v.value_nick, count(*) as count FROM showcase_mvalues mv
			left join showcase_values v on v.value_id = mv.value_id
			left join showcase_models m on m.model_id = mv.model_id
			left join showcase_groups g on g.group_id = m.group_id and g.group_nick = :group_nick
			where mv.prop_id = :prop_id
			group by mv.value_id
			',[':prop_id'=>$prop_id, ':group_nick'=>$group['group_nick']]);
		} else if ($type == 'number') {

			$options = Data::all('SELECT mv.number as value, mv.number as value_nick, count(*) as count FROM showcase_mnumbers mv
			inner join showcase_models m on m.model_id = mv.model_id
			inner join showcase_groups g on g.group_id = m.group_id and g.group_nick = :group_nick
			where mv.prop_id = :prop_id
			group by mv.number
			order by mv.number DESC
			',[':prop_id'=>$prop_id, ':group_nick'=>$group['group_nick']]);
			foreach($options as $i => $val) {
				$options[$i]['value'] = (float) $val['value'];
				$options[$i]['value_nick'] = (float) $val['value_nick'];
			}
		} else {
			continue;
		}
		

		$params[$prop_nick] = [
			'prop_nick' => $prop_nick,
			'prop' => $prop,
			'more' => true,
			'options' => $options
		];
		if (in_array($prop_nick, $columns)) $params[$prop_nick]['more'] = false;
		
		
	}
	$ans['list'] = $params;
	return Ans::ret($ans);
});