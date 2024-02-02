﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Обработчик обновления. Обновляет значения ставок НДС объектов закупки.
Процедура ОбновитьСтавкиНДСОбъектовЗакупки() Экспорт
	
	Если Метаданные.Перечисления.Найти("УдалитьСтавкиНДСКонтрактовЕИС") = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Выборка = Справочники.ГосударственныеКонтрактыЕИС.Выбрать();
	Пока Выборка.Следующий() Цикл
		Объект = Выборка.ПолучитьОбъект();
		СтавкиИзменены = Ложь;
		Для Каждого ОбъектЗакупки Из Объект.ОбъектыЗакупки Цикл
			Если ЗначениеЗаполнено(ОбъектЗакупки.УдалитьСтавкаНДС) Тогда
				СтавкаНДСТекст = ТекстовоеПредставлениеСтавкиНДС(ОбъектЗакупки.УдалитьСтавкаНДС);
				ДанныеОбъектаЗакупки = Новый Структура("СтавкаНДС", СтавкаНДСТекст);
				ОбъектЗакупки.СтавкаНДС = ЭлектронноеАктированиеЕИС.
					СтавкаНДСОбъектаЗакупки(ДанныеОбъектаЗакупки);
				СтавкиИзменены = Истина;
			КонецЕсли;
		КонецЦикла;
		Если СтавкиИзменены Тогда
			ОбновлениеИнформационнойБазы.ЗаписатьОбъект(Объект);
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Используется в обработчике обновления.
Функция ТекстовоеПредставлениеСтавкиНДС(СтавкаНДС)
	
	СтавкиНДС = Новый Соответствие;
	ПеречислениеСтавок = Перечисления["УдалитьСтавкиНДСКонтрактовЕИС"];
	СтавкиНДС.Вставить(ПеречислениеСтавок.НДС0, "0");
	СтавкиНДС.Вставить(ПеречислениеСтавок.НДС10, "10");
	СтавкиНДС.Вставить(ПеречислениеСтавок.НДС18, "18");
	СтавкиНДС.Вставить(ПеречислениеСтавок.НДС20, "20");
	СтавкиНДС.Вставить(ПеречислениеСтавок.БезНДС, "n");
	СтавкаНДСПриложения = СтавкиНДС[СтавкаНДС];
	
	Возврат СтавкаНДСПриложения;
	
КонецФункции

#КонецОбласти

#КонецЕсли