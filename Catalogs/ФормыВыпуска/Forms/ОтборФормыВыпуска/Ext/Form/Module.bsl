﻿
////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьУсловноеОформлениеФормы();
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	ЗаполняемыеПараметры = ОбщегоНазначенияКлиентСервер.КлючиСтруктурыВСтроку(ФильтрНоменклатурыЛекарственныхСредствКлиентСервер.ПараметрыФормыВыпуска());
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, Параметры, ЗаполняемыеПараметры);
	УстановитьФлагиПоЗаполненнымРеквизитам();
	
КонецПроцедуры

#КонецОбласти // ОбработчикиСобытийФормы

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ
#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура УстановитьОтбор(Команда)
	
	Отбор = Новый Структура;
	ВозвращаемыеРеквизиты = ФильтрНоменклатурыЛекарственныхСредствКлиентСервер.ПараметрыФормыВыпуска();
	Для Каждого Реквизит Из ВозвращаемыеРеквизиты Цикл
		Отбор.Вставить(Реквизит.Ключ, ?(ЭтотОбъект["Отбор" + Реквизит.Ключ], ЭтотОбъект[Реквизит.Ключ], Неопределено));
	КонецЦикла;
	
	Закрыть(Отбор);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьПоФормеВыпуска(Команда)
	
	Оповещение = Новый ОписаниеОповещения("ЗаполнитьПоФормеВыпускаЗавершение", ЭтотОбъект);
	ОткрытьФорму("Справочник.ФормыВыпуска.ФормаВыбора",, ЭтотОбъект,,,, Оповещение, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

#КонецОбласти // ОбработчикиСобытийФормы

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ФОРМЫ
#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура ЗначениеОтбораПриИзменении(Элемент)
	
	ЭтотОбъект["Отбор" + Элемент.Имя] = ЗначениеЗаполнено(ЭтотОбъект[Элемент.Имя]);
	
КонецПроцедуры

#КонецОбласти // ОбработчикиСобытийЭлементовФормы

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ
#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформлениеФормы()
	
	// Отметка незаполненного поля ГруппаЛекарственныхФорм
	Элемент = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ГруппаЛекарственныхФорм.Имя);
	
	ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(Элемент.Отбор,
		"ОтборГруппаЛекарственныхФорм", ВидСравненияКомпоновкиДанных.Равно, Ложь);
	
	Элемент.Оформление.УстановитьЗначениеПараметра("ОтметкаНезаполненного", Ложь);
	
КонецПроцедуры

// Заполняет поля отбора по выбранному значению формы выпуска
// Продолжение процедуры ЗаполнитьПоФормеВыпуска
//
// Параметры:
//  ВыбранноеЗначение       - значение, переданное при вызове метода Закрыть открываемой формы
//  ДополнительныеПараметры - (не используется)
//
&НаКлиенте
Процедура ЗаполнитьПоФормеВыпускаЗавершение(ВыбранноеЗначение, ДополнительныеПараметры) Экспорт
	
	Если ЗначениеЗаполнено(ВыбранноеЗначение) Тогда
		ЗаполнитьПоФормеВыпускаСервер(ВыбранноеЗначение);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьПоФормеВыпускаСервер(Знач ФормаВыпуска)
	
	ЗапрашиваемыеРеквизиты = ФильтрНоменклатурыЛекарственныхСредствКлиентСервер.ПараметрыФормыВыпуска();
	ПараметрыФормыВыпуска = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(ФормаВыпуска, ЗапрашиваемыеРеквизиты);
	
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, ПараметрыФормыВыпуска);
	
	УстановитьФлагиПоЗаполненнымРеквизитам();
	
КонецПроцедуры

&НаСервере
Процедура УстановитьФлагиПоЗаполненнымРеквизитам()
	
	ПроверяемыеРеквизиты = ФильтрНоменклатурыЛекарственныхСредствКлиентСервер.ПараметрыФормыВыпуска();
	Для Каждого Реквизит Из ПроверяемыеРеквизиты Цикл
		
		ЭтотОбъект["Отбор" + Реквизит.Ключ] = ЗначениеЗаполнено(ЭтотОбъект[Реквизит.Ключ]);
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти // СлужебныеПроцедурыИФункции
