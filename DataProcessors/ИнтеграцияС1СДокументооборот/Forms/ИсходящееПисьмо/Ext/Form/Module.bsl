﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Прокси = ИнтеграцияС1СДокументооборотБазоваяФункциональностьПовтИсп.ПолучитьПрокси();
	
	// почта
	Если Не ИнтеграцияС1СДокументооборотБазоваяФункциональностьПовтИсп.ДоступенФункционалВерсииСервиса("1.2.8.1.CORP") Тогда
		ВызватьИсключение(НСтр("ru = 'Функционал не поддерживается в данной версии 1С:Документооборота.'"));
	КонецЕсли;
	
	Если Параметры.Свойство("Предмет") И ЗначениеЗаполнено(Параметры.Предмет) Тогда
		ЗаполнитьКарточкуНовогоПисьма(Прокси, Параметры);
		
	ИначеЕсли ЗначениеЗаполнено(Параметры.ID) И ЗначениеЗаполнено(Параметры.type) Тогда
		// Открывается карточка имеющегося письма
		ПисьмоXDTO = ИнтеграцияС1СДокументооборотБазоваяФункциональность.ПолучитьОбъект(
			Прокси,
			Параметры.type,
			Параметры.ID);
		ЗаполнитьФормуИзОбъектаXDTO(ПисьмоXDTO);
		
	Иначе
		ПисьмоXDTO = ИнтеграцияС1СДокументооборотБазоваяФункциональность.НовоеИсходящееПисьмо(Прокси);
		ЗаполнитьФормуИзОбъектаXDTO(ПисьмоXDTO);
		
	КонецЕсли;
	
	Если Не ИнтеграцияС1СДокументооборотБазоваяФункциональностьПовтИсп.ДоступенФункционалВерсииСервиса("1.4.8.1") Тогда
		Элементы.ФормаПереслать.Доступность = Ложь;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ID) И Отправлено Тогда
		ТолькоПросмотр = Истина;
		Элементы.ФормаЗакрыть.Видимость = Истина;
		Элементы.ПростойТекст.Видимость = Ложь;
		Элементы.ФормаЗакрыть.КнопкаПоУмолчанию = Истина;
		Элементы.ФормаОтправить.Видимость = Ложь;
		
		Элементы.ДеревоПриложений.ТолькоПросмотр = Истина;
		Элементы.Адресаты.ТолькоПросмотр = Истина;
		Элементы.Важность.ТолькоПросмотр = Истина;
		Элементы.Добавить.Доступность = Ложь;
		Элементы.Удалить.Доступность = Ложь;
		Элементы.Тема.ТолькоПросмотр = Истина;
		Элементы.ФормаДобавитьАдресатов.Видимость = Ложь;
	Иначе
		Элементы.HTMLПредставление.Видимость = Ложь;
		Элементы.ФормаЗакрыть.Видимость = Ложь;
		Элементы.ФормаПереслать.Видимость = Ложь;
		Элементы.СоздатьНаОсновании.Видимость = Ложь;
	КонецЕсли;
	
	ОтобразитьКоличествоФайловСервер();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если Не ЗначениеЗаполнено(ID) И Адресаты.Количество() = 0 Тогда
		ПодключитьОбработчикОжидания("УстановитьТекущийЭлементПолучатель", 0.2, Истина);
	ИначеЕсли Не ЗначениеЗаполнено(Тема) Тогда
		ПодключитьОбработчикОжидания("УстановитьТекущийЭлементТема", 0.2, Истина);
	Иначе
		ПодключитьОбработчикОжидания("УстановитьТекущийЭлементТекст", 0.2, Истина);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ПисьмоОснованиеНажатие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Если ЗначениеЗаполнено(ПисьмоОснованиеID) Тогда
		ИнтеграцияС1СДокументооборотБазоваяФункциональностьКлиент.ОткрытьОбъект(
			ПисьмоОснованиеТип,
			ПисьмоОснованиеID,
			Элемент);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПредметНажатие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Если ЗначениеЗаполнено(ПредметID) Тогда
		ИнтеграцияС1СДокументооборотБазоваяФункциональностьКлиент.ОткрытьОбъект(ПредметТип, ПредметID, Элемент);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВажностьНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ИнтеграцияС1СДокументооборотКлиент.ВыбратьЗначениеИзВыпадающегоСписка(
		"DMEMailImportance",
		"Важность",
		ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ВажностьАвтоПодбор(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, Ожидание, СтандартнаяОбработка)
	
	Если ЗначениеЗаполнено(Текст) Тогда
		ИнтеграцияС1СДокументооборотБазоваяФункциональностьВызовСервера.ДанныеДляАвтоПодбора(
			"DMEMailImportance", ДанныеВыбора, Текст, СтандартнаяОбработка);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВажностьОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, СтандартнаяОбработка)
	
	Если ЗначениеЗаполнено(Текст) Тогда
		ИнтеграцияС1СДокументооборотБазоваяФункциональностьВызовСервера.ДанныеДляАвтоПодбора(
			"DMEMailImportance",
			ДанныеВыбора,
			Текст,
			СтандартнаяОбработка);
		
		Если ДанныеВыбора.Количество() = 1 Тогда
			ИнтеграцияС1СДокументооборотБазоваяФункциональностьКлиент.ОбработкаВыбораДанныхДляАвтоПодбора(
				"Важность",
				ДанныеВыбора[0].Значение,
				СтандартнаяОбработка,
				ЭтотОбъект);
			СтандартнаяОбработка = Истина;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВажностьОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	ИнтеграцияС1СДокументооборотБазоваяФункциональностьКлиент.ОбработкаВыбораДанныхДляАвтоПодбора(
		"Важность",
		ВыбранноеЗначение,
		СтандартнаяОбработка,
		ЭтотОбъект);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыДеревоПриложений

&НаКлиенте
Процедура ДеревоПриложенийВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ОткрытьЭлементДереваПриложений(Элемент.ТекущиеДанные);
	
КонецПроцедуры

&НаКлиенте
Процедура ДеревоПриложенийПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	
	Отказ = Истина;
	НачатьДобавлениеФайлаСДиска();
	
КонецПроцедуры

&НаКлиенте
Процедура ДеревоПриложенийПеретаскивание(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка, Строка, Поле)
	
	СтандартнаяОбработка = Ложь;
	
	Если ТипЗнч(ПараметрыПеретаскивания.Значение) = Тип("Файл") Тогда
		ПолныеИменаФайлов = Новый Массив;
		ПолныеИменаФайлов.Добавить(ПараметрыПеретаскивания.Значение.ПолноеИмя);
		НачатьДобавлениеФайлаСДискаПоМассивуИмен(ПолныеИменаФайлов);
	ИначеЕсли ТипЗнч(ПараметрыПеретаскивания.Значение) = Тип("Массив") Тогда
		ПолныеИменаФайлов = Новый Массив;
		Для Каждого ЭлементМассива Из ПараметрыПеретаскивания.Значение Цикл
			Если ТипЗнч(ЭлементМассива) = Тип("Файл") Тогда
				ПолныеИменаФайлов.Добавить(ЭлементМассива.ПолноеИмя);
			КонецЕсли;
		КонецЦикла;
		Если ПолныеИменаФайлов.Количество() > 0 Тогда
			НачатьДобавлениеФайлаСДискаПоМассивуИмен(ПолныеИменаФайлов);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ДеревоПриложенийПроверкаПеретаскивания(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка, Строка, Поле)
	
	ПеретаскиваемоеЗначение = ПараметрыПеретаскивания.Значение;
	Если ТипЗнч(ПеретаскиваемоеЗначение) <> Тип("Массив")
		И ТипЗнч(ПеретаскиваемоеЗначение) <> Тип("Файл") Тогда
		
		СтандартнаяОбработка = Истина;
		Возврат;
		
	КонецЕсли;
	
	СтандартнаяОбработка = Ложь;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыАдресаты

&НаКлиенте
Процедура АдресатыПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	
	Элемент.ТекущийЭлемент = Элементы.АдресатыАдресат;
	
	СтрокаДанных = Адресаты.НайтиПоИдентификатору(Элементы.Адресаты.ТекущаяСтрока);
	КоличествоАдресатовДоДобавления = Адресаты.Количество();
	Если Не ЗначениеЗаполнено(СтрокаДанных.ТипАдреса) Тогда
		Если КоличествоАдресатовДоДобавления = 1 Тогда
			СтрокаДанных.ТипАдреса = НСтр("ru='Кому:'");
		Иначе
			СтрокаДанных.ТипАдреса = НСтр("ru='Копия:'");
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура АдресатыАдресатАдресНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Оповещение = Новый ОписаниеОповещения("АдресатыАдресатАдресНачалоВыбораЗавершение", ЭтотОбъект);
	
	ОткрытьФорму("Обработка.ИнтеграцияС1СДокументооборот.Форма.АдреснаяКнига",,Элемент,,,, Оповещение);
	
КонецПроцедуры

&НаКлиенте
Процедура АдресатыАдресатОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, СтандартнаяОбработка)
	
	Если ЗначениеЗаполнено(Текст) Тогда
		ДанныеДляАвтоПодбораАдресата(ДанныеВыбора, Текст, СтандартнаяОбработка);
		
		Если ДанныеВыбора.Количество() = 1 Тогда
			ИнтеграцияС1СДокументооборотБазоваяФункциональностьКлиент.ОбработкаВыбораДанныхДляАвтоПодбора(
				"Адресат",
				ДанныеВыбора[0].Значение,
				СтандартнаяОбработка,
				ЭтотОбъект,
				Истина,
				Элемент);
			Элемент.Родитель.ТекущиеДанные.НеНайден = Ложь;
			СтандартнаяОбработка = Истина;
		ИначеЕсли ДанныеВыбора.Количество() = 0 Тогда
			СтандартнаяОбработка = Истина;
			Элемент.Родитель.ТекущиеДанные.НеНайден = Истина;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура АдресатыАдресатАвтоПодбор(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, Ожидание, СтандартнаяОбработка)
	
	Если ЗначениеЗаполнено(Текст) Тогда
		ДанныеДляАвтоПодбораАдресата(ДанныеВыбора, Текст, СтандартнаяОбработка);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура АдресатыАдресатОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	ИнтеграцияС1СДокументооборотБазоваяФункциональностьКлиент.ОбработкаВыбораДанныхДляАвтоПодбора(
		"Адресат",
		ВыбранноеЗначение,
		СтандартнаяОбработка,
		ЭтотОбъект,
		Истина,
		Элемент);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Переслать(Команда)
	
	ПараметрыФормы = Новый Структура("Предмет", Новый Структура);
	
	ПараметрыФормы.Предмет.Вставить("name", Тема);
	ПараметрыФормы.Предмет.Вставить("ID", ID);
	ПараметрыФормы.Предмет.Вставить("type", Тип);
	ПараметрыФормы.Вставить("answerType", "transfer");
	
	ОткрытьФорму("Обработка.ИнтеграцияС1СДокументооборот.Форма.ИсходящееПисьмо", ПараметрыФормы);
	ПодключитьОбработчикОжидания("ЗакрытьФормуПриПересылке", 0.2, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьПроцесс(Команда)
	
	ПараметрыФормы = Новый Структура("Предмет", Новый Структура);
	
	ПараметрыФормы.Предмет.Вставить("ID", ID);
	ПараметрыФормы.Предмет.Вставить("type", Тип);
	ПараметрыФормы.Предмет.Вставить("name", Представление);
	
	ОткрытьФорму("Обработка.ИнтеграцияС1СДокументооборот.Форма.СозданиеБизнесПроцесса", ПараметрыФормы);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗакрытьФорму(Команда)
	Закрыть();
КонецПроцедуры

&НаКлиенте
Процедура Отправить(Команда)
	
	ГотовоКОтправке = ПроверитьПисьмоПередОтправкой();
	
	Если Не ГотовоКОтправке Тогда
		Возврат;
	КонецЕсли;
	
	// Подготовка файлов для передачи
	МассивФайлов = Новый Массив;
	
	Для Каждого Строка Из ДеревоПриложений Цикл
		Если ЗначениеЗаполнено(Строка.АдресВременногоХранилищаФайла) Тогда
			МассивФайлов.Добавить(ПодготовитьФайлСДискаКлиент(Строка));
		Иначе
			МассивФайлов.Добавить(ПодготовитьФайлВДокументообороте(Строка));
		КонецЕсли;
	КонецЦикла;
	
	ОтправитьНаСервере(МассивФайлов);
	ИнтеграцияС1СДокументооборотКлиент.Оповестить_ЗаписьИсходящегоПисьма(ЭтотОбъект);
	ПодключитьОбработчикОжидания("ЗакрытьФормуПриПересылке",0.2, Истина);
	
	Состояние(СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru='Письмо ""%1"" отправлено.'"), Тема));
	
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьАдресат(Команда)
	
	Элементы.Адресаты.ДобавитьСтроку();
	СтрокаДанных = Адресаты.НайтиПоИдентификатору(Элементы.Адресаты.ТекущаяСтрока);
	
	Оповещение = Новый ОписаниеОповещения("ДобавитьАдресатЗавершение", ЭтотОбъект, СтрокаДанных);
	
	ОткрытьФорму("Обработка.ИнтеграцияС1СДокументооборот.Форма.АдреснаяКнига",,СтрокаДанных,,,,
		Оповещение, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьФайл(Команда)
	НачатьДобавлениеФайлаСДиска();
КонецПроцедуры

&НаКлиенте
Процедура УдалитьФайл(Команда)
	ТекущаяСтрока = Элементы.ДеревоПриложений.ТекущиеДанные;
	Если ТекущаяСтрока <> Неопределено Тогда
		ДеревоПриложений.Удалить(ТекущаяСтрока);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьФайл(Команда)
	
	ОткрытьЭлементДереваПриложений(Элементы.ДеревоПриложений.ТекущиеДанные);
	
КонецПроцедуры

&НаКлиенте
Процедура ОснованиеПриИзменении(Элемент)
	Если ЗначениеЗаполнено(Основание) Тогда
		Основание.Открыть();
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура АдресатыАдресатАдресНачалоВыбораЗавершение(РезультатВыбора, ПараметрыОповещения) Экспорт
	
	ОбработатьВыборАдресата(РезультатВыбора);
	
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьАдресатЗавершение(РезультатВыбора, СтрокаДанных) Экспорт
	
	Если ТипЗнч(РезультатВыбора) = Тип("Массив") Тогда
		Если РезультатВыбора.Количество() = 1 Тогда
			ЗаполнитьЗначенияСвойств(СтрокаДанных, РезультатВыбора[0]);
		Иначе
			Для Каждого ЭлементМассива Из РезультатВыбора Цикл
				Если РезультатВыбора.Найти(ЭлементМассива) = 0 Тогда
					ЗаполнитьЗначенияСвойств(СтрокаДанных, РезультатВыбора[0]);
				Иначе
					ТекущаяСтрока = Адресаты.Добавить();
					ЗаполнитьЗначенияСвойств(ТекущаяСтрока,ЭлементМассива);
					ТекущаяСтрока.ТипАдреса =  СтрокаДанных.ТипАдреса;
				КонецЕсли;
			КонецЦикла;
		КонецЕсли;
	КонецЕсли;
	
	ОтменаРедактирования = Ложь;
	Элементы.Адресаты.ЗакончитьРедактированиеСтроки(ОтменаРедактирования);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьЭлементДереваПриложений(Строка)
	
	Если Строка <> Неопределено Тогда
		Если ЗначениеЗаполнено(Строка.СсылкаID) Тогда
			ИнтеграцияС1СДокументооборотБазоваяФункциональностьКлиент.ОткрытьФайл(
				Строка.СсылкаID,
				Строка.Ссылка,
				Строка.Расширение,
				УникальныйИдентификатор);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьФормуИзОбъектаXDTO(ПисьмоXDTO, НовоеПисьмо = Ложь)
	
	ID = ПисьмоXDTO.objectID.ID;
	Тип = ПисьмоXDTO.objectID.type;
	Представление = ПисьмоXDTO.objectID.presentation;
	Тема = ПисьмоXDTO.subject;
	ТекстПисьма = ПисьмоXDTO.body;
	
	// заполняется ли свойство sent?
	Если ИнтеграцияС1СДокументооборотБазоваяФункциональностьПовтИсп.ДоступенФункционалВерсииСервиса("1.3.2.3") Тогда
		Отправлено = ПисьмоXDTO.sent;
		Если Не Отправлено И Не НовоеПисьмо Тогда // преобразуем HTML в plaintext
			ТекстПисьмаФорматированный.УстановитьHTML(ПисьмоXDTO.body, Новый Структура);
			ТекстПисьма = ТекстПисьмаФорматированный.ПолучитьТекст();
		КонецЕсли;
	Иначе
		Отправлено = Истина;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ПисьмоXDTO.objectID.ID) Тогда
		ДобавитьАдресатов(ПисьмоXDTO.senderAddress, НСтр("ru='От:'"));
	Иначе
		Отправитель = ПисьмоXDTO.senderAddress;
	КонецЕсли;
	
	ДобавитьАдресатов(ПисьмоXDTO.recipients, НСтр("ru='Кому:'"));
	ДобавитьАдресатов(ПисьмоXDTO.courtesyCopyRecipients, НСтр("ru='Копия:'"));
	ДобавитьАдресатов(ПисьмоXDTO.blindCourtesyCopyRecipients, НСтр("ru='СК:'"));
	
	ДатаСоздания = ПисьмоXDTO.creationDate;
	ИнтеграцияС1СДокументооборотБазоваяФункциональность.ЗаполнитьОбъектныйРеквизит(ЭтотОбъект, ПисьмоXDTO.importance,"Важность");
	ИнтеграцияС1СДокументооборотБазоваяФункциональность.ЗаполнитьОбъектныйРеквизит(ЭтотОбъект, ПисьмоXDTO.target,"Предмет");
	
	Если Не ЗначениеЗаполнено(ПредметID) Тогда
		Предмет = "Нет";
		Элементы.Предмет.Гиперссылка = Ложь;
		Элементы.Основание.Видимость = Ложь;
	Иначе
		Основания = ИнтеграцияС1СДокументооборотБазоваяФункциональность.СсылкиПоВнешнимОбъектам(ПисьмоXDTO.target);
		Если Основания.Количество() = 0 Тогда
			Элементы.Основание.Видимость = Ложь;
		Иначе
			Основание = Основания[0];
		КонецЕсли;
	КонецЕсли;
	
	Если ПисьмоXDTO.Установлено("answerType") Тогда
		ИнтеграцияС1СДокументооборотБазоваяФункциональность.ЗаполнитьОбъектныйРеквизит(
			ЭтотОбъект, ПисьмоXDTO.answerType,"ТипОтвета");
	КонецЕсли;
	
	Если ТипОтветаID = "ПересылкаПисьма" Или Не ЗначениеЗаполнено(ТипОтветаID) Тогда //@NON-NLS-1
		Элементы.ПисьмоОснование.Видимость = Ложь;
	КонецЕсли;
	
	Если ПисьмоXDTO.Установлено("baseObject") Тогда
		ИнтеграцияС1СДокументооборотБазоваяФункциональность.ЗаполнитьОбъектныйРеквизит(
			ЭтотОбъект, ПисьмоXDTO.baseObject,"ПисьмоОснование");
	Иначе
		Элементы.ПисьмоОснование.Видимость = Ложь;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ПисьмоXDTO.subject) Тогда
		Заголовок = СтрШаблон(НСтр("ru='%1 (Исходящее письмо)'"), ПисьмоXDTO.subject);
	Иначе
		Заголовок = ПисьмоXDTO.objectID.presentation;
	КонецЕсли;
	
	Если ПисьмоXDTO.Свойства().Получить("files") <> Неопределено Тогда
		Для Каждого Файл Из ПисьмоXDTO.files Цикл
			Строка = ДеревоПриложений.Добавить();
			ИнтеграцияС1СДокументооборотБазоваяФункциональность.ЗаполнитьОбъектныйРеквизит(Строка, Файл, "Ссылка");
			Строка.Расширение = Файл.extension;
			Строка.ВремяИзменения = Файл.modificationDateUniversal;
			Строка.Размер = Файл.size;
			
			ПометкаУдаления = Ложь;
			Если ИнтеграцияС1СДокументооборотБазоваяФункциональность.СвойствоУстановлено(Файл, "deletionMark") Тогда
				ПометкаУдаления = Файл.deletionMark;
			КонецЕсли;
			Строка.КартинкаТипаОбъекта =
				ИнтеграцияС1СДокументооборотБазоваяФункциональность.ИндексПиктограммыФайла(
					Строка.Расширение,
					ПометкаУдаления);
			
			УстановитьКартинкуТипаОбъекта(Строка);
		КонецЦикла;
	КонецЕсли;
	
	Обработки.ИнтеграцияС1СДокументооборотБазоваяФункциональность.УстановитьНавигационнуюСсылку(ЭтотОбъект, ПисьмоXDTO);
	
КонецПроцедуры

&НаСервере
Процедура ДобавитьАдресатов(СтрокаАдресатов, ТипАдреса)
	
	Если Не ПустаяСтрока(СтрокаАдресатов) Тогда
		МассивАдресатов = СтрРазделить(СтрокаАдресатов, ";", Ложь);
		Для Каждого Адресат Из МассивАдресатов Цикл
			Если Не ПустаяСтрока(СокрЛП(Адресат)) Тогда 
				СтрокаАдресата = Адресаты.Добавить();
				СтрокаАдресата.ТипАдреса = ТипАдреса;
				СтрокаАдресата.Адресат = СокрЛП(Адресат);
				СтрокаАдресата.АдресатТип = "DMObject";
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьКартинкуТипаОбъекта(СтрокаПредмета)
	Если Найти(СтрокаПредмета.СсылкаТип,"Документ.") <> 0 Тогда
		СтрокаПредмета.КартинкаТипаОбъекта = БиблиотекаКартинок.Документ;
	ИначеЕсли Найти(СтрокаПредмета.СсылкаТип,"Справочник.") <> 0 Тогда
		СтрокаПредмета.КартинкаТипаОбъекта = БиблиотекаКартинок.Справочник
	ИначеЕсли Найти(СтрокаПредмета.СсылкаТип,"БизнесПроцесс.") <> 0 Тогда
		СтрокаПредмета.КартинкаТипаОбъекта = БиблиотекаКартинок.БизнесПроцесс;
	ИначеЕсли Найти(СтрокаПредмета.СсылкаТип,"Задача.") <> 0 Тогда
		СтрокаПредмета.КартинкаТипаОбъекта = БиблиотекаКартинок.Задача;
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьКарточкуНовогоПисьма(Прокси, Параметры)
	
	Если Параметры.Предмет.type = "DMIncomingEMail" Тогда
		НовыйОбъект = ПолучитьОтветНаВходящееПисьмо(Прокси, Параметры);
		
	ИначеЕсли Параметры.Предмет.type = "DMOutgoingEMail"
			И Параметры.Свойство("answerType") <> Неопределено
			И Параметры.answerType = "transfer" Тогда
		НовыйОбъект = ПолучитьИсходящееПисьмоДляПересылки(Прокси, Параметры);
		
	Иначе
		НовыйОбъект = ИнтеграцияС1СДокументооборотБазоваяФункциональность.ПолучитьНовыйОбъект(
			Прокси,
			"DMOutgoingEMail",
			Параметры.Предмет);
	КонецЕсли;
	
	ЗаполнитьФормуИзОбъектаXDTO(НовыйОбъект, Истина);
	
КонецПроцедуры

&НаСервере
Функция ПолучитьОтветНаВходящееПисьмо(Прокси, Параметры)
	
	Запрос = ИнтеграцияС1СДокументооборотБазоваяФункциональность.СоздатьОбъект(Прокси, "DMGetIncomingEMailAnswerRequest");
	Запрос.type = "DMOutgoingEmail";
	
	Запрос.targetID = ИнтеграцияС1СДокументооборотБазоваяФункциональность.СоздатьObjectID(
		Прокси,
		Параметры.Предмет.ID,
		Параметры.Предмет.type);
	
	Запрос.answerType = Параметры.answerType;
	
	Ответ = ИнтеграцияС1СДокументооборотБазоваяФункциональность.ВыполнитьЗапрос(Прокси, Запрос);
	ИнтеграцияС1СДокументооборотБазоваяФункциональность.ПроверитьВозвратВебСервиса(Прокси, Ответ);
	
	Если ИнтеграцияС1СДокументооборотБазоваяФункциональность.ПроверитьТип(Прокси, Ответ, "DMGetIncomingEMailAnswerResponse") Тогда
		Возврат Ответ.object;
	КонецЕсли;
	
КонецФункции

&НаСервере
Функция ПолучитьИсходящееПисьмоДляПересылки(Прокси, Параметры)
	
	Запрос = ИнтеграцияС1СДокументооборотБазоваяФункциональность.СоздатьОбъект(Прокси, "DMGetOutgoingEMailForwardRequest");
	Запрос.type = "DMOutgoingEmail";
	
	Запрос.targetID = ИнтеграцияС1СДокументооборотБазоваяФункциональность.СоздатьObjectID(
		Прокси,
		Параметры.Предмет.ID,
		Параметры.Предмет.type);
	
	Ответ = ИнтеграцияС1СДокументооборотБазоваяФункциональность.ВыполнитьЗапрос(Прокси, Запрос);
	ИнтеграцияС1СДокументооборотБазоваяФункциональность.ПроверитьВозвратВебСервиса(Прокси, Ответ);
	
	Если ИнтеграцияС1СДокументооборотБазоваяФункциональность.ПроверитьТип(Прокси, Ответ, "DMGetOutgoingEMailForwardResponse") Тогда
		Возврат Ответ.object;
	КонецЕсли;
	
КонецФункции

&НаСервере
Процедура ОтобразитьКоличествоФайловСервер()
	
	Если ДеревоПриложений.Количество() > 0 Тогда
		Элементы.ДеревоПриложенийСсылка.Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Файлы (%1)'"),
			ДеревоПриложений.Количество());
	Иначе
		Элементы.ДеревоПриложенийСсылка.Заголовок = НСтр("ru = 'Файлы'");
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОтправитьНаСервере(МассивФайлов)
	
	Прокси = ИнтеграцияС1СДокументооборотБазоваяФункциональностьПовтИсп.ПолучитьПрокси();
	
	Письмо = ИнтеграцияС1СДокументооборотБазоваяФункциональность.СоздатьОбъект(Прокси, "DMOutgoingEMail");
	ПрисоединенныеФайлы = Письмо.files; // СписокXDTO
	
	Письмо.name = Тема;
	Письмо.subject = Тема;
	Письмо.body = ТекстПисьма;
	Письмо.creationDate = ТекущаяДатаСеанса();
	Письмо.objectID = ИнтеграцияС1СДокументооборотБазоваяФункциональность.СоздатьObjectID(Прокси, "", "DMOutgoingEMail");
	
	Если ЗначениеЗаполнено(ПисьмоОснование) Тогда
		Обработки.ИнтеграцияС1СДокументооборот.ЗаполнитьОбъектXDTOИзОбъектногоРеквизита(
			Прокси, ЭтотОбъект, "ПисьмоОснование", Письмо.baseObject, "DMObject");
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ТипОтвета) Тогда
		Обработки.ИнтеграцияС1СДокументооборот.ЗаполнитьОбъектXDTOИзОбъектногоРеквизита(
			Прокси, ЭтотОбъект, "ТипОтвета", Письмо.answerType, "DMEMailAnswerType");
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Предмет) Тогда
		Обработки.ИнтеграцияС1СДокументооборот.ЗаполнитьОбъектXDTOИзОбъектногоРеквизита(
			Прокси, ЭтотОбъект, "Предмет", Письмо.target, "DMObject");
	КонецЕсли;
	
	Обработки.ИнтеграцияС1СДокументооборот.ЗаполнитьОбъектXDTOИзОбъектногоРеквизита(
		Прокси, ЭтотОбъект, "Важность", Письмо.importance, "DMEMailImportance");
	
	Письмо.recipients = ПолучитьСтрокуПолучателей("Кому:");
	Письмо.courtesyCopyRecipients = ПолучитьСтрокуПолучателей("Копия:");
	Письмо.blindCourtesyCopyRecipients = ПолучитьСтрокуПолучателей("СК:");
	
	Письмо.readyToBeSent = ТекущаяДатаСеанса();
	Письмо.senderAddress = Отправитель;
	
	// передача файлов
	Для Каждого ПараметрыФайла Из МассивФайлов Цикл
		ПрисоединенныеФайлы.Добавить(ПодготовитьФайлКОтправке(Прокси, ПараметрыФайла));
	КонецЦикла;
	
	Запрос = ИнтеграцияС1СДокументооборотБазоваяФункциональность.СоздатьОбъект(Прокси, "DMCreateRequest");
	Запрос.object = Письмо;
	Результат = ИнтеграцияС1СДокументооборотБазоваяФункциональность.ВыполнитьЗапрос(Прокси, Запрос);
	ИнтеграцияС1СДокументооборотБазоваяФункциональность.ПроверитьВозвратВебСервиса(Прокси, Результат);
	
КонецПроцедуры

&НаСервере
Функция ПолучитьСтрокуПолучателей(ТипАдреса)
	
	СтрокиПолучателей = Адресаты.НайтиСтроки(Новый Структура("ТипАдреса",ТипАдреса));
	АдресатыСтрокой = "";
	Для Каждого Строка Из СтрокиПолучателей Цикл
		АдресатыСтрокой = АдресатыСтрокой + Строка.Адресат + "; ";
	КонецЦикла;
	
	Возврат АдресатыСтрокой;
	
КонецФункции

&НаКлиенте
Функция ПодготовитьФайлСДискаКлиент(Строка)
	
	ТекущийФайл = ИнтеграцияС1СДокументооборотБазоваяФункциональностьКлиентСервер.ДанныеФайла(
		Строка.Ссылка,
		Неопределено,
		"DMFile",
		Строка.Расширение);
	ТекущийФайл.Размер = Строка.Размер;
	ТекущийФайл.ДатаМодификации = Строка.ВремяИзменения;
	ТекущийФайл.ДатаМодификацииУниверсальная = Строка.ВремяИзмененияУниверсальное;
	
	ПараметрыСоздания = ИнтеграцияС1СДокументооборотБазоваяФункциональностьКлиентСервер.НовыеПараметрыСозданияФайла(
		ТекущийФайл);
	ПараметрыСоздания.АдресВременногоХранилищаФайла = Строка.АдресВременногоХранилищаФайла;
	
	Возврат ПараметрыСоздания;
	
КонецФункции

&НаКлиенте
Функция ПодготовитьФайлВДокументообороте(Строка)
	
	ТекущийФайл = ИнтеграцияС1СДокументооборотБазоваяФункциональностьКлиентСервер.ДанныеФайла(
		Строка.Ссылка,
		Строка.СсылкаID,
		Строка.СсылкаТип,
		Строка.Расширение);
	ТекущийФайл.Размер = Строка.Размер;
	ТекущийФайл.ДатаМодификации = Строка.ВремяИзменения;
	ТекущийФайл.ДатаМодификацииУниверсальная = Строка.ВремяИзмененияУниверсальное;
	
	ПараметрыСоздания = ИнтеграцияС1СДокументооборотБазоваяФункциональностьКлиентСервер.НовыеПараметрыСозданияФайла(
		ТекущийФайл);
	
	Возврат ПараметрыСоздания;
	
КонецФункции

&НаКлиенте
Процедура НачатьДобавлениеФайлаСДиска()
	
	НачатьПодключениеРасширенияРаботыСФайлами(Новый ОписаниеОповещения(
		"НачатьДобавлениеФайлаСДискаПослеПодключенияРасширения", ЭтотОбъект));
	
КонецПроцедуры

&НаКлиенте
Процедура НачатьДобавлениеФайлаСДискаПослеПодключенияРасширения(Подключено, ПараметрыОповещения) Экспорт
	
	Если Подключено Тогда
		
		ВыборФайла = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Открытие);
		ВыборФайла.МножественныйВыбор = Истина;
		ВыборФайла.Заголовок = НСтр("ru = 'Выбор файла'");
		ВыборФайла.Фильтр = НСтр("ru = 'Все файлы (*.*)|*.*'");
		ВыборФайла.Показать(Новый ОписаниеОповещения(
			"НачатьДобавлениеФайлаСДискаПослеДиалогаВыбораФайла", ЭтотОбъект));
		
	Иначе
		
		ПоказатьПредупреждение(, НСтр("ru = 'Необходимо подключить расширение для работы файлами.'"));
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура НачатьДобавлениеФайлаСДискаПослеДиалогаВыбораФайла(ПолныеИменаФайлов, ПараметрыОповещения) Экспорт
	
	Если ПолныеИменаФайлов <> Неопределено Тогда
		НачатьДобавлениеФайлаСДискаПоМассивуИмен(ПолныеИменаФайлов);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура НачатьДобавлениеФайлаСДискаПоМассивуИмен(ПолныеИменаФайлов)
	
	ПараметрыОповещения = Новый Структура;
	ПараметрыОповещения.Вставить("ОписанияФайлов", Новый Массив);
	Для Каждого ПолноеИмяФайла Из ПолныеИменаФайлов Цикл
		ОписаниеФайла = Новый Структура;
		ОписаниеФайла.Вставить("ПолноеИмяФайла", ПолноеИмяФайла);
		// Разберем полный путь на имя и расширение.
		СтруктураИмени = ИнтеграцияС1СДокументооборотБазоваяФункциональностьКлиент.РазложитьПолноеИмяФайла(
			ПолноеИмяФайла);
		ОписаниеФайла.Вставить("Расширение", СтруктураИмени.Расширение);
		ОписаниеФайла.Вставить("Имя", СтруктураИмени.ИмяБезРасширения);
		ОписаниеФайла.Вставить("КартинкаТипаОбъекта",
			ИнтеграцияС1СДокументооборотБазоваяФункциональностьКлиент.ИндексПиктограммыФайла(
				СтруктураИмени.Расширение));
		ПараметрыОповещения.ОписанияФайлов.Добавить(ОписаниеФайла);
	КонецЦикла;
	ПараметрыОповещения.Вставить("НомерФайла", 0);
	
	Файл = Новый Файл(ПараметрыОповещения.ОписанияФайлов[0].ПолноеИмяФайла);
	ПараметрыОповещения.ОписанияФайлов[0].Вставить("Файл", Файл);
	
	Файл.НачатьПолучениеРазмера(
		Новый ОписаниеОповещения("НачатьДобавлениеФайлаСДискаПослеПолученияРазмера",
			ЭтотОбъект, ПараметрыОповещения));
	
КонецПроцедуры

&НаКлиенте
Процедура НачатьДобавлениеФайлаСДискаПослеПолученияРазмера(Размер, ПараметрыОповещения) Экспорт
	
	ОписаниеФайла = ПараметрыОповещения.ОписанияФайлов[ПараметрыОповещения.НомерФайла];
	ОписаниеФайла.Вставить("Размер", Размер);
	ОписаниеФайла.Файл.НачатьПолучениеВремениИзменения(
		Новый ОписаниеОповещения("НачатьДобавлениеФайлаСДискаПослеПолученияВремениИзменения",
			ЭтотОбъект, ПараметрыОповещения));
	
КонецПроцедуры

&НаКлиенте
Процедура НачатьДобавлениеФайлаСДискаПослеПолученияВремениИзменения(ВремяИзменения, ПараметрыОповещения) Экспорт
	
	ОписаниеФайла = ПараметрыОповещения.ОписанияФайлов[ПараметрыОповещения.НомерФайла];
	ОписаниеФайла.Вставить("ВремяИзменения", ВремяИзменения);
	ОписаниеФайла.Файл.НачатьПолучениеУниверсальногоВремениИзменения(
		Новый ОписаниеОповещения("НачатьДобавлениеФайлаСДискаПослеПолученияУниверсальногоВремениИзменения",
			ЭтотОбъект, ПараметрыОповещения));
	
КонецПроцедуры

&НаКлиенте
Процедура НачатьДобавлениеФайлаСДискаПослеПолученияУниверсальногоВремениИзменения(ВремяИзмененияУниверсальное,
		ПараметрыОповещения) Экспорт
	
	ОписаниеФайла = ПараметрыОповещения.ОписанияФайлов[ПараметрыОповещения.НомерФайла];
	ОписаниеФайла.Вставить("ВремяИзмененияУниверсальное", ВремяИзмененияУниверсальное);
	
	// Есть ли еще файлы?
	Если ПараметрыОповещения.НомерФайла < ПараметрыОповещения.ОписанияФайлов.Количество() - 1 Тогда
		ПараметрыОповещения.НомерФайла = ПараметрыОповещения.НомерФайла + 1;
		Файл = Новый Файл(ПараметрыОповещения.ОписанияФайлов[ПараметрыОповещения.НомерФайла].ПолноеИмяФайла);
		ПараметрыОповещения.ОписанияФайлов[ПараметрыОповещения.НомерФайла].Вставить("Файл", Файл);
		
		Файл.НачатьПолучениеРазмера(
			Новый ОписаниеОповещения("НачатьДобавлениеФайлаСДискаПослеПолученияРазмера",
				ЭтотОбъект, ПараметрыОповещения));
	Иначе
		ПомещаемыеФайлы = Новый Массив;
		Для Каждого ОписаниеФайла Из ПараметрыОповещения.ОписанияФайлов Цикл
			ПомещаемыеФайлы.Добавить(Новый ОписаниеПередаваемогоФайла(ОписаниеФайла.ПолноеИмяФайла, ""));
		КонецЦикла;
		НачатьПомещениеФайлов(
			Новый ОписаниеОповещения("НачатьДобавлениеФайлаСДискаПослеПомещенияФайлов",
				ЭтотОбъект, ПараметрыОповещения),
			ПомещаемыеФайлы,,
			Ложь,
			УникальныйИдентификатор);
	КонецЕсли;
	
КонецПроцедуры

// Продолжение процедуры НачатьДобавлениеФайлаСДискаПослеПолученияУниверсальногоВремениИзменения.
//
// Параметры:
//   ПомещенныеФайлы - Массив из ОписаниеПереданногоФайла
//   ПараметрыОповещения - Структура:
//     * ОписанияФайлов - Массив из Структура:
//         ** ПолноеИмяФайла - Строка
//         ** Расширение - Строка
//         ** Имя - Строка
//         ** КартинкаТипаОбъекта - Число
//     * НомерФайла - Число
//
&НаКлиенте
Процедура НачатьДобавлениеФайлаСДискаПослеПомещенияФайлов(ПомещенныеФайлы, ПараметрыОповещения) Экспорт
	
	Для НомерФайла = 0 По ПомещенныеФайлы.Количество() - 1 Цикл
		ПомещенныйФайл = ПомещенныеФайлы[НомерФайла];
		ОписаниеФайла = ПараметрыОповещения.ОписанияФайлов[НомерФайла];
		НоваяСтрока = ДеревоПриложений.Добавить();
		НоваяСтрока.Ссылка = ОписаниеФайла.Имя;
		НоваяСтрока.Расширение = ОписаниеФайла.Расширение;
		НоваяСтрока.КартинкаТипаОбъекта = ОписаниеФайла.КартинкаТипаОбъекта;
		НоваяСтрока.Размер = ОписаниеФайла.Размер;
		НоваяСтрока.ВремяИзменения = ОписаниеФайла.ВремяИзменения;
		НоваяСтрока.ВремяИзмененияУниверсальное = ОписаниеФайла.ВремяИзмененияУниверсальное;
		НоваяСтрока.АдресВременногоХранилищаФайла = ПомещенныйФайл.Хранение;
	КонецЦикла;
	
КонецПроцедуры

// Создает XDTO объект типа DMFile.
//
// Параметры:
//   Прокси - WSПрокси - объект для подключения к web-сервисам Документооборота.
//   ПараметрыСоздания - Структура - ИнтеграцияС1СДокументооборотБазоваяФункциональностьКлиентСервер.НовыеПараметрыСозданияФайла
//
// Возвращаемое значение:
//   ОбъектXDTO
//
&НаСервере
Функция ПодготовитьФайлКОтправке(Прокси, ПараметрыСоздания)
	
	Файл = ИнтеграцияС1СДокументооборотБазоваяФункциональность.СоздатьОбъект(Прокси, "DMFile");
	
	Файл.objectID = ИнтеграцияС1СДокументооборотБазоваяФункциональность.СоздатьObjectID(Прокси, "", "DMFile");
	Файл.name = ПараметрыСоздания.ТекущийФайл.Наименование;
	
	Если ЗначениеЗаполнено(ПараметрыСоздания.ТекущийФайл.ID) Тогда
		Файл.objectID.ID = ПараметрыСоздания.ТекущийФайл.ID;
	Иначе
		Файл.binaryData = ПолучитьИзВременногоХранилища(ПараметрыСоздания.АдресВременногоХранилищаФайла);
		Файл.extension = ПараметрыСоздания.ТекущийФайл.Расширение;
		Файл.modificationDate = ПараметрыСоздания.ТекущийФайл.ДатаМодификации;
		Файл.modificationDateUniversal = ПараметрыСоздания.ТекущийФайл.ДатаМодификацииУниверсальная;
		Файл.size = ПараметрыСоздания.ТекущийФайл.Размер;
		Если Не ПустаяСтрока(ПараметрыСоздания.ТекущийФайл.Текст) Тогда
			Файл.text = ПараметрыСоздания.ТекущийФайл.Текст;
		КонецЕсли;
	КонецЕсли;
	
	Возврат Файл;
	
КонецФункции

&НаКлиенте
Процедура ЗакрытьФормуПриПересылке()
	
	Закрыть();
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура ДанныеДляАвтоПодбораАдресата(ДанныеВыбора, Текст, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ДанныеВыбора = Новый СписокЗначений;
	
	Прокси = ИнтеграцияС1СДокументооборотБазоваяФункциональностьПовтИсп.ПолучитьПрокси();
	Запрос = ИнтеграцияС1СДокументооборотБазоваяФункциональность.СоздатьОбъект(Прокси, "DMGetRecipientsListByNameRequest");
	Запрос.query = Текст;
	
	Результат = ИнтеграцияС1СДокументооборотБазоваяФункциональность.ВыполнитьЗапрос(Прокси, Запрос);
	ИнтеграцияС1СДокументооборотБазоваяФункциональность.ПроверитьВозвратВебСервиса(Прокси, Результат);
	
	НайденныеЗначения =  Результат.items;
	
	Для Каждого НайденноеЗначение Из НайденныеЗначения Цикл
		
		ДанныеДляВыбора = Новый Структура;
		ДанныеДляВыбора.Вставить("ID", "");
		ДанныеДляВыбора.Вставить("type", "DMObject");
		ДанныеДляВыбора.Вставить("name", НайденноеЗначение);
		ДанныеВыбора.Добавить(ДанныеДляВыбора, НайденноеЗначение);
		
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьТекущийЭлементПолучатель()
		
	АвтоматическиНачатоРедактированиеАдреса = Истина;
	Элементы.Адресаты.ДобавитьСтроку();
	Модифицированность = Ложь;
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьТекущийЭлементТема()
	
	ТекущийЭлемент = Элементы.Тема;
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьТекущийЭлементТекст()
	
	ТекущийЭлемент = Элементы.Тема;
	
	Если ЗначениеЗаполнено(ID) Тогда
		ТекущийЭлемент = Элементы.HTMLПредставление;
	Иначе
		ТекущийЭлемент = Элементы.ПростойТекст;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработатьВыборАдресата(РезультатВыбора)
	
	Если ТипЗнч(РезультатВыбора) = Тип("Массив") Тогда
		Если РезультатВыбора.Количество() = 1 Тогда
			ЗаполнитьЗначенияСвойств(Элементы.Адресаты.ТекущиеДанные, РезультатВыбора[0]);
			Элементы.Адресаты.ТекущиеДанные.НеНайден = Ложь;
		Иначе
			Для Каждого ЭлементМассива Из РезультатВыбора Цикл
				Если РезультатВыбора.Найти(ЭлементМассива) = 0 Тогда
					ЗаполнитьЗначенияСвойств(Элементы.Адресаты.ТекущиеДанные, РезультатВыбора[0]);
					Элементы.Адресаты.ТекущиеДанные.НеНайден = Ложь;
				Иначе
					ТекущаяСтрока = Адресаты.Добавить();
					ЗаполнитьЗначенияСвойств(ТекущаяСтрока,ЭлементМассива);
					ТекущаяСтрока.ТипАдреса =  Элементы.Адресаты.ТекущиеДанные.ТипАдреса;
				КонецЕсли;
			КонецЦикла;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ПроверитьПисьмоПередОтправкой()
	
	КодВозврата = Истина;
	
	СписокАдресов = Новый Массив;
	Для Каждого Стр Из Адресаты Цикл
		Если ЗначениеЗаполнено(Стр.Адресат) Тогда
			СписокАдресов.Добавить(Стр.Адресат);
		КонецЕсли;
	КонецЦикла;
	
	Если СписокАдресов.Количество() = 0 Тогда
		
		ОбщегоНазначения.СообщитьПользователю(
			НСтр("ru = 'Нельзя отправить письмо. Необходимо указать хотя бы одного получателя.'"),,
				"Адресаты");
		
		КодВозврата = Ложь;
		
	КонецЕсли;
	
	Если ПустаяСтрока(Тема) Тогда
		
		ОбщегоНазначения.СообщитьПользователю(
			НСтр("ru = 'Нельзя отправить письмо. Не заполнена тема.'"),,
			"Тема");
		
		КодВозврата = Ложь;
		
	КонецЕсли;
	
	Если КодВозврата = Ложь Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Возврат Истина;
	
КонецФункции

#КонецОбласти