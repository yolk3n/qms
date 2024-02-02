﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

////////////////////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС
#Область ПрограммныйИнтерфейс

// Функция возвращает элемент таблицы доступных печатных форм объекта печати
//
Функция ДобавитьПечатнуюФорму(ПечатныеФормы) Экспорт
	
	МетаданныеМакета = МетаданныеМакета();
	МенеджерПечати = МетаданныеМакета.Родитель().ПолноеИмя();
	
	ПечатнаяФорма = УправлениеПечатьюБольничнаяАптека.ДобавитьПечатнуюФорму(ПечатныеФормы, "АктОПриемеПередаче0510434", МенеджерПечати);
	ПечатнаяФорма.ПутьКМакету = ФормированиеПечатныхФормБольничнаяАптека.ПутьКМакету(МетаданныеМакета);
	ПечатнаяФорма.Представление = МетаданныеМакета.Представление();
	
	Возврат ПечатнаяФорма;
	
КонецФункции

// Функция формирует печатную форму акт о приемке-передаче ф.0510434
//
Функция ПечатьАктОПриемеПередаче0510434(МассивОбъектов, ОбъектыПечати, ПараметрыПечати = Неопределено) Экспорт
	
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
		
		Параметры = Новый Структура;
		Параметры.Вставить("ПолучатьЦены");
		
		ДанныеДляПечати = МенеджерОбъекта.ПолучитьДанныеДляПечати(СтруктураОбъектов.Значение, Параметры);
		
		СформироватьТабличныйДокумент(ТабличныйДокумент, Макет, ДанныеДляПечати, ОбъектыПечати, ПараметрыПечати);
		
	КонецЦикла;
	
	Возврат ТабличныйДокумент;
	
КонецФункции

#КонецОбласти // ПрограммныйИнтерфейс

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ
#Область СлужебныеПроцедурыИФункции

Процедура СформироватьТабличныйДокумент(ТабличныйДокумент, Макет, ДанныеДляПечати, ОбъектыПечати, ПараметрыПечати)

	ВалютаПечати = ЗначениеНастроекБольничнаяАптекаПовтИсп.ПолучитьВалютуРегламентированногоУчета();
	
	ТаблицаКурсовВалют = Неопределено;
	ДанныеДляПечати.Свойство("ТаблицаКурсовВалют", ТаблицаКурсовВалют);
	
	Шапка = ДанныеДляПечати.РезультатПоШапке.Выбрать();
	ВыборкаПоДокументам = ДанныеДляПечати.РезультатПоТабличнойЧасти.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	
	ПоляШапки = Шапка.Владелец().Колонки;
	ЕстьКолонкаЦенаВключаетНДС  = (ПоляШапки.Найти("ЦенаВключаетНДС") <> Неопределено);
	ЕстьКолонкаПринятьНДСКВычету = (ПоляШапки.Найти("ПринятьНДСКВычету") <> Неопределено);
	
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
		
		// Инициализация нумерации
		Нумерация = ИнициализироватьНумерацию();
		
		// Вывод области ШапкаТаблицы
		ФормированиеПечатныхФормБольничнаяАптека.ВывестиОбластьПоИмени(ТабличныйДокумент, Макет, "ШапкаТаблицы_Раздел1", Нумерация);
		ОбластьСтрока = Макет.ПолучитьОбласть("Строка_Раздел1");
		
		// Инициализация итогов по документу
		ВыборкаПоДокументам.Сбросить();
		ПараметрыПоиска = Новый Структура("Документ", Шапка.Ссылка);
		Если ВыборкаПоДокументам.НайтиСледующий(ПараметрыПоиска) Тогда
			ВыборкаСтрокТовары = ВыборкаПоДокументам.Выбрать();
			
			КлючиПараметров = ФормированиеПечатныхФормБольничнаяАптека.ПолучитьИменаКолонокТаблицы(ВыборкаСтрокТовары);
			
			Если ТаблицаКурсовВалют <> Неопределено Тогда
				КоэффициентПересчета = КоэффициентПересчетаВалюты(Шапка, ТаблицаКурсовВалют, ВалютаПечати);
			Иначе
				КоэффициентПересчета = 1;
			КонецЕсли;
			
			КоличествоСтрок = ВыборкаСтрокТовары.Количество();
			НомерСтроки = 0;
			
			ПараметрыИтого = Новый Структура;
			ПараметрыИтого.Вставить("Сумма", 0);
			
			Пока ВыборкаСтрокТовары.Следующий() Цикл
				
				ФормированиеПечатныхФормБольничнаяАптека.УвеличитьНомер(Нумерация, "НомерСтроки");
				
				ДанныеСтроки = Новый Структура(КлючиПараметров);
				ЗаполнитьЗначенияСвойств(ДанныеСтроки, ВыборкаСтрокТовары);
				
				ТоварНаименование = ОбщегоНазначенияБольничнаяАптека.ПолучитьПредставлениеНоменклатурыДляПечати(
					ВыборкаСтрокТовары.ТоварНаименование,
					ВыборкаСтрокТовары.СерияНоменклатуры,
					ВыборкаСтрокТовары.Партия);
				
				Если ДанныеСтроки.Свойство("СуммаСНДС") Тогда
					
					СуммаСНДС = Окр(ВыборкаСтрокТовары.СуммаСНДС * КоэффициентПересчета, 2);
					СуммаНДС  = Окр(ВыборкаСтрокТовары.СуммаНДС * КоэффициентПересчета, 2);
					СуммаБезНДС = СуммаСНДС - СуммаНДС;
					
					Если ЕстьКолонкаПринятьНДСКВычету И Шапка.ПринятьНДСКВычету Тогда
						Сумма = СуммаБезНДС;
						Если ЕстьКолонкаЦенаВключаетНДС И Шапка.ЦенаВключаетНДС Тогда
							Цена = ?(ВыборкаСтрокТовары.Количество = 0, 0, СуммаБезНДС / ВыборкаСтрокТовары.Количество);
						Иначе
							Цена = ВыборкаСтрокТовары.Цена * КоэффициентПересчета;
						КонецЕсли;
					Иначе
						Сумма = СуммаСНДС;
						Если ЕстьКолонкаЦенаВключаетНДС И Шапка.ЦенаВключаетНДС Тогда
							Цена = ВыборкаСтрокТовары.Цена * КоэффициентПересчета;
						Иначе
							Цена = ?(ВыборкаСтрокТовары.Количество = 0, 0, СуммаСНДС / ВыборкаСтрокТовары.Количество);
						КонецЕсли;
					КонецЕсли;
					
				Иначе
					
					Сумма = Окр(ВыборкаСтрокТовары.Сумма * КоэффициентПересчета, 2);
					Цена = ВыборкаСтрокТовары.Цена * КоэффициентПересчета;
					
				КонецЕсли;
				
				ДанныеСтроки.Вставить("НомерСтроки"      , Нумерация.НомерСтроки);
				ДанныеСтроки.Вставить("ТоварНаименование", ТоварНаименование);
				ДанныеСтроки.Вставить("Цена"             , Окр(Цена, 2));
				ДанныеСтроки.Вставить("Сумма"            , Сумма);
				
				ОбластьСтрока.Параметры.Заполнить(ДанныеСтроки);
				
				ЭтоПоследняяСтрока = Нумерация.НомерСтроки = КоличествоСтрок;
				МассивВыводимыхОбластей = Новый Массив;
				МассивВыводимыхОбластей.Добавить(ОбластьСтрока);
				Если ЭтоПоследняяСтрока Тогда
					МассивВыводимыхОбластей.Добавить(Макет.ПолучитьОбласть("Итог_Раздел1"));
				КонецЕсли;
				ПроверитьВыводСтроки(ТабличныйДокумент, Макет, МассивВыводимыхОбластей, ОбластьСтрока, ЭтоПоследняяСтрока, Нумерация, "ШапкаТаблицы_Раздел1");
				
				// Вывод области Строка
				ТабличныйДокумент.Вывести(ОбластьСтрока);
				
				ФормированиеПечатныхФормБольничнаяАптека.РассчитатьИтоги(ДанныеСтроки, ПараметрыИтого);
				
			КонецЦикла;
			
			ФормированиеПечатныхФормБольничнаяАптека.ВывестиОбластьПоИмени(ТабличныйДокумент, Макет, "Итог_Раздел1", ПараметрыИтого);
			
			ФормированиеПечатныхФормБольничнаяАптека.УстановитьНачальныйНомер(Нумерация, "НомерСтроки");
			
			ПараметрыИтого = Новый Структура;
			ПараметрыИтого.Вставить("Сумма", 0);
			
			Если ПроверитьВыводСтроки(ТабличныйДокумент, Макет, Новый Массив, "ШапкаТаблицы_Раздел2", Ложь, Нумерация, "ШапкаТаблицы_Раздел2") Тогда
				ФормированиеПечатныхФормБольничнаяАптека.ВывестиОбластьПоИмени(ТабличныйДокумент, Макет, "ШапкаТаблицы_Раздел2", Нумерация);
			КонецЕсли;
			
			ОбластьСтрока = Макет.ПолучитьОбласть("Строка_Раздел2");
			
			КоличествоСтрок = ВыборкаСтрокТовары.Количество();
			НомерСтроки = 0;
			ВыборкаСтрокТовары.Сбросить();
			Пока ВыборкаСтрокТовары.Следующий() Цикл
				
				ФормированиеПечатныхФормБольничнаяАптека.УвеличитьНомер(Нумерация, "НомерСтроки");
				
				ДанныеСтроки = Новый Структура(КлючиПараметров);
				ЗаполнитьЗначенияСвойств(ДанныеСтроки, ВыборкаСтрокТовары);
				
				ТоварНаименование = ОбщегоНазначенияБольничнаяАптека.ПолучитьПредставлениеНоменклатурыДляПечати(
					ВыборкаСтрокТовары.ТоварНаименование,
					ВыборкаСтрокТовары.СерияНоменклатуры,
					ВыборкаСтрокТовары.Партия);
				
				ДанныеСтроки.Вставить("НомерСтроки"      , Нумерация.НомерСтроки);
				ДанныеСтроки.Вставить("ТоварНаименование", ТоварНаименование);
				
				ОбластьСтрока.Параметры.Заполнить(ДанныеСтроки);
				
				ЭтоПоследняяСтрока = Нумерация.НомерСтроки = КоличествоСтрок;
				МассивВыводимыхОбластей = Новый Массив;
				МассивВыводимыхОбластей.Добавить(ОбластьСтрока);
				Если ЭтоПоследняяСтрока Тогда
					МассивВыводимыхОбластей.Добавить(Макет.ПолучитьОбласть("Итог_Раздел2"));
				КонецЕсли;
				ПроверитьВыводСтроки(ТабличныйДокумент, Макет, МассивВыводимыхОбластей, ОбластьСтрока, ЭтоПоследняяСтрока, Нумерация, "ШапкаТаблицы_Раздел2");
				
				// Вывод области Строка
				ТабличныйДокумент.Вывести(ОбластьСтрока);
				
				ФормированиеПечатныхФормБольничнаяАптека.РассчитатьИтоги(ДанныеСтроки, ПараметрыИтого);
				
			КонецЦикла;
			
		КонецЕсли;
		
		ФормированиеПечатныхФормБольничнаяАптека.ВывестиОбластьПоИмени(ТабличныйДокумент, Макет, "Итог_Раздел2", ПараметрыИтого);
		
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
	СведенияОбОтправителе = ФормированиеПечатныхФорм.СведенияОЮрФизЛице(Шапка.Отправитель, Шапка.ДатаДокумента);
	СведенияОПолучателе   = ФормированиеПечатныхФорм.СведенияОЮрФизЛице(Шапка.Получатель, Шапка.ДатаДокумента);
	
	Параметры.Вставить("НомерДокумента",           ПрефиксацияОбъектовКлиентСервер.НомерНаПечать(Шапка.НомерДокумента));
	Параметры.Вставить("ОтправительПредставление", ФормированиеПечатныхФорм.ОписаниеОрганизации(СведенияОбОтправителе));
	Параметры.Вставить("ПолучательПредставление",  ФормированиеПечатныхФорм.ОписаниеОрганизации(СведенияОПолучателе));
	
	// Данные подписей документа
	МОЛОтправителя = РегистрыСведений.МатериальноОтветственныеЛица.ПолучитьДанныеОтветственного(Шапка.СкладОтправитель, Шапка.ДатаДокумента);
	МОЛПолучателя  = РегистрыСведений.МатериальноОтветственныеЛица.ПолучитьДанныеОтветственного(Шапка.СкладПолучатель, Шапка.ДатаДокумента);
	
	Параметры.Вставить("ОтправительФИО",       МОЛОтправителя.ФИО);
	Параметры.Вставить("ОтправительДолжность", МОЛОтправителя.Должность);
	Параметры.Вставить("ПолучательФИО",        МОЛПолучателя.ФИО);
	Параметры.Вставить("ПолучательДолжность",  МОЛПолучателя.Должность);
	
	Возврат Параметры;
	
КонецФункции

Функция КоэффициентПересчетаВалюты(ДанныеПечати, ТаблицаКурсовВалют, ВалютаРегламентированногоУчета)
	
	КоэффициентПересчета = 1;
	Если ДанныеПечати.Валюта <> ВалютаРегламентированногоУчета Тогда
		
		СтруктураПоиска = Новый Структура("Валюта, Дата", ДанныеПечати.Валюта, НачалоДня(ДанныеПечати.ДатаДокумента));
		Массив = ТаблицаКурсовВалют.НайтиСтроки(СтруктураПоиска);
		Если Массив.Количество() > 0 Тогда
			КоэффициентПересчета = ?(Массив[0].Кратность <> 0, Массив[0].Курс / Массив[0].Кратность, 1);
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат КоэффициентПересчета;
	
КонецФункции

Функция ИнициализироватьНумерацию()
	
	Нумерация = Новый Структура;
	Нумерация.Вставить("НомерСтроки"  , 0);
	Нумерация.Вставить("НомерСтраницы", 1);
	Нумерация.Вставить("НомерСтрокиНаСтранице", 0);
	
	Возврат Нумерация;
	
КонецФункции

Функция ПроверитьВыводСтроки(ТабличныйДокумент, Макет, МассивВыводимыхОбластей, ТекущаяОбласть, ЭтоПоследняяСтрока, Нумерация, ИмяШапки)
	
	Если МассивВыводимыхОбластей.Количество() = 0 Тогда
		МассивВыводимыхОбластей.Добавить(ТекущаяОбласть);
	КонецЕсли;
	
	Если Не ОбщегоНазначения.ПроверитьВыводТабличногоДокумента(ТабличныйДокумент, МассивВыводимыхОбластей) Тогда
		ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		ФормированиеПечатныхФормБольничнаяАптека.УвеличитьНомер(Нумерация, "НомерСтраницы");
		ФормированиеПечатныхФормБольничнаяАптека.ВывестиОбластьПоИмени(ТабличныйДокумент, Макет, "ЗаголовокСтраницы", Нумерация);
		ФормированиеПечатныхФормБольничнаяАптека.ВывестиОбластьПоИмени(ТабличныйДокумент, Макет, ИмяШапки, Нумерация);
		Возврат Ложь;
	КонецЕсли;

	Возврат Истина;
	
КонецФункции

Функция МетаданныеМакета()
	
	Возврат Метаданные.Обработки.ПечатьАктОПриемеПередаче0510434.Макеты.ПФ_MXL_АктОПриемеПередаче0510434;
	
КонецФункции

#КонецОбласти // СлужебныеПроцедурыИФункции

#КонецЕсли
