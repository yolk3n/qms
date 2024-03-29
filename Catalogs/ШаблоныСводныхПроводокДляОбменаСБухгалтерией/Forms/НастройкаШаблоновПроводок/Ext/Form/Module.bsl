﻿
////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьУсловноеОформление();
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	ЗаполнитьСписокПлановОбмена();
	
	Справочники.НастройкиХозяйственныхОпераций.ДобавитьОтборКомпоновкиПоДоступнымОперациям(ХозяйственныеОперации.Отбор);
	
	НастройкаОтраженияВБухгалтерскомУчете = Параметры.НастройкаОтраженияВБухгалтерскомУчете;
	
	УстановитьОтборШаблоновПроводок();
	УстановитьОтборПоПлануОбмена();
	УстановитьОтборПоНастройкеОтражения();
	
КонецПроцедуры

&НаСервере
Процедура ПередЗагрузкойДанныхИзНастроекНаСервере(Настройки)
	
	Если ЗначениеЗаполнено(НастройкаОтраженияВБухгалтерскомУчете) Тогда
		Настройки.Очистить();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриЗагрузкеДанныхИзНастроекНаСервере(Настройки)
	
	Если ЗначениеЗаполнено(Настройки.Получить("НастройкаОтраженияВБухгалтерскомУчете")) Тогда
		УстановитьОтборПоНастройкеОтражения();
	ИначеЕсли ЗначениеЗаполнено(Настройки.Получить("ПланОбмена")) Тогда
		УстановитьОтборПоПлануОбмена();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "ЗаписанШаблонПроводки" Тогда
		Элементы.ХозяйственныеОперации.Обновить();
	КонецЕсли;
	
	Если ИмяСобытия = "ИзмененыНастройкиИспользованияВБухгалтерскомУчете" Тогда
		ОповеститьОбИзменении(Тип("СправочникСсылка.ШаблоныСводныхПроводокДляОбменаСБухгалтерией"));
		Элементы.ХозяйственныеОперации.Обновить();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти // ОбработчикиСобытийФормы

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ
#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура СоздатьШаблонПроводки(Команда)
	
	Если Не ВозможноСоздатьШаблонПроводки() Тогда
		Возврат;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(ПланОбмена) Тогда
		ОбщегоНазначенияКлиент.СообщитьПользователю(НСтр("ru = 'Не заполнено поле ""План обмена""'"),,, "ПланОбмена");
		Возврат;
	КонецЕсли;
	
	ДополнительныеПараметрыСоздания = Новый Структура;
	ДополнительныеПараметрыСоздания.Вставить("ЭтоГруппаШаблонов", Ложь);
	Элементы.ШаблоныПроводок.ДополнительныеПараметрыСоздания = Новый ФиксированнаяСтруктура(ДополнительныеПараметрыСоздания);
	
	Элементы.ШаблоныПроводок.ДобавитьСтроку();
	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьГруппуШаблоновПроводок(Команда)
	
	Если Не ВозможноСоздатьШаблонПроводки() Тогда
		Возврат;
	КонецЕсли;
	
	ДополнительныеПараметрыСоздания = Новый Структура;
	ДополнительныеПараметрыСоздания.Вставить("ЭтоГруппаШаблонов", Истина);
	Элементы.ШаблоныПроводок.ДополнительныеПараметрыСоздания = Новый ФиксированнаяСтруктура(ДополнительныеПараметрыСоздания);
	
	Элементы.ШаблоныПроводок.ДобавитьСтроку();
	
КонецПроцедуры

&НаКлиенте
Процедура ВключитьВНастройкуОтражения(Команда)
	
	ОтразитьВНастройке(Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ИсключитьИзНастройкиОтражения(Команда)
	
	ОтразитьВНастройке(Ложь);
	
КонецПроцедуры

&НаКлиенте
Процедура ПоменятьОперациюШаблонаПроводки(Команда)
	
	Если ТекущаяСтрокаНедоступна(Элементы.ШаблоныПроводок.ТекущаяСтрока) Тогда
		Возврат;
	КонецЕсли;
	
	ЗаголовокВопроса = НСтр("ru = 'Изменение шаблонов проводок'");
	
	ТекстВопроса = НСтр("ru = 'Изменение операции шаблона проводок может привести к потере работоспособности установленных настроек счетов
		|и дополнительных отборов.'");
	Если Элементы.ШаблоныПроводок.ТекущиеДанные.ЭтоГруппаШаблонов Тогда
		ТекстВопроса = ТекстВопроса + Символы.ПС + НСтр("ru = 'Изменение будет выполнено для всех подчиненных элементов.'");
	КонецЕсли;
	ТекстВопроса = ТекстВопроса  + Символы.ПС + НСтр("ru = 'Продолжить?'");
	
	Кнопки = Новый СписокЗначений;
	Кнопки.Добавить(КодВозвратаДиалога.ОК    , НСтр("ru = 'Продолжить'"));
	Кнопки.Добавить(КодВозвратаДиалога.Отмена, НСтр("ru = 'Отмена'"));
	
	Оповестить = Новый ОписаниеОповещения("ПоменятьОперациюШаблонаПроводкиПослеПодтверждения", ЭтотОбъект);
	ПоказатьВопрос(Оповестить, ТекстВопроса, Кнопки,, КодВозвратаДиалога.ОК, ЗаголовокВопроса);
	
КонецПроцедуры

&НаКлиенте
Процедура ПеренестиШаблонПроводки(Команда)
	
	ТекущаяСтрока = Элементы.ХозяйственныеОперации.ТекущаяСтрока;
	Если ТекущаяСтрокаНедоступна(ТекущаяСтрока)
	 Или ТекущаяСтрокаНедоступна(Элементы.ШаблоныПроводок.ТекущаяСтрока) Тогда
		Возврат;
	КонецЕсли;
	
	Отбор = Новый Структура;
	Отбор.Вставить("Операция"         , ТекущаяСтрока);
	Отбор.Вставить("ПланОбмена"       , ПланОбмена);
	Отбор.Вставить("ЭтоГруппаШаблонов", Истина);
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Отбор"              , Отбор);
	ПараметрыФормы.Вставить("РазрешитьВыборКорня", Истина);
	
	Оповестить = Новый ОписаниеОповещения("ПоменятьРодителяШаблонаПроводки", ЭтотОбъект);
	ОткрытьФорму("Справочник.ШаблоныСводныхПроводокДляОбменаСБухгалтерией.ФормаВыбора", ПараметрыФормы,,,,, Оповестить);
	
КонецПроцедуры

#КонецОбласти // ОбработчикиКомандФормы

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ФОРМЫ
#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура ПланОбменаПриИзменении(Элемент)
	
	УстановитьОтборПоПлануОбмена();
	
КонецПроцедуры

&НаКлиенте
Процедура НастройкаОтраженияВБухгалтерскомУчетеПриИзменении(Элемент)
	
	УстановитьОтборПоНастройкеОтражения();
	
КонецПроцедуры

&НаКлиенте
Процедура ХозяйственныеОперацииПриАктивизацииСтроки(Элемент)
	
	ПодключитьОбработчикОжидания("ОбработчикХозяйственныеОперацииПриАктивизацииСтроки", 0.2, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ШаблоныПроводокПриАктивизацииСтроки(Элемент)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

&НаКлиенте
Процедура ШаблоныПроводокПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	
	ТекущиеДанные = Элемент.ТекущиеДанные;
	Если Копирование И ТекущиеДанные.ЭтоГруппаШаблонов Тогда
		
		Отказ = Истина;
		
		ЗаголовокВопроса = НСтр("ru = 'Копирование шаблонов проводок'");
		ТекстВопроса     = НСтр("ru = 'Скопировать только текущий элемент или вместе с подчиненными?'");
		
		Кнопки = Новый СписокЗначений;
		Кнопки.Добавить("СкопироватьТекущийЭлемент", НСтр("ru = 'Скопировать'"));
		Кнопки.Добавить("СкопироватьСПодчиненными" , НСтр("ru = 'Скопировать с подчиненными'"));
		Кнопки.Добавить(КодВозвратаДиалога.Отмена, НСтр("ru = 'Отмена'"));
		
		Оповестить = Новый ОписаниеОповещения("СкопироватьГруппуШаблоновПроводок", ЭтотОбъект, ТекущиеДанные.Ссылка);
		ПоказатьВопрос(Оповестить, ТекстВопроса, Кнопки,, Кнопки[0].Значение, ЗаголовокВопроса);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ШаблоныПроводокПроверкаПеретаскивания(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка, Строка, Поле)
	
	Если ТекущаяСтрокаНедоступна(Строка, Ложь) Тогда
		ПараметрыПеретаскивания.Действие = ДействиеПеретаскивания.Отмена;
		Возврат;
	КонецЕсли;
	
	Для Каждого ИсточникДанных Из ПараметрыПеретаскивания.Значение Цикл
		Если ТипЗнч(ИсточникДанных) <> Тип("СправочникСсылка.ШаблоныСводныхПроводокДляОбменаСБухгалтерией") Тогда
			ПараметрыПеретаскивания.Действие = ДействиеПеретаскивания.Отмена;
			Возврат;
		КонецЕсли;
	КонецЦикла;
	
	ТекущиеДанныеПриемника = Элементы.ШаблоныПроводок.ДанныеСтроки(Строка);
	Если Не ТекущиеДанныеПриемника.ЭтоГруппаШаблонов Тогда
		ПараметрыПеретаскивания.Действие = ДействиеПеретаскивания.Отмена;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти // ОбработчикиСобытийЭлементовФормы

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ
#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	///////////////////////////////////////////////////////////////////////////////
	// Шаблоны проводок (Элементы)
	
	// ЦветТекста строки списка Шаблоны проводок
	Элемент = ШаблоныПроводок.УсловноеОформление.Элементы.Добавить();
	
	ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(Элемент.Отбор,
		"ЭтоГруппаШаблонов", ВидСравненияКомпоновкиДанных.Равно, Ложь);
	
	ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(Элемент.Отбор,
		"ДействующийШаблон", ВидСравненияКомпоновкиДанных.Равно, Ложь);
	
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ЦветТекстаОтмененнойСтрокиДокумента);
	
	// Видимость поля ШаблоныПроводокВариантСовместногоПрименения
	Элемент = ШаблоныПроводок.УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных("ВариантСовместногоПрименения");
	
	ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(Элемент.Отбор,
		"ЭтоГруппаШаблонов", ВидСравненияКомпоновкиДанных.Равно, Ложь);
	
	Элемент.Оформление.УстановитьЗначениеПараметра("Видимость", Ложь);
	
	///////////////////////////////////////////////////////////////////////////////
	// Шаблоны проводок (Группы)
	
	// Видимость полей списка Шаблоны проводок
	Элемент = ШаблоныПроводок.УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных("КПССчетаДебета");
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных("СчетДебета");
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных("КЭКСчетаДебета");
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных("КПССчетаКредита");
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных("СчетКредита");
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных("КЭКСчетаКредита");
	
	ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(Элемент.Отбор,
		"ЭтоГруппаШаблонов", ВидСравненияКомпоновкиДанных.Равно, Истина);
	
	Элемент.Оформление.УстановитьЗначениеПараметра("Видимость", Ложь);
	
	// Справочная надпись для группы с вариантом "Вытеснение"
	Элемент = ШаблоныПроводок.УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных("ВариантСовместногоПрименения");
	
	ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(Элемент.Отбор,
		"ЭтоГруппаШаблонов", ВидСравненияКомпоновкиДанных.Равно, Истина);
	
	ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(Элемент.Отбор,
		"ВариантСовместногоПрименения", ВидСравненияКомпоновкиДанных.Равно, Перечисления.ВариантыСовместногоПримененияШаблоновПроводок.Вытеснение);
	
	Элемент.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru = 'Данные для первых в порядке следования шаблонов исключаются из данных для последующих шаблонов'"));
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ПоясняющийТекст);
	
	// Справочная надпись для группы с вариантом "Все"
	Элемент = ШаблоныПроводок.УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных("ВариантСовместногоПрименения");
	
	ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(Элемент.Отбор,
		"ЭтоГруппаШаблонов", ВидСравненияКомпоновкиДанных.Равно, Истина);
	
	ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(Элемент.Отбор,
		"ВариантСовместногоПрименения", ВидСравненияКомпоновкиДанных.Равно, Перечисления.ВариантыСовместногоПримененияШаблоновПроводок.Все);
	
	Элемент.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru = 'Данные для шаблонов формируются независимо'"));
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ПоясняющийТекст);
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСписокПлановОбмена()
	
	Список = Элементы.ПланОбмена.СписокВыбора;
	ПланыОбменаСПроводками = Метаданные.ОпределяемыеТипы.ОбменПроводками.Тип.Типы();
	Для Каждого ПланОбменаТип Из ПланыОбменаСПроводками Цикл
		ПланОбменаМетаданные = Метаданные.НайтиПоТипу(ПланОбменаТип);
		Если ОбменДаннымиПовтИсп.ДоступноИспользованиеПланаОбмена(ПланОбменаМетаданные.Имя) Тогда
			Список.Добавить(ОбщегоНазначения.ИдентификаторОбъектаМетаданных(ПланОбменаМетаданные));
		КонецЕсли;
	КонецЦикла;
	
	Если Список.Количество() = 1 Тогда
		ПланОбмена = Список[0].Значение;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработчикХозяйственныеОперацииПриАктивизацииСтроки()
	
	ТекущаяСтрока = Элементы.ХозяйственныеОперации.ТекущаяСтрока;
	Если ТекущаяСтрокаНедоступна(ТекущаяСтрока, Ложь) Тогда
		ТекущаяСтрока = Неопределено;
	КонецЕсли;
	
	УстановитьОтборШаблоновПроводок(ТекущаяСтрока);
	
КонецПроцедуры

&НаКлиенте
Функция ВозможноСоздатьШаблонПроводки()
	
	Элемент = Элементы.ХозяйственныеОперации;
	
	Возврат Не ТекущаяСтрокаНедоступна(Элемент.ТекущаяСтрока) И Не Элемент.ТекущиеДанные.ЭтоГруппа;
	
КонецФункции

&НаКлиенте
Функция ТекущаяСтрокаНедоступна(ТекущаяСтрока, ВыводитьПредупреждение = Истина)
	
	ТекущаяСтрокаНедоступна = ТекущаяСтрока = Неопределено Или ТипЗнч(ТекущаяСтрока) = Тип("СтрокаГруппировкиДинамическогоСписка");
	
	Если ТекущаяСтрокаНедоступна И ВыводитьПредупреждение Тогда
		ПоказатьПредупреждение(, НСтр("ru='Команда не может быть выполнена для указанного объекта.'"));
	КонецЕсли;
	
	Возврат ТекущаяСтрокаНедоступна;
	
КонецФункции

#Область УстановкаОтборов

&НаСервере
Процедура УстановитьОтборШаблоновПроводок(Знач ХозяйственнаяОперация = Неопределено)
	
	Если ХозяйственнаяОперация = Неопределено Тогда
		ХозяйственнаяОперация = Справочники.НастройкиХозяйственныхОпераций.ПустаяСсылка();
	КонецЕсли;
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(ШаблоныПроводок, "Операция", ХозяйственнаяОперация);
	
КонецПроцедуры

&НаСервере
Процедура УстановитьОтборПоПлануОбмена()
	
	ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(ХозяйственныеОперации, "ПланОбмена", ПланОбмена);
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(ШаблоныПроводок, "ПланОбмена", ПланОбмена);
	
КонецПроцедуры

&НаСервере
Процедура УстановитьОтборПоНастройкеОтражения()
	
	Элементы.ПланОбмена.ТолькоПросмотр = ЗначениеЗаполнено(НастройкаОтраженияВБухгалтерскомУчете);
	
	ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(ХозяйственныеОперации, "НастройкаОтраженияВБухгалтерскомУчете", НастройкаОтраженияВБухгалтерскомУчете);
	ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(ШаблоныПроводок, "НастройкаОтраженияВБухгалтерскомУчете", НастройкаОтраженияВБухгалтерскомУчете);
	
	Если ЗначениеЗаполнено(НастройкаОтраженияВБухгалтерскомУчете) Тогда
		ПланОбмена = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(НастройкаОтраженияВБухгалтерскомУчете, "ПланОбмена");
		УстановитьОтборПоПлануОбмена();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти // УстановкаОтборов

#Область НастройкиОтраженияВБухгалтерскомУчете

&НаКлиенте
Процедура ОтразитьВНастройке(ВключитьВНастройку)
	
	ВыделенныеШаблоны = ВзаимодействиеСПользователемКлиент.ПроверитьПолучитьВыделенныеВСпискеСсылки(Элементы.ШаблоныПроводок);
	Если Не ЗначениеЗаполнено(ВыделенныеШаблоны) Тогда
		Возврат;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(НастройкаОтраженияВБухгалтерскомУчете) Тогда
		ОбщегоНазначенияКлиент.СообщитьПользователю(НСтр("ru = 'Не заполнена Настройка отражения в бухгалтерском учете.'"),, "НастройкаОтраженияВБухгалтерскомУчете");
		Возврат;
	КонецЕсли;
	
	ОтразитьВНастройкеНаСервере(ВыделенныеШаблоны, ВключитьВНастройку);
	
	Оповестить("ИзмененыНастройкиИспользованияВБухгалтерскомУчете");
	
КонецПроцедуры

&НаСервере
Процедура ОтразитьВНастройкеНаСервере(Знач СписокШаблонов, Знач ВключитьВНастройку)
	
	НаборЗаписей = РегистрыСведений.ПравилаОтраженияВБухгалтерскомУчете.СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.НастройкаОтраженияВБухгалтерскомУчете.Установить(НастройкаОтраженияВБухгалтерскомУчете);
	
	ДобавляемыеЗаписи = НаборЗаписей.Выгрузить();
	УдаляемыеЗаписи = НаборЗаписей.Выгрузить();
	
	НаборЗаписей.Прочитать();
	ТекущиеЗаписи = НаборЗаписей.Выгрузить();
	
	Для Каждого ШаблонПроводки Из СписокШаблонов Цикл
		Запись = ТекущиеЗаписи.Найти(ШаблонПроводки, "ШаблонПроводки");
		Если Запись = Неопределено Тогда
			Если ВключитьВНастройку Тогда
				НоваяЗапись = ДобавляемыеЗаписи.Добавить();
				НоваяЗапись.НастройкаОтраженияВБухгалтерскомУчете = НастройкаОтраженияВБухгалтерскомУчете;
				НоваяЗапись.ШаблонПроводки = ШаблонПроводки;
			КонецЕсли;
		Иначе
			Если Не ВключитьВНастройку Тогда
				ЗаполнитьЗначенияСвойств(УдаляемыеЗаписи.Добавить(), Запись);
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
	Если ДобавляемыеЗаписи.Количество() > 0 Тогда
		НаборЗаписей.Загрузить(ДобавляемыеЗаписи);
		НаборЗаписей.Записать(Ложь);
	КонецЕсли;
	
	НаборЗаписей.Очистить();
	Для Каждого Запись Из УдаляемыеЗаписи Цикл
		НаборЗаписей.Отбор.ШаблонПроводки.Установить(Запись.ШаблонПроводки);
		НаборЗаписей.Записать();
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти // НастройкиОтраженияВБухгалтерскомУчете

