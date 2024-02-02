﻿
////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	БизнесПроцессыИЗадачиСервер.ФормаЗадачиПриСозданииНаСервере(
		ЭтотОбъект,
		Объект, 
		Элементы.ГруппаСостояние,
		Элементы.ДатаИсполнения);
	
	РезультатыУтвержденияУтверждено = Перечисления.РезультатыУтверждения.Утверждено;
	РезультатыУтвержденияНеУтверждено = Перечисления.РезультатыУтверждения.НеУтверждено;
	
	Если Не ЗначениеЗаполнено(Объект.Ссылка) Тогда
		ИнициализацияФормы();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	// СтандартныеПодсистемы.УправлениеДоступом
	УправлениеДоступом.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
	ИнициализацияФормы();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "ИзмененыРеквизитыНевыполненныхЗадач" И Параметр = Объект.БизнесПроцесс И Не Объект.Выполнена Тогда 
		ДатаИсполнения = Объект.ДатаИсполнения;
		Прочитать();
		Объект.ДатаИсполнения = ДатаИсполнения;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	Если ПараметрыЗаписи.Свойство("ВыполнитьЗадачу") И ПараметрыЗаписи.ВыполнитьЗадачу Тогда 
		
		УстановитьПривилегированныйРежим(Истина);
		УтверждениеОбъект = ТекущийОбъект.БизнесПроцесс.ПолучитьОбъект();
		ЗаблокироватьДанныеДляРедактирования(УтверждениеОбъект.Ссылка);
		НайденнаяСтрока = УтверждениеОбъект.РезультатыУтверждения.Найти(ТекущийОбъект.Ссылка, "ЗадачаИсполнителя");
		НайденнаяСтрока.РезультатУтверждения = ПараметрыЗаписи.РезультатУтверждения;
		УтверждениеОбъект.Записать();
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриЗаписиНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	Если ТекущийОбъект.ДополнительныеСвойства.Свойство("ВыполнитьЗадачу")
	   И ТекущийОбъект.ДополнительныеСвойства.ВыполнитьЗадачу
	   И ПодписыватьЭП Тогда
		
		Если ДанныеДляЗанесенияВРегистр.Количество() > 0 Тогда
			ЭлектроннаяПодписьБольничнаяАптека.ЗанестиИнформациюОПодписях(ДанныеДляЗанесенияВРегистр.ВыгрузитьЗначения(), УникальныйИдентификатор);
		КонецЕсли;
		
	КонецЕсли;
	
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
Процедура ЗаписатьИЗакрытьВыполнить(Команда)
	
	ОчиститьСообщения();
	Если Записать() Тогда
		ОповеститьОбИзменении(Объект.Ссылка);
		ПоказатьОповещениеПользователя(
			"Изменение:", 
			ПолучитьНавигационнуюСсылку(Объект.Ссылка),
			Строка(Объект.Ссылка),
			БиблиотекаКартинок.Информация32);
		Закрыть();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаписатьВыполнить(Команда)
	
	Если Записать() Тогда
		ОповеститьОбИзменении(Объект.Ссылка);
		ПоказатьОповещениеПользователя(
			"Изменение:", 
			ПолучитьНавигационнуюСсылку(Объект.Ссылка),
			Строка(Объект.Ссылка),
			БиблиотекаКартинок.Информация32);
	КонецЕсли;	
	
КонецПроцедуры

&НаКлиенте
Процедура Утверждено(Команда)
	
	ПараметрыЗаписи = Новый Структура;
	ПараметрыЗаписи.Вставить("ВыполнитьЗадачу", Истина);
	ПараметрыЗаписи.Вставить("РезультатУтверждения", РезультатыУтвержденияУтверждено);
	
	Оповещение = Новый ОписаниеОповещения("ПродолжитьУтверждениеПослеПодписанияПредмета", ЭтотОбъект, ПараметрыЗаписи);
	ПодписатьПредмет(Оповещение);
	
КонецПроцедуры

&НаКлиенте
Процедура ПродолжитьУтверждениеПослеПодписанияПредмета(Результат, ПараметрыЗаписи) Экспорт
	
	Если Результат <> Истина Тогда
		Возврат;
	КонецЕсли;
	
	Если Не Записать(ПараметрыЗаписи) Тогда 
		Возврат;
	КонецЕсли;
	
	ПоказатьОповещениеПользователя(
		НСтр("ru = 'Выполнение:'"),
		ПолучитьНавигационнуюСсылку(Объект.Ссылка),
		Строка(Объект.Ссылка),
		БиблиотекаКартинок.Информация32);
	
	Оповестить("ЗадачаВыполнена", Объект.Ссылка);
	Закрыть();
	
КонецПроцедуры

&НаКлиенте
Процедура НеУтверждено(Команда)
	
	Если Не ЗначениеЗаполнено(Объект.РезультатВыполнения) Тогда 
		ОчиститьСообщения();
		ОбщегоНазначенияКлиент.СообщитьПользователю(
			НСтр("ru = 'Укажите причину отклонения документа'"),, 
			"Объект.РезультатВыполнения");
		Возврат;
	КонецЕсли;
	
	ДанныеДляЗанесенияВРегистр = Новый СписокЗначений;
	
	ПараметрыЗаписи = Новый Структура;
	ПараметрыЗаписи.Вставить("ВыполнитьЗадачу", Истина);
	ПараметрыЗаписи.Вставить("РезультатУтверждения", РезультатыУтвержденияНеУтверждено);
	
	Если Не Записать(ПараметрыЗаписи) Тогда 
		Возврат;
	КонецЕсли;
	
	Оповестить("ЗадачаВыполнена", Объект.Ссылка);
	Закрыть();
	
КонецПроцедуры

&НаКлиенте
Процедура История(Команда)
	
	ПараметрыФормы = Новый Структура("ЗадачаСсылка", Объект.Ссылка);
	ОткрытьФорму("БизнесПроцесс.Утверждение.Форма.ФормаИсторияУтверждения", ПараметрыФормы, ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура Дополнительно(Команда)
	
	БизнесПроцессыИЗадачиКлиент.ОткрытьДопИнформациюОЗадаче(Объект.Ссылка);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьБизнесПроцесс(Команда)
	
	ПоказатьЗначение(, Объект.БизнесПроцесс);
	
КонецПроцедуры

&НаКлиенте
Процедура ПринятьКИсполнению(Команда)
	
	БизнесПроцессыИЗадачиКлиент.ПринятьЗадачуКИсполнению(ЭтотОбъект, ТекущийПользователь);	
	
КонецПроцедуры

&НаКлиенте
Процедура ОтменитьПринятиеКИсполнению(Команда)
	
	БизнесПроцессыИЗадачиКлиент.ОтменитьПринятиеЗадачиКИсполнению(ЭтотОбъект);
	
КонецПроцедуры

#КонецОбласти // ОбработчикиКомандФормы

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ФОРМЫ
#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура ИсполнительСтрокойОткрытие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	Если ЗначениеЗаполнено(Объект.Исполнитель) Тогда
		ПоказатьЗначение(, Объект.Исполнитель);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПредметНажатие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ПоказатьЗначение(, Объект.Предмет);
	
КонецПроцедуры

#КонецОбласти // ОбработчикиСобытийЭлементовФормы

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ
#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ИнициализацияФормы()
	            
	БизнесПроцессыИЗадачиБольничнаяАптека.ФормаЗадачиИнициализировать(ЭтотОбъект, Объект, Элементы.СрокИсполнения, Элементы.Предмет);
	
	// номер цикла
	НайденнаяСтрока = Объект.БизнесПроцесс.РезультатыУтверждения.Найти(Объект.Ссылка, "ЗадачаИсполнителя");
	Если НайденнаяСтрока <> Неопределено Тогда 
		НомерИтерации = НайденнаяСтрока.НомерИтерации;
		
		Элементы.ТекстРезультатаВыполнения.Заголовок = Строка(Объект.БизнесПроцесс.РезультатУтверждения) + ".";
		Если Объект.БизнесПроцесс.РезультатУтверждения = Перечисления.РезультатыУтверждения.Утверждено Тогда 
			Элементы.ТекстРезультатаВыполнения.ЦветТекста = ЦветаСтиля.ОтметкаПоложительногоВыполненияЗадачи;
		ИначеЕсли Объект.БизнесПроцесс.РезультатУтверждения = Перечисления.РезультатыУтверждения.НеУтверждено Тогда 
			Элементы.ТекстРезультатаВыполнения.ЦветТекста = ЦветаСтиля.ОтметкаОтрицательногоВыполненияЗадачи;
		КонецЕсли;
	КонецЕсли;	
		
	Если НомерИтерации <= 1 Тогда 
		Элементы.НомерИтерации.Видимость = Ложь;
		Элементы.История.Видимость = Ложь;
	КонецЕсли;	
	
	Предмет = Объект.БизнесПроцесс.Предмет;
	ПодписыватьЭП = Объект.БизнесПроцесс.ПодписыватьЭП;
	
	Если ПодписыватьЭП Тогда
		Команды.Утверждено.Заголовок = НСтр("ru = 'Утверждено (ЭП)'");
		Команды.Утверждено.Подсказка =
			НСтр("ru = 'При нажатии кнопки ""Утверждено"" потребуется выбрать сертификат для подписи и ввести пароль'");
	КонецЕсли;	
	
КонецПроцедуры	

&НаКлиенте
Процедура ПодписатьПредмет(ОповещениеПослеПодписания)
	
	ДанныеДляЗанесенияВРегистр = Новый СписокЗначений;
	
	Если ПодписыватьЭП И ЗначениеЗаполнено(Предмет) Тогда
		Оповещение = Новый ОписаниеОповещения("ПодписатьПредметЗавершение", ЭтотОбъект);
		ЭлектроннаяПодписьБольничнаяАптекаКлиент.ПодписатьПредмет(Предмет, УникальныйИдентификатор, Оповещение, Ложь);
	Иначе
		ВыполнитьОбработкуОповещения(ОповещениеПослеПодписания, Истина);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПодписатьПредметЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат.Успех Тогда
		
		ПодписанныеДанные = Новый Массив;
		Для Каждого Данные Из Результат.НаборДанных Цикл
			Если Не Данные.Свойство("СвойстваПодписи") Тогда
				Возврат;
			КонецЕсли;
			Элемент = Новый Структура;
			Элемент.Вставить("ПодписанныйОбъект", Данные.Представление);
			Элемент.Вставить("СвойстваПодписи", Данные.СвойстваПодписи);
			ПодписанныеДанные.Добавить(Элемент);
		КонецЦикла;
		
		ДанныеДляЗанесенияВРегистр.ЗагрузитьЗначения(ПодписанныеДанные);
		ВыполнитьОбработкуОповещения(ДополнительныеПараметры.ОповещениеПослеПодписания, Истина);
	Иначе
		ВыполнитьОбработкуОповещения(ДополнительныеПараметры.ОповещениеПослеПодписания, Ложь);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти // СлужебныеПроцедурыИФункции


