﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2023, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Заголовок = НСтр("ru = 'Перезапуск отложенного обновления'");
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ГиперссылкаВыборОбработчиковОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
КонецПроцедуры

&НаКлиенте
Процедура ГиперссылкаВыборОбработчиковНажатие(Элемент)
	ОбработкаЗавершения = Новый ОписаниеОповещения("ПослеВыбораОбработчиков", ЭтотОбъект);
	
	ПараметрыВыбора = Новый Структура;
	ПараметрыВыбора.Вставить("ВыбранныеОбработчики", ВыбранныеОбработчики);
	ОткрытьФорму("РегистрСведений.ОбработчикиОбновления.Форма.ФормаВыбора", ПараметрыВыбора,,,,, ОбработкаЗавершения);
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКоманд

&НаКлиенте
Процедура Перезапустить(Команда)
	Элементы.ФормаПерезапустить.Доступность = Ложь;
	
	ДлительнаяОперация = ДлительнаяОперация();
	
	ОповещениеОЗавершении = Новый ОписаниеОповещения("ОбработатьРезультат", ЭтотОбъект);
	ПараметрыОжидания = ДлительныеОперацииКлиент.ПараметрыОжидания(ЭтотОбъект);
	ДлительныеОперацииКлиент.ОжидатьЗавершение(ДлительнаяОперация, ОповещениеОЗавершении, ПараметрыОжидания);
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ПослеВыбораОбработчиков(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ВыбранныеОбработчики.ЗагрузитьЗначения(Результат);
	
	Если ВыбранныеОбработчики.Количество() = 0 Тогда
		Элементы.ГиперссылкаВыборОбработчиков.Заголовок = НСтр("ru = 'Выбрать обработчики'");
	Иначе
		Элементы.ГиперссылкаВыборОбработчиков.Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Выбрано обработчиков: %1'"),
			ВыбранныеОбработчики.Количество());
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ДлительнаяОперация()
	ПараметрыВыполнения = ДлительныеОперации.ПараметрыВыполненияВФоне(УникальныйИдентификатор);
	ПараметрыВыполнения.ОжидатьЗавершение = 0;
	
	Результат = ДлительныеОперации.ВыполнитьПроцедуру(ПараметрыВыполнения, "ОбновлениеИнформационнойБазы.ПерезапуститьОтложенноеОбновление",
		ВыбранныеОбработчики.ВыгрузитьЗначения());
	
	Возврат Результат;
КонецФункции

&НаКлиенте
Процедура ОбработатьРезультат(Результат, ДополнительныеПараметры) Экспорт
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Оповестить("ОтложенноеОбновлениеПерезапущено");
	Закрыть();
КонецПроцедуры

#КонецОбласти