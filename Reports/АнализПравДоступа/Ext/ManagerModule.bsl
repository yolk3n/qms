﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2023, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область ДляВызоваИзДругихПодсистем

// См. ВариантыОтчетовПереопределяемый.ПередДобавлениемКомандОтчетов.
Процедура ПередДобавлениемКомандОтчетов(КомандыОтчетов, Параметры, СтандартнаяОбработка) Экспорт
	
	Если Не ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.ВариантыОтчетов") Тогда
		Возврат;
	КонецЕсли;
	
	Если Не ПравоДоступа("Просмотр", Метаданные.Отчеты.АнализПравДоступа)
	 Или СтандартныеПодсистемыСервер.ЭтоБазоваяВерсияКонфигурации() Тогда
		Возврат;
	КонецЕсли;
	
	Команда = КомандыОтчетов.Добавить();
	Команда.Представление = НСтр("ru = 'Права пользователей'");
	Команда.МножественныйВыбор = Истина;
	Команда.Менеджер = "Отчет.АнализПравДоступа";
	
	Если Параметры.ИмяФормы = "Справочник.Пользователи.Форма.ФормаСписка" Тогда
		Команда.Представление = НСтр("ru = 'Права пользователя'");
		Команда.КлючВарианта = "ПраваПользователейНаТаблицы";
		
	ИначеЕсли Параметры.ИмяФормы = "Справочник.Пользователи.Форма.ФормаЭлемента" Тогда
		Команда.Представление = НСтр("ru = 'Права пользователя'");
		Команда.КлючВарианта = "ПраваПользователяНаТаблицы";
	Иначе
		Команда.КлючВарианта = "ПраваПользователейНаТаблицу";
		Команда.ТолькоВоВсехДействиях = Истина;
		Команда.Важность = "СмТакже";
	КонецЕсли;
	
КонецПроцедуры

// Параметры:
//   Настройки - см. ВариантыОтчетовПереопределяемый.НастроитьВариантыОтчетов.Настройки.
//   НастройкиОтчета - см. ВариантыОтчетов.ОписаниеОтчета.
//
Процедура НастроитьВариантыОтчета(Настройки, НастройкиОтчета) Экспорт
	
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.ВариантыОтчетов") Тогда
		МодульВариантыОтчетов = ОбщегоНазначения.ОбщийМодуль("ВариантыОтчетов");
	Иначе
		Возврат;
	КонецЕсли;
	
	МодульВариантыОтчетов.УстановитьРежимВыводаВПанеляхОтчетов(Настройки, НастройкиОтчета, Ложь);
	НастройкиОтчета.ОпределитьНастройкиФормы = Истина;

	НастройкиВарианта = МодульВариантыОтчетов.ОписаниеВарианта(Настройки, НастройкиОтчета, "АнализПравДоступа");
	НастройкиВарианта.Описание = НСтр("ru = 'Показывает текущие настройки прав доступа пользователей к таблицам информационной базы.'");
	
	НастройкиВарианта = МодульВариантыОтчетов.ОписаниеВарианта(Настройки, НастройкиОтчета, "ПраваПользователейНаТаблицы");
	НастройкиВарианта.Включен = Ложь;

	НастройкиВарианта = МодульВариантыОтчетов.ОписаниеВарианта(Настройки, НастройкиОтчета, "ПраваПользователяНаТаблицы");
	НастройкиВарианта.Включен = Ложь;

	НастройкиВарианта = МодульВариантыОтчетов.ОписаниеВарианта(Настройки, НастройкиОтчета, "ПраваПользователейНаТаблицу");
	НастройкиВарианта.Включен = Ложь;
	
	НастройкиВарианта = МодульВариантыОтчетов.ОписаниеВарианта(Настройки, НастройкиОтчета, "ПраваПользователяНаТаблицу");
	НастройкиВарианта.Включен = Ложь;

	НастройкиВарианта = МодульВариантыОтчетов.ОписаниеВарианта(Настройки, НастройкиОтчета, "ПраваПользователяНаТаблицыОтчета");
	НастройкиВарианта.Включен = Ложь;

	НастройкиВарианта = МодульВариантыОтчетов.ОписаниеВарианта(Настройки, НастройкиОтчета, "ПраваПользователейНаТаблицыОтчета");
	НастройкиВарианта.Включен = Ложь;

	НастройкиВарианта = МодульВариантыОтчетов.ОписаниеВарианта(Настройки, НастройкиОтчета, "ПраваПользователяНаТаблицыОтчетов");
	НастройкиВарианта.Включен = Ложь;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Параметры:
//  АдресДанныхРасшифровки - Строка - адрес временного хранилища данных расшифровки отчета.
//  Расшифровка - ИдентификаторРасшифровкиКомпоновкиДанных - элемент расшифровки.
//
// Возвращаемое значение:
//  Структура:
//   * ИмяПоляРасшифровки - Строка
//   * СписокПолей - Соответствие из КлючИЗначение:
//    ** Ключ - Строка
//    ** Значение - Произвольный
//
Функция ПараметрыРасшифровки(АдресДанныхРасшифровки, Расшифровка) Экспорт
	
	ДанныеРасшифровки = ПолучитьИзВременногоХранилища(АдресДанныхРасшифровки); // ДанныеРасшифровкиКомпоновкиДанных
	ЭлементРасшифровки = ДанныеРасшифровки.Элементы[Расшифровка];

	СписокПолей = Новый Соответствие;
	ЗаполнитьСписокПолей(СписокПолей, ЭлементРасшифровки);
	
	ИмяПоляРасшифровки = "";
	Для Каждого ЗначениеПоля Из ЭлементРасшифровки.ПолучитьПоля() Цикл
		ИмяПоляРасшифровки = ЗначениеПоля.Поле;
		Прервать;
	КонецЦикла;
	
	Результат = Новый Структура;
	Результат.Вставить("ИмяПоляРасшифровки", ИмяПоляРасшифровки);
	Результат.Вставить("СписокПолей", СписокПолей);
	
	Возврат Результат;
	
КонецФункции

// Параметры:
//   СписокПолей - Соответствие
//   ЭлементРасшифровки - ЭлементРасшифровкиКомпоновкиДанныхПоля
//                      - ЭлементРасшифровкиКомпоновкиДанныхГруппировка
//
Процедура ЗаполнитьСписокПолей(СписокПолей, ЭлементРасшифровки)
	
	Если ТипЗнч(ЭлементРасшифровки) = Тип("ЭлементРасшифровкиКомпоновкиДанныхПоля") Тогда
		Для Каждого ЗначениеПоля Из ЭлементРасшифровки.ПолучитьПоля() Цикл
			Если СписокПолей[ЗначениеПоля.Поле] = Неопределено Тогда
				СписокПолей.Вставить(ЗначениеПоля.Поле, ЗначениеПоля.Значение);
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
		
	Для Каждого Родитель Из ЭлементРасшифровки.ПолучитьРодителей() Цикл
		ЗаполнитьСписокПолей(СписокПолей, Родитель);
	КонецЦикла;
	
КонецПроцедуры

// Возвращает таблицу, содержащую вид ограничений доступа
// по каждому праву объектов метаданных.
//  Если записи по праву нет, значит ограничений по праву нет.
//
// Параметры:
//  ДляВнешнихПользователей - Булево - когда Истина вернуть ограничения для внешних пользователей.
//                              Учитывается только для универсального ограничения.
//
//  ВидДоступаДляТаблицСОтключеннымИспользованием - Булево - если Истина, тогда для таблиц
//    с отключенным использованием (только универсальное ограничение) добавить
//    вид доступа "Перечисление.ДополнительныеЗначенияДоступа.ДоступРазрешен".
//    Учитывается только для универсального ограничения.
//
// Возвращаемое значение:
//  ТаблицаЗначений:
//   * ДляВнешнихПользователей - Булево - если Ложь, тогда ограничение для пользователей,
//                                 если Истина, тогда для внешних пользователей.
//                                 Колонка присутствует только для универсального ограничения.
//   * Таблица       - СправочникСсылка.ИдентификаторыОбъектовМетаданных
//                   - СправочникСсылка.ИдентификаторыОбъектовРасширений - идентификатор таблицы.
//   * ВидДоступа    - ЛюбаяСсылка - пустая ссылка основного типа значений вида доступа.
//   * Представление - Строка - представление вида доступа.
//   * Право         - Строка - "Чтение", "Изменение".
//
Функция ВидыОграниченийПрав(ДляВнешнихПользователей = Неопределено,
			ВидДоступаДляТаблицСОтключеннымИспользованием = Ложь) Экспорт
	
	УниверсальноеОграничение =
		УправлениеДоступомСлужебный.ОграничиватьДоступНаУровнеЗаписейУниверсально(Истина, Истина);
	
	Если Не УниверсальноеОграничение Тогда
		Кэш = УправлениеДоступомСлужебныйПовтИсп.ВидыОграниченийПравОбъектовМетаданных();
		
		Если ТекущаяДатаСеанса() < Кэш.ДатаОбновления + 60*30 Тогда
			Возврат Кэш.Таблица;
		КонецЕсли;
	КонецЕсли;
	
	ТипыЗначенийВидовДоступа =
		УправлениеДоступомСлужебныйПовтИсп.ТипыЗначенийВидовДоступаИВладельцевНастроекПрав().Получить(); // ТаблицаЗначений
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ПостоянныеВидыОграничений",
		УправлениеДоступомСлужебныйПовтИсп.ПостоянныеВидыОграниченийПравОбъектовМетаданных());
	
	Если УниверсальноеОграничение Тогда
		Запрос.Текст =
		"ВЫБРАТЬ
		|	ПостоянныеВидыОграничений.ДляВнешнихПользователей КАК ДляВнешнихПользователей,
		|	ПостоянныеВидыОграничений.ПолноеИмя КАК ПолноеИмя,
		|	ПостоянныеВидыОграничений.Таблица КАК Таблица,
		|	ПостоянныеВидыОграничений.Право КАК Право,
		|	ПостоянныеВидыОграничений.ВидДоступа КАК ВидДоступа
		|ПОМЕСТИТЬ ПостоянныеВидыОграничений
		|ИЗ
		|	&ПостоянныеВидыОграничений КАК ПостоянныеВидыОграничений
		|ГДЕ
		|	&ОтборДляВнешнихПользователей
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ВидыДоступаСПредставлением.ВидДоступа КАК ВидДоступа,
		|	ВидыДоступаСПредставлением.Представление КАК Представление
		|ПОМЕСТИТЬ ВидыДоступаСПредставлением
		|ИЗ
		|	&ВидыДоступаСПредставлением КАК ВидыДоступаСПредставлением
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ТаблицыСОтключеннымОграничением.ДляВнешнихПользователей КАК ДляВнешнихПользователей,
		|	ТаблицыСОтключеннымОграничением.ПолноеИмя КАК ПолноеИмя,
		|	ТаблицыСОтключеннымОграничением.Таблица КАК Таблица,
		|	ТаблицыСОтключеннымОграничением.ВидДоступа КАК ВидДоступа,
		|	ТаблицыСОтключеннымОграничением.Представление КАК Представление
		|ПОМЕСТИТЬ ТаблицыСОтключеннымОграничением
		|ИЗ
		|	&ТаблицыСОтключеннымОграничением КАК ТаблицыСОтключеннымОграничением
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	ВидыОграниченийПрав.ДляВнешнихПользователей КАК ДляВнешнихПользователей,
		|	ВидыОграниченийПрав.Таблица КАК Таблица,
		|	ВидыОграниченийПрав.Право КАК Право,
		|	ВидыОграниченийПрав.ВидДоступа КАК ВидДоступа,
		|	ВидыОграниченийПрав.Представление КАК Представление
		|ИЗ
		|	(ВЫБРАТЬ
		|		ПостоянныеВидыОграничений.ДляВнешнихПользователей КАК ДляВнешнихПользователей,
		|		ПостоянныеВидыОграничений.Таблица КАК Таблица,
		|		ВЫБОР
		|			КОГДА НЕ ТаблицыСОтключеннымОграничением.ПолноеИмя ЕСТЬ NULL
		|				ТОГДА """"
		|			ИНАЧЕ ПостоянныеВидыОграничений.Право
		|		КОНЕЦ КАК Право,
		|		ВЫБОР
		|			КОГДА НЕ ТаблицыСОтключеннымОграничением.ПолноеИмя ЕСТЬ NULL
		|				ТОГДА ТаблицыСОтключеннымОграничением.ВидДоступа
		|			ИНАЧЕ ПостоянныеВидыОграничений.ВидДоступа
		|		КОНЕЦ КАК ВидДоступа,
		|		ВЫБОР
		|			КОГДА НЕ ТаблицыСОтключеннымОграничением.ПолноеИмя ЕСТЬ NULL
		|				ТОГДА ТаблицыСОтключеннымОграничением.Представление
		|			ИНАЧЕ ЕСТЬNULL(ВидыДоступаСПредставлением.Представление, &ПредставлениеНеизвестногоВидаДоступа)
		|		КОНЕЦ КАК Представление
		|	ИЗ
		|		ПостоянныеВидыОграничений КАК ПостоянныеВидыОграничений
		|			ЛЕВОЕ СОЕДИНЕНИЕ ТаблицыСОтключеннымОграничением КАК ТаблицыСОтключеннымОграничением
		|			ПО (ТаблицыСОтключеннымОграничением.ДляВнешнихПользователей = ПостоянныеВидыОграничений.ДляВнешнихПользователей)
		|				И (ТаблицыСОтключеннымОграничением.ПолноеИмя = ПостоянныеВидыОграничений.ПолноеИмя)
		|			ЛЕВОЕ СОЕДИНЕНИЕ ВидыДоступаСПредставлением КАК ВидыДоступаСПредставлением
		|			ПО (ВидыДоступаСПредставлением.ВидДоступа = ПостоянныеВидыОграничений.ВидДоступа)
		|	ГДЕ
		|		ПостоянныеВидыОграничений.ВидДоступа <> НЕОПРЕДЕЛЕНО
		|	
		|	ОБЪЕДИНИТЬ ВСЕ
		|	
		|	ВЫБРАТЬ
		|		ТаблицыСОтключеннымОграничением.ДляВнешнихПользователей,
		|		ТаблицыСОтключеннымОграничением.Таблица,
		|		"""",
		|		ТаблицыСОтключеннымОграничением.ВидДоступа,
		|		ТаблицыСОтключеннымОграничением.Представление
		|	ИЗ
		|		ТаблицыСОтключеннымОграничением КАК ТаблицыСОтключеннымОграничением
		|			ЛЕВОЕ СОЕДИНЕНИЕ ПостоянныеВидыОграничений КАК ПостоянныеВидыОграничений
		|			ПО (ПостоянныеВидыОграничений.ДляВнешнихПользователей = ТаблицыСОтключеннымОграничением.ДляВнешнихПользователей)
		|				И (ПостоянныеВидыОграничений.ПолноеИмя = ТаблицыСОтключеннымОграничением.ПолноеИмя)
		|	ГДЕ
		|		ПостоянныеВидыОграничений.ПолноеИмя ЕСТЬ NULL
		|		И ТаблицыСОтключеннымОграничением.Таблица <> НЕОПРЕДЕЛЕНО) КАК ВидыОграниченийПрав";
		
		Если ТипЗнч(ДляВнешнихПользователей) = Тип("Булево") Тогда
			Запрос.УстановитьПараметр("ДляВнешнихПользователей", ДляВнешнихПользователей);
			Запрос.Текст = СтрЗаменить(Запрос.Текст, "&ОтборДляВнешнихПользователей",
				"ПостоянныеВидыОграничений.ДляВнешнихПользователей = &ДляВнешнихПользователей");
		Иначе
			Запрос.Текст = СтрЗаменить(Запрос.Текст, "&ОтборДляВнешнихПользователей", "ИСТИНА");
		КонецЕсли;
		Запрос.УстановитьПараметр("ВидыДоступаСПредставлением",
			ВидыДоступаСПредставлением(ТипыЗначенийВидовДоступа, Ложь));
		Запрос.УстановитьПараметр("ПредставлениеНеизвестногоВидаДоступа",
			ПредставлениеНеизвестногоВидаДоступа());
		Запрос.УстановитьПараметр("ТаблицыСОтключеннымОграничением",
			ТаблицыСОтключеннымОграничением(ДляВнешнихПользователей,
				ВидДоступаДляТаблицСОтключеннымИспользованием));
	Иначе
		Запрос.УстановитьПараметр("ТипыЗначенийВидовДоступа", ТипыЗначенийВидовДоступа);
		Запрос.УстановитьПараметр("ИспользуемыеВидыДоступа",
			ВидыДоступаСПредставлением(ТипыЗначенийВидовДоступа, Истина));
		// АПК:96-выкл - №434 Использование ОБЪЕДИНИТЬ допустимо, так как
		// строки не должны повторятся и результат кэшируется.
		Запрос.Текст =
		"ВЫБРАТЬ
		|	ПостоянныеВидыОграничений.Таблица КАК Таблица,
		|	ПостоянныеВидыОграничений.Право КАК Право,
		|	ПостоянныеВидыОграничений.ВидДоступа КАК ВидДоступа,
		|	ПостоянныеВидыОграничений.ТаблицаОбъекта КАК ТаблицаОбъекта
		|ПОМЕСТИТЬ ПостоянныеВидыОграничений
		|ИЗ
		|	&ПостоянныеВидыОграничений КАК ПостоянныеВидыОграничений
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ТипыЗначенийВидовДоступа.ВидДоступа КАК ВидДоступа,
		|	ТипыЗначенийВидовДоступа.ТипЗначений КАК ТипЗначений
		|ПОМЕСТИТЬ ТипыЗначенийВидовДоступа
		|ИЗ
		|	&ТипыЗначенийВидовДоступа КАК ТипыЗначенийВидовДоступа
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ИспользуемыеВидыДоступа.ВидДоступа КАК ВидДоступа,
		|	ИспользуемыеВидыДоступа.Представление КАК Представление
		|ПОМЕСТИТЬ ИспользуемыеВидыДоступа
		|ИЗ
		|	&ИспользуемыеВидыДоступа КАК ИспользуемыеВидыДоступа
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	ПостоянныеВидыОграничений.Таблица КАК Таблица,
		|	""Чтение"" КАК Право,
		|	ТИПЗНАЧЕНИЯ(СтрокиНаборов.ЗначениеДоступа) КАК ТипЗначений
		|ПОМЕСТИТЬ ПеременныеВидыОграничений
		|ИЗ
		|	РегистрСведений.НаборыЗначенийДоступа КАК НомераНаборов
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ПостоянныеВидыОграничений КАК ПостоянныеВидыОграничений
		|		ПО (ПостоянныеВидыОграничений.Право = ""Чтение"")
		|			И (ПостоянныеВидыОграничений.ВидДоступа = НЕОПРЕДЕЛЕНО)
		|			И (ТИПЗНАЧЕНИЯ(НомераНаборов.Объект) = ТИПЗНАЧЕНИЯ(ПостоянныеВидыОграничений.ТаблицаОбъекта))
		|			И (НомераНаборов.Чтение)
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.НаборыЗначенийДоступа КАК СтрокиНаборов
		|		ПО (СтрокиНаборов.Объект = НомераНаборов.Объект)
		|			И (СтрокиНаборов.НомерНабора = НомераНаборов.НомерНабора)
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	ПостоянныеВидыОграничений.Таблица,
		|	""Изменение"",
		|	ТИПЗНАЧЕНИЯ(СтрокиНаборов.ЗначениеДоступа)
		|ИЗ
		|	РегистрСведений.НаборыЗначенийДоступа КАК НомераНаборов
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ПостоянныеВидыОграничений КАК ПостоянныеВидыОграничений
		|		ПО (ПостоянныеВидыОграничений.Право = ""Изменение"")
		|			И (ПостоянныеВидыОграничений.ВидДоступа = НЕОПРЕДЕЛЕНО)
		|			И (ТИПЗНАЧЕНИЯ(НомераНаборов.Объект) = ТИПЗНАЧЕНИЯ(ПостоянныеВидыОграничений.ТаблицаОбъекта))
		|			И (НомераНаборов.Изменение)
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.НаборыЗначенийДоступа КАК СтрокиНаборов
		|		ПО (СтрокиНаборов.Объект = НомераНаборов.Объект)
		|			И (СтрокиНаборов.НомерНабора = НомераНаборов.НомерНабора)
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ПостоянныеВидыОграничений.Таблица КАК Таблица,
		|	ПостоянныеВидыОграничений.Право КАК Право,
		|	ТипыЗначенийВидовДоступа.ВидДоступа КАК ВидДоступа
		|ПОМЕСТИТЬ ВсеВидыОграниченийПрав
		|ИЗ
		|	ПостоянныеВидыОграничений КАК ПостоянныеВидыОграничений
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ТипыЗначенийВидовДоступа КАК ТипыЗначенийВидовДоступа
		|		ПО ПостоянныеВидыОграничений.ВидДоступа = ТипыЗначенийВидовДоступа.ВидДоступа
		|			И (ПостоянныеВидыОграничений.ВидДоступа <> НЕОПРЕДЕЛЕНО)
		|
		|ОБЪЕДИНИТЬ
		|
		|ВЫБРАТЬ
		|	ПеременныеВидыОграничений.Таблица,
		|	ПеременныеВидыОграничений.Право,
		|	ТипыЗначенийВидовДоступа.ВидДоступа
		|ИЗ
		|	ПеременныеВидыОграничений КАК ПеременныеВидыОграничений
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ТипыЗначенийВидовДоступа КАК ТипыЗначенийВидовДоступа
		|		ПО (ПеременныеВидыОграничений.ТипЗначений = ТИПЗНАЧЕНИЯ(ТипыЗначенийВидовДоступа.ТипЗначений))
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ВсеВидыОграниченийПрав.Таблица КАК Таблица,
		|	ВсеВидыОграниченийПрав.Право КАК Право,
		|	ВсеВидыОграниченийПрав.ВидДоступа КАК ВидДоступа,
		|	ИспользуемыеВидыДоступа.Представление КАК Представление
		|ИЗ
		|	ВсеВидыОграниченийПрав КАК ВсеВидыОграниченийПрав
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ИспользуемыеВидыДоступа КАК ИспользуемыеВидыДоступа
		|		ПО ВсеВидыОграниченийПрав.ВидДоступа = ИспользуемыеВидыДоступа.ВидДоступа";
		// АПК:96-вкл.
	КонецЕсли;
	
	Выгрузка = Запрос.Выполнить().Выгрузить();
	
	Если Не УниверсальноеОграничение Тогда
		Кэш.Таблица = Выгрузка;
		Кэш.ДатаОбновления = ТекущаяДатаСеанса();
	КонецЕсли;
	
	Возврат Выгрузка;
	
КонецФункции

// Для функции ВидыОграниченийПрав.
Функция ВидыДоступаСПредставлением(ТипыЗначенийВидовДоступа, ТолькоИспользуемые)
	
	ВидыДоступа = ТипыЗначенийВидовДоступа.Скопировать(, "ВидДоступа");
	
	ВидыДоступа.Свернуть("ВидДоступа");
	ВидыДоступа.Колонки.Добавить("Представление", Новый ОписаниеТипов("Строка", , Новый КвалификаторыСтроки(150)));
	
	Индекс = ВидыДоступа.Количество()-1;
	Пока Индекс >= 0 Цикл
		Строка = ВидыДоступа[Индекс];
		СвойстваВидаДоступа = УправлениеДоступомСлужебный.СвойстваВидаДоступа(Строка.ВидДоступа);
		
		Если СвойстваВидаДоступа = Неопределено Тогда
			МетаданныеВладельцаНастроекПрав = Метаданные.НайтиПоТипу(ТипЗнч(Строка.ВидДоступа));
			Если МетаданныеВладельцаНастроекПрав = Неопределено Тогда
				Строка.Представление = ПредставлениеНеизвестногоВидаДоступа();
			Иначе
				Строка.Представление = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru = 'Настройки прав на %1'"),
					МетаданныеВладельцаНастроекПрав.Представление());
			КонецЕсли;
			
		ИначеЕсли Не ТолькоИспользуемые
		      Или УправлениеДоступомСлужебный.ВидДоступаИспользуется(Строка.ВидДоступа) Тогда
			
			Строка.Представление = УправлениеДоступомСлужебный.ПредставлениеВидаДоступа(СвойстваВидаДоступа);
		Иначе
			ВидыДоступа.Удалить(Строка);
		КонецЕсли;
		
		Индекс = Индекс - 1;
	КонецЦикла;
	
	Возврат ВидыДоступа;
	
