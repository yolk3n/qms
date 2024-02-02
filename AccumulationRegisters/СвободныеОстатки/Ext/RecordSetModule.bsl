﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ
#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ, Замещение)
	
	Если ОбменДанными.Загрузка Или Не ПроведениеБольничнаяАптека.РассчитыватьИзменения(ДополнительныеСвойства) Тогда
		Возврат;
	КонецЕсли;
	
	БлокироватьДляИзменения = Истина;
	
	// Текущее состояние набора помещается во временную таблицу "ДвиженияПередЗаписью",
	// чтобы при записи получить изменение нового набора относительно текущего.
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Регистратор", Отбор.Регистратор.Значение);
	Запрос.УстановитьПараметр("ЭтоНовый", ДополнительныеСвойства.ЭтоНовый);
	Запрос.МенеджерВременныхТаблиц = ПроведениеБольничнаяАптека.ПолучитьМенеджерВременныхТаблицДляКонтроляПроведения(ДополнительныеСвойства);
	Запрос.Текст = "
	|ВЫБРАТЬ
	|	Таблица.Организация             КАК Организация,
	|	Таблица.Номенклатура            КАК Номенклатура,
	|	Таблица.СерияНоменклатуры       КАК СерияНоменклатуры,
	|	Таблица.Партия                  КАК Партия,
	|	Таблица.Склад                   КАК Склад,
	|	Таблица.МестоХранения           КАК МестоХранения,
	|	Таблица.ИсточникФинансирования  КАК ИсточникФинансирования,
	|	ВЫБОР
	|		КОГДА Таблица.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Расход)
	|			ТОГДА -Таблица.ВНаличии
	|		ИНАЧЕ 0
	|	КОНЕЦ КАК ВНаличииПередЗаписью,
	|	ВЫБОР
	|		КОГДА Таблица.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход)
	|			ТОГДА -Таблица.ВРезервеСоСклада
	|		ИНАЧЕ 0
	|	КОНЕЦ КАК ВРезервеСоСкладаПередЗаписью
	|ПОМЕСТИТЬ СвободныеОстаткиПередЗаписью
	|ИЗ
	|	РегистрНакопления.СвободныеОстатки КАК Таблица
	|ГДЕ
	|	Таблица.Регистратор = &Регистратор
	|	И НЕ &ЭтоНовый
	|";
	Запрос.Выполнить();
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ, Замещение)
	
	Если ОбменДанными.Загрузка Или Не ПроведениеБольничнаяАптека.РассчитыватьИзменения(ДополнительныеСвойства) Тогда
		Возврат;
	КонецЕсли;
	
	// Рассчитывается изменение нового набора относительно текущего с учетом накопленных изменений
	// и помещается во временную таблицу.
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Регистратор", Отбор.Регистратор.Значение);
	Запрос.МенеджерВременныхТаблиц = ПроведениеБольничнаяАптека.ПолучитьМенеджерВременныхТаблицДляКонтроляПроведения(ДополнительныеСвойства);
	Запрос.Текст = "
	|ВЫБРАТЬ
	|	Таблица.Организация                   КАК Организация,
	|	Таблица.Номенклатура                  КАК Номенклатура,
	|	Таблица.СерияНоменклатуры             КАК СерияНоменклатуры,
	|	Таблица.Партия                        КАК Партия,
	|	Таблица.Склад                         КАК Склад,
	|	Таблица.МестоХранения                 КАК МестоХранения,
	|	Таблица.ИсточникФинансирования        КАК ИсточникФинансирования,
	|	Таблица.ВНаличииПередЗаписью          КАК ВНаличииИзменение,
	|	Таблица.ВРезервеСоСкладаПередЗаписью  КАК ВРезервеСоСкладаИзменение
	|ПОМЕСТИТЬ ТаблицаИзменений
	|ИЗ
	|	СвободныеОстаткиПередЗаписью КАК Таблица
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	Таблица.Организация             КАК Организация,
	|	Таблица.Номенклатура            КАК Номенклатура,
	|	Таблица.СерияНоменклатуры       КАК СерияНоменклатуры,
	|	Таблица.Партия                  КАК Партия,
	|	Таблица.Склад                   КАК Склад,
	|	Таблица.МестоХранения           КАК МестоХранения,
	|	Таблица.ИсточникФинансирования  КАК ИсточникФинансирования,
	|	ВЫБОР
	|		КОГДА Таблица.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Расход)
	|			ТОГДА Таблица.ВНаличии
	|		ИНАЧЕ 0
	|	КОНЕЦ                           КАК ВНаличииИзменение,
	|	ВЫБОР
	|		КОГДА Таблица.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход)
	|			ТОГДА Таблица.ВРезервеСоСклада
	|		ИНАЧЕ 0
	|	КОНЕЦ                           КАК ВРезервеСоСкладаИзменение
	|ИЗ
	|	РегистрНакопления.СвободныеОстатки КАК Таблица
	|ГДЕ
	|	Таблица.Регистратор = &Регистратор
	|;
	|
	|//////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТаблицаИзменений.Организация                       КАК Организация,
	|	ТаблицаИзменений.Номенклатура                      КАК Номенклатура,
	|	ТаблицаИзменений.СерияНоменклатуры                 КАК СерияНоменклатуры,
	|	ТаблицаИзменений.Партия                            КАК Партия,
	|	ТаблицаИзменений.Склад                             КАК Склад,
	|	ТаблицаИзменений.МестоХранения                     КАК МестоХранения,
	|	ТаблицаИзменений.ИсточникФинансирования            КАК ИсточникФинансирования,
	|	СУММА(ТаблицаИзменений.ВНаличииИзменение)          КАК ВНаличииИзменение,
	|	СУММА(ТаблицаИзменений.ВРезервеСоСкладаИзменение)  КАК ВРезервеСоСкладаИзменение
	|ПОМЕСТИТЬ ДвиженияСвободныеОстаткиИзменение
	|ИЗ
	|	ТаблицаИзменений КАК ТаблицаИзменений
	|
	|СГРУППИРОВАТЬ ПО
	|	ТаблицаИзменений.Организация,
	|	ТаблицаИзменений.Номенклатура,
	|	ТаблицаИзменений.СерияНоменклатуры,
	|	ТаблицаИзменений.Партия,
	|	ТаблицаИзменений.Склад,
	|	ТаблицаИзменений.МестоХранения,
	|	ТаблицаИзменений.ИсточникФинансирования
	|
	|ИМЕЮЩИЕ
	|	СУММА(ТаблицаИзменений.ВНаличииИзменение) > 0
	|	ИЛИ СУММА(ТаблицаИзменений.ВРезервеСоСкладаИзменение) > 0
	|;
	|
	|//////////////////////////////////////////////////////////////////////////////
	|УНИЧТОЖИТЬ СвободныеОстаткиПередЗаписью
	|;
	|
	|//////////////////////////////////////////////////////////////////////////////
	|УНИЧТОЖИТЬ ТаблицаИзменений
	|";
	
	Выборка = Запрос.ВыполнитьПакет()[1].Выбрать();
	Выборка.Следующий();
	
	// Новые изменения были помещены во временную таблицу "ДвиженияСвободныеОстаткиИзменение".
	// Добавляется информация о ее существовании и наличии в ней записей об изменении.
	Если Выборка.Количество > 0 Тогда
		ПроведениеБольничнаяАптека.ДобавитьПараметрыКонтроля(
			ДополнительныеСвойства,
			ТекстЗапросаПроверки(),
			РегистрыНакопления.СвободныеОстатки);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти // ОбработчикиСобытий

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ
#Область СлужебныеПроцедурыИФункции

Функция ТекстЗапросаПроверки()
	
	ТекстЗапроса = "
	|ВЫБРАТЬ
	|	ТаблицаОстатков.Организация                        КАК Организация,
	|	ТаблицаОстатков.Номенклатура                       КАК Номенклатура,
	|	ТаблицаОстатков.Номенклатура.ОсновнаяЕдиницаУчета  КАК Упаковка,
	|	ТаблицаОстатков.СерияНоменклатуры                  КАК СерияНоменклатуры,
	|	ТаблицаОстатков.Партия                             КАК Партия,
	|	ТаблицаОстатков.Склад                              КАК Склад,
	|	ТаблицаОстатков.МестоХранения                      КАК МестоХранения,
	|	ТаблицаОстатков.ИсточникФинансирования             КАК ИсточникФинансирования,
	|	ТаблицаОстатков.ВНаличииОстаток                    КАК ВНаличии,
	|	ТаблицаОстатков.ВРезервеСоСкладаОстаток            КАК ВРезервеСоСклада
	|ИЗ
	|	РегистрНакопления.СвободныеОстатки.Остатки(,
	|			(Организация, Номенклатура, СерияНоменклатуры, Партия, Склад, МестоХранения, ИсточникФинансирования) В
	|				(ВЫБРАТЬ
	|					Таблица.Организация,
	|					Таблица.Номенклатура,
	|					Таблица.СерияНоменклатуры,
	|					Таблица.Партия,
	|					Таблица.Склад,
	|					Таблица.МестоХранения,
	|					Таблица.ИсточникФинансирования
	|				ИЗ
	|					ДвиженияСвободныеОстаткиИзменение КАК Таблица)
	|	) КАК ТаблицаОстатков
	|
	|ГДЕ
	|	ТаблицаОстатков.ВНаличииОстаток < 0
	|	ИЛИ (ТаблицаОстатков.ВНаличииОстаток - ТаблицаОстатков.ВРезервеСоСкладаОстаток) < 0
	|";
	
	Возврат ТекстЗапроса;
	
КонецФункции

#КонецОбласти // СлужебныеПроцедурыИФункции

#КонецЕсли