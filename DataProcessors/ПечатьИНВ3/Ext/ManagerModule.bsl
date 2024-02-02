﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

////////////////////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС
#Область ПрограммныйИнтерфейс

// Функция возвращает элемент таблицы доступных печатных форм объекта печати
//
Функция ДобавитьПечатнуюФорму(ПечатныеФормы) Экспорт
	
	МетаданныеМакета = МетаданныеМакета();
	МенеджерПечати = МетаданныеМакета.Родитель().ПолноеИмя();
	
	ПечатнаяФорма = УправлениеПечатьюБольничнаяАптека.ДобавитьПечатнуюФорму(ПечатныеФормы, "ИНВ3", МенеджерПечати);
	ПечатнаяФорма.ПутьКМакету = ФормированиеПечатныхФормБольничнаяАптека.ПутьКМакету(МетаданныеМакета);
	ПечатнаяФорма.Представление = МетаданныеМакета.Представление();
	
	ПечатнаяФорма.Параметризуемая = Истина;
	ПечатнаяФорма.ДополнительныеПараметры.Вставить("БезФактическихДанных", Ложь);
	
	Возврат ПечатнаяФорма;
	
КонецФункции

// Функция формирует печатную форму ИНВ-3
//
Функция ПечатьИНВ3(МассивОбъектов, ОбъектыПечати, ПараметрыПечати) Экспорт
	
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
	
	Шапка = ДанныеДляПечати.ОсновныеДанные;
	
	ТекстИтогоПоСтранице = НСтр("ru = 'Итого по странице'") + ":";
	ТекстИтогоПоОписи    = НСтр("ru = 'Итого по описи'") + ":";
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
		ТаблицаЦен  = ПолучитьТаблицуЦен(Шапка);
		
		// Вывод области Заголовок
		ФормированиеПечатныхФормБольничнаяАптека.ВывестиОбластьСоШтрихкодом(ТабличныйДокумент, Макет, "Заголовок", ДанныеШапки);
		
		// Вывод области МОЛ
		ПараметрыОглавления = Новый Структура("ОглавлениеПодписи", НСтр("ru = 'Материально ответственное (ые) лицо(а)'") + ":");
		ФормированиеПечатныхФормБольничнаяАптека.ВывестиОбластьПоИмени(ТабличныйДокумент, Макет, "ОглавлениеПодписи", ПараметрыОглавления);
		
		ОбластиМОЛ = СформироватьОбластиМОЛ(Макет, Шапка);
		Для Каждого ОбластьМОЛ Из ОбластиМОЛ Цикл
			ТабличныйДокумент.Вывести(ОбластьМОЛ);
		КонецЦикла;
		
		// Вывод области ДатаСнятияОстатков
		ФормированиеПечатныхФормБольничнаяАптека.ВывестиОбластьПоИмени(ТабличныйДокумент, Макет, "ДатаСнятияОстатков", ДанныеШапки);
		
		ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		
		// Вывод области ИсточникФинансирования
		Если ЗначениеЗаполнено(Шапка.ИсточникФинансирования) Тогда
			ФормированиеПечатныхФормБольничнаяАптека.ВывестиОбластьПоИмени(ТабличныйДокумент, Макет, "ИсточникФинансирования", ДанныеШапки);
		КонецЕсли;
		
		// Инициализация нумерации
		Нумерация = ИнициализироватьНумерацию();
		
		// Вывод области ШапкаТаблицы
		ФормированиеПечатныхФормБольничнаяАптека.ВывестиОбластьПоИмени(ТабличныйДокумент, Макет, "ШапкаТаблицы", Нумерация);
		
		// Инициализация итогов
		ПараметрыИтогоПоСтранице = ИнициализироватьСтруктуруИтогов();
		ПараметрыИтогоПоОписи    = ИнициализироватьСтруктуруИтогов();
		
		// Вывод многострочной части
		ВыборкаСтрокТовары = Шапка.Товары.Выбрать();
		КлючиПараметров = ФормированиеПечатныхФормБольничнаяАптека.ПолучитьИменаКолонокТаблицы(ВыборкаСтрокТовары);
		
		ОбластьСтрока = Макет.ПолучитьОбласть("Строка");
		
		КоличествоСтрок = ВыборкаСтрокТовары.Количество();
		Пока ВыборкаСтрокТовары.Следующий() Цикл
			
			ФормированиеПечатныхФормБольничнаяАптека.УвеличитьНомер(Нумерация, "НомерСтроки");
			
			ДанныеСтроки = Новый Структура(КлючиПараметров);
			ЗаполнитьЗначенияСвойств(ДанныеСтроки, ВыборкаСтрокТовары);
			
			ТоварНаименование = ОбщегоНазначенияБольничнаяАптека.ПолучитьПредставлениеНоменклатурыДляПечати(
				ВыборкаСтрокТовары.ТоварНаименование,
				ВыборкаСтрокТовары.Серия,
				ВыборкаСтрокТовары.Партия);
			
			Цена = 0;
			Если ТаблицаЦен <> Неопределено Тогда
				СтрокаЦены = ТаблицаЦен.Найти(ВыборкаСтрокТовары.НомерСтроки, "НомерСтроки");
				Если СтрокаЦены <> Неопределено Тогда
					Цена = СтрокаЦены.Цена;
				КонецЕсли;
			КонецЕсли;
			
			ФактСумма = Окр(Цена * ВыборкаСтрокТовары.ФактКоличество, 2);
			БухСумма  = Окр(Цена * ВыборкаСтрокТовары.БухКоличество, 2);
			
			ДанныеСтроки.Вставить("НомерСтроки"      , Нумерация.НомерСтроки);
			ДанныеСтроки.Вставить("ТоварНаименование", ТоварНаименование);
			ДанныеСтроки.Вставить("Цена"             , Окр(Цена, 2));
			ДанныеСтроки.Вставить("ФактКоличество"   , ВыборкаСтрокТовары.ФактКоличество);
			ДанныеСтроки.Вставить("ФактСумма"        , ФактСумма);
			ДанныеСтроки.Вставить("БухКоличество"    , ВыборкаСтрокТовары.БухКоличество);
			ДанныеСтроки.Вставить("БухСумма"         , БухСумма);
			
			ОбластьСтрока.Параметры.Заполнить(ДанныеСтроки);
			
			ЭтоПоследняяСтрока = Нумерация.НомерСтроки = КоличествоСтрок;
			СтрокаНеПомещаетсяНаСтраницу = ПроверитьВыводСтроки(ТабличныйДокумент, Макет, МассивВыводимыхОбластей, ОбластьСтрока, ЭтоПоследняяСтрока);
			
			Если СтрокаНеПомещаетсяНаСтраницу Тогда
				
				// Вывод области Итого по странице
				ПараметрыИтогоПоСтранице.Вставить("ТекстИтого", ТекстИтогоПоСтранице);
				ФормированиеПечатныхФормБольничнаяАптека.ВывестиОбластьПоИмени(ТабличныйДокумент, Макет, "Итого", ПараметрыИтогоПоСтранице);
				
				// Вывод области ИтогоПрописью по странице
				ПараметрыИтогоПрописью = СформироватьИтогиПрописью(ПараметрыИтогоПоСтранице, ВалютаПечати, Нумерация.НомерСтрокиНаСтранице, ТекстИтогоПоСтранице);
				ФормированиеПечатныхФормБольничнаяАптека.ВывестиОбластьПоИмени(ТабличныйДокумент, Макет, "ИтогоПрописью", ПараметрыИтогоПрописью);
				
				// Обнулить итоги по странице
				ФормированиеПечатныхФормБольничнаяАптека.ОбнулитьИтоги(ПараметрыИтогоПоСтранице);
				ФормированиеПечатныхФормБольничнаяАптека.УстановитьНачальныйНомер(Нумерация, "НомерСтрокиНаСтранице");
				
				// Перейти на следующую страницу
				ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
				
				// Вывод области ШапкаТаблицы
				ФормированиеПечатныхФормБольничнаяАптека.УвеличитьНомер(Нумерация, "НомерСтраницы");
				ФормированиеПечатныхФормБольничнаяАптека.ВывестиОбластьПоИмени(ТабличныйДокумент, Макет, "ШапкаТаблицы", Нумерация);
				
			КонецЕсли;
			
			// Вывод области Строка
			ТабличныйДокумент.Вывести(ОбластьСтрока);
			
			ФормированиеПечатныхФормБольничнаяАптека.РассчитатьИтоги(ДанныеСтроки, ПараметрыИтогоПоСтранице);
			ФормированиеПечатныхФормБольничнаяАптека.РассчитатьИтоги(ДанныеСтроки, ПараметрыИтогоПоОписи);
			
			ФормированиеПечатныхФормБольничнаяАптека.УвеличитьНомер(Нумерация, "НомерСтрокиНаСтранице");
			
		КонецЦикла;
		
		// Вывод области Итого по странице
		ПараметрыИтогоПоСтранице.Вставить("ТекстИтого", ТекстИтогоПоСтранице);
		ФормированиеПечатныхФормБольничнаяАптека.ВывестиОбластьПоИмени(ТабличныйДокумент, Макет, "Итого", ПараметрыИтогоПоСтранице);
		
		// Вывод области Итого по описи
		ПараметрыИтогоПоОписи.Вставить("ТекстИтого", ТекстИтогоПоОписи);
		ФормированиеПечатныхФормБольничнаяАптека.ВывестиОбластьПоИмени(ТабличныйДокумент, Макет, "Итого", ПараметрыИтогоПоОписи);
		
		// Вывести итоги прописью по странице
		ПараметрыИтогоПрописью = СформироватьИтогиПрописью(ПараметрыИтогоПоСтранице, ВалютаПечати, Нумерация.НомерСтрокиНаСтранице, ТекстИтогоПоСтранице);
		ФормированиеПечатныхФормБольничнаяАптека.ВывестиОбластьПоИмени(ТабличныйДокумент, Макет, "ИтогоПрописью", ПараметрыИтогоПрописью);
		
		// Вывод области ИтогоПрописью на следующей странице
		ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		
		ПараметрыИтогоПрописью = СформироватьИтогиПрописью(ПараметрыИтогоПоОписи, ВалютаПечати, Нумерация.НомерСтроки, ТекстИтогоПоОписи);
		ФормированиеПечатныхФормБольничнаяАптека.ВывестиОбластьПоИмени(ТабличныйДокумент, Макет, "ИтогоПрописью", ПараметрыИтогоПрописью);
		
		// Вывод области КомментарииПодписи
		ФормированиеПечатныхФормБольничнаяАптека.ВывестиОбластьПоИмени(ТабличныйДокумент, Макет, "КомментарииПодписи");
		
		// Вывод области Комиссии
		ОбластиКомиссии = СформироватьОбластиКомиссии(Макет, Шапка);
		
		Для Каждого ОбластьКомиссии Из ОбластиКомиссии Цикл
			ТабличныйДокумент.Вывести(ОбластьКомиссии);
		КонецЦикла;
		
		// Вывод области КомментарииПодписи2
		ПараметрыКомментария = Новый Структура;
		ПараметрыКомментария.Вставить("НачальныйНомерПоПорядку", 1);
		ПараметрыКомментария.Вставить("НомерКонца"             , КоличествоСтрок);
		
		ФормированиеПечатныхФормБольничнаяАптека.ВывестиОбластьПоИмени(ТабличныйДокумент, Макет, "КомментарииПодписи2", ПараметрыКомментария);
		
		// Вывод области МОЛ
		ПараметрыОглавления = Новый Структура("ОглавлениеПодписи", НСтр("ru = 'Лицо (а), ответственное (ые) за сохранность товарно-материальных ценностей'") + ":");
		ФормированиеПечатныхФормБольничнаяАптека.ВывестиОбластьПоИмени(ТабличныйДокумент, Макет, "ОглавлениеПодписи", ПараметрыОглавления);
		
		Для Каждого ОбластьМОЛ Из ОбластиМОЛ Цикл
			ТабличныйДокумент.Вывести(ОбластьМОЛ);
		КонецЦикла;
		
		// Вывод области ДатаПодписи
		ФормированиеПечатныхФормБольничнаяАптека.ВывестиОбластьПоИмени(ТабличныйДокумент, Макет, "ДатаПодписи");
		
		// Вывод области Проверил
		ПараметрыОглавления = Новый Структура("ОглавлениеПодписи", НСтр("ru = 'Указанные в настоящей описи данные и расчеты проверил'") + ":");
		ФормированиеПечатныхФормБольничнаяАптека.ВывестиОбластьПоИмени(ТабличныйДокумент, Макет, "ОглавлениеПодписи", ПараметрыОглавления);
		
		ФормированиеПечатныхФормБольничнаяАптека.ВывестиОбластьПоИмени(ТабличныйДокумент, Макет, "Подписи");
		
		// Вывод области ДатаПодписи
		ФормированиеПечатныхФормБольничнаяАптека.ВывестиОбластьПоИмени(ТабличныйДокумент, Макет, "ДатаПодписи");
		
		УправлениеПечатью.ЗадатьОбластьПечатиДокумента(ТабличныйДокумент, НомерСтрокиНачало, ОбъектыПечати, Шапка.Ссылка);
		
	КонецЦикла;
	
КонецПроцедуры

Функция ПолучитьДанныеШапкиДокумента(Шапка)
	
	КлючиПараметров = ФормированиеПечатныхФормБольничнаяАптека.ПолучитьИменаКолонокТаблицы(Шапка);
	
	Параметры = Новый Структура(КлючиПараметров);
	ЗаполнитьЗначенияСвойств(Параметры, Шапка);
	
	// Данные заголовка
	СведенияОбОрганизации    = ФормированиеПечатныхФорм.СведенияОЮрФизЛице(Шапка.Организация, Шапка.ДатаДокумента);
	ОрганизацияПредставление = ФормированиеПечатныхФорм.ОписаниеОрганизации(СведенияОбОрганизации);
	
	Параметры.Вставить("НомерДокумента"          , ПрефиксацияОбъектовКлиентСервер.НомерНаПечать(Шапка.НомерДокумента));
	Параметры.Вставить("ОрганизацияПредставление", ОрганизацияПредставление);
	Параметры.Вставить("ОрганизацияОКПО"         , СведенияОбОрганизации.КодПоОКПО);
	
	Возврат Параметры;
	
КонецФункции

Функция ПолучитьТаблицуЦен(Шапка)
	
	МенеджерОбъекта = ОбщегоНазначения.МенеджерОбъектаПоСсылке(Шапка.Ссылка);
	Возврат МенеджерОбъекта.ПолучитьТаблицуЦен(Шапка);
	
КонецФункции

Функция СформироватьОбластиМОЛ(Макет, Шапка)
	
	ОбластиМОЛ = Новый Массив;
	МОЛ = РегистрыСведений.МатериальноОтветственныеЛица.ПолучитьДанныеОтветственного(Шапка.Склад, Шапка.ДатаДокумента);
	
	ПустыеСтроки = 2;
	Для ИндексПодписи = 0 По ПустыеСтроки Цикл
		
		Параметры = Новый Структура;
		
		Если ИндексПодписи = 0 Тогда
			Параметры.Вставить("ПодписьФИО"      , МОЛ.ФИО);
			Параметры.Вставить("ПодписьДолжность", МОЛ.Должность);
		КонецЕсли;
		
		ФормированиеПечатныхФормБольничнаяАптека.ДобавитьОбластьВМассивПоОписанию(Макет, "Подписи", ОбластиМОЛ, Параметры);
		
	КонецЦикла;
	
	Возврат ОбластиМОЛ;
	
КонецФункции

Функция СформироватьОбластиКомиссии(Макет, Шапка)
	
	ОбластиКомиссии = Новый Массив;
	
	ПустыеСтроки = 4;
	ПредседательВСоставе = Истина;
	
	Комиссия = Шапка.ИнвентаризационнаяКомиссия.Выбрать();
	КоличествоЧленовКомиссии = Комиссия.Количество();
	
	Для НомерЧленаКомиссии = 1 По Макс(КоличествоЧленовКомиссии, ПустыеСтроки) Цикл
		
		Параметры = Новый Структура;
		
		Если НомерЧленаКомиссии > КоличествоЧленовКомиссии Тогда
			ЧленКомиссииСтатус = ?(НомерЧленаКомиссии = 1, НСтр("ru = 'Председатель комиссии'"), ?(НомерЧленаКомиссии = 2, НСтр("ru = 'Члены комиссии'"), ""));
			Параметры.Вставить("Статус", ЧленКомиссииСтатус);
		Иначе
			
			Комиссия.Следующий();
			
			Если Комиссия.Председатель И НомерЧленаКомиссии = 1 Тогда
				Параметры.Вставить("Статус", НСтр("ru = 'Председатель комиссии'"));
				ПредседательВСоставе = Истина;
			ИначеЕсли ПредседательВСоставе И НомерЧленаКомиссии = 2
				  Или НомерЧленаКомиссии = 1 Тогда
				Параметры.Вставить("Статус", НСтр("ru = 'Члены комиссии'"));
			КонецЕсли;
			
			Параметры.Вставить("ПодписьФИО"      , ФизическиеЛицаКлиентСервер.ФамилияИнициалы(СокрЛП(Комиссия.Представление)));
			Параметры.Вставить("ПодписьДолжность", Комиссия.Должность);
			
		КонецЕсли;
		
		ФормированиеПечатныхФормБольничнаяАптека.ДобавитьОбластьВМассивПоОписанию(Макет, "Подписи", ОбластиКомиссии, Параметры);
		
	КонецЦикла;
	
	Возврат ОбластиКомиссии;
	
КонецФункции

Функция ИнициализироватьСтруктуруИтогов()
	
	ПараметрыИтого = Новый Структура;
	ПараметрыИтого.Вставить("БухКоличество",  0);
	ПараметрыИтого.Вставить("БухСумма",       0);
	ПараметрыИтого.Вставить("ФактКоличество", 0);
	ПараметрыИтого.Вставить("ФактСумма",      0);
	
	Возврат ПараметрыИтого;
	
КонецФункции

Функция ИнициализироватьНумерацию()
	
	Нумерация = Новый Структура;
	Нумерация.Вставить("НомерСтроки"  , 0);
	Нумерация.Вставить("НомерСтраницы", 1);
	Нумерация.Вставить("НомерСтрокиНаСтранице", 0);
	
	Возврат Нумерация;
	
КонецФункции

Функция СформироватьИтогиПрописью(ПараметрыИсточник, ВалютаПечати, НомерСтроки, ТекстИтого)
	
	КоличествоНаименованийПрописью          = ЧислоПрописью(НомерСтроки, , ",,,,,,,,0");
	ОбщееКоличествоЕдиницФактическиПрописью = ОбщегоНазначенияБольничнаяАптека.КоличествоПрописью(ПараметрыИсточник.ФактКоличество);
	СуммаФактическиПрописью                 = РаботаСКурсамиВалют.СформироватьСуммуПрописью(ПараметрыИсточник.ФактСумма, ВалютаПечати);
	
	ПараметрыИтогов = Новый Структура;
	ПараметрыИтогов.Вставить("ТекстИтого",                              ТекстИтого);
	ПараметрыИтогов.Вставить("КоличествоНаименованийПрописью",          КоличествоНаименованийПрописью);
	ПараметрыИтогов.Вставить("ОбщееКоличествоЕдиницФактическиПрописью", ОбщееКоличествоЕдиницФактическиПрописью);
	ПараметрыИтогов.Вставить("СуммаФактическиПрописью",                 СуммаФактическиПрописью);
	
	Возврат ПараметрыИтогов;
	
КонецФункции

Функция ПроверитьВыводСтроки(ТабличныйДокумент, Макет, МассивВыводимыхОбластей, ТекущаяОбласть, ЭтоПоследняяСтрока)
	
	МассивВыводимыхОбластей.Очистить();
	МассивВыводимыхОбластей.Добавить(ТекущаяОбласть);
	МассивВыводимыхОбластей.Добавить(Макет.ПолучитьОбласть("Итого"));
	МассивВыводимыхОбластей.Добавить(Макет.ПолучитьОбласть("ИтогоПрописью"));
	Если ЭтоПоследняяСтрока Тогда
		МассивВыводимыхОбластей.Добавить(Макет.ПолучитьОбласть("Итого"));
	КонецЕсли;
	
	Возврат Не ОбщегоНазначения.ПроверитьВыводТабличногоДокумента(ТабличныйДокумент, МассивВыводимыхОбластей);
	
КонецФункции

Функция МетаданныеМакета()
	
	Возврат Метаданные.Обработки.ПечатьИНВ3.Макеты.ПФ_MXL_ИНВ3;
	
КонецФункции

#КонецОбласти // СлужебныеПроцедурыИФункции

#КонецЕсли
