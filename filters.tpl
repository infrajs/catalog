{root:}
	{~length(data.list)>:0?data.list::showmf}
	{showmf:}
		{:{tpl}}
	{prop-select:}
		<select 
		style="margin-top:3px" 
		onchange="Crumb.go('/catalog/{:get}'+this.value+'=1')" 
		class="custom-select form-control mb-0 shadow-over">
			<option>{prop}</option>
			{values::fopt}
		</select>
	{prop-buttons:}
		<div class="my-3">
			<div class="btn-group btn-group-toggle" data-toggle="buttons">
				{values::fbtn}
			</div>
		</div>
	{prop-image:}
		<div class="my-3 text-left">
			{values::prodimg}
		</div>
	{prop-a:}
		<div class="my-3">
			{values::va}
		</div>
		{va:}<span 
		onclick="Crumb.go('/catalog/{:getv}')" 
		class="a {:is?:font-weight-bold}">{value}</span><br>
	{prodimg:}
		<a href="/catalog/{:getv}"><img class="img-fluid my-3 mr-3" src="/-imager?w=200&src={...src}&name={value}"></a>
		
	{fopt:}<option {:is?:selected} value="{value_nick}">{value}</option>
	{fbtn:}<label class="btn btn-secondary {:is?:active}">
				<input type="radio" name="options" id="option1" autocomplete="off" {:is?:checked}> {value}
			</label>
	{is:}{(data.md.more[...prop_nick][value_nick]|data.md[...prop_nick][value_nick])?:yes}
	{get:}{:cat.mark.add}{more?:more.}{prop_nick}::.
	{getv:}{...prop_nick=:producer?:getvinu?:getvinm}
	{getvinm:}{:cat.mark.add}{...more?:more.}{...prop_nick}::.{value_nick}{:is??:one}
	{getvinu:}{value_nick}{:cat.mark.set}
	{one:}=1

	{prop-cost:}
		<div style="margin-top:5px; border-bottom:1px solid #ddd">
			<style scoped>
				.costslide {
					margin-bottom:10px;
				}
				#costslider{prop_nick} .noUi-connect {
					background-color: var(--primary);
				}
				#costslider{prop_nick} {
					margin-left:10px;
					margin-right:10px;
				}
			</style>
			<div>
				<div class="d-flex justify-content-between" style="font-weight:bold; font-size:16px">
					<span>
					  	<!-- id add label checked-->
					  	{:costlabel}
						{~objasdf(:id,:costyes,:add,:more.Цена.yes,:label,:costlabel,:checked,data.md.more.Цена.yes):box}
					</span>
					<span style="font-weight:normal; font-size:14px">
							{~obj(:id,:costno,:add,:more.Цена.no,:label,:costlabelno,:checked,data.md.more.Цена.no):box}
					</span>
				</div>
			</div>
			<div class="costslide mt-1">
				<div class="row" style="margin-bottom:10px; font-size:18px">
					<div class="col-sm-6">
						<input style="width:100%; border:none; border-bottom:1px solid #ddd; padding-left:4px" id="inpmin{prop_nick}" type="text">
					</div>
					<div class="col-sm-6">
						<input style="text-align:right; width:100%; border:none; border-bottom:1px solid #ddd; padding-left:4px" id="inpmax{prop_nick}" type="text">
					</div>
				</div>
				<div id="costslider{prop_nick}"></div>
			</div>
			<div>
				<label>
				  
				</label>
			</div>
			<script>
				domready(function(){
					var m = "{data.m}";
					var path = "more.{prop_nick}";
					var min = {min|:0};
					var max = {max|:100};
					var origminval = {minval|:0};
					var origmaxval = {maxval|:100};
					var step = {step|:10};
					var go = function (minval, maxval){
						Ascroll.once = false;
						if (min >= minval && max <= maxval) {
							Crumb.go('/catalog?m=' + m + ':'+path+'.minmax');
						}else if (minval == maxval) {
							var minv = minval - step;
							var maxv = Number(maxval) + step;
							if (minv < min) minv = min;
							if (maxv > max) maxv = max;
							Crumb.go('/catalog?m=' + m + ':' + path + '.minmax=' + minv + '/' + maxv);
						} else {
							Crumb.go('/catalog?m=' + m + ':' + path + '.minmax='+minval+'/'+maxval);
						}
					}
					var slider = document.getElementById('costslider{prop_nick}');
					noUiSlider.create(slider, {
						start: [origminval, origmaxval],
						connect: true,	
						animate:true,
						step:step,
						range: {
							'min': min,
							'max': max
						}
					});

					var inpmin = document.getElementById('inpmin{prop_nick}');
					var inpmax = document.getElementById('inpmax{prop_nick}');

					slider.noUiSlider.on('update', function( values, handle ) {
						var value = values[handle];
						if ( handle ) { //max
							inpmax.value = Math.round(value);
						} else { //min
							inpmin.value = Math.round(value);
						}
						
					});
					slider.noUiSlider.on('set', function (values) {
						var min = Math.round(values[0]);
						var max = Math.round(values[1]);
						go(min, max);
					});

					inpmax.addEventListener('change', function(){
						slider.noUiSlider.set([null, this.value]);
					});
					inpmin.addEventListener('change', function(){
						slider.noUiSlider.set([this.value, null]);
					});
					
				});	
			</script>
		</div>
		{costlabel:}Цена,&nbsp;руб.
		{costlabelno:}не&nbsp;указана
		{cat::}-catalog/cat.tpl
		{box:}
			<!-- id add label checked-->
			<div style="cursor:pointer" class="custom-control custom-checkbox">
				<input onchange="Ascroll.once = false; Crumb.go('/catalog{:cat.mark.add}{add}{checked??:one}')" {checked?:checked} type="checkbox" class="custom-control-input" id="box{id}">
				<label class="custom-control-label" for="box{id}">{label}</label>
			</div>
		<!--<input style="cursor:pointer" onchange="Ascroll.once = false; Crumb.go('/catalog{:cat.mark.add}{add}')" {checked?:checked} type="checkbox">-->
































{producers:}
	<h3>Производители</h3>
	<ul>
		{data.list::prodlist}
	</ul>
	<div class="d-block d-lg-none">
		<a data-anchor=".breadcrumb" href="/{Controller.names.catalog.crumb}{:cat.mark.set}">Показать</a>
	</div>
	{prodlist:}
		<li><a data-ascroll="false"{data.fd.producer[~key]?:selprod} href="/{Controller.names.catalog.crumb}{:cat.mark.add}producer.{~key}=1">{~key} - {.}</a></li>
	{selprod:} style="font-weight:bold"
{cat::}-catalog/cat.tpl
{filters:}
<div class="catfilters">
	<style scoped>
		.catfilters .checked {
			font-weight:bold;
		}
		.catfilters small {
			color:#aaa;
			font-size:80%;
		}
		.catfilters label {
			font-weight:normal;
		}
		.catfilters .disabled {
			color:#999;
		}
		
		
	</style>
	{~length(data.blocks)?:filtersbody}
</div>
	{filtersbody:}
		<div style="margin-top:20px; font-size:38px; opacity: 0.2; text-transform: uppercase; font-weight: bold;">Фильтры</div>
		<div class="space">
			{data.blocks::layout}
		</div>
		<div class="space">
			Найдено <a class="a" rel="nofollow" data-anchor="h1" href="/catalog{:cat.mark.set}">{data.search} {~words(data.search,:pos1,:pos2,:pos5)}</a>
		</div>
		{pos1:}позиция
		{pos2:}позиции
		{pos5:}позиций
{layout:}
	{:layout-{layout}}
{layout-default:}
	<div style="margin-top:5px; border-bottom:1px solid #ddd">
		<div>
			<label style="font-weight:bold;">
			  {data.count!count?:box}
			  {title}&nbsp;<small>{filter}</small>
			</label>
		</div>
		{row::option}
	</div>
	{option:}
		<div class="{filter??:disabled}">
			<label style="cursor:pointer">
			  {:box} {title}&nbsp;<small>{filter}</small>
			</label>
		</div>
{checked:}checked
{disabled:}disabled
{*box:}<input style="cursor:pointer" onchange="Ascroll.once = false; Crumb.go('/catalog{:cat.mark.add}{add}')" {checked?:checked} type="checkbox">
