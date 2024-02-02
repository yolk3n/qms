﻿
////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ
#Область СлужебныеПроцедурыИФункции

// Вызов этой функции должен осуществляться только из клиентского модуля ОбработкаТабличнойЧастиКлиент.
//
// Параметры
//  ТекущаяСтрока - данные обрабатываемой строки
//  СтруктураДействий - структура с выполняемыми действиями
//  КэшированныеЗначения - структура с кэшированными значениями
//
Процедура ОбработатьСтрокуТабличнойЧасти(ТекущаяСтрока, СтруктураДействий, КэшированныеЗначения) Экспорт
	
	ОбработкаТабличнойЧастиСервер.ОбработатьСтрокуТабличнойЧасти(ТекущаяСтрока, СтруктураДействий, КэшированныеЗначения);
	
КонецПроцедуры

// Выполняет обработку полученных штрихкодов в табличной части
//
// Параметры:
//  КопияТабличнойЧасти
//  ПараметрыДействия
//  КэшированныеЗначения
//  Модифицированность
//
Процедура ОбработатьШтрихкодыТабличнойЧасти(КопияТабличнойЧасти, ПараметрыДействия, КэшированныеЗначения, Модифицированность) Экспорт
	
	ОбработкаТабличнойЧастиСервер.ОбработатьШтрихкодыТабличнойЧасти(КопияТабличнойЧасти, ПараметрыДействия, КэшированныеЗначения, Модифицированность);
	
КонецПроцедуры

#КонецОбласти // СлужебныеПроцедурыИФункции
