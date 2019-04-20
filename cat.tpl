{groups:}
	<div>
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
			.catgrouplist {
				
			}
			.catgrouplist a {
				font-size:1.2rem;
				outline:solid 1px rgba(0,0,0,0.1);
			}
			/*.catgrouplist :last-child a {
				outline-offset: -1px;
				margin-left:-1px;
			}*/
			.catgrouplist a:hover {
				outline-color:rgba(0,0,0,0.3);
				position:relative;
				z-index:2;
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
		<div class="catgrouplist row no-gutters mb-4">
			{::groups_group}
		</div>
	</div>
	{groups_group:}
		<div class="col-sm-6">
			<a class="d-flex p-1 bg-white" style="align-items:center; min-height:92px;" data-anchor='.breadcrumb' href="/{Controller.names.catalog.crumb}/{group_nick}{:mark.set}">
				<div style="flex-basis: 130px; text-align:center">
					{img?:gimg}
				</div>
				<div style="flex:1; padding-left: 5px;">
					{group}
				</div>
			</a>
		</div>
		{gimg:}<img src="/-imager/?src={img}&w=130&h=90">
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
	{set:}?m={add}
	{hrefmain:}/
	{href:}/{Controller.names.catalog.crumb}{href?:/}{href}{add?(~conf.catalog.filtermemory?:add?:set)?(~conf.catalog.filtermemory?(nomark)|mark.set)}
{mark::}-catalog/mark.tpl
{/:}/
{menu:}
	<div style="margin-top:10px">
		
		{::items}
		
	</div>
	{items:}
		<a class="badge badge-pills" data-anchor='.breadcrumb' href="/{Controller.names.catalog.crumb}/{~key}{:mark.set}">{title}</a>
{idsp:}{item_nick?:sp}{item_nick}
{sp:} 
{idsl:}{item_nick?:sl}{item_nick}
{sl:}/
