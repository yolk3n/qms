﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Форма предназначена для поиска номенклатуры в информационной базе и сервисе 1С:Номенклатура по штрихкоду.
// Позволяет загружать найденную в сервисе номенклатуру в информационную базу.
//
// Форма является частью программного интерфейса подсистемы РаботаСНоменклатурой. 
// Допускается встраивание формы в качестве самостоятельного объекта, 
// без использования функциональности сервиса 1С:Номенклатура.
//
// Если использование формы планируется в качестве самостоятельного объекта, помимо самой формы необходимы
// следующие объекты библиотеки:
//   * ОбщийМодуль.РаботаСНоменклатуройКлиентПереопределяемый;
//   * ОбщийМодуль.РаботаСНоменклатуройПереопределяемый;
//   * ОпределяемыйТип.НоменклатураРаботаСНоменклатурой; 
//   * ОпределяемыйТип.ХарактеристикаРаботаСНоменклатурой.
//
// При использовании формы в качестве самостоятельного объекта, 
// в методе РаботаСНоменклатуройПереопределяемый.ПоискНоменклатурыПоШтрихкодуПриСозданииНаСервере 
// необходимо установить значения следующих реквизитов формы:
//   * ИспользоватьХарактеристикиНоменклатуры - Булево - признак использования характеристик.
//
// Допускается обращение к следующим реквизитам формы:
//   * ШтрихкодыНоменклатуры - таблица штрихкодов номенклатуры.
//   * ИспользоватьХарактеристикиНоменклатуры - признак использования характеристик.
//
// При открытии формы необходимо указать оповещения о закрытии формы, в которое будет передана структура с результатом работы формы.
//
// Параметры формы:
//   * НеизвестныеШтрихкоды             - Массив - Массив из Структура - коллекция штрихкодов номенклатуры, где:
//     ** Штрихкод                      - Строка - штрихкод номенклатуры.
//     ** Количество                    - Строка - количество номенклатуры.
//   * ДействияСНеизвестнымиШтрихкодами - Строка - описание действие, которое необходимо выполнить с неизвестными штрихкодами.
//                                                 Возможные значения: "ЗарегистрироватьПеренестиВДокумент", "ТолькоЗарегистрировать".
//
// Возвращаемое значение:
//  Неопределено, Структура - ключи структуры:
//   * ОтложенныеТовары - Массив - Массив из Структура. Ключи структуры: Штрихкод, Количество. Штрихкоды которые не сохранялись в базу.
//   * ЗарегистрированныеШтрихкоды - Массив из Структура. Ключи структуры: Штрихкод, Количество. Штрихкоды которые были сохранены в базу.
//   * ПолученыНовыеШтрихкоды - Массив из Структура. Ключи структуры: Штрихкод, Количество. Штрихкоды которые были сохранены в базу.
//   * НайденыНезарегистрированныеТовары - Булево - признак наличия незарегистрированных штрихкодов.
//   * ШтрихкодыНоменклатуры - Массив из Структура. Номенклатура, штрихкоды которой были сохранены в базу.
//     Ключи структуры:
//     ** Номенклатура - Ссылка - ссылка на номенклатуру.
//     ** Характеристика - Ссылка - ссылка на характеристику.
//     ** Штрихкод - Строка - штрихкод номенклатуры.
//     ** Количество - Число - количество номенклатуры.
//

#Область ОписаниеПеременных

&НаКлиенте
Перем ВыполняетсяЗакрытие;

&НаКлиенте
Перем ПроверятьТЧПередЗакрытием; //признак необходимости проверки заполненности ТЧ перед закрытием

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьУсловноеОформление();
	
	ЕстьПодсистемаРаботаСНоменклатурой = ЕстьПодсистемаРаботаСНоменклатурой();
	
	Если ЕстьПодсистемаРаботаСНоменклатурой Тогда
		ИспользоватьХарактеристикиНоменклатуры = МодульРаботаСНоменклатурой().ВедетсяУчетПоХарактеристикам();
	КонецЕсли;
	
	ИспользуетсяСервис1СНоменклатура = СервисДоступен();
	
	НастроитьФормуПриСоздании();
	
	Для Каждого СтрокаШтрихкода Из Параметры.НеизвестныеШтрихкоды Цикл
		
		НоваяСтрока = ШтрихкодыНоменклатуры.Добавить();
		
		НоваяСтрока.ПоискВСервисеНеПроизводился = Истина;
		
		ЗаполнитьЗначенияСвойств(НоваяСтрока, СтрокаШтрихкода);
		
	КонецЦикла;
				
	ДействияСНеизвестнымиШтрихкодами = Параметры.ДействияСНеизвестнымиШтрихкодами;
	
	Если ДействияСНеизвестнымиШтрихкодами = "ТолькоЗарегистрировать" Тогда
		Элементы.ЗаписатьИЗакрыть.Заголовок = НСтр("ru = 'Зарегистрировать штрихкоды'");
	Иначе
		Элементы.ЗаписатьИЗакрыть.Заголовок = НСтр("ru = 'Перенести в документ'");
	КонецЕсли;
	
	РаботаСНоменклатуройПереопределяемый.ПоискНоменклатурыПоШтрихкодуПриСозданииНаСервере(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ТекущийЭлемент = Элементы.ШтрихкодыНоменклатурыНоменклатура;
	
	ПроверятьТЧПередЗакрытием = Ложь;
	
	ПолучитьНоменклатуруПоШтрихкодам();
	
	РаботаСНоменклатуройКлиентПереопределяемый.ПоискНоменклатурыПоШтрихкодуПриОткрытии(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	
	РаботаСНоменклатуройКлиентПереопределяемый.ПоискНоменклатурыПоШтрихкодуПриЗакрытии(ЭтаФорма, ЗавершениеРаботы);
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	РаботаСНоменклатуройПереопределяемый.
		ПоискНоменклатурыПоШтрихкодуОбработкаПроверкиЗаполнения(ЭтотОбъект, Отказ, ПроверяемыеРеквизиты);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	ШтрихКоды = Новый Массив;
	
	РаботаСНоменклатуройКлиентПереопределяемый.
		ПоискНоменклатурыПоШтрихкодуОбработкаОповещения(ЭтотОбъект, ИмяСобытия, Параметр, Источник, ШтрихКоды);
		
	Если ЗначениеЗаполнено(ШтрихКоды) Тогда
		ПолучитьНоменклатуруПоШтрихкодам(ШтрихКоды);
	КонецЕсли;	
		
	Если ИмяСобытия = "РаботаСНоменклатурой_ЗагрузкаНоменклатуры" Тогда
		
		Если Параметр.СозданныеОбъекты.Количество() = 0 Тогда
			Возврат;
		КонецЕсли;
		
		СтрокиНоменклатуры = ШтрихкодыНоменклатуры.НайтиСтроки(
			Новый Структура("ИдентификаторНоменклатуры", Параметр.СозданныеОбъекты[0].ИдентификаторНоменклатуры));
		
		Для каждого ЭлементКоллекции Из СтрокиНоменклатуры Цикл
			ЭлементКоллекции.Номенклатура = Параметр.СозданныеОбъекты[0].Номенклатура;
			ЭлементКоллекции.Зарегистрирован = Истина;
		КонецЦикла;
		
	КонецЕсли;
		
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)
	
	РаботаСНоменклатуройКлиентПереопределяемый.ПоискНоменклатурыПоШтрихкодуОбработкаВыбора(ЭтотОбъект, ВыбранноеЗначение, ИсточникВыбора);
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	Если НЕ ВыполняетсяЗакрытие И Не ПроверятьТЧПередЗакрытием И НЕ ЗавершениеРаботы Тогда
		Отказ = Истина;
			
		Если ДействияСНеизвестнымиШтрихкодами = "ТолькоЗарегистрировать" Тогда
			ТекстВопроса = НСтр("ru='Штрихкоды не будут зарегистрированы.'");
		Иначе
			ТекстВопроса = НСтр("ru='Товары не будут перенесены в документ.
								|Отложите их в сторону как неотсканированные.'");
		КонецЕсли;					
		ПоказатьВопрос(Новый ОписаниеОповещения("ПередЗакрытиемЗавершение", ЭтотОбъект), ТекстВопроса, РежимДиалогаВопрос.ОКОтмена);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыШтрихкодыНоменклатуры

&НаКлиенте
Процедура ШтрихкодыНоменклатурыНоменклатураПриИзменении(Элемент)
	
	РаботаСНоменклатуройКлиентПереопределяемый.
		ПоискНоменклатурыПоШтрихкодуНоменклатураПриИзменении(ЭтаФорма, Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура ШтрихкодыНоменклатурыНоменклатураСоздание(Элемент, СтандартнаяОбработка)
	
	РаботаСНоменклатуройКлиентПереопределяемый.
		ПоискНоменклатурыПоШтрихкодуНоменклатураСоздание(ЭтаФорма, Элемент, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ШтрихкодыНоменклатурыНоменклатураНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	РаботаСНоменклатуройКлиентПереопределяемый.
		ПоискНоменклатурыПоШтрихкодуНоменклатураНачалоВыбора(ЭтаФорма, Элемент, ДанныеВыбора, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ШтрихкодыНоменклатурыХарактеристикаПриИзменении(Элемент)
	
	РаботаСНоменклатуройКлиентПереопределяемый.
		ПоискНоменклатурыПоШтрихкодуХарактеристикаПриИзменении(ЭтаФорма, Элемент);
		
КонецПроцедуры

&НаКлиенте
Процедура ШтрихкодыНоменклатурыХарактеристикаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	РаботаСНоменклатуройКлиентПереопределяемый.
		ПоискНоменклатурыПоШтрихкодуХарактеристикаНачалоВыбора(ЭтаФорма, Элемент, ДанныеВыбора, СтандартнаяОбработка);
		
КонецПроцедуры

&НаКлиенте
Процедура ШтрихкодыНоменклатурыХарактеристикаСоздание(Элемент, СтандартнаяОбработка)
	
	РаботаСНоменклатуройКлиентПереопределяемый.
		ПоискНоменклатурыПоШтрихкодуХарактеристикаСоздание(ЭтаФорма, Элемент, СтандартнаяОбработка);

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура СоздатьНоменклатуру(Команда)
	
	Если Элементы.ШтрихкодыНоменклатуры.ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ТекущиеДанные = Элементы.ШтрихкодыНоменклатуры.ТекущиеДанные;
	
	Если Не ЗначениеЗаполнено(ТекущиеДанные.ИдентификаторНоменклатуры) Тогда
		Возврат;
	КонецЕсли;
	
	ИдентификаторыНоменклатуры = ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(
		Новый Структура("ИдентификаторНоменклатуры, ИдентификаторХарактеристики", 
			ТекущиеДанные.ИдентификаторНоменклатуры, ТекущиеДанные.ИдентификаторХарактеристики));
	
	СоздатьНоменклатуруПоИдентификаторам(ИдентификаторыНоменклатуры);
	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьВсе(Команда)
	
	Если ШтрихкодыНоменклатуры.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	Идентификаторы = Новый Массив;
	
	Для каждого ЭлементКоллекции Из ШтрихкодыНоменклатуры Цикл
		Если ЗначениеЗаполнено(ЭлементКоллекции.ИдентификаторНоменклатуры) 
			И НЕ ЗначениеЗаполнено(ЭлементКоллекции.Номенклатура) Тогда
			
			Идентификаторы.Добавить(Новый Структура("ИдентификаторНоменклатуры, ИдентификаторХарактеристики", 
				ЭлементКоллекции.ИдентификаторНоменклатуры, 
				ЭлементКоллекции.ИдентификаторХарактеристики));
		КонецЕсли;
	КонецЦикла;
	
	СоздатьНоменклатуруПоИдентификаторам(Идентификаторы);
	
КонецПроцедуры

&НаКлиенте
Процедура ПеренестиВДокумент(Команда)
	
	ОчиститьСообщения();
	
	ПараметрЗакрытия = ЗарегистрироватьШтрихкодыНаСервере();
	Если ПараметрЗакрытия = Неопределено Тогда
		Возврат;
	КонецЕсли;	
		
	Если ПараметрЗакрытия.НайденыНезарегистрированныеТовары Тогда
		
		Если ДействияСНеизвестнымиШтрихкодами = "ТолькоЗарегистрировать" Тогда
			Если ИспользоватьХарактеристикиНоменклатуры Тогда
				ТекстВопроса = НСтр("ru='Не для всех новых штрихкодов указана соответствующая номенклатура и характеристика.
				|По этим позициям штрихкод не будет зарегистрирован.'");
			Иначе
				ТекстВопроса = НСтр("ru='Не для всех новых штрихкодов указана соответствующая номенклатура.
				|По этим позициям штрихкод не будет зарегистрирован.'");
			КонецЕсли;
		Иначе	
			Если ИспользоватьХарактеристикиНоменклатуры Тогда
				ТекстВопроса = НСтр("ru='Не для всех новых штрихкодов указана соответствующая номенклатура и характеристика.
				|Эти товары не будут перенесены в документ.
				|Отложите их в сторону как неотсканированные.'");
			Иначе
				ТекстВопроса = НСтр("ru='Не для всех новых штрихкодов указана соответствующая номенклатура.
				|Эти товары не будут перенесены в документ.
				|Отложите их в сторону как неотсканированные.'");
			КонецЕсли;
		КонецЕсли;
		
		РезультатВопроса = Неопределено;
		
		ПоказатьВопрос(Новый ОписаниеОповещения("ПеренестиВДокументЗавершение", ЭтотОбъект, Новый Структура("ПараметрЗакрытия", ПараметрЗакрытия)), ТекстВопроса, РежимДиалогаВопрос.ОКОтмена);
		Возврат;
		
	КонецЕсли;
	
	ПеренестиВДокументФрагмент(ПараметрЗакрытия);
	
КонецПроцедуры

&НаКлиенте
Процедура Отмена(Команда)
	
	Закрыть();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Функция ЕстьПодсистемаРаботаСНоменклатурой()
	
	УстановитьПривилегированныйРежим(Истина);
	
	ЕстьФункциональнаяОпция = Метаданные.ФункциональныеОпции.Найти("ИспользоватьСервисРаботаСНоменклатурой") <> Неопределено;
	
	СервисИспользуется = Ложь;
	
	Если ЕстьФункциональнаяОпция Тогда
		СервисИспользуется = ПолучитьФункциональнуюОпцию("ИспользоватьСервисРаботаСНоменклатурой");
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Ложь);
	
	Возврат СервисИспользуется;
	
КонецФункции

&НаСервере
Функция МодульРаботаСНоменклатурой()
	
	Возврат ОбщегоНазначения.ОбщийМодуль("РаботаСНоменклатурой");
	
КонецФункции

&НаКлиенте
Функция МодульРаботаСНоменклатуройКлиент()
	
	Возврат ОбщегоНазначенияКлиент.ОбщийМодуль("РаботаСНоменклатуройКлиент");
	
КонецФункции

&НаСервере
Процедура НастроитьФормуПриДлительнойОперации(ЭтоНачалоДлительнойОперации, Режим)
	
	Если Режим = "Поиск" Тогда
		Элементы.НадписьДлительнойОперации.Заголовок = НСтр("ru = 'Поиск номенклатуры'");
		Элементы.ЗаписатьИЗакрыть.Доступность = Истина;
	ИначеЕсли Режим = "Загрузка" Тогда	
		Элементы.НадписьДлительнойОперации.Заголовок = НСтр("ru = 'Загрузка номенклатуры'");
		Элементы.ЗаписатьИЗакрыть.Доступность = Не ЭтоНачалоДлительнойОперации;
	КонецЕсли;
		
	Элементы.ГруппаДекорацииДлительнойОперации.Видимость = ЭтоНачалоДлительнойОперации;
	Элементы.ГруппаКнопокСоздания.Доступность            = Не ЭтоНачалоДлительнойОперации;
		
КонецПроцедуры

&НаСервере
Функция СервисДоступен()
	
	Если ЕстьПодсистемаРаботаСНоменклатурой Тогда
		
		ОбщийМодульИнтернетПоддержкаПользователей = ОбщегоНазначения.ОбщийМодуль("ИнтернетПоддержкаПользователей");
		
		Результат = МодульРаботаСНоменклатурой().ДоступнаФункциональностьПодсистемы()
			И ОбщийМодульИнтернетПоддержкаПользователей.ЗаполненыДанныеАутентификацииПользователяИнтернетПоддержки();
	Иначе
		Результат = Ложь;
	КонецЕсли;
		
	Возврат Результат;
		
КонецФункции

&НаКлиенте
Процедура ПеренестиВДокументФрагмент(Знач ПараметрЗакрытия)
	
	ПроверятьТЧПередЗакрытием = Истина;
	
	Если ТипЗнч(ВладелецФормы) = Тип("ФормаКлиентскогоПриложения") Тогда
		ПараметрЗакрытия.Вставить("ФормаВладелец", ВладелецФормы.УникальныйИдентификатор);
	КонецЕсли;
	
	Закрыть(ПараметрЗакрытия);
	
	Оповестить("НеизвестныеШтрихкоды", ПараметрЗакрытия, "ПодключаемоеОборудование");

КонецПроцедуры

&НаСервере
Функция ЗарегистрироватьШтрихкодыНаСервере()
	
	Если Не ПроверитьЗаполнение() Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Отказ = Ложь;
	
	ЗарегистрироватьШтрихкодыНаСервереПродолжение(Отказ);
	
	Если Отказ Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	НайденыНезарегистрированныеТовары = ШтрихкодыНоменклатуры.НайтиСтроки(Новый Структура("Зарегистрирован, ЗарегистрированОбработкой", Ложь, Ложь));
	
	ЗарегистрированныеШтрихкоды = Новый Массив;
	НайденныеЗарегистрированныеШтрихкоды = ШтрихкодыНоменклатуры.НайтиСтроки(Новый Структура("ЗарегистрированОбработкой", Истина));
	Для Каждого СтрокаШтрихкода Из НайденныеЗарегистрированныеШтрихкоды Цикл
		ЗарегистрированныеШтрихкоды.Добавить(Новый Структура("Штрихкод, Количество", СтрокаШтрихкода.Штрихкод, СтрокаШтрихкода.Количество));
	КонецЦикла;
	
	ОтложенныеТовары = Новый Массив;
	НайденныеОтложенныеТовары = ШтрихкодыНоменклатуры.НайтиСтроки(Новый Структура("Зарегистрирован, ЗарегистрированОбработкой", Ложь, Ложь));
	Для Каждого СтрокаШтрихкода Из НайденныеОтложенныеТовары Цикл
		ОтложенныеТовары.Добавить(Новый Структура("Штрихкод, Количество", СтрокаШтрихкода.Штрихкод, СтрокаШтрихкода.Количество));
	КонецЦикла;
	
	ПолученыНовыеШтрихкоды = Новый Массив;
	НайденныеПолученныеШтрихкоды = ШтрихкодыНоменклатуры.НайтиСтроки(Новый Структура("Зарегистрирован", Истина));
	Для Каждого СтрокаШтрихкода Из НайденныеПолученныеШтрихкоды Цикл
		ПолученыНовыеШтрихкоды.Добавить(Новый Структура("Штрихкод, Количество", СтрокаШтрихкода.Штрихкод, СтрокаШтрихкода.Количество));
	КонецЦикла;
	
	ПараметрЗакрытия = Новый Структура();
	
	ПараметрЗакрытия.Вставить("ОтложенныеТовары",                  ОтложенныеТовары);
	ПараметрЗакрытия.Вставить("ЗарегистрированныеШтрихкоды",       ЗарегистрированныеШтрихкоды);
	ПараметрЗакрытия.Вставить("ПолученыНовыеШтрихкоды",            ПолученыНовыеШтрихкоды);
	ПараметрЗакрытия.Вставить("НайденыНезарегистрированныеТовары", НайденыНезарегистрированныеТовары.Количество() > 0);
	ПараметрЗакрытия.Вставить("ШтрихкодыНоменклатуры",             ДанныеПоШтрихкодам());
	
	Возврат ПараметрЗакрытия;
			
КонецФункции

&НаСервере
Функция ДанныеПоШтрихкодам()
	
	Штрихкоды = Новый Массив;
	
	Для каждого ЭлементКоллекции Из ШтрихкодыНоменклатуры Цикл
		Если ЗначениеЗаполнено(ЭлементКоллекции.Номенклатура)
			И ЗначениеЗаполнено(ЭлементКоллекции.Штрихкод) Тогда
			
			ДанныеПоШтрихкоды = Новый Структура;
			
			ДанныеПоШтрихкоды.Вставить("Номенклатура",   Неопределено);
			ДанныеПоШтрихкоды.Вставить("Характеристика", Неопределено);
			ДанныеПоШтрихкоды.Вставить("Штрихкод",       "");
			ДанныеПоШтрихкоды.Вставить("Количество",     0);
						
			ЗаполнитьЗначенияСвойств(ДанныеПоШтрихкоды, ЭлементКоллекции);
			
			Штрихкоды.Добавить(ДанныеПоШтрихкоды);
		КонецЕсли;
	КонецЦикла;
	
	Возврат Штрихкоды;	
	
КонецФункции

&НаСервере
Процедура ЗарегистрироватьШтрихкодыНаСервереПродолжение(Отказ)
	
	ШтрихкодыДляОтработки = ШтрихкодыНоменклатуры.Выгрузить().СкопироватьКолонки();
	СтрокиДляОтработки    = Новый Массив;
	
	Для каждого СтрокаШтрихкода Из ШтрихкодыНоменклатуры Цикл
		
		Если СтрокаШтрихкода.Зарегистрирован ИЛИ Не ЗначениеЗаполнено(СтрокаШтрихкода.Номенклатура)
			ИЛИ (СтрокаШтрихкода.ХарактеристикиИспользуются И Не ЗначениеЗаполнено(СтрокаШтрихкода.Характеристика))Тогда
			
			Продолжить;
		КонецЕсли;
		
		ЗаполнитьЗначенияСвойств(ШтрихкодыДляОтработки.Добавить(), СтрокаШтрихкода);
		
		СтрокиДляОтработки.Добавить(СтрокаШтрихкода);
		
	КонецЦикла;
	
	Если ШтрихкодыДляОтработки.Количество() > 0 Тогда
		
		НачатьТранзакцию();
		
		Попытка
			РаботаСНоменклатуройПереопределяемый.ЗарегистрироватьШтрихкоды(ШтрихкодыДляОтработки);
			ЗафиксироватьТранзакцию();
		Исключение
			
			ОтменитьТранзакцию();
			
			ОписаниеОшибки = НСтр("ru = 'При записи штрихкодов произошла ошибка.
				|Дополнительное описание:
				|%ДополнительноеОписание%'");
			ОбщегоНазначения.СообщитьПользователю(
			СтрЗаменить(ОписаниеОшибки, "%ДополнительноеОписание%", ИнформацияОбОшибке().Описание));
			
			Отказ = Истина;
			
		КонецПопытки;
		
		Для каждого ЭлементКоллекции Из СтрокиДляОтработки Цикл
			ЭлементКоллекции.ЗарегистрированОбработкой = Истина;	
		КонецЦикла;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПолучитьНоменклатуруПоШтрихкодам(ШтрихКоды = Неопределено)
	
	ПолучитьНоменклатуруПоШтрихкодамВТекущейБазе(ШтрихКоды);
	
	Если ШтрихКоды.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	Если ИспользуетсяСервис1СНоменклатура Тогда
		ПолучитьНоменклатуруПоШтрихкодамВСервисе(ШтрихКоды);
	КонецЕсли;
		
КонецПроцедуры

&НаКлиенте
Процедура ПолучитьНоменклатуруПоШтрихкодамВСервисе(ШтрихКоды)
	
	НастроитьФормуПриДлительнойОперации(Истина, "Поиск");
	
	ПараметрыЗавершения = Новый Структура;
	
	СоздатьНоменклатуруПродолжение = Новый ОписаниеОповещения("ПолучитьНоменклатуруПоШтрихкодамЗавершение",
		ЭтотОбъект, ПараметрыЗавершения);
	
	МодульРаботаСНоменклатуройКлиент().ПолучитьНоменклатуруПоШтрихкодам(
		СоздатьНоменклатуруПродолжение, 
		ШтрихКоды, 
		ЭтотОбъект, 
		ИдентификаторЗадания, 
		Элементы.ГруппаДекорацииДлительнойОперации);	
	
КонецПроцедуры
	
&НаКлиенте
Процедура ПолучитьНоменклатуруПоШтрихкодамЗавершение(Результат, ДополнительныеПараметры) Экспорт 
	
	РазобратьРезультатПоискаПоШтрихкоду(Результат);

КонецПроцедуры

&НаСервере
Процедура РазобратьРезультатПоискаПоШтрихкоду(Результат)
	
	НастроитьФормуПриДлительнойОперации(Ложь, "Поиск");	
	
	Если Не ЭтоАдресВременногоХранилища(Результат.АдресРезультата) Тогда
		Возврат;
	КонецЕсли;
	
	ДанныеПоШтрихкодам = ПолучитьИзВременногоХранилища(Результат.АдресРезультата);
	УдалитьИзВременногоХранилища(Результат.АдресРезультата);
	
	Если ТипЗнч(ДанныеПоШтрихкодам) <> Тип("ТаблицаЗначений") Тогда
		Возврат;
	КонецЕсли;
	
	ШтрихкодыСервиса = МодульРаботаСНоменклатурой().РазвернутыеДанныеПоШтрихкодам(ДанныеПоШтрихкодам);
	
	Для каждого ЭлементКоллекции Из ШтрихкодыНоменклатуры Цикл
		
		Если ЗначениеЗаполнено(ЭлементКоллекции.ИдентификаторНоменклатуры) Тогда
			Продолжить;
		КонецЕсли;
		
		ЭлементКоллекции.ПоискВСервисеНеПроизводился = Ложь;
		
		СтрокиПоШтрихкоду = ШтрихкодыСервиса.НайтиСтроки(Новый Структура("Штрихкод", ЭлементКоллекции.Штрихкод));
		
		Если СтрокиПоШтрихкоду.Количество() = 0 Тогда
			ЭлементКоллекции.НоменклатураНеНайденаВСервисе = Истина;
			Продолжить;
		КонецЕсли;
		
		ЭлементКоллекции.НоменклатураНеНайденаВСервисе = Ложь;	
		
		СтрокаДанных = СтрокиПоШтрихкоду[0];
		
		ЭлементКоллекции.НоменклатураСервиса         = СтрокаДанных.НаименованиеНоменклатурыПолное;
		ЭлементКоллекции.ИдентификаторНоменклатуры   = СтрокаДанных.ИдентификаторНоменклатуры;
		ЭлементКоллекции.ИдентификаторХарактеристики = СтрокаДанных.ИдентификаторХарактеристики;
		ЭлементКоллекции.Количество                  = 1;
		
	КонецЦикла;
	
	ИзменитьДоступностьКнопкиЗагрузитьВсе();
	
КонецПроцедуры
	
&НаСервере
Процедура ПолучитьНоменклатуруПоШтрихкодамВТекущейБазе(ШтрихКоды = Неопределено)
	
	Если ШтрихКоды = Неопределено Тогда
		ШтрихКоды = ШтрихкодыНоменклатуры.Выгрузить().ВыгрузитьКолонку("Штрихкод");
	Иначе
		НайтиШтрихкодыСредиДобавленных(ШтрихКоды);
	КонецЕсли;
	
	Если ШтрихКоды.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	ДанныеПоШтрихкодам = Новый ТаблицаЗначений;
	
	РаботаСНоменклатуройПереопределяемый.ПолучитьНоменклатуруПоШтрихкодам(ШтрихКоды, ДанныеПоШтрихкодам);
	
	Если ДанныеПоШтрихкодам.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	Для каждого ЭлементКоллекции Из ДанныеПоШтрихкодам Цикл
		
		СтрокиПоШтрихкоду = ШтрихкодыНоменклатуры.НайтиСтроки(Новый Структура("Штрихкод", ЭлементКоллекции.Штрихкод));
		
		Если СтрокиПоШтрихкоду.Количество() <> 0 Тогда
			
			ТекущаяСтрока = СтрокиПоШтрихкоду[0];
			
			ТекущаяСтрока.Номенклатура                = ЭлементКоллекции.Номенклатура;
			ТекущаяСтрока.ЕдиницаИзмерения            = ЭлементКоллекции.ЕдиницаИзмерения;
			ТекущаяСтрока.Характеристика              = ЭлементКоллекции.Характеристика;
			ТекущаяСтрока.Зарегистрирован             = Истина;
			ТекущаяСтрока.ПоискВСервисеНеПроизводился = Истина;
			ТекущаяСтрока.Количество                  = 1;
			
			ОбщегоНазначенияКлиентСервер.УдалитьЗначениеИзМассива(ШтрихКоды, ЭлементКоллекции.Штрихкод);
			
		КонецЕсли;
	КонецЦикла;
		
КонецПроцедуры

&НаСервере
Процедура НайтиШтрихкодыСредиДобавленных(ШтрихКоды)
	
	НайденныеШтрихкоды = Новый Массив;
	
	Для каждого ЭлементКоллекции Из ШтрихКоды Цикл
		
		СтрокиШтрихкодов = ШтрихкодыНоменклатуры.НайтиСтроки(Новый Структура("Штрихкод", ЭлементКоллекции));
		
		Если СтрокиШтрихкодов.Количество() > 0 Тогда
			Для каждого ЭлементКоллекции Из СтрокиШтрихкодов Цикл
				ЭлементКоллекции.Количество = ЭлементКоллекции.Количество + 1;
			КонецЦикла;
			
			НайденныеШтрихкоды.Добавить(ЭлементКоллекции);
		КонецЕсли;
	КонецЦикла;	
	
	Для каждого ЭлементКоллекции Из НайденныеШтрихкоды Цикл
		ОбщегоНазначенияКлиентСервер.УдалитьЗначениеИзМассива(ШтрихКоды, ЭлементКоллекции);
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура НастроитьФормуПриСоздании()
	
	Если Не ИспользуетсяСервис1СНоменклатура Тогда
		Элементы.ПояснениеКФорме.Заголовок = 
			НСтр("ru = 'Отсканируйте штрихкод товара для поиска номенклатуры и последующего переноса ее в документ.'")
	КонецЕсли;
	
	Элементы.ГруппаДекорацииДлительнойОперации.Видимость        = ИспользуетсяСервис1СНоменклатура;
	Элементы.ШтрихкодыНоменклатурыНоменклатураСервиса.Видимость = ИспользуетсяСервис1СНоменклатура;
	
	Если ИспользуетсяСервис1СНоменклатура Тогда
		
		ПравоИзмененияДанных = МодульРаботаСНоменклатурой().ПравоИзмененияДанных();
		
		Элементы.ГруппаКнопокСоздания.Видимость = ПравоИзмененияДанных;
		Элементы.СоздатьВсе.Видимость           = ПравоИзмененияДанных И МодульРаботаСНоменклатурой().РазрешеноПакетноеСозданиеНоменклатуры();
		
	Иначе
 		Элементы.ГруппаКнопокСоздания.Видимость = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьУсловноеОформление()

	УсловноеОформление.Элементы.Очистить();
	
	////////////////////////////////////////////////////////////////////////////////
	
	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ШтрихкодыНоменклатурыХарактеристика.Имя);

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ШтрихкодыНоменклатуры.ХарактеристикиИспользуются");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Ложь;

	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ТекстЗапрещеннойЯчейкиЦвет);
	Элемент.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru = '<характеристики не используются>'"));
	Элемент.Оформление.УстановитьЗначениеПараметра("ТолькоПросмотр", Истина);
	Элемент.Оформление.УстановитьЗначениеПараметра("ОтметкаНезаполненного", Ложь);
	
	////////////////////////////////////////////////////////////////////////////////
	
	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ШтрихкодыНоменклатурыНоменклатураСервиса.Имя);

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ШтрихкодыНоменклатуры.НоменклатураНеНайденаВСервисе");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Истина;

	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ТекстЗапрещеннойЯчейкиЦвет);
	Элемент.Оформление.УстановитьЗначениеПараметра("ТолькоПросмотр", Истина);
	Элемент.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru = '<номенклатура не найдена>'"));
		
	////////////////////////////////////////////////////////////////////////////////
	
	Элемент = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ШтрихкодыНоменклатурыНоменклатураСервиса.Имя);
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ШтрихкодыНоменклатуры.ПоискВСервисеНеПроизводился");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Истина;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ТекстЗапрещеннойЯчейкиЦвет);
	Элемент.Оформление.УстановитьЗначениеПараметра("ТолькоПросмотр", Истина);
	Элемент.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru = '<поиск не производился>'"));
	
	////////////////////////////////////////////////////////////////////////////////
	
	Элемент = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ШтрихкодыНоменклатурыШтрихкод.Имя);
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ШтрихкодыНоменклатуры.Номенклатура");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Заполнено;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("ТолькоПросмотр", Истина);
	
	////////////////////////////////////////////////////////////////////////////////
	
	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ШтрихкодыНоменклатурыСостояние.Имя);

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ШтрихкодыНоменклатуры.Зарегистрирован");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Ложь;

	Элемент.Оформление.УстановитьЗначениеПараметра("Шрифт", Метаданные.ЭлементыСтиля.ВажнаяНадписьШрифт.Значение);
	Элемент.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru = 'Новый'"));

	////////////////////////////////////////////////////////////////////////////////
	
	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ШтрихкодыНоменклатурыСостояние.Имя);

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ШтрихкодыНоменклатуры.Зарегистрирован");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Истина;

	Элемент.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru = 'Зарегистрирован'"));

КонецПроцедуры

&НаКлиенте
Процедура СоздатьНоменклатуруПоИдентификаторам(ИдентификаторыНоменклатуры)
	
	НастроитьФормуПриДлительнойОперации(Истина, "Загрузка");	
	
	ПараметрыЗавершения = Новый Структура;
	ПараметрыЗавершения.Вставить("ИдентификаторЗадания", Неопределено);
	
	СоздатьНоменклатуруПродолжение = Новый ОписаниеОповещения("СоздатьНоменклатуруПродолжение",
		ЭтотОбъект, ПараметрыЗавершения);
	
	МодульРаботаСНоменклатуройКлиент().ЗагрузитьНоменклатуруИХарактеристики(
		СоздатьНоменклатуруПродолжение, 
		ИдентификаторыНоменклатуры, 
		ЭтотОбъект, 
		Неопределено,
		Неопределено,
		Элементы.ГруппаДекорацииДлительнойОперации);
	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьНоменклатуруПродолжение(Результат, ДополнительныеПараметры) Экспорт 
	
	НастроитьФормуПриДлительнойОперации(Ложь, "Загрузка");
	
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
		
	ЗаполнитьНоменклатуру(Результат.НовыеЭлементы);
	
	ИзменитьДоступностьКнопкиЗагрузки();
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьНоменклатуру(СозданнаяНоменклатура)
	
	Для каждого ЭлементКоллекции Из СозданнаяНоменклатура Цикл
		
		СтрокиИдентификатору = ШтрихкодыНоменклатуры.НайтиСтроки(
			Новый Структура("ИдентификаторНоменклатуры, ИдентификаторХарактеристики", 
				ЭлементКоллекции.ИдентификаторНоменклатуры, ЭлементКоллекции.ИдентификаторХарактеристики));
		
		Для каждого Штрихкод Из СтрокиИдентификатору Цикл
			
			Штрихкод.Номенклатура = ЭлементКоллекции.Номенклатура;
			Штрихкод.Характеристика = ЭлементКоллекции.Характеристика;
			
			Если ЗначениеЗаполнено(Штрихкод.Характеристика) Тогда
				Штрихкод.ХарактеристикиИспользуются = Истина;
			КонецЕсли;
			
			Штрихкод.Зарегистрирован = Истина;
			
			РаботаСНоменклатуройПереопределяемый.
				ПоискНоменклатурыПоШтрихкодуПослеЗагрузкиНоменклатуры(Штрихкод, ЭлементКоллекции.Номенклатура);
			
		КонецЦикла;
	
	КонецЦикла;
	
	ИзменитьДоступностьКнопкиЗагрузитьВсе();
	
КонецПроцедуры

&НаКлиенте
Процедура ШтрихкодыНоменклатурыНоменклатураСервисаОткрытие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Если Элементы.ШтрихкодыНоменклатуры.ТекущиеДанные <> Неопределено
		И ЗначениеЗаполнено(Элементы.ШтрихкодыНоменклатуры.ТекущиеДанные.ИдентификаторНоменклатуры) Тогда
		
		МодульРаботаСНоменклатуройКлиент().ОткрытьФормуКарточкиНоменклатуры(
			ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(
				Элементы.ШтрихкодыНоменклатуры.ТекущиеДанные.ИдентификаторНоменклатуры),
			ЭтотОбъект);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытиемЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
	
	Если РезультатВопроса = КодВозвратаДиалога.ОК Тогда
		ПроверятьТЧПередЗакрытием = Истина;
		ВыполняетсяЗакрытие = Истина;
		Закрыть();
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ПеренестиВДокументЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
	
	ПараметрЗакрытия = ДополнительныеПараметры.ПараметрЗакрытия;
	
	Если РезультатВопроса = КодВозвратаДиалога.Отмена Тогда
		Возврат;
	КонецЕсли;
	
	ПеренестиВДокументФрагмент(ПараметрЗакрытия);

КонецПроцедуры

&НаКлиенте
Процедура ШтрихкодыНоменклатурыПриАктивизацииСтроки(Элемент)
	
	ИзменитьДоступностьКнопкиЗагрузки();
		
КонецПроцедуры

&НаКлиенте
Процедура ИзменитьДоступностьКнопкиЗагрузки()
			
	ТекущиеДанные = Элементы.ШтрихкодыНоменклатуры.ТекущиеДанные;
	
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли; 
	
	Элементы.СоздатьНоменклатуру.Доступность = 
		ЗначениеЗаполнено(ТекущиеДанные.НоменклатураСервиса) 
			И НЕ ЗначениеЗаполнено(ТекущиеДанные.Номенклатура)
				И НЕ Элементы.ГруппаДекорацииДлительнойОперации.Видимость;

КонецПроцедуры

&НаСервере
Процедура ИзменитьДоступностьКнопкиЗагрузитьВсе()
	
	ЕстьНоменклатураКСозданию = Ложь;
	
	Для каждого ЭлементКоллекции Из ШтрихкодыНоменклатуры Цикл
		Если Не ЗначениеЗаполнено(ЭлементКоллекции.Номенклатура)
			И ЗначениеЗаполнено(ЭлементКоллекции.НоменклатураСервиса) Тогда
			
			ЕстьНоменклатураКСозданию = Истина;
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
	Элементы.СоздатьВсе.Доступность = ЕстьНоменклатураКСозданию 
		И Не Элементы.ГруппаДекорацииДлительнойОперации.Видимость;
		
КонецПроцедуры

#КонецОбласти

#Область Инициализация

ВыполняетсяЗакрытие = Ложь;

#КонецОбласти
