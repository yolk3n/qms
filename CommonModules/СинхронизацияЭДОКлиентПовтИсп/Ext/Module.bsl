﻿//@strict-types

#Область СлужебныеПроцедурыИФункции

// Возвращает наличие права выполнения обмена у текущего пользователя.
// 
// Возвращаемое значение:
// 	Булево
Функция ЕстьПравоВыполненияОбмена() Экспорт
	
	Возврат СинхронизацияЭДОВызовСервера.ЕстьПравоВыполненияОбмена();
	
КонецФункции

#КонецОбласти
