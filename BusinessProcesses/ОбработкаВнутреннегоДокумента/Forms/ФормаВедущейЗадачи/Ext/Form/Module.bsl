﻿
////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	БизнесПроцессыВедущейЗадачи = БизнесПроцессыИЗадачиСервер.БизнесПроцессыВедущейЗадачи(Объект.Ссылка);
	Если БизнесПроцессыВедущейЗадачи.Количество() > 0 Тогда
		БизнесПроцессВедущейЗадачи = БизнесПроцессыВедущейЗадачи[0];
		Элементы.ДекорацияОткрытьФормуБизнесПроцесса.Заголовок = Строка(БизнесПроцессВедущейЗадачи);
	КонецЕсли;
	
	БизнесПроцессыИЗадачиСервер.УстановитьФорматДаты(Элементы.Дата);
	БизнесПроцессыИЗадачиСервер.УстановитьФорматДаты(Элементы.ДатаИсполнения);
	
	Элементы.Предмет.Гиперссылка = ЗначениеЗаполнено(Объект.Предмет);
	ПредметСтрокой = ОбщегоНазначения.ПредметСтрокой(Объект.Предмет);
	
	Элементы.ГруппаРезультат.Видимость = Объект.Выполнена;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	БизнесПроцессыИЗадачиКлиент.ФормаЗадачиОбработкаОповещения(ЭтотОбъект, ИмяСобытия, Параметр, Источник);
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	// СтандартныеПодсистемы.УправлениеДоступом
	УправлениеДоступом.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	// СтандартныеПодсистемы.УправлениеДоступом
	УправлениеДоступом.ПослеЗаписиНаСервере(ЭтотОбъект, ТекущийОбъект, ПараметрыЗаписи);
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
КонецПроцедуры

#КонецОбласти // ОбработчикиСобытийФормы

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ
#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОткрытьБизнесПроцесс(Команда)
	
	ПоказатьЗначение(Неопределено, Объект.БизнесПроцесс);
	
КонецПроцедуры

&НаКлиенте
Процедура Дополнительно(Команда)
	
	БизнесПроцессыИЗадачиКлиент.ОткрытьДопИнформациюОЗадаче(Объект.Ссылка);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаписатьИЗакрытьВыполнить(Команда)
	
	БизнесПроцессыИЗадачиКлиент.ЗаписатьИЗакрытьВыполнить(ЭтотОбъект);
	
КонецПроцедуры

#КонецОбласти // ОбработчикиКомандФормы

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ФОРМЫ
#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура ДекорацияОткрытьФормуБизнесПроцессаНажатие(Элемент)
	
	Если ЗначениеЗаполнено(БизнесПроцессВедущейЗадачи) Тогда
		ПоказатьЗначение(Неопределено, БизнесПроцессВедущейЗадачи);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти // ОбработчикиСобытийЭлементовФормы
