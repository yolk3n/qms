﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2018, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Обработка входящих сообщений с типом {http://www.1c.ru/SaaS/ManageZonesBackup/a.b.c.d}PlanZoneBackup.
// @skip-warning ПустойМетод - особенность реализации.
//
// Параметры:
//  КодОбластиДанных - Число - код области данных,
//  ИдентификаторРезервнойКопии - УникальныйИдентификатор - идентификатор резервной копии,
//  МоментРезервнойКопии - Дата - дата и время резервной копии,
//  Принудительно - Булево - флаг принудительного создания резервной копии.
//  ДляПоддержки - Булево - признак создания копии для службы поддержки.
//
Процедура ПланироватьСозданиеРезервнойКопииОбласти(Знач КодОбластиДанных,
		Знач ИдентификаторРезервнойКопии, Знач МоментРезервнойКопии,
		Знач Принудительно, Знач ДляПоддержки) Экспорт
КонецПроцедуры

// Обработка входящих сообщений с типом {http://www.1c.ru/SaaS/ManageZonesBackup/a.b.c.d}CancelZoneBackup.
// @skip-warning ПустойМетод - особенность реализации.
//
// Параметры:
//  КодОбластиДанных - Число - код области данных,
//  ИдентификаторРезервнойКопии - УникальныйИдентификатор - идентификатор резервной копии.
//
Процедура ОтменитьСозданиеРезервнойКопииОбласти(Знач КодОбластиДанных, Знач ИдентификаторРезервнойКопии) Экспорт
КонецПроцедуры

// Обработка входящих сообщений с типом
// {http://www.1c.ru/SaaS/ManageZonesBackup/a.b.c.d}UpdateScheduledZoneBackupSettings.
// @skip-warning ПустойМетод - особенность реализации.
//
// Параметры:
//  ОбластьДанных - Число - значение разделителя области данных.
//  Настройки - Структура - новые настройки резервного копирования.
//
Процедура ОбновитьНастройкиПериодическогоРезервногоКопирования(Знач ОбластьДанных, Знач Настройки) Экспорт
КонецПроцедуры

// Обработка входящих сообщений с типом {http://www.1c.ru/SaaS/ManageZonesBackup/a.b.c.d}CancelScheduledZoneBackup.
// @skip-warning ПустойМетод - особенность реализации.
//
// Параметры:
//  ОбластьДанных - Число - значение разделителя области данных.
//
Процедура ОтменитьПериодическоеРезервноеКопирование(Знач ОбластьДанных) Экспорт
КонецПроцедуры

#КонецОбласти
