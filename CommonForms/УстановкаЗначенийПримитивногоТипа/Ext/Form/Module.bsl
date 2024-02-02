﻿
////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	ИмяРеквизита = Параметры.ИмяРеквизита;
	Если Параметры.ТипЗначения.СодержитТип(Тип("Строка")) Тогда
		ИнициализироватьФормуДляВыбораСтроки();
	ИначеЕсли Параметры.ТипЗначения.СодержитТип(Тип("Дата")) Тогда
		ИнициализироватьФормуДляВыбораПериодаДат();
	ИначеЕсли Параметры.ТипЗначения.СодержитТип(Тип("Число")) Тогда
		ИнициализироватьФормуДляВыбораПериодаЧисел();
	ИначеЕсли ТипЗнч(Параметры.Значение) = Тип("СписокЗначений") Тогда
		ИнициализироватьФормуДляВыбораСпискаЗначений();
	Иначе
		ВызватьИсключение НСтр("ru = 'Некорректный вызов обработки.'");
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти // ОбработчикиСобытийФормы

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ
#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура КомандаОтмена(Команда)
	Закрыть();
КонецПроцедуры

&НаКлиенте
Процедура КомандаОК(Команда)
	
	СтруктураВозврата = Новый Структура;
	Если Элементы.СтраницыВидовОтбора.ТекущаяСтраница = Элементы.СтраницаОтборСтрока Тогда
		СтруктураВозврата.Вставить("ЗначениеОтбора", ЭтотОбъект["ЗначениеСтрока"]);
	ИначеЕсли Элементы.СтраницыВидовОтбора.ТекущаяСтраница = Элементы.СтраницаОтборДата Тогда
		СтруктураВозврата.Вставить("ИнтервалОт", ЭтотОбъект["ЗначениеДатаОт"]);
		СтруктураВозврата.Вставить("ИнтервалДо", ЭтотОбъект["ЗначениеДатаДо"]);
	ИначеЕсли Элементы.СтраницыВидовОтбора.ТекущаяСтраница = Элементы.СтраницаОтборЧисло Тогда
		СтруктураВозврата.Вставить("ИнтервалОт", ЭтотОбъект["ЗначениеЧислоОт"]);
		СтруктураВозврата.Вставить("ИнтервалДо", ЭтотОбъект["ЗначениеЧислоДо"]);
	ИначеЕсли Элементы.СтраницыВидовОтбора.ТекущаяСтраница = Элементы.СтраницаОтборСписок Тогда
		ЗначениеОтбора = Новый СписокЗначений;
		Для Каждого Элемент Из ЭтотОбъект["ЗначениеСписок"] Цикл
			Если Элемент.Пометка
			   И ЗначениеОтбора.НайтиПоЗначению(Элемент.Значение) = Неопределено Тогда
				ЗначениеОтбора.Добавить(Элемент.Значение);
			КонецЕсли;
		КонецЦикла;
		СтруктураВозврата.Вставить("ЗначениеОтбора", ЗначениеОтбора);
	КонецЕсли;
	
	Закрыть(СтруктураВозврата);
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьИнтервал(Команда)
	
	Диалог = Новый ДиалогРедактированияСтандартногоПериода();
	
	Диалог.Период.ДатаНачала    = ЭтотОбъект["ЗначениеДатаОт"];
	Диалог.Период.ДатаОкончания = ЭтотОбъект["ЗначениеДатаДо"];
	Оповещение = Новый ОписаниеОповещения("УстановитьИнтервалЗавершение", ЭтотОбъект);
	Диалог.Показать(Оповещение);
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьИнтервалЗавершение(Период, ДополнительныеПараметры) Экспорт
	
	Если Период <> Неопределено Тогда
		
		ЭтотОбъект["ЗначениеДатаОт"] = Период.ДатаНачала;
		ЭтотОбъект["ЗначениеДатаДо"] = Период.ДатаОкончания;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти // ОбработчикиКомандФормы

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ФОРМЫ
#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура Подключаемый_ЗначениеСписокОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	Для Каждого Значение Из ВыбранноеЗначение Цикл
		ЭлементСписка = ЭтотОбъект["ЗначениеСписок"].НайтиПоЗначению(Значение);
		Если ЭлементСписка = Неопределено Тогда
			ЭлементСписка = ЭтотОбъект["ЗначениеСписок"].Добавить(Значение,, Истина);
		Иначе
			ЭлементСписка.Пометка = Истина;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ЗначениеСписокПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	
	Отказ = Истина;
	ЭлементСписка = ЭтотОбъект["ЗначениеСписок"].Добавить(,, Истина);
	Элемент.ТекущаяСтрока = ЭлементСписка.ПолучитьИдентификатор();
	Элемент.ТекущийЭлемент = Элементы["ЗначениеСписокЗначение"];
	Элемент.ИзменитьСтроку();
	
КонецПроцедуры

#КонецОбласти // ОбработчикиСобытийЭлементовФормы

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ
#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ИнициализироватьФормуДляВыбораСтроки()
	
	Заголовок = НСтр("ru = 'Установите значение отбора'");
	КлючСохраненияПоложенияОкна = "ВыборСтроки";
	
	НовыеРеквизиты = Новый Массив;
	НовыеРеквизиты.Добавить(
		Новый РеквизитФормы("ЗначениеСтрока", Новый ОписаниеТипов("Строка",, Параметры.ТипЗначения.КвалификаторыСтроки)));
	ИзменитьРеквизиты(НовыеРеквизиты);
	
	ЭлементЗначениеСтрока = Элементы.Добавить("ЗначениеСтрока", Тип("ПолеФормы"), Элементы.СтраницаОтборСтрока);
	ЭлементЗначениеСтрока.Вид = ВидПоляФормы.ПолеВвода;
	ЭлементЗначениеСтрока.ПутьКДанным = "ЗначениеСтрока";
	ЭлементЗначениеСтрока.ПоложениеЗаголовка = ПоложениеЗаголовкаЭлементаФормы.Нет;
	ЭлементЗначениеСтрока.Ширина = 44;
	ЭлементЗначениеСтрока.АвтоМаксимальнаяШирина = Ложь;
	ЭлементЗначениеСтрока.КнопкаВыпадающегоСписка = Истина;
	ЭлементЗначениеСтрока.КнопкаОчистки = Истина;
	
	ЭтотОбъект["ЗначениеСтрока"] = Параметры.Значение.Строка;
	ЭлементЗначениеСтрока.СписокВыбора.ЗагрузитьЗначения(Параметры.Значение.СписокВыбора);
	
	Элементы.СтраницыВидовОтбора.ТекущаяСтраница = Элементы.СтраницаОтборСтрока;
	
КонецПроцедуры

&НаСервере
Процедура ИнициализироватьФормуДляВыбораПериодаДат()
	
	Заголовок = НСтр("ru = 'Установите интервал значений отбора'");
	КлючСохраненияПоложенияОкна = "ВыборДаты";
	
	НовыеРеквизиты = Новый Массив;
	НовыеРеквизиты.Добавить(
		Новый РеквизитФормы("ЗначениеДатаОт", Новый ОписаниеТипов("Дата",,, Параметры.ТипЗначения.КвалификаторыДаты)));
	НовыеРеквизиты.Добавить(
		Новый РеквизитФормы("ЗначениеДатаДо", Новый ОписаниеТипов("Дата",,, Параметры.ТипЗначения.КвалификаторыДаты)));
	ИзменитьРеквизиты(НовыеРеквизиты);
	
	ЭлементЗначениеДатаОт = Элементы.Вставить(
		"ЗначениеДатаОт",
		Тип("ПолеФормы"),
		Элементы.СтраницаОтборДата,
		Элементы.УстановитьИнтервал);
	ЭлементЗначениеДатаОт.Вид = ВидПоляФормы.ПолеВвода;
	ЭлементЗначениеДатаОт.ПутьКДанным = "ЗначениеДатаОт";
	ЭлементЗначениеДатаОт.Заголовок = НСтр("ru = 'от'");
	ЭлементЗначениеДатаОт.КнопкаОчистки = Истина;
	ЭлементЗначениеДатаОт.ФорматРедактирования = Параметры.Значение.Формат;
	
	ЭлементЗначениеДатаДо = Элементы.Вставить(
		"ЗначениеДатаДо",
		Тип("ПолеФормы"),
		Элементы.СтраницаОтборДата,
		Элементы.УстановитьИнтервал);
	ЭлементЗначениеДатаДо.Вид = ВидПоляФормы.ПолеВвода;
	ЭлементЗначениеДатаДо.ПутьКДанным = "ЗначениеДатаДо";
	ЭлементЗначениеДатаДо.Заголовок = НСтр("ru = 'до'");
	ЭлементЗначениеДатаДо.КнопкаОчистки = Истина;
	ЭлементЗначениеДатаДо.ФорматРедактирования = Параметры.Значение.Формат;
	
	ЭтотОбъект["ЗначениеДатаОт"] = Параметры.Значение.ИнтервалОт;
	ЭтотОбъект["ЗначениеДатаДо"] = Параметры.Значение.ИнтервалДо;
	
	Элементы.СтраницыВидовОтбора.ТекущаяСтраница = Элементы.СтраницаОтборДата;
	
	Элементы.УстановитьИнтервал.Видимость = (Параметры.ТипЗначения.КвалификаторыДаты.ЧастиДаты <> ЧастиДаты.Время);
	
КонецПроцедуры

&НаСервере
Процедура ИнициализироватьФормуДляВыбораПериодаЧисел()
	
	Заголовок = НСтр("ru = 'Установите интервал значений отбора'");
	КлючСохраненияПоложенияОкна = "ВыборЧисла";
	
	НовыеРеквизиты = Новый Массив;
	НовыеРеквизиты.Добавить(
		Новый РеквизитФормы("ЗначениеЧислоОт", Новый ОписаниеТипов("Число", Параметры.ТипЗначения.КвалификаторыЧисла)));
	НовыеРеквизиты.Добавить(
		Новый РеквизитФормы("ЗначениеЧислоДо", Новый ОписаниеТипов("Число", Параметры.ТипЗначения.КвалификаторыЧисла)));
	ИзменитьРеквизиты(НовыеРеквизиты);
	
	ЭлементЗначениеЧислоОт = Элементы.Добавить("ЗначениеЧислоОт", Тип("ПолеФормы"), Элементы.СтраницаОтборЧисло);
	ЭлементЗначениеЧислоОт.Вид = ВидПоляФормы.ПолеВвода;
	ЭлементЗначениеЧислоОт.ПутьКДанным = "ЗначениеЧислоОт";
	ЭлементЗначениеЧислоОт.Заголовок = НСтр("ru = 'от'");
	ЭлементЗначениеЧислоОт.КнопкаОчистки = Истина;
	ЭлементЗначениеЧислоОт.ФорматРедактирования = Параметры.Значение.Формат;
	
	ЭлементЗначениеЧислоДо = Элементы.Добавить("ЗначениеЧислоДо", Тип("ПолеФормы"), Элементы.СтраницаОтборЧисло);
	ЭлементЗначениеЧислоДо.Вид = ВидПоляФормы.ПолеВвода;
	ЭлементЗначениеЧислоДо.ПутьКДанным = "ЗначениеЧислоДо";
	ЭлементЗначениеЧислоДо.Заголовок = НСтр("ru = 'до'");
	ЭлементЗначениеЧислоДо.КнопкаОчистки = Истина;
	ЭлементЗначениеЧислоДо.ФорматРедактирования = Параметры.Значение.Формат;
	
	ЭтотОбъект["ЗначениеЧислоОт"] = Параметры.Значение.ИнтервалОт;
	ЭтотОбъект["ЗначениеЧислоДо"] = Параметры.Значение.ИнтервалДо;
	
	Элементы.СтраницыВидовОтбора.ТекущаяСтраница = Элементы.СтраницаОтборЧисло;
	
КонецПроцедуры

&НаСервере
Процедура ИнициализироватьФормуДляВыбораСпискаЗначений()
	
	Заголовок = НСтр("ru = 'Установите значение отбора'");
	КлючСохраненияПоложенияОкна = "ВыборСписка";
	
	ПолноеИмяОбъекта = Метаданные.НайтиПоТипу(Параметры.ТипЗначения.Типы()[0]).ПолноеИмя();
	
	Если Параметры.ЭтоДопРеквизит Тогда
		Свойство = Параметры.Свойство;
		ЭтоЗначенияСвойствОбъектов =
			Параметры.ТипЗначения.СодержитТип(Тип("СправочникСсылка.ЗначенияСвойствОбъектов"))
			Или Параметры.ТипЗначения.СодержитТип(Тип("СправочникСсылка.ЗначенияСвойствОбъектовИерархия"));
	КонецЕсли;
	
	НовыеРеквизиты = Новый Массив;
	НовыеРеквизиты.Добавить(Новый РеквизитФормы("ЗначениеСписок", Новый ОписаниеТипов("СписокЗначений")));
	ИзменитьРеквизиты(НовыеРеквизиты);
	
	ЭтотОбъект["ЗначениеСписок"].ТипЗначения = Параметры.ТипЗначения;
	Для Каждого Элемент Из Параметры.Значение Цикл
		ЭтотОбъект["ЗначениеСписок"].Добавить(Элемент.Значение,, Истина);
	КонецЦикла;
	
	ЭлементСписок = Элементы.Добавить("ЗначениеСписок", Тип("ТаблицаФормы"), Элементы.СтраницаОтборСписок);
	ЭлементСписок.ПутьКДанным = "ЗначениеСписок";
	ЭлементСписок.УстановитьДействие("ПередНачаломДобавления", "Подключаемый_ЗначениеСписокПередНачаломДобавления");
	ЭлементСписок.УстановитьДействие("ОбработкаВыбора", "Подключаемый_ЗначениеСписокОбработкаВыбора");
	
	Элемент = Элементы.Добавить("ЗначениеСписокПометка", Тип("ПолеФормы"), ЭлементСписок);
	Элемент.Вид = ВидПоляФормы.ПолеФлажка;
	Элемент.ПутьКДанным = "ЗначениеСписок.Пометка";
	
	Элемент = Элементы.Добавить("ЗначениеСписокЗначение", Тип("ПолеФормы"), ЭлементСписок);
	Элемент.Вид = ВидПоляФормы.ПолеВвода;
	Элемент.ПутьКДанным = "ЗначениеСписок.Значение";
	Элемент.Заголовок = НСтр("ru = 'Значение отбора'");
	
	Если ЭтоЗначенияСвойствОбъектов Тогда
		ПараметрыВыбора = Новый Массив;
		ПараметрыВыбора.Добавить(Новый ПараметрВыбора("Отбор.Владелец", Свойство));
		Элемент.ПараметрыВыбора = Новый ФиксированныйМассив(ПараметрыВыбора);
	КонецЕсли;
	
	Элементы.СтраницыВидовОтбора.ТекущаяСтраница = Элементы.СтраницаОтборСписок;
	
КонецПроцедуры

#КонецОбласти // СлужебныеПроцедурыИФункции
