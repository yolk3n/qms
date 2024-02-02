﻿
////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ
#Область ОбработчикиСобытий

Процедура ОбработкаПолученияФормы(ВидФормы, Параметры, ВыбраннаяФорма, ДополнительнаяИнформация, СтандартнаяОбработка)
	
	Если Параметры.Свойство("Отбор") Тогда
		
		ТипСклада = Неопределено;
		Параметры.Отбор.Свойство("ТипСклада", ТипСклада);
		ИмяОбъекта = ПустаяСсылка().Метаданные().ПолноеИмя();
		
		ДоступныеЭлементы = УправлениеДоступомБольничнаяАптекаВызовСервера.ПолучитьДоступныеЭлементыДляОтбора(ИмяОбъекта, Параметры, ТипСклада);
		Если ДоступныеЭлементы <> Неопределено Тогда
			Параметры.Отбор.Вставить("Ссылка", ДоступныеЭлементы);
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаПолученияДанныхВыбора(ДанныеВыбора, Параметры, СтандартнаяОбработка)
	
	ТипСклада = Неопределено;
	Параметры.Отбор.Свойство("ТипСклада", ТипСклада);
	ИмяОбъекта = ПустаяСсылка().Метаданные().ПолноеИмя();
	
	ДоступныеЭлементы = УправлениеДоступомБольничнаяАптекаВызовСервера.ПолучитьДоступныеЭлементыДляОтбора(ИмяОбъекта, Параметры, ТипСклада);
	Если ДоступныеЭлементы <> Неопределено Тогда
		Параметры.Отбор.Вставить("Ссылка", ДоступныеЭлементы);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти // ОбработчикиСобытий

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

////////////////////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС
#Область ПрограммныйИнтерфейс

// Функция получает склад по умолчанию
//
Функция ПолучитьСкладПоУмолчанию(ТипСклада, ТаблицаОбъекта = Неопределено) Экспорт
	
	ДоступныеСклады = ПолучитьДоступные(ТипСклада, ТаблицаОбъекта);
	Если ДоступныеСклады.Количество() = 1 Тогда
		Возврат ДоступныеСклады[0];
	КонецЕсли;
	
	Возврат Справочники.Склады.ПустаяСсылка();
	
КонецФункции

// Возвращает доступные склады по типу
//
Функция ПолучитьДоступные(ТипыСкладов = Неопределено, ТаблицаОбъекта = Неопределено) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	Запрос.Текст = "
	|ВЫБРАТЬ
	|	Склад.Ссылка КАК Склад
	|ИЗ
	|	ЗначенияДоступа КАК ЗначенияДоступа
	|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.Склады КАК Склад
	|	ПО
	|		ЗначенияДоступа.Ссылка = Склад.Ссылка
	|ГДЕ
	|	НЕ Склад.ПометкаУдаления
	|";
	
	УправлениеДоступомБольничнаяАптека.ЗначенияДоступаРазрешающиеИзменениеОбъекта(ТаблицаОбъекта, Тип("СправочникСсылка.Склады"), Запрос.МенеджерВременныхТаблиц);
	
	Если ТипыСкладов <> Неопределено Тогда
		Запрос.Текст = Запрос.Текст + "
			|	И Склад.ТипСклада В (&ТипыСкладов)";
		Запрос.УстановитьПараметр("ТипыСкладов", ТипыСкладов);
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	Возврат Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Склад");
	
КонецФункции

// Функция возвращает учетный вид цен склада
//
//	Параметры:
//		Склад - СправочникСсылка.Склады - склад, для которого определяется учетный вид цены.
//	Возвращаемое значение:
//		СправочникСсылка.ВидыЦен
//
Функция УчетныйВидЦены(Склад) Экспорт
	Перем ВидЦены;
	
	Если ЗначениеЗаполнено(Склад) Тогда
		
		Запрос = Новый Запрос;
		Запрос.Текст = "
		|ВЫБРАТЬ
		|	Склады.УчетныйВидЦены
		|ИЗ
		|	Справочник.Склады КАК Склады
		|ГДЕ
		|	Склады.Ссылка = &Склад
		|";
		Запрос.УстановитьПараметр("Склад", Склад);
		
		Выборка = Запрос.Выполнить().Выбрать();
		Если Выборка.Следующий() Тогда
			ВидЦены = Выборка.УчетныйВидЦены;
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат Справочники.ВидыЦен.ВидЦеныПоУмолчанию(ВидЦены);
	
КонецФункции

#КонецОбласти // ПрограммныйИнтерфейс

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ
#Область СлужебныеПроцедурыИФункции

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
	
	БлокируемыеРеквизиты.Добавить("Родитель");
	БлокируемыеРеквизиты.Добавить("ТипСклада");
	БлокируемыеРеквизиты.Добавить("ИспользоватьМестаХранения");
	
	БлокируемыеРеквизиты.Добавить("РозничныйВидЦены");
	БлокируемыеРеквизиты.Добавить("ЛьготныйВидЦены");
	БлокируемыеРеквизиты.Добавить("ИсточникФинансирования");
	
	Возврат БлокируемыеРеквизиты;
	
КонецФункции

// СтандартныеПодсистемы.ВерсионированиеОбъектов

// Определяет настройки объекта для подсистемы ВерсионированиеОбъектов.
//
// Параметры:
//  Настройки - Структура - настройки подсистемы.
//
Процедура ПриОпределенииНастроекВерсионированияОбъектов(Настройки) Экспорт
	
КонецПроцедуры

// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов

#КонецОбласти // СтандартныеПодсистемы

////////////////////////////////////////////////////////////////////////////////
// ОБНОВЛЕНИЕ ИНФОРМАЦИОННОЙ БАЗЫ
#Область ОбновлениеИнформационнойБазы

// Обработчик обновления информационной базы, предназначенный для первоначального заполнения
// и обновления значения реквизитов, предопределенных видов КИ.
//
Процедура ОбновитьПредопределенныеВидыКонтактнойИнформации() Экспорт
	
	ПараметрыВида = УправлениеКонтактнойИнформацией.ПараметрыВидаКонтактнойИнформации("Адрес");
	ПараметрыВида.Вид = Справочники.ВидыКонтактнойИнформации.АдресСклада;
	ПараметрыВида.МожноИзменятьСпособРедактирования = Истина;
	ПараметрыВида.Порядок = 1;
	УправлениеКонтактнойИнформацией.УстановитьСвойстваВидаКонтактнойИнформации(ПараметрыВида);
	
	ПараметрыВида = УправлениеКонтактнойИнформацией.ПараметрыВидаКонтактнойИнформации("Телефон");
	ПараметрыВида.Вид = Справочники.ВидыКонтактнойИнформации.ТелефонСклада;
	ПараметрыВида.МожноИзменятьСпособРедактирования = Истина;
	ПараметрыВида.РазрешитьВводНесколькихЗначений = Истина;
	ПараметрыВида.Порядок = 2;
	УправлениеКонтактнойИнформацией.УстановитьСвойстваВидаКонтактнойИнформации(ПараметрыВида);
	
КонецПроцедуры

#КонецОбласти // ОбновлениеИнформационнойБазы

#КонецЕсли