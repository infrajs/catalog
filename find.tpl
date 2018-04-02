{root:}
	{data.breadcrumbs:cat.breadcrumbs}
	<h1>Поиск по каталогу</h1>
	<form style="margin-bottom:30px" class="form-horizontal" onsubmit="
		var val=$(this).find('[type=text]').val();
		val=Path.encode(val,true);
		var layer=Controller.names.catalog;
		
		if (Crumb.get.m) {
			var params='?m=' + Crumb.get.m;
		} else {
			var params='?m=';
		}
		params+=':search='+val;
		Crumb.go('/'+Controller.names.catalog.crumb.toString()+params);
		setTimeout(function(){
			$.getJSON('/-catalog/stat.php?submit=1&amp;val='+val);
		},1);
		return false;">

			<div class="row">
				<div class="col-md-6 col-sm-9" style="margin-bottom:15px;">
					<input class="form-control input-lg" name="search" type="text" placeholder="Поиск по каталогу">
				</div>
				<div class="col-md-3 col-sm-3" style="margin-bottom:15px">
					<input class="btn btn-primary btn-lg" type="submit" value="Искать">
				</div>
			</div>
	</form>
	{data.childs:cat.groups}
	{data.menu:cat.menu}
{cat::}-catalog/cat.tpl
{cat.mark.set:}{:cat.mark.client.set}
{cat.mark.add:}{:cat.mark.client.add}
