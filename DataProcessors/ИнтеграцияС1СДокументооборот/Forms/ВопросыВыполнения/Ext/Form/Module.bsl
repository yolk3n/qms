﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("ID") Тогда
		ПредметID = Параметры.ID;
		ПредметТип = Параметры.type;
	КонецЕсли;
	
	// вопросы выполнения задач
	Если ИнтеграцияС1СДокументооборотБазоваяФункциональностьПовтИсп.ДоступенФункционалВерсииСервиса("1.2.7.3")
			И Не ИнтеграцияС1СДокументооборотБазоваяФункциональностьПовтИсп.ДоступенФункционалВерсииСервиса("3.0.1.1") Тогда
		ВывестиСписокВопросов();
	Иначе
		Обработки.ИнтеграцияС1СДокументооборот.ОбработатьФормуПриНедоступностиФункционалаВерсииСервиса(ЭтотОбъект);
		Элементы.Вопросы.Видимость = Ложь;
		Элементы.ВопросыОписание.Видимость = Ложь;
	КонецЕсли;
	
	Если Не ИнтеграцияС1СДокументооборотБазоваяФункциональностьПовтИсп.ДоступенФункционалВерсииСервиса("2.1.18.1.CORP") Тогда
		Элементы.ВопросыВидВопроса.Видимость = Ложь;
		Элементы.СписокВопросовГруппаСроки.Видимость = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если (ИмяСобытия = "Запись_ДокументооборотЗадача" 
			Или ИмяСобытия = "Запись_ДокументооборотБизнесПроцесс") И Источник = ЭтотОбъект Тогда
		ВывестиСписокВопросов();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыВопросы

&НаКлиенте
Процедура ВопросыВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Процесс = Элементы.Вопросы.ТекущиеДанные;
	
	Если Процесс <> Неопределено Тогда
		ИнтеграцияС1СДокументооборотБазоваяФункциональностьКлиент.ОткрытьОбъект(Процесс.ВопросТип, Процесс.ВопросID, ЭтотОбъект);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Обновить(Команда)
	
	Модифицированность = Ложь;
	ВывестиСписокВопросов();
	
КонецПроцедуры

&НаКлиенте
Процедура НайтиВыполнить(Команда)
	
	Модифицированность = Ложь;
	ПараметрыФормы = Новый Структура("СтрокаПоиска",СтрокаПоиска);
	Оповещение = Новый ОписаниеОповещения("НайтиВыполнитьЗавершение", ЭтотОбъект);
	
	ОткрытьФорму("Обработка.ИнтеграцияС1СДокументооборотБазоваяФункциональность.Форма.ПоискВСписке", ПараметрыФормы, ЭтотОбъект,,,, Оповещение);
	
КонецПроцедуры

&НаКлиенте
Процедура НайтиВыполнитьЗавершение(Результат, ПараметрыОповещения) Экспорт
	
	Если ТипЗнч(Результат) = Тип("Строка") Тогда
		СтрокаПоиска = Результат;
		ВывестиСписокВопросов();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОтменитьПоиск(Команда)
	
	// отменяем режим поиска
	Модифицированность = Ложь;
	СтрокаПоиска = "";
	ВывестиСписокВопросов();
	
КонецПроцедуры

&НаКлиенте
Процедура Создать(Команда)
	
	Модифицированность = Ложь;
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ID", ПредметID);
	ПараметрыФормы.Вставить("type", ПредметТип);
	ПараметрыФормы.Вставить("ВидВопроса", НСтр("ru = 'Иное'"));
	ПараметрыФормы.Вставить("ВидВопросаID", "Иное"); //@NON-NLS-2
	
	ОткрытьФорму("Обработка.ИнтеграцияС1СДокументооборот.Форма.БизнесПроцессРешениеВопросовНовыйВопрос",
		ПараметрыФормы, ЭтотОбъект, ПредметID);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ВывестиСписокВопросов()
	
	Прокси = ИнтеграцияС1СДокументооборотБазоваяФункциональностьПовтИсп.ПолучитьПрокси();
	
	Условия = ИнтеграцияС1СДокументооборотБазоваяФункциональность.СоздатьОбъект(Прокси, "DMObjectListQuery");
	СписокУсловийОтбора = Условия.conditions; // СписокXDTO
	
	Условие = ИнтеграцияС1СДокументооборотБазоваяФункциональность.СоздатьОбъект(Прокси, "DMObjectListCondition");
	Условие.property = "target";
	Условие.value = ИнтеграцияС1СДокументооборотБазоваяФункциональность.СоздатьObjectID(Прокси, ПредметID, ПредметТип);
	СписокУсловийОтбора.Добавить(Условие);
	
	Если ЗначениеЗаполнено(СтрокаПоиска) Тогда
		Условие = ИнтеграцияС1СДокументооборотБазоваяФункциональность.СоздатьОбъект(Прокси, "DMObjectListCondition");
		Условие.property = "name";
		Условие.value = СтрокаПоиска;
		СписокУсловийОтбора.Добавить(Условие);
	КонецЕсли;
	
	Ответ = ИнтеграцияС1СДокументооборотБазоваяФункциональность.НайтиСписокОбъектов(
		Прокси,
		"DMBusinessProcessIssuesSolution",
		Условия);
	
	Вопросы.Очистить();
	Для Каждого Вопрос Из Ответ.items Цикл
		
		БизнесПроцесс = Вопрос.object;
		СтрокаВопроса = Вопросы.Добавить();
		ИнтеграцияС1СДокументооборотБазоваяФункциональность.ЗаполнитьОбъектныйРеквизит(СтрокаВопроса, БизнесПроцесс, "Вопрос");
		СтрокаВопроса.Вопрос = БизнесПроцесс.description;
		Если ИнтеграцияС1СДокументооборотБазоваяФункциональность.СвойствоУстановлено(БизнесПроцесс, "issueType") Тогда
			СтрокаВопроса.ВидВопроса = БизнесПроцесс.issueType.name;
		ИначеЕсли ИнтеграцияС1СДокументооборотБазоваяФункциональностьПовтИсп.ДоступенФункционалВерсииСервиса("2.1.18.1") Тогда
			СтрокаВопроса.ВидВопроса = НСтр("ru = 'Иное'");
		КонецЕсли;
		СтрокаВопроса.Дата = БизнесПроцесс.beginDate;
		СтрокаВопроса.Описание = БизнесПроцесс.perfomanceHistory;
		СтрокаВопроса.Автор = БизнесПроцесс.author.name;
		Если ИнтеграцияС1СДокументооборотБазоваяФункциональность.СвойствоУстановлено(БизнесПроцесс, "completionMark") Тогда
			СтрокаВопроса.Картинка = ИнтеграцияС1СДокументооборот.ИндексКартинкиПометкиЗавершения(
				БизнесПроцесс.completionMark);
		КонецЕсли;
		Если ИнтеграцияС1СДокументооборотБазоваяФункциональность.СвойствоУстановлено(БизнесПроцесс, "initiator") Тогда
			СтрокаВопроса.Кому = БизнесПроцесс.initiator.name;
		КонецЕсли;
		Если СтрокаВопроса.ВидВопроса = НСтр("ru = 'Перенос срока'") Тогда
			СтрокаВопроса.ЗаголовокНовыйСрок = НСтр("ru = 'Новый срок:'");
			СтрокаВопроса.ЗаголовокСтарыйСрок = НСтр("ru = 'Старый срок:'");
			Если ИнтеграцияС1СДокументооборотБазоваяФункциональность.СвойствоУстановлено(БизнесПроцесс, "newDueDate") Тогда
				СтрокаВопроса.НовыйСрок = БизнесПроцесс.newDueDate;
			КонецЕсли;
			Если ИнтеграцияС1СДокументооборотБазоваяФункциональность.СвойствоУстановлено(БизнесПроцесс, "oldDueDate") Тогда
				СтрокаВопроса.СтарыйСрок = БизнесПроцесс.oldDueDate;
			Иначе
				СтрокаВопроса.СтарыйСрок = БизнесПроцесс.issueTask.dueDate;
			КонецЕсли;
		КонецЕсли;
		
	КонецЦикла;
	
	Вопросы.Сортировать("Дата УБЫВ");
	
КонецПроцедуры

#КонецОбласти
