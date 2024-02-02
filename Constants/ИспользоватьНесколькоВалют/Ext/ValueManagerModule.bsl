﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

////////////////////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС
#Область ПрограммныйИнтерфейс

Процедура ПриОпределенииЗависимостиКонстант(ТаблицаКонстант) Экспорт
	
	ИмяКонстанты = Метаданные().Имя;
	
	ОбщегоНазначенияБольничнаяАптека.ДобавитьИнвертируемыеКонстанты(ТаблицаКонстант, ИмяКонстанты);
	
КонецПроцедуры

#КонецОбласти // ПрограммныйИнтерфейс

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если Не Значение И ОбщегоНазначенияБольничнаяАптека.КоличествоЭлементов(Метаданные.Справочники.Валюты) > 1 Тогда
		ВызватьИсключение НСтр("ru='В базе заведено более одной валюты.
									|Отключение ведения учета по нескольким валютам невозможно.'");
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
