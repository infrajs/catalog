{root:}
	{data.breadcrumbs:cat.breadcrumbs}
	<h1>Поиск по каталогу</h1>
	{:find}
	{data.childs:cat.groups}
	{data.menu:cat.menu}
{find:}
	<form class="form-horizontal" onsubmit="
		var val=$(this).find('[type=text]').val();
		val=Path.encode(val,true);
		var layer=Controller.names.catalog;
		
		if (Crumb.get.m) {
			var params='?m=' + Crumb.get.m;
		} else {
			var params='';
		}
		//params+=':search='+val;
		Crumb.go('/'+Controller.names.catalog.crumb.toString()+'/'+val+params);
		setTimeout(function(){
			$.getJSON('/-catalog/stat.php?submit=1&amp;val='+val);
		},1);
		return false;">

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
