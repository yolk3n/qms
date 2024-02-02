﻿
////////////////////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС
#Область ПрограммныйИнтерфейс

Функция ПолучитьДопустимыеТипыПолитикУчетаСерий(Параметры) Экспорт
	
	ДопустимыеТипыПолитик = Новый Массив;
		
	Если Не Параметры.ИспользоватьСерии Тогда
		Возврат ДопустимыеТипыПолитик;
	КонецЕсли;
	
	Если Параметры.ТипНоменклатуры = ПредопределенноеЗначение("Перечисление.ТипыНоменклатуры.Товар") Тогда
		
		ДопустимыеТипыПолитик.Добавить(ПредопределенноеЗначение("Перечисление.ТипыПолитикУчетаСерий.НеУчитывать"));
		Если Параметры.НастройкаИспользованияСерий = ПредопределенноеЗначение("Перечисление.НастройкиИспользованияСерийНоменклатуры.ЭкземплярТовара") Тогда
			ДопустимыеТипыПолитик.Добавить(ПредопределенноеЗначение("Перечисление.ТипыПолитикУчетаСерий.СправочноеУказаниеСерий"));
		Иначе
			ДопустимыеТипыПолитик.Добавить(ПредопределенноеЗначение("Перечисление.ТипыПолитикУчетаСерий.СправочноеУказаниеСерий"));
			ДопустимыеТипыПолитик.Добавить(ПредопределенноеЗначение("Перечисление.ТипыПолитикУчетаСерий.УправлениеОстаткамиСерий"));
			ДопустимыеТипыПолитик.Добавить(ПредопределенноеЗначение("Перечисление.ТипыПолитикУчетаСерий.УчетСебестоимостиПоСериям"));
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат ДопустимыеТипыПолитик;
	
КонецФункции

// Идентификатор потребительской упаковки
//
Функция ВидЕдиницы_ПотребительскаяУпаковка() Экспорт
	Возврат ВРег("ПотребительскаяУпаковка");
КонецФункции

// Идентификатор минимальной единицы
//
Функция ВидЕдиницы_МинимальнаяЕдиница() Экспорт
	Возврат ВРег("МинимальнаяЕдиница");
КонецФункции

// Идентификатор основной единицы
//
Функция ВидЕдиницы_ОсновнаяЕдиница() Экспорт
	Возврат ВРег("ОсновнаяЕдиница");
КонецФункции

// Возвращает представление номенклатуры для печати.
//
// Параметры:
//  НаименованиеНоменклатуры - СправочникСсылка.Номенклатура, Строка       - представление номенклатуры.
//  Серия                    - СправочникСсылка.СерииНоменклатуры, Строка  - представление серии.
//  Партия                   - СправочникСсылка.ПартииНоменклатуры, Строка - представление партии.
//
// Возвращаемое значение:
//  Строка - представление номенклатуры для печати
//
Функция ПредставлениеНоменклатурыДляПечати(НаименованиеНоменклатуры, Серия = Неопределено, Партия = Неопределено) Экспорт
	
	Результат = "(";
	
	Если ЗначениеЗаполнено(Серия) Тогда
		Результат = Результат + Серия;
		Результат = СтрЗаменить(Результат, "<>", "");
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Партия) Тогда
		Результат = ?(Результат = "(", Результат, Результат + "; ");
		Результат = Результат + Партия;
	КонецЕсли;
	
	Результат = Результат + ")";
	
	Возврат СокрЛП(НаименованиеНоменклатуры) + ?(Результат = "()", "", " " + Результат);
	
КонецФункции

// Ошибка платформы 00110413.
// Пересчитывает значение даты элемента справочника "СерииНоменклатуры", после выбора значения платформенными средствами.
//
// Параметры:
//  ДатаСерии - Дата - дата элемента справочника "СерииНоменклатуры", полученная платформенными средствами.
//
Процедура ПересчитатьДатуСерии(ДатаСерии) Экспорт
	
	Если Не ЗначениеЗаполнено(ДатаСерии) Тогда
		Возврат;
	КонецЕсли;
	
	ДатаСерии = ?(Дата(2000, 1, 1) > ДатаСерии, ДобавитьМесяц(ДатаСерии, 1200), ДатаСерии);
	
КонецПроцедуры

#КонецОбласти // ПрограммныйИнтерфейс
