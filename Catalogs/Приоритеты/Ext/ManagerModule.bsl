﻿
////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ
#Область ОбработчикиСобытий

Процедура ОбработкаПолученияДанныхВыбора(ДанныеВыбора, Параметры, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Запрос = Новый Запрос("
	|ВЫБРАТЬ
	|	Приоритеты.Ссылка                      КАК Ссылка,
	|	Приоритеты.ПометкаУдаления             КАК ПометкаУдаления,
	|	Приоритеты.РеквизитДопУпорядочивания   КАК РеквизитДопУпорядочивания,
	|	ПРЕДСТАВЛЕНИЕССЫЛКИ(Приоритеты.Ссылка) КАК Представление
	|ИЗ
	|	Справочник.Приоритеты КАК Приоритеты
	|ГДЕ
	|	НЕ Приоритеты.ПометкаУдаления
	|	И Приоритеты.Наименование ПОДОБНО &СтрокаПоиска
	|УПОРЯДОЧИТЬ ПО
	|	РеквизитДопУпорядочивания
	|");
	
	Запрос.УстановитьПараметр("СтрокаПоиска", ?(Параметры.СтрокаПоиска = Неопределено, "", Параметры.СтрокаПоиска) + "%");
	
	РезультатЗапроса = Запрос.Выполнить();
	Если Не РезультатЗапроса.Пустой() Тогда
		
		ДанныеВыбора = Новый СписокЗначений;
		
		Выборка = РезультатЗапроса.Выбрать();
		Пока Выборка.Следующий() Цикл
			ДанныеВыбора.Добавить(Выборка.Ссылка);
		КонецЦикла;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

////////////////////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС
#Область ПрограммныйИнтерфейс

// Возвращает самый низший приоритет.
//
// Возвращаемое значение:
//  СправочникСсылка.Приоритеты - самый низкий приоритет
//
Функция ПолучитьНизшийПриоритет() Экспорт
	
	Результат = Справочники.Приоритеты.ПустаяСсылка();
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	Приоритеты.Ссылка                    КАК Приоритет,
	|	Приоритеты.РеквизитДопУпорядочивания КАК РеквизитДопУпорядочивания
	|ИЗ
	|	Справочник.Приоритеты КАК Приоритеты
	|ГДЕ
	|	НЕ Приоритеты.ПометкаУдаления
	|
	|УПОРЯДОЧИТЬ ПО
	|	РеквизитДопУпорядочивания УБЫВ");
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Если НЕ РезультатЗапроса.Пустой() Тогда
		
		Выборка = РезультатЗапроса.Выбрать();
		Выборка.Следующий();
		Результат = Выборка.Приоритет;
		
	КонецЕсли;
		
	Возврат Результат;
	
КонецФункции

// Возвращает самый высший приоритет.
//
// Возвращаемое значение:
//  СправочникСсылка.Приоритеты -  самый высокий приоритет
//
Функция ПолучитьВысшийПриоритет() Экспорт
	
	Результат = Справочники.Приоритеты.ПустаяСсылка();
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	Приоритеты.Ссылка                    КАК Приоритет,
	|	Приоритеты.РеквизитДопУпорядочивания КАК РеквизитДопУпорядочивания
	|ИЗ
	|	Справочник.Приоритеты КАК Приоритеты
	|ГДЕ
	|	НЕ Приоритеты.ПометкаУдаления
	|
	|УПОРЯДОЧИТЬ ПО
	|	РеквизитДопУпорядочивания ВОЗР");
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Если НЕ РезультатЗапроса.Пустой() Тогда
		
		Выборка = РезультатЗапроса.Выбрать();
		Выборка.Следующий();
		Результат = Выборка.Приоритет;
		
	КонецЕсли;
		
	Возврат Результат;
	
КонецФункции

// Получает приоритет, используемый для заполнения новых документов.
//
// Возвращаемое значение:
//	СправочникСсылка.Приоритеты - приоритет по умолчанию
//
Функция ПолучитьПриоритетПоУмолчанию(Знач Приоритет) Экспорт
	
	Результат = Справочники.Приоритеты.ПустаяСсылка();
	
	Если ЗначениеЗаполнено(Приоритет) Тогда
		
		Результат = Приоритет;
		
	Иначе
		
		Запрос = Новый Запрос(
		"ВЫБРАТЬ ПЕРВЫЕ 1
		|	Приоритеты.Приоритет                 КАК Приоритет,
		|	Приоритеты.РеквизитДопУпорядочивания КАК РеквизитДопУпорядочивания
		|ИЗ
		|	(ВЫБРАТЬ ПЕРВЫЕ 2
		|		Приоритеты.Ссылка                    КАК Приоритет,
		|		Приоритеты.РеквизитДопУпорядочивания КАК РеквизитДопУпорядочивания
		|	ИЗ
		|		Справочник.Приоритеты КАК Приоритеты
		|	ГДЕ
		|		НЕ Приоритеты.ПометкаУдаления
		|	
		|	УПОРЯДОЧИТЬ ПО
		|		РеквизитДопУпорядочивания УБЫВ) КАК Приоритеты
		|
		|УПОРЯДОЧИТЬ ПО
		|	РеквизитДопУпорядочивания ВОЗР");
		
		РезультатЗапроса = Запрос.Выполнить();
		
		Если НЕ РезультатЗапроса.Пустой() Тогда
			
			Выборка = РезультатЗапроса.Выбрать();
			Выборка.Следующий();
			Результат = Выборка.Приоритет;
			
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

// Устанавливает условное оформление для приоритетов
//
// Параметры
//	Форма - ФормаКлиентскогоПриложения
//
Процедура УстановитьУсловноеОформление(Форма) Экспорт
	
	УсловноеОформление = Форма.УсловноеОформление;
	Элементы = Форма.Элементы;
	
	Запрос = Новый Запрос("
	|ВЫБРАТЬ
	|	Наименование КАК Представление,
	|	Ссылка КАК Приоритет,
	|	Цвет КАК Цвет
	|ИЗ
	|	Справочник.Приоритеты
	|ГДЕ
	|	НЕ ПометкаУдаления");
	
	АвтоЦвет = Новый Цвет();
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		
		Элемент = УсловноеОформление.Элементы.Добавить();
		Элемент.Представление = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Документ с приоритетом ""%1""'"), Выборка.Представление);
			
		ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
		ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы["Приоритет"].Имя);
		
		ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Объект.Приоритет");
		ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
		ОтборЭлемента.ПравоеЗначение = Выборка.Приоритет;
		
		ЦветФона = Выборка.Цвет.Получить();
		Элемент.Оформление.УстановитьЗначениеПараметра("ЦветФона", ЦветФона);
		Элемент.Использование = (ЦветФона <> АвтоЦвет);
		
	КонецЦикла;
	
КонецПроцедуры

// Устанавливает условное оформление для приоритетов
//
// Параметры
//	Список - ДинамическийСписок
//
Процедура УстановитьУсловноеОформлениеСписка(Список, РежимОтображения = Неопределено) Экспорт
	
	Если РежимОтображения = Неопределено Тогда
		РежимОтображения = РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Обычный;
	КонецЕсли;
	
	Если РежимОтображения = РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный Тогда
		УсловноеОформление = Список.КомпоновщикНастроек.ФиксированныеНастройки.УсловноеОформление;
	Иначе
		УсловноеОформление = Список.КомпоновщикНастроек.Настройки.УсловноеОформление;
	КонецЕсли;
	
	Запрос = Новый Запрос("
	|ВЫБРАТЬ
	|	Наименование КАК Представление,
	|	Ссылка КАК Приоритет,
	|	Цвет КАК Цвет
	|ИЗ
	|	Справочник.Приоритеты
	|ГДЕ
	|	НЕ ПометкаУдаления");
	
	АвтоЦвет = Новый Цвет();
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		
		Элемент = УсловноеОформление.Элементы.Добавить();
		Элемент.Представление = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Документ с приоритетом ""%1""'"), Выборка.Представление);
			
		ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Приоритет");
		ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
		ОтборЭлемента.ПравоеЗначение = Выборка.Приоритет;
		
		ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ПометкаУдаления");
		ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
		ОтборЭлемента.ПравоеЗначение = Ложь;
		
		ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Проведен");
		ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
		ОтборЭлемента.ПравоеЗначение = Истина;
		
		ЦветФона = Выборка.Цвет.Получить();
		Элемент.Оформление.УстановитьЗначениеПараметра("ЦветФона", ЦветФона);
		Элемент.Использование = (ЦветФона <> АвтоЦвет);
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

////////////////////////////////////////////////////////////////////////////////
// ОБНОВЛЕНИЕ ИНФОРМАЦИОННОЙ БАЗЫ
#Область ОбновлениеИнформационнойБазы

// Выполняет первоначальное заполнение справочника
//
Процедура СоздатьПриоритетыПоУмолчанию() Экспорт
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	1 КАК Поле
	|ИЗ
	|	Справочник.Приоритеты КАК Приоритеты");
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Если РезультатЗапроса.Пустой() Тогда
		
		ПриоритетыЭлемент = Справочники.Приоритеты.СоздатьЭлемент();
		ПриоритетыЭлемент.Наименование = НСтр("ru = 'Высокий'");
		ПриоритетыЭлемент.Цвет = Новый ХранилищеЗначения(ЦветаСтиля.ВысокийПриоритетДокумента);
		ПриоритетыЭлемент.РеквизитДопУпорядочивания = 1;
		ПриоритетыЭлемент.Записать();
		
		ПриоритетыЭлемент = Справочники.Приоритеты.СоздатьЭлемент();
		ПриоритетыЭлемент.Наименование = НСтр("ru = 'Средний'");
		ПриоритетыЭлемент.Цвет = Новый ХранилищеЗначения(Новый Цвет()); // Авто цвет
		ПриоритетыЭлемент.РеквизитДопУпорядочивания = 2;
		ПриоритетыЭлемент.Записать();
		
		ПриоритетыЭлемент = Справочники.Приоритеты.СоздатьЭлемент();
		ПриоритетыЭлемент.Наименование = НСтр("ru = 'Низкий'");
		ПриоритетыЭлемент.Цвет = Новый ХранилищеЗначения(ЦветаСтиля.НизкийПриоритетДокумента);
		ПриоритетыЭлемент.РеквизитДопУпорядочивания = 3;
		ПриоритетыЭлемент.Записать();
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти // ОбновлениеИнформационнойБазы

#КонецЕсли