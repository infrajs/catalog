{priceblockbig:}{:orig.priceblockbig}
{pos-page:}{Цена?:priceblockbig}
	{orig.priceblockbig:}
		{min?(show?:showonecost?:showitemscost)?:showonecost}	
	{showitemscost:}
	<span>Цена от&nbsp;<b>{~cost(min)}</b> до&nbsp;<b>{~cost(max)}{:unit}</b></span>
	{show??:itemsa}
	{itemsa:}<a 
		href="/{Controller.names.catalog.crumb}/{producer_nick}/{article_nick}{:cat.idsl}{:cat.mark.set}" 
		data-anchor="#items">
			{~length(items)}&nbsp;{~words(~length(items),:позиция,:позиции,:позиций)}</a>.
	{itemsspan:}<span class="a" onclick="Ascroll.go('#items')">{~length(items)}&nbsp;{~words(~length(items),:позиция,:позиции,:позиций)}</span>.
	{showonecost:}Цена <b class="cost">{~cost(Цена)}{:unit}</b>
{pos-sign:}
	<p>
		Перейти к группе <a href="/{crumb.parent.parent}/{group_nick}{:cat.mark.set}">{group}</a><br>
	</p>
	{Скрытый:}Скрытый
{pos-item-css:}
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
	</style>
{nalichie:}
	<div style="position:absolute; left:15px; z-index:1" class="m-1">{:badgenalichie}</div>
{badgenalichie:}
	{Наличие?:badgenalichieshow}
	{badgenalichieshow:}
<a href="/catalog{:cat.mark.add}more.{Path.encode(:strНаличие)}::.{Path.encode(Наличие)}=1" class="badge {Наличие=:strnal?:clsnal?(Наличие=:strras?:clsras?(Наличие=:strzak?:clszak?(Наличие=:stract?:clsact?(Наличие=:strmalo?:clsmalo?:clsdef))))}">
		{Наличие}</a>
	{strНаличие:}Наличие
	{strnal:}В наличии
	{clsnal:}badge-primary
	{clsdef:}badge-secondary

	{stract:}Акция
	{clsact:}badge-danger

	{strras:}Распродажа
	{clsras:}badge-success

	{strzak:}На заказ
	{clszak:}badge-info

	{strmalo:}Мало
	{clsmalo:}badge-warning
	
	{label-success:}badge-success
	{label-info:}
	{label-secondary:}badge-secondary
	{label-danger:}badge-danger
{pos-img:}
		{Наличие?:nalichie}
		<a style="position: relative" href="/{Controller.names.catalog.crumb}/{producer_nick}/{article_nick}{:cat.idsl}{:cat.mark.set}">
			<img class="img-thumbnail" src="/-imager/?m=1&amp;w=528&amp;src={images.0}" />
		</a>
{pos-item:}
	<div class="row cat_item">
		<div class="{images.0??:mobimghide}col-12 col-sm-4 col-md-3">
			{images.0?:pos-img?:pos-img}
		</div>
		<div class="col-12 col-sm-8 col-md-9">
			<a class="title padding" href="/{Controller.names.catalog.crumb}/{producer_nick}/{article_nick}{:cat.idsl}{:cat.mark.set}">{Наименование|:name}</a>
			{logo?:producerlogo}
			<div class="float-right" style="font-size:90%; margin-left:10px; clear:right"><a href="/{Controller.names.catalog.crumb}/{group_nick}{:cat.mark.set}">{group}</a></div>
			<div class="padding">
				<b><a href="/{Controller.names.catalog.crumb}/{producer_nick}/{article_nick}{:cat.idsl}{:cat.mark.set}">{~conf.showcase.hiddenarticle??:prodart}</a></b>
				
			</div>
			{(more&~conf.catalog.showmore)?:havemore?:nomore}
			
		</div>
	</div>
	{prodart:}{producer} {article}
	{mobimghide:}d-none d-sm-block 
	{name:}{article}
	{havemore:}
		<div class="padding">    
			{more::cat_more}
		</div>
		<div class="padding">
			{Цена?:priceblockbig}
		
		</div>
	{nomore:}
		<div class="padding">
			<div>{Описание}</div>
		</div>
		<div class="padding">
			{Цена?:priceblockbig}
		</div>
	{cat_more:}{(.&(.!:no))?:more}
	{more:}{~key}:&nbsp;{.}{~last()|:comma}
	{comma:}, 
	{no:}Нет
	{producerlogo:}
		<a title="Посмотреть продукцию {producer}" href="/{Controller.names.catalog.crumb}{:cat.mark.add}producer.{producer_nick}=1" class="float-right" style="margin:5px 0 5px 5px">
			<img width="100" src="/-imager/?w=100&amp;h=100&amp;src={logo}" />
		</a>
	{cat::}-catalog/cat.tpl?v={~conf.index.v}
	{strcatalog:}catalog
	{priceblock:}<div class="alert alert-success cost" style="clear:right; font-size:140%; padding:5px 10px; margin:15px 0;">{~cost(Цена)}{:unit}</div>
	{unit:}&nbsp;руб.