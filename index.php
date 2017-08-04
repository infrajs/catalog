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
					if ($pos['producer'] == $prod) $poss[] = $list[$k];
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