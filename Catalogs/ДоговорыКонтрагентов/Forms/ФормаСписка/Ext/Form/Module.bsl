﻿
////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьУсловноеОформление();
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	// СтандартныеПодсистемы.ВерсионированиеОбъектов
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	// ЭлектронноеВзаимодействие.ОбменСКонтрагентами
	ПараметрыПриСозданииНаСервере = ОбменСКонтрагентами.ПараметрыПриСозданииНаСервере_ФормаСписка();
	ПараметрыПриСозданииНаСервере.Форма = ЭтотОбъект;
	ПараметрыПриСозданииНаСервере.МестоРазмещенияКоманд = Элементы.КомандыЭДО;
	ПараметрыПриСозданииНаСервере.ИсточникКомандЭДО     = Список;
	ОбменСКонтрагентами.ПриСозданииНаСервере_ФормаСписка(ПараметрыПриСозданииНаСервере);
	// Конец ЭлектронноеВзаимодействие.ОбменСКонтрагентами
	
	// ИнтеграцияС1СДокументооборотом
	ИнтеграцияС1СДокументооборотБазоваяФункциональность.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец ИнтеграцияС1СДокументооборотом
	
	Список.Параметры.УстановитьЗначениеПараметра("ДатаАктуальности", НачалоДня(ТекущаяДатаСеанса()));
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список, "Владелец", Справочники.Контрагенты.ДляПереходаНаДоговорыБезВладельца);
	
	ОбщегоНазначенияБольничнаяАптека.ЗаполнитьСписокВыбораОтбораПоАктуальности(Элементы.ОтборСрокДействия.СписокВыбора);
	ОбщегоНазначенияБольничнаяАптека.ЗаполнитьСписокПользователейСПравомИзменения(Элементы.ОтборМенеджер.СписокВыбора, Метаданные.Справочники.ДоговорыКонтрагентов);
	
	СтруктураБыстрогоОтбора = Параметры.СтруктураБыстрогоОтбора;
	Если СтруктураБыстрогоОтбора <> Неопределено Тогда
		Если СтруктураБыстрогоОтбора.Свойство("Состояние", Состояние) Тогда
			ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список, "Состояние", Состояние,,, ЗначениеЗаполнено(Состояние));
		КонецЕсли;
		Если СтруктураБыстрогоОтбора.Свойство("Организация", Организация) Тогда
			ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список, "Организация", Организация,,, ЗначениеЗаполнено(Организация));
		КонецЕсли;
		Если СтруктураБыстрогоОтбора.Свойство("Контрагент", Контрагент) Тогда
			ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список, "Контрагент", Контрагент,,, ЗначениеЗаполнено(Контрагент));
		КонецЕсли;
		Если СтруктураБыстрогоОтбора.Свойство("Менеджер", Менеджер) Тогда
			ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список, "Менеджер", Менеджер,,, ЗначениеЗаполнено(Менеджер));
		КонецЕсли;
		СтруктураБыстрогоОтбора.Свойство("Актуальность", Актуальность);
		СтруктураБыстрогоОтбора.Свойство("ДатаСобытия", ДатаСобытия);
		ОбщегоНазначенияБольничнаяАптека.ПриИзмененииОтбораПоАктуальности(Список, Актуальность, ДатаСобытия);
	КонецЕсли;
	
	Если Параметры.Свойство("Заголовок") Тогда
		АвтоЗаголовок = Ложь;
		Заголовок = Параметры.Заголовок;
	КонецЕсли;
	
	Если Параметры.Свойство("Отбор") И Параметры.Отбор.Свойство("Контрагент") Тогда
		Элементы.ОтборКонтрагент.Видимость = Ложь;
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
	
	Если СтруктураБыстрогоОтбора = Неопределено Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список, "Состояние", Состояние,,, ЗначениеЗаполнено(Состояние));
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список, "Организация", Организация,,, ЗначениеЗаполнено(Организация));
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список, "Контрагент", Контрагент,,, ЗначениеЗаполнено(Контрагент));
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список, "Менеджер", Менеджер,,, ЗначениеЗаполнено(Менеджер));
		ОбщегоНазначенияБольничнаяАптека.ПриИзмененииОтбораПоАктуальности(Список, Актуальность, ДатаСобытия);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// ЭлектронноеВзаимодействие.ОбменСКонтрагентами
	ОбменСКонтрагентамиКлиент.ПриОткрытии(ЭтотОбъект);
	// Конец ЭлектронноеВзаимодействие.ОбменСКонтрагентами
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	// ЭлектронноеВзаимодействие.ОбменСКонтрагентами
	ПараметрыОповещенияЭДО = ОбменСКонтрагентамиКлиент.ПараметрыОповещенияЭДО_ФормаСписка();
	ПараметрыОповещенияЭДО.Форма = ЭтотОбъект;
	ПараметрыОповещенияЭДО.ИмяДинамическогоСписка = "Список";
	ОбменСКонтрагентамиКлиент.ОбработкаОповещения_ФормаСписка(ИмяСобытия, Параметр, Источник, ПараметрыОповещенияЭДО);
	// Конец ЭлектронноеВзаимодействие.ОбменСКонтрагентами
	
