﻿
////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(Объект, ЭтотОбъект);
	
	Если Объект.Ссылка.Пустая() Тогда
		ПриСозданииНовогоПриЧтенииНаСервере();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	ПриСозданииНовогоПриЧтенииНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	Оповестить("Запись_НастройкиПродажДляПользователей", ПараметрыЗаписи, Объект.Ссылка);
	
КонецПроцедуры

#КонецОбласти

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ФОРМЫ
#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура РМК_ИспользоватьПриИзменении(Элемент)
	
	ОбновитьВидимостьЭлементовРМК(ЭтотОбъект);
	
КонецПроцедуры

#КонецОбласти

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ
#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ПриСозданииНовогоПриЧтенииНаСервере()
	
	ОбновитьВидимостьЭлементовРМК(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ОбновитьВидимостьЭлементовРМК(Форма)
	
	РМК_Использовать = Форма.Объект.РМК_Использовать;
	
	Форма.Элементы.РМК_ВозвратТовара.Доступность                    = РМК_Использовать;
	Форма.Элементы.РМК_ВнесениеДенег.Доступность                    = РМК_Использовать;
	Форма.Элементы.РМК_ВыемкаДенег.Доступность                      = РМК_Использовать;
	Форма.Элементы.РМК_КорректировкаСтрок.Доступность               = РМК_Использовать;
	Форма.Элементы.РМК_Отложить.Доступность                         = РМК_Использовать;
	Форма.Элементы.РМК_Зарезервировать.Доступность                  = РМК_Использовать;
	Форма.Элементы.РМК_ОткрытьСмену.Доступность                     = РМК_Использовать;
	Форма.Элементы.РМК_ЗакрытьСмену.Доступность                     = РМК_Использовать;
	
КонецПроцедуры

#КонецОбласти
