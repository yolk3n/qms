﻿
&НаКлиенте
Процедура ЗагрузитьПодразделения(Команда)
	// Вставить содержимое обработчика.
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьОбмен(Команда) 
	
	 //добавить даты
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	АдресСервера = бит_ИнтеграцияQMSСерверПовтИсп.НастройкиПодключения().АдресСервера; 
	
КонецПроцедуры

&НаКлиенте
Процедура НадписьСоответствияОбъектовНажатие(Элемент)
	
	ОткрытьФорму("РегистрСведений.бит_СоответствияОбъектовУчетаQMS.ФормаСписка");

КонецПроцедуры

&НаКлиенте
Процедура ИзменитьНастройки(Команда)
	
	ОткрытьФорму("Справочник.бит_НастройкиИнтеграцииQMS.ФормаСписка")
	
КонецПроцедуры
