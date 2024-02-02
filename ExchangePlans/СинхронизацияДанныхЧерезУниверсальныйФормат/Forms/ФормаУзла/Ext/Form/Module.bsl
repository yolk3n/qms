﻿
////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	ОбменДаннымиСервер.ФормаУзлаПриСозданииНаСервере(ЭтотОбъект, Отказ);
	
	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(Объект, ЭтотОбъект);
	
	СформироватьСписокДоступныхДокументов();
	ОбновитьСписокВерсийФорматаОбмена();
	
	УстановитьВидимостьНаСервере();
	ОбновитьНаименованиеКомандФормы();
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	ОбменДаннымиКлиент.ФормаНастройкиПередЗакрытием(Отказ, ЭтотОбъект, ЗавершениеРаботы);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	
	Если Не ЗавершениеРаботы Тогда
		Оповестить("Запись_УзелПланаОбмена");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)
	
	Если ИсточникВыбора.ИмяФормы = "ОбщаяФорма.ФормаВыбораДополнительныхУсловий" Тогда
		ОбновитьДанныеОбъекта(ВыбранноеЗначение);
		Модифицированность = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "ИзменениеПравилОбменаЧерезУниверсальныйФормат" Тогда
		ОбновитьСписокВерсийФорматаОбмена();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриЗаписиНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	ОбменДаннымиСервер.ФормаУзлаПриЗаписиНаСервере(ТекущийОбъект, Отказ);
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	ОбновитьИнтерфейс();
	
КонецПроцедуры

#КонецОбласти // ОбработчикиСобытийФормы

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ
#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОткрытьСписокВыбранныхОрганизаций(Команда)
	
	ПараметрыФормы = ПараметрыФормыВыбораЭлементовОтбораПоУмолчанию();
	ПараметрыФормы.ИмяЭлементаФормыДляЗаполнения          = "Организации";
	ПараметрыФормы.ИмяРеквизитаЭлементаФормыДляЗаполнения = "Организация";
	ПараметрыФормы.ИмяТаблицыВыбора                       = "Справочник.Организации";
	ПараметрыФормы.ЗаголовокФормыВыбора                   = НСтр("ru = 'Выберите организации для отбора:'");
	
	ОткрытьСписокВыбранныхЭлементов(ПараметрыФормы);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьСписокОтправляемыхВидовЦен(Команда)
	
	ПараметрыФормы = ПараметрыФормыВыбораЭлементовОтбораПоУмолчанию();
	ПараметрыФормы.ИмяЭлементаФормыДляЗаполнения          = "ВидыЦенНоменклатуры";
	ПараметрыФормы.ИмяРеквизитаЭлементаФормыДляЗаполнения = "ВидЦенНоменклатуры";
	ПараметрыФормы.ИмяТаблицыВыбора                       = "Справочник.ВидыЦен";
	ПараметрыФормы.ЗаголовокФормыВыбора                   = НСтр("ru = 'Выберите виды цен для отправки:'");
	
	ОткрытьСписокВыбранныхЭлементов(ПараметрыФормы);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьСписокВыбранныхДокументов(Команда)
	
	ПараметрыФормы = ПараметрыФормыВыбораЭлементовОтбораПоУмолчанию();
	ПараметрыФормы.ИмяЭлементаФормыДляЗаполнения          = "ВыгружаемыеДокументы";
	ПараметрыФормы.ИмяРеквизитаЭлементаФормыДляЗаполнения = "ИдентификаторДокумента";
	ПараметрыФормы.ИмяТаблицыВыбора                       = "Справочник.ИдентификаторыОбъектовМетаданных";
	ПараметрыФормы.ЗаголовокФормыВыбора                   = НСтр("ru = 'Выберите типы документов для отбора:'");
	
	ОтборСправочника = Новый Структура;
	ОтборСправочника.Вставить("РеквизитОтбора"   , "Ссылка");
	ОтборСправочника.Вставить("Условие"          , "В");
	ОтборСправочника.Вставить("ИмяПараметра"     , "ДоступныеДокументы");
	ОтборСправочника.Вставить("ЗначениеПараметра", ДоступныеДокументы);
	
	КоллекцияФильтров = Новый Массив;
	КоллекцияФильтров.Добавить(ОтборСправочника);
	
	ПараметрыФормы.КоллекцияФильтров = КоллекцияФильтров;
	
	ОткрытьСписокВыбранныхЭлементов(ПараметрыФормы);
	
КонецПроцедуры

#КонецОбласти // ОбработчикиКомандФормы

