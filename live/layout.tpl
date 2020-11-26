{root:}
	<form data-autosave="{autosavename}">
		<input name="search" type="search" class="form-control" placeholder="Поиск по каталогу">
		{:JS}
	</form>
{model::}-catalog/model.tpl
{SUGGESTION:}
		<a href="{:model.link-pos}">{images.0?:img}{Наименование}<br><b>{article}</b></a>
			<br>{Цена?:cost}
		<hr class="my-2" style="clear:both">
	{br:} <br>{.}
	{cost:} <b>{~cost(Цена)}{:model.unit}</b>
	{img:}<img style="clear:both; margin-left:5px; float:right; position:relative" src="/-imager/?src={images.0}&h=70&w=70&crop=1">
{JS:}
	<div>
		<style>
			#{div} .submit {
				cursor: pointer
			}
			.autocomplete-suggestions { border: 1px solid #999; background: #FFF; overflow: auto; }
			.autocomplete-suggestion { 
				padding: 2px 5px; 
				/*white-space: nowrap; */
				/*overflow: hidden; */
			}
			.autocomplete-selected { 
				background-color: white; 
			}
			.autocomplete-suggestions strong { font-weight: normal; color: #3399FF; cursor:pointer;}
			.autocomplete-group { padding: 2px 5px; }
			.autocomplete-group strong { display: block; border-bottom: 1px solid #000; }
		</style>
		<script type="module">
			import { inViewport } from '/vendor/akiyatkin/load/inViewport.js'
			import { CDN } from '/vendor/akiyatkin/load/CDN.js'
			import { Autosave } from '/vendor/akiyatkin/form/Autosave.js'
			import { Catalog } from '/vendor/infrajs/catalog/Catalog.js'
			import { Crumb } from '/vendor/infrajs/controller/src/Crumb.js'
			import { Template } from '/vendor/infrajs/template/Template.js'
			//let Template

			
			const form = document.getElementById('{div}').getElementsByTagName('form')[0]
			const cls = cls => form.getElementsByClassName(cls)
			const tag = tag => form.getElementsByTagName(tag)
			inViewport(form, ()=> {
				for (let btn of cls('submit')) {
					btn.addEventListener('click', ()=>{
						let event = new Event('submit');
						form.dispatchEvent(event);
					})
				}

				form.addEventListener('submit', (event) => {
					event.preventDefault()
					var query = tag('input')[0].value
					Catalog.search(query);
				})

				Autosave.init(form, form.dataset.autosave)


				CDN.fire('load','jquery.autocomplete').then(() => {
					
					if (!form.closest('html')) return;

					$(tag('input')).autocomplete({
						triggerSelectOnValidInput:false,
						showNoSuggestionNotice:true,
						noSuggestionNotice:'<div class="p-2">По запросу ничего не найдено. Попробуйте изменить запрос или поискать по <a onclick="$(\'#{div}\').find(\'input\').autocomplete(\'hide\'); Crumb.go(\'/catalog\'); $(\'#{div}\').find(\'input\').blur(); return false" href="/catalog">группам</a>.</div>',
						serviceUrl: function (q) {
							var query = encodeURIComponent(q);
							return '/-showcase/api2/live/?query=' + query;
						},
						onSearchStart: async () => {
							//Template = (await import('/vendor/infrajs/template/Template.js')).Template
						},
						onSelect: function (suggestion) {
							return;
						},
						transformResult: function (ans) {
							var query = form.getElementsByTagName('input')[0].value
							return {
								suggestions: $.map(ans.list, function (pos) {
									return { 
										value: query, 
										data: pos 
									};
								})
							};
						},
						dataType:"json",
						ignoreParams: true,
						formatResult: function (suggestion, currentValue) {
							if (!currentValue) return suggestion;
							return Template.parse('-catalog/live/layout.tpl',suggestion.data, 'SUGGESTION');
					    },
					    groupBy2:'group',
					    onSearchComplete: function (suggestion) {
					    	var q = encodeURIComponent(suggestion);
					    	
					    	$('.autocomplete-suggestions').not(':last()').remove();
					    	
					    	if ($('.autocomplete-suggestions').find('.msgready').length) {
								DOM.emit('load')
								return;
							}
					    	if ($('.autocomplete-suggestion').length < 10) {
					    		$('.autocomplete-suggestions').append('<div class="msgready" style="margin:10px 5px 5px 5px;" onclick="$(\'#{div}\').find(\'input\').autocomplete(\'hide\'); Crumb.go(\'/catalog/'+q+'\');"><a onclick="return false" href="/catalog" class="float-right"><b>Открыть каталог</b></a></div>');
					    	} else {
					    		$('.autocomplete-suggestions').append('<div class="msgready" style="margin:10px 5px 5px 5px;" onclick="$(\'#{div}\').find(\'input\').autocomplete(\'hide\'); Crumb.go(\'/catalog/'+q+'\'); "><a onclick="return false" href="/catalog" class="float-right"><b>Показать всё</b></a></div>');
					    	}
					    	//Чтобы ссылки в результатах поиска были асинхронными
							DOM.emit('load')
					    	
					    }
					}).autocomplete('disable').click( function (){
						$(this).autocomplete('enable');
					});

				});
			});
		</script>
	</div>