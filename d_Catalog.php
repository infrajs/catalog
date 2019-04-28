<?php
namespace infrajs\catalog;
use infrajs\excel\Xlsx;
use infrajs\path\Path;
use infrajs\load\Load;
use infrajs\each\Each;
use infrajs\mark\Mark as Marker;
use akiyatkin\boo\Cache;
use akiyatkin\boo\MemCache;
use infrajs\once\Once;
use infrajs\event\Event;
use infrajs\config\Config;
use infrajs\access\Access;
use infrajs\sequence\Sequence;
use infrajs\rubrics\Rubrics;
use infrajs\ans\Ans;
use akiyatkin\dabudi\Dabudi;

global $TESTDATA;
$TESTDATA = array();
class Catalog
{
	public static $conf = array();
	public static $data = false; 
	public static function getOptions(){
			$conf = Catalog::$conf;
			$columns = array_merge(array("Наименование","Файлы","Фото","prod2","Артикул","Производитель","Цена","Описание","Скрыть фильтры в полном описании"),$conf['columns']);
			$options = array(
				'root' => $conf['title'],
				'more' => true,
				'Имя файла' => $conf['filename'],
				'Игнорировать имена листов' => $conf['ignorelistname'],
				'listreverse' => $conf['listreverse'],
				'Известные колонки' => $columns
				);
			return $options;
	}
	public static function init()
	{  
		echo '<pre>';
		debug_print_backtrace();
		exit;
		//все данные
		return Catalog::cacheF(function () {
			$options = Catalog::getOptions();
			$conf = Catalog::$conf;
			$data = Xlsx::init([$conf['dir'], $conf['dir'].'tables/'], $options);
			//Xlsx::runGroups($data, function (&$gr) {
			//	$gr['data'] = array_reverse($gr['data']); // Возвращает массив с элементами в обратном порядке
			//});
			Event::tik('Catalog.oninit');
			Event::fire('Catalog.oninit', $data);
			return $data;
		});
	}
	public static function getProducer($producer){
		$sproducer = mb_strtolower($producer);
		//'производители'
		$pos = Catalog::cache( function &($sproducer){
			$data = Catalog::init();
			return Xlsx::runPoss($data, function &($pos) use ($sproducer) {
				if (mb_strtolower($pos['producer']) == $sproducer) return $pos;
				$r = null; return $r;
			});
		}, array($sproducer));
		$producer = $pos['producer'];
		return $pos['Производитель'];
	}
	public static function getGroup($group){
		//'группы'
		return MemCache::func( function ($group){
			$data = Catalog::init();
			if ($group) $data = Xlsx::runGroups($data, function &($gr) use ($group) {
				if ($gr['title'] == $group) return $gr;
				if ($gr['id'] == $group) return $gr;
				$r = null; return $r;
			});
			if (!$data) return array();
			$data['childscount'] = sizeof($data['childs']);
			$data['datacount'] = sizeof($data['data']);
			unset($data['childs']);
			unset($data['data']);
			return $data;
		}, array($group));
	}

	/*
	* getParams Собирает в простую структуру все параметры и возможные значения фильтров для указанной группы
	*/
	public static function getParams($group = false){
		//'все параметры'

		return Catalog::cache(function &($group){
			$poss = Catalog::getPoss($group);

			if (!$group) Cache::setTitle('Корень');
			$params = array();//параметры
			//ПОСЧИТАЛИ COUNT
			$count = sizeof($poss); //количество позиций
			$parametr = array(
				'posname' => null, //Артикул - имя свойства в позиции с именем
				'posid' => null, //article - имя свойства в позиции с id 
				'mdid' => null, //art - имя в массиве параметров
				'title' => null, //Уникальный Артикул для названия блока
				'more' => null, 
				'separator' => ', ',
				'count' => 0,
				'group' => false, //Группа параметра для расположения рядом
				'filter' => 0,
				'search' => 0,
				'option' => array()
			);
			/*$option = array(
				'id' => null, //id значения для передачи в адресе
				'title' => null, //тайтл иллюстрирующий именно это значение
				'count' => 0, //Количество этого значения без учёта всех фильтров
				'search' => 0, //Количество этого значения в отфильтрованном списке позиций
				'filter' => 0 //Количество этого значения без учёта текущего значения этого параметра
			);*/
			//count - сколько всего в группе позиций с указанным параметром
			//search - сколько всего найдено с md
			//filter - сколько найдено если данный параметр не указана в md

			//more берутся все параметры, а из main только указанные, расширенные config.catalog.filters
			$main = Catalog::$conf['filters'];

			foreach ($main as $k => $prop) {
				if (!empty($prop['more'])) continue;
				$prop['mdid'] = $k;
				$params[$k] = array_merge($parametr, $prop);
			}
			$ignores = [];
			foreach ($poss as $tpos) {
				$items = Xlsx::getItemsFromPos($tpos);
				foreach ($items as $pos) {
					foreach ($main as $k => $prop) {
						if (isset($ignores[$k])) continue;
						if (!empty($prop['more'])) continue;
						$prop = $params[$k];
						if (isset($pos[$prop['posid']])) {
							$val = $pos[$prop['posid']];
						} else {
							$val = null;
						}
						if (isset($pos[$prop['posname']])) {
							$name=$pos[$prop['posname']];
						} else {
							$name = null;
						}
						
						//if (preg_match("/[:]/", $val)) continue;//Зачем, после : указывается парамтр?
						if (!Xlsx::isSpecified($val)) continue;
						
						$r = false;
						if ($prop['separator']) {
							$arval = explode($prop['separator'], $val);
							$arname = explode($prop['separator'], $name);
						} else {
							$arval = array($val);
							$arname = array($name);
						}

						foreach($arval as $i => $value){
							$idi = Path::encode($value);
							$id=$idi;//mb_strtolower($idi);
							if (!Xlsx::isSpecified($id)) continue;
							if (!isset($params[$k]['option'][$id])) {
								$params[$k]['option'][$id] = array(
									'count' => 0, //Количество этого значения без учёта всех фильтров
									'search' => 0, //Количество этого значения в отфильтрованном списке позиций
									'filter' => 0, //Количество этого значения без учёта текущего значения этого параметра
									'id' => $idi,
									'title' => trim($arname[$i])
								);
							}
							$r=true;
							$params[$k]['option'][$id]['count']++;
						}
						
						if ($r) {
							$params[$k]['count']++;//Позиций с этим параметром
							if ($params[$k]['count'] > 50) {
								$ignores[$k] = true;
								unset($params[$k]);
							} else if ($params[$k]['count'] > 20 && $params[$k]['count'] * 0.5 <= sizeof($params[$k]['option'])) {
								//Если совпадений меньше 20%
								$ignores[$k] = true;
								unset($params[$k]);
							}
						}
					}
					if (!empty($pos['more'])) {
						foreach ($pos['more'] as $k => $val) {
							if (isset($ignores[$k])) continue;
							//if (preg_match("/[:]/", $val)) continue;
							//if (preg_match("/[:]/", $k)) continue;
							if (!Xlsx::isSpecified($val)) continue;

							if (!isset($params[$k])) {
								$params[$k] = array_merge($parametr,array(
									'posname' => $k,
									'posid' => $k,
									'mdid' => $k,
									'title' => $k,
									'more' => true
								));
							}
							$prop = $params[$k];
							$r = false;
							
							if ($prop['separator']) {
								$arval=explode($prop['separator'], $val);
							} else {
								$arval = array($val);
							}
							foreach ($arval as $value){
								$idi = Path::encode($value);
								//$id=mb_strtolower($idi);
								$id = $idi;
								if (!Xlsx::isSpecified($id)) continue;
								$r = true;
								if (!isset($params[$k]['option'][$id])) {
									$params[$k]['option'][$id] = array(
										'count' => 0, //Количество этого значения без учёта всех фильтров
										'search' => 0, //Количество этого значения в отфильтрованном списке позиций
										'filter' => 0, //Количество этого значения без учёта текущего значения этого параметра
										'id' => $idi,
										'title' => trim($value)
									);
								}
								$params[$k]['option'][$id]['count']++;
							}
							if ($r) {
								$params[$k]['count']++;
								if ($params[$k]['count'] > 30) {
									$ignores[$k] = true;
									unset($params[$k]);
								}/* else if ($params[$k]['count'] > 20 && $params[$k]['count'] * 0.5 <= sizeof($params[$k]['option'])) {
									//Если совпадений меньше 20%
									$ignores[$k] = true;
									unset($params[$k]);
								}*/
							}
						}
					}
				}
			}
			/*echo '<pre>';
			print_r($params);
			exit;*/
			foreach ($main as $k => $prop) {
				if (empty($prop['more'])) continue;
				if (empty($params[$k])) continue;
				$prop['mdid'] = $k;
				$params[$k] = array_merge($prop, $params[$k]);
			}
			$conf = Config::get('catalog');
			if (!is_array($conf['filtershowhard'])) $conf['filtershowhard'] = array($conf['filtershowhard']);
			$showhard = $conf['filtershowhard'];

			
			uasort($params, function ($p1, $p2) use ($showhard) {
				
				if (in_array($p1['mdid'], $showhard) && in_array($p2['mdid'], $showhard) ) {
					$key1 = array_search($p1['mdid'], $showhard);
					$key2 = array_search($p2['mdid'], $showhard);
					if ($key1 > $key2) return 1;
					else return -1;
				}

				if (in_array($p1['mdid'], $showhard)) return -1;
				if (in_array($p2['mdid'], $showhard)) return 1;
				



				if (!empty($p1['group']) || !empty($p2['group'])) {
					if ($p1['group'] == $p2['group']) return 0;
					if (!empty($p1['group'])) return 1;
					if (!empty($p2['group'])) return -1;
				}

				if ($p1['count'] > $p2['count']) return -1;
				if ($p1['count'] < $p2['count']) return 1;
				return 0;
			});
			
			return $params;
		}, array($group));
	}
	public static function calcParams(&$params, $md, &$ans = array()) {
		//Поиск
		$poss = Catalog::getPoss($md['group']);
		$count = sizeof($poss); //Позиций в группах
		
		$res = Catalog::search($md);
		
		$poss = $res['list'];
		$search = sizeof($poss); //Позиций найдено
		
		$ans['search'] = $search;//Позиций найдено
		$ans['count'] = $count;//Позиций в группе

		foreach ($params as $k => &$prop) {
			if ($prop['more']){
				foreach ($poss as &$pos) {
					Dabudi::runItems($pos, function($pos) use (&$prop) {
						if (!isset($pos['more'][$prop['posid']]) || !Xlsx::isSpecified($pos['more'][$prop['posid']])) return false;
						if ($prop['separator']) {
							$arval = explode($prop['separator'], $pos['more'][$prop['posid']]);
						} else {
							$arval = array($pos['more'][$prop['posid']]);
						}
						$r = false;
						foreach ($arval as $value) {
							$idi = Path::encode($value);
							$id = mb_strtolower($idi);
							if (!Xlsx::isSpecified($id)) continue;
							$r = true;
							$prop['option'][$idi]['search']++;
						}

						if ($r)	$prop['search']++;
						//if (!isset($pos['items']['more'][$prop['posid']])) return false;
					});
				}
			} else {
				foreach ($poss as &$pos){
					if (!isset($pos[$prop['posid']]) || !Xlsx::isSpecified($pos[$prop['posid']])) continue;
					
					if ($prop['separator']) {
						$arval = explode($prop['separator'], $pos[$prop['posid']]);
						$arname = explode($prop['separator'], $pos[$prop['posname']]);
					} else {
						$arval = array($pos[$prop['posid']]);
						$arname = array($pos[$prop['posname']]);
					}

					$r = false;
					foreach ($arval as $i => $value) {
						$idi=Path::encode($value);
						$id=mb_strtolower($idi);

						if (!Xlsx::isSpecified($id)) continue;
						$r = true;
						$params[$k]['option'][$idi]['search']++;
					}
					if ($r)	$params[$k]['search']++;//Позиций с этим параметром
				}
			}

			$params[$k]['nosearch'] = sizeof($poss) - $params[$k]['search'];
		}
		
		//ПОСЧИТАЛИ FILTER как если бы не было выбрано в этой группе md
		foreach ($params as $k => &$prop) {

			if ($prop['more']) {
				$mymd = $md;
			
				$mymd['more'] = array_diff_key($md['more'], array_flip(array($prop['mdid'])));
				
				$res = Catalog::search($mymd);
				$poss = $res['list'];
				
				foreach ($poss as &$pos){
					Dabudi::runItems($pos, function($pos) use (&$prop) {
						if (!isset($pos['more'][$prop['posid']])) return false;
						if (preg_match("/[:]/", $pos['more'][$prop['posid']])) return;
						if (!Xlsx::isSpecified($pos['more'][$prop['posid']])) return;

						$r = false;
						if ($prop['separator']) {
							$arval = explode($prop['separator'], $pos['more'][$prop['posid']]);
						} else {
							$arval = array($pos['more'][$prop['posid']]);
						}
						foreach ($arval as $value){
							$idi = Path::encode($value);
							$id = mb_strtolower($idi);
							if (!Xlsx::isSpecified($id)) continue;
							$r = true;
							$prop['option'][$idi]['filter']++;
						}
						if ($r)	$prop['filter']++;
						//if (!isset($pos['items']['more'][$prop['posid']])) return false;
					});
				}
			} else {
				$mymd = array_diff_key($md, array_flip(array($prop['mdid'])));

				$res = Catalog::search($mymd);
				$poss = $res['list'];
				foreach($poss as &$pos){
					if(!isset($pos[$prop['posid']])) continue;
					if (preg_match("/[:]/", $pos[$prop['posid']])) continue;
					if (!Xlsx::isSpecified($pos[$prop['posid']])) continue;

					$r=false;
					if ($prop['separator']) {
						$arval=explode($prop['separator'], $pos[$prop['posid']]);
					} else {
						$arval=array($pos[$prop['posid']]);
					}
					
					foreach ($arval as $i => $value) {
						$idi = Path::encode($value);
						$id = mb_strtolower($idi);
						if (!Xlsx::isSpecified($id)) continue;
						$r=true;
						$params[$k]['option'][$idi]['filter']++;
					}
					if ($r)	$params[$k]['filter']++;//Позиций с этим параметром
				}
			}
			//У скольки позиций в выборке у которых этот параметр не указан
			$params[$k]['nofilter']=sizeof($poss)-$params[$k]['filter'];//
		}
	}
	public static function getPoss($mdgroup = false){
		if ($mdgroup) foreach ($mdgroup as $group => $v) break;
		else $group = false;
		
		//'позиции группы'
		$poss = Catalog::cache( function ($group){
			$data = Catalog::init();
			
			if ($group) $data = Xlsx::runGroups($data, function &($gr) use($group) {
				if ($gr['title'] == $group) return $gr;
				if ($gr['id'] == $group) return $gr;
				$r = null; return $r;
			});

			$poss = array();
			Xlsx::runPoss($data, function &(&$pos) use (&$poss) {
				$poss[] = $pos;
				$r = null; return $r;
			});
			
			
			return $poss;
		}, array($group));
		return $poss;
	}
	public static function nocache($md) {
		$mdnocache = array_diff_key($md, array_flip(array("sort", "reverse", "count")));
		return $mdnocache;
	}
	public static function sort(&$poss, $md) {
		$arg = array('title' => 'Поиск', 'data' => &$poss, 'md' => $md);
		Event::fire('Catalog.onsort', $arg);
		
		if ($md['sort']) {

			if ($md['sort']=='name') {
				usort($poss, function ($a, $b) {
					$a = @$a['Наименование'];
					$b = @$b['Наименование'];
					return strcasecmp($a, $b);
				});
				if ($md['reverse']) {
					$poss = array_reverse($poss);
				}
			} else if ($md['sort']=='art') {
				usort($poss, function ($a, $b) {
					$a=$a['Артикул'];
					$b=$b['Артикул'];
					return strcasecmp($a, $b);
				});
				if ($md['reverse']) {
					$poss = array_reverse($poss);
				}
			} else if ($md['sort']=='cost') {
				$one = (int) $md['reverse'];
				$one = 1 - $one*2;
				usort($poss, function ($a, $b) use ($one){
					if(!isset($a['Цена'])) return 1;
					if(!isset($b['Цена'])) return -1;
					$a=$a['Цена'];
					$b=$b['Цена'];
					if ($a == $b) return 0;
					return ($a < $b) ? -$one : $one;
				});

			} else if ($md['sort']=='change') {
				$args = array(Catalog::nocache($md));
				
				//'сортировка по изменениям'
				$poss = Catalog::cache( function ($md) use ($poss) {
					foreach($poss as &$pos) {
						$conf = Catalog::$conf;
						$dir = Path::theme($conf['dir'].$pos['producer'].'/'.$pos['article'].'/');
						if (!$dir) {
							$dir = Path::theme($conf['dir']);
							$pos['time']=0; //filemtime($dir);
						} else {
							$pos['time']=filemtime($dir);
							array_map(function ($file) use (&$pos, $dir) {
								if ($file{0} == '.') return;
								$file = Path::tofs($file);
								$t = filemtime($dir.$file);
								if ($t > $pos['time']) {
									$pos['time'] = $t;
								}
							}, scandir($dir));
						}
					}
					usort($poss, function ($a, $b) {
						$a=$a['time'];
						$b=$b['time'];
						if ($a == $b) return 0;
						return ($a < $b) ? 1 : -1;
					});
					return $poss;
				}, $args, isset($_GET['re']));
				if ($md['reverse']) {
					$poss = array_reverse($poss);
				}
			}
		}
	}
	public static function getSubgroups() {
		return Catalog::cache(function () {
			//Микро вставка всё ради того чтобы не пользоваться $data на этом уровне
			//данный кэш один для любой страницы каталога
			$subgroups = array();
			$data = Catalog::init();
				
			Xlsx::runGroups($data, function &($group) use (&$subgroups) {
				$r = null;
				$subgroups[$group['id']] = array(
					'title' => $group['title'], 
					'count' => sizeof(Catalog::getPoss([$group['id'] => 1])),
					'id' => $group['id'], 
					'name' => $group['name']
				);
				if (empty($group['childs'])) return $r;
				$childs = array();
				array_walk($group['childs'], function ($g) use (&$childs) {
					$childs[] = array(
						'title' => $g['title'], 
						'count' => sizeof(Catalog::getPoss([$g['id'] => 1])),
						'name' => $g['name'], 
						'id' => $g['id']
					);
				});
				$subgroups[$group['id']]['childs'] = $childs;
				return $r;
			});
			return $subgroups;
		});
	}
	public static function getGroups($list, $now = false) {
		//Groups
		//'все группы'
	
		$subgroups = Catalog::getSubgroups();

		$groups = array();
		$path = array();
		
		foreach ($list as &$pos) {
			$path = $pos['path'];
			break;
		}

		foreach ($list as &$pos) {
			foreach ($pos['path'] as $v) {
				if (!isset($groups[$v])) {
					$groups[$v] = array('pos' => Catalog::getPos($pos), 'count' => 0);
					$img = Path::theme(Catalog::$conf['dir'].'images/'.$v.'.jpg');
					if(!$img) $img = Path::theme(Catalog::$conf['dir'].'images/'.$v.'.png');
					if ($img) $groups[$v]['img'] = Path::pretty(Path::toutf($img));
					else if(isset($groups[$v]['pos']['images'][0])) {
						$groups[$v]['img'] = $groups[$v]['pos']['images'][0];
					} else {
						$groups[$v]['img'] = false;
					}
				};
				if (empty($groups[$v]['pos']['images'])) {
					$groups[$v]['pos'] = Catalog::getPos($pos);
					if(isset($groups[$v]['pos']['images'][0])) {
						$groups[$v]['img'] = $groups[$v]['pos']['images'][0];
					}
				}
				$groups[$v]['count']++;
			}
			$rpath = array();
			foreach ($path as $k => $p) {
				if ($pos['path'][$k] != $p) break;
				$rpath[$k] = $p;
			}
			$path = $rpath;
		}

		if (!sizeof($path)) {
			$conf = Catalog::$conf;
			if (!empty($subgroups[Path::encode($conf['title'])]['childs'])) {
				$groupchilds = $subgroups[Path::encode($conf['title'])];
			} else {
				$groupchilds = array();
			}
		} else {

			$g = $path[sizeof($path) - 1];
			if (!empty($subgroups[$g]['childs'])) {
				$groupchilds = $subgroups[$g];
			} else {
				if (!$now || $now != $g) {
					$groupchilds = ['childs'=>[$subgroups[$g]]];
				} else {
					$groupchilds = false;
				}
			}
		}
		$childs = array();
		if ($groupchilds) {

			foreach ($groupchilds['childs'] as $g) { //Для правильной сортировки найденных групп.
				if (empty($groups[$g['id']])) continue;
				$pos = $groups[$g['id']]['pos'];
				$posd = array(
					'article' => $pos['article'], 
					'producer' => $pos['producer'], 
					'images' => $pos['images']
				);
				$g['img'] = $groups[$g['id']]['img'];
				if (!empty($subgroups[$g['id']]['childs'])) {
					$g['childs'] = $subgroups[$g['id']]['childs'];
				} else {
					$g['childs'] = array();
				}
				
				foreach ($g['childs'] as $k => $gc) {
					if (!$subgroups[$gc['id']]['count']) {
						unset($g['childs'][$k]);
					}
				}
				$g['childs'] = array_values($g['childs']);
				$childs[] = array_merge($g, array(
					'pos' => $posd, 
					'count' => $groups[$g['id']]['count'])
				);
			}
		}
		
		return $childs;
	}
	public static function setItemRowValue(&$pos) {
		$row = [];
		if (empty($pos['itemrows'])) {
			$pos['itemrow'] = '';
			return;
		}
		//$pos['itemshow'] = [];
		foreach ($pos['itemrows'] as $key => $i) {
			if (isset($pos[$key])) continue;
			$r = $key.': ';
			$r .= $pos['more'][$key];
			$row[] = $r;
			//$pos['itemshow'][] = $key;
		}

		$pos['itemrow'] = implode(', ', $row);

	}
	public static function searchTestItem($pos, $v) {
		$str=$pos['Артикул'];
		$str.=' '.implode(' ', $pos['path']);

		$params = array('article', 'Наименование', 'Производитель', 'producer', 'Описание');
		foreach ($params as $name) {
			if (!isset($pos[$name])) continue;
			$str.=' '.$pos[$name];
		}
		
		if (!empty($pos['more'])) {
			$str.=' '.implode(' ', $pos['more']);
			$str.=' '.implode(' ', array_keys($pos['more']));
		}

		/*if (!empty($pos['items'])) {
			foreach ($pos['items'] as $i => $p) {
				if (isset($p['more'])) {
					$str.=' '.implode(' ', $p['more']);
					unset($p['more']);
				}
				$str.=' '.implode(' ', $p);
			}
		}*/
		$str = mb_strtolower($str);
		foreach ($v as $s) {
			if (mb_strrpos($str, $s)===false) {
				return false;
			}
		}
		return true;
	}
	public static function cache($call, $args = array(), $level = 0)
	{	
		$level++;
		$conf = Catalog::$conf;
		return Cache::func($call, $args, null, null, $level);
		//return MemCache::func($call, $args, array('akiyatkin\boo\Cache','getModifiedTime'), $conf['cache'], $level);
	}
	public static function cacheF($call, $args = array(), $level = 0)
	{
		$level++;
		$conf = Catalog::$conf;
		return Cache::func($call, $args, null, null, $level);
		//return Cache::func($call, $args, array('akiyatkin\boo\Cache','getModifiedTime'), $conf['cache'], $level);
	}
	public static function numbers($page, $pages, $plen = 11)
	{
		//$plen=11;//Только нечётные и больше 6 - количество показываемых циферок
		/*
		$pages=10
		$plen=6

		(1)2345-10
		1(2)345-10
		12(3)45-10
		123(4)5-10
		1-4(5)6-10
		1-5(6)7-10
		1-6(7)8910
		1-67(8)910
		1-678(9)10
		1-6789(10)

		$lside=$plen/2+1=4//Последняя цифра после которой появляется переход слева
		$rside=$pages-$lside-1=6//Первая цифра после которой справа появляется переход
		$islspace=$page>$lside//нужна ли пустая вставка слева
		$isrspace=$page<$rside
		$nums=$plen/2-2;//Количество цифр показываемых сбоку от текущей когда есть $islspace далее текущая


		*/

		if ($pages<=$plen) {
			$ar = array_fill(0, $pages+1, 1);
			$ar = array_keys($ar);
			array_shift($ar);
		} else {
			$plen=$plen-1;
			$lside=$plen/2+1;//Последняя цифра после которой появляется переход слева
			$rside=$pages-$lside-1;//Первая цифра после которой справа появляется переход
			$islspace=$page>$lside;
			$isrspace=$page<$rside+2;
			$ar = array(1);
			if ($isrspace&&!$islspace) {
				for ($i = 0; $i < $plen-2; $i++) {
					$ar[] = $i+2;
				}
				$ar[]=0;
				$ar[] = $pages;
			} else if (!$isrspace&&$islspace) {
				$ar[]=0;
				for ($i=0; $i<$plen-1; $i++) {
					$ar[] = $pages-$plen/2+$i-3;
				}
			} else if ($isrspace&&$islspace) {
				$nums=$plen/2-2;//Количество цифр показываемых сбоку от текущей когда есть $islspace далее текущая
				$ar[]=0;
				for ($i=0; $i<$nums*2+1; $i++) {
					$ar[] = $page-$plen/2+$i+2;
				}
				$ar[]=0;
				$ar[] = $pages;
			}
		}
		
		Each::exec($ar, function &(&$num) use ($page) {
			$n = $num;
			$num = array('num' => $n, 'title' => $n);
			if (!$num['num']) {
				$num['empty']=true;
				$num['num']='';
				$num['title']='&nbsp;';
			}
			if ($n==$page) {
				$num['active']=true;
			}
			$r = null;
			return $r;
		});
		if (sizeof($ar)<2) {
			return false;
		}
		$prev = array('num' => $page-1, 'title' => '&laquo;');
		if ($page<=1) {
			$prev['empty']=true;
		}

		array_unshift($ar, $prev);
		$next = array('num' => $page+1, 'title' => '&raquo;');
		if ($page>=$pages) {
			$next['empty']=true;
		}
		array_push($ar, $next);
		return $ar;
	}
	public static $list = array();
	public static function add($name, $fndef, $fncheck)
	{
		Catalog::$list[$name] = array('fndef' => $fndef, 'fncheck' => $fncheck);
	}
	public static function getDefaultMark() {
		$mark = new Marker('~auto/.catalog/');
		$mark->len = 5;
		foreach (Catalog::$list as $name => $v) {
			$mark->add($name, $v['fndef'], $v['fncheck']);
		}
		return $mark;
	}
	public static function initMark(&$ans = array())
	{
		$val = Ans::GET('val');
		$val = Path::encode(Path::toutf(strip_tags($val)));
		$art = Ans::GET('art');
		if ($val && !$art) {
			$group = Catalog::getGroup($val);
			if (!isset($_GET['m'])) $_GET['m'] = '';
			if ($group) {
				$_GET['m'].=':group::.'.$val.'=1';
			} else {
				$producer = Catalog::getProducer($val);
				if ($producer) {
					$_GET['m'].=':producer::.'.$val.'=1';
				} else {
					$_GET['m'].=':search='.$val;
				}
			}
		}
		$m = Path::toutf(Sequence::get($_GET, array('m')));
		$ar = Once::func( function ($m) {
			$mark = Catalog::getDefaultMark();
			$mark->setVal($m);
			$md = $mark->getData();
			$m = $mark->getVal();	
			return array('md' => $md, 'm' => $m);
		}, array($m));
		$ans['m'] = $ar['m'];
		$ans['md'] = $ar['md'];
		return $ar['md'];
	}
	/*public static function checkMark(&$ans)
	{
		$mark = Catalog::getDefaultMark();
		$mark->setData($ans['md']);
		$ans['m'] = $mark->getVal();
	}*/
	public static function urlencode($str)
	{
		$str = preg_replace("/\+/", "%2B", $str);
		$str = preg_replace("/\s/", "+", $str);
		return $str;
	}
	public static function filtering(&$poss, $md)
	{
		if (!sizeof($poss)) return;
		$params = Catalog::getParams();
		$filters = array();

		foreach ($params as $prop) {
			$valtitles = array();
			$filter = array( 'title' => $prop['title'] );
			if ($prop['more']) {
				if (empty($md['more'])) continue; //Filter more
				if (empty($md['more'][$prop['mdid']])) continue; //Filter more
				$val = $md['more'][$prop['mdid']];
				$filter['name'] = Sequence::short(array('more', Catalog::urlencode($prop['mdid'])));
			} else {
				if (empty($md[$prop['mdid']])) continue;
				$valtitles = array();
				$val = $md[$prop['mdid']];
				$filter['name'] = Sequence::short(array(Catalog::urlencode($prop['mdid'])));
			}
			foreach ($val as $value => $one) {
				if ($value === 'minmax') {
					$r = explode('/', $one);
					if ($r[0] == $r[1]) {
						$valtitles[$value] = $r[0];
					} else {
						$valtitles[$value] = $r[0].' &mdash; '.$r[1];
					}
				} else if ($value === 'no') {
					$valtitles[$value] = 'не указанно';
				} else if ($value === 'yes') {
					$valtitles[$value] = 'указано';
				} else {
					$valtitles[$value] = $value;	
				}
			}

			$fposs = array();
			foreach ($poss as $pos) {
				$items = Xlsx::getItemsFromPos($pos);
				$items = array_filter($items, function ($pos) use ($prop, $val, &$valtitles) {
					if ($prop['more']) {
						if (isset($pos['more'])) $data = $pos['more'];
						else $data = array();
					} else {
						$data = $pos;
					}
						

					foreach ($val as $value => $one) {
						$option = Sequence::get($data, array($prop['posid']));
						$titles = Sequence::get($data, array($prop['posname']));
						
						
						if ($value === 'yes' && Xlsx::isSpecified($option)) return true;
						if ($value === 'no' && !Xlsx::isSpecified($option)) return true;
						
						if ($prop['separator']) {
							$option = explode($prop['separator'], $option);
							$titles = explode($prop['separator'], $titles);
						} else {
							$option = array($option);
							$titles = array($titles);
						}
						foreach ($option as $k => $opt){
							$id = Path::encode($opt);
							if (strcasecmp($value, $id) == 0) {
								$valtitles[$value] = $titles[$k];
								return true;
							}
							if ($value == 'minmax') {
								$r = explode('/', $one);
								if(sizeof($r) == 2) {
									if ($r[0] <= $opt && $r[1] >= $opt) {
										return true;
									}
								}
							}
						}
					}
					return false;
				});
				
				if (!$items) continue;

	
				$items = array_values($items);
				$pos = Xlsx::makePosFromItems($items);
				$fposs[] = $pos;
			}
			/*$poss = array_filter($poss, function (&$pos) use ($prop, $val, &$valtitles) {
				//Нужно найти те позиции которые удовлетворяют условию.
				//Заполнить модель первым вхождением и остальные сохранить в items
				$items = Xlsx::getItemsFromPos($pos);

				$items = array_filter($items, function ($pos) use ($prop, $val, &$valtitles) {
					if ($prop['more']) {
						if (isset($pos['more'])) $data = $pos['more'];
						else $data = array();
					} else {
						$data = $pos;
					}

					foreach ($val as $value => $one) {
						$option = Sequence::get($data, array($prop['posid']));
						$titles = Sequence::get($data, array($prop['posname']));
						
						
						if ($value === 'yes' && Xlsx::isSpecified($option)) return true;
						if ($value === 'no' && !Xlsx::isSpecified($option)) return true;
						
						if ($prop['separator']) {
							$option = explode($prop['separator'], $option);
							$titles = explode($prop['separator'], $titles);
						} else {
							$option = array($option);
							$titles = array($titles);
						}
						foreach ($option as $k => $opt){
							$id = Path::encode($opt);
							if (strcasecmp($value, $id) == 0) {
								$valtitles[$value] = $titles[$k];
								return true;
							}
							if ($value == 'minmax') {
								$r = explode('/', $one);
								if(sizeof($r) == 2) {
									if ($r[0] <= $opt && $r[1] >= $opt) {
										return true;
									}
								}
							}
						}
					}
					return false;
				});
				
				if (!$items) return false;
				
				$items = array_values($items);
				$pos = Xlsx::makePosFromItems($items);
				
				return true;
			});*/

			$poss = array_values($fposs);
			if (!empty($val['no'])) {
				unset($val['no']);
				$val['Не указано'] = 1;	
			}
			if (!empty($val['yes'])) {
				unset($val['yes']);
				$val['Указано'] = 1;
			}
			$filter['value'] = implode(', ', array_values($valtitles));
			$filters[] = $filter;


		}
		
		//Filter group
		$key = 'group';
		$sid = 'gid';
		if (!empty($md[$key])) {
			$title = 'Группа';
			$val = $md[$key];
			$filter = array(
				'title' => $title, 
				'name' => $key
			);

			if (empty($val[Catalog::$conf['title']]) && empty($val[Path::encode(Catalog::$conf['title'])])) {
				
				$poss = array_filter($poss, function ($pos) use ($key, $val, $sid) {
					foreach ($val as $value => $one) {
						if ($value === 'yes') return true;
						if ($pos[$sid] === $value) return true;
						foreach($pos['path'] as $path){
							if ((string)$value === $path) return true;
						}
					}
					return false;
				});
				
			}

			if (!empty($val['no'])) {
				unset($val['no']);
				$val['Не указано'] = 1;
			}
			if (!empty($val['yes'])) {
				unset($val['yes']);
				$val['Указано'] = 1;
			}
			$filter['value'] = implode(', ', array_keys($val));
			if ($md['search']) $filters[] = $filter;
		}
		//Filter search
		if (!empty($md['search'])) {
			$v = preg_split("/[\s\-]+/", mb_strtolower($md['search']));
			foreach($v as $i => $s) {
				$v[$i] = preg_replace("/ы$/","",$s);
			}
			$poss = array_filter($poss, function ($pos) use ($v) {
				return Catalog::searchTestItem($pos, $v);
			});
			$filters[] = array(
				'title' => 'Поиск',
				'name' => 'search',
				'value' => $md['search']
			);
		}
		//Extend::filtering($poss, $md, $filters);
		return $filters;
	}
	public static function option($values, $count, $search, $showhard = false){
		$value = '';
		$conf = Catalog::$conf;
		foreach ($values as $value => $s) break;
		$opt = array('type' => '', 'values' => $values);
		//$min = $value;
		//$max = $value;
		$yes = 0;
		$yesall = 0;
		
		
		/*
			$values массив со всеми возможными занчениями каждого параметра
			каждое значение характеризуется
			count - сколько всего в текущем разделе, определяющего набор фильтров
			search - сколько всего найдено с md
			filter - сколько найдено если данный параметр не указана в md
		*/
		foreach ($opt['values'] as $v => $c) {
			if (Xlsx::isSpecified($v)) {
				$yes += $c['search'];//Сколько найдено
				$yesall += $c['count'];//Сколько в группе
			}
		}

		$opt['search'] = $yes;
		$opt['count'] = $yesall;
		



		if (!$showhard && (($count * ($conf['filterslimitpercent'] / 100)) > $yesall)) { //Если отмеченных менее 10% то такие опции не показываются
			return false;
		}
		
		$type = false;
		foreach ($opt['values'] as $val => $c) {
			
			/*$n = (float) $c['title'];
			if ($c['title'] === "1/3") {
				echo "1/3";
				var_dump($n);
				var_dump($n == $c['title']);
				exit;
			}
			if ($n == $c['title'] && $n != '') continue;*/
			if (is_numeric($c['title'])) continue;

			$type = 'string';
			break;
			
			//if ($val < $min) $min = $val;
			//if ($val > $max) $max = $val;
		}
		if (!$type) {
			$type = 'number';
			/*$len = sizeof($opt['values']);
			$opt['len'] = $len;
			$opt['min'] = $min;
			$opt['max'] = $max;*/
		}
		$opt['type'] = $type;
	
		//if (in_array($opt['type'], array('string', 'number'))) {
		$saved_values = $opt['values'];
		if (sizeof($opt['values']) > $conf['foldwhen']) {
			//$opt['values'] = array();
			//if (!$showhard) return false;
		}
		if (is_array($showhard)) {	
			foreach ($showhard as $show => $one) {
				$title = $show;
				//$show = mb_strtolower($show);
				if ($show == 'yes') continue;
				if ($show == 'no') continue;
				if (!empty($opt['values'][$show])) continue;
				if (empty($saved_values[$show])) {
					continue;
				}
				
				$opt['values'][$show] = $saved_values[$show];//array('id' => $show, 'title' => $title);
			}
		}
		/*foreach($opt['values'] as $v){//Когда всех значений по 1
			if($v!=1){
				//Единичные опции
				$opt['values'] = array();
				break;
			}
		}*/
		//if(sizeof($opt['values'])>10){
			//$opt['values_more'] = array_slice($opt['values'],6,sizeof($opt['values'])-6,true);
			//$opt['values'] = array_slice($opt['values'],0,6,true);
		//}
		//}

		if ($opt['type'] == 'string') {
			usort($opt['values'], function ($v1, $v2){
				//if ($v1['filter']>$v2['filter']) return -1;
				//if ($v1['filter']<$v2['filter']) return 1;
				if ($v1['count'] > $v2['count']) return -1;
				if ($v1['count'] < $v2['count']) return 1;
				if ($v1['title'] > $v2['title']) return -1;
				if ($v1['title'] < $v2['title']) return 1;
			});
		} else if ($opt['type'] == 'number') {
			usort($opt['values'], function ($v1, $v2){
				//if ($v1['filter']>$v2['filter']) return -1;
				//if ($v1['filter']<$v2['filter']) return 1;
				if ($v1['title'] > $v2['title']) return 1;
				if ($v1['title'] < $v2['title']) return -1;
			});
		}
		if (empty($opt['values']) && $opt['type'] != 'slider') {
			if ($opt['count'] == $count){ //Слишком много занчений но при этом у всех позиций они указаны и нет no yes
				return false;
			}
		}
		$opt['nosearch'] = $search - $opt['search']; //из общего количества вычесть количество указанных
		$opt['nocount'] = $count - $opt['count']; //из общего количества вычесть количество с yes
		return $opt;
	}
	/**
	 * Добавляем к позиции картинки и файлы
	 **/
	public static function &getPos(&$pos) {
		$args = array($pos['producer'], $pos['article'], $pos['id']);
		$arr = Catalog::cache( function($prod, $art, $id) use ($pos) {
			$pos['images'] = array();
			$pos['texts'] = array();
			$pos['files'] = array();
			$pos['video'] = array();
			Cache::addCond(['akiyatkin\\boo\\Cache','getModifiedTime'],[Catalog::$conf['dir']]);
			if (!empty($pos['Файлы'])) {
				$list = explode(', ', $pos['Файлы']);	
				foreach ($list as $f) {
					if (!$f) continue;
					$f = trim($f);
					Xlsx::addFiles(Catalog::$conf['dir'], $pos, $f);
				}
			}

			Xlsx::addFiles(Catalog::$conf['dir'], $pos);

			$files = array();
			foreach ($pos['files'] as $f) {
				if (is_string($f)) {
					$f = Path::theme($f); //убрали звездочку
					$d = Load::srcInfo(Path::toutf($f));
				} else {
					$d = $f;
					$f = Path::theme($d['src']);
				}

				$d['size'] = round(filesize(Path::tofs($f))/1000000, 2);
				if (!$d['size']) $d['size'] = '0.01';
				$d['src'] = Path::pretty($d['src']);
				$files[] = $d;
			}

			$pos['files'] = $files;
			if ($pos['texts']) {
				foreach ($pos['texts'] as $k => $t) {
					$pos['texts'][$k] = Rubrics::article($t);
				}
			}
			Catalog::setItemRowValue($pos);
			
			Catalog::searchImages($pos, $prod, $art);
			if (isset($pos['prod2'])) {
				Catalog::searchImages($pos, $pos['prod2'], $art);
			}
			
			return $pos;
		}, $args);
		
		$pos['itemrow'] = $arr['itemrow']; 
		$pos['images'] = $arr['images'];
		$pos['texts'] = $arr['texts'];
		$pos['files'] = $arr['files'];
		$pos['video'] = $arr['video'];
		return $pos;
	}
	public static function searchImages(&$pos, $prod, $art) {
		$dir = Catalog::$conf['dir'].$prod.'/images/';
		$images = Catalog::getIndex($dir);
		if (isset($pos['Фото'])) {
			$key = mb_strtolower(Path::encode($pos['Фото']));
			if (isset($images[mb_strtolower($key)])) $pos['images'] = array_merge($images[mb_strtolower($key)], $pos['images']);
			if (isset($images[mb_strtolower($prod.'-'.$key)])) $pos['images'] = array_merge($images[mb_strtolower($prod.'-'.$key)], $pos['images']);
		}
		if (isset($images[mb_strtolower($art)])) $pos['images'] = array_merge($images[mb_strtolower($art)], $pos['images']);
		if (isset($images[mb_strtolower($prod.'-'.$art)])) $pos['images'] = array_merge($images[mb_strtolower($prod.'-'.$art)], $pos['images']);
	}
	public static function getIndex($dir) {
		if (!Path::theme($dir)) return array();
		return Access::func( function ($dir) {
			$list = array();
			Config::scan($dir, function ($src, $level) use (&$list) {
				$fd = Load::pathInfo($src);
				if (!in_array($fd['ext'], array('jpg', 'png', 'jpeg'))) return;
				$name = $fd['name'];
				$p = explode(', ',$name);
				foreach ($p as $name) {
					$name = preg_replace("/_\d*$/", '',$name);
					$name = preg_replace("/\s*\(\d*\)*$/", '',$name);
					$name = mb_strtolower(Path::encode($name));
					if (!$name) continue;
					if (empty($list[$name])) $list[$name] = array();
					$list[$name][] = $src;
				}
			}, true);
			return $list;
		}, array($dir));
	}
	public static function search($md, &$ans = array()) {
		$args = array(Catalog::nocache($md));
		//'поиск',

		$res = Once::func( function &($md) {
			$ans = array();
			$ans['list'] = Catalog::getPoss($md['group']);

			//if (sizeof($ans['list']) > 1000) $ans['list'] = array();
			//ЭТАП filters list
			//echo '<pre>'; print_r($ans['list']);
			
			$ans['filters'] = Catalog::filtering($ans['list'], $md);
			$now = null;
			foreach ($md['group'] as $now => $one) break;

		//	if ($now) Cache::setTitle($now);
		//	else Cache::setTitle('Корень');
			$ans['childs'] = Catalog::getGroups($ans['list'], $now);
			$ans['count'] = sizeof($ans['list']);
			
			return $ans;
		}, $args);
		
		$ans = array_merge($ans, $res);
		
		
		
		
		return $ans;
	}
}