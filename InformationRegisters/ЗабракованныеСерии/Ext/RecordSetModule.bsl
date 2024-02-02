﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

////////////////////////////////////////////////////////////////////////////////
// ОПИСАНИЕ ПЕРЕМЕННЫХ
#Область ОписаниеПеременных

Перем СтарыйНабор;

#КонецОбласти // ОписаниеПеременных

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ
#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ, Замещение)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если Замещение Тогда
		ТекущийНабор = Выгрузить();
		Прочитать();
		СтарыйНабор = Выгрузить();
		Загрузить(ТекущийНабор);
	КонецЕсли;
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ, Замещение)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ОбновитьДанныеЗабракованныхСерий(Выгрузить(), СтарыйНабор);
	
КонецПроцедуры

#КонецОбласти // ОбработчикиСобытий

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ
#Область СлужебныеПроцедурыИФункции

Процедура ОбновитьДанныеЗабракованныхСерий(НовыйНабор, СтарыйНабор = Неопределено)
	
	Если СтарыйНабор = Неопределено Тогда
		СтарыйНабор = НовыйНабор.СкопироватьКолонки();
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("НовыйНабор", НовыйНабор);
	Запрос.УстановитьПараметр("СтарыйНабор", СтарыйНабор);
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	Набор.ЗабраковкаСерии,
	|	Набор.Серия
	|ПОМЕСТИТЬ НовыйНабор
	|ИЗ
	|	&НовыйНабор КАК Набор
	|ГДЕ
	|	НЕ Набор.ИсключитьИзАвтоматическогоПоиска
	|;
	|
	|//////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	Набор.Серия
	|ПОМЕСТИТЬ ЗабракованныеСерии
	|ИЗ
	|	НовыйНабор КАК Набор
	|ГДЕ
	|	ВЫРАЗИТЬ(Набор.ЗабраковкаСерии КАК Справочник.ЗабракованныеСерии).Статус = ЗНАЧЕНИЕ(Перечисление.СтатусыЗабраковкиСерий.Действует)
	|	И НЕ ВЫРАЗИТЬ(Набор.ЗабраковкаСерии КАК Справочник.ЗабракованныеСерии).ПометкаУдаления
	|;
	|
	|//////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Набор.ЗабраковкаСерии,
	|	Набор.Серия
	|ПОМЕСТИТЬ СтарыйНабор
	|ИЗ
	|	&СтарыйНабор КАК Набор
	|ГДЕ
	|	НЕ Набор.ИсключитьИзАвтоматическогоПоиска
	|;
	|
	|//////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	Набор.Серия
	|ПОМЕСТИТЬ КандидатыНаОтменуЗабраковки
	|ИЗ
	|	СтарыйНабор КАК Набор
	|	ЛЕВОЕ СОЕДИНЕНИЕ
	|		ЗабракованныеСерии КАК ЗабракованныеСерии
	|		ПО
	|			ЗабракованныеСерии.Серия = Набор.Серия
	|ГДЕ
	|	ВЫРАЗИТЬ(Набор.ЗабраковкаСерии КАК Справочник.ЗабракованныеСерии).Статус = ЗНАЧЕНИЕ(Перечисление.СтатусыЗабраковкиСерий.Действует)
	|	И НЕ ВЫРАЗИТЬ(Набор.ЗабраковкаСерии КАК Справочник.ЗабракованныеСерии).ПометкаУдаления
	|	И ЗабракованныеСерии.Серия ЕСТЬ NULL
	|;
	|
	|//////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Набор.Серия КАК СерияНоменклатуры,
	|	ИСТИНА КАК Забракована
	|ИЗ
	|	ЗабракованныеСерии КАК Набор
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	Набор.Серия КАК СерияНоменклатуры,
	|	ЛОЖЬ КАК Забракована
	|ИЗ
	|	КандидатыНаОтменуЗабраковки КАК Набор
	|ГДЕ
	|	НЕ ИСТИНА В
	|		(ВЫБРАТЬ ПЕРВЫЕ 1
	|			ИСТИНА
	|		ИЗ
	|			РегистрСведений.ЗабракованныеСерии КАК ЗабракованныеСерии
	|		ГДЕ
	|			ЗабракованныеСерии.Серия = Набор.Серия
	|			И (НЕ ЗабракованныеСерии.ИсключитьИзАвтоматическогоПоиска)
	|			И ЗабракованныеСерии.ЗабраковкаСерии.Статус = ЗНАЧЕНИЕ(Перечисление.СтатусыЗабраковкиСерий.Действует)
	|			И (НЕ ЗабракованныеСерии.ЗабраковкаСерии.ПометкаУдаления))
	|";
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		РаботаСИнформациейОбОбъектах.УстановитьСвойствоЗабракован(Выборка.СерияНоменклатуры, Выборка.Забракована);
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти // СлужебныеПроцедурыИФункции

#КонецЕсли