﻿
#Область ПрограммныйИнтерфейс

/// Проверка наличия полей у структуры, строки табличной части и т.п.
//
// Параметры:
//   Значение - Структура, СтрокаТабличнойЧасти и т.п. -
//     Объект, в котором проверяется наличие полей.
//   Поля - Строка -
//     Список имен полей (свойств, реквизитов и т.п.) через запятую.
//   Сообщение - Строка -
//     Текст исключения, которое будет возбуждено при нарушении условия.
///
Процедура __ПОЛЯ__(Значение, Поля, Сообщение = Неопределено, Арг1 = "", Арг2 = "", Арг3 = "", Арг4 = "") Экспорт
	
	__ПРОВЕРКА__(Тип("Строка") = ТипЗнч(Поля), "Второй аргумент (Поля) метода __ПОЛЯ__ должен быть строкой.");
	
	Шаблон_ = Новый Структура(Поля);
	Отказ_ = Ложь;
	
	Попытка
		
		ЗаполнитьЗначенияСвойств(Шаблон_, Значение);
		
		НеЗаполнено_ = '05710422152926';
		
		Для Каждого КлючИЗначение_ Из Шаблон_ Цикл
			Если Неопределено = КлючИЗначение_.Значение Тогда
				Отказ_ = Истина;
				Шаблон_[КлючИЗначение_.Ключ] = НеЗаполнено_;
			КонецЕсли;
		КонецЦикла;
		
		Если Истина = Отказ_ Тогда
			
			Отказ_ = Ложь;
			ЗаполнитьЗначенияСвойств(Шаблон_, Значение);
			
			Для Каждого КлючИЗначение_ Из Шаблон_ Цикл
				Если НеЗаполнено_ = КлючИЗначение_.Значение Тогда
					Отказ_ = Истина;
				КонецЕсли;
			КонецЦикла;
		
		КонецЕсли;
		
		Если Ложь = Отказ_ Тогда
			Возврат;
		КонецЕсли;
		
	Исключение
		
	КонецПопытки;
	
	Сообщение_ = Сообщение;
	
	Если Неопределено = Сообщение_ Тогда
		Сообщение_ =
			"Ошибка проверки наличия полей.
			|Значение не содержит полей из списка:
			|{" + Поля + "}."
		;
	КонецЕсли;
	
	__ПРОВЕРКА__(Ложь, Сообщение_, Арг1, Арг2, Арг3, Арг4);
	
КонецПроцедуры

/// Проверка соответствия значения типу
//
// Если тип значения не соответствует списку типов, возбуждается исключение с текстом Сообщение.
//
// Параметры:
//   Значение - Произвольный -
//     Проверяемое значение.
//   СписокТипов - Строка, Тип, ОписаниеТипов -
//     Объект Тип, объект ОписаниеТипов или строка с именами типов, разделенными запятыми.
//     После запятой допускется пробел.
//   Сообщение - Строка -
//     Сообщение, которое будет выдаваться вместе с исключением.
///
Процедура __ТИП__(Значение, СписокТипов, Сообщение = Неопределено, Арг1 = "", Арг2 = "", Арг3 = "", Арг4 = "") Экспорт
	
	__ПРОВЕРКА__(ТипЗнч(СписокТипов) = Тип("Строка") Или ТипЗнч(СписокТипов) = Тип("Тип") Или ТипЗнч(СписокТипов) = Тип("ОписаниеТипов"), "Второй аргумент (СписокТипов) метода __ТИП__ должен быть строкой, объектом Тип или объектом ОписаниеТипов.");
	
	Если ТипЗнч(СписокТипов) = Тип("ОписаниеТипов") Тогда
		
		Если СписокТипов.СодержитТип(ТипЗнч(Значение)) Тогда
			Возврат;
		КонецЕсли;
		
	ИначеЕсли ТипЗнч(СписокТипов) = Тип("Тип") Тогда
		
		Если ТипЗнч(Значение) = СписокТипов Тогда
			Возврат;
		КонецЕсли;
		
	ИначеЕсли Значение = Неопределено Тогда
		
		Если Не 0 = Найти(СписокТипов, "Неопределено") Тогда
			ИменаТипов_ = СтрРазделить(СтрЗаменить(СписокТипов, " ", ""), ",");
			Если Не Неопределено = ИменаТипов_.Найти("Неопределено") Тогда
				Возврат;
			КонецЕсли;
		КонецЕсли;
		
	Иначе
		
		ОписаниеТипов_ = Новый ОписаниеТипов(СписокТипов);
		Если ОписаниеТипов_.СодержитТип(ТипЗнч(Значение)) Тогда
			Возврат;
		КонецЕсли;
		
	КонецЕсли;
	
	Сообщение_ =
		"Ошибка проверки типов.
		|Тип '" + ТипЗнч(Значение) + "' значения '" + Значение + "'
		|не входит в множество допустимых типов
		|{" + СписокТипов + "}."
	;

	Если Не Неопределено = Сообщение Тогда
		Сообщение_ = Сообщение + Символы.ПС + Сообщение_;
	КонецЕсли;
	
	__ПРОВЕРКА__(Ложь, Сообщение_, Арг1, Арг2, Арг3, Арг4);
	
КонецПроцедуры

/// Проверка выполнения заданного условия
//   Процедура проверяет условие проверки и, если оно не выполняется,
//   возбуждает исключение.
//   Процедура является эквивалентом функции assert в языке C.
//
// Параметры:
//   УсловиеПроверки - Булево -
//     Условие, котрое должно иметь значение Истина.
//   Сообщение - Строка -
//     Сообщение, которое будет выдаваться вместе с исключением.
///
Процедура __СТРАЖ__(Условие, Сообщение = Неопределено, Арг1 = "", Арг2 = "", Арг3 = "", Арг4 = "") Экспорт
	
	Если Не Условие = Истина Тогда
		
		ТекстСообщения_ = Сообщение;
		Если Не ЗначениеЗаполнено(ТекстСообщения_) Тогда
			ТекстСообщения_ = "DEBUG:СТРАЖ";
		КонецЕсли;
		ТекстСообщения_ = СтрЗаменить(ТекстСообщения_, "%1", Арг1);
		ТекстСообщения_ = СтрЗаменить(ТекстСообщения_, "%2", Арг2);
		ТекстСообщения_ = СтрЗаменить(ТекстСообщения_, "%3", Арг3);
		ТекстСообщения_ = СтрЗаменить(ТекстСообщения_, "%4", Арг4);
		
		#Если Сервер Тогда
			ЗаписьЖурналаРегистрации("DEBUG:СТРАЖ", УровеньЖурналаРегистрации.Ошибка, , , ТекстСообщения_);
		#КонецЕсли
		
		Сообщение_ = Новый СообщениеПользователю;
		Сообщение_.Текст = ТекстСообщения_;
		Сообщение_.Сообщить();
		
		ВызватьИсключение (ТекстСообщения_);
		
	КонецЕсли;
	
КонецПроцедуры

/// Устарешвая функция, используйте __СТРАЖ__
Процедура __ПРОВЕРКА__(УсловиеПроверки, Сообщение = Неопределено, Арг1 = "", Арг2 = "", Арг3 = "", Арг4 = "") Экспорт
	
	__СТРАЖ__(УсловиеПроверки, Сообщение, Арг1, Арг2, Арг3, Арг4);
	
КонецПроцедуры
#КонецОбласти
