﻿
////////////////////////////////////////////////////////////////////////////////
// ОПИСАНИЕ ПЕРЕМЕННЫХ
#Область ОписаниеПеременных

&НаКлиенте
Перем НачалоЗагрузки;

#КонецОбласти // ОписаниеПеременных

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	Контрагент = Константы.КонтрагентДляПроектаОперативныйМониторингЛС.Получить();
	Если Не ЗначениеЗаполнено(Контрагент) Тогда
		ВызватьИсключение НСтр("ru = 'Не настроены параметры проекта оперативного мониторинга ЛС. Для настройки параметров перейдите Администрирование - Предприятие - Оперативный мониторинг ЛС.'");
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти // ОбработчикиСобытийФормы

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ
#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Загрузить(Команда)
	
	ОчиститьСообщения();
	
	ПараметрыЗагрузки = ФайловаяСистемаКлиент.ПараметрыЗагрузкиФайла();
	ПараметрыЗагрузки.ИдентификаторФормы = УникальныйИдентификатор;
	ПараметрыЗагрузки.Диалог.Фильтр = НСтр("ru = '*.csv|*.csv'");
	ПараметрыЗагрузки.Диалог.Заголовок = НСтр("ru = 'Номенклатура в сегменте'");
	ПараметрыЗагрузки.Диалог.ПроверятьСуществованиеФайла = Истина;
	
	Оповестить = Новый ОписаниеОповещения("ПолучитьДанныеИзФайлаНаДискеЗавершение", ЭтотОбъект);
	ФайловаяСистемаКлиент.ЗагрузитьФайл(Оповестить, ПараметрыЗагрузки);
	
КонецПроцедуры

&НаКлиенте
Процедура ПолучитьДанныеИзФайлаНаДискеЗавершение(ПомещенныйФайл, ДополнительныеПараметры) Экспорт
	
	Если ЗначениеЗаполнено(ПомещенныйФайл) Тогда
		ЗагрузитьНоменклатуруСегмента(ПомещенныйФайл);
	Иначе
		УстановитьСтатусЗагрузки();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Отмена(Команда)
	
	Если Элементы.СтраницыЗагрузки.ТекущаяСтраница = Элементы.СтраницаСтатусЗагрузки Тогда
		Если ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
			ОтменитьФоновоеЗадание(ИдентификаторЗадания);
		КонецЕсли;
		УстановитьСтатусЗагрузки();
	Иначе
		Закрыть();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти // ОбработчикиКомандФормы

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ
#Область СлужебныеПроцедурыИФункции

// Устанавливает текст статус загрузки
//
&НаКлиенте
Процедура УстановитьСтатусЗагрузки(Знач Сообщение = "")
	
	
	Если ПустаяСтрока(Сообщение) Тогда
		Элементы.СтраницыЗагрузки.ТекущаяСтраница = Элементы.ГруппаПустаяГруппа;
		Элементы.Загрузить.Доступность = Истина;
	Иначе
		СтатусЗагрузки = НСтр("ru = 'Пожалуйста, подождите...'") + Символы.ПС + Сообщение;
		ОбновитьВремяРаботы();
		Элементы.СтраницыЗагрузки.ТекущаяСтраница = Элементы.СтраницаСтатусЗагрузки;
		Элементы.Загрузить.Доступность = Ложь;
	КонецЕсли;
	
	ОбновитьОтображениеДанных();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьВремяРаботы()
	
	ПрошлоВремени = ОбщегоНазначенияБольничнаяАптекаКлиентСервер.ПрошлоВремени(НачалоЗагрузки);
	ТекущееВремяРаботы = ОбщегоНазначенияБольничнаяАптекаКлиентСервер.ПредставлениеВремени(ПрошлоВремени);
	Если ВремяРаботы <> ТекущееВремяРаботы Тогда
		ВремяРаботы = ТекущееВремяРаботы;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьНоменклатуруСегмента(ОписаниеФайла)
	
	НачалоЗагрузки = ТекущаяУниверсальнаяДатаВМиллисекундах();
	УстановитьСтатусЗагрузки(НСтр("ru='Идет загрузка данных.'"));
	Задание = ЗагрузитьНоменклатуруСегментаСервер(ОписаниеФайла);
	
	ПараметрыОжидания = ДлительныеОперацииКлиент.ПараметрыОжидания(ЭтотОбъект);
	ПараметрыОжидания.ВыводитьОкноОжидания = Ложь;
	ПараметрыОжидания.ВыводитьПрогрессВыполнения = Истина;
	ПараметрыОжидания.ОповещениеОПрогрессеВыполнения = Новый ОписаниеОповещения("ОтобразитьПрогрессЗагрузки", ЭтотОбъект);
	
	Оповестить = Новый ОписаниеОповещения("ОбработатьЗавершениеЗагрузкиНоменклатурыСегмента", ЭтотОбъект);
	ДлительныеОперацииКлиент.ОжидатьЗавершение(Задание, Оповестить, ПараметрыОжидания);
	
