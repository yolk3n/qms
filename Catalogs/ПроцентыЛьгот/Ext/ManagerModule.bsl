﻿
////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ
#Область ОбработчикиСобытий

Процедура ОбработкаПолученияПредставления(Данные, Представление, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Процент = Данные[ПустаяСсылка().Метаданные().Реквизиты.Процент.Имя];
	
	Представление = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = '%1%'"), Процент);
	
КонецПроцедуры

Процедура ОбработкаПолученияПолейПредставления(Поля, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Поля.Добавить(ПустаяСсылка().Метаданные().Реквизиты.Процент.Имя);
	
КонецПроцедуры

#КонецОбласти // ОбработчикиСобытий

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

////////////////////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС
#Область ПрограммныйИнтерфейс

Процедура ЗаполнитьПредопределенныеПроцентыЛьгот() Экспорт
	
	Запрос = Новый Запрос("
	|ВЫБРАТЬ
	|	ПроцентыЛьгот.Ссылка                     КАК Ссылка,
	|	ПроцентыЛьгот.ИмяПредопределенныхДанных  КАК ИмяПредопределенныхДанных
	|ИЗ
	|	Справочник.ПроцентыЛьгот КАК ПроцентыЛьгот
	|ГДЕ
	|	ПроцентыЛьгот.Предопределенный
	|");
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		
		Объект = Выборка.Ссылка.ПолучитьОбъект();
		Объект.Процент = Число(Сред(Объект.ИмяПредопределенныхДанных, СтрНайти(Объект.ИмяПредопределенныхДанных, "_") + 1));
		Объект.Записать();
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти // ПрограммныйИнтерфейс

#КонецЕсли