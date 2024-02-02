﻿
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ
#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	ТипДанныхЗаполнения = ТипЗнч(ДанныеЗаполнения);
	
	Если ТипДанныхЗаполнения = Тип("Структура") Тогда
		ЗаполнитьНаборПоОтбору(ДанныеЗаполнения);
	КонецЕсли;
	
	ЗаполнитьПоляЗаписейНабораПоУмолчанию();
	
КонецПроцедуры

#КонецОбласти // ОбработчикиСобытий

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ
#Область СлужебныеПроцедурыИФункции

Процедура ЗаполнитьНаборПоОтбору(ДанныеЗаполнения)
	
	Для Каждого Запись Из ЭтотОбъект Цикл
		ЗаполнитьЗначенияСвойств(Запись, ДанныеЗаполнения);
	КонецЦикла;
	
КонецПроцедуры

Процедура ЗаполнитьПоляЗаписейНабораПоУмолчанию()
	
	ТаблицаОбъекта = Метаданные().ПолноеИмя();
	
	Для Каждого Запись Из ЭтотОбъект Цикл
		Запись.Организация = ЗначениеНастроекБольничнаяАптекаПовтИсп.ПолучитьОрганизациюПоУмолчанию(Запись.Организация, ТаблицаОбъекта);
		Запись.Отделение   = ЗначениеНастроекБольничнаяАптекаПовтИсп.ПолучитьОтделениеПоУмолчанию(Запись.Отделение, Запись.Организация, ТаблицаОбъекта);
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти // СлужебныеПроцедурыИФункции

#КонецЕсли
