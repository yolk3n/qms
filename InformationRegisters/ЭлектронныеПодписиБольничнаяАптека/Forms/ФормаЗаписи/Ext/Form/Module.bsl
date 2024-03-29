﻿
////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	МенеджерЗаписи = Неопределено;
	
	Если Не Параметры.Ключ.Пустой()Тогда
		МенеджерЗаписи = ЭлектроннаяПодписьБольничнаяАптека.ПолучитьЭлектроннуюПодпись(Запись.Объект, Запись.УникальныйИдентификатор);
	ИначеЕсли Параметры.Свойство("Объект") И Параметры.Свойство("УникальныйИдентификатор") Тогда
		МенеджерЗаписи = ЭлектроннаяПодписьБольничнаяАптека.ПолучитьЭлектроннуюПодпись(Параметры.Объект, Параметры.УникальныйИдентификатор);
	Иначе
		ВызватьИсключение НСтр("ru = 'Не хватает параметров для открытия формы просмотра ЭП.'");
	КонецЕсли;
	
	Если МенеджерЗаписи = Неопределено Тогда
		ВызватьИсключение НСтр("ru = 'Электронная подпись не найдена'");
	КонецЕсли;
	
	ЗначениеВРеквизитФормы(МенеджерЗаписи, "Запись");
	
	Если Не ЗначениеЗаполнено(Запись.Комментарий) Тогда
		Запись.Комментарий = НСтр("ru = 'Не указан'");
		Элементы.Комментарий.ЦветТекста = ЦветаСтиля.ЦветНедоступногоТекста;
	КонецЕсли;
	
	ОбщийСтатусПроверки = ЭлектроннаяПодписьБольничнаяАптекаКлиентСервер.ПолучитьОбщийСтатусПроверкиПодписи(
		Запись.ПодписьВерна, Запись.СертификатДействителен, Запись.ДатаПроверкиПодписи);
	
	СтатусПодписи = "НеПроверена";
	ОбщийСтатусПроверкиКартинка = 1;
	Если ЗначениеЗаполнено(Запись.ДатаПроверкиПодписи) Тогда
		Если Запись.ПодписьВерна Тогда
			СтатусПодписи = "Верна";
			ОбщийСтатусПроверкиКартинка = 2;
		Иначе
			СтатусПодписи = "НеВерна";
			ОбщийСтатусПроверкиКартинка = 3;
		КонецЕсли;
	КонецЕсли;
	
	Если СтатусПодписи = "Верна" Тогда
		Элементы.ГруппаОсновная.ЦветФона = ЦветаСтиля.ФонПодписьВерна;
		Элементы.СтатусПроверки.ЦветТекста = ЦветаСтиля.ОтметкаПоложительногоВыполненияЗадачи;
	ИначеЕсли СтатусПодписи = "НеВерна" Тогда
		Элементы.ГруппаОсновная.ЦветФона = ЦветаСтиля.ФонПодписьНеверна;
		Элементы.СтатусПроверки.ЦветТекста = ЦветаСтиля.ОтметкаОтрицательногоВыполненияЗадачи;
	КонецЕсли;
	
	Если Параметры.Свойство("АдресПодписи") Тогда
		АдресПодписи = Параметры.АдресПодписи;
	Иначе
		ДвоичныеДанные = МенеджерЗаписи.Подпись.Получить();
		Если ДвоичныеДанные <> Неопределено Тогда 
			АдресПодписи = ПоместитьВоВременноеХранилище(ДвоичныеДанные, УникальныйИдентификатор);
		КонецЕсли;
	КонецЕсли;
	
	Если Параметры.Свойство("АдресСертификата") Тогда
		АдресСертификата = Параметры.АдресСертификата;
	Иначе
		ДвоичныеДанные = МенеджерЗаписи.Сертификат.Получить();
		Если ДвоичныеДанные <> Неопределено Тогда 
			АдресСертификата = ПоместитьВоВременноеХранилище(ДвоичныеДанные, УникальныйИдентификатор);
		КонецЕсли;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Запись.ТекстОшибкиПроверкиПодписи) Тогда
		КлючСохраненияПоложенияОкна = "ФормаЗаписиСТекстомПричины";
		ТекстПричины = Запись.ТекстОшибкиПроверкиПодписи;
		Элементы.ТекстПричины.Заголовок = НСтр("ru = 'Подпись не прошла проверку по причине'");
	ИначеЕсли ЗначениеЗаполнено(Запись.ТекстОшибкиПроверкиСертификата) Тогда
		КлючСохраненияПоложенияОкна = "ФормаЗаписиСТекстомПричины";
		Элементы.ТекстПричины.Заголовок = НСтр("ru = 'Сертификат не прошел проверку по причине'");
		ТекстПричины = Запись.ТекстОшибкиПроверкиСертификата;
	Иначе
		Элементы.ТекстПричины.Видимость = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СертификатНажатие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	Если Не ЗначениеЗаполнено(АдресСертификата) Тогда
		ЭлектроннаяПодписьКлиент.ОткрытьСертификат(Запись.Отпечаток, Истина);
	Иначе
		ЭлектроннаяПодписьКлиент.ОткрытьСертификат(АдресСертификата, Истина);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти // ОбработчикиСобытийФормы

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ
#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Выгрузить(Команда)
	
	ЭлектроннаяПодписьКлиент.СохранитьПодпись(АдресПодписи);
	
КонецПроцедуры

#КонецОбласти // ОбработчикиКомандФормы
