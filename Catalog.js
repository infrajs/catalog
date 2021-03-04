import { Crumb } from '/vendor/infrajs/controller/src/Crumb.js'
import { Fire } from '/vendor/akiyatkin/load/Fire.js'
let Catalog = {
	...Fire,
	choiсe: function (producer, article, id, divcatitem, m) {
		var ans = Load.loadJSON('-showcase/api/pos/' + producer + '/' + article + '/' + id + '?m=' + m);
		//var pos = ans['data'];
		//var m = ans['m'];

		var html = Template.parse('-catalog/extend.tpl', ans, 'pos-item', 'data');
		divcatitem.html(html);
		Controller.check();
	},
	search: function (val) {
		if (val) {
			Crumb.go('/catalog?m=:search=' + val)
		} else {
			Crumb.go('/catalog')
		}
		return;

		let m = Crumb.get.m ? '?m=' + Crumb.get.m : '?m='
		if (/:search/.test(m)) {
			m = m.replace(/:search[^:]*/g,'')
		}
		if (val) {
			m += ':search=' + val
		}
		if (Crumb.child.name == 'catalog' && Crumb.child.child && !Crumb.child.child.child) {
			Crumb.go('/catalog/'+Crumb.child.child.name + m)
		} else {
			Crumb.go('/catalog' + m)
		}
		
		return false;
	},
	find: function (val) {
		val = val.replace(':', ' ')
		val = encodeURIComponent(val)
		//let m = Crumb.get.m ? '?m=' + Crumb.get.m : '?m='
		let m = '?m='

		if (/:search/.test(m)) {
			m = m.replace(/:search=[^:]*/,':search=' + val)	
		} else {
			m += ':search=' + val
		}
		m = m.replace(/:search$/,'')	
		//if (Crumb.child.name == 'catalog' && Crumb.child.child) {
		//	Crumb.go('/catalog/' + Crumb.child.child.name + m)	
		//} else {
			Crumb.go('/catalog' + m)	
		//}
		
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

Catalog.hand('find', (obj, val) => {
	Catalog.find(val)
})

window.Catalog = Catalog
export { Catalog }