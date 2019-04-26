{root:}
	{data.breadcrumbs:cat.breadcrumbs}
	<h1>Производители</h1>
	<div style="padding:10px; font-size:12px; margin-bottom:20px;">
		{data.list::catprod1}
	</div>
	<div style="background-color:white; padding:10px; text-align:center; margin-bottom:20px;">
		{data.list::catprod}
	</div>
	{data.text}
	{data.menu:cat.menu}
{catprod1:}
	<a href='/{crumb.parent}/{producer_nick}{:cat.mark.set}' title="{producer} {count}">{producer}</a>{~last()?:point?:comma}
{comma:},
{point:}.
{catprod:}
	{logo?:catprodlogo}
{catprodlogo:}
	<a href='/{crumb.parent}/{producer_nick}{:cat.mark.set}' title="{producer} {.}"><img alt="{producer}" width="100" style="margin-bottom:10px" src="/-imager/?w=100&src={logo}"></a>
{cat::}-catalog/cat.tpl
{cat.mark.set:}{:cat.mark.client.set}
{cat.mark.add:}{:cat.mark.client.add}
