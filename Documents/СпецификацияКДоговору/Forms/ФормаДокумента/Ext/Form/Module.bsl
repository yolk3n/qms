﻿
////////////////////////////////////////////////////////////////////////////////
// ОПИСАНИЕ ПЕРЕМЕННЫХ
#Область ОписаниеПеременных

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
	
	// СтандартныеПодсистемы.Свойства
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("ИмяЭлементаДляРазмещения", Элементы.ГруппаДополнительныеРеквизиты.Имя);
	УправлениеСвойствами.ПриСозданииНаСервере(ЭтотОбъект, ДополнительныеПараметры);
	// Конец СтандартныеПодсистемы.Свойства
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	// ПодключаемоеОборудование
	ПодключаемоеОборудованиеСервер.НастроитьФормуДляИспользованияПодключаемогоОборудования(ЭтотОбъект);
	// Конец ПодключаемоеОборудование
	
	// ИнтеграцияС1СДокументооборотом
	ИнтеграцияС1СДокументооборотБазоваяФункциональность.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец ИнтеграцияС1СДокументооборотом
	
	НастройкаФормБольничнаяАптека.ФормаДокумента_ПриСозданииНаСервере(ЭтотОбъект);
	НастройкаФормБольничнаяАптека.НастроитьОтображениеИтогов(Элементы.ГруппаСуммаВсего);
	
	// БуферОбменаТоварами
	УстановитьДоступностьКомандБуфераОбмена(ЭтотОбъект, Не ОбработкаТабличнойЧастиСервер.БуферОбменаПустой());
	// Конец БуферОбменаТоварами
	
	// ИнтеграцияСМобильнымПриложением
	ИнтеграцияСМобильнымПриложением.СоздатьКомандуЗагрузкиДанныхИзМобильногоПриложенияНаФорме(ЭтотОбъект, "Товары", Элементы.Товары.КоманднаяПанель.Имя);
	// Конец ИнтеграцияСМобильнымПриложением
	
	Если Объект.Ссылка.Пустая() Тогда
		ПриСозданииНовогоПриЧтенииНаСервере();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	// СтандартныеПодсистемы.УправлениеДоступом
	УправлениеДоступом.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.Свойства
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	НастройкаФормБольничнаяАптека.ФормаДокумента_ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	
	ПриСозданииНовогоПриЧтенииНаСервере();
	
КонецПроцедуры

&НаСервере
Процедура ПриЗагрузкеДанныхИзНастроекНаСервере(Настройки)
	
	Элементы.ФормаНеВыполнятьПроверкуСопоставленнойНоменклатурыПоставщика.Пометка = НеВыполнятьПроверкуСопоставленнойНоменклатурыПоставщика;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствамиКлиент.ПослеЗагрузкиДополнительныхРеквизитов(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.Свойства
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	// СтандартныеПодсистемы.Свойства
	Если УправлениеСвойствамиКлиент.ОбрабатыватьОповещения(ЭтотОбъект, ИмяСобытия, Параметр) Тогда
		ОбновитьЭлементыДополнительныхРеквизитов();
		УправлениеСвойствамиКлиент.ПослеЗагрузкиДополнительныхРеквизитов(ЭтотОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.Свойства
	
	// ПодключаемоеОборудование
	Если ПодключаемоеОборудованиеКлиент.ОбрабатыватьОповещение(ЭтотОбъект, Источник) Тогда
		Если ПодключаемоеОборудованиеКлиент.ОбработатьПолучениеДанныхОтСканераШтрихкода(ЭтотОбъект, ИмяСобытия, Параметр) Тогда
			ОбработатьШтрихкоды(ОбщегоНазначенияБольничнаяАптекаКлиентСервер.ПолучитьДанныеШтрихкода(Параметр, 1));
		КонецЕсли;
	КонецЕсли;
	// Конец ПодключаемоеОборудование
	
	Если ИмяСобытия = "ВведенШтрихкод" И Источник = УникальныйИдентификатор Тогда
		ОбработатьШтрихкоды(ОбщегоНазначенияБольничнаяАптекаКлиентСервер.ПолучитьДанныеШтрихкода(Параметр, 1));
	КонецЕсли;
	
	Если Источник = "РегистрацияШтрихкодов"
	   И ИмяСобытия = "ЗарегистрированыШтрихкоды"
	   И Параметр.КлючВладельца = УникальныйИдентификатор Тогда
		Если Параметр.ЗарегистрированныеШтрихкоды.Количество() > 0 Тогда
			ОбновитьСтрокиНенайденныхШтрихКодов(Параметр.ЗарегистрированныеШтрихкоды);
		КонецЕсли;
	КонецЕсли;
	
	// БуферОбменаТоварами
	Если ОбработкаТабличнойЧастиКлиент.ОбрабатыватьОповещениеОтБуфераОбмена(ЭтотОбъект, ИмяСобытия, Источник) Тогда
		ДоступностьБуфераОбмена = ОбработкаТабличнойЧастиКлиент.ОпределитьДоступностьВставкиИзБуфераОбменаПоСобытию(ИмяСобытия);
		УстановитьДоступностьКомандБуфераОбмена(ЭтотОбъект, ДоступностьБуфераОбмена);
	КонецЕсли;
	// Конец БуферОбменаТоварами
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)
	
	Если ПодборТоваровКлиент.ОбработатьПодборТоваровВДокументПоступления(ЭтотОбъект, ИсточникВыбора) Тогда
		ОбработатьПодбор(ВыбранноеЗначение.АдресТоваровВХранилище, КэшированныеЗначения);
	Иначе
		// БуферОбменаТоварами
		Если ОбработкаТабличнойЧастиКлиент.НужноОбработатьВставкуИзБуфераОбмена(ЭтотОбъект, ИсточникВыбора) Тогда
			ВставитьТоварыИзБуфераОбмена(ВыбранноеЗначение);
		КонецЕсли;
		// Конец БуферОбменаТоварами
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ОбработкаПроверкиЗаполнения(ЭтотОбъект, Отказ, ПроверяемыеРеквизиты);
	// Конец СтандартныеПодсистемы.Свойства
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	ОценкаПроизводительностиБольничнаяАптекаКлиент.НачатьЗамерПроведенияДокумента(Объект.Ссылка, Отказ, ПараметрыЗаписи);
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ПередЗаписьюНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.Свойства
	
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
	
	НастройкаФормБольничнаяАптека.ФормаДокумента_ПослеЗаписиНаСервере(ЭтотОбъект, ТекущийОбъект, ПараметрыЗаписи);
	
КонецПроцедуры

#КонецОбласти // ОбработчикиСобытийФормы

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ
#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура НеВыполнятьПроверкуСопоставленнойНоменклатурыПоставщика(Команда)
	
	НеВыполнятьПроверкуСопоставленнойНоменклатурыПоставщика = Не НеВыполнятьПроверкуСопоставленнойНоменклатурыПоставщика;
	Элементы.ФормаНеВыполнятьПроверкуСопоставленнойНоменклатурыПоставщика.Пометка = НеВыполнятьПроверкуСопоставленнойНоменклатурыПоставщика;
	
КонецПроцедуры

&НаКлиенте
Процедура РазбитьСтроку(Команда)
	
	ТекущаяСтрока = Элементы.Товары.ТекущиеДанные;
	Оповещение = Новый ОписаниеОповещения("ПослеРазбиенияСтроки", ЭтотОбъект, ТекущаяСтрока);
	ОбработкаТабличнойЧастиКлиент.РазбитьСтрокуТЧ(Объект.Товары, ТекущаяСтрока, Оповещение);
	
КонецПроцедуры

&НаКлиенте
Процедура ПоискПоШтрихкодуВыполнить()
	
	ОбработкаТабличнойЧастиКлиент.ПоказатьВводШтрихкода(УникальныйИдентификатор);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьДанныеИзТСД(Команда)
	
	Оповещение = Новый ОписаниеОповещения("ОбработатьЗагрузкуДанныхИзТСД", ЭтотОбъект);
	ОборудованиеТерминалыСбораДанныхКлиент.НачатьЗагрузкуДанныеИзТСД(Оповещение, УникальныйИдентификатор);
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаПодбор(Команда)
	
	ПараметрыПодбора = Новый Структура;
	ПараметрыПодбора.Вставить("Документ", Объект.Ссылка);
	ПараметрыПодбора.Вставить("Организация", Объект.Организация);
	ПараметрыПодбора.Вставить("Поставщик", Объект.Контрагент);
	ПараметрыПодбора.Вставить("МестоХраненияОстатка", "Склад");
	ПараметрыПодбора.Вставить("ПодборВПоступление", Истина);
	ПараметрыПодбора.Вставить("РежимПодбораБезРазрезовУчета", Истина);
	
	ТипыНоменклатуры = ПодборТоваровКлиентСервер.ПолучитьОтборПоТипуНоменклатурыИзПараметровВыбора(Элементы.ТоварыНоменклатура.ПараметрыВыбора);
	ПараметрыПодбора.Вставить("ОтборПоТипуНоменклатуры", ТипыНоменклатуры);
	
	ПодборТоваровКлиент.ОткрытьПодборТоваровВДокументПоступления(ЭтотОбъект, ПараметрыПодбора);
	
КонецПроцедуры

&НаКлиенте
Процедура ПерезаполнитьНенайденныеШтрихкоды(Команда)
	
	ОбновитьСтрокиНенайденныхШтрихКодов();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработатьНенайденныеШтрихкоды(Команда)
	
	ОбработкаТабличнойЧастиКлиент.ОбработатьНенайденныеШтрихкоды(Объект.Товары, ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаПерезаполнитьСуммыПоПроцентам(Команда)
	
	ПерезаполнитьСуммыПоПроцентам();
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	// ИнтеграцияСМобильнымПриложением
	Оповестить = Новый ОписаниеОповещения("ОбработатьЗагрузкуДанныхИзТСД", ЭтотОбъект);
	ИнтеграцияСМобильнымПриложениемКлиент.ВыполнитьКомандуЗагрузкиДанныхИзМобильногоПриложения(ЭтотОбъект, Команда, Оповестить);
	// Конец ИнтеграцияСМобильнымПриложением
	
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
Процедура ОрганизацияПриИзменении(Элемент)
	
	ОбработатьИзменениеОрганизации();
	ОбработкаВыбораВалюты();
	
КонецПроцедуры

&НаКлиенте
Процедура КонтрагентПриИзменении(Элемент)
	
	ОбработатьИзменениеКонтрагента();
	ОбработкаВыбораВалюты();
	
КонецПроцедуры

&НаКлиенте
Процедура ДоговорКонтрагентаПриИзменении(Элемент)
	
	ОбработатьИзменениеДоговораКонтрагента();
	ОбработкаВыбораВалюты();
	
КонецПроцедуры

&НаКлиенте
Процедура ВалютаПриИзменении(Элемент)
	
	ОбработкаВыбораВалюты();
	
КонецПроцедуры

&НаКлиенте
Процедура ЦенаВключаетНДСПриИзменении(Элемент)
	
	ОбработатьИзменениеЦенаВключаетНДСНаСервере(КэшированныеЗначения);
	
КонецПроцедуры

&НаКлиенте
Процедура НалогообложениеНДСПриИзменении(Элемент)
	
	ОбработатьИзменениеНалогооблаженияНДС();
	
КонецПроцедуры

#КонецОбласти // Шапка

////////////////////////////////////////////////////////////////////////////////
// Список "Товары"
#Область Товары

&НаКлиенте
Процедура ТоварыПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	
	ТекущиеДанные = Элементы.Товары.ТекущиеДанные;
	Если НоваяСтрока Тогда
		ТекущиеДанные.КодСтроки = 0;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыНоменклатураПоставщикаПриИзменении(Элемент)
	
	ТекущаяСтрока = Элементы.Товары.ТекущиеДанные;
	
	Действия = ОбработкаТабличнойЧастиКлиентСервер;
	
	СтруктураДействий = Новый Структура;
	СтруктураДействий.Вставить(Действия.Действие_ЗаполнитьНоменклатуруПоНоменклатуреПоставщика());
	СтруктураДействий.Вставить(
		Действия.Действие_ПроверитьСопоставленнуюНоменклатуруПоставщика(),
		Действия.ПолучитьПараметрыПроверкиСопоставленнойНоменклатурыПоставщика(
			Объект,
			НеВыполнятьПроверкуСопоставленнойНоменклатурыПоставщика));
	СтруктураДействий.Вставить(Действия.Действие_ПроверитьУпаковкуПоВладельцу(), ТекущаяСтрока.ЕдиницаИзмерения);
	СтруктураДействий.Вставить(Действия.Действие_ЗаполнитьЕдиницуИзмерения(), НоменклатураКлиентСервер.ВидЕдиницы_ПотребительскаяУпаковка());
	СтруктураДействий.Вставить(Действия.Действие_ПересчитатьКоэффициент());
	СтруктураДействий.Вставить(Действия.Действие_ПересчитатьКоличествоЕдиниц());
	СтруктураДействий.Вставить(Действия.Действие_ЗаполнитьСтавкуНДС(), Объект.НалогообложениеНДС);
	СтруктураДействий.Вставить(Действия.Действие_ПересчитатьСумму());
	ПараметрыПересчетаСуммы = Действия.ПолучитьПараметрыПересчетаСуммыНДС(Объект);
	СтруктураДействий.Вставить(Действия.Действие_ПересчитатьСуммуНДС(), ПараметрыПересчетаСуммы);
	СтруктураДействий.Вставить(Действия.Действие_ПересчитатьСуммуСНДС(), ПараметрыПересчетаСуммы);
	
	ОбработкаТабличнойЧастиКлиент.ОбработатьСтрокуТабличнойЧасти(ТекущаяСтрока, СтруктураДействий, КэшированныеЗначения);
	
	Если ЗначениеЗаполнено(ТекущаяСтрока.Номенклатура) Тогда
		ТекущаяСтрока.Штрихкод = "";
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыНоменклатураПриИзменении(Элемент)
	
	ТекущаяСтрока = Элементы.Товары.ТекущиеДанные;
	
	ТекущаяСтрока.Штрихкод = "";
	
	Действия = ОбработкаТабличнойЧастиКлиентСервер;
	
	СтруктураДействий = Новый Структура;
	СтруктураДействий.Вставить(Действия.Действие_ЗаполнитьНоменклатуруПоставщикаПоНоменклатуре(), Объект.Контрагент);
	СтруктураДействий.Вставить(
		Действия.Действие_ПроверитьСопоставленнуюНоменклатуруПоставщика(),
		Действия.ПолучитьПараметрыПроверкиСопоставленнойНоменклатурыПоставщика(
			Объект,
			НеВыполнятьПроверкуСопоставленнойНоменклатурыПоставщика));
	СтруктураДействий.Вставить(Действия.Действие_ПроверитьУпаковкуПоВладельцу(), ТекущаяСтрока.ЕдиницаИзмерения);
	СтруктураДействий.Вставить(Действия.Действие_ЗаполнитьЕдиницуИзмерения(), НоменклатураКлиентСервер.ВидЕдиницы_ПотребительскаяУпаковка());
	СтруктураДействий.Вставить(Действия.Действие_ПересчитатьКоэффициент());
	СтруктураДействий.Вставить(Действия.Действие_ПересчитатьКоличествоЕдиниц());
	СтруктураДействий.Вставить(Действия.Действие_ЗаполнитьСтавкуНДС(), Объект.НалогообложениеНДС);
	СтруктураДействий.Вставить(Действия.Действие_ПересчитатьСумму());
	ПараметрыПересчетаСуммы = Действия.ПолучитьПараметрыПересчетаСуммыНДС(Объект);
	СтруктураДействий.Вставить(Действия.Действие_ПересчитатьСуммуНДС(), ПараметрыПересчетаСуммы);
	СтруктураДействий.Вставить(Действия.Действие_ПересчитатьСуммуСНДС(), ПараметрыПересчетаСуммы);
	
	ОбработкаТабличнойЧастиКлиент.ОбработатьСтрокуТабличнойЧасти(ТекущаяСтрока, СтруктураДействий, КэшированныеЗначения);
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыЕдиницаИзмеренияПриИзменении(Элемент)
	
	ТекущаяСтрока = Элементы.Товары.ТекущиеДанные;
	
	Действия = ОбработкаТабличнойЧастиКлиентСервер;
	
	СтруктураДействий = Новый Структура;
	СтруктураДействий.Вставить(Действия.Действие_ПересчитатьКоэффициент());
	СтруктураДействий.Вставить(Действия.Действие_ПересчитатьКоличествоЕдиниц());
	Если ТекущаяСтрока.Количество > 0 Тогда
		СтруктураДействий.Вставить(Действия.Действие_ПересчитатьЦенуЗаУпаковку(), Действия.ПолучитьПараметрыПересчетаЦеныЗаУпаковку(ТекущаяСтрока.Количество));
		СтруктураДействий.Вставить(Действия.Действие_ПересчитатьСумму());
		ПараметрыПересчетаСуммы = Действия.ПолучитьПараметрыПересчетаСуммыНДС(Объект);
		СтруктураДействий.Вставить(Действия.Действие_ПересчитатьСуммуНДС(), ПараметрыПересчетаСуммы);
		СтруктураДействий.Вставить(Действия.Действие_ПересчитатьСуммуСНДС(), ПараметрыПересчетаСуммы);
	КонецЕсли;
	
	ОбработкаТабличнойЧастиКлиент.ОбработатьСтрокуТабличнойЧасти(ТекущаяСтрока, СтруктураДействий, КэшированныеЗначения);
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыКоличествоПриИзменении(Элемент)
	
	ТекущаяСтрока = Элементы.Товары.ТекущиеДанные;
	ПриИзмененииКоличестваВСтрокеСпискаТовары(ТекущаяСтрока);
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыЦенаПриИзменении(Элемент)
	
	ТекущаяСтрока = Элементы.Товары.ТекущиеДанные;
	
	Действия = ОбработкаТабличнойЧастиКлиентСервер;
	
	СтруктураДействий = Новый Структура;
	СтруктураДействий.Вставить(Действия.Действие_ПересчитатьСумму());
	ПараметрыПересчетаСуммы = Действия.ПолучитьПараметрыПересчетаСуммыНДС(Объект);
	СтруктураДействий.Вставить(Действия.Действие_ПересчитатьСуммуНДС(), ПараметрыПересчетаСуммы);
	СтруктураДействий.Вставить(Действия.Действие_ПересчитатьСуммуСНДС(), ПараметрыПересчетаСуммы);
	
	ОбработкаТабличнойЧастиКлиент.ОбработатьСтрокуТабличнойЧасти(ТекущаяСтрока, СтруктураДействий, КэшированныеЗначения);
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыСтавкаНДСПриИзменении(Элемент)
	
	ТекущаяСтрока = Элементы.Товары.ТекущиеДанные;
	
	Действия = ОбработкаТабличнойЧастиКлиентСервер;
	
	СтруктураДействий = Новый Структура;
	СтруктураДействий.Вставить(Действия.Действие_ПересчитатьСумму());
	ПараметрыПересчетаСуммы = Действия.ПолучитьПараметрыПересчетаСуммыНДС(Объект);
	СтруктураДействий.Вставить(Действия.Действие_ПересчитатьСуммуНДС(), ПараметрыПересчетаСуммы);
	СтруктураДействий.Вставить(Действия.Действие_ПересчитатьСуммуСНДС(), ПараметрыПересчетаСуммы);
	
	ОбработкаТабличнойЧастиКлиент.ОбработатьСтрокуТабличнойЧасти(ТекущаяСтрока, СтруктураДействий, КэшированныеЗначения);
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыСуммаНДСПриИзменении(Элемент)
	
	ТекущаяСтрока = Элементы.Товары.ТекущиеДанные;
	
	Действия = ОбработкаТабличнойЧастиКлиентСервер;
	
	СтруктураДействий = Новый Структура;
	ПараметрыПересчетаСуммы = Действия.ПолучитьПараметрыПересчетаСуммыНДС(Объект);
	СтруктураДействий.Вставить(Действия.Действие_ПересчитатьСуммуСНДС(), ПараметрыПересчетаСуммы);
	
	ОбработкаТабличнойЧастиКлиент.ОбработатьСтрокуТабличнойЧасти(ТекущаяСтрока, СтруктураДействий, КэшированныеЗначения);
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыСуммаПриИзменении(Элемент)
	
	ТекущаяСтрока = Элементы.Товары.ТекущиеДанные;
	
	Действия = ОбработкаТабличнойЧастиКлиентСервер;
	
	СтруктураДействий = Новый Структура;
	СтруктураДействий.Вставить(Действия.Действие_ПересчитатьЦену());
	ПараметрыПересчетаСуммы = Действия.ПолучитьПараметрыПересчетаСуммыНДС(Объект);
	СтруктураДействий.Вставить(Действия.Действие_ПересчитатьСуммуНДС(), ПараметрыПересчетаСуммы);
	СтруктураДействий.Вставить(Действия.Действие_ПересчитатьСуммуСНДС(), ПараметрыПересчетаСуммы);
	
	ОбработкаТабличнойЧастиКлиент.ОбработатьСтрокуТабличнойЧасти(ТекущаяСтрока, СтруктураДействий, КэшированныеЗначения);
	
КонецПроцедуры

#КонецОбласти // Товары

////////////////////////////////////////////////////////////////////////////////
// Список "Распределение по источникам финансирования"
#Область РаспределениеПоИсточникамФинансирования

&НаКлиенте
Процедура РаспределениеПоИсточникамФинансированияПроцентПоИсточникуПриИзменении(Элемент)
	
	ТекущаяСтрока = Элементы.РаспределениеПоИсточникамФинансирования.ТекущиеДанные;
	
	Если Объект.РаспределениеПоИсточникамФинансирования.Итог("ПроцентПоИсточнику") > 100 Тогда
		ТекущаяСтрока.ПроцентПоИсточнику =
			ТекущаяСтрока.ПроцентПоИсточнику
			- (Объект.РаспределениеПоИсточникамФинансирования.Итог("ПроцентПоИсточнику") - 100);
	КонецЕсли;
	
	СуммаВсего = Объект.Товары.Итог("СуммаСНДС");
	
	Если ТекущаяСтрока.ПроцентПоИсточнику > 0
	   И Объект.РаспределениеПоИсточникамФинансирования.Итог("ПроцентПоИсточнику") = 100 Тогда
		
		СуммаПоИсточнику = 0;
		Для Каждого ТекСтрока Из Объект.РаспределениеПоИсточникамФинансирования Цикл
			Если ТекСтрока.НомерСтроки <> ТекущаяСтрока.НомерСтроки Тогда
				СуммаПоИсточнику = СуммаПоИсточнику + ТекСтрока.СуммаПоИсточнику;
			КонецЕсли;
		КонецЦикла;
		
		ТекущаяСтрока.СуммаПоИсточнику = СуммаВсего - СуммаПоИсточнику;
	Иначе
		
		ТекущаяСтрока.СуммаПоИсточнику = СуммаВсего * ТекущаяСтрока.ПроцентПоИсточнику / 100;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура РаспределениеПоИсточникамФинансированияСуммаПоИсточникуПриИзменении(Элемент)
	
	ТекущаяСтрока = Элементы.РаспределениеПоИсточникамФинансирования.ТекущиеДанные;
	
	СуммаВсего = Объект.Товары.Итог("СуммаСНДС");
	
	Если СуммаВсего > 0 Тогда
		
		Если Объект.РаспределениеПоИсточникамФинансирования.Итог("СуммаПоИсточнику") > СуммаВсего Тогда
			ТекущаяСтрока.СуммаПоИсточнику =
				ТекущаяСтрока.СуммаПоИсточнику
				- (Объект.РаспределениеПоИсточникамФинансирования.Итог("СуммаПоИсточнику") - СуммаВсего);
		КонецЕсли;
		
		Если ТекущаяСтрока.СуммаПоИсточнику > 0
		   И Объект.РаспределениеПоИсточникамФинансирования.Итог("СуммаПоИсточнику") = СуммаВсего Тогда
			
			ПроцентПоИсточнику = 0;
			Для Каждого ТекСтрока Из Объект.РаспределениеПоИсточникамФинансирования Цикл
				Если ТекСтрока.НомерСтроки <> ТекущаяСтрока.НомерСтроки Тогда
					ПроцентПоИсточнику = ПроцентПоИсточнику + ТекСтрока.ПроцентПоИсточнику;
				КонецЕсли;
			КонецЦикла;
			
			ТекущаяСтрока.ПроцентПоИсточнику = 100 - ПроцентПоИсточнику;
			
		Иначе
			ТекущаяСтрока.ПроцентПоИсточнику = ТекущаяСтрока.СуммаПоИсточнику * 100 / СуммаВсего;
		КонецЕсли;
		
	Иначе
		
		ТекущаяСтрока.СуммаПоИсточнику = 0;
		ТекущаяСтрока.ПроцентПоИсточнику = 0;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти // РаспределениеПоИсточникамФинансирования

#КонецОбласти // ОбработчикиСобытийЭлементовФормы

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ
#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ПриСозданииНовогоПриЧтенииНаСервере()
	
	ВалютаДокумента = Объект.Валюта;
	НастроитьОтображениеИтогов();
	
КонецПроцедуры

&НаСервере
Процедура УстановитьУсловноеОформлениеФормы()
	
	ОбработкаТабличнойЧастиСервер.УстановитьОформлениеЦенаВключаетНДС(ЭтотОбъект);
	ОбработкаТабличнойЧастиСервер.УстановитьОформлениеСуммаНДС(ЭтотОбъект);
	ОбработкаТабличнойЧастиСервер.УстановитьОформлениеСуммНДС(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбораВалюты()
	
	ВалютаДокумента = Объект.Валюта;
	
КонецПроцедуры

&НаКлиенте
Процедура ПерезаполнитьСуммыПоПроцентам()
	
	СуммаВсего = Объект.Товары.Итог("СуммаСНДС");
	
	Для Каждого Строка Из Объект.РаспределениеПоИсточникамФинансирования Цикл
		
		Строка.СуммаПоИсточнику = СуммаВсего * Строка.ПроцентПоИсточнику / 100;
		
	КонецЦикла;
	
	Если Объект.РаспределениеПоИсточникамФинансирования.Количество() > 1
	   И Объект.РаспределениеПоИсточникамФинансирования.Итог("ПроцентПоИсточнику") = 100 Тогда
		
		ПоследняяСтрока = Объект.РаспределениеПоИсточникамФинансирования.Получить(
			Объект.РаспределениеПоИсточникамФинансирования.Количество() - 1);
		ПоследняяСтрока.СуммаПоИсточнику =
			ПоследняяСтрока.СуммаПоИсточнику
			+ (СуммаВсего - Объект.РаспределениеПоИсточникамФинансирования.Итог("СуммаПоИсточнику"));
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура НастроитьОтображениеИтогов()
	
	Если Объект.НалогообложениеНДС = Перечисления.ТипыНалогообложенияНДС.ПродажаНеОблагаетсяНДС Тогда
		Элементы.СуммаВсегоНДС.ФорматРедактирования = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку("ЧН='%1'", НСтр("ru = 'Без НДС'"));
		Элементы.СуммаСНДС.Заголовок = НСтр("ru = 'Всего'");
		Элементы.СуммаСНДС.Ширина = 14;
	Иначе
		Элементы.СуммаВсегоНДС.ФорматРедактирования = "";
		Элементы.СуммаСНДС.Заголовок = НСтр("ru = 'Всего с НДС'");
		Элементы.СуммаСНДС.Ширина = 10;
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Обработка штрихкодов
#Область ОбработкаШтрихкодов

&НаКлиенте
Процедура ОбработатьШтрихкоды(ДанныеШтрихкодов)
	
	Действия = ОбработкаТабличнойЧастиКлиентСервер;
	
	ДействияСДобавленнымиСтроками = Новый Структура;
	ДействияСДобавленнымиСтроками.Вставить(Действия.Действие_ЗаполнитьНоменклатуруПоставщикаПоНоменклатуре(), Объект.Контрагент);
	ДействияСДобавленнымиСтроками.Вставить(Действия.Действие_ЗаполнитьЕдиницуИзмерения(), НоменклатураКлиентСервер.ВидЕдиницы_ПотребительскаяУпаковка());
	ДействияСДобавленнымиСтроками.Вставить(Действия.Действие_ПересчитатьКоэффициент());
	ДействияСДобавленнымиСтроками.Вставить(Действия.Действие_ЗаполнитьСтавкуНДС(), Объект.НалогообложениеНДС);
	ДействияСДобавленнымиСтроками.Вставить(Действия.Действие_ПересчитатьКоличествоЕдиниц());
	ДействияСДобавленнымиСтроками.Вставить(Действия.Действие_ПересчитатьСумму());
	ПараметрыПересчетаСуммы = Действия.ПолучитьПараметрыПересчетаСуммыНДС(Объект);
	ДействияСДобавленнымиСтроками.Вставить(Действия.Действие_ПересчитатьСуммуНДС(), ПараметрыПересчетаСуммы);
	ДействияСДобавленнымиСтроками.Вставить(Действия.Действие_ПересчитатьСуммуСНДС(), ПараметрыПересчетаСуммы);
	
	ДействияСИзмененнымиСтроками = Новый Структура;
	ДействияСИзмененнымиСтроками.Вставить(Действия.Действие_ПересчитатьКоличествоЕдиниц());
	ДействияСИзмененнымиСтроками.Вставить(Действия.Действие_ПересчитатьСумму());
	ПараметрыПересчетаСуммы = Действия.ПолучитьПараметрыПересчетаСуммыНДС(Объект);
	ДействияСИзмененнымиСтроками.Вставить(Действия.Действие_ПересчитатьСуммуНДС(), ПараметрыПересчетаСуммы);
	ДействияСИзмененнымиСтроками.Вставить(Действия.Действие_ПересчитатьСуммуСНДС(), ПараметрыПересчетаСуммы);
	
	ИзменятьКоличество = Не ТолькоПросмотр И Не Объект.Согласован;
	ПараметрыДействия = ОбработкаТабличнойЧастиКлиент.ПолучитьПараметрыОбработкиШтрихкодов(ДанныеШтрихкодов, ДействияСДобавленнымиСтроками, ДействияСИзмененнымиСтроками);
	ПараметрыДействия.ИзменятьКоличество = ИзменятьКоличество;
	
	ОбработатьШтрихкодыНаСервере(ПараметрыДействия, КэшированныеЗначения);
	
	ОбработкаТабличнойЧастиКлиент.СообщитьОНеизвестныхШтрихкодах(ПараметрыДействия);
	
	Если ПараметрыДействия.ТекущаяСтрока <> Неопределено Тогда
		Элементы.Товары.ТекущаяСтрока = ПараметрыДействия.ТекущаяСтрока;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОбработатьШтрихкодыНаСервере(ПараметрыДействия, КэшированныеЗначения)
	
	ОбработкаТабличнойЧастиСервер.ОбработатьШтрихкоды(ЭтотОбъект, Объект, ПараметрыДействия, КэшированныеЗначения);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьСтрокиНенайденныхШтрихКодов(ЗарегистрированныеШтрихкоды = Неопределено)
	
	Если Не ОбработкаТабличнойЧастиКлиент.ЕстьНенайденныеШтрихкоды(Объект.Товары) Тогда
		Возврат;
	КонецЕсли;
	
	Действия = ОбработкаТабличнойЧастиКлиентСервер;
	
	ДействияСИзмененнымиСтроками = Новый Структура;
	ДействияСИзмененнымиСтроками.Вставить(Действия.Действие_ЗаполнитьНоменклатуруПоставщикаПоНоменклатуре(), Объект.Контрагент);
	ДействияСИзмененнымиСтроками.Вставить(Действия.Действие_ЗаполнитьЕдиницуИзмерения(), НоменклатураКлиентСервер.ВидЕдиницы_ПотребительскаяУпаковка());
	ДействияСИзмененнымиСтроками.Вставить(Действия.Действие_ПересчитатьКоэффициент());
	ДействияСИзмененнымиСтроками.Вставить(Действия.Действие_ЗаполнитьСтавкуНДС(), Объект.НалогообложениеНДС);
	ДействияСИзмененнымиСтроками.Вставить(Действия.Действие_ПересчитатьКоличествоЕдиниц());
	ПараметрыПересчетаСуммы = Действия.ПолучитьПараметрыПересчетаСуммыНДС(Объект);
	ДействияСИзмененнымиСтроками.Вставить(Действия.Действие_ПересчитатьСуммуНДС(), ПараметрыПересчетаСуммы);
	ДействияСИзмененнымиСтроками.Вставить(Действия.Действие_ПересчитатьСуммуСНДС(), ПараметрыПересчетаСуммы);
	
	ПараметрыДействия = ОбработкаТабличнойЧастиКлиент.ПолучитьПараметрыОбработкиНенайденныхШтрихкодов();
	ПараметрыДействия.ДействияСИзмененнымиСтроками = ДействияСИзмененнымиСтроками;
	Если ЗарегистрированныеШтрихкоды <> Неопределено Тогда
		ПараметрыДействия.ЗарегистрированныеШтрихкоды = ЗарегистрированныеШтрихкоды;
	КонецЕсли;
	
	ОбновитьДанныеНенайденныхШтрихКодовНаСервере(ПараметрыДействия, КэшированныеЗначения);
	
	Если ПараметрыДействия.Модифицированность Тогда
		Модифицированность = Истина;
	КонецЕсли;
	
	ОбработкаТабличнойЧастиКлиент.СообщитьОНеизвестныхШтрихкодах(ПараметрыДействия);
	ОбработкаТабличнойЧастиКлиент.СообщитьОРезультатеОбновленияДанныхПоШтрихкодам(ПараметрыДействия);
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьДанныеНенайденныхШтрихКодовНаСервере(ПараметрыДействия, КэшированныеЗначения)
	
	ОбработкаТабличнойЧастиСервер.ОбновитьДанныеНенайденныхШтрихКодов(Объект, ПараметрыДействия, КэшированныеЗначения);
	
КонецПроцедуры

#КонецОбласти // ОбработкаШтрихкодов

////////////////////////////////////////////////////////////////////////////////
// Обработка подбора
#Область ОбработкаПодбора

&НаСервере
Процедура ОбработатьПодбор(Знач АдресТоваровВХранилище, КэшированныеЗначения)
	
	Действия = ОбработкаТабличнойЧастиКлиентСервер;
	
	СтруктураДействий = Новый Структура;
	СтруктураДействий.Вставить(Действия.Действие_ЗаполнитьСтавкуНДС(), Объект.НалогообложениеНДС);
	СтруктураДействий.Вставить(Действия.Действие_ПересчитатьКоличествоЕдиниц());
	СтруктураДействий.Вставить(Действия.Действие_ПересчитатьСумму());
	ПараметрыПересчетаСуммы = Действия.ПолучитьПараметрыПересчетаСуммыНДС(Объект);
	СтруктураДействий.Вставить(Действия.Действие_ПересчитатьСуммуНДС(), ПараметрыПересчетаСуммы);
	СтруктураДействий.Вставить(Действия.Действие_ПересчитатьСуммуСНДС(), ПараметрыПересчетаСуммы);
	
	СписокТоваров = ПолучитьИзВременногоХранилища(АдресТоваровВХранилище);
	
	Для Каждого СтрокаТовара Из СписокТоваров Цикл
		НоваяСтрока = Объект.Товары.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, СтрокаТовара);
		ОбработкаТабличнойЧастиСервер.ОбработатьСтрокуТабличнойЧасти(НоваяСтрока, СтруктураДействий, КэшированныеЗначения);
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти // ОбработкаПодбора

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
Процедура ОбработатьИзменениеДоговораКонтрагента()
	
	Если ЗначениеЗаполнено(Объект.ДоговорКонтрагента) Тогда
		
		РеквизитыДоговора = ЗакупкиСервер.ПолучитьОсновныеРеквизитыДоговора(Объект.ДоговорКонтрагента);
		
		Если Не ЗначениеЗаполнено(Объект.Организация) Тогда
			Объект.Организация = РеквизитыДоговора.Организация;
		КонецЕсли;
		
		Если Не ЗначениеЗаполнено(Объект.Контрагент) Тогда
			Объект.Контрагент = РеквизитыДоговора.Контрагент;
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОбработатьИзменениеКонтрагента()
	
	Объект.ДоговорКонтрагента = ЗначениеНастроекБольничнаяАптекаПовтИсп.ПолучитьДоговорПоУмолчанию(
		,
		Объект.Контрагент,
		Объект.Организация);
	ОбработатьИзменениеДоговораКонтрагента();
	
КонецПроцедуры

&НаСервере
Процедура ОбработатьИзменениеЦенаВключаетНДСНаСервере(КэшированныеЗначения)
	
	Действия = ОбработкаТабличнойЧастиКлиентСервер;
	
	СтруктураДействий = Новый Структура;
	ПараметрыПересчетаСуммы = Действия.ПолучитьПараметрыПересчетаСуммыНДС(Объект);
	СтруктураДействий.Вставить(Действия.Действие_ПересчитатьСуммуНДС(), ПараметрыПересчетаСуммы);
	СтруктураДействий.Вставить(Действия.Действие_ПересчитатьСуммуСНДС(), ПараметрыПересчетаСуммы);
	
	ОбработкаТабличнойЧастиСервер.ОбработатьТабличнуюЧасть(Объект.Товары, СтруктураДействий, КэшированныеЗначения);
	
КонецПроцедуры

&НаСервере
Процедура ОбработатьИзменениеНалогооблаженияНДС()
	
	Действия = ОбработкаТабличнойЧастиКлиентСервер;
	
	СтруктураДействий = Новый Структура;
	СтруктураДействий.Вставить(Действия.Действие_ЗаполнитьСтавкуНДС(), Объект.НалогообложениеНДС);
	ПараметрыПересчетаСуммы = Действия.ПолучитьПараметрыПересчетаСуммыНДС(Объект);
	СтруктураДействий.Вставить(Действия.Действие_ПересчитатьСуммуНДС(), ПараметрыПересчетаСуммы);
	СтруктураДействий.Вставить(Действия.Действие_ПересчитатьСуммуСНДС(), ПараметрыПересчетаСуммы);
	
	ОбработкаТабличнойЧастиСервер.ОбработатьТабличнуюЧасть(Объект.Товары, СтруктураДействий, Неопределено);
	
	НастроитьОтображениеИтогов();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработатьЗагрузкуДанныхИзТСД(РезультатВыполнения, ДополнительныеПараметры) Экспорт
	
	Если РезультатВыполнения.Результат Тогда
		ОбработатьШтрихкоды(РезультатВыполнения.ТаблицаТоваров);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриИзмененииКоличестваВСтрокеСпискаТовары(ТекущаяСтрока)
	
	Действия = ОбработкаТабличнойЧастиКлиентСервер;
	
	СтруктураДействий = Новый Структура;
	СтруктураДействий.Вставить(Действия.Действие_ПересчитатьКоличествоЕдиниц());
	СтруктураДействий.Вставить(Действия.Действие_ПересчитатьСумму());
	ПараметрыПересчетаСуммы = Действия.ПолучитьПараметрыПересчетаСуммыНДС(Объект);
	СтруктураДействий.Вставить(Действия.Действие_ПересчитатьСуммуНДС(), ПараметрыПересчетаСуммы);
	СтруктураДействий.Вставить(Действия.Действие_ПересчитатьСуммуСНДС(), ПараметрыПересчетаСуммы);
	
	ОбработкаТабличнойЧастиКлиент.ОбработатьСтрокуТабличнойЧасти(ТекущаяСтрока, СтруктураДействий, КэшированныеЗначения);
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеРазбиенияСтроки(НоваяСтрока, ТекущаяСтрока) Экспорт
	
	НоваяСтрока.КодСтроки = 0;
	
	ПриИзмененииКоличестваВСтрокеСпискаТовары(ТекущаяСтрока);
	ПриИзмененииКоличестваВСтрокеСпискаТовары(НоваяСтрока);
	
	Элементы.Товары.ТекущаяСтрока = НоваяСтрока.ПолучитьИдентификатор();
	
КонецПроцедуры

#КонецОбласти // ОбработкаИзмененияРеквизитов

////////////////////////////////////////////////////////////////////////////////
// Буфер обмена товарами
#Область БуферОбменаТоварами

&НаКлиенте
Процедура СкопироватьСтроки(Команда)
	
	ТаблицаТовары = Элементы.Товары;
	Если ОбработкаТабличнойЧастиКлиент.ВозможноКопированиеСтрок(ТаблицаТовары.ТекущаяСтрока) Тогда
		СкопироватьСтрокиВБуферОбмена(ТаблицаТовары.Имя);
		ОбработкаТабличнойЧастиКлиент.ОповеститьПользователяОКопированииСтрок(ТаблицаТовары.ВыделенныеСтроки.Количество());
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВставитьСтроки(Команда)
	
	ВставитьТоварыИзБуфераОбмена();
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьБуфераОбмена(Команда)
	
	ОбработкаТабличнойЧастиКлиент.ОткрытьБуферОбмена(ЭтотОбъект);
	
КонецПроцедуры

&НаСервере
Процедура СкопироватьСтрокиВБуферОбмена(Знач ИмяТабличнойЧасти)
	
	ОбработкаТабличнойЧастиСервер.СкопироватьВыделенныеСтрокиВБуферОбмена(Объект, Объект[ИмяТабличнойЧасти], Элементы[ИмяТабличнойЧасти].ВыделенныеСтроки);
	
КонецПроцедуры

&НаКлиенте
Процедура ВставитьТоварыИзБуфераОбмена(ВыбранныеТовары = Неопределено)
	
	ТаблицаТовары = Объект.Товары;
	КоличествоТоваровДоВставки = ТаблицаТовары.Количество();
	
	ВставитьТоварыИзБуфераОбменаСервер(ВыбранныеТовары);
	
	КоличествоВставленных = ТаблицаТовары.Количество() - КоличествоТоваровДоВставки;
	ОбработкаТабличнойЧастиКлиент.ОповеститьПользователяОВставкеСтрок(КоличествоВставленных);
	
КонецПроцедуры

&НаСервере
Процедура ВставитьТоварыИзБуфераОбменаСервер(Знач ВыбранныеТовары = Неопределено)
	
	ТабличнаяЧасть = Объект.Товары;
	
	Действия = ОбработкаТабличнойЧастиКлиентСервер;
	
	СтруктураДействий = Новый Структура;
	СтруктураДействий.Вставить(Действия.Действие_ПересчитатьКоэффициент());
	СтруктураДействий.Вставить(Действия.Действие_ЗаполнитьСтавкуНДС(), Объект.НалогообложениеНДС);
	СтруктураДействий.Вставить(Действия.Действие_ПересчитатьКоличествоЕдиниц());
	СтруктураДействий.Вставить(Действия.Действие_ПересчитатьСумму());
	ПараметрыПересчетаСуммы = Действия.ПолучитьПараметрыПересчетаСуммыНДС(Объект);
	СтруктураДействий.Вставить(Действия.Действие_ПересчитатьСуммуНДС(), ПараметрыПересчетаСуммы);
	СтруктураДействий.Вставить(Действия.Действие_ПересчитатьСуммуСНДС(), ПараметрыПересчетаСуммы);
	
	ДанныеВставлены = ОбработкаТабличнойЧастиСервер.ВставитьТоварыИзБуфераОбмена(ВыбранныеТовары, ТабличнаяЧасть, СтруктураДействий);
	Если ДанныеВставлены Тогда
		Модифицированность = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьДоступностьКомандБуфераОбмена(Форма, ЕстьДанныеВБуфереОбмена)
	
	Элементы = Форма.Элементы;
	Элементы.ТоварыБуферОбменаВставить.Доступность = ЕстьДанныеВБуфереОбмена;
	Элементы.ТоварыКонтекстноеМенюБуферОбменаВставить.Доступность = ЕстьДанныеВБуфереОбмена;
	Элементы.ТоварыБуферОбмена.Доступность = ЕстьДанныеВБуфереОбмена;
	
КонецПроцедуры

#КонецОбласти // БуферОбменаТоварами

#КонецОбласти // СлужебныеПроцедурыИФункции

////////////////////////////////////////////////////////////////////////////////
// СТАНДАРТНЫЕ ПОДСИСТЕМЫ
#Область СтандартныеПодсистемы

// СтандартныеПодсистемы.Свойства

&НаКлиенте
Процедура Подключаемый_СвойстваВыполнитьКоманду(ЭлементИлиКоманда, НавигационнаяСсылка = Неопределено, СтандартнаяОбработка = Неопределено)
	УправлениеСвойствамиКлиент.ВыполнитьКоманду(ЭтотОбъект, ЭлементИлиКоманда, СтандартнаяОбработка);
КонецПроцедуры

&НаСервере
Процедура ОбновитьЭлементыДополнительныхРеквизитов()
	УправлениеСвойствами.ОбновитьЭлементыДополнительныхРеквизитов(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьЗависимостиДополнительныхРеквизитов()
	УправлениеСвойствамиКлиент.ОбновитьЗависимостиДополнительныхРеквизитов(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПриИзмененииДополнительногоРеквизита(Элемент)
	УправлениеСвойствамиКлиент.ОбновитьЗависимостиДополнительныхРеквизитов(ЭтотОбъект);
КонецПроцедуры

// Конец СтандартныеПодсистемы.Свойства

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

// ИнтеграцияС1СДокументооборотом

&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуИнтеграции(Команда)
	
	// ИнтеграцияС1СДокументооборотом
	ИнтеграцияС1СДокументооборотБазоваяФункциональностьКлиент.ВыполнитьПодключаемуюКомандуИнтеграции(Команда, ЭтотОбъект, Объект);
	// Конец ИнтеграцияС1СДокументооборотом
	
КонецПроцедуры

// Конец ИнтеграцияС1СДокументооборотом

#КонецОбласти // СтандартныеПодсистемы
