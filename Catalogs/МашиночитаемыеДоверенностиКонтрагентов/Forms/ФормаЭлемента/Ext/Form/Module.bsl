﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ЗаполнитьТабличныйДокументМЧД();

	ПодписанныеДокументы.Параметры.УстановитьЗначениеПараметра("Доверенность", Объект.Ссылка);
	КоличествоДокументов = ИнтерфейсДокументовЭДО.КоличествоПодписанныхЭлектронныхДокументовПоМЧД(Объект.Ссылка);
	КоличествоДокументов = СтрШаблон(" (%1)", КоличествоДокументов);
	Элементы.ГруппаПодписанныеДокументы.Заголовок = Элементы.ГруппаПодписанныеДокументы.Заголовок + КоличествоДокументов;
		
	ЦветФонаВниманиеМЧД = ЦветаСтиля.ЦветФонаВниманиеМЧД;
	ЦветФонаНедействительнаяМЧД = ЦветаСтиля.ЦветФонаНедействительнаяМЧД;
	ЦветФонаДействительнаяМЧД = ЦветаСтиля.ЦветФонаДействительнаяМЧД;
	
	Справочники.ПравилаПроверкиПолномочийМЧД.ПриСозданииНаСервереФормыНастроек(ЭтотОбъект);
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	Справочники.ПравилаПроверкиПолномочийМЧД.ЗаписатьПравило(ТекущийОбъект.Ссылка, ЭтотОбъект);
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	Справочники.ПравилаПроверкиПолномочийМЧД.ПриЧтенииНастроек(ТекущийОбъект, ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	УправлениеФормой();
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ТекстСкриптаПриИзменении(Элемент)
	МашиночитаемыеДоверенностиКлиент.СформироватьЗаголовокВкладкиПолномочия(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура ВариантПроверкиПриИзменении(Элемент)
	МашиночитаемыеДоверенностиКлиент.ОтобразитьВариантПроверки(ЭтотОбъект);
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыДеревоОтбора

&НаКлиенте
Процедура ДеревоОтбораПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, ЭтоГруппа, Параметр)
	МашиночитаемыеДоверенностиКлиент.ДеревоОтбораПередНачаломДобавления(Элемент, Отказ, Элементы.ДеревоОтбораДанные);
КонецПроцедуры

&НаКлиенте
Процедура ДеревоОтбораПередОкончаниемРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования, Отказ)
	МашиночитаемыеДоверенностиКлиент.ДеревоОтбораПередОкончаниемРедактирования(
		Элемент, ОтменаРедактирования, ДеревоОтбора);
КонецПроцедуры

&НаКлиенте
Процедура ДеревоОтбораПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	Элементы.ДеревоОтбора.ТекущиеДанные.Картинка = МашиночитаемыеДоверенностиКлиентСервер.НаборКартинок().Реквизит;
КонецПроцедуры

&НаКлиенте
Процедура ДеревоОтбораПередНачаломИзменения(Элемент, Отказ)
	
	ДанныеСтроки = Элемент.ТекущиеДанные;
	ДополнительныеПараметры = Новый Структура("ДанныеСтроки", ДанныеСтроки);
	Оповещение = Новый ОписаниеОповещения("ПослеВводаЗначения", ЭтотОбъект, ДополнительныеПараметры);
	МашиночитаемыеДоверенностиКлиент.ДеревоОтбораПередНачаломИзменения(
		ДанныеСтроки, Отказ, Элементы.ДеревоОтбораДанные, Оповещение);
	
КонецПроцедуры

