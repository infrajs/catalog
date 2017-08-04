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


return Rest::get( function () {

		Check::show('root');
	}, "repeats", [function () {
		$data = Check::repeats();
		Check::show('repeats', $data);
	}], function () {
		Check::show('404');
});