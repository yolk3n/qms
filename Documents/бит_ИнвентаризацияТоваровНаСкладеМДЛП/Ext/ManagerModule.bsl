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
	
	ПараметрыУчета.ИспользоватьСправочноеУказаниеСерий = Ложь;
	
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

// Инициализирует таблицы значений, содержащие данные табличных частей документа.
// Таблицы значений сохраняет в свойствах структуры "ДополнительныеСвойства".
//
Процедура СформироватьТаблицыДвиженийДляПроведения(ДополнительныеСвойства, Регистры = Неопределено) Экспорт
	
	ОсновныеДанныеДокумента = ПодготовитьОсновныеДанныеДляПроведения(ДополнительныеСвойства);
	
	ПроведениеБольничнаяАптека.ДобавитьТекстЗапросаДвижений(ДополнительныеСвойства, ТекстЗапросаВтТаблицаТовары());
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
	ЗапрашиваемыеДанные.Вставить("ДокументОснование", "Ссылка");
	ЗапрашиваемыеДанные.Вставить("Период", "Дата");
	ЗапрашиваемыеДанные.Вставить("Организация");
	ЗапрашиваемыеДанные.Вставить("Склад");
	ЗапрашиваемыеДанные.Вставить("Статус");
	
	ОсновныеДанныеДокумента = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(
		ПроведениеБольничнаяАптека.ПолучитьСсылкуНаДокументДляПроведения(ДополнительныеСвойства),
		ЗапрашиваемыеДанные);
	
	ОсновныеДанныеДокумента.Вставить("ВестиУчетПоИсточникамФинансирования", ПолучитьФункциональнуюОпцию("ИспользоватьИсточникиФинансирования"));
	
	ЗапасыСервер.ПриПодготовкеОсновныхДанныхДляПроведения(ДополнительныеСвойства, ОсновныеДанныеДокумента);
	
	Возврат ОсновныеДанныеДокумента;
	
КонецФункции

