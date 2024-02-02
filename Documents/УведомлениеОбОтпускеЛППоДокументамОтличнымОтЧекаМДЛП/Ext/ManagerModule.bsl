﻿
#Область ОбработчикиСобытий

Процедура ОбработкаПолученияФормы(ВидФормы, Параметры, ВыбраннаяФорма, ДополнительнаяИнформация, СтандартнаяОбработка)
	
	ИнтеграцияМДЛПВызовСервера.ПриПолученииФормыДокумента(
		ПустаяСсылка(), ВидФормы, Параметры, ВыбраннаяФорма, ДополнительнаяИнформация, СтандартнаяОбработка);
	
КонецПроцедуры

#КонецОбласти

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область ДействияПриОбмене

Функция ОбновитьСтатусПослеПодготовкиКПередачеДанных(ДокументСсылка, Операция) Экспорт
	
	Возврат ИнтеграцияМДЛП.ОбновитьСтатусПослеПодготовкиКПередачеДанных(ДокументСсылка, Операция);
	
КонецФункции

Функция ОбновитьСтатусПослеПередачиДанных(ДокументСсылка, Операция, СтатусОбработки) Экспорт
	
	Возврат ИнтеграцияМДЛП.ОбновитьСтатусПослеПередачиДанных(ДокументСсылка, Операция, СтатусОбработки);
	
КонецФункции

Функция ОбновитьСтатусПослеПолученияДанных(ДокументСсылка, Операция, ДанныеКвитанции = Неопределено) Экспорт
	
	Возврат ИнтеграцияМДЛП.ОбновитьСтатусПослеПолученияДанных(ДокументСсылка, Операция, ДанныеКвитанции);
	
КонецФункции

Процедура ОбновитьСостояниеПодтверждения(ДокументОбъект, Операция, Сообщение, СтатусОбработки, ОтклоненныеНомера = Неопределено) Экспорт
	
	ПараметрыОбновления = ИнтеграцияМДЛП.СостояниеПодтверждения(Операция, Сообщение, СтатусОбработки);
	
	Если ПараметрыОбновления = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ДокументОбъект.СостояниеПодтверждения = ПараметрыОбновления.Состояние;
	Если ДокументОбъект.СостояниеПодтверждения <> Перечисления.СостоянияПодтвержденияМДЛП.ОтклоненоГИСМ
	   И ЗначениеЗаполнено(ОтклоненныеНомера) Тогда
		
		Для Каждого Номер Из ОтклоненныеНомера Цикл
			Строка = ДокументОбъект.НомераУпаковок.Найти(Номер.Ключ, "НомерКиЗ");
			Строка.Отклонено = Истина;
			Строка.ПричинаОтказа = ИнтеграцияМДЛП.ПредставлениеПричиныОтклонения(Номер.Значение);
		КонецЦикла;
		
	КонецЕсли;
	
КонецПроцедуры

// Расчет статуса оформления при смене статуса информирования.
//
// Параметры:
//  ДокументСсылка - ДокументСсылка.УведомлениеОбОтпускеЛППоДокументамОтличнымОтЧека - Документ, по которому требуется рассчитать статус оформления.
//  ПредыдущийСтатус - ПеречислениеСсылка.СтатусыИнформирования - Предыдущий статус.
//  НовыйСтатус - ПеречислениеСсылка.СтатусыИнформирования - Новый статус.
//
Процедура РассчитатьСтатусОформления(ДокументСсылка, ПредыдущийСтатус, НовыйСтатус) Экспорт
	
	Основание = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ДокументСсылка, "Основание");
	Если ЗначениеЗаполнено(Основание) Тогда
		ИнтеграцияМДЛППереопределяемый.РассчитатьСтатусОформленияУведомленияОбОтпускеЛППоДокументамОтличнымОтЧека(Основание);
	КонецЕсли;
	
КонецПроцедуры

// Получить последовательность операций в течении жизненного цикла документа.
// 
// Возвращаемое значение:
//  ТаблицаЗначений - см. функцию ИнтеграцияМДЛП.ПустаяТаблицаПоследовательностьОпераций().
//
Функция ПоследовательностьОпераций(ДокументСсылка) Экспорт
	
	Таблица = ИнтеграцияМДЛП.ПустаяТаблицаПоследовательностьОпераций();
	
	Исходящее = Перечисления.ТипыСообщенийМДЛП.Исходящее;
	
	Операция = ИнтеграцияМДЛП.ДобавитьОперациюВПоследовательность(Таблица, 0, Исходящее, Перечисления.ОперацииОбменаМДЛП.ПередачаДанных_ОтпускЛППоДокументамОтличнымОтЧека);
	
	Возврат Таблица;
	
КонецФункции

#КонецОбласти

#Область Статусы

// Возвращает статус информирования по умолчанию.
// 
// Возвращаемое значение:
//  Перечисления.СтатусыИнформированияМДЛП - Статус по-умолчанию.
//
Функция СтатусИнформированияПоУмолчанию() Экспорт
	
	Возврат Перечисления.СтатусыИнформированияМДЛП.Черновик;
	
КонецФункции

// Возвращает дальнейшее действие по умолчанию.
// 
// Возвращаемое значение:
//  Перечисления.ДальнейшиеДействияПоВзаимодействиюМДЛП - Дальнейшее действие по-умолчанию.
//
Функция ДальнейшееДействиеПоУмолчанию() Экспорт
	
	Возврат Перечисления.ДальнейшиеДействияПоВзаимодействиюМДЛП.ПередайтеДанные;
	
КонецФункции

// Возвращает запрос для получения статуса оформления.
//
// Параметры:
//  ДокументОснование - ДокументСсылка - Документ основание.
// 
// Возвращаемое значение:
//  Запрос - Запрос для получения статуса оформления.
//
Функция ЗапросСтатусаОформления(ДокументОснование) Экспорт
	
	Запрос = ИнтеграцияМДЛППереопределяемый.ЗапросСтатусаОформленияУведомленияОбОтпускеЛППоДокументамОтличнымОтЧека(ДокументОснование);
	
	Возврат Запрос;
	
КонецФункции

#КонецОбласти

#Область ПанельМаркировкиМДЛП

Функция ВсеТребующиеДействия(Все = Ложь) Экспорт
	
	Действия = Новый Массив;
	Действия.Добавить(Перечисления.ДальнейшиеДействияПоВзаимодействиюМДЛП.ПередайтеДанные);
	Если Все Или Не ПолучитьФункциональнуюОпцию("ИспользоватьАвтоматическуюОтправкуПолучениеДанныхМДЛП") Тогда
		Действия.Добавить(Перечисления.ДальнейшиеДействияПоВзаимодействиюМДЛП.ВыполнитеОбмен);
	КонецЕсли;
	Действия.Добавить(Перечисления.ДальнейшиеДействияПоВзаимодействиюМДЛП.ПолучитеКвитанциюОФиксации);
	
	Возврат Действия;
	
КонецФункции

Функция ВсеТребующиеОжидания(Все = Ложь) Экспорт
	
	Действия = Новый Массив;
	Действия.Добавить(Перечисления.ДальнейшиеДействияПоВзаимодействиюМДЛП.ОжидайтеПолучениеКвитанцииОФиксации);
	Если Все Или ПолучитьФункциональнуюОпцию("ИспользоватьАвтоматическуюОтправкуПолучениеДанныхМДЛП") Тогда
		Действия.Добавить(Перечисления.ДальнейшиеДействияПоВзаимодействиюМДЛП.ОжидайтеПередачуДанныхРегламентнымЗаданием);
	КонецЕсли;
	
	Возврат Действия;
	
КонецФункции

Процедура ПриЗаполненииДокументовПанелиМаркировкиМДЛП(ТаблицаДокументы) Экспорт
	
	Описание = ИнтеграцияМДЛП.ДобавитьДокументНаПанельМаркировки(
		ТаблицаДокументы,
		Метаданные.Документы.УведомлениеОбОтпускеЛППоДокументамОтличнымОтЧекаМДЛП,
		НСтр("ru = 'Отпуск ЛП по документам, отличным от кассового чека'"),
		ИнтеграцияМДЛПКлиентСервер.ПанельМаркировкаРазделПродажи());
	
	Описание.Оформите    = Истина;
	Описание.Отработайте = Истина;
	Описание.Ожидайте    = Истина;
	
	Описание.Порядок = 40;
	
КонецПроцедуры

// Возвращает текст запроса для получения количества документов для оформления
// 
// Возвращаемое значение:
//  Строка - Текст запроса
//
Функция ПанельМаркировкиМДЛПТекстЗапросаОформите() Экспорт
	
	Возврат ИнтеграцияМДЛППереопределяемый.УведомлениеОбОтпускеЛППоДокументамОтличнымОтЧекаТекстЗапросаОформите();
	
КонецФункции

// Возвращает текст запроса для получения количества документов для отработки
// 
// Возвращаемое значение:
//  Строка - Текст запроса
//
Функция ПанельМаркировкиМДЛПТекстЗапросаОтработайте() Экспорт
	
	Возврат Обработки.ПанельМаркировкиМДЛП.ТекстЗапросаОтработайте(Метаданные.Документы.УведомлениеОбОтпускеЛППоДокументамОтличнымОтЧекаМДЛП);
	
КонецФункции

// Возвращает текст запроса для получения количества документов, находящихся в состоянии ожидания
// 
// Возвращаемое значение:
//  Строка - Текст запроса
//
Функция ПанельМаркировкиМДЛПТекстЗапросаОжидайте() Экспорт
	
	Возврат Обработки.ПанельМаркировкиМДЛП.ТекстЗапросаОжидайте(Метаданные.Документы.УведомлениеОбОтпускеЛППоДокументамОтличнымОтЧекаМДЛП);
	
КонецФункции

// Возвращает текст запроса для формирования данных динамического списка формы списка и формы выбора документов.
// 
// Возвращаемое значение:
//  Строка - Текст запроса
//
Функция ПанельМаркировкиМДЛПТекстЗапросаДинамическогоСписока() Экспорт
	
	Возврат Обработки.ПанельМаркировкиМДЛП.ТекстЗапросаДинамическогоСпискаФормДокументов(ПустаяСсылка().Метаданные());
	
КонецФункции

// Возвращает текст запроса для формирования данных динамического Списка к оформлению формы списка и формы выбора документов.
// 
// Возвращаемое значение:
//  Строка - Текст запроса
//
Функция ПанельМаркировкиМДЛПТекстЗапросаДинамическогоСпискаКОформлению() Экспорт
	
	ТекстЗапроса = ИнтеграцияМДЛППереопределяемый.УведомлениеОбОтпускеЛППоДокументамОтличнымОтЧекаТекстЗапросаДинамическогоСпискаКОформлению();
	Если Не ЗначениеЗаполнено(ТекстЗапроса) Тогда
		ТекстЗапроса = Обработки.ПанельМаркировкиМДЛП.ТекстЗапросаДинамическогоСпискаКОформлениюФормДокументов();
	КонецЕсли;
	
	Возврат ТекстЗапроса;
	
КонецФункции

#КонецОбласти

#Область СообщенияМДЛП

Функция СообщениеКПередаче(ДокументСсылка, ДальнейшееДействие, ДополнительныеПараметры = Неопределено) Экспорт
	
	Возврат УведомлениеОбОтпускеЛППоДокументамОтличнымОтЧека(ДокументСсылка);
	
КонецФункции

#КонецОбласти

// Возвращает данные для заполнения представления документа.
//
// Возвращаемое значение:
//  Структура - Структура со свойствами:
//  * КомандаСоздать - Строка - Представление документа, если документ требуется создать.
//  * ИмяКомандыСоздать - Строка - Имя команды "Создать".
//  * ИмяКомандыОткрыть - Строка - Имя команды "Открыть".
//  * ДокументОтсутствуетНетПравНаСоздание - Строка - Представление документа, если документ не создан.
//  * Представление - Строка - Представление документа.
//  * НесколькоДокументовПредставление - Строка - Представление документа, если их несколько.
//
Функция ПредставлениеДокумента() Экспорт
	
	ВозвращаемоеЗначение = ИнтеграцияМДЛП.ПустоеПредставлениеДокумента();
	ВозвращаемоеЗначение.КомандаСоздать                       = НСтр("ru = 'Создать уведомление об отпуске ЛП по документам, отличным от кассового чека МДЛП'");
	ВозвращаемоеЗначение.ИмяКомандыСоздать                    = "СоздатьУведомлениеОбОтпускеЛППоДокументамОтличнымОтЧекаМДЛП";
	ВозвращаемоеЗначение.ИмяКомандыОткрыть                    = "ОткрытьУведомлениеОбОтпускеЛППоДокументамОтличнымОтЧекаМДЛП";
	ВозвращаемоеЗначение.ДокументОтсутствуетНетПравНаСоздание = НСтр("ru = 'Уведомление об отпуске ЛП по документам, отличным от кассового чека МДЛП не создано'");
	ВозвращаемоеЗначение.Представление                        = НСтр("ru = 'Уведомление об отпуске ЛП по документам, отличным от кассового чека МДЛП: %1'");
	ВозвращаемоеЗначение.НесколькоДокументовПредставление     = НСтр("ru = 'Уведомление об отпуске ЛП по документам, отличным от кассового чека МДЛП (%1)'");
	
	Возврат ВозвращаемоеЗначение;
	
КонецФункции

Функция ПоддерживаетЗагрузкуУведомлений() Экспорт
	Возврат Ложь;
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция УведомлениеОбОтпускеЛППоДокументамОтличнымОтЧека(ДокументСсылка)
	
	УстановитьПривилегированныйРежим(Истина);
	
	Сообщения = Новый Массив;
	
	СообщениеКПередаче = ИнтеграцияМДЛП.СтруктураСообщенияКПередаче();
	СообщениеКПередаче.Документ = ДокументСсылка;
	СообщениеКПередаче.Операция = Перечисления.ОперацииОбменаМДЛП.ПередачаДанных_ОтпускЛППоДокументамОтличнымОтЧека;
	
	Запрос = Новый Запрос("
	|ВЫБРАТЬ
	|	Шапка.Организация.ВерсияСхемОбмена     КАК ВерсияСхемОбмена,
	|	Шапка.Ссылка                           КАК Ссылка,
	|	Шапка.Основание                        КАК Основание,
	|	Шапка.Дата                             КАК Дата,
	|	Шапка.МестоДеятельности.Идентификатор  КАК ИдентификаторОрганизации
	|ИЗ
	|	Документ.УведомлениеОбОтпускеЛППоДокументамОтличнымОтЧекаМДЛП КАК Шапка
	|ГДЕ
	|	Шапка.Ссылка = &Ссылка
	|	И Шапка.СостояниеПодтверждения = ЗНАЧЕНИЕ(Перечисление.СостоянияПодтвержденияМДЛП.КПередаче)
	|;
	|
	|//////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ДокументыПродажи.ИдентификаторДокумента      КАК ИдентификаторДокумента,
	|	ДокументыПродажи.НомерДокумента              КАК НомерДокумента,
	|	ДокументыПродажи.ДатаДокумента               КАК ДатаДокумента,
	|	ДокументыПродажи.НомерЛьготногоРецепта       КАК НомерЛьготногоРецепта,
	|	ДокументыПродажи.ДатаЛьготногоРецепта        КАК ДатаЛьготногоРецепта,
	|	ДокументыПродажи.НомерСерииЛьготногоРецепта  КАК НомерСерииЛьготногоРецепта
	|ИЗ
	|	Документ.УведомлениеОбОтпускеЛППоДокументамОтличнымОтЧекаМДЛП.ДокументыПродажи КАК ДокументыПродажи
	|ГДЕ
	|	ДокументыПродажи.Ссылка = &Ссылка
	|УПОРЯДОЧИТЬ ПО
	|	ИдентификаторДокумента
	|;
	|
	|//////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТаблицаТовары.ИдентификаторДокумента   КАК ИдентификаторДокумента,
	|	ТаблицаТовары.GTIN                     КАК GTIN,
	|	ТаблицаНомераУпаковок.НомерКиЗ         КАК НомерКиЗ,
	|	ТаблицаНомераУпаковок.Цена             КАК Цена,
	|	ТаблицаНомераУпаковок.СуммаНДС         КАК СуммаНДС,
	|	ТаблицаНомераУпаковок.КоличествоПервичныхУпаковок     КАК КоличествоПервичныхУпаковок,
	|	ТаблицаТовары.КоличествоПервичныхУпаковокВоВторичной  КАК КоличествоПервичныхУпаковокВоВторичной
	|ИЗ
	|	Документ.УведомлениеОбОтпускеЛППоДокументамОтличнымОтЧекаМДЛП.Товары КАК ТаблицаТовары
	|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ
	|		Документ.УведомлениеОбОтпускеЛППоДокументамОтличнымОтЧекаМДЛП.НомераУпаковок КАК ТаблицаНомераУпаковок
	|	ПО
	|		ТаблицаНомераУпаковок.Ссылка = ТаблицаТовары.Ссылка
	|		И ТаблицаНомераУпаковок.ИдентификаторСтроки = ТаблицаТовары.ИдентификаторСтроки
	|ГДЕ
	|	ТаблицаТовары.Ссылка = &Ссылка
	|УПОРЯДОЧИТЬ ПО
	|	ИдентификаторДокумента
	|");
	Запрос.УстановитьПараметр("Ссылка", ДокументСсылка);
	
	Результат = Запрос.ВыполнитьПакет();
	Шапка            = Результат[Результат.ВГраница() - 2].Выбрать();
	ДокументыПродажи = Результат[Результат.ВГраница() - 1].Выбрать();
	Товары           = Результат[Результат.ВГраница()    ].Выбрать();
	
	Если Не Шапка.Следующий() Или Результат[Результат.ВГраница() - 1].Пустой() Или Результат[Результат.ВГраница()].Пустой() Тогда
		
		ИнтеграцияМДЛПКлиентСервер.ДобавитьТекстОшибки(СообщениеКПередаче, НСтр("ru = 'Нет данных для выгрузки.'"));
		Сообщения.Добавить(СообщениеКПередаче);
		Возврат Сообщения;
		
	КонецЕсли;
	
	ПространствоИмен = ИнтеграцияМДЛП.ПространствоИмен(Шапка.ВерсияСхемОбмена);
	
	УстановленныеДаты = Новый Соответствие;
	
	ИмяТипа   = "documents";
	ИмяПакета = "withdrawal_without_kkt";
	
	ПередачаДанных = ИнтеграцияМДЛП.ОбъектXDTOПоИмениСвойства(Неопределено, ИмяТипа, ПространствоИмен);
	ИнтеграцияМДЛП.УстановитьВерсиюСхемОбменаПакета(ПередачаДанных);
	
	Уведомление = ИнтеграцияМДЛП.ОбъектXDTOПоИмениСвойства(ПередачаДанных, ИмяПакета);
	ПередачаДанных[ИмяПакета] = Уведомление;
	
	Уведомление.action_id = Уведомление.action_id;
	
	ИнтеграцияМДЛП.ЗаполнитьСвойствоXDTO(Уведомление, "subject_id", Шапка.ИдентификаторОрганизации, СообщениеКПередаче);
	ИнтеграцияМДЛП.УстановитьДатуСЧасовымПоясом(Уведомление, "operation_date", Шапка.Дата, УстановленныеДаты, СообщениеКПередаче);
	
	Уведомление.sales = ИнтеграцияМДЛП.ОбъектXDTOПоИмениСвойства(Уведомление, "sales");
	Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(Уведомление.sales, "union") Тогда
		Пока ДокументыПродажи.Следующий() Цикл
			
			ДанныеДокументаПродажи = ИнтеграцияМДЛП.ОбъектXDTOПоИмениСвойства(Уведомление.sales, "union");
			
			ИнтеграцияМДЛП.ЗаполнитьСвойствоXDTO(ДанныеДокументаПродажи, "doc_number", ДокументыПродажи.НомерДокумента, СообщениеКПередаче);
			ИнтеграцияМДЛП.ЗаполнитьСвойствоXDTO(ДанныеДокументаПродажи, "doc_date"  , Формат(ДокументыПродажи.ДатаДокумента, "ДФ=dd.MM.yyyy"), СообщениеКПередаче);
			
			Если ЗначениеЗаполнено(ДокументыПродажи.НомерЛьготногоРецепта) Тогда
				ЛьготныйРецепт = ИнтеграцияМДЛП.ОбъектXDTOПоИмениСвойства(ДанныеДокументаПродажи, "prescription");
				ИнтеграцияМДЛП.ЗаполнитьСвойствоXDTO(ЛьготныйРецепт, "prescription_num", ДокументыПродажи.НомерЛьготногоРецепта, СообщениеКПередаче);
				ИнтеграцияМДЛП.ЗаполнитьСвойствоXDTO(ЛьготныйРецепт, "prescription_date", Формат(ДокументыПродажи.ДатаЛьготногоРецепта, "ДФ=dd.MM.yyyy"), СообщениеКПередаче);
				ИнтеграцияМДЛП.ЗаполнитьСвойствоXDTO(ЛьготныйРецепт, "prescription_series" , ДокументыПродажи.НомерСерииЛьготногоРецепта, СообщениеКПередаче);
				ДанныеДокументаПродажи.prescription = ЛьготныйРецепт;
			КонецЕсли;
			
			Пока Товары.НайтиСледующий(ДокументыПродажи.ИдентификаторДокумента, "ИдентификаторДокумента") Цикл
				НоваяСтрока = ИнтеграцияМДЛП.ОбъектXDTOПоИмениСвойства(ДанныеДокументаПродажи, "detail");
				ИнтеграцияМДЛП.ЗаполнитьСвойствоXDTO(НоваяСтрока, "sgtin"    , Товары.НомерКИЗ, СообщениеКПередаче);
				ИнтеграцияМДЛП.ЗаполнитьСвойствоXDTO(НоваяСтрока, "cost"     , Товары.Цена    , СообщениеКПередаче);
				ИнтеграцияМДЛП.ЗаполнитьСвойствоXDTO(НоваяСтрока, "vat_value", Товары.СуммаНДС, СообщениеКПередаче);
				Если ЗначениеЗаполнено(Товары.КоличествоПервичныхУпаковок) Тогда
					ДоляУпаковки = СтрШаблон("%1/%2", Формат(Товары.КоличествоПервичныхУпаковок, "ЧГ="), Формат(Товары.КоличествоПервичныхУпаковокВоВторичной, "ЧГ="));
					ИнтеграцияМДЛП.ЗаполнитьСвойствоXDTO(НоваяСтрока, "sold_part", ДоляУпаковки, СообщениеКПередаче);
				КонецЕсли;
				ДанныеДокументаПродажи.detail.Добавить(НоваяСтрока);
			КонецЦикла;
			
			Уведомление.sales.union.Добавить(ДанныеДокументаПродажи);
			
		КонецЦикла;
	КонецЕсли;
	
	ИнтеграцияМДЛП.ПроверитьОбъектXDTO(ПередачаДанных, СообщениеКПередаче);
	
	ТекстСообщения = ИнтеграцияМДЛП.ОбъектXDTOВXML(ПередачаДанных, ИмяТипа, ПространствоИмен);
	ТекстСообщения = ИнтеграцияМДЛП.ПреобразоватьВременныеДаты(УстановленныеДаты, ТекстСообщения);
	
	СообщениеКПередаче.ТекстСообщения = ТекстСообщения;
	СообщениеКПередаче.ИдентификаторСубъектаОбращения = Шапка.ИдентификаторОрганизации;
	СообщениеКПередаче.Основание      = Шапка.Основание;
	СообщениеКПередаче.ТипСообщения   = Перечисления.ТипыСообщенийМДЛП.Исходящее;
	СообщениеКПередаче.ОбновитьСостояниеПодтверждения = Истина;
	
	Сообщения.Добавить(СообщениеКПередаче);
	Возврат Сообщения;
	
КонецФункции

#Область Серии

// Имена реквизитов, от значений которых зависят параметры указания серий
//
// Возвращаемое значение:
//  Строка - имена реквизитов, перечисленные через запятую
//
Функция ИменаРеквизитовДляЗаполненияПараметровУказанияСерий() Экспорт
	
	Возврат ГосударственныеИнформационныеСистемыПереопределяемый.ИменаРеквизитовДляЗаполненияПараметровУказанияСерий(ПустаяСсылка().Метаданные());
	
КонецФункции

// Возвращает параметры указания серий для товаров, указанных в документе.
//
// Параметры:
//  Объект - Структура - структура значений реквизитов объекта, необходимых для заполнения параметров указания серий.
// 
// Возвращаемое значение:
//  Структура
//
Функция ПараметрыУказанияСерий(Объект) Экспорт
	
	Возврат ГосударственныеИнформационныеСистемыПереопределяемый.ПараметрыУказанияСерий(ПустаяСсылка().Метаданные(), Объект);
	
КонецФункции

// Возвращает текст запроса для расчета статусов указания серий
//	Параметры:
//		ПараметрыУказанияСерий - Структура
//	Возвращаемое значение:
//		Строка - текст запроса
//
Функция ТекстЗапросаЗаполненияСтатусовУказанияСерий(ПараметрыУказанияСерий) Экспорт
	
	Возврат ГосударственныеИнформационныеСистемыПереопределяемый.ТекстЗапросаЗаполненияСтатусовУказанияСерий(ПустаяСсылка().Метаданные(), ПараметрыУказанияСерий);
	
КонецФункции

#КонецОбласти

#Область Отчеты

// Заполняет список команд отчетов.
// 
// Параметры:
//   КомандыОтчетов - ТаблицаЗначений - состав полей см. в функции Подключаемые.СоздатьКоллекциюКомандОтчетов
//
Процедура ДобавитьКомандыОтчетов(КомандыОтчетов, НастройкиФормы) Экспорт
	
	ГосударственныеИнформационныеСистемыПереопределяемый.ДобавитьКомандуСтруктураПодчиненности(КомандыОтчетов);
	
КонецПроцедуры

#КонецОбласти

#Область Печать

// Заполняет список команд печати.
// 
// Параметры:
//   КомандыПечати - ТаблицаЗначений - состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати.
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	
	
	
КонецПроцедуры

// Сформировать печатные формы объектов.
//
// ВХОДЯЩИЕ:
//   ИменаМакетов    - Строка    - Имена макетов, перечисленные через запятую.
//   МассивОбъектов  - Массив    - Массив ссылок на объекты которые нужно распечатать.
//   ПараметрыПечати - Структура - Структура дополнительных параметров печати.
//
// ИСХОДЯЩИЕ:
//   КоллекцияПечатныхФорм - Таблица значений - Сформированные табличные документы.
//   ПараметрыВывода       - Структура        - Параметры сформированных табличных документов.
//
Процедура Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт
	
	
	
КонецПроцедуры

#КонецОбласти

#Область ВерсионированиеОбъектов

// Определяет настройки объекта для подсистемы ВерсионированиеОбъектов.
//
// Параметры:
//  Настройки - Структура - настройки подсистемы.
//
Процедура ПриОпределенииНастроекВерсионированияОбъектов(Настройки) Экспорт
	
	
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецЕсли
