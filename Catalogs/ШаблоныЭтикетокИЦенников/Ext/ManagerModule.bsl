﻿
////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ
#Область ОбработчикиСобытий

Процедура ОбработкаПолученияФормы(ВидФормы, Параметры, ВыбраннаяФорма, ДополнительнаяИнформация, СтандартнаяОбработка)
	
	Если ВидФормы = "ФормаОбъекта" 
	   И Не Параметры.Свойство("Ключ")
	   И Не Параметры.Свойство("ОткрытьРедактор")
	   И Не Параметры.Свойство("ЗначениеКопирования") Тогда
		
		ВыбраннаяФорма = "ПомощникНового";
		СтандартнаяОбработка = Ложь;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти // ОбработчикиСобытий

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

////////////////////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС
#Область ПрограммныйИнтерфейс

// Функция выполняет получение имени поля из доступных полей компоновки данных.
//
// Параметры
//  ИмяПоля  - Строка - Имя поля
//
// Возвращаемое значение:
//   Строка   - Имя поля в шаблоне
//
Функция ИмяПоляВШаблоне(Знач ИмяПоля) Экспорт
	
	ИмяПоля = СтрЗаменить(ИмяПоля, ".DeletionMark", ".ПометкаУдаления");
	ИмяПоля = СтрЗаменить(ИмяПоля, ".Owner", ".Владелец");
	ИмяПоля = СтрЗаменить(ИмяПоля, ".Code", ".Код");
	ИмяПоля = СтрЗаменить(ИмяПоля, ".Parent", ".Родитель");
	ИмяПоля = СтрЗаменить(ИмяПоля, ".Predefined", ".Предопределенный");
	ИмяПоля = СтрЗаменить(ИмяПоля, ".IsFolder", ".ЭтоГруппа");
	ИмяПоля = СтрЗаменить(ИмяПоля, ".Description", ".Наименование");
	Возврат ИмяПоля;
	
КонецФункции

// Возвращает шаблон указанного назначения, если он один в базе, иначе - пустую ссылку.
//
// Параметры:
//  Назначение - ПеречислениеСсылка.НазначенияШаблоновЭтикетокИЦенников - назначение шаблона
// Возвращаемое значение:
//  СправочникСсылка.ШаблоныЭтикетокИЦенников
//
Функция ШаблонПоУмолчанию(Назначение) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = "
	|ВЫБРАТЬ ПЕРВЫЕ 2
	|	ШаблоныЭтикетокИЦенников.Ссылка
	|ИЗ
	|	Справочник.ШаблоныЭтикетокИЦенников КАК ШаблоныЭтикетокИЦенников
	|ГДЕ
	|	ШаблоныЭтикетокИЦенников.Назначение = &Назначение
	|	И НЕ ШаблоныЭтикетокИЦенников.ПометкаУдаления
	|";
	
	Запрос.УстановитьПараметр("Назначение",Назначение);
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Если Выборка.Количество() = 1 Тогда
		Выборка.Следующий();
		Возврат Выборка.Ссылка;
	Иначе
		Возврат Справочники.ШаблоныЭтикетокИЦенников.ПустаяСсылка();
	КонецЕсли;
	
КонецФункции

