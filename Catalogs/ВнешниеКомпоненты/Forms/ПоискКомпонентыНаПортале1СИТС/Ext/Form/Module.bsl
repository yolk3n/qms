﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2023, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если ПустаяСтрока(Параметры.ТекстПояснения) Тогда
		ТекстПояснения = ВнешниеКомпонентыСлужебный.ПредставлениеКомпоненты(Параметры.Идентификатор, Параметры.Версия);
	Иначе 
		ТекстПояснения = Параметры.ТекстПояснения;
	КонецЕсли;
	
	Элементы.ДекорацияПояснение.Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru = '%1
		           |
		           |Компонента не загружена в программу.
		           |Загрузить?'"),
		ТекстПояснения);
	
	ДанныеАутентификацииПорталаСохранены = ДанныеАутентификацииПорталаСохранены();
	ДоступнаЗагрузкаСПортала = ВнешниеКомпонентыСлужебный.ДоступнаЗагрузкаСПортала();
	
	Элементы.ПодключитьИнтернетПоддержку.Видимость = Не ДанныеАутентификацииПорталаСохранены;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если Не ДоступнаЗагрузкаСПортала Тогда
		Отказ = Истина;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПодключитьИнтернетПоддержку(Команда = Неопределено)
	
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("ИнтернетПоддержкаПользователей") Тогда
		МодульИнтернетПоддержкаПользователейКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ИнтернетПоддержкаПользователейКлиент");
		Оповещение = Новый ОписаниеОповещения("ПослеПодключенияИнтернетПоддержки", ЭтотОбъект);
		МодульИнтернетПоддержкаПользователейКлиент.ПодключитьИнтернетПоддержкуПользователей(Оповещение, ЭтотОбъект);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Загрузить(Команда)
	
	Если Не ДанныеАутентификацииПорталаСохранены Тогда 
		ПодключитьИнтернетПоддержку();
		Возврат;
	КонецЕсли;
	
	Элементы.Загрузить.Доступность = Ложь;
	Элементы.Страницы.ТекущаяСтраница = Элементы.ДлительнаяОперация;
	
	ДлительнаяОперация = НачатьПолучениеКомпонентыСПортала(Параметры.Идентификатор, Параметры.Версия);
	
	Если ДлительнаяОперация = Неопределено Тогда 
		КраткоеПредставлениеОшибки = НСтр("ru = 'Не удалось создать фоновое задание обновления компоненты.'");
		Элементы.Страницы.ТекущаяСтраница = Элементы.Ошибка;
	КонецЕсли;
	
	ПараметрыОжидания = ДлительныеОперацииКлиент.ПараметрыОжидания(ЭтотОбъект);
	ПараметрыОжидания.ФормаВладелец = ЭтотОбъект;
	ПараметрыОжидания.ВыводитьОкноОжидания = Ложь;
	
	Оповещение = Новый ОписаниеОповещения("ПослеПолученияКомпонентыСПортала", ЭтотОбъект);
	ДлительныеОперацииКлиент.ОжидатьЗавершение(ДлительнаяОперация, Оповещение, ПараметрыОжидания);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ПослеПодключенияИнтернетПоддержки(Результат, Параметр) Экспорт
	
	Если ТипЗнч(Результат) = Тип("Структура") Тогда
		Элементы.ПодключитьИнтернетПоддержку.Видимость = Ложь;
		ДанныеАутентификацииПорталаСохранены = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ДанныеАутентификацииПорталаСохранены()
	
	Если ОбщегоНазначения.ПодсистемаСуществует("ИнтернетПоддержкаПользователей") Тогда
		МодульИнтернетПоддержкаПользователей = ОбщегоНазначения.ОбщийМодуль("ИнтернетПоддержкаПользователей");
		Возврат МодульИнтернетПоддержкаПользователей.ЗаполненыДанныеАутентификацииПользователяИнтернетПоддержки();
	КонецЕсли;
	
	Возврат Ложь;
	
КонецФункции

&НаСервере
Функция НачатьПолучениеКомпонентыСПортала(Идентификатор, Версия)
	
	Если Не ВнешниеКомпонентыСлужебный.ДоступнаЗагрузкаСПортала() Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	ПараметрыПроцедуры = ВнешниеКомпонентыСлужебный.ПараметрыКомпонентаСПортала();
	ПараметрыПроцедуры.Идентификатор = Идентификатор;
	ПараметрыПроцедуры.Версия = Версия;
	
	ПараметрыВыполнения = ДлительныеОперации.ПараметрыВыполненияВФоне(УникальныйИдентификатор);
	ПараметрыВыполнения.НаименованиеФоновогоЗадания = НСтр("ru = 'Получение внешней компоненты.'");
	
	Возврат ДлительныеОперации.ВыполнитьВФоне("ВнешниеКомпонентыСлужебный.НоваяКомпонентаСПортала",
		ПараметрыПроцедуры, ПараметрыВыполнения);
	
КонецФункции

&НаКлиенте
Процедура ПослеПолученияКомпонентыСПортала(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если Результат.Статус = "Ошибка" Тогда
		КраткоеПредставлениеОшибки = Результат.КраткоеПредставлениеОшибки;
		Элементы.Страницы.ТекущаяСтраница = Элементы.Ошибка;
	КонецЕсли;
	
	Если Результат.Статус = "Выполнено" Тогда 
		Закрыть(Истина);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти