﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныйПрограммныйИнтерфейс

// Устанавливает признак Истина у свойства Гиперссылка декорации формы.
// 
// Параметры:
// 	Надпись - Надпись - декорация формы.
Процедура УстановитьПризнакГиперссылки(Надпись) Экспорт
	
	Надпись.Гиперссылка = Истина;
	
КонецПроцедуры

// Добавляет в текст сообщения от пользователя информацию о текущем приложении.
//
// Параметры:
//  ТекстHTML - Строка - текст сообщения пользователя.
//  ВложенияHTML - Структура - изображения, встроенные в сообщение пользователя
//
Процедура ДобавитьИнформациюОПриложении(ТекстHTML, ВложенияHTML) Экспорт
    
    СистемнаяИнформация = Новый СистемнаяИнформация();
    
    ТекстHTML = ТекстHTML + Символы.ПС + СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку( 
        "<!-- @AddInfo 
        |{
        |   ""base_id"": ""%1"",
        |   ""platformVersion"": ""%2"",
        |   ""configVersion"": ""%3"",
        |   ""configName"": ""%4"",
		|	""descriptionImages"": %5
        |} 
        |-->", 
		Константы.ИдентификаторИнформационнойБазы.Получить(), 
        СистемнаяИнформация.ВерсияПриложения,
        Метаданные.Версия,
        Метаданные.Имя,
		РаботаВМоделиСервисаБТС.СтрокаИзСтруктурыJSON(ВложенияHTML));
	
КонецПроцедуры

Процедура ДобавитьЗначениеВСписокXDTO(Объект, ПолеСписка, Знач Значение) Экспорт

	Список = Объект[ПолеСписка]; // СписокXDTO
	Список.Добавить(Значение);
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли