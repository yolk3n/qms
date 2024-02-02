﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Идентификатор = Строка(Запись.Идентификатор);
	
	Запрос = Новый Запрос(
		"ВЫБРАТЬ
		|	ОчередьСообщенийВ1СДокументооборот.Данные КАК Данные
		|ИЗ
		|	РегистрСведений.ОчередьСообщенийВ1СДокументооборот КАК ОчередьСообщенийВ1СДокументооборот
		|ГДЕ
		|	ОчередьСообщенийВ1СДокументооборот.Идентификатор = &Идентификатор");
	Запрос.УстановитьПараметр("Идентификатор", Запись.Идентификатор);
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Если Выборка.Следующий() Тогда
		Данные = Выборка.Данные.Получить();
		Если СтрДлина(Данные) <> 0 Тогда
			ИмяВременногоФайла = ПолучитьИмяВременногоФайла("xml");
			Данные.Записать(ИмяВременногоФайла);
			
			ФайлСДанными = Новый Файл(ИмяВременногоФайла);
			Размер = ФайлСДанными.Размер() / 1024;	// Кб
			
			ТекстовыйДокумент = Новый ТекстовыйДокумент;
			ТекстовыйДокумент.Прочитать(ИмяВременногоФайла);
			ТекстСообщения = ТекстовыйДокумент.ПолучитьТекст();
			УдалитьФайлы(ИмяВременногоФайла);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	УстановитьВидимостьЭлементов();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура УстановитьВидимостьЭлементов()
	
	Элементы.ТекстСообщенияОбОшибке.Видимость = ЗначениеЗаполнено(Запись.ТекстСообщенияОбОшибке);
	
КонецПроцедуры

#КонецОбласти