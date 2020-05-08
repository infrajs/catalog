let Catalog = {
	choiсe: function (producer, article, id, divcatitem, m) {
		var ans = Load.loadJSON('-showcase/api/pos/' + producer + '/' + article + '/' + id + '?m=' + m);
		//var pos = ans['data'];
		//var m = ans['m'];

		var html = Template.parse('-catalog/extend.tpl', ans, 'pos-item', 'data');
		divcatitem.html(html);
		Controller.check();
	},
	search: function (val) {
		var params = Crumb.get.m ? '?m=' + Crumb.get.m : '?m=';
		params += ':search=' + val;
		Crumb.go('/catalog' + params);
		return false;
	},
	getItemRowValue: function (pos) {
		var row = [];
		if (!pos.itemrows) return '';
		for (var key in pos.itemrows) {
			if (pos[key]) continue;
			var r = key + ': ';
			r += pos['more'][key];
			row.push(r);
		}
		return row.join(', ');

	}
}

window.Catalog = Catalog
export { Catalog }