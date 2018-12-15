<style scoped>
	.cat-position .bigimage {
		border-top:1px dotted gray;
		text-align:center;
		padding-top:10px;
		padding-bottom:10px;
	}

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
{data.breadcrumbs:cat.breadcrumbs}
{data.result?data.pos:start?:error}
{error:}
	<div class="alert alert-danger">Позиция <b>{crumb.parent.name} {crumb.name}</b> не найдена!</div>
{extend::}-catalog/extend.tpl
{start:}
	<div class="cat-position">
		<div style="float:right">
			{:producer}
		</div>
		<h1 style="text-align:left">{Наименование}{descr.Артикул!:Скрытый?:startart}</h1>
		<div><small class="text-muted">{itemrow}</small></div>
		{~length(images)?:images}
		{:extend.pos-page}
		<div style="color:gray; margin-bottom:30px; margin-top:15px">{Описание}</div>
		{Скрыть фильтры в полном описании??:print_more}
		
		<small class="text-muted a gagarin">{itemrow}</small>
		<div style="display:none">
			{items?:showitems}
		</div>

		{texts::text}
		{~length(files)?:files}
		<div style="clear:left; margin-bottom: 50px">
			<hr>
			{:extend.pos-sign}
		</div>
	</div>
	{startart:} <nobr>{Производитель}</nobr> <nobr>{Артикул}</nobr>
{showitems:}
	<table class="table table-striped table-hover">
		<thead>
			<tr>
				{items.0.more::ihead}
				{Цена?:headcost}
			</tr>
		</thead>
		<tbody style="cursor:pointer;">
			<tr class="success" onclick="Ascroll.ignore = '.cat-position'; Crumb.go('/{crumb}{:cat.idsl}{:cat.mark.set}');">
				{~obj(:more,items.0.more,:pos,.).more::imore}
				{...Цена?:prcost}
			</tr>
		
			{items::iitem}
		</tbody>
	</table>
	{prcost:}<td>{~cost(Цена|...Цена)}&nbsp;руб.</td>
	{headcost:}<th>Цена</th>
	{iitem:}
		<tr style="cursor:pointer" onclick="Ascroll.once = '.cat-position'; Crumb.go('/{crumb}{:cat.idsl}{:cat.mark.set}');">
			{~obj(:more,more,:itm,.,:pos,...).more::imore}
			{Цена?:prcost}
		</tr>
		{imore:}<td>{Dabudi.propget(...pos,~key,...itm)}</td>

	{ihead:}<th>{~key}</th>
{print_more:}
	<table class="table table-striped" style="width:auto">
		{more::pos_more}
	</table>
	
{pos_more:}<tr><td>{~key}:</td><th style="text-align:left">{.}</th></tr>
{files:}
	<h2>Файлы для {Продажа} {Производитель} {descr.Артикул!:Скрытый?Артикул}</h2>
		<ul class="files">
			{files::file}
		</ul>
	{file:}
		<li class="ico" style="background-image:url('/-autoedit/icons/{ext}.png')">
			<a href="/{src}">{name}</a> {size}&nbsp;Mb
		</li>
{text:}
	{.}
{bigimg:}<img class="img-fluid" src="/-imager/?src={images.0}">
{strбольшая:}Большая
{images:}
	{descr.Картинка=:strбольшая?:bigimg}
	<div class="cat_images" style="clear:both; text-align:center; margin-top:10px; margin-bottom:10px;">
		{descr.Картинка=:strбольшая?(~length(images)>:1?images::image)?images::imagedef}
		<div style="clear:both"></div>
	</div>
	<script>
		domready( function () {
			var div = $('.cat-position .cat_images');
			if (!div.magnificPopup) return console.info('Требуется magnificPopup');
				
			div.find('a.gallery').magnificPopup({
				type: 'image',
				gallery:{
					enabled:true
				}
			});
		
		});
	</script>
	{image:}
		<div class="float-left" style="margin:5px">
			<a class="gallery" title="{..Наименование}" href="/-imager/?src={.}">
				<img class="img-thumbnail" title="{data.pos.Производитель} {data.pos.Артикул}" src="/-imager/?mark=1&h=150&top=1&src={.}" />
			</a>
		</div>
	{imagedef:}
		<div class="float-left" style="margin:5px">
			<a class="gallery" style="margin-bottom:0;" title="{..Наименование}" href="/-imager/?src={.}">
				<img class="img-thumbnail" title="{data.pos.Производитель} {data.pos.Артикул}" src="/-imager/?mark=1&h={~key=:0?:320?:150}&top=1&src={.}" />
			</a>
		</div>
{producer:}
	<div style="float:right; padding:10px 10px 10px 10px; margin-left:5px; margin-bottom:5px;">
		<a data-anchor=".pagination" title="Посмотреть продукцию {producer}" href="/{crumb.parent.parent}/{producer}{:cat.mark.set}">
			<img style="margin-left:5px" src="/-imager/?w=160&h=100&src={Config.get(:strcatalog).dir}{producer}/&or=-imager/empty.png" />
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
