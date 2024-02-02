﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2023, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область СлужебныеПроцедурыИФункции

// Открывает форму текущих напоминаний пользователя.
//
Процедура ПроверитьТекущиеНапоминания() Экспорт

	ПараметрыКлиента = СтандартныеПодсистемыКлиент.ПараметрКлиента(Неопределено);
	Если Не ПараметрыКлиента.ДоступноИспользованиеРазделенныхДанных Тогда
		Возврат;
	КонецЕсли;
	
	// Открываем форму текущих оповещений.
	ВремяБлижайшего = Неопределено;
	ИнтервалСледующейПроверки = 60;
	
	Если НапоминанияПользователяКлиент.ПолучитьТекущиеОповещения(ВремяБлижайшего).Количество() > 0 Тогда
		НапоминанияПользователяКлиент.ОткрытьФормуОповещения();
	ИначеЕсли ЗначениеЗаполнено(ВремяБлижайшего) Тогда
		ИнтервалСледующейПроверки = Макс(Мин(ВремяБлижайшего - ОбщегоНазначенияКлиент.ДатаСеанса(), ИнтервалСледующейПроверки), 1);
	КонецЕсли;
	
	ПодключитьОбработчикОжидания("ПроверитьТекущиеНапоминания", ИнтервалСледующейПроверки, Истина);
	
КонецПроцедуры

#КонецОбласти
