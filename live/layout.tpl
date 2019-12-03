{root:}
<div class="cart-search-complete">
	<style>
		.autocomplete-suggestions { border: 1px solid #999; background: #FFF; overflow: auto; }
		.autocomplete-suggestion { padding: 2px 5px; white-space: nowrap; overflow: hidden; }
		.autocomplete-selected { 
			background-color: white; 
		}

		.autocomplete-suggestions strong { font-weight: normal; color: #3399FF; cursor:pointer;}
		.autocomplete-group { padding: 2px 5px; }
		.autocomplete-group strong { display: block; border-bottom: 1px solid #000; }
	</style>
	<h1>Добавить в корзину</h1>
	<!--<p><a href="/cart/{config.place}/{config.id|:my}/list">Оформление заказа {config.id}</a></p>-->
	<p>
		<input value='' min="0" max="999" autosave="0" type="text" class="formControll input" style="width:100%">
	</p>
	<!--<span class="btn btn-secondary button">Добавить</span>-->
	<script>
		domready(function () {
			//https://github.com/devbridge/jQuery-Autocomplete
			var prodart = false;
			var div = $('.cart-search-complete');
			div.find('.button').click( function () {
				if (!prodart) return;
				Cart.add('{config.place}', '{config.id}', prodart);
				div.find('.input').val('');
			});
			var query = '';
			div.find('.input').autocomplete({
				serviceUrl: function (q) {
					query = q;
					return '/-cart/rest/search/' + q;
				},
				onSelect: function (suggestion) {
					var pos = suggestion.data;
					prodart = pos['producer_nick'] + ' ' + pos['article_nick'];
					if (pos['id']) prodart += ' ' + pos['id'];
					Popup.confirm('Количество: <input name="count" type="number">', function(div){
						var count = div.find('[name=count]').val();
						Cart.set('{config.place}', '{config.id}', prodart, count, function(){
							Cart.act('{config.place}', 'sync', '{config.id}', function(ans){
								console.log(ans);
							});
							Global.check('cart');	
						});
						
					}, pos['producer'] + ' ' + pos['article'] + '<br><small>' + pos['item_nick']+'</small>');
					
				},
				transformResult: function (ans) {
					return {
						suggestions: $.map(ans.list, function (pos) {
							//var itemrow = Catalog.getItemRowValue(pos);
							//if (itemrow) itemrow = ' ' + itemrow;
							//var value = pos['Производитель'] + ' ' + pos['Артикул'] + itemrow;
							return { 
								value: query, 
								data: pos 
							};
						})
					};
				},
				dataType:"json",
				ignoreParams: true,
				onSearchComplete: function () {
					Controller.check();
				},
				formatResult: function (suggestion, currentValue) {
					if (!currentValue) return suggestion;
					//var pattern = '(' + $.Autocomplete.utils.escapeRegExChars(currentValue) + ')';
					//var res = suggestion.value;
					var res = Template.parse('-cart/rest/search/layout.tpl',suggestion.data, 'SUGGESTION');
					return res;
			    }
			});
		});
	</script>
</div>
{extend::}-catalog/extend.tpl
{SUGGESTION:}
		<a href="/catalog/{producer_nick}/{article_nick}{:extend.cat.idsl}">{images.0?:img}{Наименование}{Цена?:cost}</a>
		<hr class="my-2" style="clear:both">
	{br:} <br>{.}
	{cost:} <b>{~cost(Цена)}{:extend.unit}</b>
	{img:}<img style="clear:both; margin-left:5px; float:right; position:relative" src="/-imager/?src={images.0}&h=70&w=70&crop=1">
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
		<script>
			if (!window.cdns) window.cdns = function (src, func) {
				if (window.cdns[src]) {
					func();
					return;
				}
				window.cdns[src] = true;
				
				var s = document.createElement("script");
		        s.type = "text/javascript";
		        s.async = false;
		        s.defer = false;
		        s.onload = func;
		        s.src = src;
		        var n = document.getElementsByTagName("script")[0];
		        n.parentNode.insertBefore(s, n);
				
			};
			domready(function () {
				
				var div = $('#{div}');
				window.cdns("https://cdnjs.cloudflare.com/ajax/libs/jquery.devbridge-autocomplete/1.4.10/jquery.autocomplete.js", function () {
					//window.cdns('https://cdnjs.cloudflare.com/ajax/libs/jquery.devbridge-autocomplete/1.4.2/jquery.autocomplete.min.js', function () {
					//https://github.com/devbridge/jQuery-Autocomplete
					var prodart = false;
					div.find('input').autocomplete({
						triggerSelectOnValidInput:true,
						showNoSuggestionNotice:true,
						noSuggestionNotice:'<div class="p-2">По запросу ничего не найдено. Попробуйте изменить запрос или поискать по <a onclick="$(\'#{div}\').find(\'input\').autocomplete(\'hide\'); Crumb.go(\'/catalog\'); $(\'#{div}\').find(\'input\').blur(); return false" href="/catalog">группам</a>.</div>',
						serviceUrl: function (q) {
							var query = Path.encode(q);
							return '/-catalog/live/' + query;
						},
						onSelect: function (suggestion) {
							return;
						},
						transformResult: function (ans) {
							var query = div.find('input').val();
							return {
								suggestions: $.map(ans.list, function (pos) {
									//var itemrow = Catalog.getItemRowValue(pos);
									//if (itemrow) itemrow = ' ' + itemrow;
									//var value = pos['Производитель'] + ' ' + pos['Артикул'] + itemrow;
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
							//var pattern = '(' + $.Autocomplete.utils.escapeRegExChars(currentValue) + ')';
							//var res = suggestion.value;
							var res = Template.parse('-catalog/live/layout.tpl',suggestion.data, 'SUGGESTION');
							return res;
					    },
					    groupBy2:'group',
					    onSearchComplete: function (suggestion) {
					    	var q = Path.encode(suggestion);
					    	
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
						//if (!disabled) return;
						//disabled = false;
						$(this).autocomplete('enable');
					});	
				});
				
				//var disabled = true;
				div.find('form').submit( function () {
					var q = div.find('input').val();
					var q = Path.encode(q, true);
					if (Crumb.get.m) {
						var params = '?m=' + Crumb.get.m;
					} else {
						var params = '?m=';
					}
					params+=':search='+q;
					
					var href = '/catalog';
					//if (Crumb.child && Crumb.child.child && !Crumb.child.child.child) href = '/catalog/'+Crumb.child.child.name;

					Crumb.go(href+''+params);
					return false;
				});
			});
		</script>
	</div>