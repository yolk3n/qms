﻿#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура СогласенПриИзменении(Элемент)
	
	Элементы.ОтменитьРегистрацию.Доступность = Согласен;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОтменитьРегистрацию(Команда)
	
	МожноНачатьОтменуРегистрации = Истина;
	
	Если ИспользуетсяИнтеграцияССистемойВзаимодействияВМоделиСервиса Тогда
		
		РезультатПроверки = ПроверитьВозможностьОтключенияБазы();
		
		Если Не РезультатПроверки.МожноОтключать Тогда
			Сообщить(РезультатПроверки.ТекстСообщения);
			МожноНачатьОтменуРегистрации = Ложь;
			Возврат;
		КонецЕсли;
		
	КонецЕсли;
	
	Если МожноНачатьОтменуРегистрации Тогда
		СистемаВзаимодействия.НачатьОтменуРегистрацииИнформационнойБазы(Новый ОписаниеОповещения("ОтменаРегистрацииЗавершение", ЭтаФорма, , "ОшибкаОтменыРегистрации", ЭтаФорма));
		ЭтаФорма.Доступность = Ложь;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура Инициализировать(ИспользуетсяИнтеграцияССистемойВзаимодействия) Экспорт
	
	ИспользуетсяИнтеграцияССистемойВзаимодействияВМоделиСервиса = ИспользуетсяИнтеграцияССистемойВзаимодействия;
	
КонецПроцедуры

&НаКлиенте
Процедура ОтменаРегистрацииЗавершение(ДополнительныеПараметры) Экспорт
	
	Если ИспользуетсяИнтеграцияССистемойВзаимодействияВМоделиСервиса Тогда
		СообщитьОбОтключенииБазыВМенеджерСервиса(Истина);
	КонецЕсли;
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ОтменаРегистрацииПредупреждение", ЭтаФорма);
	ПоказатьПредупреждение(ОписаниеОповещения, НСтр("ru = 'Регистрация отменена'"));
	
КонецПроцедуры

&НаКлиенте
Процедура ОтменаРегистрацииПредупреждение(ДополнительныеПараметры) Экспорт
	
	Закрыть(1);
	
КонецПроцедуры

&НаКлиенте
Процедура ОшибкаОтменыРегистрации(ИнформацияОбОшибке, СтандартнаяОбработка, ДополнительныеПараметры) Экспорт
	
	Если ИспользуетсяИнтеграцияССистемойВзаимодействияВМоделиСервиса Тогда
		СообщитьОбОтключенииБазыВМенеджерСервиса(Ложь, КраткоеПредставлениеОшибки(ИнформацияОбОшибке));
	КонецЕсли;

	СтандартнаяОбработка = Ложь;
	ПоказатьИнформациюОбОшибке(ИнформацияОбОшибке);

	Закрыть(0);
	
КонецПроцедуры

// @skip-warning ПустойМетод - особенность реализации.
// 
// Возвращаемое значение:
//	Структура:
//	 * МожноОтключать - Булево
//	 * ТекстСообщения - Строка
//
&НаСервере
Функция ПроверитьВозможностьОтключенияБазы()
	
КонецФункции

// @skip-warning ПустойМетод - особенность реализации.
&НаСервере
Процедура СообщитьОбОтключенииБазыВМенеджерСервиса(Успешно, ТекстСообщения = "")
	
КонецПроцедуры

#КонецОбласти

