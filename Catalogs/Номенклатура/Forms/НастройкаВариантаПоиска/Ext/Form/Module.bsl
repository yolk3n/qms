﻿
////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	ИспользоватьППД              = ПолучитьФункциональнуюОпцию("ИспользоватьПолнотекстовыйПоискПриПодбореТоваров");
	ИспользоватьСтандартныйПоиск = Константы.ИспользоватьСтандартныйПоискПриПодбореТоваров.Получить();
	
	Элементы.ДекорацияИспользуетсяПДД.Видимость   = ИспользоватьППД;
	Элементы.ДекорацияНеИспользуетсяПДД.Видимость = Не ИспользоватьППД;
	
	Элементы.ДекорацияСтандартныйПоиск.Видимость = ИспользоватьСтандартныйПоиск;
	Элементы.ДекорацияРасширенныйПоиск.Видимость = Не ИспользоватьСтандартныйПоиск;
	
	Если Параметры.ВариантПоискаТоваров = "ПоУмолчанию" Тогда
		ИспользованиеНастройкиПоУмолчанию = "ПоУмолчанию"; 
	Иначе
		ИспользованиеНастройкиПоУмолчанию = "Индивидуально";
	КонецЕсли;
	
	Если Параметры.ВариантПоискаТоваров = "СтандартныйПоиск" Тогда
		ВариантПоиска = "СтандартныйПоиск";
	Иначе
		ВариантПоиска = "РасширенныйПоиск";
	КонецЕсли;
	
	УстановитьДоступностьИндивидуальныхНастроек(Элементы.ГруппаВариантПоиска, ИспользованиеНастройкиПоУмолчанию);
	
КонецПроцедуры

#КонецОбласти // ОбработчикиСобытийФормы

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ
#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОК(Команда)
	
	СтруктураПараметров = Новый Структура;
	
	Если ИспользованиеНастройкиПоУмолчанию = "ПоУмолчанию" Тогда
		СтруктураПараметров.Вставить("ВариантПоискаТоваров", "ПоУмолчанию");
	Иначе
		СтруктураПараметров.Вставить("ВариантПоискаТоваров", ВариантПоиска);
	КонецЕсли;
	
	СтруктураПараметров.Вставить("ИспользоватьСтандартныйПоиск", ИспользоватьСтандартныйПоиск);
	
	Закрыть(СтруктураПараметров);
	
КонецПроцедуры

&НаКлиенте
Процедура Отмена(Команда)
	
	Закрыть(Неопределено);
	
КонецПроцедуры

#КонецОбласти // ОбработчикиКомандФормы

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ФОРМЫ
#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура ИспользованиеНастройкиПоУмолчаниюПриИзменении(Элемент)
	
	УстановитьДоступностьИндивидуальныхНастроек(Элементы.ГруппаВариантПоиска, ИспользованиеНастройкиПоУмолчанию);
	
КонецПроцедуры

&НаКлиенте
Процедура ИспользованиеИндивидуальнойНастройкиПриИзменении(Элемент)
	
	УстановитьДоступностьИндивидуальныхНастроек(Элементы.ГруппаВариантПоиска, ИспользованиеНастройкиПоУмолчанию);
	
КонецПроцедуры

#КонецОбласти // ОбработчикиСобытийЭлементовФормы

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ
#Область СлужебныеПроцедурыИФункции

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьДоступностьИндивидуальныхНастроек(ГруппаВариантПоиска, ИспользованиеНастройкиПоУмолчанию)
	
	Если ИспользованиеНастройкиПоУмолчанию = "ПоУмолчанию" Тогда
		ГруппаВариантПоиска.Доступность = Ложь;
	Иначе
		ГруппаВариантПоиска.Доступность = Истина;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти // СлужебныеПроцедурыИФункции
