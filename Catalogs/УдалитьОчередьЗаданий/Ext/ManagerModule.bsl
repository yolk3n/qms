﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
#Область СлужебныйПрограммныйИнтерфейс

Процедура ПеренестиЗадания() Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	НачатьТранзакцию();
	Попытка
		Блокировка = Новый БлокировкаДанных();
		Блокировка.Добавить("Справочник.УдалитьОчередьЗаданий");
		Блокировка.Добавить("Справочник.ОчередьЗаданий");
		Блокировка.Добавить("РегистрСведений.СвойстваЗаданий");
		Блокировка.Заблокировать();
		
		Выборка = Справочники.УдалитьОчередьЗаданий.Выбрать();
		Пока Выборка.Следующий() Цикл
			СтароеЗадание = Выборка.ПолучитьОбъект();
			НовоеЗадание = Справочники.ОчередьЗаданий.СоздатьЭлемент();
			НовоеЗадание.Использование = СтароеЗадание.Использование;
			НовоеЗадание.ЗапланированныйМоментЗапуска = СтароеЗадание.ЗапланированныйМоментЗапуска;
			НовоеЗадание.Миллисекунды = СтароеЗадание.Миллисекунды;
			НовоеЗадание.СостояниеЗадания = СтароеЗадание.СостояниеЗадания;
			НовоеЗадание.ИсполняющееФоновоеЗадание = СтароеЗадание.ИсполняющееФоновоеЗадание;
			НовоеЗадание.ЭксклюзивноеВыполнение = СтароеЗадание.ЭксклюзивноеВыполнение;
			НовоеЗадание.НомерПопытки = СтароеЗадание.НомерПопытки;
			НовоеЗадание.ИмяМетода = СтароеЗадание.ИмяМетода;
			НовоеЗадание.Параметры = СтароеЗадание.Параметры;
			НовоеЗадание.ДатаНачалаПоследнегоЗапуска = СтароеЗадание.ДатаНачалаПоследнегоЗапуска;
			НовоеЗадание.ДатаЗавершенияПоследнегоЗапуска = СтароеЗадание.ДатаЗавершенияПоследнегоЗапуска;
			НовоеЗадание.Ключ = СтароеЗадание.Ключ;
			НовоеЗадание.ИнтервалПовтораПриАварийномЗавершении = СтароеЗадание.ИнтервалПовтораПриАварийномЗавершении;
			НовоеЗадание.Расписание = СтароеЗадание.Расписание;
			НовоеЗадание.КоличествоПовторовПриАварийномЗавершении = СтароеЗадание.КоличествоПовторовПриАварийномЗавершении;
			НовоеЗадание.ИмяПользователя = СтароеЗадание.ИмяПользователя;
			НоваяСсылка = Справочники.ОчередьЗаданий.ПолучитьСсылку(Выборка.Ссылка.УникальныйИдентификатор());
			НовоеЗадание.УстановитьСсылкуНового(НоваяСсылка);
			НовоеЗадание.ОбменДанными.Загрузка = Истина;
			НовоеЗадание.Записать();
			СтароеЗадание.ОбменДанными.Загрузка = Истина;
			СтароеЗадание.Удалить();
		КонецЦикла;
		
		Запрос = Новый Запрос;
		Запрос.Текст =
		"ВЫБРАТЬ
		|	СвойстваЗаданий.ИдентификаторЗадания
		|ИЗ
		|	РегистрСведений.СвойстваЗаданий КАК СвойстваЗаданий
		|ГДЕ
		|	СвойстваЗаданий.Задание ССЫЛКА Справочник.УдалитьОчередьЗаданий";
		Выборка = Запрос.Выполнить().Выбрать();
		Пока Выборка.Следующий() Цикл
			НаборЗаписей = РегистрыСведений.СвойстваЗаданий.СоздатьНаборЗаписей();
			НаборЗаписей.Отбор.ИдентификаторЗадания.Установить(Выборка.ИдентификаторЗадания);
			НаборЗаписей.Прочитать();
			Для Каждого Запись Из НаборЗаписей Цикл
				Запись.Задание = Справочники.ОчередьЗаданий.ПолучитьСсылку(Запись.Задание.УникальныйИдентификатор());
			КонецЦикла;
			НаборЗаписей.ОбменДанными.Загрузка = Истина;
			НаборЗаписей.Записать();
		КонецЦикла;
		
		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
		ВызватьИсключение;
	КонецПопытки;
		
КонецПроцедуры

#КонецОбласти
	
#КонецЕсли