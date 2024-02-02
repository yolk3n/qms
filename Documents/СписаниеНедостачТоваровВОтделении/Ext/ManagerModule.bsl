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
	ПроведениеБольничнаяАптека.ДобавитьТекстЗапросаДвижений(ДополнительныеСвойства, ТекстЗапросаВтАналитика());
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
	ЗапрашиваемыеДанные.Вставить("Отделение");
	ЗапрашиваемыеДанные.Вставить("ДокументОснование", "ИнвентаризацияТоваровВОтделении");
	ЗапрашиваемыеДанные.Вставить("СтатьяРасходов");
	ЗапрашиваемыеДанные.Вставить("АналитикаРасходов");
	
	ОсновныеДанныеДокумента = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(
		ПроведениеБольничнаяАптека.ПолучитьСсылкуНаДокументДляПроведения(ДополнительныеСвойства),
		ЗапрашиваемыеДанные);
	
	ОсновныеДанныеДокумента.Вставить("ВестиУчетПоИсточникамФинансирования", ПолучитьФункциональнуюОпцию("ИспользоватьИсточникиФинансирования"));
	ОсновныеДанныеДокумента.Вставить("ИспользоватьМестаХранения", ПолучитьФункциональнуюОпцию("ИспользоватьМестаХранения", Новый Структура("Склад", ОсновныеДанныеДокумента.Склад)));
	ОсновныеДанныеДокумента.Вставить("ХозяйственнаяОперация", Перечисления.ХозяйственныеОперации.СписаниеТоваров);
	ОсновныеДанныеДокумента.Вставить("ЗаполненДокументОснование", ЗначениеЗаполнено(ОсновныеДанныеДокумента.ДокументОснование));
	
	ЗапасыСервер.ПриПодготовкеОсновныхДанныхДляПроведения(ДополнительныеСвойства, ОсновныеДанныеДокумента);
	
	Возврат ОсновныеДанныеДокумента;
	
КонецФункции

Функция ТекстЗапросаВтТаблицаТовары()
	
	ТекстЗапроса = "
	|ВЫБРАТЬ
	|	ТаблицаТовары.НомерСтроки                               КАК НомерСтроки,
	|	&Организация                                            КАК Организация,
	|	&Склад                                                  КАК Склад,
	|	ВЫБОР
	|		КОГДА &ИспользоватьМестаХранения
	|			ТОГДА ТаблицаТовары.МестоХранения
	|		ИНАЧЕ ЗНАЧЕНИЕ(Справочник.МестаХранения.ПустаяСсылка)
	|	КОНЕЦ                                                   КАК МестоХранения,
	|	ТаблицаТовары.Номенклатура                              КАК Номенклатура,
	|	ВЫБОР
	|		КОГДА ТаблицаТовары.СтатусУказанияСерий В (&СтатусУчетПоСериям, &СтатусУчетСебестоимостиПоСериям)
	|			ТОГДА ТаблицаТовары.СерияНоменклатуры
	|		ИНАЧЕ ЗНАЧЕНИЕ(Справочник.СерииНоменклатуры.ПустаяСсылка)
	|	КОНЕЦ                                                   КАК СерияНоменклатуры,
	|	ТаблицаТовары.Партия                                    КАК Партия,
	|	ВЫБОР 
	|		КОГДА &ВестиУчетПоИсточникамФинансирования
	|			ТОГДА ТаблицаТовары.ИсточникФинансирования
	|		ИНАЧЕ ЗНАЧЕНИЕ(Справочник.ИсточникиФинансирования.ПустаяСсылка)
	|	КОНЕЦ                                                   КАК ИсточникФинансирования,
	|	ТаблицаТовары.Количество                                КАК Количество,
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
	|	Документ.СписаниеНедостачТоваровВОтделении.Товары КАК ТаблицаТовары
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
	|	ЗНАЧЕНИЕ(ВидДвиженияНакопления.Расход)  КАК ВидДвижения,
	|	&Период                                 КАК Период,
	|	ТаблицаТовары.Организация               КАК Организация,
	|	&Отделение                              КАК Отделение,
	|	ТаблицаТовары.Склад                     КАК Склад,
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
	|	ЗНАЧЕНИЕ(ВидДвиженияНакопления.Расход)  КАК ВидДвижения,
	|	&Период                                 КАК Период,
	|	ТаблицаТовары.Организация               КАК Организация,
	|	&Отделение                              КАК Отделение,
	|	ТаблицаТовары.Склад                     КАК Склад,
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

Функция ТекстЗапросаВтАналитика()
	
	ТекстЗапроса = "
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ТаблицаТовары.Номенклатура                                                 КАК Номенклатура,
	|	ТаблицаТовары.СерияНоменклатурыДляСебестоимости                            КАК СерияНоменклатуры,
	|	ТаблицаТовары.ПартияДляСебестоимости                                       КАК Партия,
	|	ТаблицаТовары.ИсточникФинансирования                                       КАК ИсточникФинансирования,
	|	АналитикаУчетаНоменклатуры.КлючАналитики                                   КАК АналитикаУчетаНоменклатуры,
	|	АналитикаВидаУчета.КлючАналитики                                           КАК АналитикаВидаУчета,
	|	ЗНАЧЕНИЕ(Перечисление.РазделыУчетаСебестоимостиТоваров.ТоварыВОтделениях)  КАК РазделУчета
	|ПОМЕСТИТЬ ВтАналитика
	|ИЗ
	|	ВтТаблицаТовары КАК ТаблицаТовары
	|		ЛЕВОЕ СОЕДИНЕНИЕ
	|			РегистрСведений.АналитикаУчетаНоменклатуры КАК АналитикаУчетаНоменклатуры
	|		ПО
	|			ТаблицаТовары.Номенклатура                        = АналитикаУчетаНоменклатуры.Номенклатура
	|			И ТаблицаТовары.СерияНоменклатурыДляСебестоимости = АналитикаУчетаНоменклатуры.СерияНоменклатуры
	|			И ТаблицаТовары.ПартияДляСебестоимости            = АналитикаУчетаНоменклатуры.Партия
	|		ЛЕВОЕ СОЕДИНЕНИЕ
	|			РегистрСведений.АналитикаВидаУчета КАК АналитикаВидаУчета
	|		ПО
	|			АналитикаВидаУчета.Организация                = ТаблицаТовары.Организация
	|			И АналитикаВидаУчета.Склад                    = ТаблицаТовары.Склад
	|			И АналитикаВидаУчета.ИсточникФинансирования   = ТаблицаТовары.ИсточникФинансирования
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	АналитикаУчетаНоменклатуры,
	|	АналитикаВидаУчета,
	|	РазделУчета
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|";
	
	Возврат ТекстЗапроса;
	
КонецФункции

Функция ТекстЗапросаСебестоимостьТоваров()
	
	ТекстЗапроса = "
	|ВЫБРАТЬ
	|	ТаблицаТовары.НомерСтроки                         КАК НомерСтроки,
	|	&Период                                           КАК Период,
	|	ЗНАЧЕНИЕ(ВидДвиженияНакопления.Расход)            КАК ВидДвижения,
	|	Аналитика.АналитикаУчетаНоменклатуры              КАК АналитикаУчетаНоменклатуры,
	|	Аналитика.АналитикаВидаУчета                      КАК АналитикаВидаУчета,
	|	Аналитика.РазделУчета                             КАК РазделУчета,
	|	ТаблицаТовары.Количество                          КАК Количество,
	|	&ХозяйственнаяОперация                            КАК ХозяйственнаяОперация,
	|	&Ссылка                                           КАК ДокументДвижения,
	|	&СтатьяРасходов                                   КАК СтатьяРасходов,
	|	&АналитикаРасходов                                КАК АналитикаРасходов
	|ИЗ
	|	ВтТаблицаТовары КАК ТаблицаТовары
	|		ЛЕВОЕ СОЕДИНЕНИЕ
	|			ВтАналитика КАК Аналитика
	|		ПО
	|			ТаблицаТовары.Номенклатура                        = Аналитика.Номенклатура
	|			И ТаблицаТовары.СерияНоменклатурыДляСебестоимости = Аналитика.СерияНоменклатуры
	|			И ТаблицаТовары.ПартияДляСебестоимости            = Аналитика.Партия
	|			И ТаблицаТовары.ИсточникФинансирования            = Аналитика.ИсточникФинансирования
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
	|	ТаблицаТовары.НомерСтроки                         КАК НомерСтроки,
	|	&Период                                           КАК Период,
	|	&ХозяйственнаяОперация                            КАК ХозяйственнаяОперация,
	|	&СтатьяРасходов                                   КАК СтатьяДоходовРасходов,
	|	&АналитикаРасходов                                КАК АналитикаРасходов,
	|	Аналитика.АналитикаВидаУчета                      КАК АналитикаВидаУчета,
	|	Аналитика.АналитикаУчетаНоменклатуры              КАК АналитикаУчетаНоменклатуры,
	|	ТаблицаТовары.Количество                          КАК Количество,
	|	&Ссылка                                           КАК ДокументДвижения
	|ИЗ
	|	ВтТаблицаТовары КАК ТаблицаТовары
	|		ЛЕВОЕ СОЕДИНЕНИЕ
	|			ВтАналитика КАК Аналитика
	|		ПО
	|			ТаблицаТовары.Номенклатура                        = Аналитика.Номенклатура
	|			И ТаблицаТовары.СерияНоменклатурыДляСебестоимости = Аналитика.СерияНоменклатуры
	|			И ТаблицаТовары.ПартияДляСебестоимости            = Аналитика.Партия
	|			И ТаблицаТовары.ИсточникФинансирования            = Аналитика.ИсточникФинансирования
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
	|	0                                       КАК КОформлениюОприходования,
	|	ТаблицаТовары.Количество                КАК КОформлениюСписания
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
	|	Документ.СписаниеНедостачТоваровВОтделении.Товары КАК ТаблицаТовары
	|ГДЕ
	|	ТаблицаТовары.Ссылка = &Ссылка
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	СерияНоменклатуры,
	|	Номенклатура,
	|	Партия";
	
	Запрос.УстановитьПараметр("Ссылка", Реквизиты.Ссылка);
	Запрос.УстановитьПараметр("СтатусУчетСебестоимостиПоСериям", Реквизиты.СтатусУчетСебестоимостиПоСериям);
	Запрос.УстановитьПараметр("СтатусУчетСебестоимостиПоПартиям", Реквизиты.СтатусУчетСебестоимостиПоПартиям);
	Запрос.Выполнить();
	
	Справочники.КлючиАналитикиУчетаНоменклатуры.ИнициализироватьКлючиАналитики(Запрос.МенеджерВременныхТаблиц);
	
КонецПроцедуры

Процедура ИнициализироватьКлючиАналитикиВидаУчета(Реквизиты)
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	Запрос.Текст =
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	&Организация КАК Организация,
	|	&Склад КАК Склад,
	|	ВЫБОР
	|		КОГДА &ВестиУчетПоИсточникамФинансирования
	|			ТОГДА ТаблицаТовары.ИсточникФинансирования
	|		ИНАЧЕ ЗНАЧЕНИЕ(Справочник.ИсточникиФинансирования.ПустаяСсылка)
	|	КОНЕЦ КАК ИсточникФинансирования
	|ПОМЕСТИТЬ втТаблицаАналитики
	|ИЗ
	|	Документ.СписаниеНедостачТоваровВОтделении.Товары КАК ТаблицаТовары
	|ГДЕ
	|	ТаблицаТовары.Ссылка = &Ссылка
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Организация,
	|	Склад,
	|	ИсточникФинансирования";
	
	Запрос.УстановитьПараметр("Ссылка", Реквизиты.Ссылка);
	Запрос.УстановитьПараметр("Организация", Реквизиты.Организация);
	Запрос.УстановитьПараметр("Склад", Реквизиты.Склад);
	Запрос.УстановитьПараметр("ВестиУчетПоИсточникамФинансирования", Реквизиты.ВестиУчетПоИсточникамФинансирования);
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
	
	ПечатныеФормы = УправлениеПечатьюБольничнаяАптека.СоздатьКоллекциюДоступныхПечатныхФорм();
	
	Обработки.ПечатьАктСписания0504230.ДобавитьПечатнуюФорму(ПечатныеФормы);
	Обработки.ПечатьАктСписания0510460.ДобавитьПечатнуюФорму(ПечатныеФормы);
	Обработки.ПечатьТОРГ16.ДобавитьПечатнуюФорму(ПечатныеФормы);
	
	МетаданныеДокумента = ПустаяСсылка().Метаданные();
	МенеджерПечати      = МетаданныеДокумента.ПолноеИмя();
	МетаданныеМакетов   = МетаданныеДокумента.Макеты;
	
	ПечатнаяФорма = УправлениеПечатьюБольничнаяАптека.ДобавитьПечатнуюФорму(ПечатныеФормы, "ВедомостьНаСписание", МенеджерПечати);
	ПечатнаяФорма.Представление = МетаданныеМакетов.ПФ_MXL_Накладная.Представление();
	ПечатнаяФорма.ПутьКМакету = ФормированиеПечатныхФормБольничнаяАптека.ПутьКМакету(МетаданныеМакетов.ПФ_MXL_Накладная);
	УправлениеПечатьюБольничнаяАптека.ДобавитьКомандуПечати(ПечатнаяФорма);
	
	ПечатнаяФорма = УправлениеПечатьюБольничнаяАптека.ДобавитьПечатнуюФорму(ПечатныеФормы, "АктСписанияТоваров", МенеджерПечати);
	ПечатнаяФорма.Представление = НСтр("ru='Акт списания товаров (форма АП-20)'");
	ПечатнаяФорма.ПутьКМакету = ФормированиеПечатныхФормБольничнаяАптека.ПутьКМакету(МетаданныеМакетов.ПФ_MXL_АктСписанияТоваров);
	УправлениеПечатьюБольничнаяАптека.ДобавитьКомандуПечати(ПечатнаяФорма);
	
	Возврат ПечатныеФормы;
	
КонецФункции

Функция ПечатьВедомостьНаСписание(МассивОбъектов, ОбъектыПечати) Экспорт
	
	ТабличныйДокумент = Новый ТабличныйДокумент;
	ТабличныйДокумент.ОриентацияСтраницы = ОриентацияСтраницы.Портрет;
	ТабличныйДокумент.АвтоМасштаб        = Истина;
	
	ПолноеИмяМакета = ФормированиеПечатныхФормБольничнаяАптека.ПутьКМакету(ПустаяСсылка().Метаданные().Макеты.ПФ_MXL_Накладная);
	ТабличныйДокумент.ИмяПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_" + ПолноеИмяМакета;
	Макет = УправлениеПечатью.МакетПечатнойФормы(ПолноеИмяМакета);
	
	МассивВыводимыхОбластей = Новый Массив;
	
	ВалютаПечати = ЗначениеНастроекБольничнаяАптекаПовтИсп.ПолучитьВалютуРегламентированногоУчета();
	
	ПараметрыПечати = Новый Структура;
	ПараметрыПечати.Вставить("ПолучатьЦены");
	ДанныеДляПечати = ПолучитьДанныеДляПечати(МассивОбъектов, ПараметрыПечати);
	
	Шапка = ДанныеДляПечати.РезультатПоШапке.Выбрать();
	ВыборкаПоДокументам = ДанныеДляПечати.РезультатПоТабличнойЧасти.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	
	ПервыйДокумент = Истина;
	Пока Шапка.Следующий() Цикл
		
		Если Не ПервыйДокумент Тогда
			ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		КонецЕсли;
		
		ПервыйДокумент = Ложь;
		НомерСтрокиНачало = ТабличныйДокумент.ВысотаТаблицы + 1;
		
		ШтрихкодированиеПечатныхФорм.ВывестиШтрихкодВТабличныйДокумент(Шапка.Ссылка, ТабличныйДокумент, Макет);
		
		// Получение параметров для заполнения
		ПараметрыИзШапки = ПолучитьПараметрыШапкиВедомостьНаСписание(Шапка);
		
		// Вывод области Заголовок
		ФормированиеПечатныхФормБольничнаяАптека.ВывестиОбластьПоИмени(ТабличныйДокумент, Макет, "Заголовок", ПараметрыИзШапки);
		
		// Вывод области РеквизитыШапки
		ФормированиеПечатныхФормБольничнаяАптека.ВывестиОбластьПоИмени(ТабличныйДокумент, Макет, "РеквизитыШапки", ПараметрыИзШапки);
		
		// Вывод области ШапкаТаблицы
		ФормированиеПечатныхФормБольничнаяАптека.ВывестиОбластьПоИмени(ТабличныйДокумент, Макет, "ШапкаТаблицы", ПараметрыИзШапки);
		
		// Инициализация итогов по документу
		ПараметрыИтого = Новый Структура;
		ПараметрыИтого.Вставить("Сумма", 0);
		
		ВыборкаПоДокументам.Сбросить();
		ПараметрыПоиска = Новый Структура("Документ", Шапка.Ссылка);
		Если ВыборкаПоДокументам.НайтиСледующий(ПараметрыПоиска) Тогда
			ВыборкаСтрокТовары = ВыборкаПоДокументам.Выбрать();
			
			КлючиПараметров = ФормированиеПечатныхФормБольничнаяАптека.ПолучитьИменаКолонокТаблицы(ВыборкаСтрокТовары);
			
			ОбластьСтрока = Макет.ПолучитьОбласть("Строка");
			
			КоличествоСтрок = ВыборкаСтрокТовары.Количество();
			НомерСтроки = 0;
			Пока ВыборкаСтрокТовары.Следующий() Цикл
				
				НомерСтроки = НомерСтроки + 1;
				
				ДанныеСтроки = Новый Структура(КлючиПараметров);
				ЗаполнитьЗначенияСвойств(ДанныеСтроки, ВыборкаСтрокТовары);
				
				ТоварНаименование = ОбщегоНазначенияБольничнаяАптека.ПолучитьПредставлениеНоменклатурыДляПечати(
					ВыборкаСтрокТовары.ТоварНаименование,
					ВыборкаСтрокТовары.СерияНоменклатуры,
					ВыборкаСтрокТовары.Партия);
				
				ДанныеСтроки.Вставить("ТоварНаименование" , ТоварНаименование);
				
				ОбластьСтрока.Параметры.Заполнить(ДанныеСтроки);
				
				МассивВыводимыхОбластей.Очистить();
				МассивВыводимыхОбластей.Добавить(ОбластьСтрока);
				Если НомерСтроки = КоличествоСтрок Тогда
					МассивВыводимыхОбластей.Добавить(Макет.ПолучитьОбласть("Итого"));
					МассивВыводимыхОбластей.Добавить(Макет.ПолучитьОбласть("Подписи"));
				КонецЕсли;
				
				Если Не ОбщегоНазначения.ПроверитьВыводТабличногоДокумента(ТабличныйДокумент, МассивВыводимыхОбластей) Тогда
					ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
					ТабличныйДокумент.Вывести(Макет.ПолучитьОбласть("ШапкаТаблицы"));
				КонецЕсли;
				
				// Вывод области Строка
				ТабличныйДокумент.Вывести(ОбластьСтрока);
				
				ФормированиеПечатныхФормБольничнаяАптека.РассчитатьИтоги(ДанныеСтроки, ПараметрыИтого);
				
			КонецЦикла;
		КонецЕсли;
		
		// Вывод области Итого
		ФормированиеПечатныхФормБольничнаяАптека.ВывестиОбластьПоИмени(ТабличныйДокумент, Макет, "Итого", ПараметрыИтого);
		
		// Вывод области СуммаПрописью
		ФорматированнаяСумма = ОбщегоНазначенияБольничнаяАптека.ФорматСумм(ПараметрыИтого.Сумма, ВалютаПечати);
		ИтоговаяСтрока = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Всего наименований %1, на сумму %2'"), КоличествоСтрок, ФорматированнаяСумма);
		
		ПараметрыСуммаПрописью = Новый Структура;
		ПараметрыСуммаПрописью.Вставить("ИтоговаяСтрока", ИтоговаяСтрока);
		ПараметрыСуммаПрописью.Вставить("СуммаПрописью" , РаботаСКурсамиВалют.СформироватьСуммуПрописью(ПараметрыИтого.Сумма, ВалютаПечати));
		
		ФормированиеПечатныхФормБольничнаяАптека.ВывестиОбластьПоИмени(ТабличныйДокумент, Макет, "СуммаПрописью", ПараметрыСуммаПрописью);
		
		// Вывод области Подписи
		ФормированиеПечатныхФормБольничнаяАптека.ВывестиОбластьПоИмени(ТабличныйДокумент, Макет, "Подписи", ПараметрыИзШапки);
		
		УправлениеПечатью.ЗадатьОбластьПечатиДокумента(ТабличныйДокумент, НомерСтрокиНачало, ОбъектыПечати, Шапка.Ссылка);
		
	КонецЦикла;
	
	Возврат ТабличныйДокумент;
	
КонецФункции

Функция ПолучитьПараметрыШапкиВедомостьНаСписание(Шапка)
	
	КлючиПараметров = ФормированиеПечатныхФормБольничнаяАптека.ПолучитьИменаКолонокТаблицы(Шапка);
	
	Параметры = Новый Структура(КлючиПараметров);
	ЗаполнитьЗначенияСвойств(Параметры, Шапка);
	
	// Данные заголовка
	НомерДокумента = ПрефиксацияОбъектовКлиентСервер.НомерНаПечать(Шапка.НомерДокумента);
	ШаблонТекстЗаголовка = НСтр("ru = 'Списание товаров № %1 от %2'");
	ТекстЗаголовка = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		ШаблонТекстЗаголовка, НомерДокумента, Формат(Шапка.ДатаДокумента, "ДЛФ=DD"));
	
	СведенияОбОрганизации    = ФормированиеПечатныхФорм.СведенияОЮрФизЛице(Шапка.Организация, Шапка.ДатаДокумента);
	ОрганизацияПредставление = ФормированиеПечатныхФорм.ОписаниеОрганизации(СведенияОбОрганизации, "ПолноеНаименование,");
	
	Параметры.Вставить("ТекстЗаголовка"          , ТекстЗаголовка);
	Параметры.Вставить("ОрганизацияПредставление", ОрганизацияПредставление);
	
	// Данные шапки таблицы
	Параметры.Вставить("ИмяКолонкиКодов", НСтр("ru = 'Код'"));
	
	// Данные подписей документа
	МОЛ = РегистрыСведений.МатериальноОтветственныеЛица.ПолучитьДанныеОтветственного(Шапка.Склад, Шапка.ДатаДокумента);
	
	Параметры.Вставить("Отпустил", МОЛ.ФИО);
	
	Возврат Параметры;
	
КонецФункции

Функция ПечатьАктСписанияТоваров(МассивОбъектов, ОбъектыПечати) Экспорт
	
	ТабДокумент = Новый ТабличныйДокумент;
	
	// Зададим параметры макета
	ТабДокумент.АвтоМасштаб = Истина;
	
	ТабДокумент.ИмяПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_СписаниеНедостачТоваровВОтделении_АктСписанияТоваров";
	
	Макет = УправлениеПечатью.МакетПечатнойФормы("Документ.СписаниеНедостачТоваровВОтделении.ПФ_MXL_АктСписанияТоваров");
	
	ВалютаПечати = ЗначениеНастроекБольничнаяАптекаПовтИсп.ПолучитьВалютуРегламентированногоУчета();
	
	ПараметрыПечати = Новый Структура;
	ПараметрыПечати.Вставить("ПолучатьЦены");
	ДанныеДляПечати = ПолучитьДанныеДляПечати(МассивОбъектов, ПараметрыПечати);
	
	Шапка = ДанныеДляПечати.РезультатПоШапке.Выбрать();
	ВыборкаПоДокументам = ДанныеДляПечати.РезультатПоТабличнойЧасти.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	
	ПервыйДокумент = Истина;
	Пока Шапка.Следующий() Цикл
		
		Если Не ПервыйДокумент Тогда
			ТабДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		КонецЕсли;
		
		ПервыйДокумент = Ложь;
		НомерСтрокиНачало = ТабДокумент.ВысотаТаблицы + 1;
		
		СведенияОПокупателе = ФормированиеПечатныхФорм.СведенияОЮрФизЛице(Шапка.Организация, Шапка.ДатаДокумента);
		ОбластьШапка = Макет.ПолучитьОбласть("Заголовок");
		ОбластьШапка.Параметры.Заполнить(Шапка);
		
		ШтрихкодированиеПечатныхФорм.ВывестиШтрихкодВТабличныйДокумент(Шапка.Ссылка, ТабДокумент, Макет, ОбластьШапка);
		
		ОбластьШапка.Параметры.ПредставлениеОрганизации = ФормированиеПечатныхФорм.ОписаниеОрганизации(СведенияОПокупателе, "ПолноеНаименование,");
		ОбластьШапка.Параметры.Дата = Формат(Шапка.ДатаДокумента, "ДЛФ=D");
		ОбластьШапка.Параметры.Номер = ПрефиксацияОбъектовКлиентСервер.НомерНаПечать(Шапка.НомерДокумента);
		ТабДокумент.Вывести(ОбластьШапка);
		
		ЗаголовокТаблицы = Макет.ПолучитьОбласть("Шапка");
		ТабДокумент.Вывести(ЗаголовокТаблицы);
		
		НомерСтроки = 0;
		
		// Инициализация итогов в документе
		СуммаИтого = 0;
		
		// Выводим многострочную часть документа
		ОбластьСтрока = Макет.ПолучитьОбласть("Строка");
		
		ВыборкаПоДокументам.Сбросить();
		ПараметрыПоиска = Новый Структура("Документ", Шапка.Ссылка);
		Если ВыборкаПоДокументам.НайтиСледующий(ПараметрыПоиска) Тогда
			ВыборкаСтрокТовары = ВыборкаПоДокументам.Выбрать();
			
			КоличествоСтрок = ВыборкаСтрокТовары.Количество();
			
			Пока ВыборкаСтрокТовары.Следующий() Цикл
				
				НомерСтроки = НомерСтроки + 1;
				
				ОбластьСтрока.Параметры.Заполнить(ВыборкаСтрокТовары);
				ОбластьСтрока.Параметры.НомерСтроки = НомерСтроки;
				ОбластьСтрока.Параметры.ТоварНаименование = ОбщегоНазначенияБольничнаяАптека.ПолучитьПредставлениеНоменклатурыДляПечати(
					ВыборкаСтрокТовары.ТоварНаименование,
					ВыборкаСтрокТовары.СерияНоменклатуры,
					ВыборкаСтрокТовары.Партия);
				
				ТабДокумент.Вывести(ОбластьСтрока);
				
				СуммаИтого = СуммаИтого + ВыборкаСтрокТовары.Сумма;
				
			КонецЦикла;
		КонецЕсли;
		
		// Вывести Сумму прописью
		ОбластьМакета = Макет.ПолучитьОбласть("Подвал");
		ОбластьМакета.Параметры.КоличествоПрописью = ЧислоПрописью(НомерСтроки,, НСтр("ru = 'наименование, наименования, наименований,с,,,,,0'"));
		ОбластьМакета.Параметры.СуммаПрописью  = РаботаСКурсамиВалют.СформироватьСуммуПрописью(СуммаИтого, ВалютаПечати);
		
		ТабДокумент.Вывести(ОбластьМакета);
		
		УправлениеПечатью.ЗадатьОбластьПечатиДокумента(ТабДокумент, НомерСтрокиНачало, ОбъектыПечати, Шапка.Ссылка);
		
	КонецЦикла;
	
	Возврат ТабДокумент;
	
КонецФункции

Функция ПолучитьДанныеДляПечати(МассивОбъектов, ПараметрыПечати = Неопределено) Экспорт
	
	ПолучатьЦены = Ложь;
	Если ТипЗнч(ПараметрыПечати) = Тип("Структура") Тогда
		ПолучатьЦены = ПараметрыПечати.Свойство("ПолучатьЦены");
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст = ТекстЗапросаДанныеДляПечати(ПолучатьЦены);
	Запрос.УстановитьПараметр("ТекущийДокумент", МассивОбъектов);
	Запрос.УстановитьПараметр("ИспользоватьИсточникиФинансирования", ПолучитьФункциональнуюОпцию("ИспользоватьИсточникиФинансирования"));
	ЗапасыСервер.УстановитьСтатусыПараметровУчетаВПараметрахЗапроса(Запрос);
	
	РезультатыЗапросов = Запрос.ВыполнитьПакет();
	
	ДанныеДляПечати = Новый Структура;
	ДанныеДляПечати.Вставить("РезультатПоШапке"          , РезультатыЗапросов[РезультатыЗапросов.ВГраница() - 2]);
	ДанныеДляПечати.Вставить("РезультатПоТабличнойЧасти" , РезультатыЗапросов[РезультатыЗапросов.ВГраница() - 1]);
	ДанныеДляПечати.Вставить("РезультатПоСоставуКомиссии", РезультатыЗапросов[РезультатыЗапросов.ВГраница()]);
	
	Возврат ДанныеДляПечати;
	
КонецФункции

Функция ТекстЗапросаДанныеДляПечати(ПолучатьЦены = Ложь)
	
	ТекстЗапроса = "
	|ВЫБРАТЬ
	|	Документ.Ссылка                                   КАК Ссылка,
	|	Документ.Номер                                    КАК НомерДокумента,
	|	Документ.Дата                                     КАК ДатаДокумента,
	|	Документ.Организация                              КАК Организация,
	|	Документ.Отделение                                КАК Подразделение,
	|	Документ.Отделение.Представление                  КАК ПодразделениеПредставление,
	|	Документ.Склад                                    КАК Склад,
	|	Документ.Склад.Представление                      КАК СкладПредставление,
	|	Документ.НомерПриказа                             КАК НомерПриказа,
	|	Документ.ДатаПриказа                              КАК ДатаПриказа,
	|	Документ.СтатьяРасходов                           КАК СтатьяРасходов,
	|	Документ.АналитикаРасходов                        КАК АналитикаРасходов,
	|	Документ.ВидЦены                                  КАК ВидЦены,
	|	Документ.Склад.ИсточникИнформацииОЦенахДляПечати  КАК ИсточникИнформацииОЦенах,
	|	РасчетСебестоимостиТоваров.ПредварительныйРасчет  КАК ПредварительныйРасчет
	|ПОМЕСТИТЬ втШапка
	|ИЗ
	|	Документ.СписаниеНедостачТоваровВОтделении КАК Документ
	|	ЛЕВОЕ СОЕДИНЕНИЕ
	|		Документ.РасчетСебестоимостиТоваров КАК РасчетСебестоимостиТоваров
	|	ПО
	|		РасчетСебестоимостиТоваров.Дата МЕЖДУ НАЧАЛОПЕРИОДА(Документ.Дата, МЕСЯЦ) И КОНЕЦПЕРИОДА(Документ.Дата, МЕСЯЦ)
	|		И РасчетСебестоимостиТоваров.Проведен
	|		И Документ.Организация = РасчетСебестоимостиТоваров.Организация
	|ГДЕ
	|	Документ.Ссылка В (&ТекущийДокумент)
	|;
	|
	|//////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Товары.Ссылка                            КАК Документ,
	|	Товары.НомерСтроки                       КАК НомерСтроки,
	|	КОНЕЦПЕРИОДА(Шапка.ДатаДокумента, ДЕНЬ)  КАК ДатаПолученияЦены,
	|	Шапка.Организация                        КАК Организация,
	|	Шапка.Склад                              КАК Склад,
	|	Шапка.ВидЦены                            КАК ВидЦены,
	|	Шапка.ИсточникИнформацииОЦенах           КАК ИсточникИнформацииОЦенах,
	|	Шапка.ПредварительныйРасчет              КАК ПредварительныйРасчет,
	|	ЗНАЧЕНИЕ(Перечисление.РазделыУчетаСебестоимостиТоваров.ТоварыВОтделениях) КАК РазделУчета,
	|	Товары.Номенклатура                      КАК Номенклатура,
	|	Товары.Номенклатура.НаименованиеПолное   КАК ТоварНаименование,
	|	Товары.Номенклатура.Код                  КАК ТоварКод,
	|	Товары.СерияНоменклатуры                 КАК СерияНоменклатуры,
	|	ВЫБОР
	|		КОГДА Товары.СтатусУказанияСерий В (&СтатусУчетСебестоимостиПоСериям)
	|			ТОГДА Товары.СерияНоменклатуры
	|		ИНАЧЕ ЗНАЧЕНИЕ(Справочник.СерииНоменклатуры.ПустаяСсылка)
	|	КОНЕЦ                                    КАК СерияНоменклатурыДляСебестоимости,
	|	ЕСТЬNULL(Товары.СерияНоменклатуры.ГоденДо, ДАТАВРЕМЯ(1,1,1,0,0,0))
	|	                                         КАК СрокГодности,
	|	Партия                                   КАК Партия,
	|	ВЫБОР
	|		КОГДА Товары.СтатусУказанияПартий В (&СтатусУчетСебестоимостиПоПартиям)
	|			ТОГДА Товары.Партия
	|		ИНАЧЕ ЗНАЧЕНИЕ(Справочник.ПартииНоменклатуры.ПустаяСсылка)
	|	КОНЕЦ                                    КАК ПартияДляСебестоимости,
	|	Товары.МестоХранения                     КАК МестоХранения,
	|	Товары.ЕдиницаИзмерения                  КАК ЕдиницаИзмерения,
	|	Товары.ЕдиницаИзмерения.КодОКЕИ          КАК КодПоОКЕИ,
	|	Товары.КоличествоВЕдиницахИзмерения      КАК Количество,
	|	Товары.Количество                        КАК КоличествоБазовых,
	|	ВЫБОР
	|		КОГДА &ИспользоватьИсточникиФинансирования
	|			ТОГДА Товары.ИсточникФинансирования
	|		ИНАЧЕ ЗНАЧЕНИЕ(Справочник.ИсточникиФинансирования.ПустаяСсылка)
	|	КОНЕЦ                                    КАК ИсточникФинансирования,
	|	Товары.Коэффициент                       КАК Коэффициент,
	|	Шапка.СтатьяРасходов                     КАК СтатьяРасходов,
	|	Шапка.АналитикаРасходов                  КАК АналитикаРасходов
	|ПОМЕСТИТЬ втТовары
	|ИЗ
	|	Документ.СписаниеНедостачТоваровВОтделении.Товары КАК Товары
	|	ЛЕВОЕ СОЕДИНЕНИЕ
	|		втШапка КАК Шапка
	|	ПО
	|		Товары.Ссылка = Шапка.Ссылка
	|ГДЕ
	|	Товары.Ссылка В (&ТекущийДокумент)
	|";
	
	ПараметрыПолученияЦен = ФормированиеПечатныхФормБольничнаяАптека.ПараметрыПолученияЦен();
	
	Если ПолучатьЦены Тогда
		
		ПараметрыПолученияЦен.ИспользоватьЦеныПоВидуЦен = Истина;
		ПараметрыПолученияЦен.ТочноеСоответствиеЦеныПоВидуЦен = Ложь;
		ПараметрыПолученияЦен.ИспользоватьЦеныПоСебестоимости = Истина;
		
	КонецЕсли;
	
	ТекстЗапроса = ФормированиеПечатныхФормБольничнаяАптека.ТекстЗапросаСЦенами(ТекстЗапроса, ПараметрыПолученияЦен);
	
	СхемаЗапроса = Новый СхемаЗапроса;
	СхемаЗапроса.УстановитьТекстЗапроса(ТекстЗапроса);
	Запрос = СхемаЗапроса.ПакетЗапросов.Добавить(Тип("ЗапросВыбораСхемыЗапроса"));
	Запрос.УстановитьТекстЗапроса("
	|ВЫБРАТЬ
	|	СоставКомиссии.Ссылка                     КАК Документ,
	|	СоставКомиссии.НомерСтроки                КАК НомерСтроки,
	|	СоставКомиссии.ЧленКомиссии               КАК ЧленКомиссии,
	|	СоставКомиссии.ЧленКомиссии.Наименование  КАК Представление,
	|	СоставКомиссии.Председатель               КАК Председатель,
	|	СоставКомиссии.Должность                  КАК Должность
	|ИЗ
	|	Документ.СписаниеНедостачТоваровВОтделении.СоставКомиссии КАК СоставКомиссии
	|ГДЕ
	|	СоставКомиссии.Ссылка В (&ТекущийДокумент)
	|
	|УПОРЯДОЧИТЬ ПО
	|	Ссылка,
	|	Председатель УБЫВ,
	|	НомерСтроки
	|ИТОГИ ПО
	|	Документ
	|");
	
	ТекстЗапроса = СхемаЗапроса.ПолучитьТекстЗапроса();
	
	Возврат ТекстЗапроса;
	
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