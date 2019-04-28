{root:}
	{data.path?:h1link?:h1}
	{~conf.catalog.searchingroups?:search}
	{:GROUPS}

	{find::}-catalog/find.tpl
	{search:}{:find.find}
	{h1link:}<h1><a href="/catalog">{~conf.catalog.title}</a></h1>
	{h1:}<h1>{~conf.catalog.title}</h1>
{cat::}-catalog/cat.tpl
{GROUPS:}
	<div class="-catalog-groups">
		<style>
			.-catalog-groups .far {
				cursor:pointer;
			}
			.-catalog-groups .childs .child {
				margin-bottom:5px;
			}
			.-catalog-groups {
				/*font-size:100%;*/
			}
			.-catalog-groups .point {
				cursor: pointer;
				font-size:80%;
			}
		</style>
		{data.root.childs::child}
		<script>
			domready(function(){
				var div = $('.-catalog-groups');
				div.find('.point').click( function () {
					$(this).toggleClass('fa-minus').toggleClass('fa-plus').parent().find('.childs:first').slideToggle('slow');
				})
			})
		</script>
	</div>
{group:}
	{childs?:gr}<a data-anchor=".-catalog-groups" href="/catalog/{group_nick}{:cat.mark.server.set}" class="{active?:clsactive}">{group}</a><br>
	<div class="pl-4 childs" style="{active??:strnone}">
		{childs::child}
	</div>
	{strnone:}display:none;
	{clsactive:}font-weight-bold
	{gr:}{active?:minus?:plus}
	{plus:}<span style="color:#aaa" class="point fas fa-plus"></span> 
	{minus:}<span style="color:#aaa" class="point fas fa-minus"></span> 
{child:}
	<div class="child">{.:group}</div>
