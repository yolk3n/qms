﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка)
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("Структура") Тогда
		ЗаполнитьЗначенияСвойств(ЭтотОбъект, ДанныеЗаполнения);
	КонецЕсли;
	
	ИнициализироватьСправочник();
	
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	
	ДатаНачалаВеденияСкладскогоУчета = '00010101';
	
	ИнициализироватьСправочник();
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);
	
	Если ЗначениеЗаполнено(Родитель) Тогда
		ПодразделениеОрганизации = Неопределено;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ИнициализироватьСправочник()
	
	Владелец = ЗначениеНастроекБольничнаяАптекаПовтИсп.ПолучитьОрганизациюПоУмолчанию(Владелец);
	
	Если ПолучитьФункциональнуюОпцию("ВестиСкладскойУчетВОтделениях") Тогда
		ВестиСкладскойУчет = Истина;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли