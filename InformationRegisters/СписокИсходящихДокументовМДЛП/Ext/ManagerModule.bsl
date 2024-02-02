﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Добавить сообщение в регистра сведений СписокВходящихДокументовМДЛП.
//
// Параметры:
//  Данные - Структура - данные входящего документа.
//
Процедура ДобавитьОписаниеДокумента(Данные) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	НоваяЗапись = СоздатьМенеджерЗаписи();
	ЗаполнитьЗначенияСвойств(НоваяЗапись, Данные);
	
	НоваяЗапись.ЗагрузкаНеТребуется = НоваяЗапись.ЗагрузкаНеТребуется Или Не НужноЗагружатьДокумент(НоваяЗапись.ТипДокумента);
	
	НоваяЗапись.Записать();
	
КонецПроцедуры

// Устанавливает признак загрузки документа
//
// Параметры:
//  ИдентификаторДокумента - Строка - идентификатор загруженного документа
//
Процедура ОтметитьДокументЗагружен(ИдентификаторДокумента) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Набор = СоздатьНаборЗаписей();
	Набор.Отбор.ИдентификаторДокумента.Установить(ИдентификаторДокумента);
	Набор.Прочитать();
	Если Набор.Количество() = 0 Тогда
		ВызватьИсключение СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Отсутствуют данные по идентификатору документа %1 в списке исходящих документов'"), ИдентификаторДокумента);
	КонецЕсли;
	Для Каждого Запись Из Набор Цикл
		Запись.Загружен = Истина;
	КонецЦикла;
	Набор.Записать();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция НужноЗагружатьДокумент(ТипДокумента)
	
	ТипыДокументовКЗагрузке = Новый Массив;
	Если ОбщегоНазначения.ПодсистемаСуществует("ИнтеграцияМДЛП.Производство") Тогда
		ТипыДокументовКЗагрузке.Добавить(10311); // Завершение окончательной упаковки РЭ
	КонецЕсли;
	Если ОбщегоНазначения.ПодсистемаСуществует("ИнтеграцияМДЛП.РозничныеПродажи") Тогда
		ТипыДокументовКЗагрузке.Добавить(10511); // Розничная продажа ККТ
		ТипыДокументовКЗагрузке.Добавить(10521); // Отпуск по льготным рецептам РВ
		ТипыДокументовКЗагрузке.Добавить(10522); // Отпуск по льготным рецептам ККТ
		ТипыДокументовКЗагрузке.Добавить(10523); // Отпуск по льготным рецептам ККТ с отклонением
	КонецЕсли;
	Если ОбщегоНазначения.ПодсистемаСуществует("ИнтеграцияМДЛП.Склад") Тогда
		ТипыДокументовКЗагрузке.Добавить(431); // Перемещение между собственными местами деятельности
		ТипыДокументовКЗагрузке.Добавить(470); // Перемещение между собственными местами деятельности в рамках ГЛО
		ТипыДокументовКЗагрузке.Добавить(10531); // Выдача для оказания мед. помощи РВ
		ТипыДокументовКЗагрузке.Добавить(10532); // Выдача для оказания мед. помощи РВ с отклонением
		ТипыДокументовКЗагрузке.Добавить(10552); // Вывод по различным причинам РВ
		ТипыДокументовКЗагрузке.Добавить(552); // Выбытие по прочим причинам
	КонецЕсли;
	Если ОбщегоНазначения.ПодсистемаСуществует("ИнтеграцияМДЛП.ИмпортЭкспорт") Тогда
		ТипыДокументовКЗагрузке.Добавить(10300); // Эмиссия КМ РЭ
		ТипыДокументовКЗагрузке.Добавить(10319); // Упаковка и маркировка за пределами РФ РЭ
	КонецЕсли;
	
	Возврат ТипыДокументовКЗагрузке.Найти(ТипДокумента) <> Неопределено;
	
КонецФункции

#КонецОбласти

#КонецЕсли