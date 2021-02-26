import { Fire } from '/vendor/akiyatkin/load/Fire.js'
import { Load } from '/vendor/akiyatkin/load/Load.js'
import { DOM } from '/vendor/akiyatkin/load/DOM.js'
import { Path } from '/vendor/infrajs/path/Path.js'
import { Form } from "/vendor/akiyatkin/form/Form.js"
import { Catalog } from "/vendor/infrajs/catalog/Catalog.js"
import { Template } from "/vendor/infrajs/template/Template.js"

const Live = { ...Fire }
const wait = delay => new Promise(resolve => setTimeout(resolve, delay))

const cls = (div, cls) => div.getElementsByClassName(cls)
const tag = (div, tag) => div.getElementsByTagName(tag)

Live.submit = form => {
	let event = new Event('submit');
	form.dispatchEvent(event);
}
Live.once('process', async () => {
	await Load.fire('css','-catalog/live/style.css')
})
Live.hand('search', async (query) => {	
	query = encodeURIComponent(query)
	return Load.fire('json', '-showcase/api2/live/?query=' + query)
})
Live.before('init', async form => {
	Form.fire('init', form)
})
const ws = new WeakMap()
Live.hash = query => {
	return Path.encode(query)
}
Live.hand('init', async form => {
	const state = {}
	ws.set(form, state)
	const input = form.elements.search
	if (!input) return false
	input.classList.add('liveinput')
	input.setAttribute('autocomplete','off')
	form.addEventListener('submit', async e => {
		e.preventDefault()
		Catalog.search(input.value)
	})
	const go = async () => {
		let query = input.value
		query = query.toLowerCase()
		query = query.replace(/<\/?[^>]+(>|$)/g, "")
		query = query.replace(/[\s\-\"\']+/g, " ")
		//if (!query) return
		const hash = Path.encode(query)

		
		Live.emit('process', form, query)
		
	 	const ans = await Live.puff('search', query)
 		if (state.hash != hash) return
	 	Live.emit('show', form, ans)
	}
	if (document.activeElement == input) go()
	input.addEventListener('focus', go)
	input.addEventListener('input', go)
	document.body.addEventListener('click', (e) => {
		if (!form.closest('body')) return
		let el = e.target
		let path = [el]
		while (el && el.parentElement) path.push(el = el.parentElement)
		const menu = Live.getMenu(form)
		if (!path.find(el => el.tagName == 'A')) {//Клик по ссылке всегда сворачивает меню
			if (path.find(el => el == input)) return; //Клик по форме не сворачивает
			if (path.find(el => el == menu)) return; //Клик по меню не сворачивает
		}
		menu.classList.remove('show') //Скрываем меню
	})
})

Live.hand('process', (form, query) => {
	const hash = Path.encode(query)
	const state = ws.get(form)
	const menu = Live.getMenu(form)
	const title = cls(menu, 'livetitle')[0]
	const body = cls(menu, 'livebody')[0]
	if (state.hash != hash) {
		body.classList.add('mute')
		title.innerHTML = Template.parse('-catalog/live/layout.tpl', { data: { query } }, 'TITLE')
	}
	menu.classList.add('show')
	state.hash = hash	
})
Live.done('process', async (form, res, query) => {
 	const menu = Live.getMenu(form)
 	const title = cls(menu, 'livetitle')[0]
 	const ans = await Live.puff('search', query) 	
 	const state = ws.get(form)
 	if (state.hash != Path.encode(query)) return
 	title.innerHTML = Template.parse('-catalog/live/layout.tpl', { data: ans }, 'TITLEBODY')
 	DOM.emit('load')
})


Live.hand('show', async (form, ans) => {
	const menu = Live.getMenu(form)
	const body = cls(menu, 'livebody')[0]
	body.classList.remove('mute')
	body.innerHTML = Template.parse('-catalog/live/layout.tpl', { data: ans }, 'BODY')
	DOM.emit('load')
})

Live.getMenu = form => {
	let div = cls(form, 'livemenu')[0]
	if (div) return div

	form.classList.add('liveform')
	div = document.createElement('div')
	const title = document.createElement('div')
	title.classList.add('livetitle')
	div.append(title)
	const body = document.createElement('div')
	body.classList.add('livebody')
	div.append(body)
	div.classList.add('livemenu')
	form.append(div)
	return div
}
window.Live = Live
export { Live }