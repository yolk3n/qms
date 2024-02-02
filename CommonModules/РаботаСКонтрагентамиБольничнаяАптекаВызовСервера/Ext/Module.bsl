﻿
////////////////////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС
#Область ПрограммныйИнтерфейс

// Возвращает данные контрагента по ИНН
//
// Параметры:
//  СтрокаИНН - Строка - строка состоящая из 10 или 12 цифр
//
// Возвращаемое значение
//  Структура - состав полей зависит от вида контрагента
//
Функция ПолучитьРеквизитыПоИНН(Знач СтрокаИНН) Экспорт
	
	ЭтоЮридическоеЛицо = (СтрДлина(СтрокаИНН) = 10);
	ТекстСообщения = "";
	Если Не РегламентированныеДанныеКлиентСервер.ИННСоответствуетТребованиям(СтрокаИНН, ЭтоЮридическоеЛицо, ТекстСообщения) Тогда
		Возврат Новый Структура("ОписаниеОшибки", ТекстСообщения);
	КонецЕсли;
	
	Если ЭтоЮридическоеЛицо Тогда
		СведенияОЮридическомЛицеПоИНН = РаботаСКонтрагентами.СведенияОЮридическомЛицеПоИНН(СтрокаИНН);
		РеквизитыКонтрагента = ОбщегоНазначенияКлиентСервер.СвойствоСтруктуры(СведенияОЮридическомЛицеПоИНН, "ЕГРЮЛ");
	Иначе
		РеквизитыКонтрагента = РаботаСКонтрагентами.РеквизитыПредпринимателяПоИНН(СтрокаИНН);
	КонецЕсли;
	
	Если РеквизитыКонтрагента.Свойство("ИсторияРеквизитов") Тогда
		РеквизитыКонтрагента.Удалить("ИсторияРеквизитов");
	КонецЕсли;
	
	ВидДеятельности = ОбщегоНазначенияКлиентСервер.СвойствоСтруктуры(РеквизитыКонтрагента, "ВидДеятельности");
	Если ВидДеятельности <> Неопределено Тогда
		РеквизитыКонтрагента.Вставить("КодОКВЭД", ВидДеятельности.Код);
		РеквизитыКонтрагента.Вставить("ЭтоОКВЭД2", ВидДеятельности.Классификатор = "ОКВЭД2");
	КонецЕсли;
	
	Если РеквизитыКонтрагента.Свойство("ОткрытыеГосударственныеДанныеФНС") Тогда
		РеквизитыКонтрагента.Удалить("ОткрытыеГосударственныеДанныеФНС");
	КонецЕсли;
	
	Если РеквизитыКонтрагента.Свойство("ДанныеРуководителей")
		И РеквизитыКонтрагента.ДанныеРуководителей <> Неопределено
		И РеквизитыКонтрагента.ДанныеРуководителей.Свойство("СкрытыеДанные")
		И РеквизитыКонтрагента.ДанныеРуководителей.СкрытыеДанные = Ложь Тогда
		
		Если РеквизитыКонтрагента.ДанныеРуководителей.Руководители.Количество() > 0 Тогда
			РеквизитыКонтрагента.Вставить("Руководитель", Новый Структура("Фамилия, Имя, Отчество", "", "", ""));
			ЗаполнитьЗначенияСвойств(РеквизитыКонтрагента.Руководитель, ОбщегоНазначения.СтрокаТаблицыЗначенийВСтруктуру(РеквизитыКонтрагента.ДанныеРуководителей.Руководители[0]));
		КонецЕсли;
		
		РеквизитыКонтрагента.Удалить("ДанныеРуководителей");
		
	КонецЕсли;
	
	Если РеквизитыКонтрагента.Свойство("Руководители") Тогда
		РеквизитыКонтрагента.Удалить("Руководители");
	КонецЕсли;
	
	Возврат РеквизитыКонтрагента;
	
КонецФункции

#КонецОбласти // ПрограммныйИнтерфейс
