﻿
#Область ОбработчикиСобытий

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	ОткрытьФорму(
		"Обработка.ПанельСправочниковСинхронизация.Форма.НастройкиИСправочникиСинхронизации",
		Новый Структура,
		ПараметрыВыполненияКоманды.Источник,
		"Обработка.ПанельСправочниковСинхронизация.Форма.НастройкиИСправочникиСинхронизации" + ?(ПараметрыВыполненияКоманды.Окно = Неопределено, ".ОтдельноеОкно", ""),
		ПараметрыВыполненияКоманды.Окно);
	
КонецПроцедуры

#КонецОбласти
