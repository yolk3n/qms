﻿
////////////////////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС
#Область ПрограммныйИнтерфейс

// Подписывает предмет электронной подписью.
//
// Параметры:
//  Предмет              - Ссылка - подписываемый предмет.
//  ИдентификаторФормы   - УникальныйИдентификатор
//  ОбработчикЗавершения - ОписаниеОповещения - описание обработки завершения подписания.
//  СтандартнаяОбработка - Булево - если Ложь, то результат подписания будет передан в обработчик завершения,
//                                  сохранение подписей не происходит.
//
Процедура ПодписатьПредмет(Предмет, ИдентификаторФормы, ОбработчикЗавершения = Неопределено, СтандартнаяОбработка = Истина) Экспорт
	
	Если Не СтандартнаяОбработка И ОбработчикЗавершения = Неопределено Тогда
		ВызватьИсключение НСтр("ru = 'Не задан обработчик завершения подписания предмета'");
	КонецЕсли;
	
	НаборДанных = Новый Массив;
	ДанныеОбъектов = Новый Массив;
	
	// У документов сперва подписываем файлы.
	ПодчиненныеФайлы = ЭлектроннаяПодписьБольничнаяАптекаВызовСервера.ПолучитьВсеПодчиненныеФайлы(Предмет);
	Для Каждого Файл Из ПодчиненныеФайлы Цикл
		
		ДанныеОбъектов.Добавить(Файл);
		
		ТекущиеПараметрыВыполнения = Новый Структура;
		ТекущиеПараметрыВыполнения.Вставить("ИдентификаторФормы" , ИдентификаторФормы);
		ТекущиеПараметрыВыполнения.Вставить("ПодписываемыеДанные", Файл);
		
		ЭлементДанных = Новый Структура;
		ЭлементДанных.Вставить("Представление", Файл);
		ЭлементДанных.Вставить("Данные"       , Новый ОписаниеОповещения("ПриЗапросеДвоичныхДанныхФайла", ЭтотОбъект, ТекущиеПараметрыВыполнения));
		ЭлементДанных.Вставить("Объект"       , Новый ОписаниеОповещения("ПриПолученииПодписиФайла", ЭтотОбъект, ТекущиеПараметрыВыполнения));
		НаборДанных.Добавить(ЭлементДанных);
		
	КонецЦикла;
	
	ДанныеОбъектов.Добавить(Предмет);
	
	ТекущиеПараметрыВыполнения = Новый Структура;
	ТекущиеПараметрыВыполнения.Вставить("ИдентификаторФормы" , ИдентификаторФормы);
	ТекущиеПараметрыВыполнения.Вставить("ПодписываемыеДанные", Предмет);
	
	ЭлементДанных = Новый Структура;
	ЭлементДанных.Вставить("Представление", Предмет);
	ЭлементДанных.Вставить("Данные"       , Новый ОписаниеОповещения("ПриЗапросеДвоичныхДанныхПредмета", ЭтотОбъект, ТекущиеПараметрыВыполнения));
	ЭлементДанных.Вставить("Объект"       , Новый ОписаниеОповещения("ПриПолученииПодписиПредмета", ЭтотОбъект, ТекущиеПараметрыВыполнения));
	НаборДанных.Добавить(ЭлементДанных);
	
	ОписаниеДанных = Новый Структура;
	ОписаниеДанных.Вставить("ПоказатьКомментарий", Истина);
	ОписаниеДанных.Вставить("Операция"           , НСтр("ru = 'Подписание предмета'"));
	ОписаниеДанных.Вставить("ЗаголовокДанных"    , НСтр("ru = 'Предмет'"));
	ОписаниеДанных.Вставить("НаборДанных"        , НаборДанных);
	ОписаниеДанных.Вставить("ПредставлениеНабора", НСтр("ru = 'Предметы (%1)'"));
	
	Параметры = Новый Структура;
	Параметры.Вставить("Предмет"             , Предмет);
	Параметры.Вставить("ИдентификаторФормы"  , ИдентификаторФормы);
	Параметры.Вставить("ОбработчикЗавершения", ОбработчикЗавершения);
	Параметры.Вставить("СтандартнаяОбработка", СтандартнаяОбработка);
	
	ОбработчикПродолжения = Новый ОписаниеОповещения("ПодписатьПредметЗавершение", ЭтотОбъект, Параметры);
	ЭлектроннаяПодписьКлиент.Подписать(ОписаниеДанных,, ОбработчикПродолжения);
	
КонецПроцедуры

// Подписывает основной объект формы электронной подписью
//
Процедура ПодписатьОбъектВФорме(Форма, ОбработчикЗавершения = Неопределено) Экспорт
	
	Объект = Форма.Объект;
	Если Объект.Ссылка.Пустая() Или Форма.Модифицированность
	 Или ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(Объект, "Проведен") И Не Объект.Проведен Тогда
		Параметры = Новый Структура;
		Параметры.Вставить("Форма", Форма);
		Параметры.Вставить("ОбработчикЗавершения", ОбработчикЗавершения);
		Оповещение = Новый ОписаниеОповещения("ПодписатьПослеВопросаОПроведении", ЭтотОбъект, Параметры);
		ТекстВопроса = НСтр(
			"ru = 'Данные еще не записаны.
			|Подписать данные возможно только после записи.
			|Данные будут записаны.'");
		ПоказатьВопрос(Оповещение, ТекстВопроса, РежимДиалогаВопрос.ОКОтмена);
	Иначе
		ПодписатьПредмет(Объект.Ссылка, Форма.УникальныйИдентификатор, ОбработчикЗавершения);
	КонецЕсли;
	
КонецПроцедуры

// Проверяет подписи данных.
//
// Параметры:
//  Форма            - ФормаКлиентскогоПриложения - форма предмета электронной подписи.
//  Данные           - ДвоичныеДанные -электронная подпись предмета.
//  ВыделенныеСтроки - Массив(Число) - идентификаторы строк табличной части проверяемых электронных подписей.
//
Процедура ПроверитьПодписи(Форма, ПроверятьВыделенные = Ложь, ОбработчикЗавершения = Неопределено) Экспорт
	
	ВыделенныеСтроки = Неопределено;
	Если ПроверятьВыделенные Тогда
		ВыделенныеСтроки = ЭлектроннаяПодписьБольничнаяАптекаКлиентСервер.ЭлементТаблицаПодписей(Форма).ВыделенныеСтроки;
		Если ВыделенныеСтроки.Количество() = 0 Тогда
			Возврат;
		КонецЕсли;
	КонецЕсли;
	
	ПараметрыПроверкиПодписи = Новый Структура;
	ПараметрыПроверкиПодписи.Вставить("Форма", Форма);
	ПараметрыПроверкиПодписи.Вставить("ОбработчикЗавершения", ОбработчикЗавершения);
	ПараметрыПроверкиПодписи.Вставить("ИдентификаторФормы", Форма.УникальныйИдентификатор);
	
	ЭлектронныеПодписи = ЭлектроннаяПодписьБольничнаяАптекаКлиентСервер.ТаблицаПодписей(Форма);
	Коллекция = ПолучитьСписокДанныхПодписей(ЭлектронныеПодписи, ВыделенныеСтроки);
	ПараметрыПроверкиПодписи.Вставить("ВыделенныеСтроки", Коллекция);
	
	КоллекцияОбъектов = Новый Массив;
	Для Каждого ЭлементКоллекции Из Коллекция Цикл
		Если ТипЗнч(ЭлементКоллекции) = Тип("Число") Тогда
			Данные = ЭлектронныеПодписи.НайтиПоИдентификатору(ЭлементКоллекции);
		Иначе
			Данные = ЭлементКоллекции;
		КонецЕсли;
		Если КоллекцияОбъектов.Найти(Данные.Объект) <> Неопределено Тогда
			Продолжить;
		КонецЕсли;
		Если Не ЗначениеЗаполнено(Данные.УникальныйИдентификатор) И Данные.УникальныйИдентификатор <> 0 Тогда
			Продолжить;
		КонецЕсли;
		КоллекцияОбъектов.Добавить(Данные.Объект);
	КонецЦикла;
	
	ПараметрыПроверкиПодписи.Вставить("КоллекцияОбъектов", КоллекцияОбъектов);
	
	ПараметрыПроверкиПодписи.Вставить("ИндексОбъекта", -1);
	ПроверитьПодписиОбъектаЦиклОбъектовНачало(ПараметрыПроверкиПодписи);
	
КонецПроцедуры

// Открывает форму просмотра подписи ЭП.
//
Процедура ОткрытьПодпись(Форма) Экспорт
	
	ТекущиеДанные = ЭлектроннаяПодписьБольничнаяАптекаКлиентСервер.ЭлементТаблицаПодписей(Форма).ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	#Если ВебКлиент Тогда
	Если ОбщегоНазначенияКлиент.ЭтоMacOSКлиент() Тогда
		Возврат;
	КонецЕсли;
	#КонецЕсли
	
	Если ТекущиеДанные.ПолучитьРодителя() = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если ЭлектроннаяПодписьБольничнаяАптекаКлиентСервер.ЭтоФайл(ТекущиеДанные.Объект) Тогда
		ЭлектроннаяПодписьКлиент.ОткрытьПодпись(ТекущиеДанные);
	Иначе
		
		Параметры = Новый Структура;
		Параметры.Вставить("Объект", ТекущиеДанные.Объект);
		Параметры.Вставить("УникальныйИдентификатор", ТекущиеДанные.УникальныйИдентификатор);
		Ключ = Новый (Тип("РегистрСведенийКлючЗаписи.ЭлектронныеПодписиБольничнаяАптека"), ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(Параметры));
		ПараметрыФормы = Новый Структура;
		ПараметрыФормы.Вставить("Ключ", Ключ);
		
		ОткрытьФорму("РегистрСведений.ЭлектронныеПодписиБольничнаяАптека.ФормаЗаписи", ПараметрыФормы,,,,,, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
		
	КонецЕсли;
	
КонецПроцедуры

// Сохраняет подпись на диск
//
Процедура СохранитьПодпись(Форма) Экспорт
	
	ТекущаяСтрока = ЭлектроннаяПодписьБольничнаяАптекаКлиентСервер.ЭлементТаблицаПодписей(Форма).ТекущиеДанные;
	Если ТекущаяСтрока = Неопределено
	 Или Не ЗначениеЗаполнено(ТекущаяСтрока.Объект) Тогда
		Возврат;
	КонецЕсли;
	
	ЭлектроннаяПодписьКлиент.СохранитьПодпись(ТекущаяСтрока.АдресПодписи);
	
КонецПроцедуры

// По окончании подписания нотифицирует.
//
// Параметры:
//  ПодписанныеДанные - Массив
//   * ПодписанныйОбъект - Ссылка - подписанный объект.
//   * СвойстваПодписи   - Структура - данные электронной подписи.
//  Объект - предмет электронной подписи.
//
Процедура ИнформироватьОПодписании(ПодписанныеДанные, Объект) Экспорт
	
	Для Каждого Данные Из ПодписанныеДанные Цикл
		ОповеститьОбИзменении(Данные.Представление);
	КонецЦикла;
	
	ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru = 'Установлена подпись для ""%1""'"), Объект);
	Состояние(ТекстСообщения);
	
КонецПроцедуры

#КонецОбласти // ПрограммныйИнтерфейс

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ
#Область СлужебныеПроцедурыИФункции

// Продолжение ПодписатьОбъектВФорме
Процедура ПодписатьПослеВопросаОПроведении(Ответ, ДополнительныеПараметры) Экспорт
	
	Если Ответ <> КодВозвратаДиалога.ОК Тогда
		Возврат;
	КонецЕсли;
	
	Форма = ДополнительныеПараметры.Форма;
	Предмет = Форма.Объект.Ссылка;
	ОбработчикЗавершения = ДополнительныеПараметры.ОбработчикЗавершения;
	
	ПараметрыЗаписи = Новый Структура;
	ПараметрыЗаписи.Вставить("РежимЗаписи", РежимЗаписиДокумента.Проведение);
	
	ЭтоНовый = Предмет.Пустая();
	Если Не Форма.Записать(ПараметрыЗаписи) Тогда
		Если ОбработчикЗавершения <> Неопределено Тогда
			ВыполнитьОбработкуОповещения(ОбработчикЗавершения, Ложь);
		КонецЕсли;
		Возврат;
	КонецЕсли;
	
	ПоказатьОповещениеПользователя(
		?(ЭтоНовый, "Создание:", "Изменение:"),
		ПолучитьНавигационнуюСсылку(Предмет),
		Строка(Предмет),
		БиблиотекаКартинок.Информация32);
	
	ПодписатьПредмет(Предмет, Форма.УникальныйИдентификатор, ОбработчикЗавершения);
	
КонецПроцедуры

// Продолжение процедуры ПодписатьПредмет.
// Вызывается из подсистемы ЭлектроннаяПодпись при запросе данных для подписания.
//
Процедура ПриЗапросеДвоичныхДанныхПредмета(Параметры, Контекст) Экспорт
	
	Данные = ЭлектроннаяПодписьБольничнаяАптекаВызовСервера.ПолучитьДанныеПредметаДляПодписи(Контекст.ПодписываемыеДанные);
	ВыполнитьОбработкуОповещения(Параметры.Оповещение, Новый Структура("Данные", Данные));
	
КонецПроцедуры

// Продолжение процедуры ПодписатьПредмет.
// Вызывается из подсистемы ЭлектроннаяПодпись при запросе данных для подписания.
//
Процедура ПриЗапросеДвоичныхДанныхФайла(Параметры, Контекст) Экспорт
	
	Данные = ПолучитьИзВременногоХранилища(РаботаСФайламиКлиент.ДанныеФайла(Контекст.ПодписываемыеДанные).СсылкаНаДвоичныеДанныеФайла);
	ВыполнитьОбработкуОповещения(Параметры.Оповещение, Новый Структура("Данные", Данные));
	
КонецПроцедуры

// Продолжение процедуры ПодписатьПредмет.
// Вызывается из подсистемы ЭлектроннаяПодпись после подписания данных для нестандартного
// способа добавления подписи в объект.
//
Процедура ПриПолученииПодписиПредмета(Параметры, Контекст) Экспорт
	
	ВыполнитьОбработкуОповещения(Параметры.Оповещение, Новый Структура);
	
КонецПроцедуры

// Продолжение процедуры ПодписатьПредмет.
// Вызывается из подсистемы ЭлектроннаяПодпись после подписания данных для нестандартного
// способа добавления подписи в объект.
//
Процедура ПриПолученииПодписиФайла(Параметры, Контекст) Экспорт
	
	ВыполнитьОбработкуОповещения(Параметры.Оповещение, Новый Структура);
	
КонецПроцедуры

// Продолжение процедуры ПодписатьПредмет.
//
Процедура ПодписатьПредметЗавершение(Результат, Параметры) Экспорт
	
	Если Не Параметры.СтандартнаяОбработка Тогда
		ВыполнитьОбработкуОповещения(Параметры.ОбработчикЗавершения, Результат);
		Возврат;
	КонецЕсли;
	
	Если Результат.Успех Тогда
		ПодписанныеДанные = Новый Массив;
		Для Каждого Данные Из Результат.НаборДанных Цикл
			Если Не Данные.Свойство("СвойстваПодписи") Тогда
				Возврат;
			КонецЕсли;
			Элемент = Новый Структура;
			Элемент.Вставить("ПодписанныйОбъект", Данные.Представление);
			Элемент.Вставить("СвойстваПодписи"  , Данные.СвойстваПодписи);
			ПодписанныеДанные.Добавить(Элемент);
		КонецЦикла;
		
		ЭлектроннаяПодписьБольничнаяАптекаВызовСервера.ЗанестиИнформациюОПодписях(ПодписанныеДанные, Параметры.ИдентификаторФормы);
		ИнформироватьОПодписании(Результат.НаборДанных, Параметры.Предмет);
	КонецЕсли;
	
	Если Параметры.ОбработчикЗавершения <> Неопределено Тогда
		ВыполнитьОбработкуОповещения(Параметры.ОбработчикЗавершения, Результат.Успех);
	КонецЕсли;
	
КонецПроцедуры

// Продолжение процедуры ПроверитьПодписи
Процедура ПроверитьПодписиОбъектаЦиклОбъектовНачало(Параметры)
	
	Параметры.ИндексОбъекта = Параметры.ИндексОбъекта + 1;
	Если Параметры.КоллекцияОбъектов.ВГраница() < Параметры.ИндексОбъекта Тогда
		Если Параметры.ОбработчикЗавершения <> Неопределено Тогда
			ВыполнитьОбработкуОповещения(Параметры.ОбработчикЗавершения);
		КонецЕсли;
		Возврат;
	КонецЕсли;
	
	Объект = Параметры.КоллекцияОбъектов[Параметры.ИндексОбъекта];
	
	КоллекцияПодписей = Новый Массив;
	Для Каждого Данные Из Параметры.ВыделенныеСтроки Цикл
		Если Данные.Объект <> Объект Тогда
			Продолжить;
		КонецЕсли;
		КоллекцияПодписей.Добавить(Данные);
	КонецЦикла;
	Параметры.Вставить("Коллекция", КоллекцияПодписей);
	
	Если ЭлектроннаяПодписьБольничнаяАптекаКлиентСервер.ЭтоФайл(Объект) Тогда
		
		ДанныеФайла = РаботаСФайламиКлиент.ДанныеФайла(Объект);
		Если ДанныеФайла.Зашифрован Тогда
			
			ОписаниеДанных = Новый Структура;
			ОписаниеДанных.Вставить("ИдентификаторФормы",    Параметры.ИдентификаторФормы);
			ОписаниеДанных.Вставить("Операция",              НСтр("ru = 'Расшифровка файла'"));
			ОписаниеДанных.Вставить("ЗаголовокДанных",       НСтр("ru = 'Файл'"));
			ОписаниеДанных.Вставить("Данные",                ДанныеФайла.СсылкаНаДвоичныеДанныеФайла);
			ОписаниеДанных.Вставить("Представление",         Объект);
			ОписаниеДанных.Вставить("СертификатыШифрования", Объект);
			ОписаниеДанных.Вставить("СообщитьОЗавершении",   Ложь);
			
			ОбработчикПродолжения = Новый ОписаниеОповещения("ПроверитьПодписиОбъектаПослеРасшифровкиФайла", ЭтотОбъект, Параметры);
			ЭлектроннаяПодписьКлиент.Расшифровать(ОписаниеДанных,, ОбработчикПродолжения);
			
		Иначе
			
			ПроверитьПодписиОбъектаПослеПодготовкиДанных(ДанныеФайла.СсылкаНаДвоичныеДанныеФайла, Параметры);
			
		КонецЕсли;
		
	Иначе
		
		ПроверитьПодписиОбъектаПослеПодготовкиДанных(Неопределено, Параметры);
		
	КонецЕсли;
	
КонецПроцедуры

// Продолжение процедуры ПроверитьПодписи
Процедура ПроверитьПодписиОбъектаПослеРасшифровкиФайла(ОписаниеДанных, ДополнительныеПараметры) Экспорт
	
	Если Не ОписаниеДанных.Успех Тогда
		Возврат;
	КонецЕсли;
	
	ПроверитьПодписиОбъектаПослеПодготовкиДанных(ОписаниеДанных.РасшифрованныеДанные, ДополнительныеПараметры);
	
КонецПроцедуры

// Продолжение процедуры ПроверитьПодписи
Процедура ПроверитьПодписиОбъектаПослеПодготовкиДанных(Данные, ДополнительныеПараметры)
	
	ПроверятьЭлектронныеПодписиНаСервере = ЭлектроннаяПодписьКлиент.ОбщиеНастройки().ПроверятьЭлектронныеПодписиНаСервере;
	
	Если ПроверятьЭлектронныеПодписиНаСервере Тогда
		
		ДанныеСтрок = Новый Массив;
		
		Если ТипЗнч(Данные) = Тип("ДвоичныеДанные") Тогда
			АдресДанных = ПоместитьВоВременноеХранилище(Данные, ДополнительныеПараметры.ИдентификаторФормы);
		Иначе
			АдресДанных = Данные;
		КонецЕсли;
		
		Для Каждого СтрокаПодписи Из ДополнительныеПараметры.Коллекция Цикл
			
			ДанныеСтроки = Новый Структура;
			ДанныеСтроки.Вставить("Объект");
			ДанныеСтроки.Вставить("УникальныйИдентификатор");
			ДанныеСтроки.Вставить("АдресПодписи");
			ДанныеСтроки.Вставить("ПодписьВерна");
			ДанныеСтроки.Вставить("АдресСертификата");
			ДанныеСтроки.Вставить("СертификатДействителен");
			ДанныеСтроки.Вставить("Статус");
			ДанныеСтроки.Вставить("ДатаПодписи");
			ДанныеСтроки.Вставить("ДатаПроверкиПодписи");
			ДанныеСтроки.Вставить("Версия");
			ЗаполнитьЗначенияСвойств(ДанныеСтроки, СтрокаПодписи);
			ДанныеСтрок.Добавить(ДанныеСтроки);
			
		КонецЦикла;
		
		ЭлектроннаяПодписьБольничнаяАптекаВызовСервера.ПроверитьПодписи(АдресДанных, ДанныеСтрок);
		
		Индекс = 0;
		Для Каждого СтрокаПодписи Из ДополнительныеПараметры.Коллекция Цикл
			СтрокаПодписи.Статус  = ДанныеСтрок[Индекс].Статус;
			СтрокаПодписи.ПодписьВерна = ДанныеСтрок[Индекс].ПодписьВерна;
			СтрокаПодписи.СертификатДействителен = ДанныеСтрок[Индекс].СертификатДействителен;
			СтрокаПодписи.ДатаПроверкиПодписи = ДанныеСтрок[Индекс].ДатаПроверкиПодписи;
			Индекс = Индекс + 1;
		КонецЦикла;
		
		ПроверитьПодписиОбъектаЦиклОбъектовНачало(ДополнительныеПараметры);
		
	Иначе
		
		ДополнительныеПараметры.Вставить("Данные", Данные);
		ОповещениеПродолжения = Новый ОписаниеОповещения("ПроверитьПодписиПослеСозданияМенеджераКриптографии", ЭтотОбъект, ДополнительныеПараметры);
		ЭлектроннаяПодписьКлиент.СоздатьМенеджерКриптографии(ОповещениеПродолжения, "ПроверкаПодписи");
		
	КонецЕсли;
	
КонецПроцедуры

// Продолжение процедуры ПроверитьПодписи.
//
// Параметры:
//  МенеджерКриптографии    - МенеджерКриптографии - предоставляет доступ к криптографическому
//                            функционалу с помощью заданного модуля криптозащиты.
//  ДополнительныеПараметры - Структура - данные проверки.
//
Процедура ПроверитьПодписиПослеСозданияМенеджераКриптографии(МенеджерКриптографии, ДополнительныеПараметры) Экспорт
	
	Если ТипЗнч(МенеджерКриптографии) <> Тип("МенеджерКриптографии") Тогда
		Возврат;
	КонецЕсли;
	
	ДополнительныеПараметры.Вставить("Индекс"              , 0);
	ДополнительныеПараметры.Вставить("МенеджерКриптографии", МенеджерКриптографии);
	
	ПроверитьПодписиЦиклНачало(ДополнительныеПараметры);
	
КонецПроцедуры

// Продолжение процедуры ПроверитьПодписи.
Процедура ПроверитьПодписиЦиклНачало(ДополнительныеПараметры)
	
	Если ДополнительныеПараметры.Коллекция.ВГраница() < ДополнительныеПараметры.Индекс Тогда
		ПроверитьПодписиОбъектаЦиклОбъектовНачало(ДополнительныеПараметры);
		Возврат;
	КонецЕсли;
	
	СтрокаПодписи = ДополнительныеПараметры.Коллекция[ДополнительныеПараметры.Индекс];
	ДополнительныеПараметры.Индекс = ДополнительныеПараметры.Индекс + 1;
	
	ДополнительныеПараметры.Вставить("СтрокаПодписи", СтрокаПодписи);
	
	Данные = ДополнительныеПараметры.Данные;
	Если Данные = Неопределено Тогда
		Данные = ЭлектроннаяПодписьБольничнаяАптекаВызовСервера.ПолучитьДанныеПредметаДляПодписи(СтрокаПодписи.Объект, СтрокаПодписи.Версия);
	КонецЕсли;
	
	ЭлектроннаяПодписьКлиент.ПроверитьПодпись(
		Новый ОписаниеОповещения("ПроверитьПодписиПослеПроверкиСтроки", ЭтотОбъект, ДополнительныеПараметры),
		Данные,
		СтрокаПодписи.АдресПодписи,
		ДополнительныеПараметры.МенеджерКриптографии,
		СтрокаПодписи.ДатаПодписи);
	
КонецПроцедуры

// Продолжение процедуры ПроверитьПодписи.
//
// Параметры:
//  Результат               - Булево - признак успешного выполнения проверки.
//  ДополнительныеПараметры - Структура - данные проверки.
//
Процедура ПроверитьПодписиПослеПроверкиСтроки(Результат, ДополнительныеПараметры) Экспорт
	
	СтрокаПодписи = ДополнительныеПараметры.СтрокаПодписи;
	
	Если ТипЗнч(Результат) = Тип("Булево") Тогда
		СтрокаПодписи.ПодписьВерна = Результат;
		СтрокаПодписи.СертификатДействителен = Результат;
		
		ОбновитьСтатусПроверкиПодписи(СтрокаПодписи);
		
		ПроверитьПодписиЦиклНачало(ДополнительныеПараметры);
	Иначе
		ДополнительныеПараметры.Вставить("ОшибкаПроверкиПодписи", Результат);
		ЭлектроннаяПодписьКлиент.ПроверитьСертификат(
			Новый ОписаниеОповещения("ПроверитьПодписиПослеПроверкиСертификатаСтроки", ЭтотОбъект, ДополнительныеПараметры),
			СтрокаПодписи.АдресСертификата,
			ДополнительныеПараметры.МенеджерКриптографии,
			ДополнительныеПараметры.СтрокаПодписи.ДатаПодписи);
	КонецЕсли;
	
КонецПроцедуры

// Продолжение процедуры ПроверитьПодписи.
//
// Параметры:
//  Результат               - Булево - признак успешного выполнения проверки.
//  ДополнительныеПараметры - Структура - данные проверки.
//
Процедура ПроверитьПодписиПослеПроверкиСертификатаСтроки(Результат, ДополнительныеПараметры) Экспорт
	
	СтрокаПодписи = ДополнительныеПараметры.СтрокаПодписи;
	СтрокаПодписи.ПодписьВерна = Не (Результат = Истина Или Результат <> ДополнительныеПараметры.ОшибкаПроверкиПодписи);
	
	ТекстОшибкиПроверкиПодписи = "";
	ТекстОшибкиПроверкиСертификата = "";
	
	Если Не СтрокаПодписи.ПодписьВерна Тогда
		ТекстОшибкиПроверкиПодписи = ДополнительныеПараметры.ОшибкаПроверкиПодписи;
	КонецЕсли;
	
	Если ТипЗнч(Результат) = Тип("Булево") Тогда
		СтрокаПодписи.СертификатДействителен = Результат;
	Иначе
		СтрокаПодписи.СертификатДействителен = Ложь;
		ТекстОшибкиПроверкиСертификата = Результат;
	КонецЕсли;
	
	ОбновитьСтатусПроверкиПодписи(СтрокаПодписи, ТекстОшибкиПроверкиПодписи, ТекстОшибкиПроверкиСертификата);
	
	ДополнительныеПараметры.Удалить("ОшибкаПроверкиПодписи");
	ПроверитьПодписиЦиклНачало(ДополнительныеПараметры);
	
КонецПроцедуры

// Обновляет статус проверки подписи.
//
Процедура ОбновитьСтатусПроверкиПодписи(СтрокаПодписи, ТекстОшибкиПроверкиПодписи = "", ТекстОшибкиПроверкиСертификата = "")
	
	ДанныеПодписи = Новый Структура;
	ДанныеПодписи.Вставить("УникальныйИдентификатор");
	ДанныеПодписи.Вставить("Объект");
	ДанныеПодписи.Вставить("ПодписьВерна");
	ДанныеПодписи.Вставить("ТекстОшибкиПроверкиПодписи");
	ДанныеПодписи.Вставить("СертификатДействителен");
	ДанныеПодписи.Вставить("ТекстОшибкиПроверкиСертификата");
	
	ЗаполнитьЗначенияСвойств(ДанныеПодписи, СтрокаПодписи);
	
	ДанныеПодписи.ТекстОшибкиПроверкиПодписи = ТекстОшибкиПроверкиПодписи;
	ДанныеПодписи.ТекстОшибкиПроверкиСертификата = ТекстОшибкиПроверкиСертификата;
	
	СтрокаПодписи.ДатаПроверкиПодписи = ОбщегоНазначенияКлиент.ДатаСеанса();
	СтрокаПодписи.Статус = ЭлектроннаяПодписьБольничнаяАптекаВызовСервера.ОбновитьСтатусПроверкиПодписи(ДанныеПодписи, СтрокаПодписи.ДатаПроверкиПодписи);
	
КонецПроцедуры

Функция ПолучитьСписокДанныхПодписей(ТаблицаПодписей, ВыделенныеСтроки = Неопределено) Экспорт
	
	ДанныеСтрок = Новый Массив;
	
	Если ВыделенныеСтроки = Неопределено Тогда
		
		ЭлементыПервогоУровня = ТаблицаПодписей.ПолучитьЭлементы();
		Для Каждого СтрокаУровняОдин Из ЭлементыПервогоУровня Цикл
			ЭлементыВторогоУровня = СтрокаУровняОдин.ПолучитьЭлементы();
			
			Для Каждого Строка Из ЭлементыВторогоУровня Цикл
				ДанныеСтрок.Добавить(Строка);
			КонецЦикла;
		КонецЦикла;
		
	Иначе
		
		Для Каждого ИдентификаторСтроки Из ВыделенныеСтроки Цикл
			СтрокаПодписи = ТаблицаПодписей.НайтиПоИдентификатору(ИдентификаторСтроки);
			Если СтрокаПодписи.ПолучитьРодителя() <> Неопределено Тогда
				ДанныеСтрок.Добавить(СтрокаПодписи);
			КонецЕсли;
		КонецЦикла;
		
	КонецЕсли;
	
	Возврат ДанныеСтрок;
	
КонецФункции

#КонецОбласти // СлужебныеПроцедурыИФункции

