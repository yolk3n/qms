﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ
#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если Значение = Истина И ОбщегоНазначенияБольничнаяАптека.ЭтоОсновнаяПодсистемаКонфигурации() Тогда
		Отказ = Истина; // В Больничной аптеке значение этой константы должно быть Ложь.
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли