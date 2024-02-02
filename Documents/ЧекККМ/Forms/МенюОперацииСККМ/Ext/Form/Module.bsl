﻿
////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	// ПодключаемоеОборудование
	ПодключаемоеОборудованиеСервер.НастроитьФормуДляИспользованияПодключаемогоОборудования(ЭтотОбъект);
	// Конец ПодключаемоеОборудование
	
	КассаККМ = Параметры.КассаККМ;
	Кассир   = Параметры.Кассир;
	РеквизитыКассира = РозничныеПродажи.РеквизитыКассира(Кассир);
	
	НастроитьФомуПоКассеККМ();
	
	НастроитьРМК();
	
	ОбновитьЗаголовкиФормы(ЭтотОбъект);
	
КонецПроцедуры

#КонецОбласти

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ
#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ИзменитьКассуККМ(Команда)
	
	Отбор = Новый Структура("Ссылка", ДоступныеКассыККМ);
	ПараметрыОткрытия = Новый Структура("Отбор", Отбор);
	
	Оповестить = Новый ОписаниеОповещения("ИзменитьКассуККМЗавершение", ЭтотОбъект);
	ОткрытьФорму("Справочник.КассыККМ.ФормаВыбора", ПараметрыОткрытия,,,,, Оповестить, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьКассовуюСмену(Команда)
	
	ОчиститьСообщения();
	
	ПараметрыОперации = ПараметрыОперацииНаФискальномУстройстве();
	Оповестить = Новый ОписаниеОповещения("ОткрытьКассовуюСменуЗавершение", ЭтотОбъект);
	РозничныеПродажиКлиент.ОткрытьКассовуюСмену(ПараметрыКассыККМ, ПараметрыОперации, Оповестить);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗакрытьКассовуюСмену(Команда)
	
	ОчиститьСообщения();
	
	ПараметрыОперации = ПараметрыОперацииНаФискальномУстройстве();
	Оповестить = Новый ОписаниеОповещения("ЗакрытьКассовуюСменуЗавершение", ЭтотОбъект);
	РозничныеПродажиКлиент.ЗакрытьКассовуюСмену(ПараметрыКассыККМ, ПараметрыОперации, Оповестить);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтчетБезГашения(Команда)
	
	ПараметрыОперации = ПараметрыОперацииНаФискальномУстройстве();
	Оповестить = Новый ОписаниеОповещения("НапечататьОтчетБезГашенияЗавершение", ЭтотОбъект);
	РозничныеПродажиКлиент.НапечататьОтчетБезГашения(ПараметрыКассыККМ, ПараметрыОперации, Оповестить);
	
КонецПроцедуры

&НаКлиенте
Процедура ВнесениеДенежныхСредств(Команда)
	
	Оповестить = Новый ОписаниеОповещения("ВнесениеДенегЗавершение", ЭтотОбъект);
	РозничныеПродажиКлиент.ВнестиДенежныеСредстваВКассу(ЭтотОбъект, Оповестить);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыемкаДенежныхСредств(Команда)
	
	Оповестить = Новый ОписаниеОповещения("ВыемкаДенегЗавершение", ЭтотОбъект);
	РозничныеПродажиКлиент.ИзъятьДенежныеСредстваИзКассы(ЭтотОбъект, Оповестить);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьДенежныйЯщик(Команда)
	
	ИдентификаторУстройстваФР = ПараметрыКассыККМ.ИдентификаторУстройства;
	
	ОборудованиеЧекопечатающиеУстройстваКлиент.НачатьОткрытиеДенежногоЯщика(
		Новый ОписаниеОповещения("ОткрытиеДенежногоЯщикаЗавершение", ЭтотОбъект),
		ЭтотОбъект,
		ИдентификаторУстройстваФР);
	
КонецПроцедуры

#КонецОбласти

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ
#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ОткрытьКассовуюСменуЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	ОбновитьЗаголовкиФормы(ЭтотОбъект);
	
	Если Результат И ЗакрыватьФормуПослеЗавершенияОперации Тогда
		Закрыть();
	КонецЕсли;
	
	Оповестить("ИзменениеКассовойСмены");
	
КонецПроцедуры

&НаКлиенте
Процедура ЗакрытьКассовуюСменуЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	ОбновитьЗаголовкиФормы(ЭтотОбъект);
	
	Если Результат И ЗакрыватьФормуПослеЗавершенияОперации Тогда
		Закрыть();
	КонецЕсли;
	
	Оповестить("ИзменениеКассовойСмены");
	
КонецПроцедуры

&НаКлиенте
Процедура НапечататьОтчетБезГашенияЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат И ЗакрыватьФормуПослеЗавершенияОперации Тогда
		Закрыть();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВнесениеДенегЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	ОбновитьЗаголовкиФормы(ЭтотОбъект);
	
	Если Результат И ЗакрыватьФормуПослеЗавершенияОперации Тогда
		Закрыть();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыемкаДенегЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	ОбновитьЗаголовкиФормы(ЭтотОбъект);
	
	Если Результат И ЗакрыватьФормуПослеЗавершенияОперации Тогда
		Закрыть();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ОбновитьЗаголовкиФормы(Форма)
	
	Форма.СостояниеКассовойСмены = РозничныеПродажиВызовСервера.СостояниеКассовойСмены(Форма.КассаККМ);
	
	Форма.Элементы.ОткрытьКассовуюСмену.Доступность = Форма.ПраваДоступа.ОткрытьСмену И Не Форма.СостояниеКассовойСмены.СменаОткрыта;
	Форма.Элементы.ЗакрытьКассовуюСмену.Доступность = Форма.ПраваДоступа.ЗакрытьСмену И    Форма.СостояниеКассовойСмены.СменаОткрыта;
	
	Форма.Элементы.ВнесениеДенежныхСредств.Доступность = Форма.ПраваДоступа.ВнесениеДенег;
	Форма.Элементы.ВыемкаДенежныхСредств.Доступность   = Форма.ПраваДоступа.ВыемкаДенег;
	
	Форма.Элементы.ГруппаКассаККМ.Заголовок = Строка(Форма.КассаККМ);
	
	Если ЗначениеЗаполнено(Форма.СостояниеКассовойСмены.СтатусКассовойСмены) Тогда
		
		ЗаголовокГруппыОперацииСКассовойСменой = НСтр("ru = 'Статус смены: %СтатусСмены% %ВремяИзменения%'");
		
		ЗаголовокГруппыОперацииСКассовойСменой = СтрЗаменить(ЗаголовокГруппыОперацииСКассовойСменой, "%СтатусСмены%", Форма.СостояниеКассовойСмены.СтатусКассовойСмены);
		ЗаголовокГруппыОперацииСКассовойСменой = СтрЗаменить(ЗаголовокГруппыОперацииСКассовойСменой, "%ВремяИзменения%", Формат(Форма.СостояниеКассовойСмены.ДатаИзмененияСтатуса, "ДЛФ=DT"));
		
	Иначе
		
		ЗаголовокГруппыОперацииСКассовойСменой = НСтр("ru = 'Смена не открыта'");
		
	КонецЕсли;
	Форма.Элементы.ГруппаОперацииСКассовойСменой.Заголовок = ЗаголовокГруппыОперацииСКассовойСменой;
	
	ЗаголовокГруппыДенежныеОперации = НСтр("ru = 'В кассе %НаличностьВКассе% %Валюта%'");
	
	ЗаголовокГруппыДенежныеОперации = СтрЗаменить(ЗаголовокГруппыДенежныеОперации, "%НаличностьВКассе%", Форма.СостояниеКассовойСмены.НаличностьВКассе);
	ЗаголовокГруппыДенежныеОперации = СтрЗаменить(ЗаголовокГруппыДенежныеОперации, "%Валюта%", Форма.СостояниеКассовойСмены.ВалютаПредставление);
	Форма.Элементы.ГруппаДенежныеОперации.Заголовок = ЗаголовокГруппыДенежныеОперации;
	
КонецПроцедуры

&НаКлиенте
Процедура ИзменитьКассуККМЗавершение(ВыбраннаяКассаККМ, ДополнительныеПараметры) Экспорт
	
	Если Не ЗначениеЗаполнено(ВыбраннаяКассаККМ) Тогда
		Возврат;
	КонецЕсли;
	
	КассаККМ = ВыбраннаяКассаККМ;
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ИзменитьКассуККМЗавершение", ВладелецФормы);
	ВыполнитьОбработкуОповещения(ОписаниеОповещения, КассаККМ);
	
	Если ЗакрыватьФормуПослеЗавершенияОперации Тогда
		Закрыть();
	Иначе
		НастроитьФомуПоКассеККМ();
		ОбновитьЗаголовкиФормы(ЭтотОбъект);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытиеДенежногоЯщикаЗавершение(РезультатВыполнения, Параметры) Экспорт
	
	Если Не РезультатВыполнения.Результат Тогда
		ОбщегоНазначенияКлиент.СообщитьПользователю(НСтр("ru = 'При открытии денежного ящика возникла ошибка.'"));
		Возврат;
	КонецЕсли;
	
	Если ЗакрыватьФормуПослеЗавершенияОперации Тогда
		Закрыть();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура НастроитьФомуПоКассеККМ()
	
	СостояниеКассовойСмены = РозничныеПродажиВызовСервера.СостояниеКассовойСмены(КассаККМ);
	ПараметрыКассыККМ = Новый ФиксированнаяСтруктура(Справочники.КассыККМ.ПараметрыКассыККМ(КассаККМ));
	
	ИспользоватьОборудование = ПодключаемоеОборудованиеКлиентСервер.ИспользоватьПодключаемоеОборудование(ЭтотОбъект) И Не ПараметрыКассыККМ.ИспользоватьБезПодключенияОборудования;
	Элементы.ОткрытьДенежныйЯщик.Видимость = ИспользоватьОборудование;
	Элементы.ОтчетБезГашения.Видимость = ИспользоватьОборудование;
	
КонецПроцедуры

&НаСервере
Процедура НастроитьРМК()
	
	ПраваДоступа = РозничныеПродажи.ПраваДоступаРМК(Кассир);
	
	РозничныеПродажи.ПодписатьГорячиеКлавишиНаКнопках(ЭтотОбъект);
	
	Запрос = Новый Запрос("
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	КассыККМ.Ссылка КАК КассаККМ
	|ИЗ
	|	Справочник.КассыККМ КАК КассыККМ
	|ГДЕ
	|	НЕ КассыККМ.ПометкаУдаления
	|	И КассыККМ.ТипКассы = ЗНАЧЕНИЕ(Перечисление.ТипыКассККМ.ФискальныйРегистратор)
	|	И (КассыККМ.ПодключаемоеОборудование.РабочееМесто = &РабочееМесто
	|		ИЛИ КассыККМ.ИспользоватьБезПодключенияОборудования
	|		ИЛИ НЕ &ИспользоватьПодключаемоеОборудование)
	|");
	
	РабочееМесто = МенеджерОборудованияВызовСервера.РабочееМестоКлиента();
	Запрос.УстановитьПараметр("РабочееМесто", РабочееМесто);
	Запрос.УстановитьПараметр("КассаККМ", КассаККМ);
	Запрос.УстановитьПараметр("ИспользоватьПодключаемоеОборудование", ПодключаемоеОборудованиеКлиентСервер.ИспользоватьПодключаемоеОборудование(ЭтотОбъект));
	
	ДоступныеКассыККМ.ЗагрузитьЗначения(Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("КассаККМ"));
	
	Элементы.ИзменитьКассуККМ.Видимость = ДоступныеКассыККМ.Количество() > 1 И Параметры.ИзменитьКассуККМ;
	
КонецПроцедуры

&НаКлиенте
Функция ПараметрыОперацииНаФискальномУстройстве()
	
	ПараметрыОперации = ОборудованиеЧекопечатающиеУстройстваКлиентСервер.ПараметрыВыполненияОперации();
	ПараметрыОперации.Кассир = РеквизитыКассира.Наименование;
	ПараметрыОперации.КассирИНН = РеквизитыКассира.ИНН;
	
	Возврат ПараметрыОперации;
	
КонецФункции

#КонецОбласти