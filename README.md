# catalog используется с infrajs
Каталог не использует базу данных. Имеет ограничение в ~1000 полных описаний на самом простом хостинге. При использовании memсache и хороших серверов ограничение можно подвинуть.

## Установка через composer

```json
{
	"require":{
		"infrajs/catalog":"~1"
	}
}
```

## Подключение слоя по адресу /catalog

```json
{
	"crumb":"catalog",
	"external":"-catalog/catalog.layer.json"
}
```

Excel документы в папке ```data/catalog/``` будут интерпретироваться, как данные для каталога, где имя Excel Документа это имя Производителя. 
В папках ```data/catalog/{producer}/{article}/``` должны лежать картинки и docx файлы с полным описанием позиций каталога.

## Фильтры
Для автоматически сфомированных фильтров необходим отдельный слой
```json
{
	"external":"-catalog/filters.layer.json",
}
```
Список позиций можно фильтровать по разным параметрам. 
Фильтрация реализуется с помощью магиченской метки-параметра в адресной строке ```&m=key:param1=value1:param2=value2```. 
Где ```key``` хэш уже переданных на сервер параметров, а ```param1``` и ```param2``` это только что добавленные параметры. 
Метка ```m``` должна передаваться во все php файлы, которые работают с выборкой. В описании слоя это делается подстановокой в шаблоне ```...file.php?m={infra.Crumb.get.m}```
Ответ сервера содержит уже новый хэш ```mark``` включающий и только что переданные параметры.

В скрипте весь набор параметров с новыми и старыми получается методом ```$md=Catalog::initMark($ans);``` где ```$md``` ассоциативный массив со всеми параметрами. 
В ```$ans``` будет добавлено свойство ```mark``` которое будет содержать хэш с новыми параметрами для использования в следующих ссылках.
```initMark``` настроена на работу с параметром ```&m=``` из адресной строки.

Список доступных параметров указан в ```config.catalog.filters```, кроме указанных есть предопределённые 
```json
{
    "count":10,
	"reverse":false,
	"sort":false,
	"producer":{},
	"group":{},
	"search":false,
	"more":{},
	"cost":{}
}
```
## Работа с данными
Данные каталога получаются с помощью ```$data = Catalog::init();``` Дальнейшая работа осуществляется средствами ```Xlsx::runGroups```, ```Xlsx::runPoss``` из расширения [infrajs/excel](https://github.com/infrajs/excel)

У позиции значения ```Производитель``` и ```Артикул``` имеют свои копии с удалёнными некоторыми символами, которые нельзя использовать в адресной строке ```producer``` и ```article```. 
У групп ```descr.Наименование``` и ```title```. 

Уникальность позиции определяется парой ```producer``` и ```article``` эти параметры используются для ссылки на страницу полного описания позиции ```catalog/producer/article```.

## Конфиг [infrajs/config](https://github.com/infrajs/config)

```js
{
	"nds":false,
	"dir":"~catalog/",
	"cache":["~catalog/"],
	"title":"Каталог",
	"md":{ },
	"filename":"Производитель",
	"columns":[],
	"alwaysshowposs":true, //Показывать позиции, когда есть вложенные группы
	"filgroups":[], //группы из параметров позиций
	"countonpage":10, //Количество позиций на странице по умолчаню
	"foldwhen"=>30, //Скрывать значения фильтра если их больше
	"filteroneitem"=>true, //Показывать ли фильтр в котором только один пункт, который true для всей выборке
	"filtershowhard" => array(), //Фильтры, которые всегда показываются
	"filterslimitpercent" = 10, //Процент позиций у которых должен быть указан параметр, чтобы он показался в фильтрах
	"filters":{
		"producer":{
			"posid":"producer",
			"posname":"Производитель",
			"title":"Производитель",
			"separator":false
		},
		"cost":{
			"posid":"Цена",
			"posname":"Цена",
			"title":"Цена",
			"separator":false //Символ который разделяет несколько значения в одной ячейки, например ","
		}
	}
}
```
## Специальные колонки
Колонки из Excel, которые индивидуально обрабатываются в шаблонах и не должы попадать в массив more и автоматически показываться в списке параметров нужно указать в config.column

### Предопределённые специальные колонки
- Наименование
- Файлы
- Артикул
- Производитель
- Цена
- Описание
- Скрыть фильтры в полном описании"

## Описание группы
Описание группы это данные указанные над таблицей. Описание может занимать только две колонки. Имя параметра и значение параметра.
Предусмотрены следующие параметры.
- Наименование - полное наименование группы или то наименование, которое должно показываться посетителю.
- Картинка - и значение **Большая** У всех позиций данной группы первая картинка в описании будет развёрнута на всю страницу.
- Артикул - и значение **Cкрытый**

## Колонка Скрыть фильтры в полном описании
При добавлении в excel колонки **Скрыть фильтры в полном описании** со значением *true* например "скрыть" на странице позиции, данные используемые для фильтра не показываются в отдельной таблице. Предпологается что все параметры перечислены вручную в полном описании - документ Word.

## Колонка Файлы
Указывается путь относительно папки каталога. Путь ведёт на папку или файл, который также нужно привязать к позиции.

## Добавить свои фильтры

При добавлении сових фильтров нужно скорректировать конфиг, например так:

```json
{
	"columns":["ИД","Наличие","Акция"],
	"md":{ 
		"action":false
	},
	"filters":{
		"producer":{
			"posid":"producer",
			"posname":"Производитель",
			"title":"Производитель",
			"separator":false
		},
		"action":{
			"posid":"action",
			"posname":"action",
			"title":"Товары на акции",
			"separator":false
		},
		"cost":{
			"posid":"Цена",
			"posname":"Цена",
			"title":"Цена",
			"separator":false
		}
	}
}
```
## Поддерживается ручная корректировка SEO

Для ручной корректировки SEO необходимо в папку позиции добавить файл seo.json
Пример файла seo.json:

```json
{
	"title": "Позиция у которой заголовок seo создан вручную",
	"description": "Описание добавленное вручную"
}
```


## Как сделать своё оформление для параметра фильтрации

1. Нужно добавить для каталога (infrajs/catalog) новую зависимость. Так как сам каталог не знает о ней, нужно изменить в конфиге каталога опцию dependencies. Сделать это можно в момент установки расширия в update.php через sys-конфиг или в корневом конфиге проекта. [Пример через расшиение](https://github.com/akiyatkin/catalog-range/blob/master/update.php). В этом случае расширение точно подключится при обращении к каталогу. Без этой части при обращении к REST обработчикам каталога расширение не будет инициализироваться и подписки расширение с новым дизайном фильтров не сработают.
1. Нужно сделать подписку на событие ```Catalog.option```, которое срабатывает для всех параметров и по данным параметрам определить нужный фильтр и далее подготовить переменные для шаблона, которые сохранить в ```$param['block']```. [Пример](https://github.com/akiyatkin/catalog-range/blob/master/infra.php).
1. В подписке, в переменной ```$param['block']['layout']``` указать имя шаблона, который должен выводить этот фильтр.
1. В конфиге каталога нужно добавить путь до шаблона, который должен подключаться вместе с фильтрами "filtertpl":["-path/to/layout.tpl"]. Шаблон должен содержать подшаблон с именем layout-{layout}, где layout имя указанное в подписке в ```$param['block']['layout']```. Можно это сделать подменив конфиг в корне проекта или в отдельном расширении, как [здесь](https://github.com/akiyatkin/catalog-range/blob/master/update.php).

## Как выбрать диапазон значений параметра

В фильтрах у каждого параметра предсмотрены специальные значения
1. minmax=min/max - указывается диапазон значений
1. no=1 - все позиции у которых значение не указанно
1. yes=1 - все позиции у которых значение указанно


## Псевод группы filgroups сгенерированные на оснвое парамеров

Описание групп хранится в свойстве conf.filgroups имя параметра и шаблон группы на его основе.

## Класс gagarin
При клике показывает следующий за ним Html-элемент или тот который указан в атрибуте data-div. По умолчанию показываемый элемент должен быть скрыт display:none. Действие пользователя запоминается в sessionStorage