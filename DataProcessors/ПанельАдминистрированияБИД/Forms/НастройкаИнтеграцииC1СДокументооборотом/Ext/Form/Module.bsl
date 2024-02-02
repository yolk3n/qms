﻿#Область ОписаниеПеременных

&НаКлиенте
Перем ОбновитьИнтерфейс;

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ЕстьПодсистемаДО2 = ИнтеграцияС1СДокументооборотБазоваяФункциональность.ЕстьПодсистемаДО2();
	ЕстьПодсистемаДО3 = ИнтеграцияС1СДокументооборотБазоваяФункциональность.ЕстьПодсистемаДО3();
	
	// Значения реквизитов формы
	СоставНабораКонстантФормы = СоставНабораКонстант(НаборКонстант);
	ВнешниеРодительскиеКонстанты = РодительскиеКонстанты(СоставНабораКонстантФормы);
	ДоступноПравоАдминистрирование = ПравоДоступа("Администрирование", Метаданные);
	
	РежимРаботы = Новый Структура;
	РежимРаботы.Вставить("СоставНабораКонстантФормы", Новый ФиксированнаяСтруктура(СоставНабораКонстантФормы));
	РежимРаботы.Вставить("ВнешниеРодительскиеКонстанты", Новый ФиксированнаяСтруктура(ВнешниеРодительскиеКонстанты));
	
	РежимРаботы = Новый ФиксированнаяСтруктура(РежимРаботы);
	
	ПолучитьМаксимальныйРазмерПередаваемогоФайла();
	
	МассивСтрокПояснениеСрокХранения = Новый Массив;
	МассивСтрокПояснениеСрокХранения.Добавить(НСтр("ru = 'Количество времени, в течении которого будет храниться'"));
	МассивСтрокПояснениеСрокХранения.Добавить(" ");
	МассивСтрокПояснениеСрокХранения.Добавить(
		Новый ФорматированнаяСтрока(НСтр("ru = 'история отправки'"),,
			Элементы.ПояснениеСрокХраненияСообщений.ЦветТекста,,
			"e1cib/list/РегистрСведений.ИсторияОтправкиСообщенийВ1СДокументооборот"));
	МассивСтрокПояснениеСрокХранения.Добавить(" ");
	МассивСтрокПояснениеСрокХранения.Добавить(НСтр("ru = 'и'"));
	МассивСтрокПояснениеСрокХранения.Добавить(" ");
	МассивСтрокПояснениеСрокХранения.Добавить(
		Новый ФорматированнаяСтрока(НСтр("ru = 'очередь отправки'"),,
			Элементы.ПояснениеСрокХраненияСообщений.ЦветТекста,,
			"e1cib/list/РегистрСведений.ОчередьСообщенийВ1СДокументооборот"));
	МассивСтрокПояснениеСрокХранения.Добавить(" ");
	МассивСтрокПояснениеСрокХранения.Добавить(НСтр("ru = 'сообщений.'"));
	Элементы.ПояснениеСрокХраненияСообщений.Заголовок = Новый ФорматированнаяСтрока(МассивСтрокПояснениеСрокХранения);
	Элементы.ПояснениеСрокХраненияСообщенийДО3.Заголовок = Новый ФорматированнаяСтрока(МассивСтрокПояснениеСрокХранения);
	
	ОбновитьСпособХраненияПрисоединенныхФайлов();
	ОбновитьНастройкиОбновленияСвязанныхРеквизитов();
	ПолучитьСрокХраненияСообщенийВ1СДокументооборот();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	УстановитьВидимость();
	
	Если ЗначениеЗаполнено(НаборКонстант.АдресВебСервиса1СДокументооборот) Тогда
		ОписаниеОповещения = Новый ОписаниеОповещения("ПроверитьПодключениеЗавершение", ЭтотОбъект);
		ИнтеграцияС1СДокументооборотБазоваяФункциональностьКлиент.ПроверитьПодключение(ОписаниеОповещения, ЭтотОбъект);
	КонецЕсли;
	
	УстановитьДоступность();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии()
	
	ОбновитьИнтерфейсПрограммы();
	
КонецПроцедуры

// Обработчик оповещения формы.
//
// Параметры:
//   ИмяСобытия - Строка - обрабатывается только событие Запись_НаборКонстант, генерируемое панелями администрирования.
//   Параметр   - Структура - содержит имена констант, подчиненных измененной константе, "вызвавшей" оповещение.
//   Источник   - Строка - имя измененной константы, "вызвавшей" оповещение.
//
&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "ИнтеграцияС1СДокументооборотом_УспешноеПодключение" Тогда
		УстановитьВидимость();
	КонецЕсли;
	
	Если ИмяСобытия <> "Запись_НаборКонстант" Тогда
		Возврат; // такие событие не обрабатываются
	КонецЕсли;
	
	// Если это изменена константа, расположенная в другой форме и влияющая на значения констант этой формы,
	// то прочитаем значения констант и обновим элементы этой формы.
	Если РежимРаботы.ВнешниеРодительскиеКонстанты.Свойство(Источник)
			Или (ТипЗнч(Параметр) = Тип("Структура")
			И ПолучитьОбщиеКлючиСтруктур(Параметр, РежимРаботы.ВнешниеРодительскиеКонстанты).Количество() > 0) Тогда
		
		Прочитать();
		УстановитьДоступность();
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ДекорацияНастройкиАвторизацииНажатие(Элемент)
	
	Если Не ЗначениеЗаполнено(НаборКонстант.АдресВебСервиса1СДокументооборот) Тогда
		ПоказатьПредупреждение(, НСтр("ru = 'Не указан адрес веб-сервиса.'"));
		Возврат;
	КонецЕсли;
	
	Оповещение = Новый ОписаниеОповещения("НастройкиАвторизацииНажатиеЗавершение", ЭтотОбъект);
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ВызовДляНастройкиДоступа", Истина);
	
	ОткрытьФорму(
		"Обработка.ИнтеграцияС1СДокументооборотБазоваяФункциональность.Форма.АвторизацияВ1СДокументооборот",
		ПараметрыФормы,
		ЭтотОбъект,,,,
		Оповещение,
		РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьИнтеграциюС1СДокументооборотПриИзменении(Элемент)
	
	Подключаемый_ПриИзмененииРеквизита(Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура АдресВебСервиса1СДокументооборотПриИзменении(Элемент)
	
	Подключаемый_ПриИзмененииРеквизита(Элемент, Ложь);
	
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьСвязанныеДокументы1СДокументооборотаПриИзменении(Элемент)
	
	Подключаемый_ПриИзмененииРеквизита(Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьПроцессыИЗадачи1СДокументооборотаПриИзменении(Элемент)
	
	Подключаемый_ПриИзмененииРеквизита(Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьОбработкуОбъектов1СДокументооборотаПриИзменении(Элемент)
	
	Подключаемый_ПриИзмененииРеквизита(Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьЕжедневныеОтчеты1СДокументооборотаПриИзменении(Элемент)
	
	Подключаемый_ПриИзмененииРеквизита(Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьЭлектроннуюПочту1СДокументооборотаПриИзменении(Элемент)
	
	Подключаемый_ПриИзмененииРеквизита(Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура СпособХраненияПрисоединенныхФайловПриИзменении(Элемент)
	
	Если СпособХраненияПрисоединенныхФайлов = 0 Тогда // не использовать ДО
		НаборКонстант.ИспользоватьПрисоединенныеФайлы1СДокументооборота = Ложь;
		НаборКонстант.ИспользоватьФайловоеХранилище1СДокументооборота = Ложь;
		
	ИначеЕсли СпособХраненияПрисоединенныхФайлов = 1 Тогда // файлы связанных объектов
		НаборКонстант.ИспользоватьПрисоединенныеФайлы1СДокументооборота = Истина;
		НаборКонстант.ИспользоватьФайловоеХранилище1СДокументооборота = Ложь;
		
	Иначе // 2, файлы в папках
		НаборКонстант.ИспользоватьПрисоединенныеФайлы1СДокументооборота = Ложь;
		НаборКонстант.ИспользоватьФайловоеХранилище1СДокументооборота = Истина;
		
	КонецЕсли;
	
	Подключаемый_ПриИзмененииРеквизита(Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура НаименованиеКорневойПапкиФайлов1СДокументооборотНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ОписаниеОповещения = Новый ОписаниеОповещения(
		"НаименованиеКорневойПапкиФайловПроверкаПодключенияЗавершение",
		ЭтотОбъект,
		Элемент);
	ИнтеграцияС1СДокументооборотБазоваяФункциональностьКлиент.ПроверитьПодключение(
		ОписаниеОповещения,
		ЭтотОбъект,
		Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура НаименованиеКорневойПапкиФайловПроверкаПодключенияЗавершение(Результат, ЭлементФормы) Экспорт
	
	Если Результат = Истина Тогда
		УстановитьКорневуюПапкуФайловДокументооборота(ЭлементФормы);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьКорневуюПапкуФайловДокументооборота(Элемент)
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ТипОбъектаВыбора", "DMFileFolder");
	ПараметрыФормы.Вставить("Отбор", Неопределено);
	ПараметрыФормы.Вставить("ВыбранныйЭлемент", НаборКонстант.ИдентификаторКорневойПапкиФайлов1СДокументооборот);
	ПараметрыФормы.Вставить("Заголовок", НСтр("ru = 'Выбор папки файлов'"));
	
	Оповещение = Новый ОписаниеОповещения(
		"УстановитьКорневуюПапкуФайловДокументооборотаЗавершение",
		ЭтотОбъект,
		Элемент);
	
	ОткрытьФорму(
		"Обработка.ИнтеграцияС1СДокументооборотБазоваяФункциональность.Форма.ВыборИзСписка",
		ПараметрыФормы,
		ЭтотОбъект,,,,
		Оповещение,
		РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

&НаКлиенте
Процедура НаименованиеКорневойПапкиФайлов1СДокументооборотОчистка(Элемент, СтандартнаяОбработка)
	
	НаборКонстант.ИдентификаторКорневойПапкиФайлов1СДокументооборот = "";
	Подключаемый_ПриИзмененииРеквизита(Элемент, Ложь);
	
КонецПроцедуры

&НаКлиенте
Процедура МаксимальныйРазмерФайлаДляПередачиВ1СДокументооборотПриИзменении(Элемент)
	
	Подключаемый_ПриИзмененииРеквизита(Элемент, Ложь, "МаксимальныйРазмерФайлаДляПередачиВ1СДокументооборот");
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаНавигационнойСсылки(НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	Если НавигационнаяСсылкаФорматированнойСтроки = "ИзменитьРасписание" Тогда
		
		СтандартнаяОбработка = Ложь;
		
		ОписаниеОповещения = Новый ОписаниеОповещения("ДиалогНастройкиРасписанияЗавершение", ЭтотОбъект);
		
		ДиалогНастройкиРасписания = Новый ДиалогРасписанияРегламентногоЗадания(РасписаниеРегламентногоЗадания);
		ДиалогНастройкиРасписания.Показать(ОписаниеОповещения);
		
	ИначеЕсли НавигационнаяСсылкаФорматированнойСтроки = "ВвестиИмяПользователяИПароль" Тогда
		
		СтандартнаяОбработка = Ложь;
		
		ПараметрыФормы = Новый Структура;
		ПараметрыФормы.Вставить("ВызовДляПользователяЗаданияОбмена", Истина);
		
		ОткрытьФорму("Обработка.ИнтеграцияС1СДокументооборотБазоваяФункциональность.Форма.АвторизацияВ1СДокументооборот",
			ПараметрыФормы,
			ЭтотОбъект,,,,,
			РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновлятьСвязанныеОбъектыАвтоматическиПриИзменении(Элемент)
	
	ОбновитьИспользованиеРегламентногоЗадания(ОбновлятьСвязанныеОбъектыАвтоматически);
	
КонецПроцедуры

&НаКлиенте
Процедура СрокХраненияСообщенийВ1СДокументооборотПриИзменении(Элемент)
	
	Подключаемый_ПриИзмененииРеквизита(Элемент, Ложь, "СрокХраненияСообщенийВ1СДокументооборот");
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ИнтегрируемыеОбъекты(Команда)
	
	ИмяФормыИнтегрируемыеОбъекты = "Справочник.ПравилаИнтеграцииС1СДокументооборотом.Форма.ИнтегрируемыеОбъекты";
	ОткрытьФорму(ИмяФормыИнтегрируемыеОбъекты, , ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ПравилаИнтеграции(Команда)
	
	ИмяФормыСписка = "Справочник.ПравилаИнтеграцииС1СДокументооборотом.Форма.ФормаСписка";
	ОткрытьФорму(ИмяФормыСписка, , ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ПравилаИнтеграцииДО3(Команда)
	
	ИмяФормыСписка = "Справочник.ПравилаИнтеграцииС1СДокументооборотом3.Форма.ФормаСписка";
	ОткрытьФорму(ИмяФормыСписка, , ЭтотОбъект);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область Клиент

&НаКлиенте
Процедура ПроверитьПодключениеЗавершение(Результат, Параметры) Экспорт
	
	Если Результат = Истина Тогда
		
		УстановитьВидимость();
		
		Если Лев(ВерсияСервиса, 1) = "2"
				И ЕстьПодсистемаДО3
				И НаборКонстант.ИспользоватьИнтеграциюС1СДокументооборот3 Тогда
			НаборКонстант.ИспользоватьИнтеграциюС1СДокументооборот3 = Ложь;
			Подключаемый_ПриИзмененииРеквизита(Элементы.ИспользоватьИнтеграциюС1СДокументооборот3);
			
		ИначеЕсли Лев(ВерсияСервиса, 1) = "3"
				И ЕстьПодсистемаДО2
				И НаборКонстант.ИспользоватьИнтеграциюС1СДокументооборот Тогда
			НаборКонстант.ИспользоватьИнтеграциюС1СДокументооборот = Ложь;
			Подключаемый_ПриИзмененииРеквизита(Элементы.ИспользоватьИнтеграциюС1СДокументооборот);
			
		КонецЕсли;
		
	Иначе // не удалось подключиться к ДО
		
		Оповещение = Новый ОписаниеОповещения("НастройкиАвторизацииНажатиеЗавершение", ЭтотОбъект);
		
		ПараметрыФормы = Новый Структура;
		ПараметрыФормы.Вставить("ВызовДляНастройкиДоступа", Истина);
		
		ОткрытьФорму(
			"Обработка.ИнтеграцияС1СДокументооборотБазоваяФункциональность.Форма.АвторизацияВ1СДокументооборот",
			ПараметрыФормы,
			ЭтотОбъект,,,,
			Оповещение,
			РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура НастройкиАвторизацииНажатиеЗавершение(Результат, Параметры) Экспорт
	
	УстановитьВидимость();
	
КонецПроцедуры

&НаКлиенте
Процедура ДиалогНастройкиРасписанияЗавершение(Результат, Параметры) Экспорт
	
	Если Результат <> Неопределено Тогда
		ОбновитьНастройкиОбновленияСвязанныхРеквизитов(Результат);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьДоступность()
	
	Если ЕстьПодсистемаДО2 Тогда
		
		ЗначениеКонстанты = НаборКонстант.ИспользоватьИнтеграциюС1СДокументооборот;
		УстановитьДоступностьИспользованияИнтеграции(ЗначениеКонстанты);
		
		ЗначениеКонстанты = НаборКонстант.ИспользоватьФайловоеХранилище1СДокументооборота;
		Элементы.НаименованиеКорневойПапкиФайлов1СДокументооборот.Доступность = ЗначениеКонстанты;
		
	КонецЕсли;
	
	Если ЕстьПодсистемаДО3 Тогда
		
		ЗначениеКонстанты = НаборКонстант.ИспользоватьИнтеграциюС1СДокументооборот3;
		УстановитьДоступностьИспользованияИнтеграцииДО3(ЗначениеКонстанты);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьДоступностьИспользованияИнтеграции(Значение)
	
	Если Не Элементы.ГруппаПодключение.Доступность Тогда
		Элементы.ГруппаПодключение.Доступность = Истина;
		
		Если ЗначениеЗаполнено(НаборКонстант.АдресВебСервиса1СДокументооборот) Тогда
			ОписаниеОповещения = Новый ОписаниеОповещения("ПроверитьПодключениеЗавершение", ЭтотОбъект);
			ИнтеграцияС1СДокументооборотБазоваяФункциональностьКлиент.ПроверитьПодключение(ОписаниеОповещения, ЭтотОбъект);
		Иначе
			УстановитьВидимость();
		КонецЕсли;
	КонецЕсли;
	
	Элементы.ИспользоватьПроцессыИЗадачи1СДокументооборота.Доступность = Значение;
	Элементы.ИспользоватьСвязанныеДокументы1СДокументооборота.Доступность = Значение;
	Элементы.ИспользоватьЕжедневныеОтчеты1СДокументооборота.Доступность = Значение;
	Элементы.ИспользоватьЭлектроннуюПочту1СДокументооборота.Доступность = Значение;
	Элементы.СпособХраненияПрисоединенныхФайлов.Доступность = Значение;
	Элементы.ГруппаПоляМаксимальныйРазмерФайлаДляПередачи.Доступность = Значение;
	Элементы.ИнтегрируемыеОбъекты.Доступность = Значение;
	Элементы.ПравилаИнтеграции.Доступность = Значение;
	
	Элементы.ГруппаАвтообновлениеДО2.Доступность = Значение И ДоступноПравоАдминистрирование;
	Элементы.КомандыНастройкиОбновленияДО2.Доступность = Значение И ДоступноПравоАдминистрирование;
	Элементы.ГруппаСрокХраненияДО2.Доступность = Значение И ДоступноПравоАдминистрирование;
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьДоступностьИспользованияИнтеграцииДО3(Значение)
	
	Если Не Элементы.ГруппаПодключение.Доступность Тогда
		Элементы.ГруппаПодключение.Доступность = Истина;
		
		Если ЗначениеЗаполнено(НаборКонстант.АдресВебСервиса1СДокументооборот) Тогда
			ОписаниеОповещения = Новый ОписаниеОповещения("ПроверитьПодключениеЗавершение", ЭтотОбъект);
			ИнтеграцияС1СДокументооборотБазоваяФункциональностьКлиент.ПроверитьПодключение(ОписаниеОповещения, ЭтотОбъект);
		Иначе
			УстановитьВидимость();
		КонецЕсли;
	КонецЕсли;
	
	Элементы.ИспользоватьОбработкуОбъектов1СДокументооборота.Доступность = Значение;
	Элементы.СпособХраненияПрисоединенныхФайловДО3.Доступность = Значение;
	Элементы.ГруппаПоляМаксимальныйРазмерФайлаДляПередачиДО3.Доступность = Значение;
	Элементы.ПравилаИнтеграцииДО3.Доступность = Значение;
	
	Элементы.ГруппаАвтообновлениеДО3.Доступность = Значение И ДоступноПравоАдминистрирование;
	Элементы.КомандыНастройкиОбновленияДО3.Доступность = Значение И ДоступноПравоАдминистрирование;
	Элементы.ГруппаСрокХраненияДО3.Доступность = Значение И ДоступноПравоАдминистрирование;
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьКорневуюПапкуФайловДокументооборотаЗавершение(Результат, Элемент) Экспорт
	
	Если ТипЗнч(Результат) = Тип("Структура") Тогда
		НаборКонстант.НаименованиеКорневойПапкиФайлов1СДокументооборот  = Результат.РеквизитПредставление;
		НаборКонстант.ИдентификаторКорневойПапкиФайлов1СДокументооборот = Результат.РеквизитID;
	КонецЕсли;
	
	Подключаемый_ПриИзмененииРеквизита(Элемент, Ложь);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПриИзмененииРеквизита(Элемент, ОбновлятьИнтерфейс = Истина, КонстантаИмя = "")
	
	ПриИзмененииРеквизитаСервер(Элемент.Имя, КонстантаИмя);
	
	Если КонстантаИмя = "ИспользоватьИнтеграциюС1СДокументооборот"
			И Не НаборКонстант.ИспользоватьИнтеграциюС1СДокументооборот Тогда
		УстановитьДоступностьИспользованияИнтеграции(Ложь);
	КонецЕсли;
	
	Если КонстантаИмя = "ИспользоватьИнтеграциюС1СДокументооборот3"
			И Не НаборКонстант.ИспользоватьИнтеграциюС1СДокументооборот3 Тогда
		УстановитьДоступностьИспользованияИнтеграцииДО3(Ложь);
	КонецЕсли;
	
	Если КонстантаИмя = "АдресВебСервиса1СДокументооборот" Тогда
		Элементы.ГруппаПодключение.Доступность = Ложь;
	КонецЕсли;
	
	Если ОбновлятьИнтерфейс Тогда
#Если Не ВебКлиент Тогда
		ПодключитьОбработчикОжидания("ОбновитьИнтерфейсПрограммы", 1, Истина);
		ОбновитьИнтерфейс = Истина;
#Иначе
		УстановитьДоступность();
#КонецЕсли
	Иначе
		УстановитьДоступность();
	КонецЕсли;
	
	Если КонстантаИмя <> "" Тогда
		Оповестить("Запись_НаборКонстант", Новый Структура, КонстантаИмя);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьИнтерфейсПрограммы()
	
	Если ОбновитьИнтерфейс = Истина Тогда
		ОбновитьИнтерфейс = Ложь;
		ОбновитьИнтерфейс();
	КонецЕсли;
	
	УстановитьДоступность();
	
КонецПроцедуры

&НаКлиенте
Функция ПолучитьОбщиеКлючиСтруктур(Структура1, Структура2)
	
	Результат = Новый Структура;
	
	Для Каждого КлючИЗначение Из Структура1 Цикл
		Если Структура2.Свойство(КлючИЗначение.Ключ) Тогда
			Результат.Вставить(КлючИЗначение.Ключ);
		КонецЕсли;
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти

#Область ВызовСервера

&НаСервере
Процедура УстановитьВидимость()
	
	Элементы.ГруппаСтраницы.Видимость = Ложь;
	
	ВерсияСервиса = ИнтеграцияС1СДокументооборотБазоваяФункциональность.ВерсияСервиса();
	
	Если ИнтеграцияС1СДокументооборотБазоваяФункциональностьКлиентСервер.СервисДоступен(ВерсияСервиса) Тогда
		
		НомерРедакции = Лев(ВерсияСервиса, 1);
		
		Элементы.ГруппаСтраницы.Видимость = Истина;
		Если НомерРедакции = "1" Тогда
			Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.СтраницаВерсияНеПоддерживается;
			Элементы.ДекорацияОписаниеВерсияНеПоддерживается.Заголовок = НСтр(
				"ru = 'Интеграция с 1С:Документооборот редакции 1 не поддерживается.'");
			
		ИначеЕсли НомерРедакции = "2" Тогда
			Если ЕстьПодсистемаДО2 Тогда
				Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.ГруппаИнтеграцияС1СДокументооборотомРедакции2;
			Иначе
				Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.СтраницаВерсияНеПоддерживается;
				Элементы.ДекорацияОписаниеВерсияНеПоддерживается.Заголовок = НСтр(
					"ru = 'Интеграция с 1С:Документооборот редакции 2 не поддерживается.'");
			КонецЕсли;
			
		ИначеЕсли НомерРедакции = "3" Тогда
			Если ЕстьПодсистемаДО3 Тогда
				Если ИнтеграцияС1СДокументооборотБазоваяФункциональность.ДоступенФункционалВерсииСервиса("3.0.7.1") Тогда
					Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.ГруппаИнтеграцияС1СДокументооборотомРедакции3;
					
				Иначе
					Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.СтраницаВерсияНеПоддерживается;
					Элементы.ДекорацияОписаниеВерсияНеПоддерживается.Заголовок = НСтр(
						"ru = 'Функционал не поддерживается в данной версии 1С:Документооборота.
						|Требуется 1С:Документооборот версии 3.0.7 или выше.'");
					
				КонецЕсли;
			Иначе
				Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.СтраницаВерсияНеПоддерживается;
				Элементы.ДекорацияОписаниеВерсияНеПоддерживается.Заголовок = НСтр(
					"ru = 'Интеграция с 1С:Документооборот редакции 3 не поддерживается.'");
			КонецЕсли;
			
		Иначе
			Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.СтраницаВерсияНеПоддерживается;
			Элементы.ДекорацияОписаниеВерсияНеПоддерживается.Заголовок = СтрШаблон(
				НСтр("ru = 'Интеграция с 1С:Документооборот редакции %1 не поддерживается.'"),
				НомерРедакции);
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьСпособХраненияПрисоединенныхФайлов()
	
	Если НаборКонстант.ИспользоватьПрисоединенныеФайлы1СДокументооборота Тогда
		СпособХраненияПрисоединенныхФайлов = 1;
	ИначеЕсли НаборКонстант.ИспользоватьФайловоеХранилище1СДокументооборота Тогда
		СпособХраненияПрисоединенныхФайлов = 2;
	Иначе
		СпособХраненияПрисоединенныхФайлов = 0;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьНастройкиОбновленияСвязанныхРеквизитов(Расписание = Неопределено)
	
	Если Не ДоступноПравоАдминистрирование Тогда
		ОписаниеНастройкиОбновления = Новый ФорматированнаяСтрока(НСтр("ru = 'Расписание не доступно'"));
		Возврат;
	КонецЕсли;
	
	Задание = РегламентныеЗаданияСервер.Задание(
		Метаданные.РегламентныеЗадания.ИнтеграцияС1СДокументооборотВыполнитьОбменДанными);
	
	Если Расписание <> Неопределено Тогда
		Задание.Расписание = Расписание;
		Задание.Записать();
	КонецЕсли;
	
	ОбновлятьСвязанныеОбъектыАвтоматически = Задание.Использование;
	РасписаниеРегламентногоЗадания = Задание.Расписание;
	
	МассивСтрокОписание = Новый Массив;
	
	РасписаниеСтрокой = Строка(Задание.Расписание);
	Если Не СтрЗаканчиваетсяНа(РасписаниеСтрокой, ".") Тогда
		РасписаниеСтрокой = РасписаниеСтрокой + ".  ";
	Иначе
		РасписаниеСтрокой = РасписаниеСтрокой + "  ";
	КонецЕсли;
	МассивСтрокОписание.Добавить(РасписаниеСтрокой);
	
	ОписаниеНастройкиОбновления = Новый ФорматированнаяСтрока(МассивСтрокОписание);
	
	МассивСтрокКоманды = Новый Массив;
	
	СтрокаСсылки = Новый ФорматированнаяСтрока(НСтр("ru = 'Изменить расписание'"),,,, "ИзменитьРасписание");
	МассивСтрокКоманды.Добавить(СтрокаСсылки);
	
	МассивСтрокКоманды.Добавить("  ");
	
	СтрокаСсылки = Новый ФорматированнаяСтрока(
		НСтр("ru = 'Задать служебного пользователя для обмена'"),,,,
		"ВвестиИмяПользователяИПароль");
	МассивСтрокКоманды.Добавить(СтрокаСсылки);
	
	КомандыНастройкиОбновления = Новый ФорматированнаяСтрока(МассивСтрокКоманды);
	
КонецПроцедуры

&НаСервере
Процедура ПриИзмененииРеквизитаСервер(ИмяЭлемента, КонстантаИмя)
	
	РеквизитПутьКДанным = Элементы[ИмяЭлемента].ПутьКДанным;
	
	СохранитьЗначениеРеквизита(РеквизитПутьКДанным, КонстантаИмя);
	
	Если КонстантаИмя = "ИспользоватьИнтеграциюС1СДокументооборот"
			Или КонстантаИмя = "ИспользоватьИнтеграциюС1СДокументооборот3" Тогда
		ОбновитьСпособХраненияПрисоединенныхФайлов();
		ОбновитьНастройкиОбновленияСвязанныхРеквизитов();
	КонецЕсли;
	
	Если КонстантаИмя = "АдресВебСервиса1СДокументооборот" Тогда
		ПараметрыСеанса.ИнтеграцияС1СДокументооборотПарольИзвестен = Ложь;
		ПараметрыСеанса.ИнтеграцияС1СДокументооборотМестоположениеПрокси = "";
		Если Не ЗначениеЗаполнено(НаборКонстант.АдресВебСервиса1СДокументооборот) Тогда
			ПараметрыСеанса.ИнтеграцияС1СДокументооборотВерсияСервиса = "0.0.0.0";
		КонецЕсли;
	КонецЕсли;
	
	ИнтеграцияС1СДокументооборотБазоваяФункциональность.ОбновитьПовторноИспользуемыеПараметры();
	
КонецПроцедуры

&НаСервере
Процедура СохранитьЗначениеРеквизита(РеквизитПутьКДанным, КонстантаИмя = "", ПеречитыватьФорму = Истина)
	
	// Сохранение значений реквизитов, не связанных с константами напрямую (в отношении один-к-одному).
	Если РеквизитПутьКДанным = "" Тогда
		Возврат;
	КонецЕсли;
	
	Если КонстантаИмя = "" Тогда
		// Определение имени константы.
		МассивЧастейРеквизитПутьКДанным = СтрРазделить(РеквизитПутьКДанным, ".");
		Если МассивЧастейРеквизитПутьКДанным.Количество() = 2
				И НРег(МассивЧастейРеквизитПутьКДанным[0]) = НРег("НаборКонстант") Тогда
			// Если путь к данным реквизита указан через "НаборКонстант".
			КонстантаИмя = МассивЧастейРеквизитПутьКДанным[1];
		КонецЕсли;
	КонецЕсли;
	
	// Определение имени и запись значения реквизита в соответствующей константе из "НаборКонстант".
	// Используется для тех реквизитов формы, которые связаны с константами напрямую (в отношении один-к-одному).
	Если РеквизитПутьКДанным = "МаксимальныйРазмерФайлаДляПередачиВ1СДокументооборот"
			Или КонстантаИмя = "МаксимальныйРазмерФайлаДляПередачиВ1СДокументооборот" Тогда
		НаборКонстант.МаксимальныйРазмерФайлаДляПередачиВ1СДокументооборот =
			МаксимальныйРазмерФайлаДляПередачиВ1СДокументооборот * (1024*1024);
		КонстантаИмя = "МаксимальныйРазмерФайлаДляПередачиВ1СДокументооборот";
		
	ИначеЕсли РеквизитПутьКДанным = "СрокХраненияСообщенийВ1СДокументооборот"
			Или КонстантаИмя = "СрокХраненияСообщенийВ1СДокументооборот" Тогда
		НаборКонстант.СрокХраненияСообщенийВ1СДокументооборот = СрокХраненияСообщенийВ1СДокументооборот;
		КонстантаИмя = "СрокХраненияСообщенийВ1СДокументооборот";
		
	КонецЕсли;
	
	// Сохранение значения константы.
	Если КонстантаИмя <> "" Тогда
		КонстантаМенеджер = Константы[КонстантаИмя];
		КонстантаЗначение = НаборКонстант[КонстантаИмя];
		
		Если КонстантаМенеджер.Получить() <> КонстантаЗначение Тогда
			КонстантаМенеджер.Установить(КонстантаЗначение);
		КонецЕсли;
		
		Если ЕстьПодчиненныеКонстанты(КонстантаИмя, КонстантаЗначение) И ПеречитыватьФорму Тогда
			Прочитать();
		КонецЕсли;
		
	КонецЕсли;
	
	Если КонстантаИмя = "НаименованиеКорневойПапкиФайлов1СДокументооборот" Тогда
		СохранитьЗначениеРеквизита("НаборКонстант.ИдентификаторКорневойПапкиФайлов1СДокументооборот");
	КонецЕсли;
	
	Если РеквизитПутьКДанным = "СпособХраненияПрисоединенныхФайлов" Тогда
		СохранитьЗначениеРеквизита("НаборКонстант.ИспользоватьФайловоеХранилище1СДокументооборота",, Ложь);
		СохранитьЗначениеРеквизита("НаборКонстант.ИспользоватьПрисоединенныеФайлы1СДокументооборота");
		КонстантаИмя = "ИспользоватьПрисоединенныеФайлы1СДокументооборота";
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПолучитьСрокХраненияСообщенийВ1СДокументооборот()
	
	СрокХраненияСообщенийВ1СДокументооборот = НаборКонстант.СрокХраненияСообщенийВ1СДокументооборот;
	
	Если СрокХраненияСообщенийВ1СДокументооборот = 0 Тогда
		СрокХраненияСообщенийВ1СДокументооборот = 30; // Дней
		СохранитьЗначениеРеквизита("СрокХраненияСообщенийВ1СДокументооборот");
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПолучитьМаксимальныйРазмерПередаваемогоФайла()
	
	МаксимальныйРазмерФайлаДляПередачиВ1СДокументооборот =
		НаборКонстант.МаксимальныйРазмерФайлаДляПередачиВ1СДокументооборот / (1024*1024);
	
	Если МаксимальныйРазмерФайлаДляПередачиВ1СДокументооборот = 0 Тогда
		МаксимальныйРазмерФайлаДляПередачиВ1СДокументооборот = 10; // мб
		СохранитьЗначениеРеквизита("МаксимальныйРазмерФайлаДляПередачиВ1СДокументооборот");
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция СоставНабораКонстант(Набор)
	
	Результат = Новый Структура;
	
	Для Каждого МетаКонстанта Из Метаданные.Константы Цикл
		Если ЕстьРеквизитОбъекта(Набор, МетаКонстанта.Имя) Тогда
			Результат.Вставить(МетаКонстанта.Имя);
		КонецЕсли;
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

&НаСервере
Функция ЕстьРеквизитОбъекта(Объект, ИмяРеквизита)
	
	КлючУникальностиОбъекта = Новый УникальныйИдентификатор;
	СтруктураРеквизита = Новый Структура(ИмяРеквизита, КлючУникальностиОбъекта);
	
	ЗаполнитьЗначенияСвойств(СтруктураРеквизита, Объект);
	
	Возврат СтруктураРеквизита[ИмяРеквизита] <> КлючУникальностиОбъекта;
	
КонецФункции

&НаСервере
Функция ЕстьПодчиненныеКонстанты(ИмяРодительскойКонстанты, ЗначениеРодительскойКонстанты)
	
	ТаблицаКонстант = ИнтеграцияС1СДокументооборотБазоваяФункциональность.ЗависимостиКонстант();
	
	ПодчиненныеКонстанты = ТаблицаКонстант.НайтиСтроки(
		Новый Структура(
			"ИмяРодительскойКонстанты, ЗначениеРодительскойКонстанты",
			ИмяРодительскойКонстанты, ЗначениеРодительскойКонстанты));
	
	Возврат ПодчиненныеКонстанты.Количество() > 0;
	
КонецФункции

&НаСервере
Функция РодительскиеКонстанты(СтруктураПодчиненныхКонстант)
	
	Результат = Новый Структура;
	ТаблицаКонстант = ИнтеграцияС1СДокументооборотБазоваяФункциональность.ЗависимостиКонстант();
	
	Для Каждого ИскомаяКонстанта Из СтруктураПодчиненныхКонстант Цикл
		
		РодительскиеКонстанты = ТаблицаКонстант.НайтиСтроки(
			Новый Структура("ИмяПодчиненнойКонстанты", ИскомаяКонстанта.Ключ));
		
		Для Каждого СтрокаРодителя Из РодительскиеКонстанты Цикл
			
			Если Результат.Свойство(СтрокаРодителя.ИмяРодительскойКонстанты)
					Или СтруктураПодчиненныхКонстант.Свойство(СтрокаРодителя.ИмяРодительскойКонстанты) Тогда
				Продолжить;
			КонецЕсли;
			
			Результат.Вставить(СтрокаРодителя.ИмяРодительскойКонстанты);
			
			РодителиРодителя = РодительскиеКонстанты(Новый Структура(СтрокаРодителя.ИмяРодительскойКонстанты));
			
			Для Каждого РодительРодителя Из РодителиРодителя Цикл
				Результат.Вставить(РодительРодителя.Ключ);
			КонецЦикла;
			
		КонецЦикла;
		
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти

#Область Сервер

&НаСервереБезКонтекста
Процедура ОбновитьИспользованиеРегламентногоЗадания(Использование)
	
	Задание = РегламентныеЗаданияСервер.Задание(
		Метаданные.РегламентныеЗадания.ИнтеграцияС1СДокументооборотВыполнитьОбменДанными);
	Задание.Использование = Использование;
	Задание.Записать();
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти
