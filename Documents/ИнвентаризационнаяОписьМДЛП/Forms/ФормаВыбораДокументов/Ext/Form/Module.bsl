﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьУсловноеОформление();
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	Если Параметры.Уведомление = Неопределено Тогда
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	МетаданныеОбъекта = Параметры.Уведомление.Метаданные();
	ПолноеИмяУведомления = МетаданныеОбъекта.ПолноеИмя();
	
	МенеджерОбъекта = ОбщегоНазначения.МенеджерОбъектаПоПолномуИмени(ПолноеИмяУведомления);
	
	СвойстваСписка = ОбщегоНазначения.СтруктураСвойствДинамическогоСписка();
	СвойстваСписка.ТекстЗапроса = МенеджерОбъекта.ПанельМаркировкиМДЛПТекстЗапросаДинамическогоСписока();
	СвойстваСписка.ОсновнаяТаблица = ПолноеИмяУведомления;
	СвойстваСписка.ДинамическоеСчитываниеДанных = Истина;
	ОбщегоНазначения.УстановитьСвойстваДинамическогоСписка(Элементы.Список, СвойстваСписка);
	
	КлючНазначенияИспользования = МетаданныеОбъекта.Имя;
	
	Если Не ПустаяСтрока(МетаданныеОбъекта.ПредставлениеСписка) Тогда
		Заголовок = МетаданныеОбъекта.ПредставлениеСписка;
	ИначеЕсли Не ПустаяСтрока(МетаданныеОбъекта.РасширенноеПредставлениеСписка) Тогда
		Заголовок = МетаданныеОбъекта.РасширенноеПредставлениеСписка;
	Иначе
		Заголовок = МетаданныеОбъекта.Представление();
	КонецЕсли;
	
	ЕстьМестоДеятельности = ОбщегоНазначения.ЕстьРеквизитОбъекта("МестоДеятельности", МетаданныеОбъекта);
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.ПодключаемыеКоманды") Тогда
		МодульПодключаемыеКоманды = ОбщегоНазначения.ОбщийМодуль("ПодключаемыеКоманды");
		ПараметрыРазмещения = МодульПодключаемыеКоманды.ПараметрыРазмещения();
		ПараметрыРазмещения.Источники = ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(МетаданныеОбъекта);
		ПараметрыРазмещения.КоманднаяПанель = Элементы.Список.КоманднаяПанель;
		МодульПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект, ПараметрыРазмещения);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	// СтандартныеПодсистемы.ВерсионированиеОбъектов
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.ВерсионированиеОбъектов") Тогда
		// Аналог функции ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтотОбъект);
		// Функцию подсистемы ВерсионированиеОбъектов не используем, т.к. форма списка и форма выбора документов Уведомлений общие
		// и хранятся в обработке ПанельМаркировкиМДЛП.
		ТипВерсионируемогоОбъекта = ОбщегоНазначения.ИдентификаторОбъектаМетаданных(ПолноеИмяУведомления);
		УстановитьПараметрыФункциональныхОпцийФормы(Новый Структура("ТипВерсионируемогоОбъекта", ТипВерсионируемогоОбъекта));
	КонецЕсли;
	// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов
	
	ИспользоватьНесколькоОрганизаций = ИнтеграцияМДЛП.ИспользоватьНесколькоОрганизаций();
	ИспользоватьМестаДеятельности = ИнтеграцияМДЛП.ИспользоватьМестаДеятельности() И ЕстьМестоДеятельности;
	
	Если ЗначениеЗаполнено(Параметры.Отбор) Тогда
		
		Период = ОбщегоНазначенияКлиентСервер.СвойствоСтруктуры(Параметры.Отбор, "Период");
		Если ЗначениеЗаполнено(Период) Тогда
			ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
				Список, "ДатаНачала", Период, ВидСравненияКомпоновкиДанных.МеньшеИлиРавно,, Истина);
		КонецЕсли;
		
		Элементы.ОрганизацияОтбор.Видимость       = Ложь;
		Элементы.ОтветственныйОтбор.Видимость     = Ложь;
		Элементы.МестоДеятельностиОтбор.Видимость = Ложь;
		Элементы.МестоДеятельности.Видимость      = ИспользоватьМестаДеятельности;
		
	Иначе
		
		СтруктураБыстрогоОтбора = Параметры.СтруктураБыстрогоОтбора;
		Если СтруктураБыстрогоОтбора <> Неопределено Тогда
			Если СтруктураБыстрогоОтбора.Свойство("Организация", Организация) Тогда
				ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
					Список, "Организация", Организация,,, ЗначениеЗаполнено(Организация));
			КонецЕсли;
			Если СтруктураБыстрогоОтбора.Свойство("МестоДеятельности", МестоДеятельности) Тогда
				ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
					Список, "МестоДеятельности", МестоДеятельности,,, ЗначениеЗаполнено(МестоДеятельности));
			КонецЕсли;
			Если СтруктураБыстрогоОтбора.Свойство("Ответственный", Ответственный) Тогда
				ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
					Список, "Ответственный", Ответственный,,, ЗначениеЗаполнено(Ответственный));
			КонецЕсли;
		КонецЕсли;
		
		Элементы.ОрганизацияОтбор.Видимость       = ИспользоватьНесколькоОрганизаций;
		Элементы.МестоДеятельностиОтбор.Видимость = ИспользоватьМестаДеятельности;
		Элементы.МестоДеятельности.Видимость      = ИспользоватьМестаДеятельности;
		
	КонецЕсли;
	
	СобытияФормМДЛППереопределяемый.ПриСозданииНаСервере(ЭтотОбъект, Отказ, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ФормаСправочникМДЛППрисоединенныеФайлыПротоколОбмена", "Видимость", Ложь);
	
КонецПроцедуры

&НаСервере
Процедура ПередЗагрузкойДанныхИзНастроекНаСервере(Настройки)
	
	Если ЗначениеЗаполнено(Параметры.Отбор) Или СтруктураБыстрогоОтбора <> Неопределено Тогда
		Настройки.Очистить();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриЗагрузкеДанныхИзНастроекНаСервере(Настройки)
	
	Если СтруктураБыстрогоОтбора = Неопределено Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
			Список, "Организация", Организация,,, ЗначениеЗаполнено(Организация));
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
			Список, "МестоДеятельности", МестоДеятельности,,, ЗначениеЗаполнено(МестоДеятельности));
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
			Список, "Ответственный", Ответственный,,, ЗначениеЗаполнено(Ответственный));
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "ИзменениеСостоянияМДЛП"
	   И ТипЗнч(Параметр.Ссылка) = ТипЗнч(Параметры.Уведомление) Тогда
		
		Элементы.Список.Обновить();
		
	КонецЕсли;
	
	Если ИмяСобытия = "Запись_ИнвентаризацияПотребительскихУпаковокМДЛП" Тогда
		
		Элементы.Список.Обновить();
		
	КонецЕсли;
	
	Если ИмяСобытия = "ВыполненОбменМДЛП" Тогда
		
		Элементы.Список.Обновить();
		
	КонецЕсли;
	
	СобытияФормМДЛПКлиентПереопределяемый.ОбработкаОповещения(ЭтотОбъект, ИмяСобытия, Параметр, Источник);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ОтветственныйОтборПриИзменении(Элемент)
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		Список, "Ответственный", Ответственный,,, ЗначениеЗаполнено(Ответственный));
	
