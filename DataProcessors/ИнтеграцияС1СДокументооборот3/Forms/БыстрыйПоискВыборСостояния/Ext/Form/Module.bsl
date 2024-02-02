﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Для Каждого Состояние Из Параметры.Состояния Цикл
		Если ТипЗнч(Состояние.Значение) <> Тип("Строка") Тогда
			НовСтр = ТаблицаСостояний.Добавить();
			НовСтр.Состояние = Состояние.Представление;
			НовСтр.СостояниеID = Состояние.Значение.ID;
			НовСтр.СостояниеТип = Состояние.Значение.Тип;
		КонецЕсли;
	КонецЦикла;
	
	Для Каждого Стр Из ТаблицаСостояний Цикл
		Если ТипЗнч(Параметры.ТекущиеДанныеЗначение) = Тип("СписокЗначений") Тогда
			Для Каждого Элемент Из Параметры.ТекущиеДанныеЗначение Цикл
				Если Элемент.Значение.ID = Стр.СостояниеID
						И Элемент.Значение.Тип = Стр.СостояниеТип Тогда
					Стр.Пометка = Истина;
					Прервать;
				КонецЕсли;
			КонецЦикла;
		ИначеЕсли Параметры.ТекущиеДанныеЗначениеID = Стр.СостояниеID
				И Параметры.ТекущиеДанныеЗначениеТип = Стр.СостояниеТип Тогда
			Стр.Пометка = Истина;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыТаблицаСостояний

&НаКлиенте
Процедура ТаблицаСостоянийПередУдалением(Элемент, Отказ)
	
	Отказ = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаСостоянийПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	
	Отказ = Истина;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Готово(Команда)
	
	// Вернем СписокЗначений.
	СписокВыбораСостояний = Новый СписокЗначений;
	
	Для Каждого Стр Из ТаблицаСостояний Цикл
		Если Стр.Пометка Тогда
			Значение = ИнтеграцияС1СДокументооборотБазоваяФункциональностьКлиентСервер.ДанныеСсылочногоОбъектаДО(
				Стр.СостояниеID,
				Стр.СостояниеТип,
				Стр.Состояние);
			СписокВыбораСостояний.Добавить(Значение, Значение.Наименование);
		КонецЕсли;
	КонецЦикла;
	
	Если СписокВыбораСостояний.Количество() = 1 Тогда
		ОповеститьОВыборе(СписокВыбораСостояний[0].Значение);
	Иначе
		ОповеститьОВыборе(СписокВыбораСостояний); // если 0 - тоже здесь.
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОтметитьВсе(Команда)
	
	Для Каждого Стр Из ТаблицаСостояний Цикл
		Стр.Пометка = Истина;
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура СнятьВсе(Команда)
	
	Для Каждого Стр Из ТаблицаСостояний Цикл
		Стр.Пометка = Ложь;
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти