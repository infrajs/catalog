<?php
use infrajs\path\Path;
use infrajs\ans\Ans;
use infrajs\load\Load;
use infrajs\rubrics\Rubrics;
use infrajs\access\Access;
use infrajs\router\Router;
use infrajs\nostore\Nostore;
use infrajs\template\Template;
use infrajs\rest\Rest;
use akiyatkin\boo\Once;
use infrajs\catalog\Catalog;

Nostore::on();

return Rest::get([ function () {
		$data = array();
		$data['query'] = Rest::getQuery();
		$data['root'] = Rest::getRoot();
		$data['crumbs'] = array();
		$data['crumbs'][] = array(
			'title' => "Сервис каталога",
			'active' =>true
		);
		echo Template::parse('-catalog/index.tpl', $data);
	},
	"getPoss", function( $t, $group = null ){
		$poss = Catalog::getPoss($group);
		echo sizeof($poss);
	},
	"init", function () {
		$data = Catalog::init();
		
		/*echo '<pre>';
		unset(Once::$items[Once::$lastid]['exec']['result']);
		print_r(Once::$items['062fbe0f303e589637d068012eb392fe']);
		print_r(Once::$items[Once::$lastid]);*/
		//echo '<pre>';
		//print_r($data);
		//exit;
		$res = array();
		$res['size'] = sizeof($data['childs']);
		echo Rest::parse('-catalog/index.tpl', $res, 'INIT');	
	},
	"pos",  [ function ($type) {
			$ans = array();
			$list = Catalog::getPoss();
			$ans['data'] = $list;
			return Ans::ret($ans);
		}, [ function ($type, $prod = false, $art = false) {

				$ans = array();
				$ans['producer'] = $prod;
				$ans['article'] = $art;
				$ans['data'] = false;
				$list = Catalog::getPoss();

				$poss = array();
				foreach ($list as $k => $pos) {
					if ($pos['producer'] == $prod) {
						$poss[] = $list[$k];
					}
				}
				
				$ans['data'] = $poss;
				return Ans::ret($ans);
			}, function ($type, $prod = false, $art = false) {

				$ans = array();
				$ans['producer'] = $prod;
				$ans['article'] = $art;
				$ans['data'] = false;
				$list = Catalog::getPoss();
				
				$poss = array();
				foreach ($list as $k => $pos) {
					if ($pos['producer'] == $prod) $poss[] = $list[$k];
				}
				foreach ($poss as $k => $pos) {
					if ($pos['article'] == $art) {
						$ans['data'] = Catalog::getPos($poss[$k]);
						break;
					}
				}
				return Ans::ret($ans);
			}
		]
	]
]);


/*

$rule2 = [
	function () {
		echo '?';
	},
	"pos", $posrule,
	[
		function () {
			echo '-/?';
		},
		"two", function () {
			echo '-/two/?';
		},
		[
			function () {
				echo '-/-/?';
			},
			"three", function ($one, $two) {
				echo '-/-/three/?';
			},
			"four", function () {
				echo '-/-/four/?';
			},
			function () {
				echo '-/-/-/?';
			}
		]
	]
];*/