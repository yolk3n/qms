﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2023, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныеПроцедурыИФункции

// Записывает таблицу настроек в данные регистра по указанным измерениям.
//
// Параметры:
//   ТаблицаНастроек - ТаблицаЗначений 
//   ЗначенияИзмерений - Структура
//   ЗначенияРесурсов - Структура
//   УдалятьСтарые - Булево
//
Процедура ЗаписатьПакетНастроек(ТаблицаНастроек, ЗначенияИзмерений, ЗначенияРесурсов, УдалятьСтарые) Экспорт
	
	НаборЗаписей = СоздатьНаборЗаписей();
	Для Каждого КлючИЗначение Из ЗначенияИзмерений Цикл
		Отбор = НаборЗаписей.Отбор[КлючИЗначение.Ключ];// ЭлементОтбора
		Отбор.Установить(КлючИЗначение.Значение, Истина);
		ТаблицаНастроек.Колонки.Добавить(КлючИЗначение.Ключ);
		ТаблицаНастроек.ЗаполнитьЗначения(КлючИЗначение.Значение, КлючИЗначение.Ключ);
	КонецЦикла;
	Для Каждого КлючИЗначение Из ЗначенияРесурсов Цикл
		ТаблицаНастроек.Колонки.Добавить(КлючИЗначение.Ключ);
		ТаблицаНастроек.ЗаполнитьЗначения(КлючИЗначение.Значение, КлючИЗначение.Ключ);
	КонецЦикла;
	Если Не УдалятьСтарые Тогда
		НаборЗаписей.Прочитать();
		СтарыеЗаписи = НаборЗаписей.Выгрузить();
		ПоискПоИзмерениям = Новый Структура("ДополнительныйОтчетИлиОбработка, ИдентификаторКоманды, Пользователь");
		Для Каждого СтараяЗапись Из СтарыеЗаписи Цикл
			ЗаполнитьЗначенияСвойств(ПоискПоИзмерениям, СтараяЗапись);
			Если ТаблицаНастроек.НайтиСтроки(ПоискПоИзмерениям).Количество() = 0 Тогда
				ЗаполнитьЗначенияСвойств(ТаблицаНастроек.Добавить(), СтараяЗапись);
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	НаборЗаписей.Загрузить(ТаблицаНастроек);
	НаборЗаписей.Записать(Истина);
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли