window.Catalog = {
	choiсe: function (producer, article, id, divcatitem, m) {
		var ans = Load.loadJSON('-catalog/pos/'+producer+'/'+article+'/'+id+'?m='+m);
		//var pos = ans['data'];
		//var m = ans['m'];

		var html = Template.parse('-catalog/extend.tpl', ans, 'pos-item','data');
		divcatitem.html(html);
		Controller.check();
	},
	getItemRowValue: function (pos) {
		var row = [];
		if (!pos.itemrows) return '';
		for (var key in pos.itemrows) {
			if (pos[key]) continue;
			var r = key +': ';
			r += pos['more'][key];
			row.push(r);
		}
		return row.join(', ');

	}
}