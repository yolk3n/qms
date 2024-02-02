﻿
////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	СоставНабораКонстантФормы    = ОбщегоНазначенияБольничнаяАптека.ПолучитьСоставНабораКонстант(НаборКонстант);
	ВнешниеРодительскиеКонстанты = ОбщегоНазначенияБольничнаяАптекаПовтИсп.ПолучитьРодительскиеКонстанты(СоставНабораКонстантФормы);
	
	// Значения реквизитов формы
	РежимРаботы = Новый Структура;
	
	РежимРаботы.Вставить("ВнешниеРодительскиеКонстанты", Новый ФиксированнаяСтруктура(ВнешниеРодительскиеКонстанты));
	
	РежимРаботы = Новый ФиксированнаяСтруктура(РежимРаботы);
	
	Если Не ОбщегоНазначения.РазделениеВключено() Тогда
		РассылкаЭлектронныхЧековИдентификатор = РегламентныеЗаданияСервер.УникальныйИдентификатор(Метаданные.РегламентныеЗадания.РассылкаЭлектронныхЧеков);
	КонецЕсли;
	
	// Обновление состояния элементов
	УстановитьДоступность();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия <> "Запись_НаборКонстант" Тогда
		Возврат; // такие событие не обрабатываются
	КонецЕсли;
	
	// Если это изменена константа, расположенная в другой форме и влияющая на значения констант этой формы,
	// то прочитаем значения констант и обновим элементы этой формы.
	Если РежимРаботы.ВнешниеРодительскиеКонстанты.Свойство(Источник) Тогда
		
		Прочитать();
		УстановитьДоступность();
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	
	Если ЗавершениеРаботы Тогда
		Возврат;
	КонецЕсли;
	
	ОбновитьИнтерфейсПрограммы();
	
КонецПроцедуры

#КонецОбласти // ОбработчикиСобытийФормы

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ
#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОткрытьСписокИдентификационныеДанныеПользователей(Команда)
	
	ОткрытьФорму("РегистрСведений.ИдентификационныеДанныеПользователей.ФормаСписка");
	
КонецПроцедуры

&НаКлиенте
Процедура НастроитьОтправкуЭлектронныхЧековПоРасписанию(Команда)
	
	ПараметрыВыполнения = Новый Структура;
	РегламентныеЗаданияИзменитьРасписание(ПараметрыВыполнения);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьОчередьЭлектронныхЧеков(Команда)
	
	ОткрытьФорму("Справочник.ОчередьЭлектронныхЧековКОтправке.ФормаСписка",, ЭтотОбъект);
	
КонецПроцедуры

#КонецОбласти // ОбработчикиКомандФормы

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ФОРМЫ
#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура ВидЦенПоступленияПриИзменении(Элемент)
	
	Подключаемый_ПриИзмененииРеквизита(Элемент, Ложь);
	
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьЦеновыеГруппыПриИзменении(Элемент)
	
	Подключаемый_ПриИзмененииРеквизита(Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьРозничныеПродажиПриИзменении(Элемент)
	
	Подключаемый_ПриИзмененииРеквизита(Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура КонтролироватьОстаткиПриПробитииЧековККМПриИзменении(Элемент)
	
	Подключаемый_ПриИзмененииРеквизита(Элемент, Ложь);
	
КонецПроцедуры

&НаКлиенте
Процедура КоличествоДнейХраненияОтложенныхЧековПриИзменении(Элемент)
	
	Подключаемый_ПриИзмененииРеквизита(Элемент, Ложь);
	
КонецПроцедуры

&НаКлиенте
Процедура КоличествоДнейХраненияЗаархивированныхЧековПриИзменении(Элемент)
	
	Подключаемый_ПриИзмененииРеквизита(Элемент, Ложь);
	
КонецПроцедуры

&НаКлиенте
Процедура ОперацияПриЗакрытииКассовойСменыПриИзменении(Элемент)
	
	Подключаемый_ПриИзмененииРеквизита(Элемент, Ложь);
	
КонецПроцедуры

&НаКлиенте
Процедура ОперацияПриЗакрытииКассовойСменыОчистка(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьАвторизациюРМКПриИзменении(Элемент)
	
	Подключаемый_ПриИзмененииРеквизита(Элемент, Ложь);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтправкаЭлектронныхЧековПослеПробитияЧекаПриИзменении(Элемент)
	
	РассылкаЭлектронныхЧековИспользование = Не НаборКонстант.ОтправкаЭлектронныхЧековПослеПробитияЧека;
	
	Подключаемый_ПриИзмененииРеквизита(Элемент, Ложь);
	
	Если РассылкаЭлектронныхЧековИспользование Тогда
		ПараметрыВыполнения = Новый Структура;
		ПараметрыВыполнения.Вставить("ВключениеРегламентногоЗадания");
		
		РегламентныеЗаданияИзменитьРасписание(ПараметрыВыполнения);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОтправлятьЭлектронныеЧекиПоSMSЧерезОФДПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент, Ложь);
КонецПроцедуры

&НаКлиенте
Процедура ОтправлятьЭлектронныеЧекиПоEmailЧерезОФДПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент, Ложь);
КонецПроцедуры

&НаКлиенте
Процедура НеПечататьФискальныйЧекПриОтправкеЭлектронногоЧекаПокупателюПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент, Ложь);
КонецПроцедуры

#КонецОбласти // ОбработчикиСобытийЭлементовФормы

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ
#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура Подключаемый_ПриИзмененииРеквизита(Элемент, ОбновлятьИнтерфейс = Истина)
	
	КонстантаИмя = ПриИзмененииРеквизитаСервер(Элемент.Имя);
	
	ОбновитьПовторноИспользуемыеЗначения();
	
	Если ОбновлятьИнтерфейс Тогда
		ОбновитьИнтерфейс = Истина;
		ПодключитьОбработчикОжидания("ОбновитьИнтерфейсПрограммы", 2, Истина);
	КонецЕсли;
	
	Если КонстантаИмя <> "" Тогда
		Оповестить("Запись_НаборКонстант", Новый Структура, КонстантаИмя);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьИнтерфейсПрограммы()
	
	Если ОбновитьИнтерфейс = Истина Тогда
		ОбновитьИнтерфейс = Ложь;
		ОбщегоНазначенияКлиент.ОбновитьИнтерфейсПрограммы();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ПриИзмененииРеквизитаСервер(ИмяЭлемента)
	
	РеквизитПутьКДанным = Элементы[ИмяЭлемента].ПутьКДанным;
	
	КонстантаИмя = СохранитьЗначениеРеквизита(РеквизитПутьКДанным);
	
	УстановитьДоступность(РеквизитПутьКДанным);
	
	ОбновитьПовторноИспользуемыеЗначения();
	
	Возврат КонстантаИмя;
	
КонецФункции

&НаСервере
Функция СохранитьЗначениеРеквизита(РеквизитПутьКДанным)
	
	// Определение имени константы.
	КонстантаИмя = "";
	Если НРег(Лев(РеквизитПутьКДанным, 14)) = НРег("НаборКонстант.") Тогда
		// Если путь к данным реквизита указан через "НаборКонстант".
		КонстантаИмя = Сред(РеквизитПутьКДанным, 15);
	Иначе
		// Определение имени и запись значения реквизита в соответствующей константе из "НаборКонстант".
		// Используется для тех реквизитов формы, которые связаны с константами напрямую (в отношении один-к-одному).
	КонецЕсли;
	
	// Сохранения значения константы.
	Если КонстантаИмя <> "" Тогда
		КонстантаМенеджер = Константы[КонстантаИмя];
		КонстантаЗначение = НаборКонстант[КонстантаИмя];
		
		Если КонстантаМенеджер.Получить() <> КонстантаЗначение Тогда
			Попытка
				КонстантаМенеджер.Установить(КонстантаЗначение);
			Исключение
				Прочитать();
				ВызватьИсключение;
			КонецПопытки;
			
			Если ОбщегоНазначенияБольничнаяАптекаПовтИсп.ЕстьПодчиненныеКонстанты(КонстантаИмя, КонстантаЗначение) Тогда
				Прочитать();
			КонецЕсли;
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат КонстантаИмя;
	
КонецФункции

&НаСервере
Процедура УстановитьДоступность(РеквизитПутьКДанным = "")
	
	Если РеквизитПутьКДанным = "НаборКонстант.ИспользоватьРозничныеПродажи" Или РеквизитПутьКДанным = "" Тогда
		
		Элементы.ОперацияПриЗакрытииКассовойСмены.Доступность = НаборКонстант.ИспользоватьРозничныеПродажи;
		Элементы.КоличествоДнейХраненияОтложенныхЧеков.Доступность = НаборКонстант.ИспользоватьРозничныеПродажи;
		Элементы.КонтролироватьОстаткиПриПробитииЧековККМ.Доступность = НаборКонстант.ИспользоватьРозничныеПродажи;
		
		Элементы.КоличествоДнейХраненияЗаархивированныхЧеков.Доступность =
			(НаборКонстант.ИспользоватьРозничныеПродажи
			И НаборКонстант.ОперацияПриЗакрытииКассовойСмены = Перечисления.ОперацииПриЗакрытииКассовойСмены.АрхивацияЧековККМ);
		
		Элементы.НастройкиПродавцов.Доступность = НаборКонстант.ИспользоватьРозничныеПродажи;
		Элементы.ОтправкаЭлектронныхЧековПослеПробитияЧека.Доступность = НаборКонстант.ИспользоватьРозничныеПродажи;
		Элементы.ОтправлятьЭлектронныеЧекиПоEmailЧерезОФД.Доступность = НаборКонстант.ИспользоватьРозничныеПродажи;
		Элементы.ОтправлятьЭлектронныеЧекиПоSMSЧерезОФД.Доступность = НаборКонстант.ИспользоватьРозничныеПродажи;
		Элементы.НеПечататьФискальныйЧекПриОтправкеЭлектронногоЧекаПокупателю.Доступность = НаборКонстант.ИспользоватьРозничныеПродажи;
		Элементы.ИспользоватьАвторизациюРМК.Доступность = НаборКонстант.ИспользоватьРозничныеПродажи;
		Элементы.ИдентификационныеДанныеПользователей.Доступность = НаборКонстант.ИспользоватьАвторизациюРМК И НаборКонстант.ИспользоватьРозничныеПродажи;
		
	КонецЕсли;
	
	Если РеквизитПутьКДанным = "НаборКонстант.ОперацияПриЗакрытииКассовойСмены" Тогда
		Элементы.КоличествоДнейХраненияЗаархивированныхЧеков.Доступность =
			(НаборКонстант.ИспользоватьРозничныеПродажи
			И НаборКонстант.ОперацияПриЗакрытииКассовойСмены = Перечисления.ОперацииПриЗакрытииКассовойСмены.АрхивацияЧековККМ);
	КонецЕсли;
	
	Если РеквизитПутьКДанным = "НаборКонстант.ИспользоватьАвторизациюРМК" Тогда
		Элементы.ИдентификационныеДанныеПользователей.Доступность = НаборКонстант.ИспользоватьАвторизациюРМК И НаборКонстант.ИспользоватьРозничныеПродажи;
	КонецЕсли;
	
	Если Не ОбщегоНазначения.РазделениеВключено() Тогда
		
		Если РеквизитПутьКДанным = "НаборКонстант.ОтправкаЭлектронныхЧековПослеПробитияЧека" Или РеквизитПутьКДанным = "НаборКонстант.ИспользоватьРозничныеПродажи" Или РеквизитПутьКДанным = "" Тогда
			
			РегламентноеЗадание = РегламентныеЗаданияСервер.Задание(РассылкаЭлектронныхЧековИдентификатор);
			РассылкаЭлектронныхЧековИспользование = РегламентноеЗадание.Использование;
			РассылкаЭлектронныхЧековРасписание    = РегламентноеЗадание.Расписание;
			
			Элементы.РассылкаЭлектронныхЧеков.Доступность = Не НаборКонстант.ОтправкаЭлектронныхЧековПослеПробитияЧека И НаборКонстант.ИспользоватьРозничныеПродажи;
			Если РассылкаЭлектронныхЧековИспользование Тогда
				РасписаниеПредставление = Строка(РассылкаЭлектронныхЧековРасписание);
				Представление = СтрЗаменить(НСтр("ru = 'Расписание отправки электронных чеков: %1'"), "%1", РасписаниеПредставление);
			Иначе
				Представление = НСтр("ru = '<Отключено>'");
			КонецЕсли;
			Элементы.РассылкаЭлектронныхЧеков.Заголовок = Представление;
			
		КонецЕсли;
		
	Иначе
		Элементы.ГруппаУправлениеРозничнымиПродажамиФЗ54ОтправкаЭлектронныхЧековРасписание.Видимость = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура РегламентныеЗаданияИзменитьРасписание(ПараметрыВыполнения)
	
	Обработчик = Новый ОписаниеОповещения("РегламентныеЗаданияПослеИзмененияРасписания", ЭтотОбъект, ПараметрыВыполнения);
	Диалог = Новый ДиалогРасписанияРегламентногоЗадания(РассылкаЭлектронныхЧековРасписание);
	Диалог.Показать(Обработчик);
	
