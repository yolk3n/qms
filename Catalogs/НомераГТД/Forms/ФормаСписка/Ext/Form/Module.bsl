﻿
///////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	Если Параметры.Свойство("Отбор") И Параметры.Отбор.Свойство("Владелец") Тогда
		
		Если Не Параметры.Отбор.Владелец.ВестиУчетПоГТД Тогда
			
			ТекстЗаголовка = НСтр("ru = 'Для элемента: ""%Владелец%"" номера ГТД не используются'");
			ТекстЗаголовка = СтрЗаменить(ТекстЗаголовка, "%Владелец%", Строка(Параметры.Отбор.Владелец));
			
			АвтоЗаголовок = Ложь;
			Заголовок     = ТекстЗаголовка;
			
			Элементы.Список.ТолькоПросмотр = Истина;
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти // ОбработчикиСобытийФормы
