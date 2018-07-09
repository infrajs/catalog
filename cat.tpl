{groups:}
	<div class="catgrouplist row">
		{::groups_group}
	</div>
	{groups_group:}
		<div class="col-sm-6">
			<a class="thumbnail" data-anchor='.breadcrumb' href="/{Controller.names.catalog.crumb}/{id}{:mark.set}">
				<table>
					<tr>
						<td class="img">
							{pos.images.0?:gimg}
						</td>
						<td class="name">
							{title}
						</td>
					</tr>
				</table>
			</a>
		</div>
		{gimg:}<img src="/-imager/?src={pos.images.0}&w=110&h=80">
{breadcrumbs:}
	<ul class="breadcrumb">
		{::brcrumb}
	</ul>
	{brcrumb:}
		{active?:crumblast?:crumb}
	{crumb:}
		<li class="breadcrumb-item"><a data-anchor='.breadcrumb' href="{main?:hrefmain?:href}">{title}</a></li>
	{crumblast:}
		<li class="breadcrumb-item active">{title}</li>
	{add:}{:mark.add}{add}
	{hrefmain:}/
	{href:}/{Controller.names.catalog.crumb}{href?:/}{href}{add?:add?(nomark|:mark.set)}
{mark::}-catalog/mark.tpl
{/:}/
{menu:}
	<div style="margin-top:10px">
		<ul class="nav nav-pills">
			{::items}
		</ul>
	</div>
	{items:}
		<li role="presentation"><a data-anchor='.breadcrumb' href="/{Controller.names.catalog.crumb}/{~key}{:mark.set}">{title}</a></li>
{idsp:}{id?:sp}{id}
{sp:} 
{idsl:}{id?:sl}{id}
{sl:}/
