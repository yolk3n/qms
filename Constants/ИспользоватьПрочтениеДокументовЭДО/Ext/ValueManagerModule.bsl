﻿#Область ОбработчикиСобытий

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
         Возврат;
	КонецЕсли;
	
	Константы.ДатаОбновленияНаВерсиюСПрочтенностью.Установить(ТекущаяДатаСеанса());
		
КонецПроцедуры

#КонецОбласти