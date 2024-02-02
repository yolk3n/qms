﻿#Область ПрограммныйИнтерфейс

// Определяет менеджеры логических хранилищ.
// @skip-warning ПустойМетод - переопределяемый метод.
//
// Параметры:
//   ВсеМенеджерыЛогическихХранилищ - Соответствие - менеджеры логических хранилищ.
//    * Ключ - Строка - идентификатор логического хранилища;
//    * Значение - ОбщийМодуль - менеджер логического хранилища.
//
Процедура МенеджерыЛогическихХранилищ(ВсеМенеджерыЛогическихХранилищ) Экспорт
	
КонецПроцедуры

// Определяет менеджеры физических хранилищ.
// @skip-warning ПустойМетод - переопределяемый метод.
//
// Параметры:
//   ВсеМенеджерыФизическихХранилищ - Соответствие - менеджеры физических хранилищ.
//    * Ключ - Строка - идентификатор физического хранилища;
//    * Значение - ОбщийМодуль - менеджер физического хранилища.
//
Процедура МенеджерыФизическихХранилищ(ВсеМенеджерыФизическихХранилищ) Экспорт
	
КонецПроцедуры

// Определяет период действия временного идентификатора.
// @skip-warning ПустойМетод - переопределяемый метод.
//
// Параметры:
//   ПериодДействияВременногоИдентификатора - Число - период действия временного идентификатора.
//
Процедура ПериодДействияВременногоИдентификатора(ПериодДействияВременногоИдентификатора) Экспорт
	
КонецПроцедуры

// Определяет размер блока получения данных.
// @skip-warning ПустойМетод - переопределяемый метод.
//
// Параметры:
//   РазмерБлокаПолученияДанных - Число - размер блока получения данных в байтах.
//
Процедура РазмерБлокаПолученияДанных(РазмерБлокаПолученияДанных) Экспорт
	
КонецПроцедуры

// Определяет размер блока отправки данных.
// @skip-warning ПустойМетод - переопределяемый метод.
//
// Параметры:
//   РазмерБлокаОтправкиДанных - Число - размер блока отправки данных в байтах.
//
Процедура РазмерБлокаОтправкиДанных(РазмерБлокаОтправкиДанных) Экспорт
	
КонецПроцедуры

// Вызывается при ошибке получения данных.
// @skip-warning ПустойМетод - переопределяемый метод.
//
// Параметры:
//   Ответ - HTTPСервисОтвет - ответ сервиса при получении данных.
//
Процедура ОшибкаПриПолученииДанных(Ответ) Экспорт
	
КонецПроцедуры

// Вызывается при ошибке отправки данных.
// @skip-warning ПустойМетод - переопределяемый метод.
//
// Параметры:
//   Ответ - HTTPСервисОтвет - ответ сервиса при отправке данных.
//
Процедура ОшибкаПриОтправкеДанных(Ответ) Экспорт
	
КонецПроцедуры

// Вызывается при получении имени временного файла.
// @skip-warning ПустойМетод - переопределяемый метод.
//
// Параметры:
//   ИмяВременногоФайла - Строка - имя временного файла.
//   Расширение - Строка - желаемое расширение имени временного файла.
//   ДополнительныеПараметры - Структура - дополнительные параметры временного файла.
//
Процедура ПриПолученииИмениВременногоФайла(ИмяВременногоФайла, Расширение, ДополнительныеПараметры) Экспорт
	
КонецПроцедуры

// Вызывается при продлении действия временного идентификатора.
// @skip-warning ПустойМетод - переопределяемый метод.
//
// Параметры:
//   Идентификатор - Строка - идентификатор запроса.
//   Дата - Дата - дата регистрации запроса.
//   Запрос - Структура - исходный HTTP-запрос.
//    * HTTPМетод - Строка - HTTP-метод;
//    * БазовыйURL - Строка - базовая часть URL-запроса, включающая имя сервиса;
//    * Заголовки - ФиксированноеСоответствие - заголовки HTTP-запроса;
//    * ОтносительныйURL - Строка - относительную часть URL-адреса (относительно сервиса);
//    * ПараметрыURL - ФиксированноеСоответствие - части URL-адреса, которые были параметризованы в шаблоне;
//    * ПараметрыЗапроса - ФиксированноеСоответствие - параметры запроса (в строке URL-адреса параметры следуют после знака запроса);
//    * ИдентификаторЗапроса - Строка - уникальный идентификатор запроса;
//    * ТипЗапроса - Строка - тип запроса;
//    * ИмяВременногоФайла - Строка - имя используемого временного файла.
//
Процедура ПриПродленииДействияВременногоИдентификатора(Идентификатор, Дата, Запрос) Экспорт

КонецПроцедуры

#КонецОбласти