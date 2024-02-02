﻿
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.УправлениеДоступом

// См. УправлениеДоступомПереопределяемый.ПриЗаполненииСписковСОграничениемДоступа.
Процедура ПриЗаполненииОграниченияДоступа(Ограничение) Экспорт

	Ограничение.Текст =
	"РазрешитьЧтениеИзменение
	|ГДЕ
	|	ЗначениеРазрешено(Организация)";
	
	Ограничение.ТекстДляВнешнихПользователей =
	"РазрешитьЧтениеИзменение
	|ГДЕ
	|	ЗначениеРазрешено(Организация)";

КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом

#КонецОбласти

#КонецОбласти

#Область ОбработчикиСобытий

Процедура ОбработкаПолученияФормы(ВидФормы, Параметры, ВыбраннаяФорма, ДополнительнаяИнформация, СтандартнаяОбработка)
	
	Если ВидФормы <> "ФормаЗаписи" Тогда
		Возврат;
	КонецЕсли;
	
	КлючЗаписи = Неопределено;
	Если Не Параметры.Свойство("Ключ", КлючЗаписи)
		Или КлючЗаписи.Пустой() Тогда
		Возврат;
	КонецЕсли;
	
	СтандартнаяОбработка = Ложь;
	Параметры.Вставить("Организация", Параметры.Ключ.Организация);
	Параметры.Вставить("СоздатьНовуюНастройку", Ложь);
	ВыбраннаяФорма = КлючЗаписи.Метаданные().Формы.НастройкиВнутреннегоЭДО;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

#Область ДляВызоваИзДругихПодсистем

Процедура ВключитьИспользованиеВнутреннихДокументов(Параметры) Экспорт
	
	Параметры.ПрогрессВыполнения.ВсегоОбъектов = 1;
	
	МетаданныеОбъекта = Метаданные.Константы.ИспользоватьВнутренниеДокументыЭДО;
	ПолноеИмяОбъекта = МетаданныеОбъекта.ПолноеИмя();
	ПараметрыОтметкиВыполнения = ОбновлениеИнформационнойБазы.ДополнительныеПараметрыОтметкиОбработки();
	ОбработанныхОбъектов = 0;
	ПроблемныхОбъектов = 0;
	
	НачатьТранзакцию();
	Попытка
		
		Блокировка = Новый БлокировкаДанных;
		ЭлементБлокировки = Блокировка.Добавить(ПолноеИмяОбъекта);
		ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
		Блокировка.Заблокировать();
		
		Записать = Ложь;
		
		Менеджер = Константы.ИспользоватьВнутренниеДокументыЭДО.СоздатьМенеджерЗначения();
		Менеджер.Прочитать();
		
		ВключатьФункциональнуюОпцию = Не СтандартныеПодсистемыСервер.ЭтоБазоваяВерсияКонфигурации();
		ОбменСКонтрагентамиПереопределяемый.ВключатьФункциональнуюОпциюИспользоватьВнутренниеДокументыЭДО(ВключатьФункциональнуюОпцию);
		Если Не Менеджер.Значение И ВключатьФункциональнуюОпцию = Истина И Константы.ИспользоватьОбменЭД.Получить() Тогда
			Менеджер.Значение = Истина;
			Записать = Истина;
		КонецЕсли;
		
		Если Записать Тогда
			ОбновлениеИнформационнойБазы.ЗаписатьДанные(Менеджер);
		Иначе
			ОбновлениеИнформационнойБазы.ОтметитьВыполнениеОбработки(Менеджер, ПараметрыОтметкиВыполнения);
		КонецЕсли;
		
		ОбработанныхОбъектов = ОбработанныхОбъектов + 1;
		
		ЗафиксироватьТранзакцию();
		
	Исключение
		
		ОтменитьТранзакцию();
		ПроблемныхОбъектов = ПроблемныхОбъектов + 1;
		ТекстСообщения = НСтр("ru = 'Не удалось обработать константу ""Использовать внутренние документы"" по причине:'") 
			+ Символы.ПС + ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
		ЗаписьЖурналаРегистрации(ОбновлениеИнформационнойБазы.СобытиеЖурналаРегистрации(), УровеньЖурналаРегистрации.Ошибка,
			МетаданныеОбъекта,, ТекстСообщения);
		
	КонецПопытки;
		
	Если ОбработанныхОбъектов > 0 Тогда
		ТекстСообщения = НСтр("ru = 'Обработана константа ""Использовать внутренние документы"".'");
		ЗаписьЖурналаРегистрации(ОбновлениеИнформационнойБазы.СобытиеЖурналаРегистрации(), УровеньЖурналаРегистрации.Информация,
			МетаданныеОбъекта,, ТекстСообщения);
	КонецЕсли;
	
	Параметры.ПрогрессВыполнения.ОбработаноОбъектов = Параметры.ПрогрессВыполнения.ОбработаноОбъектов + ОбработанныхОбъектов;
	
	Параметры.ОбработкаЗавершена = Истина;
	
КонецПроцедуры

Процедура ВключитьИспользованиеВнутреннихДокументовНачальноеЗаполнение() Экспорт
	
	Менеджер = Константы.ИспользоватьВнутренниеДокументыЭДО.СоздатьМенеджерЗначения();
	Менеджер.Прочитать();
	
	ВключатьФункциональнуюОпцию = Не СтандартныеПодсистемыСервер.ЭтоБазоваяВерсияКонфигурации();
	ОбменСКонтрагентамиПереопределяемый.ВключатьФункциональнуюОпциюИспользоватьВнутренниеДокументыЭДО(ВключатьФункциональнуюОпцию);
	
	ИспользоватьОбменЭД = Константы.ИспользоватьОбменЭД.Получить();
	
	Если Не Менеджер.Значение И ВключатьФункциональнуюОпцию И ИспользоватьОбменЭД Тогда
		Менеджер.Значение = Истина;
		ОбновлениеИнформационнойБазы.ЗаписатьДанные(Менеджер);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецЕсли