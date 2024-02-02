﻿

#Область ПрограммныйИнтерфейс

// Распаковывать не подписанные заказчиком титулы поставщика.
// 
// Параметры:
//  РаспаковыватьНеПодписанныеТитулы - Булево - распаковывать титулы не подписанные заказчиком.
Процедура РаспаковыватьПроектыТитуловПоставщикаПриПолученииЗаказчиком(РаспаковыватьНеПодписанныеТитулы) Экспорт
	
	// БольничнаяАптека
	ЭлектронноеАктированиеЕИСБольничнаяАптека.РаспаковыватьПроектыТитуловПоставщикаПриПолученииЗаказчиком(РаспаковыватьНеПодписанныеТитулы);
	// Конец БольничнаяАптека
	
КонецПроцедуры

// Сопоставлять номенклатуру контракта средствами подсистемы сопоставление номенклатуры.
// 
// Параметры:
//  СопоставлятьНоменклатуру - Булево - Сопоставлять номенклатуру.
Процедура СопоставлятьНоменклатуруКонтракта(СопоставлятьНоменклатуру) Экспорт
	
	
КонецПроцедуры

// После загрузки контракта из ЕИС.
// 
// Параметры:
//  СсылкаНаКонтракт - СправочникСсылка.ГосударственныеКонтрактыЕИС - ссылка на контракт.
Процедура ПослеЗагрузкиКонтрактаИзЕИС(СсылкаНаКонтракт) Экспорт
	
	
КонецПроцедуры

// Перед записью на сервере государственного контракта.
// 
// Параметры:
//  ЭтотОбъект - ФормаКлиентскогоПриложения - форма контракта.
//  Отказ - Булево - признак отказа.
//  ТекущийОбъект - Объект - Данные объекта.
//  ПараметрыЗаписи - Структура - параметры записи.
Процедура ПередЗаписьюНаСервереГосударственногоКонтракта(
		ЭтотОбъект, Отказ, ТекущийОбъект, ПараметрыЗаписи) Экспорт

КонецПроцедуры

// Заполнить связи параметров выбора и параметры выбора договора.
// Используется для заполнения параметров элемента формы договора в форме гос.контракта.
// 
// Параметры:
//  СвязиПараметровВыбора - ФиксированныйМассив - связи параметров выбора договора.
//  ПараметрыВыбора - ФиксированныйМассив - параметры выбора договора.
Процедура ЗаполнитьСвязиПараметровВыбораИПараметрыВыбораДоговора(СвязиПараметровВыбора,
			 ПараметрыВыбора) Экспорт
		
КонецПроцедуры

// Заполнение типов объектов из которых вызывается команда открытия параметров актирования.
// 
// Параметры:
//  ТипыОбъектов - Массив - типы объектов.
Процедура ЗаполнитьТипыОбъектовВызоваКомандыОткрытияПараметровАктирования(ТипыОбъектов) Экспорт
	
КонецПроцедуры

// Возвращается признак того, что для документа заполняются места поставки.
// Места доставки заполняются для исходных титулов, для корректирующих
// и исправительных не заполняются. 
// 
// Параметры:
//  Документ - ДокументСсылка - ссылка на документ.
//  МестаПоставкиЗаполняются - Булево - признак того, что места поставки заполняются.
Процедура ДляДокументаЗаполняютсяМестаПоставки(Документ, МестаПоставкиЗаполняются) Экспорт
	
КонецПроцедуры

// Возвращается признак того, что для документа заполняется судебное решение.
// Судебное решение заполняется УПД и исправления УПД. 
// 
// Параметры:
//  Документ - ДокументСсылка - ссылка на документ.
//  СудебноеРешениеЗаполняется - Булево - признак того, что судебное решение заполняется.
Процедура ДляДокументаЗаполняетсяСудебноеРешение(Документ, СудебноеРешениеЗаполняется) Экспорт
	
КонецПроцедуры

// Заполнить деревья данных параметров актирования документа.
// 
// Параметры:
//  Документ - ДокументСсылка - ссылка на документ.
//  ДанныеКонтракта - Структура - данные контракта.
//  ДеревоТоваров - ДеревоЗначений - дерево товаров.
//  ДеревоРаботУслуг - ДеревоЗначений - дерево работ услуг.
Процедура ЗаполнитьДеревьяДанныхПараметровАктированияДокумента(Документ,
				ДанныеКонтракта, ДеревоТоваров, ДеревоРаботУслуг) Экспорт
	
КонецПроцедуры

// Разрешается использовать электронное актирование ЕИС для заказчиков.
// 
// Параметры:
//  ИспользованиеРазрешено - Булево - Истина, если использование разрешено.
Процедура РазрешаетсяИспользоватьЭлектронноеАктированиеДляЗаказчиков(ИспользованиеРазрешено) Экспорт
	
	// БольничнаяАптека
	ЭлектронноеАктированиеЕИСБольничнаяАптека.РазрешаетсяИспользоватьЭлектронноеАктированиеДляЗаказчиков(ИспользованиеРазрешено);
	// Конец БольничнаяАптека
	
КонецПроцедуры

// Разрешается использовать электронное актирование ЕИС для поставщиков.
// 
// Параметры:
//  ИспользованиеРазрешено - Булево - Истина, если использование разрешено.
Процедура РазрешаетсяИспользоватьЭлектронноеАктированиеДляПоставщиков(ИспользованиеРазрешено) Экспорт
	
	// БольничнаяАптека
	ЭлектронноеАктированиеЕИСБольничнаяАптека.РазрешаетсяИспользоватьЭлектронноеАктированиеДляПоставщиков(ИспользованиеРазрешено);
	// Конец БольничнаяАптека
	
КонецПроцедуры

// Заполнить табличную часть документа по данным дерева товаров услуг.
// 
// Параметры:
//  СсылкаНаДокумент - ОпределяемыйТип.ОснованияЭлектронныхДокументовЭДО - ссылка на документ.
//  ДеревоТоваров - ДеревоЗначений - дерево товаров.
//  ДеревоРаботУслуг - ДеревоЗначений - дерево работ услуг.
//  РезультатЗаполнения - Структура - см. ЭлектронноеАктированиеЕИС.НовыйРезультатЗаполненияТабличныхЧастей().
Процедура ЗаполнитьТабличнуюЧастьДокументаПоДаннымДереваТоваровУслуг(
			СсылкаНаДокумент, ДеревоТоваров, ДеревоРаботУслуг, РезультатЗаполнения) Экспорт

КонецПроцедуры

// Создать элемент формы параметров электронного актирования документа.
// 
// Параметры:
//  Форма - ФормаКлиентскогоПриложения - форма документа.
//  Элемент - ЭлементыФормы - элемент для редактирования параметров эл.актирования.
Процедура СоздатьЭлементФормыПараметровЭлектронногоАктированияДокумента(Форма, Элемент) Экспорт
	
КонецПроцедуры

// Кнопки заполнения табличных частей документов.
// 
// Параметры:
//  Форма - ФормаКлиентскогоПриложения - форма документа.
//  Кнопки - Массив - имена элементов формы кнопок для заполнения табличных частей документов.
Процедура КнопкиЗаполненияТабличныхЧастейДокументов(Форма, Кнопки) Экспорт
	
КонецПроцедуры

// Места поставки документа, формируется из адресов грузополучателей.
// Метод вызывается из процедуры ЭлектронноеАктированиеЕИС.ЗаполнитьПараметрыАктированияДокументаПоУмолчанию,
// вызов этой процедуры нужно добавить в обработчик события ПослеЗаписиНаСервере документа реализации. 
// 
// Параметры:
//  Документ - ДокументСсылка - ссылка на документ-источник.
//  МестаПоставки - Массив - места поставки в формате json.
Процедура ЗаполнитьМестаПоставкиДокумента(Документ, МестаПоставки) Экспорт
	
КонецПроцедуры

// Версия приложения. Возвращемое значение не должно превышать 40 символов.
// 
// Параметры:
//  Версия - Строка - версия приложения. Строка длиной не более 40 символов.
Процедура ВерсияПриложения(Версия) Экспорт
	
	// БольничнаяАптека
	ЭлектронноеАктированиеЕИСБольничнаяАптека.ВерсияПриложения(Версия);
	// Конец БольничнаяАптека
	
КонецПроцедуры

// Определить владельца присоединенных файлов электронного документа.
// 
// Параметры:
//  ОбъектыУчетаЭД - Массив - массив ссылок на документы объекты учета.
//  Владелец - ДокументСсылка - документ владелец присоединенных файлов.
Процедура ОпределитьВладельцаПрисоединенныхФайлов(Знач ОбъектыУчетаЭД, Владелец) Экспорт
	
КонецПроцедуры

// Преобразование прикладного значения ставки в текстовое для приложения УПД/УКД.
// 
// Параметры:
//  СтавкаНДС - ПеречислениеСсылка, СправочникСсылка - прикладное значение ставки.
//  СтавкаНДСПриложения - Строка - ставка НДС для приложения ЕИС.
Процедура СтавкаНДСДляПриложенияЕИС(Знач СтавкаНДС, СтавкаНДСПриложения) Экспорт
		
КонецПроцедуры

// Медицинская специализация включена.
// 
// Параметры:
//  СпециализацияВключена - Булево - в параметре заполняется признак включения медицинской специализации.
Процедура МедицинскаяСпециализацияВключена(СпециализацияВключена) Экспорт
	
	// БольничнаяАптека
	ЭлектронноеАктированиеЕИСБольничнаяАптека.МедицинскаяСпециализацияВключена(СпециализацияВключена);
	// Конец БольничнаяАптека
	
КонецПроцедуры

// Строительная специализация включена.
// 
// Параметры:
//  СпециализацияВключена - Булево - в параметре заполняется признак включения строительной специализации.
Процедура СтроительнаяСпециализацияВключена(СпециализацияВключена) Экспорт
	
КонецПроцедуры

// Найти создать контрагента по сведениям о заказчике.
// 
// Параметры:
//  ДанныеКонтрагента - Структура - Данные контрагента.
//   * ПолноеНаименование 
//   * СокращенноеНаименование 
//   * ИНН 
//   * КПП
//  Контрагент - СправочникСсылка - Контрагент.
Процедура НайтиСоздатьКонтрагентаПоСведениямОЗаказчике(ДанныеКонтрагента, Контрагент) Экспорт
	
	// БольничнаяАптека
	ЭлектронноеАктированиеЕИСБольничнаяАптека.НайтиСоздатьКонтрагентаПоСведениямОЗаказчике(ДанныеКонтрагента, Контрагент);
	// Конец БольничнаяАптека
	
КонецПроцедуры

// Государственный контракт документа.
// 
// Параметры:
//  Документ - ДокументСсылка - ссылка на документ.
//  ГосударственныйКонтракт - СправочникСсылка.ГосударственныеКонтрактыЕИС - Государственный контракт.
Процедура ГосударственныйКонтрактДокумента(Документ, ГосударственныйКонтракт) Экспорт
	
КонецПроцедуры

// Заполняется договор контрагента документа.
// 
// Параметры:
//  ИсточникКоманды - ДанныеФормыСтруктура - данные источника команды.
//  ДоговорКонтрагента - СправочникСсылка, Неопределено - ссылка договор контрагента.
Процедура ДоговорКонтрагентаИсточникаКоманды(ИсточникКоманды, ДоговорКонтрагента) Экспорт
	
КонецПроцедуры

// Преобразование текстового значения ставки из данных контракта в прикладное.
// 
// Параметры:
//  СтавкаНДСОбъектаЗакупки - Строка - строковая ставка НДС объект закупки.
//  СтавкаНДС - ОпределяемыйТип.СтавкаНДСКонтрактаЕИС - ставка НДС конфигурации потребителя.
Процедура СтавкаНДСОбъектаЗакупки(Знач СтавкаНДСОбъектаЗакупки, СтавкаНДС) Экспорт
	
КонецПроцедуры

// Создать договор на основании контракта.
// 
// Параметры:
//  СсылкаНаКонтракт - СправочникСсылка.ГосударственныеКонтрактыЕИС - Ссылка на контракт.
//  РезультатСоздания - Структура - результат создания контракта:
//    * Договор - Неопределено, ОпределяемыйТип.ДоговорСКонтрагентомЭДО - ссылка на договор.
//    * Выполнено - Булево - Истина, если договор был успешно создан.
//    * ОписаниеОшибки - Строка - описание ошибки создания договора.
Процедура СоздатьДоговорНаОснованииКонтракта(СсылкаНаКонтракт, РезультатСоздания) Экспорт
	
КонецПроцедуры

// При определении объектов с командами создания на основании.
// 
// Параметры:
//  Объекты см. СозданиеНаОснованииПереопределяемый.ПриОпределенииОбъектовСКомандамиСозданияНаОсновании
Процедура ПриОпределенииОбъектовСКомандамиСозданияНаОсновании(Объекты) Экспорт
	
КонецПроцедуры

// Инициализация команд формы.
// Используется для реализации прикладной логики управления командами формы.
//
// Параметры:
//  ИмяСобытия - Строка - ключ имени события, например "ДобавитьКомандуСоздатьНаОсновании".
//  ИмяОбъекта - Строка - имя объекта метаданных, например "РеализацияТоваровУслуг".
//  Контекст   - Произвольный - контекст инициализации.
//  Результат  - Произвольный - возвращаемый результат.
//  Параметры  - Произвольный - параметры инициализации.
//
Процедура ИнициализацияКомандФормы(ИмяСобытия, ИмяОбъекта, Контекст, Результат = Неопределено, Параметры = Неопределено) Экспорт
	
КонецПроцедуры

// Вместо процедуры следует использовать РазрешаетсяИспользоватьЭлектронноеАктированиеДляПоставщиков().
// Разрешается использовать электронное актирование ЕИС для поставщиков.
// 
// Параметры:
//  ИспользованиеРазрешено - Булево - Истина, если использование разрешено.
Процедура РазрешаетсяИспользоватьЭлектронноеАктированиеЕИС(ИспользованиеРазрешено) Экспорт
	
КонецПроцедуры

// Условие отбора государственных контрактов ЕИС по договору.
// Условие используется в запросе для формирования настроек отправки объекта учета.
// См. ЭлектронноеАктированиеЕИС.ТекстЗапросаНастроекОтправкиОбъектовУчета
// Условие задается в том случае, если в качестве справочника контрактов ЕИС используется
// справочник отличный от ГосударственныеКонтрактыЕИС и в справочнике отсутствует реквизит
// ВладелецКонтракта со ссылкой на договор контрагента.
// 
// Параметры:
//  ТекстУсловия - Строка
Процедура УсловиеОтбораГосударственныхКонтрактовПоДоговору(ТекстУсловия) Экспорт
	
КонецПроцедуры

// Заполнение таблицы номенклатуры контракта по сопоставленной номенклатуре.
// Процедура должна содержать реализацию если используется другой способ
// поиска сопоставленной объектам закупки номенклатуры, который реализован
// в ЭлектронноеАктированиеЕИСПолучениеВходящих.ТаблицаНоменклатурыКонтракта
// 
// Параметры:
//  ТаблицаИдентификаторов - ТаблицаЗначений - Таблица идентификаторов номенклатуры:
//   * ИдентификаторНоменклатурыКонтрагентов - Строка - идентификатор для сопоставления номенклатуры
//   * Идентификатор - Строка - идентификатор объекта закупки из ЕИС
//   * Количество - Число
//  ДанныеГосконтракта - ДанныеФормыСтруктура,
//   СправочникОбъект.ГосударственныеКонтрактыЕИС - объект справочника гос.контрактов или данные формы.
//  ТаблицаНоменклатуры - ТаблицаЗначений - таблица для загрузки в табличную часть
//     НоменклатураОбъектовЗакупки гос.контракта:
//   * Идентификатор - Строка - идентификатор объекта закупки из ЕИС
//   * Количество - Число
//   * Характеристика - ОпределяемыйТип.ХарактеристикаНоменклатурыБЭД
//   * Номенклатура - ОпределяемыйТип.НоменклатураБЭД
Процедура ЗаполнитьТаблицуНоменклатурыКонтракта(ТаблицаИдентификаторов, ДанныеГосКонтракта, ТаблицаНоменклатуры) Экспорт
	
КонецПроцедуры

#КонецОбласти // ПрограммныйИнтерфейс

