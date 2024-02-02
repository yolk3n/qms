﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2023, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Процедура позволяет переопределить список способов первичной аутентификации, доступный пользователю
//
// Параметры:
//  МассивСпособов - Массив из ПеречислениеСсылка.СпособыАвторизацииDSS
//
//@skip-warning Пустой метод
//
Процедура СписокПервичнойАвторизации(МассивСпособов) Экспорт
	
	
КонецПроцедуры

// Процедура позволяет переопределить список способов вторичной авторизация, доступный пользователю
//
// Параметры:
//  МассивСпособов - Массив из ПеречислениеСсылка.СпособыАвторизацииDSS
//
//@skip-warning Пустой метод
//
Процедура СписокВторичнойАвторизации(МассивСпособов) Экспорт
	
	
КонецПроцедуры

// Процедура вызывается при изменении значения константы ИспользоватьСервисDSS
//
//@skip-warning Пустой метод
//
Процедура ПриВключенииСервисаОблачнойПодписи() Экспорт

КонецПроцедуры

// Позволяет переопределить использование синхронного режима работы в зависимости от вида клиента
//
// Параметры:
//  ТекущийРежим - Булево - для ВебКлиента Ложь, для остальных Истина
//
//@skip-warning Пустой метод
//
Процедура ИспользоватьСинхронныйРежим(ТекущийРежим) Экспорт
	
КонецПроцедуры

#КонецОбласти
