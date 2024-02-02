﻿
////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ
#Область ОбработчикиСобытий

Процедура ОбработкаПолученияДанныхВыбора(ДанныеВыбора, Параметры, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Если ЗначениеЗаполнено(Параметры.СтрокаПоиска) Тогда
		
		Запрос = Новый Запрос;
		Запрос.Текст =
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	ФизическиеЛица.Ссылка КАК Ссылка,
		|	ФизическиеЛица.Наименование КАК Представление,
		|	ФизическиеЛица.Уточнение,
		|	ФизическиеЛица.ПометкаУдаления КАК ПометкаУдаления
		|ИЗ
		|	Справочник.ФизическиеЛица КАК ФизическиеЛица
		|ГДЕ
		|	(ФизическиеЛица.Наименование ПОДОБНО &ФамилияИмяОтчество
		|			ИЛИ ФизическиеЛица.Наименование ПОДОБНО &ФамилияИмя
		|			ИЛИ ФизическиеЛица.Наименование ПОДОБНО &Фамилия)
		|
		|УПОРЯДОЧИТЬ ПО
		|	ПометкаУдаления";
		
		ФИО = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(СокрЛП(Параметры.СтрокаПоиска)," ");
		
		КоличествоПодстрок = ФИО.Количество();
		Фамилия            = ?(КоличествоПодстрок > 0,ФИО[0],"");
		Имя                = ?(КоличествоПодстрок > 1,ФИО[1],"");
		Отчество           = ?(КоличествоПодстрок > 2,ФИО[2],"");
		
		Запрос.УстановитьПараметр("ФамилияИмяОтчество", СокрЛП(Фамилия + " " + Имя + " " + Отчество) + "%");
		Запрос.УстановитьПараметр("ФамилияИмя", СокрЛП(Фамилия + " " + Имя + "%"));
		Запрос.УстановитьПараметр("Фамилия",  СокрЛП(Фамилия) + "%");
		
		ДанныеВыбора = Новый СписокЗначений;
		
		Выборка = Запрос.Выполнить().Выбрать();
		
		Пока Выборка.Следующий() Цикл
			
			Представление = Выборка.Представление + ?(ПустаяСтрока(Выборка.Уточнение),""," (" + Выборка.Уточнение +")");
			
			Если Выборка.ПометкаУдаления Тогда
				СтруктураЗначение = Новый Структура("Значение, ПометкаУдаления", Выборка.Ссылка, Выборка.ПометкаУдаления);
				ДанныеВыбора.Добавить(СтруктураЗначение, Представление,, БиблиотекаКартинок.ПомеченныйНаУдалениеЭлемент);
			Иначе
				ДанныеВыбора.Добавить(Выборка.Ссылка, Представление);
			КонецЕсли;
			
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти // ОбработчикиСобытий

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

////////////////////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС
#Область ПрограммныйИнтерфейс

// Возвращает строковое представление должности по ФРМР физ.лица.
//
// Параметры:
//  ФизЛицо - СправочникСсылка.ФизическиеЛица
// 
// Возвращаемое значение:
//  Строка
//
Функция ДолжностьФизЛицаПоФРМР(ФизЛицо) Экспорт

	Должность = "";

	Если ЗначениеЗаполнено(ФизЛицо) Тогда
		Если ТипЗнч(ФизЛицо) <> Тип("СправочникСсылка.ФизическиеЛица") Тогда
			ТекстСообщения = НСтр("ru = 'Некорректные параметры функции ""Справочники.ФизическиеЛица.ДолжностьФизЛицаПоФРМР"". Обратитесь к разработчику.'");
			ВызватьИсключение(ТекстСообщения);
		КонецЕсли;
		
		Должность = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ФизЛицо, "ДолжностьФРМР");
	КонецЕсли;

	Возврат Должность;

КонецФункции

#КонецОбласти // ПрограммныйИнтерфейс

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ
#Область СлужебныеПроцедурыИФункции

// Обработчик для события формы ОбработкаПроверкиЗаполненияНаСервере.
// Вызывается из модуля формы.
//
// Параметры:
//    Форма                - ФормаКлиентскогоПриложения - Форма, предназначенная для вывода контактной информации.
//    ПроверяемыеРеквизиты - Массив           - Массив путей к реквизитам, для которых будет выполнена проверка заполнения.
//
Процедура ОбработкаПроверкиЗаполненияНаСервере(Форма, Отказ, ПроверяемыеРеквизиты) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ФизическиеЛица.Ссылка
	|ИЗ
	|	Справочник.ФизическиеЛица КАК ФизическиеЛица
	|ГДЕ
	|	ФизическиеЛица.Наименование = &Наименование
	|	И ФизическиеЛица.Уточнение = &Уточнение
	|	И ФизическиеЛица.Ссылка <> &Ссылка";
	
	Запрос.УстановитьПараметр("Наименование", Форма.Объект.Наименование);
	Запрос.УстановитьПараметр("Уточнение",    Форма.Объект.Уточнение);
	Запрос.УстановитьПараметр("Ссылка",       Форма.Объект.Ссылка);
	
	Результат = Запрос.Выполнить();
	Если Не Результат.Пустой() Тогда
		ТекстСообщения = НСтр("ru = 'Физическое лицо с таким ФИО и уточнением уже существует в информационной базе.
			|Необходимо либо указать другую уточняющую информацию, либо воспользоваться уже имеющимся элементом справочника.'"); 
		ОбщегоНазначения.СообщитьПользователю(ТекстСообщения,, "Объект.Наименование",, Отказ);
	КонецЕсли;
	
КонецПроцедуры

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

////////////////////////////////////////////////////////////////////////////////
// ОБНОВЛЕНИЕ ИНФОРМАЦИОННОЙ БАЗЫ
#Область ОбновлениеИнформационнойБазы

// Обработчик обновления информационной базы, предназначенный для первоначального заполнения
// и обновления значения реквизитов, предопределенных видов КИ.
//
Процедура ОбновитьПредопределенныеВидыКонтактнойИнформации() Экспорт
	
	ПараметрыВида = УправлениеКонтактнойИнформацией.ПараметрыВидаКонтактнойИнформации("АдресЭлектроннойПочты");
	ПараметрыВида.Вид = Справочники.ВидыКонтактнойИнформации.EmailФизическогоЛица;
	ПараметрыВида.МожноИзменятьСпособРедактирования = Истина;
	ПараметрыВида.РазрешитьВводНесколькихЗначений = Истина;
	ПараметрыВида.Порядок = 1;
	УправлениеКонтактнойИнформацией.УстановитьСвойстваВидаКонтактнойИнформации(ПараметрыВида);
	
	ПараметрыВида = УправлениеКонтактнойИнформацией.ПараметрыВидаКонтактнойИнформации("Телефон");
	ПараметрыВида.Вид = Справочники.ВидыКонтактнойИнформации.ТелефонМобильныйФизическиеЛица;
	ПараметрыВида.МожноИзменятьСпособРедактирования = Истина;
	ПараметрыВида.РазрешитьВводНесколькихЗначений = Истина;
	ПараметрыВида.Порядок = 2;
	УправлениеКонтактнойИнформацией.УстановитьСвойстваВидаКонтактнойИнформации(ПараметрыВида);
	
	ПараметрыВида = УправлениеКонтактнойИнформацией.ПараметрыВидаКонтактнойИнформации("Телефон");
	ПараметрыВида.Вид = Справочники.ВидыКонтактнойИнформации.ТелефонРабочийФизическиеЛица;
	ПараметрыВида.МожноИзменятьСпособРедактирования = Истина;
	ПараметрыВида.РазрешитьВводНесколькихЗначений = Истина;
	ПараметрыВида.Порядок = 3;
	УправлениеКонтактнойИнформацией.УстановитьСвойстваВидаКонтактнойИнформации(ПараметрыВида);
	
	ПараметрыВида = УправлениеКонтактнойИнформацией.ПараметрыВидаКонтактнойИнформации("Телефон");
	ПараметрыВида.Вид = Справочники.ВидыКонтактнойИнформации.ТелефонДомашнийФизическиеЛица;
	ПараметрыВида.МожноИзменятьСпособРедактирования = Истина;
	ПараметрыВида.РазрешитьВводНесколькихЗначений = Истина;
	ПараметрыВида.Порядок = 4;
	УправлениеКонтактнойИнформацией.УстановитьСвойстваВидаКонтактнойИнформации(ПараметрыВида);
	
	ПараметрыВида = УправлениеКонтактнойИнформацией.ПараметрыВидаКонтактнойИнформации("Адрес");
	ПараметрыВида.Вид = Справочники.ВидыКонтактнойИнформации.АдресДляИнформированияФизическиеЛица;
	ПараметрыВида.МожноИзменятьСпособРедактирования = Истина;
	ПараметрыВида.Порядок = 5;
	УправлениеКонтактнойИнформацией.УстановитьСвойстваВидаКонтактнойИнформации(ПараметрыВида);
	
	ПараметрыВида = УправлениеКонтактнойИнформацией.ПараметрыВидаКонтактнойИнформации("Адрес");
	ПараметрыВида.Вид = Справочники.ВидыКонтактнойИнформации.АдресЗаПределамиРФФизическиеЛица;
	ПараметрыВида.МожноИзменятьСпособРедактирования = Истина;
	ПараметрыВида.Порядок = 6;
	УправлениеКонтактнойИнформацией.УстановитьСвойстваВидаКонтактнойИнформации(ПараметрыВида);
	
	ПараметрыВида = УправлениеКонтактнойИнформацией.ПараметрыВидаКонтактнойИнформации("Адрес");
	ПараметрыВида.Вид = Справочники.ВидыКонтактнойИнформации.АдресПоПропискеФизическиеЛица;
	ПараметрыВида.МожноИзменятьСпособРедактирования = Истина;
	ПараметрыВида.Порядок = 7;
	УправлениеКонтактнойИнформацией.УстановитьСвойстваВидаКонтактнойИнформации(ПараметрыВида);
	
	ПараметрыВида = УправлениеКонтактнойИнформацией.ПараметрыВидаКонтактнойИнформации("Адрес");
	ПараметрыВида.Вид = Справочники.ВидыКонтактнойИнформации.АдресМестаПроживанияФизическиеЛица;
	ПараметрыВида.МожноИзменятьСпособРедактирования = Истина;
	ПараметрыВида.Порядок = 8;
	УправлениеКонтактнойИнформацией.УстановитьСвойстваВидаКонтактнойИнформации(ПараметрыВида);
	
КонецПроцедуры

#КонецОбласти // ОбновлениеИнформационнойБазы

#КонецЕсли