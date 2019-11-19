{root:}
	{data.breadcrumbs:cat.breadcrumbs}
	<div class="float-right">{:showcount}</div>
	<h1>
		{~conf.catalog.showparentgroup?:showparentgroup}{data.title|data.name}
	</h1>
	{data.count?data:searchgood?data:searchbad}
	{:text}
{root-twocolumns:}
	{data.breadcrumbs:cat.breadcrumbs}
	<div class="row">
		<div class="col-lg-4 col-xl-3">
			<div id="MAINFILTERS"></div>
			<div id="allgroups" class="d-none d-lg-block"></div>	
		</div>
		<div class="col-lg-8 col-xl-9">
			<div class="float-right">{:showcount}</div>
			<h1>
				{~conf.catalog.showparentgroup?:showparentgroup}{data.title|data.name}
			</h1>
			{data.count?data:searchgood?data:searchbad}
		</div>
	</div>
	<p>{descr}</p>
	{:text}
	{showparentgroup:}<a href="/{Controller.names.catalog.crumb}/{data.group.parent}{:cat.mark.set}">{data.group.parent}</a>{data.group.parent?:tire} 
	{tire:} &mdash; 
	{Группа:}
	{Поиск:}Поиск, 
	{Производитель:}Производитель,  
{showcount:}
	{data.is=:isproducer?:Производитель}{data.is=:issearch?:Поиск}{data.is=:isgroup?:Группа}
	{data.count} {~words(data.count,:модель,:модели,:моделей)}
	{asdf:}<span class="badge badge-secondary">{data.count}</span> {~words(data.count,:позиция,:позиции,:позиций)}
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
	<div class="showfilters alert {~conf.catalog.showfilterscls}" role="alert">
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
	<div class="row">
		<div class="col-md-8 col-lg-8 col-xl-6" id="filgroups"></div>
	</div>
	<div class="mb-4"></div>
	<p>К сожалению, позиции не найдены.</p>
	{~length(data.filters)?:showfilters}
	{isproducer:}producer
	{isgroup:}group
	{issearch:}search

{itemlist:}{data.count>:limit?:cat_notshow?:cat_showlist}
{itemlist:}{((data.count>:limit)|~length(data.childs))?:cat_notshow?:cat_showlist}
{itemlist:}{((data.count>:limit)|~length(data.childs))&~length(data.filters)<:1?:cat_notshow?:cat_showlist}
{searchgood:}

	{:groups-{(group.showcase.tplgroups|~conf.catalog.tplgroups)}}
	{:itemlist}
	<p>{descr}</p>
	{limit:}1000
	{1:}1
	{cat_notshow:}Найдено <b>{data.count}</b> {~words(data.count,:модель,:модели,:моделей)} &mdash; выберите группу.
	{groups-default:}
		{~length(data.filters)?:showfilters}
		<div class="row">
			<div class="col-md-8 col-lg-8 col-xl-6" id="filgroups"></div>
		</div>
		{~length(data.childs)?data.childs:cat.groups}
	{groups-blocks:}
		{~length(data.childs)?:showblocks?:nogroups_simple}
		{showblocks:}
		<div class="row catgroups mt-4 mb-1">
			<style>
				.catgroups ul { 
					list-style: none inside;
					padding-left: 0.5rem;
				} 
				.catgroups ul > li:before {
					content: "—"; 
					margin-left: -1ex; 
					margin-right: 1ex; 
				}
			</style>
			
			{data.childs::groups_group_block}
			
		</div>
		{~length(data.filters)?:showfilters}
	{groups-info3:}
		{~length(data.childs)?:showgroups3?:nogroups_simple}
		{showgroups3:}
		<div class="catgroups mt-4 mb-1">
			<style>
				.catgroups ul { 
					list-style: none inside;
					padding-left: 0.5rem;
				} 
				.catgroups ul > li:before {
					content: "—"; 
					margin-left: -1ex; 
					margin-right: 1ex; 
				}
			</style>
			
			{data.childs::groups_group}
			
			{~length(data.filters)?:showfilters}
			
		</div>
	{groups-info:}
		{~length(data.childs)?:showgroups?:nogroups}
		{showgroups:}
		<div class="row catgroups mt-4 mb-1">
			<style>
				.catgroups ul { 
					list-style: none inside;
					padding-left: 0.5rem;
				} 
				.catgroups ul > li:before {
					content: "—"; 
					margin-left: -1ex; 
					margin-right: 1ex; 
				}
			</style>
			<div class="order-2 order-md-1 col-md-8 col-lg-8 col-xl-8 mb-3">
				<div class="row">
					{data.childs::groups_group}
				</div>
				{~length(data.filters)?:showfilters}
			</div>
			<div class="order-1 order-md-2 col-md-4 col-lg-4 col-xl-4 mb-3">
				<div id="filgroups"></div>
			</div>
		</div>
		{nogroups:}
			<div class="row catgroups mt-4">
				<div class="col-md-6 mb-3">
					<div id="filgroups"></div>
					{~length(data.filters)?:showfilters}
				</div>
			</div>
		{nogroups_simple:}
			<div class="catgroups mt-4">
				<div class="mb-3">
					{~length(data.filters)?:showfilters}
				</div>
			</div>
	{groups_group_block_bg:}
		<div 
			class="col-6 col-md-4 col-lg-4 col-xl-3 d-flex mb-4 flex-column justify-content-start" 
			style="{(icon|img)?:bgimg}">

			<div class="text-center my-5 p-2" style=" background-color:rgba(255,255,255,0.8); background-color:rgba(0,0,0,0.7);">
				<div style="font-size:100%; overflow: hidden; text-overflow: ellipsis; font-weight: bold; text-transform: uppercase;"><a href="/{Controller.names.catalog.crumb}/{group_nick}{:cat.mark.set}">{group}</a></div>
			</div>

		</div>
		{bgimg:}background-image:url('/-imager/?w=300&h=200&m=1&crop=1&src={icon|img}'); background-repeat:no-repeat; background-position: center; background-size: cover;
	{groups_group_block:}
		<div  class="col-6 col-md-4 col-lg-4 col-xl-3 d-flex mb-4 flex-column justify-content-between">
			<div class="flex-grow-1">{(icon|img)?:gimg_big}</div>
			<div class="text-center mt-1">
				<div style="font-size:100%; overflow: hidden; text-overflow: ellipsis; font-weight: bold; text-transform: uppercase;"><a href="/{Controller.names.catalog.crumb}/{group_nick}{:cat.mark.set}">{group}</a></div>
			</div>

		</div>
		
		{gimg_big:}<a href="/{Controller.names.catalog.crumb}/{group_nick}{:cat.mark.set}"><img class="img-fluid" src="/-imager/?w=300&h=200&crop=1&src={icon|img}"></a>
	{groups_group:}
		<div class="col-lg-12 col-lg-6 col-xl-6 d-flex mb-3">
			<div class="mr-2" style="min-width:100px; text-align:center">
				<a href="/{Controller.names.catalog.crumb}/{group_nick}{:cat.mark.set}">{(img|icon)?:gimg}</a>
			</div>
			<div class="flex-grow-1">
				<div style="font-size:100%; overflow: hidden; text-overflow: ellipsis; font-weight: bold; text-transform: uppercase;"><a href="/{Controller.names.catalog.crumb}/{group_nick}{:cat.mark.set}">{group}</a></div>
				{~length(childs)?:subgrs2?:subposs}
			</div>
		</div>
		{subposs:}
			<div>{min?(min!max?:showcost?:onecost)?:nocost}</div>
			{showcost:}Цены от&nbsp;{~cost(min)}&nbsp;руб. до&nbsp;{~cost(max)}&nbsp;руб.
			{nocost:}
			{onecost:}Цена {~cost(min)}&nbsp;руб.
		{subgrs2:}
			<div>{childs::subgr2}</div>
			{subgr2:}<a href="/{Controller.names.catalog.crumb}/{group_nick}{:cat.mark.set}">{group}</a>{~last()|:comma}
			{comma:}, 
		{subgrs:}
			<ul>
				{childs::subgr}
			</ul>
			{subgr:}<li><a href="/{Controller.names.catalog.crumb}/{group_nick}{:cat.mark.set}">{group}</a></li>
		{gimg:}<img src="/-imager/?w=100&h=100&src={icon|img}">
{cat_showlist:}
	{:pages}
	{~conf.catalog.pageset?:pageset}
	{list:search-{(group.showcase.tplsearch|~conf.catalog.tplsearch)}}
	{:pages}
{search-rows:}
	{:extend.pos-item-css}
	<div style="clear:both"></div>
	{::cat_item}
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
	
	<div class="row cat_item"  style="margin-bottom:20px; clear:both">
		{::pos-item-columns}
	</div>
{pos-item-columns:}
	<div class="mb-4 col-12 col-sm-6 col-lg-4 col-xl-4 columpos space">
		
		<a class="title p-2 nobr" href="/{Controller.names.catalog.crumb}/{producer_nick}/{article_nick}{:cat.idsl}{:cat.mark.set}">{Наименование|article}</a>
		<div class="p-2 nobr">
			<b><a href="/{Controller.names.catalog.crumb}/{producer_nick}/{article_nick}{:cat.idsl}{:cat.mark.set}">{producer} {article}</a></b>
		</div>
		{Наличие на складе?:extend.nalichie}
		<div>{images.0?:posimg?:noimg}</div>
		<div class="py-2">
			{Цена?:extend.priceblockbig}
			<div>{~cut(:200,Описание)}</div>
		</div>
	</div>
	{350:}350
	{producerlogo:}
		<a data-anchor=".breadcrumb" title="Посмотреть продукцию {producer}" href="/{Controller.names.catalog.crumb}/{producer}{:cat.mark.set}" class="float-right p-2">
			<img width="100" src="/-imager/?w=100&amp;h=100&amp;src={logo}" />
		</a>
{posimg:}
	<a style="position: relative;"href="/{Controller.names.catalog.crumb}/{producer_nick}/{article_nick}{:cat.idsl}{:cat.mark.set}">
		<img class="img-fluid border" src="/-imager/?m=1&amp;w=528&amp;h=528&amp;top=1&amp;crop=1&amp;src={images.0}" />
	</a>
{noimg:}
	<a style="position: relative" href="/{Controller.names.catalog.crumb}/{producer_nick}/{article_nick}{:cat.idsl}{:cat.mark.set}">
		<img class="img-fluid" src="/-imager/?m=1&amp;w=528&amp;h=528&amp;top=1&amp;crop=1&amp;src={images.0}" />
	</a>
{cat_item:}
	<div class="position" style="margin-bottom:20px;">
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
		<select onchange="ascroll.once='.pagination'; Crumb.go('/{Controller.names.catalog.crumb}{:cat.mark.add}count='+$(this).val());">
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
	{pagenuma:}<a class="page-link" rel="nofollow" data-anchor='.pagination' href="/{Controller.names.catalog.crumb}?p={num}{:cat.mark.aset}">{title}</a>
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