﻿
////////////////////////////////////////////////////////////////////////////////
// ОПИСАНИЕ ПЕРЕМЕННЫХ
#Область ОписаниеПеременных

// СтандартныеПодсистемы.РаботаСКонтрагентами
&НаКлиенте
Перем ПроверкаКонтрагентовПараметрыОбработчикаОжидания Экспорт;

&НаКлиенте
Перем ФормаДлительнойОперации Экспорт;
// Конец СтандартныеПодсистемы.РаботаСКонтрагентами

&НаКлиенте
Перем КэшированныеЗначения;

#КонецОбласти // ОписаниеПеременных

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьУсловноеОформлениеФормы();
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(Объект, ЭтотОбъект);
	
	// СтандартныеПодсистемы.ВерсионированиеОбъектов
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	// СтандартныеПодсистемы.РаботаСКонтрагентами
	ПроверкаКонтрагентов.ПриСозданииНаСервереДокумент(ЭтотОбъект, Параметры);
	// Конец СтандартныеПодсистемы.РаботаСКонтрагентами
	
	// ИнтеграцияС1СДокументооборотом
	ИнтеграцияС1СДокументооборотБазоваяФункциональность.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец ИнтеграцияС1СДокументооборотом
	
	НастройкаФормБольничнаяАптека.ФормаДокумента_ПриСозданииНаСервере(ЭтотОбъект);
	НастройкаФормБольничнаяАптека.НастроитьОтображениеИтогов(Элементы.ГруппаИтоговаяСумма);
	
	Если Объект.Ссылка.Пустая() Тогда
		ПриСозданииНовогоПриЧтенииНаСервере();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	// СтандартныеПодсистемы.УправлениеДоступом
	УправлениеДоступом.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
	// СтандартныеПодсистемы.ДатыЗапретаИзменения
	ДатыЗапретаИзменения.ОбъектПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.ДатыЗапретаИзменения
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	НастройкаФормБольничнаяАптека.ФормаДокумента_ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	
	ПриСозданииНовогоПриЧтенииНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	// СтандартныеПодсистемы.РаботаСКонтрагентами
	ПроверкаКонтрагентовКлиент.ПриОткрытииДокумент(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.РаботаСКонтрагентами
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	// СтандартныеПодсистемы.РаботаСКонтрагентами
	ПроверкаКонтрагентовКлиент.ОбработкаОповещения(ЭтотОбъект, ИмяСобытия, Параметр, Источник);
	// Конец СтандартныеПодсистемы.РаботаСКонтрагентами
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	ОценкаПроизводительностиБольничнаяАптекаКлиент.НачатьЗамерПроведенияДокумента(Объект.Ссылка, Отказ, ПараметрыЗаписи);
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	// СтандартныеПодсистемы.РаботаСКонтрагентами
	ПроверкаКонтрагентов.ПередЗаписьюНаСервереДокумент(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.РаботаСКонтрагентами
	
КонецПроцедуры

&НаСервере
Процедура ПриЗаписиНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	// СтандартныеПодсистемы.РаботаСКонтрагентами
	ПроверкаКонтрагентов.ПриЗаписиНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.РаботаСКонтрагентами
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.ПослеЗаписи(ЭтотОбъект, Объект, ПараметрыЗаписи);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	// СтандартныеПодсистемы.УправлениеДоступом
	УправлениеДоступом.ПослеЗаписиНаСервере(ЭтотОбъект, ТекущийОбъект, ПараметрыЗаписи);
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
	// СтандартныеПодсистемы.РаботаСКонтрагентами
	ПроверкаКонтрагентов.ПослеЗаписиНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.РаботаСКонтрагентами
	
	ЗаполнитьСлужебныеРеквизиты();
	
	НастройкаФормБольничнаяАптека.ФормаДокумента_ПослеЗаписиНаСервере(ЭтотОбъект, ТекущийОбъект, ПараметрыЗаписи);
	НастройкаФормБольничнаяАптека.ИзменитьЗаголовокПоХозяйственнойОперации(ЭтотОбъект);
	
КонецПроцедуры

#КонецОбласти // ОбработчикиСобытийФормы

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ
#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПроверитьКонтрагентов(Команда)
	
	// СтандартныеПодсистемы.РаботаСКонтрагентами
	ПроверкаКонтрагентовКлиент.ПроверитьКонтрагентовВДокументеПоКнопке(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.РаботаСКонтрагентами
	
КонецПроцедуры

&НаКлиенте
Процедура РазбитьСтроку(Команда)
	
	ТекущаяСтрока = Элементы.Расходы.ТекущиеДанные;
	Оповещение = Новый ОписаниеОповещения("ПослеРазбиенияСтроки", ЭтотОбъект, ТекущаяСтрока);
	ОбработкаТабличнойЧастиКлиент.РазбитьСтрокуТЧ(Объект.Расходы, ТекущаяСтрока, Оповещение, "Количество");
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьСтатьюРасходов(Команда)
	
	ВариантыРаспределенияРасходов = Новый Массив;
	ВариантыРаспределенияРасходов.Добавить(ПредопределенноеЗначение("Перечисление.ВариантыРаспределенияРасходов.НаСебестоимостьТоваров"));
	
	ПараметрыФормыВыбора = Новый Структура;
	ПараметрыФормыВыбора.Вставить("ВариантыРаспределенияРасходов", ВариантыРаспределенияРасходов);
	ПараметрыФормыВыбора.Вставить("ХозяйственнаяОперация", ПредопределенноеЗначение("Перечисление.ХозяйственныеОперации.СписаниеТоваровПоТребованию"));
	ПараметрыФормыВыбора.Вставить("Организация", Объект.Организация);
	
	ЗаполнитьРеквизитВВыделенныхСтроках(
		"СтатьяРасходов",
		НСтр("ru='Статья расходов'"),
		"ПланВидовХарактеристик.СтатьиРасходов.Форма.ФормаВыбораСтатьиИАналитики",
		ПараметрыФормыВыбора);
	
КонецПроцедуры

&НаКлиенте
Процедура РаспределитьНаПоступления(Команда)
	
	АдресСтрокКРаспределению = ПоместитьВыделенныеСтрокиВХранилище();
	Если АдресСтрокКРаспределению = Неопределено Тогда
		ОбщегоНазначенияКлиент.СообщитьПользователю(НСтр("ru='Отсутствуют строки к распределению на документы поступления.'"));
	Иначе
		Обработчик = Новый ОписаниеОповещения("РаспределитьНаПоступленияЗавершение", ЭтотОбъект);
		Режим = РежимОткрытияОкнаФормы.БлокироватьОкноВладельца;
		
		ПараметрыФормы = Новый Структура;
		ПараметрыФормы.Вставить("Ссылка"      , Объект.Ссылка);
		ПараметрыФормы.Вставить("Валюта"      , Объект.Валюта);
		ПараметрыФормы.Вставить("Организация" , Объект.Организация);
		ПараметрыФормы.Вставить("ТаблицаСтрок", АдресСтрокКРаспределению);
		ОткрытьФорму("Документ.ПоступлениеДопРасходов.Форма.РаспределениеРасходовНаПоступления", ПараметрыФормы,,,,, Обработчик, Режим);
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура РаспределитьНаПоступленияЗавершение(РезультатЗакрытия, Параметры) Экспорт
	
	Если РезультатЗакрытия <> Неопределено Тогда
		ПеренестиРезультатВТабличнуюЧасть(РезультатЗакрытия);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	ОбщегоНазначенияБольничнаяАптекаКлиентПереопределяемый.ВыполнитьПереопределяемуюКоманду(ЭтотОбъект, Команда);
	
КонецПроцедуры

#КонецОбласти // ОбработчикиКомандФормы

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ФОРМЫ
#Область ОбработчикиСобытийЭлементовФормы

////////////////////////////////////////////////////////////////////////////////
// Шапка
#Область Шапка

&НаКлиенте
Процедура ДатаПриИзменении(Элемент)
	
	// СтандартныеПодсистемы.РаботаСКонтрагентами
	ПроверкаКонтрагентовКлиент.ЗапуститьПроверкуКонтрагентовВДокументе(ЭтотОбъект, Объект.Дата);
	// Конец СтандартныеПодсистемы.РаботаСКонтрагентами
	
КонецПроцедуры

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	
	ОбработатьИзменениеОрганизации();
	ОбработатьИзменениеВалюты();
	
КонецПроцедуры

&НаКлиенте
Процедура КонтрагентПриИзменении(Элемент)
	
	// СтандартныеПодсистемы.РаботаСКонтрагентами
	ПроверкаКонтрагентовКлиент.ЗапуститьПроверкуКонтрагентовВДокументе(ЭтотОбъект, Элемент);
	// Конец СтандартныеПодсистемы.РаботаСКонтрагентами
	
	ОбработатьИзменениеКонтрагента();
	ОбработатьИзменениеВалюты();
	
КонецПроцедуры

&НаКлиенте
Процедура ДоговорКонтрагентаПриИзменении(Элемент)
	
	ОбработатьИзменениеДоговораКонтрагента();
	ОбработатьИзменениеВалюты();
	
КонецПроцедуры

&НаКлиенте
Процедура ПодразделениеОрганизацииПриИзменении(Элемент)
	
	Если ЗначениеЗаполнено(Объект.ПодразделениеОрганизации) Тогда
		ОбработатьИзменениеПодразделения();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВалютаПриИзменении(Элемент)
	
	ОбработатьИзменениеВалюты();
	
КонецПроцедуры

&НаКлиенте
Процедура ЦенаВключаетНДСПриИзменении(Элемент)
	
	ОбработатьИзменениеЦенаВключаетНДС(КэшированныеЗначения);
	
КонецПроцедуры

&НаКлиенте
Процедура ТекстСчетФактураОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	Оповестить = Новый ОписаниеОповещения("ОбработатьИзменениеСчетаФактуры", ЭтотОбъект);
	ЗакупкиКлиент.ОбработатьНавигационнуюСсылкуСчетаФактуры(
		ЭтотОбъект, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка, Оповестить);
	
КонецПроцедуры

&НаКлиенте
Процедура ХозяйственнаяОперацияПриИзменении(Элемент)
	
	ОбработатьИзменениеХозяйственнойОперации();
	
КонецПроцедуры

&НаКлиенте
Процедура НалогообложениеНДСПриИзменении(Элемент)
	
	ОбработатьИзменениеНалогообложенияНДС();
	
КонецПроцедуры

#КонецОбласти // Шапка

////////////////////////////////////////////////////////////////////////////////
// Список Расходы
#Область Расходы

&НаКлиенте
Процедура РасходыКоличествоПриИзменении(Элемент)
	
	ТекущаяСтрока = Элементы.Расходы.ТекущиеДанные;
	ПриИзмененииКоличестваВСтрокеСпискаРасходы(ТекущаяСтрока);
	
КонецПроцедуры

&НаКлиенте
Процедура РасходыЦенаПриИзменении(Элемент)
	
	ТекущаяСтрока = Элементы.Расходы.ТекущиеДанные;
	
	Действия = ОбработкаТабличнойЧастиКлиентСервер;
	
	СтруктураДействий = Новый Структура;
	СтруктураДействий.Вставить(Действия.Действие_ПересчитатьСумму(), "Количество");
	ПараметрыПересчетаСуммы = Действия.ПолучитьПараметрыПересчетаСуммыНДС(Объект);
	СтруктураДействий.Вставить(Действия.Действие_ПересчитатьСуммуНДС(), ПараметрыПересчетаСуммы);
	СтруктураДействий.Вставить(Действия.Действие_ПересчитатьСуммуСНДС(), ПараметрыПересчетаСуммы);
	
	ОбработкаТабличнойЧастиКлиент.ОбработатьСтрокуТабличнойЧасти(ТекущаяСтрока, СтруктураДействий, КэшированныеЗначения);
	
КонецПроцедуры

&НаКлиенте
Процедура РасходыСуммаПриИзменении(Элемент)
	
	ТекущаяСтрока = Элементы.Расходы.ТекущиеДанные;
	
	Действия = ОбработкаТабличнойЧастиКлиентСервер;
	
	СтруктураДействий = Новый Структура;
	СтруктураДействий.Вставить(Действия.Действие_ПересчитатьЦену(), "Количество");
	ПараметрыПересчетаСуммы = Действия.ПолучитьПараметрыПересчетаСуммыНДС(Объект);
	СтруктураДействий.Вставить(Действия.Действие_ПересчитатьСуммуНДС(), ПараметрыПересчетаСуммы);
	СтруктураДействий.Вставить(Действия.Действие_ПересчитатьСуммуСНДС(), ПараметрыПересчетаСуммы);
	
	ОбработкаТабличнойЧастиКлиент.ОбработатьСтрокуТабличнойЧасти(ТекущаяСтрока, СтруктураДействий, КэшированныеЗначения);
	
КонецПроцедуры

&НаКлиенте
Процедура РасходыСтавкаНДСПриИзменении(Элемент)
	
	ТекущаяСтрока = Элементы.Расходы.ТекущиеДанные;
	
	Действия = ОбработкаТабличнойЧастиКлиентСервер;
	
	СтруктураДействий = Новый Структура;
	ПараметрыПересчетаСуммы = Действия.ПолучитьПараметрыПересчетаСуммыНДС(Объект);
	СтруктураДействий.Вставить(Действия.Действие_ПересчитатьСуммуНДС(), ПараметрыПересчетаСуммы);
	СтруктураДействий.Вставить(Действия.Действие_ПересчитатьСуммуСНДС(), ПараметрыПересчетаСуммы);
	
	ОбработкаТабличнойЧастиКлиент.ОбработатьСтрокуТабличнойЧасти(ТекущаяСтрока, СтруктураДействий, КэшированныеЗначения);
	
КонецПроцедуры

&НаКлиенте
Процедура РасходыСуммаНДСПриИзменении(Элемент)
	
	ТекущаяСтрока = Элементы.Расходы.ТекущиеДанные;
	
	Действия = ОбработкаТабличнойЧастиКлиентСервер;
	
	СтруктураДействий = Новый Структура;
	ПараметрыПересчетаСуммы = Действия.ПолучитьПараметрыПересчетаСуммыНДС(Объект);
	СтруктураДействий.Вставить(Действия.Действие_ПересчитатьСуммуСНДС(), ПараметрыПересчетаСуммы);
	
	ОбработкаТабличнойЧастиКлиент.ОбработатьСтрокуТабличнойЧасти(ТекущаяСтрока, СтруктураДействий, КэшированныеЗначения);
	
КонецПроцедуры

&НаКлиенте
Процедура РасходыСтатьяРасходовПриИзменении(Элемент)
	
	ОбработатьИзменениеСтатьиРасходов(КэшированныеЗначения);
	
КонецПроцедуры

#КонецОбласти // Расходы

#КонецОбласти // ОбработчикиСобытийЭлементовФормы

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ
#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ПриСозданииНовогоПриЧтенииНаСервере()
	
	ВалютаДокумента = Объект.Валюта;
	
	ЗаполнитьСлужебныеРеквизиты();
	
	УстановитьВидимостьЭлементовПоОперацииСервер();
	НастроитьОтображениеИтогов();
	
КонецПроцедуры

&НаСервере
Процедура УстановитьУсловноеОформлениеФормы()
	
	ОбработкаТабличнойЧастиСервер.УстановитьОформлениеЦенаВключаетНДС(ЭтотОбъект, "РасходыСуммаСНДС");
	ОбработкаТабличнойЧастиСервер.УстановитьОформлениеСуммаНДС(ЭтотОбъект, "РасходыСуммаНДС", "Объект.Расходы.СтавкаНДС");
	ОбработкаТабличнойЧастиСервер.УстановитьОформлениеСуммНДС(ЭтотОбъект, "РасходыСтавкаНДС", "РасходыСуммаНДС", "РасходыСуммаСНДС");
	
	ПланыВидовХарактеристик.СтатьиРасходов.УстановитьУсловноеОформлениеАналитик(ЭтотОбъект, Новый Структура("Расходы"));
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьРеквизитВВыделенныхСтроках(ИмяРеквизита, ПредставлениеРеквизита, ИмяФормыВыборка, ПараметрыФормы = Неопределено)
	
	ВыделенныеСтроки = Элементы.Расходы.ВыделенныеСтроки;
	ЗаполнениеВозможно = ОбработкаТабличнойЧастиКлиент.ПроверитьВозможностьЗаполненияРеквизитаВТабличнойЧасти(
		Объект.Расходы, ВыделенныеСтроки, НСтр("ru='Расходы'"), ПредставлениеРеквизита);
	Если ЗаполнениеВозможно Тогда
		
		ПараметрыЗаполнения = Новый Структура("ИмяРеквизита, ПредставлениеРеквизита", ИмяРеквизита, ПредставлениеРеквизита);
		Оповещение = Новый ОписаниеОповещения("ЗаполнитьРеквизитВВыделенныхСтрокахЗавершение", ЭтотОбъект, ПараметрыЗаполнения);
		ОткрытьФорму(ИмяФормыВыборка, ПараметрыФормы, ЭтотОбъект,,,, Оповещение, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьРеквизитВВыделенныхСтрокахЗавершение(Значение, ПараметрыЗаполнения) Экспорт
	
	Если Значение <> Неопределено Тогда
		ВыделенныеСтроки = Элементы.Расходы.ВыделенныеСтроки;
		ЗаполненоСтрок = ОбработкаТабличнойЧастиКлиент.ЗаполнитьРеквизитВВыделенныхСтроках(
			Объект.Расходы, ВыделенныеСтроки, ПараметрыЗаполнения.ИмяРеквизита, Значение);
		ОбработкаТабличнойЧастиКлиент.ПоказатьОповещениеОЗаполненииРеквизитаВВыделенныхСтроках(
			Значение, ЗаполненоСтрок, ВыделенныеСтроки.Количество(), ПараметрыЗаполнения.ПредставлениеРеквизита);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьВидимостьЭлементовПоОперацииСервер()
	Перем ВсеЭлементы;
	Перем ВидимыеЭлементы;
	
	Документы.ПоступлениеДопРасходов.ЗаполнитьИменаРеквизитовПоТипуОперации(
		Объект.ХозяйственнаяОперация,
		ВсеЭлементы,
		ВидимыеЭлементы);
	
	ОбщегоНазначенияБольничнаяАптекаКлиентСервер.УстановитьВидимостьЭлементовФормыПоМассиву(Элементы, ВсеЭлементы, ВидимыеЭлементы);
	
	НастройкаФормБольничнаяАптека.ИзменитьЗаголовокПоХозяйственнойОперации(ЭтотОбъект);
	
	НастроитьПредставлениеСчетаФактуры();
	
КонецПроцедуры

&НаСервере
Процедура НастроитьОтображениеИтогов()
	
	Если Объект.НалогообложениеНДС = Перечисления.ТипыНалогообложенияНДС.ПродажаНеОблагаетсяНДС Тогда
		Элементы.СуммаВсегоНДС.ФорматРедактирования = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку("ЧН='%1'", НСтр("ru = 'Без НДС'"));
		Элементы.СуммаВсего.Заголовок = НСтр("ru = 'Всего'");
		Элементы.СуммаВсего.Ширина = 14;
	Иначе
		Элементы.СуммаВсегоНДС.ФорматРедактирования = "";
		Элементы.СуммаВсего.Заголовок = НСтр("ru = 'Всего с НДС'");
		Элементы.СуммаВсего.Ширина = 10;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура НастроитьПредставлениеСчетаФактуры()
	
	НеТребуетсяВводСчетаФактуры = Объект.ХозяйственнаяОперация <> Перечисления.ХозяйственныеОперации.ЗакупкаУПоставщика;
	
	ТекстСчетФактура = ЗакупкиСервер.ПредставлениеСчетаФактурыВДокументеЗакупки(Объект, НеТребуетсяВводСчетаФактуры, ТолькоПросмотр);
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСлужебныеРеквизиты()
	
	ПланыВидовХарактеристик.СтатьиРасходов.ЗаполнитьСлужебныеРеквизиты(Объект.Расходы);
	
КонецПроцедуры

&НаСервере
Функция ПоместитьВыделенныеСтрокиВХранилище()
	
	ОписаниеТаблицыРасходов = Объект.Ссылка.Метаданные().ТабличныеЧасти.Расходы;
	ТаблицаСтрок = Новый ТаблицаЗначений;
	ТаблицаСтрок.Колонки.Добавить("НомерСтроки"      , ОписаниеТаблицыРасходов.СтандартныеРеквизиты.НомерСтроки.Тип);
	ТаблицаСтрок.Колонки.Добавить("Содержание"       , ОписаниеТаблицыРасходов.Реквизиты.Содержание.Тип);
	ТаблицаСтрок.Колонки.Добавить("Сумма"            , ОписаниеТаблицыРасходов.Реквизиты.Сумма.Тип);
	ТаблицаСтрок.Колонки.Добавить("Количество"       , ОписаниеТаблицыРасходов.Реквизиты.Количество.Тип);
	ТаблицаСтрок.Колонки.Добавить("СтавкаНДС"        , ОписаниеТаблицыРасходов.Реквизиты.СтавкаНДС.Тип);
	ТаблицаСтрок.Колонки.Добавить("СтатьяРасходов"   , ОписаниеТаблицыРасходов.Реквизиты.СтатьяРасходов.Тип);
	ТаблицаСтрок.Колонки.Добавить("АналитикаРасходов", ОписаниеТаблицыРасходов.Реквизиты.АналитикаРасходов.Тип);
	
	Для Каждого ВыделеннаяСтрока Из Элементы.Расходы.ВыделенныеСтроки Цикл
		
		СтрокаТаблицы = Объект.Расходы.НайтиПоИдентификатору(ВыделеннаяСтрока);
		Если СтрокаТаблицы = Неопределено
		 Или ТипЗнч(СтрокаТаблицы.АналитикаРасходов) <> Тип("ДокументСсылка.ПоступлениеТоваров") Тогда
			Продолжить;
		КонецЕсли;
		
		ЗаполнитьЗначенияСвойств(ТаблицаСтрок.Добавить(), СтрокаТаблицы);
		
	КонецЦикла;
	
	Если ТаблицаСтрок.Количество() = 0 Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Возврат ПоместитьВоВременноеХранилище(ТаблицаСтрок, УникальныйИдентификатор);
	
КонецФункции

&НаСервере
Процедура ПеренестиРезультатВТабличнуюЧасть(Знач Параметры)
	
	КэшированныеЗначения = Неопределено;
	Действия = ОбработкаТабличнойЧастиКлиентСервер;
	
	СтруктураДействий = Новый Структура;
	СтруктураДействий.Вставить(Действия.Действие_ПересчитатьЦену(), "Количество");
	ПараметрыПересчетаСуммы = Действия.ПолучитьПараметрыПересчетаСуммыНДС(Объект);
	СтруктураДействий.Вставить(Действия.Действие_ПересчитатьСуммуНДС(), ПараметрыПересчетаСуммы);
	СтруктураДействий.Вставить(Действия.Действие_ПересчитатьСуммуСНДС(), ПараметрыПересчетаСуммы);
	
	РезультатРаспределения = ПолучитьИзВременногоХранилища(Параметры.АдресВоВременномХранилище);
	Для Каждого ТекущаяСтрока Из РезультатРаспределения Цикл
		
		МассивСтрок = Объект.Расходы.НайтиСтроки(Новый Структура("НомерСтроки", ТекущаяСтрока.НомерСтроки));
		Если МассивСтрок.Количество() = 1 Тогда
			СтрокаКЗаполнению = МассивСтрок[0];
		Иначе
			СтрокаКЗаполнению = Объект.Расходы.Добавить();
		КонецЕсли;
		
		ЗаполнитьЗначенияСвойств(СтрокаКЗаполнению, ТекущаяСтрока,, "Содержание");
		
		Если ПустаяСтрока(СтрокаКЗаполнению.Содержание) Тогда
			СтрокаКЗаполнению.Содержание = ТекущаяСтрока.Содержание;
		КонецЕсли;
		
		ОбработкаТабличнойЧастиСервер.ОбработатьСтрокуТабличнойЧасти(СтрокаКЗаполнению, СтруктураДействий, КэшированныеЗначения);
		
	КонецЦикла;
	
	КУдалению = ПолучитьИзВременногоХранилища(Параметры.СтрокиКУдалению);
	Для Каждого СтрокаКУдалению Из КУдалению Цикл
		Объект.Расходы.Удалить(СтрокаКУдалению.НомерСтроки - 1);
	КонецЦикла;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Обработка изменения реквизитов
#Область ОбработкаИзмененияРеквизитов

&НаСервере
Процедура ОбработатьИзменениеОрганизации()
	
	Объект.ПодразделениеОрганизации = ЗначениеНастроекБольничнаяАптекаПовтИсп.ПолучитьПодразделениеПоУмолчанию(Объект.ПодразделениеОрганизации, Объект.Организация);
	Объект.ДоговорКонтрагента = ЗначениеНастроекБольничнаяАптекаПовтИсп.ПолучитьДоговорПоУмолчанию(
		Объект.ДоговорКонтрагента,
		Объект.Контрагент,
		Объект.Организация);
	ОбработатьИзменениеДоговораКонтрагента();
	
КонецПроцедуры

&НаСервере
Процедура ОбработатьИзменениеПодразделения()
	
	Если Не ЗначениеЗаполнено(Объект.Организация) Тогда
		Объект.Организация = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Объект.ПодразделениеОрганизации, "Владелец");
		Объект.ДоговорКонтрагента = ЗначениеНастроекБольничнаяАптекаПовтИсп.ПолучитьДоговорПоУмолчанию(
			Объект.ДоговорКонтрагента,
			Объект.Контрагент,
			Объект.Организация);
		ОбработатьИзменениеДоговораКонтрагента();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОбработатьИзменениеКонтрагента()
	
	Объект.ДоговорКонтрагента = ЗначениеНастроекБольничнаяАптекаПовтИсп.ПолучитьДоговорПоУмолчанию(
		Объект.ДоговорКонтрагента,
		Объект.Контрагент,
		Объект.Организация);
	ОбработатьИзменениеДоговораКонтрагента();
	
КонецПроцедуры

&НаСервере
Процедура ОбработатьИзменениеДоговораКонтрагента()
	
	Если ЗначениеЗаполнено(Объект.ДоговорКонтрагента) Тогда
		
		РеквизитыДоговора = ЗакупкиСервер.ПолучитьОсновныеРеквизитыДоговора(Объект.ДоговорКонтрагента);
		
		Если Не ЗначениеЗаполнено(Объект.Организация) Тогда
			Объект.Организация = РеквизитыДоговора.Организация;
		КонецЕсли;
		
		Если Не ЗначениеЗаполнено(Объект.Контрагент) Тогда
			Объект.Контрагент = РеквизитыДоговора.Контрагент;
		КонецЕсли;
		
		Объект.ВалютаВзаиморасчетов = РеквизитыДоговора.ВалютаВзаиморасчетов;
		Объект.Валюта = Объект.ВалютаВзаиморасчетов;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработатьИзменениеВалюты()
	
	Оповещение = Новый ОписаниеОповещения("ПересчитатьСуммыВВалютуДокумента", ЭтотОбъект);
	ВзаимодействиеСПользователемКлиент.ПроверитьНеобходимостьПересчетаВВалюту(Объект.Расходы, Объект.Валюта, ВалютаДокумента, Оповещение);
	
КонецПроцедуры

&НаКлиенте
Процедура ПересчитатьСуммыВВалютуДокумента(Ответ, ДополнительныеПараметры) Экспорт
	
	Если ВалютаДокумента <> Объект.Валюта Тогда
		
		ПересчитатьСуммы = (Ответ = КодВозвратаДиалога.Да);
		Если ПересчитатьСуммы Тогда
			ПересчитатьСуммыВВалютуСервер(Объект.Валюта);
			ВзаимодействиеСПользователемКлиент.ОповеститьОбОкончанииПересчетаСуммВВалюту(ВалютаДокумента, Объект.Валюта);
		КонецЕсли;
		
		ВалютаДокумента = Объект.Валюта;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПересчитатьСуммыВВалютуСервер(Знач НоваяВалюта)
	
	КурсовСтаройВалюты = РаботаСКурсамиВалют.ПолучитьКурсВалюты(ВалютаДокумента, Объект.Дата);
	КурсНовойВалюты = РаботаСКурсамиВалют.ПолучитьКурсВалюты(НоваяВалюта, Объект.Дата);
	
	ОбработкаТабличнойЧастиСервер.ПересчитатьСуммыТабличнойЧастиВВалюту(
		Объект.Расходы,
		Объект.ЦенаВключаетНДС,
		КурсовСтаройВалюты,
		КурсНовойВалюты,
		"Количество");
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработатьИзменениеСчетаФактуры(Результат, ДополнительныеПараметры) Экспорт
	
	НастроитьПредставлениеСчетаФактуры();
	
КонецПроцедуры

&НаСервере
Процедура ОбработатьИзменениеХозяйственнойОперации()
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	Если Объект.ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ЗакупкаЧерезПодотчетноеЛицо Тогда
		Объект.НалогообложениеНДС = Перечисления.ТипыНалогообложенияНДС.ПродажаНеОблагаетсяНДС;
		ОбработатьИзменениеНалогообложенияНДС();
	КонецЕсли;
	
	УстановитьВидимостьЭлементовПоОперацииСервер();
	
КонецПроцедуры

&НаСервере
Процедура ОбработатьИзменениеНалогообложенияНДС()
	
	Действия = ОбработкаТабличнойЧастиКлиентСервер;
	
	СтруктураДействий = Новый Структура;
	СтруктураДействий.Вставить(Действия.Действие_ЗаполнитьСтавкуНДС(), Объект.НалогообложениеНДС);
	ПараметрыПересчетаСуммы = Действия.ПолучитьПараметрыПересчетаСуммыНДС(Объект);
	СтруктураДействий.Вставить(Действия.Действие_ПересчитатьСуммуНДС(), ПараметрыПересчетаСуммы);
	СтруктураДействий.Вставить(Действия.Действие_ПересчитатьСуммуСНДС(), ПараметрыПересчетаСуммы);
	
	ОбработкаТабличнойЧастиСервер.ОбработатьТабличнуюЧасть(Объект.Расходы, СтруктураДействий, Неопределено);
	
	НастроитьОтображениеИтогов();
	
КонецПроцедуры

&НаСервере
Процедура ОбработатьИзменениеЦенаВключаетНДС(КэшированныеЗначения)
	
	Действия = ОбработкаТабличнойЧастиКлиентСервер;
	
	СтруктураДействий = Новый Структура;
	ПараметрыПересчетаСуммы = Действия.ПолучитьПараметрыПересчетаСуммыНДС(Объект);
	СтруктураДействий.Вставить(Действия.Действие_ПересчитатьСуммуНДС(), ПараметрыПересчетаСуммы);
	СтруктураДействий.Вставить(Действия.Действие_ПересчитатьСуммуСНДС(), ПараметрыПересчетаСуммы);
	
	ОбработкаТабличнойЧастиСервер.ОбработатьТабличнуюЧасть(Объект.Расходы, СтруктураДействий, КэшированныеЗначения);
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеРазбиенияСтроки(НоваяСтрока, ТекущаяСтрока) Экспорт
	
	ПриИзмененииКоличестваВСтрокеСпискаРасходы(ТекущаяСтрока);
	ПриИзмененииКоличестваВСтрокеСпискаРасходы(НоваяСтрока);
	
	Элементы.Расходы.ТекущаяСтрока = НоваяСтрока.ПолучитьИдентификатор();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриИзмененииКоличестваВСтрокеСпискаРасходы(ТекущаяСтрока)
	
	Действия = ОбработкаТабличнойЧастиКлиентСервер;
	
	СтруктураДействий = Новый Структура;
	СтруктураДействий.Вставить(Действия.Действие_ПересчитатьСумму(), "Количество");
	ПараметрыПересчетаСуммы = Действия.ПолучитьПараметрыПересчетаСуммыНДС(Объект);
	СтруктураДействий.Вставить(Действия.Действие_ПересчитатьСуммуНДС(), ПараметрыПересчетаСуммы);
	СтруктураДействий.Вставить(Действия.Действие_ПересчитатьСуммуСНДС(), ПараметрыПересчетаСуммы);
	
	ОбработкаТабличнойЧастиКлиент.ОбработатьСтрокуТабличнойЧасти(ТекущаяСтрока, СтруктураДействий, КэшированныеЗначения);
	
КонецПроцедуры

&НаСервере
Процедура ОбработатьИзменениеСтатьиРасходов(КэшированныеЗначения)
	
	ТекущаяСтрока = Объект.Расходы.НайтиПоИдентификатору(Элементы.Расходы.ТекущаяСтрока);
	ПланыВидовХарактеристик.СтатьиРасходов.ОбработатьИзменениеСтатьиРасходов(Объект, ТекущаяСтрока);
	
	Действия = ОбработкаТабличнойЧастиКлиентСервер;
	
	СтруктураДействий = Новый Структура;
	СтруктураДействий.Вставить(Действия.Действие_ЗаполнитьСлужебныеРеквизитыСтатьиРасходов());
	
	ОбработкаТабличнойЧастиСервер.ОбработатьСтрокуТабличнойЧасти(ТекущаяСтрока, СтруктураДействий, КэшированныеЗначения);
	
КонецПроцедуры

#КонецОбласти // ОбработкаИзмененияРеквизитов

#КонецОбласти // СлужебныеПроцедурыИФункции

////////////////////////////////////////////////////////////////////////////////
// СТАНДАРТНЫЕ ПОДСИСТЕМЫ
#Область СтандартныеПодсистемы

// СтандартныеПодсистемы.ПодключаемыеКоманды

&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Объект);
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат) Экспорт
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, Объект, Результат);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
КонецПроцедуры

// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

// СтандартныеПодсистемы.РаботаСКонтрагентами

&НаКлиенте
Процедура Подключаемый_ПоказатьПредложениеИспользоватьПроверкуКонтрагентов()
	ПроверкаКонтрагентовКлиент.ПредложитьВключитьПроверкуКонтрагентов(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбработатьРезультатПроверкиКонтрагентов()
	ПроверкаКонтрагентовКлиент.ОбработатьРезультатПроверкиКонтрагентовВДокументе(ЭтотОбъект);
КонецПроцедуры

&НаСервере
Процедура ОтобразитьРезультатПроверкиКонтрагента() Экспорт
	ПроверкаКонтрагентов.ОтобразитьРезультатПроверкиКонтрагентаВДокументе(ЭтотОбъект);
КонецПроцедуры

&НаСервере
Процедура ПроверитьКонтрагентовФоновоеЗадание(ПараметрыФоновогоЗадания) Экспорт
	ПроверкаКонтрагентов.ПроверитьКонтрагентовВДокументеФоновоеЗадание(ЭтотОбъект, ПараметрыФоновогоЗадания);
КонецПроцедуры

// Конец СтандартныеПодсистемы.РаботаСКонтрагентами

// ИнтеграцияС1СДокументооборотом

&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуИнтеграции(Команда)
	
	// ИнтеграцияС1СДокументооборотом
	ИнтеграцияС1СДокументооборотБазоваяФункциональностьКлиент.ВыполнитьПодключаемуюКомандуИнтеграции(Команда, ЭтотОбъект, Объект);
	// Конец ИнтеграцияС1СДокументооборотом
	
КонецПроцедуры

// Конец ИнтеграцияС1СДокументооборотом

#КонецОбласти // СтандартныеПодсистемы
