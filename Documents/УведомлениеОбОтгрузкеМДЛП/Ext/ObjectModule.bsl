﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка)
	
	ИнтеграцияМДЛППереопределяемый.ОбработкаЗаполнения(ЭтотОбъект, ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка);
	
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	
	СхемаАкцептования = Метаданные().Реквизиты.СхемаАкцептования.ЗначениеЗаполнения;
	
	НомераУпаковок.Очистить();
	ТранспортныеУпаковки.Очистить();
	СоставТранспортныхУпаковок.Очистить();
	ИерархияГрупповыхУпаковок.Очистить();
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	НепроверяемыеРеквизиты = Новый Массив;
	
	Если Не ИнтеграцияМДЛП.ИспользоватьХарактеристикиНоменклатуры() Тогда
		НепроверяемыеРеквизиты.Добавить("Товары.Характеристика");
		НепроверяемыеРеквизиты.Добавить("СоставТранспортныхУпаковок.Характеристика");
	КонецЕсли;
	
	Если Не ИнтеграцияМДЛП.ИспользоватьСерииНоменклатуры() Тогда
		НепроверяемыеРеквизиты.Добавить("Товары.Серия");
		НепроверяемыеРеквизиты.Добавить("СоставТранспортныхУпаковок.Серия");
	КонецЕсли;
	
	Если СхемаАкцептования = Перечисления.СхемыАкцептованияМДЛП.ПрямойПорядок Тогда
		ИнтеграцияМДЛП.ПроверитьЗаполнениеУпаковок(ЭтотОбъект, Отказ);
	КонецЕсли;
	
	ВсеРеквизиты = Неопределено;
	РеквизитыОперации = Неопределено;
	Документы.УведомлениеОбОтгрузкеМДЛП.ЗаполнитьИменаРеквизитовПоТипуОперации(Операция, ВсеРеквизиты, РеквизитыОперации);
	Для Каждого Реквизит Из ВсеРеквизиты Цикл
		Если РеквизитыОперации.Найти(Реквизит) = Неопределено Тогда
			НепроверяемыеРеквизиты.Добавить(Реквизит);
		КонецЕсли;
	КонецЦикла;
	
	Если КонтрагентНеЗарегистрированВГИСМ Тогда
		НепроверяемыеРеквизиты.Добавить("Грузополучатель");
		НепроверяемыеРеквизиты.Добавить("МестоДеятельностиГрузополучателя");
		НепроверяемыеРеквизиты.Добавить("ИсточникФинансирования");
		Если КонтрагентФизическоеЛицо Тогда
			НепроверяемыеРеквизиты.Добавить("КонтрагентКПП");
		КонецЕсли;
	Иначе
		Если Операция = Перечисления.ОперацииОтгрузкиМДЛП.Продажа Тогда
			НепроверяемыеРеквизиты.Добавить("МестоДеятельностиГрузополучателя");
		КонецЕсли;
		НепроверяемыеРеквизиты.Добавить("КонтрагентИНН");
		НепроверяемыеРеквизиты.Добавить("КонтрагентКПП");
	КонецЕсли;
	
	Если Операция = Перечисления.ОперацииОтгрузкиМДЛП.ПередачаСобственникуВРамкахГЛО Тогда
		НепроверяемыеРеквизиты.Добавить("ТипОперации");
	КонецЕсли;
	
	ЭтоПередачаНаБезвозмезднойОснове = ТипДоговора = Перечисления.ТипыДоговоровМДЛП.ПередачаНаБезвозмезднойОснове И НепроверяемыеРеквизиты.Найти("ТипДоговора") = Неопределено;
	
	Если (Операция = Перечисления.ОперацииОтгрузкиМДЛП.Продажа
	 Или Операция = Перечисления.ОперацииОтгрузкиМДЛП.Возврат
	 Или Операция = Перечисления.ОперацииОтгрузкиМДЛП.ВывозВЕАЭС)
	   И Не ЭтоПередачаНаБезвозмезднойОснове Тогда
		Для Каждого Строка Из ТранспортныеУпаковки Цикл
			Если Строка.Цена = 0 Тогда
				Состав = СоставТранспортныхУпаковок.НайтиСтроки(Новый Структура("ИдентификаторСтроки", Строка.ИдентификаторСтроки));
				ЕстьСтрокиБезЦены = Состав.Количество() = 0;
				Для Каждого СтрокаСостава Из Состав Цикл
					ЕСли СтрокаСостава.Цена = 0 Тогда
						ЕстьСтрокиБезЦены = Истина;
						Прервать;
					КонецЕсли;
				КонецЦикла;
				Если ЕстьСтрокиБезЦены Тогда
					ТекстОшибки = ОбщегоНазначенияКлиентСервер.ТекстОшибкиЗаполнения("Колонка",, НСтр("ru = 'Цена'"), Строка.НомерСтроки, НСтр("ru = 'Транспортные упаковки'"));
					Поле = ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("ТранспортныеУпаковки", Строка.НомерСтроки, "Цена");
					ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстОшибки, ЭтотОбъект, Поле,, Отказ);
				КонецЕсли;
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
	Если ЭтоПередачаНаБезвозмезднойОснове Тогда
		НепроверяемыеРеквизиты.Добавить("Товары.Сумма");
		НепроверяемыеРеквизиты.Добавить("СоставТранспортныхУпаковок.Цена");
	КонецЕсли;
	
	ИнтеграцияМДЛППереопределяемый.ОбработкаПроверкиЗаполнения(ЭтотОбъект, Отказ, ПроверяемыеРеквизиты, НепроверяемыеРеквизиты);
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, НепроверяемыеРеквизиты);
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);
	
	ДополнительныеСвойства.Вставить("ЭтоНовый", ЭтоНовый());
	
	ИнтеграцияМДЛП.ПроверитьВозможностьЗаписиУведомления(ЭтотОбъект, РежимЗаписи);
	
	ВсеРеквизиты = Неопределено;
	РеквизитыОперации = Неопределено;
	Документы.УведомлениеОбОтгрузкеМДЛП.ЗаполнитьИменаРеквизитовПоТипуОперации(Операция, ВсеРеквизиты, РеквизитыОперации);
	
	Если Операция = Перечисления.ОперацииОтгрузкиМДЛП.Продажа Тогда
		РеквизитыОперации.Добавить("ТипОперации");
		Если Не ЗначениеЗаполнено(ТипОперации) Тогда
			ТипОперации = Перечисления.ТипыОперацийОтгрузкиМДЛП.Продажа;
		КонецЕсли;
	ИначеЕсли Операция = Перечисления.ОперацииОтгрузкиМДЛП.Возврат Тогда
		РеквизитыОперации.Добавить("ТипОперации");
		Если Не ЗначениеЗаполнено(ТипОперации) Тогда
			ТипОперации = Перечисления.ТипыОперацийОтгрузкиМДЛП.Возврат;
		КонецЕсли;
	КонецЕсли;
	
	Если Не КонтрагентНеЗарегистрированВГИСМ Тогда
		Если ЗначениеЗаполнено(Контрагент) И Операция <> Перечисления.ОперацииОтгрузкиМДЛП.ВывозВЕАЭС Тогда
			Контрагент = Неопределено;
		КонецЕсли;
		ВсеРеквизиты.Добавить("АдресСкладаКонтрагента");
		ВсеРеквизиты.Добавить("АдресСкладаКонтрагентаЗначенияПолей");
		ВсеРеквизиты.Добавить("АдресСкладаКонтрагентаИдентификаторАдресногоОбъекта");
		ВсеРеквизиты.Добавить("АдресСкладаКонтрагентаИдентификаторДома");
		ВсеРеквизиты.Добавить("АдресСкладаКонтрагентаПомещение");
		ВсеРеквизиты.Добавить("КонтрагентФизическоеЛицо");
		ВсеРеквизиты.Добавить("КонтрагентИНН");
		ВсеРеквизиты.Добавить("КонтрагентКПП");
	Иначе
		Индекс = РеквизитыОперации.Найти("Грузополучатель");
		Если Индекс <> -1 Тогда
			РеквизитыОперации.Удалить(Индекс);
		КонецЕсли;
		Индекс = РеквизитыОперации.Найти("МестоДеятельностиГрузополучателя");
		Если Индекс <> -1 Тогда
			РеквизитыОперации.Удалить(Индекс);
		КонецЕсли;
	КонецЕсли;
	
	ИнтеграцияМДЛП.ОчиститьНеиспользуемыеРеквизиты(ЭтотОбъект, ВсеРеквизиты, РеквизитыОперации);
	
	ИнтеграцияМДЛП.УбратьНезначащиеСимволы(ЭтотОбъект, "НомерДокумента,НомерКонтракта");
	
	ИнтеграцияМДЛППереопределяемый.ПередЗаписью(ЭтотОбъект, Отказ, РежимЗаписи, РежимПроведения);
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ИнтеграцияМДЛП.ЗаписатьСтатусДокументаПоУмолчанию(ЭтотОбъект);
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	СтандартнаяОбработка = Истина;
	ИнтеграцияМДЛППереопределяемый.ОбработкаПроведения(ЭтотОбъект, Отказ, РежимПроведения, СтандартнаяОбработка);
	Если Не СтандартнаяОбработка Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыОперации = ИнтеграцияМДЛП.ПараметрыОперацииИзмененияСтатусаУпаковок();
	ПараметрыОперации.ДатаОперации = Дата;
	
	Если Операция = Перечисления.ОперацииОтгрузкиМДЛП.ПередачаСобственникуДляВыпуска Тогда
		ПараметрыОперации.ИсходныйСтатус = Перечисления.СтатусыУпаковокМДЛП.ОжидаетВыпуска;
	ИначеЕсли Операция = Перечисления.ОперацииОтгрузкиМДЛП.ВозвратПриостановленныхЛП Тогда
		Статусы = Новый Массив;
		Статусы.Добавить(Перечисления.СтатусыУпаковокМДЛП.ОборотПриостановлен);
		Статусы.Добавить(Перечисления.СтатусыУпаковокМДЛП.ВОбороте);
		ПараметрыОперации.ИсходныйСтатус = Статусы;
	Иначе
		ПараметрыОперации.ИсходныйСтатус = Перечисления.СтатусыУпаковокМДЛП.ВОбороте;
	КонецЕсли;
	
	ПараметрыОперации.НовыйСтатус = Перечисления.СтатусыУпаковокМДЛП.ПустаяСсылка();
	
	Если Операция = Перечисления.ОперацииОтгрузкиМДЛП.ПередачаСобственнику
	 Или Операция = Перечисления.ОперацииОтгрузкиМДЛП.ПередачаСобственникуДляВыпуска Тогда
		ПараметрыОперации.Владелец = Грузополучатель;
	Иначе
		ПараметрыОперации.Владелец = Справочники.ОрганизацииМДЛП.ПустаяСсылка();
	КонецЕсли;
	
	ПараметрыОперации.МестоДеятельности = МестоДеятельности;
	ПараметрыОперации.ДокументРезерва = Ссылка;
	
	Запрос = Новый Запрос("
	|ВЫБРАТЬ
	|	НомераУпаковок.НомерКиЗ                КАК НомерУпаковки,
	|	НомераУпаковок.СостояниеПодтверждения  КАК СостояниеПодтверждения
	|ПОМЕСТИТЬ ПодтвержденныеУпаковки
	|ИЗ
	|	Документ.УведомлениеОбОтгрузкеМДЛП.НомераУпаковок КАК НомераУпаковок
	|ГДЕ
	|	НомераУпаковок.Ссылка = &Ссылка
	|	И НомераУпаковок.СостояниеПодтверждения В (
	|		ЗНАЧЕНИЕ(Перечисление.СостоянияПодтвержденияМДЛП.Подтверждено),
	|		ЗНАЧЕНИЕ(Перечисление.СостоянияПодтвержденияМДЛП.ДанныеОбУпаковкахАктуализированы),
	|		ЗНАЧЕНИЕ(Перечисление.СостоянияПодтвержденияМДЛП.ОприходованоНовымВладельцем))
	|	И НомераУпаковок.Арбитраж = &АрбитражНеУстановлен
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	НомераУпаковок.НомерУпаковки           КАК НомерУпаковки,
	|	НомераУпаковок.СостояниеПодтверждения  КАК СостояниеПодтверждения
	|ИЗ
	|	Документ.УведомлениеОбОтгрузкеМДЛП.ТранспортныеУпаковки КАК НомераУпаковок
	|ГДЕ
	|	НомераУпаковок.Ссылка = &Ссылка
	|	И НомераУпаковок.СостояниеПодтверждения В (
	|		ЗНАЧЕНИЕ(Перечисление.СостоянияПодтвержденияМДЛП.Подтверждено),
	|		ЗНАЧЕНИЕ(Перечисление.СостоянияПодтвержденияМДЛП.ДанныеОбУпаковкахАктуализированы),
	|		ЗНАЧЕНИЕ(Перечисление.СостоянияПодтвержденияМДЛП.ОприходованоНовымВладельцем))
	|	И НомераУпаковок.Арбитраж = &АрбитражНеУстановлен
	|;
	|
	|//////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	НомераУпаковок.НомерСтроки  КАК НомерСтроки,
	|	НомераУпаковок.НомерКиЗ     КАК НомерУпаковки,
	|	1                           КАК ДоляУпаковки,
	|	ЛОЖЬ                        КАК ГрупповаяУпаковка,
	|	""НомераУпаковок""          КАК ИмяТабличнойЧасти,
	|	""НомерКиЗ""                КАК ИмяПоля
	|ПОМЕСТИТЬ НомераУпаковок
	|ИЗ
	|	Документ.УведомлениеОбОтгрузкеМДЛП.НомераУпаковок КАК НомераУпаковок
	|ГДЕ
	|	НомераУпаковок.Ссылка = &Ссылка
	|	И НЕ (НомераУпаковок.СостояниеПодтверждения В (&КонечныеСостояния) И НомераУпаковок.Арбитраж = &АрбитражНеУстановлен)
	|	И НомераУпаковок.НомерРодительскойУпаковки = """"
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	НомераУпаковок.НомерСтроки    КАК НомерСтроки,
	|	НомераУпаковок.НомерУпаковки  КАК НомерУпаковки,
	|	1                             КАК ДоляУпаковки,
	|	ИСТИНА                        КАК ГрупповаяУпаковка,
	|	""ТранспортныеУпаковки""      КАК ИмяТабличнойЧасти,
	|	""НомерУпаковки""             КАК ИмяПоля
	|ИЗ
	|	Документ.УведомлениеОбОтгрузкеМДЛП.ТранспортныеУпаковки КАК НомераУпаковок
	|ГДЕ
	|	НомераУпаковок.Ссылка = &Ссылка
	|	И НЕ (НомераУпаковок.СостояниеПодтверждения В (&КонечныеСостояния) И НомераУпаковок.Арбитраж = &АрбитражНеУстановлен)
	|");
	
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	Запрос.УстановитьПараметр("ДокументРезерва", ПараметрыОперации.ДокументРезерва);
	Запрос.УстановитьПараметр("МестоДеятельности", ПараметрыОперации.МестоДеятельности);
	Запрос.УстановитьПараметр("АрбитражНеУстановлен", Перечисления.СостоянияАрбитражаМДЛП.ПустаяСсылка());
	
	КонечныеСостояния = Новый Массив;
	КонечныеСостояния.Добавить(Перечисления.СостоянияПодтвержденияМДЛП.ПустаяСсылка());
	КонечныеСостояния.Добавить(Перечисления.СостоянияПодтвержденияМДЛП.Подтверждено);
	КонечныеСостояния.Добавить(Перечисления.СостоянияПодтвержденияМДЛП.ОтклоненоГИСМ);
	КонечныеСостояния.Добавить(Перечисления.СостоянияПодтвержденияМДЛП.ОтозваноПоставщиком);
	КонечныеСостояния.Добавить(Перечисления.СостоянияПодтвержденияМДЛП.ОтклоненоПокупателем);
	КонечныеСостояния.Добавить(Перечисления.СостоянияПодтвержденияМДЛП.ДанныеОбУпаковкахАктуализированы);
	КонечныеСостояния.Добавить(Перечисления.СостоянияПодтвержденияМДЛП.ОприходованоНовымВладельцем);
	Запрос.УстановитьПараметр("КонечныеСостояния", КонечныеСостояния);
	
	Запрос.УстановитьПараметр("НовыйСтатус", ПараметрыОперации.НовыйСтатус);
	Запрос.УстановитьПараметр("ДатаСтатуса", ПараметрыОперации.ДатаОперации);
	
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	Запрос.Выполнить();
	
	ИнтеграцияМДЛП.ДобавитьКлючиУпаковок(Запрос.МенеджерВременныхТаблиц, "ПодтвержденныеУпаковки");
	ИнтеграцияМДЛП.ДобавитьКлючиУпаковок(Запрос.МенеджерВременныхТаблиц);
	
	Запрос.Текст = "
	|ВЫБРАТЬ
	|	ДанныеУпаковок.НомерУпаковки                   КАК НомерУпаковки,
	|	ДанныеУпаковок.МестоДеятельности               КАК МестоДеятельности,
	|	ДанныеУпаковок.ДокументРезерва                 КАК ДокументРезерва,
	|	ДанныеУпаковок.Статус                          КАК Статус,
	|	ДанныеУпаковок.ДатаСтатуса                     КАК ДатаСтатуса,
	|	ДанныеУпаковок.ИсходныйСтатус                  КАК ИсходныйСтатус,
	|	ДанныеУпаковок.Владелец                        КАК Владелец,
	|	ДанныеУпаковок.НомерГрупповойУпаковки          КАК НомерГрупповойУпаковки,
	|	ДанныеУпаковок.ГрупповаяУпаковка               КАК ГрупповаяУпаковка,
	|	ДанныеУпаковок.ВложеныПотребительскиеУпаковки  КАК ВложеныПотребительскиеУпаковки
	|ИЗ
	|	РегистрСведений.УпаковкиМДЛП КАК ДанныеУпаковок
	|	ЛЕВОЕ СОЕДИНЕНИЕ
	|		ПодтвержденныеУпаковки КАК ПодтвержденныеУпаковки
	|	ПО
	|		ПодтвержденныеУпаковки.НомерУпаковки = ДанныеУпаковок.НомерУпаковки
	|		И ПодтвержденныеУпаковки.КлючУпаковки = ДанныеУпаковок.КлючУпаковки
	|ГДЕ
	|	ДанныеУпаковок.ДокументРезерва = &ДокументРезерва
	|	И ПодтвержденныеУпаковки.НомерУпаковки ЕСТЬ NULL
	|;
	|
	|//////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ДанныеУпаковок.НомерУпаковки                   КАК НомерУпаковки,
	|	ДанныеУпаковок.МестоДеятельности               КАК МестоДеятельности,
	|	НЕОПРЕДЕЛЕНО                                   КАК ДокументРезерва,
	|	ВЫБОР
	|		КОГДА ПодтвержденныеУпаковки.СостояниеПодтверждения = ЗНАЧЕНИЕ(Перечисление.СостоянияПодтвержденияМДЛП.ОприходованоНовымВладельцем)
	|			ТОГДА ЗНАЧЕНИЕ(Перечисление.СтатусыУпаковокМДЛП.ПустаяСсылка)
	|		ИНАЧЕ &НовыйСтатус
	|	КОНЕЦ                                          КАК Статус,
	|	&ДатаСтатуса                                   КАК ДатаСтатуса,
	|	ДанныеУпаковок.Владелец                        КАК Владелец,
	|	ДанныеУпаковок.НомерГрупповойУпаковки          КАК НомерГрупповойУпаковки,
	|	ДанныеУпаковок.ГрупповаяУпаковка               КАК ГрупповаяУпаковка,
	|	ДанныеУпаковок.ВложеныПотребительскиеУпаковки  КАК ВложеныПотребительскиеУпаковки,
	|	ЛОЖЬ                                           КАК ОприходованоСАвтоизъятием
	|ИЗ
	|	РегистрСведений.УпаковкиМДЛП КАК ДанныеУпаковок
	|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ
	|		ПодтвержденныеУпаковки КАК ПодтвержденныеУпаковки
	|	ПО
	|		ПодтвержденныеУпаковки.НомерУпаковки = ДанныеУпаковок.НомерУпаковки
	|		И ПодтвержденныеУпаковки.КлючУпаковки = ДанныеУпаковок.КлючУпаковки
	|ГДЕ
	|	ДанныеУпаковок.ДокументРезерва = &ДокументРезерва
	|
	|ОБЪЕДИНИТЬ
	|
	|ВЫБРАТЬ
	|	ДанныеУпаковок.НомерУпаковки                   КАК НомерУпаковки,
	|	ДанныеУпаковок.МестоДеятельности               КАК МестоДеятельности,
	|	НЕОПРЕДЕЛЕНО                                   КАК ДокументРезерва,
	|	ЗНАЧЕНИЕ(Перечисление.СтатусыУпаковокМДЛП.ПустаяСсылка)  КАК Статус,
	|	&ДатаСтатуса                                   КАК ДатаСтатуса,
	|	ДанныеУпаковок.Владелец                        КАК Владелец,
	|	ДанныеУпаковок.НомерГрупповойУпаковки          КАК НомерГрупповойУпаковки,
	|	ДанныеУпаковок.ГрупповаяУпаковка               КАК ГрупповаяУпаковка,
	|	ДанныеУпаковок.ВложеныПотребительскиеУпаковки  КАК ВложеныПотребительскиеУпаковки,
	|	ИСТИНА                                         КАК ОприходованоСАвтоизъятием
	|ИЗ
	|	РегистрСведений.УпаковкиМДЛП КАК ДанныеУпаковок
	|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ
	|		ПодтвержденныеУпаковки КАК ПодтвержденныеУпаковки
	|	ПО
	|		ПодтвержденныеУпаковки.НомерУпаковки = ДанныеУпаковок.НомерУпаковки
	|		И ПодтвержденныеУпаковки.КлючУпаковки = ДанныеУпаковок.КлючУпаковки
	|		И ПодтвержденныеУпаковки.СостояниеПодтверждения = ЗНАЧЕНИЕ(Перечисление.СостоянияПодтвержденияМДЛП.ОприходованоНовымВладельцем)
	|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ
	|		РегистрСведений.УпаковкиМДЛП КАК ДанныеВерхнеуровневыхУпаковок
	|	ПО
	|		ДанныеВерхнеуровневыхУпаковок.НомерУпаковки = ДанныеУпаковок.ДокументРезерва
	|ГДЕ
	|	ДанныеВерхнеуровневыхУпаковок.ДокументРезерва = &ДокументРезерва
	|";
	
	РезультатЗапроса = Запрос.ВыполнитьПакет();
	
	ОтразитьОтгрузку = РезультатЗапроса[РезультатЗапроса.ВГраница()].Выбрать();
	
	Набор = РегистрыСведений.УпаковкиМДЛП.СоздатьНаборЗаписей();
	Пока ОтразитьОтгрузку.Следующий() Цикл
		Если ОтразитьОтгрузку.Статус = Перечисления.СтатусыУпаковокМДЛП.ПустаяСсылка() Тогда
			Если ОтразитьОтгрузку.ГрупповаяУпаковка Тогда
				УдалитьУпаковки = РегистрыСведений.УпаковкиМДЛП.СоздатьНаборЗаписей();
				УдалитьУпаковки.Отбор.ДокументРезерва.Установить(ОтразитьОтгрузку.НомерУпаковки);
				УдалитьУпаковки.Отбор.МестоДеятельности.Установить(ОтразитьОтгрузку.МестоДеятельности);
				УдалитьУпаковки.Записать();
			КонецЕсли;
			Если ОтразитьОтгрузку.ОприходованоСАвтоизъятием Тогда
				УдалитьУпаковки = РегистрыСведений.УпаковкиМДЛП.СоздатьНаборЗаписей();
				УдалитьУпаковки.Отбор.НомерУпаковки.Установить(ОтразитьОтгрузку.НомерУпаковки);
				УдалитьУпаковки.Отбор.МестоДеятельности.Установить(ОтразитьОтгрузку.МестоДеятельности);
				УдалитьУпаковки.Записать();
			КонецЕсли;
		Иначе
			ЗаполнитьЗначенияСвойств(Набор.Добавить(), ОтразитьОтгрузку);
		КонецЕсли;
	КонецЦикла;
	Если Набор.Количество() > 0 Тогда
		Набор.Записать(Ложь);
	КонецЕсли;
	
	Если ОтразитьОтгрузку.Количество() > 0 Тогда
		ОставитьВРезерве = РезультатЗапроса[РезультатЗапроса.ВГраница() - 1].Выгрузить();
		Набор = РегистрыСведений.УпаковкиМДЛП.СоздатьНаборЗаписей();
		Набор.Отбор.ДокументРезерва.Установить(ПараметрыОперации.ДокументРезерва);
		Набор.Загрузить(ОставитьВРезерве);
		Набор.Записать();
	КонецЕсли;
	
	ПроверкаПройдена = ИнтеграцияМДЛП.ПроверитьДоступностьУпаковок(Запрос.МенеджерВременныхТаблиц, ПараметрыОперации, Отказ);
	Если ПроверкаПройдена Тогда
		ИнтеграцияМДЛП.ЗарезервироватьУпаковки(Запрос.МенеджерВременныхТаблиц, ПараметрыОперации);
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)
	
	СтандартнаяОбработка = Истина;
	ИнтеграцияМДЛППереопределяемый.ОбработкаУдаленияПроведения(ЭтотОбъект, Отказ, СтандартнаяОбработка);
	Если Не СтандартнаяОбработка Тогда
		Возврат;
	КонецЕсли;
	
	ИнтеграцияМДЛП.ОтменитьРезерв(Ссылка);
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли