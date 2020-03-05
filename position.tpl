{root:}
	{:css}
	{data.breadcrumbs:cat.breadcrumbs}
	{data.result?data.pos:start?:error}
{css:}
	<style scoped>
		/*.cat-position .bigimage {
			border-top:1px dotted gray;
			text-align:center;
			padding-top:10px;
			padding-bottom:10px;
		}*/

		.cat-position .files {
			margin:0;padding:0;
			list-style: none;
			margin-top: 6px;
		}
		.cat-position .files li {
			line-height: 18px;
			padding-left: 25px;
		}
		.cat-position .files .ico {
			/*background-image: url("images/pdf_icon.png");*/
			background-repeat: no-repeat;
			background-position: 0px 1px;
		}
		/*.cat-position .information {
			line-height: 18px;
			margin-top: 25px;
			font-weight: bold;
		}*/
	</style>
{error:}
	<div class="alert alert-danger">Позиция <b>{crumb.parent.name} {crumb.name}</b> не найдена!</div>
{extend::}-catalog/extend.tpl
{model::}-catalog/model.tpl
{CATPOSIMAGES:}
	{~length(images)?:images}
{images:}
	{~inArray(group_nick,~conf.catalog.bigimage)?:bigimg}
	<div class="d-flex" style="clear:both; text-align:center; margin-top:10px; margin-bottom:10px;">
		<div class="flex-grow-1">
			{images.0:imagelg}
		</div>
		<div>
			{images::image}
		</div>
	</div>
	<script async type="module">
		(async () => {
			let Load = (await import('/vendor/akiyatkin/load/Load.js')).default
			let CDN = await Load.on('import-default', '/vendor/akiyatkin/load/CDN.js')
			await CDN.load('magnific-popup')
			let div = document.getElementById('{div}')
			$(div).find('a.gallery').magnificPopup({
				type: 'image',
				gallery:{
					enabled:true
				}
			})
		})()
	</script>
	
	{image:}
		{~key=:0??:imagesm}
	{imagesm:}
		<a class="gallery" title="{..Наименование}" href="/-imager/?m=1&src={.}">
			<img class="img-fluid" title="{data.pos.producer} {data.pos.article}" 
			src="/-imager/?m=1&h=50&top=1&src={.}" />
		</a>
	{imagelg:}
		<a class="gallery" title="{..Наименование}" href="/-imager/?m=1&src={.}">
			<img class="img-fluid" title="{data.pos.producer} {data.pos.article}" 
			src="/-imager/?m=1&h=400&top=1&src={.}" />
		</a>
{start:}
	<div class="cat-position">
		<div style="float:right">
			{logo?:producer}
		</div>
		<h1 style="text-align:left">{Наименование}{~conf.showcase.hiddenarticle??:startart}</h1>
		{items?:showitems}
		{:model.css}
		{images.0?:imagesyes?:imagesno}
		{imagesno:}
			<div class="mb-3">
				{:props}
			</div>
		{imagesyes:}
		<div class="row">
			<div class="col-md-6 mb-3">
				<div id="CATPOSIMAGES"></div>
			</div>
			<div class="col-md-6 mb-3">
				{:props}
			</div>
		</div>
		{:body}
	</div>
	{body:}
		<div class="mb-4">
			{texts::text}
			{~length(files)?:files}
		</div>
		{:info}
		<div class="mb-3">	
			Перейти к группе <a data-anchor='.breadcrumb' href="{group_nick:model.link-val}">{group}</a><br>
		</div>
	{props:}
			<div class="mb-3">{:model.CARDS-props}</div>
			<div>{Скрыть фильтры в полном описании??:print_more}</div>
	{strСкрытый:}Скрытый
	{startart:}<br><small>{producer} {article}</small>
{info:}
	<div class="alert alert-primary pb-2">
		<div class="row">
			<div class="col-sm-6 mb-2">
				<b><a href="/guaranty">Гарантия</a></b>
				<div>Бесплатное устранение неполадки, замена товара на аналогичный или возврата денежных средств</div>
			</div>
			<div class="col-sm-6 mb-2">	
				<b><a href="/return">Возврат в течение 60 дней</a></b>
				<div>Вернуть и обменять товары можно в течении 60 дней со дня получения товара.</div>
			</div>
			<div class="col-sm-6 mb-2">
				<b><a href="/pay">Оплата</a></b>
				<div>На карту Сбербанка, наличные при получении, оплата картой VISA, MASTERCARD при самовывозе.</div>
			</div>
			<div class="col-sm-6 mb-2">
				<b><a href="/transport">Доставка по всей России и СНГ</a></b>
				<div>Почта России, Курьерская доставка почтой EMS, Транспортные компании: СДЭК, ПЭК, Деловые Линии, Байкал Сервис, Энергия, КИТ, Желдор экспедиция, Возовоз</div>
			</div>
			
		</div>
	</div>
{showitems:}
	<table id="items" class="table table-striped table-hover table-sm">
		<thead>
			<tr>
				{itemmore::ihead}
				{~inArray(:Наименование,itemrows)?:headname}
				{~inArray(:Цена,itemrows)?:headcost}
			</tr>
		</thead>
		<tbody style="cursor:pointer;">
			{items::iitem}
		</tbody>
	</table>
	{Наименование:}Наименование
	{Цена:}Цена
	{prcost:}<td>{Цена?:prnowcost}</td>
	{prnowcost:}{~cost(Цена)}&nbsp;руб.
	{headcost:}<th>Цена</th>
	{headdescr:}<th>Описание</th>
	{headname:}<th>Наименование</th>
	{prname:}<td>{Наименование}</td>
	{iitem:}
		<tr style="cursor:pointer; font-size:14px" class="{...item_nick=item_nick?:table-success}" onclick="Ascroll.once = '.cat_images'; Crumb.go('/{crumb}{:cat.idsl}{:cat.mark.set}');">
			{~obj(:more,more,:itm,.,:pos,...,:list,...itemmore).list::imore}
			{~inArray(:Наименование,...itemrows)?:prname}
			{~inArray(:Цена,...itemrows)?:prcost}
		</tr>
		{table-success:}font-weight-bold
		{imore:}<td>{Dabudi.propget(...pos,.,...itm)}</td>
	{ihead:}<th>{.}</th>
{print_more:}
	{~length(more)?:printmorenow}
	{printmorenow:}
	<table class="table table-striped table-sm" style="width:auto">
		{more::pos_more}
	</table>
{pos_more:}<tr><td>{~key}:</td><th style="text-align:left">{.}</th></tr>
{files:}
	<h2>Файлы для {Продажа} {producer} {~conf.showcase.hiddenarticle??article}</h2>
		<ul class="files">
			{files::file}
		</ul>
	{file:}
		<li class="ico" style="background-image:url('/-autoedit/icons/{ext}.png')">
			<a href="/{path}">{name}</a> {size}&nbsp;Mb
		</li>
{text:}
	{.}
{bigimg:}<img class="img-fluid" src="/-imager/?m=1&src={images.0}">

{producer:}
	<div style="float:right; padding:10px 10px 10px 10px; margin-left:5px; margin-bottom:5px;">
		<a data-anchor=".pagination" title="Посмотреть продукцию {producer}" href="/{crumb.parent.parent}{:cat.mark.add}producer.{producer_nick}=1">
			<img style="margin-left:5px" src="/-imager/?w=160&h=70&src={logo}" />
		</a>
	</div>
<!--	<div style="text-align:right; font-size: 11px; margin-top:5px;">
		{producer.Страна|}
	</div>
	-->
{strcatalog:}catalog
{cat::}-catalog/cat.tpl
{cat.mark.set:}{:cat.mark.client.set}
{cat.mark.add:}{:cat.mark.client.add}
{extend.cat.mark.set:}{:cat.mark.set}
{extend.cat.mark.add:}{:cat.mark.add}
