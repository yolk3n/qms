﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ
#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка)
	
	Если ЭтоГруппа Тогда 
		Возврат;
	КонецЕсли;
	
	Если ЭтоНовый() Тогда 
		Важность = Перечисления.ВариантыВажностиЗадачи.Обычная;
	КонецЕсли;	
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	Если ЭтоГруппа Тогда 
		Возврат;
	КонецЕсли;
	
	Если ПерсональныйШаблон Тогда 
		ПроверяемыеРеквизиты.Добавить("Ответственный");
	КонецЕсли;	
	
	Если ТипЗнч(Исполнитель) = Тип("СправочникСсылка.РолиИсполнителей") И Исполнитель.ВнешняяРоль Тогда 
		ОбщегоНазначения.СообщитьПользователю(
			НСтр("ru = 'Внешняя роль не может быть использована в данном поле.'"),
			ЭтотОбъект,
			"Исполнитель",
			,
			Отказ);
	КонецЕсли;
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);
	
КонецПроцедуры

#КонецОбласти // ОбработчикиСобытий

#КонецЕсли