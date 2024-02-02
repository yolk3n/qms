﻿
////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьУсловноеОформление();
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Запрос = Новый Запрос("
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	МИНИМУМ(ЧекККМ.Дата) КАК Дата
	|ИЗ
	|	Документ.ЧекККМ КАК ЧекККМ
	|ГДЕ
	|	ЧекККМ.Проведен
	|	И ЧекККМ.КассоваяСмена.СтатусКассовойСмены <> ЗНАЧЕНИЕ(Перечисление.СтатусыКассовойСмены.Открыта)
	|");
	
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		ДатаНачала = Выборка.Дата;
	КонецЕсли;
	
	КоличествоДнейХраненияЧеков = Константы.КоличествоДнейХраненияЗаархивированныхЧеков.Получить();
	ДатаОкончания = ОбщегоНазначенияБольничнаяАптекаКлиентСервер.ДобавитьКДате(ТекущаяДатаСеанса(), "ДЕНЬ", - КоличествоДнейХраненияЧеков);
	
	Если ДатаНачала > ДатаОкончания Тогда
		ДатаНачала = ДатаОкончания;
	КонецЕсли;
	
	ОбновитьСписокКассККМ();
	
КонецПроцедуры

#КонецОбласти

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ФОРМЫ
#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура ПериодДатаНачалаПриИзменении(Элемент)
	
	Если ДатаНачала > ДатаОкончания Тогда
		ДатаОкончания = ДатаНачала;
	КонецЕсли;
	ОбновитьСписокКассККМ();
	
КонецПроцедуры

&НаКлиенте
Процедура ПериодДатаОкончанияПриИзменении(Элемент)
	
	Если ДатаНачала > ДатаОкончания Тогда
		ДатаНачала = ДатаОкончания;
	КонецЕсли;
	ОбновитьСписокКассККМ();
	
КонецПроцедуры

&НаКлиенте
Процедура ВариантОбработкиПриИзменении(Элемент)
	
	ОбновитьСписокКассККМ();
	
КонецПроцедуры

#КонецОбласти // ОбработчикиСобытийЭлементовФормы

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ
#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура УстановитьИнтервал(Команда)
	
	Диалог = Новый ДиалогРедактированияСтандартногоПериода();
	Диалог.Период = Новый СтандартныйПериод(ДатаНачала, ДатаОкончания);
	Диалог.Показать(Новый ОписаниеОповещения("УстановитьИнтервалЗавершение", ЭтотОбъект));
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьВыделенныеКассы(Команда)
	
	МассивСтрок = Элементы.ТаблицаКассы.ВыделенныеСтроки;
	УстановитьЗначениеВыбораВыделенныхКасс(МассивСтрок, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ИсключитьВыделенныеКассы(Команда)
	
	МассивСтрок = Элементы.ТаблицаКассы.ВыделенныеСтроки;
	УстановитьЗначениеВыбораВыделенныхКасс(МассивСтрок, Ложь);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьОбработкуЧеков(Команда)
	
	МассивВыбранныхСтрок = ТаблицаКассы.НайтиСтроки(Новый Структура("Выбран", Истина));
	
	Если МассивВыбранныхСтрок.Количество() = 0 Тогда
		ТекстСообщения = НСтр("ru='Для обработки чеков ККМ необходимо выбрать хотя бы одну кассу ККМ.'");
		ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения,, "ТаблицаКассы");
		Возврат;
	КонецЕсли;
	
	СписокКнопок = Новый СписокЗначений;
	Если ВариантОбработки = 1 Тогда
		ТекстВопроса = НСтр("ru='ВНИМАНИЕ! Все чеки ККМ за выбранный период будут удалены.
			|Это может занять продолжительное время. Удалить чеки ККМ?'");
		СписокКнопок.Добавить("Обработать", НСтр("ru = 'Удалить'"));
	Иначе
		ТекстВопроса = НСтр("ru='ВНИМАНИЕ! Все чеки ККМ за выбранный период будут заархивированы.
			|Это может занять продолжительное время. Заархивировать чеки ККМ?'");
		СписокКнопок.Добавить("Обработать", НСтр("ru = 'Заархивировать'"));
	КонецЕсли;
	СписокКнопок.Добавить("Отмена", НСтр("ru = 'Отмена'"));
	
	Оповестить = Новый ОписаниеОповещения("ОбработатьЧекиНаКлиенте", ЭтотОбъект);
	ПоказатьВопрос(Оповестить, ТекстВопроса, СписокКнопок);
	
КонецПроцедуры

#КонецОбласти

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ
#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	Элемент = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ТаблицаКассы.Имя);
	
	ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(Элемент.Отбор,
		"ТаблицаКассы.КоличествоЧеков", ВидСравненияКомпоновкиДанных.МеньшеИлиРавно, 0);
	
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ТекстЗапрещеннойЯчейкиЦвет);
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьИнтервалЗавершение(Период, ДополнительныеПараметры) Экспорт
	
	Если ЗначениеЗаполнено(Период) Тогда
		ДатаНачала    = Период.ДатаНачала;
		ДатаОкончания = Период.ДатаОкончания;
		ОбновитьСписокКассККМ();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьСписокКассККМ()
	
	Запрос = Новый Запрос("
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	КассыККМ.Ссылка КАК КассаККМ
	|ПОМЕСТИТЬ КассыККМ
	|ИЗ
	|	Справочник.КассыККМ КАК КассыККМ
	|ГДЕ
	|	КассыККМ.ТипКассы = ЗНАЧЕНИЕ(Перечисление.ТипыКассККМ.ФискальныйРегистратор)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	КОЛИЧЕСТВО(ЧекККМ.Ссылка)  КАК КоличествоЧековККМ,
	|	ЧекККМ.КассаККМ            КАК КассаККМ
	|ПОМЕСТИТЬ ЧекиККМ
	|ИЗ
	|	Документ.ЧекККМ КАК ЧекККМ
	|ГДЕ
	|	НЕ ЧекККМ.Архивный
	|	И &ВариантОбработки = 0
	|	И ЧекККМ.КассоваяСмена.Дата МЕЖДУ &ДатаНачала И &ДатаОкончания
	|	И ЧекККМ.КассоваяСмена.СтатусКассовойСмены <> ЗНАЧЕНИЕ(Перечисление.СтатусыКассовойСмены.Открыта)
	|
	|СГРУППИРОВАТЬ ПО
	|	ЧекККМ.КассаККМ
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	КОЛИЧЕСТВО(ЧекККМ.Ссылка)  КАК КоличествоЧековККМ,
	|	ЧекККМ.КассаККМ            КАК КассаККМ
	|ИЗ
	|	Документ.ЧекККМ КАК ЧекККМ
	|ГДЕ
	|	&ВариантОбработки = 1
	|	И ЧекККМ.КассоваяСмена.Дата МЕЖДУ &ДатаНачала И &ДатаОкончания
	|	И ЧекККМ.КассоваяСмена.СтатусКассовойСмены <> ЗНАЧЕНИЕ(Перечисление.СтатусыКассовойСмены.Открыта)
	|
	|СГРУППИРОВАТЬ ПО
	|	ЧекККМ.КассаККМ
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	КОЛИЧЕСТВО(ЧекККМВозврат.Ссылка)  КАК КоличествоЧековККМ,
	|	ЧекККМВозврат.КассаККМ            КАК КассаККМ
	|ИЗ
	|	Документ.ЧекККМВозврат КАК ЧекККМВозврат
	|ГДЕ
	|	НЕ ЧекККМВозврат.Архивный
	|	И &ВариантОбработки = 0
	|	И ЧекККМВозврат.КассоваяСмена.Дата МЕЖДУ &ДатаНачала И &ДатаОкончания
	|	И ЧекККМВозврат.КассоваяСмена.СтатусКассовойСмены <> ЗНАЧЕНИЕ(Перечисление.СтатусыКассовойСмены.Открыта)
	|
	|СГРУППИРОВАТЬ ПО
	|	ЧекККМВозврат.КассаККМ
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	КОЛИЧЕСТВО(ЧекККМВозврат.Ссылка)  КАК КоличествоЧековККМ,
	|	ЧекККМВозврат.КассаККМ            КАК КассаККМ
	|ИЗ
	|	Документ.ЧекККМВозврат КАК ЧекККМВозврат
	|ГДЕ
	|	&ВариантОбработки = 1
	|	И ЧекККМВозврат.КассоваяСмена.Дата МЕЖДУ &ДатаНачала И &ДатаОкончания
	|	И ЧекККМВозврат.КассоваяСмена.СтатусКассовойСмены <> ЗНАЧЕНИЕ(Перечисление.СтатусыКассовойСмены.Открыта)
	|
	|СГРУППИРОВАТЬ ПО
	|	ЧекККМВозврат.КассаККМ
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	КОЛИЧЕСТВО(ЧекККМКоррекции.Ссылка)  КАК КоличествоЧековККМ,
	|	ЧекККМКоррекции.КассаККМ            КАК КассаККМ
	|ИЗ
	|	Документ.ЧекККМКоррекции КАК ЧекККМКоррекции
	|ГДЕ
	|	НЕ ЧекККМКоррекции.Архивный
	|	И &ВариантОбработки = 0
	|	И ЧекККМКоррекции.КассоваяСмена.Дата МЕЖДУ &ДатаНачала И &ДатаОкончания
	|	И ЧекККМКоррекции.КассоваяСмена.СтатусКассовойСмены <> ЗНАЧЕНИЕ(Перечисление.СтатусыКассовойСмены.Открыта)
	|
	|СГРУППИРОВАТЬ ПО
	|	ЧекККМКоррекции.КассаККМ
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	КОЛИЧЕСТВО(ЧекККМКоррекции.Ссылка)  КАК КоличествоЧековККМ,
	|	ЧекККМКоррекции.КассаККМ            КАК КассаККМ
	|ИЗ
	|	Документ.ЧекККМКоррекции КАК ЧекККМКоррекции
	|ГДЕ
	|	&ВариантОбработки = 1
	|	И ЧекККМКоррекции.КассоваяСмена.Дата МЕЖДУ &ДатаНачала И &ДатаОкончания
	|	И ЧекККМКоррекции.КассоваяСмена.СтатусКассовойСмены <> ЗНАЧЕНИЕ(Перечисление.СтатусыКассовойСмены.Открыта)
	|
	|СГРУППИРОВАТЬ ПО
	|	ЧекККМКоррекции.КассаККМ
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	КОЛИЧЕСТВО(ОтчетОРозничныхПродажах.Ссылка)  КАК КоличествоЧековККМ,
	|	ОтчетОРозничныхПродажах.КассаККМ            КАК КассаККМ
	|ИЗ
	|	Документ.ОтчетОРозничныхПродажах КАК ОтчетОРозничныхПродажах
	|ГДЕ
	|	ОтчетОРозничныхПродажах.Дата МЕЖДУ &ДатаНачала И &ДатаОкончания
	|	И ОтчетОРозничныхПродажах.СтатусКассовойСмены = ЗНАЧЕНИЕ(Перечисление.СтатусыКассовойСмены.Закрыта)
	|	И ОтчетОРозничныхПродажах.КассаККМ.ТипКассы = ЗНАЧЕНИЕ(Перечисление.ТипыКассККМ.ФискальныйРегистратор)
	|
	|СГРУППИРОВАТЬ ПО
	|	ОтчетОРозничныхПродажах.КассаККМ
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	КассыККМ.КассаККМ                               КАК КассаККМ,
	|	СУММА(ЕСТЬNULL(ЧекиККМ.КоличествоЧековККМ, 0))  КАК КоличествоЧеков,
	|	МАКСИМУМ(ВЫБОР
	|		КОГДА ЧекиККМ.КоличествоЧековККМ > 0
	|			ТОГДА ИСТИНА
	|		ИНАЧЕ ЛОЖЬ
	|	КОНЕЦ)                                          КАК Выбран
	|ИЗ
	|	КассыККМ КАК КассыККМ
	|		ЛЕВОЕ СОЕДИНЕНИЕ
	|			ЧекиККМ КАК ЧекиККМ
	|		ПО
	|			КассыККМ.КассаККМ = ЧекиККМ.КассаККМ
	|СГРУППИРОВАТЬ ПО
	|	КассыККМ.КассаККМ
	|");
	
	Запрос.УстановитьПараметр("ДатаНачала"      , НачалоДня(ДатаНачала));
	Запрос.УстановитьПараметр("ДатаОкончания"   , КонецДня(ДатаОкончания));
	Запрос.УстановитьПараметр("ВариантОбработки", ВариантОбработки);
	
	ТаблицаКассы.Загрузить(Запрос.Выполнить().Выгрузить());
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьЗначениеВыбораВыделенныхКасс(ВыделенныеКассы, ЗначениеВыбора)
	
	Для Каждого ИдентификаторСтроки Из ВыделенныеКассы Цикл
		СтрокаТаблицы = ТаблицаКассы.НайтиПоИдентификатору(ИдентификаторСтроки);
		Если СтрокаТаблицы.Выбран = (Не ЗначениеВыбора) Тогда
			СтрокаТаблицы.Выбран = ЗначениеВыбора;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработатьЧекиНаКлиенте(РезультатВопроса, ДополнительныеПараметры) Экспорт
	
	Если РезультатВопроса <> "Обработать" Тогда
		Возврат;
	КонецЕсли;
	
	Задание = ОбработатьЧекиНаСервере();
	
	Оповестить = Новый ОписаниеОповещения("ОбработатьРезультатОбработкиЧеков", ЭтотОбъект);
	
	ПараметрыОжидания = ДлительныеОперацииКлиент.ПараметрыОжидания(ЭтотОбъект);
	
	Если ВариантОбработки = 0 Тогда
		ПараметрыОжидания.ТекстСообщения = НСтр("ru = 'Выполняется архивирование чеков ККМ.'");
	Иначе
		ПараметрыОжидания.ТекстСообщения = НСтр("ru = 'Выполняется удаление чеков ККМ.'");
	КонецЕсли;
	
	ДлительныеОперацииКлиент.ОжидатьЗавершение(Задание, Оповестить, ПараметрыОжидания);
	
КонецПроцедуры

&НаСервере
Функция ОбработатьЧекиНаСервере()
	
	Если ИдентификаторЗадания <> Неопределено Тогда
		ОтменитьВыполнениеЗадания(ИдентификаторЗадания);
		ИдентификаторЗадания = Неопределено;
	КонецЕсли;
	
	ПараметрыМетодаДлительнойОперации = ИнициализироватьПараметрыМетодаДлительнойОперации();
	
	ПараметрыВыполнения = ДлительныеОперации.ПараметрыВыполненияВФоне(УникальныйИдентификатор);
	
	Если ВариантОбработки = 0 Тогда
		ИмяОбработчика = "РозничныеПродажи.ВыполнитьАрхивированиеЧековККМ";
	Иначе
		ИмяОбработчика = "РозничныеПродажи.ВыполнитьУдалениеЧековККМ";
	КонецЕсли;
	
	Задание = ДлительныеОперации.ВыполнитьВФоне(ИмяОбработчика, ПараметрыМетодаДлительнойОперации, ПараметрыВыполнения);
	
	ИдентификаторЗадания = Задание.ИдентификаторЗадания;
	
	Возврат Задание;
	
КонецФункции

&НаСервере
Функция ИнициализироватьПараметрыМетодаДлительнойОперации()
	
	ОбрабатываемыеКассы = Новый Массив;
	
	ВыбранныеСтроки = ТаблицаКассы.НайтиСтроки(Новый Структура("Выбран", Истина));
	Для Каждого ТекущаяСтрока Из ВыбранныеСтроки Цикл
		ОбрабатываемыеКассы.Добавить(ТекущаяСтрока.КассаККМ);
	КонецЦикла;
	
	Запрос = Новый Запрос("
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	Документ.Ссылка КАК Ссылка
	|ИЗ
	|	Документ.ОтчетОРозничныхПродажах КАК Документ
	|ГДЕ
	|	Документ.Проведен
	|	И Документ.КассаККМ В(&КассыККМ)
	|	И Документ.Дата МЕЖДУ &ДатаНачала И &ДатаОкончания
	|
	|СГРУППИРОВАТЬ ПО
	|	Документ.Ссылка
	|");
	
	Запрос.УстановитьПараметр("КассыККМ"     , ОбрабатываемыеКассы);
	Запрос.УстановитьПараметр("ДатаНачала"   , НачалоДня(ДатаНачала));
	Запрос.УстановитьПараметр("ДатаОкончания", КонецДня(ДатаОкончания));
	
	ПараметрыМетодаДлительнойОперации = Новый Структура;
	ПараметрыМетодаДлительнойОперации.Вставить("КассоваяСмена"               , Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Ссылка"));
	ПараметрыМетодаДлительнойОперации.Вставить("ЗаписыватьВЖурналРегистрации", Истина);
	ПараметрыМетодаДлительнойОперации.Вставить("ОбработкаВыполнена"          , Ложь);
	
	Возврат ПараметрыМетодаДлительнойОперации;
	
КонецФункции

&НаКлиенте
Процедура ОбработатьРезультатОбработкиЧеков(РезультатЗадания, ДополнительныеПараметры) Экспорт
	
	Если ИдентификаторЗадания <> Неопределено Тогда
		ИдентификаторЗадания = Неопределено;
	КонецЕсли;
	
	ОбновитьСписокКассККМ();
	
	Если РезультатЗадания = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если РезультатЗадания.Статус = "Ошибка" Тогда
		ПоказатьПредупреждение(, РезультатЗадания.КраткоеПредставлениеОшибки);
		Возврат;
	КонецЕсли;
	
	РезультатОбработкиЧеков = ПолучитьИзВременногоХранилища(РезультатЗадания.АдресРезультата);
	Если ВариантОбработки = 0 Тогда
		Текст = НСтр("ru='Архивирование завершено.'");
		Если РезультатОбработкиЧеков.ОбработкаВыполнена Тогда
			Пояснение = НСтр("ru='Архивирование чеков ККМ успешно завершено.'");
		Иначе
			Пояснение = НСтр("ru='Архивирование чеков ККМ завершено с ошибками. См. журнал регистрации.'");
		КонецЕсли;
	Иначе
		Текст = НСтр("ru='Удаление завершено.'");
		Если РезультатОбработкиЧеков.ОбработкаВыполнена Тогда
			Пояснение = НСтр("ru='Удаление чеков ККМ успешно завершено.'");
		Иначе
			Пояснение = НСтр("ru='Удаление чеков ККМ завершено с ошибками. См. журнал регистрации.'");
		КонецЕсли;
	КонецЕсли;
	
	ПоказатьОповещениеПользователя(Текст,, Пояснение, БиблиотекаКартинок.Информация32);
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура ОтменитьВыполнениеЗадания(ИдентификаторЗадания)
	
	ДлительныеОперации.ОтменитьВыполнениеЗадания(ИдентификаторЗадания);
	
КонецПроцедуры

#КонецОбласти
