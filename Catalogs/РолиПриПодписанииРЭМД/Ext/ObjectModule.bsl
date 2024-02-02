﻿
Процедура ОбработкаЗаполнения(ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка)
	Если ТипЗнч(ДанныеЗаполнения) = Тип("Структура") Тогда
		Если ДанныеЗаполнения.Свойство("ПравилаПодписи") Тогда
			ЭтотОбъект.ПравилаПодписи.Очистить();
			Для Каждого Правило_ Из ДанныеЗаполнения.ПравилаПодписи Цикл 
				НоваяСтрока_ = ЭтотОбъект.ПравилаПодписи.Добавить();
				ЗаполнитьЗначенияСвойств(НоваяСтрока_, Правило_);
			КонецЦикла;
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры
