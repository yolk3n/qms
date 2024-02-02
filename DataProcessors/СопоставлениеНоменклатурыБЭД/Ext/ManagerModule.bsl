﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныйПрограммныйИнтерфейс

Процедура ЗаполнитьПризнакСопоставления(Запись, Знач СвойстваНоменклатурыИБ = Неопределено) Экспорт
	
	Если СвойстваНоменклатурыИБ <> Неопределено Тогда
		ЗаполнитьСвойстваСопоставления(Запись, СвойстваНоменклатурыИБ);
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Запись.Номенклатура)
		И (ЗначениеЗаполнено(Запись.Характеристика) ИЛИ НЕ Запись.ИспользоватьХарактеристики
		ИЛИ Запись.ИспользоватьХарактеристики И НЕ Запись.ОбязательноеЗаполнениеХарактеристики)
		И (ЗначениеЗаполнено(Запись.Упаковка) ИЛИ НЕ Запись.ИспользоватьУпаковки) Тогда
		Запись.Сопоставлено = Истина;
	Иначе
		Запись.Сопоставлено = Ложь;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ЗаполнитьСвойстваСопоставления(Запись, Знач СвойстваНоменклатурыИБ)
	
	Свойства = СвойстваНоменклатурыИБ.Получить(Запись.Номенклатура);
	Если Свойства <> Неопределено Тогда
		ЗаполнитьЗначенияСвойств(Запись, Свойства);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли