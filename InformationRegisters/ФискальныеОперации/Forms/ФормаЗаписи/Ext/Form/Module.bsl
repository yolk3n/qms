﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	Реквизиты = ОборудованиеЧекопечатающиеУстройстваВызовСервера.ДанныеФискальнойОперации(Запись.ДокументОснование, Запись.ИдентификаторЗаписи);
	Если Реквизиты <> Неопределено Тогда
		ТекстСообщенияXML = Реквизиты.ДанныеXML.Получить();
	КонецЕсли;
	
	Элементы.КорректируемыйДокумент.Видимость = Не ПустаяСтрока(Запись.КорректируемыйДокумент);
	
	Если ЗначениеЗаполнено(ТекстСообщенияXML) 
		И (Реквизиты.ТипДокумента = Перечисления.ТипыФискальныхДокументовККТ.КассовыйЧек 
		Или Реквизиты.ТипДокумента = Перечисления.ТипыФискальныхДокументовККТ.КассовыйЧекКоррекции)
	Тогда
		ПараметрыФорматирования = Новый ПараметрыЗаписиXML("UTF-8", "1.0", Истина, Истина, "  ");
		ТекстXML.УстановитьТекст(ФорматироватьXMLСПараметрами(ТекстСообщенияXML, ПараметрыФорматирования));
		Элементы.Страницы.ОтображениеСтраниц = ОтображениеСтраницФормы.ЗакладкиСверху;
		Элементы.Дополнительно.Видимость = Истина;
		
		ОбщиеПараметры = ОборудованиеЧекопечатающиеУстройстваВызовСервера.ЗагрузитьДанныеФискализацииИзXML(ТекстСообщенияXML);
		ОбщиеПараметры.ДатаВремя = Реквизиты.Дата;
		Если ЗначениеЗаполнено(ОбщиеПараметры.ПокупательEmail) Тогда
			ЭлектроннаяПочта = ОбщиеПараметры.ПокупательEmail;
		Иначе
			ЭлектроннаяПочта = ПустаяСтрокаПочты();
		КонецЕсли;
		
		ТабличныйДокумент = ОборудованиеЧекопечатающиеУстройстваВызовСервера.СформироватьФискальныйДокумент(0, ОбщиеПараметры, Реквизиты);
		
	Иначе
		Элементы.Страницы.ОтображениеСтраниц = ОтображениеСтраницФормы.Нет;            
		Элементы.Дополнительно.Видимость = Ложь;
		Элементы.ГруппаДокументы.Видимость = Ложь;
	КонецЕсли;
	
	МенеджерОборудованияВызовСервераПереопределяемый.ЭкземплярФискальныеОперацииПриСозданииНаСервере(Запись, ЭтаФорма, Отказ, Параметры, СтандартнаяОбработка);
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	// СтандартныеПодсистемы.УправлениеДоступом
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.УправлениеДоступом") Тогда
		МодульУправлениеДоступом = ОбщегоНазначения.ОбщийМодуль("УправлениеДоступом");
		МодульУправлениеДоступом.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.УправлениеДоступом
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	// СтандартныеПодсистемы.УправлениеДоступом
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.УправлениеДоступом") Тогда
		МодульУправлениеДоступом = ОбщегоНазначения.ОбщийМодуль("УправлениеДоступом");
		МодульУправлениеДоступом.ПослеЗаписиНаСервере(ЭтотОбъект, ТекущийОбъект, ПараметрыЗаписи);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.УправлениеДоступом
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОтправитьНаПочту(Команда)
	
	Если ЭлектроннаяПочта = ПустаяСтрокаПочты() Тогда   
		ОбщегоНазначенияКлиент.СообщитьПользователю(НСтр("ru = 'Электронная почта не указана.'"));
		Возврат;
	КонецЕсли;
	
	МодульРассылкаЭлектронныхЧековВызовСервера = ОбщегоНазначенияКлиент.ОбщийМодуль("РассылкаЭлектронныхЧековВызовСервера");
	Если МодульРассылкаЭлектронныхЧековВызовСервера <> Неопределено Тогда
		ПараметрыЧека = Новый Структура();
		ПараметрыЧека.Вставить("НомерЧекаККТ", Запись.НомерЧекаККМ);
		ПараметрыЧека.Вставить("ИдентификаторФискальнойЗаписи", Запись.ИдентификаторЗаписи);
		ТекстСообщения = "";
		МодульРассылкаЭлектронныхЧековВызовСервера.НачатьОтправкуЭлектронногоЧека(
			ПараметрыЧека,
			ТекстСообщения, 
			ЭлектроннаяПочта,
			"");
		ОбщегоНазначенияКлиент.СообщитьПользователю(НСтр("ru = 'Электронный чек отправлен.'"));
	КонецЕсли;
		
КонецПроцедуры

&НаКлиенте
Процедура СохранитьPDF(Команда)
	
	// АПК: 1348-выкл БСП может не использоваться
	Оповещение = Новый ОписаниеОповещения("СохранитьPDF_ДиалогВыбораФайла", ЭтотОбъект);
	Диалог = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Сохранение);
	Диалог.Расширение = "pdf";
	Диалог.Фильтр = "Файлы PDF (*.pdf)|*.pdf|Все файлы|*.*";
	Диалог.Показать(Оповещение);
	// АПК: 1348-вкл
	
КонецПроцедуры

&НаКлиенте
Процедура СохранитьPDF_ДиалогВыбораФайла(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ИмяФайла = Результат[0];
	ТабличныйДокумент.НачатьЗапись(Новый ОписаниеОповещения("СохранитьPDF_Завершение", ЭтотОбъект), ИмяФайла, ТипФайлаТабличногоДокумента.PDF);

КонецПроцедуры

&НаКлиенте
Процедура СохранитьPDF_Завершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Не Результат Тогда
		ОбщегоНазначенияКлиент.СообщитьПользователю(НСтр("ru = 'Не удалось записать файл.'"));
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПечатьКопииЧека(Команда)

	ПараметрыОперации = ОборудованиеЧекопечатающиеУстройстваКлиентСервер.ПараметрыПечатьКопииЧека();  
	ПараметрыОперации.ФискальныйПризнак = Запись.ФискальныйПризнак;     
	ПараметрыОперации.Аппаратно = Ложь;
	ПараметрыОперации.НомерЧека = Запись.НомерЧекаККМ;   
	
	Доступность = Ложь;
	
	ОповещениеПриЗавершении = Новый ОписаниеОповещения("ПечатьКопииЧека_Завершение", ЭтотОбъект);
	ОборудованиеЧекопечатающиеУстройстваКлиент.НачатьПечатьКопииЧека(ОповещениеПриЗавершении, УникальныйИдентификатор, Неопределено, ПараметрыОперации);
	
КонецПроцедуры

&НаКлиенте
Процедура ПечатьКопииЧека_Завершение(РезультатВыполнения, Параметры) Экспорт
	
	Доступность = Истина;
	
	ОчиститьСообщения();
	
	Если НЕ РезультатВыполнения.Результат Тогда
		ТекстСообщения = РезультатВыполнения.ОписаниеОшибки;
		ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения);
	КонецЕсли; 
	
КонецПроцедуры

#КонецОбласти                 

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура АдресПочтыНажатие(Элемент, СтандартнаяОбработка)    
	
	СтандартнаяОбработка = Ложь;
	Строка = ?(ЭлектроннаяПочта = ПустаяСтрокаПочты(), "", ЭлектроннаяПочта);;
	Оповещение = Новый ОписаниеОповещения("АдресПочтыНажатиеЗавершение", ЭтотОбъект);
	ПоказатьВводСтроки(Оповещение, Строка, НСтр("ru = 'Электронная почта для отправки'"));  
	
КонецПроцедуры

&НаКлиенте
Процедура АдресПочтыНажатиеЗавершение(Строка, ДополнительныеПараметры) Экспорт
	
	Если Строка = Неопределено Тогда
		ЭлектроннаяПочта = ЭлектроннаяПочта;
	Иначе
		Если ПустаяСтрока(Строка) Тогда
			ЭлектроннаяПочта = ПустаяСтрокаПочты();
		Иначе
			ЭлектроннаяПочта = Строка;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти                 

#Область СлужебныеПроцедурыИФункции

// Форматирует текст сообщения в формате XML
//
&НаСервере
Функция ФорматироватьXMLСПараметрами(ТекстСообщенияXML, ПараметрыФорматирования)
	
	ЧтениеXML = Новый ЧтениеXML;
	ЧтениеXML.УстановитьСтроку(ТекстСообщенияXML);
	
	ПостроительDOM = Новый ПостроительDOM;
	ДокументDOM = ПостроительDOM.Прочитать(ЧтениеXML);
	
	ЗаписьXML = Новый ЗаписьXML;
	ЗаписьXML.УстановитьСтроку(ПараметрыФорматирования);
	
	ЗаписьDOM = Новый ЗаписьDOM;
	ЗаписьDOM.Записать(ДокументDOM, ЗаписьXML);
	
	Возврат ЗаписьXML.Закрыть();
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция ПустаяСтрокаПочты()
	
	Возврат НСтр("ru = '<не задано>'"); 

КонецФункции

#КонецОбласти
