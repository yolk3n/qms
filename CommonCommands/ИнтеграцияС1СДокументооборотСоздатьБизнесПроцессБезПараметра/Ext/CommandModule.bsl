﻿#Область ОбработчикиСобытий

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	ОписаниеОповещения = Новый ОписаниеОповещения(
		"ПроверитьПодключениеЗавершение", ЭтотОбъект, Неопределено);
	ИнтеграцияС1СДокументооборотБазоваяФункциональностьКлиент.ПроверитьПодключение(
		ОписаниеОповещения,
		ЭтотОбъект,
		Истина);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ПроверитьПодключениеЗавершение(Результат, Параметры) Экспорт
	
	Если Результат = Истина Тогда // авторизация успешна
		
		ИнтеграцияС1СДокументооборотКлиент.СоздатьБизнесПроцесс();
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти