﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

////////////////////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС
#Область ПрограммныйИнтерфейс

// Настройки общей формы отчета подсистемы "Варианты отчетов".
//
// Параметры:
//   Форма - ФормаКлиентскогоПриложения - Форма отчета.
//   КлючВарианта - Строка - Имя предопределенного варианта отчета или уникальный идентификатор пользовательского.
//   Настройки - Структура - см. возвращаемое значение ОтчетыКлиентСервер.ПолучитьНастройкиОтчетаПоУмолчанию().
//
Процедура ОпределитьНастройкиФормы(Форма, КлючВарианта, Настройки) Экспорт
	
	Настройки.События.ПередЗагрузкойВариантаНаСервере = Истина;
	
КонецПроцедуры

// Вызывается в обработчике одноименного события формы отчета после выполнения кода формы.
//
// Параметры:
//   Форма - ФормаКлиентскогоПриложения - Форма отчета.
//   НовыеНастройкиКД - НастройкиКомпоновкиДанных - Настройки для загрузки в компоновщик настроек.
//
// См. также:
//   "Расширение управляемой формы для отчета.ПриЗагрузкеВариантаНаСервере" в синтакс-помощнике.
//
Процедура ПередЗагрузкойВариантаНаСервере(Форма, НовыеНастройкиКД) Экспорт
	
	НастроитьПараметрыОтборыПоФункциональнымОпциям(КомпоновщикНастроек);
	
	НовыеНастройкиКД = КомпоновщикНастроек.Настройки;
	
КонецПроцедуры

#КонецОбласти // ПрограммныйИнтерфейс

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ
#Область ОбработчикиСобытий

Процедура ПриКомпоновкеРезультата(ДокументРезультат, ДанныеРасшифровки, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ПараметрОценкаЗапасовПоВидуЦен = ОбщегоНазначенияБольничнаяАптекаКлиентСервер.ПолучитьПараметр(КомпоновщикНастроек, "ОценкаЗапасовПоВидуЦен");
	Если ПараметрОценкаЗапасовПоВидуЦен.Значение = 3 Тогда
		ПараметрВидЦены = ОбщегоНазначенияБольничнаяАптекаКлиентСервер.ПолучитьПараметр(КомпоновщикНастроек, "ВидЦены");
		Если Не ЗначениеЗаполнено(ПараметрВидЦены.Значение) Тогда
			ВызватьИсключение НСтр("ru= 'Не указан ""Вид цены"".'");
		КонецЕсли;
	КонецЕсли;
	
	НаборДанных = СхемаКомпоновкиДанных.НаборыДанных.ТоварыНаСкладах;
	
	ТекстЗапроса = НаборДанных.Запрос;
	
	ТекстЗапросаВес = Справочники.ЕдиницыИзмерения.ТекстЗапросаКоличествоВМерныхЕдиницах(Перечисления.ТипыЕдиницИзмерения.Вес, "ДанныеОтчета.Номенклатура");
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "&ТекстЗапросаВесНоменклатуры", ТекстЗапросаВес);
	
	ТекстЗапросаОбъем = Справочники.ЕдиницыИзмерения.ТекстЗапросаКоличествоВМерныхЕдиницах(Перечисления.ТипыЕдиницИзмерения.Объем, "ДанныеОтчета.Номенклатура");
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "&ТекстЗапросаОбъемНоменклатуры", ТекстЗапросаОбъем);
	
	ТекстЗапросаДлина = Справочники.ЕдиницыИзмерения.ТекстЗапросаКоличествоВМерныхЕдиницах(Перечисления.ТипыЕдиницИзмерения.Длина, "ДанныеОтчета.Номенклатура");
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "&ТекстЗапросаДлинаНоменклатуры", ТекстЗапросаДлина);
	
	ТекстЗапросаПлощадь = Справочники.ЕдиницыИзмерения.ТекстЗапросаКоличествоВМерныхЕдиницах(Перечисления.ТипыЕдиницИзмерения.Площадь, "ДанныеОтчета.Номенклатура");
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "&ТекстЗапросаПлощадьНоменклатуры", ТекстЗапросаПлощадь);
	
	НаборДанных.Запрос = ТекстЗапроса;
	
	КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных;
	МакетКомпоновки = КомпоновщикМакета.Выполнить(СхемаКомпоновкиДанных, КомпоновщикНастроек.ПолучитьНастройки(), ДанныеРасшифровки);
	
	ЗаголовкиПолейМерныхЕдиниц = ОтчетыБольничнаяАптека.ДанныеЗаголовковПолейМерныхЕдиниц();
	ОтчетыБольничнаяАптека.УстановитьЗаголовкиМакетаКомпоновки(ЗаголовкиПолейМерныхЕдиниц, МакетКомпоновки);
	
	ПроцессорКомпоновки = Новый ПроцессорКомпоновкиДанных;
	ПроцессорКомпоновки.Инициализировать(МакетКомпоновки, , ДанныеРасшифровки, Истина);
	
	ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВТабличныйДокумент;
	ПроцессорВывода.УстановитьДокумент(ДокументРезультат);
	ПроцессорВывода.Вывести(ПроцессорКомпоновки, Истина);
	
	ОтчетыБольничнаяАптека.СкрытьВспомогательныеПараметрыОтчета(СхемаКомпоновкиДанных, КомпоновщикНастроек, ДокументРезультат, ВспомогательныеПараметрыОтчета());
	
КонецПроцедуры

#КонецОбласти

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ
#Область СлужебныеПроцедурыИФункции

Процедура НастроитьПараметрыОтборыПоФункциональнымОпциям(КомпоновщикНастроек)
	
	Если Не ПолучитьФункциональнуюОпцию("ИспользоватьНесколькоОрганизаций") Тогда
		ОбщегоНазначенияБольничнаяАптека.УдалитьЭлементОтбораИзВсехНастроекОтчета(КомпоновщикНастроек, "Организация");
	КонецЕсли;
	
КонецПроцедуры

Функция ВспомогательныеПараметрыОтчета()
	
	ВспомогательныеПараметры = Новый Массив;
	
	ПараметрОценкаЗапасовПоВидуЦен = ОбщегоНазначенияБольничнаяАптекаКлиентСервер.ПолучитьПараметр(КомпоновщикНастроек, "ОценкаЗапасовПоВидуЦен");
	Если ПараметрОценкаЗапасовПоВидуЦен.Значение <> 3 Тогда
		ВспомогательныеПараметры.Добавить("ВидЦены");
	КонецЕсли;
	
	Возврат ВспомогательныеПараметры;
	
КонецФункции

#КонецОбласти // СлужебныеПроцедурыИФункции

#КонецЕсли