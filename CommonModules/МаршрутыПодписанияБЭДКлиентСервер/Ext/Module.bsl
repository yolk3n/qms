﻿#Область СлужебныйПрограммныйИнтерфейс

// Определяет параметры подчиненных строк дерева подписания, необходимые для работы механизмов отрисовки и
// редактирования.
//
// Параметры:
//  СтрокаДерева		 - ДанныеФормыЭлементДерева - строка дерева.
//  ЕстьУсловия			 - Булево - в параметр возвращается Истина, если в подчиненных строках указаны требования к
//    подписанию.
//  ЕстьПодписанты		 - Булево - в параметр возвращается Истина, если в подчиненных строках указаны подписанты.
//  ВыбранныеЗначения	 - Массив - требования или подписанты, выбранные в подчиненных строках.
//
Процедура ОпределитьПараметрыПодчиненныхСтрокДерева(СтрокаДерева, ЕстьУсловия = Ложь, ЕстьПодписанты = Ложь,
		ВыбранныеЗначения = Неопределено) Экспорт
	
	Если СтрокаДерева <> Неопределено Тогда
		ПодчиненныеСтроки = СтрокаДерева.ПолучитьЭлементы();
		Если ВыбранныеЗначения = Неопределено Тогда
			ВыбранныеЗначения = Новый Массив;
		КонецЕсли;
		
		Для Каждого ПодчиненнаяСтрока Из ПодчиненныеСтроки Цикл
			Если ПодчиненнаяСтрока.ЭтоСтрокаУсловия Тогда
				ЕстьУсловия = Истина;
				ВыбранныеЗначения.Добавить(ПодчиненнаяСтрока.Требование);
			Иначе
				ЕстьПодписанты = Истина;
				ВыбранныеЗначения.Добавить(ПодчиненнаяСтрока.Подписант);
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры

// Заполняет служебные реквизиты дерева подписания.
//
// Параметры:
//  СтрокаДерева - ДанныеФормыЭлементДерева, СтрокаДереваЗначений - строка дерева.
//  ИмяОсновногоРеквизита- Строка - имя реквизита дерева, который будет выводиться в основной колонке.
//
Процедура ЗаполнитьСлужебныеРеквизитыСтрокиДерева(СтрокаДерева, ИмяОсновногоРеквизита = "Подписант") Экспорт
	
	Если ЗначениеЗаполнено(СтрокаДерева.Требование) ИЛИ СтрокаДерева.ЭтоСтрокаУсловия Тогда
		СтрокаДерева.ЭтоСтрокаУсловия	= Истина;
		СтрокаДерева.ИндексКартинки		= 2;
		СтрокаДерева.ОсновноеЗначение	= ПредставлениеТребованияСтроки(СтрокаДерева);
	Иначе
		СтрокаДерева.ЭтоСтрокаУсловия 	= Ложь;
		
		Если ЗначениеЗаполнено(СтрокаДерева.Сертификат) Тогда
			СтрокаДерева.ИндексКартинки 	= 1;
		Иначе
			СтрокаДерева.ИндексКартинки 	= 0;
		КонецЕсли;
		
		СтрокаДерева.ОсновноеЗначение = СтрокаДерева[ИмяОсновногоРеквизита];
		
		Если СтрокаДерева.Свойство("ОтборСертификатов") Тогда
			СписокПодписантовДляОтбора = Новый СписокЗначений;
			СписокПодписантовДляОтбора.Добавить(ПредопределенноеЗначение("Справочник.Пользователи.ПустаяСсылка"));
			Если ЗначениеЗаполнено(СтрокаДерева.Подписант) Тогда
				СписокПодписантовДляОтбора.Добавить(СтрокаДерева.Подписант);
			КонецЕсли;
			СтрокаДерева.ОтборСертификатов = СписокПодписантовДляОтбора;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

// Определяет соответствие текстовых представлений требований их ссылочным значениям.
//
// Параметры:
//  СтрокаДерева - ДанныеФормыЭлементДерева - строка дерева.
// 
// Возвращаемое значение:
//  Соответствие - ключом является требование, значением - его текстовое представление.
//
Функция СоответствиеПредставленийТребованиям(СтрокаДерева) Экспорт

	ЕстьТребования = Ложь;
	ЕстьПодписанты = Ложь;
	ОпределитьПараметрыПодчиненныхСтрокДерева(СтрокаДерева, ЕстьТребования, ЕстьПодписанты);
	
	СоответствиеПредставленийТребованиям = Новый Соответствие;
	СоответствиеПредставленийТребованиям.Вставить(ПредопределенноеЗначение("Перечисление.ТребованияКПодписаниюЭД.ИЛИ"), 
		НСтр("ru = 'Поставить любую из подписей'"));
	СоответствиеПредставленийТребованиям.Вставить(ПредопределенноеЗначение("Перечисление.ТребованияКПодписаниюЭД.И"), 
		НСтр("ru = 'Поставить все подписи'"));
	СоответствиеПредставленийТребованиям.Вставить(ПредопределенноеЗначение("Перечисление.ТребованияКПодписаниюЭД.ПоПорядку"), 
		НСтр("ru = 'Поставить все подписи по порядку'"));
	
	Если ЕстьТребования И Не ЕстьПодписанты Тогда
		СоответствиеПредставленийТребованиям.Вставить(ПредопределенноеЗначение("Перечисление.ТребованияКПодписаниюЭД.ИЛИ"), 
			НСтр("ru = 'Выполнить любое из требований'"));
		СоответствиеПредставленийТребованиям.Вставить(ПредопределенноеЗначение("Перечисление.ТребованияКПодписаниюЭД.И"), 
			НСтр("ru = 'Выполнить все требования'"));
		СоответствиеПредставленийТребованиям.Вставить(ПредопределенноеЗначение("Перечисление.ТребованияКПодписаниюЭД.ПоПорядку"), 
			НСтр("ru = 'Выполнить все требования по порядку'"));
	ИначеЕсли ЕстьПодписанты И Не ЕстьТребования Тогда
		СоответствиеПредставленийТребованиям.Вставить(ПредопределенноеЗначение("Перечисление.ТребованияКПодписаниюЭД.ИЛИ"), 
			НСтр("ru = 'Поставить любую из подписей'"));
		СоответствиеПредставленийТребованиям.Вставить(ПредопределенноеЗначение("Перечисление.ТребованияКПодписаниюЭД.И"), 
			НСтр("ru = 'Поставить все подписи'"));
		СоответствиеПредставленийТребованиям.Вставить(ПредопределенноеЗначение("Перечисление.ТребованияКПодписаниюЭД.ПоПорядку"), 
			НСтр("ru = 'Поставить все подписи по порядку'"));
	КонецЕсли;
		
	Возврат СоответствиеПредставленийТребованиям;	

КонецФункции 

Функция МаршрутУказыватьПриСоздании() Экспорт
	Возврат ПредопределенноеЗначение("Справочник.МаршрутыПодписания.УказыватьПриСоздании");
КонецФункции

Функция МаршрутОднойДоступнойПодписью() Экспорт
	Возврат ПредопределенноеЗначение("Справочник.МаршрутыПодписания.ОднойДоступнойПодписью");
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ПредставлениеТребованияСтроки(СтрокаДерева)
	
	Результат = "";
	Если ЗначениеЗаполнено(СтрокаДерева.Требование) Тогда
		Результат = СоответствиеПредставленийТребованиям(СтрокаДерева)[СтрокаДерева.Требование];
	КонецЕсли;
	Возврат Результат;

КонецФункции

#КонецОбласти