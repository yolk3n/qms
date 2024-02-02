﻿
#Область ПрограммныйИнтерфейс

// Позволяет переопределить описания операций, подключаемых к механизму контроля КМ
// (см. функцию КонтрольКодовМаркировкиМДЛП.ДопустимыеОперацииКонтроляКМ).
//
// Параметры:
//  ДопустимыеОперации - Соответствие - описание операций, подключенных к механизму контроля КМ.
//   * Ключ - Строка - полное имя метаданных объекта, подключаемого к механизму контроля КМ.
//            Расчитывается из типа определяемого типа ДокументКонтроляКМСредствамиККТМДЛП или ДокументКонтроляКМСредствамиРВМДЛП.
//   * Значение - Структура - описание операции, подключенной к механизму контроля КМ.
//      ** Представление - Строка - представление операции.
//                         Расчитывается из типа определяемого типа ДокументКонтроляКМСредствамиККТМДЛП или ДокументКонтроляКМСредствамиРВМДЛП.
//      ** ОграничитьОтключение - Булево - признак, по которому определяется возможность отключения пользователем операции от механизма контроля КМ
//                                (см. форму Обработки.ПанельМаркировкиМДЛП.Форма.НастройкиИсключенийКонтроляКодовМаркировки)
//  КлючГруппыНастроекКонтроляКМ - ключ настроек проверки КМ (см. КонтрольКодовМаркировкиМДЛПКлиентСервер.ГруппыНастроекКонтроляКМ).
//
Процедура ДопустимыеОперацииКонтроляКМ(ДопустимыеОперации, КлючГруппыНастроекКонтроляКМ) Экспорт
	
	
	
КонецПроцедуры

// Позволяет переопределить запись результатов проверки КМ.
// (см. процедуру КонтрольКодовМаркировкиМДЛП.ЗаписатьРезультатыПроверкиКМ).
//
// Параметры:
//  Параметры - Структура - см. КонтрольКодовМаркировкиМДЛП.ПараметрыЗаписиРезультатовПроверкиКМ.
//  СтандартнаяОбработка - Булево - признак использования стандартного поведения.
//
Процедура ЗаписатьРезультатыПроверкиКМ(Параметры, СтандартнаяОбработка) Экспорт
	
	
	
КонецПроцедуры

// Позволяет переопределить получение записанных результатов проверки КМ.
// (см. процедуру КонтрольКодовМаркировкиМДЛП.ПолучитьРезультатыПроверкиКМ).
//
// Параметры:
//  Параметры - Структура - см. КонтрольКодовМаркировкиМДЛП.ПараметрыПолученияРезультатовПроверкиКМ.
//  СтандартныйРезультат - ТаблицаЗначений - таблица результата проверки КМ.
//
Процедура ПолучитьРезультатыПроверкиКМ(Параметры, СтандартныйРезультат) Экспорт
	
	
	
КонецПроцедуры

// Позволяет переопределить удаление записанных результатов проверки КМ.
// (см. процедуру КонтрольКодовМаркировкиМДЛП.УдалитьРезультатыПроверкиКМ).
//
// Параметры:
//  Параметры - Структура - см. КонтрольКодовМаркировкиМДЛП.ПараметрыУдаленияРезультатовПроверкиКМ.
//  СтандартнаяОбработка - Булево - признак использования стандартного поведения.
//
Процедура УдалитьРезультатыПроверкиКМ(Параметры, СтандартнаяОбработка) Экспорт
	
	
	
КонецПроцедуры

#Область ОбработчикиСобытийФормы

// Позволяет переопределить обработчик события формы объекта, подключенной к механизму проверки КМ
// (см. процедуру КонтрольКодовМаркировкиМДЛП.ПриЧтенииНаСервере).
//
Процедура ПриЧтенииНаСервере(Форма, ТекущийОбъект, СтандартнаяОбработка) Экспорт
	
	// БольничнаяАптека
	Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(Форма, "Объект")
	   И ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(Форма.Объект, "Ссылка") Тогда
		
		ТипДокумента = ТипЗнч(Форма.Объект.Ссылка);
		Если ТипДокумента = Тип("ДокументСсылка.ЧекККМ") Тогда
			
			СтандартнаяОбработка = Ложь;
			
			ПодключитьМеханизмПроверкиКМНаФормеСредствамиККТ(Форма);
			ПолучитьРезультатыПроверкиКМНаФормеСредствамиККТ(Форма);
			
		КонецЕсли;
		
	КонецЕсли;
	// Конец БольничнаяАптека
	
КонецПроцедуры

// Позволяет переопределить обработчик события формы объекта, подключенной к механизму проверки КМ
// (см. процедуру КонтрольКодовМаркировкиМДЛП.ПриСозданииНаСервере).
//
Процедура ПриСозданииНаСервере(Форма, Отказ, СтандартнаяОбработка) Экспорт
	
	// БольничнаяАптека
	Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(Форма, "Объект")
	   И ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(Форма.Объект, "Ссылка") Тогда
		
		ТипДокумента = ТипЗнч(Форма.Объект.Ссылка);
		Если ТипДокумента = Тип("ДокументСсылка.ЧекККМ") Тогда
			
			СтандартнаяОбработка = Ложь;
			
			ПодключитьМеханизмПроверкиКМНаФормеСредствамиККТ(Форма);
			
		КонецЕсли;
		
	КонецЕсли;
	// Конец БольничнаяАптека
	
КонецПроцедуры

// Позволяет переопределить обработчик события формы объекта, подключенной к механизму проверки КМ
// (см. процедуру КонтрольКодовМаркировкиМДЛП.ПриЗаписиНаСервере).
//
Процедура ПриЗаписиНаСервере(Форма, Отказ, ТекущийОбъект, ПараметрыЗаписи, СтандартнаяОбработка) Экспорт
	
	// БольничнаяАптека
	Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(Форма, "Объект")
	   И ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(Форма.Объект, "Ссылка") Тогда
		
		ТипДокумента = ТипЗнч(Форма.Объект.Ссылка);
		Если ТипДокумента = Тип("ДокументСсылка.ЧекККМ") Тогда
			
			СтандартнаяОбработка = Ложь;
			
			ЗаписатьРезультатыПроверкиКМНаФормеСредствамиККТ(Форма, ТекущийОбъект.Ссылка);
			
		КонецЕсли;
		
	КонецЕсли;
	// Конец БольничнаяАптека
	
КонецПроцедуры

// Позволяет переопределить обработчик события формы объекта, подключенной к механизму проверки КМ
// (см. процедуру КонтрольКодовМаркировкиМДЛП.ПослеЗаписиНаСервере).
//
Процедура ПослеЗаписиНаСервере(Форма, ТекущийОбъект, ПараметрыЗаписи, СтандартнаяОбработка) Экспорт
	
	// БольничнаяАптека
	Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(Форма, "Объект")
	   И ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(Форма.Объект, "Ссылка") Тогда
		
		ТипДокумента = ТипЗнч(Форма.Объект.Ссылка);
		Если ТипДокумента = Тип("ДокументСсылка.ЧекККМ") Тогда
			
			СтандартнаяОбработка = Ложь;
			
			ПолучитьРезультатыПроверкиКМНаФормеСредствамиККТ(Форма);
			
		КонецЕсли;
		
	КонецЕсли;
	// Конец БольничнаяАптека
	
КонецПроцедуры

#КонецОбласти

#Область КонтрольКМСредствамиАПИМДЛП

// Позволяет переопределить признак необходимости подключения механизма контроля КМ к форме объекта
// (см. функцию КонтрольКодовМаркировкиСредствамиАПИМДЛП.ПроверитьВозможностьПодключенияПроверкиКМ).
//
// Параметры:
//  ДокументСсылка - Ссылка - ссылка на объект.
//  СтандартнаяОбработка - Булево - признак использования стандартного поведения.
//
// Возвращаемое значение:
//  Булево - признак необходимости подключения механизма контроля КМ к форме объекта.
//  Если не возвращать, то будет отработан стандартный механизм.
//
Функция ВключенКонтрольКМСредствамиАПИМДЛПДляДокумента(ДокументСсылка, СтандартнаяОбработка) Экспорт
	
	
	
КонецФункции

// Позволяет переопределить признак необходимости использования механизма контроля КМ на форме объекта
// (см. функцию КонтрольКодовМаркировкиСредствамиАПИМДЛП.ПроверитьВозможностьПодключенияПроверкиКМ).
// Механизм контроля КМ может быть подключен но не использоваться, например, в случае, если ранее была выполнена проверка КМ,
// а сейчас, с теми же параметрами проверка КМ запрещена, и нужно только отобразить результаты проверки, на саму проверку выполнять нельзя.
//
// Параметры:
//  СтандартнаяОбработка - Булево - признак использования стандартного поведения.
//
// Возвращаемое значение:
//  Булево - признак необходимости использования механизма контроля КМ на форме объекта.
//  Если не возвращать, то будет отработан стандартный механизм.
//
Функция РазрешеноИспользованиеНастройкиКонтроляКМСредствамиАПИМДЛП(СтандартнаяОбработка) Экспорт
	
	
	
КонецФункции

#КонецОбласти

#Область КонтрольКМСредствамиРВ

// Позволяет переопределить признак необходимости подключения механизма контроля КМ к форме объекта
// (см. функцию КонтрольКодовМаркировкиСредствамиРВМДЛП.ПроверитьВозможностьПодключенияПроверкиКМ).
//
// Параметры:
//  ДокументСсылка - Ссылка - ссылка на объект.
//  СтандартнаяОбработка - Булево - признак использования стандартного поведения.
//
// Возвращаемое значение:
//  Булево - признак необходимости подключения механизма контроля КМ к форме объекта.
//  Если не возвращать, то будет отработан стандартный механизм.
//
Функция ВключенКонтрольКМСредствамиРВДляДокумента(ДокументСсылка, СтандартнаяОбработка) Экспорт
	
	
	
КонецФункции

// Позволяет переопределить признак необходимости использования механизма контроля КМ на форме объекта
// (см. функцию КонтрольКодовМаркировкиСредствамиРВМДЛП.ПроверитьВозможностьПодключенияПроверкиКМ).
// Механизм контроля КМ может быть подключен но не использоваться, например, в случае, если ранее была выполнена проверка КМ,
// а сейчас, с теми же параметрами проверка КМ запрещена, и нужно только отобразить результаты проверки, на саму проверку выполнять нельзя.
//
// Параметры:
//  СтандартнаяОбработка - Булево - признак использования стандартного поведения.
//
// Возвращаемое значение:
//  Булево - признак необходимости использования механизма контроля КМ на форме объекта.
//  Если не возвращать, то будет отработан стандартный механизм.
//
Функция РазрешеноИспользованиеНастройкиКонтроляКМСредствамиРВ(СтандартнаяОбработка) Экспорт
	
	
	
КонецФункции

#КонецОбласти

#Область КонтрольКМСредствамиККТ

// Позволяет переопределить признак необходимости подключения механизма контроля КМ к форме объекта.
// (см. функцию КонтрольКодовМаркировкиСредствамиККТМДЛП.ПроверитьВозможностьПодключенияПроверкиКМ).
//
// Параметры:
//  ДокументСсылка - Ссылка - ссылка на объект.
//  СтандартнаяОбработка - Булево - признак использования стандартного поведения.
//
// Возвращаемое значение:
//  Булево - признак необходимости подключения механизма контроля КМ к форме объекта.
//  Если не возвращать, то будет отработан стандартный механизм.
//
Функция ВключенКонтрольКМСредствамиККТДляДокумента(ДокументСсылка, СтандартнаяОбработка) Экспорт
	
	
	
КонецФункции

