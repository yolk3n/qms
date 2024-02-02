﻿
#Область ОбработчикиСобытий

Процедура ОбработкаПолученияПолейПредставления(Поля, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	СтандартныеРеквизиты = ПустаяСсылка().Метаданные().СтандартныеРеквизиты;
	Реквизиты = ПустаяСсылка().Метаданные().Реквизиты;
	
	Поля.Добавить(СтандартныеРеквизиты.Наименование.Имя);
	Поля.Добавить(Реквизиты.НомерСвидетельства.Имя);
	Поля.Добавить(Реквизиты.ТаможенныйОрган.Имя);
	
КонецПроцедуры

Процедура ОбработкаПолученияПредставления(Данные, Представление, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Представление = СтрШаблон("%1 %2 (%3)", Данные.Наименование, Данные.НомерСвидетельства, Данные.ТаможенныйОрган);
	
КонецПроцедуры

#КонецОбласти // ОбработчикиСобытий