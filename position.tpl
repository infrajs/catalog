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
		{}
		<h1>{Наименование}<br>{Производитель} {descr.Артикул!:Скрытый?Артикул}</h1>
		{~length(images)?:images}
		{:extend.pos-page}
		<div style="color:gray; margin-bottom:30px">{Описание}</div>
		{Скрыть фильтры в полном описании??:print_more}
		{texts::text}
		{~length(files)?:files}
		<div style="clear:left">
			<hr>
			{:extend.pos-sign}
		</div>
	</div>
{print_more:}
	<table class="table table-striped">
		{more::pos_more}
	</table>
{pos_more:}<tr><td>{~key}:</td><td style="text-align:left">{.}</td></tr>
{files:}
	<h2>Файлы для {Продажа} {Производитель} {descr.Артикул!:Скрытый?Артикул} </h2>
		<ul class="files">
			{files::file}
		</ul>
	{file:}
		<li class="ico" style="background-image:url('/-autoedit/icons/{ext}.png')">
			<a href="/{src}">{name}</a> {size}&nbsp;Mb
		</li>
{text:}
	{.}
{bigimg:}<img class="img-responsive" src="/{images.0}">
{strбольшая:}Большая
{images:}
	{descr.Картинка=:strбольшая?:bigimg}
	<div class="cat_images" style="text-align:center; background-color:white; margin-top:10px; margin-bottom:10px;">
		{images::image}
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
		<div class="pull-left" style="margin:5px">
			<a class="thumbnail gallery" title="{..Наименование}" href="/-imager/?src={.}">
				<img title="{data.pos.Производитель} {data.pos.Артикул}" src="/-imager/?mark=1&h=150&w=125&crop=1&src={.}" />
			</a>
		</div>
{producer:}
	<div style="float:right; background-color:white; padding:10px 10px 10px 10px; margin-left:5px; margin-bottom:5px;">
		<a onclick="infrajs.scroll='.pagination'" title="Посмотреть продукцию {producer}" href="/{crumb.parent.parent}{:cat.mark.add}producer::.{producer}=1">
			<img style="margin-left:5px" src="/-imager/?w=160&h=100&src={infra.config(:catalog).dir}{producer}/&or=-imager/empty.png" />
		</a>
	</div>
<!--	<div style="text-align:right; font-size: 11px; margin-top:5px;">
		{producer.Страна|}
	</div>
	-->
{cat::}-catalog/cat.tpl
{cat.mark.set:}{:cat.mark.client.set}
{cat.mark.add:}{:cat.mark.client.add}
{extend.cat.mark.set:}{:cat.mark.set}
{extend.cat.mark.add:}{:cat.mark.add}
