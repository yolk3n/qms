﻿
////////////////////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС
#Область ПрограммныйИнтерфейс

// Помещает данные в буфер обмена
//
// Параметры:
//  ИдентификаторБуфера - Строка       - 
//  Данные              - Произвольный - данные, помещаемые в буфер обмена
//  Представление       - Строка       - представление данных
//
Процедура СкопироватьДанные(ИдентификаторБуфера, Данные, Представление = "") Экспорт
	
	Если ПустаяСтрока(Представление) Тогда
		ПредставлениеДанных = Строка(Данные);
	Иначе
		ПредставлениеДанных = Представление;
	КонецЕсли;
	
	ИдентификаторДанных = СохранитьДанныеСлужебный(ИдентификаторБуфера, Данные);
	
	История = ПолучитьИсториюКопированияДанных(ИдентификаторБуфера);
	История.Вставить(0, ЭлементИстории(ИдентификаторДанных, ПредставлениеДанных));
	
	СохранитьИсториюСлужебный(ИдентификаторБуфера, История);
	
	Если История.Количество() > ГлубинаХраненияИстории() Тогда
		ИдентификаторДанных = История[История.Количество() - 1].ИдентификаторДанных;
		УдалитьДанные(ИдентификаторБуфера, ИдентификаторДанных);
	КонецЕсли;
	
КонецПроцедуры

// Возвращает последние помещенные данные из буфера обмена
//
// Параметры:
//  ИдентификаторБуфера - Строка - 
//
// Возвращаемое значение:
//  Произвольный
//
Функция ПолучитьТекущиеДанные(ИдентификаторБуфера) Экспорт
	Перем Данные;
	
	История = ПолучитьИсториюКопированияДанных(ИдентификаторБуфера);
	Если История.Количество() > 0 Тогда
		ИдентификаторДанных = История[0].ИдентификаторДанных;
		Данные = ПолучитьДанные(ИдентификаторБуфера, ИдентификаторДанных);
	КонецЕсли;
	
	Возврат Данные;
	
КонецФункции

// Возвращает данные из буфера обмена
//
// Параметры:
//  ИдентификаторБуфера - Строка - 
//  ИдентификаторДанных - Строка - идентификатор ранее сохраненных данных
//
// Возвращаемое значение:
//  Произвольный
//
Функция ПолучитьДанные(ИдентификаторБуфера, ИдентификаторДанных) Экспорт
	
	Данные = ПолучитьДанныеСлужебный(ИдентификаторБуфера, ИдентификаторДанных);
	Возврат Данные;
	
КонецФункции

// Возвращает историю помещения данных в буфер обмена
//
// Параметры:
//  ИдентификаторБуфера - Строка - 
//
// Возвращаемое значение:
//  СписокЗначений - значения списка являются идентификаторами данных в буфере обмена
//
Функция ПолучитьИсториюКопированияДанных(ИдентификаторБуфера) Экспорт
	
	История = ПолучитьИсториюСлужебный(ИдентификаторБуфера);
	Если История = Неопределено Тогда
		История = Новый Массив;
	Иначе
		История = Новый Массив(История);
	КонецЕсли;
	
	Возврат История;
	
КонецФункции

// Удаляет данные из буфера обмена
//
// Параметры:
//  ИдентификаторБуфера - Строка - 
//  ИдентификаторДанных - Строка - идентификатор ранее сохраненных данных
//
Процедура УдалитьДанные(ИдентификаторБуфера, ИдентификаторДанных) Экспорт
	
	История = ПолучитьИсториюКопированияДанных(ИдентификаторБуфера);
	Элемент = История.Найти(ИдентификаторДанных);
	Если Элемент <> Неопределено Тогда
		История.Удалить(Элемент);
		СохранитьИсториюСлужебный(ИдентификаторБуфера, История);
	КонецЕсли;
	
	УдалитьДанныеСлужебный(ИдентификаторБуфера, ИдентификаторДанных);
	
КонецПроцедуры

// Очищает буфера обмена
//
// Параметры:
//  ИдентификаторБуфера - Строка - 
//
Процедура Очистить(ИдентификаторБуфера) Экспорт
	
	УстановитьПривилегированныйРежим(Истина); // Чтобы не зависеть от наличия прав
	ОбщегоНазначения.ХранилищеСистемныхНастроекУдалить(ИдентификаторБуфераОбмена(ИдентификаторБуфера), Неопределено, ИмяПользователя());
	Возврат;
	
	История = ПолучитьИсториюСлужебный(ИдентификаторБуфера);
	Если История <> Неопределено Тогда
		Для Каждого Данные Из История Цикл
			УдалитьДанныеСлужебный(ИдентификаторБуфера, Данные.Значение);
		КонецЦикла;
		История.Очистить();
		СохранитьИсториюСлужебный(ИдентификаторБуфера, История)
	КонецЕсли;
	
КонецПроцедуры

// Проверяет наличие данных в буфере обмена
//
// Параметры:
//  ИдентификаторБуфера - Строка - 
//
// Возвращаемое значение:
//  Булево - Истина, если буфер пустой, иначе Ложь.
// 
Функция Пустой(ИдентификаторБуфера) Экспорт
	
	Возврат ПолучитьИсториюКопированияДанных(ИдентификаторБуфера).Количество() = 0;
	
КонецФункции

#КонецОбласти // ПрограммныйИнтерфейс

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ
#Область СлужебныеПроцедурыИФункции

Функция СохранитьДанныеСлужебный(ИдентификаторБуфера, Данные)
	
	ДанныеВХранилище = ПоместитьВоВременноеХранилище(Данные, Новый УникальныйИдентификатор);
	Возврат ДанныеВХранилище;
	
КонецФункции

Функция ПолучитьДанныеСлужебный(ИдентификаторБуфера, ИдентификаторДанных)
	
	Если ЭтоАдресВременногоХранилища(ИдентификаторДанных) Тогда
		Возврат ПолучитьИзВременногоХранилища(ИдентификаторДанных);
	КонецЕсли;
	
	Возврат Неопределено;
	
КонецФункции

Процедура УдалитьДанныеСлужебный(ИдентификаторБуфера, ИдентификаторДанных)
	
	Если ЭтоАдресВременногоХранилища(ИдентификаторДанных) Тогда
		УдалитьИзВременногоХранилища(ИдентификаторДанных);
	КонецЕсли;
	
КонецПроцедуры

Процедура СохранитьИсториюСлужебный(ИдентификаторБуфера, История)
	
	ИмяБуфера = ИдентификаторБуфераОбмена(ИдентификаторБуфера);
	ИсторииБуфераОбмена = Новый Структура(ПараметрыСеанса.БуферОбмена);
	ИсторииБуфераОбмена.Вставить(ИмяБуфера, Новый ФиксированныйМассив(История));
	ПараметрыСеанса.БуферОбмена = Новый ФиксированнаяСтруктура(ИсторииБуфераОбмена);
	
КонецПроцедуры

Функция ПолучитьИсториюСлужебный(ИдентификаторБуфера)
	
	ИмяБуфера = ИдентификаторБуфераОбмена(ИдентификаторБуфера);
	История = Неопределено;
	ПараметрыСеанса.БуферОбмена.Свойство(ИмяБуфера, История);
	Возврат История;
	
КонецФункции

Функция ЭлементИстории(ИдентификаторДанных, ПредставлениеДанных)
	
	ЭлементИстории = Новый Структура;
	ЭлементИстории.Вставить("ИдентификаторДанных", ИдентификаторДанных);
	ЭлементИстории.Вставить("ПредставлениеДанных", ПредставлениеДанных);
	Возврат Новый ФиксированнаяСтруктура(ЭлементИстории);
	
КонецФункции

Функция ИдентификаторБуфераОбмена(ИдентификаторБуфера)
	Возврат "БуферОбмена" + "_" + ИдентификаторБуфера;
КонецФункции

Функция ГлубинаХраненияИстории()
	Возврат 10;
КонецФункции

#КонецОбласти // СлужебныеПроцедурыИФункции
