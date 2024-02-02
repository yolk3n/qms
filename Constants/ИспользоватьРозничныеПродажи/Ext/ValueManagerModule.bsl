﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

////////////////////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС
#Область ПрограммныйИнтерфейс

Процедура ПриОпределенииЗависимостиКонстант(ТаблицаКонстант) Экспорт
	
	ИмяКонстанты = Метаданные().Имя;
	
	ОбщегоНазначенияБольничнаяАптека.ДобавитьЗависимостьКонстант(ТаблицаКонстант,
		ИмяКонстанты                                             , Ложь,
		Метаданные.Константы.ОперацияПриЗакрытииКассовойСмены.Имя, Перечисления.ОперацииПриЗакрытииКассовойСмены.Нет);
	
	ОбщегоНазначенияБольничнаяАптека.ДобавитьЗависимостьКонстант(ТаблицаКонстант,
		ИмяКонстанты                                                  , Ложь,
		Метаданные.Константы.КоличествоДнейХраненияОтложенныхЧеков.Имя, 0);
	
	ОбщегоНазначенияБольничнаяАптека.ДобавитьЗависимостьКонстант(ТаблицаКонстант,
		ИмяКонстанты                                                        , Ложь,
		Метаданные.Константы.КоличествоДнейХраненияЗаархивированныхЧеков.Имя, 0);
	
КонецПроцедуры

#КонецОбласти // ПрограммныйИнтерфейс

#КонецЕсли