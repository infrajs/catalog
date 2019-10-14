<?php
use infrajs\load\Load;
use infrajs\ans\Ans;

$ans = array();

$m = Ans::GET('m','string','');

$data = Load::loadJSON('-showcase/api/search/?m='.$m);

$ans['childs'] = $data['childs'];

return Ans::ret($ans);
