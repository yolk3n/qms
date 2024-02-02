﻿// @strict-types

#Область ОбработчикиСобытий

// Выгружает доверенность в файл.
// 
// Параметры:
//  ПараметрКоманды - СправочникСсылка.МашиночитаемыеДоверенностиОрганизаций
//  ПараметрыВыполненияКоманды - ПараметрыВыполненияКоманды
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	ПараметрыВыгрузки = ВыгрузитьДанныеДоверенности(ПараметрКоманды);
	Если ПараметрыВыгрузки = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Оповещение = Новый ОписаниеОповещения("ПослеСохраненияДоверенностиВФайл", ЭтотОбъект, ПараметрКоманды);
	ФайловаяСистемаКлиент.СохранитьФайл(Оповещение, ПараметрыВыгрузки.Адрес, ПараметрыВыгрузки.ИмяФайла);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Формирует архив с данными доверенности и помещает во временное хранилище.
// 
// Параметры:
//  Ссылка - СправочникСсылка.МашиночитаемыеДоверенностиОрганизаций
// 
// Возвращаемое значение:
//  Неопределено, Структура - результат сохранения:
// * Адрес - Строка
// * ИмяФайла - Строка
&НаСервере
Функция ВыгрузитьДанныеДоверенности(Знач Ссылка)
	
	РезультатВыгрузки = МашиночитаемыеДоверенности.ВыгрузитьДанныеДоверенности(Ссылка);
	
	Если РезультатВыгрузки.Ошибка Тогда
		ОбщегоНазначения.СообщитьПользователю(РезультатВыгрузки.ТекстОшибки);
		Возврат Неопределено;
	КонецЕсли;
	
	АдресФайла = ПоместитьВоВременноеХранилище(РезультатВыгрузки.ОписаниеФайла.ДвоичныеДанные);
	
	ПараметрыАрхива = Новый Структура;
	ПараметрыАрхива.Вставить("Адрес", АдресФайла);
	ПараметрыАрхива.Вставить("ИмяФайла", РезультатВыгрузки.ОписаниеФайла.ИмяФайла);
	
	Возврат ПараметрыАрхива;
	
КонецФункции

// Продолжение метода см. ФайловаяСистемаКлиент.СохранитьФайл.
// 
// Параметры:
//  ПолученныеФайлы - Массив из ОписаниеПереданногоФайла
//                  - Неопределено
//  Ссылка - СправочникСсылка.МашиночитаемыеДоверенностиОрганизаций
&НаКлиенте
Процедура ПослеСохраненияДоверенностиВФайл(ПолученныеФайлы, Ссылка) Экспорт
	
	Если ЗначениеЗаполнено(ПолученныеФайлы) Тогда
		ШаблонСообщения =
			НСтр("ru = 'Подписанная доверенность сохранена в файл %1 и может быть передана контрагентам любым удобным способом.'");
		ТекстСообщения = СтрШаблон(ШаблонСообщения, ПолученныеФайлы[0].ПолноеИмя);
		ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения);
		ЗаписатьФактВыгрузкиДоверенностиВФайл(Ссылка);
	КонецЕсли;
	
КонецПроцедуры

// Записывает факт выгрузки доверенности в файл в журнал регистрации.
// 
// Параметры:
//  Ссылка - СправочникСсылка.МашиночитаемыеДоверенностиОрганизаций
&НаСервере
Процедура ЗаписатьФактВыгрузкиДоверенностиВФайл(Знач Ссылка)
	
	ПараметрыЗаписи = ОбщегоНазначенияБЭД.НовыеПараметрыЗаписиВЖурналРегистрации();
	ПараметрыЗаписи.Данные = Ссылка;
	Комментарий = НСтр("ru = 'Выгрузка машиночитаемой доверенности в файл.'");
	ОбщегоНазначенияБЭД.ЗаписатьВЖурналРегистрации(Комментарий,
		ОбщегоНазначенияБЭДКлиентСервер.ПодсистемыБЭД().ОбменСКонтрагентами, УровеньЖурналаРегистрации.Информация,
		ПараметрыЗаписи);
	
КонецПроцедуры

#КонецОбласти