КонецПроцедуры

&НаКлиенте
Процедура РегламентныеЗаданияПослеИзмененияРасписания(Расписание, ПараметрыВыполнения) Экспорт
	
	Если Расписание = Неопределено Тогда
		Если ПараметрыВыполнения.Свойство("ВключениеРегламентногоЗадания") Тогда
			РассылкаЭлектронныхЧековИспользование = Ложь;
			НаборКонстант.ОтправкаЭлектронныхЧековПослеПробитияЧека = Истина;
			Подключаемый_ПриИзмененииРеквизита(Элементы.ОтправкаЭлектронныхЧековПослеПробитияЧека, Истина);
		КонецЕсли;
		Возврат;
	КонецЕсли;
	
	РассылкаЭлектронныхЧековРасписание = Расписание;
	Если Не РассылкаЭлектронныхЧековИспользование Тогда
		РассылкаЭлектронныхЧековИспользование = Истина;
	КонецЕсли;
	
	СохранитьРасписаниеРегламентногоЗадания();
	
КонецПроцедуры

&НаСервере
Процедура СохранитьРасписаниеРегламентногоЗадания()
	
	ПараметрыЗадания = Новый Структура;
	ПараметрыЗадания.Вставить("Расписание"   , РассылкаЭлектронныхЧековРасписание);
	ПараметрыЗадания.Вставить("Использование", РассылкаЭлектронныхЧековИспользование);
	РегламентныеЗаданияСервер.ИзменитьЗадание(РассылкаЭлектронныхЧековИдентификатор, ПараметрыЗадания);
	
	УстановитьДоступность("НаборКонстант.ОтправкаЭлектронныхЧековПослеПробитияЧека");
	
КонецПроцедуры

&НаСервере
Процедура ПолучитьТекстЗаголовкаИРасписанияРегламентнойНастройки(Задание, ТекстРасписания, РасписаниеАктивно) Экспорт
	
	Если Задание = Неопределено Тогда
		
		ТекстРасписания = НСтр("ru = '<Расписание не задано>'");
		
	Иначе
		
		Если РасписаниеАктивно Тогда
			ТекстРасписания = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Расписание отправки электронных чеков: %1'"), Строка(Задание.Расписание));
		Иначе
			ТекстРасписания = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Расписание отправки электронных чеков (НЕ АКТИВНО): %1'"), Строка(Задание.Расписание));
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти // СлужебныеПроцедурыИФункции
