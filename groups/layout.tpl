<div class="-catalog-groups">
	<style>
		.-catalog-groups .far {
			cursor:pointer;
		}
		.-catalog-groups {
			font-size:120%;
		}
	</style>
	{data.path?:h1link?:h1}
	{data.groups[~conf.catalog.title]childs::child}
	<script>
		domready(function(){
			var div = $('.-catalog-groups');
			div.find('.far').click( function () {
				$(this).toggleClass('fa-minus-square').toggleClass('fa-plus-square').parent().find('.childs:first').slideToggle('slow');
			})
		})
	</script>
</div>
	{h1link:}<h1><a href="/catalog">{~conf.catalog.title}</a></h1>
	{h1:}<h1>{~conf.catalog.title}</h1>
{cat::}-catalog/cat.tpl
{group:}
	{childs?:gr}<a data-anchor=".-catalog-groups" href="/catalog/{id}{:cat.mark.server.add}" class="{active?:clsactive}">{title}</a><br>
	<div class="pl-4 childs" style="{active??:strnone}">
		{childs::child}
	</div>
	{strnone:}display:none;
	{clsactive:}font-weight-bold
	{gr:}{active?:minus?:plus}
	{plus:}<span class="text-muted far fa-plus-square"></span> 
	{minus:}<span class="text-muted far fa-minus-square"></span> 
{child:}
	<div>{data.groups[id]:group}</div>
