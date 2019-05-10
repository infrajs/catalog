<?php

use akiyatkin\showcase\Showcase;
use infrajs\ans\Ans;
use infrajs\excel\Xlsx;

$ans = array();
$md = Showcase::initMark($ans);
$ans['root'] = Showcase::getGroup();
Xlsx::runGroups($ans['root'], function &(&$group, $i, &$parent) {
	if ($parent && empty($group['childs']) && !$group['count']) {
		unset($parent['childs'][$i]);
	}
	$r = null;
	return $r;
}, true);

$group = false;
foreach ($md['group'] as $group => $one) break;
if ($group) {
	$group = Showcase::getGroup($group);
	$path = $group['path'];

	Xlsx::runGroups($ans['root'], function &(&$group) use ($path) {
		$r = null;
		if (in_array($group['group_nick'], $path)) {
			$group['active'] = true;
		}
		return $r;
	}, true);
	$ans['path'] = $group['path'];
}
return Ans::ret($ans);