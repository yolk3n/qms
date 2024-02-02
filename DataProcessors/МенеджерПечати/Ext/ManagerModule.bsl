﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

////////////////////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС
#Область ПрограммныйИнтерфейс

// Формирует печатные формы переданных объектов
//
Процедура Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт
	
	ОбъектыПоТипам = ОбщегоНазначенияБольничнаяАптека.РазложитьМассивСсылокПоТипам(МассивОбъектов);
	
	ПараметрыВывода.ДоступнаПечатьПоКомплектно = Истина;
	
	Для Каждого КлючИЗначение Из ОбъектыПоТипам Цикл
		ТекущиеОбъекты = КлючИЗначение.Значение;
		МетаданныеОбъекта = Метаданные.НайтиПоПолномуИмени(КлючИЗначение.Ключ);
		ДоступныеПечатныеФормы = УправлениеПечатьюБольничнаяАптекаПовтИсп.ДоступныеПечатныеФормы(МетаданныеОбъекта.ПолноеИмя());
		
		Для Каждого ПечатнаяФорма Из ДоступныеПечатныеФормы Цикл
			Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, ПечатнаяФорма.Идентификатор) Тогда
				
				МенеджерПечатиОбъекта = ОбщегоНазначения.МенеджерОбъектаПоПолномуИмени(ПечатнаяФорма.МенеджерПечати);
				
				ИмяМетода = "Печать" + ПечатнаяФорма.Идентификатор;
				ПараметрыМетода = Новый Массив;
				ПараметрыМетода.Добавить(ТекущиеОбъекты);
				ПараметрыМетода.Добавить(ОбъектыПечати);
				Если ПечатнаяФорма.Параметризуемая Тогда
					ПараметрыМетода.Добавить(ПараметрыПечати);
				КонецЕсли;
				ТабличныйДокумент = ОбщегоНазначенияБольничнаяАптека.ВыполнитьМетодОбъекта(МенеджерПечатиОбъекта, ИмяМетода, ПараметрыМетода, Истина);
				
				УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(
					КоллекцияПечатныхФорм,
					ПечатнаяФорма.Идентификатор,
					ПечатнаяФорма.Представление,
					ТабличныйДокумент,
					ПечатнаяФорма.Картинка,
					ПечатнаяФорма.ПутьКМакету);
				
			КонецЕсли;
		КонецЦикла;
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти // ПрограммныйИнтерфейс

#КонецЕсли