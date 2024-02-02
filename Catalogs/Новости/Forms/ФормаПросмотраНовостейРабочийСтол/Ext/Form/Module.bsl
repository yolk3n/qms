﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2022, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	Если ОбработкаНовостейПовтИсп.РазрешенаРаботаСНовостямиТекущемуПользователю() <> Истина Тогда
		Отказ = Истина;
		СтандартнаяОбработка = Ложь;
		Возврат;
	КонецЕсли;

	// В конфигурации есть общие реквизиты с разделением и включена ФО РаботаВМоделиСервиса.
	Если ОбщегоНазначения.РазделениеВключено() Тогда
		// Если включено разделение данных, и мы зашли в неразделенном сеансе,
		//  то нельзя устанавливать пользовательские свойства новости.
		// Зашли в конфигурацию под пользователем без разделения (и не вошли в область данных).
		Если ИнтернетПоддержкаПользователей.СеансЗапущенБезРазделителей() Тогда
			ПолучитьТекущегоПользователя = Ложь;
		Иначе
			ПолучитьТекущегоПользователя = Истина;
		КонецЕсли;
	Иначе
		ПолучитьТекущегоПользователя = Истина;
	КонецЕсли;

	Если ПолучитьТекущегоПользователя = Истина Тогда
		ЭтотОбъект.ПараметрыСеанса_ТекущийПользователь = Пользователи.ТекущийПользователь();
	Иначе
		ЭтотОбъект.ПараметрыСеанса_ТекущийПользователь = Справочники.Пользователи.ПустаяСсылка();
	КонецЕсли;

	ТипСтруктура = Тип("Структура");

	ЭтотОбъект.РежимПросмотра = "Декорации"; // Возможные значения: Декорации, ТаблицаЗначений, ФоновоеОбновление, Листание, Автолистание.
	ЭтотОбъект.ЧастотаАвтолистания = 10; // Секунд
	ЭтотОбъект.КоличествоНовостейДляЛистанияМаксимум = 5; // Реальное количество переключателей будет подстраиваться под количество новостей (но не более этого максимума).

	СтруктураНастроекПоказаНовостей = ХранилищаНастроек.НастройкиНовостей.Загрузить(
		"НастройкиПоказаНовостей",
		"");
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, СтруктураНастроекПоказаНовостей);

	ВозвращаемыеЗначения = Неопределено;
	ОбработкаНовостейПереопределяемый.ДополнительноОбработатьФормуПросмотраНовостейДляРабочегоСтолаПриСозданииНаСервере(
		ЭтотОбъект,
		ВозвращаемыеЗначения);

	Если (ЭтотОбъект.ЧастотаАвтолистания < 5) Тогда
		ЭтотОбъект.ЧастотаАвтолистания = 5;
	КонецЕсли;
	Если ЭтотОбъект.КоличествоНовостейДляЛистанияМаксимум <= 0 Тогда
		ЭтотОбъект.КоличествоНовостейДляЛистанияМаксимум = 5; // Реальное количество переключателей будет подстраиваться под количество новостей (но не более этого максимума).
	КонецЕсли;

	ЭтотОбъект.ПропуститьЗаполнениеНовостями = Ложь;
	Если ТипЗнч(ВозвращаемыеЗначения) = ТипСтруктура Тогда
		Если (ВозвращаемыеЗначения.Свойство("ПропуститьЗаполнениеНовостями") = Истина)
				И (ВозвращаемыеЗначения.ПропуститьЗаполнениеНовостями = Истина) Тогда
			ЭтотОбъект.ПропуститьЗаполнениеНовостями = Истина;
		КонецЕсли;
	КонецЕсли;

	Если ЭтотОбъект.ПропуститьЗаполнениеНовостями <> Истина Тогда
		// Автоматически заполнить новостями и обновить форму.
		НачатьПолучениеНовостейВФонеНаСервере();
	Иначе
		// Если текст новости выводится прямо в этом окне, то заранее заполнить тексты новостей.
		ЗаполнитьТекстНовостейХТМЛ();
		// Только обновить форму - новости могут быть заполнены в переопределяемом модуле.
		УправлениеФормой();
		УстановитьУсловноеОформление();
	КонецЕсли;

	Если (ОбработкаНовостейПовтИсп.ЕстьРолиЧтенияНовостей()) Тогда
		Элементы.ГруппаНавигация.Видимость = Истина;
	Иначе
		Элементы.ГруппаНавигация.Видимость = Ложь;
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)

	// 1. Получить настройки фонового задания и получить его состояние.
	ФоновоеЗадание = ПолучитьФоновоеЗаданиеПолученияНовостей(ЭтотОбъект.СостояниеФоновогоЗаданияПолученияНовостей);

	Если ФоновоеЗадание = Неопределено Тогда // Фоновое задание уже выполнено.

		// Скрыть анимацию загрузки.
		Элементы.ГруппаДлительныеОперации.Видимость = Ложь;
		// Чтобы исключить дальнейшую обработку
		ЭтотОбъект.СостояниеФоновогоЗаданияПолученияНовостей = Неопределено;

	Иначе // Фоновое задание выполняется.

		// 2. Подключение обработчика завершения фонового задания.
		ПодключитьПроверкуЗавершенияВыполненияФоновогоЗадания(ФоновоеЗадание);

	КонецЕсли;

	Если ЭтотОбъект.ПропуститьЗаполнениеНовостями <> Истина Тогда
		Если ЭтотОбъект.СписокНовостей_ИнтервалАвтообновления < 1 Тогда
			ЭтотОбъект.СписокНовостей_ИнтервалАвтообновления = 15;
		КонецЕсли;
		ЭтотОбъект.ПодключитьОбработчикОжидания("Подключаемый_АвтообновлениеСпискаНовостей", ЭтотОбъект.СписокНовостей_ИнтервалАвтообновления * 60, Ложь);
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)

	Если ИмяСобытия = "Новости. Новость прочтена" Тогда
		// Не обновлять список новостей.

	ИначеЕсли ИмяСобытия = "Новости. Загружены новости" Тогда
		Если Источник <> ЭтотОбъект.УникальныйИдентификатор Тогда
			НачатьПолучениеНовостейВФонеНаКлиенте();
		КонецЕсли;

	ИначеЕсли ИмяСобытия = "Новости. Обновлены настройки чтения новостей" Тогда
		ПриСозданииНаСервере(Ложь, Истина);

	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ПереходКНовости(Элемент)

	ИдентификаторЭлемента = Число(Сред(Элемент.Имя, 17, 3));
	Если (ИдентификаторЭлемента > 0) И (ИдентификаторЭлемента <= ЭтотОбъект.Новости.Количество()) Тогда
		ТекущаяСтрока = ЭтотОбъект.Новости[ИдентификаторЭлемента-1];
		ПараметрыОткрытияФормы = Новый Структура;
		ПараметрыОткрытияФормы.Вставить("ИнициаторОткрытияНовости", "ФормаПросмотраНовостейРабочийСтол"); // Идентификатор.
		ПараметрыОткрытияФормы.Вставить("НовостьНаименование", ТекущаяСтрока.Наименование); // Заголовок новости.
		ПараметрыОткрытияФормы.Вставить("НовостьКодЛентыНовостей", ТекущаяСтрока.КодЛентыНовостей); // Код ленты новостей.
		ОбработкаНовостейКлиент.ПоказатьНовость(
			ТекущаяСтрока.Ссылка, // НовостьСсылка
			ПараметрыОткрытияФормы, // ПараметрыОткрытияФормы. БлокироватьОкноВладельца не нужно,
			       // т.к. неизвестно что будет за владелец и блокировать первое попавшееся окно неправильно.
			ЭтотОбъект, // ФормаВладелец
			Ложь); // Уникальность по-умолчанию (по ссылке)
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ИндексТекущейНовостиПриИзменении(Элемент)

	// Если пользователь явно нажал на кнопку выбора новости, то остановить автолистание.
	// Оно автоматически включится после обновления списка новостей.
	// Отключить автолистание.
	Если (ВРег(ЭтотОбъект.РежимПросмотра) = ВРег("Автолистание")) Тогда
		ЭтотОбъект.ОтключитьОбработчикОжидания("Подключаемый_ВыполнитьАвтолистание");
	КонецЕсли;

	// Вывести текст текущей новости.
	ЭтотОбъект.ТекстНовостиХТМЛ = ЭтотОбъект.Новости.Получить(ЭтотОбъект.ИндексТекущейНовости).ТекстНовостиХТМЛ;

КонецПроцедуры

&НаКлиенте
Процедура ТекстНовостиХТМЛПриНажатии(Элемент, ДанныеСобытия, СтандартнаяОбработка)

	// Отключить автолистание.
	Если (ВРег(ЭтотОбъект.РежимПросмотра) = ВРег("Автолистание")) Тогда
		ЭтотОбъект.ОтключитьОбработчикОжидания("Подключаемый_ВыполнитьАвтолистание");
	КонецЕсли;

	лкОбъект = ЭтотОбъект.Новости.Получить(ЭтотОбъект.ИндексТекущейНовости).Ссылка; // При открытии из формы элемента справочника / документа

	ОбработкаНовостейКлиент.ОбработкаНажатияВТекстеНовости(лкОбъект, ДанныеСобытия, СтандартнаяОбработка, ЭтотОбъект, Элемент);

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормы_Новости

&НаКлиенте
Процедура НовостиВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)

	Если ВыбраннаяСтрока <> Неопределено Тогда
		ТекущаяНовость = ЭтотОбъект.Новости.НайтиПоИдентификатору(ВыбраннаяСтрока);
		Если ТекущаяНовость <> Неопределено Тогда
			Если НЕ ТекущаяНовость.Ссылка.Пустая() Тогда
				ПараметрыОткрытияФормы = Новый Структура;
				ПараметрыОткрытияФормы.Вставить("ИнициаторОткрытияНовости", "ФормаПросмотраНовостейРабочийСтол"); // Идентификатор.
				ПараметрыОткрытияФормы.Вставить("НовостьНаименование", ТекущаяНовость.Наименование); // Заголовок новости.
				ПараметрыОткрытияФормы.Вставить("НовостьКодЛентыНовостей", ТекущаяНовость.КодЛентыНовостей); // Код ленты новостей.
				ОбработкаНовостейКлиент.ПоказатьНовость(
					ТекущаяНовость.Ссылка, // НовостьСсылка
					, // ПараметрыОткрытияФормы. БлокироватьОкноВладельца не нужно, т.к. неизвестно что будет за владелец
					       // и блокировать первое попавшееся окно неправильно.
					, // ФормаВладелец
					Ложь); // Уникальность по-умолчанию (по ссылке)
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Процедура обновляет все информационные надписи, но не устанавливает видимость групп СтраницаДекорации или СтраницаТаблицаЗначений.
//
// Параметры:
//  Нет.
//
&НаСервере
Процедура УправлениеФормой()

	Если ВРег(ЭтотОбъект.РежимПросмотра) = ВРег("Декорации") Тогда

		// Все новости делать в виде гиперссылок
		ВсегоНовостей = 3;
		Для С=1 По ВсегоНовостей Цикл
			ЭлементТекстНовости   = Элементы["ДекорацияНовость" + Формат(С, "ЧЦ=3; ЧДЦ=0; ЧН=000; ЧВН=; ЧГ=0") + "ТекстНовости"];
			ЭлементДатаПубликации = Элементы["ДекорацияНовость" + Формат(С, "ЧЦ=3; ЧДЦ=0; ЧН=000; ЧВН=; ЧГ=0") + "ДатаПубликации"];
			Если ЭтотОбъект.Новости.Количество() < С Тогда
				ЭлементТекстНовости.Видимость   = Ложь;
				ЭлементДатаПубликации.Видимость = Ложь;
			Иначе
				ЭлементТекстНовости.Видимость   = Истина;
				ЭлементДатаПубликации.Видимость = Истина;
				ЭлементТекстНовости.Заголовок   = ЭтотОбъект.Новости[С-1].Наименование;
				ЭлементДатаПубликации.Заголовок = Формат(
					МестноеВремя(ЭтотОбъект.Новости[С-1].ДатаПубликации, ЧасовойПояс()),
					ОбработкаНовостей.ФорматДатыВремениДляНовости());
			КонецЕсли;
		КонецЦикла;

		Если ЭтотОбъект.Новости.Количество() = 0 Тогда
			Элементы.ДекорацияНетНовостей.Видимость = Истина;
		Иначе
			Элементы.ДекорацияНетНовостей.Видимость = Ложь;
		КонецЕсли;

		// Переключить на страницу.
		Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.СтраницаДекорации;

	ИначеЕсли ВРег(ЭтотОбъект.РежимПросмотра) = ВРег("ТаблицаЗначений") Тогда

		// Переключить на страницу.
		Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.СтраницаТаблицаЗначений;

	ИначеЕсли ВРег(ЭтотОбъект.РежимПросмотра) = ВРег("ФоновоеОбновление") Тогда

		// Переключить на страницу.
		Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.СтраницаДекорации; ////?

	ИначеЕсли (ВРег(ЭтотОбъект.РежимПросмотра) = ВРег("Листание"))
			ИЛИ (ВРег(ЭтотОбъект.РежимПросмотра) = ВРег("Автолистание")) Тогда
		// Исправить количество новостей для листания.
		ЭтотОбъект.КоличествоНовостейДляЛистания = Мин(ЭтотОбъект.Новости.Количество(), ЭтотОбъект.КоличествоНовостейДляЛистанияМаксимум);
		// Переключить на страницу.
		Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.СтраницаЛистание;
		// Перерисовать поле переключателей.
		Элементы.ИндексТекущейНовости.СписокВыбора.Очистить();
		Для С=0 По ЭтотОбъект.КоличествоНовостейДляЛистания-1 Цикл
			Элементы.ИндексТекущейНовости.СписокВыбора.Добавить(С, " ");
		КонецЦикла;
		// Если количество новостей для листания = 1, то скрыть поле переключателей.
		Если ЭтотОбъект.КоличествоНовостейДляЛистания <= 1 Тогда
			Элементы.ГруппаИндексТекущейНовости.Видимость = Ложь;
		Иначе
			Элементы.ГруппаИндексТекущейНовости.Видимость = Истина;
		КонецЕсли;
		// Сбросить счетчик текущей новости.
		ЭтотОбъект.ИндексТекущейНовости = 0;
		// Вывести текст текущей новости.
		ЭтотОбъект.ТекстНовостиХТМЛ = ЭтотОбъект.Новости.Получить(ЭтотОбъект.ИндексТекущейНовости).ТекстНовостиХТМЛ;

	КонецЕсли;

