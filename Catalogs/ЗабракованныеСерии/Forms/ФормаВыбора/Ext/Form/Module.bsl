﻿
////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТКИ СОБЫТИЙ ФОРМЫ
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьУсловноеОформлениеФормы();
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Настройки = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить("ВыборЗабраковкиСерий", "");
	Если Настройки <> Неопределено Тогда
		Если Настройки.Свойство("ИсторияПоиска") Тогда
			Элементы.СтрокаПоиска.СписокВыбора.ЗагрузитьЗначения(Настройки.ИсторияПоиска);
		КонецЕсли;
	КонецЕсли;
	
	Если Параметры.Свойство("СтрокаПоиска") Тогда
		СтрокаПоиска = Параметры.СтрокаПоиска;
		ПрименитьПоиск();
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Параметры.Заголовок) Тогда
		АвтоЗаголовок = Ложь;
		Заголовок = Параметры.Заголовок;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти // ОбработчикиСобытийФормы

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТКИ СОБЫТИЙ ЭЛЕМЕНТОВ ФОРМЫ
#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура СтрокаПоискаПриИзменении(Элемент)
	
	ПрименитьПоиск();
	
КонецПроцедуры

&НаКлиенте
Процедура СтрокаПоискаОчистка(Элемент, СтандартнаяОбработка)
	
	ПрименитьПоиск();
	
КонецПроцедуры

&НаКлиенте
Процедура СтрокаПоискаАвтоПодбор(Элемент, Текст, ДанныеВыбора, Ожидание, СтандартнаяОбработка)
	
	СпискиВыбораКлиентСервер.АвтоПодбор(Элемент, Текст, ДанныеВыбора, Ожидание, СтандартнаяОбработка);
	
КонецПроцедуры

#КонецОбласти // ОбработчикиКомандФормы

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ
#Область ОбработчикиСобытийЭлементовФормы

&НаСервере
Процедура УстановитьУсловноеОформлениеФормы()
	
	Элемент = Список.КомпоновщикНастроек.Настройки.УсловноеОформление.Элементы.Добавить();
	Элемент.Представление = НСтр("ru = 'Выделять отмененные забраковки'");
	
	Отбор = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	Отбор.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Статус");
	Отбор.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	Отбор.ПравоеЗначение = Перечисления.СтатусыЗабраковкиСерий.Отменена;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ЦветТекстаОтмененнойСтрокиДокумента);
	
КонецПроцедуры

&НаСервере
Процедура ПрименитьПоиск()
	
	Использование = ЗначениеЗаполнено(СтрокаПоиска);
	
	ГруппаОтбора = ОбщегоНазначенияКлиентСервер.СоздатьГруппуЭлементовОтбора(
		ОбщегоНазначенияБольничнаяАптекаКлиентСервер.ОбластьОтбораДинамическогоСписка(Список).Элементы,
		"ПоискПоПодстроке",
		ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИли);
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(
		ГруппаОтбора,
		"Наименование",
		СтрокаПоиска,
		ВидСравненияКомпоновкиДанных.Содержит,
		,
		Использование);
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(
		ГруппаОтбора,
		"Препарат",
		СтрокаПоиска,
		ВидСравненияКомпоновкиДанных.Содержит,
		,
		Использование);
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(
		ГруппаОтбора,
		"Производитель",
		СтрокаПоиска,
		ВидСравненияКомпоновкиДанных.Содержит,
		,
		Использование);
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(
		ГруппаОтбора,
		"ВсеСерии",
		Истина,
		ВидСравненияКомпоновкиДанных.Равно,
		,
		Использование);
	
	Если Использование Тогда
		
		СпискиВыбораКлиентСервер.ОбновитьСписокВыбора(Элементы.СтрокаПоиска.СписокВыбора, СтрокаПоиска);
		
		ПараметрыЗакрытия = Новый Структура;
		ПараметрыЗакрытия.Вставить("ИсторияПоиска", Элементы.СтрокаПоиска.СписокВыбора.ВыгрузитьЗначения());
		
		ОбщегоНазначения.ХранилищеОбщихНастроекСохранить("ВыборЗабраковкиСерий", "", ПараметрыЗакрытия);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти // ОбработчикиСобытийЭлементовФормы
