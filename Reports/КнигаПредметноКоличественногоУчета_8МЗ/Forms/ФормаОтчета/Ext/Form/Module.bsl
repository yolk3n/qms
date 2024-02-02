﻿
////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	Отчет.Период = КонецГода(ТекущаяДатаСеанса());
	ПериодСтрокой = Формат(Отчет.Период, "ДФ=yyyy");
	
	ОтчетыБольничнаяАптека.ПриСозданииНаСервере(ЭтотОбъект, Отказ, СтандартнаяОбработка);
	
	// ТехнологияСервиса.ИнформационныйЦент
	ИнформационныйЦентрСервер.ВывестиКонтекстныеСсылки(ЭтотОбъект, Элементы.ИнформационныеСсылки);
	// Конец ТехнологияСервиса.ИнформационныйЦент
	
	УстановитьВидимостьЭлементовФормы(Отказ, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ОтчетыБольничнаяАптекаКлиент.ПриОткрытии(ЭтотОбъект, Отказ);
	
КонецПроцедуры

&НаСервере
Процедура ПриЗагрузкеПользовательскихНастроекНаСервере(Настройки)
	
	ОтчетыБольничнаяАптека.ПриЗагрузкеПользовательскихНастроекНаСервере(ЭтотОбъект, Настройки);
	
	ПериодСтрокой = Формат(Отчет.Период, "ДФ=yyyy");
	
	УстановитьСостояниеОтображенияНеактуальность(Элементы.Результат, ИдентификаторЗадания);
	
КонецПроцедуры

&НаСервере
Процедура ПриСохраненииПользовательскихНастроекНаСервере(Настройки)
	
	ОтчетыБольничнаяАптека.ПриСохраненииПользовательскихНастроекНаСервере(ЭтотОбъект, Настройки);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ОтчетыБольничнаяАптекаКлиент.ОбработатьСобытиеЗаписиМакета(ЭтотОбъект, ИмяСобытия, Параметр, Источник) Тогда
		УстановитьСостояниеОтображенияНеактуальность(Элементы.Результат, ИдентификаторЗадания);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	Если Не ВыводитьЗаголовок И Не Отчет.ВыводитьПриход И Не Отчет.ВыводитьРасход Тогда
		ТекстСообщения = НСтр("ru = 'Необходимо указать выводимые области.'");
		ОбщегоНазначения.СообщитьПользователю(ТекстСообщения,, "Отчет.ВыводитьПриход",, Отказ);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	ОтчетыБольничнаяАптекаКлиент.ПередЗакрытием(ЭтотОбъект, Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка);
	
КонецПроцедуры

#КонецОбласти // ОбработчикиСобытийФормы

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНДЫ ФОРМЫ
#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура СформироватьОтчет(Команда)
	
	Сформировать();
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказатьНастройки(Команда)
	
	ПодключитьОбработчикОжидания("Подключаемый_ОткрытьНастройки", 0.1, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗакрытьНастройки(Команда)
	
	ПодключитьОбработчикОжидания("Подключаемый_ЗакрытьНастройки", 0.1, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьСтандартныеНастройки(Команда)
	
	УстановитьСтандартныеНастройкиНаСервере();
	УстановитьСостояниеОтображенияНеактуальность(Элементы.Результат, ИдентификаторЗадания);
	
КонецПроцедуры

&НаКлиенте
Процедура ГруппировкаСнятьФлажки(Команда)
	
	Для Каждого СтрокаТаблицы Из Отчет.Группировка Цикл
		СтрокаТаблицы.Использование = Ложь;
	КонецЦикла;
	
	УстановитьСостояниеОтображенияНеактуальность(Элементы.Результат, ИдентификаторЗадания);
	
КонецПроцедуры

&НаКлиенте
Процедура ГруппировкаУстановитьФлажки(Команда)
	
	Для Каждого СтрокаТаблицы Из Отчет.Группировка Цикл
		СтрокаТаблицы.Использование = Истина;
	КонецЦикла;
	
	УстановитьСостояниеОтображенияНеактуальность(Элементы.Результат, ИдентификаторЗадания);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтправитьПоЭлектроннойПочте(Команда)
	
	ОтображениеСостояния = Элементы.Результат.ОтображениеСостояния;
	Если ОтображениеСостояния.Видимость И ОтображениеСостояния.ДополнительныйРежимОтображения = ДополнительныйРежимОтображения.Неактуальность Тогда
		ТекстВопроса = НСтр("ru = 'Отчет не сформирован. Сформировать?'");
		Оповестить = Новый ОписаниеОповещения("ОтправитьПослеФормированияОтчета", ЭтотОбъект);
		ПоказатьВопрос(Оповестить, ТекстВопроса, РежимДиалогаВопрос.ДаНет, 60, КодВозвратаДиалога.Да);
	Иначе
		ПоказатьДиалогОтправкиПоЭлектроннойПочте();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ИзменитьМакет(Команда)
	
	ОтчетыБольничнаяАптекаКлиент.ИзменитьМакет(ЭтотОбъект, МакетыОтчета);
	
КонецПроцедуры

&НаКлиенте
Процедура ПерейтиКУправлениюМакетами(Команда)
	
	ОткрытьФорму("РегистрСведений.ПользовательскиеМакетыПечати.Форма.МакетыПечатныхФорм");
	
КонецПроцедуры

#КонецОбласти // ОбработчикиКомандФормы

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ФОРМЫ
#Область ОбработчикиСобытийЭлементовФормы

////////////////////////////////////////////////////////////////////////////////
// Шапка
#Область Шапка

&НаКлиенте
Процедура ПериодСтрокойРегулирование(Элемент, Направление, СтандартнаяОбработка)
	
	Отчет.Период = КонецГода(ДобавитьМесяц(Отчет.Период, Направление * 12));
	ПериодСтрокой = Формат(Отчет.Период, "ДФ=yyyy");
	
КонецПроцедуры

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	
	УстановитьСостояниеОтображенияНеактуальность(Элементы.Результат, ИдентификаторЗадания);
	ОтчетыБольничнаяАптекаКлиентСервер.ПриИзмененииРеквизитаОтчета(ЭтотОбъект, "Организация");
	
КонецПроцедуры

#КонецОбласти // Шапка

////////////////////////////////////////////////////////////////////////////////
// Табличный документ (Результат)
#Область ТабличныйДокументРезультат

&НаКлиенте
Процедура РезультатОбработкаРасшифровки(Элемент, Расшифровка, СтандартнаяОбработка)
	
	ОтчетыБольничнаяАптекаКлиент.ОбработатьРасшифровкуОтчета(ЭтотОбъект, Элемент, Расшифровка, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура РезультатОбработкаДополнительнойРасшифровки(Элемент, Расшифровка, СтандартнаяОбработка)
	
	// Не будем обрабатывать нажатие на правую кнопку мыши.
	// Покажем стандартное контекстное меню ячейки табличного документа.
	Расшифровка = Неопределено;
	
КонецПроцедуры

#КонецОбласти

////////////////////////////////////////////////////////////////////////////////
// Группировка
#Область Группировка

&НаКлиенте
Процедура ГруппировкаПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	
	ИсключаемыеПоля = ПолучитьИсключаемыеПоля("Группировка");
	ОтчетыБольничнаяАптекаКлиент.ГруппировкаПередНачаломДобавления(ЭтотОбъект, Элемент, ИсключаемыеПоля, Отказ, Копирование, Родитель, Группа);
	
КонецПроцедуры

&НаКлиенте
Процедура ГруппировкаПередНачаломИзменения(Элемент, Отказ)
	
	ИсключаемыеПоля = ПолучитьИсключаемыеПоля("Группировка");
	ОтчетыБольничнаяАптекаКлиент.ГруппировкаПередНачаломИзменения(ЭтотОбъект, Элемент, ИсключаемыеПоля, Отказ);
	
КонецПроцедуры

&НаКлиенте
Процедура ГруппировкаПриИзменении(Элемент)
	
	УстановитьСостояниеОтображенияНеактуальность(Элементы.Результат, ИдентификаторЗадания);
	
КонецПроцедуры

#КонецОбласти // Группировка

////////////////////////////////////////////////////////////////////////////////
// Отбор
#Область Отбор

&НаКлиенте
Процедура ПодразделениеОрганизацииПриИзменении(Элемент)
	
	УстановитьСостояниеОтображенияНеактуальность(Элементы.Результат, ИдентификаторЗадания);
	ОтчетыБольничнаяАптекаКлиентСервер.ПриИзмененииРеквизитаОтчета(ЭтотОбъект, "ПодразделениеОрганизации");
	
КонецПроцедуры

&НаКлиенте
Процедура ИсточникФинансированияПриИзменении(Элемент)
	
	УстановитьСостояниеОтображенияНеактуальность(Элементы.Результат, ИдентификаторЗадания);
	ОтчетыБольничнаяАптекаКлиентСервер.ПриИзмененииРеквизитаОтчета(ЭтотОбъект, "ИсточникФинансирования");
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборыПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	
	ИсключаемыеПоля = ПолучитьИсключаемыеПоля("Отбор");
	ОтчетыБольничнаяАптекаКлиент.ОтборыПередНачаломДобавления(ЭтотОбъект, Элемент, ИсключаемыеПоля, Отказ, Копирование, Родитель, Группа);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборыПередНачаломИзменения(Элемент, Отказ)
	
	ИсключаемыеПоля = ПолучитьИсключаемыеПоля("Отбор");
	ОтчетыБольничнаяАптекаКлиент.ОтборыПередНачаломИзменения(ЭтотОбъект, Элемент, ИсключаемыеПоля, Отказ);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборыПриИзменении(Элемент)
	
	Реквизиты = Новый Массив;
	Реквизиты.Добавить("Организация");
	Реквизиты.Добавить("ПодразделениеОрганизации");
	Реквизиты.Добавить("ИсточникФинансирования");
	ОтчетыБольничнаяАптекаКлиентСервер.ПриИзмененииОтбора(ЭтотОбъект, Реквизиты);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборыПриОкончанииРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования)
	
	Реквизиты = Новый Массив;
	Реквизиты.Добавить("Организация");
	Реквизиты.Добавить("ПодразделениеОрганизации");
	Реквизиты.Добавить("ИсточникФинансирования");
	ОтчетыБольничнаяАптекаКлиентСервер.ПриИзмененииОтбора(ЭтотОбъект, Реквизиты);
	
КонецПроцедуры

#КонецОбласти // Отбор

////////////////////////////////////////////////////////////////////////////////
// Порядок
#Область Порядок

&НаКлиенте
Процедура ПорядокПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	
	ИсключаемыеПоля = ПолучитьИсключаемыеПоля("Порядок");
	ОтчетыБольничнаяАптекаКлиент.ПорядокПередНачаломДобавления(ЭтотОбъект, Элемент, ИсключаемыеПоля, Отказ, Копирование, Родитель, Группа);
	
КонецПроцедуры

&НаКлиенте
Процедура ПорядокПередНачаломИзменения(Элемент, Отказ)
	
	ИсключаемыеПоля = ПолучитьИсключаемыеПоля("Порядок");
	ОтчетыБольничнаяАптекаКлиент.ПорядокПередНачаломИзменения(ЭтотОбъект, Элемент, ИсключаемыеПоля, Отказ);
	
КонецПроцедуры

&НаКлиенте
Процедура ПорядокПриИзменении(Элемент)
	
	УстановитьСостояниеОтображенияНеактуальность(Элементы.Результат, ИдентификаторЗадания);
	
КонецПроцедуры

#КонецОбласти // Порядок

////////////////////////////////////////////////////////////////////////////////
// Оформление
#Область Оформление

&НаКлиенте
Процедура УсловноеОформлениеПриИзменении(Элемент)
	
	УстановитьСостояниеОтображенияНеактуальность(Элементы.Результат, ИдентификаторЗадания);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыводитьЗаголовокПриИзменении(Элемент)
	
	УстановитьСостояниеОтображенияНеактуальность(Элементы.Результат, ИдентификаторЗадания);
	
КонецПроцедуры

#КонецОбласти // Оформление

#КонецОбласти // ОбработчикиСобытийЭлементовФормы

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ
#Область СлужебныеПроцедурыИФункции

#Область ФормированиеОтчета

&НаКлиенте
Процедура Сформировать()
	
	ОчиститьСообщения();
	
	Если Не ПроверитьЗаполнение() Тогда
		ПодключитьОбработчикОжидания("Подключаемый_ОткрытьНастройки", 0.1, Истина);
		Возврат;
	КонецЕсли;
	
	ДлительнаяОперация = СформироватьОтчетНаСервере();
	
	ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "ФормированиеОтчета");
	
	ПараметрыОжидания = ДлительныеОперацииКлиент.ПараметрыОжидания(ЭтотОбъект);
	ПараметрыОжидания.ВыводитьОкноОжидания = Ложь;
	Оповещение = Новый ОписаниеОповещения("СформироватьОтчетЗавершение", ЭтотОбъект);
	ДлительныеОперацииКлиент.ОжидатьЗавершение(ДлительнаяОперация, Оповещение, ПараметрыОжидания);
	
	ПодключитьОбработчикОжидания("Подключаемый_ЗакрытьНастройки", 0.1, Истина);
	
КонецПроцедуры

&НаСервере
Функция СформироватьОтчетНаСервере()
	
	ОтменитьВыполнениеЗадания();
	
	ИдентификаторЗадания = Неопределено;
	
	ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеИспользовать");
	
	Отчет.КомпоновщикНастроек.Настройки.ДополнительныеСвойства.Вставить("ВыводитьЗаголовок", ВыводитьЗаголовок);
	Отчет.КомпоновщикНастроек.Настройки.ДополнительныеСвойства.Вставить("ВыводитьПодвал"   , Ложь);
	
	ПараметрыОтчета = ПодготовитьПараметрыОтчета();
	
	ОтчетыБольничнаяАптека.АктуализироватьСебестоимостьТоваровДляОтчетов(Отчет.КомпоновщикНастроек, ПараметрыОтчета);
	
	ПараметрыВыполнения = ДлительныеОперации.ПараметрыВыполненияВФоне(УникальныйИдентификатор);
	ПараметрыВыполнения.НаименованиеФоновогоЗадания = ОбщегоНазначенияБольничнаяАптекаКлиентСервер.ПолучитьНаименованиеЗаданияВыполненияОтчета(ЭтотОбъект);
	
	ДлительнаяОперация = ДлительныеОперации.ВыполнитьВФоне(
		"ОтчетыБольничнаяАптека.СформироватьОтчет", ПараметрыОтчета, ПараметрыВыполнения);
	
	ИдентификаторЗадания = ДлительнаяОперация.ИдентификаторЗадания;
	
	Возврат ДлительнаяОперация;
	
КонецФункции

&НаСервере
Функция ПодготовитьПараметрыОтчета()
	
	ПараметрыОтчета = ОтчетыБольничнаяАптека.ПолучитьОсновныеПараметрыОтчета(ЭтотОбъект);
	ПараметрыОтчета.Вставить("ДатаОкончания", ПараметрыОтчета.Период);
	
	Возврат ПараметрыОтчета;
	
КонецФункции

&НаКлиенте
Процедура СформироватьОтчетЗавершение(РезультатДлительнойОперации, НеИспользуется) Экспорт
	
	ИдентификаторЗадания = Неопределено;
	
	Если ТипЗнч(РезультатДлительнойОперации) = Тип("Структура") Тогда
		Если РезультатДлительнойОперации.Статус = "Выполнено" Тогда
			ЗагрузитьПодготовленныеДанные(РезультатДлительнойОперации.АдресРезультата);
			Если ОтправитьПослеФормирования Тогда
				ПоказатьДиалогОтправкиПоЭлектроннойПочте();
			КонецЕсли;
		Иначе
			ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеИспользовать");
			Если РезультатДлительнойОперации.Статус = "Ошибка" Тогда
				ВызватьИсключение РезультатДлительнойОперации.КраткоеПредставлениеОшибки;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
	ОтправитьПослеФормирования = Ложь;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьПодготовленныеДанные(Знач АдресРезультата)
	
	РезультатВыполнения = ПолучитьИзВременногоХранилища(АдресРезультата);
	
	Если РезультатВыполнения.Свойство("ОписаниеОшибки") Тогда
		ОбщегоНазначенияКлиент.СообщитьПользователю(РезультатВыполнения.ОписаниеОшибки);
	КонецЕсли;
	
	Результат = РезультатВыполнения.Результат;
	
	ИдентификаторЗадания = Неопределено;
	
	ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеИспользовать");
	
	ОтчетыБольничнаяАптекаКлиент.ЗапуститьОжиданиеАктуализацииСебестоимостиТоваров(ЭтотОбъект, Результат);
	
КонецПроцедуры

&НаСервере
Процедура ОтменитьВыполнениеЗадания()
	
	ДлительныеОперации.ОтменитьВыполнениеЗадания(ИдентификаторЗадания);
	
КонецПроцедуры

#КонецОбласти // ФормированиеОтчета

#Область ОтправкаПоПочте

&НаКлиенте
Процедура ОтправитьПослеФормированияОтчета(Ответ, ДополнительныеПараметры) Экспорт
	
	Если Ответ = КодВозвратаДиалога.Да Тогда
		ОтправитьПослеФормирования = Истина;
		Сформировать();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказатьДиалогОтправкиПоЭлектроннойПочте()
	
	ОтчетыБольничнаяАптекаКлиент.ПоказатьДиалогОтправкиПоЭлектроннойПочте(ЭтотОбъект);
	
КонецПроцедуры

#КонецОбласти // ОтправкаПоПочте

#Область Прочее

&НаСервере
Процедура УстановитьВидимостьЭлементовФормы(Отказ, СтандартнаяОбработка)
	
	// Тесная интеграция с почтой.
	ДоступнаОтправкаПисем = Ложь;
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.РаботаСПочтовымиСообщениями") Тогда
		МодульРаботаСПочтовымиСообщениями = ОбщегоНазначения.ОбщийМодуль("РаботаСПочтовымиСообщениями");
		ДоступнаОтправкаПисем = МодульРаботаСПочтовымиСообщениями.ДоступнаОтправкаПисем();
	КонецЕсли;
	Если Не ДоступнаОтправкаПисем Тогда
		Элементы.ОтправитьПоЭлектроннойПочте.Видимость = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОткрытьНастройки()
	
	Элементы.ПрименитьНастройки.КнопкаПоУмолчанию = Истина;
	Элементы.РазделыОтчета.ТекущаяСтраница = Элементы.НастройкиОтчета;
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ЗакрытьНастройки()
	
	Элементы.Сформировать.КнопкаПоУмолчанию = Истина;
	Элементы.РазделыОтчета.ТекущаяСтраница = Элементы.Отчет;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьСтандартныеНастройкиНаСервере()
	
	ОтчетыБольничнаяАптека.УстановитьНастройкиПоУмолчанию(ЭтотОбъект);
	
	Схема = ПолучитьИзВременногоХранилища(СхемаКомпоновкиДанных);
	Отчет.КомпоновщикНастроек.ЗагрузитьНастройки(Схема.НастройкиПоУмолчанию);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьСостояниеОтображенияНеактуальность(ПолеТабличногоДокумента, ИдентификаторЗадания)
	
	Если Не ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(ПолеТабличногоДокумента, "Неактуальность");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Функция ПолучитьИсключаемыеПоля(Режим = "")
	
	СписокПолей = Новый Массив;
	
	СписокПолей.Добавить("UserFields");
	СписокПолей.Добавить("DataParameters");
	СписокПолей.Добавить("SystemFields");
	
	Если Режим = "Группировка" Тогда
		СписокПолей.Добавить("Количество");
	КонецЕсли;
	
	Возврат Новый ФиксированныйМассив(СписокПолей);
	
КонецФункции

#КонецОбласти // Прочее

#КонецОбласти // СлужебныеПроцедурыИФункции

////////////////////////////////////////////////////////////////////////////////
// СТАНДАРТНЫЕ ПОДСИСТЕМЫ
#Область СтандартныеПодсистемы

// ТехнологияСервиса.ИнформационныйЦентр

&НаКлиенте
Процедура Подключаемый_НажатиеНаИнформационнуюСсылку(Элемент)
	
	ИнформационныйЦентрКлиент.НажатиеНаИнформационнуюСсылку(ЭтотОбъект, Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_НажатиеНаСсылкуВсеИнформационныеСсылки(Элемент)
	
	ИнформационныйЦентрКлиент.НажатиеНаСсылкуВсеИнформационныеСсылки(ЭтотОбъект.ИмяФормы);
	
КонецПроцедуры

// Конец ТехнологияСервиса.ИнформационныйЦентр

#КонецОбласти // СтандартныеПодсистемы
