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
Live.hand('searchselect', async (query) => {	
	query = encodeURIComponent(query)
	return Load.fire('json', '-showcase/api2/livepos/?query=' + query)
})
Live.before('init', async form => {
	Form.fire('init', form)
})

Live.hash = query => {
	return Path.encode(query)
}
Live.ws = new WeakMap()
Live.getState = form => {
	let state = Live.ws.get(form)
	if (state) return state
	state = {
		item: null,
		hash: null,
		select: false
	}
	Live.ws.set(form, state)
	return state
}
Live.search = (form, query) => {
	let state = Live.ws.get(form)
	if (state.select) return Live.puff('searchselect', query)
	return Live.puff('search', query)
}

Live.hand('init', async form => {
	const state = Live.getState(form)
	const input = form.elements.search
	if (!input) return false
	input.classList.add('liveinput')
	input.setAttribute('autocomplete','off')

	const go = async () => {
		let query = input.value
		query = query.toLowerCase()
		query = query.replace(/<\/?[^>]+(>|$)/g, "")
		query = query.replace(/[\s\-\"\']+/g, " ")
		//if (!query) return
		const hash = Path.encode(query)
		Live.emit('process', form, query)
		

	 	const ans = await Live.search(form, query)
 		if (state.hash != hash) return ans
	 	Live.emit('show', form, ans)
	 	return ans
	}

	form.addEventListener('submit', async e => {
		e.preventDefault()
		if (state.select) {
			const ans = await go()
			Live.fire(form, 'select', ans.list[0])
		} else {
			Catalog.search(input.value)
		}
	})

	if (document.activeElement == input) go()
	input.addEventListener('focus', go)
	input.addEventListener('click', go)
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
	const state = Live.getState(form)

	const menu = Live.getMenu(form)
	const title = cls(menu, 'livetitle')[0]
	const body = cls(menu, 'livebody')[0]
	if (state.hash != hash) {
		body.classList.add('mute')
		title.innerHTML = Template.parse('-catalog/live/layout.tpl?v=2', { data: { query } }, 'TITLE')
	}
	menu.classList.add('show')
	state.hash = hash	
})
Live.done('process', async (form, res, query) => {
 	const menu = Live.getMenu(form)
 	const title = cls(menu, 'livetitle')[0]
 	const ans = await Live.search(form, query)	
 	const state = Live.getState(form)
 	if (state.hash != Path.encode(query)) return
 	const tpl = state.select ? 'TITLEBODYSELECT' : 'TITLEBODY'
 	title.innerHTML = Template.parse('-catalog/live/layout.tpl?v=2', { data: ans }, tpl)
 	DOM.emit('load')
})


Live.hand('show', async (form, ans) => {
	const menu = Live.getMenu(form)
	const state = Live.getState(form)
	const body = cls(menu, 'livebody')[0]
	body.classList.remove('mute')
	const tpl = state.select ? 'BODYSELECT' : 'BODY'
	body.innerHTML = Template.parse('-catalog/live/layout.tpl?v=2', { data: ans }, tpl)
	let i = 0
	for (const item of cls(body, 'liveselect')) {
		const index = i
		item.addEventListener('click', () => {
			state.item = ans.list[index]
			Live.emit('select', form)
			Live.drop('select', form)
		})
		i++
	}
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