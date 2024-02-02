﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

////////////////////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС
#Область ПрограммныйИнтерфейс

// Кэширует информацию об объекте
//
// Параметры:
//  Объект         - ЛюбаяСсылка - объект, по которому сохраняется информация.
//  ПолеИнформации - Строка - ключ сохраняемой информации.
//  Значение       - Произвольный - сохраняемая информация.
//
Процедура УстановитьИнформациюОбОбъекте(Объект, ПолеИнформации, Значение) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Запись = СоздатьМенеджерЗаписи();
	Запись.Объект = Объект;
	Если Запись.Объект = Неопределено Тогда // Данный тип объекта не обрабатывается
		Возврат;
	КонецЕсли;
	
	Запись.Прочитать();
	
	Если Запись[ПолеИнформации] <> Значение Тогда
		Запись.Объект = Объект;
		Запись[ПолеИнформации] = Значение;
		Запись.Записать(Истина);
	КонецЕсли;
	
КонецПроцедуры

// Получает кэшированную информацию об объекте.
//
// Параметры:
//  Объект         - ЛюбаяСсылка - объект, по которому получается информация.
//  ПолеИнформации - Строка - ключ получаемой информации.
//
Функция ПолучитьИнформациюОбОбъекте(Объект, ПолеИнформации) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Запись = СоздатьМенеджерЗаписи();
	Запись.Объект = Объект;
	Если Запись.Объект = Неопределено Тогда // Данный тип объекта не обрабатывается
		Возврат Неопределено;
	КонецЕсли;
	
	Запись.Прочитать();
	
	Возврат Запись[ПолеИнформации];
	
КонецФункции

#КонецОбласти // ПрограммныйИнтерфейс

#КонецЕсли