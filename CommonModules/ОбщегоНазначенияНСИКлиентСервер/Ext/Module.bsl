﻿
#Область ПрограммныйИнтерфейс


// Функция преобразовывает строку в тип Дата
//
// Параметры
//	ПредставлениеДаты - строка, представляющая дату
//
// Возвращаемое значение
//	Дата - дата из строки или '00010101'
//
Функция ПреобразоватьСтрокуВДату(ПредставлениеДаты) Экспорт
	
	ТипДата = Новый ОписаниеТипов("Дата");
	ЗначениеДаты = ТипДата.ПривестиЗначение();
	
	Если ПустаяСтрока(ПредставлениеДаты) Тогда
		Возврат ЗначениеДаты;
	КонецЕсли;
	
	ЗначениеДаты = ТипДата.ПривестиЗначение(ПредставлениеДаты);
	Если Не ЗначениеЗаполнено(ЗначениеДаты) Тогда //Дата не в каноническом виде, будем преобразовывать самостоятельно
		
		РазделителиДаты = ".-/\";
		Числа = "0123456789";
		ДлинаСтроки = СтрДлина(ПредставлениеДаты);
		МассивЧастейДаты = Новый Массив;
		
		ВременнаяСтрока = "";
		КоличествоЧастейДаты = 0;
		Для Индекс = 1 По ДлинаСтроки Цикл
			СимволСтроки = Сред(ПредставлениеДаты, Индекс, 1);
			Если Найти(Числа, СимволСтроки) Тогда
				ВременнаяСтрока = ВременнаяСтрока + СимволСтроки;
			ИначеЕсли Найти(РазделителиДаты, СимволСтроки) Тогда
				Если Не ПустаяСтрока(ВременнаяСтрока) Тогда
					МассивЧастейДаты.Добавить(ВременнаяСтрока);
					ВременнаяСтрока = "";
					КоличествоЧастейДаты = КоличествоЧастейДаты + 1;
				КонецЕсли;
			Иначе
				МассивЧастейДаты.Очистить();
				Прервать; //неверный формат даты
			КонецЕсли;
			Если КоличествоЧастейДаты = 3 Тогда
				Прервать;
			КонецЕсли;
		КонецЦикла;
		
		Если Не ПустаяСтрока(ВременнаяСтрока) Тогда
			МассивЧастейДаты.Добавить(ВременнаяСтрока);
		КонецЕсли;
		
		Если МассивЧастейДаты.Количество() = 3 Тогда
			Если СтрДлина(МассивЧастейДаты[0]) = 4 Тогда
				ЗначениеДаты = ПолучитьДату(МассивЧастейДаты[0], МассивЧастейДаты[1], МассивЧастейДаты[2]);
			ИначеЕсли СтрДлина(МассивЧастейДаты[2]) = 4 Тогда
				ЗначениеДаты = ПолучитьДату(МассивЧастейДаты[2], МассивЧастейДаты[1], МассивЧастейДаты[0]);
			Иначе
				ЗначениеДаты = ПолучитьДату("20" + МассивЧастейДаты[2], МассивЧастейДаты[1], МассивЧастейДаты[0]);
			КонецЕсли;
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат ЗначениеДаты;
	
КонецФункции

// Функция получает дату на основании переданных параметров
// 
// Параметры
//	Год - число, год даты
//	Месяц - число, месяц даты
//	День - число, день даты
//
// Возвращаемое значение
//	Дата
//
Функция ПолучитьДату(Год, Месяц, День)
	
	Попытка
		Результат = Дата(Год, Месяц, День);
	Исключение
		Результат = '00010101';
	КонецПопытки;
	
	Возврат Результат;
	
КонецФункции

// Добовляет значения в массив
//
// Параметры
//	Приемник - объект, в котый добавляются значения
//	Источник - объект, из которого добавляются значения
//
Процедура ДополнитьМассив(Приемник, Источник) Экспорт
	
	Для каждого Значение Из Источник Цикл
		Приемник.Добавить(Значение);
	КонецЦикла;
	
КонецПроцедуры

// Определяет необходимое количество строк текста
//
Функция КоличествоСтрок(Текст, МаксимальноеКоличествоСимволовВСтроке = 80) Экспорт
		
	КоличествоСтрок = 1;
	ДлинаРазделителя = 1;
	ДлинаСтроки = 0;
	
	Слова = СтрРазделить(Текст, " ");
	Для Индекс = 1 По Слова.Количество() Цикл
		
		ДлинаСлова = СтрДлина(Слова[Индекс - 1]);
		НоваяДлинаСтроки = ДлинаСтроки + ?(ДлинаСтроки = 0, 0, ДлинаРазделителя) + ДлинаСлова;
		Если НоваяДлинаСтроки > МаксимальноеКоличествоСимволовВСтроке Тогда
			КоличествоСтрок = КоличествоСтрок + 1;
			Если ДлинаСтроки > 0 Тогда
				ДлинаСтроки = ДлинаСлова;
			КонецЕсли;
		Иначе
			ДлинаСтроки = НоваяДлинаСтроки;
		КонецЕсли;	
		
	КонецЦикла;
	
	Возврат КоличествоСтрок - ?(ДлинаСтроки = 0, 1, 0);
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// ФУНКЦИИ ДЛЯ РАБОТЫ С УПРАВЛЯЕМЫМИ ФОРМАМИ

// Устанавливает значение свойства элемента формы, если находит элемент на форме
//
// Параметры
//  ЭлементыФормы - ВсеЭлементыФормы - элементы формы, среди которых содержится искомый элемент.
//  ИмяЭлемента   - Строка - имя искомого элемента.
//  ИмяСвойства   - Строка - имя свойства, для которого будет устанавливаться значение.
//  Значение      - Произвольный - значение, которое будет установлено
//
Процедура УстановитьСвойствоЭлементаФормы(ЭлементыФормы, ИмяЭлемента, ИмяСвойства, Значение) Экспорт
	
	Если ЭлементыФормы.Найти(ИмяЭлемента) <> Неопределено  Тогда
		Если ЭлементыФормы[ИмяЭлемента][ИмяСвойства] <> Значение Тогда
			ЭлементыФормы[ИмяЭлемента][ИмяСвойства] = Значение;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры // УстановитьСвойствоЭлементаФорма()

// Устанавливает значение свойства элементов формы, если находит элемент на форме
//
// Параметры
//  ЭлементыФормы       - ВсеЭлементыФормы - элементы формы, среди которых содержится искомый элемент.
//  МассивИменЭлементов - Массив - массив имен искомых элементов.
//  ИмяСвойства         - Строка - имя свойства, для которого будет устанавливаться значение.
//  Значение            - Произвольный - значение, которое будет установлено
//
Процедура УстановитьСвойствоЭлементовФормы(ЭлементыФормы, МассивИменЭлементов, ИмяСвойства, Значение) Экспорт
	
	Для каждого ИмяЭлемента Из МассивИменЭлементов Цикл
		УстановитьСвойствоЭлементаФормы(ЭлементыФормы, ИмяЭлемента, ИмяСвойства, Значение);
	КонецЦикла
	
КонецПроцедуры // УстановитьСвойствоЭлементовФормы()

// Устанавливает отборы для области
//
// Параметры
//	ОбластьОтбора - ОтборКомпановкиДанных, ГруппаЭлементовОтбораКомпоновкиДанных
//	Отбор - Структура
//
Процедура УстановитьЭлементыОтбораПоУмолчанию(ОбластьОтбора, Отбор) Экспорт
	
	Для каждого Элемент Из Отбор Цикл
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(
			ОбластьОтбора,
			Элемент.Ключ,
			Элемент.Значение,
			?(ТипЗнч(Элемент.Значение) = Тип("Массив") , ВидСравненияКомпоновкиДанных.ВСписке, ВидСравненияКомпоновкиДанных.Равно),
			"ОтборПоУмолчанию",
			Истина);
	КонецЦикла;
	
КонецПроцедуры


#КонецОбласти