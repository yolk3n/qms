﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2018, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)

	// Не должно быть повторений доступных категорий.
	ТаблицаПроверки = ДоступныеКатегорииНовостей.Выгрузить(, "КатегорияНовостей");
	ТаблицаПроверки.Колонки.Добавить("КоличествоСтрок");
	ТаблицаПроверки.ЗаполнитьЗначения(1, "КоличествоСтрок");
	ТаблицаПроверки.Свернуть("КатегорияНовостей", "КоличествоСтрок");
	Для каждого ТекущаяСтрока Из ТаблицаПроверки Цикл
		Если ТекущаяСтрока.КоличествоСтрок > 1 Тогда
			Отказ = Истина;
			Сообщение = Новый СообщениеПользователю;
			Сообщение.УстановитьДанные(ЭтотОбъект);
			Сообщение.Поле = "ДоступныеКатегорииНовостей";
			Сообщение.ПутьКДанным = "Объект";
			Сообщение.Текст = НСтр("ru='Категория [%КатегорияНовостей%] повторяется несколько раз.
				|Каждую категорию разрешено вводить только один раз.'");
			Сообщение.Текст = СтрЗаменить(Сообщение.Текст, "%КатегорияНовостей%", ТекущаяСтрока.КатегорияНовостей);
			Сообщение.Сообщить();
		КонецЕсли;
	КонецЦикла;

	Если ВРег(Протокол) = ВРег("file") Тогда
		// Удалить из проверяемых реквизитов "Сайт".
		НайденнаяСтрока = ПроверяемыеРеквизиты.Найти("Сайт");
		Если НайденнаяСтрока <> Неопределено Тогда
			ПроверяемыеРеквизиты.Удалить(НайденнаяСтрока);
		КонецЕсли;
	КонецЕсли;

	Если ЗагруженоССервера = Ложь Тогда
		Если ЛокальнаяЛентаНовостей = Истина Тогда
			// Удалить из проверяемых реквизитов все, связанное с обновлением:
			//  "Сайт", "Протокол", "ИмяФайла", "ВариантЛогинаПароля", "Логин", "Пароль".
			НайденнаяСтрока = ПроверяемыеРеквизиты.Найти("Сайт");
			Если НайденнаяСтрока <> Неопределено Тогда
				ПроверяемыеРеквизиты.Удалить(НайденнаяСтрока);
			КонецЕсли;
			НайденнаяСтрока = ПроверяемыеРеквизиты.Найти("Протокол");
			Если НайденнаяСтрока <> Неопределено Тогда
				ПроверяемыеРеквизиты.Удалить(НайденнаяСтрока);
			КонецЕсли;
			НайденнаяСтрока = ПроверяемыеРеквизиты.Найти("ИмяФайла");
			Если НайденнаяСтрока <> Неопределено Тогда
				ПроверяемыеРеквизиты.Удалить(НайденнаяСтрока);
			КонецЕсли;
			НайденнаяСтрока = ПроверяемыеРеквизиты.Найти("ВариантЛогинаПароля");
			Если НайденнаяСтрока <> Неопределено Тогда
				ПроверяемыеРеквизиты.Удалить(НайденнаяСтрока);
			КонецЕсли;
			НайденнаяСтрока = ПроверяемыеРеквизиты.Найти("Логин");
			Если НайденнаяСтрока <> Неопределено Тогда
				ПроверяемыеРеквизиты.Удалить(НайденнаяСтрока);
			КонецЕсли;
			НайденнаяСтрока = ПроверяемыеРеквизиты.Найти("Пароль");
			Если НайденнаяСтрока <> Неопределено Тогда
				ПроверяемыеРеквизиты.Удалить(НайденнаяСтрока);
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;

КонецПроцедуры

Процедура ПередЗаписью(Отказ)

	// Проверка должна находиться в самом начале процедуры.
	// Это необходимо для того, чтобы никакая бизнес-логика объекта не выполнялась при записи объекта через механизм обмена данными,
	//  поскольку она уже была выполнена для объекта в том узле, где он был создан.
	// В этом случае все данные загружаются в ИБ "как есть", без искажений (изменений),
	//  проверок или каких-либо других дополнительных действий, препятствующих загрузке данных.
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;

	// Возможные значения: http, https и file.
	Если ВРег(Протокол) = ВРег("https") Тогда
		Протокол = "https";
	ИначеЕсли ВРег(Протокол) = ВРег("http") Тогда
		Протокол = "http";
	ИначеЕсли ВРег(Протокол) = ВРег("file") Тогда
		Протокол = "file";
	Иначе
		Протокол = "http";
	КонецЕсли;

	// Для локально-обновляемой ленты новостей установить протокол "file",
	//  чтобы корректно отрабатывала Обработки.УправлениеНовостями.ЗагрузитьФайлыНовостейССервера(ЛентыНовостей).
	Если ЛокальнаяЛентаНовостей = Истина Тогда
		Протокол = "file";
	КонецЕсли;

	Если ВРег(Протокол) = ВРег("file") Тогда
		Сайт   = "";
		ВариантЛогинаПароля = Перечисления.ВариантЛогинаПароляДляЛентыНовостей.БезЛогинаПароля;
		Логин  = "";
		Пароль = Новый ХранилищеЗначения("", Новый СжатиеДанных(0));
	КонецЕсли;

	Если ЗагруженоССервера = Истина Тогда
		// Лента новостей, загруженная с сервера, не может быть локально-обновляемой
		//  (т.е. не загружать данные из файла, а создавать в справочнике напрямую).
		ЛокальнаяЛентаНовостей = Ложь;
		// Нельзя пометить на удаление ленту новостей, загруженную с сервера
		//  за исключением программного удаления (если ленту отключили в новостном центре).
		Если (ПометкаУдаления = Истина)
				И (Ссылка.ПометкаУдаления = Ложь) Тогда
			Если (ДополнительныеСвойства.Свойство("УдалениеЛентыНовостейЗагруженнойССервера") = Истина)
					И (ДополнительныеСвойства.УдалениеЛентыНовостейЗагруженнойССервера = Истина) Тогда
				// Все нормально, лента удаляется программно - вероятно, ее отключили в новостном центре.
			Иначе
				ТекстСообщения = НСтр("ru='Нельзя помечать на удаление ленты новостей, загруженные автоматически с сервера новостей.'");
				Сообщение = Новый СообщениеПользователю();
				Сообщение.Текст = ТекстСообщения;
				Сообщение.УстановитьДанные(Ссылка);
				Сообщение.Сообщить();
				Отказ = Истина;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;

	// В обязательном канале, загруженном с сервера, запрещено:
	// - выбирать частоту обновления "Обновлять только вручную";
	// - устанавливать свойство ВидимостьПоУмолчанию в ЛОЖЬ, при этом не указывая список пользователей.
	Если (ЗагруженоССервера = Истина)
			И (ОбязательныйКанал) Тогда
		Если (ЧастотаОбновления = 0) Тогда
			ТекстСообщения = НСтр("ru='Для обязательной ленты новостей нельзя устанавливать частоту обновления [Обновлять только вручную].'");
			Сообщение = Новый СообщениеПользователю();
			Сообщение.Текст = ТекстСообщения;
			Сообщение.УстановитьДанные(Ссылка);
			Сообщение.Сообщить();
			Отказ = Истина;
		КонецЕсли;
		Если (ВидимостьПоУмолчанию = Ложь) И (ИсключенияВидимости.Количество() = 0) Тогда
			ТекстСообщения = НСтр("ru='Для обязательной ленты новостей нельзя устанавливать видимость по умолчанию в [Скрыта от всех] и не указывать список пользователей, которые будут видеть эту ленту новостей.'");
			Сообщение = Новый СообщениеПользователю();
			Сообщение.Текст = ТекстСообщения;
			Сообщение.УстановитьДанные(Ссылка);
			Сообщение.Сообщить();
			Отказ = Истина;
		КонецЕсли;
	КонецЕсли;

КонецПроцедуры

Процедура ПриЗаписи(Отказ)

	// Проверка должна находиться в самом начале процедуры.
	// Это необходимо для того, чтобы никакая бизнес-логика объекта не выполнялась при записи объекта через механизм обмена данными,
	//  поскольку она уже была выполнена для объекта в том узле, где он был создан.
	// В этом случае все данные загружаются в ИБ "как есть", без искажений (изменений),
	//  проверок или каких-либо других дополнительных действий, препятствующих загрузке данных.
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;

	// В модуле объекта не оптимизируются и не пересчитываются отборы по новостям.
	// Если происходит загрузка лент новостей (при загрузке классификаторов), то лучше пересчитать отборы один раз.
	// Если происходит редактирование элемента справочника, то отборы будут пересчитаны в форме элемента.

КонецПроцедуры

#КонецОбласти

#КонецЕсли