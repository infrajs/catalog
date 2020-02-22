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
	<div class="child">
		<style>
			#{div} .far {
				cursor:pointer;
			}
			
			#{div} .child {
				margin-bottom:5px;
			}
			
			#{div} .header {
				cursor: pointer;
			}
			#{div} .point {
				font-size:130%;
			}
			#{div} .bt {
				border-top:1px solid var(--gray);
			}
			#{div} .bb {
				border-bottom:1px solid var(--gray);
			}
		    #{div} .childs {
		        max-height: 0;
			    opacity: 0;
			    overflow: hidden;
			    transition: 0.5s;
		    }
		    #{div} .childs.show {
		    	display: block;
		    	opacity: 1;
		    	max-height: 400px;
		    }
		</style>
		{data.root.childs::child1}
		<script type="module">
			(async () => {
				let div = document.getElementById('{div}')
				let cls = cls => div.getElementsByClassName(cls)
				let points = cls('point')
				for (let i = 0, l = points.length; i < l; i++ ) {
					let point = points[i];
					point.parentNode.parentNode.addEventListener('click', (e) => {
						point.classList.toggle('{:iopen}')
						point.classList.toggle('{:iclose}')
						let childs = point.parentNode.parentNode.nextSibling.nextSibling
						childs.classList.toggle('show')
					})
				}
			})()
		</script>
	</div>
{iopen:}fa-angle-left
{iclose:}fa-angle-down
{child1:}
	<div class="top">{.:group2}</div>
{group2:}
	<div class="header py-2 px-3 d-flex justify-content-between align-items-center" style="border-top:1px solid var(--gray)">
		<a href="/catalog/{group_nick}{:cat.mark.server.set}" class="{active?:clsactive} text-uppercase">{group}</a><div>{~length(childs)?:gr?:it}</div>
	</div>
	<div class="bt childs {active?:stron?:strnone}">
		<div class="py-2 px-3">
			{childs::child2}
		</div>
	</div>
	{notlast:}pb-2 mb-2 bb
{child2:}
	<div class="child {~last()?:last?:notlast}">{.:group3}</div>
{group3:}
	<div class="d-flex justify-content-between">
		<a href="/catalog/{group_nick}{:cat.mark.server.set}" class="{active?:clsactive}">{group}</a> <span class="ml-2" style="margin-right:7px; color:gray">{count}</span>
	</div>
	{stron:}show
	{strnone:}
	{clsactive:}font-weight-bold
	{gr:}{active?:open?:close}
	{it:}
	{close:}<span class="point fas {:iopen} fa-fw"></span> 
	{open:}<span class="point fas {:iclose} fa-fw"></span> 
