﻿
// Возвращает транспортные модули по отбору.
//
// Параметры:
//  Отбор - Структура - отбор.
// 
// Возвращаемое значение:
//  Массив - транспортные модули.
//
Функция ДоступныеТранспортныеМодули(Знач Отбор = Неопределено) Экспорт
	
	ТекстЗапроса = "
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ОрганизацииМДЛП.Ссылка                         КАК Организация,
	|	ОрганизацииМДЛП.РегистрационныйНомерУчастника  КАК ИдентификаторОрганизации,
	|	МестаДеятельностиМДЛП.Ссылка                   КАК МестоДеятельности,
	|	МестаДеятельностиМДЛП.Идентификатор            КАК ИдентификаторСубъектаОбращения,
	|	Регистраторы.Ссылка                            КАК Регистратор,
	|	Регистраторы.Адрес                             КАК Адрес,
	|	Регистраторы.Логин                             КАК Логин
	|ИЗ
	|	Справочник.РегистраторыМДЛП КАК Регистраторы
	|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ
	|		РегистрСведений.РабочиеМестаМДЛП КАК РабочиеМеста
	|	ПО
	|		РабочиеМеста.РегистраторВыбытия = Регистраторы.Ссылка
	|		И РабочиеМеста.РабочееМесто = &ТекущееРабочееМесто
	|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ
	|		Справочник.МестаДеятельностиМДЛП КАК МестаДеятельностиМДЛП
	|	ПО
	|		МестаДеятельностиМДЛП.Ссылка = Регистраторы.Владелец
	|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ
	|		Справочник.ОрганизацииМДЛП КАК ОрганизацииМДЛП
	|	ПО
	|		ОрганизацииМДЛП.Ссылка = МестаДеятельностиМДЛП.Организация
	|	
	|ГДЕ
	|	ОрганизацииМДЛП.СобственнаяОрганизация
	|	И НЕ ОрганизацииМДЛП.ПометкаУдаления
	|	И МестаДеятельностиМДЛП.ВестиУчетВЭтойИБ
	|	И Не Регистраторы.ПометкаУдаления
	|	И Регистраторы.Активно
	|";
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ТекущееРабочееМесто", МенеджерОборудованияВызовСервера.РабочееМестоКлиента());
	
	СхемаЗапроса = Новый СхемаЗапроса;
	СхемаЗапроса.УстановитьТекстЗапроса(ТекстЗапроса);
	
	ОператорВыбрать = СхемаЗапроса.ПакетЗапросов[0].Операторы[0];
	
	Индекс = 0;
	Если Отбор <> Неопределено Тогда
		Для Каждого Элемент Из Отбор Цикл
			
			Если ВРег(Элемент.Поле) = ВРег("Организация") Тогда
				ОператорВыбрать.Отбор.Добавить("ОрганизацииМДЛП.Ссылка = &Параметр_" + Индекс);
			ИначеЕсли ВРег(Элемент.Поле) = ВРег("МестоДеятельности") Тогда
				ОператорВыбрать.Отбор.Добавить("МестаДеятельностиМДЛП.Ссылка = &Параметр_" + Индекс);
			Иначе
				ВызватьИсключение НСтр("ru = 'Неподдерживаемый параметр отбора транспортных модулей МДЛП'");
			КонецЕсли;
			
			Запрос.УстановитьПараметр("Параметр_" + Индекс, Элемент.Значение);
			
			Индекс = Индекс + 1;
			
		КонецЦикла;
	КонецЕсли;
	
	Запрос.Текст = СхемаЗапроса.ПолучитьТекстЗапроса();
	
	ДоступныйТранспорт = Новый Массив;
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		
		ПараметрыПодключения = Новый Структура;
		ПараметрыПодключения.Вставить("Организация");
		ПараметрыПодключения.Вставить("ИдентификаторОрганизации");
		ПараметрыПодключения.Вставить("МестоДеятельности");
		ПараметрыПодключения.Вставить("ИдентификаторСубъектаОбращения");
		ПараметрыПодключения.Вставить("Регистратор");
		
		ЗаполнитьЗначенияСвойств(ПараметрыПодключения, Выборка);
		
		ПараметрыСервера = ТранспортМДЛПКлиентСервер.ПолучитьПараметрыСервера(Выборка.Адрес);
		ОбщегоНазначенияКлиентСервер.ДополнитьСтруктуру(ПараметрыПодключения, ПараметрыСервера, Истина);
		ПараметрыПодключения.Вставить("ПрефиксВерсии", "/v1/");
		
		ДанныеМодуля = Новый Структура;
		ДанныеМодуля.Вставить("ИдентификаторСубъектаОбращения", Выборка.ИдентификаторСубъектаОбращения);
		ДанныеМодуля.Вставить("ОбменНаСервере", Ложь);
		ДанныеМодуля.Вставить("ЗагружатьВходящиеДокументы", Истина);
		ДанныеМодуля.Вставить("МенеджерОбменаНаКлиенте", Метаданные.ОбщиеМодули.ТранспортМДЛПРВКлиент.Имя);
		ДанныеМодуля.Вставить("Представление", СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = '%1 - %2'"), Строка(Выборка.Организация), Строка(Выборка.МестоДеятельности)));
		ДанныеМодуля.Вставить("ПараметрыПодключения", ПараметрыПодключения);
		ДоступныйТранспорт.Добавить(ДанныеМодуля);
		
	КонецЦикла;
	
	Возврат ДоступныйТранспорт;
	
КонецФункции

Функция ВыполнитьМетодРВ(Знач ТранспортныйМодуль, Знач ИмяМетода, Знач Параметры = Неопределено) Экспорт
	
	Возврат ТранспортМДЛПРВКлиентСервер.ВыполнитьМетодРВ(ТранспортныйМодуль, ИмяМетода, Параметры);
	
КонецФункции

Процедура ДобавитьСообщениеВОчередьПолученияКвитанций(Сообщение, ИдентификаторОрганизации, ОбновитьСостояниеПодтверждения, РегистраторВыбытия) Экспорт
	
	РегистрыСведений.ОчередьПолученияКвитанцийМДЛП.ДобавитьСообщениеВОчередь(Сообщение, ИдентификаторОрганизации, ОбновитьСостояниеПодтверждения, РегистраторВыбытия);
	
КонецПроцедуры

Функция ПолучитьДанныеСообщенийОжидающихКвитанции(Знач РегистраторВыбытия, Знач ПараметрыВыполненияОбмена = Неопределено) Экспорт
	
	Запрос = Новый Запрос("
	|ВЫБРАТЬ
	|	Очередь.Сообщение                                 КАК Ссылка,
	|	Очередь.Сообщение.Операция                        КАК Операция,
	|	Очередь.Сообщение.ИдентификаторЗапроса            КАК ИдентификаторЗапроса,
	|	Очередь.Сообщение.ИдентификаторСубъектаОбращения  КАК ИдентификаторСубъектаОбращения
	|ИЗ
	|	РегистрСведений.ОчередьПолученияКвитанцийМДЛП КАК Очередь
	|ГДЕ
	|	Очередь.РегистраторВыбытия = &РегистраторВыбытия
	|");
	Запрос.УстановитьПараметр("РегистраторВыбытия", РегистраторВыбытия);
	
	ТипыДокументов = ОбщегоНазначенияКлиентСервер.СвойствоСтруктуры(ПараметрыВыполненияОбмена, "ТипыДокументов");
	Если ТипыДокументов <> Неопределено Тогда
		
		// Обрабатываем только те квитанции, типы владельцев которых указаны в параметре ТипыДокументов (если параметр заполнен).
		СхемаЗапроса = Новый СхемаЗапроса;
		СхемаЗапроса.УстановитьТекстЗапроса(Запрос.Текст);
		СхемаЗапроса.ПакетЗапросов[0].Операторы[0].Отбор.Добавить("ТИПЗНАЧЕНИЯ(Очередь.Сообщение.ВладелецФайла) В (&ТипыДокументов)");
		Запрос.Текст = СхемаЗапроса.ПолучитьТекстЗапроса();
		Запрос.УстановитьПараметр("ТипыДокументов", ТипыДокументов);
		
	КонецЕсли;
	
	СписокДокументов = ОбщегоНазначенияКлиентСервер.СвойствоСтруктуры(ПараметрыВыполненияОбмена, "СписокДокументов");
	Если СписокДокументов <> Неопределено Тогда
		
		// Обрабатываем только те квитанции, владельцы которых указаны в параметре СписокДокументов (если параметр заполнен).
		СхемаЗапроса = Новый СхемаЗапроса;
		СхемаЗапроса.УстановитьТекстЗапроса(Запрос.Текст);
		СхемаЗапроса.ПакетЗапросов[0].Операторы[0].Отбор.Добавить("Очередь.Сообщение.ВладелецФайла В (&СписокДокументов)");
		Запрос.Текст = СхемаЗапроса.ПолучитьТекстЗапроса();
		Запрос.УстановитьПараметр("СписокДокументов", СписокДокументов);
		
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	Возврат ОбщегоНазначения.ТаблицаЗначенийВМассив(Запрос.Выполнить().Выгрузить());
	
КонецФункции

Процедура ЗарегистрироватьКвитанциюСообщения(Знач Сообщение, Знач Квитанция) Экспорт
	
	ДополнительныеПараметры = Новый Структура("ИсточникДанных", "РВ");
	РезультатОперации = ИнтеграцияМДЛПВызовСервера.ЗарегистрироватьВходящееСообщениеКОбработке(
		Квитанция,
		Сообщение.ИдентификаторЗапроса,
		Сообщение.ИдентификаторСубъектаОбращения,
		ДополнительныеПараметры);
	Если РезультатОперации.Статус = "Ошибка" Тогда
		ВызватьИсключение РезультатОперации.ОписаниеОшибки;
	КонецЕсли;
	
	РегистрыСведений.ОчередьПолученияКвитанцийМДЛП.УдалитьСообщениеИзОчереди(Сообщение.Ссылка);
	
КонецПроцедуры

Процедура УдалитьСообщениеИзОчереди(Знач Сообщение) Экспорт
	РегистрыСведений.ОчередьПолученияКвитанцийМДЛП.УдалитьСообщениеИзОчереди(Сообщение.Ссылка);
КонецПроцедуры
