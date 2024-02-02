﻿
////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ
#Область ОбработчикиСобытий

Процедура ОбработкаПолученияДанныхВыбора(ДанныеВыбора, Параметры, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ДанныеВыбора = Новый СписокЗначений;
	ДанныеВыбора.Добавить(Перечисления.ТипыСкладов.БольничнаяАптека);
	ДанныеВыбора.Добавить(Перечисления.ТипыСкладов.Отделение);
	Если ПолучитьФункциональнуюОпцию("ИспользоватьРозничныеПродажи") Тогда
		ДанныеВыбора.Добавить(Перечисления.ТипыСкладов.РозничныйМагазин);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти // ОбработчикиСобытий

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

////////////////////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС
#Область ПрограммныйИнтерфейс

// Возвращает типы складов соответствующие складам основного учета
//
Функция ТипыСкладовАптеки() Экспорт
	
	ТипыСкладов = Новый Массив;
	ТипыСкладов.Добавить(Перечисления.ТипыСкладов.БольничнаяАптека);
	ТипыСкладов.Добавить(Перечисления.ТипыСкладов.РозничныйМагазин);
	
	Возврат ТипыСкладов;
	
КонецФункции

// Возвращает типы складов соответствующие складам, которые могут отпускать товар в отделения
//
Функция ТипыСкладовВзаимодействующиеСОтделениями() Экспорт
	
	ТипыСкладов = Новый Массив;
	ТипыСкладов.Добавить(Перечисления.ТипыСкладов.БольничнаяАптека);
	
	Возврат ТипыСкладов;
	
КонецФункции

// Возвращает типы складов соответствующие складам, на которых могут выполнятся производственные операции
//
Функция ТипыСкладовПроизводства() Экспорт
	
	ТипыСкладов = Новый Массив;
	ТипыСкладов.Добавить(Перечисления.ТипыСкладов.БольничнаяАптека);
	
	Возврат ТипыСкладов;
	
КонецФункции

// Возвращает типы складов соответствующие складам отделений
//
Функция ТипыСкладовОтделений() Экспорт
	
	ТипыСкладов = Новый Массив;
	ТипыСкладов.Добавить(Перечисления.ТипыСкладов.Отделение);
	
	Возврат ТипыСкладов;
	
КонецФункции

// Возвращает типы складов соответствующие розничным магазинам
//
Функция ТипыРозничныхСкладов() Экспорт
	
	ТипыСкладов = Новый Массив;
	ТипыСкладов.Добавить(Перечисления.ТипыСкладов.РозничныйМагазин);
	
	Возврат ТипыСкладов;
	
КонецФункции

#КонецОбласти // ПрограммныйИнтерфейс

#КонецЕсли