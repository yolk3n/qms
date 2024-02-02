﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2023, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, Параметры.СвойстваПодписи);
	
	Если Параметры.СвойстваПодписи.Свойство("Объект") Тогда
		ПодписанныйОбъект = Параметры.СвойстваПодписи.Объект;
	КонецЕсли;
	
	Если Параметры.СвойстваПодписи.ПодписьВерна Тогда
		СтандартныеПодсистемыСервер.УстановитьКлючНазначенияФормы(ЭтотОбъект, "");
		Элементы.Инструкция.Видимость     = Ложь;
		Элементы.ОписаниеОшибки.Видимость = Ложь;
	Иначе
		СтандартныеПодсистемыСервер.УстановитьКлючНазначенияФормы(ЭтотОбъект, "ОписаниеОшибки");
	КонецЕсли;
	
	Если Не ЭтоАдресВременногоХранилища(АдресПодписи) Тогда
		Возврат;
	КонецЕсли;
	
	АлгоритмПодписи = ЭлектроннаяПодписьСлужебныйКлиентСервер.АлгоритмСформированнойПодписи(
		АдресПодписи, Истина);
	
	АлгоритмХеширования = ЭлектроннаяПодписьСлужебныйКлиентСервер.АлгоритмХеширования(
		АдресПодписи, Истина);
		
	ОбновитьДанныеФормы();
		
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ИнструкцияНажатие(Элемент)
	
	ЭлектроннаяПодписьКлиент.ОткрытьИнструкциюПоТипичнымПроблемамПриРаботеСПрограммами();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура СохранитьВФайл(Команда)
	
	ЭлектроннаяПодписьКлиент.СохранитьПодпись(АдресПодписи);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьСертификат(Команда)
	
	Если ЗначениеЗаполнено(АдресСертификата) Тогда
		ЭлектроннаяПодписьКлиент.ОткрытьСертификат(АдресСертификата);
		
	ИначеЕсли ЗначениеЗаполнено(Отпечаток) Тогда
		ЭлектроннаяПодписьКлиент.ОткрытьСертификат(Отпечаток);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПродлитьДействиеПодписи(Команда)
	
	ОбработчикПродолжения = Новый ОписаниеОповещения("ПослеУсовершенствованияПодписи", ЭтотОбъект);
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ТипПодписи", ТипПодписи);
	ПараметрыФормы.Вставить("ПредставлениеДанных", 
		СтрШаблон("%1, %2, %3", КомуВыданСертификат, ДатаПодписи, ТипПодписи));
		
	Если ЗначениеЗаполнено(ПодписанныйОбъект) Тогда
		Структура = Новый Структура;
		Структура.Вставить("Подпись", АдресПодписи);
		Структура.Вставить("ПодписанныйОбъект", ПодписанныйОбъект);
		Структура.Вставить("ПорядковыйНомер", ПорядковыйНомер); 
		ПараметрыФормы.Вставить("Подпись", Структура);
	Иначе
		ПараметрыФормы.Вставить("Подпись", АдресПодписи);
	КонецЕсли;
	
	ЭлектроннаяПодписьКлиент.ОткрытьФормуПродленияДействияПодписей(ЭтотОбъект, ПараметрыФормы, ОбработчикПродолжения);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции


&НаСервере
Процедура ОбновитьДанныеФормы()
	
	Если ЭлектроннаяПодпись.ДоступнаУсовершенствованнаяПодпись() И ЭлектроннаяПодпись.ДобавлениеИзменениеЭлектронныхПодписей() Тогда
		Если (ЗначениеЗаполнено(СрокДействияПоследнейМеткиВремени) И СрокДействияПоследнейМеткиВремени <= ТекущаяДатаСеанса())
			Или ТипПодписи = Перечисления.ТипыПодписиКриптографии.ОбычнаяCMS Или Не ПодписьВерна Тогда
			Элементы.ФормаПродлитьДействиеПодписи.Видимость = Ложь;
		Иначе
			Элементы.ФормаПродлитьДействиеПодписи.Видимость = Истина;
		КонецЕсли;
	Иначе
		Элементы.ФормаПродлитьДействиеПодписи.Видимость = Ложь;
	КонецЕсли;
		
	Если ТипПодписи = Перечисления.ТипыПодписиКриптографии.БазоваяCAdESBES
		Или ТипПодписи = Перечисления.ТипыПодписиКриптографии.ОбычнаяCMS Тогда
		Если ЗначениеЗаполнено(СрокДействияПоследнейМеткиВремени) Тогда
			Элементы.СрокДействияПоследнейМеткиВремени.Заголовок = НСтр("ru='Срок действия сертификата подписи истек'"); 
		Иначе
			Элементы.СрокДействияПоследнейМеткиВремени.Видимость = Ложь;
		КонецЕсли;
	Иначе
		Элементы.СрокДействияПоследнейМеткиВремени.Видимость = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеУсовершенствованияПодписи(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если Результат.Успех Тогда
		
		Для Каждого КлючИЗначение Из Результат.СвойстваПодписей[0].СвойстваПодписи Цикл
			Если КлючИЗначение.Ключ = "Подпись" Тогда
				АдресПодписи = ПоместитьВоВременноеХранилище(КлючИЗначение.Значение);
				Продолжить;
			КонецЕсли;
			Если КлючИЗначение.Значение = Неопределено Тогда
				Продолжить;
			КонецЕсли;
			Если Элементы.Найти(КлючИЗначение.Ключ) = Неопределено Тогда
				Продолжить;
			КонецЕсли;
			
			ЭтотОбъект[КлючИЗначение.Ключ] = КлючИЗначение.Значение;
		КонецЦикла;
		
		ОбновитьДанныеФормы();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
