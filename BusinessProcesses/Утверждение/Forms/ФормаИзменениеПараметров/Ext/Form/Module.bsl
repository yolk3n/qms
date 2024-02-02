﻿
////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	ЗадачаОзнакомления = Параметры.ЗадачаОзнакомления;
	РезультатВыполнения = Параметры.РезультатВыполнения;
	
	Элементы.Предмет.Гиперссылка = Объект.Предмет <> Неопределено И Не Объект.Предмет.Пустая();
	ПредметСтрокой = ОбщегоНазначения.ПредметСтрокой(Объект.Предмет);
	
	ИспользоватьДатуИВремяВСрокахЗадач = ПолучитьФункциональнуюОпцию("ИспользоватьДатуИВремяВСрокахЗадач");
	Элементы.СрокИсполненияВремя.Видимость = ИспользоватьДатуИВремяВСрокахЗадач;
	
	ШаблоныПоПредмету.ЗагрузитьЗначения(ШаблоныБизнесПроцессов.ПолучитьШаблоныПоПредмету(Объект.Предмет, ТипЗнч(Объект.Шаблон)));
	УстановитьДоступностьПоШаблону();
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	// СтандартныеПодсистемы.УправлениеДоступом
	УправлениеДоступом.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	ТекущийОбъект.ПовторитьУтверждение = Истина;
	НайденнаяСтрока = ТекущийОбъект.РезультатыОзнакомлений.Найти(ЗадачаОзнакомления, "ЗадачаИсполнителя");
	НайденнаяСтрока.ОтправленоНаПовторноеУтверждение = Истина;
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	// СтандартныеПодсистемы.УправлениеДоступом
	УправлениеДоступом.ПослеЗаписиНаСервере(ЭтотОбъект, ТекущийОбъект, ПараметрыЗаписи);
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
	ЗаблокироватьДанныеДляРедактирования(ЗадачаОзнакомления);
	ЗадачаОбъект = ЗадачаОзнакомления.ПолучитьОбъект();
	ЗадачаОбъект.РезультатВыполнения = РезультатВыполнения;
	ЗадачаОбъект.ВыполнитьЗадачу();
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	Оповестить("БизнесПроцессИзменен", Объект.Ссылка);
	
	ПоказатьОповещениеПользователя(
		НСтр("ru = 'Выполнение:'"),
		ПолучитьНавигационнуюСсылку(ЗадачаОзнакомления),
		Строка(ЗадачаОзнакомления),
		БиблиотекаКартинок.Информация32);
	
	Оповестить("ЗадачаВыполнена",, ЗадачаОзнакомления);
	ОповеститьОбИзменении(ЗадачаОзнакомления);
	
КонецПроцедуры

#КонецОбласти // ОбработчикиСобытийФормы

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ
#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОК(Команда)
	
	Если Не ПроверитьЗаполнение() Тогда
		Возврат;
	КонецЕсли;
	
	БылиИзменения = Модифицированность;
	Если Записать() Тогда
		Если БылиИзменения Тогда
			ПоказатьОповещениеПользователя(
				НСтр("ru = 'Изменение:'"),
				ПолучитьНавигационнуюСсылку(Объект.Ссылка),
				Строка(Объект.Ссылка),
				БиблиотекаКартинок.Информация32);
		КонецЕсли;
		Закрыть(КодВозвратаДиалога.ОК);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Отмена(Команда)
	
	Модифицированность = Ложь;
	Закрыть(КодВозвратаДиалога.Отмена);
	ПоказатьЗначение(Неопределено, ЗадачаОзнакомления);
	
КонецПроцедуры

#КонецОбласти // ОбработчикиКомандФормы

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ФОРМЫ
#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура ПредметНажатие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ПоказатьЗначение(Неопределено, Объект.Предмет);
	
КонецПроцедуры

&НаКлиенте
Процедура ИсполнительНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	БизнесПроцессыИЗадачиКлиент.ВыбратьИсполнителя(
		Элемент,
		Объект.Исполнитель,
		Ложь, // ТолькоПростыеРоли
		Истина); // БезВнешнихРолей
	
КонецПроцедуры

&НаКлиенте
Процедура ИсполнительОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	Если ТипЗнч(ВыбранноеЗначение) = Тип("Структура") Тогда
		СтандартнаяОбработка = Ложь;
		
		Объект.Исполнитель = ВыбранноеЗначение.РольИсполнителя;
		Объект.ОсновнойОбъектАдресации = ВыбранноеЗначение.ОсновнойОбъектАдресации;
		Объект.ДополнительныйОбъектАдресации = ВыбранноеЗначение.ДополнительныйОбъектАдресации;
		
		Модифицированность = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ИсполнительПриИзменении(Элемент)
	
	БизнесПроцессыИЗадачиБольничнаяАптекаКлиент.ПриИзмененииУчастника(
		Объект,
		"Исполнитель",
		"ОсновнойОбъектАдресации",
		"ДополнительныйОбъектАдресации",
		ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ИсполнительАвтоПодбор(Элемент, Текст, ДанныеВыбора, Ожидание, СтандартнаяОбработка)
	
	Если ЗначениеЗаполнено(Текст) Тогда 
		СтандартнаяОбработка = Ложь;
		ДанныеВыбора = БизнесПроцессыИЗадачиВызовСервера.СформироватьДанныеВыбораИсполнителя(Текст);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ИсполнительОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, СтандартнаяОбработка)
	
	Если ЗначениеЗаполнено(Текст) Тогда 
		СтандартнаяОбработка = Ложь;
		ДанныеВыбора = БизнесПроцессыИЗадачиВызовСервера.СформироватьДанныеВыбораИсполнителя(Текст);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти // ОбработчикиСобытийЭлементовФормы

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ
#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьДоступностьПоШаблону()
	
	ДоступностьПоШаблону = ШаблоныБизнесПроцессов.ДоступностьПоШаблону(Объект);
	
	Если ЗначениеЗаполнено(Объект.СрокИсполнения) Тогда 
		Элементы.СрокИсполнения.ТолькоПросмотр = Не ДоступностьПоШаблону;
		Элементы.СрокИсполненияВремя.ТолькоПросмотр = Не ДоступностьПоШаблону;
	Иначе
		Элементы.СрокИсполнения.ТолькоПросмотр = Ложь;
		Элементы.СрокИсполненияВремя.ТолькоПросмотр = Ложь;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Объект.Исполнитель) Тогда 
		Элементы.Исполнитель.ТолькоПросмотр = Не ДоступностьПоШаблону;
	Иначе
		Элементы.Исполнитель.ТолькоПросмотр = Ложь;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти // СлужебныеПроцедурыИФункции
