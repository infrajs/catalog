<?php
namespace infrajs\autoedit;
use infrajs\load\Load;
use infrajs\access\Access;
use infrajs\ans\Ans;

if (!is_file('vendor/autoload.php')) {
	chdir('../../../../');
	require_once('vendor/autoload.php');
}

$ans=array(
	'title'=>'Проверка обработчиков каталога - позиция, группа, производители, рубрики и тп.'
);

$data=Load::loadJSON('*catalog/rubrics.php');
if (!$data) {
	return Ans::err($ans, 'Ошибка rubrics.php');
}

$data=Load::loadJSON('*catalog/producers.php');
if (!$data) {
	return Ans::err($ans, 'Ошибка producers.php');
}

$data=Load::loadJSON('*catalog/stat.php');
if (!$data) {
	return Ans::err($ans, 'Ошибка stat.php');
}


return Ans::ret($ans);
