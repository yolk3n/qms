﻿//@strict-types

#Область СлужебныеПроцедурыИФункции

// Возвращает объект HTTPСоединение для работы с сервисом электронного документооборота.
// 
// Параметры:
// 	Таймаут - Число
// 	НоваяВерсияАПИСервиса1СЭДО - Булево - использовать API v2 сервиса.
// Возвращаемое значение:
// 	см. ИнтернетСоединениеБЭД.ОписаниеHTTPСоединения
Функция СоединениеССервисом(Таймаут = 30) Экспорт
	
	Возврат ИнтернетСоединениеБЭД.ОписаниеHTTPСоединения(СервисНастроекЭДО.АдресСервисаНастроек(), Таймаут);
	
КонецФункции

#КонецОбласти