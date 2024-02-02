﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

////////////////////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС
#Область ПрограммныйИнтерфейс

// Проверяет применимость условия маршрутизации к объекту.
//
// Параметры:
//  Предмет - ссылка на документ
//  СсылкаНаУсловие - ссылка на условие маршрутизации
//
// Возвращаемое значение:
//  Истина, если условие применимо
//  Ложь, если условие неприменимо или указаны пустые ссылки
//
Функция ПроверитьПрименимостьУсловияМаршрутизацииКОбъекту(Знач Предмет, Условие) Экспорт
	
	Если Не ЗначениеЗаполнено(Условие) Тогда
		Возврат Истина;
	КонецЕсли;
	
	ЗапрашиваемыеРеквизиты = Новый Структура;
	ЗапрашиваемыеРеквизиты.Вставить("Ссылка");
	ЗапрашиваемыеРеквизиты.Вставить("Наименование");
	ЗапрашиваемыеРеквизиты.Вставить("ИдентификаторОбъекта");
	ЗапрашиваемыеРеквизиты.Вставить("СпособЗаданияУсловия");
	ЗапрашиваемыеРеквизиты.Вставить("ВыражениеУсловия");
	ЗапрашиваемыеРеквизиты.Вставить("НастройкаУсловия");
	ЗапрашиваемыеРеквизиты.Вставить("НастройкаКомбинацииУсловий");
	
	ПараметрыУсловия = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Условие, ЗапрашиваемыеРеквизиты);
	
	МетаданныеОбъекта = ОбщегоНазначения.ОбъектМетаданныхПоИдентификатору(ПараметрыУсловия.ИдентификаторОбъекта);
	ПустаяСсылка = ОбщегоНазначения.МенеджерОбъектаПоПолномуИмени(МетаданныеОбъекта.ПолноеИмя()).ПустаяСсылка();
	
	Если Не ЗначениеЗаполнено(Предмет) Тогда
		Предмет = ПустаяСсылка
	КонецЕсли;
	
	Если ТипЗнч(Предмет) <> ТипЗнч(ПустаяСсылка) Тогда
		Возврат Ложь;
	КонецЕсли;
	
	СпособЗаданияУсловия = ПараметрыУсловия.СпособЗаданияУсловия;
	Если СпособЗаданияУсловия = Перечисления.СпособыЗаданияУсловия.НаВстроенномЯзыке Тогда
		Возврат ПроверитьУсловиеНаВстроенномЯзыке(Предмет, ПараметрыУсловия);
	КонецЕсли;
		
	Если СпособЗаданияУсловия = Перечисления.СпособыЗаданияУсловия.ВРежимеКонструктора Тогда
		Возврат ПроверитьУсловиеВРежимеКонструктора(Предмет, ПараметрыУсловия.НастройкаУсловия.Получить());
	КонецЕсли;
		
	Если СпособЗаданияУсловия = Перечисления.СпособыЗаданияУсловия.КомбинацияИзДругихУсловий Тогда
		
		Настройки = МетаданныеОбъекта.НастройкаКомбинацииУсловий.Получить();
		ЗаполнитьКомбинациюПравил(Предмет, Настройки.Отбор.Элементы);
		Возврат ПроверитьУсловиеВРежимеКонструктора(Предмет, Настройки,	Истина);
		
	КонецЕсли;
	
	Возврат Ложь;
	
КонецФункции

#КонецОбласти // ПрограммныйИнтерфейс

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЙ ПРОГРАММНЫЙ ИНТЕРФЕЙС
#Область СлужебныйПрограммныйИнтерфейс

// Создает схему компоновки данных по предмету для условий маршрутизации
//
// Параметры:
//  Предмет - СправочникСсылка.ИдентификаторыОбъектовМетаданных, ЛюбаяСсылка
//
// Возвращаемое значение:
//  СхемаКомпоновкиДанных
//
Функция СхемаКомпоновкиДанныхПоПредмету(Предмет) Экспорт
	
	ТипПредмета = ТипЗнч(Предмет);
	Если ТипПредмета = Тип("СправочникСсылка.ИдентификаторыОбъектовМетаданных") Тогда
		МетаданныеПредмета = ОбщегоНазначения.ОбъектМетаданныхПоИдентификатору(Предмет);
	ИначеЕсли ОбщегоНазначения.ЭтоСсылка(ТипПредмета) Тогда
		МетаданныеПредмета = Предмет.Метаданные();
	КонецЕсли;
	
	СхемаКомпоновкиДанных = Новый СхемаКомпоновкиДанных;
	
	ИсточникДанных = СхемаКомпоновкиДанных.ИсточникиДанных.Добавить();
	ИсточникДанных.Имя = "Источник";
	ИсточникДанных.ТипИсточникаДанных = "local";
	
	НаборДанных = СхемаКомпоновкиДанных.НаборыДанных.Добавить(Тип("НаборДанныхЗапросСхемыКомпоновкиДанных"));
	ТекстЗапроса =
	"ВЫБРАТЬ
	|	*
	|ИЗ
	|	%1 КАК Таблица
	|ГДЕ
	|	Таблица.Ссылка = &Предмет
	|";
	ИмяТаблицы = МетаданныеПредмета.ПолноеИмя();
	НаборДанных.Запрос = СтрШаблон(ТекстЗапроса, ИмяТаблицы);
	
	НаборДанных.АвтоЗаполнениеДоступныхПолей = Истина;
	НаборДанных.ИсточникДанных = СхемаКомпоновкиДанных.ИсточникиДанных[0].Имя;
	НаборДанных.Имя = "Набор";
	
	Поле = НаборДанных.Поля.Добавить(Тип("ПолеНабораДанныхСхемыКомпоновкиДанных"));
	Поле.Поле = "Ссылка";
	
	Если СхемаКомпоновкиДанных.ВариантыНастроек.Количество() Тогда
		Вариант = СхемаКомпоновкиДанных.ВариантыНастроек[0];
	Иначе
		Вариант = СхемаКомпоновкиДанных.ВариантыНастроек.Добавить();
		Вариант.Имя = "Основной";
	КонецЕсли;
	Группировка = Вариант.Настройки.Структура.Добавить(Тип("ГруппировкаКомпоновкиДанных"));
	Поле = Группировка.ПоляГруппировки.Элементы.Добавить(Тип("ПолеГруппировкиКомпоновкиДанных"));
	Поле.Поле = Новый ПолеКомпоновкиДанных("Ссылка");
	
	Группировка.Выбор.Элементы.Добавить(Тип("АвтоВыбранноеПолеКомпоновкиДанных"));
	
	Возврат СхемаКомпоновкиДанных;
	
КонецФункции

#КонецОбласти // СлужебныйПрограммныйИнтерфейс

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ
#Область СлужебныеПроцедурыИФункции

Функция ПроверитьУсловиеНаВстроенномЯзыке(Предмет, Условие)
	
	Попытка
		Выражение = "Результат = Неопределено;
					|Предмет   = Параметры.Предмет;
					|" + Условие.ВыражениеУсловия + ";
					|Параметры.Результат = Результат;";
		ПараметрыМетода = Новый Структура("Предмет, Результат", Предмет, Неопределено);
		ОбщегоНазначения.ВыполнитьВБезопасномРежиме(Выражение, ПараметрыМетода);
		
		Результат = ПараметрыМетода.Результат;
		Если ТипЗнч(Результат) <> Тип("Булево") Тогда
			ВызватьИсключение НСтр("ru = 'Переменной ""Результат"" необходимо присвоить значение типа ""Булево""'");
		КонецЕсли;
	Исключение
		Информация = ИнформацияОбОшибке();
		ЗаписьЖурналаРегистрации(
			НСтр("ru = 'Проверка условия маршрутизации'", ОбщегоНазначения.КодОсновногоЯзыка()),
			УровеньЖурналаРегистрации.Ошибка,
			Условие.Ссылка.Метаданные(),
			Условие.Ссылка,
			ПодробноеПредставлениеОшибки(Информация));
		ТекстИсключения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'При проверке условия маршрутизации ""%1"" возникла ошибка:
				|%2'"),
			Условие.Наименование,
			Информация.Описание);
		Если ТипЗнч(Информация.Причина) = Тип("ИнформацияОбОшибке") Тогда
			ОписаниеПричины = Информация.Причина.Описание;
			ТекстИсключения = ТекстИсключения + Символы.ПС + НСтр("ru = 'По причине'") + ":" + Символы.ПС + ОписаниеПричины;
		КонецЕсли;
		ТекстИсключения = ТекстИсключения + Символы.ПС + НСтр("ru = 'Обратитесь к администратору.'");
		ВызватьИсключение ТекстИсключения;
	КонецПопытки;
	
	Возврат Результат;
	