КонецФункции

// Для функций ВидыОграниченийПрав, ВидыДоступаСПредставлением.
Функция ПредставлениеНеизвестногоВидаДоступа()
	
	Возврат НСтр("ru = 'Неизвестный вид доступа'");
	
КонецФункции

// Для функции ВидыОграниченийПрав.
Функция ТаблицыСОтключеннымОграничением(ДляВнешнихПользователей, Заполнять)
	
	ТипыИдентификаторов = Новый Массив;
	ТипыИдентификаторов.Добавить(Тип("СправочникСсылка.ИдентификаторыОбъектовМетаданных"));
	ТипыИдентификаторов.Добавить(Тип("СправочникСсылка.ИдентификаторыОбъектовРасширений"));
	
	Результат = Новый ТаблицаЗначений;
	Результат.Колонки.Добавить("ДляВнешнихПользователей", Новый ОписаниеТипов("Булево"));
	Результат.Колонки.Добавить("ПолноеИмя",
		Метаданные.Справочники.ИдентификаторыОбъектовМетаданных.Реквизиты.ПолноеИмя.Тип);
	Результат.Колонки.Добавить("Таблица",    Новый ОписаниеТипов(ТипыИдентификаторов));
	Результат.Колонки.Добавить("ВидДоступа", УправлениеДоступомСлужебныйПовтИсп.ОписаниеТиповЗначенийДоступаИВладельцевНастроекПрав());
	Результат.Колонки.Добавить("Представление", Новый ОписаниеТипов("Строка", , Новый КвалификаторыСтроки(150)));
	
	Если Не Заполнять Тогда
		Возврат Результат;
	КонецЕсли;
	
	ДействующиеПараметры = УправлениеДоступомСлужебный.ДействующиеПараметрыОграниченияДоступа(
		Неопределено, Неопределено, Ложь);
	
	Если ДляВнешнихПользователей <> Истина Тогда
		ДобавитьТаблицыСОтключеннымОграничением(Результат, ДействующиеПараметры, Ложь);
	КонецЕсли;
	Если ДляВнешнихПользователей <> Ложь Тогда
		ДобавитьТаблицыСОтключеннымОграничением(Результат, ДействующиеПараметры, Истина);
	КонецЕсли;
	ПолныеИмена = Результат.ВыгрузитьКолонку("ПолноеИмя");
	ИдентификаторыИмен = ОбщегоНазначения.ИдентификаторыОбъектовМетаданных(ПолныеИмена, Ложь);
	Для Каждого Строка Из Результат Цикл
		Строка.Таблица = ИдентификаторыИмен.Получить(Строка.ПолноеИмя);
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

