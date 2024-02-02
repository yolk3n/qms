﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ
#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка)
	
	ТипДанныхЗаполнения = ТипЗнч(ДанныеЗаполнения);
	
	Если ТипДанныхЗаполнения = Тип("ДокументСсылка.ОтпускТоваровВОтделение") Тогда
		ЗаполнитьДокументНаОснованииОтпускаВОтделение(ДанныеЗаполнения);
	ИначеЕсли ТипДанныхЗаполнения = Тип("ДокументСсылка.ОприходованиеИзлишковТоваровВОтделении") Тогда
		ЗаполнитьДокументНаОснованииОприходованияТоваров(ДанныеЗаполнения);
	ИначеЕсли ТипДанныхЗаполнения = Тип("ДокументСсылка.ПеремещениеТоваровМеждуОтделениями") Тогда
		ЗаполнитьДокументНаОснованииПеремещенияТоваров(ДанныеЗаполнения);
	ИначеЕсли ТипДанныхЗаполнения = Тип("ДокументСсылка.ВводОстатков") Тогда
		ЗаполнитьДокументНаОснованииВводаОстатков(ДанныеЗаполнения);
	ИначеЕсли ТипДанныхЗаполнения = Тип("Структура") Тогда
		ЗаполнитьДокументПоОтбору(ДанныеЗаполнения);
	КонецЕсли;
	
	ИнициализироватьДокумент();
	
	ЗаполнитьПоЗначениямАвтозаполнения();
	
	Если ЗначениеЗаполнено(Склад) Тогда
		
		ВедетсяУчетПоМестамХранения = ПолучитьФункциональнуюОпцию(
			"ИспользоватьМестаХранения",
			Новый Структура("Склад", Склад));
		Если Не ВедетсяУчетПоМестамХранения Тогда
			Склад = Неопределено;
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	
	ИнициализироватьДокумент();
	
	ЗапасыСервер.ЗаполнитьСтатусыУчетаНоменклатуры(ЭтотОбъект, ЗапасыСервер.ПолучитьПараметрыУчетаНоменклатуры(ЭтотОбъект));
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	НепроверяемыеРеквизиты = Новый Массив;
	
	ОбработкаТабличнойЧастиСервер.ПроверитьЗаполнениеКоличества(ЭтотОбъект, НепроверяемыеРеквизиты, Отказ);
	ОбработкаТабличнойЧастиСервер.ПроверитьЗаполнениеИсточникаФинансирования(ЭтотОбъект, НепроверяемыеРеквизиты, Отказ);
	
	СкладыСервер.ПроверитьВедениеСкладскогоУчетаВОтделении(ЭтотОбъект, Отказ);
	
	ПараметрыУчетаНоменклатуры = ЗапасыСервер.ПолучитьПараметрыУчетаНоменклатуры(ЭтотОбъект);
	ЗапасыСервер.ПроверитьЗаполнениеСерийНоменклатуры(ЭтотОбъект, ПараметрыУчетаНоменклатуры, НепроверяемыеРеквизиты, Отказ);
	ЗапасыСервер.ПроверитьЗаполнениеПартийНоменклатуры(ЭтотОбъект, ПараметрыУчетаНоменклатуры, НепроверяемыеРеквизиты, Отказ);
	
	ВсеРеквизиты = Неопределено;
	РеквизитыОперации = Неопределено;
	Документы.РазмещениеТоваровПоМестамХраненияВОтделении.ЗаполнитьИменаРеквизитовПоТипуОперации(ХозяйственнаяОперация, ВсеРеквизиты, РеквизитыОперации);
	ОбщегоНазначенияБольничнаяАптекаКлиентСервер.ЗаполнитьНепроверяемыеРеквизиты(НепроверяемыеРеквизиты, ВсеРеквизиты, РеквизитыОперации);
	
	Если ХозяйственнаяОперация = Перечисления.ОперацииРазмещенияПоМестамХраненияВОтделении.РазмещениеПоМестамХранения Тогда
		Для Каждого СтрокаРазмещения Из Товары Цикл
			
			АдресОшибки = " " + НСтр("ru='в строке %1 списка ""Товары""'");
			АдресОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(АдресОшибки, СтрокаРазмещения.НомерСтроки);
			
			Если СтрокаРазмещения.МестоХранения = СтрокаРазмещения.МестоХраненияНовое Тогда
				
				ТекстОшибки = НСтр("ru = 'Одно место хранения не может быть как отправителем, так и получателем. Измените одно из мест хранения'");
				ОбщегоНазначения.СообщитьПользователю(
					ТекстОшибки + АдресОшибки,
					ЭтотОбъект,
					ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("Товары", СтрокаРазмещения.НомерСтроки, "МестоХраненияНовое"),
					,
					Отказ);
				
			КонецЕсли;
			
		КонецЦикла;
	КонецЕсли;
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, НепроверяемыеРеквизиты);
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);
	
	ДополнительныеСвойства.Вставить("ЭтоНовый", ЭтоНовый());
	ДополнительныеСвойства.Вставить("РежимЗаписи", РежимЗаписи);
	
	ОбработкаТабличнойЧастиСервер.ОкруглитьКоличествоШтучныхТоваров(ЭтотОбъект, РежимЗаписи);
	
	Если ХозяйственнаяОперация <> Перечисления.ОперацииРазмещенияПоМестамХраненияВОтделении.РазмещениеПоМестамХранения Тогда
		Если ХозяйственнаяОперация = Перечисления.ОперацииРазмещенияПоМестамХраненияВОтделении.ПередачаНаПост Тогда
			МестоХраненияОтправитель = Справочники.МестаХранения.ПустаяСсылка();
			МестоХраненияПолучатель = МестоХранения;
		ИначеЕсли ХозяйственнаяОперация = Перечисления.ОперацииРазмещенияПоМестамХраненияВОтделении.ВозвратСПоста Тогда
			МестоХраненияОтправитель = МестоХранения;
			МестоХраненияПолучатель = Справочники.МестаХранения.ПустаяСсылка();
		КонецЕсли;
		Для Каждого ТекущаяСтрока Из Товары Цикл
			Если ТекущаяСтрока.МестоХранения <> МестоХраненияОтправитель Тогда
				ТекущаяСтрока.МестоХранения = МестоХраненияОтправитель;
			КонецЕсли;
			Если ТекущаяСтрока.МестоХраненияНовое <> МестоХраненияПолучатель Тогда
				ТекущаяСтрока.МестоХраненияНовое = МестоХраненияПолучатель;
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
	Если РежимЗаписи = РежимЗаписиДокумента.Проведение Тогда
		ОбработкаТабличнойЧастиСервер.ЗаполнитьИсточникФинансирования(ЭтотОбъект);
	КонецЕсли;
	
	ЗапасыСервер.ОчиститьНеиспользуемыеРеквизиты(ЭтотОбъект, ЗапасыСервер.ПолучитьПараметрыУчетаНоменклатуры(ЭтотОбъект));
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	ПроведениеБольничнаяАптека.СформироватьДвиженияПоРегистрам(ЭтотОбъект, Отказ, РежимПроведения);
	
КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)
	
	ПроведениеБольничнаяАптека.СформироватьДвиженияПоРегистрам(ЭтотОбъект, Отказ);
	
КонецПроцедуры

#КонецОбласти // ОбработчикиСобытий

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ
#Область СлужебныеПроцедурыИФункции

////////////////////////////////////////////////////////////////////////////////
// Инициализация и заполнение документа
#Область ИнициализацияИЗаполнение

Процедура ИнициализироватьДокумент()
	
	Автор = Пользователи.ТекущийПользователь();
	Ответственный = Пользователи.ТекущийПользователь();
	
	ЗаполнитьПоляПоУмолчанию();
	
	Если Не ПолучитьФункциональнуюОпцию("ИспользоватьСтатусыРазмещенияТоваровПоМестамХраненияВОтделении") Тогда
		Статус = Перечисления.СтатусыПеремещенийТоваров.Принято;
	КонецЕсли;
	
КонецПроцедуры

Процедура ЗаполнитьПоляПоУмолчанию()
	
	Организация = ЗначениеНастроекБольничнаяАптекаПовтИсп.ПолучитьОрганизациюПоУмолчанию(Организация);
	Отделение = ЗначениеНастроекБольничнаяАптекаПовтИсп.ПолучитьОтделениеПоУмолчанию(Отделение, Организация);
	Склад = ЗначениеНастроекБольничнаяАптекаПовтИсп.ПолучитьСкладОтделенияПоУмолчанию(Склад, Отделение);
	
КонецПроцедуры

Процедура ЗаполнитьПоЗначениямАвтозаполнения()
	
	ОбщегоНазначенияБольничнаяАптека.ЗаполнитьПоЗначениямАвтозаполнения(ЭтотОбъект, Неопределено, "Организация, Склад");
	ОбщегоНазначенияБольничнаяАптека.ЗаполнитьПоЗначениямАвтозаполнения(ЭтотОбъект, Неопределено, "Отделение", "Организация");
	
КонецПроцедуры

Процедура ЗаполнитьДокументПоОтбору(ДанныеЗаполнения)
	
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, ДанныеЗаполнения);
	
КонецПроцедуры

Процедура ЗаполнитьДокументНаОснованииОприходованияТоваров(ДокументОснование)
	
	Запрос = Новый Запрос;
	Запрос.Текст = "
	|ВЫБРАТЬ
	|	Документ.Ссылка                              КАК Основание,
	|	Документ.Организация                         КАК Организация,
	|	Документ.Отделение                           КАК Отделение,
	|	Документ.Склад                               КАК Склад,
	|	Документ.ИсточникФинансирования              КАК ИсточникФинансирования,
	|	Документ.МестоХранения                       КАК МестоХранения,
	|	ВЫБОР
	|		КОГДА Документ.МестоХранения = ЗНАЧЕНИЕ(Справочник.МестаХранения.ПустаяСсылка)
	|			ТОГДА ЗНАЧЕНИЕ(Перечисление.ОперацииРазмещенияПоМестамХраненияВОтделении.ПередачаНаПост)
	|		ИНАЧЕ ЗНАЧЕНИЕ(Перечисление.ОперацииРазмещенияПоМестамХраненияВОтделении.ВозвратСПоста)
	|	КОНЕЦ                                        КАК ХозяйственнаяОперация,
	|	НЕ Документ.Проведен                         КАК ЕстьОшибкиПроведен,
	|	НЕОПРЕДЕЛЕНО                                 КАК Статус,
	|	ЛОЖЬ                                         КАК ЕстьОшибкиСтатус,
	|	НЕ Документ.Склад.ИспользоватьМестаХранения  КАК ЕстьОшибкиИспользоватьМестаХранения
	|ИЗ
	|	Документ.ОприходованиеИзлишковТоваровВОтделении КАК Документ
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
	|	Документ.ОприходованиеИзлишковТоваровВОтделении.Товары КАК Товары
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
	
	Если Шапка.ЕстьОшибкиИспользоватьМестаХранения Тогда
		ТекстОшибки = НСтр("ru='На складе ""%Склад%"" не ведется учет по местам хранения. Ввод на основании невозможен.'");
		ТекстОшибки = СтрЗаменить(ТекстОшибки, "%Склад%", Шапка.Склад);
		ВызватьИсключение ТекстОшибки;
	КонецЕсли;
	
	ОбщегоНазначенияБольничнаяАптека.ПроверитьВозможностьВводаНаОсновании(
		Шапка.Основание,
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
	
	ПараметрыУчетаНоменклатуры = ЗапасыСервер.ПолучитьПараметрыУчетаНоменклатуры(ЭтотОбъект);
	ЗапасыСервер.ЗаполнитьСтатусыУчетаНоменклатуры(ЭтотОбъект, ПараметрыУчетаНоменклатуры);
	
КонецПроцедуры

Процедура ЗаполнитьДокументНаОснованииОтпускаВОтделение(ДокументОснование)
	
	Запрос = Новый Запрос;
	Запрос.Текст ="
	|ВЫБРАТЬ
	|	Документ.Ссылка                                        КАК Основание,
	|	Документ.Организация                                   КАК Организация,
	|	Документ.Отделение                                     КАК Отделение,
	|	Документ.СкладПолучатель                               КАК Склад,
	|	Документ.ИсточникФинансирования                        КАК ИсточникФинансирования,
	|	ЗНАЧЕНИЕ(Перечисление.ОперацииРазмещенияПоМестамХраненияВОтделении.ПередачаНаПост)
	|	                                                       КАК ХозяйственнаяОперация,
	|	НЕ Документ.Проведен                                   КАК ЕстьОшибкиПроведен,
	|	Документ.Статус                                        КАК Статус,
	|	ВЫБОР
	|		КОГДА Документ.Статус В (&ДопустимыеСтатусы)
	|			ТОГДА ЛОЖЬ
	|		ИНАЧЕ ИСТИНА
	|	КОНЕЦ                                                  КАК ЕстьОшибкиСтатус,
	|	НЕ Документ.СкладПолучатель.ИспользоватьМестаХранения  КАК ЕстьОшибкиИспользоватьМестаХранения
	|ИЗ
	|	Документ.ОтпускТоваровВОтделение КАК Документ
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
	|	Документ.ОтпускТоваровВОтделение.Товары КАК Товары
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
	
	Если Шапка.ЕстьОшибкиИспользоватьМестаХранения Тогда
		ТекстОшибки = НСтр("ru='На складе ""%Склад%"" не ведется учет по местам хранения. Ввод на основании невозможен.'");
		ТекстОшибки = СтрЗаменить(ТекстОшибки, "%Склад%", Шапка.Склад);
		ВызватьИсключение ТекстОшибки;
	КонецЕсли;
	
	ОбщегоНазначенияБольничнаяАптека.ПроверитьВозможностьВводаНаОсновании(
		Шапка.Основание,
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
	
	ПараметрыУчетаНоменклатуры = ЗапасыСервер.ПолучитьПараметрыУчетаНоменклатуры(ЭтотОбъект);
	ЗапасыСервер.ЗаполнитьСтатусыУчетаНоменклатуры(ЭтотОбъект, ПараметрыУчетаНоменклатуры);
	
КонецПроцедуры

Процедура ЗаполнитьДокументНаОснованииПеремещенияТоваров(ДокументОснование)
	
	Запрос = Новый Запрос;
	Запрос.Текст ="
	|ВЫБРАТЬ
	|	Документ.Ссылка                                        КАК Основание,
	|	Документ.Организация                                   КАК Организация,
	|	Документ.СкладПолучатель                               КАК Склад,
	|	Документ.ИсточникФинансирования                        КАК ИсточникФинансирования,
	|	ЗНАЧЕНИЕ(Перечисление.ОперацииРазмещенияПоМестамХраненияВОтделении.ПередачаНаПост)
	|	                                                       КАК ХозяйственнаяОперация,
	|	НЕ Документ.Проведен                                   КАК ЕстьОшибкиПроведен,
	|	НЕОПРЕДЕЛЕНО                                           КАК Статус,
	|	ЛОЖЬ                                                   КАК ЕстьОшибкиСтатус,
	|	НЕ Документ.СкладПолучатель.ИспользоватьМестаХранения  КАК ЕстьОшибкиИспользоватьМестаХранения
	|ИЗ
	|	Документ.ПеремещениеТоваровМеждуОтделениями КАК Документ
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
	|	Документ.ПеремещениеТоваровМеждуОтделениями.Товары КАК Товары
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
	
	Если Шапка.ЕстьОшибкиИспользоватьМестаХранения Тогда
		ТекстОшибки = НСтр("ru='На складе ""%Склад%"" не ведется учет по местам хранения. Ввод на основании невозможен.'");
		ТекстОшибки = СтрЗаменить(ТекстОшибки, "%Склад%", Шапка.Склад);
		ВызватьИсключение ТекстОшибки;
	КонецЕсли;
	
	ОбщегоНазначенияБольничнаяАптека.ПроверитьВозможностьВводаНаОсновании(
		Шапка.Основание,
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
	
	ПараметрыУчетаНоменклатуры = ЗапасыСервер.ПолучитьПараметрыУчетаНоменклатуры(ЭтотОбъект);
	ЗапасыСервер.ЗаполнитьСтатусыУчетаНоменклатуры(ЭтотОбъект, ПараметрыУчетаНоменклатуры);
	
КонецПроцедуры

Процедура ЗаполнитьДокументНаОснованииВводаОстатков(ДокументОснование)
	
	Запрос = Новый Запрос;
	Запрос.Текст = "
	|ВЫБРАТЬ
	|	Документ.Ссылка                              КАК Основание,
	|	Документ.Организация                         КАК Организация,
	|	Документ.Отделение                           КАК Отделение,
	|	Документ.Склад                               КАК Склад,
	|	Документ.ИсточникФинансирования              КАК ИсточникФинансирования,
	|	ЗНАЧЕНИЕ(Перечисление.ОперацииРазмещенияПоМестамХраненияВОтделении.РазмещениеПоМестамХранения)
	|	                                             КАК ХозяйственнаяОперация,
	|	НЕ Документ.Проведен                         КАК ЕстьОшибкиПроведен,
	|	НЕОПРЕДЕЛЕНО                                 КАК Статус,
	|	ЛОЖЬ                                         КАК ЕстьОшибкиСтатус,
	|	НЕ Документ.Склад.ИспользоватьМестаХранения  КАК ЕстьОшибкиИспользоватьМестаХранения,
	|	ВЫБОР
	|		КОГДА Документ.ТипОперации = ЗНАЧЕНИЕ(Перечисление.ТипыОперацийВводаОстатков.ОстаткиСобственныхТоваровВОтделениях)
	|			ТОГДА ЛОЖЬ
	|		ИНАЧЕ ИСТИНА
	|	КОНЕЦ                                        КАК ЕстьОшибкиТипОперации
	|ИЗ
	|	Документ.ВводОстатков КАК Документ
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
	|	Документ.ВводОстатков.Товары КАК Товары
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
	
	Если Шапка.ЕстьОшибкиТипОперации Тогда
		ТекстОшибки = НСтр("ru='Ввод на основании возможен только для документов с типом операции ввода остатков ""Собственные товары в отделениях"".'");
		ВызватьИсключение ТекстОшибки;
	КонецЕсли;
	
	Если Шапка.ЕстьОшибкиИспользоватьМестаХранения Тогда
		ТекстОшибки = НСтр("ru='На складе ""%Склад%"" не ведется учет по местам хранения. Ввод на основании невозможен.'");
		ТекстОшибки = СтрЗаменить(ТекстОшибки, "%Склад%", Шапка.Склад);
		ВызватьИсключение ТекстОшибки;
	КонецЕсли;
	
	ОбщегоНазначенияБольничнаяАптека.ПроверитьВозможностьВводаНаОсновании(
		Шапка.Основание,
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
	
	ПараметрыУчетаНоменклатуры = ЗапасыСервер.ПолучитьПараметрыУчетаНоменклатуры(ЭтотОбъект);
	ЗапасыСервер.ЗаполнитьСтатусыУчетаНоменклатуры(ЭтотОбъект, ПараметрыУчетаНоменклатуры);
	
КонецПроцедуры

#КонецОбласти // ИнициализацияИЗаполнение

////////////////////////////////////////////////////////////////////////////////
// Прочее
#Область Прочее

Функция СписокРегистровДляКонтроля() Экспорт
	
	РегистрыДляКонтроля = Новый Массив;
	
	Если ДополнительныеСвойства.РежимЗаписи = РежимЗаписиДокумента.Проведение Тогда
		РегистрыДляКонтроля.Добавить(Движения.СвободныеОстатки);
	КонецЕсли;
	
	Возврат РегистрыДляКонтроля;
	
КонецФункции

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
	СтрокаТаб.ЗначениеДоступа = Организация;
	
	СтрокаТаб = Таблица.Добавить();
	СтрокаТаб.ЗначениеДоступа = Склад;
	
КонецПроцедуры

#КонецОбласти // СтандартныеПодсистемы

#КонецЕсли