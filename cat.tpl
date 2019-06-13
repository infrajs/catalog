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
				font-size:120%;
			}
			.catgrouplist {
				
			}
			.catgrouplist a {
				font-size:1rem;
				border:solid 1px rgba(0,0,0,0.1);
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
					/*font-size:100%;*/
				}
			}
			@media (max-width: 1092px) { 
				.catgrouplist a {
					/*font-size:95%;*/
				}
			}
			@media (max-width:992px) { 	/*md*/
				.catgrouplist a {
					font-size:1rem;
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
					/*font-size: 85%*/
				}
				.catgrouplist .img {
					width:100px;
				}
				.catgrouplist .name {
					font-size:120%;
				}
			}
		</style>
		<div class="catgrouplist row no-gutters mb-4" style="margin-left:-5px; margin-right:-5px">
			{::groups_group}
		</div>
	</div>
	{groups_group:}
		<div class="col-sm-6 col-md-4 col-lg-6 col-xl-4" style="padding:5px">
			<a class="d-flex p-1 bg-white rounded" style="align-items:center; height:68px;" data-anchor='.breadcrumb' href="/{Controller.names.catalog.crumb}/{group_nick}{:mark.set}">
				<div style="text-align:center; width:70px">
					{img?:gimg}
				</div>
				<div style="padding-left: 5px; padding-right:3px; text-align:center;">
					{group}
				</div>
			</a>
		</div>
		{gimg:}<img class="img-fluid" src="/-imager/?src={img}&w=130&h=60">
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
	{href:}/{Controller.names.catalog.crumb}{href?:/}{href}{add?(~conf.catalog.filtermemory?:add?:set)?(~conf.catalog.filtermemory?:mark.set|(nomark))}
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