Функция ТекстЗапросаВтТаблицаТовары()
	
	ТекстЗапроса = "
	|ВЫБРАТЬ
	|	&Период                                                                  КАК Период,
	|	&Организация                                                             КАК Организация,
	|	&Склад КАК Склад,
	|	&ДокументОснование                                                       КАК ДокументОснование,
	|	МАКСИМУМ(ТаблицаТовары.НомерСтроки)                                      КАК НомерСтроки,
	|	ТаблицаТовары.Номенклатура КАК Номенклатура,
	|	ВЫБОР
	|		КОГДА ТаблицаТовары.СтатусУказанияСерий В (&СтатусУчетПоСериям, &СтатусУчетСебестоимостиПоСериям)
	|			ТОГДА ТаблицаТовары.СерияНоменклатуры
	|		ИНАЧЕ ЗНАЧЕНИЕ(Справочник.СерииНоменклатуры.ПустаяСсылка)
	|	КОНЕЦ                                                                    КАК СерияНоменклатуры,
	|	ВЫБОР
	|		КОГДА ТаблицаТовары.СтатусУказанияПартий В (&СтатусУчетПоПартиям, &СтатусУчетСебестоимостиПоПартиям)
	|			ТОГДА ТаблицаТовары.Партия
	|		ИНАЧЕ ЗНАЧЕНИЕ(Справочник.ПартииНоменклатуры.ПустаяСсылка)
	|	КОНЕЦ                                                                    КАК Партия,
	|	ВЫБОР
	|		КОГДА &ВестиУчетПоИсточникамФинансирования
	|			ТОГДА ТаблицаТовары.ИсточникФинансирования
	|		ИНАЧЕ ЗНАЧЕНИЕ(Справочник.ИсточникиФинансирования.ПустаяСсылка)
	|	КОНЕЦ                                                                    КАК ИсточникФинансирования,
	|	Сумма(ТаблицаТовары.Количество - ТаблицаТовары.КоличествоПоДаннымУчета)  КАК КОформлениюОприходования,
	|	0 КАК КОформлениюСписания
	|ПОМЕСТИТЬ ВтТаблицаТовары
	|ИЗ
	|	Документ.ИнвентаризацияТоваровНаСкладе.Товары КАК ТаблицаТовары
	|ГДЕ
	|	&Статус = ЗНАЧЕНИЕ(Перечисление.СтатусыИнвентаризацииТоваров.Выполнено)
	|	И ТаблицаТовары.Ссылка = &Ссылка
	|
	|СГРУППИРОВАТЬ ПО
	|	ТаблицаТовары.Номенклатура,
	|	ВЫБОР
	|		КОГДА ТаблицаТовары.СтатусУказанияСерий В (&СтатусУчетПоСериям, &СтатусУчетСебестоимостиПоСериям)
	|			ТОГДА ТаблицаТовары.СерияНоменклатуры
	|		ИНАЧЕ ЗНАЧЕНИЕ(Справочник.СерииНоменклатуры.ПустаяСсылка)
	|	КОНЕЦ,
	|	ВЫБОР
	|		КОГДА ТаблицаТовары.СтатусУказанияПартий В (&СтатусУчетПоПартиям, &СтатусУчетСебестоимостиПоПартиям)
	|			ТОГДА ТаблицаТовары.Партия
	|		ИНАЧЕ ЗНАЧЕНИЕ(Справочник.ПартииНоменклатуры.ПустаяСсылка)
	|	КОНЕЦ,
	|	ВЫБОР
	|		КОГДА &ВестиУчетПоИсточникамФинансирования
	|			ТОГДА ТаблицаТовары.ИсточникФинансирования
	|		ИНАЧЕ ЗНАЧЕНИЕ(Справочник.ИсточникиФинансирования.ПустаяСсылка)
	|	КОНЕЦ
	|
	|ИМЕЮЩИЕ
	|	СУММА(ТаблицаТовары.КоличествоВЕдиницахИзмерения - ТаблицаТовары.КоличествоВЕдиницахИзмеренияПоДаннымУчета) > 0
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	&Период,
	|	&Организация,
	|	&Склад,
	|	&ДокументОснование,
	|	МАКСИМУМ(ТаблицаТовары.НомерСтроки),
	|	ТаблицаТовары.Номенклатура,
	|	ВЫБОР
	|		КОГДА ТаблицаТовары.СтатусУказанияСерий В (&СтатусУчетПоСериям, &СтатусУчетСебестоимостиПоСериям)
	|			ТОГДА ТаблицаТовары.СерияНоменклатуры
	|		ИНАЧЕ ЗНАЧЕНИЕ(Справочник.СерииНоменклатуры.ПустаяСсылка)
	|	КОНЕЦ,
	|	ВЫБОР
	|		КОГДА ТаблицаТовары.СтатусУказанияПартий В (&СтатусУчетПоПартиям, &СтатусУчетСебестоимостиПоПартиям)
	|			ТОГДА ТаблицаТовары.Партия
	|		ИНАЧЕ ЗНАЧЕНИЕ(Справочник.ПартииНоменклатуры.ПустаяСсылка)
	|	КОНЕЦ,
	|	ВЫБОР
	|		КОГДА &ВестиУчетПоИсточникамФинансирования
	|			ТОГДА ТаблицаТовары.ИсточникФинансирования
	|		ИНАЧЕ ЗНАЧЕНИЕ(Справочник.ИсточникиФинансирования.ПустаяСсылка)
	|	КОНЕЦ,
	|	0,
	|	Сумма(ТаблицаТовары.КоличествоПоДаннымУчета - ТаблицаТовары.Количество)
	|ИЗ
	|	Документ.ИнвентаризацияТоваровНаСкладе.Товары КАК ТаблицаТовары
	|ГДЕ
	|	&Статус = ЗНАЧЕНИЕ(Перечисление.СтатусыИнвентаризацииТоваров.Выполнено)
	|	И ТаблицаТовары.Ссылка = &Ссылка
	|
	|СГРУППИРОВАТЬ ПО
	|	ТаблицаТовары.Номенклатура,
	|	ВЫБОР
	|		КОГДА ТаблицаТовары.СтатусУказанияСерий В (&СтатусУчетПоСериям, &СтатусУчетСебестоимостиПоСериям)
	|			ТОГДА ТаблицаТовары.СерияНоменклатуры
	|		ИНАЧЕ ЗНАЧЕНИЕ(Справочник.СерииНоменклатуры.ПустаяСсылка)
	|	КОНЕЦ,
	|	ВЫБОР
	|		КОГДА ТаблицаТовары.СтатусУказанияПартий В (&СтатусУчетПоПартиям, &СтатусУчетСебестоимостиПоПартиям)
	|			ТОГДА ТаблицаТовары.Партия
	|		ИНАЧЕ ЗНАЧЕНИЕ(Справочник.ПартииНоменклатуры.ПустаяСсылка)
	|	КОНЕЦ,
	|	ВЫБОР
	|		КОГДА &ВестиУчетПоИсточникамФинансирования
	|			ТОГДА ТаблицаТовары.ИсточникФинансирования
	|		ИНАЧЕ ЗНАЧЕНИЕ(Справочник.ИсточникиФинансирования.ПустаяСсылка)
	|	КОНЕЦ
	|
	|ИМЕЮЩИЕ
	|	СУММА(ТаблицаТовары.КоличествоВЕдиницахИзмерения - ТаблицаТовары.КоличествоВЕдиницахИзмеренияПоДаннымУчета) < 0
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|";
	
	Возврат ТекстЗапроса;
	
КонецФункции

Функция ТекстЗапросаТоварыКОформлениюИзлишковНедостач()
	
	ТекстЗапроса = "
	|ВЫБРАТЬ
	|	ТаблицаТовары.Период                    КАК Период,
	|	ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход)  КАК ВидДвижения,
	|	ТаблицаТовары.Организация               КАК Организация,
	|	ТаблицаТовары.Склад                     КАК Склад,
	|	ТаблицаТовары.ДокументОснование         КАК ДокументОснование,
	|	ТаблицаТовары.НомерСтроки               КАК НомерСтроки,
	|	ТаблицаТовары.Номенклатура              КАК Номенклатура,
	|	ТаблицаТовары.СерияНоменклатуры         КАК СерияНоменклатуры,
	|	ТаблицаТовары.Партия                    КАК Партия,
	|	ТаблицаТовары.ИсточникФинансирования    КАК ИсточникФинансирования,
	|	ТаблицаТовары.КОформлениюОприходования  КАК КОформлениюОприходования,
	|	ТаблицаТовары.КОформлениюСписания       КАК КОформлениюСписания
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
	
	ПечатнаяФорма = Обработки.ПечатьИнвентаризационнаяОписьНФА_0504087.ДобавитьПечатнуюФорму(ПечатныеФормы);
	КомандаПечати = УправлениеПечатьюБольничнаяАптека.ДобавитьКомандуПечати(ПечатнаяФорма);
	
	КомандаПечати = УправлениеПечатьюБольничнаяАптека.ДобавитьКомандуПечати(ПечатнаяФорма);
	КомандаПечати.Представление = КомандаПечати.Представление + " " + НСтр("ru = 'с пустыми фактическими данными'");
	КомандаПечати.ДополнительныеПараметры.Вставить("БезФактическихДанных", Истина);
	
	ПечатнаяФорма = Обработки.ПечатьИнвентаризационнаяОписьНФА_0504087_194н.ДобавитьПечатнуюФорму(ПечатныеФормы);
	КомандаПечати = УправлениеПечатьюБольничнаяАптека.ДобавитьКомандуПечати(ПечатнаяФорма);
	
	КомандаПечати = УправлениеПечатьюБольничнаяАптека.ДобавитьКомандуПечати(ПечатнаяФорма);
	КомандаПечати.Представление = КомандаПечати.Представление + " " + НСтр("ru = 'с пустыми фактическими данными'");
	КомандаПечати.ДополнительныеПараметры.Вставить("БезФактическихДанных", Истина);
	
	ПечатнаяФорма = Обработки.ПечатьИНВ3.ДобавитьПечатнуюФорму(ПечатныеФормы);
	КомандаПечати = УправлениеПечатьюБольничнаяАптека.ДобавитьКомандуПечати(ПечатнаяФорма);
	
	КомандаПечати = УправлениеПечатьюБольничнаяАптека.ДобавитьКомандуПечати(ПечатнаяФорма);
	КомандаПечати.Представление = КомандаПечати.Представление + " " + НСтр("ru = 'с пустыми фактическими данными'");
	КомандаПечати.ДополнительныеПараметры.Вставить("БезФактическихДанных", Истина);
	
	ПечатнаяФорма = Обработки.ПечатьИНВ19.ДобавитьПечатнуюФорму(ПечатныеФормы);
	КомандаПечати = УправлениеПечатьюБольничнаяАптека.ДобавитьКомандуПечати(ПечатнаяФорма);
	
	Возврат ПечатныеФормы;
	
КонецФункции

Функция ПолучитьДанныеДляПечати(МассивОбъектов, ПараметрыПечати = Неопределено) Экспорт
	
	БезФактическихДанных = Ложь;
	Если ТипЗнч(ПараметрыПечати) = Тип("Структура") Тогда
		Если ПараметрыПечати.Свойство("БезФактическихДанных") Тогда
			БезФактическихДанных = ПараметрыПечати.БезФактическихДанных;
		КонецЕсли;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст = ТекстЗапросаДанныеДляПечати();
	Запрос.УстановитьПараметр("ТекущийДокумент", МассивОбъектов);
	Запрос.УстановитьПараметр("ИспользоватьИсточникиФинансирования", ПолучитьФункциональнуюОпцию("ИспользоватьИсточникиФинансирования"));
	Запрос.УстановитьПараметр("БезФактическихДанных", БезФактическихДанных);
	ЗапасыСервер.УстановитьСтатусыПараметровУчетаВПараметрахЗапроса(Запрос);
	
	ОсновныеДанные = Запрос.Выполнить().Выбрать();
	
	ДанныеДляПечати = Новый Структура;
	ДанныеДляПечати.Вставить("ОсновныеДанные"      , ОсновныеДанные);
	ДанныеДляПечати.Вставить("БезФактическихДанных", БезФактическихДанных);
	
	Возврат ДанныеДляПечати;
	
КонецФункции

Функция ТекстЗапросаДанныеДляПечати()
	
	ТекстЗапроса = "
	|ВЫБРАТЬ
	|	Документ.Ссылка                                            КАК Ссылка,
	|	Документ.Номер                                             КАК НомерДокумента,
	|	Документ.Дата                                              КАК ДатаДокумента,
	|	Документ.ДатаОкончанияИнвентаризации                       КАК ДатаСнятияОстатков,
	|	Документ.ДатаНачалаИнвентаризации                          КАК ДатаНачалаИнвентаризации,
	|	Документ.ДатаОкончанияИнвентаризации                       КАК ДатаОкончанияИнвентаризации,
	|	Документ.ДокументОснованиеВид                              КАК ДокументОснованиеВид,
	|	Документ.ДокументОснованиеДата                             КАК ДокументОснованиеДата,
	|	Документ.ДокументОснованиеНомер                            КАК ДокументОснованиеНомер,
	|	Документ.Организация                                       КАК Организация,
	|	Документ.Склад                                             КАК Склад,
	|	Документ.Склад.Представление                               КАК ПредставлениеСклада,
	|	ВЫБОР
	|		КОГДА &ИспользоватьИсточникиФинансирования
	|			ТОГДА Документ.ИсточникФинансирования
	|		ИНАЧЕ ЗНАЧЕНИЕ(Справочник.ИсточникиФинансирования.ПустаяСсылка)
	|	КОНЕЦ                                                      КАК ИсточникФинансирования,
	|	Документ.ИсточникИнформацииОЦенахДляПечати                 КАК ИсточникИнформацииОЦенахДляПечати,
	|	Документ.ВидЦены                                           КАК ВидЦены,
	|	Документ.Товары.(
	|		НомерСтроки                                КАК НомерСтроки,
	|		ИсточникФинансирования                     КАК ИсточникФинансирования,
	|		Номенклатура                               КАК Номенклатура,
	|		Номенклатура.НаименованиеПолное            КАК ТоварНаименование,
	|		Номенклатура.Код                           КАК ТоварКод,
	|		ЕдиницаИзмерения.Представление             КАК ЕдиницаИзмерения,
	|		ЕдиницаИзмерения.КодОКЕИ                   КАК КодПоОКЕИ,
	|		Коэффициент                                КАК Коэффициент,
	|		ВЫБОР
	|			КОГДА &БезФактическихДанных
	|				ТОГДА 0
	|			ИНАЧЕ КоличествоВЕдиницахИзмерения
	|		КОНЕЦ                                      КАК ФактКоличество,
	|		КоличествоВЕдиницахИзмеренияПоДаннымУчета  КАК БухКоличество,
	|		0                                          КАК Цена,
	|		ВЫБОР
	|			КОГДА &БезФактическихДанных
	|				ТОГДА 0
	|			ИНАЧЕ 0
	|		КОНЕЦ                                      КАК ФактСумма,
	|		0                                          КАК БухСумма,
	|		СерияНоменклатуры                          КАК Серия,
	|		ВЫБОР
	|			КОГДА Товары.СтатусУказанияСерий В (&СтатусУчетСебестоимостиПоСериям)
	|				ТОГДА Товары.СерияНоменклатуры
	|			ИНАЧЕ ЗНАЧЕНИЕ(Справочник.СерииНоменклатуры.ПустаяСсылка)
	|		КОНЕЦ                                      КАК СерияНоменклатурыДляСебестоимости,
	|		Партия                                     КАК Партия,
	|		ВЫБОР
	|			КОГДА Товары.СтатусУказанияПартий В (&СтатусУчетСебестоимостиПоПартиям)
	|				ТОГДА Товары.Партия
	|			ИНАЧЕ ЗНАЧЕНИЕ(Справочник.ПартииНоменклатуры.ПустаяСсылка)
	|		КОНЕЦ                                      КАК ПартияДляСебестоимости,
	|		ВЫБОР
	|			КОГДА НЕ &БезФактическихДанных
	|				ТОГДА Товары.СтатусОбъекта
	|			ИНАЧЕ ЗНАЧЕНИЕ(Справочник.СтатусыОбъектовДляИнвентаризации.ПустаяСсылка)
	|		КОНЕЦ                                      КАК СтатусОбъекта,
	|		ВЫБОР
	|			КОГДА НЕ &БезФактическихДанных
	|				ТОГДА Товары.ЦелеваяФункцияАктива
	|			ИНАЧЕ ЗНАЧЕНИЕ(Справочник.ЦелевыеФункцииАктивовДляИнвентаризации.ПустаяСсылка)
	|		КОНЕЦ                                      КАК ЦелеваяФункция,
	|		ВЫБОР
	|			КОГДА НЕ &БезФактическихДанных
	|				ТОГДА Товары.КоличествоНеСоответствующееУсловиямАктива
	|			ИНАЧЕ 0
	|		КОНЕЦ                                      КАК КоличествоНеСоответствующееУсловиямАктива
	|	),
	|	Документ.ИнвентаризационнаяКомиссия.(
	|		НомерСтроки                КАК НомерСтроки,
	|		Должность                  КАК Должность,
	|		ЧленКомиссии.Наименование  КАК Представление,
	|		Председатель               КАК Председатель
	|	)
	|ИЗ
	|	Документ.ИнвентаризацияТоваровНаСкладе КАК Документ
	|ГДЕ
	|	Документ.Ссылка В(&ТекущийДокумент)
	|
	|УПОРЯДОЧИТЬ ПО
	|	Документ.Ссылка,
	|	Товары.НомерСтроки,
	|	ИнвентаризационнаяКомиссия.Председатель УБЫВ,
	|	ИнвентаризационнаяКомиссия.НомерСтроки
	|";
	
	Возврат ТекстЗапроса;
	
КонецФункции

// Формирует таблицу цен документа для печати
//
Функция ПолучитьТаблицуЦен(Шапка) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	ТекстЗапроса = "
	|ВЫБРАТЬ
	|	Товары.НомерСтроки                    КАК НомерСтроки,
	|	Товары.Номенклатура                   КАК Номенклатура,
	|	Товары.СерияНоменклатуры              КАК СерияНоменклатуры,
	|	Товары.Партия                         КАК Партия,
	|	Товары.ЕдиницаИзмерения               КАК ЕдиницаИзмерения,
	|	Товары.Коэффициент                    КАК Коэффициент,
	|	ВЫБОР
	|		КОГДА Товары.СтатусУказанияСерий В (&СтатусУчетСебестоимостиПоСериям)
	|			ТОГДА Товары.СерияНоменклатуры
	|		ИНАЧЕ ЗНАЧЕНИЕ(Справочник.СерииНоменклатуры.ПустаяСсылка)
	|	КОНЕЦ                                 КАК СерияНоменклатурыДляСебестоимости,
	|	ВЫБОР
	|		КОГДА Товары.СтатусУказанияПартий В (&СтатусУчетСебестоимостиПоПартиям)
	|			ТОГДА Товары.Партия
	|		ИНАЧЕ ЗНАЧЕНИЕ(Справочник.ПартииНоменклатуры.ПустаяСсылка)
	|	КОНЕЦ                                 КАК ПартияДляСебестоимости,
	|	ВЫБОР
	|		КОГДА &ИспользоватьИсточникиФинансирования
	|			ТОГДА Товары.ИсточникФинансирования
	|		ИНАЧЕ ЗНАЧЕНИЕ(Справочник.ИсточникиФинансирования.ПустаяСсылка)
	|	КОНЕЦ                                 КАК ИсточникФинансирования,
	|	Товары.Ссылка.Организация             КАК Организация,
	|	Товары.Ссылка.Склад                   КАК Склад,
	|	ЗНАЧЕНИЕ(Перечисление.РазделыУчетаСебестоимостиТоваров.ТоварыНаСкладах) КАК РазделУчета
	|ПОМЕСТИТЬ ТаблицаТовары
	|ИЗ
	|	Документ.ИнвентаризацияТоваровНаСкладе.Товары КАК Товары
	|ГДЕ
	|	Товары.Ссылка = &ТекущийДокумент
	|;
	|
	|/////////////////////////////////////////////////////////////////////////////
	|";
	
	Если Шапка.ИсточникИнформацииОЦенахДляПечати = Перечисления.ИсточникиИнформацииОЦенахДляПечати.ПоСебестоимости Тогда
		
		РасчетВыполнен = Документы.РасчетСебестоимостиТоваров.РасчетВыполнен(Шапка.Организация, Шапка.ДатаДокумента);
		Если Не РасчетВыполнен.ФактическийРасчет И Не РасчетВыполнен.ПредварительныйРасчет Тогда
			
			ТекстСообщения = НСтр("ru = 'Не удалось получить цены по себестоимости для документа %Документ%: с %ПериодС% по %ПериодПо% не произведен расчет себестоимости.'");
			
			ТекстСообщения = СтрЗаменить(ТекстСообщения, "%Документ%", Шапка.Ссылка);
			ТекстСообщения = СтрЗаменить(ТекстСообщения, "%ПериодС%", Формат(НачалоМесяца(Шапка.ДатаДокумента),"ДЛФ=DD"));
			ТекстСообщения = СтрЗаменить(ТекстСообщения, "%ПериодПо%", Формат(КонецМесяца(Шапка.ДатаДокумента),"ДЛФ=DD"));
			
			ОбщегоНазначения.СообщитьПользователю(ТекстСообщения);
			Возврат Неопределено;
			
		КонецЕсли;
		
		ТекстЗапроса = ТекстЗапроса + "
		|ВЫБРАТЬ
		|	Товары.НомерСтроки                        КАК НомерСтроки,
		|	Товары.РазделУчета                        КАК РазделУчета,
		|	АналитикиВидаУчета.КлючАналитики          КАК АналитикаВидаУчета,
		|	АналитикиУчетаНоменклатуры.КлючАналитики  КАК АналитикаУчетаНоменклатуры
		|ПОМЕСТИТЬ Аналитика
		|ИЗ
		|	ТаблицаТовары КАК Товары
		|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ
		|		РегистрСведений.АналитикаВидаУчета КАК АналитикиВидаУчета
		|	ПО
		|		АналитикиВидаУчета.Организация = Товары.Организация
		|		И АналитикиВидаУчета.Склад = Товары.Склад
		|		И АналитикиВидаУчета.ИсточникФинансирования = Товары.ИсточникФинансирования
		|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ
		|		РегистрСведений.АналитикаУчетаНоменклатуры КАК АналитикиУчетаНоменклатуры
		|	ПО
		|		АналитикиУчетаНоменклатуры.Номенклатура = Товары.Номенклатура
		|		И АналитикиУчетаНоменклатуры.СерияНоменклатуры = Товары.СерияНоменклатурыДляСебестоимости
		|		И АналитикиУчетаНоменклатуры.Партия = Товары.ПартияДляСебестоимости
		|;
		|
		|/////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	СтоимостьТоваров.РазделУчета                 КАК РазделУчета,
		|	СтоимостьТоваров.АналитикаВидаУчета          КАК АналитикаВидаУчета,
		|	СтоимостьТоваров.АналитикаУчетаНоменклатуры  КАК АналитикаУчетаНоменклатуры,
		|	СтоимостьТоваров.СтоимостьРегл               КАК Цена
		|ПОМЕСТИТЬ СтоимостьТоваров
		|ИЗ
		|	РегистрСведений.СтоимостьТоваров.СрезПоследних(
		|			&ДатаОкончания,
		|			(РазделУчета, АналитикаВидаУчета, АналитикаУчетаНоменклатуры) В
		|				(ВЫБРАТЬ
		|					Таблица.РазделУчета,
		|					Таблица.АналитикаВидаУчета,
		|					Таблица.АналитикаУчетаНоменклатуры
		|				ИЗ
		|					Аналитика КАК Таблица)
		|		) КАК СтоимостьТоваров
		|;
		|
		|/////////////////////////////////////////////////////////////////////////////
		|";
		
		Если РасчетВыполнен.ПредварительныйРасчет Тогда
			ТекстЗапроса = ТекстЗапроса + "
			|ВЫБРАТЬ
			|	Товары.НомерСтроки                    КАК НомерСтроки,
			|	ЕСТЬNULL(СтоимостьТоваров.Цена, 0)    КАК Цена
			|ПОМЕСТИТЬ ЦеныНоменклатуры
			|ИЗ
			|	Аналитика КАК Товары
			|	ЛЕВОЕ СОЕДИНЕНИЕ
			|		СтоимостьТоваров КАК СтоимостьТоваров
			|	ПО
			|		Товары.РазделУчета = СтоимостьТоваров.РазделУчета
			|		И Товары.АналитикаВидаУчета = СтоимостьТоваров.АналитикаВидаУчета
			|		И Товары.АналитикаУчетаНоменклатуры = СтоимостьТоваров.АналитикаУчетаНоменклатуры
			|;
			|
			|////////////////////////////////////////////////////////////////////////////
			|";
		Иначе
			ТекстЗапроса = ТекстЗапроса + "
			|ВЫБРАТЬ
			|	СтоимостьТоваровОстатки.РазделУчета                 КАК РазделУчета,
			|	СтоимостьТоваровОстатки.АналитикаВидаУчета          КАК АналитикаВидаУчета,
			|	СтоимостьТоваровОстатки.АналитикаУчетаНоменклатуры  КАК АналитикаУчетаНоменклатуры,
			|	ВЫБОР
			|		КОГДА СтоимостьТоваровОстатки.КоличествоОстаток = 0
			|			ТОГДА 0
			|		ИНАЧЕ ВЫРАЗИТЬ(СтоимостьТоваровОстатки.СтоимостьРеглОстаток КАК ЧИСЛО(23, 10)) / СтоимостьТоваровОстатки.КоличествоОстаток
			|	КОНЕЦ                                               КАК Цена
			|ПОМЕСТИТЬ СтоимостьТоваровОстатки
			|ИЗ
			|	РегистрНакопления.СебестоимостьТоваров.Остатки(
			|			&ДатаОстатков,
			|			(РазделУчета, АналитикаВидаУчета, АналитикаУчетаНоменклатуры) В
			|				(ВЫБРАТЬ
			|					Таблица.РазделУчета,
			|					Таблица.АналитикаВидаУчета,
			|					Таблица.АналитикаУчетаНоменклатуры
			|				ИЗ
			|					Аналитика КАК Таблица)
			|		) КАК СтоимостьТоваровОстатки
			|;
			|
			|////////////////////////////////////////////////////////////////////////////
			|ВЫБРАТЬ
			|	Товары.НомерСтроки  КАК НомерСтроки,
			|	ВЫБОР
			|		КОГДА ЕСТЬNULL(СтоимостьТоваровОстатки.Цена, 0) = 0
			|			ТОГДА ЕСТЬNULL(СтоимостьТоваров.Цена, 0)
			|		ИНАЧЕ СтоимостьТоваровОстатки.Цена
			|	КОНЕЦ               КАК Цена
			|ПОМЕСТИТЬ ЦеныНоменклатуры
			|ИЗ
			|	Аналитика КАК Товары
			|	ЛЕВОЕ СОЕДИНЕНИЕ
			|		СтоимостьТоваровОстатки КАК СтоимостьТоваровОстатки
			|	ПО
			|		Товары.РазделУчета = СтоимостьТоваровОстатки.РазделУчета
			|		И Товары.АналитикаВидаУчета = СтоимостьТоваровОстатки.АналитикаВидаУчета
			|		И Товары.АналитикаУчетаНоменклатуры = СтоимостьТоваровОстатки.АналитикаУчетаНоменклатуры
			|	ЛЕВОЕ СОЕДИНЕНИЕ
			|		СтоимостьТоваров КАК СтоимостьТоваров
			|	ПО
			|		Товары.РазделУчета = СтоимостьТоваров.РазделУчета
			|		И Товары.АналитикаВидаУчета = СтоимостьТоваров.АналитикаВидаУчета
			|		И Товары.АналитикаУчетаНоменклатуры = СтоимостьТоваров.АналитикаУчетаНоменклатуры
			|;
			|
			|////////////////////////////////////////////////////////////////////////////
			|";
		КонецЕсли;
		ТекстЗапроса = ТекстЗапроса + "
		|ВЫБРАТЬ
		|	Товары.НомерСтроки  КАК НомерСтроки,
		|	ЕСТЬNULL(ЦеныНоменклатуры.Цена, 0) * Товары.Коэффициент КАК Цена
		|ИЗ
		|	ТаблицаТовары КАК Товары
		|	ЛЕВОЕ СОЕДИНЕНИЕ
		|		ЦеныНоменклатуры КАК ЦеныНоменклатуры
		|	ПО
		|		Товары.НомерСтроки = ЦеныНоменклатуры.НомерСтроки
		|";
		
	ИначеЕсли Шапка.ИсточникИнформацииОЦенахДляПечати = Перечисления.ИсточникиИнформацииОЦенахДляПечати.ПоВидуЦен Тогда
		
		ТекстЗапроса = ТекстЗапроса + "
		|ВЫБРАТЬ
		|	ЦеныНоменклатуры.Номенклатура       КАК Номенклатура,
		|	ЦеныНоменклатуры.СерияНоменклатуры  КАК СерияНоменклатуры,
		|	ЦеныНоменклатуры.Партия             КАК Партия,
		|	ЦеныНоменклатуры.Упаковка           КАК Упаковка,
		|	ЦеныНоменклатуры.Цена
		|	* ВЫБОР
		|		КОГДА &Валюта <> ЦеныНоменклатуры.Валюта
		|			ТОГДА ВЫБОР
		|					КОГДА ЕСТЬNULL(КурсыВалютыЦены.Кратность, 0) > 0
		|						И ЕСТЬNULL(КурсыВалютыЦены.Курс, 0) > 0
		|						И ЕСТЬNULL(КурсыВалюты.Кратность, 0) > 0
		|						И ЕСТЬNULL(КурсыВалюты.Курс, 0) > 0
		|					ТОГДА 
		|						(КурсыВалютыЦены.Курс * КурсыВалюты.Кратность)
		|						/ (КурсыВалюты.Курс * КурсыВалютыЦены.Кратность)
		|					ИНАЧЕ 0
		|				КОНЕЦ
		|		ИНАЧЕ 1
		|	КОНЕЦ                               КАК Цена
		|ПОМЕСТИТЬ ЦеныНоменклатуры
		|ИЗ
		|	РегистрСведений.ЦеныНоменклатуры.СрезПоследних(
		|			&ДатаОкончания,
		|			ВидЦены = &ВидЦены
		|			И (Номенклатура, СерияНоменклатуры, Партия) В
		|				(ВЫБРАТЬ
		|					Таблица.Номенклатура,
		|					Таблица.СерияНоменклатуры,
		|					Таблица.Партия
		|				ИЗ
		|					ТаблицаТовары КАК Таблица)) КАК ЦеныНоменклатуры
		|
		|	ЛЕВОЕ СОЕДИНЕНИЕ
		|		РегистрСведений.КурсыВалют.СрезПоследних(&ДатаОкончания, ) КАК КурсыВалютыЦены
		|	ПО
		|		ЦеныНоменклатуры.Валюта = КурсыВалютыЦены.Валюта
		|
		|	ЛЕВОЕ СОЕДИНЕНИЕ
		|		РегистрСведений.КурсыВалют.СрезПоследних(&ДатаОкончания, Валюта = &Валюта) КАК КурсыВалюты
		|	ПО
		|		ИСТИНА
		|;
		|
		|////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	Товары.НомерСтроки  КАК НомерСтроки,
		|	ВЫБОР
		|		КОГДА Товары.ЕдиницаИзмерения <> ЕСТЬNULL(ЦеныНоменклатуры.Упаковка, Товары.ЕдиницаИзмерения)
		|			ТОГДА  Товары.Коэффициент
		|		ИНАЧЕ 1
		|	КОНЕЦ
		|	* ЕСТЬNULL(ЦеныНоменклатуры.Цена, 0)
		|	/ ВЫБОР
		|		КОГДА Товары.ЕдиницаИзмерения <> ЕСТЬNULL(ЦеныНоменклатуры.Упаковка, Товары.ЕдиницаИзмерения)
		|			ТОГДА  КоэффициентыУпаковокЦены.Коэффициент
		|		ИНАЧЕ 1
		|	КОНЕЦ КАК Цена
		|ИЗ
		|	ТаблицаТовары КАК Товары
		|	ЛЕВОЕ СОЕДИНЕНИЕ
		|		ЦеныНоменклатуры КАК ЦеныНоменклатуры
		|	ПО
		|		Товары.Номенклатура = ЦеныНоменклатуры.Номенклатура
		|		И Товары.СерияНоменклатуры = ЦеныНоменклатуры.СерияНоменклатуры
		|		И Товары.Партия = ЦеныНоменклатуры.Партия
		|
		|	ЛЕВОЕ СОЕДИНЕНИЕ
		|		РегистрСведений.ЕдиницыИзмеренияНоменклатуры КАК КоэффициентыУпаковокЦены
		|	ПО
		|		ЦеныНоменклатуры.Номенклатура = КоэффициентыУпаковокЦены.Номенклатура
		|		И ЦеныНоменклатуры.Упаковка = КоэффициентыУпаковокЦены.ЕдиницаИзмерения
		|";
		
	КонецЕсли;
	
	ДатаОкончания = КонецДня(Шапка.ДатаДокумента);
	
	Запрос = Новый Запрос(ТекстЗапроса);
	Запрос.УстановитьПараметр("ТекущийДокумент", Шапка.Ссылка);
	Запрос.УстановитьПараметр("ДатаОкончания", ДатаОкончания);
	Запрос.УстановитьПараметр("ДатаОстатков", ДатаОкончания + 1);
	Запрос.УстановитьПараметр("ВидЦены", Шапка.ВидЦены);
	Запрос.УстановитьПараметр("Валюта", ЗначениеНастроекБольничнаяАптекаПовтИсп.ПолучитьВалютуРегламентированногоУчета());
	Запрос.УстановитьПараметр("ИспользоватьИсточникиФинансирования", ПолучитьФункциональнуюОпцию("ИспользоватьИсточникиФинансирования"));
	ЗапасыСервер.УстановитьСтатусыПараметровУчетаВПараметрахЗапроса(Запрос);
	ТаблицаЦен = Запрос.Выполнить().Выгрузить();
	
	Возврат ТаблицаЦен;
	
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
	
	Отчеты.ТоварыКОформлениюИзлишковНедостач.ДобавитьКомандуОтчета(КомандыОтчетов);
	
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