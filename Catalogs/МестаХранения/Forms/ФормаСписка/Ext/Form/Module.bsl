﻿
////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Отбор.Свойство("Владелец") Тогда
		
		Владелец = Параметры.Отбор.Владелец;
		
		ИспользоватьМестаХранения = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Владелец, "ИспользоватьМестаХранения");
		Если Не ИспользоватьМестаХранения Тогда
			
			ТекстЗаголовка = НСтр("ru = 'Для элемента: ""%Владелец%"" места хранения не используются'");
			ТекстЗаголовка = СтрЗаменить(ТекстЗаголовка, "%Владелец%", Строка(Владелец));
			
			АвтоЗаголовок = Ложь;
			Заголовок = ТекстЗаголовка;
			
			Элементы.Список.ТолькоПросмотр = Истина;
			
			Владелец = Неопределено;
			
		КонецЕсли;
		
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список, "Владелец", Владелец,,, Истина);
		
		Параметры.Отбор.Удалить("Владелец");
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти // ОбработчикиСобытийФормы
