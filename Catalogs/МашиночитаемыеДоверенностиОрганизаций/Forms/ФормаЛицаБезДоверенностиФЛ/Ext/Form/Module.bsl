﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	СтруктураДанных = Параметры.СтруктураДанных;
	
	Если СтруктураДанных.Свойство("ТолькоПросмотрФормы") И СтруктураДанных.ТолькоПросмотрФормы Тогда
		Элементы.ЛицоБезДовФЛ_ИНН.ТолькоПросмотр 			= Истина;
		Элементы.ЛицоБезДовФЛ_СНИЛС.ТолькоПросмотр 			= Истина;
		Элементы.ЛицоБезДовФЛ_Гражданство.ТолькоПросмотр 	= Истина;
		Элементы.ЛицоБезДовФЛ_ДатаРождения.ТолькоПросмотр 	= Истина;
		Элементы.ЛицоБезДовФЛ_Должность.ТолькоПросмотр 		= Истина;
		Элементы.ФормаКнопкаСохранить.Доступность 			= Ложь;
	КонецЕсли;
	
	Если СтруктураДанных <> Неопределено Тогда
		ЛицоБезДовФЛ_Фамилия 		= СтруктураДанных.ЛицоБезДовФЛ_Фамилия;
		ЛицоБезДовФЛ_Имя 			= СтруктураДанных.ЛицоБезДовФЛ_Имя;
		ЛицоБезДовФЛ_Отчество 		= СтруктураДанных.ЛицоБезДовФЛ_Отчество;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Сохранить(Команда)
	
	Если НЕ СохранениеВозможно() Тогда
		Возврат;
	КонецЕсли;
	
	СтруктураДанных = Новый Структура;
	СтруктураДанных.Вставить("ЛицоБезДовФЛ_Фамилия", 		ЛицоБезДовФЛ_Фамилия);
	СтруктураДанных.Вставить("ЛицоБезДовФЛ_Имя", 			ЛицоБезДовФЛ_Имя);
	СтруктураДанных.Вставить("ЛицоБезДовФЛ_Отчество", 		ЛицоБезДовФЛ_Отчество);
	
	СтруктураДанных.Вставить("ЛицоБезДовФЛ_ИНН", 			ЛицоБезДовФЛ_ИНН);
	СтруктураДанных.Вставить("ЛицоБезДовФЛ_СНИЛС", 			ЛицоБезДовФЛ_СНИЛС);
	СтруктураДанных.Вставить("ЛицоБезДовФЛ_Гражданство", 	ЛицоБезДовФЛ_Гражданство);
	СтруктураДанных.Вставить("ЛицоБезДовФЛ_ДатаРождения", 	ЛицоБезДовФЛ_ДатаРождения);
	СтруктураДанных.Вставить("ЛицоБезДовФЛ_Должность", 		ЛицоБезДовФЛ_Должность);
	
	Закрыть(СтруктураДанных);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Функция СохранениеВозможно()
	
	Отказ = Ложь;
	
	ОчиститьСообщения();
	
	Если НЕ ЗначениеЗаполнено(ЛицоБезДовФЛ_Фамилия) Тогда
		ОбщегоНазначенияКлиент.СообщитьПользователю(НСтр("ru = 'Не задана фамилия.'"),,
			"ЛицоБезДовФЛ_Фамилия",, Отказ);
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(ЛицоБезДовФЛ_Имя) Тогда
		ОбщегоНазначенияКлиент.СообщитьПользователю(НСтр("ru = 'Не задано имя.'"),,
			"ЛицоБезДовФЛ_Имя",, Отказ);
	КонецЕсли;
	
	Возврат НЕ Отказ;
	
КонецФункции

#КонецОбласти
