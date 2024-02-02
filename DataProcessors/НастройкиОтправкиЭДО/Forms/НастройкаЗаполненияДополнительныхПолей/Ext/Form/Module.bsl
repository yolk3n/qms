﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ПараметрОткрытия = Неопределено;
	Параметры.Свойство("ПараметрОткрытия", ПараметрОткрытия);
	Контрагент               = ПараметрОткрытия.Получатель;
	Организация              = ПараметрОткрытия.Отправитель;
	ДоговорКонтрагента       = ПараметрОткрытия.Договор;
	ВидЭлектронногоДокумента = ПараметрОткрытия.ВидДокумента;
	Если ПараметрОткрытия.Свойство("ЭтоНастройкаОтправки") Тогда
		Формат = Параметры.ПараметрОткрытия.Формат;
	Иначе
		Формат = НастройкиЭДО.НастройкиОтправки(ПараметрОткрытия).Формат;
	КонецЕсли;
	
	ЗаполнитьРазделыДополнительныхПолей();
	
	ПодготовитьФормуНаСервере();
	
	ПрочитатьНастройкиЗаполненияПолей();
	
	ИзменитьВидимостьИнформацииОЗаполненииПолей(ЭтотОбъект);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыОбластиДопПолей

&НаКлиенте
Процедура Подключаемый_ТаблицаНастроекПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	
	Если НоваяСтрока Тогда
		ОбновитьКоличествоСтрокТаблицыНастроек(Элемент);
		Элемент.ТекущиеДанные.Идентификатор = НовыйИдентификаторНастройкиПоля();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ТаблицаНастроекПриОкончанииРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования)
	
	Если НоваяСтрока И ОтменаРедактирования Тогда
		ОбновитьКоличествоСтрокТаблицыНастроек(Элемент);
		ИзменитьВидимостьИнформацииОЗаполненииПолей(ЭтотОбъект);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ТаблицаНастроекПослеУдаления(Элемент)
	
	ОбновитьКоличествоСтрокТаблицыНастроек(Элемент);
	ИзменитьВидимостьИнформацииОЗаполненииПолей(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПравилоОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ИмяТаблицы = Элемент.Родитель.Имя;
	ТекущиеДанные = Элемент.Родитель.ТекущиеДанные;
	ОбработатьВыборПравилЗаполнения(ВыбранноеЗначение, ТекущиеДанные, ИмяТаблицы);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПравилоОчистка(Элемент, СтандартнаяОбработка)
	
	Элемент.Родитель.ТекущиеДанные.Значение = Неопределено;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура СохранитьИЗакрыть(Команда)
	
	Если Не Модифицированность Тогда
		Закрыть();
		Возврат;
	КонецЕсли;
	
	НастройкаПустая = Истина;
	Для Каждого Раздел Из РазделыДополнительныхПолей Цикл
		Если ЭтотОбъект[Раздел.ИмяТаблицыНастроек].Количество() Тогда
			НастройкаПустая = Ложь;
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
	Если НастройкаПустая Тогда
		УдалитьНастройкуЗаполненияПолей();
		Закрыть(Ложь);
		Возврат;
	КонецЕсли;
	
	Отказ = Ложь;
	
	ПроверитьЗаполнениеОбязательныхПолей(Отказ);
	
	СохранитьНастройкуЗаполненияПолей(Отказ);
	
	Если Не Отказ Тогда
		Закрыть(Истина);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыгрузитьВФайл(Команда)
	
	АдресНастройки = АдресВыгрузкиНастройкиЗаполненияДопПолей();
	ИмяФайла = ОбщегоНазначенияКлиентСервер.ЗаменитьНедопустимыеСимволыВИмениФайла(
		СтрШаблон(НСтр("ru = 'Доп поля %1 %2.json'"), ВидЭлектронногоДокумента, ФорматПредставление));
	
	ФайловаяСистемаКлиент.СохранитьФайл(Неопределено, АдресНастройки, ИмяФайла);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьИзФайла(Команда)
	
	ЕстьНастройкиПолей = Ложь;
	Для Каждого Раздел Из РазделыДополнительныхПолей Цикл
		Если ЭтотОбъект[Раздел.ИмяТаблицыНастроек].Количество() Тогда
			ЕстьНастройкиПолей = Истина;
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
	Если ЕстьНастройкиПолей Тогда
		Оповещение = Новый ОписаниеОповещения("ЗагрузитьДанныеИзФайлаПослеВопроса", ЭтотОбъект);
		ТекстВопроса = НСтр("ru = 'Текущие настройки будут замещены данными из файла. Продолжить?'");
		ПоказатьВопрос(Оповещение, ТекстВопроса, РежимДиалогаВопрос.ДаНет);
	Иначе
		ЗагрузитьДанныеИзФайла();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура УдалитьНастройку(Команда)
	
	Оповещение = Новый ОписаниеОповещения("УдалитьНастройкуПослеВопроса", ЭтотОбъект);
	ТекстВопроса = НСтр("ru = 'Удалить настройку заполнения дополнительных полей?'");
	ПоказатьВопрос(Оповещение, ТекстВопроса,РежимДиалогаВопрос.ДаНет);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ЗаполнитьРазделыДополнительныхПолей()
	
	РазделыДополнительныхПолейФормата = ЭлектронныеДокументыЭДО.РазделыДополнительныхПолейФорматаЭлектронногоДокумента(
		ВидЭлектронногоДокумента, Формат);
	Для Каждого РазделФормата Из РазделыДополнительныхПолейФормата Цикл
		Раздел = РазделыДополнительныхПолей.Добавить();
		ЗаполнитьЗначенияСвойств(Раздел, РазделФормата);
		Раздел.ИмяТаблицыНастроек = "ТаблицаНастроек" + Раздел.Имя;
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ПодготовитьФормуНаСервере()
	
	УсловноеОформление.Элементы.Очистить();
	
	ВариантыПравилЗаполнения.Добавить("ВручнуюСтрокой", НСтр("ru = 'Вручную (строкой)'"));
	ВариантыПравилЗаполнения.Добавить("ВручнуюДатой",   НСтр("ru = 'Вручную (датой)'"));
	ВариантыПравилЗаполнения.Добавить("ВручнуюЧислом",  НСтр("ru = 'Вручную (числом)'"));
	ВариантыПравилЗаполнения.Добавить("ИзСписка",       НСтр("ru = 'Из списка'"));
	ВариантыПравилЗаполнения.Добавить("ПоФормуле",      НСтр("ru = 'По формуле'"));
	
	Для Каждого Раздел Из РазделыДополнительныхПолей Цикл
		
		СоздатьРеквизитыИЭлементыРазделаДополнительныхПолей(Раздел);
		
		УстановитьУсловноеОформлениеРазделаДополнительныхПолей(Раздел);
		
		ЗаполнитьСписокВыбораПравилЗаполнения(Раздел);
		
	КонецЦикла;
	
	
	ОтборФорматов = ЭлектронныеДокументыЭДО.НовыйОтборФорматовЭлектронныхДокументов();
	ОтборФорматов.ВидыДокументов.Добавить(ВидЭлектронногоДокумента);
	СведенияОФорматах = ЭлектронныеДокументыЭДО.ФорматыЭлектронныхДокументов(ОтборФорматов);
	
	ПараметрыОтбора = Новый Структура;
	ПараметрыОтбора.Вставить("ИдентификаторФормата", Формат);
	НайденныеСтроки = СведенияОФорматах.НайтиСтроки(ПараметрыОтбора);
	
	Если НайденныеСтроки.Количество() Тогда
		ФорматПредставление = СтроковыеФункции.ФорматированнаяСтрока(НСтр("ru = '<a href=""%1"">%2</a>'"),
			НайденныеСтроки[0].СсылкаНаПриказОВведении, НайденныеСтроки[0].ПредставлениеФормата);
	Иначе
		ФорматПредставление = СтроковыеФункции.ФорматированнаяСтрока(Формат);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура СоздатьРеквизитыИЭлементыРазделаДополнительныхПолей(Раздел)
	
	ИмяТаблицыНастроек = Раздел.ИмяТаблицыНастроек;
	ОписаниеТипаСтрока = Новый ОписаниеТипов("Строка");
	
	ДобавляемыеРеквизиты = Новый Массив;
	ДобавляемыеРеквизиты.Добавить(Новый РеквизитФормы(
		"КоличествоСтрок" + ИмяТаблицыНастроек, Новый ОписаниеТипов("Число")));
	ДобавляемыеРеквизиты.Добавить(Новый РеквизитФормы(
		ИмяТаблицыНастроек, Новый ОписаниеТипов("ТаблицаЗначений"),,
		СтрШаблон(НСтр("ru = 'Таблица дополнительных полей области ""%1""'"), Раздел.Представление), Истина));
	ДобавляемыеРеквизиты.Добавить(Новый РеквизитФормы(
		"Идентификатор", ОписаниеТипаСтрока, ИмяТаблицыНастроек));
	ДобавляемыеРеквизиты.Добавить(Новый РеквизитФормы(
		"Имя", ОписаниеТипаСтрока, ИмяТаблицыНастроек, НСтр("ru = 'Имя поля'")));
	ДобавляемыеРеквизиты.Добавить(Новый РеквизитФормы(
		"Правило", ОписаниеТипаСтрока, ИмяТаблицыНастроек, НСтр("ru = 'Правила заполнения'")));
	ДобавляемыеРеквизиты.Добавить(Новый РеквизитФормы(
		"Представление", ОписаниеТипаСтрока, ИмяТаблицыНастроек, НСтр("ru = 'Представление'")));
	ДобавляемыеРеквизиты.Добавить(Новый РеквизитФормы(
		"Описание", ОписаниеТипаСтрока, ИмяТаблицыНастроек, НСтр("ru = 'Описание'")));
	ДобавляемыеРеквизиты.Добавить(Новый РеквизитФормы(
		"Заполнение", ОписаниеТипаСтрока, ИмяТаблицыНастроек));
	ДобавляемыеРеквизиты.Добавить(Новый РеквизитФормы(
		"Значение", Новый ОписаниеТипов(), ИмяТаблицыНастроек));
	ДобавляемыеРеквизиты.Добавить(Новый РеквизитФормы(
		"Версия", ОписаниеТипаСтрока, ИмяТаблицыНастроек));
	ДобавляемыеРеквизиты.Добавить(Новый РеквизитФормы(
		"ОшибкаВФормуле", Новый ОписаниеТипов("Булево"), ИмяТаблицыНастроек));
	ИзменитьРеквизиты(ДобавляемыеРеквизиты);
	
	Страница = Элементы.Добавить("Страница" + Раздел.Имя, Тип("ГруппаФормы"), Элементы.ГруппаСтраницы);
	Страница.Вид = ВидГруппыФормы.Страница;
	Страница.Заголовок = Раздел.Представление;
	Страница.Группировка = ГруппировкаПодчиненныхЭлементовФормы.Вертикальная;
	
	Страница.РасширеннаяПодсказка.Заголовок = СтроковыеФункции.ФорматированнаяСтрока(
		НСтр("ru = 'Указанные поля будут добавлены в поле <span style=""font:НаклонныйШрифтБЭД"">%1</span>'"),
		Раздел.ПутьКЭлементуXML);
	Страница.РасширеннаяПодсказка.АвтоМаксимальнаяШирина = Ложь;
	Страница.ОтображениеПодсказки = ОтображениеПодсказки.ОтображатьСверху;
	Страница.ПутьКДаннымЗаголовка = "КоличествоСтрок" + ИмяТаблицыНастроек;
	
	ТаблицаНастроек = Элементы.Добавить(ИмяТаблицыНастроек, Тип("ТаблицаФормы"), Страница);
	ТаблицаНастроек.ПутьКДанным = ИмяТаблицыНастроек;
	ТаблицаНастроек.УстановитьДействие("ПриНачалеРедактирования", "Подключаемый_ТаблицаНастроекПриНачалеРедактирования");
	ТаблицаНастроек.УстановитьДействие("ПриОкончанииРедактирования", "Подключаемый_ТаблицаНастроекПриОкончанииРедактирования");
	ТаблицаНастроек.УстановитьДействие("ПослеУдаления", "Подключаемый_ТаблицаНастроекПослеУдаления");
	
	КолонкаТаблицы = Элементы.Добавить(ИмяТаблицыНастроек + "Имя", Тип("ПолеФормы"), ТаблицаНастроек);
	КолонкаТаблицы.Вид = ВидПоляФормы.ПолеВвода;
	КолонкаТаблицы.ПутьКДанным = ИмяТаблицыНастроек + ".Имя";
	КолонкаТаблицы.АвтоОтметкаНезаполненного = Истина;
	КолонкаТаблицы.Подсказка = НСтр("ru = 'Под этим именем дополнительное поле попадет в электронный документ'");
	
	КолонкаТаблицы = Элементы.Добавить(ИмяТаблицыНастроек + "Правило", Тип("ПолеФормы"), ТаблицаНастроек);
	КолонкаТаблицы.Вид = ВидПоляФормы.ПолеВвода;
	КолонкаТаблицы.ПутьКДанным = ИмяТаблицыНастроек + ".Правило";
	КолонкаТаблицы.АвтоОтметкаНезаполненного = Истина;
	КолонкаТаблицы.КнопкаВыпадающегоСписка = Истина;
	КолонкаТаблицы.РедактированиеТекста = Ложь;
	КолонкаТаблицы.УстановитьДействие("ОбработкаВыбора", "Подключаемый_ПравилоОбработкаВыбора");
	КолонкаТаблицы.УстановитьДействие("Очистка", "Подключаемый_ПравилоОчистка");
	
	ГруппаКолонок = Элементы.Добавить(ИмяТаблицыНастроек + "НастройкаОтображения", Тип("ГруппаФормы"), ТаблицаНастроек);
	ГруппаКолонок.Вид = ВидГруппыФормы.ГруппаКолонок;
	ГруппаКолонок.Группировка = ГруппировкаКолонок.Вертикальная;
	ГруппаКолонок.Заголовок = НСтр("ru = 'Настройка отображения'");
	ГруппаКолонок.ОтображатьЗаголовок = Истина;
	ГруппаКолонок.ОтображатьВШапке = Истина;
	
	КолонкаТаблицы = Элементы.Добавить(ИмяТаблицыНастроек + "Представление", Тип("ПолеФормы"), ГруппаКолонок);
	КолонкаТаблицы.Вид = ВидПоляФормы.ПолеВвода;
	КолонкаТаблицы.ПутьКДанным = ИмяТаблицыНастроек + ".Представление";
	КолонкаТаблицы.ОтображатьВШапке = Ложь;
	КолонкаТаблицы.ПодсказкаВвода = НСтр("ru = 'Заголовок поля в форме заполнения'");
	
	КолонкаТаблицы = Элементы.Добавить(ИмяТаблицыНастроек + "Описание", Тип("ПолеФормы"), ГруппаКолонок);
	КолонкаТаблицы.Вид = ВидПоляФормы.ПолеВвода;
	КолонкаТаблицы.ПутьКДанным = ИмяТаблицыНастроек + ".Описание";
	КолонкаТаблицы.ОтображатьВШапке = Ложь;
	КолонкаТаблицы.ПодсказкаВвода = НСтр("ru = 'Введите описание поля для вывода подсказки'");
	
КонецПроцедуры

&НаСервере
Процедура УстановитьУсловноеОформлениеРазделаДополнительныхПолей(Раздел)
	
	ЭлементОформления = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = ЭлементОформления.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Раздел.ИмяТаблицыНастроек + "Представление");
	
	ОтборЭлемента = ЭлементОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных(Раздел.ИмяТаблицыНастроек + ".Представление");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.НеЗаполнено;
	
	ЭлементОформления.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru = 'Заголовок поля в форме заполнения'"));
	ЭлементОформления.Оформление.УстановитьЗначениеПараметра("ЦветТекста", WebЦвета.СветлоСерый);
	
	ЭлементОформления = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = ЭлементОформления.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Раздел.ИмяТаблицыНастроек + "Описание");
	
	ОтборЭлемента = ЭлементОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных(Раздел.ИмяТаблицыНастроек + ".Описание");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.НеЗаполнено;
	
	ЭлементОформления.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru = 'Введите описание поля для вывода подсказки'"));
	ЭлементОформления.Оформление.УстановитьЗначениеПараметра("ЦветТекста", WebЦвета.СветлоСерый);
	
	ЭлементОформления = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = ЭлементОформления.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Раздел.ИмяТаблицыНастроек + "Правило");
	
	ОтборЭлемента = ЭлементОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных(Раздел.ИмяТаблицыНастроек + ".ОшибкаВФормуле");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Истина;
	
	ЭлементОформления.Оформление.УстановитьЗначениеПараметра("ЦветТекста", WebЦвета.Красный);
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСписокВыбораПравилЗаполнения(Раздел)
	
	СписокВыбора = Элементы[Раздел.ИмяТаблицыНастроек + "Правило"].СписокВыбора;
	
	Для Каждого Вариант Из ВариантыПравилЗаполнения Цикл
		ЗаполнитьЗначенияСвойств(СписокВыбора.Добавить(), Вариант);
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ПрочитатьНастройкиЗаполненияПолей()
	
	ТекстОшибки = Неопределено;
	
	КлючНастроек = НастройкиЭДОКлиентСервер.НовыйКлючНастроекОтправки();
	КлючНастроек.Отправитель = Организация;
	КлючНастроек.Получатель = Контрагент;
	КлючНастроек.Договор = ДоговорКонтрагента;
	КлючНастроек.ВидДокумента = ВидЭлектронногоДокумента;
	НастройкаЗаполнения = НастройкиОтправкиЭДО.НастройкаЗаполненияДополнительныхПолей(
		КлючНастроек, Формат, ТекстОшибки);
	
	Если НастройкаЗаполнения = Неопределено Тогда
		Если ЗначениеЗаполнено(ТекстОшибки) Тогда
			ОбщегоНазначения.СообщитьПользователю(ТекстОшибки);
		КонецЕсли;
		Возврат;
	КонецЕсли;
	
	ЗаполнитьТаблицыНастроекПоРазделам(НастройкаЗаполнения);
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьТаблицыНастроекПоРазделам(НастройкаЗаполнения)
	
	Для Каждого Раздел Из РазделыДополнительныхПолей Цикл
		
		ТаблицаНастроек = ЭтотОбъект[Раздел.ИмяТаблицыНастроек];
		ТаблицаНастроек.Очистить();
		
		МассивНастроек = НастройкаЗаполнения.НайтиСтроки(Новый Структура("Раздел", Раздел.Имя));
		Для Каждого НастройкаПоля Из МассивНастроек Цикл
			Если НастройкаПоля.Заполнение = "ИзСписка"
				И ТипЗнч(НастройкаПоля.Значение) = Тип("Массив") Тогда
				НастройкаПоля.Значение = Новый ФиксированныйМассив(НастройкаПоля.Значение);
			КонецЕсли;
			ЗаполнитьЗначенияСвойств(ТаблицаНастроек.Добавить(), НастройкаПоля);
		КонецЦикла;
		
		ЭтотОбъект["КоличествоСтрок" + Раздел.ИмяТаблицыНастроек] = ТаблицаНастроек.Количество();
		
		ПроверитьКорректностьЗаполненияФормул(Раздел);
		
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ПроверитьКорректностьЗаполненияФормул(Раздел)
	
	ТаблицаНастроек = ЭтотОбъект[Раздел.ИмяТаблицыНастроек];
	НастройкиПоФормуле = ТаблицаНастроек.НайтиСтроки(Новый Структура("Заполнение", "ПоФормуле"));
	Если НастройкиПоФормуле.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	Если ПустаяСтрока(Раздел.АдресЗапросаКонструктораФормул) Тогда
		Раздел.АдресЗапросаКонструктораФормул = ЗапросКонструктораФормул(
			ВидЭлектронногоДокумента, Формат, Раздел.Тип, УникальныйИдентификатор);
	КонецЕсли;
	
	ТекстЗапроса = ПолучитьИзВременногоХранилища(Раздел.АдресЗапросаКонструктораФормул);
	Если Не ЗначениеЗаполнено(ТекстЗапроса) Тогда
		Возврат;
	КонецЕсли;
	
	КомпоновщикНастроек = Новый КомпоновщикНастроекКомпоновкиДанных;
	
	СхемаКомпоновкиДанных = Новый СхемаКомпоновкиДанных;
	
	Источник = СхемаКомпоновкиДанных.ИсточникиДанных.Добавить();
	Источник.Имя = "Источник";
	Источник.ТипИсточникаДанных = "Local";
	
	Набор = СхемаКомпоновкиДанных.НаборыДанных.Добавить(Тип("НаборДанныхЗапросСхемыКомпоновкиДанных"));
	Набор.Имя = Источник.Имя;
	Набор.ИсточникДанных = Источник.Имя;
	Набор.АвтоЗаполнениеДоступныхПолей = Истина;
	Набор.Запрос = ТекстЗапроса;
	
	КомпоновщикНастроек.Инициализировать(Новый ИсточникДоступныхНастроекКомпоновкиДанных(СхемаКомпоновкиДанных));
	
	Для Каждого НастройкаПоля Из НастройкиПоФормуле Цикл
		
		Результат = ОбщегоНазначенияБЭД.ПроверитьФормулу(
			СокрЛП(НастройкаПоля.Значение), КомпоновщикНастроек.Настройки.ДоступныеПоляОтбора);
		
		НастройкаПоля.ОшибкаВФормуле = Не Результат;
		
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьКоличествоСтрокТаблицыНастроек(ТаблицаФормы)
	
	ЭтотОбъект["КоличествоСтрок" + ТаблицаФормы.Имя] = ЭтотОбъект[ТаблицаФормы.Имя].Количество();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработатьВыборПравилЗаполнения(ВыбранноеЗначение, ТекущиеДанные, ИмяТаблицы)
	
	Если ВыбранноеЗначение = "ВручнуюСтрокой" Тогда
		УстановитьВариантВручнуюСтрокой(ВыбранноеЗначение, ТекущиеДанные);
		
	ИначеЕсли ВыбранноеЗначение = "ВручнуюДатой" Тогда
		УстановитьВариантВручнуюДатой(ВыбранноеЗначение, ТекущиеДанные);
		
	ИначеЕсли ВыбранноеЗначение = "ВручнуюЧислом" Тогда
		УстановитьВариантВручнуюЧислом(ВыбранноеЗначение, ТекущиеДанные);
		
	ИначеЕсли ВыбранноеЗначение = "ИзСписка" Тогда
		УстановитьВариантИзСписка(ВыбранноеЗначение, ТекущиеДанные);
		
	ИначеЕсли ВыбранноеЗначение = "ПоФормуле" Тогда
		УстановитьВариантПоФормуле(ВыбранноеЗначение, ТекущиеДанные, ИмяТаблицы);
	
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьВариантВручнуюСтрокой(ВыбранноеЗначение, ТекущиеДанные)
	
	Если ТекущиеДанные.Заполнение <> ВыбранноеЗначение Тогда
		Модифицированность = Истина;
	КонецЕсли;
	
	ТекущиеДанные.Правило = ВариантыПравилЗаполнения.НайтиПоЗначению(ВыбранноеЗначение);
	ТекущиеДанные.Заполнение = ВыбранноеЗначение;
	ТекущиеДанные.Значение = "";
	
	ИзменитьВидимостьИнформацииОЗаполненииПолей(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьВариантВручнуюДатой(ВыбранноеЗначение, ТекущиеДанные)
	
	Контекст = Новый Структура;
	Контекст.Вставить("ВыбранноеЗначение", ВыбранноеЗначение);
	Контекст.Вставить("ТекущиеДанные", ТекущиеДанные);
	
	Конструктор = Новый КонструкторФорматнойСтроки;
	Конструктор.ДоступныеТипы = Новый ОписаниеТипов("Дата");
	Если ТекущиеДанные.Заполнение = "ВручнуюДатой" Тогда
		Конструктор.Текст = ТекущиеДанные.Значение;
	КонецЕсли;
	
	Конструктор.Показать(Новый ОписаниеОповещения("ПослеРедактированияФорматаЗначения", ЭтотОбъект, Контекст));
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьВариантВручнуюЧислом(ВыбранноеЗначение, ТекущиеДанные)
	
	Контекст = Новый Структура;
	Контекст.Вставить("ВыбранноеЗначение", ВыбранноеЗначение);
	Контекст.Вставить("ТекущиеДанные", ТекущиеДанные);
	
	Конструктор = Новый КонструкторФорматнойСтроки;
	Конструктор.ДоступныеТипы = Новый ОписаниеТипов("Число");
	Если ТекущиеДанные.Заполнение = "ВручнуюЧислом" Тогда
		Конструктор.Текст = ТекущиеДанные.Значение;
	КонецЕсли;
	
	Конструктор.Показать(Новый ОписаниеОповещения("ПослеРедактированияФорматаЗначения", ЭтотОбъект, Контекст));
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьВариантИзСписка(ВыбранноеЗначение, ТекущиеДанные)
	
	Контекст = Новый Структура;
	Контекст.Вставить("ВыбранноеЗначение", ВыбранноеЗначение);
	Контекст.Вставить("ТекущиеДанные", ТекущиеДанные);
	
	Оповещение = Новый ОписаниеОповещения("ПослеРедактированияСпискаЗначений", ЭтотОбъект, Контекст);
	
	ПараметрыФормы = Неопределено;
	Если ТекущиеДанные.Заполнение = "ИзСписка"
		И ЗначениеЗаполнено(ТекущиеДанные.Значение) Тогда
		ПараметрыФормы = Новый Структура("ВариантыЗаполнения", ТекущиеДанные.Значение);
	КонецЕсли;
	
	ОткрытьФорму("Обработка.НастройкиОтправкиЭДО.Форма.СписокВариантовЗаполненияДополнительногоПоля",
		ПараметрыФормы, ЭтотОбъект,,,,Оповещение);
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьВариантПоФормуле(ВыбранноеЗначение, ТекущиеДанные, ИмяТаблицы)
	
	Контекст = Новый Структура;
	Контекст.Вставить("ВыбранноеЗначение", ВыбранноеЗначение);
	Контекст.Вставить("ТекущиеДанные", ТекущиеДанные);
	
	Оповещение = Новый ОписаниеОповещения("ПослеРедактированияФормулы", ЭтотОбъект, Контекст);
	
	ПараметрыОтбора = Новый Структура("ИмяТаблицыНастроек", ИмяТаблицы);
	Разделы = РазделыДополнительныхПолей.НайтиСтроки(ПараметрыОтбора);
	Если Разделы.Количество() Тогда
		Раздел = Разделы[0];
	Иначе
		Возврат;
	КонецЕсли;
	
	Если ПустаяСтрока(Раздел.АдресЗапросаКонструктораФормул) Тогда
		Раздел.АдресЗапросаКонструктораФормул = ЗапросКонструктораФормул(
			ВидЭлектронногоДокумента, Формат, Раздел.Тип, УникальныйИдентификатор);
	КонецЕсли;
	
	ПараметрыКонструктора = ОбщегоНазначенияБЭДКлиент.НовыеПараметрыКонструктораФормул();
	ПараметрыКонструктора.АдресНабораОперандов = Раздел.АдресЗапросаКонструктораФормул;
	Если ТекущиеДанные.Заполнение = "ПоФормуле"
		И ЗначениеЗаполнено(ТекущиеДанные.Значение) Тогда
		ПараметрыКонструктора.Формула = ТекущиеДанные.Значение;
	КонецЕсли;
	
	ОбщегоНазначенияБЭДКлиент.ОткрытьКонструкторФормул(ПараметрыКонструктора, Оповещение, ЭтотОбъект);
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ЗапросКонструктораФормул(Знач ВидЭлектронногоДокумента, Знач Формат, Знач ТипРаздела, Знач УникальныйИдентификатор)
	
	Результат = Неопределено;
	
	ТекстЗапроса = ЭлектронныеДокументыЭДО.ЗапросКонструктораДополнительныхПолей(ВидЭлектронногоДокумента, Формат, ТипРаздела);
	Если Не ЗначениеЗаполнено(ТекстЗапроса) Тогда
		Возврат Результат;
	КонецЕсли;
	
	ОчиститьПараметрыВТекстеЗапроса(ТекстЗапроса);
	
	Результат = ПоместитьВоВременноеХранилище(ТекстЗапроса, УникальныйИдентификатор);
	
	Возврат Результат;
	
КонецФункции

&НаСервереБезКонтекста
Процедура ОчиститьПараметрыВТекстеЗапроса(ТекстЗапроса)
	
	Запрос = Новый Запрос(ТекстЗапроса);
	ПараметрыЗапроса = Запрос.НайтиПараметры();
	Для Каждого Параметр Из ПараметрыЗапроса Цикл
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "&" + Параметр.Имя, """""");
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеРедактированияФорматаЗначения(Текст, Контекст) Экспорт
	
	Если Текст = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ТекущиеДанные = Контекст.ТекущиеДанные;
	
	Если ТекущиеДанные.Заполнение <> Контекст.ВыбранноеЗначение
		ИЛИ ТекущиеДанные.Значение <> Текст Тогда
		Модифицированность = Истина;
		ТекущиеДанные.Идентификатор = НовыйИдентификаторНастройкиПоля();
	КонецЕсли;
	
	ПредставлениеВарианта = ВариантыПравилЗаполнения.НайтиПоЗначению(Контекст.ВыбранноеЗначение);
	Если ПустаяСтрока(Текст) Тогда
		Правило = ПредставлениеВарианта;
	Иначе
		Правило = СтрШаблон(НСтр("ru = '%1 в формате: %2'"), ПредставлениеВарианта, Текст);
	КонецЕсли;
	
	ТекущиеДанные.Правило = Правило;
	ТекущиеДанные.Заполнение = Контекст.ВыбранноеЗначение;
	ТекущиеДанные.Значение = Текст;
	
	ИзменитьВидимостьИнформацииОЗаполненииПолей(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеРедактированияСпискаЗначений(Результат, Контекст) Экспорт
	
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Модифицированность = Истина;
	
	ТекущиеДанные = Контекст.ТекущиеДанные;
	ТекущиеДанные.Идентификатор = НовыйИдентификаторНастройкиПоля();
	
	ПредставлениеВарианта = ВариантыПравилЗаполнения.НайтиПоЗначению(Контекст.ВыбранноеЗначение);
	ТекущиеДанные.Правило = СтрШаблон(НСтр("ru = '%1: %2'"),
		ПредставлениеВарианта, Результат.Представление);
	ТекущиеДанные.Заполнение = Контекст.ВыбранноеЗначение;
	ТекущиеДанные.Значение = Результат.Значение;
	
	ИзменитьВидимостьИнформацииОЗаполненииПолей(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеРедактированияФормулы(Результат, Контекст) Экспорт
	
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ТекущиеДанные = Контекст.ТекущиеДанные;
	
	Если ТекущиеДанные.Заполнение <> Контекст.ВыбранноеЗначение
		ИЛИ ТекущиеДанные.Значение <> Результат Тогда
		Модифицированность = Истина;
		ТекущиеДанные.Идентификатор = НовыйИдентификаторНастройкиПоля();
		Если Не ЗначениеЗаполнено(ТекущиеДанные.Значение) Тогда
			ТекущиеДанные.Версия = НастройкиЭДОКлиентСервер.ВерсияНастроекДополнительныхПолейПоФормуле();
		КонецЕсли;
	КонецЕсли;
	
	ТекущиеДанные.Правило = ВариантыПравилЗаполнения.НайтиПоЗначению(Контекст.ВыбранноеЗначение);
	ТекущиеДанные.Заполнение = Контекст.ВыбранноеЗначение;
	ТекущиеДанные.Значение = Результат;
	ТекущиеДанные.ОшибкаВФормуле = Ложь;
	
	ИзменитьВидимостьИнформацииОЗаполненииПолей(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ИзменитьВидимостьИнформацииОЗаполненииПолей(Форма)
	
	Элементы = Форма.Элементы;
	
	ОтображатьИнформацию = Ложь;
	
	Для Каждого Раздел Из Форма.РазделыДополнительныхПолей Цикл
		
		Если ТребуетсяЗаполнениеПолейВручную(Форма, Раздел.ИмяТаблицыНастроек) Тогда
			ОтображатьИнформацию = Истина;
		КонецЕсли;
		
	КонецЦикла;
	
	Элементы.КартинкаИнформация.Видимость = ОтображатьИнформацию;
	Элементы.НадписьИнформация.Видимость = ОтображатьИнформацию;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция ТребуетсяЗаполнениеПолейВручную(Форма, ИмяТаблицыНастроек)
	
	Результат = Ложь;
	
	ТаблицаНастроек = Форма[ИмяТаблицыНастроек];
	КоличествоСтрок = ТаблицаНастроек.Количество();
	Если КоличествоСтрок > 0
		И ТаблицаНастроек.НайтиСтроки(Новый Структура("Заполнение", "ПоФормуле")).Количество() <> КоличествоСтрок Тогда
		Результат = Истина;
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

&НаКлиенте
Процедура ПроверитьЗаполнениеОбязательныхПолей(Отказ)
	
	ШаблонСообщения = НСтр("ru = 'Не заполнена колонка ""%1"" в строке %2 списка ""%3""'");
	Для Каждого Раздел Из РазделыДополнительныхПолей Цикл
		
		ПредставлениеСписка = Раздел.Представление;
		ТаблицаНастроек = ЭтотОбъект[Раздел.ИмяТаблицыНастроек];
		НомерСтроки = 1;
		
		Для Каждого СтрокаТаблицы Из ТаблицаНастроек Цикл
			
			Если Не ЗначениеЗаполнено(СтрокаТаблицы.Имя) Тогда
				ТекстСообщения = СтрШаблон(ШаблонСообщения, НСтр("ru = 'Имя поля'"), НомерСтроки, ПредставлениеСписка);
				Поле = ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти(Раздел.ИмяТаблицыНастроек, НомерСтроки, "Имя");
				ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения,,Поле,,Отказ);
			КонецЕсли;
			
			Если Не ЗначениеЗаполнено(СтрокаТаблицы.Правило) Тогда
				ТекстСообщения = СтрШаблон(ШаблонСообщения, НСтр("ru = 'Правила заполнения'"), НомерСтроки, ПредставлениеСписка);
				Поле = ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти(Раздел.ИмяТаблицыНастроек, НомерСтроки, "Правило");
				ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения,,Поле,,Отказ);
			КонецЕсли;
			
			Если СтрокаТаблицы.Заполнение = "ПоФормуле"
				И СтрокаТаблицы.ОшибкаВФормуле Тогда
				ТекстСообщения = СтрШаблон(НСтр("ru = 'Некорректно заполнена формула в строке %1 списка ""%2""'"),
					НомерСтроки, ПредставлениеСписка);
				Поле = ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти(Раздел.ИмяТаблицыНастроек, НомерСтроки, "Правило");
				ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения,,Поле,,Отказ);
			КонецЕсли;
			
			НомерСтроки = НомерСтроки + 1;
		КонецЦикла;
		
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ПроверитьКорректностьИменПолей(Отказ)
	
	Для Каждого Раздел Из РазделыДополнительныхПолей Цикл
		
		ПредставлениеСписка = Раздел.Представление;
		ТаблицаНастроек = ЭтотОбъект[Раздел.ИмяТаблицыНастроек];
		НомерСтроки = 1;
		
		ШаблонСообщения = НСтр("ru = 'Имя поля совпадает со служебным в строке %1 списка ""%2""'");
		Для Каждого СтрокаТаблицы Из ТаблицаНастроек Цикл
			Если ЭлектронныеДокументыЭДО.ЭтоСлужебноеИмяДополнительногоПоля(СтрокаТаблицы.Имя, Формат) Тогда
				ТекстСообщения = СтрШаблон(ШаблонСообщения, НомерСтроки, ПредставлениеСписка);
				Поле = ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти(Раздел.ИмяТаблицыНастроек, НомерСтроки, "Имя");
				ОбщегоНазначения.СообщитьПользователю(ТекстСообщения,,Поле,,Отказ);
			КонецЕсли;
			
			НомерСтроки = НомерСтроки + 1;
		КонецЦикла;
		
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Функция НастройкаЗаполненияДополнительныхПолейДокумента()
	
	НастройкиПолей = Новый Массив;
	
	Для Каждого Раздел Из РазделыДополнительныхПолей Цикл
		
		ТаблицаНастроек = ЭтотОбъект[Раздел.ИмяТаблицыНастроек];
		Если ТаблицаНастроек.Количество() = 0 Тогда
			Продолжить;
		КонецЕсли;
		
		Для Каждого СтрокаТаблицы Из ТаблицаНастроек Цикл
			
			НастройкаПоля = Новый Структура;
			НастройкаПоля.Вставить("Идентификатор", СтрокаТаблицы.Идентификатор);
			НастройкаПоля.Вставить("Имя",           СтрокаТаблицы.Имя);
			НастройкаПоля.Вставить("Представление", СтрокаТаблицы.Представление);
			НастройкаПоля.Вставить("Описание",      СтрокаТаблицы.Описание);
			НастройкаПоля.Вставить("Правило",       СтрокаТаблицы.Правило);
			НастройкаПоля.Вставить("Заполнение",    СтрокаТаблицы.Заполнение);
			НастройкаПоля.Вставить("Значение",      СтрокаТаблицы.Значение);
			Если ЗначениеЗаполнено(СтрокаТаблицы.Версия) Тогда
				НастройкаПоля.Вставить("Версия", СтрокаТаблицы.Версия);
			КонецЕсли;
			НастройкаПоля.Вставить("Раздел",        Раздел.Имя);
			
			НастройкиПолей.Добавить(НастройкаПоля);
			
		КонецЦикла;
		
	КонецЦикла;
	
	Возврат НастройкиПолей;
	
КонецФункции

&НаСервере
Процедура СохранитьНастройкуЗаполненияПолей(Отказ)
	
	ПроверитьКорректностьИменПолей(Отказ);
	
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	НастройкаЗаполнения = НастройкаЗаполненияДополнительныхПолейДокумента();
	
	Если Не ЗначениеЗаполнено(НастройкаЗаполнения) Тогда
		Возврат;
	КонецЕсли;
	
	НастройкаЗаполненияJSON = ОбщегоНазначенияБЭД.JSONСтрока(НастройкаЗаполнения);
	
	МенеджерЗаписи = РегистрыСведений.НастройкиЗаполненияДополнительныхПолей.СоздатьМенеджерЗаписи();
	МенеджерЗаписи.Отправитель = Организация;
	МенеджерЗаписи.Получатель  = Контрагент;
	МенеджерЗаписи.Договор     = ДоговорКонтрагента;
	МенеджерЗаписи.ВидЭлектронногоДокумента = ВидЭлектронногоДокумента;
	МенеджерЗаписи.Формат = Формат;
	МенеджерЗаписи.Настройка = Новый ХранилищеЗначения(НастройкаЗаполненияJSON, Новый СжатиеДанных(9));
	МенеджерЗаписи.Записать();
	
КонецПроцедуры

&НаКлиенте
Процедура УдалитьНастройкуПослеВопроса(Результат, Контекст) Экспорт
	
	Если Результат = КодВозвратаДиалога.Да Тогда
		УдалитьНастройкуЗаполненияПолей();
		Закрыть(Ложь);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура УдалитьНастройкуЗаполненияПолей()
	
	РегистрыСведений.НастройкиЗаполненияДополнительныхПолей.УдалитьНастройкуЗаполненияПолей(
		Организация, Контрагент, ДоговорКонтрагента, ВидЭлектронногоДокумента, Формат);
	
КонецПроцедуры

&НаСервере
Функция АдресВыгрузкиНастройкиЗаполненияДопПолей()
	
	НастройкаЗаполнения = НастройкаЗаполненияДополнительныхПолейДокумента();
	
	ПараметрыНастройки = Новый Структура;
	ПараметрыНастройки.Вставить("Формат", Формат);
	ПараметрыНастройки.Вставить("Поля", НастройкаЗаполнения);
	
	ПараметрыЗаписи = Новый ПараметрыЗаписиJSON(, Символы.Таб);
	
	Возврат ПоместитьВоВременноеХранилище(ОбщегоНазначенияБЭД.JSONСтрока(ПараметрыНастройки, ПараметрыЗаписи),
		УникальныйИдентификатор);
	
КонецФункции

&НаКлиенте
Процедура ЗагрузитьДанныеИзФайлаПослеВопроса(Результат, Контекст) Экспорт
	
	Если Результат = КодВозвратаДиалога.Да Тогда
		ЗагрузитьДанныеИзФайла();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьДанныеИзФайла()
	
	Оповещение = Новый ОписаниеОповещения("ЗагрузитьДанныеПослеВыбораВДиалоге", ЭтотОбъект);
	ПараметрыЗагрузки = ФайловаяСистемаКлиент.ПараметрыЗагрузкиФайла();
	ПараметрыЗагрузки.Интерактивно = Истина;
	ПараметрыЗагрузки.Диалог.Заголовок = НСтр("ru = 'Выберите файл для загрузки'");
	ПараметрыЗагрузки.Диалог.МножественныйВыбор = Ложь;
	ПараметрыЗагрузки.Диалог.Фильтр = НСтр("ru = 'Файл json|*.json'");
	ПараметрыЗагрузки.Диалог.Расширение = "json";
	ФайловаяСистемаКлиент.ЗагрузитьФайл(Оповещение, ПараметрыЗагрузки);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьДанныеПослеВыбораВДиалоге(ПомещенныйФайл, ДополнительныеПараметры) Экспорт
	
	Если ПомещенныйФайл <> Неопределено Тогда
		ЗагрузитьДанныеНаСервере(ПомещенныйФайл.Хранение);
	КонецЕсли;

КонецПроцедуры

&НаСервере
Процедура ЗагрузитьДанныеНаСервере(ДанныеФайла)
	
	ДвоичныеДанныеФайла = ПолучитьИзВременногоХранилища(ДанныеФайла);
	
	Попытка
		СтруктураДанных = ОбщегоНазначенияБЭД	.JSONЗначение(ДвоичныеДанныеФайла);
	Исключение
		ОбщегоНазначенияБЭД.ЗаписатьВЖурналРегистрации(ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()),
			ОбщегоНазначенияБЭДКлиентСервер.ПодсистемыБЭД().ОбменСКонтрагентами);
	КонецПопытки;
	
	Если СтруктураДанныхФайлаНекорректна(СтруктураДанных) Тогда
		Возврат;
	КонецЕсли;
	
	НастройкаЗаполнения = НастройкиОтправкиЭДОСлужебный.НоваяНастройкаЗаполненияДополнительныхПолей(СтруктураДанных.Поля);
	
	ЗаполнитьТаблицыНастроекПоРазделам(НастройкаЗаполнения);
	
	ИзменитьВидимостьИнформацииОЗаполненииПолей(ЭтотОбъект);
	
	Модифицированность = Истина;
	
КонецПроцедуры

&НаКлиенте
Функция НовыйИдентификаторНастройкиПоля()
	
	Возврат "f" + СтрЗаменить(Новый УникальныйИдентификатор, "-", "");
	
КонецФункции

&НаСервере
Функция СтруктураДанныхФайлаНекорректна(СтруктураДанных)
	
	Если Не ЗначениеЗаполнено(СтруктураДанных)
		ИЛИ Не СтруктураДанных.Свойство("Поля") Тогда
		СообщитьОбОшибкеЧтенияНастройкиИзФайла();
		Возврат Истина;
	КонецЕсли;
	
	СопоставлениеРазделов = Новый Соответствие;
	
	Для Каждого Раздел Из РазделыДополнительныхПолей Цикл
		СопоставлениеРазделов.Вставить(Раздел.Имя, Истина);
	КонецЦикла;
	
	ЕстьСопоставленныеРазделы = Ложь;
	НезагруженныеНастройкиПолей = Новый Массив;
	
	Для Каждого НастройкаПоля Из СтруктураДанных.Поля Цикл
		ИмяРаздела = Неопределено;
		Если Не НастройкаПоля.Свойство("Раздел", ИмяРаздела)
			ИЛИ Не ЗначениеЗаполнено(ИмяРаздела) Тогда
			Продолжить;
		КонецЕсли;
		
		Если СопоставлениеРазделов[ИмяРаздела] <> Неопределено Тогда
			ЕстьСопоставленныеРазделы = Истина;
		ИначеЕсли НастройкаПоля.Свойство("Имя")
			И ЗначениеЗаполнено(НастройкаПоля.Имя) Тогда
			НезагруженныеНастройкиПолей.Добавить(НастройкаПоля.Имя);
		КонецЕсли;
	КонецЦикла;
	
	Если Не ЕстьСопоставленныеРазделы Тогда
		СообщитьОбОшибкеЧтенияНастройкиИзФайла();
		Возврат Истина;
	КонецЕсли;
	
	Если НезагруженныеНастройкиПолей.Количество() Тогда
		ТекстСообщения = СтрШаблон(НСтр("ru = 'Не удалось загрузить настройки по следующим полям: %1.'"),
			СтрСоединить(НезагруженныеНастройкиПолей, ", "));
		ОбщегоНазначения.СообщитьПользователю(ТекстСообщения);
	КонецЕсли;
	
	Возврат Ложь;
	
КонецФункции

&НаСервере
Процедура СообщитьОбОшибкеЧтенияНастройкиИзФайла()
	
	ТекстСообщения = НСтр("ru = 'Ошибка при чтении файла настроек заполнения дополнительных полей.
		|Неизвестный формат файла.'");
	ОбщегоНазначения.СообщитьПользователю(ТекстСообщения);
	
КонецПроцедуры

#КонецОбласти