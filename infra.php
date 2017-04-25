<?php
use infrajs\event\Event;
/*
	Файл нужно переопределить в конкретном проекте для конфигурирования каталога
*/

Event::$classes['Catalog'] = function (&$obj) {
	return $obj['title'];
};
