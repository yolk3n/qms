﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

///////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ
#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка)
	
	ТипДанныхЗаполнения = ТипЗнч(ДанныеЗаполнения);
	Если ТипДанныхЗаполнения = Тип("Структура") Тогда
		ЗаполнитьПоОтбору(ДанныеЗаполнения);
	КонецЕсли;
	
	ИнициализироватьДокумент();
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	НепроверяемыеРеквизиты = Новый Массив;
	
	Если ПредварительныйРасчет Тогда
		НепроверяемыеРеквизиты.Добавить("МетодОценки");
	КонецЕсли;
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, НепроверяемыеРеквизиты);
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);
	
	ДополнительныеСвойства.Вставить("ЭтоНовый",    ЭтоНовый());
	ДополнительныеСвойства.Вставить("РежимЗаписи", РежимЗаписи);
	
	Если ДополнительныеСвойства.Свойство("ИзменитьВерсиюДокумента") Тогда
		ВерсияДокумента = ВерсияДокумента + 1;
	КонецЕсли;
	
	Если Не ЭтоНовый() И РежимЗаписи = РежимЗаписиДокумента.ОтменаПроведения И ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Ссылка, "Проведен") Тогда
		РегистрыСведений.ГраницыРасчетаСебестоимостиТоваров.СоздатьЗаданиеКРасчетуСебестоимости(Организация, НачалоМесяца(Дата), Ссылка);
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)
	
	ПроведениеБольничнаяАптека.СформироватьДвиженияПоРегистрам(ЭтотОбъект, Отказ);
	
КонецПроцедуры

#КонецОбласти // ОбработчикиСобытий

///////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ
#Область СлужебныеПроцедурыИФункции

////////////////////////////////////////////////////////////////////////////////
// Инициализация и заполнение документа
#Область ИнициализацияИЗаполнение

Процедура ИнициализироватьДокумент()
	
	Автор = Пользователи.ТекущийПользователь();
	Ответственный = Пользователи.ТекущийПользователь();
	
КонецПроцедуры

Процедура ЗаполнитьПоОтбору(ДанныеЗаполнения)
	
	Дата        = ДанныеЗаполнения.Дата;
	Организация = ДанныеЗаполнения.Организация;
	
	// Возможно только повышение статуса существующего документа: Предварительный -> Фактический.
	Если ЭтоНовый() Или ПредварительныйРасчет Тогда
		ПредварительныйРасчет = ДанныеЗаполнения.ПредварительныйРасчет;
	КонецЕсли;
	
	// Метод оценки нужен только для фактического расчета
	МетодОценки = ?(ПредварительныйРасчет, Неопределено, ДанныеЗаполнения.МетодОценки);
	
КонецПроцедуры

#КонецОбласти // ИнициализацияИЗаполнение

///////////////////////////////////////////////////////////////////////////////
// Прочее
#Область Прочее

Функция СписокРегистровДляКонтроля() Экспорт
	
	РегистрыДляКонтроля = Новый Массив;
	
	Возврат РегистрыДляКонтроля;
	
КонецФункции

#КонецОбласти // Прочее

#КонецОбласти // СлужебныеПроцедурыИФункции

#КонецЕсли