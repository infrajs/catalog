{cat::}-catalog/cat.tpl
{css:}
	<style>
		#{div} .props .line {
			margin-right:10px;
			border-bottom: 1px dotted #ccc; 
			width:100%
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
	{:CARDS-name}
	{:CARDS-props}
	{:CARDS-cost}
{CARDS-name:}
	{Наличие на складе?:nalichie}
	{images.0?:posimg?:sp}
	<a class="d-block py-2 text-truncate" href="/catalog/{producer_nick}/{article_nick}{:cat.idsl}{:cat.mark.set}">
		{Наименование|article}
	</a>
{CARDS-props:}
	<table class="props">
		{showcase.props::trprop}
	</table>
	{trprop:}

		{(....)[value]?:trpropshow}
		{trpropshow:}
		<tr>
			<td class="d-flex"><div>{title}:</div><div class="line"></div></td>
			{link?:tdlink?:tdstr}
		</tr>
		{tdlink:}
			<td><a href="/catalog/{(....)[nick]}{:orig.cat.mark.set}">{(....)[value]}</td>
		{tdstr:}
			<td>{(....)[value]}</td>
{CARDS-cost:}
	<div class="float-right">{Цена?:itemcost}</div>

{extend::}-catalog/extend.tpl
{ROWS-list:}
	{:extend.pos-item-css}
		<div style="clear:both"></div>
		{::cat_item}
	{cat_item:}
		<div class="position" style="margin-bottom:20px;">
			{:extend.pos-item}
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