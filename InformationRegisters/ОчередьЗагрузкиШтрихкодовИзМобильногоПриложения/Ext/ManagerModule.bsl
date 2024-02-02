﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

////////////////////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС
#Область ПрограммныйИнтерфейс

// Получает штрихкоды номенклатуры, помещенные в очередь, из мобильного приложения.
//
// Параметры:
//  Свойства       - Строка - (необязательный) набор свойств, перечисленных через запятую, которые нужно получить из очереди.
//  Пользователь   - СправочникСсылка.Пользователи - (необязательный) пользователь, от имени которого были сформированы данные.
//                   Если не установлен, будут получены данные текущего пользователя.
//
// Возвращаемое значение:
//  ДанныеРезультат - Массив - состоящий из структур с элементами переданных свойств.
//
Функция ПолучитьШтрихкодыИзОчереди(Свойства = "", Пользователь = Неопределено) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Если Пользователь = Неопределено Тогда
		Пользователь = Пользователи.ТекущийПользователь();
	КонецЕсли;
	
	Если ПустаяСтрока(Свойства) Тогда
		Свойства = СвойтсваОчередиДляЗагрузкиИзМобильногоПриложения();
	КонецЕсли;
	
	НачатьТранзакцию();
	Попытка
		
		Блокировка = Новый БлокировкаДанных;
		ЭлементБлокировки = Блокировка.Добавить(Метаданные.РегистрыСведений.ОчередьЗагрузкиШтрихкодовИзМобильногоПриложения.ПолноеИмя());
		ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
		ЭлементБлокировки.УстановитьЗначение("Пользователь", Пользователь);
		Блокировка.Заблокировать();
		
		Набор = РегистрыСведений.ОчередьЗагрузкиШтрихкодовИзМобильногоПриложения.СоздатьНаборЗаписей();
		Набор.Отбор.Пользователь.Установить(Пользователь);
		Набор.Прочитать();
		
		ДанныеРезультат = Новый Массив;
		Для Каждого Запись Из Набор Цикл
			
			ЭлементДанныхРезультат = Новый Структура(Свойства);
			ЗаполнитьЗначенияСвойств(ЭлементДанныхРезультат, Запись);
			ДанныеРезультат.Добавить(ЭлементДанныхРезультат);
			
			Запись.Статус = Перечисления.СтатусыОчередиЗагрузкиШтрихкодовИзМобильногоПриложения.ЗагруженВДокумент;
			
		КонецЦикла;
		
		Набор.Записать();
		
		ЗафиксироватьТранзакцию();
		
	Исключение
		
		ОтменитьТранзакцию();
		Текст = НСтр("ru = 'При получении данных мобильного приложения из очереди возникла ошибка:'");
		Текст = Текст + Символы.ПС + ОбработкаОшибок.ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
		ВызватьИсключение Текст;
		
	КонецПопытки;
	
	Возврат ДанныеРезультат;
	
КонецФункции

// Записывает штрихкоды номенклатуры в очередь из мобильного приложения.
//
// Параметры:
//  Пользователь   - СправочникСсылка.Пользователи - пользователь, которому пренадлежит запись в очереди;
//  ДанныеУпаковок - Структура - данные упаковок, записываемые в очередь.
//
Процедура ЗаписатьШтрихкодыВОчередь(Пользователь, ДанныеУпаковок) Экспорт
	
	НачатьТранзакцию();
	Попытка
		
		СтатусЗаменяемыхЗаписей = Перечисления.СтатусыОчередиЗагрузкиШтрихкодовИзМобильногоПриложения.ЗагруженВДокумент;
		СтатусНовыхЗаписей      = Перечисления.СтатусыОчередиЗагрузкиШтрихкодовИзМобильногоПриложения.ПолученИзМобильногоПриложения;
		
		Блокировка = Новый БлокировкаДанных;
		ЭлементБлокировки = Блокировка.Добавить(Метаданные.РегистрыСведений.ОчередьЗагрузкиШтрихкодовИзМобильногоПриложения.ПолноеИмя());
		ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
		ЭлементБлокировки.УстановитьЗначение("Пользователь", Пользователь);
		Блокировка.Заблокировать();
		
		// Очистка обработанных записей.
		Набор = РегистрыСведений.ОчередьЗагрузкиШтрихкодовИзМобильногоПриложения.СоздатьНаборЗаписей();
		Набор.Отбор.Пользователь.Установить(Пользователь);
		Набор.Отбор.Статус.Установить(СтатусЗаменяемыхЗаписей);
		Набор.Записать();
		
		// Добавлениеуникальных записей.
		Для Каждого ЭлементДанных Из ДанныеУпаковок Цикл
			Запись = РегистрыСведений.ОчередьЗагрузкиШтрихкодовИзМобильногоПриложения.СоздатьМенеджерЗаписи();
			ЗаполнитьЗначенияСвойств(Запись, ЭлементДанных);
			Запись.Пользователь = Пользователь;
			Запись.Статус       = СтатусНовыхЗаписей;
			Запись.Записать();
		КонецЦикла;
		
		ЗафиксироватьТранзакцию();
		
	Исключение
		
		ОтменитьТранзакцию();
		Текст = НСтр("ru = 'При записи штрихкодов в очередь возникла ошибка:'");
		Текст = Текст + Символы.ПС + ОбработкаОшибок.ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
		ВызватьИсключение Текст;
		
	КонецПопытки;
	
КонецПроцедуры

// Свойства очереди, для формирования данных, записываемых в очередь.
//
Функция СвойтсваОчередиДляЗагрузкиИзМобильногоПриложения() Экспорт
	
	СвойстваОчереди = Новый Массив;
	
	МетаданныеРегистра = Метаданные.РегистрыСведений.ОчередьЗагрузкиШтрихкодовИзМобильногоПриложения;
	Для Каждого Измерение Из МетаданныеРегистра.Измерения Цикл
		СвойстваОчереди.Добавить(Измерение.Имя);
	КонецЦикла;
	Для Каждого Ресурс Из МетаданныеРегистра.Ресурсы Цикл
		СвойстваОчереди.Добавить(Ресурс.Имя);
	КонецЦикла;
	Для Каждого Реквизит Из МетаданныеРегистра.Реквизиты Цикл
		СвойстваОчереди.Добавить(Реквизит.Имя);
	КонецЦикла;
	
	Возврат СтрСоединить(СвойстваОчереди, ",");
	
КонецФункции

#КонецОбласти

#КонецЕсли