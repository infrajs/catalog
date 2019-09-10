{root:}
	{data.breadcrumbs:cat.breadcrumbs}
	<div class="float-right">{:showcount}</div>
	<h1>{data.name|title}</h1>
	<div style="clear:both"></div>
	<div id="filgroups"></div>
	{data.count?data:searchgood?data:searchbad}
	{:text}
	{Группа:}Группа
	{Поиск:}Поиск
	{Производитель:}Производитель
{showcount:}
	{data.is=:isproducer?:Производитель}{data.is=:isgroup?:Группа}{data.is=:issearch?:Поиск}, 
	{data.count} {~words(data.count,:позиция,:позиции,:позиций)}
{showfilters:}
	<style scoped>
		.showfilters a {
			color:inherit;
			text-decoration:none;
		}
		.showfilters a:hover {
			color:red;
			text-decoration:none;
		}
	</style>
	<div class="showfilters alert alert-success" role="alert">
		Фильтры:
		{data.filters::showfilter}
	</div>
	{showfilter:}
		<div class="item" data-anchor='.breadcrumb'>
			<a rel="nofollow" href="/{crumb}{:cat.mark.add}{name}">
				<span style="color:red; font-family:Tahoma; font-weight:bold">&times;</span>
				{title}:</a> <b>{value}</b>
			
		</div>
{cat.mark.add:}{:cat.mark.server.add}
{searchbad:}
	<div class="mb-4"></div>
	<p>К сожалению, позиции не найдены.</p>
	{~length(data.filters)?:showfilters}

{isproducer:}producer
{isgroup:}group
{issearch:}search
{searchgood:}
	{~length(data.filters)?:showfilters}
	{data.childs:cat.groups}
	{~length(data.md.group)?(~length(list)?:cat_showlist)}
	<p>{descr}</p>
{cat_showlist:}
	{:pages}
	{~conf.catalog.pageset?:pageset}
	{:search-{(group.showcase.tplsearch|~conf.catalog.tplsearch)}}
	{:pages}
{search-rows:}
	{:extend.pos-item-css}
	<div style="clear:both"></div>
	{list::cat_item}
{search-columns:}
	<style scoped>
		.cat_item .title {
			display:block;
			background-color:#EFEFEF;
			text-decoration: none;
			color:#222222;
		}
		.cat_item .padding {
			padding:4px 8px;
		}
		.cat_item .title:hover {
			background-color:gray;
			color:white;
		}
		.cat_item .nobr {
			white-space: nowrap;
			overflow: hidden;
			text-overflow: ellipsis;
		}
	</style>
	
	<div class="row cat_item"  style="margin-bottom:40px; clear:both">
		{list::cat-item-columns}
	</div>
{cat-item-columns:}
	
			{:pos-item-columns}
		
{pos-item-columns:}
	<div class="mb-4 col-12 col-sm-6 col-lg-4 col-xl-4 d-flex flex-column justify-content-between">
		<div class="flex-grow-1">
			<a class="title p-2 nobr" href="/{crumb}/{producer_nick}/{article_nick}{:cat.idsl}{:cat.mark.set}">{Наименование|article}</a>
			<div class="p-2 nobr">
				<b><a href="/{crumb}/{producer_nick}/{article_nick}{:cat.idsl}{:cat.mark.set}">{producer} {article}</a></b>
			</div>
			{Наличие на складе?:extend.nalichie}
			{images.0?:posimg?:noimg}
			
		</div>
		<div class="px-2">
			{Цена?:extend.priceblockbig}
		</div>
	</div>
	{producerlogo:}
		<a data-anchor=".breadcrumb" title="Посмотреть продукцию {producer}" href="/{crumb}/{producer}{:cat.mark.set}" class="float-right p-2">
			<img width="100" src="/-imager/?w=100&amp;h=100&amp;src={logo}" />
		</a>
{posimg:}
	<a style="position: relative" href="/{crumb}/{producer_nick}/{article_nick}{:cat.idsl}{:cat.mark.set}">
		<img class="img-fluid border" src="/-imager/?m=1&amp;w=528&amp;h=528&amp;top=1&amp;crop=1&amp;src={images.0}" />
	</a>
{noimg:}
	<a style="position: relative" href="/{crumb}/{producer_nick}/{article_nick}{:cat.idsl}{:cat.mark.set}">
		<img class="img-fluid border" src="/-imager/?m=1&amp;w=528&amp;h=528&amp;top=1&amp;crop=1&amp;src={images.0}" />
	</a>
{cat_item:}
	<div class="position" style="margin-bottom:40px;">
		{:extend.pos-item}
	</div>
{pages:}
{data.numbers?:pagenumbers}