КонецПроцедуры

&НаКлиенте
Процедура ОрганизацияОтборПриИзменении(Элемент)
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		Список, "Организация", Организация,,, ЗначениеЗаполнено(Организация));
	
КонецПроцедуры

&НаКлиенте
Процедура МестоДеятельностиОтборПриИзменении(Элемент)
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		Список, "МестоДеятельности", МестоДеятельности,,, ЗначениеЗаполнено(МестоДеятельности));
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписок

&НаКлиенте
Процедура СписокПриАктивизацииСтроки(Элемент)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.ПодключаемыеКоманды") Тогда
		МодульПодключаемыеКомандыКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ПодключаемыеКомандыКлиент");
		МодульПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормМДЛПКлиентПереопределяемый.ВыполнитьПереопределяемуюКоманду(ЭтотОбъект, Команда);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	СтандартныеПодсистемыСервер.УстановитьУсловноеОформлениеПоляДата(ЭтотОбъект);
	
	СписокУсловноеОформление = Список.КомпоновщикНастроек.Настройки.УсловноеОформление;
	ИнтеграцияМДЛП.УстановитьУсловноеОформлениеСтатусДальнейшееДействие(
		СписокУсловноеОформление,
		Элементы.Статус.Имя,
		Элементы.ДальнейшееДействие.Имя,
		"Статус",
		"ДальнейшееДействие1");
		
	ИнтеграцияМДЛП.УстановитьУсловноеОформлениеСтатусИнформирования(
		СписокУсловноеОформление,
		Элементы.Статус.Имя,
		"Статус");
	
КонецПроцедуры

#КонецОбласти

#Область СтандартныеПодсистемы

// СтандартныеПодсистемы.ПодключаемыеКоманды

&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	МодульПодключаемыеКомандыКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ПодключаемыеКомандыКлиент");
	МодульПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Элементы.Список);
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат) Экспорт
	МодульПодключаемыеКоманды = ОбщегоНазначения.ОбщийМодуль("ПодключаемыеКоманды");
	МодульПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, Элементы.Список, Результат);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	МодульПодключаемыеКомандыКлиентСервер = ОбщегоНазначенияКлиент.ОбщийМодуль("ПодключаемыеКомандыКлиентСервер");
	МодульПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Элементы.Список);
КонецПроцедуры

// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

#КонецОбласти
