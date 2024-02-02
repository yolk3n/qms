﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ЗаполнитьДеревоПапок(ДеревоПапок.ПолучитьЭлементы(), ""); // Корневые папки.
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыДеревоПапок

&НаКлиенте
Процедура ДеревоПапокПередРазворачиванием(Элемент, Строка, Отказ)
	
	Лист = ДеревоПапок.НайтиПоИдентификатору(Строка);
	
	Если Лист = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если Не Лист.ПодпапкиСчитаны Тогда
		ЗаполнитьДеревоПапокПоИдентификатору(Строка, Лист.ID);
		Лист.ПодпапкиСчитаны = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ДеревоПапокПриАктивизацииСтроки(Элемент)
	
	Если Элементы.ДеревоПапок.ТекущаяСтрока <> Неопределено Тогда
		ПодключитьОбработчикОжидания("ОбработкаОжидания", 0.2, Истина);
	КонецЕсли; 
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписокФайлов

&НаКлиенте
Процедура СписокФайловВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	ВыбратьВыполнить();
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОткрытьКарточку(Команда)
	
	ОткрытьКарточкуВыполнить();
	
КонецПроцедуры
&НаКлиенте
Процедура Выбрать(Команда)
	ВыбратьВыполнить();
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ЗаполнитьДеревоПапок(ВеткаДерева, ИдентификаторПапки)
	
	Прокси = ИнтеграцияС1СДокументооборотБазоваяФункциональностьПовтИсп.ПолучитьПрокси();
	
	Запрос = ИнтеграцияС1СДокументооборотБазоваяФункциональность.СоздатьОбъект(Прокси, "DMGetSubFoldersRequest");
	
	Запрос.folder = ИнтеграцияС1СДокументооборотБазоваяФункциональность.СоздатьObjectID(
		Прокси,
		ИдентификаторПапки,
		"DMFileFolder");
	
	Ответ = ИнтеграцияС1СДокументооборотБазоваяФункциональность.ВыполнитьЗапрос(Прокси, Запрос);
	ИнтеграцияС1СДокументооборотБазоваяФункциональность.ПроверитьВозвратВебСервиса(Прокси, Ответ);
	
	ВеткаДерева.Очистить();
	
	Для Каждого ПапкаXDTO Из Ответ.folders Цикл
		Лист = ВеткаДерева.Добавить();
		Лист.ID = ПапкаXDTO.objectID.ID;
		Лист.Наименование = ПапкаXDTO.name;
		Лист.ИндексКартинки = 0;
		Лист.ПодпапкиСчитаны = Ложь;
		
		Лист.ПолучитьЭлементы().Добавить(); // чтобы появился плюсик
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьСписокФайлов()
	
	СписокФайлов.Очистить();
	
	Файлы = ИнтеграцияС1СДокументооборотБазоваяФункциональностьВызовСервера.ФайлыПоВладельцу(
		ИдентификаторТекущейПапки,
		ИмяТекущейПапки,
		"DMFileFolder");
	
	Для Каждого СведенияОФайле Из Файлы.files Цикл
		НоваяСтрока = СписокФайлов.Добавить();
		
		НоваяСтрока.Файл = СведенияОФайле.name;
		НоваяСтрока.Расширение = СведенияОФайле.extension;
		НоваяСтрока.Описание = СведенияОФайле.description;
		НоваяСтрока.Размер = Формат(СведенияОФайле.size/1024, "ЧЦ=10; ЧН=0");
		НоваяСтрока.ПодписанЭП = СведенияОФайле.signed;
		НоваяСтрока.Автор = СведенияОФайле.author.name;
		НоваяСтрока.ID = СведенияОФайле.objectID.ID;
		НоваяСтрока.ДатаСоздания = СведенияОФайле.creationDate;
		
		ПометкаУдаления = Ложь;
		Если ИнтеграцияС1СДокументооборотБазоваяФункциональность.СвойствоУстановлено(СведенияОФайле, "deletionMark") Тогда
			ПометкаУдаления = СведенияОФайле.deletionMark;
		КонецЕсли;
		НоваяСтрока.ИндексКартинки =
			ИнтеграцияС1СДокументооборотБазоваяФункциональность.ИндексПиктограммыФайла(
				НоваяСтрока.Расширение,
				ПометкаУдаления);
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьКарточкуВыполнить()
	
	Если Элементы.СписокФайлов.ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ИнтеграцияС1СДокументооборотБазоваяФункциональностьКлиент.ОткрытьОбъект(
		"DMFile",
		Элементы.СписокФайлов.ТекущиеДанные.ID);
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьДеревоПапокПоИдентификатору(ИдентификаторЭлементаДерева, ИдентификаторПапки)
	
	Лист = ДеревоПапок.НайтиПоИдентификатору(ИдентификаторЭлементаДерева);
	
	Если Лист = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ЗаполнитьДеревоПапок(Лист.ПолучитьЭлементы(), Лист.ID);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОжидания()
	
	Данные = Элементы.ДеревоПапок.ТекущиеДанные;
	
	Если Данные.ID <> ИдентификаторТекущейПапки Тогда
		ИдентификаторТекущейПапки = Данные.ID;
		ИмяТекущейПапки = Данные.Наименование;
		ОбновитьСписокФайлов();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьВыполнить()
	
	Если Элементы.СписокФайлов.ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ИдентификаторФайла = Элементы.СписокФайлов.ТекущиеДанные.ID;
	Закрыть(ИдентификаторФайла);
	
КонецПроцедуры

#КонецОбласти
