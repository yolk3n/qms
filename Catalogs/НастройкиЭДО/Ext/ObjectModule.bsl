﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий
	
Процедура ПередЗаписью(Отказ)
	
	// Вызывается непосредственно до записи объекта в базу данных
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	КлючНастройки = НастройкиЭДОКлиентСервер.НовыйКлючНастроекОтправки();
	КлючНастройки.Отправитель = Организация;
	КлючНастройки.Получатель  = Контрагент;
	КлючНастройки.Договор     = ДоговорКонтрагента;
	Наименование = НастройкиОтправкиЭДОСлужебный.ПредставлениеНастройкиОтправки(КлючНастройки);
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли