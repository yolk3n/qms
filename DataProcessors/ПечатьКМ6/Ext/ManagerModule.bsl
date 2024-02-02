﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

////////////////////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС
#Область ПрограммныйИнтерфейс

// Функция возвращает элемент таблицы доступных печатных форм объекта печати
//
Функция ДобавитьПечатнуюФорму(ПечатныеФормы) Экспорт
	
	МетаданныеМакета = МетаданныеМакета();
	МенеджерПечати = МетаданныеМакета.Родитель().ПолноеИмя();
	
	ПечатнаяФорма = УправлениеПечатьюБольничнаяАптека.ДобавитьПечатнуюФорму(ПечатныеФормы, "КМ6", МенеджерПечати);
	ПечатнаяФорма.ПутьКМакету = ФормированиеПечатныхФормБольничнаяАптека.ПутьКМакету(МетаданныеМакета);
	ПечатнаяФорма.Представление = МетаданныеМакета.Представление();
	
	УправлениеПечатьюБольничнаяАптека.ДобавитьКомандуПечати(ПечатнаяФорма);
	
	Возврат ПечатнаяФорма;
	
КонецФункции

// Функция формирует печатную форму Накладная на перемещение
//
Функция ПечатьКМ6(МассивОбъектов, ОбъектыПечати) Экспорт
	
	ТабличныйДокумент = Новый ТабличныйДокумент;
	
	ТабличныйДокумент.ОриентацияСтраницы = ОриентацияСтраницы.Портрет;
	ТабличныйДокумент.АвтоМасштаб        = Истина;
	
	ПолноеИмяМакета = ФормированиеПечатныхФормБольничнаяАптека.ПутьКМакету(МетаданныеМакета());
	ТабличныйДокумент.ИмяПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_" + ПолноеИмяМакета;
	Макет = УправлениеПечатью.МакетПечатнойФормы(ПолноеИмяМакета);
	
	СтруктураТипов = ОбщегоНазначенияБольничнаяАптека.РазложитьМассивСсылокПоТипам(МассивОбъектов);
	
	НомерТипаДокумента = 0;
	Для Каждого СтруктураОбъектов Из СтруктураТипов Цикл
		
		НомерТипаДокумента = НомерТипаДокумента + 1;
		Если НомерТипаДокумента > 1 Тогда
			ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		КонецЕсли;
		
		МенеджерОбъекта = ОбщегоНазначения.МенеджерОбъектаПоПолномуИмени(СтруктураОбъектов.Ключ);
		
		ДанныеДляПечати = МенеджерОбъекта.ПолучитьДанныеДляПечати(СтруктураОбъектов.Значение);
		
		СформироватьТабличныйДокумент(ТабличныйДокумент, Макет, ДанныеДляПечати, ОбъектыПечати);
		
	КонецЦикла;
	
	Возврат ТабличныйДокумент;
	
КонецФункции

#КонецОбласти // ПрограммныйИнтерфейс

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ
#Область СлужебныеПроцедурыИФункции

Процедура СформироватьТабличныйДокумент(ТабличныйДокумент, Макет, ДанныеДляПечати, ОбъектыПечати)
	
	Шапка = ДанныеДляПечати.РезультатПоШапке.Выбрать();
	ДанныеПоЧекам = ДанныеДляПечати.ДанныеПоЧекам.Выгрузить();
	
	ПервыйДокумент = Истина;
	Пока Шапка.Следующий() Цикл
		
		ПараметрыПоиска = Новый Структура("Документ", Шапка.Ссылка);
		СтрокиДанных = ДанныеПоЧекам.НайтиСтроки(ПараметрыПоиска);
		КоличествоСтрок = СтрокиДанных.Количество();
		
		Если КоличествоСтрок > 0 Тогда
			
			Если Не ПервыйДокумент Тогда
				ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
			Иначе
				ПервыйДокумент = Ложь;
			КонецЕсли;
			
			НомерСтрокиНачало = ТабличныйДокумент.ВысотаТаблицы + 1;
			
			ДанныеШапки = ПолучитьДанныеШапкиДокумента(Шапка);
			
			// Вывод области Заголовок
			ФормированиеПечатныхФормБольничнаяАптека.ВывестиОбластьСоШтрихкодом(ТабличныйДокумент, Макет, "Заголовок", ДанныеШапки);
			
			// Вывод области ШапкаТаблицы
			ФормированиеПечатныхФормБольничнаяАптека.ВывестиОбластьПоИмени(ТабличныйДокумент, Макет, "ШапкаТаблицы");
			
			// Инициализация итогов по документу
			ДанныеИтогов = Новый Структура;
			ДанныеИтогов.Вставить("СуммаПродаж"   , 0);
			ДанныеИтогов.Вставить("СуммаВозвратов", 0);
			
			// Вывод многострочной части
			КлючиПараметров = ФормированиеПечатныхФормБольничнаяАптека.ПолучитьИменаКолонокТаблицы(ДанныеПоЧекам);
			
			ОбластьСтрока = Макет.ПолучитьОбласть("Строка");
			
			НомерСтроки = 0;
			Для Каждого СтрокаДанных Из СтрокиДанных Цикл
				
				НомерСтроки = НомерСтроки + 1;
				
				ДанныеСтроки = Новый Структура(КлючиПараметров);
				ЗаполнитьЗначенияСвойств(ДанныеСтроки, ДанныеШапки);
				ЗаполнитьЗначенияСвойств(ДанныеСтроки, СтрокаДанных);
				
				ДанныеСтроки.Вставить("НомерСтроки", НомерСтроки);
				ДанныеСтроки.Вставить("НомерСекции", "1");
				
				ОбластьСтрока.Параметры.Заполнить(ДанныеСтроки);
				
				ЭтоПоследняяСтрока = НомерСтроки = КоличествоСтрок;
				ПроверитьВыводСтроки(ТабличныйДокумент, Макет, ОбластьСтрока, ЭтоПоследняяСтрока);
				
				// Вывод области Строка
				ТабличныйДокумент.Вывести(ОбластьСтрока);
				
				ФормированиеПечатныхФормБольничнаяАптека.РассчитатьИтоги(ДанныеСтроки, ДанныеИтогов);
				
			КонецЦикла;
			
			ДанныеШапки.Вставить("СуммаПрописью", РаботаСКурсамиВалют.СформироватьСуммуПрописью(ДанныеИтогов.СуммаПродаж - ДанныеИтогов.СуммаВозвратов, Шапка.Валюта));
			
			// Вывод области Итого
			ФормированиеПечатныхФормБольничнаяАптека.ВывестиОбластьПоИмени(ТабличныйДокумент, Макет, "Итого", ДанныеИтогов);
			
			// Вывод области Подвал
			ФормированиеПечатныхФормБольничнаяАптека.ВывестиОбластьПоИмени(ТабличныйДокумент, Макет, "Подвал", ДанныеШапки);
			
			УправлениеПечатью.ЗадатьОбластьПечатиДокумента(ТабличныйДокумент, НомерСтрокиНачало, ОбъектыПечати, Шапка.Ссылка);
			
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

