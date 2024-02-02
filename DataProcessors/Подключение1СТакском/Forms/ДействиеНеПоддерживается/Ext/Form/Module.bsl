﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2018, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ОписаниеПеременных

// Хранение контекста взаимодействия с сервисом
&НаКлиенте
Перем КонтекстВзаимодействия Экспорт;

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если КонтекстВзаимодействия.Свойство("СообщениеОНедоступностиДействия") Тогда
		Элементы.ДекорацияСообщение.Заголовок = КонтекстВзаимодействия.СообщениеОНедоступностиДействия;
	Иначе
		Элементы.ДекорацияСообщение.Заголовок = НСтр("ru = 'Выбранное действие недоступно для этой конфигурации.'");
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура КомандаОК(Команда)
	
	Закрыть();
	
КонецПроцедуры

#КонецОбласти