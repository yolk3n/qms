﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2023, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ЗакрыватьПриВыборе = Ложь; 
	Инициализировать();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыДоступныеПоля

#Область ПодключаемыйСписокПолей

&НаКлиенте
Процедура Подключаемый_СписокПолейПередРазворачиванием(Элемент, Строка, Отказ)
	
	КонструкторФормулКлиент.СписокПолейПередРазворачиванием(ЭтотОбъект, Элемент, Строка, Отказ);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_РазвернутьТекущийЭлементСпискаПолей()
	
	КонструкторФормулКлиент.РазвернутьТекущийЭлементСпискаПолей(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ЗаполнитьСписокДоступныхПолей(ПараметрыЗаполнения) Экспорт // АПК:78 процедура вызывается из общего модуля КонструкторФормулКлиент.
	
	ЗаполнитьСписокДоступныхПолей(ПараметрыЗаполнения);
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСписокДоступныхПолей(ПараметрыЗаполнения)
	
	КонструкторФормул.ЗаполнитьСписокДоступныхПолей(ЭтотОбъект, ПараметрыЗаполнения);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_СписокПолейВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ВыбратьИЗакрыть();
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_СписокПолейНачалоПеретаскивания(Элемент, ПараметрыПеретаскивания, Выполнение)
	
	КонструкторФормулКлиент.СписокПолейНачалоПеретаскивания(ЭтотОбъект, Элемент, ПараметрыПеретаскивания, Выполнение);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_СписокПолейПриАктивизацииСтроки(Элемент)
	
	ПодключитьОбработчикОжидания("СкрытьНеиспользуемыеКоманды", 0.1, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура СкрытьНеиспользуемыеКоманды()
	
	ИменаКомандРедактированияФормул = ИменаКомандРедактированияФормул();
	ИмяКомандыИсключение = "ДобавитьФормулу";
	
	КомандыРедактированияФормул = Новый Массив;
	
	Для Каждого Элемент Из Элементы.ДоступныеПоляКонтекстноеМеню.ПодчиненныеЭлементы Цикл // АПК:275  элемент добавляется программно.
		
		Элемент.Видимость = ТипЗнч(Элемент) = Тип("КнопкаФормы")
			И ИменаКомандРедактированияФормул.Найти(Элемент.ИмяКоманды) <> Неопределено;
		
		Если Элемент.Видимость И Элемент.ИмяКоманды <> ИмяКомандыИсключение Тогда 
			КомандыРедактированияФормул.Добавить(Элемент);
		КонецЕсли;
		
	КонецЦикла;
	
	Для Каждого ИмяКоманды Из ИменаКомандРедактированияФормул Цикл 
		
		Элемент = Элементы.Найти(ИмяКоманды);
		
		Если Элемент <> Неопределено И Элемент.ИмяКоманды <> ИмяКомандыИсключение Тогда 
			КомандыРедактированияФормул.Добавить(Элемент);
		КонецЕсли;
		
	КонецЦикла;
	
	ПолеСписка = СписокДоступныхПолей(ЭтотОбъект).Поле;
	РедактированиеФормулыДоступно = РедактированиеФормулыДоступно(ПолеСписка.ТекущиеДанные);
	
	Для Каждого Элемент Из КомандыРедактированияФормул Цикл 
		Элемент.Доступность = РедактированиеФормулыДоступно;
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_СтрокаПоискаИзменениеТекстаРедактирования(Элемент, Текст, СтандартнаяОбработка)
	
	КонструкторФормулКлиент.СтрокаПоискаИзменениеТекстаРедактирования(ЭтотОбъект, Элемент, Текст, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ВыполнитьПоискВСпискеПолей()
	
	ВыполнитьПоискВСпискеПолей();
	
КонецПроцедуры

&НаСервере
Процедура ВыполнитьПоискВСпискеПолей()
	
	КонструкторФормул.ВыполнитьПоискВСпискеПолей(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_СтрокаПоискаОчистка(Элемент, СтандартнаяОбработка)
	
	КонструкторФормулКлиент.СтрокаПоискаОчистка(ЭтотОбъект, Элемент, СтандартнаяОбработка);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Выбрать(Команда)
	
	ВыбратьИЗакрыть();
	
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьФормулу(Команда)
	
	АктивизироватьГруппуФормул(Ложь);
	
	ПараметрыРедактированияФормулы = КонструкторФормулКлиент.ПараметрыРедактированияФормулы();
	ПараметрыРедактированияФормулы.Операнды = НастройкиОтчета.АдресСхемы;
	ПараметрыРедактированияФормулы.ИмяКоллекцииСКДОперандов = ИмяКоллекцииПолей;
	ПараметрыРедактированияФормулы.Наименование = НаименованиеНовогоПоля();
	ПараметрыРедактированияФормулы.ДляЗапроса = Истина;
	
	Обработчик = Новый ОписаниеОповещения("ПослеДобавленияФормулы", ЭтотОбъект);
	КонструкторФормулКлиент.НачатьРедактированиеФормулы(ПараметрыРедактированияФормулы, Обработчик);
	
КонецПроцедуры

&НаКлиенте
Процедура ИзменитьФормулу(Команда)
	
	ПолеСписка = СписокДоступныхПолей(ЭтотОбъект).Поле;
	Строка = ПолеСписка.ТекущиеДанные;
	
	Если Не РедактированиеФормулыДоступно(Строка) Тогда 
		Возврат;
	КонецЕсли;
	
	ВариантыОтчетовСлужебныйКлиент.ИзменитьФормулу(
		ЭтотОбъект, КомпоновщикНастроек.Настройки, Строка.ПутьКДанным, ИмяКоллекцииПолей);
	
КонецПроцедуры

// Параметры:
//  ОписаниеФормулы - ДоступноеПолеКомпоновкиДанных
//                  - Структура:
//                      * Формула - Строка
//                      * ПредставлениеФормулы - Строка
//                      * Наименование - Строка
//  Формула - Структура:
//    * Формула - ПользовательскоеПолеВыражениеКомпоновкиДанных
//    * КоллекцияПолей - ДоступныеПоляКомпоновкиДанных
//  
&НаКлиенте
Процедура ПослеИзмененияФормулы(ОписаниеФормулы, Формула) Экспорт 
	
	Если ТипЗнч(ОписаниеФормулы) <> Тип("Структура") Тогда 
		Возврат;
	КонецЕсли;
	
	ВариантыОтчетовСлужебныйКлиент.ПослеИзмененияФормулы(ОписаниеФормулы, Формула);
	
	Список = Элементы.Найти("ДоступныеПоля");
	
	Если Список = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Строка = Список.ТекущиеДанные;
	
	Если Строка <> Неопределено Тогда 
		Строка.Заголовок = ОписаниеФормулы.Заголовок;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура УдалитьФормулу(Команда)
	
	ПолеСписка = СписокДоступныхПолей(ЭтотОбъект).Поле;
	Строка = ПолеСписка.ТекущиеДанные;
	
	Если Не РедактированиеФормулыДоступно(Строка) Тогда 
		Возврат;
	КонецЕсли;
	
	Формулы = КомпоновщикНастроек.Настройки.ПользовательскиеПоля.Элементы;
	Формула = ВариантыОтчетовСлужебныйКлиентСервер.ФормулаПоПутиКДанным(КомпоновщикНастроек.Настройки, Строка.ПутьКДанным);
	Формулы.Удалить(Формула);
	
	ОбновитьКоллекцииПолей();	
	АктивизироватьГруппуФормул();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура Инициализировать()
	
	КомпоновщикНастроек = Параметры.КомпоновщикНастроек;
	Режим = Параметры.Режим;
	НастройкиОтчета = Параметры.НастройкиОтчета;
	
	КомпоновщикНастроек.Инициализировать(Новый ИсточникДоступныхНастроекКомпоновкиДанных(НастройкиОтчета.АдресСхемы));
	
	УстановитьИмяКоллекции();
	УстановитьИдентификаторЭлементаСтруктурыНастроек();
	ИнициализироватьСписокДоступныхПолей();
	АктивизироватьДоступноеПоле();
	
КонецПроцедуры

&НаСервере
Процедура УстановитьИмяКоллекции()
	
	Режимы = Новый Соответствие;
	Режимы.Вставить("Отборы", "ДоступныеПоляОтбора");
	Режимы.Вставить("ВыбранныеПоля", "ДоступныеПоляВыбора");
	Режимы.Вставить("Сортировка", "ДоступныеПоляПорядка");
	Режимы.Вставить("ПоляГруппировки", "ДоступныеПоляГруппировок");
	Режимы.Вставить("СоставГруппировки", "ДоступныеПоляГруппировок");
	Режимы.Вставить("СтруктураВарианта", "ДоступныеПоляГруппировок");
	Режимы.Вставить("ПоляОформления", "УсловноеОформление.ДоступныеПоляПолей");
	Режимы.Вставить("УсловияОформления", "УсловноеОформление.ДоступныеПоляОтбора");
	
	ИмяКоллекцииПолей = Режимы[Режим];
	
	Если ИмяКоллекцииПолей = Неопределено Тогда		
		ВызватьИсключение СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Некорректное значение параметра ""Режим"": ""%1"".'"), Строка(Режим));		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьИдентификаторЭлементаСтруктурыНастроек()
	
	ИдентификаторЭлементаСтруктурыНастроек = ОбщегоНазначенияКлиентСервер.СвойствоСтруктуры(
		Параметры, "ИдентификаторЭлементаСтруктурыНастроек");
	
	Если ИдентификаторЭлементаСтруктурыНастроек = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ЭлементСтруктурыНастроек = КомпоновщикНастроек.Настройки.ПолучитьОбъектПоИдентификатору(ИдентификаторЭлементаСтруктурыНастроек);
	
	Если ТипЗнч(ЭлементСтруктурыНастроек) = Тип("КоллекцияЭлементовСтруктурыТаблицыКомпоновкиДанных")
		Или ТипЗнч(ЭлементСтруктурыНастроек) = Тип("КоллекцияЭлементовСтруктурыДиаграммыКомпоновкиДанных")
		Или ТипЗнч(ЭлементСтруктурыНастроек) = Тип("ТаблицаКомпоновкиДанных")
		Или ТипЗнч(ЭлементСтруктурыНастроек) = Тип("ДиаграммаКомпоновкиДанных") Тогда
		
		ИдентификаторЭлементаСтруктурыНастроек = Неопределено;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ИнициализироватьСписокДоступныхПолей()
	
	// КонструкторФормул
	
	ПараметрыДобавленияСпискаПолей = КонструкторФормул.ПараметрыДобавленияСпискаПолей();
	ПараметрыДобавленияСпискаПолей.МестоРазмещенияСписка = МестоРазмещенияСписка(Элементы);
	ПараметрыДобавленияСпискаПолей.КоллекцииПолей = КоллекцииПолей();
	
	ПараметрыДобавленияСпискаПолей.ОбработчикиСписка.Вставить("Выбор", "Подключаемый_СписокПолейВыбор");
	ПараметрыДобавленияСпискаПолей.ОбработчикиСписка.Вставить("ПриАктивизацииСтроки", "Подключаемый_СписокПолейПриАктивизацииСтроки");
	
	КонструкторФормул.ДобавитьСписокПолейНаФорму(ЭтотОбъект, ПараметрыДобавленияСпискаПолей);
	
	// Конец КонструкторФормул
	
	ДобавитьКомандыРедактированияФормулВКонтекстноеМеню();
	
КонецПроцедуры

&НаСервере
Процедура ДобавитьКомандыРедактированияФормулВКонтекстноеМеню()
	
	ПолеСписка = СписокДоступныхПолей(ЭтотОбъект).Поле;
	
	ИмяКоманднойПанелиРедактированияФормул = "КомандыРедактированияФормул";
	ИменаКомандРедактированияФормул = ИменаКомандРедактированияФормул();
	
	Для Каждого ИмяКоманды Из ИменаКомандРедактированияФормул Цикл 
		
		ИмяКнопки = "КонтекстноеМеню" + ИмяКоманднойПанелиРедактированияФормул + ИмяКоманды;
		Кнопка = Элементы.Добавить(ИмяКнопки, Тип("КнопкаФормы"), ПолеСписка.КонтекстноеМеню);
		Кнопка.ИмяКоманды = ИмяКоманды;
		
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура АктивизироватьДоступноеПоле()
	
	Поле = ОбщегоНазначенияКлиентСервер.СвойствоСтруктуры(Параметры, "ПолеКД");
	
	Если Поле = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	КоллекцияПолей = КоллекцияПолей(ЭтотОбъект);
	ДоступноеПоле = КоллекцияПолей.НайтиПоле(Поле);
	
	Если ДоступноеПоле = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ПолеДоступныхПолей = Элементы.ДоступныеПоля; // АПК:275 элементы формируются программно.
	ДанныеДоступныхПолей = ЭтотОбъект[ПолеДоступныхПолей.ПутьКДанным].ПолучитьЭлементы();
	
	Для Каждого Строка Из ДанныеДоступныхПолей Цикл 
		
		Если Строка.Поле = Поле Тогда 
			ПолеДоступныхПолей.ТекущаяСтрока = Строка.ПолучитьИдентификатор();
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьИЗакрыть()
	
	ОчиститьСообщения();
	ПолеСписка = СписокДоступныхПолей(ЭтотОбъект).Поле;
	Если ТипЗнч(ПолеСписка.ТекущиеДанные) = Тип("ДанныеФормыЭлементДерева") И ПолеСписка.ТекущиеДанные.Папка Тогда
		ОбщегоНазначенияКлиент.СообщитьПользователю(НСтр("ru = 'Выберите поле отчета, а не группу.'"));
		Возврат;
	ИначеЕсли ТипЗнч(ПолеСписка.ТекущиеДанные) <> Тип("ДанныеФормыЭлементДерева") Тогда
		ОбщегоНазначенияКлиент.СообщитьПользователю(НСтр("ru = 'Выберите поле отчета.'"));
		Возврат;
	КонецЕсли;
	
	ВыбранноеПоле = КонструкторФормулКлиент.ВыбранноеПолеВСпискеПолей(ЭтотОбъект);
	
	ДоступноеПоле = Неопределено;
	Родитель = ВыбранноеПоле.Родитель; // см. КонструкторФормулКлиент.ВыбранноеПолеВСпискеПолей

	Если Родитель <> Неопределено
		И Родитель.Имя = ИдентификаторГруппыФормул() Тогда 
		
		ДоступноеПоле = ВариантыОтчетовСлужебныйКлиентСервер.ФормулаПоПутиКДанным(
			КомпоновщикНастроек.Настройки, ВыбранноеПоле.ПутьКДанным);
			
		Если ТипЗнч(ДоступноеПоле) <> Тип("ПользовательскоеПолеВыражениеКомпоновкиДанных") Тогда
			ДоступноеПоле = Неопределено;
		КонецЕсли;
		
	ИначеЕсли ИмяКоллекцииПолей = "ДоступныеПоляГруппировок"
		И ВыбранноеПоле.Имя = "ДетальныеЗаписи" Тогда
		
		ДоступноеПоле = "<>";
		
	КонецЕсли;
	
	Если ДоступноеПоле = Неопределено Тогда
		
		КоллекцияПолей = КоллекцияПолей(ЭтотОбъект);
		Поле = Новый ПолеКомпоновкиДанных(ВыбранноеПоле.ПутьКДанным);
		ДоступноеПоле = КоллекцияПолей.НайтиПоле(Поле);
		
	КонецЕсли;
	
	ОповеститьОВыборе(ДоступноеПоле);
	Закрыть(ДоступноеПоле);
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеДобавленияФормулы(ОписаниеФормулы, ДополнительныеПараметры) Экспорт 
	
	Если ТипЗнч(ОписаниеФормулы) <> Тип("Структура")
		Или Не ОписаниеФормулы.Свойство("Формула") Тогда 
		
		Возврат;
	КонецЕсли;
	
	ВариантыОтчетовСлужебныйКлиент.ДобавитьФормулу(КомпоновщикНастроек.Настройки, КоллекцияПолей(ЭтотОбъект), ОписаниеФормулы);
	ОбновитьКоллекцииПолей();
	АктивизироватьГруппуФормул();
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьКоллекцииПолей()
	
	КонструкторФормул.ОбновитьКоллекцииПолей(ЭтотОбъект, КоллекцииПолей());
	
КонецПроцедуры

&НаКлиенте
Функция НаименованиеНовогоПоля()
	
	ЗаголовкиПолей = Новый Соответствие;
	
	ПользовательскиеПоля =  КомпоновщикНастроек.Настройки.ДоступныеПоляВыбора.Элементы.Найти(Новый ПолеКомпоновкиДанных("ПользовательскиеПоля"));
	Если ПользовательскиеПоля = Неопределено Тогда
		Возврат НСтр("ru = 'Поле 1'");
	КонецЕсли;
	
	Для Каждого Поле Из ПользовательскиеПоля.Элементы Цикл
		ЗаголовкиПолей.Вставить(Поле.Заголовок, Истина);
	КонецЦикла;

	Для НомерПоля = 1 По 100 Цикл
		НаименованиеПоля = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Поле %1'"), НомерПоля);
		Если ЗаголовкиПолей[НаименованиеПоля] = Неопределено Тогда
			Возврат НаименованиеПоля;
		КонецЕсли;
	КонецЦикла;
	
	Возврат НСтр("ru = 'Поле'");
	
КонецФункции

#Область Общее

&НаКлиентеНаСервереБезКонтекста
Функция МестоРазмещенияСписка(Элементы)
	
	Возврат Элементы.ГруппаДоступныеПоля;
	
КонецФункции

// Параметры:
//  ЭтотОбъект - ФормаКлиентскогоПриложения
//
// Возвращаемое значение:
//  Структура:
//    * Поле - ТаблицаФормы:
//        ** Имя - Строка
//        ** Заголовок - Строка
//        ** Поле - ОписаниеТипов
//        ** ПутьКДанным - Строка
//        ** ПредставлениеПутиКДанным - Строка
//        ** Тип - ОписаниеТипов
//        ** Картинка - Картинка
//        ** Папка - Булево
//        ** Таблица - Булево
//        ** СвойНаборПолей - Булево 
//        ** Отступ - Строка
//        ** СоответствуетОтбору - Булево
//        ** ПодчиненныйЭлементСоответствуетОтбору - Булево
//    * Данные - ДанныеФормыДерево:
//        ** Имя - Строка
//        ** Заголовок - Строка
//        ** Поле - ОписаниеТипов
//        ** ПутьКДанным - Строка
//        ** ПредставлениеПутиКДанным - Строка
//        ** Тип - ОписаниеТипов
//        ** Картинка - Картинка
//        ** Папка - Булево
//        ** Таблица - Булево
//        ** СвойНаборПолей - Булево 
//        ** Отступ - Строка
//        ** СоответствуетОтбору - Булево
//        ** ПодчиненныйЭлементСоответствуетОтбору - Булево
//
&НаКлиентеНаСервереБезКонтекста
Функция СписокДоступныхПолей(ЭтотОбъект)
	
	СписокДоступныхПолей = Новый Структура("Поле, Данные");
	
	МестоРазмещенияСписка = МестоРазмещенияСписка(ЭтотОбъект.Элементы);
	
	Для Каждого Элемент Из МестоРазмещенияСписка.ПодчиненныеЭлементы Цикл 
		
		Если ТипЗнч(Элемент) = Тип("ТаблицаФормы") Тогда 
			
			СписокДоступныхПолей.Поле = Элемент;
			СписокДоступныхПолей.Данные = ЭтотОбъект[Элемент.Имя];
			Прервать;
			
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат СписокДоступныхПолей;
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция ИдентификаторГруппыФормул()
	
	Возврат "ПользовательскиеПоля";
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция ИменаКомандРедактированияФормул()
	
	Возврат СтрРазделить("ДобавитьФормулу, ИзменитьФормулу, УдалитьФормулу", ", ", Ложь);
	
КонецФункции

// Параметры:
//  ВыбранноеПоле - см. СписокДоступныхПолей.Поле
// 
// Возвращаемое значение:
//  Булево
//
&НаКлиентеНаСервереБезКонтекста
Функция РедактированиеФормулыДоступно(ВыбранноеПоле)
	
	Если ТипЗнч(ВыбранноеПоле) <> Тип("ДанныеФормыЭлементДерева") Тогда 
		Возврат Ложь;
	КонецЕсли;
	
	Родитель = ВыбранноеПоле.ПолучитьРодителя();
	
	Возврат Родитель <> Неопределено И Родитель.Имя = ИдентификаторГруппыФормул();
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция КоллекцияПолей(ЭтотОбъект)
	
	Настройки = ЭтотОбъект.КомпоновщикНастроек.Настройки;
	
	Если ЭтотОбъект.ИмяКоллекцииПолей = "ДоступныеПоляГруппировок" Тогда
		
		Если ЭтотОбъект.ИдентификаторЭлементаСтруктурыНастроек = Неопределено Тогда
			
			ЭлементСтруктурыНастроек = Настройки;
		Иначе
			ЭлементСтруктурыНастроек = Настройки.ПолучитьОбъектПоИдентификатору(
				ЭтотОбъект.ИдентификаторЭлементаСтруктурыНастроек);
		КонецЕсли;
		
		Если ТипЗнч(ЭлементСтруктурыНастроек) = Тип("НастройкиКомпоновкиДанных") Тогда
			Возврат ЭлементСтруктурыНастроек.ДоступныеПоляГруппировок;
		Иначе
			Возврат ЭлементСтруктурыНастроек.ПоляГруппировки.ДоступныеПоляПолейГруппировок;
		КонецЕсли;
		
	ИначеЕсли СтрНайти(ЭтотОбъект.ИмяКоллекцииПолей, ".") > 0 Тогда 
		
		ОписаниеИмениКоллекцииПолей = СтрРазделить(ЭтотОбъект.ИмяКоллекцииПолей, ".");
		КоллекцияПолей = Настройки;
		
		Для Каждого Элемент Из ОписаниеИмениКоллекцииПолей Цикл 
			КоллекцияПолей = КоллекцияПолей[Элемент];
		КонецЦикла;
		
		Возврат КоллекцияПолей;
		
	КонецЕсли;
	
	Возврат Настройки[ЭтотОбъект.ИмяКоллекцииПолей];
	
КонецФункции

&НаСервере
Функция КоллекцииПолей()
	
	КоллекцииПолей = Новый Массив;
	КоллекцииПолей.Добавить(КоллекцияПолей(ЭтотОбъект));
	
	Если КомпоновщикНастроек.Настройки.ПользовательскиеПоля.Элементы.Количество() = 0 Тогда 
		КоллекцииПолей.Добавить(ДополнительноеПолеГруппыФормул());
	КонецЕсли;
	
	Если Режим = "СтруктураВарианта" Тогда
		КоллекцииПолей.Добавить(ДополнительноеПолеДетальныхЗаписей());
	КонецЕсли;
	
	Возврат КоллекцииПолей;
	
КонецФункции

&НаСервере
Функция ДополнительноеПолеГруппыФормул()
	
	ТаблицаПолей = КонструкторФормул.ТаблицаПолей();
	Поле = ТаблицаПолей.Добавить();
	Поле.Идентификатор = ИдентификаторГруппыФормул();
	Поле.Представление = НСтр("ru = 'Формулы'");
	Поле.Порядок = 99;
	
	Возврат КонструкторФормул.КоллекцияПолей(ТаблицаПолей);
	
КонецФункции

&НаСервере
Функция ДополнительноеПолеДетальныхЗаписей()
	
	ТаблицаПолей = КонструкторФормул.ТаблицаПолей();
	Поле = ТаблицаПолей.Добавить();
	Поле.Идентификатор = "ДетальныеЗаписи";
	Поле.Представление = НСтр("ru = '<Детальные записи>'");
	
	Возврат КонструкторФормул.КоллекцияПолей(ТаблицаПолей);
	
КонецФункции

&НаКлиенте
Функция ГруппаФормул()
	
	Список = СписокДоступныхПолей(ЭтотОбъект).Данные;
	Строки = Список.ПолучитьЭлементы();
	
	Индекс = Строки.Количество() - 1;
	
	Пока Индекс >= 0 Цикл 
		
		Строка = Строки[Индекс];
		
		Если Строка.Имя = ИдентификаторГруппыФормул() Тогда 
			Возврат Строка;
		КонецЕсли;
		
		Индекс = Индекс - 1;
		
	КонецЦикла;
	
	Возврат Неопределено;
	
КонецФункции

&НаКлиенте
Процедура АктивизироватьГруппуФормул(РазвернутьФормулы = Истина)
	
	ГруппаФормул = ГруппаФормул();
	
	ПолеСписка = СписокДоступныхПолей(ЭтотОбъект).Поле;
	ПолеСписка.ТекущаяСтрока = ГруппаФормул.ПолучитьИдентификатор();
	
	ТекущийЭлемент = ПолеСписка;
	
	Если РазвернутьФормулы Тогда 
		ПолеСписка.Развернуть(ГруппаФормул.ПолучитьИдентификатор());
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти