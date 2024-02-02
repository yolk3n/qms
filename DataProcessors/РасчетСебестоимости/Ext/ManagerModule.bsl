﻿
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

////////////////////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС
#Область ПрограммныйИнтерфейс

// Запускает фоновый расчет себестоимости
// и помещает информацию по расчету во временное хранилище по переданному адресу.
//
// Параметры:
//  Параметры      - Структура - параметры выполнения расчета себестоимости.
//  АдресХранилища - Строка - адрес хранилища, куда будет помещена информация по расчету.
//
Процедура РассчитатьСебестоимость(Параметры, АдресХранилища) Экспорт
	
	Попытка
		Документы.РасчетСебестоимостиТоваров.РассчитатьВсе(КонецМесяца(ТекущаяДатаСеанса()), Параметры.Организация);
	Исключение
		ИмяСобытия = Документы.РасчетСебестоимостиТоваров.ИмяСобытияОшибкиДляЖурналаРегистрации();
		ЗаписьЖурналаРегистрации(ИмяСобытия, УровеньЖурналаРегистрации.Ошибка,,, ОбработкаОшибок.ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
		Параметры.Вставить("ЕстьОшибкиПриРасчете", Истина);
	КонецПопытки;
	
	ПолучитьИнформациюПоРасчету(Параметры, АдресХранилища);
	
КонецПроцедуры

// Запускает фоновое получение информации по расчету себестоимости
// и помещает ее во временное хранилище по переданному адресу.
//
// Параметры:
//  Параметры      - Структура - параметры получения информации по расчету.
//  АдресХранилища - Строка - адрес хранилища, куда будет помещена информация по расчету.
//
Процедура ПолучитьИнформациюПоРасчету(Параметры, АдресХранилища) Экспорт
	
	Результат = Новый Структура;
	Результат.Вставить("СостояниеРасчета"       , Состояние_РасчетНеВыполнен());
	Результат.Вставить("ДатаАктуальностиРасчета", Документы.РасчетСебестоимостиТоваров.ДатаАктуальностиФактическогоРасчетаСебестоимости(Параметры.Организация));
	
	Если Параметры.Свойство("ЕстьОшибкиПриРасчете") Тогда
		
		// Расчет себестоимости выполнен с ошибками.
		Результат.СостояниеРасчета = Состояние_РасчетВыполненСОшибками();
		
	Иначе
		
		СхемаРасчета = Документы.РасчетСебестоимостиТоваров.СхемаРасчета(, Параметры.Организация);
		Если СхемаРасчета.Количество() = 0 Тогда
			
			// Расчет себестоимости выполнен.
			Результат.СостояниеРасчета = Состояние_РасчетВыполнен();
			
		Иначе
			
			ОшибкиОстатковТоваров = ПолучитьОшибкиОстатковТоваров(СхемаРасчета);
			Если ОшибкиОстатковТоваров.Количество() > 0 Тогда
				
				// Расчет себестоимости не может быть выполнен корректно.
				Результат.СостояниеРасчета = Состояние_РасчетНеМожетБытьВыполнен();
				Результат.Вставить("ОшибкиОстатковТоваров", ОшибкиОстатковТоваров);
				
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЕсли;
	
	ПоместитьВоВременноеХранилище(Результат, АдресХранилища);
	
КонецПроцедуры

#КонецОбласти // ПрограммныйИнтерфейс

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ
#Область СлужебныеПроцедурыИФункции

Функция ПолучитьОшибкиОстатковТоваров(СхемаРасчета)
	
	Результат = Новый ТаблицаЗначений;
	Результат.Колонки.Добавить("КлючОшибки");
	Результат.Колонки.Добавить("ПредставлениеОшибки");
	Результат.Колонки.Добавить("ПояснениеОшибки");
	Результат.Колонки.Добавить("Порядок");
	
	ТаблицаПроверокОстатков = Результат.СкопироватьКолонки();
	ТаблицаПроверокОстатков.Колонки.Добавить("ТекстЗапроса");
	
	ДобавитьПроверку_ОтрицательныеОстатки(ТаблицаПроверокОстатков);
	ДобавитьПроверку_НаличиеРазвернутогоСальдо(ТаблицаПроверокОстатков);
	
	Запрос = ИнициализироватьЗапросПроверокОстатков(СхемаРасчета);
	
	Для Каждого ЭлементСхемыРасчета Из СхемаРасчета Цикл
		
		Запрос.Текст = "";
		Для Каждого Проверка Из ТаблицаПроверокОстатков Цикл
			Запрос.Текст = Запрос.Текст + Проверка.ТекстЗапроса;
		КонецЦикла;
		
		Если ПустаяСтрока(Запрос.Текст) Тогда
			Прервать;
		КонецЕсли;
		
		Запрос.УстановитьПараметр("ОтчетныйПериод", ЭлементСхемыРасчета.Дата);
		Запрос.УстановитьПараметр("Организация", ЭлементСхемыРасчета.Организации);
		Запрос.Выполнить();
		
		Ошибки = Запрос.МенеджерВременныхТаблиц.Таблицы;
		
		ГраницаПроверок = ТаблицаПроверокОстатков.Количество() - 1;
		Для Счетчик = 0 По ГраницаПроверок Цикл
			
			Проверка = ТаблицаПроверокОстатков[ГраницаПроверок - Счетчик];
			
			Ошибка = Ошибки.Найти(Проверка.КлючОшибки);
			Если Ошибка = Неопределено Тогда
				Продолжить;
			КонецЕсли;
			
			ЕстьОшибки = Не Ошибка.ПолучитьДанные().Пустой();
			
			Запрос.Текст = "УНИЧТОЖИТЬ " + Проверка.КлючОшибки;
			Запрос.Выполнить();
			
			Если ЕстьОшибки Тогда
				ЗаполнитьЗначенияСвойств(Результат.Добавить(), Проверка);
				ТаблицаПроверокОстатков.Удалить(Проверка);
			КонецЕсли;
			
		КонецЦикла;
		
	КонецЦикла;
	
	Результат.Сортировать("Порядок");
	
	Возврат Результат;
	
КонецФункции

Функция ИнициализироватьЗапросПроверокОстатков(СхемаРасчета)
	
	Запрос = Новый Запрос("
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	АналитикаВидаУчета.КлючАналитики           КАК КлючАналитики,
	|	АналитикаВидаУчета.Организация             КАК Организация,
	|	АналитикаВидаУчета.Склад                   КАК Склад,
	|	АналитикаВидаУчета.ИсточникФинансирования  КАК ИсточникФинансирования
	|ПОМЕСТИТЬ АналитикаВидаУчета
	|ИЗ
	|	РегистрСведений.АналитикаВидаУчета КАК АналитикаВидаУчета
	|ГДЕ
	|	АналитикаВидаУчета.Организация В (&Организация)
	|ИНДЕКСИРОВАТЬ ПО
	|	КлючАналитики
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	АналитикаУчетаНоменклатуры.КлючАналитики      КАК КлючАналитики,
	|	АналитикаУчетаНоменклатуры.Номенклатура       КАК Номенклатура,
	|	АналитикаУчетаНоменклатуры.СерияНоменклатуры  КАК СерияНоменклатуры,
	|	АналитикаУчетаНоменклатуры.Партия             КАК Партия
	|ПОМЕСТИТЬ АналитикаУчетаНоменклатуры
	|ИЗ
	|	РегистрСведений.АналитикаУчетаНоменклатуры КАК АналитикаУчетаНоменклатуры
	|ИНДЕКСИРОВАТЬ ПО
	|	КлючАналитики
	|");
	
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	Запрос.УстановитьПараметр("Организация", СхемаРасчета[СхемаРасчета.Количество() - 1].Организации);
	Запрос.Выполнить();
	
	Возврат Запрос;
	
КонецФункции

Процедура ДобавитьПроверку_ОтрицательныеОстатки(ТаблицаПроверокОстатков)
	
	Проверка = ТаблицаПроверокОстатков.Добавить();
	Проверка.Порядок             = 10;
	Проверка.КлючОшибки          = "ОтрицательныеОстатки";
	Проверка.ПредставлениеОшибки = НСтр("ru = 'Отрицательные остатки'");
	
	ИспользоватьНесколькоОрганизаций = ПолучитьФункциональнуюОпцию("ИспользоватьНесколькоОрганизацийБольничнаяАптека");
	Если ИспользоватьНесколькоОрганизаций Тогда
		Проверка.ПояснениеОшибки = НСтр("ru = 'Отрицательные остатки товаров могут возникнуть при несоответствии приходов и расходов товаров в разрезе организаций и складов'");
	Иначе
		Проверка.ПояснениеОшибки = НСтр("ru = 'Отрицательные остатки товаров могут возникнуть при несоответствии приходов и расходов товаров в разрезе складов'");
	КонецЕсли;
	
	Проверка.ТекстЗапроса = "
	|ВЫБРАТЬ ПЕРВЫЕ 1
	|	&ОтчетныйПериод                                    КАК ОтчетныйПериод,
	|	КлючиАналитикиВидаУчета.Организация                КАК Организация,
	|	КлючиАналитикиВидаУчета.Склад                      КАК Склад,
	|	КлючиАналитикиУчетаНоменклатуры.Номенклатура       КАК Номенклатура,
	|	СУММА(ОстаткиИОбороты.КоличествоНачальныйОстаток)  КАК КоличествоНачальныйОстаток,
	|	СУММА(ОстаткиИОбороты.КоличествоКонечныйОстаток)   КАК КоличествоКонечныйОстаток
	|ПОМЕСТИТЬ ОтрицательныеОстатки
	|ИЗ
	|	РегистрНакопления.СебестоимостьТоваров.ОстаткиИОбороты(
	|		НАЧАЛОПЕРИОДА(&ОтчетныйПериод, МЕСЯЦ),
	|		КОНЕЦПЕРИОДА(&ОтчетныйПериод, МЕСЯЦ),
	|		Месяц,
	|		ДвиженияИГраницыПериода,
	|		АналитикаВидаУчета В (ВЫБРАТЬ АналитикаВидаУчета.КлючАналитики ИЗ АналитикаВидаУчета)
	|		) КАК ОстаткиИОбороты
	|		
	|		ЛЕВОЕ СОЕДИНЕНИЕ
	|			АналитикаВидаУчета КАК КлючиАналитикиВидаУчета
	|		ПО
	|			КлючиАналитикиВидаУчета.КлючАналитики = ОстаткиИОбороты.АналитикаВидаУчета
	|		
	|		ЛЕВОЕ СОЕДИНЕНИЕ
	|			АналитикаУчетаНоменклатуры КАК КлючиАналитикиУчетаНоменклатуры
	|		ПО
	|			КлючиАналитикиУчетаНоменклатуры.КлючАналитики = ОстаткиИОбороты.АналитикаУчетаНоменклатуры
	|ГДЕ
	|	КлючиАналитикиВидаУчета.Организация В (&Организация)
	|СГРУППИРОВАТЬ ПО
	|	КлючиАналитикиВидаУчета.Организация,
	|	КлючиАналитикиВидаУчета.Склад,
	|	КлючиАналитикиУчетаНоменклатуры.Номенклатура
	|ИМЕЮЩИЕ
	|	СУММА(ОстаткиИОбороты.КоличествоКонечныйОстаток) < 0
	|	И СУММА(ОстаткиИОбороты.КоличествоКонечныйОстаток) <> СУММА(ОстаткиИОбороты.КоличествоНачальныйОстаток)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|";
	
КонецПроцедуры

Процедура ДобавитьПроверку_НаличиеРазвернутогоСальдо(ТаблицаПроверокОстатков)
	
	Проверка = ТаблицаПроверокОстатков.Добавить();
	Проверка.Порядок             = 20;
	Проверка.КлючОшибки          = "НаличиеРазвернутогоСальдо";
	Проверка.ПредставлениеОшибки = НСтр("ru = 'Наличие развернутого сальдо'");
	
	ИспользоватьНесколькоОрганизаций = ПолучитьФункциональнуюОпцию("ИспользоватьНесколькоОрганизацийБольничнаяАптека");
	Если ИспользоватьНесколькоОрганизаций Тогда
		Проверка.ПояснениеОшибки = НСтр("ru = 'Развернутое сальдо по товарам возникает при наличии положительных и отрицательных остатков в разрезе серий, партий товаров и источников финансирования на складах организаций'");
	Иначе
		Проверка.ПояснениеОшибки = НСтр("ru = 'Развернутое сальдо по товарам возникает при наличии положительных и отрицательных остатков в разрезе серий, партий товаров и источников финансирования на складах'");
	КонецЕсли;
	
	Проверка.ТекстЗапроса = "
	|ВЫБРАТЬ ПЕРВЫЕ 1
	|	&ОтчетныйПериод                                    КАК ОтчетныйПериод,
	|	КлючиАналитикиВидаУчета.Организация                КАК Организация,
	|	КлючиАналитикиВидаУчета.Склад                      КАК Склад,
	|	КлючиАналитикиВидаУчета.ИсточникФинансирования     КАК ИсточникФинансирования,
	|	КлючиАналитикиУчетаНоменклатуры.Номенклатура       КАК Номенклатура,
	|	КлючиАналитикиУчетаНоменклатуры.СерияНоменклатуры  КАК СерияНоменклатуры,
	|	КлючиАналитикиУчетаНоменклатуры.Партия             КАК Партия,
	|	ОстаткиИОбороты.КоличествоНачальныйОстаток         КАК КоличествоНачальныйОстаток,
	|	ОстаткиИОбороты.КоличествоКонечныйОстаток          КАК КоличествоКонечныйОстаток
	|ПОМЕСТИТЬ НаличиеРазвернутогоСальдо
	|ИЗ
	|	РегистрНакопления.СебестоимостьТоваров.ОстаткиИОбороты(
	|		НАЧАЛОПЕРИОДА(&ОтчетныйПериод, МЕСЯЦ),
	|		КОНЕЦПЕРИОДА(&ОтчетныйПериод, МЕСЯЦ),
	|		Месяц,
	|		ДвиженияИГраницыПериода,
	|		АналитикаВидаУчета В (ВЫБРАТЬ АналитикаВидаУчета.КлючАналитики ИЗ АналитикаВидаУчета)
	|		) КАК ОстаткиИОбороты
	|		
	|		ЛЕВОЕ СОЕДИНЕНИЕ
	|			АналитикаВидаУчета КАК КлючиАналитикиВидаУчета
	|		ПО
	|			КлючиАналитикиВидаУчета.КлючАналитики = ОстаткиИОбороты.АналитикаВидаУчета
	|		
	|		ЛЕВОЕ СОЕДИНЕНИЕ
	|			АналитикаУчетаНоменклатуры КАК КлючиАналитикиУчетаНоменклатуры
	|		ПО
	|			КлючиАналитикиУчетаНоменклатуры.КлючАналитики = ОстаткиИОбороты.АналитикаУчетаНоменклатуры
	|ГДЕ
	|	КлючиАналитикиВидаУчета.Организация В (&Организация)
	|	И ОстаткиИОбороты.КоличествоКонечныйОстаток < 0
	|	И ОстаткиИОбороты.КоличествоКонечныйОстаток <> ОстаткиИОбороты.КоличествоНачальныйОстаток
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|";
	
КонецПроцедуры

// Возвращает состояние расчета себестоимости.
// Расчет выполнен успешно, без ошибок.
//
Функция Состояние_РасчетВыполнен() Экспорт
	
	Возврат "РасчетВыполнен";
	
КонецФункции

// Возвращает состояние расчета себестоимости.
// Расчет не выполнен по любой причине.
//
Функция Состояние_РасчетНеВыполнен() Экспорт
	
	Возврат "РасчетНеВыполнен";
	
КонецФункции

// Возвращает состояние расчета себестоимости.
// Расчет не может быть выполнен корректно, т.к. существуют ограничения расчета.
//
Функция Состояние_РасчетНеМожетБытьВыполнен() Экспорт
	
	Возврат "РасчетНеМожетБытьВыполнен";
	
КонецФункции

// Возвращает состояние расчета себестоимости.
// Расчет себестоимости завершился с ошибками.
//
Функция Состояние_РасчетВыполненСОшибками() Экспорт
	
	Возврат "РасчетВыполненСОшибками";
	
КонецФункции

#КонецОбласти // СлужебныеПроцедурыИФункции

#КонецЕсли
