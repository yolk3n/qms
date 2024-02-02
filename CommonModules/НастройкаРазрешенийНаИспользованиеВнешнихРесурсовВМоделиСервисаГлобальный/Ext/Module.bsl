﻿////////////////////////////////////////////////////////////////////////////////
// Подсистема "Базовая функциональность в модели сервиса".
// Серверные процедуры и функции общего назначения:
// - Поддержка профилей безопасности.
//
////////////////////////////////////////////////////////////////////////////////

#Область СлужебныеПроцедурыИФункции

// Выполняет асинхронную обработку оповещения о закрытии форм мастера настройки разрешений на
// использование внешних ресурсов при вызове через подключение обработчика ожидания.
// В качестве результата в обработчик передается значение КодВозвратаДиалога.ОК.
//
// Процедура не предназначена для непосредственного вызова.
//
Процедура ЗавершитьНастройкуРазрешенийНаИспользованиеВнешнихРесурсовВМоделиСервиса() Экспорт
	
	НастройкаРазрешенийНаИспользованиеВнешнихРесурсовВМоделиСервисаКлиент.ЗавершитьНастройкуРазрешенийНаИспользованиеВнешнихРесурсовСинхронно(КодВозвратаДиалога.ОК);
	
КонецПроцедуры

// Выполняет асинхронную обработку оповещения о закрытии форм мастера настройки разрешений на
// использование внешних ресурсов при вызове через подключение обработчика ожидания.
// В качестве результата в обработчик передается значение КодВозвратаДиалога.ОК.
//
// Процедура не предназначена для непосредственного вызова.
//
Процедура ПрерватьНастройкуРазрешенийНаИспользованиеВнешнихРесурсовВМоделиСервиса() Экспорт
	
	НастройкаРазрешенийНаИспользованиеВнешнихРесурсовВМоделиСервисаКлиент.ЗавершитьНастройкуРазрешенийНаИспользованиеВнешнихРесурсовСинхронно(КодВозвратаДиалога.Отмена);
	
КонецПроцедуры

#КонецОбласти