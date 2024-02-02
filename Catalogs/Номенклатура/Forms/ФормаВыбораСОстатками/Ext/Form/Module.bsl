﻿
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	
	Если Параметры.Свойство("Организация") Тогда
		Список.Параметры.УстановитьЗначениеПараметра("Организация",Параметры.Организация);
	Иначе
		Список.Параметры.УстановитьЗначениеПараметра("Организация",Справочники.Организации.ПустаяСсылка());
	КонецЕсли;
	
	Если Параметры.Свойство("Склад") Тогда
		Список.Параметры.УстановитьЗначениеПараметра("Склад",Параметры.Склад);
	Иначе
		Список.Параметры.УстановитьЗначениеПараметра("Склад",Справочники.Склады.ПустаяСсылка());
	КонецЕсли;
	
	Если Параметры.Свойство("ИсточникФинансирования") Тогда
		Список.Параметры.УстановитьЗначениеПараметра("ИсточникФинансирования",Параметры.ИсточникФинансирования);
	Иначе
		Список.Параметры.УстановитьЗначениеПараметра("ИсточникФинансирования",Справочники.ИсточникиФинансирования.ПустаяСсылка());
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СписокВыборЗначения(Элемент, Значение, СтандартнаяОбработка)
	
	ЭтотОбъект.Закрыть(Элементы.Список.ТекущиеДанные.Ссылка);
	
КонецПроцедуры
