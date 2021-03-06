{root:}
	<ul class="breadcrumb">
		<li class="breadcrumb-item"><a href="/catalog">Каталог</a></li>
		<li class="breadcrumb-item active">Карточки товаров</li>
	</ul>
	<h1>Группы с карточками товаров</h1>
	{:GROUPS}
{cat::}-catalog/cat.tpl?v={~conf.index.v}
{GROUPS:}
	<div class="child">
		<style>
			#{div} .far {
				cursor:pointer;
			}
			#{div} .child {
				margin-bottom:5px;
			}
			
			#{div} .point {
				cursor: pointer;
				font-size:130%;
			}
			
		</style>
		{data.root.childs::child}
	</div>

{child:}
	<h2>{group}</h2>
	search-columns
	{data:search.search-columns}
	search-rows
	{data:search.search-rows}
	
	{childs::child}
{pos:}
<div class="col-sm-4">
	{:extend.pos-item}
</div>
{search::}-catalog/search.tpl?v={~conf.index.v}
{extend::}-catalog/extend.tpl?v={~conf.index.v}