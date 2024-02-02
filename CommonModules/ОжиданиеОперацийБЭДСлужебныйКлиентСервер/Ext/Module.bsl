﻿#Область СлужебныеПроцедурыИФункции

Функция ИмяСобытияЗакрытияФормы() Экспорт
	
	Возврат "ЗакрытьФормуДлительнойОперации";
	
КонецФункции

Функция ИмяСобытияОбновленияПрогресса() Экспорт
	
	Возврат "ОбновитьПрогрессДлительнойОперации";
	
КонецФункции

Функция ИмяСобытияПередИнтерактивнымДействием() Экспорт
	
	Возврат "ПередИнтерактивнымДействиемВДлительнойОперации";
	
КонецФункции

// Конструктор параметров ожидания операции.
// 
// Возвращаемое значение:
// 	Структура - Описание:
// * ПроцентПрогресса - Число - число процентов выполнения операции. Если не задано, индикатор прогресса выводиться не будет. 
// * ТекстСообщения - Строка - текст сообщения, который будет выведен напротив "колеса" ожидания.
// * Заголовок - Строка - текст, который будет выведен в заголовке формы.
// * ОперацияЗавершена - Булево - признак того что форму ожидания нужно перевести в состояние завершенной операции.
Функция НовыеПараметры() Экспорт

	Параметры = Новый Структура;
	Параметры.Вставить("Заголовок", "");
	Параметры.Вставить("ТекстСообщения", "");
	Параметры.Вставить("ПроцентПрогресса");
	Параметры.Вставить("ОперацияЗавершена", Ложь);

	Возврат Параметры;

КонецФункции

#КонецОбласти