Функция ПолучитьДанныеШапкиДокумента(Шапка)
	
	КлючиПараметров = ФормированиеПечатныхФормБольничнаяАптека.ПолучитьИменаКолонокТаблицы(Шапка);
	
	Параметры = Новый Структура(КлючиПараметров);
	ЗаполнитьЗначенияСвойств(Параметры, Шапка);
	
	// Данные заголовка
	СведенияОбОрганизации    = ФормированиеПечатныхФорм.СведенияОЮрФизЛице(Шапка.Организация, Шапка.ДатаДокумента);
	ОрганизацияПредставление = ФормированиеПечатныхФорм.ОписаниеОрганизации(СведенияОбОрганизации);
	
	ОтветственныеЛица = ОтветственныеЛицаСервер.ПолучитьОтветственныеЛицаОрганизации(Шапка.Организация, Шапка.ДатаДокумента);
	
	Параметры.Вставить("НомерДокумента"          , ПрефиксацияОбъектовКлиентСервер.НомерНаПечать(Строка(Шапка.НомерДокумента), Ложь, Истина));
	Параметры.Вставить("ОрганизацияПредставление", ОрганизацияПредставление);
	Параметры.Вставить("ОрганизацияОКПО"         , СведенияОбОрганизации.КодПоОКПО);
	Параметры.Вставить("ОрганизацияИНН"          , СведенияОбОрганизации.ИНН);
	
	Параметры.Вставить("Руководитель"            , ОтветственныеЛица.Руководитель);
	Параметры.Вставить("РуководительФИО"         , ОтветственныеЛица.РуководительНаименование);
	Параметры.Вставить("РуководительДолжность"   , ОтветственныеЛица.РуководительДолжность);
	Параметры.Вставить("КассирОрганизации"       , ОтветственныеЛица.ГлавныйБухгалтер);
	Параметры.Вставить("КассирОрганизацииФИО"    , ОтветственныеЛица.ГлавныйБухгалтерНаименование);
	Параметры.Вставить("КассирОперационистФИО"   , ФизическиеЛицаКлиентСервер.ФамилияИнициалы(СокрЛП(Шапка.КассирККМ)));
	
	Параметры.Вставить("ПрограммаУчета"          , НСтр("ru = '1С: Предприятие 8'"));
	
	Возврат Параметры;
	
КонецФункции

Процедура ПроверитьВыводСтроки(ТабличныйДокумент, Макет, ТекущаяОбласть, ЭтоПоследняяСтрока)
	
	МассивВыводимыхОбластей = Новый Массив;
	МассивВыводимыхОбластей.Добавить(ТекущаяОбласть);
	Если ЭтоПоследняяСтрока Тогда
		МассивВыводимыхОбластей.Добавить(Макет.ПолучитьОбласть("Итого"));
		МассивВыводимыхОбластей.Добавить(Макет.ПолучитьОбласть("Подвал"));
	КонецЕсли;
	
	Если Не ОбщегоНазначения.ПроверитьВыводТабличногоДокумента(ТабличныйДокумент, МассивВыводимыхОбластей) Тогда
		ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		ТабличныйДокумент.Вывести(Макет.ПолучитьОбласть("ШапкаТаблицы"));
	КонецЕсли;
	
КонецПроцедуры

Функция МетаданныеМакета()
	
	Возврат Метаданные.Обработки.ПечатьКМ6.Макеты.ПФ_MXL_КМ6;
	
КонецФункции

#КонецОбласти // СлужебныеПроцедурыИФункции

#КонецЕсли
