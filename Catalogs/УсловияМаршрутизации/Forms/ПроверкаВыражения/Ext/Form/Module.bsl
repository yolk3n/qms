﻿
////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	ТекстВыражения = Параметры.Выражение;
	ИдентификаторОбъекта = Параметры.ИдентификаторОбъекта;
	
	МетаданныеОбъекта = ОбщегоНазначения.ОбъектМетаданныхПоИдентификатору(ИдентификаторОбъекта);
	Список.ОсновнаяТаблица = МетаданныеОбъекта.ПолноеИмя();
	
	Если ЗначениеЗаполнено(МетаданныеОбъекта.ПредставлениеСписка) Тогда
		Элементы.ДекорацияЗаголовок.Заголовок = МетаданныеОбъекта.ПредставлениеСписка;
	Иначе
		Элементы.ДекорацияЗаголовок.Заголовок = МетаданныеОбъекта.Синоним;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти // ОбработчикиСобытийФормы

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ
#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПроверитьВыражениеВыполнить(Команда)
	
	ПроверитьВыражение();
	
КонецПроцедуры

&НаКлиенте
Процедура ЗакрытьФорму(Команда)
	
	Если ВладелецФормы = Неопределено Тогда
		Закрыть(ТекстВыражения);
	Иначе
		ОповеститьОВыборе(ТекстВыражения);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти // ОбработчикиКомандФормы

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ФОРМЫ
#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура СписокПриАктивизацииСтроки(Элемент)
	
	Если Элемент.ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ПодключитьОбработчикОжидания("ИзменитьПредмет", 0.2, Истина);
	
КонецПроцедуры

#КонецОбласти // ОбработчикиСобытийЭлементовФормы

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ
#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ПроверитьВыражение()
	
	Попытка
		
		Выражение = "Результат = Неопределено;
					|Предмет   = Параметры.Предмет;
					|" + ТекстВыражения + ";
					|Параметры.Результат = Результат;";
		ПараметрыМетода = Новый Структура("Предмет, Результат", Предмет, Неопределено);
		ОбщегоНазначения.ВыполнитьВБезопасномРежиме(Выражение, ПараметрыМетода);
		
		Результат = ПараметрыМетода.Результат;
		Если ТипЗнч(Результат) <> Тип("Булево") Тогда
			ВызватьИсключение НСтр("ru = 'Переменной ""Результат"" необходимо присвоить значение типа ""Булево""'");
		КонецЕсли;
		
	Исключение
		Результат = Ложь;
		Информация = ИнформацияОбОшибке();
		
		Описание = "";
		Если ТипЗнч(Информация.Причина) = Тип("ИнформацияОбОшибке") Тогда
			Описание = Информация.Причина.Описание;
		Иначе
			Описание = Информация.Описание;
		КонецЕсли;
		
		РезультатПроверки = НСтр("ru = 'Ошибка'") + ":" + Символы.ПС + Описание;
		Возврат;
	КонецПопытки;
	
	РезультатПроверки = ?(Результат, НСтр("ru = 'Истина'"), НСтр("ru = 'Ложь'"));
	
КонецПроцедуры

&НаКлиенте
Процедура ИзменитьПредмет()
	
	Ссылка = Элементы.Список.ТекущаяСтрока;
	Если Ссылка = Неопределено Или Предмет = Ссылка Тогда
		Возврат;
	КонецЕсли;
	
	Предмет = Ссылка;
	Если ПроверятьАвтоматически Тогда
		ПроверитьВыражение();
	Иначе
		РезультатПроверки = "";
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти // СлужебныеПроцедурыИФункции
