﻿
////////////////////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС
#Область ПрограммныйИнтерфейс

// Устанавливает текущий элемент формы
//
// Параметры:
//  Форма                    - ФормаКлиентскогоПриложения - форма, где выполняется поиск.
//  ОтображатьПредупреждение - Булево - признак отображения предупреждения об ошибке поиска.
//
Процедура ПослеВыполненияПоиска(Форма, ОтображатьПредупреждение = Истина) Экспорт
	
	Префикс = РасширенныйПоискВСпискахКлиентСервер.Префикс();
	ПоискВыполнен = Не Форма[Префикс + "ПоискНеУдачный"];
	КодОшибки = Форма[Префикс + "КодОшибкиПоиска"];
	
	СтрокаПоиска = Форма[Префикс + "СтрокаПоиска"];
	
	Если ЗначениеЗаполнено(СтрокаПоиска) Тогда
		Если Не ПоискВыполнен И ОтображатьПредупреждение Тогда
			ПоказатьПредупреждение(, ТекстПредупрежденияОшибкиРасширенногоПоиска(КодОшибки), 120, "Поиск");
		КонецЕсли;
	КонецЕсли;
	
	// Установить текущий элемент формы.
	ТекущийЭлемент = РасширенныйПоискВСпискахКлиентСервер.ФильтруемыйСписокЭлементФормы(Форма);
	
	Если Не ПоискВыполнен Тогда
		ТекущийЭлемент = Форма.Элементы[Префикс + "СтрокаПоиска"];
	КонецЕсли;
	
	Форма.ТекущийЭлемент = ТекущийЭлемент;
	
КонецПроцедуры

#КонецОбласти // ПрограммныйИнтерфейс

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ
#Область СлужебныеПроцедурыИФункции

Функция ТекстПредупрежденияОшибкиРасширенногоПоиска(КодОшибки)
	
	Если КодОшибки = "НичегоНеНайдено" Тогда
		ТекстПредупреждения = НСтр("ru = 'Ничего не найдено, уточните запрос.'");
	ИначеЕсли КодОшибки = "СлишкомМногоРезультатов" Тогда
		ТекстПредупреждения = НСтр("ru = 'Слишком много результатов поиска, уточните запрос.'");
	ИначеЕсли КодОшибки = "ОшибкаПоиска" Тогда
		ТекстПредупреждения = НСтр("ru = 'При выполнении поиска произошла ошибка, попробуйте изменить выражение поиска.'");
	Иначе
		ТекстПредупреждения = НСтр("ru='Неизвестная ошибка.'");
	КонецЕсли;
	
	Возврат ТекстПредупреждения;
	
КонецФункции

#КонецОбласти // СлужебныеПроцедурыИФункции