КонецПроцедуры

// Процедура заполняет колонку "ТекстНовостиХТМЛ" табличной части "Новости".
//
// Параметры:
//  Нет.
//
&НаСервере
Процедура ЗаполнитьТекстНовостейХТМЛ()

	// Заполнить текст новостей.
	Если (ВРег(ЭтотОбъект.РежимПросмотра) = ВРег("Листание"))
			ИЛИ (ВРег(ЭтотОбъект.РежимПросмотра) = ВРег("Автолистание")) Тогда
		С = 0; // АПК:247 это счетчик.
		Для Каждого ТекущаяНовость Из ЭтотОбъект.Новости Цикл
			Если С >= ЭтотОбъект.КоличествоНовостейДляЛистанияМаксимум Тогда
				Прервать;
			КонецЕсли;
			Если ПустаяСтрока(ТекущаяНовость.ТекстНовостиХТМЛ) И (НЕ ТекущаяНовость.Ссылка.Пустая()) Тогда
				ТекущаяНовость.ТекстНовостиХТМЛ = Справочники.Новости.ПолучитьХТМЛТекстНовостей(
					ТекущаяНовость.Ссылка,
					Новый Структура("ОтображатьЗаголовок",
						Ложь));
			КонецЕсли;
			С = С + 1; // АПК:247 это счетчик.
		КонецЦикла;
	КонецЕсли;

КонецПроцедуры

// Процедура для автоматического запуска обработкой ожидания - обновляет список новостей.
// В интерфейсе не видна.
//
// Параметры:
//  Нет.
//
&НаКлиенте
Процедура Подключаемый_АвтообновлениеСпискаНовостей()

	НачатьПолучениеНовостейВФонеНаКлиенте();

КонецПроцедуры

// Процедура устанавливает условное оформление в форме.
//
// Параметры:
//  Нет.
//
&НаСервере
Процедура УстановитьУсловноеОформление()

	УсловноеОформление.Элементы.Очистить();

КонецПроцедуры

// Процедура обеспечивает автопереключение новостей.
//
// Параметры:
//  Нет.
//
&НаКлиенте
Процедура Подключаемый_ВыполнитьАвтолистание()

	// Увеличить счетчик текущей новости.
	ЭтотОбъект.ИндексТекущейНовости = ЭтотОбъект.ИндексТекущейНовости + 1;
	Если ЭтотОбъект.ИндексТекущейНовости > (ЭтотОбъект.КоличествоНовостейДляЛистания - 1) Тогда
		ЭтотОбъект.ИндексТекущейНовости = 0;
	КонецЕсли;

	// Вывести текст текущей новости.
	ЭтотОбъект.ТекстНовостиХТМЛ = ЭтотОбъект.Новости.Получить(ЭтотОбъект.ИндексТекущейНовости).ТекстНовостиХТМЛ;

КонецПроцедуры

&НаКлиенте
Процедура НачатьПолучениеНовостейВФонеНаКлиенте()

	// 1. Запустить фоновое задание и получить его состояние.
	ФоновоеЗадание = НачатьПолучениеНовостейВФонеНаСервере();

	Если ФоновоеЗадание = Неопределено Тогда // Фоновое задание уже выполнено.

		// Скрыть анимацию загрузки.
		Элементы.ГруппаДлительныеОперации.Видимость = Ложь;
		// Чтобы исключить дальнейшую обработку
		ЭтотОбъект.СостояниеФоновогоЗаданияПолученияНовостей = Неопределено;
		ЗавершитьПолучениеНовостейВФонеНаКлиенте();

	Иначе // Фоновое задание выполняется.

		// 2. Подключение обработчика завершения фонового задания.
		ПодключитьПроверкуЗавершенияВыполненияФоновогоЗадания(ФоновоеЗадание);

	КонецЕсли;

КонецПроцедуры

&НаСервере
Функция НачатьПолучениеНовостейВФонеНаСервере()

	// 1. Показать анимацию загрузки
	Элементы.ГруппаДлительныеОперацииСтраницы.ТекущаяСтраница = Элементы.СтраницаВыполнениеФоновогоЗадания;
	Элементы.КартинкаВыполнениеФоновогоЗадания.Подсказка = "";
	Элементы.ГруппаДлительныеОперации.Видимость = Истина;

	ПараметрыВыполнения = ДлительныеОперации.ПараметрыВыполненияВФоне(ЭтотОбъект.УникальныйИдентификатор);
		ПараметрыВыполнения.НаименованиеФоновогоЗадания = НСтр("ru='Получение в фоне списка новостей для формы рабочего стола'");
		ПараметрыВыполнения.ЗапуститьВФоне              = Истина;
		// Другие ключи:
		//   * ПараметрыВыполнения.ОжидатьЗавершение           = ?(ПолучитьСкоростьКлиентскогоСоединения() = СкоростьКлиентскогоСоединения.Низкая, 4, 0.8);
		//   * ПараметрыВыполнения.КлючФоновогоЗадания         = "";
		//   * ПараметрыВыполнения.БезРасширений               = Ложь;
		//   * ПараметрыВыполнения.СРасширениямиБазыДанных     = Ложь;
		//   * ПараметрыВыполнения.АдресРезультата             = Неопределено; // Отсутствует для процедуры.
		//   * ПараметрыВыполнения.ИдентификаторФормы          = ЭтотОбъект.УникальныйИдентификатор; // Уже установлен. // Отсутствует для процедуры.

	// 2. Запустить фоновое задание и получить его состояние.
	ПараметрыПолученияНовостей = Новый Структура;
		ПараметрыПолученияНовостей.Вставить("ВариантОтбора"     , 0);
		ПараметрыПолученияНовостей.Вставить("Источник"          , "ФормаПросмотраНовостейРабочийСтол");
	Если ЭтотОбъект.РежимПросмотра = "Декорации" Тогда // Возможные значения: Декорации, ТаблицаЗначений, ФоновоеОбновление, Листание, Автолистание.
		ПараметрыПолученияНовостей.Вставить("КоличествоНовостей", 3);
	ИначеЕсли ЭтотОбъект.РежимПросмотра = "ТаблицаЗначений" Тогда
		ПараметрыПолученияНовостей.Вставить("КоличествоНовостей", 100);
	ИначеЕсли ЭтотОбъект.РежимПросмотра = "ФоновоеОбновление" Тогда
		ПараметрыПолученияНовостей.Вставить("КоличествоНовостей", 3);
	ИначеЕсли ЭтотОбъект.РежимПросмотра = "Листание" Тогда
		ПараметрыПолученияНовостей.Вставить("КоличествоНовостей", ЭтотОбъект.КоличествоНовостейДляЛистанияМаксимум);
	ИначеЕсли ЭтотОбъект.РежимПросмотра = "Автолистание" Тогда
		ПараметрыПолученияНовостей.Вставить("КоличествоНовостей", ЭтотОбъект.КоличествоНовостейДляЛистанияМаксимум);
	КонецЕсли;

	ПараметрыМетода = Новый Структура;
		ПараметрыМетода.Вставить("ТаблицаНовостей"           , ЭтотОбъект.Новости.Выгрузить());
		ПараметрыМетода.Вставить("Пользователь"              , ЭтотОбъект.ПараметрыСеанса_ТекущийПользователь);
		ПараметрыМетода.Вставить("ПараметрыПолученияНовостей", ПараметрыПолученияНовостей);
		ПараметрыМетода.Вставить("ИнтерактивныеДействия"     , Новый Массив);

	ИмяМетода = "Справочники.Новости.ПолучитьСписокНовостейВФоне";
	ФоновоеЗадание = ДлительныеОперации.ВыполнитьВФоне(ИмяМетода, ПараметрыМетода, ПараметрыВыполнения);
	// ФоновоеЗадание - Структура:
	//   * Статус - Строка - "Выполняется", "Выполнено", "Ошибка", "Отменено".
	//   * ИдентификаторЗадания - УникальныйИдентификатор;
	//   * АдресРезультата - Строка;
	//   * АдресДополнительногоРезультата - Строка;
	//   * КраткоеПредставлениеОшибки   - Строка;
	//   * ПодробноеПредставлениеОшибки - Строка;
	//   * Сообщения - ФиксированныйМассив;

	// Добавим еще два индикатора.
	ФоновоеЗадание.Вставить("ТекущаяУниверсальнаяДатаВМиллисекундах", ТекущаяУниверсальнаяДатаВМиллисекундах());
	ФоновоеЗадание.Вставить("КоличествоПроверокЗавершенияОперации"  , 0);

	Если ФоновоеЗадание.Статус <> "Выполняется" Тогда // "Выполнено", "Ошибка", "Отменено"
		ЗавершитьПолучениеНовостейВФонеНаСервере(ФоновоеЗадание);
		ФоновоеЗадание = Неопределено; // Чтобы исключить дальнейшую обработку.
	КонецЕсли;

	ЭтотОбъект.СостояниеФоновогоЗаданияПолученияНовостей = ФоновоеЗадание;

	// 3. Обработчик проверки, что фоновое задание завершено, должен быть подключен на клиенте:
	//  - или явно (НачатьПолучениеНовостейВФонеНаКлиенте);
	//  - или в ПриОткрытии.

	Возврат ФоновоеЗадание;

КонецФункции

&НаКлиенте
Процедура ЗавершитьПолучениеНовостейВФонеНаКлиенте()

	// ЗавершитьПолучениеНовостейВФонеНаСервере уже установило СостояниеФоновогоЗаданияПолученияНовостей в Неопределено (если задание выполнено).

	// При создании на сервере были обнаружены интерактивные действия для клиента?
	Если ЭтотОбъект.ИнтерактивныеДействияПриОткрытии.Количество() > 0 Тогда
		ИнтерактивныеДействия = ЭтотОбъект.ИнтерактивныеДействияПриОткрытии.ВыгрузитьЗначения();
		ОбработкаНовостейКлиент.ВыполнитьИнтерактивныеДействия(ИнтерактивныеДействия);
	КонецЕсли;

	// Исправить количество новостей для листания.
	ЭтотОбъект.КоличествоНовостейДляЛистания = Мин(ЭтотОбъект.Новости.Количество(), ЭтотОбъект.КоличествоНовостейДляЛистанияМаксимум);

	// Подключить автолистание.
	Если (ВРег(ЭтотОбъект.РежимПросмотра) = ВРег("Автолистание")) Тогда
		ЭтотОбъект.ОтключитьОбработчикОжидания("Подключаемый_ВыполнитьАвтолистание");
		Если ЭтотОбъект.КоличествоНовостейДляЛистания > 1 Тогда
			ЭтотОбъект.ПодключитьОбработчикОжидания("Подключаемый_ВыполнитьАвтолистание", ЭтотОбъект.ЧастотаАвтолистания, Ложь);
		КонецЕсли;
	КонецЕсли;

