﻿
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	ИдентификаторДокумента_ = ОбщиеМеханизмы.ЗначениеРеквизитаОбъекта(ПараметрКоманды, "ИдентификаторДокумента");
	ПараметрыФормы = Новый Структура("Отбор", Новый Структура("ИдентификаторДокумента", ИдентификаторДокумента_));
	ОткрытьФорму("РегистрСведений.ФедеральныеВебСервисыСообщенияРЭМД.ФормаСписка", ПараметрыФормы, ПараметрыВыполненияКоманды.Источник, ПараметрыВыполненияКоманды.Уникальность, ПараметрыВыполненияКоманды.Окно, ПараметрыВыполненияКоманды.НавигационнаяСсылка);
КонецПроцедуры
