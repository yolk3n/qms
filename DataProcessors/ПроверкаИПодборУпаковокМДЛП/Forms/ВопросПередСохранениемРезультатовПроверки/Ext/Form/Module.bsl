﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	КоличествоВсего         = Параметры.КоличествоВсего;
	КоличествоНеПроверенных = Параметры.КоличествоНеПроверенных;
	КоличествоОтложенных    = Параметры.КоличествоОтложенных;
	
	ПровереноОтложено = Новый Массив;
	Если КоличествоНеПроверенных > 0 Тогда
		ПровереноОтложено.Добавить(СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Не Проверено - %1'"), КоличествоНеПроверенных));
	КонецЕсли;
	Если КоличествоОтложенных > 0 Тогда
		ПровереноОтложено.Добавить(СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Отложено - %1'"), КоличествоОтложенных));
	КонецЕсли;
	
	ТекстРезультаты = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru = 'Требовалось проверить наличие препаратов и упаковок - %1.
		           |%2.
		           |
		           |Отразить в результатах проверки отложенные и непроверенные как:'"),
		КоличествоВсего,
		СтрСоединить(ПровереноОтложено, ". "));
	
	Элементы.ДекорацияРезультатыПроверки.Заголовок = ТекстРезультаты;
	
	Если КоличествоОтложенных + КоличествоНеПроверенных > КоличествоВсего / 2 Тогда
		КакУчитыватьНеПроверенныеОтложенные = Перечисления.СтатусыПроверкиНаличияУпаковкиМДЛП.ВНаличии;
	Иначе
		КакУчитыватьНеПроверенныеОтложенные = Перечисления.СтатусыПроверкиНаличияУпаковкиМДЛП.Отсутствует;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура КомандаOK(Команда)
	
	Закрыть(КакУчитыватьНеПроверенныеОтложенные);
	
КонецПроцедуры

#КонецОбласти
