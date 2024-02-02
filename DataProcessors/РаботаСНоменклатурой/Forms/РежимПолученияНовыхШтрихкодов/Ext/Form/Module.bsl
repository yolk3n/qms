﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ПолучитьШтрихкоды            = Параметры.ПолучитьШтрихкоды;
	ПолучитьТехническиеШтрихкоды = Параметры.ПолучитьТехническиеШтрихкоды;
	ИспользоватьШтрихкодыБазы    = Параметры.ИспользоватьШтрихкодыБазы;
	
	Если Не ПолучитьШтрихкоды Тогда
		РежимПолученияНовыхШтрихкодов = 0;
	ИначеЕсли ИспользоватьШтрихкодыБазы Тогда 
		РежимПолученияНовыхШтрихкодов = 1;
	Иначе
		РежимПолученияНовыхШтрихкодов = 2;
	КонецЕсли;
	
	УстановитьСвойстваЭлементаРежимПолученияНовыхШтрихкодов();
	УстановитьСвойстваЭлементаПолучитьТехническиеШтрихкоды();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура РежимПриИзменении(Элемент)
	
	Если РежимПолученияНовыхШтрихкодов = 0 Тогда
		ПолучитьШтрихкоды = Ложь;
	ИначеЕсли РежимПолученияНовыхШтрихкодов = 1 Тогда
		ПолучитьШтрихкоды = Истина;
		ИспользоватьШтрихкодыБазы = Истина;
	ИначеЕсли РежимПолученияНовыхШтрихкодов = 2 Тогда
		ПолучитьШтрихкоды = Истина;
		ИспользоватьШтрихкодыБазы = Ложь;
	КонецЕсли;
	
	УстановитьСвойстваЭлементаРежимПолученияНовыхШтрихкодов();
	
КонецПроцедуры

&НаКлиенте
Процедура ПолучитьТехническиеШтрихкодыПриИзменении(Элемент)
	УстановитьСвойстваЭлементаПолучитьТехническиеШтрихкоды();
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура КомандаОК(Команда)
	
	ПараметрыЗакрытия = РаботаСНоменклатуройСлужебныйКлиент.НовыйРежимПолученияШтрихкодов();
	ПараметрыЗакрытия.ПолучитьШтрихкоды = ПолучитьШтрихкоды;
	ПараметрыЗакрытия.ПолучитьТехническиеШтрихкоды = ПолучитьТехническиеШтрихкоды;
	ПараметрыЗакрытия.ИспользоватьШтрихкодыБазы = ИспользоватьШтрихкодыБазы;
	Закрыть(ПараметрыЗакрытия);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьСвойстваЭлементаРежимПолученияНовыхШтрихкодов()
	
	Если РежимПолученияНовыхШтрихкодов = 0 Тогда
		РежимЗаголовок = НСтр("ru = 'Выгрузить товары со штрихкодами, которые уже есть в базе. Новые не получать.'");
		ВидДоступность = Ложь;
		ВидЗаголовок   = НСтр("ru = 'Какие штрихкоды получать (не применимо)'");
	ИначеЕсли РежимПолученияНовыхШтрихкодов = 1 Тогда
		РежимЗаголовок = НСтр("ru = 'Получать штрихкоды только на те товары, у которых их нет.'");
		ВидДоступность = Истина;
		ВидЗаголовок   = НСтр("ru = 'Какие штрихкоды получать'");
	ИначеЕсли РежимПолученияНовыхШтрихкодов = 2 Тогда
		РежимЗаголовок = НСтр("ru = 'Получить новые штрихкоды на все выгружаемые товары'");
		ВидДоступность = Истина;
		ВидЗаголовок   = НСтр("ru = 'Какие штрихкоды получать'");
	КонецЕсли;
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, 
		"РежимПолученияНовыхШтрихкодовРасширеннаяПодсказка", "Заголовок", РежимЗаголовок);
		
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, 
		"ПолучитьТехническиеШтрихкодыГруппа", "Доступность", ВидДоступность);
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, 
		"ПолучитьТехническиеШтрихкодыГруппа", "Заголовок", ВидЗаголовок);
	
КонецПроцедуры

&НаСервере
Процедура УстановитьСвойстваЭлементаПолучитьТехническиеШтрихкоды()
	
	ТекстЗаголовка = ?(ПолучитьТехническиеШтрихкоды,
	              НСтр("ru = 'Технические штрихкоды выпускает Национальный каталог, членство в ГС1 РУС не требуется.'"),
	              НСтр("ru = 'Данная возможность доступна если организация является членом ГС1 РУС.'"));
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, 
		"ПолучитьТехническиеШтрихкодыПояснение", "Заголовок", ТекстЗаголовка);
	
КонецПроцедуры

#КонецОбласти