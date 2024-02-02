﻿
////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ
#Область ОбработчикиСобытий

// Обработчик подписки на событие ОбработкаПолученияФормы для переопределения формы номенклатуры поставщика.
//
// Параметры:
//  Источник                 - СправочникМенеджер - менеджер справочника.
//  ВидФормы                 - Строка - имя стандартной формы.
//  Параметры                - Структура - параметры формы.
//  ВыбраннаяФорма           - Строка - имя или объект метаданных открываемой формы.
//  ДополнительнаяИнформация - Структура - дополнительная информация открытия формы.
//  СтандартнаяОбработка     - Булево - признак выполнения стандартной (системной) обработки события.
//
Процедура ПереопределитьПолучаемуюФормуДействующегоСправочникаЛС(Источник, ВидФормы, Параметры, ВыбраннаяФорма, ДополнительнаяИнформация, СтандартнаяОбработка) Экспорт
	
	Если Не ПолучитьФункциональнуюОпцию("УчаствоватьВПроектеОперативныйМониторингЛС") Тогда
		Возврат;
	КонецЕсли;
	
	Контрагент = Константы.КонтрагентДляПроектаОперативныйМониторингЛС.Получить();
	Если Не ЗначениеЗаполнено(Контрагент) Тогда
		Возврат;
	КонецЕсли;
	
	Если ВидФормы = "ФормаВыбора" Или ВидФормы = "ФормаСписка" Тогда
		
		Если Параметры.Свойство("Отбор") Тогда
			Если Параметры.Отбор.Свойство("ВладелецНоменклатуры") И Параметры.Отбор.ВладелецНоменклатуры = Контрагент Тогда
				Параметры.Отбор.Вставить("Владелец", Параметры.Отбор.ВладелецНоменклатуры);
				Параметры.Отбор.Удалить("ВладелецНоменклатуры");
				Если Параметры.Отбор.Свойство("Упаковка") Тогда
					Параметры.Отбор.Вставить("ЕдиницаИзмерения", Параметры.Отбор.Упаковка);
					Параметры.Отбор.Удалить("Упаковка");
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;
		
		Если Параметры.Свойство("Отбор") И Параметры.Отбор.Свойство("Владелец") И Параметры.Отбор.Владелец = Контрагент Тогда
			СтандартнаяОбработка = Ложь;
			Если ВидФормы = "ФормаВыбора" Тогда
				ВыбраннаяФорма = Метаданные.Обработки.ОперативныйМониторингЛС.Формы.ФормаВыбораНоменклатурыСегмента;
			Иначе
				ВыбраннаяФорма = Метаданные.Обработки.ОперативныйМониторингЛС.Формы.ДействующийСправочникЛС;
			КонецЕсли;
		КонецЕсли;
		
	ИначеЕсли ВидФормы = "ФормаОбъекта" Тогда
		
		Если Параметры.Свойство("Ключ") И ЗначениеЗаполнено(Параметры.Ключ) Тогда
			Если ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Параметры.Ключ, "Владелец") = Контрагент
			 Или ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Параметры.Ключ, "ВладелецНоменклатуры") = Контрагент Тогда
				СтандартнаяОбработка = Ложь;
			КонецЕсли;
		ИначеЕсли Параметры.Свойство("ЗначенияЗаполнения")
			И (Параметры.ЗначенияЗаполнения.Свойство("Владелец") И Параметры.ЗначенияЗаполнения.Владелец = Контрагент
				Или Параметры.ЗначенияЗаполнения.Свойство("ВладелецНоменклатуры") И Параметры.ЗначенияЗаполнения.ВладелецНоменклатуры = Контрагент) Тогда
			СтандартнаяОбработка = Ложь;
		КонецЕсли;
		
		Если Не СтандартнаяОбработка Тогда
			ВыбраннаяФорма = Метаданные.Обработки.ОперативныйМониторингЛС.Формы.НоменклатураСегмента;
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти // ОбработчикиСобытий