﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

////////////////////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС
#Область ПрограммныйИнтерфейс

// Получает договор контрагента, если он один в справочнике.
//
// Возвращаемое значение:
// СправочникСсылка.ДоговорКонтрагента - Найденный договор контрагента
// Неопределено - если договора нет или договоров больше одного
//
Функция ПолучитьДоговорПоУмолчанию(Контрагент, Организация) Экспорт
	
	Запрос = Новый Запрос(
	"
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ ПЕРВЫЕ 2
	|	Договоры.Ссылка КАК Договор
	|ИЗ
	|	Справочник.ДоговорыКонтрагентов КАК Договоры
	|ГДЕ
	|	НЕ Договоры.ПометкаУдаления
	|	И Договоры.Контрагент = &Контрагент
	|	И Договоры.Организация = &Организация
	|");
	
	Запрос.УстановитьПараметр("Контрагент", Контрагент);
	Запрос.УстановитьПараметр("Организация", Организация);
	
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() И Выборка.Количество() = 1 Тогда
		Договор = Выборка.Договор;
	Иначе
		Договор = Справочники.ДоговорыКонтрагентов.ПустаяСсылка();
	КонецЕсли;
	
	Возврат Договор;
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// Работа со статусами документа
#Область Статусы

// Формирует запрос проверки при смене статуса списка документов
// Вызываются из процедуры ОбщегоНазначенияБольничнаяАптека.УстановитьСтатусОбъектов(...)
//
// Параметры:
//   МассивДокументов - Массив - Массив ссылок на документы, которые надо проверять
//   НовыйСтатус - Строка - Имя нового статуса
//   ДополнительныеПараметры - Структура - Структура дополнительных параметров
//
// Возвращаемое значение:
//   Запрос - Запрос проверки перед сменой статуса
//
Функция СформироватьЗапросПроверкиПриСменеСтатуса(МассивДокументов, НовыйСтатус, ДополнительныеПараметры) Экспорт
	
	ЗначениеНовогоСтатуса = Перечисления.СтатусыДоговоровКонтрагентов[НовыйСтатус];
	
	ТекстЗапроса = "
	|ВЫБРАТЬ
	|	ТаблицаДокументов.Ссылка                 КАК Ссылка,
	|	ПРЕДСТАВЛЕНИЕ(ТаблицаДокументов.Ссылка)  КАК Представление,
	|	ПРЕДСТАВЛЕНИЕ(ТаблицаДокументов.Статус)  КАК ПредставлениеТекущегоСтатуса,
	|	ПРЕДСТАВЛЕНИЕ(&Статус)                   КАК ПредставлениеНовогоСтатуса,
	|	ВЫБОР
	|		КОГДА ТаблицаДокументов.Статус = &Статус
	|			ТОГДА ИСТИНА
	|		ИНАЧЕ ЛОЖЬ
	|	КОНЕЦ                                    КАК СтатусСовпадает,
	|	ИСТИНА                                   КАК Проведен,
	|	ТаблицаДокументов.ПометкаУдаления        КАК ПометкаУдаления,
	|	ЛОЖЬ                                     КАК ЗаписьПроведением
	|ИЗ
	|	Справочник.ДоговорыКонтрагентов КАК ТаблицаДокументов
	|ГДЕ
	|	ТаблицаДокументов.Ссылка В(&МассивДокументов)
	|	И НЕ ТаблицаДокументов.ЭтоГруппа
	|";
	
	Запрос = Новый Запрос(ТекстЗапроса);
	Запрос.УстановитьПараметр("Статус", ЗначениеНовогоСтатуса);
	Запрос.УстановитьПараметр("МассивДокументов", МассивДокументов);
	
	Возврат Запрос;
	
КонецФункции

// Возвращает результат проверки при смене статуса документа
// Вызываются из процедуры ОбщегоНазначенияБольничнаяАптека.УстановитьСтатусОбъектов(...)
//
// Параметры:
//   ВыборкаПроверки - ВыборкаИзРезультатаЗапроса - Текущая строка выборки
//   НовыйСтатус - Перечисление - Новый статус
//   ДополнительныеПараметры - Структура - Структура дополнительных параметров
//
// Возвращаемое значение:
//   Булево - Истина, в случае успешного завершения проверки
//
Функция ПроверкаПередСменойСтатуса(ВыборкаПроверки, НовыйСтатус, ДополнительныеПараметры) Экспорт
	
	Возврат Истина;
	
КонецФункции

#КонецОбласти // Статусы

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.УправлениеДоступом

// См. УправлениеДоступомПереопределяемый.ПриЗаполненииСписковСОграничениемДоступа.
Процедура ПриЗаполненииОграниченияДоступа(Ограничение) Экспорт

	Ограничение.Текст =
	"РазрешитьЧтениеИзменение
	|ГДЕ
	|	ЭтоГруппа ИЛИ
	|	ЗначениеРазрешено(Организация)";

КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом

#КонецОбласти

#КонецОбласти // ПрограммныйИнтерфейс

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ
#Область СлужебныеПроцедурыИФункции

////////////////////////////////////////////////////////////////////////////////
// Печать
#Область Печать

// Заполняет список команд печати.
// 
// Параметры:
//   КомандыПечати - ТаблицаЗначений - состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати.
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	
	
	
КонецПроцедуры

#КонецОбласти // Печать

////////////////////////////////////////////////////////////////////////////////
// Команды формы
#Область КомандыФормы

// Заполняет список команд ввода на основании.
// 
// Параметры:
//   КомандыСоздатьНаОсновании - ТаблицаЗначений - Таблица команд для вывода в подменю. Для изменения.
//
Процедура ДобавитьКомандыСозданияНаОсновании(КомандыСоздатьНаОсновании, НастройкиФормы) Экспорт
	
	ВводНаОснованииБольничнаяАптека.ДобавитьКомандыСозданияНаОсновании(ПустаяСсылка().Метаданные().ПолноеИмя(), КомандыСоздатьНаОсновании, НастройкиФормы);
	
КонецПроцедуры

// Заполняет список команд отчетов.
// 
// Параметры:
//   КомандыОтчетов - ТаблицаЗначений - Таблица команд для вывода в подменю. Для изменения.
//
Процедура ДобавитьКомандыОтчетов(КомандыОтчетов, НастройкиФормы) Экспорт
	
	МенюОтчетыБольничнаяАптека.ДобавитьОбщиеКоманды(ПустаяСсылка().Метаданные().ПолноеИмя(), КомандыОтчетов, НастройкиФормы);
	
КонецПроцедуры

#КонецОбласти // КомандыФормы

#КонецОбласти // СлужебныеПроцедурыИФункции

////////////////////////////////////////////////////////////////////////////////
// СТАНДАРТНЫЕ ПОДСИСТЕМЫ
#Область СтандартныеПодсистемы

// Возвращает описание блокируемых реквизитов
//
// Возвращаемое значение:
//  Массив - имена блокируемых реквизитов
//   Элемент массива - Строка в формате:
//     ИмяРеквизита[;ИмяЭлементаФормы,...]
//      где
//       ИмяРеквизита     - имя реквизита объекта
//       ИмяЭлементаФормы - имя элемента формы, связанного с реквизитом
//
Функция ПолучитьБлокируемыеРеквизитыОбъекта() Экспорт
	
	БлокируемыеРеквизиты = Новый Массив;
	
	БлокируемыеРеквизиты.Добавить("Контрагент");
	БлокируемыеРеквизиты.Добавить("Организация");
	БлокируемыеРеквизиты.Добавить("ВалютаВзаиморасчетов");
	
	Возврат БлокируемыеРеквизиты;
	
КонецФункции

#Область ТекущиеДела

// Заполняет список текущих дел пользователя.
// Описание параметров процедуры см. в ТекущиеДелаСлужебный.НоваяТаблицаТекущихДел()
//
Процедура ПриЗаполненииСпискаТекущихДел(ТекущиеДела) Экспорт
	
	ОбщиеПараметрыЗапросов = ТекущиеДелаСервер.ОбщиеПараметрыЗапросов();
	
	Доступность = ОбщиеПараметрыЗапросов.ЭтоПолноправныйПользователь
		Или ПравоДоступа("Редактирование", ПустаяСсылка().Метаданные());
	
	Если Не Доступность Тогда
		Возврат;
	КонецЕсли;
	
	// Расчет показателей
	Запрос = Новый Запрос;
	Запрос.Текст = "
	|ВЫБРАТЬ
	|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ВЫБОР
	|			КОГДА Договор.Статус = ЗНАЧЕНИЕ(Перечисление.СтатусыДоговоровКонтрагентов.НеСогласован)
	|				ТОГДА Договор.Ссылка
	|		КОНЕЦ) КАК ДоговорыНаСогласовании,
	|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ВЫБОР
	|			КОГДА Договор.Статус = ЗНАЧЕНИЕ(Перечисление.СтатусыДоговоровКонтрагентов.НеСогласован)
	|					И (Договор.ДатаНачалаДействия <> ДАТАВРЕМЯ(1, 1, 1)
	|							И Договор.ДатаНачалаДействия < &ДатаАктуальности
	|						ИЛИ Договор.ДатаОкончанияДействия <> ДАТАВРЕМЯ(1, 1, 1)
	|							И Договор.ДатаОкончанияДействия < &ДатаАктуальности)
	|				ТОГДА Договор.Ссылка
	|			КОГДА Договор.Статус = ЗНАЧЕНИЕ(Перечисление.СтатусыДоговоровКонтрагентов.Действует)
	|					И Договор.ДатаОкончанияДействия <> ДАТАВРЕМЯ(1, 1, 1)
	|					И Договор.ДатаОкончанияДействия < &ДатаАктуальности
	|				ТОГДА Договор.Ссылка
	|		КОНЕЦ) КАК ДоговорыПросроченные
	|ИЗ
	|	Справочник.ДоговорыКонтрагентов КАК Договор
	|ГДЕ
	|	Договор.Статус <> ЗНАЧЕНИЕ(Перечисление.СтатусыДоговоровКонтрагентов.Закрыт)
	|	И Договор.Менеджер = &Пользователь
	|	И (НЕ Договор.ПометкаУдаления)
	|";
	
	Результат = ТекущиеДелаСервер.ЧисловыеПоказателиТекущихДел(Запрос, ОбщиеПараметрыЗапросов);
	
	// Заполнение дел.
	// ДоговорыСКонтрагентами
	ДелоРодитель = ТекущиеДела.Добавить();
	ДелоРодитель.Идентификатор  = "ДоговорыСКонтрагентами";
	ДелоРодитель.Представление  = НСтр("ru = 'Договоры с контрагентами'");
	ДелоРодитель.Владелец       = Метаданные.Подсистемы.УправлениеЗапасами;
	
	ИмяФормы = "Справочник.ДоговорыКонтрагентов.Форма.ФормаСписка";
	
	// ДоговорыНаСогласовании
	ПараметрыОтбора = Новый Структура;
	ПараметрыОтбора.Вставить("Состояние"   , Перечисления.СостоянияДоговоровКонтрагентов.ОжидаетсяСогласование);
	ПараметрыОтбора.Вставить("Актуальность", "");
	ПараметрыОтбора.Вставить("ДатаСобытия" , ОбщиеПараметрыЗапросов.ПустаяДата);
	ПараметрыОтбора.Вставить("Менеджер"    , ОбщиеПараметрыЗапросов.Пользователь);
	ПараметрыОтбора.Вставить("Организация" , Неопределено);
	ПараметрыОтбора.Вставить("Контрагент"  , Неопределено);
	
	Дело = ТекущиеДела.Добавить();
	Дело.Идентификатор  = "ДоговорыНаСогласовании";
	Дело.ЕстьДела       = Результат.ДоговорыНаСогласовании > 0;
	Дело.Представление  = НСтр("ru = 'Договоры на согласовании'");
	Дело.Количество     = Результат.ДоговорыНаСогласовании;
	Дело.Важное         = Ложь;
	Дело.Форма          = ИмяФормы;
	Дело.ПараметрыФормы = Новый Структура("СтруктураБыстрогоОтбора", ПараметрыОтбора);
	Дело.Владелец       = "ДоговорыСКонтрагентами";
	
	// ДоговорыСПоставщикамиПросроченные
	ПараметрыОтбора = Новый Структура;
	ПараметрыОтбора.Вставить("Состояние"   , Неопределено);
	ПараметрыОтбора.Вставить("Актуальность", "Просроченные");
	ПараметрыОтбора.Вставить("ДатаСобытия" , ОбщиеПараметрыЗапросов.ПустаяДата);
	ПараметрыОтбора.Вставить("Менеджер"    , ОбщиеПараметрыЗапросов.Пользователь);
	ПараметрыОтбора.Вставить("Организация" , Неопределено);
	ПараметрыОтбора.Вставить("Контрагент"  , Неопределено);
	
	Дело = ТекущиеДела.Добавить();
	Дело.Идентификатор  = "ДоговорыПросроченные";
	Дело.ЕстьДела       = Результат.ДоговорыПросроченные > 0;
	Дело.Представление  = НСтр("ru = 'Просроченные договоры'");
	Дело.Количество     = Результат.ДоговорыПросроченные;
	Дело.Важное         = Истина;
	Дело.Форма          = ИмяФормы;
	Дело.ПараметрыФормы = Новый Структура("СтруктураБыстрогоОтбора", ПараметрыОтбора);
	Дело.Владелец       = "ДоговорыСКонтрагентами";
	
	Если Результат.ДоговорыНаСогласовании > 0
	 Или Результат.ДоговорыПросроченные > 0 Тогда
		ДелоРодитель.ЕстьДела = Истина;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ВерсионированиеОбъектов

// Определяет настройки объекта для подсистемы ВерсионированиеОбъектов.
//
// Параметры:
//  Настройки - Структура - настройки подсистемы.
//
Процедура ПриОпределенииНастроекВерсионированияОбъектов(Настройки) Экспорт
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти // СтандартныеПодсистемы

////////////////////////////////////////////////////////////////////////////////
// ОБНОВЛЕНИЕ ИНФОРМАЦИОННОЙ БАЗЫ
#Область ОбновлениеИнформационнойБазы

Процедура ЗарегистрироватьДанныеКОбработкеДляПереходаНаНовуюВерсию(Параметры) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = "
	|ВЫБРАТЬ
	|	Справочник.Ссылка КАК Ссылка
	|ИЗ
	|	Справочник.ДоговорыКонтрагентов КАК Справочник
	|ГДЕ
	|	Справочник.Владелец <> ЗНАЧЕНИЕ(Справочник.Контрагенты.ДляПереходаНаДоговорыБезВладельца)
	|";
	
	ОбновлениеИнформационнойБазы.ОтметитьКОбработке(Параметры, Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Ссылка"));
	
КонецПроцедуры

Процедура ОбработатьДанныеДляПереходаНаНовуюВерсию(Параметры) Экспорт
	
	МетаданныеОбъекта = ПустаяСсылка().Метаданные();
	ПолноеИмяОбъекта = МетаданныеОбъекта.ПолноеИмя();
	
	Выборка = ОбновлениеИнформационнойБазы.ВыбратьСсылкиДляОбработки(Параметры.Очередь, ПолноеИмяОбъекта);
	
	Пока Выборка.Следующий() Цикл
		
		НачатьТранзакцию();
		Попытка
			
			ОбщегоНазначенияБольничнаяАптека.ЗаблокироватьСсылку(Выборка.Ссылка);
			
			Объект = Выборка.Ссылка.ПолучитьОбъект();
			
			Если Объект = Неопределено Или Объект.Владелец = Справочники.Контрагенты.ДляПереходаНаДоговорыБезВладельца Тогда
				ОбновлениеИнформационнойБазы.ОтметитьВыполнениеОбработки(Выборка.Ссылка);
				ЗафиксироватьТранзакцию();
				Продолжить;
			КонецЕсли;
			
			Если Не Объект.ЭтоГруппа И Объект.Контрагент <> Объект.Владелец Тогда
				Объект.Контрагент = Объект.Владелец;
			КонецЕсли;
			Объект.Владелец = Справочники.Контрагенты.ДляПереходаНаДоговорыБезВладельца;
			
			ОбновлениеИнформационнойБазы.ЗаписатьДанные(Объект);
			ЗафиксироватьТранзакцию();
			
		Исключение
			
			ОтменитьТранзакцию();
			ТекстСообщения = НСтр("ru = 'Не удалось обработать: %Объект% по причине: %Причина%'", ОбщегоНазначения.КодОсновногоЯзыка());
			ТекстСообщения = СтрЗаменить(ТекстСообщения, "%Объект%", Выборка.Ссылка);
			ТекстСообщения = СтрЗаменить(ТекстСообщения, "%Причина%", ОбработкаОшибок.ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
			ЗаписьЖурналаРегистрации(
				ОбновлениеИнформационнойБазы.СобытиеЖурналаРегистрации(),
				УровеньЖурналаРегистрации.Предупреждение,
				МетаданныеОбъекта,
				Выборка.Ссылка,
				ТекстСообщения);
				
		КонецПопытки;
		
	КонецЦикла;
	
	Параметры.ОбработкаЗавершена = ОбновлениеИнформационнойБазы.ОбработкаДанныхЗавершена(Параметры.Очередь, ПолноеИмяОбъекта);
	
КонецПроцедуры

#КонецОбласти // ОбновлениеИнформационнойБазы

#КонецЕсли