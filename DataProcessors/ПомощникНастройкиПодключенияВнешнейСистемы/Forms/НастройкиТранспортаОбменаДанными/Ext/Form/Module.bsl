﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2021, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Не Параметры.Свойство("Корреспондент") Тогда
		ВызватьИсключение НСтр("ru = 'Некорректные параметры формы.'");
	КонецЕсли;
	
	// Заполнение данных формы.
	Корреспондент        = Параметры.Корреспондент;
	ПараметрыПодключения = ОбменДаннымиСВнешнимиСистемами.ПриПолученииНастроекПодключенияВнешнейСистемы(
		Корреспондент);
	
	ИдентификаторОбмена        = ПараметрыПодключения.НастройкиТранспорта.ИдентификаторОбмена;
	ОписаниеНастройки          = ПараметрыПодключения.НастройкиТранспорта.ОписаниеНастройки;
	НачальноеОписаниеНастройки = ОписаниеНастройки;
	
	УстановитьВидимостьДоступность(Элементы);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ДекорацияВсеИдентификаторыНажатие(Элемент)
	
	ОткрытьФорму("ОбщаяФорма.НастроенныеОбменыДаннымиСВнешнимиСистемами");
	
КонецПроцедуры

&НаКлиенте
Процедура ДекорацияОшибкаОбработкаНавигационнойСсылки(
		Элемент,
		НавигационнаяСсылкаФорматированнойСтроки,
		СтандартнаяОбработка)
	
	ОбменДаннымиСВнешнимиСистемамиКлиент.ДекорацияОшибкаОбработкаНавигационнойСсылки(
		ЭтотОбъект,
		Элемент,
		НавигационнаяСсылкаФорматированнойСтроки,
		СтандартнаяОбработка);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОК(Команда)
	
	Если НачальноеОписаниеНастройки <> ОписаниеНастройки Тогда
		ОбновитьОписаниеОбменаДанными();
	Иначе
		ЭтотОбъект.Закрыть();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Отмена(Команда)
	
	ЭтотОбъект.Закрыть(Неопределено);
	
КонецПроцедуры

&НаКлиенте
Процедура Назад(Команда)
	
	Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.ГруппаНастройкиЗагрузки;
	УстановитьВидимостьДоступность(Элементы);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ОбновитьОписаниеОбменаДанными()
	
	ПараметрыОжидания = ДлительныеОперацииКлиент.ПараметрыОжидания(ЭтотОбъект);
	ПараметрыОжидания.ВыводитьОкноОжидания = Ложь;
	
	РезультатВыполнения = ОбновитьОписаниеОбменаДаннымиНаСервере(
		Корреспондент,
		ОписаниеНастройки,
		ЭтотОбъект.УникальныйИдентификатор);
		
	ОповещениеОЗавершении = Новый ОписаниеОповещения(
		"ОбновитьОписаниеОбменаДаннымиЗавершение",
		ЭтотОбъект);
	
	Если РезультатВыполнения.Статус = "Выполнено" Тогда
		ОбновитьОписаниеОбменаДаннымиЗавершение(РезультатВыполнения, Неопределено);
		Возврат;
	КонецЕсли;
	
	Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.ГруппаДлительнаяОперация;
	УстановитьВидимостьДоступность(Элементы);
	
	ДлительныеОперацииКлиент.ОжидатьЗавершение(
		РезультатВыполнения,
		ОповещениеОЗавершении,
		ПараметрыОжидания);
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ОбновитьОписаниеОбменаДаннымиНаСервере(
		Корреспондент,
		ОписаниеНастройки,
		УникальныйИдентификатор)
	
	ПараметрыОбменаДанными = Новый Структура;
	ПараметрыОбменаДанными.Вставить("Корреспондент",     Корреспондент);
	ПараметрыОбменаДанными.Вставить("ОписаниеНастройки", ОписаниеНастройки);
	
	ПараметрыВыполнения = ДлительныеОперации.ПараметрыВыполненияВФоне(УникальныйИдентификатор);
	ПараметрыВыполнения.НаименованиеФоновогоЗадания =
		НСтр("ru = 'Обновление настройки загрузки данных из внешних систем.'");
	
	РезультатВыполнения = ДлительныеОперации.ВыполнитьВФоне(
		"Обработки.ПомощникНастройкиПодключенияВнешнейСистемы.ОбновитьНастройкиПодключения",
		ПараметрыОбменаДанными,
		ПараметрыВыполнения);
	
	Возврат РезультатВыполнения;
	
КонецФункции

&НаКлиенте
Процедура ОбновитьОписаниеОбменаДаннымиЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если Результат.Статус = "Выполнено" Тогда
		РезультатОперации = ПолучитьИзВременногоХранилища(Результат.АдресРезультата);
		Если ЗначениеЗаполнено(РезультатОперации.КодОшибки) Тогда
			УстановитьОтображениеОшибки(
				Элементы,
				РезультатОперации.СообщениеОбОшибке);
		Иначе
			ЭтотОбъект.Закрыть();
		КонецЕсли;
		УстановитьВидимостьДоступность(Элементы);
	ИначеЕсли Результат.Статус = "Ошибка" Тогда
		УстановитьОтображениеОшибки(
			Элементы,
			Результат.КраткоеПредставлениеОшибки);
		УстановитьВидимостьДоступность(Элементы);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьОтображениеОшибки(Элементы, ОписаниеОшибки)
	
	Элементы.ДекорацияОшибка.Заголовок = ИнтернетПоддержкаПользователейКлиентСервер.ФорматированнаяСтрокаИзHTML(
		СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = '%1
				|
				|
				|Подробнее см. <a href = ""OpenLog"">журнал регистрации</a>.'"),
			ОписаниеОшибки));
	
	Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.ГруппаОшибкиОбновления;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьВидимостьДоступность(Элементы)
	
	Если Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.ГруппаНастройкиЗагрузки Тогда
		Элементы.ОК.Видимость  = Истина;
		Элементы.Отмена.Видимость = Истина;
		Элементы.Назад.Видимость  = Ложь;
	ИначеЕсли Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.ГруппаДлительнаяОперация Тогда
		Элементы.ОК.Видимость  = Ложь;
		Элементы.Отмена.Видимость = Ложь;
		Элементы.Назад.Видимость  = Ложь;
	ИначеЕсли Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.ГруппаОшибкиОбновления Тогда
		Элементы.ОК.Видимость  = Ложь;
		Элементы.Отмена.Видимость = Истина;
		Элементы.Назад.Видимость  = Истина;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти