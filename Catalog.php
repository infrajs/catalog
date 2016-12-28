<?php
namespace infrajs\catalog;
use infrajs\excel\Xlsx;
use infrajs\path\Path;
use infrajs\load\Load;
use infrajs\each\Each;
use infrajs\mark\Mark as Marker;
use infrajs\cache\Cache;
use infrajs\access\Access;
use infrajs\sequence\Sequence;

Path::req('-catalog/Extend.php');
class Catalog
{
	public static $conf= array(
		"pub"=>array("dir", "title"),
		"dir"=>"~catalog/",
		"cache"=>array("~catalog/"),
		"title"=>"Каталог",
		"md"=>array(),
		"filename"=>"Производитель",
		"columns"=>array(),
		"filteroneitem"=>true, //Показывать ли фильтр в котором только один пункт, который true для всей выборке
		"filtershowhard" => array(), //Фильтры, которые всегда показываются
		"filters"=>array(
			"producer"=>array(
				"posid"=>"producer",
				"posname"=>"Производитель",
				"title"=>"Производитель",
				"separator"=>false
			),
			"cost"=>array(
				"posid"=>"Цена",
				"posname"=>"Цена", //Можно ли писать комменты
				"title"=>"Цена",
				"separator"=>false
			)
		)
	);
	public static function init()
	{
		return self::cache('cat_init', function () {
			$conf = Catalog::$conf;
			$columns = array_merge(array("Наименование","Файлы", "Артикул","Производитель","Цена","Описание","Скрыть фильтры в полном описании"),$conf['columns']);
			$data = &Xlsx::init($conf['dir'], array(
				'more' => true,
				'Имя файла' => $conf['filename'],
				'Известные колонки'=>$columns
				)
			);
			
			//Xlsx::runGroups($data, function (&$gr) {
			//	$gr['data']=array_reverse($gr['data']); // Возвращает массив с элементами в обратном порядке
			//});

			Extend::init($data);

			return $data;
		});
	}
	public static function getProducer(&$producer){
		$sproducer = mb_strtolower($producer);
		$pos = Catalog::cache(__FILE__.'getProducer', function &($sproducer){
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
		return Catalog::cache('getGroup', function &($group){
			$data=Catalog::init();
			if ($group) $data=Xlsx::runGroups($data, function &($gr) use($group) {
				if($gr['title']==$group)return $gr;
				$r = null; return $r;
			});
			unset($data['childs']);
			unset($data['data']);
			return $data;
		}, array($group));
	}
	/*
	* getParams Собирает в простую структуру все параметры и возможные значения фильтров для указанной группы
	*/
	public static function getParams($group = false){
		return Catalog::cache(__FILE__.'getParams', function &($group){
			$poss = Catalog::getPoss($group);
		
			$params = array();//параметры
			//ПОСЧИТАЛИ COUNT
			$count = sizeof($poss); //количество позиций
			$parametr = array(
				'posname' => null, //Артикул - имя свойства в позиции с именем
				'posid' => null, //article - имя свойства в позиции с id 
				'mdid' => null, //art - имя в массиве параметров
				'title' => null, //Уникальный Артикул для названия блока
				'more' => null, 
				'separator' => ',',
				'count' => 0,
				'group' => false, //Группа параметра для расположения рядом
				'filter' => 0,
				'search' => 0,
				'option' => array()
			);
			$option = array(
				'id' => null,
				'title' => null,
				'count' => 0,
				'filter' => 0,
				'search' => 0
			);
			//more берутся все параметры, а из main только указанные, расширенные config.catalog.filters
			$main = Catalog::$conf['filters'];
			foreach ($main as $k => $prop) {
				if (!empty($prop['more'])) continue;
				$prop['mdid']=$k;
				$params[$k] = array_merge($parametr, $prop);
			}

			foreach ($poss as &$pos) {
				foreach ($main as $k=>$prop) {
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
					
					if (preg_match("/[:]/", $val)) continue;//Зачем, после : указывается парамтр?
					if (!Xlsx::isSpecified($val)) continue;
					
					$r=false;
					if($prop['separator']){
						$arval=explode($prop['separator'], $val);
						$arname=explode($prop['separator'], $name);
					}else{
						$arval=array($val);
						$arname=array($name);
					}
					foreach($arval as $i => $value){
						$idi = Path::encode($value);
						$id=$idi;//mb_strtolower($idi);
						if (!Xlsx::isSpecified($id)) continue;
						if (!isset($params[$k]['option'][$id])) {
							$params[$k]['option'][$id] = array_merge($option, array(
								'id' => $idi,
								'title' => $arname[$i]
							));
						}
						$r=true;
						$params[$k]['option'][$id]['count']++;
					}
					if ($r)	$params[$k]['count']++;//Позиций с этим параметром
				}
				
				if (!empty($pos['more'])) {
					foreach($pos['more'] as $k=>$val){
						if (preg_match("/[:]/", $val)) continue;
						if (preg_match("/[:]/", $k)) continue;
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
						$prop=$params[$k];
						$r=false;
						
						if($prop['separator']){
							$arval=explode($prop['separator'], $val);
						}else{
							$arval=array($val);
						}
						foreach($arval as $value){
							$idi = Path::encode($value);
							//$id=mb_strtolower($idi);
							$id = $idi;
							if (!Xlsx::isSpecified($id)) continue;
							$r=true;
							if (!isset($params[$k]['option'][$id])) {
								$params[$k]['option'][$id]=array_merge($option, array(
									'id' => $idi,
									'title' => trim($value)
								));
							}
							$params[$k]['option'][$id]['count']++;
						}
						if ($r) $params[$k]['count']++;
					}
				}
			}

			foreach ($main as $k=>$prop) {
				if (empty($prop['more'])) continue;
				if (empty($params[$k])) continue;
				$prop['mdid'] = $k;
				$params[$k] = array_merge($prop, $params[$k]);
			}
			uasort($params,function ($p1, $p2) {
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
		}, array($group), isset($_GET['re']));
	}
	public static function getPoss($mdgroup){
		if ($mdgroup) foreach ($mdgroup as $group=>$v) break;
		else $group = false;
		
		return Catalog::cache('getPoss', function &($group){
			$data=Catalog::init();
			if ($group) $data=Xlsx::runGroups($data, function &($gr) use($group) {
				if ($gr['title']==$group) return $gr;
				$r = null; return $r;
			});
			$poss=array();
			Xlsx::runPoss($data, function &(&$pos) use (&$poss) {
				$poss[]=&$pos;
				$r = null; return $r;
			});
			
			return $poss;
		}, array($group));
	}
	public static function nocache($md) {
		$mdnocache=array_diff_key($md, array_flip(array("sort", "reverse", "count")));
		return $mdnocache;
	}
	public static function sort(&$poss, $md) {
		if ($md['sort']) {

			if ($md['sort']=='name') {
				usort($poss, function ($a, $b) {
					$a = $a['Наименование'];
					$b = $b['Наименование'];
					return strcasecmp($a, $b);
				});
			} else if ($md['sort']=='art') {
				usort($poss, function ($a, $b) {
					$a=$a['Артикул'];
					$b=$b['Артикул'];
					return strcasecmp($a, $b);
				});
			} else if ($md['sort']=='cost') {
				usort($poss, function ($a, $b) {
					$a=$a['Цена'];
					$b=$b['Цена'];
					if ($a == $b) return 0;
					return ($a < $b) ? 1 : -1;
				});
			} else if ($md['sort']=='change') {
				$args=array(Catalog::nocache($md));
				
				$poss=Catalog::cache('change', function($md) use($poss){
					foreach($poss as &$pos) {
						$conf = Catalog::$conf;
						$dir = Path::theme($conf['dir'].$pos['producer'].'/'.$pos['article'].'/');
						if (!$dir) {
							$dir = Path::theme($conf['dir']);
							$pos['time']=0; //filemtime($dir);
						} else {
							$pos['time']=filemtime($dir);
							array_map(function ($file) use (&$pos, $dir) {
								if ($file{0}=='.') {
									return;
								}
								$t=filemtime($dir.$file);
								if ($t>$pos['time']) {
									$pos['time']=$t;
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
			}
		}
		if ($md['reverse']) {
			$poss=array_reverse($poss);
		}
	}
	public static function getGroups($list, $now = false) {
		//Groups
		

		$subgroups = Catalog::cache('getGroups', function () {
			//Микро вставка всё ради того чтобы не пользоваться $data на этом уровне
			//данный кэш один для любой страницы каталога
			$subgroups=array();
			$data = Catalog::init();
			Xlsx::runGroups($data, function &($group) use (&$subgroups) {
				$r = null;
				if (empty($group['childs'])) return $r;
				$subgroup=array();
				array_walk($group['childs'], function ($g) use (&$subgroup) {
					$subgroup[]=array('title'=>$g['title'],'name'=>$g['name']);
				});
				$subgroups[$group['title']]=$subgroup;
				return $r;
			});
			return $subgroups;
		});
		
		$groups=array();
		$path = array();
		foreach ($list as &$pos) {
			$path = $pos['path'];
			
			foreach ($list as &$pos) {
				foreach ($pos['path'] as $v) {
					if (!isset($groups[$v])) {
						$groups[$v]=array('pos'=>$pos, 'count'=>0);
					};
					$groups[$v]['count']++;
				}
				$rpath=array();
				foreach ($path as $k => $p) {
					if ($pos['path'][$k]==$p) {
						$rpath[$k]=$p;
					} else {
						break;
					}
				}
				$path=$rpath;
			}
			break;
		}
		
		if (!sizeof($path)) {
			$conf=Catalog::$conf;
			if (!empty($subgroups[$conf['title']])) {
				$groupchilds = $subgroups[$conf['title']];
			} else {
				$groupchilds = array();
			}
		} else {
			$g=$path[sizeof($path)-1];
			if (isset($subgroups[$g])) {
				$groupchilds=$subgroups[$g];
			} else {
				if(!$now||$now!=$g){
					$groupchilds=array(array("name" => $g,"title" => $g));
				} else {
					$groupchilds=false;
				}
			}
		}
		$childs=array();
		if ($groupchilds) {
			foreach ($groupchilds as $g) {
				if (empty($groups[$g['title']])) continue;
				$pos=Catalog::getPos($groups[$g['title']]['pos']);
				$pos=array('article'=>$pos['article'],'producer'=>$pos['producer'],'images'=>$pos['images']);
				$childs[]=array_merge($g, array('pos'=>$pos,'count'=>$groups[$g['title']]['count']));
			}
		}
		return $childs;
	}
	public static function searchTest($pos, $v) {
		$str=$pos['Артикул'];
		$str.=' '.implode(' ', $pos['path']);
		$str.=' '.$pos['article'];
		$str.=' '.$pos['Наименование'];
		$str.=' '.$pos['Производитель'];
		$str.=' '.$pos['producer'];
		$str.=' '.$pos['Описание'];
		
		if (!empty($pos['more'])) {
			$str.=' '.implode(' ', $pos['more']);
			$str.=' '.implode(' ', array_keys($pos['more']));
		}
		$str=mb_strtolower($str);
		foreach ($v as $s) {
			if (mb_strrpos($str, $s)===false) {
				return false;
			}
		}
		return true;
	}
	public static function cache($name, $call, $args = array(), $re = null)
	{
		if (is_null($re)) $re=isset($_GET['re']);
		$conf=Catalog::$conf;
		return Cache::exec($conf['cache'], 'cat-'.$name, $call, $args, $re);
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
			$ar=array_fill(0, $pages+1, 1);
			$ar=array_keys($ar);
			array_shift($ar);
		} else {
			$plen=$plen-1;
			$lside=$plen/2+1;//Последняя цифра после которой появляется переход слева
			$rside=$pages-$lside-1;//Первая цифра после которой справа появляется переход
			$islspace=$page>$lside;
			$isrspace=$page<$rside+2;
			$ar=array(1);
			if ($isrspace&&!$islspace) {
				for ($i = 0; $i < $plen-2; $i++) {
					$ar[]=$i+2;
				}
				$ar[]=0;
				$ar[]=$pages;
			} else if (!$isrspace&&$islspace) {
				$ar[]=0;
				for ($i=0; $i<$plen-1; $i++) {
					$ar[]=$pages-$plen/2+$i-3;
				}
			} else if ($isrspace&&$islspace) {
				$nums=$plen/2-2;//Количество цифр показываемых сбоку от текущей когда есть $islspace далее текущая
				$ar[]=0;
				for ($i=0; $i<$nums*2+1; $i++) {
					$ar[]=$page-$plen/2+$i+2;
				}
				$ar[]=0;
				$ar[]=$pages;
			}
		}
		
		Each::exec($ar, function &(&$num) use ($page) {
			$n = $num;
			$num = array('num'=>$n,'title'=>$n);
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
		$prev=array('num'=>$page-1,'title'=>'&laquo;');
		if ($page<=1) {
			$prev['empty']=true;
		}

		array_unshift($ar, $prev);
		$next=array('num'=>$page+1,'title'=>'&raquo;');
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
	public static function initMark(&$ans = array())
	{
		$mark = new Marker('~auto/.catalog/');
		foreach (Catalog::$list as $name => $v) {
			$mark->add($name, $v['fndef'], $v['fncheck']);
		}
		$m = Path::toutf(Sequence::get($_GET, array('m')));
		$mark->setVal($m);
		$md = $mark->getData();
		$ans['m'] = $mark->getVal();
		$ans['md'] = $md;
		return $md;
	}
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

		foreach($params as $prop){

			if ($prop['more']) {
				if (empty($md['more'])) continue; //Filter more
				if (empty($md['more'][$prop['mdid']])) continue; //Filter more
				
				

				$valtitles = array();
				$val = $md['more'][$prop['mdid']];
				foreach ($val as $value => $one) $valtitles[$value] = $value;

				$filter = array(
					'title' => $prop['title'], 
					'name' => Sequence::short(array('more', Catalog::urlencode($prop['mdid'])))
				);
				$poss = array_filter($poss, function ($pos) use ($prop, $val, &$valtitles) {
					foreach ($val as $value => $one) {
						
						if (isset($pos['more'])) $more = $pos['more'];
						else $more = array();

						if (isset($more[$prop['posid']])) $option = $more[$prop['posid']];
						else $option = null;

						if ($value === 'yes' && Xlsx::isSpecified($option)) return true;
						if ($value === 'no' && !Xlsx::isSpecified($option)) return true;
						
						if (isset($more[$prop['posname']])) $titles = $more[$prop['posname']];
						else $titles = null;

						if ($prop['separator']) {
							$option=explode($prop['separator'], $option);
							$titles=explode($prop['separator'], $titles);
						} else {
							$option=array($option);
							$titles=array($titles);
						}

						foreach($option as $k=>$opt){
							$id=Path::encode($opt);
							if (strcasecmp($value, $id)==0) {
								$valtitles[$value]=$titles[$k];
								return true;
							}
						}
					}
					return false;
				});
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
				
				
			} else {
				if (empty($md[$prop['mdid']])) continue;
				$valtitles = array();
				$val = $md[$prop['mdid']];
				foreach ($val as $value => $one) $valtitles[$value] = $value;

				$filter = array(
					'title' => $prop['title'], 
					'name' => Sequence::short(array(Catalog::urlencode($prop['mdid'])))
				);

				$poss = array_filter($poss, function ($pos) use ($prop, $val, &$valtitles) {
					foreach($val as $value => $one) {
						
						
						$option = Sequence::get($pos, array($prop['posid']));
						$titles = Sequence::get($pos, array($prop['posname']));
						
						if ($value === 'yes' && Xlsx::isSpecified($option)) return true;
						if ($value === 'no' && !Xlsx::isSpecified($option)) return true;

						if ($prop['separator']) {
							$option=explode($prop['separator'], $option);
							$titles=explode($prop['separator'], $titles);
						} else {
							$option=array($option);
							$titles=array($titles);
						}
						foreach($option as $k=>$opt){
							$id=Path::encode($opt);
							if (strcasecmp($value, $id)==0) {
								$valtitles[$value]=$titles[$k];
								return true;
							}
						}
					}
					return false;
				});
				if (!empty($val['no'])) {
					unset($val['no']);
					$val['Не указано']=1;
				}
				if (!empty($val['yes'])) {
					unset($val['yes']);
					$val['Указано']=1;
				}

				$filter['value'] = implode(', ', array_values($valtitles));
				$filters[] = $filter;
			}
		}
		//Filter group
		$key='group';
		if (!empty($md[$key])) {
			$title='Группа';
			$val=$md[$key];
			$filter = array('title'=>$title, 'name'=>Sequence::short(array(Catalog::urlencode($key))));

			

			$poss=array_filter($poss, function ($pos) use ($key, $val) {
				$prop=$pos[$key];
				foreach ($val as $value => $one) {
					if ($value === 'yes') return true;
					foreach($pos['path'] as $path){
						if ((string)$value === $path) return true;
					}
				}
				return false;
			});
			if (!empty($val['no'])) {
				unset($val['no']);
				$val['Не указано']=1;
			}
			if (!empty($val['yes'])) {
				unset($val['yes']);
				$val['Указано']=1;
			}
			$filter['value']=implode(', ', array_keys($val));
			if ($md['search']) $filters[]=$filter;
		}
		//Filter search
		if (!empty($md['search'])) {
			$v = preg_split("/\s+/", mb_strtolower($md['search']));
			foreach($v as $i => $s) {
				$v[$i] = preg_replace("/ы$/","",$s);
			}
			$poss=array_filter($poss, function ($pos) use ($v) {
				return Catalog::searchTest($pos, $v);
			});
			$filters[]=array(
				'title'=>'Поиск',
				'name'=>'search',
				'value'=>$md['search']
			);
		}
		//Extend::filtering($poss, $md, $filters);
		return $filters;
	}
	public static function option($values, $count, $search, $showhard = false){
		foreach ($values as $value => $s) break;
		$opt = array('type' => '', 'values' => $values);
		$min = $value;
		$max = $value;
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
		if (!$showhard && $count > $yesall * 10) { //Если отмеченных менее 10% то такие опции не показываются
			return false;
		}
		
		$type = false;
		foreach ($opt['values'] as $val => $c) { //Слайдер
			if (is_string($val)) {
				$type = 'string';
				break;
			}
			if ($val < $min) $min = $val;
			if ($val > $max) $max = $val;
		}
		if (!$type) {
			$len = sizeof($opt['values']);
			if ($len>5) { //Слайдер
				$opt['min'] = $min;
				$opt['max'] = $max;
				$type = 'slider';
				unset($opt['values']);
			} else {
				$type = 'string';
			}
		}
		
		$opt['type'] = $type;
	
		if($opt['type'] == 'string') {
			$saved_values = $opt['values'];
			if (sizeof($opt['values']) > 30) {
				$opt['values']=array();
				if (!$showhard) return false;
			}
			if ($showhard) {	
				foreach ($showhard as $show => $one) {
					$title = $show;
					//$show = mb_strtolower($show);
					if ($show == 'yes') continue;
					if ($show == 'no') continue;
					if (!empty($opt['values'][$show])) continue;
					
					$opt['values'][$show] = $saved_values[$show];//array('id'=>$show, 'title'=>$title);
				}
			}
			/*foreach($opt['values'] as $v){//Когда всех значений по 1
				if($v!=1){
					//Единичные опции
					$opt['values']=array();
					break;
				}
			}*/
			//if(sizeof($opt['values'])>10){
				//$opt['values_more']=array_slice($opt['values'],6,sizeof($opt['values'])-6,true);
				//$opt['values']=array_slice($opt['values'],0,6,true);
			//}
		}

		if($opt['type']=='string'){
			usort($opt['values'], function ($v1, $v2){
				//if ($v1['filter']>$v2['filter']) return -1;
				//if ($v1['filter']<$v2['filter']) return 1;
				if ($v1['count']>$v2['count']) return -1;
				if ($v1['count']<$v2['count']) return 1;
			});
		}
		/*if(sizeof($opt['values'])==1){
			if($opt['yes']==$count){//Значение есть у всех позиций и только один вариант
				unset($params[$k]);
				continue;
			}
		}*/
		if (empty($opt['values']) && $opt['type'] != 'slider') {
			if ($opt['count'] == $count){//Слишком много занчений но при этом у всех позиций они указаны и нет no yes
				return false;
			}
		}
		$opt['nosearch'] = $search - $opt['search']; //из общего количества вычесть количество указанных
		$opt['nocount'] = $count - $opt['count']; //из общего количества вычесть количество с yes
		return $opt;
	}
	public static function getPos(&$pos){
		$args=array($pos['producer'],$pos['article']);
		return Access::cache('Catalog::getPos', function() use($pos){
			
			Xlsx::addFiles(Catalog::$conf['dir'], $pos);

			$files=explode(',', @$pos['Файлы']);
			foreach ($files as $f) {
				if (!$f) {
					continue;
				}
				$f=trim($f);
				Xlsx::addFiles(Catalog::$conf['dir'], $pos, $f);
			}

			$files=array();
			foreach ($pos['files'] as $f) {
				if (is_string($f)) {
					$f = Path::theme($f); //убрали звездочку
					$d=Load::srcInfo(Path::toutf($f));
				} else {
					$d=$f;
					$f=$d['src'];
				}

				$d['size']=round(filesize(Path::tofs($f))/1000000, 2);
				if (!$d['size']) {
					$d['size']='0.01';
				}
				$d['src']=Path::pretty($d['src']);
				$files[]=$d;
			}
			$pos['files']=$files;
			if ($pos['texts']) {
				foreach ($pos['texts'] as $k => $t) {
					$pos['texts'][$k]=Load::loadTEXT('-doc/get.php?src='.$t);
				}
			}
			return $pos;
		},$args);
	}
	public static function search($md, &$ans=array()) {
		$args = array(Catalog::nocache($md));
		$res = Catalog::cache('search.php filter list', function ($md) {

			$ans['list']=Catalog::getPoss($md['group']);
			//ЭТАП filters list
			$ans['filters']=Catalog::filtering($ans['list'], $md);
			$now = null;
			foreach ($md['group'] as $now => $one) break;

			$ans['childs'] = Catalog::getGroups($ans['list'], $now);
			
			$ans['count']=sizeof($ans['list']);
			
			return $ans;
		}, $args, isset($_GET['re']));
		$ans=array_merge($ans, $res);
		
		return $ans;
	}
}


Catalog::add('count', function () {
	return 10;
}, function (&$val) {
	$val = (int) $val;
	if ($val < 1 || $val > 1000) return false;
	return true;
});
Catalog::add('reverse', function () {
	return false;
}, function (&$val) {
	$val = !!$val;
	return true;
});
Catalog::add('sort', function () {
	return '';
}, function ($val) {
	return in_array($val, array('name','art', 'group','change','cost'));
});
Catalog::add('producer', function () {
	return array();
}, function (&$val) {
	if (!is_array($val)) return false;
	$val = array_filter($val);
	$producers = array_keys($val);
	$producers = array_filter($producers, function (&$value) {
		if (in_array($value,array('yes','no'))) return true;
		if (Catalog::getProducer($value)) return true;
		return false;
	});
	$val = array_fill_keys($producers, 1);
	return !!$val;
});

Catalog::add('group', function () {
	return array();
}, function (&$val) {
	if (!is_array($val)){
		$s = $val;
		$val = array();
		$val[$s] = 1;
	}
	$val = array_filter($val);
	$values = array_keys($val);
	$values = array_filter($values, function (&$value) {
		if(in_array($value,array('yes','no'))) return true;
		if(!$value)return false;
		if(!Catalog::getGroup($value))return false;
		return true;
	});
	$val = array_fill_keys($values, 1);
	return !!$val;
});

Catalog::add('search', function () {
	return '';
}, function ($val) {
	return is_string($val);
});

Catalog::add('cost', function () {
	return array();
}, function (&$val) {
	if (!is_array($val)) return false;
	$val = array_filter($val);//Удаляет false значения
	$values = array_keys($val);
	$values = array_filter($values, function (&$val) {
		if(in_array($value, array('yes','no'))) return true;
		if (!$val) return false;
		return true;
	});
	$val = array_fill_keys($values, 1);
	return !!$val;
});
Catalog::add('more', function () {
	return array();
}, function (&$val) {
	if (!is_array($val)) return;
	foreach($val as $k => $v){
		if (!is_array($v)) {
			unset($val[$k]);
		} else {
			foreach($v as $kk=>$vv){		
				if (!$vv) unset($val[$k][$kk]);
			}
			if (!$val[$k]) unset($val[$k]);
		}		
	}
	return !!$val;
});
