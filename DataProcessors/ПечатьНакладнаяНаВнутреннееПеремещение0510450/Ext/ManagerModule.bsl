﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

////////////////////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС
#Область ПрограммныйИнтерфейс

// Функция возвращает элемент таблицы доступных печатных форм объекта печати
//
Функция ДобавитьПечатнуюФорму(ПечатныеФормы) Экспорт
	
	МетаданныеМакета = МетаданныеМакета();
	МенеджерПечати = МетаданныеМакета.Родитель().ПолноеИмя();
	
	ПечатнаяФорма = УправлениеПечатьюБольничнаяАптека.ДобавитьПечатнуюФорму(ПечатныеФормы, "НакладнаяНаВнутреннееПеремещение0510450", МенеджерПечати);
	ПечатнаяФорма.ПутьКМакету = ФормированиеПечатныхФормБольничнаяАптека.ПутьКМакету(МетаданныеМакета);
	ПечатнаяФорма.Представление = МетаданныеМакета.Представление();
	
	УправлениеПечатьюБольничнаяАптека.ДобавитьКомандуПечати(ПечатнаяФорма);
	
	Возврат ПечатнаяФорма;
	
КонецФункции

// Функция формирует печатную форму требование накладная ф.0510450
//
Функция ПечатьНакладнаяНаВнутреннееПеремещение0510450(МассивОбъектов, ОбъектыПечати) Экспорт
	
	ТабличныйДокумент = Новый ТабличныйДокумент;
	
	ТабличныйДокумент.ОриентацияСтраницы = ОриентацияСтраницы.Ландшафт;
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
		
		ПараметрыПечати = Новый Структура;
		ПараметрыПечати.Вставить("ПолучатьЦены");
		ДанныеДляПечати = МенеджерОбъекта.ПолучитьДанныеДляПечати(СтруктураОбъектов.Значение, ПараметрыПечати);
		
		СформироватьТабличныйДокумент(ТабличныйДокумент, Макет, ДанныеДляПечати, ОбъектыПечати);
		
	КонецЦикла;
	
	Возврат ТабличныйДокумент;
	
КонецФункции

#КонецОбласти // ПрограммныйИнтерфейс

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ
#Область СлужебныеПроцедурыИФункции

Процедура СформироватьТабличныйДокумент(ТабличныйДокумент, Макет, ДанныеДляПечати, ОбъектыПечати)
	
	МассивВыводимыхОбластей = Новый Массив;
	
	ВалютаПечати = ЗначениеНастроекБольничнаяАптекаПовтИсп.ПолучитьВалютуРегламентированногоУчета();
	
	Шапка = ДанныеДляПечати.РезультатПоШапке.Выбрать();
	ВыборкаПоДокументам = ДанныеДляПечати.РезультатПоТабличнойЧасти.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	
	ПервыйДокумент = Истина;
	Пока Шапка.Следующий() Цикл
		
		Если Не ПервыйДокумент Тогда
			ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		Иначе
			ПервыйДокумент = Ложь;
		КонецЕсли;
		
		ШтрихкодированиеПечатныхФорм.ВывестиШтрихкодВТабличныйДокумент(Шапка.Ссылка, ТабличныйДокумент, Макет);
		
		НомерСтрокиНачало = ТабличныйДокумент.ВысотаТаблицы + 1;
		
		// Получение параметров для заполнения
		ДанныеШапки = ПолучитьДанныеШапкиДокумента(Шапка);
		
		// Вывод области Заголовок
		ФормированиеПечатныхФормБольничнаяАптека.ВывестиОбластьПоИмени(ТабличныйДокумент, Макет, "Заголовок", ДанныеШапки);
		
		// Вывод области ШапкаТаблицы
		ФормированиеПечатныхФормБольничнаяАптека.ВывестиОбластьПоИмени(ТабличныйДокумент, Макет, "ШапкаТаблицы");
		
		// Инициализация итогов по документу
		ПараметрыИтого = Новый Структура;
		ПараметрыИтого.Вставить("Количество", 0);
		ПараметрыИтого.Вставить("Сумма"     , 0);
		
		ВыборкаПоДокументам.Сбросить();
		ПараметрыПоиска = Новый Структура("Документ", Шапка.Ссылка);
		Если ВыборкаПоДокументам.НайтиСледующий(ПараметрыПоиска) Тогда
			ВыборкаСтрокТовары = ВыборкаПоДокументам.Выбрать();
			
			КлючиПараметров = ФормированиеПечатныхФормБольничнаяАптека.ПолучитьИменаКолонокТаблицы(ВыборкаСтрокТовары);
			
			ОбластьСтрока = Макет.ПолучитьОбласть("Строка");
			
			КоличествоСтрок = ВыборкаСтрокТовары.Количество();
			НомерСтроки = 0;
			Пока ВыборкаСтрокТовары.Следующий() Цикл
				
				НомерСтроки = НомерСтроки + 1;
				
				ДанныеСтроки = Новый Структура(КлючиПараметров);
				ЗаполнитьЗначенияСвойств(ДанныеСтроки, ВыборкаСтрокТовары);
				
				ТоварНаименование = ОбщегоНазначенияБольничнаяАптека.ПолучитьПредставлениеНоменклатурыДляПечати(
					ВыборкаСтрокТовары.ТоварНаименование,
					ВыборкаСтрокТовары.СерияНоменклатуры,
					ВыборкаСтрокТовары.Партия);
				
				ДанныеСтроки.Вставить("ТоварНаименование", ТоварНаименование);
				
				ОбластьСтрока.Параметры.Заполнить(ДанныеСтроки);
				
				ЭтоПоследняяСтрока = НомерСтроки = КоличествоСтрок;
				ПроверитьВыводСтроки(ТабличныйДокумент, Макет, МассивВыводимыхОбластей, ОбластьСтрока, ЭтоПоследняяСтрока);
				
				// Вывод области Строка
				ТабличныйДокумент.Вывести(ОбластьСтрока);
				
				ФормированиеПечатныхФормБольничнаяАптека.РассчитатьИтоги(ДанныеСтроки, ПараметрыИтого);
				
			КонецЦикла;
		КонецЕсли;
		
		// Вывод области Итого
		ФормированиеПечатныхФормБольничнаяАптека.ВывестиОбластьПоИмени(ТабличныйДокумент, Макет, "Итого", ПараметрыИтого);
		
		// Вывод области Подписи
		ФормированиеПечатныхФормБольничнаяАптека.ВывестиОбластьПоИмени(ТабличныйДокумент, Макет, "Подписи", ДанныеШапки);
		
		УправлениеПечатью.ЗадатьОбластьПечатиДокумента(ТабличныйДокумент, НомерСтрокиНачало, ОбъектыПечати, Шапка.Ссылка);
		
	КонецЦикла;
	
КонецПроцедуры

Функция ПолучитьДанныеШапкиДокумента(Шапка)
	
	КлючиПараметров = ФормированиеПечатныхФормБольничнаяАптека.ПолучитьИменаКолонокТаблицы(Шапка);
	
	Параметры = Новый Структура(КлючиПараметров);
	ЗаполнитьЗначенияСвойств(Параметры, Шапка);
	
	// Данные заголовка
	СведенияОбОрганизации = ФормированиеПечатныхФорм.СведенияОЮрФизЛице(Шапка.Организация,  Шапка.ДатаДокумента);
	
	Параметры.Вставить("НомерДокумента",           ПрефиксацияОбъектовКлиентСервер.НомерНаПечать(Шапка.НомерДокумента));
	Параметры.Вставить("ОрганизацияПредставление", ФормированиеПечатныхФорм.ОписаниеОрганизации(СведенияОбОрганизации));
	Параметры.Вставить("ОрганизацияОКПО",          СведенияОбОрганизации.КодПоОКПО);
	
	// Данные подписей документа
	МОЛОтправителя = РегистрыСведений.МатериальноОтветственныеЛица.ПолучитьДанныеОтветственного(Шапка.СкладОтправитель, Шапка.ДатаДокумента);
	МОЛПолучателя  = РегистрыСведений.МатериальноОтветственныеЛица.ПолучитьДанныеОтветственного(Шапка.СкладПолучатель, Шапка.ДатаДокумента);
	
	Параметры.Вставить("ОтправительФИО",       МОЛОтправителя.ФИО);
	Параметры.Вставить("ОтправительДолжность", МОЛОтправителя.Должность);
	Параметры.Вставить("ПолучательФИО",        МОЛПолучателя.ФИО);
	Параметры.Вставить("ПолучательДолжность",  МОЛПолучателя.Должность);
	
	Возврат Параметры;
	
КонецФункции

Процедура ПроверитьВыводСтроки(ТабличныйДокумент, Макет, МассивВыводимыхОбластей, ТекущаяОбласть, ЭтоПоследняяСтрока)
	
	МассивВыводимыхОбластей.Очистить();
	МассивВыводимыхОбластей.Добавить(ТекущаяОбласть);
	Если ЭтоПоследняяСтрока Тогда
		МассивВыводимыхОбластей.Добавить(Макет.ПолучитьОбласть("Итого"));
		МассивВыводимыхОбластей.Добавить(Макет.ПолучитьОбласть("Подписи"));
	КонецЕсли;
	
	Если Не ОбщегоНазначения.ПроверитьВыводТабличногоДокумента(ТабличныйДокумент, МассивВыводимыхОбластей) Тогда
		ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		ТабличныйДокумент.Вывести(Макет.ПолучитьОбласть("ШапкаТаблицы"));
	КонецЕсли;
	
КонецПроцедуры

Функция МетаданныеМакета()
	
	Возврат Метаданные.Обработки.ПечатьНакладнаяНаВнутреннееПеремещение0510450.Макеты.ПФ_MXL_НакладнаяНаВнутреннееПеремещение0510450;
	
КонецФункции

#КонецОбласти // СлужебныеПроцедурыИФункции

#КонецЕсли
