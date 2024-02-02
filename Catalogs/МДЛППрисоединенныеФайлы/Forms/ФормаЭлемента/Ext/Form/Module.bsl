﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	Если Объект.Ссылка.Пустая() Тогда
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	ТекстСообщения = ИнтеграцияМДЛПВызовСервера.ТекстСообщенияИзПротокола(Объект.Ссылка);
	ТекстСообщения = ИнтеграцияМДЛП.ФорматироватьТекстСообщения(ТекстСообщения);
	
	ТекстовыйДокументТекстСообщения.УстановитьТекст(ТекстСообщения);
	
	РежимОтладки = ОбщегоНазначенияКлиентСервер.РежимОтладки();
	ТолькоПросмотр = Не РежимОтладки;
	
	УстановитьДоступностьПодтвержденияОтправки();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПодтвердитьПередачу(Команда)
	
	Обработчик = Новый ОписаниеОповещения("ОбработатьРезультатПодтвержденияОтменыПередачи", ЭтотОбъект);
	ИнтеграцияМДЛПКлиент.ПодтвердитьПередачу(Объект.Ссылка, Обработчик);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтменитьПередачу(Команда)
	
	Обработчик = Новый ОписаниеОповещения("ОбработатьРезультатПодтвержденияОтменыПередачи", ЭтотОбъект);
	ИнтеграцияМДЛПКлиент.ОтменитьПередачу(Объект.Ссылка, Обработчик);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьДоступностьПодтвержденияОтправки()
	
	Элементы.ПодтвердитьПередачу.Видимость = Ложь;
	Элементы.ОтменитьПередачу.Видимость = Ложь;
	
	Если Объект.ТипСообщения <> Перечисления.ТипыСообщенийМДЛП.Исходящее
	 Или ЗначениеЗаполнено(Объект.ИдентификаторЗапроса) Тогда
		Возврат;
	КонецЕсли;
	
	Запрос = Новый Запрос("
	|ВЫБРАТЬ
	|	Очередь.Сообщение КАК Сообщение
	|ИЗ
	|	РегистрСведений.ОчередьПередачиДанныхМДЛП КАК Очередь
	|ГДЕ
	|	Очередь.Сообщение = &Сообщение
	|");
	Запрос.УстановитьПараметр("Сообщение", Объект.Ссылка);
	
	Если Запрос.Выполнить().Пустой() Тогда
		Возврат;
	КонецЕсли;
	
	Элементы.ПодтвердитьПередачу.Видимость = Истина;
	Элементы.ОтменитьПередачу.Видимость = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработатьРезультатПодтвержденияОтменыПередачи(Изменения, ДополнительныеПараметры) Экспорт
	
	ЕстьОшибки = Ложь;
	Для Каждого Изменение Из Изменения Цикл
		Если Не ПустаяСтрока(Изменение.ТекстОшибки) Тогда
			ЕстьОшибки = Истина;
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
	Если Не ЕстьОшибки Тогда
		Прочитать();
	КонецЕсли;
	
	УстановитьДоступностьПодтвержденияОтправки();
	
КонецПроцедуры

#КонецОбласти
