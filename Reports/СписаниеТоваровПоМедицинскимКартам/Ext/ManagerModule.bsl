﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЙ ПРОГРАММНЫЙ ИНТЕРФЕЙС
#Область СлужебныйПрограммныйИнтерфейс

// Вызывает модуль менеджера отчета для заполнения его настроек.
//   Для вызова из процедуры ВариантыОтчетовПереопределяемый.НастроитьВариантыОтчетов().
//
// Параметры:
//   Настройки - Коллекция - Передается "как есть" из процедуры НастроитьВариантыОтчетов.
//   ОтчетМетаданные - ОбъектМетаданных - Метаданные отчета.
//
// Важно:
//   Для использования в модуле менеджера отчета должна быть размещена экспортная процедура по шаблону:
//      // Настройки размещения в панели отчетов.
//      //
//      // Параметры:
//      //   Настройки - Коллекция - Передается "как есть" из ВариантыОтчетовПереопределяемый.НастроитьВариантыОтчетов().
//      //       Может использоваться для получения настроек варианта этого отчета при помощи функции ВариантыОтчетов.ОписаниеВарианта().
//      //   НастройкиОтчета - СтрокаДереваЗначений - Настройки этого отчета,
//      //       уже сформированные при помощи функции ВариантыОтчетов.ОписаниеОтчета() и готовые к изменению.
//      //       См. "Свойства для изменения" процедуры ВариантыОтчетовПереопределяемый.НастроитьВариантыОтчетов().
//      //
//      // Описание:
//      //   См. ВариантыОтчетовПереопределяемый.НастроитьВариантыОтчетов().
//      //
//      // Вспомогательные методы:
//      //	НастройкиВарианта = ВариантыОтчетов.ОписаниеВарианта(Настройки, НастройкиОтчета, "<ИмяВарианта>");
//      //	ВариантыОтчетов.УстановитьРежимВыводаВПанеляхОтчетов(Настройки, НастройкиОтчета, Истина/Ложь);
//      //
//      // Примеры:
//      //
//      //  1. Установка описания варианта.
//      //	НастройкиВарианта = ВариантыОтчетов.ОписаниеВарианта(Настройки, НастройкиОтчета, "<ИмяВарианта>");
//      //	НастройкиВарианта.Описание = НСтр("ru = '<Описание>'");
//      //
//      //  2. Отключение варианта отчета.
//      //	НастройкиВарианта = ВариантыОтчетов.ОписаниеВарианта(Настройки, НастройкиОтчета, "<ИмяВарианта>");
//      //	НастройкиВарианта.Включен = Ложь;
//      //
//      Процедура НастроитьВариантыОтчета(Настройки, НастройкиОтчета) Экспорт
//      	// Код процедуры.
//      КонецПроцедуры
//
Процедура НастроитьВариантыОтчета(Настройки, НастройкиОтчета) Экспорт
	
	НастройкиОтчета.ОпределитьНастройкиФормы = Истина;
	
	НастройкиВарианта = ВариантыОтчетов.ОписаниеВарианта(Настройки, НастройкиОтчета, "Основной");
	НастройкиВарианта.Описание = НСтр("ru = 'Отчет предназначен для анализа списаний товаров на медицинские карты.'");
	
КонецПроцедуры

#КонецОбласти // СлужебныйПрограммныйИнтерфейс

#КонецЕсли