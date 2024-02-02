﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2023, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.ГрупповоеИзменениеОбъектов

// Возвращает реквизиты объекта, которые разрешается редактировать
// с помощью обработки группового изменения реквизитов.
//
// Возвращаемое значение:
//  Массив - список имен реквизитов объекта.
//
Функция РеквизитыРедактируемыеВГрупповойОбработке() Экспорт
	
	РедактируемыеРеквизиты = Новый Массив;
	
	Возврат РедактируемыеРеквизиты;
	
КонецФункции

// Конец СтандартныеПодсистемы.ГрупповоеИзменениеОбъектов

// ТехнологияСервиса.ВыгрузкаЗагрузкаДанных

// Возвращает реквизиты справочника, которые образуют естественный ключ для элементов справочника.
//
// Возвращаемое значение:
//  Массив из Строка - массив имен реквизитов, образующих естественный ключ.
//
Функция ПоляЕстественногоКлюча() Экспорт
	
	Результат = Новый Массив;
	Результат.Добавить("АдресСервера");
	Результат.Добавить("ИдентификаторЦИ");
	
	Возврат Результат;
	
КонецФункции

// Конец ТехнологияСервиса.ВыгрузкаЗагрузкаДанных

#КонецОбласти

#КонецОбласти

#Область ОбработчикиСобытий

Процедура ОбработкаПолученияФормы(ВидФормы, Параметры, ВыбраннаяФорма, ДополнительнаяИнформация, СтандартнаяОбработка)
	
	Если НЕ ЭлектроннаяПодписьСлужебный.ИспользоватьСервисОблачнойПодписи() Тогда
		СтандартнаяОбработка = Ложь;
		ВызватьИсключение СервисКриптографииDSSСлужебный.ПолучитьОписаниеОшибки(Неопределено, "ПодсистемаОтключена");
		
	ИначеЕсли ВидФормы = "ФормаОбъекта" Тогда
		СтандартнаяОбработка = Ложь;
		ВыбраннаяФорма = Метаданные.Обработки.УправлениеПодключениемDSS.Формы.ФормаЭкземпляраСервераDSS;
		
	ИначеЕсли ВидФормы = "ФормаВыбора" Тогда
		СтандартнаяОбработка = Ложь;
		ВыбраннаяФорма = Метаданные.Обработки.УправлениеПодключениемDSS.Формы.ВыборЭкземпляровСервераDSS;
		
	ИначеЕсли ВидФормы = "ФормаСписка" Тогда
		СтандартнаяОбработка = Ложь;
		ВыбраннаяФорма = Метаданные.Обработки.УправлениеПодключениемDSS.Формы.СписокЭкземпляровСервераDSS;
		
	КонецЕсли;	
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли

