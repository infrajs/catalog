{cat::}-catalog/cat.tpl
{css:}
	<style>
		#{div} .props .line {
			margin-right:10px;
			border-bottom: 1px dotted #ccc; 
			width:100%
		}
		#{div} .cat_item .title {
			display:block;
			background-color:#EFEFEF;
			text-decoration: none;
			color:#222222;
		}
		#{div} .cat_item .padding {
			padding:4px 8px;
		}
		#{div} .cat_item .title:hover {
			background-color:gray;
			color:white;
		}
	</style>
{CARDS-list:}
	{:css}
	<div class="row">
		{::CARDS-item}
	</div>
{CARDS-item:}
	<div class="mb-4 col-12 col-sm-6 col-lg-6 col-xl-4">
		{:CARDS-data}
	</div>
{CARDS-data:}
	{:CARDS-image}
	{:CARDS-name}
	{:CARDS-props}
	{:CARDS-basket}
{CARDS-image:}
	{Наличие на складе?:nalichie}
	{images.0?:posimg}
{CARDS-name:}
	<a class="d-block py-2 text-truncate" href="/catalog/{producer_nick}/{article_nick}{:cat.idsl}{:cat.mark.set}">
		{Наименование|article}
	</a>
{CARDS-props:}
	<table class="props">
		{showcase.props::trprop}
	</table>
		{trprop:}
		{:pval?:trpropshow}
		{trpropshow:}
			{ptpl?(:{ptpl})?:prop-default}
		{prop-default:}
			<tr>
				<td class="d-flex"><div>{prop}:</div><div class="line"></div></td>
				<td>{:pval}</td>
			</tr>
		{prop-bold:}
			<tr>
				<td class="d-flex"><div>{prop}:</div><div class="line"></div></td>
				<th>{:pval}</th>
			</tr>
		{prop-link:}
			<tr>
				<td class="d-flex"><div>{prop}:</div><div class="line"></div></td>
				<td><a href="/catalog/{(....)[nick]}{:orig.cat.mark.set}">{:pval}</a></td>
			</tr>
	{pval:}{(....)[value]|(....).more[value]}
	{pnick:}{(....)[nick]|(....).more[nick]}
{CARDS-basket:}
	<div class="float-right">{Цена?:itemcost}</div>
{ROWS-list:}
	{:css}
		<div style="clear:both"></div>
		{::cat_item}
	{cat_item:}
		<div class="position" style="margin-bottom:20px;">
			{:pos-item}
		</div>
{ROWS-item:}
{ROWS-data:}
{ROWS-name:}
{ROWS-props:}

{itemcost:}<span class="cost">{~cost(Цена)}{:unit}</span>
{unit:}<small>&nbsp;руб.</small>
{sp:}&nbsp;
{nalichie:}
	<div style="position:absolute; left:15px; z-index:1" class="m-1">{:badgenalichie}</div>
{badgenalichie:}
	{Наличие на складе?:badgenalichieshow}
	{badgenalichieshow:}
		<a href="/catalog{:cat.mark.add}more.{Path.encode(:strНаличие-на-складе)}::.{Path.encode(Наличие на складе)}=1" 
			class="badge {:ncls}">
			{Наличие на складе}
		</a>
	{model-cls-src:}-catalog/model-cls.json
	{ncls:}
		{~data(:model-cls-src)[Наличие на складе]|:clsdef}		
	{clsdef:}badge-secondary
{prodimg:}
	<a data-anchor=".breadcrumb" title="Посмотреть продукцию {producer}" href="/{Controller.names.catalog.crumb}/{producer}{:cat.mark.set}" class="float-right p-2">
		<img width="100" src="/-imager/?w=100&amp;h=100&amp;src={logo}" />
	</a>
{posimg:}
	<a href="/{Controller.names.catalog.crumb}/{producer_nick}/{article_nick}{:cat.idsl}{:cat.mark.set}">
		<img class="img-fluid" src="/-imager/?m=1&amp;w=528&amp;h=528&amp;top=1&amp;crop=1&amp;src={images.0}" />
	</a>
{pos-item:}
	<div class="row cat_item">
		<div class="{images.0??:mobimghide}col-12 col-sm-4 col-md-3">
			{images.0?:pos-img?:pos-img}
		</div>
		<div class="col-12 col-sm-8 col-md-9">
			<a class="title padding" href="/{Controller.names.catalog.crumb}/{producer_nick}/{article_nick}{:cat.idsl}{:cat.mark.set}">{Наименование|:name}</a>
			{logo?:producerlogo}
			<div class="float-right" style="font-size:90%; margin-left:10px; clear:right"><a data-anchor=".breadcrumb" href="/{Controller.names.catalog.crumb}/{group_nick}{:cat.mark.set}">{group}</a></div>
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
		<a data-anchor=".breadcrumb" title="Посмотреть продукцию {producer}" href="/{Controller.names.catalog.crumb}{:cat.mark.add}producer.{producer_nick}=1" class="float-right" style="margin:5px 0 5px 5px">
			<img width="100" src="/-imager/?w=100&amp;h=100&amp;src={logo}" />
		</a>