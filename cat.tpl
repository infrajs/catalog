{groups:}
	<style>
		.catgrouplist .img {
		vertical-align:middle;
		text-align:center;
		width:120px;
		padding-right:10px;
		padding-left:0;
		height:90px;
		background-color:white;
	}
	.catgrouplist .name {
		text-align:left;
		vertical-align:middle;
		font-size:140%;
	}
	.catgrouplist a {
		font-size:1.2rem;
		border:solid 1px rgba(0,0,0,0.1);
	}
	.catgrouplist a:hover {
		border-color:gray;
	}
	@media (max-width: 1200px) { 
		.catgrouplist a {
			/*font-size:150%;*/
		}
	}
	@media (max-width:992px) { 	/*md*/
		.catgrouplist a {
			/*font-size:130%;*/
		}
		.catgrouplist .img {
			width:100px;
		}
		.catgrouplist .name {
			font-size:90%;
		}
	}
	@media (max-width:768px) { 	/*sm*/
		.catgrouplist a {
			font-size: 100%
		}
		.catgrouplist .img {
			width:120px;
		}
		.catgrouplist .name {
			font-size:120%;
		}
	}
	</style>
	<div class="catgrouplist row">
		{::groups_group}
	</div>
	{groups_group:}
		<div class="col-sm-6 mb-4">
			<a class="d-flex p-1 rounded" style="align-items:center; min-height:92;" data-anchor='.breadcrumb' href="/{Controller.names.catalog.crumb}/{id}{:mark.set}">
				<div style="flex-basis: 130px; text-align:center">
					{pos.images.0?:gimg}
				</div>
				<div style="flex:1;">
					{title}
				</div>
			</a>
		</div>
		{gimg:}<img src="/-imager/?src={pos.images.0}&w=130&h=90">
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
