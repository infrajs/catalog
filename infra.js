import { Catalog } from "/vendor/infrajs/catalog/Catalog.js"
import { Event } from "/vendor/infrajs/event/Event.js"
import { CDN } from '/vendor/akiyatkin/load/CDN.js'

Event.handler('Controller.onshow', async () => {
	//На любой элемент вешаем класс gagarin и data-name указываем имя для элемента который надо будет скрыть у которого класс gagarin{name} 	
	
	var ctrls = document.getElementsByClassName('gagarin');
	if (ctrls.length) await CDN.fire('load','jquery')
	var hand = function () {
		var div = this.dataset.div;
		if (!div) div = $(this).next().get(0);
		else div = document.getElementById(div);

		var name = 'gagarin' + (this.dataset.name || '');

		var is = sessionStorage[name];

		$(div).stop();
		if (sessionStorage[name]) {
			sessionStorage[name] = '';
			$(div).slideUp('slow');
		} else {
			sessionStorage[name] = 'true';
			$(div).slideDown('slow');
		}
	};
	for (var i = 0, l = ctrls.length; i < l; i++) {
		if (ctrls[i].dataset.gagarin) continue;
		ctrls[i].dataset.gagarin = true;

		var div = ctrls[i].dataset.div;
		if (!div) div = $(ctrls[i]).next().get(0);
		else div = document.getElementById(div);

		var name = 'gagarin' + (ctrls[i].dataset.name || '');
		if (sessionStorage[name]) {
			$(div).show();
		}
		ctrls[i].addEventListener('click', hand);
	}
});