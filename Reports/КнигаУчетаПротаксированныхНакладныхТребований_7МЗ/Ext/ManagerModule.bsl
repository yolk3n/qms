﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЙ ПРОГРАММНЫЙ ИНТЕРФЕЙС
#Область СлужебныйПрограммныйИнтерфейс

// Вызывает модуль менеджера отчета для заполнения его настроек.
//   Для вызова из процедуры ВариантыОтчетовПереопределяемый.НастроитьВариантыОтчетов().
//
// Параметры:
//   Настройки - Коллекция - Передается "как есть" из процедуры НастроитьВариантыОтчетов.
//   ОтчетМетаданные - ОбъектМетаданных - Метаданные отчета.
//
// Важно:
//   Для использования в модуле менеджера отчета должна быть размещена экспортная процедура по шаблону:
//      // Настройки размещения в панели отчетов.
//      //
//      // Параметры:
//      //   Настройки - Коллекция - Передается "как есть" из ВариантыОтчетовПереопределяемый.НастроитьВариантыОтчетов().
//      //       Может использоваться для получения настроек варианта этого отчета при помощи функции ВариантыОтчетов.ОписаниеВарианта().
//      //   НастройкиОтчета - СтрокаДереваЗначений - Настройки этого отчета,
//      //       уже сформированные при помощи функции ВариантыОтчетов.ОписаниеОтчета() и готовые к изменению.
//      //       См. "Свойства для изменения" процедуры ВариантыОтчетовПереопределяемый.НастроитьВариантыОтчетов().
//      //
//      // Описание:
//      //   См. ВариантыОтчетовПереопределяемый.НастроитьВариантыОтчетов().
//      //
//      // Вспомогательные методы:
//      //	НастройкиВарианта = ВариантыОтчетов.ОписаниеВарианта(Настройки, НастройкиОтчета, "<ИмяВарианта>");
//      //	ВариантыОтчетов.УстановитьРежимВыводаВПанеляхОтчетов(Настройки, НастройкиОтчета, Истина/Ложь);
//      //
//      // Примеры:
//      //
//      //  1. Установка описания варианта.
//      //	НастройкиВарианта = ВариантыОтчетов.ОписаниеВарианта(Настройки, НастройкиОтчета, "<ИмяВарианта>");
//      //	НастройкиВарианта.Описание = НСтр("ru = '<Описание>'");
//      //
//      //  2. Отключение варианта отчета.
//      //	НастройкиВарианта = ВариантыОтчетов.ОписаниеВарианта(Настройки, НастройкиОтчета, "<ИмяВарианта>");
//      //	НастройкиВарианта.Включен = Ложь;
//      //
//      Процедура НастроитьВариантыОтчета(Настройки, НастройкиОтчета) Экспорт
//      	// Код процедуры.
//      КонецПроцедуры
//
Процедура НастроитьВариантыОтчета(Настройки, НастройкиОтчета) Экспорт
	
	// Эти варианты отчета по умолчанию видны в панели отчетов
	НастройкиВарианта = ВариантыОтчетов.ОписаниеВарианта(Настройки, НастройкиОтчета, "Основной");
	НастройкиВарианта.Описание = НСтр("ru = 'Книга учета протаксированных накладных требований(Форма №7-МЗ)'");
	
КонецПроцедуры

// Возвращает признаки переопределения стандартного формирования отчета.
//
// Возвращаемое значение:
//  ПараметрыИсполнения - Структура - признаки использования методов формирования отчета.
//                      Каждый метод описывается в модуле менеджера отчета с именем,
//                      образованным от ключа структуры без приставки Использовать.
//    * ИспользоватьВнешниеНаборыДанных            - Булево - признак использования внешних наборов данных,
//                                                            полученных в результате выполнения указанного метода.
//    * ИспользоватьПриВыводеЗаголовка             - Булево - признак переопределения стандартного метода формирования заголовка отчета.
//                                                            Имеет смысл, если ВыводитьЗаголовок = Истина.
//    * ИспользоватьПриВыводеПодвала               - Булево - признак переопределения стандартного метода формирования подвала отчета.
//                                                            Имеет смысл, если ВыводитьПодвал = Истина.
//    * ИспользоватьПередКомпоновкойМакета         - Булево - признак выполнения дополнительных действий перед компоновкой макета.
//                                                            Имеет смысл, если необходимо изменить настройки отчета перед получением макета компоновки данных.
//    * ИспользоватьПослеКомпоновкиМакета          - Булево - признак выполнения дополнительных действий после компоновки макета.
//                                                            Имеет смысл, если необходимо изменить полученный макет компоновки данных.
//    * ИспользоватьПередВыводомЭлементаРезультата - Булево - признак выполнения дополнительных действий перед выводом элемента результата компоновки.
//                                                            Имеет смысл, если необходимо обработать элемент результата компоновки перед выводом.
//    * ИспользоватьПослеВыводаРезультата          - Булево - признак переопределения стандартного метода ОтчетыБольничнаяАптека.ПослеВыводаРезультата.
//    * ИспользоватьДанныеРасшифровки              - Булево - признак использования данных расшифровки отчета.
//                                                            Не имеет отдельного метода переопределения данных расшифровки.
//    * ИспользоватьПривилегированныйРежим         - Булево - признак использования привилегированного режима при выводе элементов результата компоновки.
//                                                            Не имеет отдельного метода.
//
// см. процедуру ОтчетыБольничнаяАптека.СформироватьОтчет
//
Функция ПолучитьПараметрыИсполненияОтчета() Экспорт
	
	ПараметрыИсполнения = Новый Структура;
	ПараметрыИсполнения.Вставить("ИспользоватьПриВыводеЗаголовка"             , Истина);
	ПараметрыИсполнения.Вставить("ИспользоватьПередКомпоновкойМакета"         , Истина);
	ПараметрыИсполнения.Вставить("ИспользоватьДанныеРасшифровки"              , Истина);
	ПараметрыИсполнения.Вставить("ИспользоватьПриВыводеПодвала"               , Истина);
	ПараметрыИсполнения.Вставить("ИспользоватьПослеВыводаРезультата"          , Истина);
	
	Возврат ПараметрыИсполнения;
	
КонецФункции

// Обработчик исполнения отчета.
// см. функцию ПолучитьПараметрыИсполненияОтчета.
//
// Параметры:
//  ПараметрыОтчета     - Структура - параметры, влияющие на результат отчета.
//  КомпоновщикНастроек - КомпоновщикНастроекКомпоновкиДанных - компоновщик для редактирования настроек отчета.
//  Результат           - ТабличныйДокумент - результат выполнения отчета.
//
// см. процедуру ОтчетыБольничнаяАптека.СформироватьОтчет
//
Процедура ПриВыводеЗаголовка(ПараметрыОтчета, КомпоновщикНастроек, Результат) Экспорт
	
	ДатаНачала    = ПараметрыОтчета.ДатаНачала;
	ДатаОкончания = ПараметрыОтчета.ДатаОкончания;
	Организация   = ПараметрыОтчета.Организация;
	МакетыОтчета  = ПараметрыОтчета.МакетыОтчета;
	
	Если Не ЗначениеЗаполнено(Организация) И ПолучитьФункциональнуюОпцию("НеИспользоватьНесколькоОрганизаций") Тогда
		Организация = ЗначениеНастроекБольничнаяАптекаПовтИсп.ПолучитьОрганизациюПоУмолчанию();
	КонецЕсли;
	ПодразделениеОрганизации = ПараметрыОтчета.ПодразделениеОрганизации;
	ИсточникФинансирования = ПараметрыОтчета.ИсточникФинансирования;
	
	ВестиУчетПоИсточникамФинансирования = ПолучитьФункциональнуюОпцию("ИспользоватьИсточникиФинансирования");
	
	ОбластьШапки = МакетыОтчета.ПФ_MXL_7МЗ.ПолучитьОбласть("Шапка");
	
	// Выведем заголовок.
	СведенияОПокупателе = ФормированиеПечатныхФорм.СведенияОЮрФизЛице(Организация, ДатаОкончания);
	
	ОбластьШапки.Параметры.ПредставлениеОрганизации = ФормированиеПечатныхФорм.ОписаниеОрганизации(СведенияОПокупателе);
	ОбластьШапки.Параметры.Организация  = Организация;
	ОбластьШапки.Параметры.Аптека       = ПодразделениеОрганизации;
	ОбластьШапки.Параметры.Период       = ПолучитьПредставлениеПериода(ДатаНачала, ДатаОкончания);
	ОтчетыБольничнаяАптека.ВывестиОбластьВТабличныйДокумент(Результат, ОбластьШапки);
	
	ТекстОтбора = "";
	Если ВестиУчетПоИсточникамФинансирования И ЗначениеЗаполнено(ИсточникФинансирования) Тогда
		ТекстОтбораИсточника = НСтр("ru = 'Источник финансирования Равно'") + " """ + ИсточникФинансирования + """";
		Если СтрНайти(Строка(КомпоновщикНастроек.Настройки.Отбор), ТекстОтбораИсточника) = 0 Тогда
			ТекстОтбора = ТекстОтбораИсточника;
		КонецЕсли;
	КонецЕсли;
	
	ОтчетыБольничнаяАптека.ВывестиОтборВТабличныйДокумент(Результат, КомпоновщикНастроек, ТекстОтбора);
	ОтчетыБольничнаяАптека.ВывестиГруппировкуВТабличныйДокумент(Результат, ПараметрыОтчета.Группировка);
	
КонецПроцедуры

// Обработчик исполнения отчета.
// см. функцию ПолучитьПараметрыИсполненияОтчета.
//
// Параметры:
//  ПараметрыОтчета     - Структура - параметры, влияющие на результат отчета.
//  Схема               - СхемаКомпоновкиДанных - схема компоновки, на основании которой будет выполняться отчет.
//  КомпоновщикНастроек - КомпоновщикНастроекКомпоновкиДанных - компоновщик для редактирования настроек отчета.
//
// см. процедуру ОтчетыБольничнаяАптека.СформироватьОтчет
//
Процедура ПередКомпоновкойМакета(ПараметрыОтчета, Схема, КомпоновщикНастроек) Экспорт
	
#Область ПараметрыИОтборы
	
	ПараметрыДанных = КомпоновщикНастроек.Настройки.ПараметрыДанных;
	Если ЗначениеЗаполнено(ПараметрыОтчета.ДатаНачала) Тогда
		ПараметрыДанных.УстановитьЗначениеПараметра("НачалоПериода", НачалоДня(ПараметрыОтчета.ДатаНачала));
	КонецЕсли;
	Если ЗначениеЗаполнено(ПараметрыОтчета.ДатаОкончания) Тогда
		ПараметрыДанных.УстановитьЗначениеПараметра("КонецПериода", КонецДня(ПараметрыОтчета.ДатаОкончания));
	КонецЕсли;
	
	ПараметрыДанных.УстановитьЗначениеПараметра("ПредставлениеПериода", ПолучитьПредставлениеПериода(ПараметрыОтчета.ДатаНачала, ПараметрыОтчета.ДатаОкончания));
	
	ВестиУчетПоИсточникамФинансирования = ПолучитьФункциональнуюОпцию("ИспользоватьИсточникиФинансирования");
	
	Отбор = КомпоновщикНастроек.Настройки.Отбор;
	ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(Отбор, "Организация", ВидСравненияКомпоновкиДанных.Равно, ПараметрыОтчета.Организация, "###ОтборПоОрганизации###", ЗначениеЗаполнено(ПараметрыОтчета.Организация));
	ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(Отбор, "ПодразделениеОрганизации", ВидСравненияКомпоновкиДанных.Равно, ПараметрыОтчета.ПодразделениеОрганизации, "###ОтборПоПодразделению###", ЗначениеЗаполнено(ПараметрыОтчета.ПодразделениеОрганизации));
	ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(Отбор, "ИсточникФинансирования", ВидСравненияКомпоновкиДанных.Равно, ПараметрыОтчета.ИсточникФинансирования, "###ОтборПоИсточникуФинансирования###", ВестиУчетПоИсточникамФинансирования И ЗначениеЗаполнено(ПараметрыОтчета.ИсточникФинансирования));
	
	Если Не ПараметрыОтчета.ПоказыватьВсеГруппыБухгалтерскогоУчета Тогда
		ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(Отбор, "ГруппаБухгалтерскогоУчета.ВыводитьВОтчетах", ВидСравненияКомпоновкиДанных.Равно, Истина, "###ГруппыБухгалтерскогоУчетаДляОтчетов###", Истина);
	КонецЕсли;
	
#КонецОбласти // ПараметрыИОтборы
	
#Область СтруктураОтчета
	
	СтруктураОтчета = КомпоновщикНастроек.Настройки.Структура;
	Структура = СтруктураОтчета[0].Строки;
	ИмяПервойГруппировки = "ПерваяГруппировка";
	ИмяГруппировки = "Группировка";
	ПерваяГруппировка = Неопределено;
	Для Каждого Группировка Из ПараметрыОтчета.Группировка Цикл
		Если Не Группировка.Использование Тогда
			Продолжить;
		КонецЕсли;
		
		ТекущаяГруппировка = Структура.Добавить();
		Если ПерваяГруппировка = Неопределено Тогда
			ПерваяГруппировка = Группировка;
			ТекущаяГруппировка.Имя = ИмяПервойГруппировки;
		Иначе
			ТекущаяГруппировка.Имя = ИмяГруппировки;
		КонецЕсли;
		ПолеГруппировки = ТекущаяГруппировка.ПоляГруппировки.Элементы.Добавить(Тип("ПолеГруппировкиКомпоновкиДанных"));
		ПолеГруппировки.Поле           = Новый ПолеКомпоновкиДанных(Группировка.Поле);
		Если Группировка.ТипГруппировки = Перечисления.ТипыГруппировокОтчетов.СГруппами Тогда
			ПолеГруппировки.ТипГруппировки = ТипГруппировкиКомпоновкиДанных.Иерархия;
		ИначеЕсли Группировка.ТипГруппировки = Перечисления.ТипыГруппировокОтчетов.ТолькоГруппы Тогда
			ПолеГруппировки.ТипГруппировки = ТипГруппировкиКомпоновкиДанных.ТолькоИерархия;
		Иначе
			ПолеГруппировки.ТипГруппировки = ТипГруппировкиКомпоновкиДанных.Элементы;
		КонецЕсли;
		ТекущаяГруппировка.Выбор.Элементы.Добавить(Тип("АвтоВыбранноеПолеКомпоновкиДанных"));
		ТекущаяГруппировка.Порядок.Элементы.Добавить(Тип("АвтоЭлементПорядкаКомпоновкиДанных"));
		ТекущаяГруппировка.ПараметрыВывода.УстановитьЗначениеПараметра("ВыводитьОтбор", ТипВыводаТекстаКомпоновкиДанных.НеВыводить);
		
		Отбор = ТекущаяГруппировка.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		Отбор.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Сумма");
		Отбор.ВидСравнения = ВидСравненияКомпоновкиДанных.НеРавно;
		Отбор.ПравоеЗначение = 0;
		
		Структура = ТекущаяГруппировка.Структура;
	КонецЦикла;
	
	ГруппировкаДокументЗакупки = Структура.Добавить();
	ИмяГруппировкиДокументОтпуска = "ДокументОтпуска";
	ГруппировкаДокументЗакупки.Имя = ИмяГруппировкиДокументОтпуска;
	ПолеГруппировки = ГруппировкаДокументЗакупки.ПоляГруппировки.Элементы.Добавить(Тип("ПолеГруппировкиКомпоновкиДанных"));
	ПолеГруппировки.Поле           = Новый ПолеКомпоновкиДанных("ДокументОтпуска");
	ПолеГруппировки.ТипГруппировки = ТипГруппировкиКомпоновкиДанных.Элементы;
	ГруппировкаДокументЗакупки.Выбор.Элементы.Добавить(Тип("АвтоВыбранноеПолеКомпоновкиДанных"));
	ГруппировкаДокументЗакупки.Порядок.Элементы.Добавить(Тип("АвтоЭлементПорядкаКомпоновкиДанных"));
	ГруппировкаДокументЗакупки.ПараметрыВывода.УстановитьЗначениеПараметра("ВыводитьОтбор", ТипВыводаТекстаКомпоновкиДанных.НеВыводить);
	
	Отбор = ГруппировкаДокументЗакупки.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	Отбор.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Сумма");
	Отбор.ВидСравнения = ВидСравненияКомпоновкиДанных.НеРавно;
	Отбор.ПравоеЗначение = 0;
	
#КонецОбласти // СтруктураОтчета
	
#Область Оформление
	
	Если ПерваяГруппировка = Неопределено Тогда
		Для Каждого МакетГруппировки Из Схема.МакетыГруппировок Цикл
			Если МакетГруппировки.ИмяГруппировки = ИмяПервойГруппировки Тогда
				МакетГруппировки.ИмяГруппировки = ИмяГруппировкиДокументОтпуска;
			КонецЕсли;
		КонецЦикла;
		Для Каждого МакетЗаголовка Из Схема.МакетыЗаголовковГруппировок Цикл
			Если МакетЗаголовка.ИмяГруппировки = ИмяПервойГруппировки Тогда
				МакетЗаголовка.ИмяГруппировки = ИмяГруппировкиДокументОтпуска;
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
#КонецОбласти // Оформление
	
КонецПроцедуры

// Обработчик исполнения отчета.
// см. функцию ПолучитьПараметрыИсполненияОтчета.
//
// Параметры:
//  ПараметрыОтчета - Структура - параметры, влияющие на результат отчета.
//  Результат       - ТабличныйДокумент - результат выполнения отчета.
//
// см. процедуру ОтчетыБольничнаяАптека.СформироватьОтчет
//
Процедура ПриВыводеПодвала(ПараметрыОтчета, Результат) Экспорт
	
	///////////////////////////////////////////////////////////////////////////////
	// Вывод подвала
	
	ОбластьПодвал = ПараметрыОтчета.МакетыОтчета.ПФ_MXL_7МЗ.ПолучитьОбласть("Подвал");
	
	ПодразделениеОрганизации = ПараметрыОтчета.ПодразделениеОрганизации;
	
	ОписаниеРуководителя = Новый Структура("ЗаведующийДолжность, ЗаведующийФИО", "ТекущаяДолжностьРуководителя", "ТекущийРуководитель");
	ДанныеРуководителя = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(ПодразделениеОрганизации, ОписаниеРуководителя);
	ДанныеРуководителя.ЗаведующийФИО = ФизическиеЛицаКлиентСервер.ФамилияИнициалы(СокрЛП(ДанныеРуководителя.ЗаведующийФИО));
	Если Не ЗначениеЗаполнено(ДанныеРуководителя.ЗаведующийДолжность) Тогда
		ДанныеРуководителя.ЗаведующийДолжность = НСтр("ru = 'Заведующий аптекой'");
	КонецЕсли;
	ОбластьПодвал.Параметры.Заполнить(ДанныеРуководителя);
	
	ОтчетыБольничнаяАптека.ВывестиОбластьВТабличныйДокумент(Результат, ОбластьПодвал);
	
КонецПроцедуры

// Обработчик исполнения отчета.
// см. функцию ПолучитьПараметрыИсполненияОтчета.
//
// Параметры:
//  ПараметрыОтчета - Структура - параметры, влияющие на результат отчета.
//  Результат       - ТабличныйДокумент - результат выполнения отчета.
//
// см. процедуру ОтчетыБольничнаяАптека.СформироватьОтчет
//
Процедура ПослеВыводаРезультата(ПараметрыОтчета, Результат) Экспорт
	
	НачальнаяОбласть = Результат.НайтиТекст("#НАЧАЛО#",,, Истина);
	КонечнаяОбласть = Результат.НайтиТекст("#ОКОНЧАНИЕ#",,, Истина);
	КонечнаяОбласть = Результат.Область(КонечнаяОбласть.Верх, КонечнаяОбласть.Лево);
	
	Если НачальнаяОбласть = Неопределено Тогда
		НачальнаяОбласть = КонечнаяОбласть;
	КонецЕсли;
	
	Область = Результат.Область(НачальнаяОбласть.Верх, НачальнаяОбласть.Лево, КонечнаяОбласть.Низ, КонечнаяОбласть.Право);
	Область.Объединить();
	Область.Текст = НСтр("ru = 'Выдано лекарственных средств на сумму (руб.)'");
	
	ОтчетыБольничнаяАптека.ОбработкаРезультатаОтчета(ПараметрыОтчета.ИдентификаторОтчета, Результат);
	
КонецПроцедуры

#КонецОбласти // СлужебныйПрограммныйИнтерфейс

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ
#Область СлужебныеПроцедурыИФункции

Функция ПолучитьПредставлениеПериода(ДатаНачала, ДатаОкончания)
	
	ПредставлениеПериода = "";
	Если ЗначениеЗаполнено(ДатаНачала) И ЗначениеЗаполнено(ДатаОкончания) И НачалоДня(ДатаНачала) < КонецДня(ДатаОкончания) Тогда
		ПредставлениеПериода = ПредставлениеПериода(НачалоДня(ДатаНачала), КонецДня(ДатаОкончания), "ФП = Истина");
	ИначеЕсли ЗначениеЗаполнено(ДатаНачала) Тогда
		ПредставлениеПериода = Формат(ДатаНачала, "ДЛФ=D") + " - ";
	ИначеЕсли ЗначениеЗаполнено(ДатаОкончания) Тогда
		ПредставлениеПериода = " - " + Формат(ДатаОкончания, "ДЛФ=D");
	КонецЕсли;
	
	Возврат ПредставлениеПериода;
	
КонецФункции

#КонецОбласти // СлужебныеПроцедурыИФункции

#КонецЕсли