&НаКлиенте
Процедура ДеревоОтбораПередУдалением(Элемент, Отказ)
	
	ДанныеСтроки = Элементы.ДеревоОтбора.ТекущиеДанные;
	ИдентификаторСтроки = 0;
	МашиночитаемыеДоверенностиКлиент.ДеревоОтбораПередУдалением(
		ДанныеСтроки, Отказ, ИдентификаторСтроки, Модифицированность);
	СформироватьПредставлениеДанныхПоСтрокеДерева(ИдентификаторСтроки);
	МашиночитаемыеДоверенностиКлиент.СформироватьЗаголовокВкладкиПолномочия(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ДеревоОтбораДанныеПриИзменении(Элемент)
	
	Модифицированность = Истина;
	ДанныеСтроки = Элементы.ДеревоОтбора.ТекущиеДанные;
	
	Если ДанныеСтроки.ИдСтроки > 0 Тогда
		ДанныеСтроки.ИдСтроки = 0;
		Элементы.ДеревоОтбора.ЗакончитьРедактированиеСтроки(Ложь);
	КонецЕсли;
	
	СформироватьПредставлениеДанныхПоСтрокеДерева(ДанныеСтроки.ПолучитьРодителя().ПолучитьИдентификатор());
	МашиночитаемыеДоверенностиКлиент.СформироватьЗаголовокВкладкиПолномочия(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ДеревоОтбораПослеУдаления(Элемент)
	
	Модифицированность = Истина;
	МашиночитаемыеДоверенностиКлиент.СформироватьЗаголовокВкладкиПолномочия(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ДеревоОтбораПриАктивизацииСтроки(Элемент)
	МашиночитаемыеДоверенностиКлиент.ДеревоОтбораПриАктивизацииСтроки(Элемент);
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыПодписанныеДокументы

&НаКлиенте
Процедура ПодписанныеДокументыВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ДанныеСтроки = Элемент.ДанныеСтроки(ВыбраннаяСтрока);
	
	Если ДанныеСтроки = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ИнтерфейсДокументовЭДОКлиент.ОткрытьЭлектронныйДокумент(ДанныеСтроки.Ссылка);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Обновить(Команда)
	
	Результат = Новый Структура;
	Результат.Вставить("СсылкаНаДоверенность", 	Неопределено);
	Результат.Вставить("СтатусПолучения", 		"");
	Результат.Вставить("ОткрытьФормуДляОбновления", Ложь);
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ЗагрузитьЗавершение", ЭтотОбъект);
	
	СтруктураДанных = Новый Структура;
	СтруктураДанных.Вставить("НомерДоверенности", Объект.НомерДоверенности);
	СтруктураДанных.Вставить("ИННДоверителя", Объект.ДоверительИНН);
	
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("ОповещениеОЗавершении", 	ОписаниеОповещения);
	ДополнительныеПараметры.Вставить("Результат", 				Результат);
	ДополнительныеПараметры.Вставить("ОбновлятьСуществующий", 	Истина);
	ДополнительныеПараметры.Вставить("ЭтоДоверенностьКонтрагента", Истина);
	ДополнительныеПараметры.Вставить("МЧД", Неопределено);
	
	МашиночитаемыеДоверенностиКлиент.ПолучитьДанныеМЧДПослеВводаРеквизитов(СтруктураДанных, ДополнительныеПараметры);
	
	УправлениеФормой();
	
КонецПроцедуры

&НаКлиенте
Процедура ПометитьОтозванной(Команда)
	
	Если Объект.Отозвана Тогда
		
		Оповещение = Новый ОписаниеОповещения("УбратьПометкуОтозванаЗавершение", ЭтотОбъект);
		ТекстВопроса = НСтр("ru = 'Убрать пометку ""отозвана"" у доверенности?'");
		ПоказатьВопрос(Оповещение, ТекстВопроса, РежимДиалогаВопрос.ДаНет);
	
	Иначе
			
		Оповещение = Новый ОписаниеОповещения("ВводДатыОтзываЗавершение", ЭтотОбъект);
		ОткрытьФорму("Справочник.МашиночитаемыеДоверенностиКонтрагентов.Форма.ВводДатыОтзыва", , ЭтотОбъект, , , , Оповещение,
			РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ПослеВводаЗначения(Значение, ДополнительныеПараметры) Экспорт
	
	Если ТипЗнч(Значение) <> Тип("Структура") Тогда
		Возврат;
	КонецЕсли;
	
	Модифицированность = Истина;
	ДополнительныеПараметры.ДанныеСтроки.НачальноеЗначение = Значение.НачальноеЗначение;
	ДополнительныеПараметры.ДанныеСтроки.КонечноеЗначение = Значение.КонечноеЗначение;
	СформироватьПредставлениеДанныхПоСтрокеДерева(ДополнительныеПараметры.ДанныеСтроки.ПолучитьИдентификатор());
	МашиночитаемыеДоверенностиКлиент.СформироватьЗаголовокВкладкиПолномочия(ЭтотОбъект);
	
КонецПроцедуры

&НаСервере
Процедура СформироватьПредставлениеДанныхПоСтрокеДерева(ИдентификаторЭлемента)
	
	СтрокаДерева = ДеревоОтбора.НайтиПоИдентификатору(ИдентификаторЭлемента);
	СтрокаДерева.Данные = Справочники.ПравилаПроверкиПолномочийМЧД.ПредставлениеДанных(СтрокаДерева);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	ОчиститьСообщения();
	
	Если ЗначениеЗаполнено(Результат.СсылкаНаДоверенность) Тогда
		ТекстСообщения = НСтр("ru = 'Данные доверенности обновлены из реестра.'");
		ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения);
	КонецЕсли;
	
	Прочитать();
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьТабличныйДокументМЧД()
	
	XMLфайлМЧД = МашиночитаемыеДоверенности.ПолныеДанныеДоверенностиНаСервереМЧД(Объект.Ссылка);
	РезультатФормирования = МашиночитаемыеДоверенности.ТабличныйДокументМЧД(XMLфайлМЧД, Истина);
	
	Если РезультатФормирования <> Неопределено Тогда
		ПолеПросмотра = РезультатФормирования.ПредставлениеДокумента;
	КонецЕсли;
			
КонецПроцедуры

&НаКлиенте
Процедура УбратьПометкуОтозванаЗавершение(Результат, Параметры) Экспорт

	Если Результат = КодВозвратаДиалога.Да Тогда

		Оповещение = Новый ОписаниеОповещения("ПроверкаПодписиМЧДЗавершение", ЭтотОбъект);
		КонтекстДиагностики = ОбработкаНеисправностейБЭДКлиент.НовыйКонтекстДиагностики();
		
		ПараметрыПроверкиМЧД = Новый Структура();
		ПараметрыПроверкиМЧД.Вставить("МЧД", Объект.Ссылка);
		ПараметрыПроверкиМЧД.Вставить("ТребуетсяПроверкаМЧДНаКлиенте", Истина);
		
		ДанныеДляПроверки = МашиночитаемыеДоверенностиКлиентСервер.НовыеДанныеДляПроверкиМЧД();
		ДанныеФайлаИПодписи = МашиночитаемыеДоверенностиВызовСервера.ДанныеФайлаДоверенностиИПодписи(Объект.Ссылка);
		ДанныеДляПроверки.ДанныеДоверенности = ДанныеФайлаИПодписи.ДанныеФайла;
		ДанныеДляПроверки.ДанныеПодписи = ДанныеФайлаИПодписи.ДанныеПодписи;
		ПараметрыПроверкиМЧД.Вставить("ДанныеДляПроверки", ДанныеДляПроверки);
		
		МашиночитаемыеДоверенностиКлиент.ПроверитьДанныеМЧД(Оповещение, ПараметрыПроверкиМЧД, КонтекстДиагностики);
		
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ВводДатыОтзываЗавершение(Результат, Параметры) Экспорт
	
	Если Результат = Неопределено Или Результат = КодВозвратаДиалога.Отмена Тогда
		Возврат;
	КонецЕсли;

	Объект.Отозвана = Истина;
	Объект.ДатаОтзыва = Результат;

	Модифицированность = Истина;
	УправлениеФормой();

КонецПроцедуры

&НаКлиенте
Процедура ПроверкаПодписиМЧДЗавершение(РезультатПроверки, Параметры) Экспорт

	Если РезультатПроверки.Результат Тогда
		
		Объект.Отозвана = Ложь;
		Объект.ДатаОтзыва = Дата(1, 1, 1);

		Модифицированность = Истина;
		
	Иначе
		
		ТекстСообщения = НСтр(
			"ru = 'Вернуть в работу не удалось. Криптографическая проверка подлинности данной доверенности не пройдена. 
			|Подпись неверна или доверенность была изменена после подписания. 
			|Обратитесь к контрагенту для получения новой доверенности'");
		ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения);
	
	КонецЕсли;
	
	УправлениеФормой();

КонецПроцедуры

&НаКлиенте
Процедура УправлениеФормой()
	
	Элементы.ГруппаПроверкаПолномочий.Видимость = Объект.ПолномочияОграничены;
	Элементы.ФормаОбновить.Видимость = ЗначениеЗаполнено(Объект.СтатусВРеестреФНС);
	
	Если Объект.Отозвана Тогда	
		Элементы.ФормаПометитьОтозванной.Заголовок = НСтр("ru = 'Вернуть в работу'");
	Иначе
		Элементы.ФормаПометитьОтозванной.Заголовок = НСтр("ru = 'Пометить отозванной'");
	КонецЕсли;
	
	ИнтерфейсДокументовЭДОКлиент.ОформитьГруппуСостоянияИСтатусыМЧД(ЭтотОбъект, 
		Объект.Подписана, Объект.Верна, Объект.Отозвана, Объект.ДатаОтзыва, Объект.СтатусВРеестреФНС);
	
	МашиночитаемыеДоверенностиКлиент.СформироватьЗаголовокВкладкиПолномочия(ЭтотОбъект);
	МашиночитаемыеДоверенностиКлиент.ОтобразитьВариантПроверки(ЭтотОбъект);
	
КонецПроцедуры

#КонецОбласти