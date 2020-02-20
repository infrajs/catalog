{root:}
	<form>
		<input name="search" type="search" class="form-control" placeholder="Поиск по каталогу">
		{:JS}
	</form>
{extend::}-catalog/extend.tpl
{SUGGESTION:}
		<a href="/catalog/{producer_nick}/{article_nick}{:extend.cat.idsl}">{images.0?:img}{Наименование}<br><b>{article}</b></a>
			<br>{Цена?:cost}
		<hr class="my-2" style="clear:both">
	{br:} <br>{.}
	{cost:} <b>{~cost(Цена)}{:extend.unit}</b>
	{img:}<img style="clear:both; margin-left:5px; float:right; position:relative" src="/-imager/?src={images.0}&h=70&w=70&crop=1">

{JSform:}
	<script async type="module">
		(async () => {
			let Load = (await import('/vendor/akiyatkin/load/Load.js')).default;
			let CDN = await Load.on('import-default', '/vendor/akiyatkin/load/CDN.js')
			await CDN.load('jquery')
	
			let div = $(document.getElementById('{div}'));
			div.find('form').submit( async (evt) => {
				evt.preventDefault();
				var q = div.find('input').val();

				let Wait = await Load.on('import-default', '/vendor/akiyatkin/load/Wait.js')
				await Wait();
				Catalog.search(q);
			});
		})();
	</script>
{JS:}
	<div>
		<style>
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
		{:JSform}
		<script async type="module">
			let iscontext = () => {
				if (!window.Controller) return true;
				let layer = Controller.ids[{id}];
				if (!layer) return true;
				return layer.counter == {counter};
			}

			(async () => {
				let Load = (await import('/vendor/akiyatkin/load/Load.js')).default;
				let Wait = await Load.on('import-default', '/vendor/akiyatkin/load/Wait.js')
				let CDN = await Load.on('import-default', '/vendor/akiyatkin/load/CDN.js')
				await CDN.load('jquery.autocomplete');
				
				let div = $(document.getElementById('{div}'));
				div.find('form').submit( function (evt) {
					var q = div.find('input').val();
					Catalog.search(q);
					evt.preventDefault();
					return false;
				});
				

				if (!iscontext()) return;

				div.find('input').autocomplete({
					triggerSelectOnValidInput:true,
					showNoSuggestionNotice:true,
					noSuggestionNotice:'<div class="p-2">По запросу ничего не найдено. Попробуйте изменить запрос или поискать по <a onclick="$(\'#{div}\').find(\'input\').autocomplete(\'hide\'); Crumb.go(\'/catalog\'); $(\'#{div}\').find(\'input\').blur(); return false" href="/catalog">группам</a>.</div>',
					serviceUrl: function (q) {
						var query = encodeURIComponent(q);
						return '/-catalog/live/' + query;
					},
					onSelect: function (suggestion) {
						return;
					},
					transformResult: function (ans) {
						var query = div.find('input').val();
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
				    	
				    	if ($('.autocomplete-suggestions').find('.msgready').length) return;
				    	if ($('.autocomplete-suggestion').length < 10) {
				    		$('.autocomplete-suggestions').append('<div class="msgready" style="margin:10px 5px 5px 5px;" onclick="$(\'#{div}\').find(\'input\').autocomplete(\'hide\'); Crumb.go(\'/catalog/'+q+'\');"><a onclick="return false" href="/catalog" class="float-right"><b>Открыть каталог</b></a></div>');
				    	} else {
				    		$('.autocomplete-suggestions').append('<div class="msgready" style="margin:10px 5px 5px 5px;" onclick="$(\'#{div}\').find(\'input\').autocomplete(\'hide\'); Crumb.go(\'/catalog/'+q+'\'); "><a onclick="return false" href="/catalog" class="float-right"><b>Показать всё</b></a></div>');
				    	}
				    	Controller.check();
				    	
				    }
				}).autocomplete('disable').click( function (){
					$(this).autocomplete('enable');
				});

			})();
		</script>
	</div>