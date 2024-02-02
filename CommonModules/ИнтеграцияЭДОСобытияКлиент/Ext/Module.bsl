﻿#Область СлужебныйПрограммныйИнтерфейс

// См. ЭлектронноеВзаимодействиеКлиент.ПослеНачалаРаботыСистемы
Процедура ПослеНачалаРаботыСистемы() Экспорт
	
	СинхронизацияЭДОКлиент.ПослеНачалаРаботыСистемы();
	
КонецПроцедуры

// Выполнение действий после отражения документов в системе
//
// Параметры:
//  ОповещениеОЗавершении - ОписаниеОповещения - Оповещение, которое будет вызвано после обработки события с параметрами:
//     Результат - см. ОбработкаНеисправностейБЭДКлиент.НовыйКонтекстДиагностики
//  ТипДокумента - ПеречислениеСсылка.ТипыДокументовЭДО
//  ТаблицаДокументов - ДанныеФормыКоллекция
//  * ОбъектУчета - ОпределяемыйТип.ОснованияЭлектронныхДокументовЭДО
//  * СпособОбработки - Строка
//  КонтекстДиагностики - см. ОбработкаНеисправностейБЭДКлиент.НовыйКонтекстДиагностики
//
Процедура ПослеОтраженияВУчете(ОповещениеОЗавершении, ТипДокумента, ТаблицаДокументов, КонтекстДиагностики) Экспорт
	
	МашиночитаемыеДоверенностиКлиент.ПослеОтраженияВУчете(ОповещениеОЗавершении, ТипДокумента, ТаблицаДокументов,
		КонтекстДиагностики);
	
КонецПроцедуры

// Выполнение действий после перезаполнения учетных документов
//
// Параметры:
//  ОповещениеОЗавершении - ОписаниеОповещения - Оповещение, которое будет вызвано после обработки события с параметрами:
//     Результат - см. ОбработкаНеисправностейБЭДКлиент.НовыйКонтекстДиагностики
//  ТипДокумента - ПеречислениеСсылка.ТипыДокументовЭДО
//  ОбъектУчета - ОпределяемыйТип.ОснованияЭлектронныхДокументовЭДО
//  КонтекстДиагностики - см. ОбработкаНеисправностейБЭДКлиент.НовыйКонтекстДиагностики
//
Процедура ПослеПерезаполненияОбъектаУчета(ОповещениеОЗавершении, ТипДокумента, ОбъектУчета, КонтекстДиагностики) Экспорт
	
	МашиночитаемыеДоверенностиКлиент.ПослеПерезаполненияОбъектаУчета(ОповещениеОЗавершении, ТипДокумента, ОбъектУчета,
		КонтекстДиагностики);
	
КонецПроцедуры

#КонецОбласти