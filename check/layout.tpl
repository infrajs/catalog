{root:}
	<h1>Проверки каталога</h1>
	<a href="/{root}/repeats">Поиск дублей</a><br>
	<a href="/{root}/misfiles">Поиск неиспользуемых файлов</a>
{ans::}-ans/ans.tpl
{404:}
	<h1>{query}</h1>
	<p>
		404 - Что вы хотите этим сказать?
	</p>
{misfiles:}
	<h1>Поиск неиспользуемых файлов</h1>
	{.:ans.msg}
	{~print(mis)}

{repeats:}
	<h1>Найдено повторов - {count}</h1>
	{list::rpkey}
	{rpkey:}
		<h2>{~key} - {~length(.)}</h2>
		<div>
			{.::collect}	
		</div>
		{collect:}<b><a href="/catalog/{0.producer}/{0.article}">{~key}</a></b><br>{::pos}
			{pos:}{file} {Производитель} - {Артикул}, {group}<br>