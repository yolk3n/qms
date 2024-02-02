﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2021, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	ЭтотОбъект.ЗакрыватьПриВыборе = Истина; // После вызова ОповеститьОВыборе форма автоматически закроется.

	ЭтотОбъект.КатегорияНовостей = Параметры.КатегорияНовостей;

	ЗаполнитьФормуДаннымиСервер(Параметры.СписокЗначенийОтборов);

	Если ЭтотОбъект.КатегорияНовостей.Пустая() Тогда
		ТекстСообщения = НСтр("ru='Не заполнено значение Категории новостей.
			|Настройка отбора невозможна.'");
		Сообщение = Новый СообщениеПользователю;
		Сообщение.Текст = ТекстСообщения;
		Сообщение.Сообщить();
		Отказ = Истина;
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура КомандаОК(Команда)

	Если ПроверитьЗаполнение() Тогда
		// Данные для передачи владельцу - только список значений.
		Результат = ПодготовитьСтруктуруДляВозвратаПоОК();
		ОповеститьОВыборе(Результат);
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура КомандаОтмена(Команда)

	ЭтотОбъект.Закрыть(Ложь);

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Функция ПодготовитьСтруктуруДляВозвратаПоОК()

	ТипСтрока         = Тип("Строка");
	ТипЧисло          = Тип("Число");
	ТипДата           = Тип("Дата");
	ТипБулево         = Тип("Булево");
	ТипСписокЗначений = Тип("СписокЗначений");

	// Удалить дублирующиеся значения.
	// Выгрузить значения в список.
	Список = Неопределено;
	Если ЭтотОбъект.КатегорияНовостей.ТипЗначения.Типы()[0] = ТипСтрока Тогда
		Список = ЭтотОбъект.ДоступныеЗначенияКатегории_Строка.Скопировать();
	ИначеЕсли ЭтотОбъект.КатегорияНовостей.ТипЗначения.Типы()[0] = ТипЧисло Тогда
		Список = ЭтотОбъект.ДоступныеЗначенияКатегории_Число.Скопировать();
	ИначеЕсли ЭтотОбъект.КатегорияНовостей.ТипЗначения.Типы()[0] = ТипДата Тогда
		Список = ЭтотОбъект.ДоступныеЗначенияКатегории_Дата.Скопировать();
	ИначеЕсли ЭтотОбъект.КатегорияНовостей.ТипЗначения.Типы()[0] = ТипБулево Тогда
		// Одно значение.
		Список = Новый СписокЗначений;
		Список.Добавить(ЭтотОбъект.ДоступныеЗначенияКатегории_Булево);
	ИначеЕсли ЭтотОбъект.КатегорияНовостей.ТипЗначения.Типы()[0] = Тип("СправочникСсылка.ЗначенияКатегорийНовостей") Тогда
		ЭтотОбъект.СписокИзДерева.Очистить();
		СформироватьСписокЗначенийИзДереваСПометками(ЭтотОбъект.ДоступныеЗначенияКатегории_Справочник);
		Список = ЭтотОбъект.СписокИзДерева.Скопировать();
	КонецЕсли;

	// Свернуть список значений - повторов быть не должно.
	Если ТипЗнч(Список) = ТипСписокЗначений Тогда
		БылиУдаления = Истина;
		Пока БылиУдаления = Истина Цикл
			БылиУдаления = Ложь;
			Для С1 = 0 По Список.Количество() - 1 Цикл
				Для С2 = С1 + 1 По Список.Количество() - 1 Цикл
					Если С1 <> С2 Тогда
						Если (С1 <= Список.Количество() - 1) И (С2 <= Список.Количество() - 1) Тогда
							Если Список[С1].Значение = Список[С2].Значение Тогда
								Список.Удалить(С2);
								БылиУдаления = Истина;
							КонецЕсли;
						КонецЕсли;
					КонецЕсли;
				КонецЦикла;
			КонецЦикла;
		КонецЦикла;
	КонецЕсли;

	Возврат Список;

КонецФункции

// Процедура заполняет дерево значений из справочника "ЗначенияКатегорийНовостей" для Категории.
//
// Параметры:
//  Строки                - Заполняемые строки дерева значений;
//  Родитель              - СправочникСсылка.ЗначенияКатегорийНовостей - родитель;
//  СписокЗначенийОтборов - Список значений - Список значений, по которым уже включен отбор, если включена пометка,
//                            то это глобальный отбор (настроенный администратором).
//
&НаСервереБезКонтекста
Процедура ЗаполнитьДеревоИзСправочника(Строки, Знач ЛокальныйВладелец, Знач ЛокальныйРодитель, Знач СписокЗначенийОтборов)

	Выборка = Справочники.ЗначенияКатегорийНовостей.Выбрать(ЛокальныйРодитель, ЛокальныйВладелец, , "Наименование");
	Пока Выборка.Следующий() Цикл
		НоваяСтрока = Строки.Добавить();
		НоваяСтрока.ЗначениеКатегорииНовостей = Выборка.Ссылка;
		НайденнаяСтрока = СписокЗначенийОтборов.НайтиПоЗначению(Выборка.Ссылка);
		Если НайденнаяСтрока <> Неопределено Тогда
			НоваяСтрока.Пометка = Истина;
		КонецЕсли;
		ЗаполнитьДеревоИзСправочника(
			НоваяСтрока.ПолучитьЭлементы(),
			ЛокальныйВладелец,
			Выборка.Ссылка,
			СписокЗначенийОтборов);
	КонецЦикла;

КонецПроцедуры

&НаСервере
// Процедура заполняет реквизит "СписокИзДерева" из дерева с пометками.
// 
// Параметры:
//  Дерево - Дерево значений с пометками, обязательные поля: ЗначениеКатегорииНовостей, Пометка.
//
Процедура СформироватьСписокЗначенийИзДереваСПометками(Знач Дерево)

	ЭлементыДерева = Дерево.ПолучитьЭлементы();
	Для каждого ЭлементДерева Из ЭлементыДерева Цикл
		Если ЭлементДерева.Пометка Тогда
			Если ЭтотОбъект.СписокИзДерева.НайтиПоЗначению(ЭлементДерева.ЗначениеКатегорииНовостей) = Неопределено Тогда
				ЭтотОбъект.СписокИзДерева.Добавить(
					ЭлементДерева.ЗначениеКатегорииНовостей,
					,
					ЭлементДерева.ЭтоГлобальныйОтбор);
			КонецЕсли;
		КонецЕсли;
		СформироватьСписокЗначенийИзДереваСПометками(ЭлементДерева);
	КонецЦикла;

КонецПроцедуры

// Процедура может очистить значение категории новостей, если в данной ленте новостей нет отбора по такой категории.
// Заполняет данными уже установленных ранее отборов.
// Также отображает правильную страницу на форме.
//
// Параметры:
//  СписокЗначенийОтборов - СписокЗначений - список установленных отборов.
//
&НаСервере
Процедура ЗаполнитьФормуДаннымиСервер(Знач СписокЗначенийОтборов)

	ТипСтрока = Тип("Строка");
	ТипЧисло  = Тип("Число");
	ТипДата   = Тип("Дата");
	ТипБулево = Тип("Булево");

	Если НЕ ЭтотОбъект.КатегорияНовостей.Пустая() Тогда
		Если ЭтотОбъект.КатегорияНовостей.ТипЗначения.Типы().Количество() >= 1 Тогда
			ЭтотОбъект.ТипЗначенияКатегории = ЭтотОбъект.КатегорияНовостей.ТипЗначения;
		Иначе
			ЭтотОбъект.ТипЗначенияКатегории = Новый ОписаниеТипов;
		КонецЕсли;
	Иначе
		ЭтотОбъект.ТипЗначенияКатегории = Новый ОписаниеТипов;
	КонецЕсли;

	Если ЭтотОбъект.КатегорияНовостей.Пустая() Тогда
		Элементы.ГруппаСтраницыДоступныеЗначения.ТекущаяСтраница = Элементы.СтраницаДоступныеЗначения_Пустая;
	Иначе
		Если ЭтотОбъект.КатегорияНовостей.ТипЗначения.Типы().Количество() >= 1 Тогда
			// Если тип значения - строка, тогда просто загрузить значения отборов;
			// Если тип значения - число, тогда просто загрузить значения отборов;
			// Если тип значения - дата, тогда просто загрузить значения отборов;
			// Если тип значения - булево, тогда просто загрузить значения отборов;
			// Если тип значения - справочник, тогда сгенерировать дерево значений.

			Если ЭтотОбъект.КатегорияНовостей.ТипЗначения.Типы()[0] = ТипСтрока Тогда
				// Заполнить данные из переданного списка установленных отборов.
				ЭтотОбъект.ДоступныеЗначенияКатегории_Строка.Очистить();
				Для каждого ТекущийОтбор Из СписокЗначенийОтборов Цикл
					ЭтотОбъект.ДоступныеЗначенияКатегории_Строка.Добавить(ТекущийОтбор.Значение, , ТекущийОтбор.Пометка);
				КонецЦикла;
				// Отобразить правильную закладку.
				Элементы.ГруппаСтраницыДоступныеЗначения.ТекущаяСтраница = Элементы.СтраницаДоступныеЗначения_Строка;

			ИначеЕсли ЭтотОбъект.КатегорияНовостей.ТипЗначения.Типы()[0] = ТипЧисло Тогда
				// Заполнить данные из переданного списка установленных отборов.
				ЭтотОбъект.ДоступныеЗначенияКатегории_Число.Очистить();
				Для каждого ТекущийОтбор Из СписокЗначенийОтборов Цикл
					ЭтотОбъект.ДоступныеЗначенияКатегории_Число.Добавить(ТекущийОтбор.Значение, , ТекущийОтбор.Пометка);
				КонецЦикла;
				// Отобразить правильную закладку.
				Элементы.ГруппаСтраницыДоступныеЗначения.ТекущаяСтраница = Элементы.СтраницаДоступныеЗначения_Число;

			ИначеЕсли ЭтотОбъект.КатегорияНовостей.ТипЗначения.Типы()[0] = ТипДата Тогда
				// Заполнить данные из переданного списка установленных отборов.
				ЭтотОбъект.ДоступныеЗначенияКатегории_Дата.Очистить();
				Для каждого ТекущийОтбор Из СписокЗначенийОтборов Цикл
					ЭтотОбъект.ДоступныеЗначенияКатегории_Дата.Добавить(ТекущийОтбор.Значение, , ТекущийОтбор.Пометка);
				КонецЦикла;
				// Отобразить правильную закладку.
				Элементы.ГруппаСтраницыДоступныеЗначения.ТекущаяСтраница = Элементы.СтраницаДоступныеЗначения_Дата;

			ИначеЕсли ЭтотОбъект.КатегорияНовостей.ТипЗначения.Типы()[0] = ТипБулево Тогда
				// Заполнить данные из переданного списка установленных отборов.
				// Для значений типа булева не имеет смысла в регистре сведений хранить несколько значений,
				//  поэтому прочитано будет только первое значение.
				ЭтотОбъект.ДоступныеЗначенияКатегории_Булево = Истина;
				Для каждого ТекущийОтбор Из СписокЗначенийОтборов Цикл
					ЭтотОбъект.ДоступныеЗначенияКатегории_Булево = ТекущийОтбор.Значение;
					Если ТекущийОтбор.Пометка Тогда
						Элементы.ДоступныеЗначенияКатегории_Булево.Доступность = Ложь;
					Иначе
						Элементы.ДоступныеЗначенияКатегории_Булево.Доступность = Истина;
					КонецЕсли;
					Прервать; // Прочитали первое значение - этого достаточно.
				КонецЦикла;
				// Отобразить правильную закладку.
				Элементы.ГруппаСтраницыДоступныеЗначения.ТекущаяСтраница = Элементы.СтраницаДоступныеЗначения_Булево;

			ИначеЕсли ЭтотОбъект.КатегорияНовостей.ТипЗначения.Типы()[0] = Тип("СправочникСсылка.ЗначенияКатегорийНовостей") Тогда
				// Заполнить данные из переданного списка установленных отборов - это пометки.
				// Также заполнить настроенные ранее отборы.
				ЭтотОбъект.ДоступныеЗначенияКатегории_Справочник.ПолучитьЭлементы().Очистить();
				ЗаполнитьДеревоИзСправочника(
					ЭтотОбъект.ДоступныеЗначенияКатегории_Справочник.ПолучитьЭлементы(),
					ЭтотОбъект.КатегорияНовостей,
					Справочники.ЗначенияКатегорийНовостей.ПустаяСсылка(),
					СписокЗначенийОтборов);
				// Отобразить правильную закладку.
				Элементы.ГруппаСтраницыДоступныеЗначения.ТекущаяСтраница = Элементы.СтраницаДоступныеЗначения_Справочник;

			Иначе // 
				Элементы.ГруппаСтраницыДоступныеЗначения.ТекущаяСтраница = Элементы.СтраницаДоступныеЗначения_Пустая;
			КонецЕсли;
		Иначе
			Элементы.ГруппаСтраницыДоступныеЗначения.ТекущаяСтраница = Элементы.СтраницаДоступныеЗначения_Пустая;
		КонецЕсли;
	КонецЕсли;

КонецПроцедуры

#КонецОбласти