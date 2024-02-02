﻿#Область СлужебныйПрограммныйИнтерфейс

// @skip-warning ПустойМетод - особенность реализации.
// 
// Параметры:
//  МассивОбработчиков - Массив - обработчики сообщений.
//
Процедура РегистрацияИнтерфейсовПринимаемыхСообщений(МассивОбработчиков) Экспорт
КонецПроцедуры

// @skip-warning ПустойМетод - особенность реализации.
//
// Параметры:
//  МассивОбработчиков - Массив - обработчики сообщений.
//
Процедура РегистрацияИнтерфейсовОтправляемыхСообщений(МассивОбработчиков) Экспорт
КонецПроцедуры

//@skip-warning
Процедура ПриОпределенииПоддерживаемыхВерсийПрограммныхИнтерфейсов(Знач СтруктураПоддерживаемыхВерсий) Экспорт
КонецПроцедуры

// Обработка входящих сообщений с типом {http://www.1c.ru/1cFresh/ManageSynopticExchange/a.b.c.d}SetSynopticExchange.
// @skip-warning ПустойМетод - особенность реализации.
//
// Параметры:
//  КодОбластиДанных - Число - код области данных,
//  Параметры - Структура - идентификатор резервной копии,
//
Процедура НастроитьЗагрузкуВСводноеПриложение(КодОбластиДанных, Параметры) Экспорт
КонецПроцедуры

// Обработка входящих сообщений с типом {http://www.1c.ru/1cFresh/ManageSynopticExchange/a.b.c.d}SetCorrSynopticExchange.
// @skip-warning ПустойМетод - особенность реализации.
//
// Параметры:
//  КодОбластиДанных - Число - код области данных,
//  Параметры - Структура - идентификатор резервной копии,
//
Процедура НастроитьВыгрузкуВСводноеПриложение(КодОбластиДанных, Параметры) Экспорт
КонецПроцедуры

// Обработка входящих сообщений с типом {http://www.1c.ru/1cFresh/ManageSynopticExchange/a.b.c.d}PushSynopticExchangeStep1.
// @skip-warning ПустойМетод - особенность реализации.
//
// Параметры:
//  КодОбластиДанных - Число - код области данных,
//  Параметры - Структура - идентификатор резервной копии,
//
Процедура ИнтерактивныйЗапускВыгрузкиВСводноеПриложение(КодОбластиДанных, Параметры) Экспорт 
КонецПроцедуры

// Обработка входящих сообщений с типом {http://www.1c.ru/1cFresh/ManageSynopticExchange/a.b.c.d}PushSynopticExchangeStep2.
// @skip-warning ПустойМетод - особенность реализации.
//
// Параметры:
//  КодОбластиДанных - Число - код области данных,
//  Параметры - Структура - идентификатор резервной копии,
//
Процедура ИнтерактивныйЗапускЗагрузкиВСводноеПриложение(КодОбластиДанных, Параметры) Экспорт 
КонецПроцедуры

// См. ОчередьЗаданийПереопределяемый.ПриОпределенииПсевдонимовОбработчиков.
// @skip-warning ПустойМетод - особенность реализации.
//
Процедура ПриОпределенииПсевдонимовОбработчиков(СоответствиеИменПсевдонимам) Экспорт
КонецПроцедуры

// См. ВыгрузкаЗагрузкаДанныхПереопределяемый.ПриЗаполненииТиповИсключаемыхИзВыгрузкиЗагрузки.
// 
// Параметры:
// 	Типы - Массив из ОбъектМетаданных
//
Процедура ПриЗаполненииТиповИсключаемыхИзВыгрузкиЗагрузки(Типы) Экспорт
	Типы.Добавить(Метаданные.РегистрыСведений.СводныеПриложенияОчередьЗагрузки);
	Типы.Добавить(Метаданные.РегистрыСведений.СводныеПриложенияСостояниеЗагрузки);
	Типы.Добавить(Метаданные.РегистрыСведений.СводныеПриложенияСостояниеВыгрузки);
	Типы.Добавить(Метаданные.Константы.ИспользоватьВыгрузкуВСводноеПриложение);
КонецПроцедуры

// См. РегламентныеЗаданияПереопределяемый.ПриОпределенииНастроекРегламентныхЗаданий
// @skip-warning ПустойМетод - особенность реализации.
//
// Параметры:
//	Настройки - см. РегламентныеЗаданияПереопределяемый.ПриОпределенииНастроекРегламентныхЗаданий.Настройки
//
Процедура ПриОпределенииНастроекРегламентныхЗаданий(Настройки) Экспорт
КонецПроцедуры

// См. ОбновлениеИнформационнойБазыБСП.ПриДобавленииОбработчиковОбновления
// @skip-warning ПустойМетод - особенность реализации.
//
// Параметры:
//	Обработчики - см. ОбновлениеИнформационнойБазы.НоваяТаблицаОбработчиковОбновления
//
Процедура ПриДобавленииОбработчиковОбновления(Обработчики) Экспорт
КонецПроцедуры

// Регламентное задание СводныеПриложенияВыгрузка.
// @skip-warning ПустойМетод - особенность реализации.
//
Процедура ЗаданиеВыгрузка() Экспорт
КонецПроцедуры

// Регламентное задание СводныеПриложенияПланированиеЗагрузки.
// @skip-warning ПустойМетод - особенность реализации.
//
Процедура ЗаданиеПланированиеЗагрузки() Экспорт
КонецПроцедуры

// Обработчик подписки на событие ПередЗаписьюОбъекта.
// @skip-warning ПустойМетод - особенность реализации.
//
Процедура ПередЗаписьюОбъекта(Источник, Отказ) Экспорт
КонецПроцедуры

// Обработчик подписки на событие ЗаписьюДокумента.
// @skip-warning ПустойМетод - особенность реализации.
//
Процедура ПередЗаписьюДокумента(Источник, Отказ, РежимЗаписи, РежимПроведения) Экспорт
КонецПроцедуры

// Обработчик подписки на событие ПередЗаписьюНабора.
// @skip-warning ПустойМетод - особенность реализации.
//
Процедура ПередЗаписьюНабора(Источник, Отказ, Замещение) Экспорт
КонецПроцедуры

// Обработчик подписки на событие ПередЗаписьюНабораРасчета.
// @skip-warning ПустойМетод - особенность реализации.
//
Процедура ПередЗаписьюНабораРасчета(Источник, Отказ, Замещение, ТолькоЗапись, ЗаписьФактическогоПериодаДействия, ЗаписьПерерасчетов) Экспорт
КонецПроцедуры

// Обработчик подписки на событие ПередУдалениемОбъекта.
// @skip-warning ПустойМетод - особенность реализации.
//
Процедура ПередУдалениемОбъекта(Источник, Отказ) Экспорт
КонецПроцедуры

#Область ИнтеграцияСПодсистемойПередачаДанных

// Возвращает описание данных логического хранилища.
// @skip-warning ПустойМетод - особенность реализации.
//
// Параметры:
//  ИдентификаторХранилища - Строка - идентификатор логического хранилища.
//  ИдентификаторДанных    - Строка - идентификатор данных хранилища.
// 
// Возвращаемое значение:
//   Структура - описание состояния задания очереди:
//    * ИмяФайла - Строка - имя файла.
//    * Размер - Число - размер файла в байтах.
//    * Данные - ДвоичныеДанные - двоичные данные файла описания задания.
//
Функция Описание(ИдентификаторХранилища, ИдентификаторДанных) Экспорт
КонецФункции

// Возвращает данные логического хранилища.
// @skip-warning ПустойМетод - особенность реализации.
//
// Параметры:
//  ОписаниеДанных - Структура - описание данных хранилища.
// 
// Возвращаемое значение:
//   ДвоичныеДанные -
//
Функция Данные(ОписаниеДанных) Экспорт
КонецФункции

// Записывает данные в логическое хранилище.
// @skip-warning ПустойМетод - особенность реализации.
// Выполняет действия:
// - сохраняет файл данных в файловом хранилище
// - планирует задание очереди заданий на обработки файла
// - возвращается идентификатор задания в ответ.
// 
// Параметры:
//	ОписаниеДанных - Структура - описание данных хранилища:
//	 * ИмяФайла - Строка - имя файла.
//	 * Размер - Число - размер файла в байтах.
//	 * Данные - ДвоичныеДанные, Строка - двоичные данные файла или расположение файла на диске.
// 
// Возвращаемое значение:
//   Структура:
//     * ИмяКонфигурации - Строка - имя конфигурации.
//     * ВерсияКонфигурации - Строка - версия конфигурации.
//     * ВыполняетсяЗагрузка - Булево - признак что выполняется загрузка.
//     * НомерПринятогоСообщения - Число - количество обработанных сообщений.
//     * ЗагруженоОбъектов - Число - количество загруженных объектов.
//     * ЗавершеноСОшибками - Булево - признак завершения с ошибками.
//     * ОписаниеОшибки - Строка - описание ошибки.
//     * ТребуетсяПовторнаяОтправка - Булево - Истина если требуется отправить повторно данные, которые находятся сейчас
//                                             в очереди.
Функция Загрузить(ОписаниеДанных) Экспорт
КонецФункции

#КонецОбласти

#КонецОбласти