{pagenumbers:}
	<ul class="pagination">
		{data.numbers::pagenum}
	</ul>
{pageset:}
	

	<div rel="nofollow" class="float-right a mr-1 mb-4" style="z-index:1; position:relative; cursor:pointer;" onclick="Session.set('catalog.cog', !$('.settings:visible').length); $('.settings').slideToggle('fast');">Сортировка</div>

	<div class="settings alert alert-info" style="display:none">
		Сортировать <a rel="nofollow" style="font-weight:{data.md.sort??:bold}" data-anchor='.pagination' href='/{crumb}{:cat.mark.add}sort'>по умолчанию</a>,
			<a rel="nofollow" style="font-weight:{data.md.sort=:name?:bold}" data-anchor='.pagination' href='/{crumb}{:cat.mark.add}sort={data.md.sort=:name|:name}'>по наименованию</a>, 
			<a rel="nofollow" style="font-weight:{data.md.sort=:art?:bold}"data-anchor='.pagination' href='/{crumb}{:cat.mark.add}sort={data.md.sort=:art|:art}'>по артикулу</a>, 
			<a rel="nofollow" style="font-weight:{data.md.sort=:cost?:bold}"data-anchor='.pagination' href='/{crumb}{:cat.mark.add}sort={data.md.sort=:cost|:cost}'>по цене</a>, 
			<a rel="nofollow" style="font-weight:{data.md.sort=:change?:bold}" data-anchor='.pagination' href='/{crumb}{:cat.mark.add}sort={data.md.sort=:change|:change}'>по дате изменений</a><br>
		Показывать по
		<select onchange="ascroll.once='.pagination'; Crumb.go('/{crumb}{:cat.mark.add}count='+$(this).val());">
			<option {data.md.count=:5?:selected}>5</option>
			<option {data.md.count=:10?:selected}>10</option>
			<option {data.md.count=:20?:selected}>20</option>
			<option {data.md.count=:100?:selected}>100</option>
		</select> позиций на странице<br>
		Показать в <a rel="nofollow" style="font-weight:{data.md.reverse?:bold}" data-anchor='.pagination' href='/{crumb}{:cat.mark.add}reverse={data.md.reverse??:1}'>обратном порядке</a>.
	</div>
	<div style="clear:both"></div>
	<script>
		domready(function () {
			Event.one('Controller.onshow', function () {
				var show = Session.get('catalog.cog');
				if (show) $('.settings').show();
			});
		});
	</script>
{pagenum:}
	<li class="page-item {active?:pageact}{empty?:pagedis}">
		{empty?:pagenumt?:pagenuma}
	</li>
	{pagenumt:}<a class="page-link">{title}</a>
	{pagenuma:}<a class="page-link" rel="nofollow" data-anchor='.pagination' href="/{crumb}?p={num}{:cat.mark.aset}">{title}</a>
{pageact:} active
{pagedis:} disabled
{space:}&nbsp;
{cat::}-catalog/cat.tpl
{extend::}-catalog/extend.tpl
{text:}
	{data.text}
	{data.textinfo.gallery::textimg}
	{textimg:}
		<img class="img-fluid" src="/-imager/?w=1000&amp;src={...gallerydir}{.}">