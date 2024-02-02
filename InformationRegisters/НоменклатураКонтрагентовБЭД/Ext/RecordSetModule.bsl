﻿////////////////////////////////////////////////////////////////////////////////
// Модуль набора записей РегистрСведений.НоменклатураКонтрагентовБЭД
//
////////////////////////////////////////////////////////////////////////////////

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	НеПроверяемыеРеквизиты = Новый Массив;
	НеПроверяемыеРеквизиты.Добавить("Владелец");
	
	МетаданныеСопоставления = СопоставлениеНоменклатурыКонтрагентовСлужебный.МетаданныеСопоставленияНоменклатуры();
	ПредставлениеВладельца = МетаданныеСопоставления.ВладелецНоменклатурыПредставлениеОбъекта;
	
	ТекстВладелецНеЗаполнен = СтрШаблон(НСтр("ru = 'Поле ""%1"" не заполнено'"), ПредставлениеВладельца);
	
	Для каждого Запись Из ЭтотОбъект Цикл
		Если Не ЗначениеЗаполнено(Запись.Владелец) Тогда
			ОбщегоНазначения.СообщитьПользователю(ТекстВладелецНеЗаполнен, , "Владелец", "Запись", Отказ);
		КонецЕсли;
	КонецЦикла;
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, НеПроверяемыеРеквизиты);
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, Замещение)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если Количество() = 0 И НЕ Модифицированность() Тогда
		ДополнительныеСвойства.Вставить("НеУдалятьЗапись", Истина);
	Иначе
		ДополнительныеСвойства.Вставить("НеУдалятьЗапись", ЗначениеЗаполнено(Количество()));
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Иначе
	
	ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
	
#КонецЕсли

