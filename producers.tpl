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
	<a href='?{crumb.parent}{:cat.mark.add}producer.{~key}=1' title="{~key} {.}">{~key}</a>{~last()?:point?:comma}
{comma:},
{point:}.
{catprod:}
	<a href='?{crumb.parent}{:cat.mark.add}producer.{~key}=1' title="{~key} {.}"><img alt="{~key}" style="margin-bottom:10px" src="/-imager/?w=100&src={infra.config(:catalog).dir}{~key}/&or=-imager/empty.png"></a>
{cat::}-catalog/cat.tpl
{cat.mark.set:}{:cat.mark.client.set}
{cat.mark.add:}{:cat.mark.client.add}
