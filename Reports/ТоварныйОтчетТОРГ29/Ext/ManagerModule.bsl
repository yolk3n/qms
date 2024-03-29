﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЙ ПРОГРАММНЫЙ ИНТЕРФЕЙС
#Область СлужебныйПрограммныйИнтерфейс

// Содержит настройки размещения вариантов отчета в панели отчетов.
//
// Параметры:
//  Настройки - Коллекция - Передается "как есть" из ВариантыОтчетовПереопределяемый.НастроитьВариантыОтчетов().
//       Может использоваться для получения настроек варианта этого отчета при помощи функции ВариантыОтчетов.ОписаниеВарианта().
//
// Описание:
//  В данной процедуре необходимо указать каким именно образом предопределенные варианты отчетов
//  будут регистрироваться в системе и показываться в панели отчетов.
//
// Вспомогательные функции:
//  Отчет = ВариантыОтчетов.ОписаниеОтчета(Настройки, Метаданные.Отчеты.<ИмяОтчета>);
//  Вариант = ВариантыОтчетов.ОписаниеВарианта(Настройки, Отчет, "<ИмяВарианта>");
//
//  Данные функции получают описание отчета или варианта отчета следующей структуры:
//       	|- Включен (Булево)
//            Если Ложь, то вариант отчета не регистрируется в подсистеме.
//              Используется для удаления технических и контекстных вариантов отчетов из всех интерфейсов.
//              Эти варианты отчета по прежнему можно открывать в форме отчета программно при помощи
//              параметров открытия (см. справку по "Расширение управляемой формы для отчета.КлючВарианта").
//       	|- ВидимостьПоУмолчанию (Булево)
//            Если Ложь, то вариант отчета по умолчанию скрыт в панели отчетов.
//              Пользователь может "включить" его в режиме настройки панели отчетов
//              или открыть через форму "Все отчеты".
//       	|- Описание (Строка)
//            Дополнительная информация по варианту отчета.
//              В панели отчетов выводится в качестве подсказки.
//              Должно расшифровывать для пользователя содержимое варианта отчета
//              и не должно дублировать наименование варианта отчета.
//       	|- Размещение (Соответствие) Настройки размещения варианта отчета в разделах
//           	|- Ключ     (ОбъектМетаданных) Подсистема, в которой размещается отчет или вариант отчета
//           	|- Значение (Строка)           Необязательный. Настройки размещения в подсистеме.
//               	|- ""        - Выводить отчет в своей группе обычным шрифтом.
//               	|- "Важный"  - Выводить отчет в своей группе жирным шрифтом.
//               	|- "СмТакже" - Выводить отчет в группе "См. также".
//
// Например:
//
//  (1) Оставить в подсистеме только один из вариантов отчета
//	Отчет = ВариантыОтчетов.ОписаниеОтчета(Настройки, Метаданные.Отчеты.ИмяОтчета);
//	Отчет.Размещение.Удалить(Метаданные.Подсистемы.ИмяРаздела);
//	Вариант = ВариантыОтчетов.ОписаниеВарианта(Настройки, Отчет, "ИмяВарианта1");
//	Отчет.Размещение.Вставить(Метаданные.Подсистемы.ИмяРаздела);
//
//  (2) Отключить вариант отчета
//	Вариант = ВариантыОтчетов.ОписаниеВарианта(Настройки, Метаданные.Отчеты.ИмяОтчета, "ИмяВарианта1");
//	Вариант.Включен = Ложь;
//
//  (3) Отключить все варианты отчета, кроме требуемого
//	Отчет = ВариантыОтчетов.ОписаниеОтчета(Настройки, Метаданные.Отчеты.ИмяОтчета);
//	Отчет.Включен = Ложь;
//	Вариант = ВариантыОтчетов.ОписаниеВарианта(Настройки, Отчет, "ИмяВарианта");
//	Вариант.Включен = Истина;
//
//  (4) Результат исполнения любого из двух фрагментов кода будет одинаковым:
//	Отчет = ВариантыОтчетов.ОписаниеОтчета(Настройки, Метаданные.Отчеты.ИмяОтчета);
//	Вариант = ВариантыОтчетов.ОписаниеВарианта(Настройки, Отчет, "ИмяВарианта1");
//	Вариант.Размещение.Удалить(Метаданные.Подсистемы.ИмяРаздела.Подсистемы.ИмяПодсистемы);
//	Вариант = ВариантыОтчетов.ОписаниеВарианта(Настройки, Отчет, "ИмяВарианта2");
//	Вариант.Размещение.Удалить(Метаданные.Подсистемы.ИмяРаздела.Подсистемы.ИмяПодсистемы);
//	Вариант = ВариантыОтчетов.ОписаниеВарианта(Настройки, Отчет, "ИмяВарианта3");
//	Вариант.Размещение.Удалить(Метаданные.Подсистемы.ИмяРаздела.Подсистемы.ИмяПодсистемы);
//
//	Отчет = ВариантыОтчетов.ОписаниеОтчета(Настройки, Метаданные.Отчеты.ИмяОтчета);
//	Отчет.Размещение.Удалить(Метаданные.Подсистемы.ИмяРаздела.Подсистемы.ИмяПодсистемы);
//	Вариант = ВариантыОтчетов.ОписаниеВарианта(Настройки, Отчет, "ИмяВарианта1");
//	Вариант = ВариантыОтчетов.ОписаниеВарианта(Настройки, Отчет, "ИмяВарианта2");
//	Вариант = ВариантыОтчетов.ОписаниеВарианта(Настройки, Отчет, "ИмяВарианта3");
//	Отчет.Размещение.Вставить(Метаданные.Подсистемы.ИмяРаздела.Подсистемы.ИмяПодсистемы);
//
//
// Важно:
//   Начальная настройка размещения отчетов по разделам зачитывается из метаданных,
//   ее дублирование в коде не требуется.
//   
//   Настройки варианта имеют приоритет над настройками отчета.
//   
//   Настройки варианта при получении формируются из настроек отчета
//   и после получения не зависят от настроек отчета (становятся самостоятельными, см. примеры 3 и 4).
//
Процедура НастроитьВариантыОтчета(Настройки, НастройкиОтчета) Экспорт
	
	НастройкиВарианта = ВариантыОтчетов.ОписаниеВарианта(Настройки, НастройкиОтчета, "");
	НастройкиВарианта.Описание = НСтр("ru = 'Анализа розничных продаж. Формируется по регламентированной форме Торг-29.'");
	НастройкиВарианта.НастройкиДляПоиска.НаименованияПолей = НСтр("ru= 'Форма по ОКУД 0330229
		|Организация
		|Структурное подразделение
		|ОКПО
		|Материально-ответственное лицо
		|МОЛ'");
	НастройкиВарианта.НастройкиДляПоиска.НаименованияПараметровИОтборов = НСтр("ru= 'Период
		|Организация
		|Склад
		|Номер отчета'");
	
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
	ПараметрыИсполнения.Вставить("ИспользоватьПриВыводеЗаголовка"            , Истина);
	ПараметрыИсполнения.Вставить("ИспользоватьПередКомпоновкойМакета"        , Истина);
	ПараметрыИсполнения.Вставить("ИспользоватьПослеКомпоновкиМакета"         , Истина);
	ПараметрыИсполнения.Вставить("ИспользоватьПередВыводомЭлементаРезультата", Истина);
	ПараметрыИсполнения.Вставить("ИспользоватьДанныеРасшифровки"             , Ложь);
	ПараметрыИсполнения.Вставить("ИспользоватьПриВыводеПодвала"              , Истина);
	
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
	
	ОтчетыБольничнаяАптека.ОбработкаРезультатаОтчета(ПараметрыОтчета.ИдентификаторОтчета, Результат);
	
	СведенияОбОрганизации = ФормированиеПечатныхФорм.СведенияОЮрФизЛице(ПараметрыОтчета.Организация, ПараметрыОтчета.ДатаОкончания);
	
	МОЛ = РегистрыСведений.МатериальноОтветственныеЛица.ПолучитьДанныеОтветственного(ПараметрыОтчета.Склад, ПараметрыОтчета.ДатаОкончания);
	МОЛДолжностьФИО = ?(ЗначениеЗаполнено(МОЛ.Должность), МОЛ.Должность + ", ", "") + МОЛ.Ответственный;
	
	ПараметрыОтчета.НомерОтчета = ПараметрыОтчета.НомерОтчета + 1;
	
	ПараметрыОтчета.Вставить("ОрганизацияПредставление", ФормированиеПечатныхФорм.ОписаниеОрганизации(СведенияОбОрганизации));
	ПараметрыОтчета.Вставить("ОрганизацияОКПО"         , СведенияОбОрганизации.КодПоОКПО);
	ПараметрыОтчета.Вставить("ДатаСоставления"         , ТекущаяДатаСеанса());
	ПараметрыОтчета.Вставить("МОЛ"                     , МОЛ);
	ПараметрыОтчета.Вставить("МОЛДолжностьФИО"         , МОЛДолжностьФИО);
	ПараметрыОтчета.Вставить("МОЛОтветственный"        , МОЛ.Ответственный);
	
	// Вывод области Заголовок
	ФормированиеПечатныхФормБольничнаяАптека.ВывестиОбластьПоИмени(Результат, ПараметрыОтчета.МакетыОтчета.ПФ_MXL_ТОРГ29, "Заголовок", ПараметрыОтчета);
	
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
	
	НастройкиКомпоновки = КомпоновщикНастроек.Настройки;
	
	// Установка параметров.
	ОбщегоНазначенияБольничнаяАптекаКлиентСервер.УстановитьПараметр(НастройкиКомпоновки, "Период", Новый СтандартныйПериод(ПараметрыОтчета.ДатаНачала, ПараметрыОтчета.ДатаОкончания));
	ОбщегоНазначенияБольничнаяАптекаКлиентСервер.УстановитьПараметр(НастройкиКомпоновки, "ОценкаЗапасовПоВидуЦен", 2);
	
	// Установка отборов.
	ОбщегоНазначенияБольничнаяАптекаКлиентСервер.ДобавитьОтбор(КомпоновщикНастроек, "Склад", ПараметрыОтчета.Склад);
	ОбщегоНазначенияБольничнаяАптекаКлиентСервер.ДобавитьОтбор(КомпоновщикНастроек, "Организация", ПараметрыОтчета.Организация);
	
	КомпоновщикНастроек.Восстановить();
	
	КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных;
	МакетКомпоновки = КомпоновщикМакета.Выполнить(Схема, КомпоновщикНастроек.ПолучитьНастройки(),,, Тип("ГенераторМакетаКомпоновкиДанныхДляКоллекцииЗначений"));
	
	ПараметрыОтчета.Вставить("МакетКомпоновки", МакетКомпоновки);
	
КонецПроцедуры

// Обработчик исполнения отчета.
// см. функцию ПолучитьПараметрыИсполненияОтчета.
//
// Параметры:
//  ПараметрыОтчета - Структура - параметры, влияющие на результат отчета.
//  МакетКомпоновки - МакетКомпоновкиДанных - созданный в результате компоновки макет компоновки.
//
// см. процедуру ОтчетыБольничнаяАптека.СформироватьОтчет
//
Процедура ПослеКомпоновкиМакета(ПараметрыОтчета, МакетКомпоновки) Экспорт
	
	МакетКомпоновки = ПараметрыОтчета.МакетКомпоновки;
	
КонецПроцедуры

// Обработчик исполнения отчета.
// см. функцию ПолучитьПараметрыИсполненияОтчета.
//
// Параметры:
//  ПараметрыОтчета         - Структура - параметры, влияющие на результат отчета.
//  МакетКомпоновки         - МакетКомпоновкиДанных - созданный в результате компоновки макет компоновки.
//  ЭлементРезультата       - ЭлементРезультатаКомпоновкиДанных - следующий элемент результата компоновки.
//  ДанныеРасшифровкиОбъект - ДанныеРасшифровкиКомпоновкиДанных - данные расшифровки.
//  СтандартнаяОбработка    - Булево - признак использования стандартного вывода элемента компоновки.
//  Результат               - ТабличныйДокумент - результат выполнения отчета.
//
// см. процедуру ОтчетыБольничнаяАптека.СформироватьОтчет
//
Процедура ПередВыводомЭлементаРезультата(ПроцессорВывода, ПроцессорКомпоновки, ПараметрыОтчета, МакетКомпоновки, ЭлементРезультата, ДанныеРасшифровкиОбъект, СтандартнаяОбработка, Результат) Экспорт
	
	СтандартнаяОбработка = Ложь;
	ПроцессорКомпоновки.Сбросить();
	
	Макет = ПараметрыОтчета.МакетыОтчета.ПФ_MXL_ТОРГ29;
	
	ДанныеМногострочнойЧасти = ПолучитьДанныеМногострочнойЧасти(ПроцессорКомпоновки, ПараметрыОтчета);
	ДанныеОбщихИтогов        = ПолучитьДанныеОбщихИтогов(ПараметрыОтчета, ДанныеМногострочнойЧасти);
	
	// Вывод шапки многострочной части
	ФормированиеПечатныхФормБольничнаяАптека.ВывестиОбластьПоИмени(Результат, Макет, "ШапкаТаблицы");
	
	Результат.ПовторятьПриПечатиСтроки = Результат.Область(Результат.ВысотаТаблицы, ,Результат.ВысотаТаблицы);
	
	// Вывод многострочной части
	Результат.НачатьАвтогруппировкуСтрок();
	Если ДанныеМногострочнойЧасти.Количество() > 0 Тогда
		
		// Вывод начальных остатков
		ФормированиеПечатныхФормБольничнаяАптека.ВывестиОбластьПоИмени(Результат, Макет, "НачальныеОстатки", ДанныеОбщихИтогов, 0);
		
		// Вывод прихода
		ФормированиеПечатныхФормБольничнаяАптека.ВывестиОбластьПоИмени(Результат, Макет, "Приход",, 1);
		
		// Вывод строк прихода
		ВывестиСтрокиМногострочнойЧасти(Результат, Макет, ДанныеМногострочнойЧасти, "Приход");
		
		// Вывод итогов по приходам
		ФормированиеПечатныхФормБольничнаяАптека.ВывестиОбластьПоИмени(Результат, Макет, "ИтогоПриход", ДанныеОбщихИтогов, 1);
		
		// Вывод итогов по приходам с начальным остатком
		ФормированиеПечатныхФормБольничнаяАптека.ВывестиОбластьПоИмени(Результат, Макет, "ВсегоПриход", ДанныеОбщихИтогов, 1);
		
		Результат.ВывестиГоризонтальныйРазделительСтраниц();
		
		// Вывод расхода
		ФормированиеПечатныхФормБольничнаяАптека.ВывестиОбластьПоИмени(Результат, Макет, "Расход",, 1);
		
		// Вывод строк расхода
		ВывестиСтрокиМногострочнойЧасти(Результат, Макет, ДанныеМногострочнойЧасти, "Расход");
		
		// Вывод итогов по расходам
		ФормированиеПечатныхФормБольничнаяАптека.ВывестиОбластьПоИмени(Результат, Макет, "ИтогоРасход", ДанныеОбщихИтогов, 1);
		
		// Вывод конечных остатков
		ФормированиеПечатныхФормБольничнаяАптека.ВывестиОбластьПоИмени(Результат, Макет, "КонечныеОстатки", ДанныеОбщихИтогов, 0);
		
	КонецЕсли;
	Результат.ЗакончитьАвтогруппировкуСтрок();
	
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
	
	МОЛ = ОбщегоНазначенияКлиентСервер.СвойствоСтруктуры(ПараметрыОтчета, "МОЛ");
	Если МОЛ = Неопределено Тогда
		МОЛ = РегистрыСведений.МатериальноОтветственныеЛица.ПолучитьДанныеОтветственного(ПараметрыОтчета.Склад, ПараметрыОтчета.ДатаОкончания);
		ПараметрыОтчета.Вставить("МОЛ"             , МОЛ);
		ПараметрыОтчета.Вставить("МОЛОтветственный", МОЛ.Ответственный);
	КонецЕсли;
	
	ПараметрыОтчета.Вставить("МОЛФИО"      , МОЛ.ФИО);
	ПараметрыОтчета.Вставить("МОЛДолжность", МОЛ.Должность);
	
	// Вывод подвала
	ФормированиеПечатныхФормБольничнаяАптека.ВывестиОбластьПоИмени(Результат, ПараметрыОтчета.МакетыОтчета.ПФ_MXL_ТОРГ29, "Подвал", ПараметрыОтчета);
	
КонецПроцедуры

#КонецОбласти // СлужебныйПрограммныйИнтерфейс

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ
#Область СлужебныеПроцедурыИФункции

Функция ПолучитьДанныеМногострочнойЧасти(ПроцессорКомпоновки, ПараметрыОтчета)
	
	ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВКоллекциюЗначений;
	ПроцессорВывода.УстановитьОбъект(Новый ТаблицаЗначений);
	ДанныеМногострочнойЧасти = ПроцессорВывода.Вывести(ПроцессорКомпоновки);
	
	Запрос = Новый Запрос("
	|ВЫБРАТЬ
	|	Таблица.Регистратор                        КАК Регистратор,
	|	ЕСТЬNULL(Таблица.СуммаНачальныйОстаток, 0) КАК СуммаНачальныйОстаток,
	|	ЕСТЬNULL(Таблица.СуммаПриход, 0)
	|		+ ЕСТЬNULL(Таблица.УвеличениеЦены, 0)  КАК СуммаПриход,
	|	ЕСТЬNULL(Таблица.СуммаРасход, 0)
	|		+ ЕСТЬNULL(Таблица.УменьшениеЦены, 0)  КАК СуммаРасход,
	|	ЕСТЬNULL(Таблица.СуммаКонечныйОстаток, 0)  КАК СуммаКонечныйОстаток
	|ПОМЕСТИТЬ ТаблицаДокументов
	|ИЗ
	|	&ИсходныеДанные КАК Таблица
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	НЕОПРЕДЕЛЕНО                             КАК Документ,
	|	НЕОПРЕДЕЛЕНО                             КАК Дата,
	|	НЕОПРЕДЕЛЕНО                             КАК Номер,
	|	ТаблицаДокументов.СуммаНачальныйОстаток  КАК СуммаНачальныйОстаток,
	|	ТаблицаДокументов.СуммаПриход            КАК СуммаПриход,
	|	ТаблицаДокументов.СуммаРасход            КАК СуммаРасход,
	|	ТаблицаДокументов.СуммаКонечныйОстаток   КАК СуммаКонечныйОстаток,
	|	ЛОЖЬ                                     КАК ЭтоПриход,
	|	ЛОЖЬ                                     КАК ЭтоРасход
	|ИЗ
	|	ТаблицаДокументов КАК ТаблицаДокументов
	|ГДЕ
	|	ТаблицаДокументов.Регистратор = НЕОПРЕДЕЛЕНО
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ТаблицаДокументов.Регистратор            КАК Документ,
	|	ТаблицаДокументов.Регистратор.Дата       КАК Дата,
	|	ТаблицаДокументов.Регистратор.Номер      КАК Номер,
	|	ТаблицаДокументов.СуммаНачальныйОстаток  КАК СуммаНачальныйОстаток,
	|	ТаблицаДокументов.СуммаПриход            КАК СуммаПриход,
	|	ТаблицаДокументов.СуммаРасход            КАК СуммаРасход,
	|	ТаблицаДокументов.СуммаКонечныйОстаток   КАК СуммаКонечныйОстаток,
	|	ВЫБОР
	|		КОГДА ТаблицаДокументов.СуммаПриход > 0 ТОГДА
	|			ИСТИНА
	|		ИНАЧЕ ЛОЖЬ
	|	КОНЕЦ                                    КАК ЭтоПриход,
	|	ВЫБОР
	|		КОГДА ТаблицаДокументов.СуммаРасход > 0 ТОГДА
	|			ИСТИНА
	|		ИНАЧЕ ЛОЖЬ
	|	КОНЕЦ                                    КАК ЭтоРасход
	|ИЗ
	|	ТаблицаДокументов КАК ТаблицаДокументов
	|ГДЕ
	|	ТаблицаДокументов.Регистратор <> НЕОПРЕДЕЛЕНО
	|");
	
	Запрос.УстановитьПараметр("ИсходныеДанные", ДанныеМногострочнойЧасти);
	
	УстановитьПривилегированныйРежим(Истина);
	ДанныеМногострочнойЧасти = Запрос.Выполнить().Выгрузить();
	УстановитьПривилегированныйРежим(Ложь);
	
	ДанныеМногострочнойЧасти.Колонки.Добавить("ДокументПредставление", Новый ОписаниеТипов("Строка"));
	
	// Формирование данных многострочной части.
	ВалютаУчета  = Константы.ВалютаРегламентированногоУчета.Получить();
	ВалютаСклада = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ПараметрыОтчета.Склад, "РозничныйВидЦены.ВалютаЦены");
	ТекущаяДата  = ТекущаяДатаСеанса();
	ПерваяСтрока = Истина;
	
	Для Каждого СтрокаМногострочнойЧасти Из ДанныеМногострочнойЧасти Цикл
		
		СтрокаМногострочнойЧасти.СуммаНачальныйОстаток = РаботаСКурсамиВалют.ПересчитатьВВалюту(
			СтрокаМногострочнойЧасти.СуммаНачальныйОстаток,
			ВалютаСклада,
			ВалютаУчета,
			ТекущаяДата);
		СтрокаМногострочнойЧасти.СуммаПриход           = РаботаСКурсамиВалют.ПересчитатьВВалюту(
			СтрокаМногострочнойЧасти.СуммаПриход,
			ВалютаСклада,
			ВалютаУчета,
			ТекущаяДата);
		СтрокаМногострочнойЧасти.СуммаРасход           = РаботаСКурсамиВалют.ПересчитатьВВалюту(
			СтрокаМногострочнойЧасти.СуммаРасход,
			ВалютаСклада,
			ВалютаУчета,
			ТекущаяДата);
		СтрокаМногострочнойЧасти.СуммаКонечныйОстаток  = РаботаСКурсамиВалют.ПересчитатьВВалюту(
			СтрокаМногострочнойЧасти.СуммаКонечныйОстаток,
			ВалютаСклада,
			ВалютаУчета,
			ТекущаяДата);
		
		Если ПерваяСтрока Тогда
			ПерваяСтрока = Ложь;
			Продолжить;
		КонецЕсли;
		
		СтрокаМногострочнойЧасти.Номер                 = ПрефиксацияОбъектовКлиентСервер.НомерНаПечать(СтрокаМногострочнойЧасти.Номер, Ложь, Истина);
		СтрокаМногострочнойЧасти.ДокументПредставление = ПолучитьПредставлениеДокумента(СтрокаМногострочнойЧасти);
		
	КонецЦикла;
	
	Возврат ДанныеМногострочнойЧасти;
	
КонецФункции

Функция ПолучитьДанныеОбщихИтогов(ПараметрыОтчета, ДанныеМногострочнойЧасти)
	
	Если ДанныеМногострочнойЧасти.Количество() > 0 Тогда
		
		ДанныеСтроки = ДанныеМногострочнойЧасти[0];
		
		ДанныеОбщихИтогов = Новый Структура;
		ДанныеОбщихИтогов.Вставить("ДатаНачала"           , НСтр("ru = 'Остаток на'") + " " + Формат(ПараметрыОтчета.ДатаНачала, "ДЛФ=Д"));
		ДанныеОбщихИтогов.Вставить("ДатаОкончания"        , НСтр("ru = 'Остаток на'") + " " + Формат(ПараметрыОтчета.ДатаОкончания, "ДЛФ=Д"));
		ДанныеОбщихИтогов.Вставить("СуммаНачальныйОстаток", ДанныеСтроки.СуммаНачальныйОстаток);
		ДанныеОбщихИтогов.Вставить("СуммаПриход"          , ДанныеСтроки.СуммаПриход);
		ДанныеОбщихИтогов.Вставить("ПриходСОстатком"      , ДанныеСтроки.СуммаНачальныйОстаток + ДанныеСтроки.СуммаПриход);
		ДанныеОбщихИтогов.Вставить("СуммаРасход"          , ДанныеСтроки.СуммаРасход);
		ДанныеОбщихИтогов.Вставить("СуммаКонечныйОстаток" , ДанныеСтроки.СуммаКонечныйОстаток);
		
	КонецЕсли;
	
	Возврат ДанныеОбщихИтогов;
	
КонецФункции

Процедура ВывестиСтрокиМногострочнойЧасти(ТабличныйДокумент, Макет, ДанныеМногострочнойЧасти, ТипДвижения)
	
	Отбор = Новый Структура("Это" + ТипДвижения, Истина);
	ДанныеДляВывода = ДанныеМногострочнойЧасти.НайтиСтроки(Отбор);
	
	МассивВыводимыхОбластей = Новый Массив;
	
	КоличествоСтрок = ДанныеДляВывода.Количество();
	НомерСтроки = 0;
	Для Каждого СтрокаМногострочнойЧасти Из ДанныеДляВывода Цикл
		
		НомерСтроки = НомерСтроки + 1;
		ЭтоПоследняяСтрока = НомерСтроки = КоличествоСтрок;
		
		ДанныеСтроки = Новый Структура("Документ, ДокументПредставление, Номер, Дата");
		ЗаполнитьЗначенияСвойств(ДанныеСтроки, СтрокаМногострочнойЧасти);
		ДанныеСтроки.Вставить("Сумма", СтрокаМногострочнойЧасти["Сумма" + ТипДвижения]);
		
		ОбластьСтрока = Макет.ПолучитьОбласть("Строка");
		ОбластьСтрока.Параметры.Заполнить(ДанныеСтроки);
		
		Если ЭтоПоследняяСтрока Тогда
			
			МассивВыводимыхОбластей.Очистить();
			МассивВыводимыхОбластей.Добавить(ОбластьСтрока);
			Если ТипДвижения = "Приход" Тогда
				МассивВыводимыхОбластей.Добавить(Макет.ПолучитьОбласть("ИтогоПриход"));
				МассивВыводимыхОбластей.Добавить(Макет.ПолучитьОбласть("ВсегоПриход"));
			ИначеЕсли ТипДвижения = "Расход" Тогда
				МассивВыводимыхОбластей.Добавить(Макет.ПолучитьОбласть("ИтогоРасход"));
				МассивВыводимыхОбластей.Добавить(Макет.ПолучитьОбласть("Подвал"));
			КонецЕсли;
			
			Если Не ТабличныйДокумент.ПроверитьВывод(МассивВыводимыхОбластей) Тогда
				
				// Переход на следующую страницу
				ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
				
			КонецЕсли;
			
		КонецЕсли;
		
		ТабличныйДокумент.Вывести(ОбластьСтрока, 2);
		
	КонецЦикла;
	
КонецПроцедуры

Функция ПолучитьПредставлениеДокумента(ДанныеСтроки)
	
	ТипДокумента = ТипЗнч(ДанныеСтроки.Документ);
	Если ТипДокумента = Тип("ДокументСсылка.ПоступлениеТоваров") Тогда
		
		НазваниеДокумента = НСтр("ru = 'Приходная накладная'");
		
	ИначеЕсли ТипДокумента = Тип("ДокументСсылка.ВозвратТоваровПоставщику") Тогда
		
		НазваниеДокумента = НСтр("ru = 'Возврат поставщику'");
		
	ИначеЕсли ТипДокумента = Тип("ДокументСсылка.УстановкаЦенНоменклатуры") Тогда
		
		НазваниеДокумента = НСтр("ru = 'Установка цен'");
		
	ИначеЕсли ТипДокумента = Тип("ДокументСсылка.ОтчетОРозничныхПродажах") Тогда
		
		НазваниеДокумента = НСтр("ru = 'Отчет о розничных продажах'");
		
	ИначеЕсли ТипДокумента = Тип("ДокументСсылка.ИзготовлениеПоЛекарственнойПрописи") Тогда
		
		НазваниеДокумента = НСтр("ru = 'Акт выпуска продукции фармацевтического производства'");
		
	ИначеЕсли ТипДокумента = Тип("ДокументСсылка.ОприходованиеИзлишковТоваров")
		  Или ТипДокумента = Тип("ДокументСсылка.ОприходованиеИзлишковТоваровВОтделении")
		  Или ТипДокумента = Тип("ДокументСсылка.ПрочееОприходованиеТоваров") Тогда
		
		НазваниеДокумента = НСтр("ru = 'Акт об оприходовании товаров'");
		
	ИначеЕсли ТипДокумента = Тип("ДокументСсылка.СписаниеНедостачТоваров")
		  Или ТипДокумента = Тип("ДокументСсылка.СписаниеНедостачТоваровВОтделении")
		  Или ТипДокумента = Тип("ДокументСсылка.ПотреблениеТоваровПоНазначениямВрачей") Тогда
		
		НазваниеДокумента = НСтр("ru = 'Акт о списании товаров'");
		
	ИначеЕсли ТипДокумента = Тип("ДокументСсылка.ПересортицаТоваров")
		  Или ТипДокумента = Тип("ДокументСсылка.ПересортицаТоваровВОтделении") Тогда
		
		НазваниеДокумента = НСтр("ru = 'Акт о пересортице товаров'");
		
	ИначеЕсли ТипДокумента = Тип("ДокументСсылка.ВнутреннееПотреблениеТоваров")
		  Или ТипДокумента = Тип("ДокументСсылка.ВнутреннееПотреблениеТоваровВОтделении")
		  Или ТипДокумента = Тип("ДокументСсылка.ТребованиеОтделения") Тогда
		
		НазваниеДокумента = НСтр("ru = 'Требование-накладная'");
		
	ИначеЕсли ТипДокумента = Тип("ДокументСсылка.ПеремещениеТоваров")
		  Или ТипДокумента = Тип("ДокументСсылка.ОтпускТоваровВОтделение")
		  Или ТипДокумента = Тип("ДокументСсылка.ВозвратТоваровИзОтделения")
		  Или ТипДокумента = Тип("ДокументСсылка.ПеремещениеТоваровМеждуОтделениями")Тогда
		
		НазваниеДокумента = НСтр("ru = 'Накладная на перемещение'");
		
	ИначеЕсли ТипДокумента = Тип("ДокументСсылка.РазмещениеТоваровПоМестамХранения")
		  Или ТипДокумента = Тип("ДокументСсылка.РазмещениеТоваровПоМестамХраненияВОтделении") Тогда
		
		НазваниеДокумента = НСтр("ru = 'Размещение по местам хранения'");
		
	ИначеЕсли ТипДокумента = Тип("ДокументСсылка.ВводОстатков")
		  Или ТипДокумента = Тип("ДокументСсылка.КорректировкаРегистров")Тогда
		
		НазваниеДокумента = НСтр("ru = 'Корректировка остатков'");
		
	ИначеЕсли ТипДокумента = Тип("ДокументСсылка.ЧекККМ") Тогда
		
		НазваниеДокумента = НСтр("ru = 'Чек ККМ'");
		
	ИначеЕсли ТипДокумента = Тип("ДокументСсылка.ПередачаТоваровНаСторону") Тогда
		
		// Для документа Передача товаров на сторону представление получается по хозяйственной операции.
		НазваниеДокумента = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ДанныеСтроки.Документ, "ХозяйственнаяОперация");
		
	Иначе
		
		НазваниеДокумента = Строка(ТипДокумента);
		
	КонецЕсли;
	
	Возврат СформироватьЗаголовокДокумента(ДанныеСтроки, НазваниеДокумента);
	
КонецФункции

// Возвращает заголовок документа в том виде, в котором его формирует платформа для представления ссылки на документ.
//
// Параметры:
//  Шапка - Структура с ключами
//    * Номер - строка или число - номер документа.
//    * Дата  - дата - дата документа.
//  НазваниеДокумента - Строка - название документа (например, синоним объекта метаданных).
//  УдалитьТолькоЛидирующиеНулиНомера - Булево
//
// Возвращаемое значение:
//  Строка - заголовок документа.
//
Функция СформироватьЗаголовокДокумента(Шапка, Знач НазваниеДокумента, УдалитьТолькоЛидирующиеНулиНомера = Ложь)
	
	ДанныеДокумента = Новый Структура("Номер, Дата");
	ЗаполнитьЗначенияСвойств(ДанныеДокумента, Шапка);
	
	Если УдалитьТолькоЛидирующиеНулиНомера Тогда
		НомерНаПечать = ПрефиксацияОбъектовКлиентСервер.УдалитьЛидирующиеНулиИзНомераОбъекта(ДанныеДокумента.Номер);
	Иначе
		НомерНаПечать = ПрефиксацияОбъектовКлиентСервер.НомерНаПечать(ДанныеДокумента.Номер);
	КонецЕсли;
	
	Возврат СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru = '%1 № %2 от %3'"), НазваниеДокумента, НомерНаПечать, Формат(ДанныеДокумента.Дата, "ДЛФ=DD"));
	
КонецФункции

#КонецОбласти // СлужебныеПроцедурыИФункции

#КонецЕсли