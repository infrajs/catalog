<?php
namespace infrajs\catalog\check;

use infrajs\template\Template;
use infrajs\view\View;
use infrajs\rest\Rest;
use infrajs\load\Load;
use infrajs\path\Path;
use infrajs\sequence\Sequence;
use infrajs\catalog\Catalog;
use infrajs\excel\Xlsx;

class Check {
	public static function show($root = 'root', $data = array()) {
		if ($root == '404') http_response_code(404);
		$data['query'] = Rest::getQuery();
		$data['root'] = Rest::getRoot();
		
		$crumbs = Sequence::right($data['query'], '/');
		$data['crumbs'] = array();		

		$href = $data['root'];
		foreach ($crumbs as $c) {
			$href.='/';
			$href.=$c;
			$data['crumbs'][] = array(
				'href' => $href,
				'title' => $c
			);
		};
		array_unshift($data['crumbs'], array('href' => "-catalog/check", "title" => "Проверки"));
		array_unshift($data['crumbs'], array('href' => "-catalog", "title" => "Сервис каталога"));
		
		$data['crumbs'][sizeof($data['crumbs'])-1]['active'] = true;

	

		$page = Template::parse('-catalog/index.tpl', $data, 'page');
		View::html($page);
		$html = Template::parse('-catalog/check/layout.tpl', $data, $root);
		View::html($html, 'page');
		echo View::html();
	}
	public static function repeats() {
		return Catalog::cache( function () {
			

			$data = Catalog::init();
			$list = array();
			Xlsx::runPoss($data, function($pos) use (&$list){
				$r = null;
				if(!isset($list[$pos['producer']])) $list[$pos['producer']] = array();
				if(!isset($list[$pos['producer']][$pos['article']])) $list[$pos['producer']][$pos['article']] = array();
				$list[$pos['producer']][$pos['article']][] = $pos;
				return $r;
			});



			/*$list = array();
			$dir = Catalog::$conf['dir'];

			array_map(function ($file) use (&$list, $dir) {
				if ($file[0] == '.') return;
				$ext = Path::getExt($file);
				$fdata = Load::nameinfo($file);
				$file = Path::toutf($file);
				if (!in_array($ext, ['xlsx', 'xls'])) return;
				$data = Xlsx::get($dir.$file);
				Xlsx::runPoss( $data, function &($origpos, $i, $group) use ($fdata, &$list) {
					$pos = array(
						'Артикул'=>false,
						'Производитель'=>false
					);
					$pos = array_intersect_key($origpos,$pos);

					if (empty($pos['Артикул'])) $pos['Артикул'] = 'empty';
					$pos['article'] = Path::encode($pos['Артикул']);

					if (empty($pos['Производитель'])) $pos['Производитель'] = $fdata['name'];
					$pos['producer'] = Path::encode($pos['Производитель']);
					
					$pos['group'] = $group['title'];
					$pos['file'] = $fdata['file'];
					//unset($pos['Производитель']);

					if(!isset($list[$pos['producer']])) $list[$pos['producer']] = array();
					if(!isset($list[$pos['producer']][$pos['article']])) $list[$pos['producer']][$pos['article']] = array();
					$list[$pos['producer']][$pos['article']][] = $pos;

					$r = null;
					return $r;
				});
			}, scandir(Path::resolve($dir)));
			*/
			
			$count = 0;
			//$cp = array();
			foreach($list as $prod => $arts) {
				//if (!isset($cp[$prod])) $cp[$prod] = 0;
				foreach($arts as $art => $poss) {
					//$cp[$prod] += sizeof($poss);
					if (sizeof($poss) == 1) unset($list[$prod][$art]);
					else $count ++;
				}
				if (!$list[$prod]) unset($list[$prod]);
			}
			
			$data = array();
			$data['count'] = $count;
			$data['list'] = $list;
			echo '<pre>';
			print_r($list);
			exit;
			return $data;
		});
	}
}