КонецПроцедуры

#КонецОбласти // ОбработчикиСобытийФормы

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ
#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОтборСостояниеПриИзменении(Элемент)
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список, "Состояние", Состояние,,, ЗначениеЗаполнено(Состояние));
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборСостояниеОчистка(Элемент, СтандартнаяОбработка)
	
	Если Не ЗначениеЗаполнено(Состояние) Тогда
		СтандартнаяОбработка = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборСрокДействияПриИзменении(Элемент)
	
	ОбработатьИзменениеОтбораПоАктуальности();
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборСрокДействияОчистка(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	Если ЗначениеЗаполнено(Актуальность) Тогда
		Актуальность = "";
		ОбработатьИзменениеОтбораПоАктуальности();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборСрокДействияОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	Оповещение = Новый ОписаниеОповещения("ОтборСрокВыполненияОбработкаВыбораЗавершение", ЭтотОбъект);
	ВзаимодействиеСПользователемКлиент.ПриВыбореАктуальности(ВыбранноеЗначение, СтандартнаяОбработка, Оповещение);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборОрганизацияПриИзменении(Элемент)
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список, "Организация", Организация,,, ЗначениеЗаполнено(Организация));
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборОрганизацияОчистка(Элемент, СтандартнаяОбработка)
	
	Если Не ЗначениеЗаполнено(Организация) Тогда
		СтандартнаяОбработка = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборКонтрагентПриИзменении(Элемент)
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список, "Контрагент", Контрагент,,, ЗначениеЗаполнено(Контрагент));
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборКонтрагентОчистка(Элемент, СтандартнаяОбработка)
	
	Если Не ЗначениеЗаполнено(Контрагент) Тогда
		СтандартнаяОбработка = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборМенеджерПриИзменении(Элемент)
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список, "Менеджер", Менеджер,,, ЗначениеЗаполнено(Менеджер));
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборМенеджерОчистка(Элемент, СтандартнаяОбработка)
	
	Если Не ЗначениеЗаполнено(Менеджер) Тогда
		СтандартнаяОбработка = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьСтатусДействует(Команда)
	
	ТекстВопроса = НСтр("ru='У выделенных в списке договоров будет установлен статус ""Действует"". Продолжить?'");
	ОбщегоНазначенияБольничнаяАптекаКлиент.УстановитьСтатусОбъектовВСписке(Элементы.Список, "Действует", НСтр("ru='Действует'"),, ТекстВопроса);
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьСтатусЗакрыт(Команда)
	
	ТекстВопроса = НСтр("ru='У выделенных в списке договоров будет установлен статус ""Закрыт"". После изменения статуса действующие договоры перестанут действовать. Продолжить?'");
	ОбщегоНазначенияБольничнаяАптекаКлиент.УстановитьСтатусОбъектовВСписке(Элементы.Список, "Закрыт", НСтр("ru='Закрыт'"),, ТекстВопроса);
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьСтатусНеСогласован(Команда)
	
	ТекстВопроса = НСтр("ru='У выделенных в списке договоров будет установлен статус ""Не согласован"". По действующим договорам могут быть оформлены документы. После изменения статуса действующие договоры перестанут действовать. Продолжить?'");
	ОбщегоНазначенияБольничнаяАптекаКлиент.УстановитьСтатусОбъектовВСписке(Элементы.Список, "НеСогласован", НСтр("ru='Не согласован'"),, ТекстВопроса);
	
КонецПроцедуры

#КонецОбласти // ОбработчикиКомандФормы

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ФОРМЫ
#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура СписокПриАктивизацииСтроки(Элемент)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	// ЭлектронноеВзаимодействие.ОбменСКонтрагентами
	ОбменСКонтрагентамиКлиент.ПриАктивизацииСтроки_ФормаСписка(ЭтотОбъект);
	// Конец ЭлектронноеВзаимодействие.ОбменСКонтрагентами
	
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
	
	ЗаказыСервер.УстановитьОформлениеСостоянияДокументаВСписке(Список, Перечисления.СостоянияДоговоровКонтрагентов.Закрыт);
	
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
Процедура Подключаемый_ОбновитьКомандыЭДО()
	ОбменСКонтрагентамиКлиент.ОбновитьКоманды(ЭтотОбъект, Элементы.Список);
КонецПроцедуры

// Конец ЭлектронноеВзаимодействие.ОбменСКонтрагентами

// ИнтеграцияС1СДокументооборотом

&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуИнтеграции(Команда)
	
	// ИнтеграцияС1СДокументооборотом
	ИнтеграцияС1СДокументооборотБазоваяФункциональностьКлиент.ВыполнитьПодключаемуюКомандуИнтеграции(Команда, ЭтотОбъект, Элементы.Список);
	// Конец ИнтеграцияС1СДокументооборотом
	
КонецПроцедуры

// Конец ИнтеграцияС1СДокументооборотом

#КонецОбласти // СтандартныеПодсистемы
