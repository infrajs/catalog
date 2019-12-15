{root:}
	{~length(data.list)>:0?:showroot}
	{showroot:}
	<div class="space">{data.list::showmf}</div>
	{showmf:}
		{:{tpl}}
{prop-default:}
	{:prop-select}
{prop-select:}
	<select 
	style="margin-top:3px; margin-bottom:10px" 
	onchange="Crumb.go('/catalog/{:get}'+this.value+'=1')" 
	class="custom-select form-control shadow-over">
		<option value="" style="font-weight: bold">{prop}</option>
		{values::fopt}
	</select>

{prop-chain:}
	<div class="{bgcls|:bgclsdef}" style="margin-bottom:10px;">
		<b>{prop}</b>
		{chain:prop-select-chain}
	</div>
	{bgclsdef:}alert alert-success
	{prop-select-chain:}
		{~length(childs)>:0?:prop-select-chain-show}
		{prop-select-chain-show:}
			<select style="margin-top:3px;" 
			onchange="
				
				var value = this.value;
				var layer = Controller.ids['{id}'];
				var root = Sequence.right('{~dataroot()}');
				var prop_nick = root[2];
				var key = '{key}';
				var data = Load.loadJSON(layer.json);
				var param = data.list[prop_nick];
				var option = Sequence.get(Sequence.get({ data: data }, root),['childs',value]);
				
				var count = 0;
				if (option && option.childs) {
					for (var i in option.childs) count++;
					if (count == 1) {
						if (i == value) count = 0;
					}
				}

				if (option && (count<1)) {
					var src = '/catalog/?m=' + data.m + ':';
						src += param.more?'more.':'';
					if (!option.childs) {
						src += prop_nick+'::.'+value+'=1';
					} else {
						while (option.childs) {
							for (var i in option.childs) break;
							option = option.childs[i];
						}
						src += prop_nick+'::.'+i+'=1';
					}
					Session.set('cat-chain.{key}');
					Crumb.go(src);

				} else {
					Session.set('cat-chain.{key}', value); 
					layer.parsed='{counter}'; 
					Controller.check();
				}
				
			" 
			class="custom-select form-control mb-0 shadow-over">
				<option>{key}</option>
				{childs::foptkey}
			</select>
			{Session.get(:cat-chain.{key})?childs[Session.get(:cat-chain.{key})]:prop-select-chain}
			
			{foptkey:}<option {:isch?:selected} value="{nick}">{value}</option>
			{isch:}{Session.get(:cat-chain.{...key})=nick?:yes}
{prop-buttons2:}
	<div class="my-3">
		<div class="btn-group btn-group-toggle" data-toggle="buttons">
			<label class="btn disabled">{prop}</label>
			{values::fbtn}
		</div>
	</div>
{prop-buttons:}
	<div class="my-3">
		<div class="btn-group btn-group-toggle" data-toggle="buttons">
			{values::fbtn}
		</div>
	</div>
	{fbtn:}<label onclick="Crumb.go('/catalog/{:getv}')" class="btn btn-secondary {:is?:active}">
			<input type="radio" name="options" id="option1" autocomplete="off" {:is?:checked}> {value}
		</label>
{prop-image:}
	<div class="mt-3 text-left">
		{values::prodimg}
	</div>
{prop-row:}
	<div style="margin-bottom:10px;">
		<b>{prop}</b>: {values::varow}
	</div>
	{varow:}<span 
	onclick="Crumb.go('/catalog/{:getv}')" 
	class="a {:is?:font-weight-bold}">{value}</span>{~last()|:comma}
	{comma:}, 
	{font-weight-bold:}font-weight-bold border-0
{prop-a:}
	<div class="my-3">
		{values::va}
	</div>
	{va:}<span 
	onclick="Crumb.go('/catalog/{:getv}')" 
	class="a {:is?:font-weight-bold}">{value}</span><br>



	{prodimg:}
		<a href="/catalog/{:getv}"><img class="img-fluid mb-4 mr-4" src="/-imager?w=200&src={...src}&name={value}"></a>
		
	{fopt:}<option {:is?:selected} value="{value_nick}">{value}</option>
	
	{is:}{(data.md.more[...prop_nick][value_nick]|data.md[...prop_nick][value_nick])?:yes}
	{get:}{:cat.mark.add}{more?:more.}{prop_nick}::.
	{getv:}{...prop_nick=:producer?:getvinu?:getvinm}
		{getvinm:}{:cat.mark.add}{...more?:more.}{...prop_nick}::.{value_nick}{:is??:one}
		{getvinu:}{value_nick}{:cat.mark.set}
	{one:}=1
	{selno:}selno{prop_nick}
	{prop-cost:}
		<div class="mb-3">
			<style scoped>
				.costslide {
					margin-bottom:10px;
				}
				#costslider{prop_nick} .noUi-connect {
					background-color: var(--primary);
				}
				/*#costslider{prop_nick} {
					margin-left:15px;
					margin-right:15px;
				}*/
			</style>
			<div>
				<div class="d-flex justify-content-between" style="font-weight:bold; overflow: hidden;">
					<div>
					  	{:costlabel}
					</div>
					<div style="font-weight:normal; margin-right:-0.5rem; position: relative;" title="Не указано">
							{~obj(:id,:selno,:add,:more.{prop_nick}.no,:label,:costlabelno,:checked,data.md.more[prop_nick]no):box}
					</div>
				</div>
			</div>
			<div class="costslide mt-1">
				<div class="row" style="margin-bottom:10px;">
					<div class="col-sm-6">
						<input style="width:100%; border:none;" id="inpmin{prop_nick}" type="text">
					</div>
					<div class="col-sm-6">
						<input style="text-align:right; width:100%; border:none; padding-left:4px;" id="inpmax{prop_nick}" type="text">
					</div>
				</div>
				<div id="costslider{prop_nick}"></div>
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
		{costlabelno:}
		{cat::}-catalog/cat.tpl
		{box:}
			<!-- id add label checked-->
			<div style="cursor:pointer" class="custom-control custom-checkbox">
				<input onchange="Ascroll.once = false; Crumb.go('/catalog{:cat.mark.add}{add}{checked??:one}')" {checked?:checked} type="checkbox" class="custom-control-input" id="box{id}">
				<label class="custom-control-label" for="box{id}">{label}</label>
			</div>
		<!--<input style="cursor:pointer" onchange="Ascroll.once = false; Crumb.go('/catalog{:cat.mark.add}{add}')" {checked?:checked} type="checkbox">-->

	{prop-slider:}
		<div class="mb-3">
			<style scoped>
				.propslide {
					margin-bottom:10px;
				}
				/*.propslide .noUi-horizontal {
					height: 10px;
				}
				.propslide .noUi-horizontal .noUi-handle {
					height: 20px;
				}
				.propslide .noUi-horizontal .noUi-handle:after, .propslide .noUi-horizontal .noUi-handle:before {
					height: 6px;
				}*/
				#propslide{prop_nick} .noUi-connect {
					background-color: var(--primary);
				}
				#propslide{prop_nick} {
					/*margin-left:15px;
					margin-right:15px;*/
				}
			</style>
			<div>
				<div class="d-flex justify-content-between" style="font-weight:bold;">
					<div>
					  	{prop}
					</div>
					<div style="font-weight:normal; margin-right:-0.5rem" title="Не указано">
							{~obj(:id,:selno,:add,:more.{prop_nick}.no,:label,:costlabelno,:checked,data.md.more[prop_nick]no):box}
					</div>
				</div>
			</div>
			<div class="propslide mt-1">
				<div class="row" style="margin-bottom:10px;">
					<div class="col-sm-6">
						<input style="width:100%; border:none;" id="inpmin{prop_nick}" type="text">
					</div>
					<div class="col-sm-6">
						<input style="text-align:right; width:100%; border:none; padding-left:4px;" id="inpmax{prop_nick}" type="text">
					</div>
				</div>
				<div id="propslide{prop_nick}"></div>
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
					var slider = document.getElementById('propslide{prop_nick}');
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
