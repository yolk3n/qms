﻿
////////////////////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС
#Область ПрограммныйИнтерфейс

// Выводит штрихкод в табличный документ.
//
// Параметры:
//  Ссылка            - ЛюбаяСсылка - ссылка для которой формируется штрихкод.
//  ТабличныйДокумент - ТабличныйДокумент - куда выводится штрихкод.
//  Макет             - ТабличныйДокумент - макет с областью "ОбластьШтрихкода", в которой есть картинка "КартинкаШтрихкода".
//  ОбластьМакета     - ТабличныйДокумент - Область макета с картинкой "КартинкаШтрихкода"
//
Процедура ВывестиШтрихкодВТабличныйДокумент(Ссылка, ТабличныйДокумент, Макет, Знач ОбластьМакета = Неопределено) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	ВыводитьШтрихкодВОтдельнуюОбласть = Ложь;
	Если ОбластьМакета = Неопределено Или Не ЕстьКартинкаШтрихкодаВОбластиМакета(ОбластьМакета) Тогда
		// Картинки штрихкода в этой области макета нет.
		
		Если Макет.Области.Найти("ОбластьШтрихкода") <> Неопределено Тогда
			
			// Проверить картинку штрихкода в области "Штрихкод"
			ОбластьМакетаШтрихкод = Макет.ПолучитьОбласть("ОбластьШтрихкода");
			Если ЕстьКартинкаШтрихкодаВОбластиМакета(ОбластьМакетаШтрихкод) Тогда
				ОбластьМакета = ОбластьМакетаШтрихкод;
				ВыводитьШтрихкодВОтдельнуюОбласть = Истина;
			Иначе
				Возврат;
			КонецЕсли;
		Иначе
			Возврат;
		КонецЕсли;
		
	КонецЕсли;
	
	Если Не ПолучитьФункциональнуюОпцию("ИспользоватьШтрихкодированиеПечатныхФормОбъектов") Тогда
		ОбластьМакета.Рисунки.Удалить(ОбластьМакета.Рисунки.КартинкаШтрихкода);
		Возврат;
	КонецЕсли;
	
	Эталон = Обработки.ПечатьЭтикетокИЦенников.ПолучитьМакет("Эталон");
	КоличествоМиллиметровВПикселе = Эталон.Рисунки.Квадрат100Пикселей.Высота / 100;
	
	ПараметрыШтрихкода = ГенерацияШтрихкода.ПараметрыГенерацииШтрихкода();
	ПараметрыШтрихкода.Ширина          = Окр(ОбластьМакета.Рисунки.КартинкаШтрихкода.Ширина / КоличествоМиллиметровВПикселе);
	ПараметрыШтрихкода.Высота          = Окр(ОбластьМакета.Рисунки.КартинкаШтрихкода.Высота / КоличествоМиллиметровВПикселе);
	ПараметрыШтрихкода.Штрихкод        = СокрЛП(ШтрихкодированиеКлиентСервер.ЧисловойКодПоСсылке(Ссылка));
	ПараметрыШтрихкода.ТипКода         = 4; // Code128
	ПараметрыШтрихкода.ОтображатьТекст = Ложь;
	ПараметрыШтрихкода.РазмерШрифта    = 6;
	
	ОбластьМакета.Рисунки.КартинкаШтрихкода.Картинка = ГенерацияШтрихкода.ИзображениеШтрихкода(ПараметрыШтрихкода).Картинка;
	
	Если ВыводитьШтрихкодВОтдельнуюОбласть Тогда
		ТабличныйДокумент.Вывести(ОбластьМакета);
	КонецЕсли;
	
КонецПроцедуры

// Возвращает список ссылок по штрихкоду.
//
// Параметры:
//  Штрихкод - Строка - штрихкод печатной формы.
//  Типы     - Массив(Тип) - список типов объектов для поиска
//
// Возвращаемое значение:
//  Массив - список найденных ссылок
//
Функция ПолучитьСсылкуПоШтрихкодуТабличногоДокумента(Штрихкод, Типы = Неопределено) Экспорт
	
	УникальныйИдентификатор = ШтрихкодированиеКлиентСервер.УникальныйИдентификаторПоШтрихкоду(Штрихкод);
	Если УникальныйИдентификатор = Неопределено Тогда
		Возврат Новый Массив;
	КонецЕсли;
	
	Если Типы = Неопределено Тогда
		МенеджерыОбъектов = Новый Массив;
		Для Каждого ЭлементМетаданных Из Метаданные.Документы Цикл
			МенеджерыОбъектов.Добавить(Документы[ЭлементМетаданных.Имя]);
		КонецЦикла;
	Иначе
		МенеджерыОбъектов = Новый Массив();
		Для Каждого ТипСсылки Из Типы Цикл
			МетаданныеСсылки = Метаданные.НайтиПоТипу(ТипСсылки);
			Если МетаданныеСсылки = Неопределено
			 Или Не ОбщегоНазначения.ЭтоСправочник(МетаданныеСсылки)
			   И Не ОбщегоНазначения.ЭтоДокумент(МетаданныеСсылки)
			   И Не ОбщегоНазначения.ЭтоЗадача(МетаданныеСсылки)
			   И Не ОбщегоНазначения.ЭтоБизнесПроцесс(МетаданныеСсылки)
			   И Не ОбщегоНазначения.ЭтоПланВидовХарактеристик(МетаданныеСсылки) Тогда
				
				ТекстИсключения = НСтр("ru = 'Ошибка распознавания штрихкода: тип ""%Тип%"" не поддерживается.'");
				ТекстИсключения = СтрЗаменить(ТекстИсключения, "%Тип%", ТипСсылки);
				ВызватьИсключение ТекстИсключения;
			КонецЕсли;
			
			МенеджерыОбъектов.Добавить(ОбщегоНазначения.МенеджерОбъектаПоПолномуИмени(МетаданныеСсылки.ПолноеИмя()));
			
		КонецЦикла;
	КонецЕсли;
	
	ШаблонЗапроса = "
	|ВЫБРАТЬ //РАЗРЕШЕННЫЕ
	|	Таблица.Ссылка КАК Ссылка
	|ИЗ
	|	#Таблица КАК Таблица
	|ГДЕ
	|	Таблица.Ссылка В (&Ссылки)
	|";
	
	СписокСсылок = Новый Массив;
	ПервыйЗапрос = Истина;
	ТекстЗапроса = "";
	Для Каждого Менеджер Из МенеджерыОбъектов Цикл
		
		Попытка
			Ссылка = Менеджер.ПолучитьСсылку(УникальныйИдентификатор);
		Исключение
			Продолжить;
		КонецПопытки;
		
		МетаданныеСсылки = Ссылка.Метаданные();
		Если Не ПравоДоступа("Чтение", МетаданныеСсылки) Тогда
			Продолжить;
		КонецЕсли;
		
		СписокСсылок.Добавить(Ссылка);
		
		Если Не ПервыйЗапрос Тогда
			ТекстЗапроса = ТекстЗапроса + "
			|ОБЪЕДИНИТЬ ВСЕ
			|";
		КонецЕсли;
		
		ТекущийЗапрос = СтрЗаменить(ШаблонЗапроса, "#Таблица", МетаданныеСсылки.ПолноеИмя());
		Если ПервыйЗапрос Тогда
			ТекущийЗапрос = СтрЗаменить(ТекущийЗапрос, "//РАЗРЕШЕННЫЕ", "РАЗРЕШЕННЫЕ");
		КонецЕсли;
		
		ТекстЗапроса = ТекстЗапроса + ТекущийЗапрос;
		
		ПервыйЗапрос = Ложь;
		
	КонецЦикла;
	
	Если Не ПервыйЗапрос Тогда
		Запрос = Новый Запрос(ТекстЗапроса);
		Запрос.УстановитьПараметр("Ссылки", СписокСсылок);
		Возврат Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Ссылка");
	Иначе
		Возврат Новый Массив;
	КонецЕсли;
	
КонецФункции

// Возвращает доступные типы объектов поля Ссылка динамического списка
//
// Параметры:
//  Список  - ДинамическийСписок - список из которого будут получаться типы
//
// Возвращаемое значение:
//  Массив - доступные типы объектов поля Ссылка динамического списка
//
Функция ТипыОбъектовДинамическогоСписка(Список) Экспорт
	
	ПолеСсылка = Список.КомпоновщикНастроек.Настройки.ДоступныеПоляВыбора.НайтиПоле(Новый ПолеКомпоновкиДанных("Ссылка"));
	Если ПолеСсылка <> Неопределено Тогда
		ДоступныеТипы = Новый Массив;
		Для Каждого Тип Из ПолеСсылка.Тип.Типы() Цикл
			Если ОбщегоНазначения.ОбъектМетаданныхДоступенПоФункциональнымОпциям(Метаданные.НайтиПоТипу(Тип)) Тогда
				ДоступныеТипы.Добавить(Тип);
			КонецЕсли;
		КонецЦикла;
		Возврат ДоступныеТипы;
	КонецЕсли;
	
	Если Не ПустаяСтрока(Список.ОсновнаяТаблица) Тогда
		Если Не ОбщегоНазначения.ОбъектМетаданныхДоступенПоФункциональнымОпциям(Метаданные.НайтиПоПолномуИмени(Список.ОсновнаяТаблица)) Тогда
			Возврат Новый Массив;
		КонецЕсли;
	КонецЕсли;
	
	ВызватьИсключение НСтр("ru = 'В списке отсутствует поле ""Ссылка""'");;
	
КонецФункции

#КонецОбласти

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ
#Область СлужебныеПроцедурыИФункции

Функция ЕстьКартинкаШтрихкодаВОбластиМакета(ОбластьМакета)
	
	СтруктураПоиска = Новый Структура;
	КартинкаОтсутствует = Новый УникальныйИдентификатор;
	СтруктураПоиска.Вставить("КартинкаШтрихкода", КартинкаОтсутствует);
	
	ЗаполнитьЗначенияСвойств(СтруктураПоиска, ОбластьМакета.Рисунки);
	
	Возврат СтруктураПоиска.КартинкаШтрихкода <> КартинкаОтсутствует;
	
КонецФункции

#КонецОбласти // СлужебныеПроцедурыИФункции
