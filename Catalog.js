window.Catalog = {
	choiсe: function (producer, article, index, divcatitem) {
		var ans = Load.loadJSON('-catalog/pos/'+producer+'/'+article+'/'+index);
		var pos = ans['data'];
		var html = Template.parse('-catalog/extend.tpl', pos, 'pos-item');
		divcatitem.html(html);
		Controller.check();
	}
}