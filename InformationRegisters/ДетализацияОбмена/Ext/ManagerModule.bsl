﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

////////////////////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС
#Область ПрограммныйИнтерфейс

Процедура ЗаполнитьДетализациюОбмена() Экспорт
	
	Если Не ПолучитьФункциональнуюОпцию("ИспользоватьИсточникиФинансирования") Тогда
		Возврат;
	КонецЕсли;
	
	ПланыОбменаСДетализациейОбмена = ОбменДаннымиБольничнаяАптека.ПланыОбменаИспользующиеДетализациюОбмена();
	ИменаОбрабатываемыхОбъектов = Новый Массив;
	Для Каждого ПланОбмена Из ПланыОбменаСДетализациейОбмена Цикл
		
		ОбрабатываемыеОбъектыТекущегоПланаОбмена = Новый Массив;
		Для Каждого ЭлементСостава Из ПланОбмена.Состав Цикл
			Если ОбщегоНазначения.ЭтоДокумент(ЭлементСостава.Метаданные)
			   И ОбщегоНазначенияБольничнаяАптека.ЕстьРеквизитТабличнойЧастиОбъекта("ИсточникФинансирования", ЭлементСостава.Метаданные, "Товары") Тогда
				ОбрабатываемыеОбъектыТекущегоПланаОбмена.Добавить(ЭлементСостава.Метаданные.ПолноеИмя());
			КонецЕсли;
		КонецЦикла;
		
		ОбщегоНазначенияКлиентСервер.ДополнитьМассив(ИменаОбрабатываемыхОбъектов, ОбрабатываемыеОбъектыТекущегоПланаОбмена, Истина);
		
	КонецЦикла;
	
	Если ИменаОбрабатываемыхОбъектов.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	ШаблонЗапроса = "
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	Объект.Ссылка КАК Объект,
	|	Объект.ИсточникФинансирования
	|ИЗ
	|	%1 КАК Объект
	|";
	ТекстОбъединения = Символы.ПС + "ОБЪЕДИНИТЬ ВСЕ" + Символы.ПС;
	
	ТекстЗапроса = "";
	Для Каждого ИмяОбъекта Из ИменаОбрабатываемыхОбъектов Цикл
		
		Если Не ПустаяСтрока(ТекстЗапроса) Тогда
			ТекстЗапроса = ТекстЗапроса + ТекстОбъединения;
			ТекстПоместить = "";
		КонецЕсли;
		ТекстЗапроса = ТекстЗапроса + СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ШаблонЗапроса, ИмяОбъекта + ".Товары");
		
	КонецЦикла;
	
	ТекстЗапроса = "
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	Объект КАК Объект,
	|	ИсточникФинансирования КАК ИсточникФинансирования
	|ПОМЕСТИТЬ ОбъектыДетализацииОбмена
	|ИЗ
	|	(" + ТекстЗапроса + ") КАК ОбъектыДетализацииОбмена
	|ИНДЕКСИРОВАТЬ ПО
	|	Объект,
	|	ИсточникФинансирования
	|;
	|
	|//////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Детализация.Объект КАК Объект,
	|	Детализация.ИсточникФинансирования КАК ИсточникФинансирования,
	|	Детализация.УникальныйИдентификатор КАК УникальныйИдентификатор
	|ПОМЕСТИТЬ ДетализацияОбмена
	|ИЗ
	|	РегистрСведений.ДетализацияОбмена КАК Детализация
	|ИНДЕКСИРОВАТЬ ПО
	|	Объект,
	|	ИсточникФинансирования
	|;
	|
	|//////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ОбъектыДетализацииОбмена.Объект КАК Объект,
	|	ОбъектыДетализацииОбмена.ИсточникФинансирования КАК ИсточникФинансирования
	|ИЗ
	|	ОбъектыДетализацииОбмена КАК ОбъектыДетализацииОбмена
	|	ЛЕВОЕ СОЕДИНЕНИЕ
	|		ДетализацияОбмена КАК Детализация
	|		ПО
	|			ОбъектыДетализацииОбмена.Объект = Детализация.Объект
	|			И ОбъектыДетализацииОбмена.ИсточникФинансирования = Детализация.ИсточникФинансирования
	|ГДЕ
	|	Детализация.Объект ЕСТЬ NULL
	|УПОРЯДОЧИТЬ ПО
	|	Объект
	|;
	|
	|//////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Детализация.Объект КАК Объект,
	|	Детализация.ИсточникФинансирования КАК ИсточникФинансирования,
	|	Детализация.УникальныйИдентификатор КАК УникальныйИдентификатор
	|ИЗ
	|	ДетализацияОбмена КАК Детализация
	|	ЛЕВОЕ СОЕДИНЕНИЕ
	|		ОбъектыДетализацииОбмена КАК ОбъектыДетализацииОбмена
	|		ПО
	|			ОбъектыДетализацииОбмена.Объект = Детализация.Объект
	|			И ОбъектыДетализацииОбмена.ИсточникФинансирования = Детализация.ИсточникФинансирования
	|ГДЕ
	|	ОбъектыДетализацииОбмена.Объект ЕСТЬ NULL
	|УПОРЯДОЧИТЬ ПО
	|	Объект
	|;
	|
	|//////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ОбъектыДетализацииОбмена.Объект КАК Объект,
	|	ОбъектыДетализацииОбмена.ИсточникФинансирования КАК ИсточникФинансирования,
	|	Детализация.УникальныйИдентификатор КАК УникальныйИдентификатор
	|ИЗ
	|	ОбъектыДетализацииОбмена КАК ОбъектыДетализацииОбмена
	|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ
	|		ДетализацияОбмена КАК Детализация
	|		ПО
	|			ОбъектыДетализацииОбмена.Объект = Детализация.Объект
	|			И ОбъектыДетализацииОбмена.ИсточникФинансирования = Детализация.ИсточникФинансирования
	|УПОРЯДОЧИТЬ ПО
	|	Объект
	|";
	
	Запрос = Новый Запрос(ТекстЗапроса);
	РезультатыЗапроса = Запрос.ВыполнитьПакет();
	
	ДанныеДляДобавления = РезультатыЗапроса[2];
	ДанныеДляУдаления = РезультатыЗапроса[3];
	
	Если ДанныеДляДобавления.Пустой() И ДанныеДляУдаления.Пустой() Тогда
		Возврат;
	КонецЕсли;
	
	НаборДанных = РегистрыСведений.ДетализацияОбмена.СоздатьНаборЗаписей();
	НаборДанных.Загрузить(РезультатыЗапроса[4].Выгрузить());
	
	Если Не ДанныеДляДобавления.Пустой() Тогда
		УдаляемыеДанные = ДанныеДляУдаления.Выгрузить();
		Выборка = ДанныеДляДобавления.Выбрать();
		Пока Выборка.Следующий() Цикл
			
			СтрокаНабора = НаборДанных.Добавить();
			СтрокаНабора.Объект = Выборка.Объект;
			СтрокаНабора.ИсточникФинансирования = Выборка.ИсточникФинансирования;
			
			УдаляемыеДанныеОбъекта = УдаляемыеДанные.НайтиСтроки(Новый Структура("Объект", Выборка.Объект));
			Если УдаляемыеДанныеОбъекта.Количество() > 0 Тогда
				СтрокаНабора.УникальныйИдентификатор = УдаляемыеДанныеОбъекта[0].УникальныйИдентификатор;
				УдаляемыеДанные.Удалить(УдаляемыеДанныеОбъекта[0]);
			Иначе
				СтрокаНабора.УникальныйИдентификатор = Строка(Новый УникальныйИдентификатор);
			КонецЕсли;
			
		КонецЦикла;
	КонецЕсли;
	
	НаборДанных.Записать(Истина);
	
КонецПроцедуры

#КонецОбласти // ПрограммныйИнтерфейс

#КонецЕсли