// Позволяет переопределить признак необходимости использования механизма контроля КМ на форме объекта
// (см. функцию КонтрольКодовМаркировкиСредствамиРВМДЛП.ПроверитьВозможностьПодключенияПроверкиКМ).
// Механизм контроля КМ может быть подключен но не использоваться, например, в случае, если ранее была выполнена проверка КМ,
// а сейчас, с теми же параметрами проверка КМ запрещена, и нужно только отобразить результаты проверки, на саму проверку выполнять нельзя.
//
// Параметры:
//  СтандартнаяОбработка - Булево - признак использования стандартного поведения.
//
// Возвращаемое значение:
//  Булево - признак необходимости использования механизма контроля КМ на форме объекта.
//  Если не возвращать, то будет отработан стандартный механизм.
//
Функция РазрешеноИспользованиеНастройкиКонтроляКМСредствамиККТ(СтандартнаяОбработка) Экспорт
	
	
	
КонецФункции

#КонецОбласти

#КонецОбласти

#Область УстаревшиеПроцедурыИФункции

#Область КонтрольКМСредствамиРВУстаревшие

// Позволяет переопределить запись результатов проверки КМ средствами РВ из формы объекта
// (см. процедуру КонтрольКодовМаркировкиСредствамиРВМДЛП.ЗаписатьРезультатыПроверкиКМ).
//
// Параметры:
//  Параметры - Структура - см. КонтрольКодовМаркировкиСредствамиРВМДЛП.ПараметрыЗаписиРезультатовПроверкиКМ.
//  СтандартнаяОбработка - Булево - признак использования стандартного поведения.
//
Процедура ЗаписатьРезультатыПроверкиКМСредствамиРВ(Параметры, СтандартнаяОбработка) Экспорт
	
	
	
КонецПроцедуры

// Позволяет переопределить получение записанных результатов проверки КМ средствами РВ для формы объекта.
// (см. процедуру КонтрольКодовМаркировкиСредствамиРВМДЛП.ПолучитьРезультатыПроверкиКМ).
//
// Параметры:
//  Параметры - Структура - см. КонтрольКодовМаркировкиСредствамиРВМДЛП.ПараметрыПолученияРезультатовПроверкиКМ.
//  СтандартныйРезультат - ТаблицаЗначений - таблица результата проверки КМ.
//
Процедура ПолучитьРезультатыПроверкиКМСредствамиРВ(Параметры, СтандартныйРезультат) Экспорт
	
	
	
КонецПроцедуры

// Позволяет переопределить удаление записанных результатов проверки КМ средствами РВ для формы объекта.
// (см. процедуру КонтрольКодовМаркировкиСредствамиРВМДЛП.УдалитьРезультатыПроверкиКМ).
//
// Параметры:
//  Параметры - Структура - см. КонтрольКодовМаркировкиСредствамиРВМДЛП.ПараметрыУдаленияРезультатовПроверкиКМ.
//  СтандартнаяОбработка - Булево - признак использования стандартного поведения.
//
Процедура УдалитьРезультатыПроверкиКМСредствамиРВ(Параметры, СтандартнаяОбработка) Экспорт
	
	
	
КонецПроцедуры

#КонецОбласти

#Область КонтрольКМСредствамиККТУстаревшие

// Позволяет переопределить запись результатов проверки КМ средствами ККТ из формы объекта
// (см. процедуру КонтрольКодовМаркировкиСредствамиККТМДЛП.ЗаписатьРезультатыПроверкиКМ).
//
// Параметры:
//  Параметры - Структура - см. КонтрольКодовМаркировкиСредствамиККТМДЛП.ПараметрыЗаписиРезультатовПроверкиКМ.
//  СтандартнаяОбработка - Булево - признак использования стандартного поведения.
//
Процедура ЗаписатьРезультатыПроверкиКМСредствамиККТ(Параметры, СтандартнаяОбработка) Экспорт
	
	
	
КонецПроцедуры

// Позволяет переопределить получение записанных результатов проверки КМ средствами ККТ для формы объекта.
// (см. процедуру КонтрольКодовМаркировкиСредствамиККТМДЛП.ПолучитьРезультатыПроверкиКМ).
//
// Параметры:
//  Параметры - Структура - см. КонтрольКодовМаркировкиСредствамиККТМДЛП.ПараметрыПолученияРезультатовПроверкиКМ.
//  СтандартныйРезультат - ТаблицаЗначений - таблица результата проверки КМ.
//
Процедура ПолучитьРезультатыПроверкиКМСредствамиККТ(Параметры, СтандартныйРезультат) Экспорт
	
	
	
КонецПроцедуры

// Позволяет переопределить удаление записанных результатов проверки КМ средствами ККТ для формы объекта.
// (см. процедуру КонтрольКодовМаркировкиСредствамиККТМДЛП.УдалитьРезультатыПроверкиКМ).
//
// Параметры:
//  Параметры - Структура - см. КонтрольКодовМаркировкиСредствамиККТМДЛП.ПараметрыУдаленияРезультатовПроверкиКМ.
//  СтандартнаяОбработка - Булево - признак использования стандартного поведения.
//
Процедура УдалитьРезультатыПроверкиКМСредствамиККТ(Параметры, СтандартнаяОбработка) Экспорт
	
	
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// БольничнаяАптека

Процедура ПодключитьМеханизмПроверкиКМНаФормеСредствамиККТ(Форма)
	
	ПараметрыПодключения = КонтрольКодовМаркировкиМДЛП.ПараметрыПодключенияПроверкиКМ(Форма);
	КонтрольКодовМаркировкиМДЛП.ПодключитьМеханизмПроверкиКМ(ПараметрыПодключения);
	
	МеханизмПроверкиКМПодключен = КонтрольКодовМаркировкиМДЛП.МеханизмПроверкиКМПодключен(Форма);
	
	Форма.Элементы.ТоварыГруппаПроверкаКМ.Видимость = МеханизмПроверкиКМПодключен;
	
	Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(Форма.Элементы, "ТоварыВыборочныйКонтрольМДЛП") Тогда
		Форма.Элементы.ТоварыВыборочныйКонтрольМДЛП.Видимость = МеханизмПроверкиКМПодключен;
	КонецЕсли;
	
КонецПроцедуры

Процедура ПолучитьРезультатыПроверкиКМНаФормеСредствамиККТ(Форма)
	
	Объект = Форма.Объект;
	
	ПараметрыПолучения = КонтрольКодовМаркировкиМДЛП.ПараметрыПолученияРезультатовПроверкиКМ();
	Для Каждого СтрокаНомераУпаковки Из Объект.Товары Цикл
		Если ЗначениеЗаполнено(СтрокаНомераУпаковки.НомерКИЗ) Тогда
			ПараметрыПолучения.НомераУпаковок.Добавить(СтрокаНомераУпаковки.НомерКИЗ);
		КонецЕсли;
	КонецЦикла;
	
	Если Не ЗначениеЗаполнено(ПараметрыПолучения.НомераУпаковок) Тогда
		Возврат;
	КонецЕсли;
	
	ТаблицаРезультатовПроверкиКМ = КонтрольКодовМаркировкиМДЛП.ПолучитьРезультатыПроверкиКМ(ПараметрыПолучения);
	Если Не ЗначениеЗаполнено(ТаблицаРезультатовПроверкиКМ) Тогда
		Возврат;
	КонецЕсли;
	
	Для Каждого СтрокаНомераУпаковки Из Объект.Товары Цикл
		
		Если Не ЗначениеЗаполнено(СтрокаНомераУпаковки.НомерКИЗ) Тогда
			Продолжить;
		КонецЕсли;
		
		СтрокиРезультатовПроверкиКМ = ТаблицаРезультатовПроверкиКМ.НайтиСтроки(Новый Структура("НомерУпаковкиПроверки", СтрокаНомераУпаковки.НомерКИЗ));
		Если СтрокиРезультатовПроверкиКМ.Количество() = 0 Тогда
			Продолжить;
		КонецЕсли;
		
		ЗаполнитьЗначенияСвойств(СтрокаНомераУпаковки, СтрокиРезультатовПроверкиКМ[0]);
		
		КонтрольКодовМаркировкиМДЛПКлиентСервер.ЗаполнитьПредставлениеРезультатаПроверкиКМ(Форма, СтрокаНомераУпаковки);
		
	КонецЦикла;
	
КонецПроцедуры

Процедура ЗаписатьРезультатыПроверкиКМНаФормеСредствамиККТ(Форма, ДокументСсылка)
	
	Если Не КонтрольКодовМаркировкиМДЛП.МеханизмПроверкиКМИспользуется(Форма) Тогда
		Возврат;
	КонецЕсли;
	
	Если Не Форма.Модифицированность Тогда
		Возврат;
	КонецЕсли;
	
	Объект = Форма.Объект;
	
	ПараметрыЗаписи = КонтрольКодовМаркировкиМДЛП.ПараметрыЗаписиРезультатовПроверкиКМ(Форма);
	
	КонтрольВыполнятьВФормеВыборочногоКонтроляКМ = ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(Форма, "КонтрольВыполнятьВФормеВыборочногоКонтроляКМ") И Форма.КонтрольВыполнятьВФормеВыборочногоКонтроляКМ;
	
	СвойстваСтрокиРезультата = Новый Массив;
	Для Каждого Колонка Из ПараметрыЗаписи.ТаблицаРезультатовПроверкиКМ.Колонки Цикл
		СвойстваСтрокиРезультата.Добавить(Колонка.Имя);
	КонецЦикла;
	СвойстваСтрокиРезультатаСтрокой = СтрСоединить(СвойстваСтрокиРезультата, ",");
	
	Для Каждого СтрокаНомераУпаковки Из Объект.Товары Цикл
		
		Если Не ЗначениеЗаполнено(СтрокаНомераУпаковки.НомерКИЗ) Тогда
			Продолжить;
		КонецЕсли;
		
		ЗначенияСтрокиРезультата = Новый Структура(СвойстваСтрокиРезультатаСтрокой);
		ЗаполнитьЗначенияСвойств(ЗначенияСтрокиРезультата, СтрокаНомераУпаковки);
		ЗначенияСтрокиРезультата.НомерУпаковки = СтрокаНомераУпаковки.НомерКИЗ;
		
		Если КонтрольВыполнятьВФормеВыборочногоКонтроляКМ Тогда
			// Если КонтрольВыполнятьВФормеВыборочногоКонтроляКМ = Истина,
			// то из текущей формы повторно записывать строки, у которых КонтрольВыполнен = Истина, не нужно, т.к. контроль уже выполнен.
			// Если КонтрольВыполнен = Ложь, то это может значить, что КМ только что был добавлен в документ и нужно провести анализ в процедуре ЗаписатьРезультатыПроверкиКМ.
			// Если КонтрольВыполнятьВФормеВыборочногоКонтроляКМ = Ложь, то есть вероятность, что в значение КонтрольВыполнен могло измениться в документе
			// и нужно провести анализ в процедуре ЗаписатьРезультатыПроверкиКМ.
			КонтрольВыполнен = ОбщегоНазначенияКлиентСервер.СвойствоСтруктуры(ЗначенияСтрокиРезультата.РезультатПроверкиКМ, "КонтрольВыполнен", Ложь);
			Если КонтрольВыполнен Тогда
				Продолжить;
			КонецЕсли;
		КонецЕсли;
		
		СтрокаРезультата = ПараметрыЗаписи.ТаблицаРезультатовПроверкиКМ.Добавить();
		ЗаполнитьЗначенияСвойств(СтрокаРезультата, ЗначенияСтрокиРезультата);
		
	КонецЦикла;
	
	Если Не ЗначениеЗаполнено(ПараметрыЗаписи.ТаблицаРезультатовПроверкиКМ) Тогда
		Возврат;
	КонецЕсли;
	
	КонтрольКодовМаркировкиМДЛП.ЗаписатьРезультатыПроверкиКМ(ПараметрыЗаписи);
	
КонецПроцедуры

// Конец БольничнаяАптека

#КонецОбласти
