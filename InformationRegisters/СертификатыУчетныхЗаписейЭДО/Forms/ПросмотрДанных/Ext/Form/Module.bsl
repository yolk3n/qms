﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Заголовок = Параметры.ПредставлениеДанных;
	
	Данные = Неопределено;
	Если Параметры.Свойство("Данные", Данные) Тогда
		Для каждого ЭлементДанных Из Данные Цикл
			НоваяСтрока = Список.Добавить();
			НоваяСтрока.Значение = ЭлементДанных.Значение;
			НоваяСтрока.Представление = ЭлементДанных.Представление;
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписок

&НаКлиенте
Процедура СписокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ОткрытьДанные();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура СписокОткрыть()
	
	ОткрытьДанные();
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьДанные()
	
	ТекущиеДанные = Элементы.Список.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ПоказатьЗначение(, ТекущиеДанные.Значение);
	
КонецПроцедуры

#КонецОбласти
