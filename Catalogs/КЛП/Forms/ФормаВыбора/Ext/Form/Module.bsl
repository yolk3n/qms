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
	
	// СтандартныеПодсистемы.ВерсионированиеОбъектов
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов
	
	УстановитьОтборыСписка();
	
КонецПроцедуры

#КонецОбласти // ОбработчикиСобытийФормы

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ФОРМЫ
#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура ОтборНеПривязанныеКЕСКЛППриИзменении(Элемент)
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список, Неопределено,,, "СозданныеВРучную", ОтборНеПривязанныеКЕСКЛП);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборНеПривязанныеКНоменклатуреПриИзменении(Элемент)
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список, Неопределено,,, "НеПривязанныеКНоменклатуре", ОтборНеПривязанныеКНоменклатуре);
	
КонецПроцедуры

#КонецОбласти // ОбработчикиСобытийЭлементовФормы

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ
#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформлениеФормы()
	
	УсловноеОформлениеСписка = ОбщегоНазначенияБольничнаяАптекаКлиентСервер.ПолучитьУсловноеОформлениеДинамическогоСписка(
		Список, РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Обычный);
	
	// Цвет фона в строках списка Список
	Элемент =УсловноеОформлениеСписка.Элементы.Добавить();
	Элемент.Представление = НСтр("ru = 'Элементы, не связанные с ЕСКЛП'");
	
	ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(Элемент.Отбор,
		"КодЕСКЛП", ВидСравненияКомпоновкиДанных.НеЗаполнено);
	
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветФона", ЦветаСтиля.ЦветНедоступногоТекста);
	
	// Цвет фона в строках списка Список
	Элемент = УсловноеОформлениеСписка.Элементы.Добавить();
	Элемент.Представление = НСтр("ru = 'Регистрация не действует'");
	
	Статусы = Новый СписокЗначений;
	Статусы.Добавить(2);
	Статусы.Добавить(3);
	Статусы.Добавить(4);
	Статусы.Добавить(10);
	Статусы.Добавить(99);
	
	ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(Элемент.Отбор,
		"СтатусДействия", ВидСравненияКомпоновкиДанных.ВСписке, Статусы);
	
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветФона", ЦветаСтиля.ПолеСОшибкойФон);
	
КонецПроцедуры

&НаСервере
Процедура УстановитьОтборыСписка()
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список, "КодЕСКЛП",, ВидСравненияКомпоновкиДанных.НеЗаполнено, "СозданныеВРучную", Ложь);
	Группа = ОбщегоНазначенияКлиентСервер.СоздатьГруппуЭлементовОтбора(
		Список.КомпоновщикНастроек.ФиксированныеНастройки.Отбор.Элементы, "ГруппаНеПривязанныеКНоменклатуре", ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИли);
	ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(Группа, "Номенклатура",ВидСравненияКомпоновкиДанных.НеЗаполнено,, "НеПривязанныеКНоменклатуре", Ложь);
	ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(Группа, "Номенклатура",ВидСравненияКомпоновкиДанных.Равно,, "НеПривязанныеКНоменклатуреОбъект", Ложь);
	
	Если Параметры.ОтборНеПривязанныеКЕСКЛП Тогда
		ОтборНеПривязанныеКЕСКЛП = Истина;
		Элементы.ОтборНеПривязанныеКЕСКЛП.Доступность = Ложь;
	КонецЕсли;
	Если Параметры.ОтборНеПривязанныеКНоменклатуре Тогда
		ОтборНеПривязанныеКНоменклатуре = Истина;
		Элементы.ОтборНеПривязанныеКНоменклатуре.Доступность = Ложь;
	КонецЕсли;
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список, Неопределено,,, "СозданныеВРучную", ОтборНеПривязанныеКЕСКЛП);
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список, Неопределено,,, "НеПривязанныеКНоменклатуре", ОтборНеПривязанныеКНоменклатуре);
	
	Если Параметры.Свойство("Номенклатура") Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список, Неопределено, Параметры.Номенклатура,, "НеПривязанныеКНоменклатуреОбъект", Истина);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти // СлужебныеПроцедурыИФункции
