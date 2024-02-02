﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныеПроцедурыИФункции

Процедура ДобавитьЗапись(Пользователь, Логин, Пароль, КодАбонента) Экспорт
	
	Набор = СоздатьНаборЗаписей();
	Набор.ДополнительныеСвойства.Вставить("Пароль", Пароль);
	Набор.Отбор.Пользователь.Установить(Пользователь);
	Запись = Набор.Добавить();
	Запись.Пользователь = Пользователь;
	Запись.Логин = Логин;
	Запись.КодАбонента = КодАбонента;
	Набор.Записать();
	
КонецПроцедуры

// Владелец безопасного хранилища.
// 
// Параметры:
//  Пользователь - СправочникСсылка.Пользователи - Пользователь
// 
// Возвращаемое значение:
//  Строка
Функция ВладелецБезопасногоХранилища(Пользователь) Экспорт
	
	ИДПользователя = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Пользователь, "ИдентификаторПользователяИБ");
	Возврат СтрШаблон("Пользователь_%1", ИДПользователя);
	
КонецФункции
  
// Прочитать данные.
// 
// Параметры:
//  Пользователь - СправочникСсылка.Пользователи
// 
// Возвращаемое значение:
//  Структура:
// * Логин - Строка
// * Пароль - Строка
// * КодАбонента - Число
Функция Прочитать(Пользователь) Экспорт
	
	Менеджер = СоздатьМенеджерЗаписи();
	Менеджер.Пользователь = Пользователь;
	Менеджер.Прочитать();
	
	Данные = Новый Структура;
	Данные.Вставить("Логин", Менеджер.Логин);
	
	УстановитьПривилегированныйРежим(Истина);
	Владелец = ВладелецБезопасногоХранилища(Пользователь);
	Данные.Вставить("Пароль", Строка(ОбщегоНазначения.ПрочитатьДанныеИзБезопасногоХранилища(Владелец)));
	Данные.Вставить("КодАбонента", Менеджер.КодАбонента);
	
	Возврат Данные;
	
КонецФункции
 
#КонецОбласти 
 
#КонецЕсли