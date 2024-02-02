﻿
////////////////////////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	ИТСМедицина.ПолучитьПараметрыАутентификации(Логин, Пароль);
	ЗапомнитьПароль = ? (ПустаяСтрока(Пароль), Ложь, Истина);
	
КонецПроцедуры

#КонецОбласти // ОбработчикиСобытийФормы

////////////////////////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ
#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура СохранитьДанныеАутентификацииИПродолжитьВыполнить()
	
	СохраняемыйПароль = ?(ЗапомнитьПароль, Пароль, Неопределено);
	СохранитьДанныеАутентификации(Логин, СохраняемыйПароль);
	
	Результат = Новый Структура("Логин ,Пароль", Логин, Пароль);
	ОповеститьОВыборе(Результат);
	
КонецПроцедуры

#КонецОбласти // ОбработчикиКомандФормы

////////////////////////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ФОРМЫ
#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура НадписьПоясненияПодключенияАвторизацияОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ФайловаяСистемаКлиент.ОткрытьНавигационнуюСсылку("https://its.1c.ru");
	
КонецПроцедуры

&НаКлиенте
Процедура НадписьВосстановленияПароляАвторизацияНажатие(Элемент)
	
	ФайловаяСистемаКлиент.ОткрытьНавигационнуюСсылку("https://its.1c.ru/user/auth/password");
	
КонецПроцедуры

&НаКлиенте
Процедура НадписьНетЛогинаИПароляАвторизацияНажатие(Элемент)
	
	ФайловаяСистемаКлиент.ОткрытьНавигационнуюСсылку("https://its.1c.ru/dostup");
	
КонецПроцедуры

#КонецОбласти // ОбработчикиСобытийЭлементовФормы

////////////////////////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ
#Область СлужебныеПроцедурыИФункции

&НаСервереБезКонтекста
Процедура СохранитьДанныеАутентификации(Знач Логин, Знач Пароль)
	
	ИТСМедицина.СохранитьПараметрыАутентификации(Логин, Пароль);
	
КонецПроцедуры

#КонецОбласти // СлужебныеПроцедурыИФункции


