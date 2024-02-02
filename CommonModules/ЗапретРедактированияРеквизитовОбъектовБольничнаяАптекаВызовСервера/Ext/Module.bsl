﻿
////////////////////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС
#Область ПрограммныйИнтерфейс

// Функция выполняет проверку использования объекта в длительной операции
Функция ПроверитьИспользованиеОбъекта(Ссылка, УникальныйИдентификатор, ИспользоватьЛокальнуюФункциюПроверки = Ложь) Экспорт
	
	ПараметрыПроверки = Новый Структура;
	ПараметрыПроверки.Вставить("Объект", Ссылка);
	
	Если ИспользоватьЛокальнуюФункциюПроверки Тогда
		ПроцедураПроверки = ОбщегоНазначения.ИмяБазовогоТипаПоОбъектуМетаданных(Ссылка.Метаданные())
		                  + "." +Ссылка.Метаданные().Имя
		                  + ".ПроверитьИспользованиеОбъекта";
	Иначе
		ПроцедураПроверки = "ОбщегоНазначенияБольничнаяАптека.ПроверитьИспользованиеОбъекта";
	КонецЕсли;
	
	ПараметрыВыполнения = ДлительныеОперации.ПараметрыВыполненияВФоне(УникальныйИдентификатор);
	ПараметрыВыполнения.НаименованиеФоновогоЗадания = СтрЗаменить(НСтр("ru = 'Проверка использования объекта %1'"), "%1", Ссылка);
	
	Результат = ДлительныеОперации.ВыполнитьВФоне(ПроцедураПроверки, ПараметрыПроверки, ПараметрыВыполнения);
	Возврат Результат;
	
КонецФункции

// Возвращает блокируемые реквизиты объекта по форме разблокировки
//
// Параметры:
//  ИмяФормыРазблокировки - Строка - полное имя формы разблокировки реквизитов объекта
//
Функция ПолучитьБлокируемыеРеквизитыОбъекта(ИмяФормыРазблокировки) Экспорт
	
	МетаданныеОбъекта = Метаданные.НайтиПоПолномуИмени(ИмяФормыРазблокировки).Родитель();
	МенеджерОбъекта = ОбщегоНазначения.МенеджерОбъектаПоПолномуИмени(МетаданныеОбъекта.ПолноеИмя());
	Возврат МенеджерОбъекта.ПолучитьБлокируемыеРеквизитыОбъекта();
	
КонецФункции

#КонецОбласти
