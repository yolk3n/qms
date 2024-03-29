﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ
#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка)
	
	ТипДанныхЗаполнения = ТипЗнч(ДанныеЗаполнения);
	
	Если ТипДанныхЗаполнения = Тип("ДокументСсылка.ТребованиеОтделения") Тогда
		ЗаполнитьДокументНаОснованииТребованияОтделения(ДанныеЗаполнения);
	ИначеЕсли ТипДанныхЗаполнения = Тип("ДокументСсылка.ПоступлениеТоваров") Тогда
		ЗаполнитьДокументНаОснованииПоступленияТоваров(ДанныеЗаполнения);
	ИначеЕсли ТипДанныхЗаполнения = Тип("ДокументСсылка.ПеремещениеТоваров") Тогда
		ЗаполнитьДокументНаОснованииПеремещенияТоваров(ДанныеЗаполнения);
	ИначеЕсли ТипДанныхЗаполнения = Тип("ДокументСсылка.ИзготовлениеПоЛекарственнойПрописи") Тогда
		ЗаполнитьДокументНаОснованииИзготовления(ДанныеЗаполнения);
	ИначеЕсли ТипДанныхЗаполнения = Тип("ДокументСсылка.ПрочееОприходованиеТоваров") Тогда
		ЗаполнитьДокументНаОснованииОприходованияТоваров(ДанныеЗаполнения);
	ИначеЕсли ТипДанныхЗаполнения = Тип("Структура") Тогда
		ЗаполнитьДокументПоОтбору(ДанныеЗаполнения);
	КонецЕсли;
	
	ИнициализироватьДокумент();
	
	ЗаполнитьПоЗначениямАвтозаполнения();
	
	ОбщегоНазначенияБольничнаяАптека.ЗаполнитьРеквизитыПоСкладу(ЭтотОбъект, "СкладОтправитель");
	
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	
	Статус = Перечисления.СтатусыПеремещенийТоваров.КОтгрузке;
	
	Согласован = Ложь;
	ПеремещениеПоЗаказу = Ложь;
	ТребованиеОтделения = Документы.ТребованиеОтделения.ПустаяСсылка();
	
	Для Каждого ТекущаяСтрока Из Товары Цикл
		ТекущаяСтрока.КодСтроки = 0;
		ТекущаяСтрока.НоменклатураЗаказа = Неопределено;
		ТекущаяСтрока.ЕдиницаИзмеренияЗаказа = Неопределено;
		ТекущаяСтрока.КоличествоВЕдиницахЗаказа = 0;
		ТекущаяСтрока.КоэффициентЕдиницыЗаказа = 0;
	КонецЦикла;
	
	ЗапасыСервер.ЗаполнитьСтатусыУчетаНоменклатуры(ЭтотОбъект, ЗапасыСервер.ПолучитьПараметрыУчетаНоменклатуры(ЭтотОбъект));
	
	ИнициализироватьДокумент();
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	НепроверяемыеРеквизиты = Новый Массив;
	
	ОбработкаТабличнойЧастиСервер.ПроверитьЗаполнениеКоличества(ЭтотОбъект, НепроверяемыеРеквизиты, Отказ);
	ОбработкаТабличнойЧастиСервер.ПроверитьЗаполнениеИсточникаФинансирования(ЭтотОбъект, НепроверяемыеРеквизиты, Отказ);
	
	ПараметрыУчетаНоменклатуры = ЗапасыСервер.ПолучитьПараметрыУчетаНоменклатуры(ЭтотОбъект);
	ЗапасыСервер.ПроверитьЗаполнениеСерийНоменклатуры(ЭтотОбъект, ПараметрыУчетаНоменклатуры, НепроверяемыеРеквизиты, Отказ);
	ЗапасыСервер.ПроверитьЗаполнениеПартийНоменклатуры(ЭтотОбъект, ПараметрыУчетаНоменклатуры, НепроверяемыеРеквизиты, Отказ);
	
	Если СкладыСервер.ВестиСкладскойУчетВОтделении(Отделение, Дата) Тогда
		НепроверяемыеРеквизиты.Добавить("Товары.СтатьяРасходов");
		НепроверяемыеРеквизиты.Добавить("Товары.АналитикаРасходов");
	Иначе
		ПланыВидовХарактеристик.СтатьиРасходов.ПроверитьЗаполнениеАналитик(ЭтотОбъект, Новый Структура("Товары"), НепроверяемыеРеквизиты, Отказ);
	КонецЕсли;
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, НепроверяемыеРеквизиты);
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	//Мод = бит_ИнтеграцияQMSСерверПовтИсп.ОбъектМодифицирован(ЭтотОбъект);
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);
	
	ДополнительныеСвойства.Вставить("ЭтоНовый"   , ЭтоНовый());
	ДополнительныеСвойства.Вставить("РежимЗаписи", РежимЗаписи);
	
	ОбработкаТабличнойЧастиСервер.ОкруглитьКоличествоШтучныхТоваров(ЭтотОбъект, РежимЗаписи);
	
	ОбщегоНазначенияБольничнаяАптека.ИзменитьПризнакСогласованностиДокумента(
		ЭтотОбъект,
		РежимЗаписи);
	
	Если РежимЗаписи = РежимЗаписиДокумента.Проведение Тогда
		ОбработкаТабличнойЧастиСервер.ЗаполнитьИсточникФинансирования(ЭтотОбъект);
	КонецЕсли;
	
	ПараметрыУчетаНоменклатуры = ЗапасыСервер.ПолучитьПараметрыУчетаНоменклатуры(ЭтотОбъект);
	ЗапасыСервер.ОчиститьНеиспользуемыеРеквизиты(ЭтотОбъект, ПараметрыУчетаНоменклатуры);
	
	ЗаполнитьСписокЗависимыхЗаказов();
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	ПроведениеБольничнаяАптека.СформироватьДвиженияПоРегистрам(ЭтотОбъект, Отказ, РежимПроведения);
	
	РегистрыСведений.СостоянияВнутреннихЗаказов.ОтразитьСостояниеЗаказа(ДополнительныеСвойства.ЗависимыеЗаказы);
	//-Чиков А.В.  - Закомментировал Отказ = Ложь
	//Отказ = Ложь;
	//-Чиков А.В.
	
	//++бит_ИнтеграцияQMS
	//Регистрация документа к обмену
	Если ЭтотОбъект.Статус = Перечисления.СтатусыПеремещенийТоваров.Принято И
		Не ЭтотОбъект.Бит_ОтправленВQMS И
		ЭтотОбъект.Проведен Тогда
		бит_ИнтеграцияQMSСервер.ЗарегистрироватьОбъектКОбмену(ЭтотОбъект);
	КонецЕсли;
	//--бит_ИнтеграцияQMS	
КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)
	
	ПроведениеБольничнаяАптека.СформироватьДвиженияПоРегистрам(ЭтотОбъект, Отказ);
	
	РегистрыСведений.СостоянияВнутреннихЗаказов.ОтразитьСостояниеЗаказа(ДополнительныеСвойства.ЗависимыеЗаказы);
	
КонецПроцедуры

#КонецОбласти // ОбработчикиСобытий

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ОБЩЕГО НАЗНАЧЕНИЯ
#Область СлужебныеПроцедурыИФункции

////////////////////////////////////////////////////////////////////////////////
// Инициализация и заполнение документа
#Область ИнициализацияИЗаполнение

Процедура ИнициализироватьДокумент()
	
	Автор = Пользователи.ТекущийПользователь();
	Ответственный = Пользователи.ТекущийПользователь();
	
	ЗаполнитьПоляПоУмолчанию();
	
	Если Не ПолучитьФункциональнуюОпцию("ИспользоватьСтатусыОтпусковТоваровВОтделения") Тогда
		Статус = Перечисления.СтатусыПеремещенийТоваров.Принято;
	КонецЕсли;
	
КонецПроцедуры

Процедура ЗаполнитьПоляПоУмолчанию()
	
	Организация = ЗначениеНастроекБольничнаяАптекаПовтИсп.ПолучитьОрганизациюПоУмолчанию(Организация);
	ПодразделениеОрганизации = ЗначениеНастроекБольничнаяАптекаПовтИсп.ПолучитьПодразделениеПоУмолчанию(ПодразделениеОрганизации, Организация);
	СкладОтправитель = ЗначениеНастроекБольничнаяАптекаПовтИсп.ПолучитьСкладАптекиПоУмолчанию(СкладОтправитель, ПодразделениеОрганизации);
	
КонецПроцедуры

Процедура ЗаполнитьПоЗначениямАвтозаполнения()
	
	ОбщегоНазначенияБольничнаяАптека.ЗаполнитьПоЗначениямАвтозаполнения(ЭтотОбъект, Неопределено, "Организация, СкладОтправитель");
	ОбщегоНазначенияБольничнаяАптека.ЗаполнитьПоЗначениямАвтозаполнения(ЭтотОбъект, Неопределено, "ПодразделениеОрганизации", "Организация");
	
КонецПроцедуры

Процедура ЗаполнитьДокументПоОтбору(ДанныеЗаполнения)
	
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, ДанныеЗаполнения);
	ОбщегоНазначенияБольничнаяАптека.ПроверитьЗаполнениеПодразделенияОрганизации(ЭтотОбъект);
	ОбщегоНазначенияБольничнаяАптека.ПроверитьЗаполнениеПодразделенияОрганизации(ЭтотОбъект, "Отделение");
	
КонецПроцедуры

Процедура ЗаполнитьДокументНаОснованииТребованияОтделения(ДокументОснование)
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ДокументОснование", ДокументОснование);
	Запрос.Текст = "
	|ВЫБРАТЬ
	|	Документ.Ссылка                    КАК ТребованиеОтделения,
	|	Документ.Организация               КАК Организация,
	|	Документ.ПодразделениеОрганизации  КАК ПодразделениеОрганизации,
	|	Документ.СкладПолучатель           КАК СкладПолучатель,
	|	Документ.СкладОтправитель          КАК СкладОтправитель,
	|	Документ.Отделение                 КАК Отделение,
	|	Документ.ИсточникФинансирования    КАК ИсточникФинансирования,
	|	Документ.Статус                    КАК СтатусДокумента,
	|	НЕ Документ.Проведен               КАК ЕстьОшибкиПроведен,
	|	ВЫБОР
	|		КОГДА
	|			Документ.Статус В (&ДопустимыеСтатусы)
	|			ИЛИ Документ.Статус = ЗНАЧЕНИЕ(Перечисление.СтатусыТребованийОтделений.Исполнен)
	|			ИЛИ Документ.Статус = ЗНАЧЕНИЕ(Перечисление.СтатусыТребованийОтделений.Закрыт)
	|		ТОГДА
	|			ЛОЖЬ
	|		ИНАЧЕ
	|			ИСТИНА
	|	КОНЕЦ                              КАК ЕстьОшибкиСтатус
	|ИЗ
	|	Документ.ТребованиеОтделения КАК Документ
	|ГДЕ
	|	Документ.Ссылка = &ДокументОснование
	|";
	
	ДопустимыеСтатусы = Новый Массив();
	ДопустимыеСтатусы.Добавить(Перечисления.СтатусыТребованийОтделений.КВыполнению);
	Запрос.УстановитьПараметр("ДопустимыеСтатусы", ДопустимыеСтатусы);
	
	РеквизитыТребования = Запрос.Выполнить().Выбрать();
	РеквизитыТребования.Следующий();
	
	ОбщегоНазначенияБольничнаяАптека.ПроверитьВозможностьВводаНаОсновании(
		РеквизитыТребования.ТребованиеОтделения,
		РеквизитыТребования.ЕстьОшибкиПроведен,
		РеквизитыТребования.СтатусДокумента,
		РеквизитыТребования.ЕстьОшибкиСтатус,
		ДопустимыеСтатусы);
		
		Запрос.Текст = "
		|ВЫБРАТЬ
		|	ОстаткиЗаказа.ЗаказНаПеремещение КАК ЗаказНаПеремещение,
		|	ОстаткиЗаказа.КОформлениюОстаток КАК КОформлениюОстаток
		|ИЗ
		|	РегистрНакопления.ЗаказыНаПеремещение.Остатки(, ЗаказНаПеремещение = &ДокументОснование) КАК ОстаткиЗаказа
		|";
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Если РезультатЗапроса.Пустой() Тогда
		
		СообщениеОбОшибке = НСтр("ru = 'Нет данных для заполнения по документу ""%ДокументОснование%"" .'");
		СообщениеОбОшибке = СтрЗаменить(СообщениеОбОшибке, "%ДокументОснование%", ДокументОснование);
		ВызватьИсключение СообщениеОбОшибке;
		
	КонецЕсли;
	
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, РеквизитыТребования);
	ПеремещениеПоЗаказу = Истина;
	
КонецПроцедуры

Процедура ЗаполнитьДокументНаОснованииПоступленияТоваров(ДокументОснование)
	
	Запрос = Новый Запрос;
	Запрос.Текст = "
	|ВЫБРАТЬ
	|	Документ.Ссылка                    КАК Ссылка,
	|	Документ.Организация               КАК Организация,
	|	Документ.Склад                     КАК СкладОтправитель,
	|	Документ.ПодразделениеОрганизации  КАК ПодразделениеОрганизации,
	|	Документ.ИсточникФинансирования    КАК ИсточникФинансирования,
	|	НЕ Документ.Проведен               КАК ЕстьОшибкиПроведен,
	|	НЕОПРЕДЕЛЕНО                       КАК Статус,
	|	ЛОЖЬ                               КАК ЕстьОшибкиСтатус
	|ИЗ
	|	Документ.ПоступлениеТоваров КАК Документ
	|ГДЕ
	|	Документ.Ссылка = &ДокументОснование
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Товары.Номенклатура                  КАК Номенклатура,
	|	Товары.СерияНоменклатуры             КАК СерияНоменклатуры,
	|	Товары.Партия                        КАК Партия,
	|	Товары.ЕдиницаИзмерения              КАК ЕдиницаИзмерения,
	|	Товары.Коэффициент                   КАК Коэффициент,
	|	Товары.КоличествоВЕдиницахИзмерения  КАК КоличествоВЕдиницахИзмерения,
	|	Товары.Количество                    КАК Количество
	|ИЗ
	|	Документ.ПоступлениеТоваров.Товары КАК Товары
	|ГДЕ
	|	Товары.Ссылка = &ДокументОснование
	|
	|УПОРЯДОЧИТЬ ПО
	|	Товары.НомерСтроки
	|";
	
	Запрос.УстановитьПараметр("ДокументОснование", ДокументОснование);
	ДопустимыеСтатусы = Новый Массив;
	Запрос.УстановитьПараметр("ДопустимыеСтатусы", ДопустимыеСтатусы);
	
	РезультатЗапроса = Запрос.ВыполнитьПакет();
	
	Шапка = РезультатЗапроса[0].Выбрать();
	Шапка.Следующий();
	
	ОбщегоНазначенияБольничнаяАптека.ПроверитьВозможностьВводаНаОсновании(
		Шапка.Ссылка,
		Шапка.ЕстьОшибкиПроведен,
		Шапка.Статус,
		Шапка.ЕстьОшибкиСтатус,
		ДопустимыеСтатусы);
	
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, Шапка);
	
	Выборка = РезультатЗапроса[1].Выбрать();
	Пока Выборка.Следующий() Цикл
		СтрокаТовары = Товары.Добавить();
		ЗаполнитьЗначенияСвойств(СтрокаТовары, Выборка);
	КонецЦикла;
	
	ЗапасыСервер.ЗаполнитьСтатусыУчетаНоменклатуры(ЭтотОбъект, ЗапасыСервер.ПолучитьПараметрыУчетаНоменклатуры(ЭтотОбъект));
	
КонецПроцедуры

Процедура ЗаполнитьДокументНаОснованииПеремещенияТоваров(ДокументОснование)
	
	Запрос = Новый Запрос;
	Запрос.Текст = "
	|ВЫБРАТЬ
	|	Документ.Ссылка                  КАК Ссылка,
	|	ВЫБОР
	|		КОГДА Документ.ХозяйственнаяОперация = ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ПеремещениеТоваровМеждуФилиалами)
	|			ТОГДА Документ.ОрганизацияПолучатель
	|		ИНАЧЕ Документ.Организация
	|	КОНЕЦ                            КАК Организация,
	|	Документ.СкладПолучатель         КАК СкладОтправитель,
	|	Документ.ИсточникФинансирования  КАК ИсточникФинансирования,
	|	НЕ Документ.Проведен             КАК ЕстьОшибкиПроведен,
	|	Документ.Статус                  КАК Статус,
	|	ВЫБОР
	|		КОГДА Документ.Статус В (&ДопустимыеСтатусы)
	|			ТОГДА ЛОЖЬ
	|		ИНАЧЕ ИСТИНА
	|	КОНЕЦ                            КАК ЕстьОшибкиСтатус
	|ИЗ
	|	Документ.ПеремещениеТоваров КАК Документ
	|ГДЕ
	|	Документ.Ссылка = &ДокументОснование
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Товары.Номенклатура                  КАК Номенклатура,
	|	Товары.СерияНоменклатуры             КАК СерияНоменклатуры,
	|	Товары.Партия                        КАК Партия,
	|	Товары.ИсточникФинансирования        КАК ИсточникФинансирования,
	|	Товары.ЕдиницаИзмерения              КАК ЕдиницаИзмерения,
	|	Товары.Коэффициент                   КАК Коэффициент,
	|	Товары.Количество                    КАК Количество,
	|	Товары.КоличествоВЕдиницахИзмерения  КАК КоличествоВЕдиницахИзмерения
	|ИЗ
	|	Документ.ПеремещениеТоваров.Товары КАК Товары
	|ГДЕ
	|	Товары.Ссылка = &ДокументОснование
	|
	|УПОРЯДОЧИТЬ ПО
	|	Товары.НомерСтроки
	|";
	
	Запрос.УстановитьПараметр("ДокументОснование", ДокументОснование);
	ДопустимыеСтатусы = Новый Массив;
	ДопустимыеСтатусы.Добавить(Перечисления.СтатусыПеремещенийТоваров.Принято);
	Запрос.УстановитьПараметр("ДопустимыеСтатусы", ДопустимыеСтатусы);
	
	РезультатЗапроса = Запрос.ВыполнитьПакет();
	
	Шапка = РезультатЗапроса[0].Выбрать();
	Шапка.Следующий();
	
	ОбщегоНазначенияБольничнаяАптека.ПроверитьВозможностьВводаНаОсновании(
		Шапка.Ссылка,
		Шапка.ЕстьОшибкиПроведен,
		Шапка.Статус,
		Шапка.ЕстьОшибкиСтатус,
		ДопустимыеСтатусы);
	
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, Шапка);
	
	Выборка = РезультатЗапроса[1].Выбрать();
	Пока Выборка.Следующий() Цикл
		СтрокаТовары = Товары.Добавить();
		ЗаполнитьЗначенияСвойств(СтрокаТовары, Выборка);
	КонецЦикла;
	
	ЗапасыСервер.ЗаполнитьСтатусыУчетаНоменклатуры(ЭтотОбъект, ЗапасыСервер.ПолучитьПараметрыУчетаНоменклатуры(ЭтотОбъект));
	
КонецПроцедуры

Процедура ЗаполнитьДокументНаОснованииИзготовления(ДокументОснование)
	
	Запрос = Новый Запрос;
	Запрос.Текст = "
	|ВЫБРАТЬ
	|	Документ.Ссылка                    КАК Ссылка,
	|	Документ.Организация               КАК Организация,
	|	Документ.Склад                     КАК СкладОтправитель,
	|	Документ.ПодразделениеОрганизации  КАК ПодразделениеОрганизации,
	|	Документ.ИсточникФинансирования    КАК ИсточникФинансирования,
	|	НЕ Документ.Проведен               КАК ЕстьОшибкиПроведен,
	|	Документ.Статус                    КАК Статус,
	|	ВЫБОР
	|		КОГДА Документ.Статус В (&ДопустимыеСтатусы)
	|			ТОГДА ЛОЖЬ
	|		ИНАЧЕ ИСТИНА
	|	КОНЕЦ                              КАК ЕстьОшибкиСтатус
	|ИЗ
	|	Документ.ИзготовлениеПоЛекарственнойПрописи КАК Документ
	|ГДЕ
	|	Документ.Ссылка = &ДокументОснование
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Продукция.Номенклатура                  КАК Номенклатура,
	|	Продукция.СерияНоменклатуры             КАК СерияНоменклатуры,
	|	Продукция.Партия                        КАК Партия,
	|	Продукция.ЕдиницаИзмерения              КАК ЕдиницаИзмерения,
	|	Продукция.Коэффициент                   КАК Коэффициент,
	|	Продукция.Количество                    КАК Количество,
	|	Продукция.КоличествоВЕдиницахИзмерения  КАК КоличествоВЕдиницахИзмерения
	|ИЗ
	|	Документ.ИзготовлениеПоЛекарственнойПрописи КАК Продукция
	|ГДЕ
	|	Продукция.Ссылка = &ДокументОснование
	|";
	
	Запрос.УстановитьПараметр("ДокументОснование", ДокументОснование);
	ДопустимыеСтатусы = Новый Массив;
	ДопустимыеСтатусы.Добавить(Перечисления.СтатусыИзготовлений.Изготовлено);
	Запрос.УстановитьПараметр("ДопустимыеСтатусы", ДопустимыеСтатусы);
	
	РезультатЗапроса = Запрос.ВыполнитьПакет();
	
	Шапка = РезультатЗапроса[0].Выбрать();
	Шапка.Следующий();
	
	ОбщегоНазначенияБольничнаяАптека.ПроверитьВозможностьВводаНаОсновании(
		Шапка.Ссылка,
		Шапка.ЕстьОшибкиПроведен,
		Шапка.Статус,
		Шапка.ЕстьОшибкиСтатус,
		ДопустимыеСтатусы);
	
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, Шапка);
	
	Выборка = РезультатЗапроса[1].Выбрать();
	Пока Выборка.Следующий() Цикл
		СтрокаТовары = Товары.Добавить();
		ЗаполнитьЗначенияСвойств(СтрокаТовары, Выборка);
	КонецЦикла;
	
	ЗапасыСервер.ЗаполнитьСтатусыУчетаНоменклатуры(ЭтотОбъект, ЗапасыСервер.ПолучитьПараметрыУчетаНоменклатуры(ЭтотОбъект));
	
КонецПроцедуры

Процедура ЗаполнитьДокументНаОснованииОприходованияТоваров(ДокументОснование)
	
	Запрос = Новый Запрос;
	Запрос.Текст = "
	|ВЫБРАТЬ
	|	Документ.Ссылка                    КАК Ссылка,
	|	Документ.Организация               КАК Организация,
	|	Документ.Склад                     КАК СкладОтправитель,
	|	Документ.ПодразделениеОрганизации  КАК ПодразделениеОрганизации,
	|	Документ.ИсточникФинансирования    КАК ИсточникФинансирования,
	|	НЕ Документ.Проведен               КАК ЕстьОшибкиПроведен,
	|	НЕОПРЕДЕЛЕНО                       КАК Статус,
	|	ЛОЖЬ                               КАК ЕстьОшибкиСтатус
	|ИЗ
	|	Документ.ПрочееОприходованиеТоваров КАК Документ
	|ГДЕ
	|	Документ.Ссылка = &ДокументОснование
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Товары.Номенклатура                  КАК Номенклатура,
	|	Товары.СерияНоменклатуры             КАК СерияНоменклатуры,
	|	Товары.Партия                        КАК Партия,
	|	Товары.ЕдиницаИзмерения              КАК ЕдиницаИзмерения,
	|	Товары.Коэффициент                   КАК Коэффициент,
	|	Товары.КоличествоВЕдиницахИзмерения  КАК КоличествоВЕдиницахИзмерения,
	|	Товары.Количество                    КАК Количество
	|ИЗ
	|	Документ.ПрочееОприходованиеТоваров.Товары КАК Товары
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ПартииНоменклатуры КАК ПартииНоменклатуры
	|		ПО
	|			Товары.Ссылка = ПартииНоменклатуры.ДокументОприходования
	|ГДЕ
	|	Товары.Ссылка = &ДокументОснование
	|
	|УПОРЯДОЧИТЬ ПО
	|	Товары.НомерСтроки
	|";
	
	Запрос.УстановитьПараметр("ДокументОснование", ДокументОснование);
	ДопустимыеСтатусы = Новый Массив;
	Запрос.УстановитьПараметр("ДопустимыеСтатусы", ДопустимыеСтатусы);
	
	РезультатЗапроса = Запрос.ВыполнитьПакет();
	
	Шапка = РезультатЗапроса[0].Выбрать();
	Шапка.Следующий();
	
	ОбщегоНазначенияБольничнаяАптека.ПроверитьВозможностьВводаНаОсновании(
		Шапка.Ссылка,
		Шапка.ЕстьОшибкиПроведен,
		Шапка.Статус,
		Шапка.ЕстьОшибкиСтатус,
		ДопустимыеСтатусы);
	
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, Шапка);
	
	Выборка = РезультатЗапроса[1].Выбрать();
	Пока Выборка.Следующий() Цикл
		СтрокаТовары = Товары.Добавить();
		ЗаполнитьЗначенияСвойств(СтрокаТовары, Выборка);
	КонецЦикла;
	
	ЗапасыСервер.ЗаполнитьСтатусыУчетаНоменклатуры(ЭтотОбъект, ЗапасыСервер.ПолучитьПараметрыУчетаНоменклатуры(ЭтотОбъект));
	
КонецПроцедуры

#КонецОбласти // ИнициализацияИЗаполнение

////////////////////////////////////////////////////////////////////////////////
// Прочее
#Область Прочее

Функция СписокРегистровДляКонтроля() Экспорт
	
	РегистрыДляКонтроля = Новый Массив;
	
	// Приходы в регистр (сторно расхода из регистра) контролируем при перепроведении и отмене проведения
	РегистрыДляКонтроля.Добавить(Движения.СебестоимостьТоваров);
	
	Если ДополнительныеСвойства.РежимЗаписи = РежимЗаписиДокумента.Проведение Тогда
		РегистрыДляКонтроля.Добавить(Движения.ЗаказыНаПеремещение);
		РегистрыДляКонтроля.Добавить(Движения.СвободныеОстатки);
	КонецЕсли;
	
	Возврат РегистрыДляКонтроля;
	
КонецФункции

Процедура ЗаполнитьСписокЗависимыхЗаказов()
	
	СписокЗаказов = Новый Массив;
	Если ПеремещениеПоЗаказу Тогда
		СписокЗаказов.Добавить(ТребованиеОтделения);
	КонецЕсли;
	
	Если Не ЭтоНовый() Тогда
		РеквизитыДоЗаписи = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Ссылка, "ПеремещениеПоЗаказу, ТребованиеОтделения");
		Если РеквизитыДоЗаписи.ПеремещениеПоЗаказу Тогда
			Если СписокЗаказов.Найти(РеквизитыДоЗаписи.ТребованиеОтделения) = Неопределено Тогда
				СписокЗаказов.Добавить(РеквизитыДоЗаписи.ТребованиеОтделения);
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
	ДополнительныеСвойства.Вставить("ЗависимыеЗаказы", СписокЗаказов);
	
КонецПроцедуры

#КонецОбласти // Прочее

#КонецОбласти // СлужебныеПроцедурыИФункции

////////////////////////////////////////////////////////////////////////////////
// СТАНДАРТНЫЕ ПОДСИСТЕМЫ
#Область СтандартныеПодсистемы

// Процедура ЗаполнитьНаборыЗначенийДоступа заполняет наборы значений доступа
// по объекту в таблице с полями:
//  - НомерНабора     Число                                     (необязательно, если набор один),
//  - ВидДоступа      ПланВидовХарактеристикСсылка.ВидыДоступа, (обязательно),
//  - ЗначениеДоступа Неопределено, СправочникСсылка или др.    (обязательно),
//  - Чтение          Булево (необязательно, если набор для всех прав; устанавливается для одной строки набора),
//  - Добавление      Булево (необязательно, если набор для всех прав; устанавливается для одной строки набора),
//  - Изменение       Булево (необязательно, если набор для всех прав; устанавливается для одной строки набора),
//  - Удаление        Булево (необязательно, если набор для всех прав; устанавливается для одной строки набора).
//
//  Вызывается из процедуры УправлениеДоступом.ЗаписатьНаборыЗначенийДоступа(),
// если объект зарегистрирован в "ПодпискаНаСобытие.ЗаписатьНаборыЗначенийДоступа" и
// из таких же процедур объектов, у которых наборы значений доступа зависят от наборов этого
// объекта (в этом случае объект зарегистрирован в "ПодпискаНаСобытие.ЗаписатьЗависимыеНаборыЗначенийДоступа").
//
// Параметры:
//  Таблица      - ТабличнаяЧасть,
//                 РегистрСведенийНаборЗаписей.НаборыЗначенийДоступа,
//                 ТаблицаЗначений, возвращаемая УправлениеДоступом.ТаблицаНаборыЗначенийДоступа().
//
Процедура ЗаполнитьНаборыЗначенийДоступа(Таблица) Экспорт
	
	СтрокаТаб = Таблица.Добавить();
	СтрокаТаб.НомерНабора     = 1;
	СтрокаТаб.ЗначениеДоступа = Организация;
	
	СтрокаТаб = Таблица.Добавить();
	СтрокаТаб.НомерНабора     = 1;
	СтрокаТаб.ЗначениеДоступа = СкладОтправитель;
	
	СтрокаТаб = Таблица.Добавить();
	СтрокаТаб.НомерНабора     = 1;
	СтрокаТаб.ЗначениеДоступа = ПодразделениеОрганизации;
	
	Если Проведен И Статус <> Перечисления.СтатусыПеремещенийТоваров.КОтгрузке Тогда
		
		СтрокаТаб = Таблица.Добавить();
		СтрокаТаб.НомерНабора     = 2;
		СтрокаТаб.Чтение          = Истина;
		СтрокаТаб.ЗначениеДоступа = Организация;
		
		СтрокаТаб = Таблица.Добавить();
		СтрокаТаб.НомерНабора     = 2;
		СтрокаТаб.ЗначениеДоступа = СкладПолучатель;
		
		СтрокаТаб = Таблица.Добавить();
		СтрокаТаб.НомерНабора     = 2;
		СтрокаТаб.ЗначениеДоступа = Отделение;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти // СтандартныеПодсистемы

#КонецЕсли