КонецПроцедуры

&НаСервере
Процедура ЗавершитьПолучениеНовостейВФонеНаСервере(ФоновоеЗадание)

	Если ФоновоеЗадание = Неопределено Тогда // Фоновое задание уже выполнено.

		// Скрыть анимацию загрузки.
		Элементы.ГруппаДлительныеОперации.Видимость = Ложь;
		// Чтобы исключить дальнейшую обработку
		ЭтотОбъект.СостояниеФоновогоЗаданияПолученияНовостей = Неопределено;

	Иначе // Фоновое задание выполняется.

		Если ФоновоеЗадание.Статус = "Выполнено" Тогда
			// Загрузить данные.
			Результат = ПолучитьИзВременногоХранилища(ФоновоеЗадание.АдресРезультата);

			ЭтотОбъект.ИнтерактивныеДействияПриОткрытии.ЗагрузитьЗначения(Результат.ИнтерактивныеДействия);
			ЭтотОбъект.Новости.Загрузить(Результат.ТаблицаНовостей);
			ЭтотОбъект.Новости.Сортировать("ДатаПубликации УБЫВ");

			// Заполнить текст новостей.
			ЗаполнитьТекстНовостейХТМЛ();

			// После загрузки новостей обновить отображение быстрых фильтров.
			УправлениеФормой();

			// Скрыть анимацию загрузки.
			Элементы.ГруппаДлительныеОперации.Видимость = Ложь;

			// Т.к. форма рабочего стола не закрывается, то необходимо вручную удалять содержимое временного хранилища,
			//  чтобы не было переполнения хранилища сеансовых данных.
			УдалитьИзВременногоХранилища(ФоновоеЗадание.АдресРезультата); // Данные во временном хранилище больше не требуются.

		ИначеЕсли ФоновоеЗадание.Статус = "Ошибка" Тогда

			// Анимацию загрузки перевести на показ ошибки. Не скрывать ее.
			Элементы.ГруппаДлительныеОперацииСтраницы.ТекущаяСтраница = Элементы.СтраницаОшибкаВыполненияФоновогоЗадания;
			Элементы.КартинкаОшибкаВыполненияФоновогоЗадания.Подсказка = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru='Ошибка выполнения фонового задания получения списка новостей:
					|%1
					|
					|%2'"),
				ФоновоеЗадание.КраткоеПредставлениеОшибки,
				ФоновоеЗадание.ПодробноеПредставлениеОшибки);

		ИначеЕсли ФоновоеЗадание.Статус = "Отменено" Тогда

			// Анимацию загрузки перевести на показ ошибки. Не скрывать ее.
			Элементы.ГруппаДлительныеОперацииСтраницы.ТекущаяСтраница = Элементы.СтраницаОшибкаВыполненияФоновогоЗадания;
			Элементы.КартинкаОшибкаВыполненияФоновогоЗадания.Подсказка = НСтр("ru='Фоновое задание получения списка новостей было отменено.'");

		КонецЕсли;

		// Чтобы исключить дальнейшую обработку
		ЭтотОбъект.СостояниеФоновогоЗаданияПолученияНовостей = Неопределено;

	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ПослеПолученияНовостейВФонеНаКлиенте(ФоновоеЗадание, ДополнительныеПараметры) Экспорт

	Если ФоновоеЗадание = Неопределено Тогда // Фоновое задание уже выполнено.

		// Скрыть анимацию загрузки.
		Элементы.ГруппаДлительныеОперации.Видимость = Ложь;
		// Чтобы исключить дальнейшую обработку
		ЭтотОбъект.СостояниеФоновогоЗаданияПолученияНовостей = Неопределено;

	Иначе // Фоновое задание выполняется / выполнено / выполнено с ошибкой.

		ЗавершитьПолучениеНовостейВФонеНаСервере(ФоновоеЗадание);

	КонецЕсли;

КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция ПолучитьФоновоеЗаданиеПолученияНовостей(СостояниеФоновогоЗаданияПолученияНовостей)

	ТипСтруктура = Тип("Структура");
	Результат = Неопределено;

	Если (ТипЗнч(СостояниеФоновогоЗаданияПолученияНовостей) = ТипСтруктура)
			И (СостояниеФоновогоЗаданияПолученияНовостей.Свойство("Статус"))
			И (СостояниеФоновогоЗаданияПолученияНовостей.Свойство("ИдентификаторЗадания"))
			И (СостояниеФоновогоЗаданияПолученияНовостей.Свойство("АдресРезультата")) Тогда
		// Другие проверки не выполняем. Считаем, что в параметре уже есть все необходимые ключи.
		Результат = СостояниеФоновогоЗаданияПолученияНовостей;
	КонецЕсли;

	Возврат Результат;

КонецФункции

&НаКлиенте
Процедура ПодключитьПроверкуЗавершенияВыполненияФоновогоЗадания(ФоновоеЗадание)

	Если ФоновоеЗадание.Статус = "Выполняется" Тогда // "Выполнено", "Ошибка", "Отменено"
		// Первый раз обработчик проверки подключается без условий.
		ПараметрыОжидания = ДлительныеОперацииКлиент.ПараметрыОжидания(ЭтотОбъект);
			ПараметрыОжидания.ПолучатьРезультат    = Истина;
			ПараметрыОжидания.ВыводитьОкноОжидания = Ложь;
			ПараметрыОжидания.ТекстСообщения       = НСтр("ru='Загрузка новостей...'", ОбщегоНазначенияКлиент.КодОсновногоЯзыка());
			ПараметрыОжидания.Интервал             = 2; // 2 секунды. Быстрее стандартного интервала, т.к. выводится на начальной странице. Аналогично Обработка.ТекущиеДела.
		// Другие ключи:
		//   * ПараметрыОжидания.ФормаВладелец                  = ЭтотОбъект;
		//   * ПараметрыОжидания.ВыводитьПрогрессВыполнения     = Ложь;
		//   * ПараметрыОжидания.ОповещениеОПрогрессеВыполнения = Неопределено;
		//   * ПараметрыОжидания.ВыводитьСообщения              = Ложь;
		ДополнительныеПараметры = Неопределено;
		Оповещение = Новый ОписаниеОповещения("ПослеПолученияНовостейВФонеНаКлиенте", ЭтотОбъект, ДополнительныеПараметры);
		ДлительныеОперацииКлиент.ОжидатьЗавершение(ФоновоеЗадание, Оповещение, ПараметрыОжидания);
	КонецЕсли;

КонецПроцедуры

#КонецОбласти
