{pos-page:}{Цена?:priceblockbig}
	{priceblockbig:}
		<div class="alert alert-success">
			Цена: <span style="font-size:20px">{~cost(Цена)} руб.</span>{:nds}<br> 
			<!--По вопросам приобретения обращайтесь по телефонам в <a href="/contacts">контактах</a>.-->
		</div>
	{nds:}{~conf.catalog.nds?:ndsshow}{ndsshow:} c НДС 20%
{pos-sign:}
	<p>
		Перейти к группе <a data-anchor='.breadcrumb' href="/{crumb.parent.parent}/{group}{:cat.mark.set}">{Группа}</a><br>
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
{pos-img:}
		<a href="/{Controller.names.catalog.crumb}/{producer_nick}/{article_nick}{:cat.idsl}{:cat.mark.set}">
			<img class="img-thumbnail" src="/-imager/?m=1&amp;w=256&amp;h=256&amp;src={images.0}&amp;or=-imager/empty.png" />
		</a>
{pos-item:}
	<div class="row cat_item">
		<div class="col-4 col-md-3">
			{images.0?:pos-img}
		</div>
		<div class="col-8 col-md-9">
			<a class="title padding" href="/{Controller.names.catalog.crumb}/{producer_nick}/{article_nick}{:cat.idsl}{:cat.mark.set}">{Наименование|:name}</a>
			{:producerlogo}
			<div class="padding">
				<b><a href="/{Controller.names.catalog.crumb}/{producer_nick}/{article_nick}{:cat.idsl}{:cat.mark.set}">{producer} {~conf.showcase.hiddenarticle??article}</a></b>
				<div class="float-right" style="font-size:90%; margin-left:10px"><a data-anchor=".breadcrumb" href="/{Controller.names.catalog.crumb}/{group_nick}{:cat.mark.set}">{group}</a></div>
			</div>
			{(more&~conf.catalog.showmore)?:havemore?:nomore}
		</div>
	</div>

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
		<a data-anchor=".breadcrumb" title="Посмотреть продукцию {producer}" href="/{Controller.names.catalog.crumb}/{producer}{:cat.mark.set}" class="float-right" style="margin:5px 0 5px 5px">
			<img src="/-imager/?w=100&amp;h=100&amp;src={Config.get(:strcatalog).dir}{producer}/&amp;or=-imager/empty.png" />
		</a>
	{cat::}-catalog/cat.tpl
	{strcatalog:}catalog
	{priceblock:}<div class="alert alert-success" style="clear:right; font-size:140%; padding:5px 10px; margin:15px 0;">{~cost(Цена)}&nbsp;руб.</div>
{nalichie:}<span class="badge {Наличие на складе=:strnal?:strpri?(Наличие на складе=:strras?:label-success?(Наличие на складе=:strzak?:label-info?(Наличие на складе=:stract?:label-danger?:label-default)))}">
		{Наличие на складе}</span>
	{strnal:}В наличии
	{stract:}Акция
	{strras:}Распродажа
	{strzak:}На заказ
	{strpri:}badge-primary
	{label-success:}badge-success
	{label-info:}badge-info
	{label-default:}badge-secondary
	{label-danger:}badge-danger