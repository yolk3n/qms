﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

////////////////////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС
#Область ПрограммныйИнтерфейс

// Функция возвращает элемент таблицы доступных печатных форм объекта печати
//
Функция ДобавитьПечатнуюФорму(ПечатныеФормы) Экспорт
	
	МетаданныеМакета = МетаданныеМакета();
	МенеджерПечати = МетаданныеМакета.Родитель().ПолноеИмя();
	
	ПечатнаяФорма = УправлениеПечатьюБольничнаяАптека.ДобавитьПечатнуюФорму(ПечатныеФормы, "ВедомостьВыдачиНФА_0504210", МенеджерПечати);
	ПечатнаяФорма.ПутьКМакету = ФормированиеПечатныхФормБольничнаяАптека.ПутьКМакету(МетаданныеМакета);
	ПечатнаяФорма.Представление = МетаданныеМакета.Представление();
	
	УправлениеПечатьюБольничнаяАптека.ДобавитьКомандуПечати(ПечатнаяФорма);
	
	Возврат ПечатнаяФорма;
	
КонецФункции

// Функция формирует печатную форму требование накладная ф.0504204
//
Функция ПечатьВедомостьВыдачиНФА_0504210(МассивОбъектов, ОбъектыПечати) Экспорт
	
	ТабличныйДокумент = Новый ТабличныйДокумент;
	
	ТабличныйДокумент.ОриентацияСтраницы = ОриентацияСтраницы.Ландшафт;
	ТабличныйДокумент.АвтоМасштаб = Истина;
	
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
		
		НомерСтрокиНачало = ТабличныйДокумент.ВысотаТаблицы + 1;
		
		// Получение параметров для заполнения
		ДанныеШапки = ПолучитьДанныеШапкиДокумента(Шапка);
		
		// Вывод области Утверждаю
		ФормированиеПечатныхФормБольничнаяАптека.ВывестиОбластьСоШтрихкодом(ТабличныйДокумент, Макет, "Утверждаю", ДанныеШапки);
		
		// Вывод области Заголовок
		ФормированиеПечатныхФормБольничнаяАптека.ВывестиОбластьПоИмени(ТабличныйДокумент, Макет, "Заголовок", ДанныеШапки);
		
		// Вывод области БухгалтерскаяЗапись
		ФормированиеПечатныхФормБольничнаяАптека.ВывестиОбластьПоИмени(ТабличныйДокумент, Макет, "БухгалтерскаяЗапись");
		
		// Вывод области Подписи
		ФормированиеПечатныхФормБольничнаяАптека.ВывестиОбластьПоИмени(ТабличныйДокумент, Макет, "Подписи", ДанныеШапки);
		
		ГраницаСтрокДанных = -1;
		
		ВыборкаПоДокументам.Сбросить();
		ПараметрыПоиска = Новый Структура("Документ", Шапка.Ссылка);
		Если ВыборкаПоДокументам.НайтиСледующий(ПараметрыПоиска) Тогда
			ВыборкаСтрокТовары = ВыборкаПоДокументам.Выбрать();
			ГраницаСтрокДанных = ВыборкаСтрокТовары.Количество() - 1;
		КонецЕсли;
		
		КоличествоКолонок = 10;
		
		ДанныеСтроки = Новый Структура;
		Для ИндексСтроки = 0 По ГраницаСтрокДанных Цикл
			
			НомерКолонки = (ИндексСтроки % КоличествоКолонок) + 1;
			
			ВыборкаСтрокТовары.Следующий();
			
			ТоварНаименование = ОбщегоНазначенияБольничнаяАптека.ПолучитьПредставлениеНоменклатурыДляПечати(
				ВыборкаСтрокТовары.ТоварНаименование,
				ВыборкаСтрокТовары.СерияНоменклатуры,
				ВыборкаСтрокТовары.Партия);
			
			ДанныеСтроки.Вставить("ТоварНаименование" + НомерКолонки, ТоварНаименование);
			ДанныеСтроки.Вставить("ТоварКод"          + НомерКолонки, ВыборкаСтрокТовары.ТоварКод);
			ДанныеСтроки.Вставить("ЕдиницаИзмерения"  + НомерКолонки, ВыборкаСтрокТовары.ЕдиницаИзмерения);
			ДанныеСтроки.Вставить("КодПоОКЕИ"         + НомерКолонки, ВыборкаСтрокТовары.КодПоОКЕИ);
			ДанныеСтроки.Вставить("Количество"        + НомерКолонки, ВыборкаСтрокТовары.Количество);
			ДанныеСтроки.Вставить("Цена"              + НомерКолонки, ВыборкаСтрокТовары.Цена);
			ДанныеСтроки.Вставить("Сумма"             + НомерКолонки, ВыборкаСтрокТовары.Сумма);
			
			Если НомерКолонки = КоличествоКолонок Или ИндексСтроки = ГраницаСтрокДанных Тогда
				
				ДанныеСтроки.Вставить("НомерСтроки", 1);
				
				// Вывод области Шапка
				ФормированиеПечатныхФормБольничнаяАптека.ВывестиОбластьПоИмени(ТабличныйДокумент, Макет, "Шапка", ДанныеСтроки);
				
				ОбластьСтрока = Макет.ПолучитьОбласть("Строка");
				ОбластьИтого = Макет.ПолучитьОбласть("Итого");
				
				// Вывод области Строка
				ОбластьСтрока.Параметры.Заполнить(ДанныеШапки);
				ОбластьСтрока.Параметры.Заполнить(ДанныеСтроки);
				ТабличныйДокумент.Вывести(ОбластьСтрока);
				
				// Вывод пустых строк до конца листа
				МассивВыводимыхОбластей = Новый Массив;
				МассивВыводимыхОбластей.Добавить(ОбластьСтрока);
				МассивВыводимыхОбластей.Добавить(ОбластьИтого);
				
				Пока ОбщегоНазначения.ПроверитьВыводТабличногоДокумента(ТабличныйДокумент, МассивВыводимыхОбластей) Цикл
					ФормированиеПечатныхФормБольничнаяАптека.ВывестиОбластьПоИмени(ТабличныйДокумент, Макет, "Строка");
				КонецЦикла;
				
				// Вывод области Итог
				ФормированиеПечатныхФормБольничнаяАптека.ВывестиОбластьПоИмени(ТабличныйДокумент, Макет, "Итого", ДанныеСтроки);
				
				ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
				
				ДанныеСтроки.Очистить();
				
			КонецЕсли;
			
		КонецЦикла;
		
		УправлениеПечатью.ЗадатьОбластьПечатиДокумента(ТабличныйДокумент, НомерСтрокиНачало, ОбъектыПечати, Шапка.Ссылка);
		
	КонецЦикла;
	
КонецПроцедуры

Функция ПолучитьДанныеШапкиДокумента(Шапка)
	
	КлючиПараметров = ФормированиеПечатныхФормБольничнаяАптека.ПолучитьИменаКолонокТаблицы(Шапка);
	
	Параметры = Новый Структура(КлючиПараметров);
	ЗаполнитьЗначенияСвойств(Параметры, Шапка);
	
	СведенияОбОрганизации    = ФормированиеПечатныхФорм.СведенияОЮрФизЛице(Шапка.Организация, Шапка.ДатаДокумента);
	ОрганизацияПредставление = ФормированиеПечатныхФорм.ОписаниеОрганизации(СведенияОбОрганизации);
	
	ОтветственныеЛица = ОтветственныеЛицаСервер.ПолучитьОтветственныеЛицаОрганизации(Шапка.Организация, Шапка.ДатаДокумента);
	МОЛОтправителя = РегистрыСведений.МатериальноОтветственныеЛица.ПолучитьДанныеОтветственного(Шапка.Склад, Шапка.ДатаДокумента);
	
	Параметры.Вставить("НомерДокумента"          , ПрефиксацияОбъектовКлиентСервер.НомерНаПечать(Шапка.НомерДокумента));
	Параметры.Вставить("РуководительФИО"         , ОтветственныеЛица.РуководительНаименование);
	Параметры.Вставить("ОрганизацияПредставление", ОрганизацияПредставление);
	Параметры.Вставить("ОрганизацияОКПО"         , СведенияОбОрганизации.КодПоОКПО);
	Параметры.Вставить("МОЛОтветственный"        , МОЛОтправителя.Ответственный);
	Параметры.Вставить("МОЛФИО"                  , МОЛОтправителя.ФИО);
	Параметры.Вставить("МОЛДолжность"            , МОЛОтправителя.Должность);
	Параметры.Вставить("БухгалтерФИО"            , ОтветственныеЛица.ГлавныйБухгалтерНаименование);
	
	Возврат Параметры;
	
КонецФункции

Функция МетаданныеМакета()
	
	Возврат Метаданные.Обработки.ПечатьВедомостьВыдачиНФА_0504210.Макеты.ПФ_MXL_ВедомостьВыдачиНФА_0504210;
	
КонецФункции

#КонецОбласти // СлужебныеПроцедурыИФункции

#КонецЕсли
