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
	
	ОбновитьИсториюПоиска(Элементы.СтрокаПоиска);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ВыполнитьПоиск(Команда)
	
	Если ПустаяСтрока(СтрокаПоиска) Тогда
		ПоказатьПредупреждение(, НСтр("ru = 'Введите, что нужно найти.'"));
		Возврат;
	КонецЕсли;
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ПереданнаяСтрокаПоиска", СтрокаПоиска);
	
	ОткрытьФорму("ОбщаяФорма.ФормаПоиска", ПараметрыФормы,, Истина);
	
	ОбновитьИсториюПоиска(Элементы.СтрокаПоиска);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиентеНаСервереБезКонтекста
Процедура ОбновитьИсториюПоиска(Элемент)
	
	ИсторияПоиска = СохраненнаяИсторияПоиска();
	Если ТипЗнч(ИсторияПоиска) = Тип("Массив") Тогда
		Элемент.СписокВыбора.ЗагрузитьЗначения(ИсторияПоиска);
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция СохраненнаяИсторияПоиска()
	
	Возврат ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить("ПолнотекстовыйПоискСтрокиПолнотекстовогоПоиска", "");
	
КонецФункции

#КонецОбласти
