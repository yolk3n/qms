﻿
////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьУсловноеОформлениеФормы();
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Если Параметры.Документ = Неопределено Тогда
		ВызватьИсключение НСтр("ru='Предусмотрено открытие обработки только из форм объектов.'");
	КонецЕсли;
	
	Организация = Параметры.Организация;
	Склад = Параметры.Склад;
	ИсточникФинансирования = Параметры.ИсточникФинансирования;
	
	УстановитьПараметрыФункциональныхОпцийФормы(Новый Структура("Склад", Склад));
	
	ЗагрузитьНастройкиОтбораПоУмолчанию();
	
	ПодборТоваровСервер.УстановитьЗаголовокФормыПодбора(ЭтотОбъект);
	
	Если ЗначениеЗаполнено(Параметры.ЗаголовокКнопкиПеренести) Тогда
		Команды.ПеренестиВДокумент.Заголовок = Параметры.ЗаголовокКнопкиПеренести;
		Команды.ПеренестиВДокумент.Подсказка = Параметры.ЗаголовокКнопкиПеренести;
	КонецЕсли;
	
	МестоХраненияОстатка = Параметры.МестоХраненияОстатка;
	Если Не ЗначениеЗаполнено(МестоХраненияОстатка) Тогда
		МестоХраненияОстатка = ?(СкладыСервер.ЭтоСкладОтделения(Склад), "Отделение", "Склад");
	КонецЕсли;
	
	ПараметрыУчетаНоменклатуры = ЗапасыСервер.ПараметрыУчетаНоменклатуры();
	ПараметрыУчетаНоменклатуры.ИспользоватьСерии = Истина;
	ПараметрыУчетаНоменклатуры.ИспользоватьПартии = Истина;
	ПараметрыУчетаНоменклатуры.ПолноеИмяОбъекта = Метаданные.ОбщиеМодули.ПодборТоваровСервер.Имя;
	ПараметрыУчетаНоменклатуры.Вставить("МестоХраненияОстатка", МестоХраненияОстатка);
	
	ПодборВПоступление = Параметры.ПодборВПоступление;
	
	РежимПодбораБезРазрезовУчета = Параметры.РежимПодбораБезРазрезовУчета;
	Элементы.ТоварыСерияНоменклатуры.Видимость = Не РежимПодбораБезРазрезовУчета;
	Элементы.ТоварыПартия.Видимость = Не РежимПодбораБезРазрезовУчета;
	
	РежимПодбораБезКоличественныхПараметров = Параметры.РежимПодбораБезКоличественныхПараметров;
	Элементы.ТоварыКоличественныеПараметры.Видимость = Не РежимПодбораБезКоличественныхПараметров;
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	Если Объект.Товары.Количество() > 0 Тогда
		Оповещение = Новый ОписаниеОповещения("ПередЗакрытиемЗавершение", ЭтотОбъект);
		ТекстВопроса = НСтр("ru = 'Подобранные товары не перенесены в документ. Перенести?'");
		ОбщегоНазначенияКлиент.ПоказатьПодтверждениеЗакрытияФормы(Оповещение, Отказ, ЗавершениеРаботы, ТекстВопроса, ТекстПредупреждения);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытиемЗавершение(Ответ, ДополнительныеПараметры) Экспорт
	
	ПеренестиВДокументДанныеПодбора();
	
КонецПроцедуры

#КонецОбласти // ОбработчикиСобытийФормы

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ
#Область ОбработкаКомандФормы

&НаКлиенте
Процедура ПеренестиВДокумент(Команда)
	
	ПеренестиВДокументДанныеПодбора();
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьТаблицуТоваров(Команда)
	
	Если Объект.Товары.Количество() = 0 Тогда
		ЗаполнитьТаблицуТоваровНаСервере();
	Иначе
		Оповещение = Новый ОписаниеОповещения("ЗаполнитьТаблицуТоваровЗавершение", ЭтотОбъект);
		ТекстВопроса = НСтр("ru = 'При перезаполнении все введенные вручную данные будут потеряны, продолжить?'");
		ПоказатьВопрос(Оповещение, ТекстВопроса, РежимДиалогаВопрос.ДаНет,,КодВозвратаДиалога.Да);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьТаблицуТоваровЗавершение(Ответ, ДополнительныеПараметры) Экспорт
	
	Если Ответ = КодВозвратаДиалога.Да Тогда
		ЗаполнитьТаблицуТоваровНаСервере();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти // ОбработкаКомандФормы

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ
#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформлениеФормы()
	
	ОбработкаТабличнойЧастиСервер.УстановитьОформлениеСерийНоменклатуры(ЭтотОбъект);
	ОбработкаТабличнойЧастиСервер.УстановитьОформлениеПартий(ЭтотОбъект);
	
КонецПроцедуры

&НаСервере
Функция СтруктураНастроек()
	
	СтруктураНастроек = Новый Структура;
	СтруктураНастроек.Вставить("ОбязательныеПоля"   , Новый Массив); //
	СтруктураНастроек.Вставить("ПараметрыДанных"    , Новый Структура);
	СтруктураНастроек.Вставить("КомпоновщикНастроек", Неопределено); // Отбор
	СтруктураНастроек.Вставить("ИмяМакетаСхемыКомпоновкиДанных" , Неопределено);
	
	Возврат СтруктураНастроек;
	
КонецФункции

&НаКлиенте
Процедура ПеренестиВДокументДанныеПодбора()
	
	АдресТоваровВХранилище = ПоместитьОтобранныеТоварыВХранилище();
	ДанныеПодбора = Новый Структура("АдресТоваровВХранилище", АдресТоваровВХранилище);
	
	ЗакрыватьПриВыборе = Ложь;
	ОповеститьОВыборе(ДанныеПодбора);
	
	Модифицированность = Ложь;
	Закрыть(ДанныеПодбора);
	
КонецПроцедуры

&НаСервере
Функция ПоместитьОтобранныеТоварыВХранилище()
	
	Возврат ПоместитьВоВременноеХранилище(Объект.Товары.Выгрузить(), УникальныйИдентификатор);
	
КонецФункции

&НаСервере
Процедура ЗаполнитьТаблицуТоваровНаСервере(ПроверятьЗаполнение = Истина)
	
	// Поля необходимые для вывода в таблицу товаров на форме.
	СтруктураНастроек = СтруктураНастроек();
	
	СтруктураНастроек.ОбязательныеПоля.Добавить("Номенклатура");
	Если Не РежимПодбораБезРазрезовУчета Тогда
		СтруктураНастроек.ОбязательныеПоля.Добавить("СерияНоменклатуры");
		СтруктураНастроек.ОбязательныеПоля.Добавить("Партия");
	КонецЕсли;
	Если Не РежимПодбораБезКоличественныхПараметров Тогда
		СтруктураНастроек.ОбязательныеПоля.Добавить("ИсточникФинансирования");
		СтруктураНастроек.ОбязательныеПоля.Добавить("МестоХранения");
	КонецЕсли;
	
	СтруктураНастроек.КомпоновщикНастроек = КомпоновщикНастроек;
	СтруктураНастроек.ИмяМакетаСхемыКомпоновкиДанных = "Макет";
	
	Объект.Товары.Очистить();
	
	КэшированныеЗначения = Неопределено;
	Действия = ОбработкаТабличнойЧастиКлиентСервер;
	
	СтруктураДействий = Новый Структура;
	СтруктураДействий.Вставить(Действия.Действие_ЗаполнитьПараметрыУчета(), ПараметрыУчетаНоменклатуры);
	Если Не РежимПодбораБезКоличественныхПараметров Тогда
		СтруктураДействий.Вставить(Действия.Действие_ЗаполнитьЕдиницуИзмерения(), ?(ПодборВПоступление, НоменклатураКлиентСервер.ВидЕдиницы_ПотребительскаяУпаковка(), ""));
		СтруктураДействий.Вставить(Действия.Действие_ПересчитатьКоэффициент());
		СтруктураДействий.Вставить(Действия.Действие_ПересчитатьКоличествоУпаковок());
	КонецЕсли;
	
	СтруктураРезультата = Обработки.ПодборТоваровПоОтбору.ПодготовитьСтруктуруДанных(СтруктураНастроек);
	Для Каждого СтрокаТЧ Из СтруктураРезультата.ТаблицаТоваров Цикл
		НоваяСтрока = Объект.Товары.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, СтрокаТЧ);
		Если Не РежимПодбораБезКоличественныхПараметров Тогда
			НоваяСтрока.Количество = СтрокаТЧ.ОстатокНаСкладе;
		КонецЕсли;
		ОбработкаТабличнойЧастиСервер.ОбработатьСтрокуТабличнойЧасти(НоваяСтрока, СтруктураДействий, КэшированныеЗначения);
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ЗагрузитьНастройкиОтбораПоУмолчанию()
	
	СхемаКомпоновкиДанных = Обработки.ПодборТоваровПоОтбору.ПолучитьМакет("Макет");
	КомпоновщикНастроек.Инициализировать(
		Новый ИсточникДоступныхНастроекКомпоновкиДанных(ПоместитьВоВременноеХранилище(СхемаКомпоновкиДанных, УникальныйИдентификатор)));
	КомпоновщикНастроек.ЗагрузитьНастройки(СхемаКомпоновкиДанных.НастройкиПоУмолчанию);
	КомпоновщикНастроек.Восстановить(СпособВосстановленияНастроекКомпоновкиДанных.ПроверятьДоступность);
	
	Если ПолучитьФункциональнуюОпцию("ИспользоватьНесколькоОрганизаций") Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(КомпоновщикНастроек.Настройки.Отбор, "Организация", Организация,,, ЗначениеЗаполнено(Организация));
	Иначе
		ОбщегоНазначенияБольничнаяАптека.УдалитьЭлементОтбораИзВсехНастроекОтчета(КомпоновщикНастроек, "Организация");
	КонецЕсли;
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(КомпоновщикНастроек.Настройки.Отбор, "Склад", Склад,,, ЗначениеЗаполнено(Склад));
	Если ПолучитьФункциональнуюОпцию("ИспользоватьИсточникиФинансирования") Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(КомпоновщикНастроек.Настройки.Отбор, "ИсточникФинансирования", ИсточникФинансирования,,, ЗначениеЗаполнено(ИсточникФинансирования));
	Иначе
		ОбщегоНазначенияБольничнаяАптека.УдалитьЭлементОтбораИзВсехНастроекОтчета(КомпоновщикНастроек, "ИсточникФинансирования");
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти // СлужебныеПроцедурыИФункции

