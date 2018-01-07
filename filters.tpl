{producers:}
	<h3>Производители</h3>
	<ul>
		{data.list::prodlist}
	</ul>
	<div class="visible-xs visible-sm">
		<a data-anchor=".breadcrumb" href="/{Controller.names.catalog.crumb}{:cat.mark.set}">Показать</a>
	</div>
	{prodlist:}
		<li><a data-ascroll="false"{data.fd.producer[~key]?:selprod} href="/{Controller.names.catalog.crumb}{:cat.mark.add}producer.{~key}=1">{~key} - {.}</a></li>
	{selprod:} style="font-weight:bold"
{cat::}-catalog/cat.tpl
{filters:}
<div class="catfilters">
	<style scoped>
		.catfilters .checked {
			font-weight:bold;
		}
		.catfilters small {
			color:#aaa;
			font-size:80%;
		}
		.catfilters label {
			font-weight:normal;
		}
		.catfilters .disabled {
			color:#999;
		}
		
		
	</style>
	{~length(data.blocks)?:filtersbody}
</div>
	{filtersbody:}
		<h1>Фильтры</h1>
		<div class="space">
			{data.blocks::block}
		</div>
		<div class="space">
			Найдено <a class="a" rel="nofollow" data-anchor="h1" href="/catalog{:cat.mark.set}">{data.search} {~words(data.search,:pos1,:pos2,:pos5)}</a>
		</div>
		{pos1:}позиция
		{pos2:}позиции
		{pos5:}позиций
{block:}
	{:blocks-{layout}}
{blocks-default:}
	<div style="margin-top:5px; border-bottom:1px solid #ddd">
		<div>
			<label style="font-weight:bold;">
			  {data.count!count?:box}
			  {title}&nbsp;<small>{filter}</small>
			</label>
		</div>
		{row::option}
	</div>
	{option:}
		<div class="{filter??:disabled}">
			<label style="cursor:pointer">
			  {:box} {title}&nbsp;<small>{filter}</small>
			</label>
		</div>
{checked:}checked
{disabled:}disabled
{box:}<input style="cursor:pointer" onchange="Ascroll.once = false; Crumb.go('/catalog{:cat.mark.add}{add}')" {checked?:checked} type="checkbox">