КонецФункции

Функция ПроверитьУсловиеВРежимеКонструктора(Предмет, Настройки, ПроверитьКомбинациюУсловий = Ложь)
	
	Если ПроверитьКомбинациюУсловий Тогда
		СхемаКомпоновкиДанных = Справочники.УсловияМаршрутизации.ПолучитьМакет("Условия");
	Иначе
		СхемаКомпоновкиДанных = СхемаКомпоновкиДанныхПоПредмету(Предмет);
	КонецЕсли;
	
	Компоновщик = Новый КомпоновщикНастроекКомпоновкиДанных;
	URLСхемы = ПоместитьВоВременноеХранилище(СхемаКомпоновкиДанных, Новый УникальныйИдентификатор());
	ИсточникНастроек = Новый ИсточникДоступныхНастроекКомпоновкиДанных(URLСхемы);
	Компоновщик.Инициализировать(ИсточникНастроек);
	Компоновщик.ЗагрузитьНастройки(Настройки);
	
	Если Не ПроверитьКомбинациюУсловий Тогда
		
		ПараметрПредмет = Компоновщик.Настройки.ПараметрыДанных.Элементы[0];
		ПараметрПредмет.Значение = Предмет;
		ПараметрПредмет.Использование = Истина;
		
	КонецЕсли;
	
	КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных;
	
	МакетКомпоновки = КомпоновщикМакета.Выполнить(СхемаКомпоновкиДанных, Компоновщик.ПолучитьНастройки(),,, Тип("ГенераторМакетаКомпоновкиДанныхДляКоллекцииЗначений"));
	ПроцессорКомпоновки = Новый ПроцессорКомпоновкиДанных;
	ПроцессорКомпоновки.Инициализировать(МакетКомпоновки);
	ТаблицаРезультата = Новый ТаблицаЗначений;
	ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВКоллекциюЗначений;
	ПроцессорВывода.УстановитьОбъект(ТаблицаРезультата);
	ПроцессорВывода.Вывести(ПроцессорКомпоновки);
	
	Возврат (ТаблицаРезультата.Количество() > 0);
	
КонецФункции

Процедура ЗаполнитьКомбинациюПравил(Предмет, ЭлементыКомбинации)
	
	Для Каждого ЭлементОтбора Из ЭлементыКомбинации Цикл
		Если ТипЗнч(ЭлементОтбора) = Тип("ГруппаЭлементовОтбораКомпоновкиДанных") Тогда
			ЗаполнитьКомбинациюПравил(Предмет, ЭлементОтбора.Элементы);
		Иначе
			
			Результат = ПроверитьПрименимостьУсловияМаршрутизацииКОбъекту(Предмет, ЭлементОтбора.ПравоеЗначение);
			
			ПолеОтбора = Новый ПолеКомпоновкиДанных("ПолеДляПроверки");
			ЭлементОтбора.ЛевоеЗначение = ПолеОтбора;
			ЭлементОтбора.Использование = Истина;
			ЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
			ЭлементОтбора.ПравоеЗначение = Результат;
			
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти // СлужебныеПроцедурыИФункции

#КонецЕсли