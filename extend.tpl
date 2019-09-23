{priceblockbig:}{:orig.priceblockbig}
{pos-page:}{Цена?:priceblockbig}
	{orig.priceblockbig:}
		<div class="alert alert-success">
			Цена: <span class="cost" style="font-size:20px">{~cost(Цена)}{:unit}</span>{:nds}<br> 
			<!--По вопросам приобретения обращайтесь по телефонам в <a href="/contacts">контактах</a>.-->
		</div>
	{nds:}{~conf.catalog.nds?:ndsshow}{ndsshow:} c НДС 20%
{pos-sign:}
	<p>
		Перейти к группе <a data-anchor='.breadcrumb' href="/{crumb.parent.parent}/{group_nick}{:cat.mark.set}">{group}</a><br>
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
	{Наличие на складе?:badgenalichieshow}
	{badgenalichieshow:}
<a href="/catalog{:cat.mark.add}more.Наличие-на-складе::.{Наличие на складе}=1" class="badge {Наличие на складе=:strnal?:strpri?(Наличие на складе=:strras?:label-success?(Наличие на складе=:strzak?:label-info?(Наличие на складе=:stract?:label-danger?:label-secondary)))}">
		{Наличие на складе}</a>
	{strnal:}В наличии
	{stract:}Акция
	{strras:}Распродажа
	{strzak:}На заказ
	{strpri:}badge-primary
	{label-success:}badge-success
	{label-info:}badge-info
	{label-secondary:}badge-secondary
	{label-danger:}badge-danger
{pos-img:}
		{Наличие на складе?:nalichie}
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
			<div class="padding">
				<b><a href="/{Controller.names.catalog.crumb}/{producer_nick}/{article_nick}{:cat.idsl}{:cat.mark.set}">{producer} {~conf.showcase.hiddenarticle??article}</a></b>
				<div class="float-right" style="font-size:90%; margin-left:10px; clear:right"><a data-anchor=".breadcrumb" href="/{Controller.names.catalog.crumb}/{group_nick}{:cat.mark.set}">{group}</a></div>
			</div>
			
			{(more&~conf.catalog.showmore)?:havemore?:nomore}
			
		</div>
	</div>
	{mobimghide:}d-none d-sm-block 
	{name:}{article}
	{havemore:}
		<div class="padding" style="font-family:Tahoma; font-size:85%; margin-bottom:4px">    
			{more::cat_more}
		</div>
		<div class="padding">
			{Цена?:priceblockbig}
		</div>
		{#Описание?:descrshow}
		{descrshow:}
		<div class="padding">
			<span style="border-bottom:1px dashed gray; cursor:pointer" onclick="$(this).next().slideToggle();">Описание</span>
			<div style="display:none;">
				{Описание}
				<b><a href="/{Controller.names.catalog.crumb}/{producer_nick}/{article_nick}{:cat.idsl}{:cat.mark.set}">Подробнее</a></b>
			</div>
		</div>
	{nomore:}
		<div class="padding">
			<div style="font-family:Tahoma; font-size:85%; margin-bottom:10px">{Описание}</div>
			{Цена?:priceblockbig}
			<b><a href="/{Controller.names.catalog.crumb}/{producer_nick}/{article_nick}{:cat.idsl}{:cat.mark.set}">Подробнее</a></b>
		</div>
	{cat_more:}{(.&(.!:no))?:more}
	{more:}{~key}:&nbsp;{.}{~last()|:comma}
	{comma:}, 
	{no:}Нет
	{producerlogo:}
		<a data-anchor=".breadcrumb" title="Посмотреть продукцию {producer}" href="/{Controller.names.catalog.crumb}/{producer_nick}{:cat.mark.set}" class="float-right" style="margin:5px 0 5px 5px">
			<img width="100" src="/-imager/?w=100&amp;h=100&amp;src={logo}" />
		</a>
	{cat::}-catalog/cat.tpl
	{strcatalog:}catalog
	{priceblock:}<div class="alert alert-success cost" style="clear:right; font-size:140%; padding:5px 10px; margin:15px 0;">{~cost(Цена)}{:unit}</div>
	{unit:}<small>&nbsp;руб.</small>
