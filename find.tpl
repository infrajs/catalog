{root:}
	{data.breadcrumbs:cat.breadcrumbs}
	<h1>Поиск по каталогу</h1>
	{:find}
	<div class="d-none" id="filgroups"></div>
	{data.childs:search.groups-blocks}
{find:}
	<form class="form-horizontal">
		<div class="input-group" style="margin-bottom:15px;">
			
			<input class="form-control form-control" name="search" type="text" placeholder="Поиск по каталогу">
			<div class="input-group-append">
				<input class="btn btn-primary btn" type="submit" value="Искать">
			</div>
		</div>
	</form>
	<script type="module">
		import { CDN } from '/vendor/akiyatkin/load/CDN.js'
		import { Catalog } from '/vendor/infrajs/catalog/Catalog.js'
		let div = document.getElementById('{div}')
		let tag = tag => div.getElementsByTagName(tag)
		tag('form')[0].addEventListener('submit', async function (event) {
			event.preventDefault()
			Catalog.search($(this).find('[type=text]').val())	
		})
	</script>
{cat::}-catalog/cat.tpl
{search::}-catalog/search.tpl
{cat.mark.set:}{:cat.mark.client.set}
{cat.mark.add:}{:cat.mark.client.add}
