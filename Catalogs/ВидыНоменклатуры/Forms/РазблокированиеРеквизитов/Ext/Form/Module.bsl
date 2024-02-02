﻿
////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ЗапретРедактированияРеквизитовОбъектовБольничнаяАптекаСервер.НастроитьФормуРазблокированияРеквизитов(ЭтотОбъект);
	
КонецПроцедуры

#КонецОбласти // ОбработчикиСобытийФормы

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ
#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура РазрешитьРедактирование(Команда)
	
	РазблокируемыеРеквизиты = Новый Массив;
	
	Если РазрешитьРедактированиеТипНоменклатурыРасширенный Тогда
		РазблокируемыеРеквизиты.Добавить("ТипНоменклатурыРасширенный");
	КонецЕсли;
	
	Если РазрешитьРедактированиеИспользоватьСерии Тогда
		РазблокируемыеРеквизиты.Добавить("ИспользоватьСерии");
		РазблокируемыеРеквизиты.Добавить("НастройкаИспользованияСерий");
		РазблокируемыеРеквизиты.Добавить("ТочностьУказанияСрокаГодностиСерии");
		РазблокируемыеРеквизиты.Добавить("ПолитикаУчетаСерий");
		РазблокируемыеРеквизиты.Добавить("ПолитикаУчетаСерийВОтделениях");
	КонецЕсли;
	
	Если РазрешитьРедактированиеИспользоватьПартии Тогда
		РазблокируемыеРеквизиты.Добавить("ИспользоватьПартии");
		РазблокируемыеРеквизиты.Добавить("ПолитикаУчетаПартий");
		РазблокируемыеРеквизиты.Добавить("ПолитикаУчетаПартийВОтделениях");
	КонецЕсли;
	
	ЗапретРедактированияРеквизитовОбъектовБольничнаяАптекаКлиент.РазрешитьРедактирование(ЭтотОбъект, РазблокируемыеРеквизиты);
	
КонецПроцедуры

#КонецОбласти // ОбработчикиКомандФормы
