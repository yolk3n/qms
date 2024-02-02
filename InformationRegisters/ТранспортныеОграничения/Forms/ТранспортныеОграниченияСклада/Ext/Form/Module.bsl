﻿
////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("Отбор") И Параметры.Отбор.Свойство("Склад") Тогда
		
		Склад = Параметры.Отбор.Склад;
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(ТранспортныеОграничения, "Склад", Склад,,, ЗначениеЗаполнено(Склад));
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти // ОбработчикиСобытийФормы

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ
#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПереместитьЭлементВверх(Команда)
	
	Если Элементы.ТранспортныеОграничения.ТекущаяСтрока <> Неопределено Тогда
		
		ПереместитьЭлементВверхНаСервере(Элементы.ТранспортныеОграничения.ТекущаяСтрока);
		Элементы.ТранспортныеОграничения.Обновить();
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПереместитьЭлементВниз(Команда)
	
	Если Элементы.ТранспортныеОграничения.ТекущаяСтрока <> Неопределено Тогда
		
		ПереместитьЭлементВнизНаСервере(Элементы.ТранспортныеОграничения.ТекущаяСтрока);
		Элементы.ТранспортныеОграничения.Обновить();
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти // ОбработчикиКомандФормы

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ
#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ПереместитьЭлементВверхНаСервере(КлючЗаписи)
	
	МенеджерЗаписи = РегистрыСведений.ТранспортныеОграничения.СоздатьМенеджерЗаписи();
	
	МенеджерЗаписи.Склад = КлючЗаписи.Склад;
	МенеджерЗаписи.Номенклатура = КлючЗаписи.Номенклатура;
	МенеджерЗаписи.СпособПополненияЗапаса = КлючЗаписи.СпособПополненияЗапаса;
	
	МенеджерЗаписи.Прочитать();
	
	Если МенеджерЗаписи.РеквизитДопУпорядочивания > 1 Тогда
		
		МенеджерЗаписи.РеквизитДопУпорядочивания = МенеджерЗаписи.РеквизитДопУпорядочивания - 1;
		МенеджерЗаписи.Записать();
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПереместитьЭлементВнизНаСервере(КлючЗаписи)
	
	МенеджерЗаписи = РегистрыСведений.ТранспортныеОграничения.СоздатьМенеджерЗаписи();
	
	МенеджерЗаписи.Склад = КлючЗаписи.Склад;
	МенеджерЗаписи.Номенклатура = КлючЗаписи.Номенклатура;
	МенеджерЗаписи.СпособПополненияЗапаса = КлючЗаписи.СпособПополненияЗапаса;
	
	МенеджерЗаписи.Прочитать();
	
	МенеджерЗаписи.РеквизитДопУпорядочивания = МенеджерЗаписи.РеквизитДопУпорядочивания + 1;
	МенеджерЗаписи.Записать();
	
КонецПроцедуры

#КонецОбласти // СлужебныеПроцедурыИФункции
