﻿
#Область ОписаниеПеременных

&НаКлиенте
Перем КэшированныеЗначения;

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьУсловноеОформление();
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	ИнтеграцияМДЛППереопределяемый.НастроитьПодключаемоеОборудование(ЭтотОбъект);
	
	//ЛОГ
	Если ИспользоватьПодключаемоеОборудование Тогда
		Логи = Логи + РазделительЛогов() + НСтр("ru = 'Признак использования подключаемого оборудования установлен.'");
	КонецЕсли;
	//Конец ЛОГ
	
	ГосударственныеИнформационныеСистемыПереопределяемый.ЗаполнитьСлужебныеРеквизитыВКоллекции(ЭтотОбъект, Объект.Товары);
	
	ПараметрыУказанияСерий = ГосударственныеИнформационныеСистемыПереопределяемый.ПараметрыУказанияСерийФормыОбъекта(Объект, Обработки.АнализСканированияШтрихкодовМДЛП);
	
	ОбновитьСтатусыЗаполненияНомеровУпаковок(Объект);
	
	ГосударственныеИнформационныеСистемыПереопределяемый.УстановитьПараметрыВыбораНоменклатуры(ЭтотОбъект);
	ГосударственныеИнформационныеСистемыПереопределяемый.УстановитьСвязиПараметровВыбораСНоменклатурой(ЭтотОбъект, Элементы.ТоварыХарактеристика.Имя);
	ГосударственныеИнформационныеСистемыПереопределяемый.УстановитьСвязиПараметровВыбораСНоменклатурой(ЭтотОбъект, Элементы.ТоварыСерия.Имя);
	ГосударственныеИнформационныеСистемыПереопределяемый.УстановитьСвязиПараметровВыбораСНоменклатурой(ЭтотОбъект, Элементы.ТоварыУпаковка.Имя);
	
	Элементы.ТоварыХарактеристика.Видимость = ИнтеграцияМДЛП.ИспользоватьХарактеристикиНоменклатуры();
	Элементы.ТоварыСерия.Видимость = ИнтеграцияМДЛП.ИспользоватьСерииНоменклатуры();
	Элементы.ТоварыУпаковка.Видимость = ИнтеграцияМДЛП.ИспользоватьУпаковкиНоменклатуры();
	
	СобытияФормМДЛППереопределяемый.ПриСозданииНаСервере(ЭтотОбъект, Отказ, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// ПодключаемоеОборудование.СканерыШтрихкода
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("ПоддержкаОборудования.ПодключаемоеОборудование.УстройстваВвода") Тогда
		ПоддерживаемыеТипыПодключаемогоОборудования = "СканерШтрихкода";
		МодульМенеджерОборудованияКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("МенеджерОборудованияКлиент");
		ОповещениеПриПодключении = Новый ОписаниеОповещения("ПодключитьОборудованиеЗавершениеПоУмолчанию", ЭтотОбъект);
		МодульМенеджерОборудованияКлиент.НачатьПодключениеОборудованиеПриОткрытииФормы(Неопределено, ЭтотОбъект, ПоддерживаемыеТипыПодключаемогоОборудования);
	КонецЕсли;
	// Конец ПодключаемоеОборудование.СканерыШтрихкода
	
	// ЛОГИ
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("ПоддержкаОборудования.ПодключаемоеОборудование.УстройстваВвода") Тогда
		Логи = Логи + РазделительЛогов() + НСтр("ru = 'Подсистема ""СканерыШтрихкода"" существует.'");
	Иначе
		Логи = Логи + РазделительЛогов() + НСтр("ru = 'Подсистема ""СканерыШтрихкода"" не существует. Сканирование невозможно.'");
	КонецЕсли;
	// Конец ЛОГИ
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	ВводДоступен = ВводДоступен();
	
	// ЛОГИ
	Логи = Логи + РазделительЛогов() + НСтр("ru = 'Событие ОбработкаОповещения начало.'");
	Логи = Логи + РазделительЭлементовЛога() + НСтр("ru = '	Источник      - '") + Источник;
	Логи = Логи + РазделительЭлементовЛога() + НСтр("ru = '	Ввод доступен - '") + ВводДоступен;
	Логи = Логи + РазделительЭлементовЛога() + НСтр("ru = '	Имя события   - '") + ИмяСобытия;
	// Конец ЛОГИ
	
	Если Источник = "ПодключаемоеОборудование" И ВводДоступен И Не ТолькоПросмотр Тогда
		Если ИмяСобытия = "ScanData" Тогда
			
			ОбработатьШтрихкоды(ИнтеграцияМДЛПКлиент.ПреобразоватьДанныеСоСканераВМассив(Параметр));
			
		КонецЕсли;
	КонецЕсли;
	
	СобытияФормМДЛПКлиентПереопределяемый.ОбработкаОповещения(ЭтотОбъект, ИмяСобытия, Параметр, Источник);
	
	// ЛОГИ
	Логи = Логи + РазделительЭлементовЛога() + НСтр("ru = 'Событие ОбработкаОповещения конец.'");
	// Конец ЛОГИ
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	
	// ПодключаемоеОборудование
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("ПоддержкаОборудования.ПодключаемоеОборудование") Тогда
		МодульМенеджерОборудованияКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("МенеджерОборудованияКлиент");
		МодульМенеджерОборудованияКлиент.НачатьОтключениеОборудованиеПриЗакрытииФормы(Неопределено, ЭтотОбъект);
	КонецЕсли;
	// Конец ПодключаемоеОборудование
	
КонецПроцедуры

#КонецОбласти // ОбработчикиСобытийФормы

#Область ОбработчикиСобытийЭлементовТабличнойЧастиТовары

&НаКлиенте
Процедура ТоварыПриАктивизацииСтроки(Элемент)
	
	ТекущиеДанные = Элементы.Товары.ТекущиеДанные;
	
	Если ТекущиеДанные <> Неопределено Тогда
		УстановитьОтборНомеровУпаковок(ТекущиеДанные.ИдентификаторСтроки);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	
	Если НоваяСтрока Тогда
		ТекущиеДанные = Элемент.ТекущиеДанные;
		ТекущиеДанные.ИдентификаторСтроки = Строка(Новый УникальныйИдентификатор);
		УстановитьОтборНомеровУпаковок(ТекущиеДанные.ИдентификаторСтроки);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыПередУдалением(Элемент, Отказ)
	
	СобытияФормМДЛПКлиент.ТоварыПередУдалением(ЭтотОбъект, Элемент, Отказ);
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыНоменклатураНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ТекущаяСтрока = Элементы.Товары.ТекущиеДанные;
	СобытияФормМДЛПКлиентПереопределяемый.НачалоВыбораНоменклатуры(ЭтотОбъект, ТекущаяСтрока, Элемент, ДанныеВыбора, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыНоменклатураПриИзменении(Элемент)
	
	ТекущаяСтрока = Элементы.Товары.ТекущиеДанные;
	
	ПараметрыЗаполнения = ИнтеграцияМДЛПКлиентСервер.ПараметрыЗаполненияТабличнойЧасти();
	ПараметрыЗаполнения.ПересчитатьКоличествоЕдиниц   = Истина;
	ПараметрыЗаполнения.ПроверитьСериюРассчитатьСтатус = Истина;
	ПараметрыЗаполнения.ПараметрыУказанияСерий = ПараметрыУказанияСерий;
	
	СобытияФормМДЛПКлиентПереопределяемый.ПриИзмененииНоменклатуры(ЭтотОбъект, ТекущаяСтрока, КэшированныеЗначения, ПараметрыЗаполнения);
	
	ОбновитьСтатусЗаполненияУпаковокВСтроке(ТекущаяСтрока);
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыХарактеристикаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ТекущаяСтрока = Элементы.Товары.ТекущиеДанные;
	
	СобытияФормМДЛПКлиентПереопределяемый.НачалоВыбораХарактеристики(ЭтотОбъект, ТекущаяСтрока, Элемент, ДанныеВыбора, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыХарактеристикаПриИзменении(Элемент)
	
	ТекущаяСтрока = Элементы.Товары.ТекущиеДанные;
	
	ПараметрыЗаполнения = ИнтеграцияМДЛПКлиентСервер.ПараметрыЗаполненияТабличнойЧасти();
	ПараметрыЗаполнения.ПересчитатьКоличествоЕдиниц   = Истина;
	
	СобытияФормМДЛПКлиентПереопределяемый.ПриИзмененииХарактеристики(ЭтотОбъект, ТекущаяСтрока, КэшированныеЗначения, ПараметрыЗаполнения);
	
	ОбновитьСтатусЗаполненияУпаковокВСтроке(ТекущаяСтрока);
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыСерияНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ТекущаяСтрока = Элементы.Товары.ТекущиеДанные;
	СобытияФормМДЛПКлиентПереопределяемый.НачалоВыбораСерии(ЭтотОбъект, ТекущаяСтрока, ПараметрыУказанияСерий, Элемент, ДанныеВыбора, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыСерияПриИзменении(Элемент)
	
	ТекущаяСтрока = Элементы.Товары.ТекущиеДанные;
	
	ПараметрыЗаполнения = ИнтеграцияМДЛПКлиентСервер.ПараметрыЗаполненияТабличнойЧасти();
	ПараметрыЗаполнения.ПараметрыУказанияСерий = ПараметрыУказанияСерий;
	
	СобытияФормМДЛПКлиентПереопределяемый.ПриИзмененииСерии(ЭтотОбъект, ТекущаяСтрока, КэшированныеЗначения, ПараметрыЗаполнения);
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыУпаковкаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ТекущаяСтрока = Элементы.Товары.ТекущиеДанные;
	
	СобытияФормМДЛПКлиентПереопределяемый.НачалоВыбораУпаковки(ЭтотОбъект, ТекущаяСтрока, Элемент, ДанныеВыбора, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыУпаковкаПриИзменении(Элемент)
	
	ТекущаяСтрока = Элементы.Товары.ТекущиеДанные;
	
	ПараметрыЗаполнения = ИнтеграцияМДЛПКлиентСервер.ПараметрыЗаполненияТабличнойЧасти();
	ПараметрыЗаполнения.ПересчитатьКоличествоЕдиниц = Истина;
	
	СобытияФормМДЛПКлиентПереопределяемый.ПриИзмененииУпаковки(ЭтотОбъект, ТекущаяСтрока, КэшированныеЗначения, ПараметрыЗаполнения);
	
	ОбновитьСтатусЗаполненияУпаковокВСтроке(ТекущаяСтрока);
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыКоличествоУпаковокПриИзменении(Элемент)
	
	ТекущаяСтрока = Элементы.Товары.ТекущиеДанные;
	
	ПараметрыЗаполнения = ИнтеграцияМДЛПКлиентСервер.ПараметрыЗаполненияТабличнойЧасти();
	ПараметрыЗаполнения.ПересчитатьКоличествоЕдиниц = Истина;
	
	СобытияФормМДЛПКлиентПереопределяемый.ПриИзмененииКоличестваУпаковок(ЭтотОбъект, ТекущаяСтрока, КэшированныеЗначения, ПараметрыЗаполнения);
	
	ОбновитьСтатусЗаполненияУпаковокВСтроке(ТекущаяСтрока);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТабличнойЧастиНомераУпаковок

&НаКлиенте
Процедура НомераУпаковокПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	
	ТекущиеДанные = Элементы.Товары.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		ПоказатьПредупреждение(, НСтр("ru = 'Не выбрана строка с товаром.'"));
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	ПараметрыОтбора = Новый Структура("ИдентификаторСтроки", ТекущиеДанные.ИдентификаторСтроки);
	СтрокиУпаковок = Объект.НомераУпаковок.НайтиСтроки(ПараметрыОтбора);
	
	Если ТекущиеДанные.Количество <= СтрокиУпаковок.Количество() Тогда
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура НомераУпаковокПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	
	Если НоваяСтрока Тогда
		ТекущиеДанные = Элемент.ТекущиеДанные;
		Если Копирование Тогда
			ТекущиеДанные.НомерКиЗ = "";
		Иначе
			ТекущиеДанные.ИдентификаторСтроки = Элементы.Товары.ТекущиеДанные.ИдентификаторСтроки;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура НомераУпаковокПриОкончанииРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования)
	
	Если НоваяСтрока И Не ОтменаРедактирования Тогда
		ОбновитьСтатусЗаполненияУпаковокВСтроке(Элементы.Товары.ТекущиеДанные);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура НомераУпаковокПередУдалением(Элемент, Отказ)
	
	ПодключитьОбработчикОжидания("ОбновитьСтатусыЗаполненияНомеровУпаковокОтложено", 0.2, Истина);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТабличнойЧастиТранспортныеУпаковки

&НаКлиенте
Процедура ТранспортныеУпаковкиПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	
	Если НоваяСтрока Тогда
		ТекущиеДанные = Элемент.ТекущиеДанные;
		ТекущиеДанные.НомерУпаковки = "";
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОтображатьВсеНомераУпаковок(Команда)
	
	ПоказыватьВсеНомераУпаковок = Не ПоказыватьВсеНомераУпаковок;
	Элементы.ТоварыОтображатьВсеНомераУпаковок.Пометка = Не ПоказыватьВсеНомераУпаковок;
	
	УстановитьОтборНомеровУпаковок(ИдентификаторТекущейСтроки);
	
КонецПроцедуры

&НаКлиенте
Процедура РучнойВводШтрихкода(Команда)
	
	// ЛОГИ
	Логи = Логи + РазделительЛогов() + НСтр("ru = 'Событие РучнойВводШтрихкода начало.'");
	// Конец ЛОГИ
	
	Обработчик = Новый ОписаниеОповещения("РучнойВводШтрихкодаЗавершение", ЭтотОбъект);
	СобытияФормМДЛПКлиент.ПоказатьВводШтрихкода(Обработчик);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьДанныеИзТСД(Команда)
	
	// ЛОГИ
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("ПоддержкаОборудования.ПодключаемоеОборудование.ТерминалыСбораДанных") Тогда
		Логи = Логи + РазделительЛогов() + НСтр("ru = 'Подсистема ""ТерминалыСбораДанных"" существует.'");
		Логи = Логи + РазделительЭлементовЛога() + НСтр("ru = 'Событие ЗагрузитьДанныеИзТСД начало.'");
	Иначе
		Логи = Логи + РазделительЛогов() + НСтр("ru = 'Подсистема ""ТерминалыСбораДанных"" не существует. Сканирование невозможно.'");
	КонецЕсли;
	// Конец ЛОГИ
	
	ОчиститьСообщения();
	
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("ПоддержкаОборудования.ПодключаемоеОборудование.ТерминалыСбораДанных") Тогда
		МодульОборудованиеТерминалыСбораДанныхКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ОборудованиеТерминалыСбораДанныхКлиент");
		МодульОборудованиеТерминалыСбораДанныхКлиент.НачатьЗагрузкуДанныеИзТСД(
			Новый ОписаниеОповещения("ЗагрузитьИзТСДЗавершение", ЭтотОбъект),
			УникальныйИдентификатор);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОчиститьШтрихкоды(Команда)
	
	ИмяТаблицы = СтрЗаменить(Команда.Имя, "ОчиститьШтрихкоды", "");
	Таблица = ЭтотОбъект[ИмяТаблицы];
	Если ТипЗнч(Таблица) = Тип("ДанныеФормыКоллекция") Тогда
		Таблица.Очистить();
	ИначеЕсли ТипЗнч(Таблица) = Тип("ДанныеФормыДерево") Тогда
		Таблица.ПолучитьЭлементы().Очистить()
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОчиститьЛоги(Команда)
	
	Логи = Неопределено;
	
КонецПроцедуры

&НаКлиенте
Процедура СохранитьРезультат(Команда)
	
	АдресДанных = ПолучитьДанныеДляСохранения();
	
	ПараметрыСохранения = ФайловаяСистемаКлиент.ПараметрыСохраненияФайла();
	ПараметрыСохранения.Диалог.Заголовок = НСтр("ru = 'Сохранение результатов'");
	ПараметрыСохранения.Диалог.Фильтр = "Файл результатов проверки сканирования (*.js)|*.js";
	
	Оповестить = Новый ОписаниеОповещения("СохранитьРезультатЗавершение", ЭтотОбъект);
	ФайловаяСистемаКлиент.СохранитьФайл(Оповестить, АдресДанных,, ПараметрыСохранения);
	
	Модифицированность = Ложь;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьРезультат(Команда)
	
	АдресДанных = Неопределено;
	
	ПараметрыЗагрузки = ФайловаяСистемаКлиент.ПараметрыЗагрузкиФайла();
	ПараметрыЗагрузки.Диалог.Заголовок = НСтр("ru = 'Загрузка результатов'");
	ПараметрыЗагрузки.Диалог.Фильтр = "Файл результатов проверки сканирования (*.js)|*.js";
	
	Оповестить = Новый ОписаниеОповещения("ЗагрузитьРезультатЗавершение", ЭтотОбъект);
	ФайловаяСистемаКлиент.ЗагрузитьФайл(Оповестить, ПараметрыЗагрузки,, АдресДанных);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьРезультатЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = Неопределено Тогда
		ПоказатьОповещениеПользователя(НСтр("ru = 'Загрузка результатов'"),, НСтр("ru = 'Не удалось загрузить файл'"));
		Возврат;
	КонецЕсли;
	
	ЗагрузитьСохраненныеДанные(Результат.Хранение);
	
	ПоказатьОповещениеПользователя(НСтр("ru = 'Загрузка результатов'"),, НСтр("ru = 'Файл результатов загружен'"));
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормМДЛПКлиентПереопределяемый.ВыполнитьПереопределяемуюКоманду(ЭтотОбъект, Команда);
	
КонецПроцедуры

#КонецОбласти // ОбработчикиКомандФормы

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	ГосударственныеИнформационныеСистемыПереопределяемый.УстановитьУсловноеОформлениеЕдиницИзмерения(ЭтотОбъект);
	ГосударственныеИнформационныеСистемыПереопределяемый.УстановитьУсловноеОформлениеХарактеристикНоменклатуры(ЭтотОбъект);
	ГосударственныеИнформационныеСистемыПереопределяемый.УстановитьУсловноеОформлениеСерийНоменклатуры(ЭтотОбъект);
	
	//
	Элемент = УсловноеОформление.Элементы.Добавить();
	Элемент.Поля.Элементы.Добавить().Поле = Новый ПолеКомпоновкиДанных(Элементы.НомераУпаковок.Имя);
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(Элемент.Отбор,
		"Объект.НомераУпаковок.ИдентификаторСтроки", Новый ПолеКомпоновкиДанных("ИдентификаторТекущейСтроки"), ВидСравненияКомпоновкиДанных.НеРавно);
	
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ЦветТекстаНеТребуетВниманияМДЛП);
	
	
	//
	Элемент = УсловноеОформление.Элементы.Добавить();
	Элемент.Поля.Элементы.Добавить().Поле = Новый ПолеКомпоновкиДанных(Элементы.ДанныеШтрихкодовКИЗКонтрольныйСимвол.Имя);
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(Элемент.Отбор,
		"ДанныеШтрихкодовКИЗ.КонтрольныйСимволОтличается", "1", ВидСравненияКомпоновкиДанных.Равно);
	
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветФона", ЦветаСтиля.ЦветФонаПредупреждения);
	
	//
	Элемент = УсловноеОформление.Элементы.Добавить();
	Элемент.Поля.Элементы.Добавить().Поле = Новый ПолеКомпоновкиДанных(Элементы.ДанныеШтрихкодовТранспортныхУпаковокКонтрольныйСимвол.Имя);
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(Элемент.Отбор,
		"ДанныеШтрихкодовТранспортныхУпаковок.КонтрольныйСимволОтличается", "1", ВидСравненияКомпоновкиДанных.Равно);
	
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветФона", ЦветаСтиля.ЦветФонаПредупреждения);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьСтатусыЗаполненияНомеровУпаковокОтложено()
	
	ОбновитьСтатусыЗаполненияНомеровУпаковок(Объект);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ОбновитьСтатусыЗаполненияНомеровУпаковок(Объект)
	
	Для Каждого СтрокаТЧ Из Объект.Товары Цикл
		
		ПараметрыОтбора = Новый Структура("ИдентификаторСтроки", СтрокаТЧ.ИдентификаторСтроки);
		СтрокиНомеров = Объект.НомераУпаковок.НайтиСтроки(ПараметрыОтбора);
		Если СтрокиНомеров.Количество() = СтрокаТЧ.Количество Тогда
			СтрокаТЧ.СтатусЗаполненияУпаковок = 1;
		Иначе
			СтрокаТЧ.СтатусЗаполненияУпаковок = 0;
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьСтатусЗаполненияУпаковокВСтроке(ТекущиеДанные)
	
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыОтбора = Новый Структура("ИдентификаторСтроки", ТекущиеДанные.ИдентификаторСтроки);
	СтрокиНомеров = Объект.НомераУпаковок.НайтиСтроки(ПараметрыОтбора);
	
	Если СтрокиНомеров.Количество() = ТекущиеДанные.Количество Тогда
		ТекущиеДанные.СтатусЗаполненияУпаковок = 1;
	Иначе
		ТекущиеДанные.СтатусЗаполненияУпаковок = 0;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьОтборНомеровУпаковок(ИдентификаторСтроки)
	
	Если ИдентификаторТекущейСтроки <> ИдентификаторСтроки Тогда
		ИдентификаторТекущейСтроки = ИдентификаторСтроки;
	КонецЕсли;
	
	Если Не ПоказыватьВсеНомераУпаковок Тогда
		ИнтеграцияМДЛПКлиент.УстановитьОтборСтрок(
			Элементы.НомераУпаковок.ОтборСтрок,
			Новый Структура("ИдентификаторСтроки", ИдентификаторТекущейСтроки));
	Иначе
		ИнтеграцияМДЛПКлиент.СнятьОтборСтрок(Элементы.НомераУпаковок.ОтборСтрок, "ИдентификаторСтроки");
	КонецЕсли;
	
КонецПроцедуры

#Область ОбработкаШтрихкодов

&НаКлиенте
Процедура РучнойВводШтрихкодаЗавершение(ДанныеШтрихкода, ДополнительныеПараметры) Экспорт
	
	ОбработатьШтрихкоды(ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(ДанныеШтрихкода));
	
	// ЛОГИ
	Логи = Логи + РазделительЭлементовЛога() + НСтр("ru = 'Событие РучнойВводШтрихкода конец.'");
	// Конец ЛОГИ
	
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьИзТСДЗавершение(РезультатВыполнения, ДополнительныеПараметры) Экспорт
	
	// ЛОГИ
	Если РезультатВыполнения.Результат Тогда
		Логи = Логи + РазделительЭлементовЛога() + НСтр("ru = '	Данные из ТСД получены.'");
	Иначе
		Логи = Логи + РазделительЭлементовЛога() + НСтр("ru = '	Не удалось получить данные'");
	КонецЕсли;
	// Конец ЛОГИ
	
	Если РезультатВыполнения.Результат Тогда
		ОбработатьШтрихкоды(РезультатВыполнения.ТаблицаТоваров);
	КонецЕсли;
	
	// ЛОГИ
	Логи = Логи + РазделительЭлементовЛога() + НСтр("ru = 'Событие ЗагрузитьДанныеИзТСД конец.'");
	// Конец ЛОГИ
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработатьШтрихкоды(ДанныеШтрихкодов)
	
	// ЛОГИ
	Логи = Логи + РазделительЭлементовЛога() + НСтр("ru = '	Событие ОбработатьШтрихкоды начало.'");
	Логи = Логи + РазделительЭлементовЛога() + НСтр("ru = '		Данные штрихкодов:'");
	Для Каждого ДанныеШтрихкода Из ДанныеШтрихкодов Цикл
		Логи = Логи + РазделительЭлементовЛога() + Символы.Таб + Символы.Таб + Символы.Таб + СтрЗаменить(ДанныеШтрихкода.Штрихкод, Символ(29), " 'GS' ");
	КонецЦикла;
	Логи = Логи + РазделительЭлементовЛога() + НСтр("ru = '		Детальную информацию по штрихкодам см. в соответствующих таблицах.'");
	// Конец ЛОГИ
	
	ДанныеШтрихкодовПоТипам = ИнтеграцияМДЛПКлиентСервер.РазобратьШтрихкодыПоТипам(ДанныеШтрихкодов);
	
	ЗаполнитьДанныеШтрихкодовSGTIN(ДанныеШтрихкодовПоТипам.НомераКиЗ);
	ЗаполнитьДанныеШтрихкодовSSCC(ДанныеШтрихкодовПоТипам.НомераТранспортныхУпаковок);
	ЗаполнитьДанныеНеизвестныхШтрихкодов(ДанныеШтрихкодовПоТипам.НеизвестныеШтрихкоды);
	
	ПараметрыЗаполнения = ИнтеграцияМДЛПКлиентСервер.ПараметрыЗаполненияТабличнойЧасти();
	ПараметрыЗаполнения.ПересчитатьКоличествоЕдиниц = Истина;
	
	ДанныеДляОбработки = СобытияФормМДЛПКлиентПереопределяемый.ПодготовитьДанныеДляОбработкиШтрихкодов(
		ЭтотОбъект, ДанныеШтрихкодовПоТипам, КэшированныеЗначения, ПараметрыЗаполнения);
	
	ИнтеграцияМДЛПСлужебныйКлиент.ЗаполнитьДокументПоШтрихкодам(ЭтотОбъект, Объект, КэшированныеЗначения, ДанныеШтрихкодовПоТипам.НомераКиЗ, ДанныеШтрихкодовПоТипам.НомераТранспортныхУпаковок);
	
	ОбработатьПолученныеШтрихкодыСервер(ДанныеДляОбработки, КэшированныеЗначения);
	
	СобытияФормМДЛПКлиентПереопределяемый.ПослеОбработкиШтрихкодов(
		ЭтотОбъект,
		ДанныеДляОбработки,
		КэшированныеЗначения);
	
	// ЛОГИ
	Логи = Логи + РазделительЭлементовЛога() + НСтр("ru = '	Событие ОбработатьШтрихкоды конец.'");
	// Конец ЛОГИ
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьДанныеШтрихкодовSGTIN(НомераКиЗ)
	
	ЭлементыДанных = ДанныеШтрихкодовКИЗ.ПолучитьЭлементы();
	Для Каждого НомерУпаковки Из НомераКиЗ Цикл
		
		ЭлементДанных = ЭлементыДанных.Добавить();
		ЗаполнитьЗначенияСвойств(ЭлементДанных, НомерУпаковки);
		
		//ЭлементДанных.Тип
		ЭлементДанных.ШтрихкодGS = СтрЗаменить(ПолучитьСтрокуИзДвоичныхДанных(Base64Значение(НомерУпаковки.ШтрихкодBase64)), Символ(29), " 'GS' ");
		ЭлементДанных.КонтрольныйСимвол = МенеджерОборудованияКлиентСервер.РассчитатьКонтрольныйСимволGTIN(НомерУпаковки.GTIN);
		ЭлементДанных.КонтрольныйСимволОтличается = Строка(Число(ЭлементДанных.КонтрольныйСимвол <> Прав(НомерУпаковки.GTIN, 1)));
		
		Если НомерУпаковки.Свойство("ДанныеШтрихкода") Тогда
			ПодчененныеЭлементыДанных = ЭлементДанных.ПолучитьЭлементы();
			Для Каждого ДанныеТекущегоШтрихкода Из НомерУпаковки.ДанныеШтрихкода Цикл
				ЗаполнитьЗначенияСвойств(ПодчененныеЭлементыДанных.Добавить(), ДанныеТекущегоШтрихкода);
			КонецЦикла;
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьДанныеШтрихкодовSSCC(НомераТранспортныхУпаковок)
	
	ЭлементыДанных = ДанныеШтрихкодовТранспортныхУпаковок.ПолучитьЭлементы();
	Для Каждого НомерУпаковки Из НомераТранспортныхУпаковок Цикл
		
		ЭлементДанных = ЭлементыДанных.Добавить();
		ЗаполнитьЗначенияСвойств(ЭлементДанных, НомерУпаковки);
		
		ЭлементДанных.КонтрольныйСимвол = МенеджерОборудованияКлиентСервер.РассчитатьКонтрольныйСимволGTIN(НомерУпаковки.SSCC);
		ЭлементДанных.КонтрольныйСимволОтличается = Строка(Число(ЭлементДанных.КонтрольныйСимвол <> Прав(НомерУпаковки.SSCC, 1)));
		
		Если НомерУпаковки.Свойство("ДанныеШтрихкода") Тогда
			ПодчененныеЭлементыДанных = ЭлементДанных.ПолучитьЭлементы();
			Для Каждого ДанныеТекущегоШтрихкода Из НомерУпаковки.ДанныеШтрихкода Цикл
				ЗаполнитьЗначенияСвойств(ПодчененныеЭлементыДанных.Добавить(), ДанныеТекущегоШтрихкода);
			КонецЦикла;
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьДанныеНеизвестныхШтрихкодов(НеизвестныеШтрихкоды)
	
	Для Каждого Данные Из НеизвестныеШтрихкоды Цикл
		ЗаполнитьЗначенияСвойств(ДанныеНеизвестныхШтрихкодов.Добавить(), Данные);
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ОбработатьПолученныеШтрихкодыСервер(ДанныеДляОбработки, КэшированныеЗначения)
	
	СобытияФормМДЛППереопределяемый.ОбработатьШтрихкоды(ЭтотОбъект, ДанныеДляОбработки, КэшированныеЗначения);
	
	ОбновитьСтатусыЗаполненияНомеровУпаковок(Объект);
	
	ГосударственныеИнформационныеСистемыПереопределяемый.ЗаполнитьСлужебныеРеквизитыВКоллекции(ЭтотОбъект, Объект.Товары);
	
КонецПроцедуры

&НаКлиенте
Процедура ПодключитьОборудованиеЗавершениеПоУмолчанию(РезультатВыполнения, Параметры) Экспорт
	
	Если Не РезультатВыполнения.Результат Тогда
		ТекстСообщения = НСтр("ru='При подключении оборудования произошла ошибка:""%ОписаниеОшибки%"".'");
		ТекстСообщения = СтрЗаменить(ТекстСообщения, "%ОписаниеОшибки%" , РезультатВыполнения.ОписаниеОшибки);
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
	КонецЕсли;
	
	// ЛОГИ
	Если Не РезультатВыполнения.Результат Тогда
		ТекстСообщения = НСтр("ru='При подключении оборудования произошла ошибка:""%ОписаниеОшибки%"".'");
		ТекстСообщения = СтрЗаменить(ТекстСообщения, "%ОписаниеОшибки%" , РезультатВыполнения.ОписаниеОшибки);
		Логи = Логи + РазделительЛогов() + ТекстСообщения;
	Иначе
		Логи = Логи + РазделительЛогов() + НСтр("ru = 'Подключение оборудования выполнено успешно.'");
	КонецЕсли;
	// Конец ЛОГИ
	
КонецПроцедуры

#Область Логирование

&НаКлиентеНаСервереБезКонтекста
Функция РазделительЭлементовЛога()
	
	Возврат Символы.ПС + ПолучитьТекущуюДатуСеансаВФормате() + ": ";
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция РазделительЛогов()
	
	Возврат Символы.ПС + Символы.ПС + "=================================================================================" + Символы.ПС + ПолучитьТекущуюДатуСеансаВФормате() + ": ";
	
КонецФункции

&НаСервереБезКонтекста
Функция ПолучитьТекущуюДатуСеансаВФормате()
	
	Возврат Формат(ТекущаяДатаСеанса(), "ДЛФ=DT");
	
КонецФункции

#КонецОбласти // Логирование

#Область Сохранение

&НаСервере
Функция ПолучитьДанныеДляСохранения()
	
	Данные = Новый Структура;
	Данные.Вставить("ДанныеШтрихкодовКИЗ"                 , РеквизитФормыВЗначение("ДанныеШтрихкодовКИЗ"));
	Данные.Вставить("ДанныеШтрихкодовТранспортныхУпаковок", РеквизитФормыВЗначение("ДанныеШтрихкодовТранспортныхУпаковок"));
	Данные.Вставить("ДанныеНеизвестныхШтрихкодов"         , РеквизитФормыВЗначение("ДанныеНеизвестныхШтрихкодов"));
	Данные.Вставить("ДанныеЛогов"                         , Логи);
	
	Возврат ПоместитьВоВременноеХранилище(ПреобразоватьЗначениеВJSON(Данные));
	
КонецФункции

&НаСервере
Процедура ЗагрузитьСохраненныеДанные(АдресДанных)
	
	Данные = ПреобразоватьJSONВЗначение(ПолучитьСтрокуИзДвоичныхДанных(ПолучитьИзВременногоХранилища(АдресДанных)));
	
	Если ТипЗнч(Данные) = Тип("Структура") Тогда
		Если Данные.Свойство("ДанныеШтрихкодовКИЗ") Тогда
			ЗначениеВРеквизитФормы(Данные.ДанныеШтрихкодовКИЗ, "ДанныеШтрихкодовКИЗ");
		КонецЕсли;
		Если Данные.Свойство("ДанныеШтрихкодовТранспортныхУпаковок") Тогда
			ЗначениеВРеквизитФормы(Данные.ДанныеШтрихкодовТранспортныхУпаковок, "ДанныеШтрихкодовТранспортныхУпаковок");
		КонецЕсли;
		Если Данные.Свойство("ДанныеНеизвестныхШтрихкодов") Тогда
			ЗначениеВРеквизитФормы(Данные.ДанныеНеизвестныхШтрихкодов, "ДанныеНеизвестныхШтрихкодов");
		КонецЕсли;
		Если Данные.Свойство("ДанныеЛогов") Тогда
			Логи = Данные.ДанныеЛогов;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СохранитьРезультатЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат <> Неопределено Тогда
		ПоказатьОповещениеПользователя(НСтр("ru = 'Сохранение результатов'"),, НСтр("ru = 'Файл результатов сохранен'"));
	Иначе
		ПоказатьОповещениеПользователя(НСтр("ru = 'Сохранение результатов'"),, НСтр("ru = 'Файл не сохранен'"));
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ПреобразоватьЗначениеВJSON(Значение)
	
	Запись = Новый ЗаписьJSON;
	Запись.УстановитьСтроку();
	СериализаторXDTO.ЗаписатьJSON(Запись, Значение, НазначениеТипаXML.Явное);
	Возврат Запись.Закрыть();
	
КонецФункции

&НаСервере
Функция ПреобразоватьJSONВЗначение(Строка)
	
	Если Не ЗначениеЗаполнено(Строка) Тогда
		Возврат Строка;
	КонецЕсли;
	
	Чтение = Новый ЧтениеJSON;
	Чтение.УстановитьСтроку(Строка);
	Значение = СериализаторXDTO.ПрочитатьJSON(Чтение);
	
	Возврат Значение;
	
КонецФункции

#КонецОбласти // Сохранение

#КонецОбласти

#КонецОбласти // СлужебныеПроцедурыИФункции
