<?php

use infrajs\catalog\Catalog;
use infrajs\ans\Ans;

$ans = array();
$md = Catalog::initMark($ans);
$ans['groups'] = Catalog::getSubgroups();
$group = false;
foreach($ans['groups'] as $k => $val) {
	if (!$val['count']) {
		unset($ans['groups'][$k]);
		continue;
	}
	if (empty($val['childs'])) continue;
	foreach ($val['childs'] as $i => $ch) {
		if (!$ch['count']) unset($ans['groups'][$k]['childs'][$i]);
	}
	$ans['groups'][$k]['childs'] = array_values($ans['groups'][$k]['childs']);
	if (empty($ans['groups'][$k]['childs'])) unset($ans['groups'][$k]['childs']);
}

foreach ($md['group'] as $group => $one) break;
if ($group) {
	$group = Catalog::getGroup($group);
	foreach ($group['path'] as $k => $g) {
		$ans['groups'][$g]['active'] = true;
	}
	$ans['path'] = $group['path'];
}
return Ans::ret($ans);