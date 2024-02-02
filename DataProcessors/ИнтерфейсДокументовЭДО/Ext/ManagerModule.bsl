﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныйПрограммныйИнтерфейс

Функция ПроверитьПодписиНаСервере(МассивСообщений = Неопределено) Экспорт

	КонтекстДиагностики = ОбработкаНеисправностейБЭД.НовыйКонтекстДиагностики();
	
	Результат = ЭлектронныеДокументыЭДО.НовыйРезультатПроверкиПодписей();
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ЭлектронныеПодписи.ПодписанныйОбъект КАК ПодписанныйОбъектСсылка
		|ПОМЕСТИТЬ ВТНеВерныеПодписи
		|ИЗ
		|	РегистрСведений.ЭлектронныеПодписи КАК ЭлектронныеПодписи
		|ГДЕ
		|	ЭлектронныеПодписи.ПодписанныйОбъект ССЫЛКА Справочник.СообщениеЭДОПрисоединенныеФайлы
		|	И НЕ ЭлектронныеПодписи.ПодписьВерна
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	СообщениеЭДОПрисоединенныеФайлы.ВладелецФайла КАК ВладелецФайла
		|ИЗ
		|	ВТНеВерныеПодписи КАК ВТНеВерныеПодписи
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.СообщениеЭДОПрисоединенныеФайлы КАК СообщениеЭДОПрисоединенныеФайлы
		|		ПО ВТНеВерныеПодписи.ПодписанныйОбъектСсылка = СообщениеЭДОПрисоединенныеФайлы.Ссылка
		|ГДЕ
		|	НЕ СообщениеЭДОПрисоединенныеФайлы.ВладелецФайла.ПометкаУдаления";
	
	Если МассивСообщений <> Неопределено И МассивСообщений.Количество() > 0 Тогда
		Запрос.Текст = Запрос.Текст
		+
		"
		|И СообщениеЭДОПрисоединенныеФайлы.ВладелецФайла В (&МассивСообщений)";
		Запрос.УстановитьПараметр("МассивСообщений", МассивСообщений);
	КонецЕсли;
	
	РезультатЗапроса = Запрос.Выполнить();
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		
		СообщениеЭДО = ВыборкаДетальныеЗаписи.ВладелецФайла;
		РезультатПроверки = 
			ЭлектронныеДокументыЭДО.ПроверитьПодписиСообщения(СообщениеЭДО, КонтекстДиагностики);
		ОбщегоНазначенияКлиентСервер.ДополнитьМассив(Результат.ПодписиДляПроверки, РезультатПроверки.ПодписиДляПроверки);
		Результат.Успех = Результат.Успех Или РезультатПроверки.Успех;
		
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти

#КонецЕсли