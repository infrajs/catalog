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

```json
{
	"nds":false,
	"dir":"~catalog/",
	"cache":["~catalog/"],
	"title":"Каталог",
	"md":{ },
	"filename":"Производитель",
	"columns":[],
	"filteroneitem":true,
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
			"separator":false
		}
	}
}
```
## Описание группы
Описание группы это данные указанные над таблицей. Описание может занимать только две колонки. Имя параметра и значение параметра.
Предусмотрены следующие параметры.
- Наименование - полное наименование группы или то наименование, которое должно показываться посетителю.
- Картинка - и значение **Большая** У всех позиций данной группы первая картинка в описании будет развёрнута на всю страницу.

## Колонка Скрыть фильтры в полном описании
При добавлении в excel колонки **Скрыть фильтры в полном описании** со значением *true* например "скрыть" на странице позиции, данные используемые для фильтра не показываются в отдельной таблице. Предпологается что все параметры перечислены вручную в полном описании - документ Word.

## Колонка Файлы
Указывается путь относительно папки каталога. Путь ведёт на папку или файл, который также нужно привязать к позиции.