// Возвращает структуру макета шаблона этикеток и ценников
//
// Параметры:
//  ПолеТабличногоДокумента - ТабличныйДокумент - область отображение шаблона этикеток и ценников
//  Назначение              - ПеречислениеСсылка.НазначенияШаблоновЭтикетокИЦенников - назначение шаблона
//
// Возвращаемое значение:
//  СтруктураМакетаШаблона - Структура - набор параметров для формирования шаблона этикеток и ценников
//
Функция ПодготовитьСтруктуруМакетаШаблона(ПолеТабличногоДокумента, Назначение) Экспорт
	
	СтруктураМакетаШаблона = Новый Структура;
	ПараметрыШаблона       = Новый Соответствие;
	СчетчикПараметров      = 0;
	ПрефиксИмениПараметра  = "ПараметрМакета";
	
	ОбластьМакетаЭтикетки = ПолеТабличногоДокумента.ПолучитьОбласть(ПолеТабличногоДокумента.ОбластьПечати.Имя);
	СкопироватьСвойстваТабличногоДокумента(ОбластьМакетаЭтикетки, ПолеТабличногоДокумента);
	
	ОбластьМакетаЭтикетки.ОбластьПечати = ОбластьМакетаЭтикетки.Область(1, 1, ОбластьМакетаЭтикетки.ВысотаТаблицы, ОбластьМакетаЭтикетки.ШиринаТаблицы);
	
	ПросмотренныеЯчейки = Новый Массив;
	
	Для НомерКолонки = 1 По ОбластьМакетаЭтикетки.ШиринаТаблицы Цикл
		
		Для НомерСтроки = 1 По ОбластьМакетаЭтикетки.ВысотаТаблицы Цикл
			
			Ячейка = ОбластьМакетаЭтикетки.Область(НомерСтроки, НомерКолонки);
			Если ПросмотренныеЯчейки.Найти(Ячейка.Имя) <> Неопределено Тогда
				Продолжить;
			КонецЕсли;
			ПросмотренныеЯчейки.Добавить(Ячейка.Имя);
			
			Если Ячейка.Заполнение = ТипЗаполненияОбластиТабличногоДокумента.Шаблон Тогда
				
				МассивПараметров = ПозицииПараметров(Ячейка.Текст);
				
				КоличествоПараметров = МассивПараметров.Количество();
				Для Индекс = 1 По КоличествоПараметров Цикл
					
					Структура = МассивПараметров[КоличествоПараметров - Индекс];
					
					ИмяПараметра = Сред(Ячейка.Текст, Структура.Начало + 1, Структура.Конец - Структура.Начало - 1);
					Если Найти(ИмяПараметра, ПрефиксИмениПараметра) = 0 Тогда
						
						ЛеваяЧасть = Лев(Ячейка.Текст, Структура.Начало);
						ПраваяЧасть = Прав(Ячейка.Текст, СтрДлина(Ячейка.Текст) - Структура.Конец + 1);
						
						СохраненноеИмяПараметраМакета = ПараметрыШаблона.Получить(ИмяПараметра);
						Если СохраненноеИмяПараметраМакета = Неопределено Тогда
							СчетчикПараметров = СчетчикПараметров + 1;
							Ячейка.Текст = ЛеваяЧасть + (ПрефиксИмениПараметра + СчетчикПараметров) + ПраваяЧасть;
							ПараметрыШаблона.Вставить(ИмяПараметра, ПрефиксИмениПараметра + СчетчикПараметров);
						Иначе
							Ячейка.Текст = ЛеваяЧасть + (СохраненноеИмяПараметраМакета) + ПраваяЧасть;
						КонецЕсли;
						
					КонецЕсли;
					
				КонецЦикла;
				
			ИначеЕсли Ячейка.Заполнение = ТипЗаполненияОбластиТабличногоДокумента.Параметр Тогда
				
				Если Найти(Ячейка.Параметр, ПрефиксИмениПараметра) = 0 Тогда
					СохраненноеИмяПараметраМакета = ПараметрыШаблона.Получить(Ячейка.Параметр);
					Если СохраненноеИмяПараметраМакета = Неопределено Тогда
						СчетчикПараметров = СчетчикПараметров + 1;
						ПараметрыШаблона.Вставить(Ячейка.Параметр, ПрефиксИмениПараметра + СчетчикПараметров);
						Ячейка.Параметр = ПрефиксИмениПараметра + СчетчикПараметров;
					Иначе
						Ячейка.Параметр = СохраненноеИмяПараметраМакета;
					КонецЕсли;
				КонецЕсли;
				
			КонецЕсли;
			
		КонецЦикла;
		
	КонецЦикла;
	
	ТребуетсяПараметрШтрихкод = ПараметрыШаблона.Получить(ИмяПараметраШтрихкод()) = Неопределено;
	ТребуетсяПараметрКодВалюты = ПараметрыШаблона.Получить(ИмяПараметраКодВалюты()) = Неопределено;
	
	// Вставляем в параметры штрихкод
	Для Каждого Рисунок Из ОбластьМакетаЭтикетки.Рисунки Цикл
		Если СтрНайти(Рисунок.Имя, ИмяПараметраШтрихкод()) = 1 Тогда
			Если ТребуетсяПараметрШтрихкод Тогда
				СчетчикПараметров = СчетчикПараметров + 1;
				ПараметрыШаблона.Вставить(ИмяПараметраШтрихкод(), ПрефиксИмениПараметра + СчетчикПараметров);
			КонецЕсли;
			Рисунок.Картинка = Новый Картинка;
		ИначеЕсли СтрНайти(Рисунок.Имя, "ЗнакВалюты") = 1 Тогда
			Если ТребуетсяПараметрКодВалюты Тогда
				СчетчикПараметров = СчетчикПараметров + 1;
				ПараметрыШаблона.Вставить(ИмяПараметраКодВалюты(), ПрефиксИмениПараметра + СчетчикПараметров);
			КонецЕсли;
			Рисунок.Картинка = Новый Картинка;
		КонецЕсли;
	КонецЦикла;
	
	КоличествоНаСтранице = МаксимальноеКоличествоНаСтранице(ПолеТабличногоДокумента, Назначение);
	
	ОтображатьТекст = Истина;
	ТипКода = 1;
	РазмерШрифта = 12;
	
	СтруктураМакетаШаблона.Вставить("МакетЭтикетки"            , ОбластьМакетаЭтикетки);
	СтруктураМакетаШаблона.Вставить("ИмяОбластиПечати"         , ОбластьМакетаЭтикетки.ОбластьПечати.Имя);
	СтруктураМакетаШаблона.Вставить("ТипКода"                  , ТипКода);
	СтруктураМакетаШаблона.Вставить("РазмерШрифта"             , РазмерШрифта);
	СтруктураМакетаШаблона.Вставить("ОтображатьТекст"          , ОтображатьТекст);
	СтруктураМакетаШаблона.Вставить("ПараметрыШаблона"         , ПараметрыШаблона);
	СтруктураМакетаШаблона.Вставить("РедакторТабличныйДокумент", ПолеТабличногоДокумента);
	СтруктураМакетаШаблона.Вставить("КоличествоПоВертикали"    , КоличествоНаСтранице.ПоВертикали);
	СтруктураМакетаШаблона.Вставить("КоличествоПоГоризонтали"  , КоличествоНаСтранице.ПоГоризонтали);
	
	Возврат СтруктураМакетаШаблона;
	
КонецФункции