//////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ФОРМЫ
#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура ПереключательОтправлятьНСИАвтоматическиПриИзменении(Элемент)
	УстановитьВидимостьНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура ПереключательОтправлятьНСИПоНеобходимостиПриИзменении(Элемент)
	УстановитьВидимостьНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура ПереключательОтправлятьНСИНикогдаПриИзменении(Элемент)
	УстановитьВидимостьНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура ПереключательДокументыОтправлятьАвтоматическиПриИзменении(Элемент)
	УстановитьВидимостьНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура ПереключательДокументыОтправлятьВручнуюПриИзменении(Элемент)
	УстановитьВидимостьНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура ПереключательДокументыНеОтправлятьПриИзменении(Элемент)
	УстановитьВидимостьНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура ФлагИспользоватьОтборПоОрганизациямПриИзменении(Элемент)
	УстановитьВидимостьНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура ФлагОтправлятьВидыЦенНоменклатурыПриИзменении(Элемент)
	УстановитьВидимостьНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьОтборПоТипамДокументовПриИзменении(Элемент)
	УстановитьВидимостьНаСервере();
КонецПроцедуры

#КонецОбласти // ОбработчикиСобытийЭлементовФормы

//////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ
#Область СлужебныеПроцедурыИФункции

#Область ФормированиеСпискаЭлементовОтбора

&НаКлиенте
Процедура ОткрытьСписокВыбранныхЭлементов(ПараметрыФормы)
	
	ПараметрыФормы.Вставить("МассивВыбранныхЗначений", СформироватьМассивВыбранныхЗначений(ПараметрыФормы));
	
	ОткрытьФорму("ОбщаяФорма.ФормаВыбораДополнительныхУсловий", ПараметрыФормы, ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Функция ПараметрыФормыВыбораЭлементовОтбораПоУмолчанию()
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ИмяЭлементаФормыДляЗаполнения"         , "");
	ПараметрыФормы.Вставить("ИмяРеквизитаЭлементаФормыДляЗаполнения", "");
	ПараметрыФормы.Вставить("ИмяТаблицыВыбора"                      , "");
	ПараметрыФормы.Вставить("ЗаголовокФормыВыбора"                  , "");
	ПараметрыФормы.Вставить("КоллекцияФильтров"                     , Неопределено);
	ПараметрыФормы.Вставить("ПараметрыВнешнегоСоединения"           , Неопределено);
	ПараметрыФормы.Вставить("ТолькоПросмотр"                        , ТолькоПросмотр);
	
	Возврат ПараметрыФормы;
	
КонецФункции

&НаСервере
Функция СформироватьМассивВыбранныхЗначений(ПараметрыФормы)
	
	Возврат Объект[ПараметрыФормы.ИмяЭлементаФормыДляЗаполнения].Выгрузить(
			,
			ПараметрыФормы.ИмяРеквизитаЭлементаФормыДляЗаполнения
		).ВыгрузитьКолонку(ПараметрыФормы.ИмяРеквизитаЭлементаФормыДляЗаполнения);
	
КонецФункции

#КонецОбласти // ФормированиеСпискаЭлементовОтбора

&НаСервере
Процедура ОбновитьСписокВерсийФорматаОбмена()
	
	ВерсияФорматаОбмена = Элементы.ВерсияФорматаОбмена.СписокВыбора;
	ВерсияФорматаОбмена.Очистить();
	
	ИдентификаторПланаОбмена = ОбщегоНазначения.ИдентификаторОбъектаМетаданных(Объект.Ссылка.Метаданные());
	МенеджерыВерсийФормата = ОбменДаннымиБольничнаяАптека.МенеджерыВерсийФорматаОбмена(ИдентификаторПланаОбмена);
	
	Для Каждого КлючИЗначение Из МенеджерыВерсийФормата Цикл
		ВерсияФорматаОбмена.Добавить(КлючИЗначение.Ключ);
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура СформироватьСписокДоступныхДокументов()
	
	МетаданныеОбъекта = Объект.Ссылка.Метаданные();
	
	ДокументУстановкиЦен = Метаданные.Документы.УстановкаЦенНоменклатуры;
	Для Каждого ЭлементСостава Из МетаданныеОбъекта.Состав Цикл
		Если ОбщегоНазначения.ЭтоДокумент(ЭлементСостава.Метаданные) И ЭлементСостава.Метаданные <> ДокументУстановкиЦен Тогда
			ДоступныеДокументы.Добавить(ОбщегоНазначения.ИдентификаторОбъектаМетаданных(ЭлементСостава.Метаданные));
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьВидимостьНаСервере()
	
	// Отбор по организациям
	Если Объект.ПравилаОтправкиСправочников = "НеСинхронизировать"
	   И Объект.ПравилаОтправкиДокументов = "НеСинхронизировать" Тогда
		Элементы.ГруппаСтраницыОтборПоОрганизациям.ТекущаяСтраница = Элементы.ГруппаСтраницаОтборПоОрганизациямПустая;
	Иначе
		Элементы.ГруппаСтраницыОтборПоОрганизациям.ТекущаяСтраница = Элементы.ГруппаСтраницаОтборПоОрганизациям;
	КонецЕсли;
	
	// Выгрузка цен номенклатуры
	Если Объект.ПравилаОтправкиСправочников = "НеСинхронизировать"
	 Или Объект.ПравилаОтправкиСправочников = "СинхронизироватьПоНеобходимости" Тогда
		Элементы.ГруппаСтраницыОтправляемыеВидыЦен.ТекущаяСтраница = Элементы.ГруппаСтраницаОтправляемыеВидыЦенПустая;
	Иначе
		Элементы.ГруппаСтраницыОтправляемыеВидыЦен.ТекущаяСтраница = Элементы.ГруппаСтраницаОтправляемыеВидыЦен;
	КонецЕсли;
	
	// Отбор по типам документов
	Если Объект.ПравилаОтправкиДокументов = "НеСинхронизировать" Тогда
		Элементы.ГруппаСтраницыОтборПоТипамДокументов.ТекущаяСтраница = Элементы.ГруппаСтраницаОтборПоТипамДокументовПустая;
	Иначе
		Элементы.ГруппаСтраницыОтборПоТипамДокументов.ТекущаяСтраница = Элементы.ГруппаСтраницаОтборПоТипамДокументов;
	КонецЕсли;
	
	Элементы.ДатаНачалаВыгрузкиДокументов.Доступность = (Объект.ПравилаОтправкиДокументов = "АвтоматическаяСинхронизация");
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьНаименованиеКомандФормы()
	
	// Обновление заголовка команды выбора организаций для ограничения миграции.
	Если Объект.Организации.Количество() > 0 Тогда
		НовыйЗаголовокОрганизаций = СтрСоединить(Объект.Организации.Выгрузить().ВыгрузитьКолонку("Организация"), ", ");
	Иначе
		НовыйЗаголовокОрганизаций = НСтр("ru = 'Выбрать организации'");
	КонецЕсли;
	
	Элементы.ОткрытьСписокВыбранныхОрганизаций.Заголовок = НовыйЗаголовокОрганизаций;
	
	// Обновление заголовка команды выбора видов цен для выгрузки цен номенклатуры.
	Если Объект.ВидыЦенНоменклатуры.Количество() > 0 Тогда
		НовыйЗаголовокВидовЦен = СтрСоединить(Объект.ВидыЦенНоменклатуры.Выгрузить().ВыгрузитьКолонку("ВидЦенНоменклатуры"), ", ");
	Иначе
		НовыйЗаголовокВидовЦен = НСтр("ru = 'Выбрать виды цен'");
	КонецЕсли;
	
	Элементы.ОткрытьСписокОтправляемыхВидовЦен.Заголовок = НовыйЗаголовокВидовЦен;
	
	// Обновление заголовка команды выбора типов документов для ограничения миграции.
	Если Объект.ВыгружаемыеДокументы.Количество() > 0 Тогда
		НовыйЗаголовокДокументы = СтрСоединить(Объект.ВыгружаемыеДокументы.Выгрузить().ВыгрузитьКолонку("ИдентификаторДокумента"), ", ");
	Иначе
		НовыйЗаголовокДокументы = НСтр("ru = 'Выбрать типы документов'");
	КонецЕсли;
	
	Элементы.ОткрытьСписокВыбранныхДокументов.Заголовок = НовыйЗаголовокДокументы;
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьДанныеОбъекта(СтруктураПараметров)
	
	Объект[СтруктураПараметров.ИмяТаблицыДляЗаполнения].Очистить();
	
	СписокВыбранныхЗначений = ПолучитьИзВременногоХранилища(СтруктураПараметров.АдресТаблицыВоВременномХранилище);
	
	Если СписокВыбранныхЗначений.Количество() > 0 Тогда
		СписокВыбранныхЗначений.Колонки.Представление.Имя = СтруктураПараметров.ИмяКолонкиДляЗаполнения;
		Объект[СтруктураПараметров.ИмяТаблицыДляЗаполнения].Загрузить(СписокВыбранныхЗначений);
	КонецЕсли;
	
	ОбновитьНаименованиеКомандФормы();
	
КонецПроцедуры

#КонецОбласти // СлужебныеПроцедурыИФункции
