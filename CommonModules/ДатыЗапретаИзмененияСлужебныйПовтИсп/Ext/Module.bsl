﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2023, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область СлужебныеПроцедурыИФункции

// Возвращает сведения о последней проверке версии действующих дат запрета изменения.
//
// Возвращаемое значение:
//  Структура:
//   * Дата - Дата - дата и время последней проверки действующих дат.
//
Функция ПоследняяПроверкаВерсииДействующихДатЗапрета() Экспорт
	
	Возврат Новый Структура("Дата", '00010101');
	
КонецФункции

// Возвращает поля шапки объекта метаданных.
//
// Параметры:
//  Таблица - Строка - полное имя объекта метаданных.
//
// Возвращаемое значение:
//  ФиксированнаяСтруктура:
//    * Ключ - Строка - имя поля.
//    * Значение - Неопределено.
//
Функция ПоляШапки(Таблица) Экспорт
	
	СхемаЗапроса = Новый СхемаЗапроса;
	СхемаЗапроса.УстановитьТекстЗапроса(СтрЗаменить("ВЫБРАТЬ * ИЗ #Таблица", "#Таблица", Таблица));
	
	ПоляШапки = Новый Структура;
	Для Каждого Колонка Из СхемаЗапроса.ПакетЗапросов[0].Колонки Цикл
		ПоляШапки.Вставить(Колонка.Псевдоним);
	КонецЦикла;
	
	Возврат Новый ФиксированнаяСтруктура(ПоляШапки);
	
КонецФункции

#КонецОбласти
