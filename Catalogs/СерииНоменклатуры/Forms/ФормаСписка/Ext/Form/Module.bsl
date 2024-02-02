﻿
////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьУсловноеОформлениеФормы();
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	Параметры.Отбор.Свойство("Владелец", Номенклатура);
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список, "Владелец", Номенклатура);
	Если ЗначениеЗаполнено(Номенклатура) Тогда
		Элементы.Номенклатура.ТолькоПросмотр = Истина;
	КонецЕсли;
	УстановитьНастройкиПоНоменклатуре();
	
КонецПроцедуры

#КонецОбласти // ОбработчикиСобытийФормы

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ
#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ИзменитьВыделенные(Команда)
	
	ГрупповоеИзменениеОбъектовКлиент.ИзменитьВыделенные(Элементы.Список);
	
КонецПроцедуры

#КонецОбласти // ОбработчикиКомандФормы

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ФОРМЫ
#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура НоменклатураПриИзменении(Элемент)
	
	ОбработатьИзменениеНоменклатуры();
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	
	Если Не Копирование Тогда
		Если Не ЗначениеЗаполнено(Номенклатура) Тогда
			ТекстПредупреждения = НСтр("ru = 'Перед добавлением серии необходимо указать номенклатуру.'");
			ПоказатьПредупреждение(, ТекстПредупреждения);
			Отказ = Истина;
			Возврат;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти // ОбработчикиСобытийЭлементовФормы

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ
#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформлениеФормы()
	
	УсловноеОформлениеСписка = ОбщегоНазначенияБольничнаяАптекаКлиентСервер.ПолучитьУсловноеОформлениеДинамическогоСписка(
		Список,
		РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Обычный);
	
	// Цвет текста, Шрифт в строках списка Список
	Элемент = УсловноеОформлениеСписка.Элементы.Добавить();
	Элемент.Представление = НСтр("ru = 'Список: серия забракована'");
	
	ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(Элемент.Отбор,
		"Забракована", ВидСравненияКомпоновкиДанных.Равно, Истина);
	
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.СерияЗабракованаЦветТекста);
	Элемент.Оформление.УстановитьЗначениеПараметра("Шрифт", ШрифтыСтиля.СерияЗабракованаШрифт);
	
КонецПроцедуры

&НаСервере
Процедура ОбработатьИзменениеНоменклатуры()
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список, "Владелец", Номенклатура);
	УстановитьНастройкиПоНоменклатуре();
	
КонецПроцедуры

&НаСервере
Процедура УстановитьНастройкиПоНоменклатуре()
	
	Если Не ЗначениеЗаполнено(Номенклатура) Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыСерий = ЗначениеНастроекБольничнаяАптекаПовтИсп.ПараметрыСерийНоменклатуры(ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Номенклатура, "ВидНоменклатуры"));
	
	Элементы.ГоденДо.Видимость = ПараметрыСерий.ИспользоватьСрокГодностиСерии;
	Если ПараметрыСерий.ИспользоватьСрокГодностиСерии Тогда
		Элементы.ГоденДо.Формат = ПараметрыСерий.ФорматнаяСтрокаСрокаГодности;
	КонецЕсли;
	
	Элементы.Номер.Видимость = ПараметрыСерий.ИспользоватьНомерСерии;
	
	ТолькоПросмотр = Не ПараметрыСерий.ИспользоватьСерии;
	
КонецПроцедуры

#КонецОбласти // СлужебныеПроцедурыИФункции
