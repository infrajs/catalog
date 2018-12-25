{root:}
	{data.breadcrumbs:cat.breadcrumbs}
	
	<div class="float-right">{:showcount}</div>
	{data.count?data:searchgood?data:searchbad}
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
			<a rel="nofollow" href="/{Controller.names.catalog.crumb}{:cat.mark.add}{name}">
				<span style="color:red; font-family:Tahoma; font-weight:bold">&times;</span>
				{title}:</a> <b>{value}</b>
			
		</div>
{cat.mark.add:}{:cat.mark.server.add}
{searchbad:}
	<h1>{title}</h1>
	<div id="filgroups"></div>
	<p>К сожалению позиции не найдены.</p>
	{~length(data.filters)?:showfilters}
	
	{:text}
{isproducer:}producer
{isgroup:}group
{issearch:}search
{searchgood:}
	<h1>{data.name}</h1>
	<div style="clear:both"></div>
	<div id="filgroups"></div>
	{~length(data.filters)?:showfilters}
		
	{data.childs:cat.groups}

	{~length(list)?:cat_showlist}
	
	<p>{descr}</p>
	{:text}
	
	<!--<h2>{data.name}</h2>
	{~length(data.filters)?:showfilters}
	<p>
		<a rel="nofollow" data-anchor='.breadcrumb' href="/{Controller.names.catalog.crumb}{:cat.mark.set}">{data.count} {~words(data.count,:позиция,:позиции,:позиций)}</a>
	</p>-->
{cat_showlist:}
	{:pages}
	{~conf.catalog.pageset?:pageset}
	{:extend.pos-item-css}
	<div style="clear:both"></div>
	{list::cat_item}

	{:pages}
{cat_item:}
	<div class="position" style="margin-bottom:40px;">
		<div style="text-align:right">{time?~date(:j F Y,time)}</div>
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
		Сортировать <a rel="nofollow" style="font-weight:{data.md.sort??:bold}" data-anchor='.pagination' href='/{Controller.names.catalog.crumb}{:cat.mark.add}sort'>по умолчанию</a>,
			<a rel="nofollow" style="font-weight:{data.md.sort=:name?:bold}" data-anchor='.pagination' href='/{Controller.names.catalog.crumb}{:cat.mark.add}sort={data.md.sort=:name|:name}'>по наименованию</a>, 
			<a rel="nofollow" style="font-weight:{data.md.sort=:art?:bold}"data-anchor='.pagination' href='/{Controller.names.catalog.crumb}{:cat.mark.add}sort={data.md.sort=:art|:art}'>по артикулу</a>, 
			<a rel="nofollow" style="font-weight:{data.md.sort=:cost?:bold}"data-anchor='.pagination' href='/{Controller.names.catalog.crumb}{:cat.mark.add}sort={data.md.sort=:cost|:cost}'>по цене</a>, 
			<a rel="nofollow" style="font-weight:{data.md.sort=:change?:bold}" data-anchor='.pagination' href='/{Controller.names.catalog.crumb}{:cat.mark.add}sort={data.md.sort=:change|:change}'>по дате изменений</a><br>
		Показывать по
		<select onchange="ascroll.once='.pagination'; infra.Crumb.go('/{Controller.names.catalog.crumb}{:cat.mark.add}count='+$(this).val());">
			<option {data.md.count=:5?:selected}>5</option>
			<option {data.md.count=:10?:selected}>10</option>
			<option {data.md.count=:20?:selected}>20</option>
			<option {data.md.count=:100?:selected}>100</option>
		</select> позиций на странице<br>
		Показать в <a rel="nofollow" style="font-weight:{data.md.reverse?:bold}" data-anchor='.pagination' href='/{Controller.names.catalog.crumb}{:cat.mark.add}reverse={data.md.reverse??:1}'>обратном порядке</a>.
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
	{pagenuma:}<a class="page-link" rel="nofollow" data-anchor='#filgroups' href="/{crumb}?p={num}{:cat.mark.aset}">{title}</a>
{pageact:} active
{pagedis:} disabled
{space:}&nbsp;
{cat::}-catalog/cat.tpl
{extend::}-catalog/extend.tpl
{text:}
	{text}
	{textinfo.gallery::textimg}
	{textimg:}
		<img class="img-fluid" src="/-imager/?w=1000&amp;src={...gallerydir}{.}">