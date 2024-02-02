﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПриЗаписи(Отказ)

	Если ЭтотОбъект.ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;

	Если ЭтотОбъект.ДополнительныеСвойства.Свойство("АктуализироватьСписокОтложенногоПодписания")
		И ЭтотОбъект.ДополнительныеСвойства.АктуализироватьСписокОтложенногоПодписания = Истина
	Тогда
		РегистрыСведений.ОтложенноеПодписаниеЭП.АктуализироватьСписокОтложенногоПодписания(ЭтотОбъект.Ссылка);
	КонецЕсли;
	
КонецПроцедуры


Процедура ПередЗаписью(Отказ)

	Если ЭтотОбъект.ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ЭтотОбъект.Ссылка) Тогда
	
		Если Не ЭтотОбъект.ДополнительныеСвойства.Свойство("НеУдалятьПодписиЭМД")
			Или ЭтотОбъект.ДополнительныеСвойства.НеУдалятьПодписиЭМД = Ложь
		Тогда
			Если ЗначениеЗаполнено(ЭтотОбъект.Пациент) Тогда
				ПациентИБ_ = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ЭтотОбъект.Ссылка, "Пациент");
				Если ЗначениеЗаполнено(ПациентИБ_) И ЭтотОбъект.Пациент <> ПациентИБ_ Тогда
					// Возможно было объединение дублей пациентов, дубль был удален, а в реквизит Пациент поместили верное значение,
					// т.к. в шапке СЭМД присутствуют данные пациента, включая его идентификатор, то возможно требуется пересоздание СЭМД
					// и его подписание.

					ФедеральныеВебСервисыРЭМД.УдалитьЭлектронныеПодписи(ЭтотОбъект);
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;
		
		// Определим есть ли изменения в списке ЭП.
		Запрос_ = Новый Запрос;
		Запрос_.Текст =
			"ВЫБРАТЬ
			|	ФедеральныеВебСервисыЭМДЭлектронныеПодписиЭМД.РольРЭМД КАК РольРЭМД,
			|	ФедеральныеВебСервисыЭМДЭлектронныеПодписиЭМД.Сотрудник КАК Сотрудник
			|ИЗ
			|	Справочник.ФедеральныеВебСервисыЭМД.ЭлектронныеПодписиЭМД КАК ФедеральныеВебСервисыЭМДЭлектронныеПодписиЭМД
			|ГДЕ
			|	ФедеральныеВебСервисыЭМДЭлектронныеПодписиЭМД.Ссылка = &Ссылка
			|	И НЕ ФедеральныеВебСервисыЭМДЭлектронныеПодписиЭМД.ЭтоПодписьМО";
		
		Запрос_.УстановитьПараметр("Ссылка", ЭтотОбъект.Ссылка);
		ПодписиДоЗаписи_ = Запрос_.Выполнить().Выгрузить();
		
		ЭлектронныеПодписиЭМД_ = ЭтотОбъект.ЭлектронныеПодписиЭМД.НайтиСтроки(Новый Структура("ЭтоПодписьМО", Ложь));
		
		Если ПодписиДоЗаписи_.Количество() <> ЭлектронныеПодписиЭМД_.Количество() Тогда
			
			ЭтотОбъект.ДополнительныеСвойства.Вставить("АктуализироватьСписокОтложенногоПодписания", Истина);
			
		ИначеЕсли ЭтотОбъект.ПометкаУдаления <> ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ЭтотОбъект.Ссылка, "ПометкаУдаления") Тогда
		
			ЭтотОбъект.ДополнительныеСвойства.Вставить("АктуализироватьСписокОтложенногоПодписания", Истина);
			
		Иначе
			
			Для Каждого строкаТЧ_ Из ЭлектронныеПодписиЭМД_ Цикл
				Найденные_ = ПодписиДоЗаписи_.НайтиСтроки(Новый Структура("Сотрудник, РольРЭМД", строкаТЧ_.Сотрудник, строкаТЧ_.РольРЭМД));
				
				Если Найденные_.Количество() = 0 Тогда
					ЭтотОбъект.ДополнительныеСвойства.Вставить("АктуализироватьСписокОтложенногоПодписания", Истина);
					Прервать;
				КонецЕсли;
			КонецЦикла;
		КонецЕсли;
		
	Иначе
		ЭтотОбъект.ДополнительныеСвойства.Вставить("АктуализироватьСписокОтложенногоПодписания", Истина);
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ЭтотОбъект.Ссылка) И ЭтотОбъект.ОбновитьДанныеДокументаВРЭМД = Истина Тогда
		Реквизиты_ = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(ЭтотОбъект.Ссылка, "emdrId,ОбновитьДанныеДокументаВРЭМД");
		
		Если ЭтотОбъект.emdrId <> Реквизиты_.emdrId И ЗначениеЗаполнено(ЭтотОбъект.emdrId)
			И Реквизиты_.ОбновитьДанныеДокументаВРЭМД = Истина
		Тогда
			// Записывается новый emdrId, должно быть документ зарегистрировался в РЭМД.
			ЭтотОбъект.ОбновитьДанныеДокументаВРЭМД = Ложь;
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#КонецЕсли