КонецПроцедуры

&НаСервере
Функция ЗагрузитьНоменклатуруСегментаСервер(Знач ОписаниеФайла)
	
	ИмяПроцедуры = "Обработки.ОперативныйМониторингЛС.ЗагрузитьНоменклатуруСегментаИзФайла";
	ПараметрыЗагрузки = Новый Структура;
	ПараметрыЗагрузки.Вставить("ДанныеКлассификатора", ПолучитьИзВременногоХранилища(ОписаниеФайла.Хранение));
	ПараметрыЗагрузки.Вставить("Контрагент", Контрагент);
	ПараметрыЗагрузки.Вставить("ЗагружатьНоменклатуруСНулевойЦеной", ЗагружатьНоменклатуруСНулевойЦеной);
	ПараметрыЗагрузки.Вставить("ПометитьНаУдалениеОтсутствующие", ПометитьНаУдалениеОтсутствующиеВФайлеЭлементы);
	
	ПараметрыВыполнения = ДлительныеОперации.ПараметрыВыполненияВФоне(УникальныйИдентификатор);
	ПараметрыВыполнения.НаименованиеФоновогоЗадания = НСтр("ru = 'Загрузка номенклатуры сегмента'");
	
	Задание = ДлительныеОперации.ВыполнитьВФоне(ИмяПроцедуры, ПараметрыЗагрузки, ПараметрыВыполнения);
	ИдентификаторЗадания = Задание.ИдентификаторЗадания;
	
	Возврат Задание;
	
КонецФункции

&НаКлиенте
Процедура ОтобразитьПрогрессЗагрузки(СостояниеЗадания, ДополнительныеПараметры) Экспорт
	
	Если СостояниеЗадания = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если СостояниеЗадания.Статус = "Выполняется" Тогда
		Если СостояниеЗадания.Прогресс <> Неопределено Тогда
			УстановитьСтатусЗагрузки(СостояниеЗадания.Прогресс.Текст);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработатьЗавершениеЗагрузкиНоменклатурыСегмента(Результат, ДополнительныеПараметры) Экспорт
	
	ИдентификаторЗадания = Неопределено;
	
	УстановитьСтатусЗагрузки();
	Если Результат = Неопределено Тогда
		ПоказатьПредупреждение(Неопределено, НСтр("ru = 'Загрузка номенклатуры сегмента отменена.'"));
	Иначе
		Если Результат.Статус = "Ошибка" Тогда
			ТекстОшибки = НСтр("ru = 'При загрузке возникла ошибка: %1'");
			ПоказатьПредупреждение(Неопределено, СтрЗаменить(ТекстОшибки, "%1", Результат.КраткоеПредставлениеОшибки));
		Иначе
			ОповеститьОбИзменении(Тип("СправочникСсылка.НоменклатураКонтрагентов"));
			РезультатЗагрузки = ПолучитьИзВременногоХранилища(Результат.АдресРезультата);
			ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru='Загружено %1 из %2 позиций'"),
				РезультатЗагрузки.ЗагруженоСтрок,
				РезультатЗагрузки.ВсегоСтрок);
			ПоказатьОповещениеПользователя(
				НСтр("ru = 'Номенклатура сегмента успешно загружена.'"),
				,
				ТекстСообщения,
				БиблиотекаКартинок.Информация32);
			Закрыть(КодВозвратаДиалога.ОК);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработатьОшибкуПомещенияФайла(ИнформацияОбОшибке, СтандартнаяОбработка, ДополнительныеПараметры) Экспорт
	
	УстановитьСтатусЗагрузки();
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура ОтменитьФоновоеЗадание(ИдентификаторЗадания)
	
	ДлительныеОперации.ОтменитьВыполнениеЗадания(ИдентификаторЗадания);
	
КонецПроцедуры

#КонецОбласти // СлужебныеПроцедурыИФункции
