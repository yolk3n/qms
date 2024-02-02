﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Заполняет настройки, влияющие на использование плана обмена.
// @skip-warning ПустойМетод - особенность реализации.
// 
// Параметры:
//  Настройки - см. ОбменДаннымиСервер.НастройкиПланаОбмена
//
Процедура ПриПолученииНастроек(Настройки) Экспорт	
КонецПроцедуры

// Заполняет набор параметров, определяющих вариант настройки обмена.
// @skip-warning ПустойМетод - особенность реализации.
// 
// Параметры:
//	ОписаниеВарианта - см. ОбменДаннымиСервер.ОписаниеВариантаНастройки
//  ИдентификаторНастройки - Строка - идентификатор варианта настройки обмена.
//  ПараметрыКонтекста - Структура - см. ОбменДаннымиСервер.ПараметрыКонтекстаПолученияОписанияВариантаНастройки 
//  								 описание возвращаемого значения функции. 
//
Процедура ПриПолученииОписанияВариантаНастройки(ОписаниеВарианта, ИдентификаторНастройки,
	ПараметрыКонтекста) Экспорт
КонецПроцедуры

// Возвращает реквизиты объекта, которые не рекомендуется редактировать
// с помощью обработки группового изменения реквизитов.
// @skip-warning ПустойМетод - особенность реализации.
//
// Возвращаемое значение:
//  Массив из Строка - список имен реквизитов объекта.
//  
Функция РеквизитыНеРедактируемыеВГрупповойОбработке() Экспорт	
КонецФункции

#КонецОбласти

#КонецЕсли