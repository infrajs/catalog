{root:}
	<h1>Проверки каталога</h1>
	<a href="/{root}/repeats">Поиск дублей</a><br>
	<a href="/{root}/misfiles">Убрать в архив неиспользуемые файлы</a><br>
	<a href="/{root}/oldpos">Поиск старых позиции</a>
{ans::}-ans/ans.tpl
{404:}
	<h1>{query}</h1>
	<p>
		404 - Что вы хотите этим сказать?
	</p>
{oldpos:}
	<h1>Старые позиции</h1>
	<p>Позиции, которых нет в выгрузке из 1С и нет в прайсах поставщиков.</p>
	{msg?:ans.msg}
	<p><b>{~length(list)} {~words(:позиция,:позиции,:позиций)}</b></p>
	{list::olditems}
	
	{olditems:}
		<div class="mb-3">
			<a href="/catalog/{producer}/{article}">{Производитель} {Артикул}</a> <i>{Код?Код}</i><br>
			<small>{path}</small><br>
			<small>{Наименование}</small>
	</div>
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
