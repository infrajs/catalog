{root:}
	{~length(data.list)>:0?:showroot}
	{showroot:}
		<div class="mb-3">{data.list::showmf}</div>
	{showmf:}
		{:{tplfilter}?:{tplfilter}?:prop-default}
		<script type="module">
			import { Crumb } from '/vendor/infrajs/controller/src/Crumb.js'
			let div = document.getElementById('{div}')
			let cls = cls => div.getElementsByClassName(cls)
			for (let s of cls('propselect')) {
				s.addEventListener('change', async () => {
					let val = s.value; 
					Crumb.go('/catalog/{:get}'+val+'=1')
				})
			}
		</script>
{prop-default:}
	{:prop-select}
{prop-select:}
	<select class="propselect mb-3 custom-select form-control shadow-over">
		<option value="" style="font-weight: bold">{title?title?prop}</option>
		{values::fopt}
	</select>
{prop-chain-card:}
	<div class="card">
		<div class="card-header bg-primary text-uppercase font-weight-bold">
			{title|prop}
		</div>
		<div class="card-body">
			{chain:prop-select-chain}
		</div>
	</div>
	{bgclsdef:}alert alert-success
{prop-chain:}
	<div class="{bgcls|:bgclsdef}" style="margin-bottom:10px;">
		<b>{prop}</b>
		{chain:prop-select-chain}
	</div>
	{prop-select-chain:}
		{~length(childs)>:0?:prop-select-chain-show}
		{prop-select-chain-show:}
			<select style="margin-top:3px;" 
			class="chain{key} custom-select form-control mb-0 shadow-over">
				<option>{key}</option>
				{childs::foptkey}
			</select>
			<script type="module">
				import { Crumb } from '/vendor/infrajs/controller/src/Crumb.js'
				import { Session } from '/vendor/infrajs/session/Session.js'
				import { Seq } from '/vendor/infrajs/sequence/Seq.js'
				import { Layer } from '/vendor/infrajs/controller/src/Layer.js'
				let cls = (cls, div = document.getElementById('{div}')) => div.getElementsByClassName(cls)[0]
				cls('chain{key}').addEventListener('change', async function () {
					var value = this.value;
					var layer = await Layer.get({id});
					var root = Seq.right('{~dataroot()}');
					var prop_nick = root[2];
					var key = '{key}';
					var data = await Load.on('json', layer.json);
					var param = data.list[prop_nick];
					var option = Seq.getr(Seq.getr({ data: data }, root),['childs',value]);
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
						Session.set('cat-chain.{key}')
						Crumb.go(src)

					} else {
						Session.set('cat-chain.{key}', value); 
						layer.parsed='{counter}'; 
						DOM.emit('check')
					}
				})
			</script>
			{Session.get(:cat-chain.{key})?childs[Session.get(f-chain.{key})]:prop-select-chain}
			
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
	{fbtn:}<label data-crumb="/catalog/{:getv}" class="btn btn-secondary {:is?:active}">
			<input type="radio" name="options" id="option1" autocomplete="off" {:is?:checked}> {value}
		</label>
{prop-image:}
	<div class="mt-3 text-left">
		{values::prodimg}
	</div>
{prop-row:}
	<div style="margin-bottom:10px;">
		<b>{prop}</b>{help:help}: {multi?values::varowmulti?values::varow}
	</div>
	<script type="module">
		import { CDN } from '/vendor/akiyatkin/load/CDN.js'
		CDN.load('jquery', () => {
			$('[data-toggle="tooltip"]').tooltip();	
		})
	</script>
	{help:}&nbsp;<i style="cursor: pointer; color:gray" 
		data-toggle="tooltip" title="{.}" data-html="true" 
		data-trigger="click" class="far fa-question-circle"></i>
	{varowmulti:}<span 
		data-crumb="/catalog/{:getvmulti}" 
		class="a {:is?:font-weight-bold}">{value}</span>{~last()|:comma}
	{varow:}<span 
		data-crumb="/catalog/{:getv}" 
		class="a {:is?:font-weight-bold}">{value}</span>{~last()|:comma}
	{comma:}, 
	{font-weight-bold:}font-weight-bold border-0
{prop-a:}
	<div class="my-3">
		{values::va}
	</div>
	{va:}<span 
	data-crumb="/catalog/{:getv}" 
	class="a {:is?:font-weight-bold}">{value}</span><br>



	{prodimg:}
		<a href="/catalog/{:getv}"><img class="img-fluid mb-4 mr-4" src="/-imager?w=200&src={...src}&name={value}"></a>
		
	{fopt:}<option {:is?:selected} value="{value_nick}">{value}</option>
	
	{is:}{(data.md.more[...prop_nick][value_nick]|data.md[...prop_nick][value_nick])?:yes}
	{get:}{:cat.mark.add}{more?:more.}{prop_nick}::.
	{getvmulti:}{:cat.mark.add}{...more?:more.}{...prop_nick}.{value_nick}{:is??:one}
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
				/*#costslider{prop_nick} .noUi-connect {
					background-color: var(--primary);
				}*/
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
			<script type="module">
				import { CDN } from '/vendor/akiyatkin/load/CDN.js'
				import { DOM } from '/vendor/akiyatkin/load/DOM.js'
				import { Ascroll } from '/vendor/infrajs/ascroll/Ascroll.js'
				import { Crumb } from '/vendor/infrajs/controller/src/Crumb.js'

				var m = "{data.m}"
				var path = "more.{prop_nick}"
				var min = {min|:0}
				var max = {max|:100}
				var origminval = {minval|:0}
				var origmaxval = {maxval|:100}
				var step = {step|:10}
				var go = function (minval, maxval){
					Ascroll.once = false
					if (min >= minval && max <= maxval) {
						Crumb.go('/catalog?m=' + m + ':'+path+'.minmax')
					}else if (minval == maxval) {
						var minv = minval - step
						var maxv = Number(maxval) + step
						if (minv < min) minv = min
						if (maxv > max) maxv = max
						Crumb.go('/catalog?m=' + m + ':' + path + '.minmax=' + minv + '/' + maxv)
					} else {
						Crumb.go('/catalog?m=' + m + ':' + path + '.minmax='+minval+'/'+maxval)
					}
				}
				var slider = document.getElementById('costslider{prop_nick}')

				CDN.on('load','nouislider').then(() => {
					if (!slider.closest('body')) return
					noUiSlider.create(slider, {
						start: [origminval, origmaxval],
						connect: true,	
						animate:true,
						step:step,
						range: {
							'min': min,
							'max': max
						}
					})

					var inpmin = document.getElementById('inpmin{prop_nick}')
					var inpmax = document.getElementById('inpmax{prop_nick}')

					slider.noUiSlider.on('update', function( values, handle ) {
						if(!slider.closest('body')) return
						var value = values[handle]
						if ( handle ) { //max
							inpmax.value = Math.round(value)
						} else { //min
							inpmin.value = Math.round(value)
						}
						
					})
					slider.noUiSlider.on('set', function (values) {
						var min = Math.round(values[0])
						var max = Math.round(values[1])
						go(min, max)
					})

					inpmax.addEventListener('change', function(){
						slider.noUiSlider.set([null, this.value])
					})
					inpmin.addEventListener('change', function(){
						slider.noUiSlider.set([this.value, null])
					})
				})					
			</script>
		</div>
		{costlabel:}Цена,&nbsp;руб.
		{costlabelno:}
	{prop-slider:}
		<div class="mb-3">
			<style scoped>
				.propslide {
					margin-bottom:10px;
				}
			</style>
			<div>
				<div class="d-flex justify-content-between" style="font-weight:bold;">
					<div>
					  	{prop}
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
			<script type="module">
				import { CDN } from '/vendor/akiyatkin/load/CDN.js'
				import { Ascroll } from '/vendor/infrajs/ascroll/Ascroll.js'
				import { Crumb } from '/vendor/infrajs/controller/src/Crumb.js'
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
				CDN.fire('load','nouislider').then(async () => {
					if (!slider.closest('body')) return
					
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
						if (!slider.closest('body')) return
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
{checked:}checked
