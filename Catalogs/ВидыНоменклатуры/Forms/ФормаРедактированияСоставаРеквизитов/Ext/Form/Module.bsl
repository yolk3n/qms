﻿
////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьУсловноеОформлениеФормы();
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	ТаблицаРеквизитов.Загрузить(ПолучитьИзВременногоХранилища(Параметры.АдресВХранилище));
	
	ТаблицаРеквизитов.Сортировать("ПредставлениеРеквизита");
	
	ЗакрыватьПриВыборе = Ложь;
	
КонецПроцедуры

#КонецОбласти

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ
#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ДобавитьВПанель(Команда)
	
	ВыполнитьПодборРеквизитов();
	
КонецПроцедуры

#КонецОбласти

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ФОРМЫ
#Область ОбработчикиСобытийЭлементовФормы

#Область ТаблицаРеквизитов

&НаКлиенте
Процедура ТаблицаРеквизитовПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	
	Отказ = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаРеквизитовПередУдалением(Элемент, Отказ)
	
	Отказ = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаРеквизитовВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ВыполнитьПодборРеквизитов();
	
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаРеквизитовВыборЗначения(Элемент, Значение, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ВыполнитьПодборРеквизитов();
	
КонецПроцедуры

#КонецОбласти // ТаблицаРеквизитов

#КонецОбласти // ОбработчикиСобытийЭлементовФормы

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ
#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформлениеФормы()
	
	// Шрифт строки таблицы ТаблицаРеквизитов
	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ТаблицаРеквизитов.Имя);
	
	ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(Элемент.Отбор,
		"ТаблицаРеквизитов.Используется", ВидСравненияКомпоновкиДанных.Равно, Истина);
	
	Элемент.Оформление.УстановитьЗначениеПараметра("Шрифт", Новый Шрифт(ШрифтыСтиля.ШрифтТекста,,, Истина));
	
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьПодборРеквизитов()
	
	Если Элементы.ТаблицаРеквизитов.ВыделенныеСтроки.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	МассивДобавляемых = Новый Массив;
	
	Для Каждого ВыделеннаяСтрока Из Элементы.ТаблицаРеквизитов.ВыделенныеСтроки Цикл
		
		ПараметрыСтроки = Новый Структура("ИмяРеквизита, ЭтоДопРеквизит, Свойство, Используется, ПредставлениеРеквизита, Используется");
		
		ДанныеСтроки = Элементы.ТаблицаРеквизитов.ДанныеСтроки(ВыделеннаяСтрока);
		ДанныеСтроки.Используется = Истина;
		
		ЗаполнитьЗначенияСвойств(ПараметрыСтроки, ДанныеСтроки);
		МассивДобавляемых.Добавить(ПараметрыСтроки);
		
	КонецЦикла;
	
	ОповеститьОВыборе(МассивДобавляемых);
	
КонецПроцедуры

#КонецОбласти
