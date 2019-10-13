<?php
use infrajs\excel\Xlsx;
use infrajs\load\Load;
use infrajs\ans\Ans;
use akiyatkin\showcase\Showcase;
use infrajs\router\Router;

$ans = array();

$m = Ans::GET('m','string','');

$data = Load::loadJSON('-showcase/api/search/?m='.$m);

$ans['childs'] = $data['childs'];

return Ans::ret($ans);
