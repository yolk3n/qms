﻿
////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьУсловноеОформлениеФормы();
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
	
	// СтандартныеПодсистемы.РаботаСКонтрагентами
	ПроверкаКонтрагентов.ПриСозданииНаСервереСписокДокументов(Список);
	
	Если Не ПроверкаКонтрагентовВызовСервера.ИспользованиеПроверкиВозможно() Тогда
		Элементы.ЕстьОшибкиПроверкиКонтрагентов.Видимость = Ложь;
	КонецЕсли;
	// Конец СтандартныеПодсистемы.РаботаСКонтрагентами
	
	// ПодключаемоеОборудование
	ПодключаемоеОборудованиеСервер.НастроитьФормуДляИспользованияПодключаемогоОборудования(ЭтотОбъект);
	// Конец ПодключаемоеОборудование
	
	// ЭлектронноеВзаимодействие.ОбменСКонтрагентами
	ОбменСКонтрагентамиБольничнаяАптека.ПриСозданииНаСервере_ФормаСпискаДокумента(ЭтотОбъект);
	// Конец ЭлектронноеВзаимодействие.ОбменСКонтрагентами
	
	ДоступныеОрганизации = Справочники.Организации.ПолучитьДанныеВыбора(Новый Структура("ТаблицаОбъекта", Метаданные.Документы.ПоступлениеТоваров.ПолноеИмя())).ВыгрузитьЗначения();
	Элементы.ОтборОрганизация.СписокВыбора.ЗагрузитьЗначения(ДоступныеОрганизации);
	
	ДоступныеСклады = Справочники.Склады.ПолучитьДоступные(Перечисления.ТипыСкладов.ТипыСкладовАптеки(), Метаданные.Документы.ПоступлениеТоваров.ПолноеИмя());
	Элементы.ОтборСклад.СписокВыбора.ЗагрузитьЗначения(ДоступныеСклады);
	
	ИспользоватьЗаказыПоставщикам = ПолучитьФункциональнуюОпцию("ИспользоватьЗаказыПоставщикам");
	ИспользоватьСпецификацииКДоговорам = ПолучитьФункциональнуюОпцию("ИспользоватьСпецификацииКДоговорам");
	
	СписокРаспоряженияНаОформление.Параметры.УстановитьЗначениеПараметра("ИспользоватьЗаказыПоставщикам", ИспользоватьЗаказыПоставщикам);
	СписокРаспоряженияНаОформление.Параметры.УстановитьЗначениеПараметра("ИспользоватьСпецификацииКДоговорам", ИспользоватьСпецификацииКДоговорам);
	
	Если Не ИспользоватьЗаказыПоставщикам И Не ИспользоватьСпецификацииКДоговорам Тогда
		Элементы.Страницы.ОтображениеСтраниц = ОтображениеСтраницФормы.Нет;
		Элементы.ГруппаРаспоряженияНаОформление.Видимость = Ложь;
	КонецЕсли;
	
	Элементы.СписокРаспоряженияНаОформлениеСоздатьПоступлениеТоваров.Видимость =
		ПравоДоступа("Добавление", Метаданные.Документы.ПоступлениеТоваров);
	
КонецПроцедуры

&НаСервере
Процедура ПриЗагрузкеДанныхИзНастроекНаСервере(Настройки)
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		Список,
		"Контрагент",
		ОтборКонтрагент,
		,
		,
		ЗначениеЗаполнено(ОтборКонтрагент));
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		Список,
		"Склад",
		ОтборСклад,
		,
		,
		ЗначениеЗаполнено(ОтборСклад));
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		Список,
		"Организация",
		ОтборОрганизация,
		,
		,
		ЗначениеЗаполнено(ОтборОрганизация));

	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		СписокРаспоряженияНаОформление,
		"Контрагент",
		ОтборКонтрагент,
		,
		,
		ЗначениеЗаполнено(ОтборКонтрагент));
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		СписокРаспоряженияНаОформление,
		"Организация",
		ОтборОрганизация,
		,
		,
		ЗначениеЗаполнено(ОтборОрганизация));
	
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
Процедура СоздатьПоступлениеТоваров(Команда)
	
	ТекущаяСтрока = Элементы.СписокРаспоряженияНаОформление.ТекущиеДанные;
	Если ТекущаяСтрока = Неопределено
	 Или ТипЗнч(Элементы.СписокРаспоряженияНаОформление.ТекущаяСтрока) = Тип("СтрокаГруппировкиДинамическогоСписка") Тогда
		
		ТекстПредупреждения = НСтр("ru = 'Команда не может быть выполнена для указанного объекта.'");
		ПоказатьПредупреждение(, ТекстПредупреждения);
		Возврат;
		
	КонецЕсли;
	
	ОценкаПроизводительностиБольничнаяАптекаКлиент.НачатьЗамерСозданияФормыОбъекта(ТипыДокументов[0], Ложь, Ложь);
	ОткрытьФорму("Документ.ПоступлениеТоваров.ФормаОбъекта", Новый Структура("Основание", ТекущаяСтрока.Ссылка));
	
КонецПроцедуры

#КонецОбласти // ОбработчикиКомандФормы

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ФОРМЫ
#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура ОтборКонтрагентПриИзменении(Элемент)
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		Список,
		"Контрагент",
		ОтборКонтрагент,
		,
		,
		ЗначениеЗаполнено(ОтборКонтрагент));
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		СписокРаспоряженияНаОформление,
		"Контрагент",
		ОтборКонтрагент,
		,
		,
		ЗначениеЗаполнено(ОтборКонтрагент));
		
КонецПроцедуры

&НаКлиенте
Процедура ОтборСкладПриИзменении(Элемент)
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		Список,
		"Склад",
		ОтборСклад,
		,
		,
		ЗначениеЗаполнено(ОтборСклад));
КонецПроцедуры

&НаКлиенте
Процедура ОтборОрганизацияПриИзменении(Элемент)
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		Список,
		"Организация",
		ОтборОрганизация,
		,
		,
		ЗначениеЗаполнено(ОтборОрганизация));
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		СписокРаспоряженияНаОформление,
		"Организация",
		ОтборОрганизация,
		,
		,
		ЗначениеЗаполнено(ОтборОрганизация));
	
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
	
	ДанныеСтроки = Элемент.ТекущиеДанные;
	Если ДанныеСтроки = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ОценкаПроизводительностиБольничнаяАптекаКлиент.НачатьЗамерОткрытияФормыОбъекта(ДанныеСтроки.Ссылка, Отказ);
	
КонецПроцедуры

&НаКлиенте
Процедура СписокРаспоряженияНаОформлениеВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ПоказатьЗначение(Неопределено, Элемент.ДанныеСтроки(ВыбраннаяСтрока).Ссылка);
	
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
Процедура УстановитьУсловноеОформлениеФормы()
	
	ОбработкаТабличнойЧастиСервер.УстановитьОформлениеПоляДата(ЭтотОбъект);
	ОбработкаТабличнойЧастиСервер.УстановитьОформлениеПоляДата(ЭтотОбъект, "СписокРаспоряженияНаОформление");
	
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


#Область ДоработкиСоколов
&Насервере 
Функция ВернутьКомментарий(СсылкаНаОбъект)
	Возврат СсылкаНаОбъект.Комментарий;
КонецФункции

&НаКлиенте
Процедура сок_ИзменитьКомментарийПосле(Команда)
	ТекущиеДанные=Элементы.Список.ТекущиеДанные;
	Если НЕ ТекущиеДанные=Неопределено Тогда
		Комментарий = Вернутькомментарий(Элементы.Список.ТекущаяСтрока);
		ОписаниеОповещения=Новый Описаниеоповещения("ИзменитьКомментарийЗавершение",Этаформа,Новый Структура("Ключ",Элементы.Список.ТекущаяСтрока));
		ПоказатьВводСтроки(ОписаниеОповещения,Комментарий,"Измените комментарий",,Истина);
	КонецЕсли;	
	
КонецПроцедуры

&НаСервере
Процедура ИзменитьКомментарийНаСервере(СсылкаНаОбъект,Комментарий) 
	Элемент=СсылкаНаОбъект.получитьОбъект();
	Если Ложь Тогда Элемент=Документы.ПоступлениеТоваров.СоздатьДокумент(); КонецЕсли;
	
	Элемент.Комментарий=Комментарий;
	Элемент.ДополнительныеСвойства.Вставить("ЗаписьВЗакрытомПериоде",Истина);
	Элемент.ОбменДанными.Загрузка=Истина;
	Элемент.Записать();
КонецПроцедуры

&НаКлиенте
Процедура ИзменитьКомментарийЗавершение(Рез,Парам) Экспорт
	Если Не Рез=Неопределено Тогда
		ИзменитьКомментарийНаСервере(Парам.Ключ,Рез);
	КонецЕсли;
КонецПроцедуры	


&НаСервере
Процедура сок_ВерутьВСостояниеЗаказаноПослеНаСервере(СсылкаНаОбъект)
	Отказ=Ложь;
	сок_СерверПривилегированный.ПоступлениеТоваров_ВерутьВСостояниеЗаказано(СсылкаНаОбъект,Отказ);
	Если Отказ Тогда
		ОбщегоНазначения.СообщитьПользователю("Документ "+СсылкаНаОбъект+" перевод в состояние ""Заказано"" не выполнен.");
	КонецЕсли;	
КонецПроцедуры

&НаКлиенте
Процедура сок_ВерутьВСостояниеЗаказаноПосле(Команда)
	Для Каждого Стр из Элементы.Список.ВыделенныеСтроки Цикл
		сок_ВерутьВСостояниеЗаказаноПослеНаСервере(Стр);
	КонецЦикла;	
	Элементы.Список.Обновить();
КонецПроцедуры

&НаСервере
Процедура сок_ВсостояниеПолученоПослеНаСервере(СсылкаНаОбъект)
	
	Отказ=Ложь;           
	Попытка
		сок_СерверПривилегированный.ПоступлениеТоваров_ВСостояниеПолученоПослеНаСервере(СсылкаНаОбъект,Отказ);
	Исключение
	КонецПопытки;	
	
КонецПроцедуры

&НаКлиенте
Процедура сок_ВСостояниеПолучено(Команда)
	НПП=1;
	КС=Элементы.Список.ВыделенныеСтроки.Количество();
	Для Каждого Стр из Элементы.Список.ВыделенныеСтроки Цикл
		Состояние(""+НПП+" из "+КС,НПП/КС*100);
		НПП=НПП+1;
		сок_ВСостояниеПолученоПослеНаСервере(Стр);
	КонецЦикла;	 
	
	Элементы.Список.Обновить();
КонецПроцедуры

&НаСервере
Процедура ИзменитьПровереноБухгалтериейНаСервере(Ссылка)
	Если Ложь Тогда Ссылка=Документы.ПоступлениеТоваров.ПустаяСсылка(); КонецЕсли;
	ДокОбъект = Ссылка.ПолучитьОбъект();
	ДокОбъект.ПровереноБухгалтерией=НЕ ДокОбъект.ПровереноБухгалтерией;
	ДокОбъект.ОбменДанными.Загрузка=Истина;
	Попытка
		ДокОбъект.Записать();
	Исключение
		ОбщегоНазначения.СообщитьПользователю("Не удалось изменить пометку ""Проверено бухгалтерией"" для "+Ссылка,Ссылка);
	КонецПопытки;	
КонецПроцедуры


&НаКлиенте
Процедура сок_ИзменитьПровереноБухгалтериейПосле(Команда)
	Ссылка = Элементы.Список.ТекущиеДанные.Ссылка;
	ИзменитьПровереноБухгалтериейНаСервере(Ссылка);
	Элементы.Список.Обновить();
КонецПроцедуры


#КонецОбласти

