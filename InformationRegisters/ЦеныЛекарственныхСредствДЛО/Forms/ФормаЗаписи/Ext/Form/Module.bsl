﻿
////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Перем ЗначениеИзСтруктуры;
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(Запись, ЭтотОбъект);
	
	Если Не Параметры.Ключ.Пустой() Тогда
		
		Если Не ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Запись.КАТ, "НомерРЛС") = 0 Тогда
			ТолькоПросмотр = Истина;
		КонецЕсли;
		
	Иначе
		
		Если Параметры.ЗначенияЗаполнения.Свойство("КАТ", ЗначениеИзСтруктуры) И ЗначениеЗаполнено(ЗначениеИзСтруктуры) Тогда
			Если Не ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ЗначениеИзСтруктуры, "НомерРЛС") = 0 Тогда
				ВызватьИсключение НСтр("ru = 'Заполнение цен ДЛО данного препарата происходит при обновлении из базы РЛС.'");
			КонецЕсли;
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти // ОбработчикиСобытийФормы
