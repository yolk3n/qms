﻿
////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	// СтандартныеПодсистемы.ВерсионированиеОбъектов
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	// ЭлектронноеВзаимодействие.РаботаСНоменклатурой
	РаботаСНоменклатурой.ПриСозданииНаСервереФормаСпискаВидаНоменклатуры(ЭтотОбъект, ЭтотОбъект.КоманднаяПанель);
	// Конец ЭлектронноеВзаимодействие.РаботаСНоменклатурой
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	// ЭлектронноеВзаимодействие.РаботаСНоменклатурой
	Если ИмяСобытия = РаботаСНоменклатуройКлиент.ОписаниеОповещенийПодсистемы().ЗагрузкаКатегорий Тогда
		Если Параметр.Количество() > 0 Тогда
			Элементы.Список.ТекущаяСтрока = Параметр[0];
		КонецЕсли;
	КонецЕсли;
	// Конец ЭлектронноеВзаимодействие.РаботаСНоменклатурой
	
КонецПроцедуры

#КонецОбласти // ОбработчикиСобытийФормы

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ФОРМЫ
#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура СписокПриАктивизацииСтроки(Элемент)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

#КонецОбласти // ОбработчикиСобытийЭлементовФормы

////////////////////////////////////////////////////////////////////////////////
// СТАНДАРТНЫЕ ПОДСИСТЕМЫ
#Область СтандартныеПодсистемы

// СтандартныеПодсистемы.ПодключаемыеКоманды

&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Элементы.Список);
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат) Экспорт
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, Элементы.Список, Результат);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Элементы.Список);
КонецПроцедуры

// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

// ЭлектронноеВзаимодействие.РаботаСНоменклатурой

&НаКлиенте
Процедура Подключаемый_ПодобратьКатегорииИзСервиса(Команда)
	
	РаботаСНоменклатуройКлиент.ПодобратьКатегорииИзСервиса(ЭтотОбъект);
	
КонецПроцедуры

// Конец ЭлектронноеВзаимодействие.РаботаСНоменклатурой

#КонецОбласти // СтандартныеПодсистемы
