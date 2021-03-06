{root:}
	{data.breadcrumbs:cat.breadcrumbs}
	<div class="float-right ml-2">{:showcount}</div>
	<h1>
		{~conf.catalog.showparentgroup?:showparentgroup}{data.name|data.title}
	</h1>
	{data.group.options.tplgroups?:groups-{data.group.options.tplgroups}?:groups-default}
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
				{~conf.catalog.showparentgroup?:showparentgroup}{data.name|data.title}
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
	<div style="margin-bottom: 30px" class="showfilters alert alert-primary" role="alert">
		Фильтры:
		{data.filters::showfilter}
	</div>
	{showfilter:}
		<div class="item">
			<a rel="nofollow" href="/{Controller.names.catalog.crumb}{:cat.mark.add}{name}">
				<span style="color:red; font-family:Tahoma; font-weight:bold">&times;</span>
				{title}:</a> <b>{value}</b>
			
		</div>
{cat.mark.add:}{:cat.mark.server.add}
{searchbad:}
	<!--<div class="row">
		<div class="col-md-6 mb-3">
			<div id="filgroups"></div>
		</div>
		<div class="col-md-6 mb-3">
			{~length(data.filters)?:showfilters}	
		</div>
	</div>-->
	<div class="mb-4"></div>
	<p>К сожалению, позиции не найдены.</p>
	
	{isproducer:}producer
	{isgroup:}group
	{issearch:}search

{itemlist2:}{data.group.count?:cat_showlist?(~length(data.filters)?(data.count>:limit?:cat_notshow?:cat_showlist)?:cat_notshow)}
{itemlist:}{data.showlist?:cat_showlist?:cat_notshow}
{searchgood:}
	<div class="cat-search">
		{:itemlist}
		<p>{descr}</p>
	</div>
	{limit:}500
	{1:}1
	{cat_notshow:}Найдено <b>{data.count}</b> {~words(data.count,:модель,:модели,:моделей)} &mdash; выберите группу.
	{groups-default:}
		{~length(data.filters)?:showfilters}
		<div class="row">
			<div class="col-md-8 col-lg-8 col-xl-6" id="filgroups"></div>
		</div>
		{~length(data.childs)?data.childs:groups-def}
		{groups-def:}
			<div class="cart">
				<div class="catgrouplist row no-gutters mb-4" style="margin-left:-5px; margin-right:-5px">
					{::groups-def-group}
				</div>
			</div>
			{groups-def-group:}
				<div class="col-sm-6 col-md-4 col-lg-6 col-xl-4" style="padding:5px">
					<a class="d-flex p-1 bg-white rounded" style="align-items:center; height:68px; border: none" 
						href="{group_nick:model.link-val}">
						<div style="text-align:center; width:70px">
							{(img|icon):gimgdef}
						</div>
						<div class="title">
							{group}
						</div>
					</a>
				</div>
				{gimgdef:}<img class="img-fluid" src="/-imager/?src={.}&w=130&h=60">
	{groups-blocks:}
		<div class="row">
			<div class="col-md-8 col-lg-8 col-xl-6" id="filgroups"></div>
		</div>
		{~length(data.childs)?:showblocks?:nogroups_simple}
		{showblocks:}
			<!-- catgroups mt-4 -->
			<div class="row catgroups mb-1">
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
		<div class="catgroups mb-1">
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
			<div class="row catgroups mb-4">
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
				<div class="order-2 order-md-2 col-md-6 col-lg-8 col-xl-8 mb-3">
					<div class="row">
						{data.childs::groups_group}
					</div>
					{~length(data.filters)?:showfilters}
				</div>
				<div class="order-1 order-md-1 col-md-6 col-lg-4 col-xl-4 mb-3">
					<div id="filgroups"></div>
				</div>
			</div>
		{nogroups:}
			<div class="row catgroups mb-4">
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
				<div class="order-2 order-md-2 col-md-6 mb-3">
					<div class="row">
						{data.childs::groups_group}
					</div>
				</div>
				<div class="order-1 order-md-1 col-md-6 mb-3">
					<div id="filgroups"></div>
					{~length(data.filters)?:showfiltersm}
				</div>
			</div>
			{showfiltersm:}
				<div class="mt-2">{:showfilters}</div>
		{nogroups_simple:}
			<div class="catgroups">
				<div class="mb-3">
					{~length(data.filters)?:showfilters}
				</div>
			</div>
	{groups_group_block_bg:}
		<div 
			class="col-6 col-md-4 col-lg-4 col-xl-3 d-flex mb-4 flex-column justify-content-start" 
			style="{(icon|img)?:bgimg}">

			<div class="text-center my-5 p-2" style=" background-color:rgba(255,255,255,0.8); background-color:rgba(0,0,0,0.7);">
				<div style="font-size:100%; overflow: hidden; text-overflow: ellipsis; font-weight: bold; text-transform: uppercase;"><a href="{group_nick:model.link-val}">{group}</a></div>
			</div>

		</div>
		{bgimg:}background-image:url('/-imager/?w=300&h=200&m=1&crop=1&src={icon|img}'); background-repeat:no-repeat; background-position: center; background-size: cover;
	{groups_group_block:}
		<div  class="col-6 col-md-4 col-lg-4 col-xl-3 d-flex mb-4 flex-column justify-content-between">
			<div class="flex-grow-1">{(icon|img)?:gimg_big}</div>
			<div class="text-center mt-1">
				<div style="font-size:100%; overflow: hidden; text-overflow: ellipsis; font-weight: bold; text-transform: uppercase;"><a href="{group_nick:model.link-val}">{group}</a></div>
			</div>

		</div>
		
		{gimg_big:}<a style="border: none" href="{group_nick:model.link-val}"><img class="img-fluid" src="/-imager/?w=300&h=200&crop=1&src={icon|img}"></a>
	{groups_group:}
		<div class="col-md-12 col-lg-6 col-xl-6 d-flex mb-3">
			<div class="mr-2" style="min-width:100px; text-align:center">
				<a style="border: none" href="{group_nick:model.link-val}">{(img|icon)?:gimg}</a>
			</div>
			<div class="flex-grow-1">
				<div style="font-size:100%; overflow: hidden; text-overflow: ellipsis; font-weight: bold; text-transform: uppercase;"><a href="{group_nick:model.link-val}">{group}</a></div>
				{~length(childs)&(childs!~root().childs)?:subgrs2?:subposs}
			</div>
		</div>
		{subposs:}
			<div>{min?(min!max?:showcost?:onecost)?:nocost}</div>
			{showcost:}Цены от&nbsp;{~cost(min)}&nbsp;руб. до&nbsp;{~cost(max)}&nbsp;руб.
			{nocost:}
			{onecost:}Цена {~cost(min)}&nbsp;руб.
		{subgrs2:}
			<div>{childs::subgr2}</div>
			{subgr2:}<a href="{group_nick:model.link-val}">{group}</a>{~last()|:comma}
			{comma:}, 
		{subgrs:}
			<ul>
				{childs::subgr}
			</ul>
			{subgr:}<li><a href="{group_nick:model.link-val}">{group}</a></li>
		{gimg:}<img src="/-imager/?w=100&h=100&src={icon|img}">
{model::}-catalog/model.tpl?v={~conf.index.v}
{cat_showlist:}
	{:pages}
	{group.options.tplsearch?list:model.{group.options.tplsearch}-list?list:model.ROWS-list}
	{:pages}

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
		.cat_item .hoverup {
			transform: scale(1);
			transition: transform 1s ease;
		}
		.cat_item .hoverup:hover {
		    transform: scale(1.05);
		}
	</style>
	<div class="row cat_item" style="clear:both">
		{::pos-item-columns}
	</div>
	{pos-item-columns:}
		<div class="mb-4 col-12 col-sm-6 col-lg-4 col-xl-4 columpos space">
			
			{Наличие?:extend.nalichie}
			<div>{images.0?:posimg?:noimg}</div>
			<a class="d-block pt-2 text-truncate" href="{:model.link-pos}">{Наименование|article}</a>
			<div class="py-2 between">
				
				{:extend.print_more}
				{:extend.priceblockbig}
			</div>
		</div>
		{350:}350
		{producerlogo:}
			<a title="Посмотреть продукцию {producer}" href="{producer_nick:model.link-val}" class="float-right p-2">
				<img width="100" src="/-imager/?w=100&amp;h=100&amp;src={logo}" />
			</a>
{posimg:}
	<a style="position: relative;" href="{:model.link-pos}">
		<img class="img-fluid" src="/-imager/?m=1&amp;w=528&amp;h=528&amp;top=1&amp;crop=1&amp;src={images.0}&or=-images/noimage.jpg" />
	</a>
{noimg:}
	&nbsp;
{search-rows:}
	{:extend.pos-item-css}
	<div style="clear:both"></div>
	{::cat_item}
{cat_item:}
	<div class="position" style="margin-bottom:20px;">
		{:extend.pos-item}
	</div>
{pages:}
{data.numbers?:pagenumbers}

{pagenumbers:}
	<ul class="pagination" style="margin: 30px 0">
		{data.numbers::pagenum}
	</ul>
{pagenum:}
	<li class="page-item {active?:pageact}{empty?:pagedis}">
		{empty?:pagenumt?:pagenuma}
	</li>
	{pagenumt:}<a class="page-link">{title}</a>
	{pagenuma:}<a class="page-link" rel="nofollow" data-anchor='.pagination' href="/{Controller.names.catalog.crumb}?p={num}{:cat.mark.aset}">{title}</a>
{pageact:} active
{pagedis:} disabled
{space:}&nbsp;
{cat::}-catalog/cat.tpl?v={~conf.index.v}
{extend::}-catalog/extend.tpl?v={~conf.index.v}
{text:}
	{data.text}
	{data.textinfo.gallery::textimg}
	{textimg:}
		<img class="img-fluid" src="/-imager/?w=1000&amp;src={...gallerydir}{.}">