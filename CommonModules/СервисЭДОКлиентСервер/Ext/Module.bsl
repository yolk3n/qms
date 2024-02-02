﻿//@strict-types

#Область СлужебныйПрограммныйИнтерфейс

// Возвращает параметры уведомлений в сервисе 1С-ЭДО.
// 
// Возвращаемое значение:
// 	Структура:
// * АдресУведомлений - Строка
// * УведомлятьОСобытиях - Булево
// * УведомлятьОНовыхПриглашениях - Булево
// * УведомлятьОбОтветахНаПриглашения - Булево
// * УведомлятьОНовыхДокументах - Булево
// * УведомлятьОНеобработанныхДокументах - Булево
// * УведомлятьОбОкончанииСрокаДействияСертификата - Булево
Функция НовыеПараметрыУведомлений() Экспорт
	
	ПараметрыУведомлений = Новый Структура;
	ПараметрыУведомлений.Вставить("АдресУведомлений", "");
	ПараметрыУведомлений.Вставить("УведомлятьОСобытиях", Ложь);
	ПараметрыУведомлений.Вставить("УведомлятьОНовыхПриглашениях", Ложь);
	ПараметрыУведомлений.Вставить("УведомлятьОбОтветахНаПриглашения", Ложь);
	ПараметрыУведомлений.Вставить("УведомлятьОНовыхДокументах", Ложь);
	ПараметрыУведомлений.Вставить("УведомлятьОНеобработанныхДокументах", Ложь);
	ПараметрыУведомлений.Вставить("УведомлятьОбОкончанииСрокаДействияСертификата", Ложь);
		
	Возврат ПараметрыУведомлений;
	
КонецФункции


// Возвращает ссылку на описание сервиса.
// 
// Возвращаемое значение:
// 	Строка - ссылка на описание.
Функция СсылкаНаОписаниеСервисаЭДО() Экспорт
	
	Возврат "https://portal.1c.ru/applications/30/#conditions";
	
КонецФункции

#КонецОбласти