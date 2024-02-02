﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.УправлениеДоступом

// См. УправлениеДоступомПереопределяемый.ПриЗаполненииСписковСОграничениемДоступа.
Процедура ПриЗаполненииОграниченияДоступа(Ограничение) Экспорт

	Ограничение.Текст =
	"РазрешитьЧтениеИзменение
	|ГДЕ
	|	ЗначениеРазрешено(Организация)
	|	И ЗначениеРазрешено(Склад)
	|	И ЗначениеРазрешено(ПодразделениеОрганизации)";

КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом

#КонецОбласти

#КонецОбласти

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЙ ПРОГРАММНЫЙ ИНТЕРФЕЙС
#Область СлужебныйПрограммныйИнтерфейс

#Область РасчетСебестоимостиТоваров

Функция ХозяйственныеОперацииКорректировки() Экспорт
	
	Операции = Новый Массив;
	Операции.Добавить(Перечисления.ХозяйственныеОперации.РеализацияВРозницу);
	Операции.Добавить(Перечисления.ХозяйственныеОперации.РеализацияМатериальныхЗапасов);
	Операции.Добавить(Перечисления.ХозяйственныеОперации.ВозвратТоваровОтКлиентаПрошлыхПериодов);
	Операции.Добавить(Перечисления.ХозяйственныеОперации.СторноРеализации);
	
	Возврат Операции;
	
КонецФункции

Процедура СформироватьДвижениеКорректировки(ПараметрыРасчета, Выборка) Экспорт
	
	ИмяРегистра = СоздатьНаборЗаписей().Метаданные().Имя;
	ЗаполняемыеПоля = Новый Структура;
	ЗаполняемыеПоля.Вставить("Период");
	ЗаполняемыеПоля.Вставить("ХозяйственнаяОперация");
	ЗаполняемыеПоля.Вставить("АналитикаУчетаНоменклатуры");
	ЗаполняемыеПоля.Вставить("Организация");
	ЗаполняемыеПоля.Вставить("ИсточникФинансирования");
	ЗаполняемыеПоля.Вставить("ПодразделениеОрганизации");
	ЗаполняемыеПоля.Вставить("Контрагент");
	ЗаполняемыеПоля.Вставить("ДоговорКонтрагента");
	ЗаполняемыеПоля.Вставить("Склад");
	ЗаполняемыеПоля.Вставить("ДокументДвижения");
	ЗаполняемыеПоля = ОбщегоНазначенияКлиентСервер.КлючиСтруктурыВСтроку(ЗаполняемыеПоля);
	
	Запись = Документы.РасчетСебестоимостиТоваров.ДобавитьЗаписьВТаблицуДвижений(ПараметрыРасчета, ИмяРегистра, Выборка, ЗаполняемыеПоля);
	Если Выборка.ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ВозвратТоваровОтКлиентаПрошлыхПериодов Тогда
		Знак = -1;
	Иначе
		Знак = 1;
	КонецЕсли;
	
	Запись.Стоимость = Знак * (Выборка.СтоимостьКорректировка + Выборка.СуммаДопРасходовКорректировка);
	Запись.СтоимостьБезНДС = Знак * (Выборка.СтоимостьБезНДСКорректировка + Выборка.СуммаДопРасходовБезНДСКорректировка);
	Запись.СтоимостьРегл = Знак * Выборка.СтоимостьРеглКорректировка;
	
КонецПроцедуры

#КонецОбласти // РасчетСебестоимостиТоваров

#КонецОбласти // СлужебныйПрограммныйИнтерфейс

#КонецЕсли