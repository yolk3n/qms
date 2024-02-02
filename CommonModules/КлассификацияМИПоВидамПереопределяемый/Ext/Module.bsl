﻿
#Область ПрограммныйИнтерфейс

#Область РаботаСФормами

// Процедура, вызываемая из обработчика события формы ПриСозданииНаСервере.
//
// Параметры:
//  Форма                - ФормаКлиентскогоПриложения - форма, из обработчика события которой происходит вызов процедуры.
//  Отказ                - Булево - признак отказа от создания формы. Если установить
//                                  данному параметру значение Истина, то форма создана не будет.
//  СтандартнаяОбработка - Булево - в данный параметр передается признак выполнения стандартной (системной) обработки
//                                  события. Если установить данному параметру значение Ложь, 
//                                  стандартная обработка события производиться не будет.
//
Процедура ПриСозданииНаСервере(Форма, Отказ, СтандартнаяОбработка) Экспорт
	
	
	
КонецПроцедуры

// Вызывается из обработчика ПриЗагрузкеДанныхИзНастроекНаСервере формы.
//
// Параметры:
//  Форма     - ФормаКлиентскогоПриложения - форма, из обработчика события которой происходит вызов процедуры.
//  Настройки - Соответствие - значения реквизитов формы.
//
Процедура ПриЗагрузкеДанныхИзНастроекНаСервере(Форма, Настройки) Экспорт
	
	
	
КонецПроцедуры

#КонецОбласти

#Область ЗагрузкаКлассификаторов

// Переопределяет необходимость загрузки и обновления всего классификатора без учета ранее загруженных данных.
//
// Параметры:
//  ЗагружатьПолностью - Булево - признак необходимости загрузки и обновления всего классификатора.
//                       Истина - весь классификатор загружается и обновляется без учета ранее загруженных данных.
//                       Ложь   - (по умолчанию) значения загружаются пользователем интерактивно,
//                                 обновляются только те значения, которые были загружены ранее.
//
Процедура ЗагружатьКлассификаторПолностью(ЗагружатьПолностью) Экспорт
	
	
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти
