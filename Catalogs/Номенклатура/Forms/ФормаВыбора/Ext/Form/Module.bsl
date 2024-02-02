﻿
////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	// СтандартныеПодсистемы.ВерсионированиеОбъектов
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПараметрыРазмещения = ПодключаемыеКоманды.ПараметрыРазмещения();
	ПараметрыРазмещения.ПрефиксГрупп = "СтандартныйПоиск";
	ПараметрыРазмещения.КоманднаяПанель = Элементы.КоманднаяПанельСписокТоваровСтандартныйПоиск;
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект, ПараметрыРазмещения);
	
	ПараметрыРазмещения = ПодключаемыеКоманды.ПараметрыРазмещения();
	ПараметрыРазмещения.ПрефиксГрупп = "РасширенныйПоиск";
	ПараметрыРазмещения.КоманднаяПанель = Элементы.КоманднаяПанельСписокТоваровРасширенныйПоиск;
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект, ПараметрыРазмещения);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	// ПодключаемоеОборудование
	ПодключаемоеОборудованиеСервер.НастроитьФормуДляИспользованияПодключаемогоОборудования(ЭтотОбъект);
	// Конец ПодключаемоеОборудование
	
	Если Параметры.Отбор.Свойство("НомерРЛС") Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(СписокТоваров, "Ссылка.ЭлементКАТ.НомерРЛС",  Параметры.Отбор.НомерРЛС,,, Истина);
		Параметры.Отбор.Удалить("НомерРЛС");
	КонецЕсли;
	
	ПараметрыФормы = Новый ФиксированнаяСтруктура;
	
	КодФормы = "Справочник_Номенклатура_ФормаВыбора";
	ПодборТоваровСервер.ПриСозданииФормыСпискаНаСервере(ЭтотОбъект);
	
	Параметры.Свойство("ТекущаяСтрока", НоменклатураЭлементПриОткрытии);
	Если ЗначениеЗаполнено(НоменклатураЭлементПриОткрытии) Тогда
		Если ФильтрыСписковКлиентСервер.ИспользоватьФильтры(ЭтотОбъект) Тогда
			Если ФильтрыСписковКлиентСервер.ТекущийФильтр(ЭтотОбъект) = ФильтрНоменклатурыПоИерархииКлиентСервер.Идентификатор() Тогда
				НоменклатураРодительПриОткрытии = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(НоменклатураЭлементПриОткрытии, "Родитель");
			Иначе
				ПодборТоваровСервер.ОтфильтроватьПоАналогичнымСвойствам(ЭтотОбъект, НоменклатураЭлементПриОткрытии);
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// ПодключаемоеОборудование
	МенеджерОборудованияКлиент.НачатьПодключениеОборудованиеПриОткрытииФормы(Неопределено, ЭтотОбъект, "СканерШтрихкода");
	// Конец ПодключаемоеОборудование
	
	Если ФильтрыСписковКлиентСервер.ИспользоватьФильтры(ЭтотОбъект) Тогда
		Если ФильтрыСписковКлиентСервер.ТекущийФильтр(ЭтотОбъект) = ФильтрНоменклатурыПоИерархииКлиентСервер.Идентификатор() Тогда
			ФильтрНоменклатурыПоИерархииКлиентСервер.ИерархияНоменклатуры(ЭтотОбъект).ТекущаяСтрока = НоменклатураРодительПриОткрытии;
			ФильтрНоменклатурыПоИерархииКлиент.ПриАктивизацииСтрокиИерархииНоменклатуры(ЭтотОбъект);
		КонецЕсли;
	КонецЕсли;
	
	ПодборТоваровКлиентСервер.ТекущийСписокТоваров(ЭтотОбъект).ТекущаяСтрока = НоменклатураЭлементПриОткрытии;
	
	ПодключитьОбработчикОжидания("НастроитьПользовательскиеНастройкиПриНеобходимости", 1);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
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
	
	Если ИмяСобытия = "Запись_Номенклатура" Тогда
		Если ЗначениеЗаполнено(Источник) Тогда
			ПодборТоваровКлиентСервер.ТекущийСписокТоваров(ЭтотОбъект).ТекущаяСтрока = Источник;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	
	Если Не ЗавершениеРаботы Тогда
		СохранитьНастройкиФормы();
	КонецЕсли;
	
	// ПодключаемоеОборудование
	МенеджерОборудованияКлиент.НачатьОтключениеОборудованиеПриЗакрытииФормы(Неопределено, ЭтотОбъект);
	// Конец ПодключаемоеОборудование
	
КонецПроцедуры

#КонецОбласти // ОбработчикиСобытийФормы

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ
#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ВыбратьЗначениеНоменклатуры(Команда)
	
	ТекущаяСтрока = ПодборТоваровКлиентСервер.ТекущийСписокТоваров(ЭтотОбъект).ТекущаяСтрока;
	Если ТекущаяСтрока <> Неопределено Тогда
		ОповеститьОВыборе(ТекущаяСтрока);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура НастроитьПоиск(Команда)
	
	ПодборТоваровКлиент.НастроитьПоиск(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ПоискПоШтрихкодуВыполнить()
	
	ОчиститьСообщения();
	ОбработкаТабличнойЧастиКлиент.ПоказатьВводШтрихкода(УникальныйИдентификатор);
	
КонецПроцедуры

#КонецОбласти // ОбработчикиКомандФормы

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ФОРМЫ
#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура СписокПриАктивизацииСтроки(Элемент)
	
	// ФильтрНоменклатурыПоИерархии
	ФильтрНоменклатурыПоИерархииКлиент.ПриАктивизацииСтрокиСпискаНоменклатуры(ЭтотОбъект);
	// Конец ФильтрНоменклатурыПоИерархии
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

&НаКлиенте
Процедура СписокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ОповеститьОВыборе(ВыбраннаяСтрока);
	
КонецПроцедуры

&НаСервере
Процедура СписокТоваровПриОбновленииСоставаПользовательскихНастроекНаСервере(СтандартнаяОбработка)
	
	ТребуетсяОбновитьОтображениеПользовательскихНастроек = Истина;
	
КонецПроцедуры

#КонецОбласти // ОбработчикиСобытийЭлементовФормы

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ
#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ОбработатьШтрихкоды(ДанныеШтрихкода)
	
	Данные = ОбработкаТабличнойЧастиКлиентСервер.ПолучитьДанныеИзШтрихкода(ДанныеШтрихкода.Штрихкод);
	
	Номенклатура = ПолучитьНоменклатуруПоШтрихкоду(Данные);
	Если ЗначениеЗаполнено(Номенклатура) Тогда
		ФильтрыСписковКлиентСервер.ФильтруемыйСписокЭлементФормы(ЭтотОбъект).ТекущаяСтрока = Номенклатура;
		ПоказатьЗначение(, Номенклатура);
	Иначе
		
		ШтрихкодПоиска = ОбщегоНазначенияКлиентСервер.СвойствоСтруктуры(Данные, "GTIN");
		Если Не ЗначениеЗаполнено(ШтрихкодПоиска) Тогда
			ШтрихкодПоиска = Данные.Штрихкод;
		КонецЕсли;
		
		Оповестить = Новый ОписаниеОповещения("ЗавершитьПоискНоменклатурыПоШтрихкодуВСервисе", ЭтотОбъект, ШтрихкодПоиска);
		РаботаСНоменклатуройКлиент.НайтиНоменклатуруПоШтрихкодуВСервисе(ШтрихкодПоиска, ЭтотОбъект, Оповестить);
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьНоменклатуруПоШтрихкоду(Знач ДанныеШтрихкода)
	
	Возврат НоменклатураСервер.ПолучитьНоменклатуруПоШтрихкоду(ДанныеШтрихкода);
	
КонецФункции

&НаКлиенте
Процедура ЗавершитьПоискНоменклатурыПоШтрихкодуВСервисе(Результат, ШтрихкодПоиска) Экспорт
	
	СозданнаяНоменклатура = ОбщегоНазначенияКлиентСервер.СвойствоСтруктуры(Результат, "СозданнаяНоменклатура");
	Если ЗначениеЗаполнено(СозданнаяНоменклатура) Тогда
		ФильтрыСписковКлиентСервер.ФильтруемыйСписокЭлементФормы(ЭтотОбъект).ТекущаяСтрока = СозданнаяНоменклатура[0];
	Иначе
		Пояснение = НСтр("ru = 'По штрихкоду %1 номенклатура не загружена.'");
		Пояснение = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(Пояснение, ШтрихкодПоиска);
		ПоказатьОповещениеПользователя(НСтр("ru = 'Номенклатура не загружена'"),, Пояснение);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура СохранитьНастройкиФормы()
	
	ПодборТоваровСервер.СохранитьНастройкиФормы(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура НастроитьПользовательскиеНастройкиПриНеобходимости()
	
	Если ТребуетсяОбновитьОтображениеПользовательскихНастроек И Элементы.ГруппаПользовательскихНастроек.ПодчиненныеЭлементы.Количество() > 0 Тогда
		ТребуетсяОбновитьОтображениеПользовательскихНастроек = Ложь;
		НастроитьОтображениеПользовательскихНастроек();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура НастроитьОтображениеПользовательскихНастроек()
	
	ПодборТоваровСервер.НастроитьОтображениеПользовательскихНастроек(Элементы.ГруппаПользовательскихНастроек);
	
КонецПроцедуры

#КонецОбласти // СлужебныеПроцедурыИФункции

////////////////////////////////////////////////////////////////////////////////
// Расширенный поиск в списке номенклатуры
#Область СтрокаПоиска

&НаКлиенте
Процедура Подключаемый_РасширенныйПоискВСписках_СтрокаПоискаПриИзменении(Элемент)
	
	ВыполнитьПоиск();
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_РасширенныйПоискВСписках_СтрокаПоискаОчистка(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	РасширенныйПоискВСпискахКлиентСервер.СнятьОтборПоСтрокеПоиска(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_РасширенныйПоискВСписках_НайтиПоТочномуСоответствиюПриИзменении(Элемент)
	
	ВыполнитьПоиск();
	
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьПоиск()
	
	ВыполнитьПоискНаСервере();
	
	РасширенныйПоискВСпискахКлиент.ПослеВыполненияПоиска(ЭтотОбъект);
	
КонецПроцедуры

&НаСервере
Процедура ВыполнитьПоискНаСервере()
	
	РасширенныйПоискВСписках.ВыполнитьПоиск(ЭтотОбъект);
	
КонецПроцедуры

#КонецОбласти // СтрокаПоиска

////////////////////////////////////////////////////////////////////////////////
// Фильтры списка номенклатуры
#Область ФильтрыСписков

&НаКлиенте
Процедура Подключаемый_ПодборТоваров_ОтфильтроватьПоАналогичнымСвойствам(Команда)
	
	ТекущаяСтрока = ПодборТоваровКлиентСервер.ТекущийСписокТоваров(ЭтотОбъект).ТекущаяСтрока;
	Если ТекущаяСтрока = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ОтфильтроватьПоАналогичнымСвойствам(ТекущаяСтрока);
	
КонецПроцедуры

&НаСервере
Процедура ОтфильтроватьПоАналогичнымСвойствам(Знач Номенклатура)
	
	ПодборТоваровСервер.ОтфильтроватьПоАналогичнымСвойствам(ЭтотОбъект, Номенклатура);
	ФильтрыСписковКлиентСервер.ФильтруемыйСписокЭлементФормы(ЭтотОбъект).ТекущаяСтрока = Номенклатура;
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ФильтрыСписков_ИспользоватьФильтрыПриИзменении(Элемент)
	
	ФильтрыСписков_ИспользоватьФильтрыПриИзменении();
	
КонецПроцедуры

&НаСервере
Процедура ФильтрыСписков_ИспользоватьФильтрыПриИзменении()
	
	ФильтрыСписков.ИспользоватьФильтрыПриИзменении(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ФильтрыСписков_ВариантФильтраПриИзменении(Элемент)
	
	Если ФильтрыСписковКлиент.НуженСерверныйВызовПриИзмененииВариантаФильтра(ЭтотОбъект) Тогда
		ФильтрыСписков_ВариантФильтраПриИзменении();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ФильтрыСписков_ВариантФильтраПриИзменении()
	
	ФильтрыСписков.ВариантФильтраПриИзменении(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ФильтрыСписков_ВариантФильтраОчистка(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Фильтр номенклатуры по иерархии
#Область ИерархияНоменклатуры

&НаКлиенте
Процедура Подключаемый_ФильтрНоменклатурыПоИерархии_СоздатьГруппуНоменклатуры(Команда)
	
	ФильтрНоменклатурыПоИерархииКлиент.СоздатьГруппуНоменклатуры(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ФильтрНоменклатурыПоИерархии_ИзменитьГруппуНоменклатуры(Команда)
	
	ФильтрНоменклатурыПоИерархииКлиент.ИзменитьГруппуНоменклатуры(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ФильтрНоменклатурыПоИерархии_СкопироватьГруппуНоменклатуры(Команда)
	
	ФильтрНоменклатурыПоИерархииКлиент.СкопироватьГруппуНоменклатуры(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ФильтрНоменклатурыПоИерархии_УстановитьПометкуУдаленияГруппыНоменклатуры(Команда)
	
	ФильтрНоменклатурыПоИерархииКлиент.УстановитьПометкуУдаленияГруппыНоменклатуры(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ФильтрНоменклатурыПоИерархии_ИзменитьВыделенныеГруппы(Команда)
	
	ФильтрНоменклатурыПоИерархииКлиент.ИзменитьВыделенныеГруппы(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ФильтрНоменклатурыПоИерархии_УстановитьТекущуюСтрокуИерархииНоменклатуры()
	
	ФильтрНоменклатурыПоИерархииКлиент.УстановитьТекущуюСтрокуИерархииНоменклатуры(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ФильтрНоменклатурыПоИерархии_ИерархияНоменклатурыПриАктивизацииСтроки(Элемент)
	
	ФильтрНоменклатурыПоИерархииКлиент.ПриАктивизацииСтрокиИерархииНоменклатуры(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ФильтрНоменклатурыПоИерархии_ОбработатьАктивациюСтрокиИерархииНоменклатуры()
	
	ФильтрНоменклатурыПоИерархииКлиент.ОбработатьАктивациюСтрокиИерархииНоменклатуры(ЭтотОбъект);
	
КонецПроцедуры

#КонецОбласти // ИерархияНоменклатуры

////////////////////////////////////////////////////////////////////////////////
// Фильтр номенклатуры лекарственных средств
#Область ЛекарственныеСредства

&НаКлиенте
Процедура Подключаемый_ФильтрНоменклатурыЛекарственныхСредств_СброситьОтборы(Команда)
	
	ФильтрНоменклатурыЛекарственныхСредств_СброситьОтборы();
	
КонецПроцедуры

&НаСервере
Процедура ФильтрНоменклатурыЛекарственныхСредств_СброситьОтборы()
	
	ФильтрНоменклатурыЛекарственныхСредств.СброситьОтборы(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ФильтрНоменклатурыЛекарственныхСредств_СписокОтбораНажатие(Элемент, СтандартнаяОбработка)
	
	ФильтрНоменклатурыЛекарственныхСредствКлиент.ВыбратьСписокОтбора(ЭтотОбъект, Элемент.Имя, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ФильтрНоменклатурыЛекарственныхСредств_ПриИзмененииФлажкаОтбора(Элемент)
	
	ФильтрНоменклатурыЛекарственныхСредств_ПриИзмененииФлажкаОтбора(Элемент.Имя);
	
КонецПроцедуры

&НаСервере
Процедура ФильтрНоменклатурыЛекарственныхСредств_ПриИзмененииФлажкаОтбора(Знач ИмяФлажка)
	
	ФильтрНоменклатурыЛекарственныхСредств.ПриИзмененииФлажкаОтбора(ЭтотОбъект, ИмяФлажка);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ФильтрНоменклатурыЛекарственныхСредств_ПриИзмененииЗначенияОтбора(Элемент)
	
	ФильтрНоменклатурыЛекарственныхСредств_ПриИзмененииЗначенияОтбора(Элемент.Имя);
	
КонецПроцедуры

&НаСервере
Процедура ФильтрНоменклатурыЛекарственныхСредств_ПриИзмененииЗначенияОтбора(Знач ИмяЭлемента)
	
	ФильтрНоменклатурыЛекарственныхСредств.ПриИзмененииЗначенияОтбора(ЭтотОбъект, ИмяЭлемента);
	
КонецПроцедуры

&НаКлиенте
Процедура ФильтрНоменклатурыЛекарственныхСредств_ОбработатьВыборЭлементовСписка(СписокВыбора, ИмяСписка) Экспорт
	
	Если ФильтрНоменклатурыЛекарственныхСредствКлиент.ОбработатьВыборЭлементовСписка(ЭтотОбъект, СписокВыбора, ИмяСписка) Тогда
		ФильтрНоменклатурыЛекарственныхСредств_ПриИзмененииЗначенияОтбора(ЭтотОбъект.ТекущийЭлемент.Имя);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ФильтрНоменклатурыЛекарственныхСредств_ФормаВыпускаНажатие(Элемент, СтандартнаяОбработка)
	
	ФильтрНоменклатурыЛекарственныхСредствКлиент.УстановитьОтборПоФормеВыпуска(ЭтотОбъект, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ФильтрНоменклатурыЛекарственныхСредств_ОбработатьУстановкуОтбораПоФормеВыпуска(Отбор, ДополнительныеПараметры) Экспорт
	
	Если Отбор <> Неопределено Тогда
		ФильтрНоменклатурыЛекарственныхСредств_ОбработатьУстановкуОтбораПоФормеВыпускаСервер(Отбор);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ФильтрНоменклатурыЛекарственныхСредств_ОбработатьУстановкуОтбораПоФормеВыпускаСервер(Знач Отбор)
	
	ФильтрНоменклатурыЛекарственныхСредств.УстановитьОтборыСписка(ЭтотОбъект, Отбор);
	
КонецПроцедуры

#КонецОбласти // ЛекарственныеСредства

////////////////////////////////////////////////////////////////////////////////
// Фильтр номенклатуры по виду и свойствам
#Область ПоВидуИСвойствам

&НаКлиенте
Процедура Подключаемый_ФильтрНоменклатурыПоВидуИСвойствам_СброситьФильтрПоСвойствам(Команда)
	
	ФильтрНоменклатурыПоВидуИСвойствам_СброситьФильтрПоСвойствам();
	
КонецПроцедуры

&НаСервере
Процедура ФильтрНоменклатурыПоВидуИСвойствам_СброситьФильтрПоСвойствам()
	
	ФильтрНоменклатурыПоВидуИСвойствам.СброситьФильтрПоСвойствам(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ФильтрНоменклатурыПоВидуИСвойствам_ПриИзмененииВидаНоменклатуры(Элемент)
	
	ФильтрНоменклатурыПоВидуИСвойствам_ПриИзмененииВидаНоменклатуры();
	
КонецПроцедуры

&НаСервере
Процедура ФильтрНоменклатурыПоВидуИСвойствам_ПриИзмененииВидаНоменклатуры()
	
	ФильтрНоменклатурыПоВидуИСвойствам.ПриИзмененииВидаНоменклатуры(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ФильтрНоменклатурыПоВидуИСвойствам_ПоказатьСкрытьВидыНоменклатурыНажатие(Элемент)
	
	ФильтрНоменклатурыПоВидуИСвойствамКлиент.ПоказатьСкрытьВидыНоменклатуры(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ФильтрНоменклатурыПоВидуИСвойствам_ВидыНоменклатурыПриАктивизацииСтроки(Элемент)
	
	ФильтрНоменклатурыПоВидуИСвойствамКлиент.ПриАктивизацииСтрокиВидаНоменклатуры(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ФильтрНоменклатурыПоИерархии_ОбработатьАктивациюСтрокиВидаНоменклатуры()
	
	ФильтрНоменклатурыПоВидуИСвойствам_ПриИзмененииВидаНоменклатуры();
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ФильтрНоменклатурыПоВидуИСвойствам_ФильтрПоСвойствамВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ФильтрНоменклатурыПоВидуИСвойствамКлиент.ФильтрПоСвойствамВыбор(ЭтотОбъект, Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ФильтрНоменклатурыПоВидуИСвойствам_ФильтрПоСвойствамОтборПриИзменении(Элемент)
	
	ФильтрНоменклатурыПоВидуИСвойствамКлиент.ФильтрПоСвойствамОтборПриИзменении(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ФильтрНоменклатурыПоВидуИСвойствам_ФильтрПоСвойствамПриИзмененииОтбора() Экспорт
	
	ФильтрНоменклатурыПоВидуИСвойствам_ФильтрПоСвойствамПриИзмененииОтбораНаСервере();
	
КонецПроцедуры

&НаСервере
Процедура ФильтрНоменклатурыПоВидуИСвойствам_ФильтрПоСвойствамПриИзмененииОтбораНаСервере()
	
	ФильтрНоменклатурыПоВидуИСвойствам.ФильтрПоСвойствамПриИзменении(ЭтотОбъект);
	
КонецПроцедуры

#КонецОбласти // ПоВидуИСвойствам

&НаКлиенте
Процедура Подключаемый_ПанельОтборов_СвернутьРазвернутьОтбор(Элемент)
	
	ПанельОтборовКлиентСервер.СкрытьПоказатьПанельОтборов(ЭтотОбъект);
	
КонецПроцедуры

#КонецОбласти // ФильтрыСписков

////////////////////////////////////////////////////////////////////////////////
// СТАНДАРТНЫЕ ПОДСИСТЕМЫ
#Область СтандартныеПодсистемы

// СтандартныеПодсистемы.ПодключаемыеКоманды

&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	Список = ПодборТоваровКлиентСервер.ТекущийСписокТоваров(ЭтотОбъект);
	ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Список);
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат) Экспорт
	Список = ПодборТоваровКлиентСервер.ТекущийСписокТоваров(ЭтотОбъект);
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, Список, Результат);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	Список = ПодборТоваровКлиентСервер.ТекущийСписокТоваров(ЭтотОбъект);
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Список);
КонецПроцедуры

// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

#КонецОбласти // СтандартныеПодсистемы