#Область КопированиеГруппШаблоновПроводок

&НаКлиенте
Процедура СкопироватьГруппуШаблоновПроводок(РезультатВопроса, КопируемаяГруппа) Экспорт
	
	Если РезультатВопроса = "СкопироватьТекущийЭлемент" Тогда
		
		ПараметрыФормы = Новый Структура("ЗначениеКопирования", КопируемаяГруппа);
		ОткрытьФорму("Справочник.ШаблоныСводныхПроводокДляОбменаСБухгалтерией.ФормаОбъекта", ПараметрыФормы);
		
	ИначеЕсли РезультатВопроса = "СкопироватьСПодчиненными" Тогда
		
		СкопироватьГруппуШаблоновВместеСПодчиненнымиЭлементами(КопируемаяГруппа);
		ОповеститьОбИзменении(ТипЗнч(КопируемаяГруппа));
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура СкопироватьГруппуШаблоновВместеСПодчиненнымиЭлементами(Знач КопируемаяГруппа)
	
	Запрос = Новый Запрос("
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ШаблоныПроводок.Ссылка  КАК Ссылка
	|ИЗ
	|	Справочник.ШаблоныСводныхПроводокДляОбменаСБухгалтерией КАК ШаблоныПроводок
	|ГДЕ
	|	ШаблоныПроводок.Ссылка В ИЕРАРХИИ(&Ссылка)
	|УПОРЯДОЧИТЬ ПО
	|	РеквизитДопУпорядочивания ИЕРАРХИЯ
	|");
	
	Запрос.УстановитьПараметр("Ссылка", КопируемаяГруппа);
	РезультатЗапроса = Запрос.Выполнить();
	
	Если РезультатЗапроса.Пустой() Тогда
		Возврат;
	КонецЕсли;
	
	НачатьТранзакцию();
	
	Попытка
		
		Блокировка = Новый БлокировкаДанных;
		ЭлементБлокировки = Блокировка.Добавить(КопируемаяГруппа.Метаданные().ПолноеИмя());
		ЭлементБлокировки.ИсточникДанных = РезультатЗапроса;
		ЭлементБлокировки.ИспользоватьИзИсточникаДанных("Ссылка", "Ссылка");
		ЭлементБлокировки.Режим = РежимБлокировкиДанных.Разделяемый;
		Блокировка.Заблокировать();
		
		Выборка = РезультатЗапроса.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкамСИерархией);
		Выборка.Следующий();
		
		КоличествоУровней = Выборка.Ссылка.Метаданные().КоличествоУровней;
		Стек = Новый Массив(КоличествоУровней);
		СоответствияЭлементов = Новый Соответствие;
		
		СкопироватьШаблонПроводки(Выборка.Ссылка, СоответствияЭлементов);
		
		Пока ВыбратьСледующуюЗапись(Выборка, Стек) Цикл
			СкопироватьШаблонПроводки(Выборка.Ссылка, СоответствияЭлементов);
		КонецЦикла;
		
		ЗафиксироватьТранзакцию();
		
	Исключение
		
		ОтменитьТранзакцию();
		ВызватьИсключение;
		
	КонецПопытки;
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура СкопироватьШаблонПроводки(Ссылка, СоответствияЭлементов)
	
	Копия = Ссылка.Скопировать();
	
	НовыйРодитель = СоответствияЭлементов.Получить(Копия.Родитель);
	Если НовыйРодитель <> Неопределено Тогда
		Копия.Родитель = НовыйРодитель;
	КонецЕсли;
	
	Копия.Записать();
	
	СоответствияЭлементов.Вставить(Ссылка, Копия.Ссылка);
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ВыбратьСледующуюЗапись(Выборка, Стек)
	
	Стек[Выборка.Уровень()] = Выборка;
	
	Выборка = Выборка.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкамСИерархией);
	ЗаписьВыбрана = Выборка.Следующий();
	
	Пока Не ЗаписьВыбрана И Выборка.Уровень() > 0 Цикл
		
		Выборка = Стек[Выборка.Уровень() - 1];
		ЗаписьВыбрана = Выборка.Следующий();
		
	КонецЦикла;
	
	Возврат ЗаписьВыбрана;
	
КонецФункции

#КонецОбласти // КопированиеГруппШаблоновПроводок

#Область ИзменениеОперацииШаблоновПроводок

&НаКлиенте
Процедура ПоменятьОперациюШаблонаПроводкиПослеПодтверждения(РезультатВопроса, ДополнительныеПараметры) Экспорт
	
	Если РезультатВопроса <> КодВозвратаДиалога.ОК Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ТекущаяСтрока", Элементы.ХозяйственныеОперации.ТекущаяСтрока);
	
	Оповестить = Новый ОписаниеОповещения("ПоменятьОперациюШаблонаПроводкиПослеВыбораОперации", ЭтотОбъект);
	ОткрытьФорму("Справочник.НастройкиХозяйственныхОпераций.ФормаВыбора", ПараметрыФормы,,,,, Оповестить);
	
КонецПроцедуры

&НаКлиенте
Процедура ПоменятьОперациюШаблонаПроводкиПослеВыбораОперации(ВыбраннаяОперация, ДополнительныеПараметры) Экспорт
	
	Если ВыбраннаяОперация = Неопределено
	 Или ВыбраннаяОперация = Элементы.ХозяйственныеОперации.ТекущаяСтрока Тогда
		Возврат;
	КонецЕсли;
	
	ТекущаяСтрока = Элементы.ШаблоныПроводок.ТекущаяСтрока;
	ПоменятьОперациюШаблонаПроводкиНаСервере(ТекущаяСтрока, ВыбраннаяОперация);
	ОповеститьОбИзменении(ТипЗнч(ТекущаяСтрока));
	Элементы.ХозяйственныеОперации.Обновить();
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура ПоменятьОперациюШаблонаПроводкиНаСервере(Знач ШаблонПроводки, Знач Операция)
	
	Справочники.ШаблоныСводныхПроводокДляОбменаСБухгалтерией.ПоменятьОперациюШаблонаПроводки(ШаблонПроводки, Операция);
	
КонецПроцедуры

#КонецОбласти // ИзменениеОперацииШаблоновПроводок

#Область ИзменениеРодителейЭлементов

&НаКлиенте
Процедура ПоменятьРодителяШаблонаПроводки(ВыбранныйРодитель, ДополнительныеПараметры) Экспорт
	
	Если ВыбранныйРодитель = Неопределено
	 Или ВыбранныйРодитель = Элементы.ШаблоныПроводок.ТекущиеДанные.Родитель Тогда
		Возврат;
	КонецЕсли;
	
	ТекущаяСтрока = Элементы.ШаблоныПроводок.ТекущаяСтрока;
	ПоменятьРодителяШаблонаПроводкиНаСервере(ТекущаяСтрока, ВыбранныйРодитель);
	ОповеститьОбИзменении(ТипЗнч(ТекущаяСтрока));
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура ПоменятьРодителяШаблонаПроводкиНаСервере(Знач ШаблонПроводки, Знач Родитель)
	
	ШаблонОбъект = ШаблонПроводки.ПолучитьОбъект();
	ШаблонОбъект.Родитель = Родитель;
	ШаблонОбъект.Записать();
	
КонецПроцедуры

#КонецОбласти // ИзменениеРодителейЭлементов

#КонецОбласти // СлужебныеПроцедурыИФункции

////////////////////////////////////////////////////////////////////////////////
// СТАНДАРТНЫЕ ПОДСИСТЕМЫ
#Область СтандартныеПодсистемы

// СтандартныеПодсистемы.ПодключаемыеКоманды

&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Элементы.ШаблоныПроводок);
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат) Экспорт
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, Элементы.ШаблоныПроводок, Результат);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Элементы.ШаблоныПроводок);
КонецПроцедуры

// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

#КонецОбласти // СтандартныеПодсистемы
