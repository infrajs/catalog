{cat::}-catalog/cat.tpl
{css:}
	<style>
		#{div} .props .line {
			margin-right:10px;
			border-bottom: 1px dotted #ccc; 
			width:100%
		}
	</style>
{PRINT-item:}
	<p>
		{Наименование} {producer} {article}{item:pr}
		<br><b>{count}</b> по <b>{~cost(cost)}&nbsp;руб.</b> = <b>{~cost(sum)}&nbsp;руб.</b>
	</p>
{CARDS-list:}
	{:css}
	<div class="row">
		{::CARDS-item}
	</div>
{CARDS-item:}
	<div class="mb-4 col-12 col-md-6 col-lg-4 col-xl-3 d-flex flex-column justify-content-between">
		{:CARDS-data}
	</div>
{CARDS-data:}
	<div>
		{:CARDS-image}
		{:CARDS-name}
		{:CARDS-props}
	</div>
	<div>
		{:CARDS-basket}
	</div>
{CARDS-image:}
	{Наличие?:nalichie}
	{images.0?:posimg}
{CARDS-name:}
	<a class="d-block mt-2 text-truncate" href="{:link-pos}">
		{Наименование|article}
	</a>
{CARDS-props:}
	<div class="props">
		{showcase.props::divprop}
	</div>
	{divprop:}
		{:pval?:divpropshow}
		{divpropshow:}
			{ptpl?(:div-{ptpl})?:div-prop-filter}
		{div-prop-default:}
			<div class="d-flex my-1">
				<div class="ptitle pr-2 text-nowrap">{prop}:</div>
				<div title="{:pval}" class="text-truncate">{:pval}</div>
			</div>
		{div-prop-bold:}
			<div class="d-flex my-1">
				<div class="ptitle pr-2 text-nowrap">{prop}:</div>
				<div title="{:pval}" class="text-truncate"><b>{:pval}</b></div>
			</div>
		{div-prop-link:}
			<div class="d-flex my-1">
				<div class="ptitle pr-2 text-nowrap">{prop}:</div>
				<div title="{:pval}" class="text-truncate"><a href="{(:pnick):link-val}">{:pval}</a></div>
			</div>
		{div-prop-p:}<div class="my-1">{:pval}</div>
		{div-prop-empty:}
		{div-prop-filter:}
			<div class="d-flex my-1">
				<div class="ptitle pr-2 text-nowrap">{prop}:</div>
				<div class="text-truncate">{:fval}</div>
			</div>
	{fval:}{~split(:value,((....)[value]|(....).more[value]),:nick,nick)::filter-vals}
		{filter-vals:}{~key?:comma}<a rel="nofollow" href="{:link-filter}">{value}</a>
		{link-filter:}/{Controller.names.catalog.crumb}/{:cat.mark.add}more.{nick}::.{Path.encode(value)}=1
	{pval:}{(....)[value]|(....).more[value]}
	{pnick:}{(....)[nick]|(....).more[nick]}
	{ampval:}&{.}
	{sl:}/
	{slval:}/{.}
	{link-pos:}/{Controller.names.catalog.crumb}/{producer_nick}/{article_nick}{item_nick:slval}{catkit?:sl}{catkit:ampval}{:cat.mark.set}
	{link-val:}/{Controller.names.catalog.crumb}/{.}{:cat.mark.set}
	
{CARDS-basket:}
	<div class="float-right">{Цена?:itemcost}</div>
{ROWS-list:}
	{:css}
	{::ROWS-item}
	{ROWS-item:}
		<div class="row mb-5">
			<div class="{images.0??:mobimghide} col-12 col-sm-4 col-md-3">
				{:ROWS-image}
			</div>
			<div class="col-12 col-sm-8 col-md-9">
				{:ROWS-data}
			</div>
		</div>
	{mobimghide:}d-none d-sm-block 
	{ROWS-image:}
		{Наличие?:nalichie}
		<a href="{:link-pos}">
			<img class="img-fluid" src="/-imager/?m=1&amp;w=525&amp;src={images.0}" />
		</a>
	{ROWS-data:}
		<div class="bg-secondary text-white px-2 py-1 mb-2">
			{:ROWS-name}
		</div>
		<div class="px-2">
			{:ROWS-props}
			{:ROWS-basket}
		</div>
		{ROWS-basket:}
			<div class="my-1 float-right">{:cost}</div>
		{ROWS-name:}
			<a style="color:inherit" href="{:link-pos}">{Наименование|article}</a>
		{ROWS-props:}
			{logo?:producerlogo}
			<table class="props">
				{showcase.props::trprop}
			</table>
			{trprop:}
				{:pval?:trpropshow}
				{trpropshow:}
					{ptpl?(:tr-{ptpl})?:tr-prop-filter}
				{tr-prop-default:}
					<tr>
						<td class="d-flex text-nowrap"><div>{prop}:</div><div class="line"></div></td>
						<td>{:pval}</td>
					</tr>
				{tr-prop-bold:}
					<tr>
						<td class="d-flex text-nowrap"><div>{prop}:</div><div class="line"></div></td>
						<th>{:pval}</th>
					</tr>
				{tr-prop-link:}
					<tr>
						<td class="d-flex text-nowrap"><div>{prop}:</div><div class="line"></div></td>
						<td><a href="{(:pnick):link-val}">{:pval}</a></td>
					</tr>
				{tr-prop-empty:}
				{tr-prop-p:}<tr><td colspan="2">{:pval}</td></tr>
				{tr-prop-filter:}
					<tr>
						<td class="d-flex text-nowrap"><div>{prop}:</div><div class="line"></div></td>
						<td>{:fval}</td>
					</tr>
{itemcost:}
	<div class="my-1">{:cost}</div>
{cost:}
	{min?(show?:cost-one?:cost-two)?:cost-one}
	{cost-one:}
		Цена:&nbsp;<b class="cost">{~cost(Цена)}{:unit}</b>
	{cost-two:}
		Цена от&nbsp;<b class="cost">{~cost(min)}</b> 
		до&nbsp;<b class="cost">{~cost(max)}{:unit}</b>

{unit:}<small>&nbsp;руб.</small>
{sp:}&nbsp;
{nalichie:}
	<div style="position:absolute; left:15px; z-index:1" class="m-1">{:badgenalichie}</div>
{badgenalichie:}
	{Наличие?:badgenalichieshow}
	{strНаличие:}Наличие
	{badgenalichieshow:}
		<a href="/{Controller.names.catalog.crumb}/{:cat.mark.add}{Path.encode(:strНаличие)}::.{Path.encode(Наличие)}=1" 
			class="badge {:ncls}">
			{Наличие}
		</a>
	{model-cls-src:}-catalog/model-cls.json
	{ncls:}
		{~data(:model-cls-src)[Наличие]|:clsdef}		
	{clsdef:}badge-secondary
{prodimg:}
	<a data-anchor=".breadcrumb" title="Посмотреть продукцию {producer}" href="{producer_nick:link-val}" class="float-right p-2">
		<img width="100" src="/-imager/?w=100&amp;h=100&amp;src={logo}" />
	</a>
{posimg:}
	<a href="{:link-pos}">
		<img class="img-fluid" src="/-imager/?m=1&amp;w=525&amp;h=420&amp;top=1&amp;crop=1&amp;src={images.0}" />
	</a>
	{prodart:}{producer} {article}
	{cat_more:}{(.&(.!:no))?:more}
	{more:}{~key}:&nbsp;{.}{~last()|:comma}
	{comma:}, 
	{no:}Нет
	{producerlogo:}
		<a data-anchor=".breadcrumb" title="Посмотреть продукцию {producer}" href="{producer_nick:link-val}" class="float-right" style="margin:5px 0 5px 5px">
			<img width="100" src="/-imager/?w=100&amp;h=100&amp;src={logo}" />
		</a>