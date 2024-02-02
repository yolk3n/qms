﻿
////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьУсловноеОформление();
	ТипыДокументов = Новый ФиксированныйМассив(ШтрихкодированиеПечатныхФорм.ТипыОбъектовДинамическогоСписка(Список));
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	// СтандартныеПодсистемы.ВерсионированиеОбъектов
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	// ИнтеграцияС1СДокументооборотом
	ИнтеграцияС1СДокументооборотБазоваяФункциональность.ПриСозданииНаСервере(ЭтотОбъект, Элементы.СписокКоманднаяПанель);
	// Конец ИнтеграцияС1СДокументооборотом
	
	// ПодключаемоеОборудование
	ПодключаемоеОборудованиеСервер.НастроитьФормуДляИспользованияПодключаемогоОборудования(ЭтотОбъект);
	// Конец ПодключаемоеОборудование
	
	// ЭлектронноеВзаимодействие.ОбменСКонтрагентами
	ОбменСКонтрагентамиБольничнаяАптека.ПриСозданииНаСервере_ФормаСпискаДокумента(ЭтотОбъект);
	// Конец ЭлектронноеВзаимодействие.ОбменСКонтрагентами
	
	ИспользоватьСтатусы = ОбщегоНазначенияБольничнаяАптека.ИспользоватьСтатусы(Документы.ЗаказНаПеремещение.ПустаяСсылка());
	Список.Параметры.УстановитьЗначениеПараметра("ДатаАктуальности", НачалоДня(ТекущаяДатаСеанса()));
	Список.Параметры.УстановитьЗначениеПараметра("ИспользоватьСтатусы", ИспользоватьСтатусы);
	
	ЗаполнитьСписокВыбораОтбораПоСостоянию(Элементы.ОтборСостояние.СписокВыбора, ИспользоватьСтатусы);
	ОбщегоНазначенияБольничнаяАптека.ЗаполнитьСписокВыбораОтбораПоАктуальности(Элементы.ОтборСрокВыполнения.СписокВыбора);
	ОбщегоНазначенияБольничнаяАптека.ЗаполнитьСписокПользователейСПравомИзменения(Элементы.ОтборОтветственный.СписокВыбора, ТипыДокументов);
	
	СтруктураБыстрогоОтбора = Параметры.СтруктураБыстрогоОтбора;
	Если СтруктураБыстрогоОтбора <> Неопределено Тогда
		Если СтруктураБыстрогоОтбора.Свойство("Состояние", Состояние) Тогда
			УстановитьОтборПоСостояниюСервер();
		КонецЕсли;
		Если СтруктураБыстрогоОтбора.Свойство("Ответственный", Ответственный) Тогда
			ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список, "Ответственный", Ответственный,,, ЗначениеЗаполнено(Ответственный));
		КонецЕсли;
		СтруктураБыстрогоОтбора.Свойство("Актуальность", Актуальность);
		СтруктураБыстрогоОтбора.Свойство("ДатаСобытия", ДатаСобытия);
		ОбщегоНазначенияБольничнаяАптека.ПриИзмененииОтбораПоАктуальности(Список, Актуальность, ДатаСобытия);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПередЗагрузкойДанныхИзНастроекНаСервере(Настройки)
	
	Если СтруктураБыстрогоОтбора <> Неопределено Тогда
		Настройки.Очистить();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриЗагрузкеДанныхИзНастроекНаСервере(Настройки)
	
	Если СтруктураБыстрогоОтбора <> Неопределено Тогда
		УстановитьОтборПоСостояниюСервер();
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список, "Ответственный", Ответственный,,, ЗначениеЗаполнено(Ответственный));
		ОбщегоНазначенияБольничнаяАптека.ПриИзмененииОтбораПоАктуальности(Список, Актуальность, ДатаСобытия);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// ПодключаемоеОборудование
	МенеджерОборудованияКлиент.НачатьПодключениеОборудованиеПриОткрытииФормы(Неопределено, ЭтотОбъект, "СканерШтрихкода");
	// Конец ПодключаемоеОборудование
	
	// ЭлектронноеВзаимодействие.ОбменСКонтрагентами
	ОбменСКонтрагентамиКлиент.ПриОткрытии(ЭтотОбъект);
	// Конец ЭлектронноеВзаимодействие.ОбменСКонтрагентами
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	// ПодключаемоеОборудование
	Если ПодключаемоеОборудованиеКлиент.ОбрабатыватьОповещение(ЭтотОбъект, Источник) Тогда
		Если ПодключаемоеОборудованиеКлиент.ОбработатьПолучениеДанныхОтСканераШтрихкода(ЭтотОбъект, ИмяСобытия, Параметр) Тогда
			ОбработатьШтрихкоды(ОбщегоНазначенияБольничнаяАптекаКлиентСервер.ПолучитьДанныеШтрихкода(Параметр, 1));
		КонецЕсли;
	КонецЕсли;
	// Конец ПодключаемоеОборудование
	
	// ЭлектронноеВзаимодействие.ОбменСКонтрагентами
	ОбменСКонтрагентамиБольничнаяАптекаКлиент.ОбработкаОповещения_ФормаСпискаДокумента(ЭтотОбъект, ИмяСобытия, Параметр, Источник);
	// Конец ЭлектронноеВзаимодействие.ОбменСКонтрагентами
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	
	// ПодключаемоеОборудование
	МенеджерОборудованияКлиент.НачатьОтключениеОборудованиеПриЗакрытииФормы(Неопределено, ЭтотОбъект);
	// Конец ПодключаемоеОборудование
	
КонецПроцедуры

#КонецОбласти // ОбработчикиСобытийФормы

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ
#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура УстановитьСтатусНеСогласован(Команда)
	
	ТекстВопроса = НСтр("ru='У выделенных в списке заказов будет установлен статус ""Не согласован"". По принятым в работу заказам могут быть оформлены документы. Продолжить?'");
	ОбщегоНазначенияБольничнаяАптекаКлиент.УстановитьСтатусОбъектовВСписке(Элементы.Список, "НеСогласован", НСтр("ru='Не согласован'"),, ТекстВопроса);
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьСтатусКОбеспечению(Команда)
	
	ТекстВопроса = НСтр("ru='У выделенных в списке заказов будет установлен статус ""К обеспечению"". Продолжить?'");
	ОбщегоНазначенияБольничнаяАптекаКлиент.УстановитьСтатусОбъектовВСписке(Элементы.Список, "Подтвержден", НСтр("ru='Подтвержден'"),, ТекстВопроса);
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьСтатусКВыполнению(Команда)
	
	ТекстВопроса = НСтр("ru='У выделенных в списке заказов будет установлен статус ""К выполнению"". Продолжить?'");
	ОбщегоНазначенияБольничнаяАптекаКлиент.УстановитьСтатусОбъектовВСписке(Элементы.Список, "КПоступлению", НСтр("ru='К поступлению'"),, ТекстВопроса);
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьСтатусЗакрытУПолностьюОтработанныхЗаказов(Команда)
	
	ТекстВопроса = НСтр("ru='У полностью отработанных из выделенных в списке заказов будет установлен статус ""Закрыт"". Продолжить?'");
	ОбщегоНазначенияБольничнаяАптекаКлиент.УстановитьСтатусОбъектовВСписке(Элементы.Список, "Закрыт", НСтр("ru='Закрыт'"), Новый Структура("КонтрольВыполненияЗаказа"), ТекстВопроса);
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьСтатусЗакрытСОтменойНеотработанныхСтрок(Команда)
	
	ТекстВопроса = НСтр(
		"ru='У выделенных в списке заказов будет установлен статус ""Закрыт"".
			|Все неотработанные строки будут отменены. Продолжить?'");
	ОбщегоНазначенияБольничнаяАптекаКлиент.УстановитьСтатусОбъектовВСписке(Элементы.Список, "Закрыт", НСтр("ru='Закрыт'"), Новый Структура("ОтменаНеотработанныхСтрок"), ТекстВопроса);
	
КонецПроцедуры

#КонецОбласти // ОбработчикиКомандФормы

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ФОРМЫ
#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура ТекущееСостояниеПриИзменении(Элемент)
	
	УстановитьОтборПоСостояниюСервер();
	
КонецПроцедуры

&НаКлиенте
Процедура ТекущееСостояниеОчистка(Элемент, СтандартнаяОбработка)
	
	Если Состояние = Неопределено Тогда
		СтандартнаяОбработка = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборСрокВыполненияПриИзменении(Элемент)
	
	ОбработатьИзменениеОтбораПоАктуальности();
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборСрокВыполненияОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	Оповещение = Новый ОписаниеОповещения("ОтборСрокВыполненияОбработкаВыбораЗавершение", ЭтотОбъект);
	ВзаимодействиеСПользователемКлиент.ПриВыбореАктуальности(ВыбранноеЗначение, СтандартнаяОбработка, Оповещение);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборСрокВыполненияОчистка(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	Если ЗначениеЗаполнено(Актуальность) Тогда
		Актуальность = "";
		ОбработатьИзменениеОтбораПоАктуальности();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборОтветственныйПриИзменении(Элемент)
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список, "Ответственный", Ответственный,,, ЗначениеЗаполнено(Ответственный));
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборОтветственныйОчистка(Элемент, СтандартнаяОбработка)
	
	Если Не ЗначениеЗаполнено(Ответственный) Тогда
		СтандартнаяОбработка = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СписокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	// ЭлектронноеВзаимодействие.ОбменСКонтрагентами
	ОбменСКонтрагентамиБольничнаяАптекаКлиент.СписокВыбор_ФормаСпискаДокумента(ЭтотОбъект, Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка);
	// Конец ЭлектронноеВзаимодействие.ОбменСКонтрагентами
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПриАктивизацииСтроки(Элемент)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	// ЭлектронноеВзаимодействие.ОбменСКонтрагентами
	ОбменСКонтрагентамиКлиент.ПриАктивизацииСтроки_ФормаСписка(ЭтотОбъект);
	// Конец ЭлектронноеВзаимодействие.ОбменСКонтрагентами
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	
	ОценкаПроизводительностиБольничнаяАптекаКлиент.НачатьЗамерСозданияФормыОбъекта(ТипыДокументов[0], Отказ, Копирование);
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПередНачаломИзменения(Элемент, Отказ)
	
	ОценкаПроизводительностиБольничнаяАптекаКлиент.НачатьЗамерОткрытияФормыОбъекта(Элемент.ТекущаяСтрока, Отказ);
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура СписокПриПолученииДанныхНаСервере(ИмяЭлемента, Настройки, Строки)
	
	// ЭлектронноеВзаимодействие.ОбменСКонтрагентами
	ОбменСКонтрагентами.ПриПолученииДанныхНаСервере(ИмяЭлемента, Настройки, Строки);
	// Конец ЭлектронноеВзаимодействие.ОбменСКонтрагентами
	
КонецПроцедуры

#КонецОбласти // ОбработчикиСобытийЭлементовФормы

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ
#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	ОбработкаТабличнойЧастиСервер.УстановитьОформлениеПоляДата(ЭтотОбъект);
	
	ЗаказыСервер.УстановитьОформлениеСостоянияДокументаВСписке(Список, Перечисления.СостоянияВнутреннихЗаказов.Закрыт);
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура ЗаполнитьСписокВыбораОтбораПоСостоянию(СписокВыбора, ИспользоватьСтатусы)
	
	СписокВыбора.Добавить("ВсеОткрытые", НСтр("ru='Все открытые'"));
	СписокВыбора.Добавить("ВсеОжидающиеИсполнения", НСтр("ru='Все ожидающие исполнения'"));
	
	Если ИспользоватьСтатусы Тогда
		Для Каждого Состояние Из Перечисления.СостоянияВнутреннихЗаказов Цикл
			СписокВыбора.Добавить(Состояние, Состояние);
		КонецЦикла;
	Иначе
		СписокВыбора.Добавить(Перечисления.СостоянияВнутреннихЗаказов.ВПроцессеОтгрузки);
		СписокВыбора.Добавить(Перечисления.СостоянияВнутреннихЗаказов.ВПроцессеПоступления);
		СписокВыбора.Добавить(Перечисления.СостоянияВнутреннихЗаказов.Закрыт);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьОтборПоСостояниюСервер()
	
	Если Состояние = "ВсеОткрытые" Тогда
		
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список, "Состояние", Перечисления.СостоянияВнутреннихЗаказов.Закрыт, ВидСравненияКомпоновкиДанных.НеРавно,, Истина);
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список, "ПометкаУдаления", Ложь,,, Истина);
		
	ИначеЕсли Состояние = "ВсеОжидающиеИсполнения" Тогда
		
		МассивСостояний = Новый Массив;
		МассивСостояний.Добавить(Перечисления.СостоянияВнутреннихЗаказов.ОжидаетсяСогласование);
		МассивСостояний.Добавить(Перечисления.СостоянияВнутреннихЗаказов.ГотовКОтгрузке);
		МассивСостояний.Добавить(Перечисления.СостоянияВнутреннихЗаказов.ГотовКЗакрытию);
		
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список, "Состояние", МассивСостояний, ВидСравненияКомпоновкиДанных.ВСписке,, Истина);
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список, "ПометкаУдаления", Ложь,,, Истина);
		
	Иначе
		
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список, "Состояние", Состояние, ВидСравненияКомпоновкиДанных.Равно,, ЗначениеЗаполнено(Состояние));
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список, "ПометкаУдаления",,,, Ложь);
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОбработатьИзменениеОтбораПоАктуальности()
	
	ОбщегоНазначенияБольничнаяАптека.ПриИзмененииОтбораПоАктуальности(Список, Актуальность, ДатаСобытия);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборСрокВыполненияОбработкаВыбораЗавершение(ОтборАктуальности, ДополнительныеПараметры) Экспорт
	
	Актуальность = ОтборАктуальности.Актуальность;
	ДатаСобытия = ОтборАктуальности.ДатаСобытия;
	ПодключитьОбработчикОжидания("ОбновитьОтборПоАктуальности", 0.1, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьОтборПоАктуальности()
	ОбработатьИзменениеОтбораПоАктуальности();
КонецПроцедуры

&НаКлиенте
Процедура ОбработатьШтрихкоды(ДанныеШтрихкода)
	
	ШтрихкодированиеПечатныхФормКлиент.ПоказатьСсылкуПоШтрихкодуТабличногоДокумента(Элементы.Список, ДанныеШтрихкода.Штрихкод, ТипыДокументов);
	
КонецПроцедуры

#КонецОбласти // СлужебныеПроцедурыИФункции

////////////////////////////////////////////////////////////////////////////////
// СТАНДАРТНЫЕ ПОДСИСТЕМЫ
#Область СтандартныеПодсистемы

// СтандартныеПодсистемы.ПодключаемыеКоманды

&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Элементы.Список);
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат) Экспорт
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, Элементы.Список, Результат);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Элементы.Список);
КонецПроцедуры

// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

// ИнтеграцияС1СДокументооборотом

&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуИнтеграции(Команда)
	
	// ИнтеграцияС1СДокументооборотом
	ИнтеграцияС1СДокументооборотБазоваяФункциональностьКлиент.ВыполнитьПодключаемуюКомандуИнтеграции(Команда, ЭтотОбъект, Элементы.Список);
	// Конец ИнтеграцияС1СДокументооборотом
	
КонецПроцедуры

// Конец ИнтеграцияС1СДокументооборотом

// ЭлектронноеВзаимодействие.ОбменСКонтрагентами

&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуЭДО(Команда)
	
	ЭлектронноеВзаимодействиеКлиент.ВыполнитьПодключаемуюКомандуЭДО(Команда, ЭтотОбъект, Элементы.Список);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбработчикОжиданияЭДО()
	
	ОбменСКонтрагентамиКлиент.ОбработчикОжиданияЭДО(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьВидимостьСостоянияЭДО()
	
	ОбменСКонтрагентамиКлиент.ОбработчикОбновленияВидимостьСостоянияЭДО(ЭтотОбъект, Элементы.ПредставлениеСостояния);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКомандыЭДО()
	ОбменСКонтрагентамиКлиент.ОбновитьКоманды(ЭтотОбъект, Элементы.Список);
КонецПроцедуры

// Конец ЭлектронноеВзаимодействие.ОбменСКонтрагентами

#КонецОбласти // СтандартныеПодсистемы
