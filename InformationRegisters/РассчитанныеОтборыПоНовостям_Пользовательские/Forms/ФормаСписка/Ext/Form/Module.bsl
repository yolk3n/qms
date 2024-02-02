﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2020, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	Если ОбработкаНовостейПовтИсп.ЕстьРольАдминистраторСистемы()
			И ОбработкаНовостейПовтИсп.ЕстьРольПолныеПрава() Тогда
		Элементы.СписокКомандаПересчитатьОтборы.Видимость = Истина;
	Иначе
		Элементы.СписокКомандаПересчитатьОтборы.Видимость = Ложь;
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура КомандаПересчитатьОтборы(Команда)

	// Удалить неправильные отборы, которые могут помешать проверке общих и пользовательских отборов.
	// В разделенном сеансе будут пересчитаны только пользовательские отборы и общие для области данных.
	ОбработкаНовостейВызовСервера.ОптимизироватьОтборыПоНовостям(Неопределено);

	// Пересчитать отборы.
	ОбработкаНовостейВызовСервера.ПересчитатьОтборыПоНовостям_Пользовательские(Неопределено, Неопределено); // По всем пользователям

КонецПроцедуры

&НаКлиенте
Процедура КомандаСкрытьОтобразитьПодсказку(Команда)

	Если Элементы.ДекорацияПодсказка.Высота = 1 Тогда
		Элементы.ДекорацияПодсказка.Высота = 5;
	Иначе
		Элементы.ДекорацияПодсказка.Высота = 1;
	КонецЕсли;

КонецПроцедуры

#КонецОбласти
