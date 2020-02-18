{root:}
	{data.path?:h1link?:h1}
	{~conf.catalog.searchingroups?:find}
	{:GROUPS}
	{h1link:}<h1><a href="/catalog">{~conf.catalog.title}</a></h1>
	{h1:}<h1>{~conf.catalog.title}</h1>
{search::}-cart/rest/search/layout.tpl
{find:}
	<form style="margin-bottom:15px;">
		<input class="form-control" name="search" type="text" placeholder="Поиск по каталогу">
	</form>
	{:search.JS}
{cat::}-catalog/cat.tpl
{GROUPS:}
	<div class="-catalog-groups child">
		<style>
			.-catalog-groups .far {
				cursor:pointer;
			}
			.-catalog-groups .childs {
				margin-top:5px;
			}
			.-catalog-groups .child {
				margin-bottom:5px;
			}
			.-catalog-groups {
				/*font-size:100%;*/
			}
			.-catalog-groups .point {
				cursor: pointer;
				font-size:130%;
			}
			.bt {
				border-top:1px solid var(--gray);
			}
			.bb {
				border-bottom:1px solid var(--gray);
			}
		</style>
		{data.root.childs::child1}
		<script>
			domready(function(){
				var div = $('.-catalog-groups');
				div.find('.point').click( function () {
					$(this).toggleClass('{:iopen}').toggleClass('{:iclose}').parents('.top:first').find('.childs:first').slideToggle('fast');
				})
			})
		</script>
	</div>
{iopen:}fa-angle-left
{iclose:}fa-angle-down
{child1:}
	<div class="top">{.:group2}</div>
{group2:}
	<div class="py-2 px-3 d-flex justify-content-between align-items-center" style="border-top:1px solid var(--gray)">
		<a href="/catalog/{group_nick}{:cat.mark.server.set}" class="{active?:clsactive} text-uppercase">{group}</a><div>{~length(childs)?:gr?:it}</div>
	</div>
	<div class="py-2 px-3 bt childs" style="{active??:strnone}">
		{childs::child2}
	</div>
	{notlast:}pb-2 mb-2 bb
{child2:}
	<div class="child {~last()?:last?:notlast}">{.:group3}</div>
{group3:}
	<div class="d-flex justify-content-between">
		<a href="/catalog/{group_nick}{:cat.mark.server.set}" class="{active?:clsactive}">{group}</a> <span class="ml-2" style="margin-right:7px; color:gray">{count}</span>
	</div>
	{strnone:}display:none;
	{clsactive:}font-weight-bold
	{gr:}{active?:open?:close}
	{it:}
	{close:}<span class="point fas {:iopen} fa-fw"></span> 
	{open:}<span class="point fas {:iclose} fa-fw"></span> 
