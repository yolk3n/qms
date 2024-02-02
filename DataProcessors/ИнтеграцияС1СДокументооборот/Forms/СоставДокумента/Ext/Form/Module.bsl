﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Документ = Параметры.Документ;
	ДокументID = Параметры.ДокументID;
	ДокументТип = Параметры.ДокументТип;
	
	КоличествоЛистов = Параметры.КоличествоЛистов;
	КоличествоЭкземпляров = Параметры.КоличествоЭкземпляров;
	КоличествоПриложений = Параметры.КоличествоПриложений;
	ЛистовВПриложениях = Параметры.ЛистовВПриложениях;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОК(Команда)
	
	ОчиститьСообщения();
	Если Не ПроверитьЗаполнение() Тогда
		Возврат;
	КонецЕсли;
	
	Результат = Новый Структура;
	Результат.Вставить("КоличествоЛистов", КоличествоЛистов);
	Результат.Вставить("КоличествоПриложений", КоличествоПриложений);
	Результат.Вставить("КоличествоЭкземпляров", КоличествоЭкземпляров);
	Результат.Вставить("ЛистовВПриложениях", ЛистовВПриложениях);
	
	Закрыть(Результат);
	
КонецПроцедуры

&НаКлиенте
Процедура Отмена(Команда)
	
	Закрыть();
	
КонецПроцедуры

#КонецОбласти
