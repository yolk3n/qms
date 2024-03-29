﻿
////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	ЗначенияЗаполнения = Параметры.ЗначенияЗаполнения;
	Если Параметры.Свойство("ОтборПоТипамОпераций") И Параметры.ОтборПоТипамОпераций.Количество() > 0 Тогда
		СписокТиповОпераций.ЗагрузитьЗначения(Параметры.ОтборПоТипамОпераций.ВыгрузитьЗначения());
		СписокТиповОпераций.СортироватьПоЗначению();
	Иначе
		СписокТиповОпераций.ЗагрузитьЗначения(Перечисления.ТипыОперацийВводаОстатков.ПолучитьДоступные().ВыгрузитьЗначения());
		СписокТиповОпераций.СортироватьПоЗначению();
	КонецЕсли;
	Если Параметры.Свойство("Организация") Тогда
		Объект.Организация = Параметры.Организация;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
КонецПроцедуры

#КонецОбласти // ОбработчикиСобытийФормы

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНДЫ ФОРМЫ
#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ВыбратьТипОперации(Команда)
	
	ОбработкаВыбораТипаОперации();
	
КонецПроцедуры

#КонецОбласти // ОбработчикиКомандФормы

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ФОРМЫ
#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура СписокТиповОперацийВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ОбработкаВыбораТипаОперации();
	
КонецПроцедуры

#КонецОбласти // ОбработчикиСобытийЭлементовФормы

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ
#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ОбработкаВыбораТипаОперации()
	
	СтрокаТаблицы = Элементы.СписокТиповОпераций.ТекущиеДанные;
	Если СтрокаТаблицы <> Неопределено Тогда
		ЗначенияЗаполнения.Вставить("ТипОперации", СтрокаТаблицы.Значение);
		ЗначенияЗаполнения.Вставить("Организация", Объект.Организация);
		Закрыть();
		ОценкаПроизводительностиБольничнаяАптекаКлиент.НачатьЗамерСозданияФормыОбъекта(Объект.Ссылка, Ложь, Ложь, СтрокаТаблицы.Значение);
		ОткрытьФорму("Документ.ВводОстатков.ФормаОбъекта", Новый Структура("ЗначенияЗаполнения", ЗначенияЗаполнения), ВладелецФормы);
	КонецЕсли; 
	
КонецПроцедуры

#КонецОбласти // СлужебныеПроцедурыИФункции
