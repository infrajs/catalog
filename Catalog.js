window.Catalog = {
	choiсe: function (producer, article, id, divcatitem, m) {
		var ans = Load.loadJSON('-showcase/api/pos/'+producer+'/'+article+'/'+id+'?m='+m);
		//var pos = ans['data'];
		//var m = ans['m'];

		var html = Template.parse('-catalog/extend.tpl', ans, 'pos-item','data');
		divcatitem.html(html);
		Controller.check();
	},
	search: function (val) {
		//val = Path.encode(val, true);
		var layer = Controller.names.catalog;
		var params = (Crumb.get.m) ? '?m=' + Crumb.get.m : '';
		Crumb.go('/'+Controller.names.catalog.crumb.toString()+'/'+val+params);
		setTimeout( function () {
			$.getJSON('/-catalog/stat.php?submit=1&val=' + val);
		}, 1);
		return false;
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