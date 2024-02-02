﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

////////////////////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС
#Область ПрограммныйИнтерфейс

// Имена реквизитов, от значений которых зависят параметры учета номенклатуры
//
// Возвращаемое значение:
//   Строка - имена реквизитов, перечисленные через запятую
//
Функция ИменаРеквизитовДляЗаполненияПараметровУчетаНоменклатуры() Экспорт
	
	Возврат "Склад";
	
КонецФункции

// Возвращает параметры учета для номенклатуры, указанной в документе
//
// Параметры
//   Объект - Структура - структура значений реквизитов объекта, необходимых для заполнения параметров указания серий
// Возвращаемое значение
//   Структура - Состав полей задается в функции НоменклатураКлиентСервер.ПараметрыУчетаНоменклатуры
//
Функция ПараметрыУчетаНоменклатуры(Объект) Экспорт
	
	ПараметрыУчета = ЗапасыСервер.ПараметрыУчетаНоменклатуры();
	ПараметрыУчета.ПолноеИмяОбъекта = ПустаяСсылка().Метаданные().ПолноеИмя();
	
	ПараметрыУчетаНаСкладе = СкладыСервер.ПараметрыУчетаНоменклатуры(Объект.Склад);
	ПараметрыУчета.ИспользоватьСерии = ПараметрыУчетаНаСкладе.ИспользоватьСерииНоменклатуры;
	ПараметрыУчета.ИспользоватьПартии = ПараметрыУчетаНаСкладе.ИспользоватьПартии;
	ПараметрыУчета.Склад = Объект.Склад;
	
	Возврат ПараметрыУчета;
	
КонецФункции

// Возвращает текст запроса для расчета статусов указания параметров учета номенклатуры
//
// Параметры
//   ПараметрыУчетаНоменклатуры - Структура - состав полей задается в функции ЗапасыСервер.ПараметрыУчетаНоменклатуры
//
// Возвращаемое значение
//   Строка - текст запроса
//
Функция ТекстЗапросаРасчетаСтатусовУчетаНоменклатуры(ПараметрыУчетаНоменклатуры) Экспорт
	
	Возврат ЗапасыСервер.ТекстЗапросаРасчетаСтатусовУчетаНоменклатуры(ПараметрыУчетаНоменклатуры);
	
КонецФункции

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.УправлениеДоступом

// См. УправлениеДоступомПереопределяемый.ПриЗаполненииСписковСОграничениемДоступа.
Процедура ПриЗаполненииОграниченияДоступа(Ограничение) Экспорт

	Ограничение.Текст =
	"РазрешитьЧтениеИзменение
	|ГДЕ
	|	ЗначениеРазрешено(Организация)
	|	И ЗначениеРазрешено(Отделение)
	|	И ЗначениеРазрешено(Склад)";

КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом

#КонецОбласти

#КонецОбласти // ПрограммныйИнтерфейс

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ
#Область СлужебныеПроцедурыИФункции

////////////////////////////////////////////////////////////////////////////////
// Проведение
#Область Проведение

// Инициализирует таблицы значений, содержащие данные для проведения документа.
// Таблицы значений сохраняет в свойствах структуры "ДополнительныеСвойства".
//
Процедура СформироватьТаблицыДвиженийДляПроведения(ДополнительныеСвойства, Регистры = Неопределено) Экспорт
	
	ОсновныеДанныеДокумента = ПодготовитьОсновныеДанныеДляПроведения(ДополнительныеСвойства);
	
	ИнициализироватьКлючиАналитикиВидаУчета(ОсновныеДанныеДокумента);
	ИнициализироватьКлючиАналитикиУчетаНоменклатуры(ОсновныеДанныеДокумента);
	
	ПроведениеБольничнаяАптека.ДобавитьТекстЗапросаДвижений(ДополнительныеСвойства, ТекстЗапросаВтТаблицаТовары());
	ПроведениеБольничнаяАптека.ДобавитьТекстЗапросаДвижений(ДополнительныеСвойства, ТекстЗапросаТоварыНаСкладахВОтделениях(), Метаданные.РегистрыНакопления.ТоварыНаСкладахВОтделениях);
	ПроведениеБольничнаяАптека.ДобавитьТекстЗапросаДвижений(ДополнительныеСвойства, ТекстЗапросаСвободныеОстатки(), Метаданные.РегистрыНакопления.СвободныеОстатки);
	ПроведениеБольничнаяАптека.ДобавитьТекстЗапросаДвижений(ДополнительныеСвойства, ТекстЗапросаСебестоимостьТоваров(), Метаданные.РегистрыНакопления.СебестоимостьТоваров);
	ПроведениеБольничнаяАптека.ДобавитьТекстЗапросаДвижений(ДополнительныеСвойства, ТекстЗапросаДвиженияНоменклатураДоходыРасходы(), Метаданные.РегистрыНакопления.ДвиженияНоменклатураДоходыРасходы);
	ПроведениеБольничнаяАптека.ДобавитьТекстЗапросаДвижений(ДополнительныеСвойства, ТекстЗапросаТоварыКОформлениюИзлишковНедостач(), Метаданные.РегистрыНакопления.ТоварыКОформлениюИзлишковНедостач);
	
	Запрос = Новый Запрос(ПроведениеБольничнаяАптека.ПолучитьТекстЗапросаДвижений(ДополнительныеСвойства, Регистры));
	
	Для Каждого ДанныеДокумента Из ОсновныеДанныеДокумента Цикл
		Запрос.УстановитьПараметр(ДанныеДокумента.Ключ, ДанныеДокумента.Значение);
	КонецЦикла;
	
	ПроведениеБольничнаяАптека.ЗаполнитьТаблицыДвижений(ДополнительныеСвойства, Запрос.ВыполнитьПакет(), Регистры);
	
КонецПроцедуры

Функция ПодготовитьОсновныеДанныеДляПроведения(ДополнительныеСвойства)
	
	ЗапрашиваемыеДанные = Новый Структура;
	ЗапрашиваемыеДанные.Вставить("Ссылка");
	ЗапрашиваемыеДанные.Вставить("Период", "Дата");
	ЗапрашиваемыеДанные.Вставить("Организация");
	ЗапрашиваемыеДанные.Вставить("Склад");
	ЗапрашиваемыеДанные.Вставить("МестоХранения");
	ЗапрашиваемыеДанные.Вставить("Отделение");
	ЗапрашиваемыеДанные.Вставить("ДокументОснование", "ИнвентаризацияТоваровВОтделении");
	ЗапрашиваемыеДанные.Вставить("ИсточникФинансирования");
	ЗапрашиваемыеДанные.Вставить("СтатьяДоходов");
	ЗапрашиваемыеДанные.Вставить("АналитикаДоходов");
	
	ОсновныеДанныеДокумента = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(
		ПроведениеБольничнаяАптека.ПолучитьСсылкуНаДокументДляПроведения(ДополнительныеСвойства),
		ЗапрашиваемыеДанные);
	
	ОсновныеДанныеДокумента.Вставить("ВестиУчетПоИсточникамФинансирования", ПолучитьФункциональнуюОпцию("ИспользоватьИсточникиФинансирования"));
	ОсновныеДанныеДокумента.Вставить("ХозяйственнаяОперация", Перечисления.ХозяйственныеОперации.ОприходованиеТоваров);
	ОсновныеДанныеДокумента.Вставить("ЗаполненДокументОснование", ЗначениеЗаполнено(ОсновныеДанныеДокумента.ДокументОснование));
	
	Если Не ОсновныеДанныеДокумента.ВестиУчетПоИсточникамФинансирования Тогда
		ОсновныеДанныеДокумента.ИсточникФинансирования = Справочники.ИсточникиФинансирования.ПустаяСсылка();
	КонецЕсли;
	
	ЗапасыСервер.ПриПодготовкеОсновныхДанныхДляПроведения(ДополнительныеСвойства, ОсновныеДанныеДокумента);
	
	Возврат ОсновныеДанныеДокумента;
	
КонецФункции

Функция ТекстЗапросаВтТаблицаТовары()
	
	ТекстЗапроса = "
	|ВЫБРАТЬ
	|	ТаблицаТовары.НомерСтроки                               КАК НомерСтроки,
	|	ТаблицаТовары.Ссылка                                    КАК ДокументЗакупки,
	|	&Организация                                            КАК Организация,
	|	&Отделение                                              КАК Отделение,
	|	&Склад                                                  КАК Склад,
	|	&МестоХранения                                          КАК МестоХранения,
	|	ТаблицаТовары.Номенклатура                              КАК Номенклатура,
	|	ВЫБОР
	|		КОГДА ТаблицаТовары.СтатусУказанияСерий В (&СтатусУчетПоСериям, &СтатусУчетСебестоимостиПоСериям)
	|			ТОГДА ТаблицаТовары.СерияНоменклатуры
	|		ИНАЧЕ ЗНАЧЕНИЕ(Справочник.СерииНоменклатуры.ПустаяСсылка)
	|	КОНЕЦ                                                   КАК СерияНоменклатуры,
	|	ТаблицаТовары.Партия                                    КАК Партия,
	|	&ИсточникФинансирования                                 КАК ИсточникФинансирования,
	|	ТаблицаТовары.Количество                                КАК Количество,
	|	ТаблицаТовары.Сумма                                     КАК Сумма,
	|	ВЫБОР
	|		КОГДА ТаблицаТовары.СтатусУказанияСерий В (&СтатусУчетСебестоимостиПоСериям)
	|			ТОГДА ТаблицаТовары.СерияНоменклатуры
	|		ИНАЧЕ ЗНАЧЕНИЕ(Справочник.СерииНоменклатуры.ПустаяСсылка)
	|	КОНЕЦ                                                   КАК СерияНоменклатурыДляСебестоимости,
	|	ВЫБОР
	|		КОГДА ТаблицаТовары.СтатусУказанияПартий В (&СтатусУчетСебестоимостиПоПартиям)
	|			ТОГДА ТаблицаТовары.Партия
	|		ИНАЧЕ ЗНАЧЕНИЕ(Справочник.ПартииНоменклатуры.ПустаяСсылка)
	|	КОНЕЦ                                                   КАК ПартияДляСебестоимости
	|ПОМЕСТИТЬ ВтТаблицаТовары
	|ИЗ
	|	Документ.ОприходованиеИзлишковТоваровВОтделении.Товары КАК ТаблицаТовары
	|ГДЕ
	|	ТаблицаТовары.Ссылка = &Ссылка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|";
	
	Возврат ТекстЗапроса;
	
КонецФункции

Функция ТекстЗапросаТоварыНаСкладахВОтделениях()
	
	ТекстЗапроса = "
	|ВЫБРАТЬ
	|	ТаблицаТовары.НомерСтроки               КАК НомерСтроки,
	|	ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход)  КАК ВидДвижения,
	|	&Период                                 КАК Период,
	|	ТаблицаТовары.Организация               КАК Организация,
	|	ТаблицаТовары.Склад                     КАК Склад,
	|	ТаблицаТовары.Отделение                 КАК Отделение,
	|	ТаблицаТовары.МестоХранения             КАК МестоХранения,
	|	ТаблицаТовары.Номенклатура              КАК Номенклатура,
	|	ТаблицаТовары.СерияНоменклатуры         КАК СерияНоменклатуры,
	|	ТаблицаТовары.Партия                    КАК Партия,
	|	ТаблицаТовары.ИсточникФинансирования    КАК ИсточникФинансирования,
	|	ТаблицаТовары.Количество                КАК Количество
	|ИЗ
	|	ВтТаблицаТовары КАК ТаблицаТовары
	|
	|УПОРЯДОЧИТЬ ПО
	|	НомерСтроки
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|";
	
	Возврат ТекстЗапроса;
	
КонецФункции

Функция ТекстЗапросаСвободныеОстатки()
	
	ТекстЗапроса = "
	|ВЫБРАТЬ
	|	ТаблицаТовары.НомерСтроки               КАК НомерСтроки,
	|	ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход)  КАК ВидДвижения,
	|	&Период                                 КАК Период,
	|	ТаблицаТовары.Организация               КАК Организация,
	|	ТаблицаТовары.Склад                     КАК Склад,
	|	ТаблицаТовары.Отделение                 КАК Отделение,
	|	ТаблицаТовары.МестоХранения             КАК МестоХранения,
	|	ТаблицаТовары.Номенклатура              КАК Номенклатура,
	|	ТаблицаТовары.СерияНоменклатуры         КАК СерияНоменклатуры,
	|	ТаблицаТовары.Партия                    КАК Партия,
	|	ТаблицаТовары.ИсточникФинансирования    КАК ИсточникФинансирования,
	|	ТаблицаТовары.Количество                КАК ВНаличии
	|ИЗ
	|	ВтТаблицаТовары КАК ТаблицаТовары
	|
	|УПОРЯДОЧИТЬ ПО
	|	НомерСтроки
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|";
	
	Возврат ТекстЗапроса;
	
КонецФункции

Функция ТекстЗапросаСебестоимостьТоваров()
	
	ТекстЗапроса = "
	|ВЫБРАТЬ
	|	ТаблицаТовары.НомерСтроки                 КАК НомерСтроки,
	|	&Период                                   КАК Период,
	|	ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход)    КАК ВидДвижения,
	|	АналитикаУчетаНоменклатуры.КлючАналитики  КАК АналитикаУчетаНоменклатуры,
	|	АналитикаВидаУчета.КлючАналитики          КАК АналитикаВидаУчета,
	|	ЗНАЧЕНИЕ(Перечисление.РазделыУчетаСебестоимостиТоваров.ТоварыВОтделениях) КАК РазделУчета,
	|	ТаблицаТовары.Количество                  КАК Количество,
	|	ТаблицаТовары.Сумма                       КАК Стоимость,
	|	ТаблицаТовары.Сумма                       КАК СтоимостьБезНДС,
	|	ТаблицаТовары.Сумма                       КАК СтоимостьРегл,
	|	&ХозяйственнаяОперация                    КАК ХозяйственнаяОперация,
	|	&СтатьяДоходов                            КАК СтатьяДоходов,
	|	&АналитикаДоходов                         КАК АналитикаДоходов
	|ИЗ
	|	ВтТаблицаТовары КАК ТаблицаТовары
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.АналитикаУчетаНоменклатуры КАК АналитикаУчетаНоменклатуры
	|		ПО 
	|			ТаблицаТовары.Номенклатура                        = АналитикаУчетаНоменклатуры.Номенклатура
	|			И ТаблицаТовары.СерияНоменклатурыДляСебестоимости = АналитикаУчетаНоменклатуры.СерияНоменклатуры
	|			И ТаблицаТовары.ПартияДляСебестоимости            = АналитикаУчетаНоменклатуры.Партия
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.АналитикаВидаУчета КАК АналитикаВидаУчета
	|		ПО 
	|			ТаблицаТовары.Организация               = АналитикаВидаУчета.Организация
	|			И ТаблицаТовары.Склад                   = АналитикаВидаУчета.Склад
	|			И ТаблицаТовары.ИсточникФинансирования  = АналитикаВидаУчета.ИсточникФинансирования
	|
	|УПОРЯДОЧИТЬ ПО
	|	НомерСтроки
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|";
	
	Возврат ТекстЗапроса;
	
КонецФункции

Функция ТекстЗапросаДвиженияНоменклатураДоходыРасходы()
	
	ТекстЗапроса = "
	|ВЫБРАТЬ
	|	ТаблицаТовары.НомерСтроки                 КАК НомерСтроки,
	|	&Период                                   КАК Период,
	|	&ХозяйственнаяОперация                    КАК ХозяйственнаяОперация,
	|	&СтатьяДоходов                            КАК СтатьяДоходовРасходов,
	|	&АналитикаДоходов                         КАК АналитикаДоходов,
	|	АналитикаВидаУчета.КлючАналитики          КАК АналитикаВидаУчета,
	|	АналитикаУчетаНоменклатуры.КлючАналитики  КАК АналитикаУчетаНоменклатуры,
	|	ТаблицаТовары.Количество                  КАК Количество,
	|	ТаблицаТовары.Сумма                       КАК Стоимость,
	|	ТаблицаТовары.Сумма                       КАК СтоимостьБезНДС,
	|	ТаблицаТовары.Сумма                       КАК СтоимостьРегл,
	|	&Ссылка                                   КАК ДокументДвижения
	|ИЗ
	|	ВтТаблицаТовары КАК ТаблицаТовары
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.АналитикаУчетаНоменклатуры КАК АналитикаУчетаНоменклатуры
	|		ПО 
	|			ТаблицаТовары.Номенклатура                        = АналитикаУчетаНоменклатуры.Номенклатура
	|			И ТаблицаТовары.СерияНоменклатурыДляСебестоимости = АналитикаУчетаНоменклатуры.СерияНоменклатуры
	|			И ТаблицаТовары.ПартияДляСебестоимости            = АналитикаУчетаНоменклатуры.Партия
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.АналитикаВидаУчета КАК АналитикаВидаУчета
	|		ПО 
	|			ТаблицаТовары.Организация              = АналитикаВидаУчета.Организация
	|			И ТаблицаТовары.Склад                  = АналитикаВидаУчета.Склад
	|			И ТаблицаТовары.ИсточникФинансирования = АналитикаВидаУчета.ИсточникФинансирования
	|
	|УПОРЯДОЧИТЬ ПО
	|	НомерСтроки
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|";
	
	Возврат ТекстЗапроса;
	
КонецФункции

Функция ТекстЗапросаТоварыКОформлениюИзлишковНедостач()
	
	ТекстЗапроса = "
	|ВЫБРАТЬ
	|	&Период                                 КАК Период,
	|	ЗНАЧЕНИЕ(ВидДвиженияНакопления.Расход)  КАК ВидДвижения,
	|	ТаблицаТовары.Организация               КАК Организация,
	|	ТаблицаТовары.Склад                     КАК Склад,
	|	&ДокументОснование                      КАК ДокументОснование,
	|	ТаблицаТовары.НомерСтроки               КАК НомерСтроки,
	|	ТаблицаТовары.Номенклатура              КАК Номенклатура,
	|	ТаблицаТовары.СерияНоменклатуры         КАК СерияНоменклатуры,
	|	ТаблицаТовары.Партия                    КАК Партия,
	|	ТаблицаТовары.ИсточникФинансирования    КАК ИсточникФинансирования,
	|	ТаблицаТовары.Количество                КАК КОформлениюОприходования,
	|	0                                       КАК КОформлениюСписания
	|ИЗ
	|	ВтТаблицаТовары КАК ТаблицаТовары
	|ГДЕ
	|	&ЗаполненДокументОснование
	|
	|УПОРЯДОЧИТЬ ПО
	|	НомерСтроки
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|";
	
	Возврат ТекстЗапроса;
	
КонецФункции

Процедура ИнициализироватьКлючиАналитикиУчетаНоменклатуры(Реквизиты)
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	Запрос.Текст = "
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ТаблицаТовары.Номенклатура КАК Номенклатура,
	|	ВЫБОР
	|		КОГДА ТаблицаТовары.СтатусУказанияСерий В (&СтатусУчетСебестоимостиПоСериям)
	|			ТОГДА ТаблицаТовары.СерияНоменклатуры
	|		ИНАЧЕ ЗНАЧЕНИЕ(Справочник.СерииНоменклатуры.ПустаяСсылка)
	|	КОНЕЦ КАК СерияНоменклатуры,
	|	ВЫБОР
	|		КОГДА ТаблицаТовары.СтатусУказанияПартий В (&СтатусУчетСебестоимостиПоПартиям)
	|			ТОГДА ТаблицаТовары.Партия
	|		ИНАЧЕ ЗНАЧЕНИЕ(Справочник.ПартииНоменклатуры.ПустаяСсылка)
	|	КОНЕЦ КАК Партия
	|ПОМЕСТИТЬ втТаблицаАналитики
	|ИЗ
	|	Документ.ОприходованиеИзлишковТоваровВОтделении.Товары КАК ТаблицаТовары
	|ГДЕ
	|	ТаблицаТовары.Ссылка = &Ссылка
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Номенклатура,
	|	СерияНоменклатуры,
	|	Партия
	|";
	
	Запрос.УстановитьПараметр("Ссылка", Реквизиты.Ссылка);
	Запрос.УстановитьПараметр("СтатусУчетСебестоимостиПоСериям", Реквизиты.СтатусУчетСебестоимостиПоСериям);
	Запрос.УстановитьПараметр("СтатусУчетСебестоимостиПоПартиям", Реквизиты.СтатусУчетСебестоимостиПоПартиям);
	Запрос.Выполнить();
	
	Справочники.КлючиАналитикиУчетаНоменклатуры.ИнициализироватьКлючиАналитики(Запрос.МенеджерВременныхТаблиц);
	
КонецПроцедуры

Процедура ИнициализироватьКлючиАналитикиВидаУчета(Реквизиты)
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	Запрос.Текст = "
	|ВЫБРАТЬ
	|	&Организация КАК Организация,
	|	&Склад КАК Склад,
	|	&ИсточникФинансирования КАК ИсточникФинансирования
	|ПОМЕСТИТЬ втТаблицаАналитики
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Организация,
	|	Склад,
	|	ИсточникФинансирования
	|";
	Запрос.УстановитьПараметр("Организация" , Реквизиты.Организация);
	Запрос.УстановитьПараметр("Склад" , Реквизиты.Склад);
	Запрос.УстановитьПараметр("ИсточникФинансирования" , Реквизиты.ИсточникФинансирования);
	Запрос.Выполнить();
	
	Справочники.КлючиАналитикиВидаУчета.ИнициализироватьКлючиАналитики(Запрос.МенеджерВременныхТаблиц);
	
КонецПроцедуры

#КонецОбласти // Проведение

////////////////////////////////////////////////////////////////////////////////
// Печать
#Область Печать

// Заполняет список команд печати.
// 
// Параметры:
//   КомандыПечати - ТаблицаЗначений - состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	
	УправлениеПечатьюБольничнаяАптека.ДобавитьКомандыПечати(ПустаяСсылка().Метаданные().ПолноеИмя(), КомандыПечати);
	
КонецПроцедуры

// Возвращает список доступных печатных форм документа
//
Функция ДоступныеПечатныеФормы() Экспорт
	
	МетаданныеДокумента = ПустаяСсылка().Метаданные();
	МенеджерПечати      = МетаданныеДокумента.ПолноеИмя();
	МетаданныеМакетов   = МетаданныеДокумента.Макеты;
	
	ПечатныеФормы = УправлениеПечатьюБольничнаяАптека.СоздатьКоллекциюДоступныхПечатныхФорм();
	
	ПечатнаяФорма = УправлениеПечатьюБольничнаяАптека.ДобавитьПечатнуюФорму(ПечатныеФормы, "ВедомостьНаОприходование", МенеджерПечати);
	ПечатнаяФорма.Параметризуемая = Истина;
	ПечатнаяФорма.ПутьКМакету = ФормированиеПечатныхФормБольничнаяАптека.ПутьКМакету(МетаданныеМакетов.ПФ_MXL_Накладная);
	
	КомандаПечати = УправлениеПечатьюБольничнаяАптека.ДобавитьКомандуПечати(ПечатнаяФорма);
	КомандаПечати.Представление = МетаданныеМакетов.ПФ_MXL_Накладная.Представление();
	
	КомандаПечати = УправлениеПечатьюБольничнаяАптека.ДобавитьКомандуПечати(ПечатнаяФорма);
	КомандаПечати.Представление = МетаданныеМакетов.ПФ_MXL_Накладная.Представление() + " " + НСтр("ru='(аптека)'");
	КомандаПечати.ДополнительныеПараметры.Вставить("ВывестиИтогПоГруппамБухгалтерскогоУчета", Истина);
	
	Возврат ПечатныеФормы;
	
КонецФункции

Функция ПолучитьТекстЗапросаДанныеДляПечати()
	
	ТекстЗапроса = "
	|ВЫБРАТЬ
	|	Ссылка                           КАК Ссылка,
	|	Дата                             КАК ДатаДокумента,
	|	Номер                            КАК НомерДокумента,
	|	Организация                      КАК Организация,
	|	Отделение                        КАК Подразделение,
	|	Отделение.Представление          КАК ПодразделениеПредставление,
	|	ИсточникФинансирования           КАК ИсточникФинансирования,
	|	Склад                            КАК Склад,
	|	Склад.Представление              КАК СкладПредставление,
	|	ИнвентаризацияТоваровВОтделении  КАК Инвентаризация,
	|	Товары.(
	|		НомерСтроки                      КАК НомерСтроки,
	|		Номенклатура                     КАК Номенклатура,
	|		Номенклатура.НаименованиеПолное  КАК ТоварНаименование,
	|		Номенклатура.Код                 КАК ТоварКод,
	|		СерияНоменклатуры                КАК Серия,
	|		Партия                           КАК Партия,
	|		ЕдиницаИзмерения                 КАК ЕдиницаИзмерения,
	|		ЕдиницаИзмерения.КодОКЕИ         КАК КодПоОКЕИ,
	|		КоличествоВЕдиницахИзмерения     КАК Количество,
	|		Цена                             КАК Цена,
	|		Сумма                            КАК Сумма,
	|		Коэффициент                      КАК Коэффициент
	|	)
	|ИЗ
	|	Документ.ОприходованиеИзлишковТоваровВОтделении КАК Документ
	|ГДЕ
	|	Документ.Ссылка В(&ТекущийДокумент)
	|
	|УПОРЯДОЧИТЬ ПО
	|	Ссылка,
	|	НомерСтроки
	|";
	
	Возврат ТекстЗапроса;
	
КонецФункции

Функция ПолучитьТекстЗапросаПоГруппамБухУчета()
	
	ТекстЗапроса = "
	|ВЫБРАТЬ
	|	ТаблицаГруппБухУчета.Документ                   КАК Документ,
	|	ТаблицаГруппБухУчета.ГруппаБухгалтерскогоУчета  КАК ГруппаБухгалтерскогоУчета,
	|	СУММА(ТаблицаГруппБухУчета.Сумма)               КАК Сумма
	|ИЗ
	|	(ВЫБРАТЬ
	|		ТаблицаТовары.Ссылка КАК Документ,
	|		ТаблицаТовары.Номенклатура.ВидНоменклатуры.ГруппаБухгалтерскогоУчета КАК ГруппаБухгалтерскогоУчета,
	|		ТаблицаТовары.Сумма КАК Сумма
	|	ИЗ
	|		Документ.ОприходованиеИзлишковТоваровВОтделении.Товары КАК ТаблицаТовары
	|	ГДЕ
	|		ТаблицаТовары.Ссылка В(&ТекущийДокумент)) КАК ТаблицаГруппБухУчета
	|
	|СГРУППИРОВАТЬ ПО
	|	Документ,
	|	ГруппаБухгалтерскогоУчета
	|
	|УПОРЯДОЧИТЬ ПО
	|	Документ,
	|	ГруппаБухгалтерскогоУчета.РеквизитДопУпорядочивания
	|";
	
	Возврат ТекстЗапроса;
	
КонецФункции

Функция ПечатьВедомостьНаОприходование(МассивОбъектов, ОбъектыПечати, ПараметрыПечати) Экспорт
	
	ТабличныйДокумент = Новый ТабличныйДокумент;
	ТабличныйДокумент.ОриентацияСтраницы = ОриентацияСтраницы.Портрет;
	ТабличныйДокумент.АвтоМасштаб        = Истина;
	
	ПолноеИмяМакета = ФормированиеПечатныхФормБольничнаяАптека.ПутьКМакету(ПустаяСсылка().Метаданные().Макеты.ПФ_MXL_Накладная);
	ТабличныйДокумент.ИмяПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_" + ПолноеИмяМакета;
	Макет = УправлениеПечатью.МакетПечатнойФормы(ПолноеИмяМакета);
	
	МассивВыводимыхОбластей = Новый Массив;
	
	ВалютаПечати = ЗначениеНастроекБольничнаяАптекаПовтИсп.ПолучитьВалютуРегламентированногоУчета();
	
	ВывестиИтогПоГруппамБухгалтерскогоУчета = Ложь;
	Если ПараметрыПечати.Свойство("ВывестиИтогПоГруппамБухгалтерскогоУчета") Тогда
		ВывестиИтогПоГруппамБухгалтерскогоУчета = ПараметрыПечати.ВывестиИтогПоГруппамБухгалтерскогоУчета;
	КонецЕсли;
	
	ИмяОбластьШапка  = "ШапкаТаблицыСКодом";
	ИмяОбластьСтрока = "СтрокаСКодом";
	
	Запрос = Новый Запрос;
	Запрос.Текст = ПолучитьТекстЗапросаДанныеДляПечати() + ?(ВывестиИтогПоГруппамБухгалтерскогоУчета, ";" + ПолучитьТекстЗапросаПоГруппамБухУчета(), "");
	Запрос.УстановитьПараметр("ТекущийДокумент", МассивОбъектов);
	
	РезультатыЗапроса = Запрос.ВыполнитьПакет();
	
	Шапка = РезультатыЗапроса[0].Выбрать();
	
	Если ВывестиИтогПоГруппамБухгалтерскогоУчета Тогда
		ГруппыБухУчета = РезультатыЗапроса[1].Выгрузить();
	КонецЕсли;
	
	ПервыйДокумент = Истина;
	Пока Шапка.Следующий() Цикл
		
		Если Не ПервыйДокумент Тогда
			ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		КонецЕсли;
		
		ПервыйДокумент = Ложь;
		НомерСтрокиНачало = ТабличныйДокумент.ВысотаТаблицы + 1;
		
		ШтрихкодированиеПечатныхФорм.ВывестиШтрихкодВТабличныйДокумент(Шапка.Ссылка, ТабличныйДокумент, Макет);
		
		// Получение параметров для заполнения
		ПараметрыИзШапки = ПолучитьПараметрыШапкиВедомостьНаОприходование(Шапка);
		
		// Вывод области Заголовок
		ФормированиеПечатныхФормБольничнаяАптека.ВывестиОбластьПоИмени(ТабличныйДокумент, Макет, "Заголовок", ПараметрыИзШапки);
		
		// Вывод области РеквизитыШапки
		ФормированиеПечатныхФормБольничнаяАптека.ВывестиОбластьПоИмени(ТабличныйДокумент, Макет, "РеквизитыШапки", ПараметрыИзШапки);
		
		// Вывод области ШапкаТаблицы
		ФормированиеПечатныхФормБольничнаяАптека.ВывестиОбластьПоИмени(ТабличныйДокумент, Макет, ИмяОбластьШапка, ПараметрыИзШапки);
		
		// Инициализация итогов по документу
		ПараметрыИтого = Новый Структура;
		ПараметрыИтого.Вставить("Сумма", 0);
		
		// Формирование области Строка
		ВыборкаСтрокТовары = Шапка.Товары.Выбрать();
		КлючиПараметров = ФормированиеПечатныхФормБольничнаяАптека.ПолучитьИменаКолонокТаблицы(ВыборкаСтрокТовары);
		
		МассивСтрокТаблицы = Новый Массив;
		КоличествоСтрок = ВыборкаСтрокТовары.Количество();
		НомерСтроки = 0;
		Пока ВыборкаСтрокТовары.Следующий() Цикл
			
			НомерСтроки = НомерСтроки + 1;
			
			ДанныеСтроки = Новый Структура(КлючиПараметров);
			ЗаполнитьЗначенияСвойств(ДанныеСтроки, ВыборкаСтрокТовары);
			
			ТоварНаименование = ОбщегоНазначенияБольничнаяАптека.ПолучитьПредставлениеНоменклатурыДляПечати(
				ВыборкаСтрокТовары.ТоварНаименование,
				ВыборкаСтрокТовары.Серия,
				ВыборкаСтрокТовары.Партия);
			
			ДанныеСтроки.Вставить("ТоварНаименование", ТоварНаименование);
			
			ФормированиеПечатныхФормБольничнаяАптека.ДобавитьОбластьВМассивПоОписанию(Макет, ИмяОбластьСтрока, МассивСтрокТаблицы, ДанныеСтроки);
			
			ФормированиеПечатныхФормБольничнаяАптека.РассчитатьИтоги(ДанныеСтроки, ПараметрыИтого);
			
		КонецЦикла;
		
		МассивОбластейПодвала = Новый Массив;
		
		// Формирование области Итого
		ФормированиеПечатныхФормБольничнаяАптека.ДобавитьОбластьВМассивПоОписанию(Макет, "Итого", МассивОбластейПодвала, ПараметрыИтого);
		
		// Формирование области СуммаПрописью
		ФорматированнаяСумма = ОбщегоНазначенияБольничнаяАптека.ФорматСумм(ПараметрыИтого.Сумма, ВалютаПечати);
		ИтоговаяСтрока = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Всего выпущено наименований %1, на сумму %2'"), КоличествоСтрок, ФорматированнаяСумма);
		
		ПараметрыСуммаПрописью = Новый Структура;
		ПараметрыСуммаПрописью.Вставить("ИтоговаяСтрока", ИтоговаяСтрока);
		ПараметрыСуммаПрописью.Вставить("СуммаПрописью" , РаботаСКурсамиВалют.СформироватьСуммуПрописью(ПараметрыИтого.Сумма, ВалютаПечати));
		
		ФормированиеПечатныхФормБольничнаяАптека.ДобавитьОбластьВМассивПоОписанию(Макет, "СуммаПрописью", МассивОбластейПодвала, ПараметрыСуммаПрописью);
		
		// Формирование области ИтогПоГруппе
		Если ВывестиИтогПоГруппамБухгалтерскогоУчета Тогда
			
			ФормированиеПечатныхФормБольничнаяАптека.ДобавитьОбластьВМассивПоОписанию(Макет, "ШапкаИтоговПоГруппам", МассивОбластейПодвала, ПараметрыСуммаПрописью);
			
			МассивГруппБухУчета = ГруппыБухУчета.НайтиСтроки(Новый Структура("Документ", Шапка.Ссылка));
			
			Для Каждого ГруппаБухУчета Из МассивГруппБухУчета Цикл
				Если ГруппаБухУчета.Сумма > 0 Тогда
					
					ПараметрыИтогПоГруппе = Новый Структура;
					ПараметрыИтогПоГруппе.Вставить("Группа", ?(ЗначениеЗаполнено(ГруппаБухУчета.ГруппаБухгалтерскогоУчета), ГруппаБухУчета.ГруппаБухгалтерскогоУчета, НСтр("ru = 'Вне групп'")));
					ПараметрыИтогПоГруппе.Вставить("Сумма" , ОбщегоНазначенияБольничнаяАптека.ФорматСумм(ГруппаБухУчета.Сумма));
					
					ФормированиеПечатныхФормБольничнаяАптека.ДобавитьОбластьВМассивПоОписанию(Макет, "ИтогПоГруппе", МассивОбластейПодвала, ПараметрыИтогПоГруппе);
					
				КонецЕсли;
			КонецЦикла;
		КонецЕсли;
		
		// Формирование области Подписи
		ФормированиеПечатныхФормБольничнаяАптека.ДобавитьОбластьВМассивПоОписанию(Макет, "Подписи", МассивОбластейПодвала, ПараметрыИзШапки);
		
		// Вывод области Строка
		ГраницаОбластейСтрока = МассивСтрокТаблицы.ВГраница();
		Для ИндексОбласти = 0 По ГраницаОбластейСтрока Цикл
			
			ОбластьСтрока = МассивСтрокТаблицы[ИндексОбласти];
			
			МассивВыводимыхОбластей.Очистить();
			МассивВыводимыхОбластей.Добавить(ОбластьСтрока);
			Если ИндексОбласти = ГраницаОбластейСтрока Тогда
				ОбщегоНазначенияКлиентСервер.ДополнитьМассив(МассивВыводимыхОбластей, МассивОбластейПодвала);
			КонецЕсли;
			
			Если Не ОбщегоНазначения.ПроверитьВыводТабличногоДокумента(ТабличныйДокумент, МассивВыводимыхОбластей) Тогда
				ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
				ФормированиеПечатныхФормБольничнаяАптека.ВывестиОбластьПоИмени(ТабличныйДокумент, Макет, ИмяОбластьШапка, ПараметрыИзШапки);
			КонецЕсли;
			
			ТабличныйДокумент.Вывести(ОбластьСтрока);
			
		КонецЦикла;
		
		// Вывод областей подвала
		Для Каждого ОбластьПодвала Из МассивОбластейПодвала Цикл
			ТабличныйДокумент.Вывести(ОбластьПодвала);
		КонецЦикла;
		
		УправлениеПечатью.ЗадатьОбластьПечатиДокумента(ТабличныйДокумент, НомерСтрокиНачало, ОбъектыПечати, Шапка.Ссылка);
		
	КонецЦикла;
	
	Возврат ТабличныйДокумент;
	
КонецФункции

Функция ПолучитьПараметрыШапкиВедомостьНаОприходование(Шапка)
	
	КлючиПараметров = ФормированиеПечатныхФормБольничнаяАптека.ПолучитьИменаКолонокТаблицы(Шапка);
	
	Параметры = Новый Структура(КлючиПараметров);
	ЗаполнитьЗначенияСвойств(Параметры, Шапка);
	
	// Данные заголовка
	НомерДокумента = ПрефиксацияОбъектовКлиентСервер.НомерНаПечать(Шапка.НомерДокумента);
	ШаблонТекстЗаголовка = НСтр("ru = 'Оприходование товаров № %1 от %2'");
	ТекстЗаголовка = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		ШаблонТекстЗаголовка, НомерДокумента, Формат(Шапка.ДатаДокумента, "ДЛФ=DD"));
	
	СведенияОбОрганизации = ФормированиеПечатныхФорм.СведенияОЮрФизЛице(Шапка.Организация, Шапка.ДатаДокумента);
	ОрганизацияПредставление = ФормированиеПечатныхФорм.ОписаниеОрганизации(СведенияОбОрганизации, "ПолноеНаименование,");
	
	Параметры.Вставить("ТекстЗаголовка"          , ТекстЗаголовка);
	Параметры.Вставить("ОрганизацияПредставление", ОрганизацияПредставление);
	Параметры.Вставить("Основание"               , Шапка.Инвентаризация);
	
	// Данные шапки таблицы
	Параметры.Вставить("ИмяКолонкиКодов", НСтр("ru = 'Код'"));
	
	// Данные подписей документа
	МОЛ = РегистрыСведений.МатериальноОтветственныеЛица.ПолучитьДанныеОтветственного(Шапка.Склад, Шапка.ДатаДокумента);
	
	Параметры.Вставить("Получил", МОЛ.ФИО);
	
	Возврат Параметры;
	
КонецФункции

#КонецОбласти // Печать

////////////////////////////////////////////////////////////////////////////////
// Команды формы
#Область КомандыФормы

// Заполняет список команд ввода на основании.
// 
// Параметры:
//   КомандыСоздатьНаОсновании - ТаблицаЗначений - Таблица команд для вывода в подменю. Для изменения.
//
Процедура ДобавитьКомандыСозданияНаОсновании(КомандыСоздатьНаОсновании, НастройкиФормы) Экспорт
	
	ВводНаОснованииБольничнаяАптека.ДобавитьКомандыСозданияНаОсновании(ПустаяСсылка().Метаданные().ПолноеИмя(), КомандыСоздатьНаОсновании, НастройкиФормы);
	
КонецПроцедуры

// Заполняет список команд отчетов.
// 
// Параметры:
//   КомандыОтчетов - ТаблицаЗначений - Таблица команд для вывода в подменю. Для изменения.
//
Процедура ДобавитьКомандыОтчетов(КомандыОтчетов, НастройкиФормы) Экспорт
	
	МенюОтчетыБольничнаяАптека.ДобавитьОбщиеКоманды(ПустаяСсылка().Метаданные().ПолноеИмя(), КомандыОтчетов, НастройкиФормы);
	
КонецПроцедуры

#КонецОбласти // КомандыФормы

#КонецОбласти // СлужебныеПроцедурыИФункции

////////////////////////////////////////////////////////////////////////////////
// СТАНДАРТНЫЕ ПОДСИСТЕМЫ
#Область СтандартныеПодсистемы

// СтандартныеПодсистемы.ВерсионированиеОбъектов

// Определяет настройки объекта для подсистемы ВерсионированиеОбъектов.
//
// Параметры:
//  Настройки - Структура - настройки подсистемы.
//
Процедура ПриОпределенииНастроекВерсионированияОбъектов(Настройки) Экспорт
	
КонецПроцедуры

// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов

#КонецОбласти // СтандартныеПодсистемы

#КонецЕсли