﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2021, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	ЭтотОбъект.ТолькоПросмотр = Параметры.ВладелецТолькоПросмотр;
	ЭтотОбъект.ВидимостьПоУмолчанию = Параметры.ВидимостьПоУмолчанию;
	ЭтотОбъект.СписокИсключений.ЗагрузитьЗначения(Параметры.СписокИсключений.ВыгрузитьЗначения());

	Если ЭтотОбъект.ТолькоПросмотр = Истина Тогда
		Элементы.КнопкаОК.Видимость = Ложь;
		Элементы.КнопкаОтмена.Заголовок = НСтр("ru='Закрыть'");
		Элементы.СписокИсключений.ИзменятьПорядокСтрок = Ложь;
		Элементы.СписокИсключений.ИзменятьСоставСтрок  = Ложь;
		Элементы.СписокИсключенийДобавить.Видимость    = Ложь;
		Элементы.СписокИсключенийУдалить.Видимость     = Ложь;
		Элементы.СписокИсключенийСкопировать.Видимость = Ложь;
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура КомандаОК(Команда)

	// Данные для передачи владельцу
	Результат = ПодготовитьСтруктуруДляВозвратаПоОК();
	ЭтотОбъект.Закрыть(Результат);

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Функция ПодготовитьСтруктуруДляВозвратаПоОК()

	СписокИсключенийБезПовторов = Новый СписокЗначений;
	Для каждого ТекущийЭлементСписка Из ЭтотОбъект.СписокИсключений Цикл
		Если НЕ ТекущийЭлементСписка.Значение.Пустая() Тогда
			НайденнаяСтрока = СписокИсключенийБезПовторов.НайтиПоЗначению(ТекущийЭлементСписка.Значение);
			Если НайденнаяСтрока = Неопределено Тогда
				СписокИсключенийБезПовторов.Добавить(ТекущийЭлементСписка.Значение);
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;

	Результат = Новый Структура("ВидимостьПоУмолчанию, СписокИсключений",
		ЭтотОбъект.ВидимостьПоУмолчанию,
		СписокИсключенийБезПовторов);

	Возврат Результат;

КонецФункции

#КонецОбласти

