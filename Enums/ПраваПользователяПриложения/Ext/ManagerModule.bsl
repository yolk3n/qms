﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныйПрограммныйИнтерфейс

// Возвращает значение перечисления по имени значения в API.
//
// Параметры:
//  ИмяЗначения	- Строка - имя значения, как оно передается через API
// 
// Возвращаемое значение:
//  ПеречислениеСсылка.ПраваПользователяПриложения - значение перечисления по имени.
//
Функция ЗначениеПоИмени(ИмяЗначения) Экспорт
    
    Если ИмяЗначения = "user" Тогда
        Возврат ПредопределенноеЗначение("Перечисление.ПраваПользователяПриложения.Запуск");
    ИначеЕсли ИмяЗначения = "administrator" Тогда
        Возврат ПредопределенноеЗначение("Перечисление.ПраваПользователяПриложения.ЗапускИАдминистрирование");
    ИначеЕсли ИмяЗначения = "api" Тогда
        Возврат ПредопределенноеЗначение("Перечисление.ПраваПользователяПриложения.ДоступКAPI");
    Иначе
        Возврат ПредопределенноеЗначение("Перечисление.ПраваПользователяПриложения.ПустаяСсылка");
    КонецЕсли; 
    
КонецФункции

// Возвращает имя значения для API по значению перечисления.
//
// Параметры:
//  Значение - ПеречислениеСсылка.ПраваПользователяПриложения - значение перечисления для получения имени значения для API
// 
// Возвращаемое значение:
//  Строка - имя значения для API
//
Функция ИмяПоЗначению(Значение) Экспорт
	
    Если Значение = ПредопределенноеЗначение("Перечисление.ПраваПользователяПриложения.Запуск") Тогда
        Возврат "user";
    ИначеЕсли Значение = ПредопределенноеЗначение("Перечисление.ПраваПользователяПриложения.ЗапускИАдминистрирование") Тогда
        Возврат "administrator";
    ИначеЕсли Значение = ПредопределенноеЗначение("Перечисление.ПраваПользователяПриложения.ДоступКAPI") Тогда
        Возврат "api";
    Иначе 
        Возврат Неопределено;
    КонецЕсли; 
	
КонецФункции

#КонецОбласти

#КонецЕсли