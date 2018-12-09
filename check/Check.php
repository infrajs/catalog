<?php
namespace infrajs\catalog\check;

use infrajs\template\Template;
use infrajs\view\View;
use infrajs\rest\Rest;
use infrajs\load\Load;
use akiyatkin\prices\Prices;
use infrajs\config\Config;
use akiyatkin\fs\FS;
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

		echo Rest::parse('-catalog/check/layout.tpl', $data, $root);

	}
	
	public static function oldpos() {
		$ans = array();
		$data = Catalog::init();
		$list = array();
		$provs = Prices::getList();
		$provs = array_keys($provs);
		$ans['provs'] = $provs;
		Xlsx::runPoss($data, function &($pos) use (&$list) {
			//Если позиция есть в Прайсе1C, Синхронизация = Да
			//Если позиция есть в прайсе поставщика, то prices = true
			$r = null;
			if (!empty($pos['Синхронизация']) && $pos['Синхронизация'] === 'Да') return $r;
			if (!empty($pos['prices'])) return $r;
			$pos['path'] = implode(', ', $pos['path']);
			$list[] = $pos;
			return $r;
		});
		$ans['list'] = $list;
		$ans['result'] = 1;
		return $ans;
	}
	public static function misfiles() {
		$dir = Catalog::$conf['dir'];
		$ans = array();
		$data = Catalog::init();

		$producers = array();
		Xlsx::runPoss($data, function &(&$pos) use (&$producers) {
			$prod = mb_strtolower($pos['producer']);
			$art =  mb_strtolower($pos['article']);
			if (empty($producers[$prod])) $producers[$prod] = array();
			$producers[$prod][$art] = true;
			$r = null;
			return $r;
		});

		
		$mis = array();
		
		Config::scan($dir, function($src, $level) use (&$producers, &$mis){
			//return false - Выходим из этой папки и другие файлы не обрабатываем
			//return true - не заходим вглубь
			$r = explode('/', $src);
			$folder = $r[sizeof($r) - 2];
			if ($level == 0) {
				if ($folder == 'images') return true;
				if ($folder == 'tables') return true;
				if ($folder == 'articles') return true;
				if (preg_match('/.*backup/u',$folder)) return true; 
				$prod = mb_strtolower($folder);
				if (empty($producers[$prod])) {
					$mis[] = $src;
					return true;
				}
				return null;
			}
			if ($level == 1) {
				if ($folder == 'images') return true;
				$prod = mb_strtolower($r[sizeof($r) - 3]);
				$art = mb_strtolower($folder);
				if (empty($producers[$prod][$art])) {
					$mis[] = $src;
					return true;
				}
				return true;
			}	
		});
		if (!empty($mis)) {
			
			$bname = date('ymd').'-backup/';
			FS::mkdir($dir.$bname);
			foreach ($mis as $src) {
				$bsrc = str_replace($dir,'',$src);
				FS::rename($src,$dir.$bname.$bsrc);
			}
		}
		$ans['mis'] = $mis;
		$ans['msg'] = 'Проверка выполнена, все неиспользуемые файлы перемещены в папку backup';
		$ans['result'] = 1;
		return $ans;
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
			return $data;
		});
	}
}