{root:}
	{:html}
	<h1>REST сервис</h1>
	<ul>
		<li>JSON <a href="/{root}/pos">{root}pos/{{producer}}/{{article}}</a></li>
		<li>HTML <a href="/{root}/check">Проверить каталог</li>
	</ul>
	{:/html}
{html:}
<html>
	<head>
		<title>REST сервис infrajs/catalog</title>
		<link href="/-collect/?css" type="text/css" rel="stylesheet">
	</head>
	<body>
	<div class="container" style="margin-top:50px">
		<ul class="breadcrumb">
			{crumbs::li}
		</ul>
		{li:}{active?:liactive?:lijust}
		{lijust:}<li><a href="/{href}">{title}</a></li>
		{liactive:}<li class="active">{title}</li>
{/html:}
	</div></body></html>
{page:}
	{:html}
	<div id="page"></div>
	{:/html}