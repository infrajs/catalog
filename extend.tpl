{pos-page:}{Цена?:priceblockbig}
	{priceblockbig:}
		<div class="alert alert-success">
			Цена: <span style="font-size:20px">{~cost(Цена)} руб.</span>{:nds}<br> 
			<!--По вопросам приобретения обращайтесь по телефонам в <a href="/contacts">контактах</a>.-->
		</div>
	{nds:}{~conf.catalog.nds?:ndsshow}{ndsshow:} c <abbr title="Налог на Добавленную Стоимость">НДС</abbr>
{pos-sign:}
	<p>
		Перейти к группе <a data-anchor='.breadcrumb' href="/{crumb.parent.parent}{:cat.mark.add}group::.{group}=1">{group}</a><br>
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
		<a class="thumbnail" href="/{Controller.names.catalog.crumb}/{producer}/{article}{:cat.idsl}{:cat.mark.set}">
			<img src="/-imager/?mark=1&amp;w=256&amp;h=256&amp;src={images.0}&amp;or=-imager/empty.png" />
		</a>
{pos-item:}
	<div class="row cat_item">
		<div class="col-xs-4 col-sm-3">
			{images.0?:pos-img}
		</div>
		<div class="col-xs-8 col-sm-9">
			<a class="title padding" href="/{Controller.names.catalog.crumb}/{producer}/{article}{:cat.idsl}{:cat.mark.set}">{Наименование|:name}</a>
			{:producerlogo}
			<div class="padding">
				<b><a href="/{Controller.names.catalog.crumb}/{producer}/{article}{:cat.idsl}{:cat.mark.set}">{Производитель} {descr.Артикул!:Скрытый?Артикул?Наименование}</a></b>
				<div class="pull-right" style="font-size:90%"><a data-anchor=".breadcrumb" href="/{Controller.names.catalog.crumb}{:cat.mark.add}group::.{group}=1">{Группа}</a></div>
			</div>
			{more?:havemore?:nomore}
		</div>
	</div>

	{name:}{Артикул}
	{havemore:}
		<div class="padding" style="font-family:Tahoma; font-size:85%; margin-bottom:10px">    
			{more::cat_more}
		</div>
		<div class="padding">
			{Цена?:priceblock}
		</div>
		{Описание?:descrshow}
		{descrshow:}
		<div class="padding">
			<span style="border-bottom:1px dashed gray; cursor:pointer" onclick="$(this).next().slideToggle();">Описание</span>
			<div style="display:none;">
				{Описание}
				<b><a href="/{Controller.names.catalog.crumb}/{producer}/{article}{:cat.idsl}{:cat.mark.set}">Подробнее</a></b>
			</div>
		</div>
	{nomore:}
		<div class="padding">
			<div style="font-family:Tahoma; font-size:85%; margin-bottom:10px">{Описание}</div>
			{Цена?:priceblock}
			<b><a href="/{Controller.names.catalog.crumb}/{producer}/{article}{:cat.idsl}{:cat.mark.set}">Подробнее</a></b>
		</div>
	{cat_more:}{(.&(.!:no))?:more}
	{more:}{~key}:&nbsp;{.}{~last()|:comma}
	{comma:}, 
	{no:}Нет
	{producerlogo:}
		<a data-anchor=".breadcrumb" title="Посмотреть продукцию {Производитель}" href="/{Controller.names.catalog.crumb}{:cat.mark.add}producer::.{producer}=1" class="pull-right" style="margin:5px 0 5px 5px">
			<img src="/-imager/?w=100&amp;h=100&amp;src={Config.get(:strcatalog).dir}{producer}/&amp;or=-imager/empty.png" />
		</a>
	{cat::}-catalog/cat.tpl
	{strcatalog:}catalog
	{priceblock:}<div class="alert alert-success" style="clear:right; font-size:140%; padding:5px 10px; margin:15px 0;">{~cost(Цена)}&nbsp;руб.</div>
