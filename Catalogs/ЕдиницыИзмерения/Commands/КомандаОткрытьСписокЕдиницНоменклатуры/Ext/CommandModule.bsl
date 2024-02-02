﻿
////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ
#Область ОбработчикиСобытий

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	Отбор = Новый Структура("Номенклатура", ПараметрКоманды);
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Отбор", Отбор);
	ПараметрыФормы.Вставить("Заголовок", СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru='Упаковки номенклатуры (%1)'"), ПараметрКоманды));
	
	ОткрытьФорму(
		"Справочник.ЕдиницыИзмерения.Форма.ФормаСпискаУпаковок",
		ПараметрыФормы,
		ПараметрыВыполненияКоманды.Источник,
		ПараметрыВыполненияКоманды.Уникальность,
		ПараметрыВыполненияКоманды.Окно);
	
КонецПроцедуры

#КонецОбласти // ОбработчикиСобытий