// Возвращает максимальное количество этикеток и ценников, которые могут поместиться на странице.
//
// Параметры:
//  ПолеТабличногоДокумента - ТабличныйДокумент - область отображение шаблона этикеток и ценников
//  Назначение              - ПеречислениеСсылка.НазначенияШаблоновЭтикетокИЦенников - назначение шаблона
//
// Возвращаемое значение:
//  МаксимальноеКоличество - Структура - максимальное количество этикеток и ценников на странице.
//
Функция МаксимальноеКоличествоНаСтранице(ПолеТабличногоДокумента, Назначение) Экспорт
	
	МаксимальноеКоличество = Новый Структура("ПоГоризонтали, ПоВертикали, Описание", 1, 1);
	
	Если Назначение = Перечисления.НазначенияШаблоновЭтикетокИЦенников.ЦенникДляТоваров
	 Или Назначение = Перечисления.НазначенияШаблоновЭтикетокИЦенников.СтеллажнаяКарточкаДляТовара Тогда
		
		ОбластьМакета = ПолеТабличногоДокумента.ПолучитьОбласть(ПолеТабличногоДокумента.ОбластьПечати.Имя);
		
		РисунокШтрихкода = ОбластьМакета.Рисунки.Добавить(ТипРисункаТабличногоДокумента.Картинка);
		РисунокШтрихкода.Расположить(ОбластьМакета.Область(1, 1, ОбластьМакета.ВысотаТаблицы, ОбластьМакета.ШиринаТаблицы));
		
		Если ПолеТабличногоДокумента.ОриентацияСтраницы = ОриентацияСтраницы.Ландшафт Тогда
			ВысотаСтраницы = ПолеТабличногоДокумента.ШиринаСтраницы;
			ШиринаСтраницы = ПолеТабличногоДокумента.ВысотаСтраницы;
		Иначе
			ВысотаСтраницы = ПолеТабличногоДокумента.ВысотаСтраницы;
			ШиринаСтраницы = ПолеТабличногоДокумента.ШиринаСтраницы;
		КонецЕсли;
		
		Если Не ПолеТабличногоДокумента.АвтоМасштаб Тогда
			Если РисунокШтрихкода.Ширина <> 0 Тогда
				МаксимальноеКоличество.ПоГоризонтали = Цел((ШиринаСтраницы - ПолеТабличногоДокумента.ПолеСлева - ПолеТабличногоДокумента.ПолеСправа) / РисунокШтрихкода.Ширина);
			Иначе
				МаксимальноеКоличество.ПоГоризонтали = 1;
			КонецЕсли;
		Иначе
			МаксимальноеКоличество.ПоГоризонтали = 3;
		КонецЕсли;
		
		Если РисунокШтрихкода.Высота <> 0 Тогда
			МаксимальноеКоличество.ПоВертикали = Цел((ВысотаСтраницы - ПолеТабличногоДокумента.ПолеСверху - ПолеТабличногоДокумента.ПолеСнизу) / РисунокШтрихкода.Высота);
		Иначе
			МаксимальноеКоличество.ПоВертикали = 1;
		КонецЕсли;
		
	КонецЕсли;
	
	РазмерСтраницы = РазмерСтраницы(ПолеТабличногоДокумента);
	МаксимальноеКоличество.Описание = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru = 'На странице %1 помещается по вертикали: %2 по горизонтали: %3'"),
		РазмерСтраницы,
		МаксимальноеКоличество.ПоВертикали,
		МаксимальноеКоличество.ПоГоризонтали);
	
	Возврат МаксимальноеКоличество;
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// Печать образцов
#Область ПечатьОбразцов

// Возвращает образцы штрихкодов
//
// Возвращаемое значение:
//  Коды - Массив - примеры штрихкодов
//
Функция ПолучитьОбразцыШтрихкодов() Экспорт
	
	Коды = Новый Массив;
	
	ПримерКода = Новый Структура("ТипКода, Наименование, Пример");
	ПримерКода.ТипКода      = 0;
	ПримерКода.Наименование = "EAN8";
	ПримерКода.Пример       = "20059217";
	Коды.Добавить(ПримерКода);
	
	ПримерКода = Новый Структура("ТипКода, Наименование, Пример");
	ПримерКода.ТипКода      = 1;
	ПримерКода.Наименование = "EAN13";
	ПримерКода.Пример       = "4600051000057";
	Коды.Добавить(ПримерКода);
	
	ПримерКода = Новый Структура("ТипКода, Наименование, Пример");
	ПримерКода.ТипКода      = 2;
	ПримерКода.Наименование = "EAN128";
	ПримерКода.Пример       = "(01)2595623342995(15)542115(10)ANIMOS53435(00)8685243154";
	Коды.Добавить(ПримерКода);
	
	ПримерКода = Новый Структура("ТипКода, Наименование, Пример");
	ПримерКода.ТипКода      = 3;
	ПримерКода.Наименование = "Code39";
	ПримерКода.Пример       = "2PMP-468-PJM";
	Коды.Добавить(ПримерКода);
	
	ПримерКода = Новый Структура("ТипКода, Наименование, Пример");
	ПримерКода.ТипКода      = 4;
	ПримерКода.Наименование = "Code128";
	ПримерКода.Пример       = "93-0bonUM68";
	Коды.Добавить(ПримерКода);
	
	ПримерКода = Новый Структура("ТипКода, Наименование, Пример");
	ПримерКода.ТипКода      = 6;
	ПримерКода.Наименование = "PDF417";
	ПримерКода.Пример       = "93-0bonUM68";
	Коды.Добавить(ПримерКода);
	
	Возврат Коды;
	
КонецФункции

// Возвращает параметры для печати образца этикетки товара
//
// Параметры:
//  ДляЧего                 - СправочникСсылка.Номенклатура - номенклатурная единица - образец
//  ТипКода                 - Число - тип штрихкода
//  УникальныйИдентификатор - УникальныйИдентификатор - уникальный идентификатор
//
// Возвращаемое значение:
//  ПараметрыПечати - Структура - параметры для передачи в менеджер печати.
//
Функция ПолучитьПараметрыДляПечатиОбразцаЭтикеткиТовара(ДляЧего, ТипКода, УникальныйИдентификатор) Экспорт
	
	Товары = Новый ТаблицаЗначений;
	Товары.Колонки.Добавить("Номенклатура"                , Новый ОписаниеТипов("СправочникСсылка.Номенклатура"));
	Товары.Колонки.Добавить("СерияНоменклатуры"           , Новый ОписаниеТипов("СправочникСсылка.СерииНоменклатуры"));
	Товары.Колонки.Добавить("Партия"                      , Новый ОписаниеТипов("СправочникСсылка.ПартииНоменклатуры"));
	Товары.Колонки.Добавить("Упаковка"                    , Новый ОписаниеТипов("СправочникСсылка.ЕдиницыИзмерения"));
	Товары.Колонки.Добавить("Цена"                        , Новый ОписаниеТипов("Число"));
	Товары.Колонки.Добавить("Штрихкод"                    , Новый ОписаниеТипов("Строка"));
	Товары.Колонки.Добавить("ШаблонЦенника"               , Новый ОписаниеТипов("СправочникСсылка.ШаблоныЭтикетокИЦенников"));
	Товары.Колонки.Добавить("КоличествоЦенников"          , Новый ОписаниеТипов("Число"));
	Товары.Колонки.Добавить("ШаблонЭтикетки"              , Новый ОписаниеТипов("СправочникСсылка.ШаблоныЭтикетокИЦенников"));
	Товары.Колонки.Добавить("КоличествоЭтикеток"          , Новый ОписаниеТипов("Число"));
	Товары.Колонки.Добавить("ШаблонСтеллажнойКарточки"    , Новый ОписаниеТипов("СправочникСсылка.ШаблоныЭтикетокИЦенников"));
	Товары.Колонки.Добавить("КоличествоСтеллажныхКарточек", Новый ОписаниеТипов("Число"));
	Товары.Колонки.Добавить("ОстатокНаСкладе"             , Новый ОписаниеТипов("Число"));
	Товары.Колонки.Добавить("КоличествоВДокументе"        , Новый ОписаниеТипов("Число"));
	
	Товары.Колонки.Добавить("Организация"                 , Новый ОписаниеТипов("СправочникСсылка.Организации"));
	
	НоваяСтрока = Товары.Добавить();
	НоваяСтрока.Номенклатура       = ДляЧего;
	НоваяСтрока.СерияНоменклатуры  = ПолучитьСериюНоменклатурыДляПечатиОбразца(ДляЧего);
	НоваяСтрока.Партия             = ПолучитьПартиюДляПечатиОбразца();
	НоваяСтрока.Цена               = 100;
	НоваяСтрока.КоличествоЭтикеток = 30;
	НоваяСтрока.Организация        = ПолучитьОрганизациюДляПечатиОбразца();
	
	НоваяСтрока.Штрихкод = "";
	Коды = ПолучитьОбразцыШтрихкодов();
	Для Каждого СтрокаТЧ Из Коды Цикл
		Если СтрокаТЧ.ТипКода = ТипКода Тогда
			НоваяСтрока.Штрихкод = СтрокаТЧ.Пример;
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
	ПараметрыПечати = Новый Структура;
	ПараметрыПечати.Вставить("Товары" , ПоместитьВоВременноеХранилище(Товары, УникальныйИдентификатор));
	ПараметрыПечати.Вставить("ВидЦены", ПолучитьВидЦеныДляПечатиОбразца());
	
	Возврат ПараметрыПечати;
	
КонецФункции

// Возвращает параметры для печати образца ценника товара
//
// Параметры:
//  ДляЧего                 - СправочникСсылка.Номенклатура - номенклатурная единица - образец
//  ТипКода                 - Число - тип штрихкода
//  УникальныйИдентификатор - УникальныйИдентификатор - уникальный идентификатор
//
// Возвращаемое значение:
//  ПараметрыПечати - Структура - параметры для передачи в менеджер печати.
//
Функция ПолучитьПараметрыДляПечатиОбразцаЦенникаТовара(ДляЧего, ТипКода, УникальныйИдентификатор) Экспорт
	
	Товары = Новый ТаблицаЗначений;
	Товары.Колонки.Добавить("Номенклатура"                , Новый ОписаниеТипов("СправочникСсылка.Номенклатура"));
	Товары.Колонки.Добавить("СерияНоменклатуры"           , Новый ОписаниеТипов("СправочникСсылка.СерииНоменклатуры"));
	Товары.Колонки.Добавить("Партия"                      , Новый ОписаниеТипов("СправочникСсылка.ПартииНоменклатуры"));
	Товары.Колонки.Добавить("Упаковка"                    , Новый ОписаниеТипов("СправочникСсылка.ЕдиницыИзмерения"));
	Товары.Колонки.Добавить("Цена"                        , Новый ОписаниеТипов("Число"));
	Товары.Колонки.Добавить("Штрихкод"                    , Новый ОписаниеТипов("Строка"));
	Товары.Колонки.Добавить("ШаблонЦенника"               , Новый ОписаниеТипов("СправочникСсылка.ШаблоныЭтикетокИЦенников"));
	Товары.Колонки.Добавить("КоличествоЦенников"          , Новый ОписаниеТипов("Число"));
	Товары.Колонки.Добавить("ШаблонЭтикетки"              , Новый ОписаниеТипов("СправочникСсылка.ШаблоныЭтикетокИЦенников"));
	Товары.Колонки.Добавить("КоличествоЭтикеток"          , Новый ОписаниеТипов("Число"));
	Товары.Колонки.Добавить("ШаблонСтеллажнойКарточки"    , Новый ОписаниеТипов("СправочникСсылка.ШаблоныЭтикетокИЦенников"));
	Товары.Колонки.Добавить("КоличествоСтеллажныхКарточек", Новый ОписаниеТипов("Число"));
	Товары.Колонки.Добавить("ОстатокНаСкладе"             , Новый ОписаниеТипов("Число"));
	Товары.Колонки.Добавить("КоличествоВДокументе"        , Новый ОписаниеТипов("Число"));
	
	Товары.Колонки.Добавить("Организация"                 , Новый ОписаниеТипов("СправочникСсылка.Организации"));
	
	НоваяСтрока = Товары.Добавить();
	НоваяСтрока.Номенклатура       = ДляЧего;
	НоваяСтрока.СерияНоменклатуры  = ПолучитьСериюНоменклатурыДляПечатиОбразца(ДляЧего);
	НоваяСтрока.Партия             = ПолучитьПартиюДляПечатиОбразца();
	НоваяСтрока.Цена               = 100;
	НоваяСтрока.КоличествоЦенников = 30;
	
	НоваяСтрока.Организация        = ПолучитьОрганизациюДляПечатиОбразца();
	
	НоваяСтрока.Штрихкод = "";
	Коды = ПолучитьОбразцыШтрихкодов();
	Для Каждого СтрокаТЧ Из Коды Цикл
		Если СтрокаТЧ.ТипКода = ТипКода Тогда
			НоваяСтрока.Штрихкод = СтрокаТЧ.Пример;
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
	ПараметрыПечати = Новый Структура;
	ПараметрыПечати.Вставить("Товары", ПоместитьВоВременноеХранилище(Товары, УникальныйИдентификатор));
	ПараметрыПечати.Вставить("ВидЦены", ПолучитьВидЦеныДляПечатиОбразца());
	
	Возврат ПараметрыПечати;
	
КонецФункции

// Возвращает параметры для печати образца стеллажной карточки товара
//
// Параметры:
//  ДляЧего                 - СправочникСсылка.Номенклатура - номенклатурная единица - образец
//  ТипКода                 - Число - тип штрихкода
//  УникальныйИдентификатор - УникальныйИдентификатор - уникальный идентификатор
//
// Возвращаемое значение:
//  ПараметрыПечати - Структура - параметры для передачи в менеджер печати.
//
Функция ПолучитьПараметрыДляПечатиОбразцаСтеллажнойКарточкиТовара(ДляЧего, ТипКода, УникальныйИдентификатор) Экспорт
	
	Товары = Новый ТаблицаЗначений;
	Товары.Колонки.Добавить("Номенклатура"                , Новый ОписаниеТипов("СправочникСсылка.Номенклатура"));
	Товары.Колонки.Добавить("СерияНоменклатуры"           , Новый ОписаниеТипов("СправочникСсылка.СерииНоменклатуры"));
	Товары.Колонки.Добавить("Партия"                      , Новый ОписаниеТипов("СправочникСсылка.ПартииНоменклатуры"));
	Товары.Колонки.Добавить("Упаковка"                    , Новый ОписаниеТипов("СправочникСсылка.ЕдиницыИзмерения"));
	Товары.Колонки.Добавить("Цена"                        , Новый ОписаниеТипов("Число"));
	Товары.Колонки.Добавить("Штрихкод"                    , Новый ОписаниеТипов("Строка"));
	Товары.Колонки.Добавить("ШаблонЦенника"               , Новый ОписаниеТипов("СправочникСсылка.ШаблоныЭтикетокИЦенников"));
	Товары.Колонки.Добавить("КоличествоЦенников"          , Новый ОписаниеТипов("Число"));
	Товары.Колонки.Добавить("ШаблонЭтикетки"              , Новый ОписаниеТипов("СправочникСсылка.ШаблоныЭтикетокИЦенников"));
	Товары.Колонки.Добавить("КоличествоЭтикеток"          , Новый ОписаниеТипов("Число"));
	Товары.Колонки.Добавить("ШаблонСтеллажнойКарточки"    , Новый ОписаниеТипов("СправочникСсылка.ШаблоныЭтикетокИЦенников"));
	Товары.Колонки.Добавить("КоличествоСтеллажныхКарточек", Новый ОписаниеТипов("Число"));
	Товары.Колонки.Добавить("ОстатокНаСкладе"             , Новый ОписаниеТипов("Число"));
	Товары.Колонки.Добавить("КоличествоВДокументе"        , Новый ОписаниеТипов("Число"));
	
	Товары.Колонки.Добавить("Организация"                 , Новый ОписаниеТипов("СправочникСсылка.Организации"));
	Товары.Колонки.Добавить("Склад"                       , Новый ОписаниеТипов("СправочникСсылка.Склады"));
	Товары.Колонки.Добавить("МестоХранения"               , Новый ОписаниеТипов("СправочникСсылка.МестаХранения"));
	Товары.Колонки.Добавить("ИсточникФинансирования"      , Новый ОписаниеТипов("СправочникСсылка.ИсточникиФинансирования"));
	Товары.Колонки.Добавить("Поставщик"                   , Новый ОписаниеТипов("СправочникСсылка.Контрагенты"));
	Товары.Колонки.Добавить("ДатаДокумента"               , Новый ОписаниеТипов("Дата"));
	
	НоваяСтрока = Товары.Добавить();
	НоваяСтрока.Номенклатура                 = ДляЧего;
	НоваяСтрока.СерияНоменклатуры            = ПолучитьСериюНоменклатурыДляПечатиОбразца(ДляЧего);
	НоваяСтрока.Партия                       = ПолучитьПартиюДляПечатиОбразца();
	НоваяСтрока.Цена                         = 100;
	НоваяСтрока.КоличествоСтеллажныхКарточек = 30;
	
	НоваяСтрока.Организация                  = ПолучитьОрганизациюДляПечатиОбразца();
	НоваяСтрока.Склад                        = ПолучитьСкладДляПечатиОбразца();
	НоваяСтрока.ИсточникФинансирования       = ПолучитьИсточникФинансированияДляПечатиОбразца();
	НоваяСтрока.Поставщик                    = ПолучитьПоставщикаДляПечатиОбразца();
	НоваяСтрока.ДатаДокумента                = ТекущаяДатаСеанса();
	
	НоваяСтрока.Штрихкод = "";
	Коды = ПолучитьОбразцыШтрихкодов();
	Для Каждого СтрокаТЧ Из Коды Цикл
		Если СтрокаТЧ.ТипКода = ТипКода Тогда
			НоваяСтрока.Штрихкод = СтрокаТЧ.Пример;
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
	ПараметрыПечати = Новый Структура;
	ПараметрыПечати.Вставить("Товары", ПоместитьВоВременноеХранилище(Товары, УникальныйИдентификатор));
	ПараметрыПечати.Вставить("ВидЦены", ПолучитьВидЦеныДляПечатиОбразца());
	
	Возврат ПараметрыПечати;
	
КонецФункции

#КонецОбласти // ПечатьОбразцов

#КонецОбласти // ПрограммныйИнтерфейс

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ
#Область СлужебныеПроцедурыИФункции

Процедура СкопироватьСвойстваТабличногоДокумента(Приемник, Источник)
	
	Приемник.АвтоМасштаб             = Источник.АвтоМасштаб;
	Приемник.ВысотаСтраницы          = Источник.ВысотаСтраницы;
	Приемник.ИмяПараметровПечати     = Источник.ИмяПараметровПечати;
	Приемник.ИмяПринтера             = Источник.ИмяПринтера;
	Приемник.КлючПараметровПечати    = Источник.КлючПараметровПечати;
	Приемник.КоличествоЭкземпляров   = Источник.КоличествоЭкземпляров;
	Приемник.МасштабПечати           = Источник.МасштабПечати;
	Приемник.ОриентацияСтраницы      = Источник.ОриентацияСтраницы;
	Приемник.ПолеСверху              = Источник.ПолеСверху;
	Приемник.ПолеСлева               = Источник.ПолеСлева;
	Приемник.ПолеСнизу               = Источник.ПолеСнизу;
	Приемник.ПолеСправа              = Источник.ПолеСправа;
	Приемник.РазборПоКопиям          = Источник.РазборПоКопиям;
	Приемник.РазмерКолонтитулаСверху = Источник.РазмерКолонтитулаСверху;
	Приемник.РазмерКолонтитулаСнизу  = Источник.РазмерКолонтитулаСнизу;
	Приемник.РазмерСтраницы          = Источник.РазмерСтраницы;
	Приемник.ТочностьПечати          = Источник.ТочностьПечати;
	Приемник.ЧерноБелаяПечать        = Источник.ЧерноБелаяПечать;
	Приемник.ШиринаСтраницы          = Источник.ШиринаСтраницы;
	Приемник.ЭкземпляровНаСтранице   = Источник.ЭкземпляровНаСтранице;
	
КонецПроцедуры

Функция РазмерСтраницы(ПолеТабличногоДокумента)
	
	ВысотаСтраницы = ПолеТабличногоДокумента.ВысотаСтраницы;
	ШиринаСтраницы = ПолеТабличногоДокумента.ШиринаСтраницы;
	
	Наименование = Строка(ШиринаСтраницы)+"х"+Строка(ВысотаСтраницы);
	
	Если ШиринаСтраницы = 210 И ВысотаСтраницы = 297 Тогда
		Наименование = "A4";
	ИначеЕсли ШиринаСтраницы = 148 И ВысотаСтраницы = 210 Тогда
		Наименование = "A5";
	ИначеЕсли ШиринаСтраницы = 105 И ВысотаСтраницы = 148 Тогда
		Наименование = "A6";
	ИначеЕсли ШиринаСтраницы = 74 И ВысотаСтраницы = 105 Тогда
		Наименование = "A7";
	ИначеЕсли ШиринаСтраницы = 52 И ВысотаСтраницы = 74 Тогда
		Наименование = "A8";
	ИначеЕсли ШиринаСтраницы = 37 И ВысотаСтраницы = 52 Тогда
		Наименование = "A9";
	ИначеЕсли ШиринаСтраницы = 26 И ВысотаСтраницы = 37 Тогда
		Наименование = "A10";
	КонецЕсли;
	
	Возврат Наименование;
	
КонецФункции

Функция ПозицииПараметров(ТекстЯчейки)
	
	Массив = Новый Массив;
	
	Начало = -1;
	Конец  = -1;
	СчетчикСкобокОткрывающих = 0;
	СчетчикСкобокЗакрывающих = 0;
	
	Для Индекс = 1 По СтрДлина(ТекстЯчейки) Цикл
		ТекущийСимвол = Сред(ТекстЯчейки, Индекс, 1);
		Если ТекущийСимвол = "[" Тогда
			СчетчикСкобокОткрывающих = СчетчикСкобокОткрывающих + 1;
			Если СчетчикСкобокОткрывающих = 1 Тогда
				Начало = Индекс;
			КонецЕсли;
		ИначеЕсли ТекущийСимвол = "]" Тогда
			СчетчикСкобокЗакрывающих = СчетчикСкобокЗакрывающих + 1;
			Если СчетчикСкобокЗакрывающих = СчетчикСкобокОткрывающих Тогда
				Конец = Индекс;
				
				Массив.Добавить(Новый Структура("Начало, Конец", Начало, Конец));
				
				Начало = -1;
				Конец  = -1;
				СчетчикСкобокОткрывающих = 0;
				СчетчикСкобокЗакрывающих = 0;
				
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
	Возврат Массив;
	
КонецФункции

Функция ИмяПараметраШтрихкод() Экспорт
	
	Возврат "Штрихкод";
	
КонецФункции

Функция ИмяПараметраКодВалюты() Экспорт
	
	Возврат "ВидЦены.ВалютаЦены.Код";
	
КонецФункции

Функция ПолучитьОрганизациюДляПечатиОбразца()
	
	Запрос = Новый Запрос("
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ ПЕРВЫЕ 1
	|	Данные.Ссылка КАК Ссылка
	|ИЗ
	|	Справочник.Организации КАК Данные
	|ГДЕ
	|	НЕ Данные.ПометкаУдаления
	|	И НЕ Данные.Предопределенный
	|");
	
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		Возврат Выборка.Ссылка;
	Иначе
		Возврат Справочники.Организации.ПустаяСсылка();
	КонецЕсли;
	
КонецФункции

Функция ПолучитьВидЦеныДляПечатиОбразца()
	
	Запрос = Новый Запрос("
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ ПЕРВЫЕ 1
	|	Данные.Ссылка КАК Ссылка
	|ИЗ
	|	Справочник.ВидыЦен КАК Данные
	|ГДЕ
	|	НЕ Данные.ПометкаУдаления
	|");
	
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		Возврат Выборка.Ссылка;
	Иначе
		Возврат Справочники.ВидыЦен.ПустаяСсылка();
	КонецЕсли;
	
КонецФункции

Функция ПолучитьСкладДляПечатиОбразца()
	
	Запрос = Новый Запрос("
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ ПЕРВЫЕ 1
	|	Данные.Ссылка КАК Ссылка
	|ИЗ
	|	Справочник.Склады КАК Данные
	|ГДЕ
	|	НЕ Данные.ПометкаУдаления
	|	И НЕ Данные.ЭтоГруппа
	|");
	
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		Возврат Выборка.Ссылка;
	Иначе
		Возврат Справочники.Склады.ПустаяСсылка();
	КонецЕсли;
	
КонецФункции

Функция ПолучитьПоставщикаДляПечатиОбразца()
	
	Запрос = Новый Запрос("
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ ПЕРВЫЕ 1
	|	Данные.Ссылка КАК Ссылка
	|ИЗ
	|	Справочник.Контрагенты КАК Данные
	|ГДЕ
	|	НЕ Данные.ПометкаУдаления
	|	И НЕ Данные.ЭтоГруппа
	|");
	
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		Возврат Выборка.Ссылка;
	Иначе
		Возврат Справочники.Контрагенты.ПустаяСсылка();
	КонецЕсли;
	
КонецФункции

Функция ПолучитьИсточникФинансированияДляПечатиОбразца()
	
	Запрос = Новый Запрос("
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ ПЕРВЫЕ 1
	|	Данные.Ссылка КАК Ссылка
	|ИЗ
	|	Справочник.ИсточникиФинансирования КАК Данные
	|ГДЕ
	|	НЕ Данные.ПометкаУдаления
	|	И НЕ Данные.ЭтоГруппа
	|");
	
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		Возврат Выборка.Ссылка;
	Иначе
		Возврат Справочники.ИсточникиФинансирования.ПустаяСсылка();
	КонецЕсли;
	
КонецФункции

Функция ПолучитьСериюНоменклатурыДляПечатиОбразца(Номенклатура)
	
	Запрос = Новый Запрос("
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ ПЕРВЫЕ 1
	|	Данные.Ссылка КАК Ссылка
	|ИЗ
	|	Справочник.СерииНоменклатуры КАК Данные
	|ГДЕ
	|	Данные.Владелец = &Номенклатура
	|	И НЕ Данные.ПометкаУдаления
	|");
	Запрос.УстановитьПараметр("Номенклатура", Номенклатура);
	
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		Возврат Выборка.Ссылка;
	Иначе
		Возврат Справочники.СерииНоменклатуры.ПустаяСсылка();
	КонецЕсли;
	
КонецФункции

Функция ПолучитьПартиюДляПечатиОбразца()
	
	Запрос = Новый Запрос("
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ ПЕРВЫЕ 1
	|	Данные.Ссылка КАК Ссылка
	|ИЗ
	|	Справочник.ПартииНоменклатуры КАК Данные
	|ГДЕ
	|	НЕ Данные.ПометкаУдаления
	|");
	
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		Возврат Выборка.Ссылка;
	Иначе
		Возврат Справочники.ПартииНоменклатуры.ПустаяСсылка();
	КонецЕсли;
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// Команды формы
#Область КомандыФормы

// Заполняет список команд ввода на основании.
// 
// Параметры:
//   КомандыСоздатьНаОсновании - ТаблицаЗначений - Таблица команд для вывода в подменю. Для изменения.
//
Процедура ДобавитьКомандыСозданияНаОсновании(КомандыСоздатьНаОсновании, НастройкиФормы) Экспорт
	
	ВводНаОснованииБольничнаяАптека.ДобавитьКомандыСозданияНаОсновании(ПустаяСсылка().Метаданные().ПолноеИмя(), КомандыСоздатьНаОсновании, НастройкиФормы);
	
КонецПроцедуры

#КонецОбласти // КомандыФормы

#КонецОбласти // СлужебныеПроцедурыИФункции

////////////////////////////////////////////////////////////////////////////////
// ОБНОВЛЕНИЕ ИНФОРМАЦИОННОЙ БАЗЫ
#Область ОбновлениеИнформационнойБазы

Процедура ЗарегистрироватьДанныеКОбработкеДляПереходаНаНовуюВерсию(Параметры) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = "
	|ВЫБРАТЬ
	|	Справочник.Ссылка КАК Ссылка
	|ИЗ
	|	Справочник.ШаблоныЭтикетокИЦенников КАК Справочник
	|ГДЕ
	|	Справочник.Назначение = ЗНАЧЕНИЕ(Перечисление.НазначенияШаблоновЭтикетокИЦенников.СтеллажнаяКарточкаДляТовара)
	|";
	
	ОбновлениеИнформационнойБазы.ОтметитьКОбработке(Параметры, Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Ссылка"));
	
КонецПроцедуры

Процедура ОбработатьДанныеДляПереходаНаНовуюВерсию(Параметры) Экспорт
	
	МетаданныеОбъекта = ПустаяСсылка().Метаданные();
	ПолноеИмяОбъекта = МетаданныеОбъекта.ПолноеИмя();
	
	Выборка = ОбновлениеИнформационнойБазы.ВыбратьСсылкиДляОбработки(Параметры.Очередь, ПолноеИмяОбъекта);
	
	Пока Выборка.Следующий() Цикл
		
		НачатьТранзакцию();
		Попытка
			
			ОбщегоНазначенияБольничнаяАптека.ЗаблокироватьСсылку(Выборка.Ссылка);
			
			Объект = Выборка.Ссылка.ПолучитьОбъект();
			
			Если Объект = Неопределено Или Объект.Назначение <> Перечисления.НазначенияШаблоновЭтикетокИЦенников.СтеллажнаяКарточкаДляТовара Тогда
				ОбновлениеИнформационнойБазы.ОтметитьВыполнениеОбработки(Выборка.Ссылка);
			Иначе
				
				ПараметрыШаблона = Объект.Шаблон.Получить();
				НовыеПараметрыШаблона = ПодготовитьСтруктуруМакетаШаблона(ПараметрыШаблона.РедакторТабличныйДокумент, Объект.Назначение);
				ЗаполнитьЗначенияСвойств(НовыеПараметрыШаблона, ПараметрыШаблона, "ТипКода, РазмерШрифта, ОтображатьТекст");
				Объект.Шаблон = Новый ХранилищеЗначения(НовыеПараметрыШаблона);
				
			КонецЕсли;
			
			ОбновлениеИнформационнойБазы.ЗаписатьДанные(Объект);
			ЗафиксироватьТранзакцию();
			
		Исключение
			
			ОтменитьТранзакцию();
			ТекстСообщения = НСтр("ru = 'Не удалось обработать: %Объект% по причине: %Причина%'", ОбщегоНазначения.КодОсновногоЯзыка());
			ТекстСообщения = СтрЗаменить(ТекстСообщения, "%Объект%", Выборка.Ссылка);
			ТекстСообщения = СтрЗаменить(ТекстСообщения, "%Причина%", ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
			ЗаписьЖурналаРегистрации(
				ОбновлениеИнформационнойБазы.СобытиеЖурналаРегистрации(),
				УровеньЖурналаРегистрации.Предупреждение,
				МетаданныеОбъекта,
				Выборка.Ссылка,
				ТекстСообщения);
				
		КонецПопытки;
		
	КонецЦикла;
	
	Параметры.ОбработкаЗавершена = ОбновлениеИнформационнойБазы.ОбработкаДанныхЗавершена(Параметры.Очередь, ПолноеИмяОбъекта);
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли