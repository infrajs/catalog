{root:}
	
	<h1>REST сервис</h1>
	<ul>
		<li>JSON <a href="/{root}/pos">{root}pos/{{producer}}/{{article}}/{{index}}</a></li>
		<li>HTML <a href="/{root}/check">Проверить каталог</a></li>
		<li>HTML <a href="/{root}/init">Данные каталога</a></li>
	</ul>

{page:}
	<div id="page"></div>
{INIT:}
	<h1>Данные каталога подготовлены</h1>
	<p>Групп первого уровня: <b>{size}</b></p>