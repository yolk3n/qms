﻿#Область СлужебныйПрограммныйИнтерфейс

Функция МенеджерыЛогическихХранилищ() Экспорт
	
	ВсеМенеджерыЛогическихХранилищ = Новый Соответствие;
	
	ПередачаДанныхВстраивание.МенеджерыЛогическихХранилищ(ВсеМенеджерыЛогическихХранилищ);
	ПередачаДанныхПереопределяемый.МенеджерыЛогическихХранилищ(ВсеМенеджерыЛогическихХранилищ);
	
	Возврат Новый ФиксированноеСоответствие(ВсеМенеджерыЛогическихХранилищ);
	
КонецФункции

Функция МенеджерыФизическихХранилищ() Экспорт
	
	ВсеМенеджерыФизическихХранилищ = Новый Соответствие;
	
	ПередачаДанныхВстраивание.МенеджерыФизическихХранилищ(ВсеМенеджерыФизическихХранилищ);
	ПередачаДанныхПереопределяемый.МенеджерыФизическихХранилищ(ВсеМенеджерыФизическихХранилищ);
	
	Возврат Новый ФиксированноеСоответствие(ВсеМенеджерыФизическихХранилищ);
	
КонецФункции

Функция Соединение(СтруктураURI, Пользователь, Пароль, Таймаут) Экспорт
	
	ЗащищенноеСоединение = ?(СтруктураURI.Схема = "https", ОбщегоНазначенияКлиентСервер.НовоеЗащищенноеСоединение(, Новый СертификатыУдостоверяющихЦентровОС), Неопределено);
	Порт = ?(ЗначениеЗаполнено(СтруктураURI.Порт), Число(СтруктураURI.Порт), ?(ЗащищенноеСоединение = Неопределено, 80, 443));
	
	Возврат Новый HTTPСоединение(СтруктураURI.Хост, Порт, Пользователь, Пароль,, Таймаут, ЗащищенноеСоединение);
	
КонецФункции

#КонецОбласти
