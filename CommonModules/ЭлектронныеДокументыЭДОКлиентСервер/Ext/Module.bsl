﻿//@strict-types

#Область СлужебныйПрограммныйИнтерфейс

#Область ОбработкаДействийПоЭДО

// Добавляет действие в набор.
// 
// Параметры:
//  НаборДействий - См. НовыйНаборДействийПоЭДО
//  Действие      - ПеречислениеСсылка.ДействияПоЭДО
//
Процедура ДобавитьДействие(НаборДействий, Действие) Экспорт
	НаборДействий.Вставить(Действие, Истина);
КонецПроцедуры

// Возвращает признак наличия действия в наборе.
// 
// Параметры:
//  НаборДействий - См. НовыйНаборДействийПоЭДО
//  Действие      - ПеречислениеСсылка.ДействияПоЭДО
// Возвращаемое значение:
//  Булево - признак наличия действия в наборе.
//
Функция ЕстьДействие(НаборДействий, Действие) Экспорт
	Возврат НаборДействий[Действие] = Истина;
КонецФункции

// Возвращает пустую коллекцию дополнительных параметров действия по ЭДО.
// 
// Возвращаемое значение:
//  Структура:
//  * Комментарий - Строка
//  * Ответственный - Неопределено,ОпределяемыйТип.Пользователь
//
Функция НовыеДополнительныеПараметрыДействия() Экспорт
	Параметры = Новый Структура;
	Параметры.Вставить("Комментарий", "");
	Параметры.Вставить("Ответственный", Неопределено);
	Возврат Параметры;
КонецФункции

// Возвращает пустую коллекцию итогов выполнения действий по ЭДО.
// 
// Возвращаемое значение:
//  Структура:
//  * ОбработанныеДокументы - Соответствие из КлючИЗначение:
//    ** Ключ     - ДокументСсылка.ЭлектронныйДокументВходящийЭДО,
//                  ДокументСсылка.ЭлектронныйДокументИсходящийЭДО
//    ** Значение - Булево
//  * ОбработаноПоДействиям - Соответствие из КлючИЗначение:
//    ** Ключ     - ПеречислениеСсылка.ДействияПоЭДО
//    ** Значение - Число
//
Функция НовыйИтогВыполненияДействийПоЭДО() Экспорт
	Итог = Новый Структура;
	Итог.Вставить("ОбработаноПоДействиям", Новый Соответствие);
	Итог.Вставить("ОбработанныеДокументы", Новый Соответствие);
	Возврат Итог;
КонецФункции

// Возвращает пустую коллекцию типов объектов для обработки по действиям ЭДО.
// 
// Возвращаемое значение:
// 	Структура:
// * ОбъектыУчета              - Массив из ОпределяемыйТип.ОснованияЭлектронныхДокументовЭДО
// * ЭлектронныеДокументы      - Массив из ДокументСсылка.ЭлектронныйДокументВходящийЭДО,
//                                         ДокументСсылка.ЭлектронныйДокументИсходящийЭДО
// * Сообщения                 - Массив из ДокументСсылка.СообщениеЭДО
// * ПакетыДокументов          - Массив из УникальныйИдентификатор
// * ИдентификаторыОрганизаций - Массив из Строка
// * МЧД					   - Массив из СправочникСсылка.МашиночитаемыеДоверенностиОрганизаций
//
Функция НовыеОбъектыДействийПоЭДО() Экспорт
	ОбъектыДействий = Новый Структура;
	ОбъектыДействий.Вставить("ОбъектыУчета", Новый Массив);
	ОбъектыДействий.Вставить("ЭлектронныеДокументы", Новый Массив);
	ОбъектыДействий.Вставить("Сообщения", Новый Массив);
	ОбъектыДействий.Вставить("ПакетыДокументов", Новый Массив);
	ОбъектыДействий.Вставить("ИдентификаторыОрганизаций", Новый Массив);
	ОбъектыДействий.Вставить("МЧД", Новый Массив);
	Возврат ОбъектыДействий;
КонецФункции

// Возвращает пустые параметры для выполнения действий по ЭДО.
// 
// Возвращаемое значение:
//  Структура - Описание:
//  * НаборДействий - См. НовыйНаборДействийПоЭДО
//  * ОбъектыДействий - См. НовыеОбъектыДействийПоЭДО
//  * ДополнительныеПараметрыДействий - Соответствие из КлючИЗначение:
//    ** Ключ - ОпределяемыйТип.ОснованияЭлектронныхДокументовЭДО
//    ** Значение - См. НовыеДополнительныеПараметрыДействия
//  * КлючиНастроекОбъектов - Соответствие из КлючИЗначение:
//    ** Ключ - ОпределяемыйТип.ОснованияЭлектронныхДокументовЭДО
//    ** Значение - Структура - См. НастройкиБЭД.КлючОбъектаНастроекВнутреннегоЭДО
//  * НастройкиОбъектов - Соответствие из КлючИЗначение:
//    ** Ключ - ОпределяемыйТип.ОснованияЭлектронныхДокументовЭДО
//    ** Значение - Структура -  См. НастройкиБЭД.НастройкиОтправки
//  * МаршрутыПодписанияОбъектов - Соответствие из КлючИЗначение:
//    ** Ключ - ОпределяемыйТип.ОснованияЭлектронныхДокументовЭДО
//    ** Значение - СправочникСсылка.МаршрутыПодписания
//  * ДополнительныеДанныеОбъектов - Соответствие из КлючИЗначение:
//    ** Ключ - ОпределяемыйТип.ОснованияЭлектронныхДокументовЭДО
//    ** Значение - Структура
//  * ПодписантыОбъектов - Соответствие из КлючИЗначение:
//    ** Ключ - ОпределяемыйТип.ОснованияЭлектронныхДокументовЭДО
//    ** Значение - Массив из ОпределяемыйТип.Пользователь
//  * ОтпечаткиСертификатов - Неопределено - если получение отпечатков не выполнялось.
//                          - См. КриптографияБЭДКлиентСервер.НовыеРезультатыПолученияОтпечатков
//  * ВыбранныеСертификаты - Массив из СправочникСсылка.СертификатыКлючейЭлектроннойПодписиИШифрования
//  * ИдентификаторыПечатныхФормОбъектов - Соответствие из КлючИЗначение:
//    ** Ключ - ОпределяемыйТип.ОснованияЭлектронныхДокументовЭДО
//    ** Значение - Строка
//  * ДополнительныеФайлы - Соответствие из КлючИЗначение:
//    ** Ключ - ОпределяемыйТип.ОснованияЭлектронныхДокументовЭДО
//    ** Значение - Строка - ДвоичныеДанные
//
Функция НовыеПараметрыВыполненияДействийПоЭДО() Экспорт
	
	ВыбранныеСертификаты = Новый Массив; // Массив из СправочникСсылка.СертификатыКлючейЭлектроннойПодписиИШифрования
	
	ПараметрыВыполнения = Новый Структура;
	ПараметрыВыполнения.Вставить("НаборДействий", НовыйНаборДействийПоЭДО());
	ПараметрыВыполнения.Вставить("ОбъектыДействий", НовыеОбъектыДействийПоЭДО());
	ПараметрыВыполнения.Вставить("ДополнительныеПараметрыДействий", Новый Соответствие);
	ПараметрыВыполнения.Вставить("КлючиНастроекОбъектов", Новый Соответствие);
	ПараметрыВыполнения.Вставить("НастройкиОбъектов", Новый Соответствие);
	ПараметрыВыполнения.Вставить("МаршрутыПодписанияОбъектов", Новый Соответствие);
	ПараметрыВыполнения.Вставить("ПодписантыОбъектов", Новый Соответствие);
	ПараметрыВыполнения.Вставить("ДополнительныеДанныеОбъектов", Новый Соответствие);
	ПараметрыВыполнения.Вставить("ОтпечаткиСертификатов", Неопределено);
	ПараметрыВыполнения.Вставить("ВыбранныеСертификаты", ВыбранныеСертификаты);
	ПараметрыВыполнения.Вставить("ИдентификаторыПечатныхФормОбъектов", Новый Соответствие);
	ПараметрыВыполнения.Вставить("ДополнительныеФайлы", Новый Соответствие);
	
	Возврат ПараметрыВыполнения;
	
КонецФункции

#КонецОбласти

#Область ДополнительныеПоля

// Возвращает поддерживаемые типы разделов дополнительных полей документов.
//
// Возвращаемое значение:
//  Структура:
//   * Шапка   - Строка
//   * Таблица - Строка
//
Функция ТипыРазделовДополнительныхПолей() Экспорт

	ТипыРазделов = Новый Структура;
	ТипыРазделов.Вставить("Шапка", "Шапка");
	ТипыРазделов.Вставить("Таблица", "Таблица");
	
	Возврат ТипыРазделов;
	
КонецФункции

#КонецОбласти

#Область СозданиеДокументаПоФайлу

// Возвращает пустые параметры создания документа по файлу.
// 
// Возвращаемое значение:
//  Структура - Новые параметры создания произвольного документа:
//  * Организация - Неопределено,ОпределяемыйТип.Организация - организация, от имени которой нужно отправить документ.
//  * Контрагент - Неопределено,ОпределяемыйТип.КонтрагентБЭД - контрагент, которому нужно отправить документ.
//  * Договор - Неопределено,ОпределяемыйТип.ДоговорСКонтрагентомЭДО - договор, по которому отправляется документ.
//  * ВидДокумента - СправочникСсылка.ВидыДокументовЭДО - вид электронного документа. Если не указан, то определяется автоматически.
//  * НомерДокумента - Строка - номер электронного документа.
//  * ДатаДокумента - Дата - дата электронного документа
//  * СуммаДокумента - Число - сумма по документу.
//  * ОбъектыУчета - Массив Из ОпределяемыйТип.ОснованияЭлектронныхДокументовЭДО - учетные объекты, которые нужно проставить в качестве основания.
//  * Подписанты - Массив из ОпределяемыйТип.Пользователь - подписанты электронного документа. Если не указаны, то заполняются из настроек. Если указаны, то устанавливается маршрут подписания См. МаршрутыПодписанияБЭД.МаршрутУказыватьПриСоздании.
//
Функция НовыеПараметрыСозданияДокументаПоФайлу() Экспорт
	Параметры = Новый Структура;
	Параметры.Вставить("Организация", Неопределено);
	Параметры.Вставить("Контрагент", Неопределено);
	Параметры.Вставить("Договор", Неопределено);
	Параметры.Вставить("ВидДокумента", ПредопределенноеЗначение("Справочник.ВидыДокументовЭДО.ПустаяСсылка"));
	Параметры.Вставить("НомерДокумента", "");
	Параметры.Вставить("ДатаДокумента", Дата(1,1,1));
	Параметры.Вставить("СуммаДокумента", 0);
	Параметры.Вставить("ОбъектыУчета", Новый Массив);
	Параметры.Вставить("Подписанты", Новый Массив);
	Возврат Параметры;
КонецФункции

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ОбработкаДействийПоЭДО

// Возвращает пустой набор действий по ЭДО.
// 
// Возвращаемое значение:
//  Соответствие из КлючИЗначение:
//  * Ключ - ПеречислениеСсылка.ДействияПоЭДО
//  * Значение - Булево
//
Функция НовыйНаборДействийПоЭДО()
	Возврат Новый Соответствие;
КонецФункции

#КонецОбласти

#Область ПредставлениеДокумента

// Заполняет имена полей для формирования представления электронного документа
// 
// Параметры:
//  Поля - Массив из Строка
//  СтандартнаяОбработка - Булево
//
Процедура ОбработкаПолученияПолейПредставленияДокумента(Поля, СтандартнаяОбработка) Экспорт
	СтандартнаяОбработка = Ложь;
	Поля.Добавить("ВидДокумента");
	Поля.Добавить("НомерДокумента");
	Поля.Добавить("ДатаДокумента");
КонецПроцедуры

// Заполняет представление электронного документа.
// 
// Параметры:
//  Данные - Структура
//  Представление - Строка
//  СтандартнаяОбработка - Булево
//
Процедура ОбработкаПолученияПредставленияДокумента(Данные, Представление, СтандартнаяОбработка) Экспорт
	СтандартнаяОбработка = Ложь;
	Представление = ПредставлениеДокументаПоСвойствам(Данные);
КонецПроцедуры

// Возвращает представление электронного документа по его свойствам.
// 
// Параметры:
//  СвойстваДокумента - Структура:
//  * ВидДокумента   - СправочникСсылка.ВидыДокументовЭДО
//  * НомерДокумента - Строка
//  * ДатаДокумента  - Дата
//  ЭтоНовый - Булево
// Возвращаемое значение:
//  Строка - представление электронного документа.
//
Функция ПредставлениеДокументаПоСвойствам(СвойстваДокумента, ЭтоНовый = Ложь) Экспорт
	
	Если ЗначениеЗаполнено(СвойстваДокумента.НомерДокумента) И ЗначениеЗаполнено(СвойстваДокумента.ДатаДокумента) Тогда
		Представление = СтрШаблон(НСтр("ru = '%1 № %2 от %3'"), СвойстваДокумента.ВидДокумента,
			СвойстваДокумента.НомерДокумента, Формат(СвойстваДокумента.ДатаДокумента, "ДЛФ=D;"));
	ИначеЕсли ЗначениеЗаполнено(СвойстваДокумента.НомерДокумента) Тогда
		Представление = СтрШаблон(НСтр("ru = '%1 № %2'"), СвойстваДокумента.ВидДокумента,
			СвойстваДокумента.НомерДокумента);
	ИначеЕсли ЗначениеЗаполнено(СвойстваДокумента.ДатаДокумента) Тогда
		Представление = СтрШаблон(НСтр("ru = '%1 от %2'"), СвойстваДокумента.ВидДокумента,
			Формат(СвойстваДокумента.ДатаДокумента, "ДЛФ=D;"));
	Иначе
		Представление = Строка(СвойстваДокумента.ВидДокумента);
	КонецЕсли;
	
	Если ЭтоНовый Тогда
		Представление = СтрШаблон(НСтр("ru = '%1 (Создание)'"), Представление);
	КонецЕсли;
	
	Возврат Представление;
	
КонецФункции

#КонецОбласти

#КонецОбласти
