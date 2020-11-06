{cat::}-catalog/cat.tpl
{css:}
	<style>
		#{div} .props .line {
			margin-right:10px;
			border-bottom: 1px dotted #ccc; 
			flex-grow: 1;
		}
		#{div} .props .limit {
			max-width: 150px;
			text-overflow: ellipsis;
			overflow: hidden;
			white-space: nowrap;
		}
		#{div} .model {
			border:1px solid var(--gray);
			position: relative;

		}
	</style>
{PRINT-item:}
	<p>
		{model.Наименование} {model.producer} {model.article}{model.item:pr}
		<br><b>{count}</b> по <b>{~cost(cost)}{:unit}</b> = <b>{~cost(sum)}{:unit}</b>
	</p>
	{pr:} {.}
{CARDS-list:}
	{:css}
	<div class="row">
		{::CARDS-item}
	</div>
{CARDS-item:}
	<div class="mb-4 col-12 col-md-6 col-lg-4 col-xl-3 d-flex justify-content-stretch">
		<div class="d-flex flex-column justify-content-between model shadow-over w-100">{:CARDS-data}</div>
	</div>
{CARDS-data:}
	<div>
		{:CARDS-image}
		<div class="px-3 pt-2">
			{:CARDS-name}
			{:CARDS-props}
		</div>
	</div>
	<div class="px-3 pb-3 pt-2">
		{:CARDS-basket}
	</div>
{CARDS-image:}
	{Наличие?:nalichie}
	{images.0?:posimg}
{CARDS-name:}
	<a class="font-weight-bold d-block pt-1" href="{:link-pos}">
		{Наименование|article}
	</a>
{POS-props:}
	<div class="props">
		{showcase.props::posprop}
	</div>
	{posprop:}
		{:pval?:pospropshow}
		{pospropshow:}
			{tplprop?(:pos-{tplprop})?:pos-prop-filter}
			{pos-prop-default:}
				{:pos-frow}{:pval}{:/pos-frow}
			{pos-prop-bold:}
				{:pos-frow}<b>{:pval}</b>{:/pos-frow}
			{pos-prop-cost:}
				{:pos-frow}<b>{~cost(:pval)}{:unit}</b>{:/pos-frow}
			{pos-prop-link:}
				{:pos-frow}<a href="{(:pnick):link-val}">{:pval}</a>{:/pos-frow}
			{pos-prop-p:}<div class="my-1">{:pval}</div>
			{pos-prop-empty:}
			{pos-prop-filter:}
				{:pos-frow}{:fval}{:/pos-frow}
			{pos-frow:}<div class="d-flex my-1 flex-wrap"><div class="pr-2">{title?title?prop}:</div><div>{/pos-frow:}</div></div>
{fromgroup:}
	{~obj(:strgroup,Load.loadJSON(:grouppath).group,:strmore,.).group.props::divprop}
	{grouppath:}-showcase/api2/group?group_id={group_id}
	{strmore:}more
	{strgroup:}group
{CARDS-props:}
	<div class="props">
		{showcase.props?showcase.props::divprop?:fromgroup}
	</div>
	{divprop:}
		{:pval?:divpropshow}
		{divpropshow:}
			{tplprop?(:div-{tplprop})?:div-prop-filter}
		{div-prop-default:}
			<div class="d-flex my-1">
				<div class="ptitle pr-2">{prop}:</div>
				<div title="{:pval}" class="text-truncate">{:pval}</div>
			</div>
		{div-prop-hideable:}
			<div class="d-flex my-1">
				<div class="ptitle pr-2">{prop}:</div>
				<div title="{:pval}" class="text-truncate">{~length(:pval)>:strlenprim?:rowprimhidden?:pval}</div>
			</div>
		{div-prop-bold:}
			<div class="d-flex my-1">
				<div class="ptitle pr-2">{title?title?prop}:</div>
				<div title="{:pval}" class="text-truncate"><b>{:pval}</b></div>
			</div>
		{div-prop-cost:}
			<div class="d-flex my-1">
				<div class="ptitle pr-2">{prop}:</div>
				<div><b>{~cost(:pval)}{:unit}</b></div>
			</div>
		{div-prop-link:}
			<div class="d-flex my-1">
				<div class="ptitle pr-2">{prop}:</div>
				<div title="{:pval}" class="text-truncate"><a href="{(:pnick):link-val}">{:pval}</a></div>
			</div>
		{div-prop-p:}<div class="my-1">{:pval}</div>
		{div-prop-empty:}
		{div-prop-filter:}
			<div class="d-flex my-1">
				<div title="{title?title?prop}" class="ptitle pr-2 text-nowrap">{title?title?prop}:</div>
				<div style="min-width:30px" class="text-truncate">{:fval}</div>
			</div>
	{fval:}{~split(:value,((....)[value]|(....).more[value]),:nick,nick)::filter-vals}
		{filter-vals:}{~key?:comma}<a rel="nofollow" href="{:link-filter}">{value}</a>
	{pval:}{(....)[value]|(....).more[value]}
	{pnick:}{(....)[nick]|(....).more[nick]}
	{ampval:}&{.}
	{sl:}/
	{slval:}/{.}
	{link-filter:}/catalog/{:cat.mark.add}more.{nick}::.{Path.encode(value)}=1
	{link-pos:}/catalog/{producer_nick}/{article_nick}{item_nick:slval}{catkit?:sl}{catkit:ampval}{:cat.mark.set}
	{link-val:}/catalog/{.}{:cat.mark.set}
	
{CARDS-basket:}
	<div class="float-right">{Цена?:itemcost}</div>
{ROWS-list:}
	{:css}
	{::ROWS-item}
{ROWS-item:}
		<div class="row mb-5">
			<div class="text-center order-1 mt-3 mt-sm-0 order-sm-1 {images.0??:mobimghide} col-12 col-sm-4 col-md-3">
				{:ROWS-image}
			</div>
			<div class="order-2 order-sm-2 col-12 col-sm-8 col-md-9">
				{:ROWS-data}
			</div>
		</div>
	{mobimghide:}d-none d-sm-block 
{ROWS-image:}
		<div style="position: absolute">{Наличие?:nalichie}</div>
		<a href="{:link-pos}" style="border:none; text-decoration: none; display: block; 
			background-image: url('/-imager/?m=1&amp;w=525&amp;h=525&amp;src={images.0}');
			background-repeat: no-repeat;
			background-position: top center;
			min-height: 200px;
			background-size: contain;
			height:100%;
			">
		</a>
{ROWS-data:}
	<div class="bg-secondary text-white px-2 py-1 mb-2">
		{:ROWS-name}
	</div>
	<div class="px-2">
		{:ROWS-props}
		{Цена?:ROWS-basket}
	</div>
{ROWS-basket:}
	<div class="my-1 float-right">{:cost}</div>
{ROWS-name:}
	<a style="color:inherit; border:none" href="{:link-pos}">{Наименование|article}</a>
{ROWS-props:}
	{logo?:producerlogo}
	<table class="props">
		{showcase.props::trprop}
	</table>
	{trprop:}
		{:pval?:trpropshow}
	{trpropshow:}
		{tplprop?(:tr-{tplprop})?:tr-prop-filter}
	{tr-prop-hideable:}
		<tr>
			<td class="d-flex text-nowrap"><div>{prop}:</div><div class="line"></div></td><td>
			{~length(:pval)>:strlenprim?:rowprimhidden?:pval}
		</tr>
			{rowprimhidden:}<span class="a" onclick="$(this).hide().next().show()">Показать</span><span onclick="$(this).hide().prev().show()" style="display: none">{:pval}</span></td>
			{strlenprim:}30
	{tr-prop-default:}
		<tr>
			<td class="d-flex text-nowrap"><div>{prop}:</div><div class="line"></div></td>
			<td>{:pval}</td>
		</tr>
	{tr-prop-bold:}
		<tr>
			<td class="d-flex text-nowrap"><div>{title?title?prop}:</div><div class="line"></div></td>
			<th>{:pval}</th>
		</tr>
	{tr-prop-cost:}
		<tr>
			<td class="d-flex text-nowrap"><div>{prop}:</div><div class="line"></div></td>
			<th>{~cost(:pval)}{:unit}</th>
		</tr>
	{tr-prop-link:}
		<tr>
			<td class="d-flex text-nowrap"><div>{prop}:</div><div class="line"></div></td>
			<td><a rel="nofollow" href="{(:pnick):link-val}">{:pval}</a></td>
		</tr>
	{tr-prop-empty:}
	{tr-prop-p:}<tr><td colspan="2">{:pval}</td></tr>
	{tr-prop-filter:}
		<tr>
			<td>
				<div class="d-flex">
					<div title="{prop}" class="limit">{title?title?prop}:</div>
					<div class="line"></div>
				</div>
			</td>
			<td>{:fval}</td>
		</tr>
{itemcost:}
	<div class="my-1">{:cost}</div>
{cost:}
	{min?(show?:cost-one?:cost-two)?:cost-one}
	{cost-one:}
		<b class="cost {Наличие=:strАкция?:strred}">{~cost(Цена)}{:unit}</b>
		{strАкция:}Акция
		{strred:}text-danger
	{cost-two:}
		От&nbsp;<b class="cost">{~cost(min)}</b> 
		до&nbsp;<b class="cost">{~cost(max)}{:unit}</b>

{unit:}&nbsp;₽
{sp:}&nbsp;
{nalichie:}
	<div style="position:absolute; left:0px; z-index:1" class="m-3">{:badgenalichie}</div>
{badgenalichie:}
	{Наличие?:badgenalichieshow}
	{strНаличие:}Наличие
	{badgenalichieshow:}
		<a rel="nofollow" href="/catalog/{:cat.mark.add}more.{Path.encode(:strНаличие)}::.{Path.encode(Наличие)}=1" 
			class="ml-3 badge {:ncls}">
			{Наличие}
		</a>
	{model-cls-src:}-catalog/model-cls.json
	{ncls:}
		{~data(:model-cls-src)[Наличие]|:clsdef}		
	{clsdef:}badge-secondary
{prodimg:}
	<a title="Посмотреть продукцию {producer}" href="{producer_nick:link-val}" class="float-right p-2">
		<img loading="lazy" width="100" src="/-imager/?w=100&amp;h=100&amp;src={logo}" />
	</a>
{posimg:}
	<a href="{:link-pos}">
		<img loading="lazy" class="img-fluid" src="/-imager/?m=1&amp;w=525&amp;h=420&amp;top=1&amp;crop=1&amp;src={images.0}">
	</a>
	{prodart:}{producer} {article}
	{cat_more:}{(.&(.!:no))?:more}
	{more:}{~key}:&nbsp;{.}{~last()|:comma}
	{comma:}, 
	{no:}Нет
	{producerlogo:}
		<a title="Посмотреть продукцию {producer}" href="{producer_nick:link-val}" class="float-right" style="margin:5px 0 5px 5px">
			<img loading="lazy" width="100" src="/-imager/?w=100&amp;h=100&amp;src={logo}" />
		</a>