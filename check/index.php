<?php
use infrajs\path\Path;
use infrajs\ans\Ans;
use infrajs\load\Load;
use infrajs\rubrics\Rubrics;
use infrajs\access\Access;
use infrajs\router\Router;
use infrajs\template\Template;
use infrajs\rest\Rest;
use infrajs\catalog\Catalog;
use infrajs\catalog\check\Check;

Access::debug(true);

return Rest::get( function () {

		Check::show('root');
	}, "repeats", [function () {
		$data = Check::repeats();
		Check::show('repeats', $data);
	},function ($type, $producer) {
		$data = Check::repeats();

		if (!empty($data['list'][$producer])) {
			$info = $data['list'][$producer];
			$data['list'] = array();
			$data['list'][$producer] = $info;
			$data['count'] = sizeof($info);
		}

		Check::show('repeats', $data);
	}], function () {
		Check::show('404');
});