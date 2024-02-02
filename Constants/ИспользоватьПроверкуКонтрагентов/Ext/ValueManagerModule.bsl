﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2021, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// Действия при изменении константы.
//  
////////////////////////////////////////////////////////////////////////////////

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
#Область ОбработчикиСобытий

Процедура ПриЗаписи(Отказ)
	
	// При записи преднамеренно не используется ОбменДанными.Загрузка.
	// Причина в том, что по РИБ может перемещаться только константа
	// "Использовать сервис проверки данных по контрагенту".
	// После того, как константа попадет в узел, должно быть включено
	// регламентное задание для периодической проверки контрагентов.
	
	// Включаем/отключаем регламентные задания в зависимости от выбора пользователя.
	ПроверкаКонтрагентовВключена = ПроверкаКонтрагентов.ПроверкаКонтрагентовВключена();
	
	РегламентныеЗаданияСервер.УстановитьИспользованиеРегламентногоЗадания(
		Метаданные.РегламентныеЗадания.ПроверкаКонтрагентов,
		ПроверкаКонтрагентовВключена);
	
	ПараметрыПоиска = Новый Структура;
	ПараметрыПоиска.Вставить("Метаданные", Метаданные.РегламентныеЗадания.ПроверкаКэшаСостоянийФНС);
	Задания = РегламентныеЗаданияСервер.НайтиЗадания(ПараметрыПоиска);
	
	Для Каждого Задание Из Задания Цикл
		ПараметрыЗадания = Новый Структура;
		ПараметрыЗадания.Вставить("Использование", ПроверкаКонтрагентовВключена);
		РегламентныеЗаданияСервер.ИзменитьЗадание(
			Задание.УникальныйИдентификатор,
			ПараметрыЗадания);
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли