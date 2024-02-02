﻿
#Область СлужебныйПрограммныйИнтерфейс

#Область КриптографическиеОперации

// Получает отпечатки сертификатов на клиенте. Для дополнения отпечатками серверных и облачных сертификатов
// необходимо вызывать см. КриптографияБЭД.ПолучитьОтпечаткиСертификатов.
// 
// Параметры:
// 	Оповещение - ОписаниеОповещения - содержит описание процедуры, которая будет вызвана после получения отпечатков
//                                    со следующими параметрами:
//    * Результат - см. КриптографияБЭДКлиентСервер.НовыеРезультатыПолученияОтпечатков
//    * ДополнительныеПараметры - Произвольный - значение, которое было указано при создании объекта ОписаниеОповещения.
//
Процедура ПолучитьОтпечаткиСертификатов(Оповещение) Экспорт
	
	КриптографияБЭДСлужебныйКлиент.ПолучитьОтпечаткиСертификатов(Оповещение, Истина);
	
КонецПроцедуры

// Подписывает данные, возвращает подпись и добавляет подпись в объект, если указано.
// 
// Параметры:
// 	ОписаниеДанных - см. ЭлектроннаяПодписьКлиент.Подписать.ОписаниеДанных
// 	КонтекстДиагностики - см. ОбработкаНеисправностейБЭДКлиент.НовыйКонтекстДиагностики
// 	Форма - см. ЭлектроннаяПодписьКлиент.Подписать.Форма
// 	Оповещение - ОписаниеОповещения - содержит описание процедуры, которая будет вызвана после подписания
//                                    со следующими параметрами:
//                         * Результат - Структура - результат, возвращаемый см. ЭлектроннаяПодписьКлиент.Подписать,
//                                                   дополненный свойством "ПаролиСертификатов".
//                         * ДополнительныеПараметры - Произвольный - значение, которое было указано при создании
//                                                                     объекта ОписаниеОповещения.
// 	ПаролиСертификатов - см. НовыеПаролиСертификатов
Процедура Подписать(ОписаниеДанных, КонтекстДиагностики, Форма = Неопределено, Оповещение = Неопределено,
	ПаролиСертификатов = Неопределено) Экспорт
	
	ПередВыполнениемКриптографическойОперации(ОписаниеДанных, ПаролиСертификатов);
	
	Контекст = Новый Структура;
	Контекст.Вставить("ВидОперации", НСтр("ru = 'Подписание данных'"));
	Контекст.Вставить("Оповещение", Оповещение);
	Контекст.Вставить("КонтекстДиагностики", КонтекстДиагностики);
	Контекст.Вставить("ПаролиСертификатов", ПаролиСертификатов);
	СлужебноеОповещение = Новый ОписаниеОповещения("ПослеВыполненияКриптографическойОперации",
		КриптографияБЭДСлужебныйКлиент, Контекст);
	ЭлектроннаяПодписьКлиент.Подписать(ОписаниеДанных, Форма, СлужебноеОповещение);
	
КонецПроцедуры

// Расшифровывает переданные данные.
// 
// Параметры:
// 	ОписаниеДанных - см. ЭлектроннаяПодписьКлиент.Расшифровать.ОписаниеДанных
// 	КонтекстДиагностики - см. ОбработкаНеисправностейБЭДКлиент.НовыйКонтекстДиагностики
// 	Форма - см. ЭлектроннаяПодписьКлиент.Расшифровать.Форма
// 	Оповещение - ОписаниеОповещения - содержит описание процедуры, которая будет вызвана после расшифровки
//               со следующими параметрами:
//                  * Результат - Структура - результат, возвращаемый см. ЭлектроннаяПодписьКлиент.Расшифровать,
//                                                   дополненный свойством "ПаролиСертификатов".
//                  * ДополнительныеПараметры - Произвольный - значение, которое было указано при создании
//                                                              объекта ОписаниеОповещения.
// 	ПаролиСертификатов - см. НовыеПаролиСертификатов
Процедура Расшифровать(ОписаниеДанных, КонтекстДиагностики, Форма = Неопределено, Оповещение = Неопределено,
	ПаролиСертификатов = Неопределено) Экспорт
	
	ПередВыполнениемКриптографическойОперации(ОписаниеДанных, ПаролиСертификатов);
	
	Контекст = Новый Структура;
	Контекст.Вставить("ВидОперации", НСтр("ru = 'Расшифровка данных'"));
	Контекст.Вставить("Оповещение", Оповещение);
	Контекст.Вставить("КонтекстДиагностики", КонтекстДиагностики);
	Контекст.Вставить("ПаролиСертификатов", ПаролиСертификатов);
	СлужебноеОповещение = Новый ОписаниеОповещения("ПослеВыполненияКриптографическойОперации",
		КриптографияБЭДСлужебныйКлиент, Контекст);
	ЭлектроннаяПодписьКлиент.Расшифровать(ОписаниеДанных, Форма, СлужебноеОповещение);
	
КонецПроцедуры

// Проверяет действительность подписи и сертификата.
// 
// Параметры:
// 	ОповещениеОЗавершении - ОписаниеОповещения - содержит описание процедуры, которая будет вызвана после расшифровки
//                                               со следующими параметрами:
//   * Результат - см. КриптографияБЭДКлиентСервер.НовыйРезультатПроверкиПодписи
//   * ДополнительныеПараметры - Произвольный - значение, которое было указано при создании
//                                              объекта ОписаниеОповещения.
// 	ИсходныеДанные - см. ЭлектроннаяПодписьКлиент.ПроверитьПодпись.ИсходныеДанные
// 	Подпись - см. ЭлектроннаяПодписьКлиент.ПроверитьПодпись.Подпись
// 	КонтекстДиагностики - см. ОбработкаНеисправностейБЭДКлиент.НовыйКонтекстДиагностики
// 	МенеджерКриптографии - см. ЭлектроннаяПодписьКлиент.ПроверитьПодпись.МенеджерКриптографии
Процедура ПроверитьПодпись(ОповещениеОЗавершении, ИсходныеДанные, Подпись, КонтекстДиагностики, МенеджерКриптографии = Неопределено) Экспорт
	
	РезультатПроверки = КриптографияБЭДКлиентСервер.НовыйРезультатПроверкиПодписи();
	
	Контекст = Новый Структура;
	Контекст.Вставить("ВидОперации", НСтр("ru = 'Проверка подписи'"));
	Контекст.Вставить("Подпись", Подпись);
	Контекст.Вставить("ИсходныеДанные", ИсходныеДанные);
	Контекст.Вставить("МенеджерКриптографии", МенеджерКриптографии);
	Контекст.Вставить("ОповещениеОЗавершении", ОповещениеОЗавершении);
	Контекст.Вставить("РезультатПроверки", РезультатПроверки);
	Контекст.Вставить("КонтекстДиагностики", КонтекстДиагностики);
	
	Оповещение = Новый ОписаниеОповещения("ПроверитьПодписьПослеПолученияМенеджераКриптографии",
		КриптографияБЭДСлужебныйКлиент, Контекст, "ОбработатьОшибкуПолученияМенеджераКриптографии",
		КриптографияБЭДСлужебныйКлиент);
	
	Если МенеджерКриптографии <> Неопределено Тогда
		ВыполнитьОбработкуОповещения(Оповещение, МенеджерКриптографии);
		Возврат;
	КонецЕсли;
	
	Попытка
		СертификатыПолучены = Ложь;
		Сертификаты = КриптографияБЭДВызовСервера.ПолучитьСертификатыИзПодписи(Подпись, СертификатыПолучены);
		СертификатыКриптографии = Новый Массив;
		Для каждого Сертификат Из Сертификаты Цикл
			СертификатыКриптографии.Добавить(Новый СертификатКриптографии(Сертификат));
		КонецЦикла;
	Исключение
		КриптографияБЭДСлужебныйКлиент.ОбработатьОшибкуВыгрузкиСертификата(ОписаниеОшибки(), Ложь, Контекст);
		Возврат;
	КонецПопытки;
	
	Если Не СертификатыПолучены Тогда
		ЭлектроннаяПодписьКлиент.СоздатьМенеджерКриптографии(Оповещение, "ПроверкаПодписи", Ложь);
		Возврат;
	КонецЕсли;
	
	Оповещение = Новый ОписаниеОповещения("ПроверитьПодписьПослеПолученияСертификатовИзПодписи",
		КриптографияБЭДСлужебныйКлиент, Контекст);
	ВыполнитьОбработкуОповещения(Оповещение, СертификатыКриптографии);
	
КонецПроцедуры

// Открывает форму для заполнения программы в сертификате, которая выглядит как форма подписания.
// Для вызова перед операцией подписания.
// 
// Параметры:
//  ОповещениеОЗавершении - ОписаниеОповещения - содержит описание процедуры, которая будет вызвана после выполнения
//                                               метода со следующими параметрами:
//   # РезультатЗаполнения - Структура:
//     ## - Результат - Булево - если Истина, программу удалось заполнить, если Ложь - отказались от операции.
//     ## - Сертификат - СправочникСсылка.СертификатыКлючейЭлектроннойПодписиИШифрования - выбранный сертификат.
//     ## - Пароль - Строка - пароль, введенный в форме.
//               - Неопределено - если заполнение программы не требуется
//   # ДополнительныеПараметры - Произвольный - значение, которое было указано при создании
//                                              объекта ОписаниеОповещения.
//  ОписаниеДанных - см. Подписать.ОписаниеДанных
Процедура ЗаполнитьПрограммуВСертификате(ОповещениеОЗавершении, ОписаниеДанных) Экспорт
	
	ЗаголовокФормы = ОбщегоНазначенияКлиентСервер.СвойствоСтруктуры(ОписаниеДанных, "Операция",
		НСтр("ru = 'Заполнение программы в сертификате ЭП'"));
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Заголовок", ЗаголовокФормы);
	ПараметрыФормы.Вставить("Сертификаты", ОписаниеДанных.ОтборСертификатов);
	
	ФормаЗаполненияПрограммы = ОткрытьФорму("Обработка.КриптографияБЭД.Форма.ЗаполнениеПрограммыВСертификате",
		ПараметрыФормы,,,,, ОповещениеОЗавершении, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
	Если ФормаЗаполненияПрограммы <> Неопределено Тогда
		ТребуетсяЗаполнениеПрограммы = Истина;
		ФормаЗаполненияПрограммы.ПродолжитьОткрытие(ОписаниеДанных);
	Иначе
		ТребуетсяЗаполнениеПрограммы = Ложь;
	КонецЕсли;
		
	Если Не ТребуетсяЗаполнениеПрограммы Тогда
		ВыполнитьОбработкуОповещения(ОповещениеОЗавершении, Неопределено);
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработатьОшибкиКриптографическойОперации(Результат, ВидОперации, КонтекстДиагностики) Экспорт
	КриптографияБЭДСлужебныйКлиент.ОбработатьОшибкиКриптографическойОперации(Результат, ВидОперации, КонтекстДиагностики);
КонецПроцедуры

#КонецОбласти

#Область Сертификаты

// Устанавливает пароли в хранилище паролей на клиенте на время сеанса.
// 
// Параметры:
// 	ДанныеСертификатов - Массив из см. СинхронизацияЭДО.НовыеДанныеСертификата
// 	Установить - Булево - если Истина - пароли будут установлены, иначе - сброшены
Процедура УстановитьПаролиСертификатов(ДанныеСертификатов, Установить = Истина) Экспорт
	
	Для каждого ДанныеСертификата Из ДанныеСертификатов Цикл
		
		Если Установить И ДанныеСертификата.Значение.ПарольПолучен
			И ДанныеСертификата.Значение.ПарольПользователя <> Неопределено Тогда
			ЭлектроннаяПодписьКлиент.УстановитьПарольСертификата(ДанныеСертификата.Ключ,
				ДанныеСертификата.Значение.ПарольПользователя);
		ИначеЕсли Не Установить Тогда
			ЭлектроннаяПодписьКлиент.УстановитьПарольСертификата(ДанныеСертификата.Ключ, Неопределено);
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

// Возвращает пароли сертификатов.
// 
// Возвращаемое значение:
// 	Соответствие из КлючИЗначение:
//    * Ключ - СправочникСсылка.СертификатыКлючейЭлектроннойПодписиИШифрования - сертификат
//    * Значение - Произвольный - пароль
Функция НовыеПаролиСертификатов() Экспорт
	
	Возврат Новый Соответствие;
	
КонецФункции

// Ищет сертификат в справочнике СертификатыКлючейЭлектроннойПодписиИШифрования, если не находит - создает новый.
// 
// Параметры:
// 	Отпечаток - Строка - отпечаток сертификата в кодировке Base64.
// 	Организация - ОпределяемыйТип.Организация - организация, которой будет принадлежать созданный сертификат.
// 	Оповещение - ОписаниеОповещения - описание процедуры, которая будет вызвана после поиска сертификата со следующими
//               параметрами:
//                 * Сертификат - СправочникСсылка.СертификатыКлючейЭлектроннойПодписиИШифрования - найденный
//                                 или новый сертификат.
//                 * ДополнительныеПараметры - Произвольный - значение, которое было указано при создании
//                                 объекта ОписаниеОповещения.
Процедура НайтиСоздатьСертификатКриптографии(Отпечаток, Организация, Оповещение) Экспорт
	
	КриптографияБЭДСлужебныйКлиент.НайтиСоздатьСертификатКриптографии(Отпечаток, Организация, Оповещение)
	
КонецПроцедуры

// Получает сертификат в формате CER из сертификата в формате PEM.
// 
// Параметры:
// 	СтрокаPEM - Строка - сертификат в формате PEM.
// Возвращаемое значение:
// 	ДвоичныеДанные
Функция СертификатИзСтрокиPEM(СтрокаPEM) Экспорт
	
	ТегНачало = КриптографияБЭДСлужебныйКлиентСервер.ТегНачалоСертификата();
	ТегКонец = КриптографияБЭДСлужебныйКлиентСервер.ТегКонецСертификата();
	Если СтрНайти(СтрокаPEM, ТегНачало) > 0 Тогда
		СтрокаPEM = СтрЗаменить(СтрокаPEM, ТегНачало, "");
		СтрокаPEM = СтрЗаменить(СтрокаPEM, ТегКонец, "");
		СтрокаPEM = СокрЛП(СтрокаPEM);
	КонецЕсли;
	ТекстСертификата = СтрЗаменить(СтрокаPEM, " ", ""); // из-за пробелов получаются пустые двоичные данные
	
	Возврат Base64Значение(ТекстСертификата);
	
КонецФункции

// Получает пересечение массива сертификатов, установленных в личном хранилище
// с массивом сертификатов зарегистрированных в 1с (действующих и доступных текущему пользователю).
// 
// Параметры:
// 	Оповещение - ОписаниеОповещения - описание процедуры, которая будет вызвана после получения сертификатов
//               со следующими параметрами:
//                 * Результат - Массив из СправочникСсылка.СертификатыКлючейЭлектроннойПодписиИШифрования.
//                 * ДополнительныеПараметры - Произвольный - значение, которое было указано при создании
//                                             объекта ОписаниеОповещения.
Процедура ПолучитьДоступныеСертификаты(Оповещение) Экспорт
	
	Контекст = Новый Структура;
	Контекст.Вставить("Оповещение", Оповещение);
	ОповещениеПослеПолученияОтпечатков = Новый ОписаниеОповещения(
		"ПолучитьДоступныеСертификатыПослеПолученияОтпечатков", КриптографияБЭДСлужебныйКлиент, Контекст);
	
	ПолучитьОтпечаткиСертификатов(ОповещениеПослеПолученияОтпечатков);
	
КонецПроцедуры

// Открывает форму выбора сертификатов.
// 
// Параметры:
// 	Оповещение - ОписаниеОповещения - содержит описание процедуры, которая будет вызвана после выбора сертификата
// 	             со следующими параметрами:
// 	               * Сертификат - СправочникСсылка.СертификатыКлючейЭлектроннойПодписиИШифрования - выбранный сертификат.
// 	               * ДополнительныеПараметры - Произвольный - значение, которое было указано при создании объекта 
// 	                                           ОписаниеОповещения.
// 	Отбор - см. НовыйОтборСпискаСертификатов
Процедура ОткрытьФормуВыбораСертификатов(Оповещение, Отбор = Неопределено) Экспорт
	
	Если Отбор = Неопределено Тогда
		Отбор = НовыйОтборСпискаСертификатов();
	КонецЕсли;
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Отбор", Новый Структура);
	
	Для Каждого ЭлементОтбора Из Отбор Цикл
		Если ЭлементОтбора.Значение <> Неопределено Тогда
			ПараметрыФормы.Отбор.Вставить(ЭлементОтбора.Ключ, ЭлементОтбора.Значение);
		КонецЕсли;
	КонецЦикла;
	
	ОткрытьФорму("Справочник.СертификатыКлючейЭлектроннойПодписиИШифрования.ФормаВыбора",
		ПараметрыФормы,,,,, Оповещение);
	
КонецПроцедуры

// Возвращает отбор, который используется при открытии формы выбора сертификатов, см. ОткрытьФормуВыбораСертификатов.
// 
// Возвращаемое значение:
// 	Структура:
// * Организация - СписокЗначений:
//   ** Значение - ОпределяемыйТип.Организация
//   ОпределяемыйТип.Организация
Функция НовыйОтборСпискаСертификатов() Экспорт
	
	Отбор = Новый Структура;
	Отбор.Вставить("Организация", Неопределено);
	
	Возврат Отбор;
	
КонецФункции

// Определяет программу сертификата.
// 
// Параметры:
// 	Сертификат - ДвоичныеДанные
// 	           - Строка - полное имя файла
// 	Пароль - Строка
// 	Оповещение - ОписаниеОповещения
Процедура ОпределитьПрограммуСертификата(Сертификат, Пароль, Оповещение) Экспорт
	
	Контекст = Новый Структура;
	Контекст.Вставить("Оповещение", Оповещение);
	Контекст.Вставить("Пароль", Пароль);
	
	ОбработкаЗавершения = Новый ОписаниеОповещения("ОпределитьПрограммуСертификатаПослеИнициализацииСертификата",
		КриптографияБЭДСлужебныйКлиент, Контекст);
		
	СертификатДляИнициализации = Новый СертификатКриптографии;
	СертификатДляИнициализации.НачатьИнициализацию(ОбработкаЗавершения, Сертификат);
	
КонецПроцедуры

// Открывает форму редактирования пароля сертификата.
// 
// Параметры:
// 	ПараметрыФормы - см. НовыеПараметрыОткрытияФормыРедактированияПароляСертификата
// 	ПараметрыОткрытияФормы - см. ОбщегоНазначенияБЭДКлиент.ОткрытьФормуБЭД.ПараметрыОткрытияФормы
Процедура ОткрытьФормуРедактированияПароляСертификата(ПараметрыФормы, ПараметрыОткрытияФормы = Неопределено) Экспорт
	
	ОбщегоНазначенияБЭДКлиент.ОткрытьФормуБЭД("Обработка.КриптографияБЭД.Форма.ЗаписьПароляСертификата",
		ПараметрыФормы, ПараметрыОткрытияФормы);
	
КонецПроцедуры

// Возвращает параметры открытия формы см. ОткрытьФормуРедактированияПароляСертификата.
// 
// Возвращаемое значение:
// 	Структура:
// * Сертификат - СправочникСсылка.СертификатыКлючейЭлектроннойПодписиИШифрования
// * СохранятьДляВсех - Булево
Функция НовыеПараметрыОткрытияФормыРедактированияПароляСертификата() Экспорт
	
	Параметры = Новый Структура;
	Параметры.Вставить("Сертификат", ПредопределенноеЗначение(
		"Справочник.СертификатыКлючейЭлектроннойПодписиИШифрования.ПустаяСсылка"));
	Параметры.Вставить("СохранятьДляВсех", Ложь);
	
	Возврат Параметры;
	
КонецФункции

// Получает свойства субъекта сертификата электронной подписи.
//
// Параметры:
//  Сертификат - СертификатКриптографии
//
// Возвращаемое значение:
//  См. ЭлектроннаяПодписьКлиент.СвойстваСубъектаСертификата
//
Функция СвойстваСубъектаСертификата(СертификатКриптографии) Экспорт
	
	Свойства = ЭлектроннаяПодписьКлиент.СвойстваСубъектаСертификата(СертификатКриптографии);
	
	КриптографияБЭДСлужебныйКлиентСервер.ЗаполнитьВСвойствахСертификатаИННПоИННЮЛ(Свойства);
	
	Возврат Свойства;
	
КонецФункции

// Возвращает ИНН субъекта сертификата без лидирующих нолей.
//
// Параметры:
//  Сертификат - СертификатКриптографии
//
// Возвращаемое значение:
//  Строка - ИНН субъекта сертификата без лидирующих нолей.
//
Функция ИННСубъектаСертификата(СертификатКриптографии) Экспорт
	
	СвойстваСубъекта = СвойстваСубъектаСертификата(СертификатКриптографии);
	Возврат СвойстваСубъекта.ИНН;
	
КонецФункции

#КонецОбласти

#Область Настройки

// Возвращает настройки криптографии.
// 
// Возвращаемое значение:
// 	Структура - Описание:
// * ИспользоватьЭлектронныеПодписи - Булево - используются электронные подписи.
// * ПроверятьПодписиНаСервере - Булево - проверка подписей выполняется на сервере.
// * ПодписыватьНаСервере - Булево - подписание выполняется на сервере.
Функция НастройкиКриптографии() Экспорт
	
	Настройки = Новый Структура;
	
	#Если МобильныйКлиент Тогда
		Настройки.Вставить("ПодписыватьНаСервере", Истина);
		Настройки.Вставить("ПроверятьПодписиНаСервере", Истина);
	#Иначе
		Настройки = Новый Структура;
		Настройки.Вставить("ПодписыватьНаСервере", ЭлектроннаяПодписьКлиент.СоздаватьЭлектронныеПодписиНаСервере());
		Настройки.Вставить("ПроверятьПодписиНаСервере", ЭлектроннаяПодписьКлиент.ПроверятьЭлектронныеПодписиНаСервере());
	#КонецЕсли
	Настройки.Вставить("ИспользоватьЭлектронныеПодписи", ЭлектроннаяПодписьКлиент.ИспользоватьЭлектронныеПодписи());
	
	Возврат Настройки;
	
КонецФункции

// Проверяет возможность использования сертификатов пользователя в облачном сервисе.
//
// Возвращаемое значение:
//  Булево - использование сертификатов пользователя в облачном сервисе возможно.
//
Функция ИспользованиеСертификатовОблачногоСервисаВозможно() Экспорт
	
	Возврат КриптографияБЭДКлиентПовтИсп.ИспользованиеСертификатовОблачногоСервисаВозможно();
	
КонецФункции

#КонецОбласти

#Область УстановкаКриптопровайдеров

Процедура УстановитьCryptoPRO(ОповещениеОЗавершении, Форма) Экспорт
	
	СистемнаяИнформация = Новый СистемнаяИнформация;
	Если СистемнаяИнформация.ТипПлатформы = ТипПлатформы.Windows_x86
		ИЛИ СистемнаяИнформация.ТипПлатформы = ТипПлатформы.Windows_x86_64 Тогда
		Контекст = Новый Структура;
		Контекст.Вставить("ОповещениеОЗавершении", ОповещениеОЗавершении);
		Контекст.Вставить("ВладелецФормы", Форма.ВладелецФормы);
		Контекст.Вставить("Форма", Форма);
		Оповещение = Новый ОписаниеОповещения("УстановитьCryptoProCSPПослеВводаРегистрационныхДанных",
			КриптографияБЭДСлужебныйКлиент, Контекст);
		
		ОткрытьФорму(
			"Обработка.КриптографияБЭД.Форма.УстановкаCryptoProCSPРегистрационныеДанные",,
			Форма.ВладелецФормы,,,, Оповещение);
	Иначе
		ОписаниеОшибки = НСтр("ru = 'Автоматическая установка CryptoPro CSP возможно только на операционных системах семейства Windows.'");
		ПоказатьПредупреждение(, ОписаниеОшибки,, НСтр("ru = 'Установка CryptoPro CSP'"));
		РезультатВыполнения = Новый Структура;
		РезультатВыполнения.Вставить("Выполнено", Ложь);
		РезультатВыполнения.Вставить("ОписаниеОшибки", ОписаниеОшибки);
		
		ВыполнитьОбработкуОповещения(ОповещениеОЗавершении, РезультатВыполнения);
	КонецЕсли;

КонецПроцедуры

Процедура УстановитьVipNet(ОповещениеОЗавершении, Форма) Экспорт
	
	// Переход на сайт VipNet вместо скачивания дистрибутива.
	ФайловаяСистемаКлиент.ОткрытьНавигационнуюСсылку("https://infotecs.ru/downloads/besplatnye-produkty/vipnet-csp.html");
	ВыполнитьОбработкуОповещения(ОповещениеОЗавершении, Неопределено);

КонецПроцедуры

#КонецОбласти

#Область Прочее

// Проверяет наличие установленных программ криптографии на клиенте и на сервере.
// 
// Параметры:
// 	Оповещение - ОписаниеОповещения - описание процедуры, которую необходимо выполнить после проверки наличия программ
// 	             со следующими параметрами:
//               * ЕстьПрограммаКриптографии - Булево - если Истина - на клиенте или на сервере установлена программа
//                                             криптографии.
//               * ДополнительныеПараметры - Произвольный - значение, которое было указано при создании
//                                 объекта ОписаниеОповещения.
Процедура ПроверитьНаличиеУстановленныхПрограмм(Оповещение) Экспорт
	
	Контекст = Новый Структура;
	Контекст.Вставить("Оповещение", Оповещение);
	
	Оповещение = Новый ОписаниеОповещения("ПроверитьНаличиеУстановленныхПрограммПослеПоискаУстановленныхПрограмм",
		КриптографияБЭДСлужебныйКлиент, Контекст);
	ЭлектроннаяПодписьКлиент.НайтиУстановленныеПрограммы(Оповещение, Новый Массив, Истина);
	
КонецПроцедуры

// Выполняет проверку сертификата.
// 
// Параметры:
// 	Сертификат - СправочникСсылка.СертификатыКлючейЭлектроннойПодписиИШифрования - проверяемый сертификат
// 	ВладелецФормы - ФормаКлиентскогоПриложения
// 	ПроверитьАвторизацию - Булево - если Истина, то к проверкам сертификата будет добавлен тест связи
//                                  с сервером Такском.
// 	ПроверкаПриВыборе - Булево - если Истина, тогда кнопка Проверить будет называться
//                                  "Проверить и продолжить", а кнопка Закрыть будет называться "Отмена".
// 	БезПодтверждения - Булево - если установить Истина, тогда при наличии пароля
//                            проверка будет выполнена сразу без открытия формы.
//                            Если режим ПроверкаПриВыборе и установлен параметр ОбработкаРезультата, то
//                            форма не будет открыта, если параметр ПроверкиПройдены установлен Истина.
// 	ОбработкаЗавершения - ОписаниеОповещения - содержит описание процедуры, которая будет вызвана после выполнения
//                                             проверок со следующими параметрами:
//                          * Результат - Неопределено, Булево - проверки выполнены.
//                          * ДополнительныеПараметры - Произвольный - значение, которое было указано при создании
//                                                      объекта ОписаниеОповещения.
Процедура ТестНастроекСПроверкойСертификата(Сертификат, ВладелецФормы, ПроверитьАвторизацию,
	ПроверкаПриВыборе, БезПодтверждения, ОбработкаЗавершения = Неопределено) Экспорт
	
	Контекст = Новый Структура;
	Контекст.Вставить("ОбработкаЗавершения", ОбработкаЗавершения);
	
	ДополнительныеПараметры = Новый Структура;
	ОбработкаРезультата = Новый ОписаниеОповещения("ОбработкаРезультатаТестаСертификата",
		КриптографияБЭДСлужебныйКлиент, ДополнительныеПараметры);
	
	ДополнительныеПараметры.Вставить("ВладелецФормы",       Неопределено);
	ДополнительныеПараметры.Вставить("ПроверкаПриВыборе",   ПроверкаПриВыборе);
	ДополнительныеПараметры.Вставить("БезПодтверждения",    БезПодтверждения);
	
	ДополнительныеПараметры.Вставить("ОбработкаРезультата", ОбработкаРезультата);
	
	ЗаголовокФормы = НСтр("ru = 'Проверка сертификата %1'");
	ЗаголовокФормы = СтрЗаменить(ЗаголовокФормы, "%1", Сертификат);
	ДополнительныеПараметры.Вставить("ЗаголовокФормы", ЗаголовокФормы);
	ДополнительныеПараметры.Вставить("ОбработкаЗавершения",
		Новый ОписаниеОповещения("ОбработкаЗавершенияТестаСертификата", КриптографияБЭДСлужебныйКлиент, Контекст));
	
	Контекст.Вставить("ДополнительныеПараметры", ДополнительныеПараметры);
	
	ЭлектроннаяПодписьКлиент.ПроверитьСертификатСправочника(Сертификат, ДополнительныеПараметры);
	
КонецПроцедуры

#КонецОбласти

#Область ДляВызоваИзДругихПодсистем

// ЭлектронноеВзаимодействие.БазоваяФункциональность.ОбработкаНеисправностей

// Открывает форму исправления ошибок с отображением сертификатов криптографии.
// 
// Параметры:
// 	КонтекстДиагностики - см. ОбработкаНеисправностейБЭДКлиент.НовыйКонтекстДиагностики
// 	ДополнительныеПараметры - Произвольный - см. ключ ПараметрыОбработчиков структуры, возвращаемой методом
//                                           см. ОбработкаНеисправностейБЭДКлиентСервер.НовоеОписаниеВидаОшибки
Процедура ОткрытьСписокОшибокПоСертификатам(КонтекстДиагностики, ДополнительныеПараметры) Экспорт
	
	Ошибки = ОбработкаНеисправностейБЭДКлиентСервер.ПолучитьОшибки(КонтекстДиагностики);
	ДополнительныеДанные = ОбработкаНеисправностейБЭДКлиентСервер.ЗначенияСвойствОшибок(Ошибки, "ДополнительныеДанные");
	
	Сертификаты = Новый Массив;
	Для каждого Элемент Из ДополнительныеДанные Цикл
		Если Сертификаты.Найти(Элемент.Сертификат) = Неопределено Тогда
			Сертификаты.Добавить(Элемент.Сертификат);
		КонецЕсли;
	КонецЦикла;
	
	ПараметрыИсправленияОшибок = ОбработкаНеисправностейБЭДКлиент.НовыеПараметрыИсправленияОшибок();
	ПараметрыИсправленияОшибок.СкрытьКнопкуПросмотреть = Истина;
	
	Если Ошибки.Количество() > 0 Тогда
		ПараметрыИсправленияОшибок.Заголовок = Ошибки[0].ВидОшибки.ЗаголовокПроблемы;
	КонецЕсли;
	
	Команда = ОбработкаНеисправностейБЭДКлиент.НовоеОписаниеКомандыФормыИсправленияОшибок();
	Команда.Заголовок = НСтр("ru = 'Посмотреть сертификат'");
	Команда.Обработчик = "ОбработкаНеисправностейБЭДКлиент.ОткрытьЭлементТаблицы";
	
	ПараметрыИсправленияОшибок.Команды.Добавить(Команда);
	
	ОбработкаНеисправностейБЭДКлиент.ИсправитьОшибки(Сертификаты, ПараметрыИсправленияОшибок);
	
КонецПроцедуры

// Конец ЭлектронноеВзаимодействие.БазоваяФункциональность.ОбработкаНеисправностей

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ПередВыполнениемКриптографическойОперации(ОписаниеДанных, ПаролиСертификатов)
	
	КонтекстОперации = ОбщегоНазначенияКлиентСервер.СвойствоСтруктуры(ОписаниеДанных, "КонтекстОперации");
	Если КонтекстОперации = Неопределено Тогда
		ОтборСертификатов = ОбщегоНазначенияКлиентСервер.СвойствоСтруктуры(ОписаниеДанных, "ОтборСертификатов",
			Новый Массив);
		Для Каждого Сертификат Из ОтборСертификатов Цикл
			Если ПаролиСертификатов <> Неопределено И ПаролиСертификатов[Сертификат] <> Неопределено Тогда
				ОписаниеДанных.Вставить("КонтекстОперации", ПаролиСертификатов[Сертификат]);
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти