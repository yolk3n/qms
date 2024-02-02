﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2023, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

// Если подсистема "Работа с файлами" не внедрена в конфигурацию,
// то эту форму также необходимо удалить из конфигурации.

#Область ОписаниеПеременных

&НаКлиенте
Перем ОбновитьИнтерфейс;

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	МаксимальныйРазмерФайла = РаботаСФайлами.МаксимальныйРазмерФайлаОбщий() / (1024*1024);
	МаксимальныйРазмерФайлаОбластиДанных = РаботаСФайлами.МаксимальныйРазмерФайла() / (1024*1024);
	
	РазделениеВключено = ОбщегоНазначения.РазделениеВключено();
	Если РазделениеВключено Тогда
		Элементы.МаксимальныйРазмерФайла.МаксимальноеЗначение = МаксимальныйРазмерФайла;
	КонецЕсли;
	
	ЗапрещатьЗагрузкуФайловПоРасширению = НаборКонстант.ЗапрещатьЗагрузкуФайловПоРасширению;
	
	ПараметрыХраненияФайловВИБ = РаботаСФайламиВТомахСлужебный.ПараметрыХраненияФайловВИнформационнойБазе();
	Если ПараметрыХраненияФайловВИБ <> Неопределено Тогда
		РасширенияФайловВИБ = ПараметрыХраненияФайловВИБ.РасширенияФайлов;
		МаксимальныйРазмерФайлаВИБ = ПараметрыХраненияФайловВИБ.МаксимальныйРазмер / (1024*1024);
	КонецЕсли;
	
	РаботаСФайламиСлужебный.ЗаполнитьСписокТипамиФайлов(Элементы.РасширенияФайловВИБ.СписокВыбора);
	
	ЭтоАдминистраторСистемы = Пользователи.ЭтоПолноправныйПользователь(, Истина);
	Элементы.УправлениеХранениемФайлов.Видимость = ЭтоАдминистраторСистемы;
	Элементы.ГруппаУправлениеТомамиФайлов.Видимость = ЭтоАдминистраторСистемы;
	Элементы.ГруппаУправлениеРазмеромФайловВИБ.Видимость = ЭтоАдминистраторСистемы;
	Элементы.ОбщиеПараметрыДляВсехОбластейДанных.Видимость = ЭтоАдминистраторСистемы И РазделениеВключено;
	Элементы.ГруппаСписокРасширенийТекстовыхФайлов.Видимость = Не РазделениеВключено;
	Элементы.ГруппаУправлениеРасширениямиФайловВИБ.Видимость = ЭтоАдминистраторСистемы;
	
	Если ЭтоАдминистраторСистемы Тогда
		ЗначениеСпособаХраненияФайлов = НаборКонстант.СпособХраненияФайлов;
		УстановитьДоступностьНастроекХраненияВТомах();
	КонецЕсли;
	
	// Обновление состояния элементов.
	УстановитьДоступность();
	
	НастройкиПрограммыПереопределяемый.НастройкиРаботыСФайламиПриСозданииНаСервере(ЭтотОбъект);
	
	Если ОбщегоНазначения.ЭтоМобильныйКлиент() Тогда
		
		Элементы.ОтступРазмерФайловВИБ.Видимость = Ложь;
		Элементы.ОтступРасширенияФайловВИБ.Видимость = Ложь;
		Элементы.МаксимальныйРазмерФайлаВИБ.КнопкаРегулирования = Ложь;
		Элементы.РасширенияФайловВИБ.ПоложениеЗаголовка = ПоложениеЗаголовкаЭлементаФормы.Верх;
		Элементы.СписокРасширенийТекстовыхФайлов.ПоложениеЗаголовка = ПоложениеЗаголовкаЭлементаФормы.Верх;
		Элементы.СписокРасширенийФайловOpenDocumentОбластиДанных.ПоложениеЗаголовка = ПоложениеЗаголовкаЭлементаФормы.Верх;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	
	Если Не ЗавершениеРаботы Тогда
		ОбновитьИнтерфейсПрограммы();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура СпособХраненияФайловПриИзменении(Элемент)
	
	Если НаборКонстант.СпособХраненияФайлов = ЗначениеСпособаХраненияФайлов Тогда
		Возврат;
	КонецЕсли;
	
	НаборКонстант.ХранитьФайлыВТомахНаДиске = НаборКонстант.СпособХраненияФайлов <> "ВИнформационнойБазе";
	
	ОбработкаОповещения = Новый ОписаниеОповещения(
		"СпособХраненияФайловПриИзмененииЗавершение", ЭтотОбъект, Элемент);
	
	Если ЗначениеСпособаХраненияФайлов <> "ВИнформационнойБазе"
		И НаборКонстант.ХранитьФайлыВТомахНаДиске Тогда
		
		ВыполнитьОбработкуОповещения(ОбработкаОповещения, КодВозвратаДиалога.ОК);
		Возврат;
	КонецЕсли;
	
	Попытка
		
		ЗапросыНаИспользованиеВнешнихРесурсов = ЗапросыНаИспользованиеВнешнихРесурсовТомовХраненияФайлов(
			НаборКонстант.ХранитьФайлыВТомахНаДиске);
		
		Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.ПрофилиБезопасности") Тогда
			МодульРаботаВБезопасномРежимеКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("РаботаВБезопасномРежимеКлиент");
			МодульРаботаВБезопасномРежимеКлиент.ПрименитьЗапросыНаИспользованиеВнешнихРесурсов(
				ЗапросыНаИспользованиеВнешнихРесурсов, ЭтотОбъект, ОбработкаОповещения);
		Иначе
			ВыполнитьОбработкуОповещения(ОбработкаОповещения, КодВозвратаДиалога.ОК);
		КонецЕсли;
		
	Исключение
		
		НаборКонстант.СпособХраненияФайлов = ЗначениеСпособаХраненияФайлов;
		НаборКонстант.ХранитьФайлыВТомахНаДиске = ЗначениеСпособаХраненияФайлов <> "ВИнформационнойБазе";
		ВызватьИсключение;
		
	КонецПопытки;
	
КонецПроцедуры

&НаКлиенте
Процедура СоздаватьПодкаталогиСИменамиВладельцевПриИзменении(Элемент)
	
	Подключаемый_ПриИзмененииРеквизита(Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура РасширенияФайловВИБПриИзменении(Элемент)
	
	ПриИзмененииНастроекХраненияФайловВИБ();
	
КонецПроцедуры

&НаКлиенте
Процедура РасширенияФайловВИБОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	РасширенияФайловВИБ = РаботаСФайламиСлужебныйКлиент.РасширенияПоТипуФайла(ВыбранноеЗначение);
	ПриИзмененииНастроекХраненияФайловВИБ();
	
КонецПроцедуры

&НаКлиенте
Процедура МаксимальныйРазмерФайлаВИБПриИзменении(Элемент)
	
	ПриИзмененииНастроекХраненияФайловВИБ();
	
КонецПроцедуры

&НаКлиенте
Процедура ЗапрещатьЗагрузкуФайловПоРасширениюПриИзменении(Элемент)
	
	Если Не ЗапрещатьЗагрузкуФайловПоРасширению Тогда
		
		Оповещение = Новый ОписаниеОповещения(
			"ЗапрещатьЗагрузкуФайловПоРасширениюПослеПодтверждения", ЭтотОбъект, Новый Структура("Элемент", Элемент));
		ОткрытьФорму("ОбщаяФорма.ПредупреждениеБезопасности",
			Новый Структура("Ключ", "ПриИзмененииСпискаЗапрещенныхРасширений"), , , , , Оповещение);
		Возврат;
		
	КонецЕсли;
	
	Подключаемый_ПриИзмененииРеквизита(Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура СинхронизироватьФайлыПриИзменении(Элемент)
	
	Подключаемый_ПриИзмененииРеквизита(Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура СписокЗапрещенныхРасширенийОбластиДанныхПриИзменении(Элемент)
	
	Подключаемый_ПриИзмененииРеквизита(Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура МаксимальныйРазмерФайлаОбластиДанныхПриИзменении(Элемент)
	
	Если МаксимальныйРазмерФайлаОбластиДанных = 0 Тогда
		
		ТекстСообщения = НСтр("ru = 'Поле ""Максимальный размер файла"" не заполнено.'");
		ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения, ,"МаксимальныйРазмерФайлаОбластиДанных");
		Возврат;
		
	КонецЕсли;
	
	Подключаемый_ПриИзмененииРеквизита(Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура СписокРасширенийФайловOpenDocumentОбластиДанныхПриИзменении(Элемент)
	
	Подключаемый_ПриИзмененииРеквизита(Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура СписокРасширенийТекстовыхФайловПриИзменении(Элемент)
	
	Подключаемый_ПриИзмененииРеквизита(Элемент);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Общие параметры для всех областей данных.

&НаКлиенте
Процедура МаксимальныйРазмерФайлаПриИзменении(Элемент)
	
	Если МаксимальныйРазмерФайла = 0 Тогда
		
		ТекстСообщения = НСтр("ru = 'Поле ""Максимальный размер файла"" не заполнено.'");
		ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения, ,"МаксимальныйРазмерФайла");
		Возврат;
		
	КонецЕсли;
	
	Подключаемый_ПриИзмененииРеквизита(Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура СписокЗапрещенныхРасширенийПриИзменении(Элемент)
	
	Подключаемый_ПриИзмененииРеквизита(Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура СписокРасширенийФайловOpenDocumentПриИзменении(Элемент)
	
	Подключаемый_ПриИзмененииРеквизита(Элемент);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура СправочникТомаХраненияФайлов(Команда)
	
	ОткрытьФорму("Справочник.ТомаХраненияФайлов.ФормаСписка", , ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура НастройкаСинхронизацииФайлов(Команда)
	
	ОткрытьФорму("РегистрСведений.НастройкиСинхронизацииФайлов.ФормаСписка", , ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ПереносФайлов(Команда)
	
	РаботаСФайламиСлужебныйКлиент.ПеренестиФайлы();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура СпособХраненияФайловПриИзмененииЗавершение(Ответ, Элемент) Экспорт
	
	Если Ответ <> КодВозвратаДиалога.ОК Тогда
		НаборКонстант.СпособХраненияФайлов = ЗначениеСпособаХраненияФайлов;
		НаборКонстант.ХранитьФайлыВТомахНаДиске = ЗначениеСпособаХраненияФайлов <> "ВИнформационнойБазе";
	Иначе
		
		Если ЗначениеСпособаХраненияФайлов = "ВИнформационнойБазе"
			И НаборКонстант.ХранитьФайлыВТомахНаДиске
			И Не ЕстьТомаХраненияФайлов() Тогда
			
			ПоказатьПредупреждение(, НСтр("ru = 'Включено хранение файлов в томах на диске, но тома еще не настроены.
				|Добавляемые файлы будут сохраняться в информационной базе до тех пор, пока не будет настроен хотя бы один том хранения файлов.'"));
		КонецЕсли;
		
		ПриИзмененииСпособаХраненияФайловНаСервере();
		ОбновитьПовторноИспользуемыеЗначения();
		ПослеИзмененияРеквизита("СпособХраненияФайлов", Ложь);
		ПослеИзмененияРеквизита("ХранитьФайлыВТомахНаДиске");
		
	КонецЕсли;
	
КонецПроцедуры

// Параметры:
//  Результат - Неопределено
//            - Строка
//  ДополнительныеПараметры - Структура:
//    * Элемент - ПолеФормы
//              - РасширениеПоляФормыДляПоляФлажка
//
&НаКлиенте
Процедура ЗапрещатьЗагрузкуФайловПоРасширениюПослеПодтверждения(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат <> Неопределено
		И Результат = "Продолжить" Тогда
		
		Подключаемый_ПриИзмененииРеквизита(ДополнительныеПараметры.Элемент);
	Иначе
		ЗапрещатьЗагрузкуФайловПоРасширению = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриИзмененииНастроекХраненияФайловВИБ()
	
	УстановитьПараметрыХраненияФайловВИБ(
		Новый Структура("РасширенияФайлов, МаксимальныйРазмер",
		РасширенияФайловВИБ, МаксимальныйРазмерФайлаВИБ*1024*1024));
	
	ОбновитьПовторноИспользуемыеЗначения();
	ПослеИзмененияРеквизита("ПараметрыХраненияФайловВИБ", Ложь);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПриИзмененииРеквизита(Элемент, ОбновлятьИнтерфейс = Истина)
	
	КонстантаИмя = ПриИзмененииРеквизитаСервер(Элемент.Имя);
	ОбновитьПовторноИспользуемыеЗначения();
	ПослеИзмененияРеквизита(КонстантаИмя, ОбновлятьИнтерфейс);
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеИзмененияРеквизита(КонстантаИмя, ОбновлятьИнтерфейс = Истина)
	
	Если ОбновлятьИнтерфейс Тогда
		ОбновитьИнтерфейс = Истина;
		ПодключитьОбработчикОжидания("ОбновитьИнтерфейсПрограммы", 2, Истина);
	КонецЕсли;
	
	Если КонстантаИмя <> "" Тогда
		Оповестить("Запись_НаборКонстант", Новый Структура, КонстантаИмя);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьИнтерфейсПрограммы()
	
	Если ОбновитьИнтерфейс = Истина Тогда
		ОбновитьИнтерфейс = Ложь;
		ОбщегоНазначенияКлиент.ОбновитьИнтерфейсПрограммы();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ПриИзмененииРеквизитаСервер(ИмяЭлемента)
	
	РеквизитПутьКДанным = Элементы[ИмяЭлемента].ПутьКДанным;
	
	КонстантаИмя = СохранитьЗначениеРеквизита(РеквизитПутьКДанным);
	
	УстановитьДоступность(РеквизитПутьКДанным);
	ОбновитьПовторноИспользуемыеЗначения();
	
	Возврат КонстантаИмя;
	
КонецФункции

&НаСервере
Процедура ПриИзмененииСпособаХраненияФайловНаСервере()
	
	ЗначениеСпособаХраненияФайлов = НаборКонстант.СпособХраненияФайлов;
	Константы.СпособХраненияФайлов.Установить(НаборКонстант.СпособХраненияФайлов);
	Константы.ХранитьФайлыВТомахНаДиске.Установить(НаборКонстант.ХранитьФайлыВТомахНаДиске);
	УстановитьДоступность("НаборКонстант.СпособХраненияФайлов");
	
	ОбновитьПовторноИспользуемыеЗначения();
	
КонецПроцедуры

&НаСервере
Процедура УстановитьДоступность(РеквизитПутьКДанным = "")
	
	Если РеквизитПутьКДанным = "НаборКонстант.СпособХраненияФайлов" Тогда
		УстановитьДоступностьНастроекХраненияВТомах();
	КонецЕсли;
	
	Если РеквизитПутьКДанным = "ЗапрещатьЗагрузкуФайловПоРасширению"
		Или РеквизитПутьКДанным = "" Тогда
		
		Элементы.СписокЗапрещенныхРасширенийОбластиДанных.Доступность = ЗапрещатьЗагрузкуФайловПоРасширению;
	КонецЕсли;
	
	Если РеквизитПутьКДанным = "НаборКонстант.СинхронизироватьФайлы"
		Или РеквизитПутьКДанным = "" Тогда
		
		Элементы.НастройкиСинхронизацииФайлов.Доступность = НаборКонстант.СинхронизироватьФайлы;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьДоступностьНастроекХраненияВТомах()
	
	Элементы.ГруппаУправлениеТомамиФайлов.Доступность = НаборКонстант.ХранитьФайлыВТомахНаДиске;
	Элементы.СправочникТомаХраненияФайлов.Доступность = НаборКонстант.ХранитьФайлыВТомахНаДиске;
	Элементы.СоздаватьПодкаталогиСИменамиВладельцев.Доступность = НаборКонстант.ХранитьФайлыВТомахНаДиске;
	Элементы.ГруппаУправлениеРазмеромФайловВИБ.Доступность =
		НаборКонстант.СпособХраненияФайлов = "ВИнформационнойБазеИТомахНаДиске";
	Элементы.ГруппаУправлениеРасширениямиФайловВИБ.Доступность =
		НаборКонстант.СпособХраненияФайлов = "ВИнформационнойБазеИТомахНаДиске";
	
КонецПроцедуры

&НаСервере
Функция СохранитьЗначениеРеквизита(РеквизитПутьКДанным)
	
	ЧастиИмени = СтрРазделить(РеквизитПутьКДанным, ".");
	Если ЧастиИмени.Количество() <> 2 Тогда
		
		Если РеквизитПутьКДанным = "МаксимальныйРазмерФайла" Тогда
			НаборКонстант.МаксимальныйРазмерФайла = МаксимальныйРазмерФайла * (1024*1024);
			КонстантаИмя = "МаксимальныйРазмерФайла";
		ИначеЕсли РеквизитПутьКДанным = "МаксимальныйРазмерФайлаОбластиДанных" Тогда
			
			Если Не ОбщегоНазначения.РазделениеВключено() Тогда
				НаборКонстант.МаксимальныйРазмерФайла = МаксимальныйРазмерФайлаОбластиДанных * (1024*1024);
				КонстантаИмя = "МаксимальныйРазмерФайла";
			Иначе
				НаборКонстант.МаксимальныйРазмерФайлаОбластиДанных = МаксимальныйРазмерФайлаОбластиДанных * (1024*1024);
				КонстантаИмя = "МаксимальныйРазмерФайлаОбластиДанных";
			КонецЕсли;
			
		ИначеЕсли РеквизитПутьКДанным = "ЗапрещатьЗагрузкуФайловПоРасширению" Тогда
			НаборКонстант.ЗапрещатьЗагрузкуФайловПоРасширению = ЗапрещатьЗагрузкуФайловПоРасширению;
			КонстантаИмя = "ЗапрещатьЗагрузкуФайловПоРасширению";
		КонецЕсли;
		
	Иначе
		КонстантаИмя = ЧастиИмени[1];
	КонецЕсли;
	
	Если ПустаяСтрока(КонстантаИмя) Тогда
		Возврат "";
	КонецЕсли;
	
	КонстантаМенеджер = Константы[КонстантаИмя];
	КонстантаЗначение = НаборКонстант[КонстантаИмя];
	
	Если КонстантаМенеджер.Получить() <> КонстантаЗначение Тогда
		КонстантаМенеджер.Установить(КонстантаЗначение);
	КонецЕсли;
	
	Возврат КонстантаИмя;
	
КонецФункции

&НаСервереБезКонтекста
Процедура УстановитьПараметрыХраненияФайловВИБ(ПараметрыХранения)
	
	РаботаСФайламиВТомахСлужебный.УстановитьПараметрыХраненияФайловВИнформационнойБазе(ПараметрыХранения);
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ЗапросыНаИспользованиеВнешнихРесурсовТомовХраненияФайлов(Включение)
	
	ЗапросыНаИспользование = Новый Массив;
	ИмяСправочника = "ТомаХраненияФайлов";
	
	Если Включение Тогда
		Справочники[ИмяСправочника].ДобавитьЗапросыНаИспользованиеВнешнихРесурсовВсехТомов(
			ЗапросыНаИспользование);
	Иначе
		Справочники[ИмяСправочника].ДобавитьЗапросыНаОтменуИспользованияВнешнихРесурсовВсехТомов(
			ЗапросыНаИспользование);
	КонецЕсли;
	
	Возврат ЗапросыНаИспользование;
	
КонецФункции

&НаСервереБезКонтекста
Функция ЕстьТомаХраненияФайлов()
	
	Возврат РаботаСФайламиВТомахСлужебный.ЕстьТомаХраненияФайлов();
	
КонецФункции

#КонецОбласти