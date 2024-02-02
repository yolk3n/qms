﻿
////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, Параметры.ДанныеРегистрационногоУдостоверения);
	
	Для Каждого Статус Из АптечныеТовары.ВозможныеСтатусыДействияПрепарата() Цикл
		Элементы.СтатусДействия.СписокВыбора.Добавить(Статус.Ключ, Статус.Значение);
	КонецЦикла;
	
	Если ЗначениеЗаполнено(СтатусДействия) И Элементы.СтатусДействия.СписокВыбора.НайтиПоЗначению(СтатусДействия) = Неопределено Тогда
		Элементы.СтатусДействия.СписокВыбора.Добавить(СтатусДействия);
	КонецЕсли;
	
	Элементы.ФормаКомандаОК.Доступность = Не ТолькоПросмотр;
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаОК(Команда)
	
	Если Модифицированность Тогда
		
		ДанныеРегистрационногоУдостоверения = Новый Структура;
		ДанныеРегистрационногоУдостоверения.Вставить("СтатусДействия"       , СтатусДействия);
		ДанныеРегистрационногоУдостоверения.Вставить("ДатаОкончанияДействия", ДатаОкончанияДействия);
		ДанныеРегистрационногоУдостоверения.Вставить("НормативныйДокумент"  , НормативныйДокумент);
		ДанныеРегистрационногоУдостоверения.Вставить("РегистрационныйНомер" , РегистрационныйНомер);
		ДанныеРегистрационногоУдостоверения.Вставить("ДатаРегистрации"      , ДатаРегистрации);
		Закрыть(ДанныеРегистрационногоУдостоверения);
		
	Иначе
		
		Закрыть();
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти // ОбработчикиСобытийФормы
