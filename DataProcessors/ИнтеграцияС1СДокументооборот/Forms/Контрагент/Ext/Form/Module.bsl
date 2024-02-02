﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ID = Параметры.ID;
	Тип = Параметры.type;
	Если Не ЗначениеЗаполнено(Тип) Тогда
		Тип = "DMCorrespondent";
	КонецЕсли;
	
	Параметры.Свойство("ВнешнийОбъект", ВнешнийОбъект);
	
	ЗначениеЮрЛицо = "ЮрЛицо"; //@NON-NLS-1
	ЗначениеФизЛицо = "ФизЛицо"; //@NON-NLS-1
	ЗначениеИП = "ИндивидуальныйПредприниматель"; //@NON-NLS-1
	ЗначениеНеРезидент = "ЮрЛицоНеРезидент"; //@NON-NLS-1
	
	Если ИнтеграцияС1СДокументооборотПовтИсп.ИспользоватьТерминКорреспонденты() Тогда
		Элементы.ДекорацияЮрФизЛицо.Заголовок = НСтр("ru = 'Вид корреспондента'");
	КонецЕсли;
	
	// считать данные документа
	Прокси = ИнтеграцияС1СДокументооборотБазоваяФункциональностьПовтИсп.ПолучитьПрокси();
	Если ЗначениеЗаполнено(ID) И ЗначениеЗаполнено(Тип) Тогда
		Запрос = ИнтеграцияС1СДокументооборотБазоваяФункциональность.СоздатьОбъект(Прокси, "DMRetrieveRequest");
		СписокОбъектов = Запрос.objectIDs; // СписокXDTO
		
		ОбъектИд = ИнтеграцияС1СДокументооборотБазоваяФункциональность.СоздатьObjectID(Прокси, ID, Тип);
		СписокОбъектов.Добавить(ОбъектИд);
		
		Результат = ИнтеграцияС1СДокументооборотБазоваяФункциональность.ВыполнитьЗапрос(Прокси, Запрос);
		ИнтеграцияС1СДокументооборотБазоваяФункциональность.ПроверитьВозвратВебСервиса(Прокси, Результат);
		
		ОбъектXDTO = Результат.objects[0];
		
		Если ИнтеграцияС1СДокументооборотПовтИсп.ИспользоватьТерминКорреспонденты() Тогда
			Заголовок = СтрШаблон(НСтр("ru = '%1 (Корреспондент)'"), ОбъектXDTO.name);
		Иначе
			Заголовок = СтрШаблон(НСтр("ru = '%1 (Контрагент)'"), ОбъектXDTO.name);
		КонецЕсли;
		
		Если Не ЗначениеЗаполнено(ВнешнийОбъект) Тогда
			ВнешниеОбъекты = ИнтеграцияС1СДокументооборотБазоваяФункциональность.СсылкиПоВнешнимОбъектам(ОбъектXDTO);
			Если ВнешниеОбъекты.Количество() <> 0 Тогда
				ВнешнийОбъект = ВнешниеОбъекты[0];
			КонецЕсли;
		КонецЕсли;
		
	Иначе
		Запрос = ИнтеграцияС1СДокументооборотБазоваяФункциональность.СоздатьОбъект(Прокси, "DMGetNewObjectRequest");
		Запрос.type = Тип;
		
		Результат = ИнтеграцияС1СДокументооборотБазоваяФункциональность.ВыполнитьЗапрос(Прокси, Запрос);
		ИнтеграцияС1СДокументооборотБазоваяФункциональность.ПроверитьВозвратВебСервиса(Прокси, Результат);
		
		ОбъектXDTO = Результат;
		
		Если ИнтеграцияС1СДокументооборотПовтИсп.ИспользоватьТерминКорреспонденты() Тогда
			Заголовок = НСтр("ru = 'Корреспондент (создание)'");
		Иначе
			Заголовок = НСтр("ru = 'Контрагент (создание)'");
		КонецЕсли;
		
	КонецЕсли;
	
	// перенести данные в форму
	ПрочитатьОбъектВФорму(ОбъектXDTO);
	
	Если Не ЗначениеЗаполнено(ID)
			И ЗначениеЗаполнено(ВнешнийОбъект)
			И ЗначениеЗаполнено(Параметры.Правило) Тогда
		
		Справочники.ПравилаИнтеграцииС1СДокументооборотом.ЗаполнитьФормуОбъектаДОПоПравилу(
			ВнешнийОбъект, ЭтотОбъект, Параметры.Правило);
		ИнтеграцияС1СДокументооборотБазоваяФункциональностьПереопределяемый.ЗаполнитьФормуИзПотребителя(
			ВнешнийОбъект, ЭтотОбъект);
		
		// Корректировка юр. / физ. лица.
		Если ЮрФизЛицо = НСтр("ru='Физическое лицо'") Тогда
			ЮрФизЛицоID = "ФизЛицо"; //@NON-NLS-1
			ЮрФизЛицоТип = "DMLegalPrivatePerson";
		ИначеЕсли ЮрФизЛицо = НСтр("ru='Юридическое лицо'") Тогда
			ЮрФизЛицоID = "ЮрЛицо"; //@NON-NLS-1
			ЮрФизЛицоТип = "DMLegalPrivatePerson";
		ИначеЕсли ЮрФизЛицо = НСтр("ru='Индивидуальный предприниматель'") Тогда
			ЮрФизЛицоID = "ИндивидуальныйПредприниматель"; //@NON-NLS-1
			ЮрФизЛицоТип = "DMLegalPrivatePerson";
		ИначеЕсли ЮрФизЛицо = НСтр("ru='Не резидент'") Тогда
			ЮрФизЛицоID = "ЮрЛицоНеРезидент"; //@NON-NLS-1
			ЮрФизЛицоТип = "DMLegalPrivatePerson";
		КонецЕсли;
		
	КонецЕсли;
	
	Если Параметры.ТолькоПросмотр = Истина Тогда
		ТолькоПросмотр = Истина;
	КонецЕсли;
	
	ОбновитьДекорацииСвязи();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "Документооборот_ВыбратьЗначениеИзВыпадающегоСпискаЗавершение" И Источник = ЭтотОбъект Тогда
		Если Параметр.Реквизит = "ЮрФизЛицо" И ЮрФизЛицоID <> ИсходноеЮрФизЛицоID Тогда
			УстановитьВидимость();
			ОбновитьЭлементыДополнительныхРеквизитов();
			ИсходноеЮрФизЛицоID = ЮрФизЛицоID;
		КонецЕсли;
		
	ИначеЕсли ИмяСобытия = "Документооборот_ДобавлениеСвязи" И Параметр.ID = ID Тогда
		ВнешнийОбъект = Параметр.Объект;
		ОбновитьДекорацииСвязи();
		
	ИначеЕсли ИмяСобытия = "Документооборот_УдалениеСвязи" И Параметр.ID = ID Тогда
		ВнешнийОбъект = Неопределено;
		ОбновитьДекорацииСвязи();
		
	ИначеЕсли ИмяСобытия = "Запись_ДокументооборотОбъект" И Параметр.ID = ID Тогда
		ОбновитьДекорацииСвязи();
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	Если ЗакрытиеСПараметром Тогда 
		Возврат;
	КонецЕсли;
	
	Если Модифицированность Тогда
		
		Оповещение = Новый ОписаниеОповещения("ПередЗакрытиемЗавершение", ЭтотОбъект);
		ТекстПредупреждения = "";
		ОбщегоНазначенияКлиент.ПоказатьПодтверждениеЗакрытияФормы(
			Оповещение, Отказ, ЗавершениеРаботы,,ТекстПредупреждения);
		
	Иначе
		
		Отказ = Истина;
		ПодключитьОбработчикОжидания("ЗакрытьСПараметром", 0.1, Истина);
	
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	УстановитьВидимость();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура СвязьОбъектНажатие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ПоказатьЗначение(, ВнешнийОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура СвязьСоздатьНажатие(Элемент)
	
	Если Не ЗначениеЗаполнено(ID) Тогда
		ЗаписатьОбъект();
	КонецЕсли;
	
	ОписаниеОповещения = Новый ОписаниеОповещения("СвязьСоздатьНажатиеЗавершение", ЭтотОбъект);
	Если ПравилаЗаполнения.Количество() = 1 Тогда
		ВыполнитьОбработкуОповещения(ОписаниеОповещения, ПравилаЗаполнения[0]);
	Иначе
		ПоказатьВыборИзМеню(ОписаниеОповещения, ПравилаЗаполнения, Элементы.СвязьСоздать);
	КонецЕсли; 
	
КонецПроцедуры

&НаКлиенте
Процедура СвязьВыбратьНажатие(Элемент)
	
	Если Не ЗначениеЗаполнено(ID) Тогда
		ЗаписатьОбъект();
	КонецЕсли;
	
	ОписаниеОповещения = Новый ОписаниеОповещения("СвязьВыбратьНажатиеЗавершение", ЭтотОбъект);
	Если ПравилаЗаполнения.Количество() = 1 Тогда
		ВыполнитьОбработкуОповещения(ОписаниеОповещения, ПравилаЗаполнения[0]);
	Иначе
		ПоказатьВыборИзМеню(ОписаниеОповещения, ПравилаЗаполнения, Элементы.СвязьВыбрать);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СвязьОчиститьНажатие(Элемент)
	
	Если Не ЗначениеЗаполнено(ВнешнийОбъект) Тогда
		Возврат;
	КонецЕсли;
	
	Оповещение = Новый ОписаниеОповещения("СвязьОчиститьНажатиеЗавершение", ЭтотОбъект);
	
	ТекстВопроса = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru = 'Очистить соответствие для
					|%1?'"),Строка(ВнешнийОбъект));
	
	Кнопки = Новый СписокЗначений;
	Кнопки.Добавить(КодВозвратаДиалога.Да,НСтр("ru='Очистить'"));
	Кнопки.Добавить(КодВозвратаДиалога.Нет,НСтр("ru='Не очищать'"));
	
	ПоказатьВопрос(Оповещение, ТекстВопроса, Кнопки,, КодВозвратаДиалога.Нет);
	
КонецПроцедуры

&НаКлиенте
Процедура ЮрФизЛицоПриИзменении(Элемент)
	
	Если ЮрФизЛицоID <> ИсходноеЮрФизЛицоID Тогда
		
		УстановитьВидимость();
		
		// Обработчик механизма "Свойства"
		ОбновитьЭлементыДополнительныхРеквизитов();
		
		ИсходноеЮрФизЛицоID = ЮрФизЛицоID;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЮрФизЛицоНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ИнтеграцияС1СДокументооборотКлиент.ВыбратьЗначениеИзВыпадающегоСписка("DMLegalPrivatePerson", "ЮрФизЛицо",
		ЭтотОбъект,,,Элементы.ЮрФизЛицо);
	
КонецПроцедуры

&НаКлиенте
Процедура ЮрФизЛицоОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, СтандартнаяОбработка)
	
	Если ЗначениеЗаполнено(Текст) Тогда
		ИнтеграцияС1СДокументооборотБазоваяФункциональностьВызовСервера.ДанныеДляАвтоПодбора(
			"DMLegalPrivatePerson", ДанныеВыбора, Текст, СтандартнаяОбработка);
		
		Если ДанныеВыбора.Количество() = 1 Тогда 
			ИнтеграцияС1СДокументооборотБазоваяФункциональностьКлиент.ОбработкаВыбораДанныхДляАвтоПодбора(
				"ЮрФизЛицо", ДанныеВыбора[0].Значение, СтандартнаяОбработка, ЭтотОбъект);
			СтандартнаяОбработка = Истина;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЮрФизЛицоАвтоПодбор(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, Ожидание, СтандартнаяОбработка)
	
	Если ЗначениеЗаполнено(Текст) Тогда
		ИнтеграцияС1СДокументооборотБазоваяФункциональностьВызовСервера.ДанныеДляАвтоПодбора(
			"DMLegalPrivatePerson",
			ДанныеВыбора,
			Текст,
			СтандартнаяОбработка);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЮрФизЛицоОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	ИнтеграцияС1СДокументооборотБазоваяФункциональностьКлиент.ОбработкаВыбораДанныхДляАвтоПодбора(
		"ЮрФизЛицо", ВыбранноеЗначение, СтандартнаяОбработка, ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура НаименованиеПриИзменении(Элемент)
	
	Если Не ЗначениеЗаполнено(ПолноеНаименование) Тогда 
		ПолноеНаименование = Наименование;
	КонецЕсли;
	
	Представление = Наименование;
	
КонецПроцедуры

&НаКлиенте
Процедура ОтветственныйНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ИнтеграцияС1СДокументооборотКлиент.ВыбратьПользователяИзДереваПодразделений("Ответственный", ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ФизЛицоНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ИнтеграцияС1СДокументооборотКлиент.ВыбратьЗначениеИзСписка("DMPrivatePerson", "ФизЛицо", ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ФизЛицоОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	ИнтеграцияС1СДокументооборотБазоваяФункциональностьКлиент.ОбработкаВыбораДанныхДляАвтоПодбора(
		"ФизЛицо", ВыбранноеЗначение, СтандартнаяОбработка, ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ФизЛицоАвтоПодбор(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, Ожидание, СтандартнаяОбработка)
	
	Если ЗначениеЗаполнено(Текст) Тогда
		ИнтеграцияС1СДокументооборотБазоваяФункциональностьВызовСервера.ДанныеДляАвтоПодбора(
			"DMPrivatePerson", ДанныеВыбора, Текст, СтандартнаяОбработка);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ФизЛицоОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, СтандартнаяОбработка)
	
	Если ЗначениеЗаполнено(Текст) Тогда
		ИнтеграцияС1СДокументооборотБазоваяФункциональностьВызовСервера.ДанныеДляАвтоПодбора("DMPrivatePerson", ДанныеВыбора, Текст, СтандартнаяОбработка);
		
		Если ДанныеВыбора.Количество() = 1 Тогда 
			ИнтеграцияС1СДокументооборотБазоваяФункциональностьКлиент.ОбработкаВыбораДанныхДляАвтоПодбора(
				"ФизЛицо", ДанныеВыбора[0].Значение, СтандартнаяОбработка, ЭтотОбъект);
			СтандартнаяОбработка = Истина;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОтветственныйОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, СтандартнаяОбработка)
	
	Если ЗначениеЗаполнено(Текст) Тогда
		ИнтеграцияС1СДокументооборотБазоваяФункциональностьВызовСервера.ДанныеДляАвтоПодбора("DMUser", ДанныеВыбора, Текст, СтандартнаяОбработка);
		
		Если ДанныеВыбора.Количество() = 1 Тогда
			ИнтеграцияС1СДокументооборотБазоваяФункциональностьКлиент.ОбработкаВыбораДанныхДляАвтоПодбора(
				"Ответственный", ДанныеВыбора[0].Значение, СтандартнаяОбработка, ЭтотОбъект);
			СтандартнаяОбработка = Истина;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОтветственныйАвтоПодбор(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, Ожидание, СтандартнаяОбработка)
	
	Если ЗначениеЗаполнено(Текст) Тогда
		ИнтеграцияС1СДокументооборотБазоваяФункциональностьВызовСервера.ДанныеДляАвтоПодбора("DMUser", ДанныеВыбора, Текст, СтандартнаяОбработка);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОтветственныйОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	ИнтеграцияС1СДокументооборотБазоваяФункциональностьКлиент.ОбработкаВыбораДанныхДляАвтоПодбора(
		"Ответственный", ВыбранноеЗначение, СтандартнаяОбработка, ЭтотОбъект);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСвойства

&НаКлиенте
Процедура СвойстваЗначениеПредставлениеНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ИнтеграцияС1СДокументооборотБазоваяФункциональностьКлиент.ВыбратьЗначениеДополнительногоРеквизита(
		ЭтотОбъект,
		Элемент,
		СтандартнаяОбработка);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ЗаписатьВыполнить(Команда)
	
	ЗаписатьОбъект();
	Модифицированность = Ложь;
	ИнтеграцияС1СДокументооборотКлиент.Оповестить_ЗаписьОбъекта(ЭтотОбъект, ВнешнийОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаписатьИЗакрыть(Команда)
	
	ЗаписатьОбъект();
	Модифицированность = Ложь;
	ИнтеграцияС1СДокументооборотКлиент.Оповестить_ЗаписьОбъекта(ЭтотОбъект, ВнешнийОбъект);
	Закрыть();
	
КонецПроцедуры

&НаКлиенте
Процедура Отправить(Команда)
	
	Если ЗначениеЗаполнено(ID) Тогда
		ИнтеграцияС1СДокументооборотКлиент.СоздатьБизнесПроцессПоОбъектуДО(ID, Тип, Наименование, ВнешнийОбъект);
	Иначе
		Оповещение = Новый ОписаниеОповещения("СоздатьБизнесПроцессЗавершение", ЭтотОбъект);
		ТекстВопроса = НСтр("ru = 'Данные еще не записаны.
							|Создание бизнес-процесса возможно только после записи данных.
							|Данные будут записаны.'");
		Кнопки = РежимДиалогаВопрос.ОКОтмена;
		ПоказатьВопрос(Оповещение, ТекстВопроса, Кнопки, 0);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ПередЗакрытиемЗавершение(Ответ, ПараметрыОповещения) Экспорт
	
	ЗаписатьОбъект();
	ИнтеграцияС1СДокументооборотКлиент.Оповестить_ЗаписьОбъекта(ЭтотОбъект, ВнешнийОбъект);
	ЗакрытьСПараметром();
	
КонецПроцедуры

// Вызывается после создания объекта ИС и фиксирует созданную связь.
//
&НаКлиенте
Процедура СвязьСоздатьНажатиеЗавершение(Результат, ПараметрыОповещения) Экспорт
	
	Если Результат <> Неопределено Тогда
		ИнтеграцияС1СДокументооборотКлиент.СоздатьИнтегрированныйОбъектПоДаннымФормы(
			ЭтотОбъект, Результат.Значение);
	КонецЕсли;
	
КонецПроцедуры

// Вызывается после выбора типа объекта ИС и начинает выбор объекта.
//
&НаКлиенте
Процедура СвязьВыбратьНажатиеЗавершение(Результат, ПараметрыОповещения) Экспорт
	
	Если Результат <> Неопределено Тогда
		ТипОбъектаИС = ИнтеграцияС1СДокументооборотВызовСервера.ЗначениеРеквизитаОбъекта(
			Результат.Значение,
			"ТипОбъектаИС");
		Оповещение = Новый ОписаниеОповещения("СвязьВыбратьНажатиеЗавершениеВыбора", ЭтотОбъект);
		ОткрытьФорму(ТипОбъектаИС + ".ФормаВыбора",, Элементы.СвязьВыбрать,,,, Оповещение);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СвязьВыбратьНажатиеЗавершениеВыбора(Результат, ПараметрыОповещения) Экспорт
	
	Если Результат <> Неопределено Тогда
		ИнтеграцияС1СДокументооборотБазоваяФункциональностьВызовСервера.ДобавитьСвязь(ID, Тип, Результат);
		ИнтеграцияС1СДокументооборотБазоваяФункциональностьКлиент.Оповестить_ДобавлениеСвязи(ID, Тип, Результат);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СвязьОчиститьНажатиеЗавершение(Ответ, ПараметрыОповещения) Экспорт
	
	Если Ответ = КодВозвратаДиалога.Да Тогда
		КэшВнешнийОбъект = ВнешнийОбъект;
		УдалитьСвязьНаСервере();
		ИнтеграцияС1СДокументооборотБазоваяФункциональностьКлиент.Оповестить_УдалениеСвязи(ID, Тип, КэшВнешнийОбъект);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьБизнесПроцессЗавершение(Ответ, ПараметрыОповещения) Экспорт
	
	Если Ответ = КодВозвратаДиалога.ОК Тогда
		ЗаписатьВыполнить(Неопределено);
		ИнтеграцияС1СДокументооборотКлиент.СоздатьБизнесПроцессПоОбъектуДО(ID, Тип, Наименование, ВнешнийОбъект);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗакрытьСПараметром()
	
	Если ЗначениеЗаполнено(ID) Тогда
		Результат = Новый Структура;
		Результат.Вставить("ID", ID);
		Результат.Вставить("type", Тип);
		Результат.Вставить("name", Наименование);
	Иначе
		Результат = Неопределено;
	КонецЕсли;
	
	ЗакрытиеСПараметром = Истина;
	Закрыть(Результат);
	
КонецПроцедуры

&НаСервере
Процедура ПрочитатьОбъектВФорму(ОбъектXDTO)
	
	// заполнение реквизитов
	Представление = ОбъектXDTO.objectID.presentation;
	ИНН = ОбъектXDTO.inn;
	КПП = ОбъектXDTO.kpp;
	КодПоОКПО = ОбъектXDTO.okpo;
	Если ОбъектXDTO.Свойства().Получить("registrationNumber") = Неопределено Тогда
		Элементы.РегистрационныйНомер.Видимость = Ложь;
		Элементы.РегистрационныйНомер2.Видимость = Ложь;
		Элементы.РегистрационныйНомер3.Видимость = Ложь;
	Иначе
		РегистрационныйНомер = ОбъектXDTO.registrationNumber;
	КонецЕсли;
	
	Комментарий = ОбъектXDTO.comment;
	ПолноеНаименование = ОбъектXDTO.fullName;
	Наименование = ОбъектXDTO.name;
	
	ИнтеграцияС1СДокументооборотБазоваяФункциональность.ЗаполнитьОбъектныйРеквизит(ЭтотОбъект,
		ОбъектXDTO.legalPrivatePerson, "ЮрФизЛицо", Ложь);
	ИнтеграцияС1СДокументооборотБазоваяФункциональность.ЗаполнитьОбъектныйРеквизит(ЭтотОбъект,
		ОбъектXDTO.privatePerson, "ФизЛицо", Ложь);
	ИнтеграцияС1СДокументооборотБазоваяФункциональность.ЗаполнитьОбъектныйРеквизит(ЭтотОбъект,
		ОбъектXDTO.responsible, "Ответственный", Ложь);
	
	ИсходноеЮрФизЛицоID = ЮрФизЛицоID;
	
	// дополнительные реквизиты
	Обработки.ИнтеграцияС1СДокументооборотБазоваяФункциональность.ПоместитьДополнительныеРеквизитыНаФорму(
		ЭтотОбъект,
		ОбъектXDTO);
	Обработки.ИнтеграцияС1СДокументооборотБазоваяФункциональность.УстановитьНавигационнуюСсылку(
		ЭтотОбъект,
		ОбъектXDTO);
	
	Если ЗначениеЗаполнено(ID) Тогда
		ПравилаЗаполнения = ИнтеграцияС1СДокументооборотВызовСервера.
			ПравилаЗаполненияИнтегрированныхОбъектовСписком(ОбъектXDTO);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьЭлементыДополнительныхРеквизитов()
	
	Прокси = ИнтеграцияС1СДокументооборотБазоваяФункциональностьПовтИсп.ПолучитьПрокси();
	Обработки.ИнтеграцияС1СДокументооборотБазоваяФункциональность.ПолучитьДополнительныеРеквизитыИПоместитьНаФорму(
		Прокси,
		ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьВидимость()
	
	Если ЮрФизЛицоID = ЗначениеФизЛицо Тогда
		Элементы.ГруппаЮрФизЛицо.ТекущаяСтраница = Элементы.ГруппаКакФизЛицо;
	ИначеЕсли ЮрФизЛицоID = ЗначениеИП Тогда
		Элементы.ГруппаЮрФизЛицо.ТекущаяСтраница = Элементы.ГруппаКакИП;
	ИначеЕсли ЮрФизЛицоID = ЗначениеНеРезидент Тогда
		Элементы.ГруппаЮрФизЛицо.ТекущаяСтраница = Элементы.ГруппаКакНерезидент;
	Иначе
		Элементы.ГруппаЮрФизЛицо.ТекущаяСтраница = Элементы.ГруппаКакЮрЛицо;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗаписатьОбъект()
	
	Прокси = ИнтеграцияС1СДокументооборотБазоваяФункциональностьПовтИсп.ПолучитьПрокси();
	ОбъектXDTO = ИнтеграцияС1СДокументооборотБазоваяФункциональность.СоздатьОбъект(
		Прокси,
		"DMCorrespondent",
		ВнешнийОбъект);
	
	Обработки.ИнтеграцияС1СДокументооборотБазоваяФункциональность.СформироватьДополнительныеСвойства(
		Прокси,
		ОбъектXDTO,
		ЭтотОбъект);
	
	СоответствиеРеквизитов = НовыйСоответствиеСвойствXDTOИРеквизитовОбъекта();
	
	Для Каждого СтрокаСоответствия Из СоответствиеРеквизитов Цикл
		Если ТипЗнч(СтрокаСоответствия.Значение) = Тип("Строка") Тогда
			ИнтеграцияС1СДокументооборот.ЗаполнитьСвойствоXDTOизСтруктурыРеквизитов(
				Прокси,
				ОбъектXDTO,
				СтрокаСоответствия.Значение,
				ЭтотОбъект,
				СтрокаСоответствия.Ключ);
		Иначе
			СписокXDTO = ОбъектXDTO[СтрокаСоответствия.Значение.Имя]; // СписокXDTO
			Для Каждого Строка Из ЭтотОбъект[СтрокаСоответствия.Ключ] Цикл
				СтрокаXDTO = ИнтеграцияС1СДокументооборотБазоваяФункциональность.СоздатьОбъект(Прокси, СтрокаСоответствия.Значение.Тип);
				Для Каждого СтрокаСоответствияТЧ Из СтрокаСоответствия.Значение.Реквизиты Цикл
					ИнтеграцияС1СДокументооборот.ЗаполнитьСвойствоXDTOизСтруктурыРеквизитов(
						Прокси,
						СтрокаXDTO,
						СтрокаСоответствияТЧ.Значение,
						Строка,
						СтрокаСоответствияТЧ.Ключ);
				КонецЦикла;
				СписокXDTO.Добавить(СтрокаXDTO);
			КонецЦикла;
		КонецЕсли;
	КонецЦикла;
	
	ОбъектXDTO.name = Наименование;
	
	Если ЗначениеЗаполнено(ID) И ЗначениеЗаполнено(Тип) Тогда // обновление
		
		ОбъектXDTO.objectID = ИнтеграцияС1СДокументооборотБазоваяФункциональность.СоздатьObjectID(Прокси, ID, Тип);
		
		Результат = ИнтеграцияС1СДокументооборотБазоваяФункциональность.ЗаписатьОбъект(Прокси, ОбъектXDTO);
		
		ОбъектXDTO = Результат.objects[0];
		
	Иначе // Создание
		
		ОбъектXDTO.objectID = ИнтеграцияС1СДокументооборотБазоваяФункциональность.СоздатьObjectID(Прокси);
		
		Запрос = ИнтеграцияС1СДокументооборотБазоваяФункциональность.СоздатьОбъект(Прокси, "DMCreateRequest");
		Запрос.object = ОбъектXDTO;
		
		Результат = ИнтеграцияС1СДокументооборотБазоваяФункциональность.ВыполнитьЗапрос(Прокси, Запрос);
		ИнтеграцияС1СДокументооборотБазоваяФункциональность.ПроверитьВозвратВебСервиса(Прокси, Результат);
		
		ОбъектXDTO = Результат.object;
		ID = ОбъектXDTO.objectID.ID;
		Тип = ОбъектXDTO.objectID.type;
		
	КонецЕсли;
	
	Если ТипЗнч(КонтрольОтправкиФайлов) = Тип("ХранилищеЗначения") Тогда
		Для Каждого Строка Из КонтрольОтправкиФайлов.Получить() Цикл
			РегистрыСведений.КонтрольОтправкиФайловВ1СДокументооборот.СохранитьХешСуммуВерсииФайла(
				Строка.Источник,
				Строка.ИмяФайла,
				Строка.ТабличныйДокумент)
		КонецЦикла;
	КонецЕсли;
	
	// Перечитать объект в форму
	ПрочитатьОбъектВФорму(ОбъектXDTO);
	
КонецПроцедуры

&НаСервере
Функция НовыйСоответствиеСвойствXDTOИРеквизитовОбъекта()
	
	СоответствиеРеквизитов = Новый Соответствие;
	СоответствиеРеквизитов.Вставить("Наименование", "name");
	СоответствиеРеквизитов.Вставить("ЮрФизЛицо", "legalPrivatePerson");
	СоответствиеРеквизитов.Вставить("ИНН", "inn");
	СоответствиеРеквизитов.Вставить("КПП", "kpp");
	СоответствиеРеквизитов.Вставить("КодПоОКПО", "okpo");
	СоответствиеРеквизитов.Вставить("РегистрационныйНомер", "registrationNumber");
	СоответствиеРеквизитов.Вставить("Комментарий", "comment");
	СоответствиеРеквизитов.Вставить("ПолноеНаименование", "fullName");
	СоответствиеРеквизитов.Вставить("ФизЛицо", "privatePerson");
	СоответствиеРеквизитов.Вставить("Ответственный", "responsible");
	
	Возврат СоответствиеРеквизитов;
	
КонецФункции

&НаСервере
Процедура УдалитьСвязьНаСервере()
	
	ИнтеграцияС1СДокументооборотБазоваяФункциональностьВызовСервера.УдалитьСвязь(ID, Тип, ВнешнийОбъект);
	ВнешнийОбъект = Неопределено;
	ОбновитьДекорацииСвязи();
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьДекорацииСвязи()
	
	ДокументЗаполнен = ЗначениеЗаполнено(ВнешнийОбъект);
	
	Если ДокументЗаполнен Тогда
		
		МетаданныеОбъекта = ВнешнийОбъект.Метаданные();
		Если ОбщегоНазначения.ЭтоСправочник(МетаданныеОбъекта) Тогда
			ВнешнийОбъектПредставление = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку("%1 (%2)",
				Строка(ВнешнийОбъект), МетаданныеОбъекта.Представление());
		Иначе
			ВнешнийОбъектПредставление = Строка(ВнешнийОбъект);
		КонецЕсли;
		
	КонецЕсли;
	
	Элементы.СвязьОбъект.Видимость = ДокументЗаполнен;
	Элементы.СвязьОчистить.Видимость = ДокументЗаполнен;
	
	Элементы.СвязьВыбрать.Видимость = Не ДокументЗаполнен;
	
	Элементы.ГруппаСвязь.Видимость = (ID <> "");
	
	Если Не ДокументЗаполнен Тогда
		
		Если ПравилаЗаполнения.Количество() > 0 Тогда
			ВозможноСозданиеОбъекта = Истина;
		Иначе
			ВозможноСозданиеОбъекта = Ложь;
		КонецЕсли;
		
		Если ПравилаЗаполнения.Количество() = 1 Тогда
			ТекстЗаголовкаСоздать = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru='создать %1'"), НРег(ПравилаЗаполнения[0].Представление));
		ИначеЕсли ПравилаЗаполнения.Количество() = 0 Тогда
			Элементы.ГруппаСвязь.Видимость = Ложь;
			Возврат;
		Иначе
			ТекстЗаголовкаСоздать = НСтр("ru='создать...'");
		КонецЕсли;
		
		Элементы.СвязьСоздать.Заголовок = ТекстЗаголовкаСоздать;
		
	КонецЕсли;
	
	Элементы.СвязьСоздать.Видимость = Не ДокументЗаполнен И ВозможноСозданиеОбъекта;
	Элементы.СвязьИли.Видимость = Не ДокументЗаполнен И ВозможноСозданиеОбъекта;
	
КонецПроцедуры

#КонецОбласти