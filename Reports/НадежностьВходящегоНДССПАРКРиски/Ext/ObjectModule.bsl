﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2021, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПриКомпоновкеРезультата(ДокументРезультат, ДанныеРасшифровки, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ДокументРезультат.Очистить();
	
	// Проверка включения использования сервиса.
	Если Не СПАРКРиски.ИспользованиеСПАРКРискиВключено() Тогда
		СПАРКРиски.ЗаполнитьОписаниеОшибкиФормированияОтчета(
			ДокументРезультат,
			Перечисления.ВидыОшибокСПАРКРиски.ИспользованиеОтключено);
		Возврат;
	КонецЕсли;
	
	// В модели сервиса вначале необходимо проверить, подключена ли услуга, или нет.
	// В коробке такая проверка не реализована.
	// Если услуга не подключена, то выдать ошибку и не выполнять никаких запросов.
	УслугаПодключена = ИнтернетПоддержкаПользователей.УслугаПодключена(
		СПАРКРискиКлиентСервер.ИдентификаторУслугиИндикаторыРиска());
	
	Если Не УслугаПодключена Тогда
		СПАРКРиски.ЗаполнитьОписаниеОшибкиФормированияОтчета(
			ДокументРезультат,
			Перечисления.ВидыОшибокСПАРКРиски.ТребуетсяОплатаИлиПревышенЛимит);
		Возврат;
	КонецЕсли;
	
	НастройкиКомпоновки = КомпоновщикНастроек.ПолучитьНастройки();
	
	ЭлементПериод      = НастройкиКомпоновки.ПараметрыДанных.Элементы.Найти("Период");
	ЭлементОрганизация = НастройкиКомпоновки.ПараметрыДанных.Элементы.Найти("Организация");
	ЭлементКонтрагенты = НастройкиКомпоновки.ПараметрыДанных.Элементы.Найти("Контрагенты");
	
	ПараметрыОтбора = Новый Структура;
	ПараметрыОтбора.Вставить("ДатаНачала", ЭлементПериод.Значение.ДатаНачала);
	ПараметрыОтбора.Вставить("ДатаОкончания", ЭлементПериод.Значение.ДатаОкончания);
	ПараметрыОтбора.Вставить("Организация", ЭлементОрганизация.Значение);
	ПараметрыОтбора.Вставить("Организация", ?(ЗначениеЗаполнено(ЭлементОрганизация.Значение),
		ЭлементОрганизация.Значение,
		Неопределено));
	ПараметрыОтбора.Вставить("Контрагенты",   ?(ЭлементКонтрагенты.Использование,
		ЭлементКонтрагенты.Значение,
		Неопределено));
	
	Использование = Истина;
	
	МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	
	ИнтеграцияПодсистемБИП.ПриФормированииОтчетаНадежностьВходящегоНДС(
		МенеджерВременныхТаблиц,
		ПараметрыОтбора,
		Использование);
	
	СПАРКРискиПереопределяемый.ПриФормированииОтчетаНадежностьВходящегоНДС(
		МенеджерВременныхТаблиц,
		ПараметрыОтбора,
		Использование);
	
	Если Не Использование Тогда
		Макет = ПолучитьОбщийМакет("ОшибкиОтчетовСПАРКРиски");
		Область = Макет.ПолучитьОбласть("ОшибкаФормированияОтчетаНадежностьНДС");
		ДокументРезультат.Вывести(Область);
		Возврат;
	КонецЕсли;
	
	Отказ = Ложь;
	СПАРКРиски.ОбновитьИндексыКонтрагентовОтчет(
		МенеджерВременныхТаблиц,
		"ВТ_ДанныеНДС",
		ДокументРезультат,
		Отказ);
	
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц;
	Запрос.Текст = 
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ РАЗЛИЧНЫЕ
		|	Рег.Контрагент КАК Контрагент,
		|	Рег.ИНН КАК ИНН
		|ПОМЕСТИТЬ ВТ_Контрагенты
		|ИЗ
		|	РегистрСведений.СвойстваКонтрагентовСПАРКРиски КАК Рег
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТ_ДанныеНДС КАК ВТ_ДанныеНДС
		|		ПО Рег.Контрагент = ВТ_ДанныеНДС.Контрагент
		|			И (Рег.ИННКорректный)
		|
		|ИНДЕКСИРОВАТЬ ПО
		|	Контрагент
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	МАКСИМУМ(СправкиСПАРКРиски.Дата) КАК Дата,
		|	СправкиСПАРКРиски.Контрагент КАК Контрагент
		|ПОМЕСТИТЬ ВТ_АктуальныеДатыСправок
		|ИЗ
		|	Документ.СправкиСПАРКРиски КАК СправкиСПАРКРиски
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТ_ДанныеНДС КАК ВТ_ДанныеНДС
		|		ПО СправкиСПАРКРиски.Контрагент = ВТ_ДанныеНДС.Контрагент
		|ГДЕ
		|	НЕ СправкиСПАРКРиски.ПометкаУдаления
		|
		|СГРУППИРОВАТЬ ПО
		|	СправкиСПАРКРиски.Контрагент
		|
		|ИНДЕКСИРОВАТЬ ПО
		|	Контрагент
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	СправкиСПАРКРиски.Дата КАК Дата,
		|	МАКСИМУМ(СправкиСПАРКРиски.Ссылка) КАК Ссылка,
		|	СправкиСПАРКРиски.Контрагент КАК Контрагент
		|ПОМЕСТИТЬ ВТ_Справки
		|ИЗ
		|	Документ.СправкиСПАРКРиски КАК СправкиСПАРКРиски
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТ_АктуальныеДатыСправок КАК ВТ_АктуальныеДатыСправок
		|		ПО СправкиСПАРКРиски.Дата = ВТ_АктуальныеДатыСправок.Дата
		|			И СправкиСПАРКРиски.Контрагент = ВТ_АктуальныеДатыСправок.Контрагент
		|ГДЕ
		|	НЕ СправкиСПАРКРиски.ПометкаУдаления
		|
		|СГРУППИРОВАТЬ ПО
		|	СправкиСПАРКРиски.Дата,
		|	СправкиСПАРКРиски.Контрагент
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ВТ_ДанныеНДС.Контрагент КАК Контрагент,
		|	ВТ_ДанныеНДС.Сумма КАК Сумма,
		|	ВТ_ДанныеНДС.СуммаНДС КАК СуммаНДС,
		|	ВТ_Контрагенты.ИНН КАК ИНН,
		|	ВТ_Справки.Дата КАК ДатаСправки,
		|	ВТ_Справки.Ссылка КАК Справка,
		|	ВЫБОР
		|		КОГДА РегИндексы.ИндексДолжнойОсмотрительности ЕСТЬ NULL
		|			ТОГДА -1
		|		ИНАЧЕ РегИндексы.ИндексДолжнойОсмотрительности
		|	КОНЕЦ КАК ИндексДолжнойОсмотрительностиЧисло,
		|	ВЫБОР
		|		КОГДА РегИндексы.ИндексПлатежнойДисциплины ЕСТЬ NULL
		|			ТОГДА -1
		|		ИНАЧЕ РегИндексы.ИндексПлатежнойДисциплины
		|	КОНЕЦ КАК ИндексПлатежнойДисциплиныЧисло,
		|	ВЫБОР
		|		КОГДА РегИндексы.ИндексФинансовогоРиска ЕСТЬ NULL
		|			ТОГДА -1
		|		ИНАЧЕ РегИндексы.ИндексФинансовогоРиска
		|	КОНЕЦ КАК ИндексФинансовогоРискаЧисло,
		|	ВЫБОР
		|		КОГДА РегИндексы.СводныйИндикатор ЕСТЬ NULL
		|			ТОГДА -1
		|		ИНАЧЕ РегИндексы.СводныйИндикатор
		|	КОНЕЦ КАК СводныйИндикаторЧисло,
		|	ВЫБОР
		|		КОГДА РегИндексы.ИндексДолжнойОсмотрительности >= 0
		|				И РегИндексы.ИндексДолжнойОсмотрительности <= 40
		|			ТОГДА ЗНАЧЕНИЕ(Перечисление.ГрадацияИндексовСПАРКРиски.Низкий)
		|		КОГДА РегИндексы.ИндексДолжнойОсмотрительности >= 41
		|				И РегИндексы.ИндексДолжнойОсмотрительности <= 71
		|			ТОГДА ЗНАЧЕНИЕ(Перечисление.ГрадацияИндексовСПАРКРиски.Средний)
		|		КОГДА РегИндексы.ИндексДолжнойОсмотрительности >= 72
		|				И РегИндексы.ИндексДолжнойОсмотрительности <= 100
		|			ТОГДА ЗНАЧЕНИЕ(Перечисление.ГрадацияИндексовСПАРКРиски.Высокий)
		|		ИНАЧЕ """"
		|	КОНЕЦ КАК ИндексДолжнойОсмотрительностиГрадация,
		|	ВЫБОР
		|		КОГДА РегИндексы.ИндексПлатежнойДисциплины >= 0
		|				И РегИндексы.ИндексПлатежнойДисциплины <= 49
		|			ТОГДА ЗНАЧЕНИЕ(Перечисление.ГрадацияИндексовСПАРКРиски.Высокий)
		|		КОГДА РегИндексы.ИндексПлатежнойДисциплины >= 50
		|				И РегИндексы.ИндексПлатежнойДисциплины <= 79
		|			ТОГДА ЗНАЧЕНИЕ(Перечисление.ГрадацияИндексовСПАРКРиски.Средний)
		|		КОГДА РегИндексы.ИндексПлатежнойДисциплины >= 80
		|				И РегИндексы.ИндексПлатежнойДисциплины <= 100
		|			ТОГДА ЗНАЧЕНИЕ(Перечисление.ГрадацияИндексовСПАРКРиски.Низкий)
		|		ИНАЧЕ """"
		|	КОНЕЦ КАК ИндексПлатежнойДисциплиныГрадация,
		|	ВЫБОР
		|		КОГДА РегИндексы.ИндексФинансовогоРиска >= 0
		|				И РегИндексы.ИндексФинансовогоРиска <= 30
		|			ТОГДА ЗНАЧЕНИЕ(Перечисление.ГрадацияИндексовСПАРКРиски.Низкий)
		|		КОГДА РегИндексы.ИндексФинансовогоРиска >= 31
		|				И РегИндексы.ИндексФинансовогоРиска <= 70
		|			ТОГДА ЗНАЧЕНИЕ(Перечисление.ГрадацияИндексовСПАРКРиски.Средний)
		|		КОГДА РегИндексы.ИндексФинансовогоРиска >= 71
		|				И РегИндексы.ИндексФинансовогоРиска <= 100
		|			ТОГДА ЗНАЧЕНИЕ(Перечисление.ГрадацияИндексовСПАРКРиски.Высокий)
		|		ИНАЧЕ """"
		|	КОНЕЦ КАК ИндексФинансовогоРискаГрадация,
		|	ВЫБОР
		|		КОГДА РегИндексы.СводныйИндикатор = 1
		|			ТОГДА ЗНАЧЕНИЕ(Перечисление.ГрадацияИндексовСПАРКРиски.Низкий)
		|		КОГДА РегИндексы.СводныйИндикатор = 2
		|			ТОГДА ЗНАЧЕНИЕ(Перечисление.ГрадацияИндексовСПАРКРиски.Средний)
		|		КОГДА РегИндексы.СводныйИндикатор = 3
		|			ТОГДА ЗНАЧЕНИЕ(Перечисление.ГрадацияИндексовСПАРКРиски.Высокий)
		|		ИНАЧЕ """"
		|	КОНЕЦ КАК СводныйИндикаторГрадация,
		|	ВЫБОР
		|		КОГДА РегИндексы.Контрагент ЕСТЬ NULL
		|			ТОГДА &НетИнформацииОКонтрагенте
		|		КОГДА РегИндексы.Активен
		|			ТОГДА РегИндексы.СтатусНазвание
		|		ИНАЧЕ &КонтрагентПрекратилДеятельность
		|	КОНЕЦ КАК СтатусНазвание,
		|	ВЫБОР
		|		КОГДА РегИндексы.Активен
		|			ТОГДА РегИндексы.Статус
		|		ИНАЧЕ ЗНАЧЕНИЕ(Справочник.ТипыСобытийСПАРКРиски.ПустаяСсылка)
		|	КОНЕЦ КАК Статус
		|ИЗ
		|	ВТ_ДанныеНДС КАК ВТ_ДанныеНДС
		|		ЛЕВОЕ СОЕДИНЕНИЕ ВТ_Контрагенты КАК ВТ_Контрагенты
		|			ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ИндексыСПАРКРиски КАК РегИндексы
		|			ПО ВТ_Контрагенты.Контрагент = РегИндексы.Контрагент
		|		ПО ВТ_ДанныеНДС.Контрагент = ВТ_Контрагенты.Контрагент
		|		ЛЕВОЕ СОЕДИНЕНИЕ ВТ_Справки КАК ВТ_Справки
		|		ПО ВТ_ДанныеНДС.Контрагент = ВТ_Справки.Контрагент";
	
	Запрос.УстановитьПараметр(
		"КонтрагентПрекратилДеятельность",
		СПАРКРиски.ТекстСтатусаПрекратилДеятельность());
	Запрос.УстановитьПараметр(
		"НетИнформацииОКонтрагенте",
		СПАРКРиски.ТекстСтатусаНетИнформацииОКонтрагенте());
	РезультатЗапроса = Запрос.Выполнить();
	
	ДокументРезультат.Очистить();
	
	КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных;

	ВнешниеНаборыДанных = Новый Структура;
	ВнешниеНаборыДанных.Вставить("ДанныеОтчета", РезультатЗапроса.Выгрузить());
	
	МакетКомпоновки = КомпоновщикМакета.Выполнить(
		СхемаКомпоновкиДанных,
		НастройкиКомпоновки,
		ДанныеРасшифровки);
	
	ПроцессорКомпоновки = Новый ПроцессорКомпоновкиДанных;
	ПроцессорКомпоновки.Инициализировать(
		МакетКомпоновки,
		ВнешниеНаборыДанных,
		ДанныеРасшифровки,
		Истина);
	
	ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВТабличныйДокумент;
	ПроцессорВывода.УстановитьДокумент(ДокументРезультат);
	
	ПроцессорВывода.Вывести(ПроцессорКомпоновки);
	
	// Установим примечание в заголовке колонки "Дата справки с ЭП" 
	ОбластьЗаголовокДатаСправки = ДокументРезультат.НайтиТекст(
		НСтр("ru = 'Дата справки с ЭП'"),
		,
		,
		,
		Истина);
	Если ОбластьЗаголовокДатаСправки <> Неопределено Тогда
		
		ТекстПримечания = НСтр("ru='Дата последней по времени аналитической
			|справки по контрагенту из системы 1СПАРК Риски,
			|заверенной электронной подписью. Для просмотра
			|справок по контрагенту кликните дважды в
			|соответствующей ячейке столбца.'");
		
		ОбластьЗаголовокДатаСправки.Примечание.Текст = ТекстПримечания;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

// Настройки общей формы отчета подсистемы "Варианты отчетов".
//
// Параметры:
//   Форма - ФормаКлиентскогоПриложения - Форма отчета.
//   КлючВарианта - Строка - Имя предопределенного варианта отчета или уникальный идентификатор пользовательского.
//   Настройки - Структура - см. возвращаемое значение ОтчетыКлиентСервер.ПолучитьНастройкиОтчетаПоУмолчанию().
//
Процедура ОпределитьНастройкиФормы(Форма, КлючВарианта, Настройки) Экспорт
	
	Настройки.ВыводитьСуммуВыделенныхЯчеек = Ложь;
	Настройки.События.ПередЗагрузкойВариантаНаСервере = Истина;
	
КонецПроцедуры

// Вызывается в обработчике одноименного события формы отчета после выполнения кода формы.
//
// Параметры:
//   Форма - ФормаКлиентскогоПриложения - Форма отчета.
//   НовыеНастройкиКД - НастройкиКомпоновкиДанных - Настройки для загрузки в компоновщик настроек.
//
// См. также:
//   "Расширение управляемой формы для отчета.ПередЗагрузкойВариантаНаСервере" в синтакс-помощнике.
//   ОтчетыПереопределяемый.ПередЗагрузкойВариантаНаСервере().
//
Процедура ПередЗагрузкойВариантаНаСервере(Форма, НовыеНастройкиКД) Экспорт
	
	СПАРКРиски.ПередЗагрузкойВариантаНаСервере(Форма, НовыеНастройкиКД);
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
