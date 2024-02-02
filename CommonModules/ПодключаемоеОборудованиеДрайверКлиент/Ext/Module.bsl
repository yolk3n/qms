﻿
#Область СлужебныйПрограммныйИнтерфейс

#Область НачатьПолучениеОбъектаДрайвера

// Начать получение объекта драйвера.
//
// Параметры:
//  ОповещениеПриЗавершении - ОписаниеОповещения
//  ПараметрыПодключения - см. МенеджерОборудованияКлиент.ПараметрыПодключенияУстройства
//
Процедура НачатьПолучениеОбъектаДрайвера(ОповещениеПриЗавершении, ПараметрыПодключения) Экспорт
	
	ОбъектДрайвера = Неопределено;
	
	ПодключаемоеОборудование = МенеджерОборудованияКлиент.ПодключаемоеОборудование();
	Для Каждого ДрайверОборудования Из ПодключаемоеОборудование.ДрайверыОборудования Цикл
		Если ДрайверОборудования.Ключ = ПараметрыПодключения.ИдентификаторОбъекта  Тогда
			ОбъектДрайвера = ДрайверОборудования.Значение;
			ВыполнитьОбработкуОповещения(ОповещениеПриЗавершении, ОбъектДрайвера);
			Возврат;
		КонецЕсли;      
	КонецЦикла;   
	
	ПараметрыОповещения = Новый Структура("ОповещениеПриЗавершении, ДанныеДрайвера", ОповещениеПриЗавершении, ПараметрыПодключения);
	Оповещение = Новый ОписаниеОповещения("НачатьПолучениеОбъектаДрайвераЗавершение", ЭтотОбъект, ПараметрыОповещения);
	
	ТекстСообщения = НСтр("ru = 'Для продолжения работы требуется установка внешней компоненты ""%Компонента%"".'"); 
	ТекстСообщения = СтрЗаменить(ТекстСообщения, "%Компонента%", ПараметрыПодключения.Наименование); 
	
	Если ПустаяСтрока(ПараметрыПодключения.ИдентификаторОбъекта) Тогда
		ВыполнитьОбработкуОповещения(ОповещениеПриЗавершении, Неопределено);
		Возврат;
	КонецЕсли;  
	
	Если ОбъектДрайвера = Неопределено Тогда
		Если ПараметрыПодключения.ПодключениеИзМакета Тогда    
			Если Не ПараметрыПодключения.МакетДоступен Тогда
				ВыполнитьОбработкуОповещения(ОповещениеПриЗавершении, Неопределено);  
				Возврат;
			КонецЕсли;
			Если МенеджерОборудованияКлиент.ДопустимаУстановкаКомпоненты(ПараметрыПодключения.ИмяМакетаДрайвера) Тогда
				Параметры = ОбщегоНазначенияКлиент.ПараметрыПодключенияКомпоненты();      
				Параметры.ПредложитьУстановить = Истина;
				Параметры.ТекстПояснения = ТекстСообщения;
				Параметры.Кэшировать = Истина;
				ОбщегоНазначенияКлиент.ПодключитьКомпонентуИзМакета(Оповещение, ПараметрыПодключения.ИдентификаторОбъекта, ПараметрыПодключения.ИмяМакетаДрайвера, Параметры);
			Иначе
				ТекстСообщения = СтрШаблон(НСтр("ru = 'Для компоненты %1 не предусмотрена работа в web-клиенте.'"), ПараметрыПодключения.Наименование);
				
				Контекст = Новый Структура();
				Контекст.Вставить("ОповещениеПриЗавершении", ОповещениеПриЗавершении);
				Контекст.Вставить("ТекстСообщения", ТекстСообщения);
				ОповещениеПриНажатии = Новый ОписаниеОповещения("ОповещениеПриОшибкеПодключенияЗавершение", ЭтотОбъект, Контекст);
				
				ПоказатьОповещениеПользователя(
					НСтр("ru = 'Ошибка подключения компоненты.'"),
					ОповещениеПриНажатии,
					ТекстСообщения,
					БиблиотекаКартинок.ОформлениеЗнакКрест,
					СтатусОповещенияПользователя.Важное);
				ВыполнитьОбработкуОповещения(ОповещениеПриЗавершении, Неопределено);  
				Возврат;
			КонецЕсли;
		ИначеЕсли ПараметрыПодключения.ПодключениеЛокальноПоИдентификатору Тогда
			ВнешниеКомпонентыКлиент.ПодключитьКомпонентуИзРеестраWindows(Оповещение,  ПараметрыПодключения.ИдентификаторОбъекта);
		Иначе
			Параметры = ВнешниеКомпонентыКлиент.ПараметрыПодключения();
			Параметры.ТекстПояснения = ТекстСообщения;
			Параметры.Кэшировать = Ложь;
			ВнешниеКомпонентыКлиент.ПодключитьКомпоненту(Оповещение,  ПараметрыПодключения.ИдентификаторОбъекта, ПараметрыПодключения.ВерсияДрайвера, Параметры);
		КонецЕсли;
	КонецЕсли;   
	
КонецПроцедуры

Процедура НачатьПолучениеОбъектаДрайвераЗавершение(РезультатПодключения, ДополнительныеПараметры) Экспорт
	
	ОбъектДрайвера = Неопределено;
	
	Если РезультатПодключения.Подключено Тогда 
		ОбъектДрайвера = РезультатПодключения.ПодключаемыйМодуль;
		ПодключаемоеОборудование = МенеджерОборудованияКлиент.ПодключаемоеОборудование();
		ПодключаемоеОборудование.ДрайверыОборудования.Вставить(ДополнительныеПараметры.ДанныеДрайвера.ИдентификаторОбъекта, ОбъектДрайвера);
	КонецЕсли;
	
	ВыполнитьОбработкуОповещения(ДополнительныеПараметры.ОповещениеПриЗавершении, ОбъектДрайвера);
	
КонецПроцедуры

Процедура ОповещениеПриОшибкеПодключенияЗавершение(Контекст) Экспорт
	ПоказатьПредупреждение(, Контекст.ТекстСообщения,,НСтр("ru = 'Ошибка подключения компоненты.'"));
КонецПроцедуры

#КонецОбласти

#Область НачатьПолучениеОписанияДрайвера

// Начинает получение описания драйвера
// 
// Параметры:
//  ОповещениеПриЗавершении - ОписаниеОповещения
//  ПараметрыПодключения - см. МенеджерОборудованияКлиент.ПараметрыПодключенияУстройства
//
Процедура НачатьПолучениеОписанияДрайвера(ОповещениеПриЗавершении, ПараметрыПодключения) Экспорт
	
	ДополнительныеПараметры = Новый Структура();
	ДополнительныеПараметры.Вставить("ОповещениеПриЗавершении", ОповещениеПриЗавершении);
	ДополнительныеПараметры.Вставить("ПараметрыПодключения"   , ПараметрыПодключения);
	ДополнительныеПараметры.Вставить("Параметры"              , ПараметрыПодключения.Параметры);
	ДополнительныеПараметры.Вставить("ОписаниеДрайвера"       , МенеджерОборудованияКлиентСервер.ПараметрыОписанияДрайвера());
	
	Оповещение = Новый ОписаниеОповещения("НачатьПолучениеОписанияДрайвера_ПолучениеОбъектаДрайвераЗавершение", ЭтотОбъект, ДополнительныеПараметры);
	НачатьПолучениеОбъектаДрайвера(Оповещение, ПараметрыПодключения);
	
КонецПроцедуры

// Завершает получение описания драйвера
// 
// Параметры:
//  ОбъектДрайвера - ВнешняяКомпонента
//  ДополнительныеПараметры - Структура:
//   * ОповещениеПриЗавершении - ОписаниеОповещения
//   * ПараметрыПодключения - см. МенеджерОборудованияКлиент.ПараметрыПодключенияУстройства
//   * Параметры - Структура
//   * ОписаниеДрайвера - см. МенеджерОборудованияКлиентСервер.ПараметрыОписанияДрайвера
//
Процедура НачатьПолучениеОписанияДрайвера_ПолучениеОбъектаДрайвераЗавершение(ОбъектДрайвера, ДополнительныеПараметры) Экспорт
	
	Если ОбъектДрайвера = Неопределено Тогда
		Если ДополнительныеПараметры.ОповещениеПриЗавершении <> Неопределено Тогда
			// Сообщить об ошибке, что не удалось загрузить драйвер.
			ОписаниеОшибки = НСтр("ru='%Наименование%: Не удалось загрузить драйвер устройства.
										|Проверьте, что драйвер корректно установлен и зарегистрирован в системе.'");
			ОписаниеОшибки = СтрЗаменить(ОписаниеОшибки, "%Наименование%", ДополнительныеПараметры.ПараметрыПодключения.Наименование);
			РезультатВыполнения = МенеджерОборудованияКлиентСервер.ПараметрыВыполненияОперацииНаОборудовании(Ложь, ОписаниеОшибки);
			ВыполнитьОбработкуОповещения(ДополнительныеПараметры.ОповещениеПриЗавершении, РезультатВыполнения);
		КонецЕсли;
	Иначе
		ДополнительныеПараметры.Вставить("ОбъектДрайвера", ОбъектДрайвера);
		
		ОписаниеДрайвера = ДополнительныеПараметры.ОписаниеДрайвера;
		ОповещениеМетода = Новый ОписаниеОповещения("НачатьПолучениеОписанияДрайвера_ПолучитьОписаниеЗавершение", ЭтотОбъект, ДополнительныеПараметры); 
		Попытка
			ДополнительныеПараметры.ОбъектДрайвера.НачатьВызовПолучитьОписание(ОповещениеМетода, ОписаниеДрайвера.ОписаниеДрайвераXML);
		Исключение                              
			РевизияИнтерфейса = 2005;
			ДополнительныеПараметры.ОбъектДрайвера.НачатьВызовПолучитьОписание(ОповещениеМетода, ОписаниеДрайвера.НаименованиеДрайвера, ОписаниеДрайвера.ОписаниеДрайвера, ОписаниеДрайвера.ТипОборудования,
				РевизияИнтерфейса, ОписаниеДрайвера.ИнтеграционныйКомпонент, ОписаниеДрайвера.ОсновнойДрайверУстановлен, ОписаниеДрайвера.URLЗагрузкиДрайвера);
		КонецПопытки;
	
	КонецЕсли;
	
КонецПроцедуры

Процедура НачатьПолучениеОписанияДрайвера_ПолучитьНомерВерсииЗавершение(РезультатВызова, ПараметрыВызова, ДополнительныеПараметры) Экспорт
	
	ОписаниеДрайвера = ДополнительныеПараметры.ОписаниеДрайвера;
	ОписаниеДрайвера.ВерсияДрайвера = РезультатВызова;
	
	ПараметрыДрайвера = "";
	ОповещениеМетода = Новый ОписаниеОповещения("НачатьПолучениеОписанияДрайвера_ПолучитьПараметрыЗавершение", ЭтотОбъект, ДополнительныеПараметры);
	Попытка
		ДополнительныеПараметры.ОбъектДрайвера.НачатьВызовПолучитьПараметры(ОповещениеМетода, ПараметрыДрайвера);
	Исключение
		ОписаниеОшибки = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
		ОбщегоНазначенияКлиент.СообщитьПользователю(НСтр("ru='Ошибка получения параметров драйвера.'") + Символы.ПС + ОписаниеОшибки);
	КонецПопытки;
	
КонецПроцедуры

Процедура НачатьПолучениеОписанияДрайвера_ПолучитьРевизиюИнтерфейсаЗавершение(РезультатВызова, ПараметрыВызова, ДополнительныеПараметры) Экспорт
	
	ОписаниеДрайвера = ДополнительныеПараметры.ОписаниеДрайвера;
	ОписаниеДрайвера.РевизияИнтерфейса = РезультатВызова;
	
	ПараметрыДрайвера = "";
	ОповещениеМетода = Новый ОписаниеОповещения("НачатьПолучениеОписанияДрайвера_ПолучитьПараметрыЗавершение", ЭтотОбъект, ДополнительныеПараметры);
	Попытка
		ДополнительныеПараметры.ОбъектДрайвера.НачатьВызовПолучитьПараметры(ОповещениеМетода, ПараметрыДрайвера);
	Исключение
		ОписаниеОшибки = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
		ОбщегоНазначенияКлиент.СообщитьПользователю(НСтр("ru='Ошибка получения параметров драйвера.'") + Символы.ПС + ОписаниеОшибки);
	КонецПопытки;
	
КонецПроцедуры

Процедура НачатьПолучениеОписанияДрайвера_ПолучитьОписаниеЗавершение(РезультатВызова, ПараметрыВызова, ДополнительныеПараметры) Экспорт
	
	ОписаниеДрайвера = ДополнительныеПараметры.ОписаниеДрайвера;
	
	Если ПараметрыВызова.Количество() > 1 И Не СтрНачинаетсяС(ПараметрыВызова[0], "<?")  Тогда  // WEB клиент не генерирует исключение при вызове метода с неверным количество параметров.
		ОписаниеДрайвера.НаименованиеДрайвера      = ПараметрыВызова[0]; // НаименованиеДрайвера
		ОписаниеДрайвера.ОписаниеДрайвера          = ПараметрыВызова[1]; // ОписаниеДрайвера
		ОписаниеДрайвера.ТипОборудования           = ПараметрыВызова[2]; // ТипОборудования
		ОписаниеДрайвера.РевизияИнтерфейса         = ПараметрыВызова[3]; // РевизияИнтерфейса
		ОписаниеДрайвера.ИнтеграционныйКомпонент   = ПараметрыВызова[4]; // ИнтеграционныйКомпонент
		ОписаниеДрайвера.ОсновнойДрайверУстановлен = ПараметрыВызова[5]; // ОсновнойДрайверУстановлен
		ОписаниеДрайвера.URLЗагрузкиДрайвера       = ПараметрыВызова[6]; // URLЗагрузкиДрайвера
		
		ОповещениеМетода = Новый ОписаниеОповещения("НачатьПолучениеОписанияДрайвера_ПолучитьНомерВерсииЗавершение", ЭтотОбъект, ДополнительныеПараметры);
		ДополнительныеПараметры.ОбъектДрайвера.НачатьВызовПолучитьНомерВерсии(ОповещениеМетода);
	Иначе
		ОписаниеДрайвераПараметры = МенеджерОборудованияВызовСервера.ПолучитьОписаниеДрайвера(ПараметрыВызова[0]); // ОписаниеДрайвераXML
		ЗаполнитьЗначенияСвойств(ОписаниеДрайвера, ОписаниеДрайвераПараметры); 
		
		ОповещениеМетода = Новый ОписаниеОповещения("НачатьПолучениеОписанияДрайвера_ПолучитьРевизиюИнтерфейсаЗавершение", ЭтотОбъект, ДополнительныеПараметры);
		ДополнительныеПараметры.ОбъектДрайвера.НачатьВызовПолучитьРевизиюИнтерфейса(ОповещениеМетода);
	КонецЕсли;
	
КонецПроцедуры

Процедура НачатьПолучениеОписанияДрайвера_ПолучитьПараметрыЗавершение(РезультатВызова, ПараметрыВызова, ДополнительныеПараметры) Экспорт
	
	ОписаниеДрайвера = ДополнительныеПараметры.ОписаниеДрайвера;
	ОписаниеДрайвера.ПараметрыДрайвера = ПараметрыВызова[0];
	
	ДополнительныеДействия = "";
	ОповещениеМетода = Новый ОписаниеОповещения("НачатьПолучениеОписанияДрайвера_ПолучитьДополнительныеДействияЗавершение", ЭтотОбъект, ДополнительныеПараметры);
	Попытка                                    
		ДополнительныеПараметры.ОбъектДрайвера.НачатьВызовПолучитьДополнительныеДействия(ОповещениеМетода, ДополнительныеДействия);
	Исключение
		ОбщегоНазначенияКлиент.СообщитьПользователю(НСтр("ru='Ошибка получения описания драйвера.'"));
	КонецПопытки;
	
КонецПроцедуры

Процедура НачатьПолучениеОписанияДрайвера_ПолучитьДополнительныеДействияЗавершение(РезультатВызова, ПараметрыВызова, ДополнительныеПараметры) Экспорт
	
	ОписаниеДрайвера = ДополнительныеПараметры.ОписаниеДрайвера;
	ОписаниеДрайвера.ДополнительныеДействия = ПараметрыВызова[0];
	ОписаниеДрайвера.Установлен = Истина;
	
	Если ДополнительныеПараметры.ПараметрыПодключения.Свойство("КоличествоПодключенных") Тогда
		ОписаниеДрайвера.Вставить("КоличествоПодключенных",  ДополнительныеПараметры.ПараметрыПодключения.КоличествоПодключенных);
	КонецЕсли;
	
	Если ДополнительныеПараметры.ОповещениеПриЗавершении <> Неопределено Тогда
		Результат = Новый Структура("Результат, ОписаниеДрайвера", Истина, ОписаниеДрайвера);
		ВыполнитьОбработкуОповещения(ДополнительныеПараметры.ОповещениеПриЗавершении, Результат);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти


#Область НачатьТестУстройства

// АПК: 581-выкл

// Процедура устанавливает параметры драйвера.
// 
// Параметры:
//  ОповещениеПриУстановкеПараметров - ОписаниеОповещения
//  ДополнительныеПараметры - Структура:
//   * ПараметрыПодключения - см. МенеджерОборудованияКлиент.ПараметрыПодключенияУстройства
//   * Параметры - Структура
//   * ПараметрыДляУстановки - Структура
//   * ОповещениеПриУстановкеПараметров - ОписаниеОповещения
//
Процедура НачатьУстановкуПараметров(ОповещениеПриУстановкеПараметров, ДополнительныеПараметры) Экспорт
	
	ВремПараметры = Новый Структура();
	Если ДополнительныеПараметры.ПараметрыПодключения.Свойство("ТипОборудования") Тогда
		// Предопределенный параметр с указанием типа драйвера.
		ВремПараметры.Вставить("P_EquipmentType",  ДополнительныеПараметры.ПараметрыПодключения.ТипОборудования) // ТипОборудования
	КонецЕсли;
	
	Для Каждого Параметр Из ДополнительныеПараметры.Параметры Цикл
		Если Лев(Параметр.Ключ, 2) = "P_" Тогда
			ВремПараметры.Вставить(Параметр.Ключ, Параметр.Значение);
		КонецЕсли;
	КонецЦикла;
	
	ДополнительныеПараметры.Вставить("ПараметрыДляУстановки", ВремПараметры);
	ДополнительныеПараметры.Вставить("ОповещениеПриУстановкеПараметров", ОповещениеПриУстановкеПараметров);
	НачатьУстановкуПараметров_Завершение(Истина, Неопределено, ДополнительныеПараметры);
	
КонецПроцедуры

// АПК: 581-вкл

// Процедура завершения установки параметров драйвера.
//
Процедура НачатьУстановкуПараметров_Завершение(РезультатВыполнения, ПараметрыВызова, ДополнительныеПараметры) Экспорт
	
	Если Не ТипЗнч(ДополнительныеПараметры.ПараметрыДляУстановки) = Тип("Структура") Тогда
		Возврат;
	КонецЕсли;
	
	Если ДополнительныеПараметры.ПараметрыДляУстановки.Количество() > 0  Тогда
		Для Каждого Параметр Из ДополнительныеПараметры.ПараметрыДляУстановки Цикл
			ИмяТекПараметра = Параметр.Ключ;
			ЗначениеПараметра = Параметр.Значение;
			ДополнительныеПараметры.ПараметрыДляУстановки.Удалить(ИмяТекПараметра);
			ОповещениеМетода = Новый ОписаниеОповещения("НачатьУстановкуПараметров_Завершение", ЭтотОбъект, ДополнительныеПараметры);
			ОбъектДрайвера = ДополнительныеПараметры.ПараметрыПодключения.ОбъектДрайвера;
			ОбъектДрайвера.НачатьВызовУстановитьПараметр(ОповещениеМетода, Сред(ИмяТекПараметра, 3), ЗначениеПараметра);
			Прервать;
		КонецЦикла;
	Иначе
		Если ДополнительныеПараметры.ОповещениеПриУстановкеПараметров <> Неопределено Тогда
			ВыполнитьОбработкуОповещения(ДополнительныеПараметры.ОповещениеПриУстановкеПараметров, ДополнительныеПараметры);
		КонецЕсли;   
	КонецЕсли;
	
КонецПроцедуры

// Выполнение тестирование устройства.
//
// Параметры:
//  ОповещениеПриЗавершении - ОписаниеОповещения
//  ПараметрыПодключения - см. МенеджерОборудованияКлиент.ПараметрыПодключенияУстройства
//  ПараметрыВыполнения - Структура
//
Процедура НачатьТестУстройства(ОповещениеПриЗавершении, ПараметрыПодключения, ПараметрыВыполнения) Экспорт
	
	ДополнительныеПараметры = Новый Структура();
	ДополнительныеПараметры.Вставить("ОповещениеПриЗавершении", ОповещениеПриЗавершении);
	ДополнительныеПараметры.Вставить("ПараметрыПодключения"   , ПараметрыПодключения);
	ДополнительныеПараметры.Вставить("Параметры"              , ПараметрыПодключения.Параметры);
	ДополнительныеПараметры.Вставить("ПараметрыВыполнения"    , ПараметрыВыполнения);
	
	Оповещение = Новый ОписаниеОповещения("НачатьТестУстройства_ПолучениеОбъектаДрайвераЗавершение", ЭтотОбъект, ДополнительныеПараметры);
	НачатьПолучениеОбъектаДрайвера(Оповещение, ПараметрыПодключения);
	
КонецПроцедуры

// Завершает получение объекта драйвера, при выполнении теста устройства
// 
// Параметры:
//  ОбъектДрайвера - ВнешняяКомпонента
//  ДополнительныеПараметры - Структура:
//   * ОповещениеПриЗавершении - ОписаниеОповещения
//   * ПараметрыПодключения - см. МенеджерОборудованияКлиент.ПараметрыПодключенияУстройства
//   * Параметры - Структура
//   * ОписаниеДрайвера - см. МенеджерОборудованияКлиентСервер.ПараметрыОписанияДрайвера
//
Процедура НачатьТестУстройства_ПолучениеОбъектаДрайвераЗавершение(ОбъектДрайвера, ДополнительныеПараметры) Экспорт 
	
	Если ОбъектДрайвера = Неопределено Тогда
		Если ДополнительныеПараметры.ОповещениеПриЗавершении <> Неопределено Тогда
			// Сообщить об ошибке, что не удалось загрузить драйвер.
			ОписаниеОшибки = НСтр("ru='%Наименование%: Не удалось загрузить драйвер устройства.
										|Проверьте, что драйвер корректно установлен и зарегистрирован в системе.'");
			ОписаниеОшибки = СтрЗаменить(ОписаниеОшибки, "%Наименование%", ДополнительныеПараметры.ПараметрыПодключения.Наименование);
			РезультатВыполнения = МенеджерОборудованияКлиентСервер.ПараметрыВыполненияОперацииНаОборудовании(Ложь, ОписаниеОшибки);
			ВыполнитьОбработкуОповещения(ДополнительныеПараметры.ОповещениеПриЗавершении, РезультатВыполнения);
		КонецЕсли;
	Иначе
		ДополнительныеПараметры.ПараметрыПодключения.Вставить("ОбъектДрайвера", ОбъектДрайвера);
		ОповещениеПриУстановкеПараметров = Новый ОписаниеОповещения("НачатьТестУстройства_УстановкаПараметровЗавершение", ЭтотОбъект, ДополнительныеПараметры);
		НачатьУстановкуПараметров(ОповещениеПриУстановкеПараметров, ДополнительныеПараметры);
	КонецЕсли;
	
КонецПроцедуры

// Завершает установку параметров, при выполнении теста устройства
// 
// Параметры:
//  Результат - Структура
//  ДополнительныеПараметры - Структура:
//   * ОповещениеПриЗавершении - ОписаниеОповещения
//   * ПараметрыПодключения - см. МенеджерОборудованияКлиент.ПараметрыПодключенияУстройства
//   * Параметры - Структура
//   * ОписаниеДрайвера - см. МенеджерОборудованияКлиентСервер.ПараметрыОписанияДрайвера
//
Процедура НачатьТестУстройства_УстановкаПараметровЗавершение(Результат, ДополнительныеПараметры) Экспорт  
	
	Попытка
		РезультатТеста       = "";
		АктивированДемоРежим = "";
		Оповещение = Новый ОписаниеОповещения("НачатьТестУстройства_Завершение", ЭтотОбъект, ДополнительныеПараметры);
		ОбъектДрайвера = ДополнительныеПараметры.ПараметрыПодключения.ОбъектДрайвера;
		ОбъектДрайвера.НачатьВызовТестУстройства(Оповещение, РезультатТеста, АктивированДемоРежим);
	Исключение
		Если ДополнительныеПараметры.ОповещениеПриЗавершении <> Неопределено Тогда
			ОписаниеОшибки = СтрШаблон(НСтр("ru='Ошибка вызова метода <%1>.'"), "ОбъектДрайвера.ТестУстройства");
			РезультатВыполнения = МенеджерОборудованияКлиентСервер.ПараметрыВыполненияОперацииНаОборудовании(Ложь, ОписаниеОшибки);
			ВыполнитьОбработкуОповещения(ДополнительныеПараметры.ОповещениеПриЗавершении, РезультатВыполнения);
		КонецЕсли;
	КонецПопытки;
	
КонецПроцедуры

Процедура НачатьТестУстройства_Завершение(Результат, ПараметрыВызова, ДополнительныеПараметры) Экспорт
	
	Если ДополнительныеПараметры.ОповещениеПриЗавершении <> Неопределено Тогда
		РезультатВыполнения = МенеджерОборудованияКлиентСервер.ПараметрыВыполненияОперацииНаОборудовании(Результат);
		РезультатВыполнения.Вставить("РезультатВыполнения" , ПараметрыВызова[0]);  
		РезультатВыполнения.Вставить("АктивированДемоРежим", ПараметрыВызова[1]);
		ВыполнитьОбработкуОповещения(ДополнительныеПараметры.ОповещениеПриЗавершении, РезультатВыполнения);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ДрайверПодключениеОтключение

// Функция начинает подключение устройства.
//
// Параметры:
//  ОповещениеПриЗавершении - ОписаниеОповещения
//  ПараметрыПодключения - см. МенеджерОборудованияКлиент.ПараметрыПодключенияУстройства
//
Процедура НачатьПодключениеУстройства(ОповещениеПриЗавершении, ПараметрыПодключения) Экспорт
	
	ДополнительныеПараметры = Новый Структура();
	ДополнительныеПараметры.Вставить("ОповещениеПриЗавершении", ОповещениеПриЗавершении);
	ДополнительныеПараметры.Вставить("ПараметрыПодключения"   , ПараметрыПодключения);
	ДополнительныеПараметры.Вставить("Параметры"              , ПараметрыПодключения.Параметры);
	
	Оповещение = Новый ОписаниеОповещения("НачатьПодключениеУстройства_ПолучениеОбъектаДрайвераЗавершение", ЭтотОбъект, ДополнительныеПараметры);
	ПодключаемоеОборудованиеДрайверКлиент.НачатьПолучениеОбъектаДрайвера(Оповещение, ПараметрыПодключения);
	
КонецПроцедуры

Процедура НачатьПодключениеУстройства_ПолучениеОбъектаДрайвераЗавершение(ОбъектДрайвера, ДополнительныеПараметры) Экспорт
	
	Если ОбъектДрайвера = Неопределено Тогда
		// Сообщить об ошибке, что не удалось загрузить драйвер.
		ОписаниеОшибки = НСтр("ru='Не удалось загрузить драйвер устройства.
								|Проверьте, что драйвер корректно установлен и зарегистрирован в системе.'");
		РезультатВыполнения = МенеджерОборудованияКлиентСервер.ПараметрыВыполненияОперацииНаОборудовании(Ложь, ОписаниеОшибки);
		ВыполнитьОбработкуОповещения(ДополнительныеПараметры.ОповещениеПриЗавершении, РезультатВыполнения);
		Возврат;
	КонецЕсли;
	
	ДополнительныеПараметры.ПараметрыПодключения.ОбъектДрайвера = ОбъектДрайвера;
	
	Оповещение = Новый ОписаниеОповещения("НачатьПодключениеУстройства_ПолучениеОписанияДрайвераЗавершение", ЭтотОбъект, ДополнительныеПараметры);
	НачатьПолучениеОписанияДрайвера(Оповещение, ДополнительныеПараметры.ПараметрыПодключения);
	
КонецПроцедуры

Процедура НачатьПодключениеУстройства_ПолучениеОписанияДрайвераЗавершение(РезультатВыполнения, ДополнительныеПараметры) Экспорт  
	
	Если РезультатВыполнения.Результат Тогда
		ПараметрыДрайвера = РезультатВыполнения.ОписаниеДрайвера;
		Если ПустаяСтрока(ПараметрыДрайвера.РевизияИнтерфейса) Или ПараметрыДрайвера.РевизияИнтерфейса = 0 Тогда
			ОписаниеОшибки = НСтр("ru='Ревизия интерфейса драйвера не определена.'");
			РезультатВыполнения = МенеджерОборудованияКлиентСервер.ПараметрыВыполненияОперацииНаОборудовании(Ложь, ОписаниеОшибки);
			ВыполнитьОбработкуОповещения(ДополнительныеПараметры.ОповещениеПриЗавершении, РезультатВыполнения);
			Возврат;
		Иначе
			ДополнительныеПараметры.ПараметрыПодключения.РевизияИнтерфейса = ПараметрыДрайвера.РевизияИнтерфейса;
		КонецЕсли;
	Иначе
		ОписаниеОшибки = НСтр("ru='Ошибка получения ревизии интерфейса драйвера.'");
		РезультатВыполнения = МенеджерОборудованияКлиентСервер.ПараметрыВыполненияОперацииНаОборудовании(Ложь, ОписаниеОшибки);
		ВыполнитьОбработкуОповещения(ДополнительныеПараметры.ОповещениеПриЗавершении, РезультатВыполнения);
		Возврат;
	КонецЕсли;
	
	Оповещение = Новый ОписаниеОповещения("НачатьПодключениеУстройства_НачатьУстановкуПараметровЗавершение", ЭтотОбъект, ДополнительныеПараметры);
	НачатьУстановкуПараметров(Оповещение, ДополнительныеПараметры);

КонецПроцедуры

Процедура НачатьПодключениеУстройства_НачатьУстановкуПараметровЗавершение(РезультатВыполнения, ДополнительныеПараметры) Экспорт
	
	ОповещениеПодключитьЗавершение = Новый ОписаниеОповещения("НачатьПодключениеУстройства_ПодключитьЗавершение", ЭтотОбъект, ДополнительныеПараметры);
	Попытка                  
		ОбъектДрайвера = ДополнительныеПараметры.ПараметрыПодключения.ОбъектДрайвера;
		ОбъектДрайвера.НачатьВызовПодключить(ОповещениеПодключитьЗавершение, ДополнительныеПараметры.ПараметрыПодключения.ИДУстройства) 
	Исключение
		Если ДополнительныеПараметры.ОповещениеПриЗавершении <> Неопределено Тогда
			ОписаниеОшибки = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
			РезультатВыполнения = МенеджерОборудованияКлиентСервер.ПараметрыВыполненияОперацииНаОборудовании(Ложь, ОписаниеОшибки);
			ВыполнитьОбработкуОповещения(ДополнительныеПараметры.ОповещениеПриЗавершении, РезультатВыполнения);
		КонецЕсли;
	КонецПопытки;
	
КонецПроцедуры

Процедура НачатьПодключениеУстройства_ПолучениеОшибкиЗавершение(РезультатВыполнения, Параметры, ДополнительныеПараметры) Экспорт
	
	Если ДополнительныеПараметры.ОповещениеПриЗавершении <> Неопределено Тогда
		ОписаниеОшибки = Параметры[0];
		РезультатВыполнения = МенеджерОборудованияКлиентСервер.ПараметрыВыполненияОперацииНаОборудовании(Ложь, ОписаниеОшибки);
		ВыполнитьОбработкуОповещения(ДополнительныеПараметры.ОповещениеПриЗавершении, РезультатВыполнения);
	КонецЕсли;
	
КонецПроцедуры

Процедура НачатьПодключениеУстройства_ПодключитьЗавершение(РезультатВыполнения, ПараметрыВызова, ДополнительныеПараметры) Экспорт
	
	Если НЕ РезультатВыполнения Тогда
		
		ОповещениеПодключитьЗавершение = Новый ОписаниеОповещения("НачатьПодключениеУстройства_ПолучениеОшибкиЗавершение", ЭтотОбъект, ДополнительныеПараметры);
		Попытка
			ОписаниеОшибки = "";
			ОбъектДрайвера = ДополнительныеПараметры.ПараметрыПодключения.ОбъектДрайвера;
			ОбъектДрайвера.НачатьВызовПолучитьОшибку(ОповещениеПодключитьЗавершение, ОписаниеОшибки);
		Исключение
			Если ДополнительныеПараметры.ОповещениеПриЗавершении <> Неопределено Тогда
				ОписаниеОшибки = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
				РезультатВыполнения = МенеджерОборудованияКлиентСервер.ПараметрыВыполненияОперацииНаОборудовании(Ложь, ОписаниеОшибки);
				ВыполнитьОбработкуОповещения(ДополнительныеПараметры.ОповещениеПриЗавершении, РезультатВыполнения);
			КонецЕсли;
		КонецПопытки;
		
	Иначе
		ИДУстройства = ПараметрыВызова[0];
		
		ДополнительныеПараметры.ПараметрыПодключения.ИДУстройства = ИДУстройства;
		ПараметрыПодключения = ДополнительныеПараметры.ПараметрыПодключения;
		
		ТипОборудования = ДополнительныеПараметры.ПараметрыПодключения.ТипОборудования;
		Если ТипОборудования = "СканерШтрихкода" Тогда
			ПараметрыПодключения.ИменаСобытий.Добавить("Штрихкод");
			ПараметрыПодключения.ИменаСобытий.Добавить("Barcode");
			ПараметрыПодключения.ИменаСобытий.Добавить("ШтрихкодBase64");
			ПараметрыПодключения.ИменаСобытий.Добавить("BarcodeBase64");
		ИначеЕсли ТипОборудования = "СчитывательМагнитныхКарт" Тогда
			ПараметрыПодключения.ИменаСобытий.Добавить("ДанныеКарты");
			ПараметрыПодключения.ИменаСобытий.Добавить("TracksData");
			ПараметрыПодключения.ИменаСобытий.Добавить("ДанныеКартыBase64");
			ПараметрыПодключения.ИменаСобытий.Добавить("TrackDataBase64");
		ИначеЕсли ТипОборудования = "СчитывательRFID" Тогда
			ПараметрыПодключения.ИменаСобытий.Добавить("RFID");
		КонецЕсли;
		
		Если ДополнительныеПараметры.ОповещениеПриЗавершении <> Неопределено Тогда
			РезультатВыполнения = МенеджерОборудованияКлиентСервер.ПараметрыВыполненияОперацииНаОборудовании(Истина);
			ВыполнитьОбработкуОповещения(ДополнительныеПараметры.ОповещениеПриЗавершении, РезультатВыполнения);
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

// Функция начинает отключение устройства.
//
// Параметры:
//  ОповещениеПриЗавершении - ОписаниеОповещения
//  ПараметрыПодключения - см. МенеджерОборудованияКлиент.ПараметрыПодключенияУстройства
//
Процедура НачатьОтключениеУстройства(ОповещениеПриЗавершении, ПараметрыПодключения) Экспорт
	
	ДополнительныеПараметры = Новый Структура();
	ДополнительныеПараметры.Вставить("ОповещениеПриЗавершении", ОповещениеПриЗавершении);
	ДополнительныеПараметры.Вставить("ПараметрыПодключения"   , ПараметрыПодключения);
	
	ОповещениеМетода = Новый ОписаниеОповещения("НачатьОтключениеУстройства_Завершение", ЭтотОбъект, ДополнительныеПараметры);
	Попытка
		ОбъектДрайвера = ДополнительныеПараметры.ПараметрыПодключения.ОбъектДрайвера;
		ОбъектДрайвера.НачатьВызовОтключить(ОповещениеМетода, ДополнительныеПараметры.ПараметрыПодключения.ИДУстройства) 
	Исключение
		Если ОповещениеПриЗавершении <> Неопределено Тогда
			ОписаниеОшибки = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
			ОписаниеОшибки = СтрШаблон(НСтр("ru='Ошибка вызова метода <%1>.'"), "ОбъектДрайвера.Отключить")  + Символы.ПС + ОписаниеОшибки; 
			РезультатВыполнения = МенеджерОборудованияКлиентСервер.ПараметрыВыполненияОперацииНаОборудовании(Ложь, ОписаниеОшибки);
			ВыполнитьОбработкуОповещения(ДополнительныеПараметры.ОповещениеПриЗавершении, РезультатВыполнения);
		КонецЕсли;
	КонецПопытки;
	
КонецПроцедуры

Процедура НачатьОтключениеУстройства_Завершение(РезультатВыполнения, ПараметрыВызова, ДополнительныеПараметры) Экспорт
	
	Если ДополнительныеПараметры.ОповещениеПриЗавершении <> Неопределено Тогда
		РезультатВыполнения = МенеджерОборудованияКлиентСервер.ПараметрыВыполненияОперацииНаОборудовании(Истина);
		ВыполнитьОбработкуОповещения(ДополнительныеПараметры.ОповещениеПриЗавершении, РезультатВыполнения);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область НачатьВыполнитьДополнительноеДействие

// Выполнение дополнительного действия для устройства.
//
// Параметры:
//  ОповещениеПриЗавершении - ОписаниеОповещения
//  ПараметрыПодключения - см. МенеджерОборудованияКлиент.ПараметрыПодключенияУстройства
//  ПараметрыВыполнения - Структура
//
Процедура НачатьВыполнитьДополнительноеДействие(ОповещениеПриЗавершении, ПараметрыПодключения, ПараметрыВыполнения) Экспорт
	
	ДополнительныеПараметры = Новый Структура();
	ДополнительныеПараметры.Вставить("ОповещениеПриЗавершении", ОповещениеПриЗавершении);
	ДополнительныеПараметры.Вставить("ПараметрыПодключения"   , ПараметрыПодключения);
	ДополнительныеПараметры.Вставить("Параметры"              , ПараметрыПодключения.Параметры);
	ДополнительныеПараметры.Вставить("ПараметрыВыполнения"    , ПараметрыВыполнения);
	
	Оповещение = Новый ОписаниеОповещения("НачатьВыполнитьДополнительноеДействие_ПолучениеОбъектаДрайвераЗавершение", ЭтотОбъект, ДополнительныеПараметры);
	НачатьПолучениеОбъектаДрайвера(Оповещение, ПараметрыПодключения);
	
КонецПроцедуры

// Завершение получения объекта драйвера при выполнении дополнительного действия
// 
// Параметры:
//  ОбъектДрайвера - ВнешняяКомпонента
//  ДополнительныеПараметры - Структура:
//   * ОповещениеПриЗавершении - ОписаниеОповещения
//   * ПараметрыПодключения - см. МенеджерОборудованияКлиент.ПараметрыПодключенияУстройства
//   * Параметры - Структура
//   * ОписаниеДрайвера - см. МенеджерОборудованияКлиентСервер.ПараметрыОписанияДрайвера
//
Процедура НачатьВыполнитьДополнительноеДействие_ПолучениеОбъектаДрайвераЗавершение(ОбъектДрайвера, ДополнительныеПараметры) Экспорт 
	
	Если ОбъектДрайвера = Неопределено Тогда
		Если ДополнительныеПараметры.ОповещениеПриЗавершении <> Неопределено Тогда
			// Сообщить об ошибке, что не удалось загрузить драйвер.
			ОписаниеОшибки = НСтр("ru='%Наименование%: Не удалось загрузить драйвер устройства.
										|Проверьте, что драйвер корректно установлен и зарегистрирован в системе.'");
			ОписаниеОшибки = СтрЗаменить(ОписаниеОшибки, "%Наименование%", ДополнительныеПараметры.ПараметрыПодключения.Наименование);
			РезультатВыполнения = МенеджерОборудованияКлиентСервер.ПараметрыВыполненияОперацииНаОборудовании(Ложь, ОписаниеОшибки);
			ВыполнитьОбработкуОповещения(ДополнительныеПараметры.ОповещениеПриЗавершении, РезультатВыполнения);
		КонецЕсли;
	Иначе
		ДополнительныеПараметры.ПараметрыПодключения.Вставить("ОбъектДрайвера", ОбъектДрайвера);
		ОповещениеПриУстановкеПараметров = Новый ОписаниеОповещения("НачатьВыполнитьДополнительноеДействие_УстановкаПараметровЗавершение", ЭтотОбъект, ДополнительныеПараметры);
		НачатьУстановкуПараметров(ОповещениеПриУстановкеПараметров, ДополнительныеПараметры);
	КонецЕсли;
	
КонецПроцедуры

Процедура НачатьВыполнитьДополнительноеДействие_УстановкаПараметровЗавершение(Результат, ДополнительныеПараметры) Экспорт  
	
	Попытка
		ИмяДействия = ДополнительныеПараметры.ПараметрыВыполнения.ИмяДействия;
		Оповещение = Новый ОписаниеОповещения("НачатьВыполнитьДополнительноеДействие_Завершение", ЭтотОбъект, ДополнительныеПараметры);
		ОбъектДрайвера = ДополнительныеПараметры.ПараметрыПодключения.ОбъектДрайвера;
		ОбъектДрайвера.НачатьВызовВыполнитьДополнительноеДействие(Оповещение, ИмяДействия );
	Исключение
		Если ДополнительныеПараметры.ОповещениеПриЗавершении <> Неопределено Тогда
			ОписаниеОшибки = СтрШаблон(НСтр("ru='Ошибка вызова метода <%1>.'"), "ОбъектДрайвера.ВыполнитьДополнительноеДействие");
			РезультатВыполнения = МенеджерОборудованияКлиентСервер.ПараметрыВыполненияОперацииНаОборудовании(Ложь, ОписаниеОшибки);
			ВыполнитьОбработкуОповещения(ДополнительныеПараметры.ОповещениеПриЗавершении, РезультатВыполнения);
		КонецЕсли;
	КонецПопытки;
	
КонецПроцедуры

Процедура НачатьВыполнитьДополнительноеДействие_Завершение(Результат, ПараметрыВызова, ДополнительныеПараметры) Экспорт
	
	Если Результат Тогда
		Если ДополнительныеПараметры.ОповещениеПриЗавершении <> Неопределено Тогда
			РезультатВыполнения = МенеджерОборудованияКлиентСервер.ПараметрыВыполненияОперацииНаОборудовании(Результат);
			ВыполнитьОбработкуОповещения(ДополнительныеПараметры.ОповещениеПриЗавершении, РезультатВыполнения);
		КонецЕсли;
	Иначе
		ОписаниеОшибки = "";
		ОбъектДрайвера = ДополнительныеПараметры.ПараметрыПодключения.ОбъектДрайвера;
		Оповещение = Новый ОписаниеОповещения("НачатьВыполнитьДополнительноеДействие_ПолучитьОшибку", ЭтотОбъект, ДополнительныеПараметры);
		ОбъектДрайвера.НачатьВызовПолучитьОшибку(Оповещение, ОписаниеОшибки) 
	КонецЕсли;
	
КонецПроцедуры

Процедура НачатьВыполнитьДополнительноеДействие_ПолучитьОшибку(Результат, ПараметрыВызова, ДополнительныеПараметры) Экспорт
	
	Если ДополнительныеПараметры.ОповещениеПриЗавершении <> Неопределено Тогда
		РезультатВыполнения = МенеджерОборудованияКлиентСервер.ПараметрыВыполненияОперацииНаОборудовании(Ложь, ПараметрыВызова[0]);
		ВыполнитьОбработкуОповещения(ДополнительныеПараметры.ОповещениеПриЗавершении, РезультатВыполнения);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработатьСобытие 

// Функция осуществляет обработку внешних событий подключаемого оборудования.
//
// Параметры:
//  ОбъектДрайвера - ВнешняяКомпонента
//  ПараметрыПодключения - см. МенеджерОборудованияКлиент.ПараметрыПодключенияУстройства
//  Событие - Строка
//  Данные - Строка
//
// Возвращаемое значение:
//  Структура.
Функция ОбработатьСобытие(ОбъектДрайвера, ПараметрыПодключения, Событие, Данные) Экспорт
	
	Результат = Ложь;
	ИмяСобытия = "";
	
	Если Событие = "Штрихкод" Или Событие = "Barcode" Тогда
		
		ИмяСобытия = "ScanData";
		Штрихкод = СокрЛП(Данные);
		Если МенеджерОборудованияКлиент.СобытиеУстройствВводаНовыйФормат() Тогда
			ДанныеСобытия = Новый Структура("Штрихкод,Данные", Штрихкод, Данные);
		Иначе
			ДанныеСобытия = Новый Массив();
			ДанныеСобытия.Добавить(Штрихкод);
			МассивВторогоПорядка = Новый Массив();
			МассивВторогоПорядка.Добавить(Данные);
			МассивВторогоПорядка.Добавить(Штрихкод);
			МассивВторогоПорядка.Добавить(0);
			ДанныеСобытия.Добавить(МассивВторогоПорядка);
		КонецЕсли;
		Результат = Истина;
		
	ИначеЕсли Событие = "ШтрихкодBase64" Или Событие = "BarcodeBase64" Тогда
		
		ИмяСобытия = "ScanDataBase64";
		Штрихкод = СокрЛП(Данные);
		Если МенеджерОборудованияКлиент.СобытиеУстройствВводаНовыйФормат() Тогда
			ДанныеСобытия = Новый Структура("Штрихкод,Данные", СокрЛП(Данные), Данные);
		Иначе
			ДанныеСобытия = Новый Массив();
			ДанныеСобытия.Добавить(Штрихкод);
			МассивВторогоПорядка = Новый Массив();
			МассивВторогоПорядка.Добавить(Данные);
			МассивВторогоПорядка.Добавить(Штрихкод);
			МассивВторогоПорядка.Добавить(0);
			ДанныеСобытия.Добавить(МассивВторогоПорядка);
		КонецЕсли;
		Результат = Истина;
		
	ИначеЕсли Событие = "ДанныеКарты" Или Событие = "TracksData" Тогда
		
		КодКарты  = Данные;
		ПозицияПрефикса = 0;
		ПозицияСуффикса = 0;
		времКодКарты    = "";
		ДанныеКарты     = "";
		ПозицияДляЧтения = 1;
		Параметры = ПараметрыПодключения.Параметры;
		
		ДанныеДорожек = Новый Массив();
		Если Параметры.Свойство("ПараметрыДорожек") И Параметры.ПараметрыДорожек <> Неопределено Тогда
			Для НомерДорожки = 1 По 3 Цикл
				ДанныеДорожек.Добавить("");
				ТекущаяДорожка = Параметры.ПараметрыДорожек[НомерДорожки - 1];
				Если ТекущаяДорожка.Использовать Тогда
					ПрефиксДрайвера = Символ(ТекущаяДорожка.Префикс);
					СуффиксДрайвера = Символ(ТекущаяДорожка.Суффикс);
					Если ПозицияДляЧтения < СтрДлина(КодКарты) Тогда
						ДанныеКарты = Сред(КодКарты, ПозицияДляЧтения);
						ПозицияПрефикса = Найти(ДанныеКарты, ПрефиксДрайвера);
						ПозицияСуффикса = Найти(ДанныеКарты, СуффиксДрайвера);
						времПозицияПрефикса = ?(ПозицияПрефикса = 0, 1, ПозицияПрефикса + СтрДлина(ПрефиксДрайвера));
						времДлинаДоСуффикса = ?(ПозицияСуффикса = 0, СтрДлина(ДанныеКарты) + 1 - времПозицияПрефикса, ПозицияСуффикса - времПозицияПрефикса);
						времКодКарты = времКодКарты + Сред(ДанныеКарты, времПозицияПрефикса, времДлинаДоСуффикса);
						ДанныеДорожек[НомерДорожки - 1] = Сред(ДанныеКарты, времПозицияПрефикса, времДлинаДоСуффикса);
						ПозицияДляЧтения = ПозицияДляЧтения + ?(ПозицияСуффикса = 0, СтрДлина(ДанныеКарты), ПозицияСуффикса + СтрДлина(СуффиксДрайвера) - 1);
					КонецЕсли;
				КонецЕсли;
			КонецЦикла;
		КонецЕсли;
		
		ИмяСобытия = "TracksData";
		КодКарты = времКодКарты;
		Если Параметры.ПараметрыДорожек <> Неопределено 
			 И МенеджерОборудованияКлиентПовтИсп.ИспользуетсяУстройстваВвода() Тогда
			 
			МодульОборудованиеУстройстваВводаКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ОборудованиеУстройстваВводаКлиент");
			СписокШаблонов = МодульОборудованиеУстройстваВводаКлиент.РасшифроватьКодМагнитнойКарты(ДанныеДорожек, Параметры.ПараметрыДорожек);
			
		Иначе
			СписокШаблонов = Неопределено;
		КонецЕсли;
		
		Если МенеджерОборудованияКлиент.СобытиеУстройствВводаНовыйФормат() Тогда
			ДанныеСобытия = Новый Структура();
			ДанныеСобытия.Вставить("КодКарты"      , КодКарты);
			ДанныеСобытия.Вставить("Данные"        , Данные);
			ДанныеСобытия.Вставить("ДанныеДорожек" , ДанныеДорожек);
			ДанныеСобытия.Вставить("СписокШаблонов", СписокШаблонов);
		Иначе
			ДанныеСобытия = Новый Массив();
			ДанныеСобытия.Добавить(КодКарты);
			МассивВторогоПорядка = Новый Массив();
			МассивВторогоПорядка.Добавить(Сред(Данные,2));
			МассивВторогоПорядка.Добавить(ДанныеДорожек);
			МассивВторогоПорядка.Добавить(0);
			МассивВторогоПорядка.Добавить(СписокШаблонов);
			ДанныеСобытия.Добавить(МассивВторогоПорядка);
		КонецЕсли;
		
		Результат = Истина;
		
	ИначеЕсли Событие = "RFID" Тогда
		
		Результат = Ложь;
		ИмяСобытия = Событие;
		
		Если МенеджерОборудованияКлиентПовтИсп.ИспользуетсяСчитывательRFID() Тогда
			РезультатВыполнения = ПодключаемоеОборудованиеДрайверСинхронноКлиент.ОбработатьСобытие(ОбъектДрайвера, ПараметрыПодключения, Событие, Данные);
			Если РезультатВыполнения.Результат Тогда
				ДанныеСобытия = МенеджерОборудованияВызовСервера.МеткиRFID(РезультатВыполнения.ТаблицаМеток);
				Результат = Истина;
			КонецЕсли;
		КонецЕсли;
	
	КонецЕсли;
	
	РезультатОбработки = Новый Структура();
	РезультатОбработки.Вставить("Результат", Результат);
	РезультатОбработки.Вставить("Событие"  , ИмяСобытия);
	РезультатОбработки.Вставить("Данные"   , ДанныеСобытия);
	
	Возврат РезультатОбработки;

КонецФункции

#КонецОбласти

#КонецОбласти