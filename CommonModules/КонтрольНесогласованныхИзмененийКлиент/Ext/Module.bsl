﻿
#Область ПрограммныйИнтерфейс

Функция ПередНачаломИзменения(Форма, Элемент, Отказ) Экспорт
	
	НастройкиКонтроляИзмененияДанных = Форма[ИмяРеквизитаНастройкиКонтроляИзмененияДанных()];
	Если НастройкиКонтроляИзмененияДанных = Неопределено Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	ЗаполнитьЗначенияСвойств(НастройкиКонтроляИзмененияДанных.ЗначенияРеквизитов[Элемент.Имя], Элемент.ТекущиеДанные);
	
	Действие = Неопределено;
	Если НастройкиКонтроляИзмененияДанных.ПередНачаломИзменения.Свойство(Элемент.Имя, Действие) Тогда
		Возврат Действие;
	КонецЕсли;
	
	Возврат Неопределено;
	
КонецФункции

Функция ПередУдалением(Форма, Элемент, Отказ) Экспорт
	
	НастройкиКонтроляИзмененияДанных = Форма[ИмяРеквизитаНастройкиКонтроляИзмененияДанных()];
	Если НастройкиКонтроляИзмененияДанных = Неопределено Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	СообщитьОНевозможностиРедактирования(Форма);
	
КонецФункции

Функция ПередНачаломДобавления(Форма, Элемент, Отказ, Копирование, Родитель, Группа) Экспорт
	
	НастройкиКонтроляИзмененияДанных = Форма[ИмяРеквизитаНастройкиКонтроляИзмененияДанных()];
	Если НастройкиКонтроляИзмененияДанных = Неопределено Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	СообщитьОНевозможностиРедактирования(Форма);
	
КонецФункции

Функция Нажатие(Форма, Элемент) Экспорт
	
	НастройкиКонтроляИзмененияДанных = Форма[ИмяРеквизитаНастройкиКонтроляИзмененияДанных()];
	Если НастройкиКонтроляИзмененияДанных = Неопределено Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	СообщитьОНевозможностиРедактирования(Форма);
	
КонецФункции

Функция Команда(Форма, Команда) Экспорт
	
	НастройкиКонтроляИзмененияДанных = Форма[ИмяРеквизитаНастройкиКонтроляИзмененияДанных()];
	Если НастройкиКонтроляИзмененияДанных = Неопределено Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	СообщитьОНевозможностиРедактирования(Форма);
	
КонецФункции

Функция ПриИзменении(Форма, Элемент) Экспорт
	
	НастройкиКонтроляИзмененияДанных = Форма[ИмяРеквизитаНастройкиКонтроляИзмененияДанных()];
	Если НастройкиКонтроляИзмененияДанных = Неопределено Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	СтароеЗначение = ОпределитьСтароеЗначение(Форма, Элемент);
	НовоеЗначение = ОпределитьТекущееЗначение(Форма, Элемент);
	Если СтароеЗначение <> НовоеЗначение Тогда
		УстановитьЗначение(Форма, Элемент, СтароеЗначение);
		СообщитьОНевозможностиРедактирования(Форма);
	КонецЕсли;
	
КонецФункции

#КонецОбласти // ПрограммныйИнтерфейс

#Область СлужебныеПроцедурыИФункции

Функция ОпределитьСтароеЗначение(Форма, Элемент)
	
	НастройкиКонтроляИзмененияДанных = Форма[ИмяРеквизитаНастройкиКонтроляИзмененияДанных()];
	
	Таблица = ПолеВнутриТаблицы(Форма, Элемент);
	Если Таблица <> Неопределено Тогда
		ПутьКДанным = НастройкиКонтроляИзмененияДанных.ПутьКДанным[Элемент.Имя];
		ПутьКДанным = Сред(ПутьКДанным, СтрНайти(ПутьКДанным, ".", НаправлениеПоиска.СКонца) + 1);
		Значение = НастройкиКонтроляИзмененияДанных.ЗначенияРеквизитов[Таблица.Имя][ПутьКДанным];
	Иначе
		Значение = НастройкиКонтроляИзмененияДанных.ЗначенияРеквизитов[Элемент.Имя];
	КонецЕсли;
	
	Возврат Значение;
	
КонецФункции

Функция ОпределитьТекущееЗначение(Форма, Элемент)
	
	Значение = Неопределено;
	НастройкиКонтроляИзмененияДанных = Форма[ИмяРеквизитаНастройкиКонтроляИзмененияДанных()];
	
	Таблица = ПолеВнутриТаблицы(Форма, Элемент);
	
	ПутьКДанным = НастройкиКонтроляИзмененияДанных.ПутьКДанным[Элемент.Имя];
	ПутьКДаннымМассивом = СтрРазделить(ПутьКДанным, ".");
	Данные = Форма;
	ПоследнийИндекс = ПутьКДаннымМассивом.ВГраница();
	Для Индекс = 0 По ПоследнийИндекс Цикл
		ЧастьПути = ПутьКДаннымМассивом[Индекс];
		Если Индекс = ПоследнийИндекс Тогда
			Если ТипЗнч(Данные) = Тип("ДанныеФормыСтруктура") Тогда
				Значение = Данные[ЧастьПути];
			ИначеЕсли ТипЗнч(Данные) = Тип("ДанныеФормыКоллекция") Тогда
				Значение = Таблица.ТекущиеДанные[ЧастьПути];
			КонецЕсли;
		Иначе
			Данные = Данные[ЧастьПути];
		КонецЕсли;
	КонецЦикла;
	
	Возврат Значение;
	
КонецФункции

Процедура УстановитьЗначение(Форма, Элемент, Значение)
	
	НастройкиКонтроляИзмененияДанных = Форма[ИмяРеквизитаНастройкиКонтроляИзмененияДанных()];
	
	Таблица = ПолеВнутриТаблицы(Форма, Элемент);
	
	ПутьКДанным = НастройкиКонтроляИзмененияДанных.ПутьКДанным[Элемент.Имя];
	ПутьКДаннымМассивом = СтрРазделить(ПутьКДанным, ".");
	Данные = Форма;
	ПоследнийИндекс = ПутьКДаннымМассивом.ВГраница();
	Для Индекс = 0 По ПоследнийИндекс Цикл
		ЧастьПути = ПутьКДаннымМассивом[Индекс];
		Если Индекс = ПоследнийИндекс Тогда
			Если ТипЗнч(Данные) = Тип("ДанныеФормыСтруктура") Тогда
				Данные[ЧастьПути] = Значение;
			ИначеЕсли ТипЗнч(Данные) = Тип("ДанныеФормыКоллекция") Тогда
				Таблица.ТекущиеДанные[ЧастьПути] = Значение;
			КонецЕсли;
		Иначе
			Данные = Данные[ЧастьПути];
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

Функция ПолеВнутриТаблицы(Форма, Элемент)
	
	Если ТипЗнч(Элемент.Родитель) = Тип("ТаблицаФормы") Тогда
		Возврат Элемент.Родитель;
	ИначеЕсли ТипЗнч(Элемент.Родитель) = Тип("ФормаКлиентскогоПриложения") Тогда
		Возврат Неопределено;
	Иначе	
		Возврат ПолеВнутриТаблицы(Форма, Элемент.Родитель);
	КонецЕсли;
	
КонецФункции

Процедура СообщитьОНевозможностиРедактирования(Форма)
	
	Объект = Форма.Объект;
	Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(Объект, "ПодписанЭП") И Объект.ПодписанЭП Тогда
		ТекстСообщения = НСтр("ru = 'Изменение подписанного документа запрещено.'");
	ИначеЕсли ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(Форма, "СообщениеОНевозможностиРедактирования")
			И Не ПустаяСтрока(Форма.СообщениеОНевозможностиРедактирования) Тогда
		ТекстСообщения = Форма.СообщениеОНевозможностиРедактирования;
	ИначеЕсли ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(Объект, "Согласован")
			И Объект.Согласован Тогда
		ТекстСообщения = НСтр("ru = 'Изменение согласованного документа запрещено.'");
	Иначе
		ТекстСообщения = НСтр("ru = 'Изменение запрещено.'");
	КонецЕсли;
	
	ВызватьИсключение ТекстСообщения;
	
КонецПроцедуры

Функция ИмяРеквизитаНастройкиКонтроляИзмененияДанных()
	
	Возврат "НастройкиКонтроляИзмененияДанных";
	
КонецФункции

#КонецОбласти // СлужебныеПроцедурыИФункции