// Для функции ТаблицыСОтключеннымОграничением.
Процедура ДобавитьТаблицыСОтключеннымОграничением(ТаблицыСОтключеннымОграничением,
			ДействующиеПараметры, ДляВнешнихПользователей)
	
	Если ДляВнешнихПользователей Тогда
		ДополнительныйКонтекст = ДействующиеПараметры.ДополнительныйКонтекст.ДляВнешнихПользователей;
	Иначе
		ДополнительныйКонтекст = ДействующиеПараметры.ДополнительныйКонтекст.ДляПользователей;
	КонецЕсли;
	
	СпискиСОтключеннымОграничением = ДополнительныйКонтекст.СпискиСОтключеннымОграничением;
	СвойстваОграниченияСписков     = ДополнительныйКонтекст.СвойстваОграниченияСписков;
	
	Для Каждого КлючИЗначение Из СвойстваОграниченияСписков Цикл
		ПолноеИмя = КлючИЗначение.Ключ;
		Если Не КлючИЗначение.Значение.ДоступЗапрещен
		   И СпискиСОтключеннымОграничением.Получить(ПолноеИмя) = Неопределено Тогда
			Продолжить;
		КонецЕсли;
		НоваяСтрока = ТаблицыСОтключеннымОграничением.Добавить();
		НоваяСтрока.ДляВнешнихПользователей = ДляВнешнихПользователей;
		НоваяСтрока.ПолноеИмя = ПолноеИмя;
		Если КлючИЗначение.Значение.ДоступЗапрещен Тогда
			НоваяСтрока.ВидДоступа    = Перечисления.ДополнительныеЗначенияДоступа.ДоступЗапрещен;
			НоваяСтрока.Представление = "<" + НСтр("ru = 'Доступ запрещен'") + ">";
		Иначе
			НоваяСтрока.ВидДоступа    = Перечисления.ДополнительныеЗначенияДоступа.ДоступРазрешен;
			НоваяСтрока.Представление = "<" + НСтр("ru = 'Ограничение отключено'") + ">";
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли

