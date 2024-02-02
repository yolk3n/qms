﻿////////////////////////////////////////////////////////////////////////////////
// Подсистема "Хранилище сертификатов (служебный)".
//  
////////////////////////////////////////////////////////////////////////////////


#Область СлужебныйПрограммныйИнтерфейс

Процедура Добавить(Сертификат, ТипХранилища) Экспорт

	ХранилищеСертификатов.Добавить(Сертификат, ТипХранилища);
	
КонецПроцедуры

// Параметры: 
//  ТипХранилища - см. ХранилищеСертификатов.Получить.ТипХранилища
// 
// Возвращаемое значение: см. ХранилищеСертификатов.Получить
Функция Получить(ТипХранилища = Неопределено) Экспорт
	
	Возврат ХранилищеСертификатов.Получить(ТипХранилища);
	
КонецФункции

// Параметры: 
//  Сертификат - см. ХранилищеСертификатов.НайтиСертификат.Сертификат
// 
// Возвращаемое значение: см. ХранилищеСертификатов.НайтиСертификат
Функция НайтиСертификат(Сертификат) Экспорт
	
	Возврат ХранилищеСертификатов.НайтиСертификат(Сертификат);
	
КонецФункции

#КонецОбласти