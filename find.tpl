{root:}
	{data.breadcrumbs:cat.breadcrumbs}
	<h1>Поиск по каталогу</h1>
	{:find}
	{data.childs:cat.groups}
	{data.menu:cat.menu}
{find:}
	<form class="form-horizontal" onsubmit="return Catalog.search($(this).find('[type=text]').val())">

			<div class="input-group" style="margin-bottom:15px;">
				
				<input class="form-control form-control" name="search" type="text" placeholder="Поиск по каталогу">
				<div class="input-group-append">
					<input class="btn btn-primary btn" type="submit" value="Искать">
				</div>
			</div>
	</form>
{cat::}-catalog/cat.tpl
{cat.mark.set:}{:cat.mark.client.set}
{cat.mark.add:}{:cat.mark.client.add}
