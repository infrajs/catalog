{breadcrumbs:}
	<ul class="breadcrumb">
		{::brcrumb}
	</ul>
	{brcrumb:}
		{active?:crumblast?:crumb}
	{crumb:}
		<li class="breadcrumb-item"><a href="{main?:hrefmain?:href}">{title}</a></li>
	{crumblast:}
		<li class="breadcrumb-item active">{title}</li>
	{add:}{:mark.add}{add}
	{set:}?m={add}
	{hrefmain:}/
	{href:}/{Controller.names.catalog.crumb}{href?:/}{href}{add?(~conf.catalog.filtermemory?:add?:set)?(~conf.catalog.filtermemory?:mark.set|(nomark))}
{mark::}-catalog/mark.tpl
{/:}/
{menu:}
	<div style="margin-top:10px">
		
		{::items}
		
	</div>
	{items:}
		<a class="badge badge-pills" href="/{Controller.names.catalog.crumb}/{~key}{:mark.set}">{title}</a>
{idsp:}{item_nick?:sp}{item_nick}{(iscatkit&catkit)?:ampvalsp}
{sp:} 
{kit:}{article_nick}{item_num!:odin?:pval}
{odin:}1
{pval:}:{item_num}
{idsl:}{(item_num!:odin|(iscatkit&catkit))?item_num:slval}{(iscatkit&catkit)?catkit:slval}
{idsladd:}{item_num:slval}/{(iscatkit&catkit)?catkit:slvalamp}
{sl:}/
{ampvalsp:}{item_nick|:sp}&{catkit}
{slval:}/{.}
{slvalamp:}/{.}&
{pospath:}{Controller.names.catalog.crumb}/{producer_nick|...producer_nick}/{article_nick|...article_nick}{:idsl}
{pospathadd:}{Controller.names.catalog.crumb}/{producer_nick}/{article_nick}{:idsladd}
