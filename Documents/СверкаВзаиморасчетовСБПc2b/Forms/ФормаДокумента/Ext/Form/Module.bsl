﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2022, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Настройки = СверкаВзаиморасчетовСБПc2b.НастройкеСверкиВзаиморасчетов();
	Элементы.ГруппаСтраницы.Видимость = Настройки.ИспользоватьСписаниеРасходов;
	
	УстановитьОформление();
	УстановитьВидимостьДоступность();
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	Если ТекущийОбъект.Состояние <> Перечисления.СостояниеСверкиВзаиморасчетовСБПc2b.Подготовлена Тогда
		ВызватьИсключение НСтр("ru = 'Некорректные параметры формы.'");
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура СписатьКомиссию(Команда)
	
	СписатьКомиссиюНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура СверкаПоОперациям(Команда)
	
	Отбор = Новый Структура;
	Отбор.Вставить("СверкаВзаиморасчетов", Объект.Ссылка);
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("СформироватьПриОткрытии", Истина);
	ПараметрыФормы.Вставить("Отбор",                   Отбор);
	
	ОткрытьФорму(
		"Отчет.СверкаОперацийСБПc2b.ФормаОбъекта",
		ПараметрыФормы,
		ЭтотОбъект,
		ЭтотОбъект.УникальныйИдентификатор);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьОформление()
	
	Если Объект.СуммаОплатКорректна Тогда
		Элементы.ГруппаСуммаОплат.ЦветФона = ЦветаСтиля.ЦветФонаКорректногоЗначенияБИП;
	Иначе
		Элементы.ГруппаСуммаОплат.ЦветФона = ЦветаСтиля.ЦветФонаНекорректногоЗначенияБИП;
	КонецЕсли;
	
	Если Объект.СуммаВозвратовКорректна Тогда
		Элементы.ГруппаСуммаВозвратов.ЦветФона = ЦветаСтиля.ЦветФонаКорректногоЗначенияБИП;
	Иначе
		Элементы.ГруппаСуммаВозвратов.ЦветФона = ЦветаСтиля.ЦветФонаНекорректногоЗначенияБИП;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьВидимостьДоступность()
	
	Элементы.ГруппаСуммаКомиссии.ТекущаяСтраница = ?(
		ЗначениеЗаполнено(Объект.СуммаКомиссии),
		Элементы.ГруппаСуммаКомиссииЗначение,
		Элементы.ГруппаСуммаКомиссииНеРассчитана);
	Элементы.ГруппаСтраницы.ТекущаяСтраница = ?(
		ЗначениеЗаполнено(Объект.СписаниеРасходов),
		Элементы.ГруппаСписаниеРасходов,
		Элементы.ГруппаСписатьКомиссию);
	
КонецПроцедуры

&НаСервере
Процедура СписатьКомиссиюНаСервере()
	
	Объект.СписаниеРасходов = СверкаВзаиморасчетовСБПc2b.СлужебнаяСписанииРасходовКомиссии(
		Объект.НастройкаПодключения,
		Объект.НачалоПериода,
		Объект.КонецПериода,
		Объект.СуммаКомиссии);
	
	ЭтотОбъект.Записать();
	УстановитьВидимостьДоступность();
	
КонецПроцедуры

#КонецОбласти
