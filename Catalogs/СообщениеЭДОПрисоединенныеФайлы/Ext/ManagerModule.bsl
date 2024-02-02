﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Регистрирует данные для обработчика обновления
// 
// Параметры:
//  Параметры - Структура - параметры.
//
Процедура ЗарегистрироватьДанныеКОбработкеДляПереходаНаНовуюВерсию(Параметры) Экспорт
	
	ОтработаныВсеДанные = Ложь;
	Ссылка = Справочники.СообщениеЭДОПрисоединенныеФайлы.ПустаяСсылка();
	
	ПараметрыВыборки = Параметры.ПараметрыВыборки;
	ПараметрыВыборки.СпособВыборки = ОбновлениеИнформационнойБазы.СпособВыборкиСсылки();
	ПараметрыВыборки.ПолныеИменаОбъектов = Ссылка.Метаданные().ПолноеИмя();
	
	Пока Не ОтработаныВсеДанные Цикл
		
		Запрос = Новый Запрос;
		Запрос.Текст = 
			"ВЫБРАТЬ ПЕРВЫЕ 1000
			|	Файлы.Ссылка КАК Ссылка
			|ИЗ
			|	Справочник.СообщениеЭДОПрисоединенныеФайлы КАК Файлы
			|ГДЕ
			|	Файлы.Ссылка > &Ссылка
			|	И (Файлы.ВладелецФайла = ЗНАЧЕНИЕ(Документ.СообщениеЭДО.ПустаяСсылка)
			|		ИЛИ ВЫРАЗИТЬ(Файлы.ПолноеИмяФайла КАК СТРОКА(1)) = """"
			|		ИЛИ НЕ Файлы.Служебный)
			|УПОРЯДОЧИТЬ ПО
			|	Ссылка";
		
		Запрос.УстановитьПараметр("Ссылка", Ссылка);
		МассивСсылок = Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Ссылка");
		
		ОбновлениеИнформационнойБазы.ОтметитьКОбработке(Параметры, МассивСсылок);
		
		КоличествоСсылок = МассивСсылок.Количество();
		Если КоличествоСсылок < 1000 Тогда
			ОтработаныВсеДанные = Истина;
		КонецЕсли;
		
		Если КоличествоСсылок > 0 Тогда
			Ссылка = МассивСсылок[КоличествоСсылок - 1];
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

// Обработчик обновления.
// 
// Параметры:
//  Параметры - Структура - параметры.
//
Процедура ОбработатьДанныеДляПереходаНаНовуюВерсию(Параметры) Экспорт
	
	МетаданныеОбъекта = Метаданные.Справочники.СообщениеЭДОПрисоединенныеФайлы;
	ПолноеИмяОбъекта = МетаданныеОбъекта.ПолноеИмя();
	
	Если ОбновлениеИнформационнойБазы.ЕстьЗаблокированныеПредыдущимиОчередямиДанные(Параметры.Очередь,
		"Справочник.ВидыДокументовЭДО") Тогда
		Параметры.ОбработкаЗавершена = ОбновлениеИнформационнойБазы.ОбработкаДанныхЗавершена(
			Параметры.Очередь, ПолноеИмяОбъекта);
		Возврат;
	КонецЕсли;
	
	ПараметрыОтметкиВыполнения = ОбновлениеИнформационнойБазы.ДополнительныеПараметрыОтметкиОбработки();
	
	ВыбранныеДанные = ОбновлениеИнформационнойБазы.ДанныеДляОбновленияВМногопоточномОбработчике(Параметры);
	
	Если Не ЗначениеЗаполнено(ВыбранныеДанные) Тогда
		Параметры.ОбработкаЗавершена = ОбновлениеИнформационнойБазы.ОбработкаДанныхЗавершена(
			Параметры.Очередь, ПолноеИмяОбъекта);
		Возврат;
	КонецЕсли;
	
	ДанныеДляЗаполнения = ДанныеДляЗаполненияВладельцев(ВыбранныеДанные);
	
	ОбъектовОбработано = 0;
	ПроблемныхОбъектов = 0;
	
	Для Каждого СтрокаДанных Из ВыбранныеДанные Цикл
		
		НачатьТранзакцию();
		Попытка
			
			Записать = Ложь;
			
			Объект = ОбщегоНазначенияБЭД.ОбъектПоСсылкеДляИзменения(СтрокаДанных.Ссылка);
			
			Если Объект <> Неопределено Тогда
				
				ЗаполнитьВладельцаФайла(Объект, ДанныеДляЗаполнения, Записать);
				
				ЗаполнитьПолноеИмяФайла(Объект, Записать);
				
				ЗаполнитьПризнакСлужебногоФайла(Объект, Записать);
				
			КонецЕсли;
			
			Если Записать Тогда
				ОбновлениеИнформационнойБазы.ЗаписатьОбъект(Объект);
			Иначе
				ОбновлениеИнформационнойБазы.ОтметитьВыполнениеОбработки(СтрокаДанных.Ссылка, ПараметрыОтметкиВыполнения);
			КонецЕсли;
			
			ОбъектовОбработано = ОбъектовОбработано + 1;
			
			ЗафиксироватьТранзакцию();
		Исключение
			ОтменитьТранзакцию();
			
			ОбновлениеИнформационнойБазы.ОтметитьВыполнениеОбработки(СтрокаДанных.Ссылка, ПараметрыОтметкиВыполнения);
			ПроблемныхОбъектов = ПроблемныхОбъектов + 1;
			
			ТекстСообщения = СтрШаблон(НСтр("ru = 'Не удалось обработать файл электронного документа: %1 по причине:
				|%2'"), СтрокаДанных.Ссылка, ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
			ЗаписьЖурналаРегистрации(ОбновлениеИнформационнойБазы.СобытиеЖурналаРегистрации(),
				УровеньЖурналаРегистрации.Ошибка, МетаданныеОбъекта, СтрокаДанных.Ссылка, ТекстСообщения);
		КонецПопытки;
		
	КонецЦикла;
	
	Если ОбъектовОбработано = 0 И ПроблемныхОбъектов <> 0 Тогда
		ШаблонСообщения = НСтр("ru = 'Не удалось обработать некоторые файлы электронных документов (пропущены): %1'");
		ТекстСообщения = СтрШаблон(ШаблонСообщения, ПроблемныхОбъектов);
		ЗаписьЖурналаРегистрации(ОбновлениеИнформационнойБазы.СобытиеЖурналаРегистрации(),
			УровеньЖурналаРегистрации.Информация,
			МетаданныеОбъекта,, ТекстСообщения);
	Иначе
		ШаблонСообщения = НСтр("ru = 'Обработана очередная порция файлов электронных документов: %1'");
		ТекстСообщения = СтрШаблон(ШаблонСообщения, ОбъектовОбработано);
		ЗаписьЖурналаРегистрации(ОбновлениеИнформационнойБазы.СобытиеЖурналаРегистрации(),
			УровеньЖурналаРегистрации.Информация,
			МетаданныеОбъекта,, ТекстСообщения);
	КонецЕсли;
	
	Параметры.ПрогрессВыполнения.ОбработаноОбъектов =
		Параметры.ПрогрессВыполнения.ОбработаноОбъектов + ОбъектовОбработано;
	
	Параметры.ОбработкаЗавершена = ОбновлениеИнформационнойБазы.ОбработкаДанныхЗавершена(
		Параметры.Очередь, ПолноеИмяОбъекта);
	
КонецПроцедуры

// См. УправлениеДоступомПереопределяемый.ПриЗаполненииСписковСОграничениемДоступа.
Процедура ПриЗаполненииОграниченияДоступа(Ограничение) Экспорт

	Ограничение.Текст =
	"РазрешитьЧтение
	|ГДЕ
	|	ЧтениеОбъектаРазрешено(ВладелецФайла)
	|;
	|РазрешитьИзменениеЕслиРазрешеноЧтение
	|ГДЕ
	|	ИзменениеОбъектаРазрешено(ВладелецФайла)";

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область СлужебныеПроцедурыИФункцииОбработчиковОбновления

Процедура ЗаполнитьВладельцаФайла(Объект, ДанныеДляЗаполнения, Записать)
	
	Если ЗначениеЗаполнено(Объект.ВладелецФайла)
		ИЛИ Не ЗначениеЗаполнено(Объект.УдалитьВладелецФайла2) Тогда
		Возврат;
	КонецЕсли;
	
	Если Объект.УдалитьТипЭлементаВерсииЭД <> Перечисления.ТипыЭлементовРегламентаЭДО.УдалитьДополнительныйЭД Тогда
		
		ВладелецОбъект = СоздатьВладельцаФайла(Объект, ДанныеДляЗаполнения);
		Если ВладелецОбъект = Неопределено Тогда
			Возврат;
		КонецЕсли;
		
		СостояниеПодписанияОтсутствует = ДанныеДляЗаполнения.ЕстьСостояниеПодписания[Объект.Ссылка] = Неопределено;
		Если ВладелецОбъект.Состояние = Перечисления.СостоянияСообщенийЭДО.Подписание И СостояниеПодписанияОтсутствует Тогда
			ЭлектронныеДокументыЭДО.Обновление_СформироватьМаршрутПодписания(ВладелецОбъект);		
		КонецЕсли;
		
		Объект.ВладелецФайла = ВладелецОбъект.Ссылка;
		Записать = Истина;
		Возврат;
		
	КонецЕсли;
	
	ОсновнойФайл = ОсновнойФайлВладельца(Объект);
	Если Не ЗначениеЗаполнено(ОсновнойФайл) Тогда
		Возврат;
	КонецЕсли;
	
	ОбъектОсновногоФайла = ОбщегоНазначенияБЭД.ОбъектПоСсылкеДляИзменения(ОсновнойФайл);
	Если ЗначениеЗаполнено(ОбъектОсновногоФайла.ВладелецФайла) Тогда
		Объект.ВладелецФайла = ОбъектОсновногоФайла.ВладелецФайла;
	Иначе
		ВладелецОбъект = СоздатьВладельцаФайла(ОбъектОсновногоФайла, ДанныеДляЗаполнения);
		Если ВладелецОбъект = Неопределено Тогда
			Возврат;
		КонецЕсли;
		Объект.ВладелецФайла = ВладелецОбъект.Ссылка;
		ОбъектОсновногоФайла.ВладелецФайла = ВладелецОбъект.Ссылка;
		ОбъектОсновногоФайла.ОбменДанными.Загрузка = Истина;
		ОбъектОсновногоФайла.Записать();
	КонецЕсли;
	
	Записать = Истина;
	
КонецПроцедуры

Функция СоздатьВладельцаФайла(Объект, ДанныеДляЗаполнения)
	
	СвойстваДокументов = ДанныеДляЗаполнения.СвойстваДокументов;
	
	СвойстваДокумента = СвойстваДокументов.Найти(Объект.УдалитьВладелецФайла2, "Ссылка");
	Если СвойстваДокумента = Неопределено
		ИЛИ Не ЗначениеЗаполнено(СвойстваДокумента.УдалитьВидДокумента) Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	СвойстваДокумента.ТипРегламента = ЭлектронныеДокументыЭДО.Обновление_ТипРегламентаПоНовойАрхитектуре(
		СвойстваДокумента.УдалитьТипЭлементаВерсииЭД);
	Если Не ЗначениеЗаполнено(СвойстваДокумента.ТипРегламента) Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	ВладелецОбъект = Документы.СообщениеЭДО.СоздатьДокумент();
	
	ТипЭлементаРодительскогоФайла = ДанныеДляЗаполнения.ТипыЭлементовРодительскихФайлов[Объект.Ссылка];
	
	ТипЭлементаРегламента = ОпределитьТипЭлементаРегламента(Объект.УдалитьТипЭлементаВерсииЭД, ТипЭлементаРодительскогоФайла);
	
	ДокументОтклонен = ДанныеДляЗаполнения.ОтклоненныеДокументы[Объект.УдалитьВладелецФайла2] <> Неопределено;
	
	ВладелецОбъект.Дата = Объект.ДатаСоздания;
	ВладелецОбъект.ОсновнойФайл = Объект.Ссылка;
	ВладелецОбъект.ЭлектронныйДокумент = Объект.УдалитьВладелецФайла2;
	ВладелецОбъект.Направление = Объект.УдалитьНаправлениеЭД;
	ВладелецОбъект.ДополнительнаяИнформация = Объект.УдалитьДополнительнаяИнформация;
	ВладелецОбъект.ТипЭлементаРегламента = ТипЭлементаРегламента;
	ВладелецОбъект.Статус = ЭлектронныеДокументыЭДО.Обновление_СтатусСообщенияПоНовойАрхитектуре(Объект.УдалитьСтатусЭД,
		СвойстваДокумента.ТипРегламента, ВладелецОбъект.ТипЭлементаРегламента, ВладелецОбъект.Направление,
		СвойстваДокумента.ОбменБезПодписи, ДокументОтклонен);
	Если Не ЗначениеЗаполнено(ВладелецОбъект.Статус) Тогда
		Возврат Неопределено;
	КонецЕсли;
	ВладелецОбъект.ДатаИзмененияСтатуса = Объект.УдалитьДатаИзмененияСтатусаЭД;
	
	Если ТипЭлементаРегламента = Перечисления.ТипыЭлементовРегламентаЭДО.ИнформацияОтправителя
		ИЛИ ТипЭлементаРегламента = Перечисления.ТипыЭлементовРегламентаЭДО.ИнформацияПолучателя Тогда
		ВладелецОбъект.ВидСообщения = ЭлектронныеДокументыЭДО.Обновление_ОпределитьВидДокумента(СвойстваДокумента);
	Иначе
		ТипСообщения = ТипСлужебногоСообщенияПоТипуЭлементаРегламента(ТипЭлементаРегламента);
		Если Не ЗначениеЗаполнено(ТипСообщения) Тогда
			ВызватьИсключение НСтр("ru = 'Не удалось определить тип служебного сообщения'");
		КонецЕсли;
		ВладелецОбъект.ВидСообщения = ЭлектронныеДокументыЭДО.ВидДокументаПоТипу(ТипСообщения);;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(ВладелецОбъект.ДатаИзмененияСтатуса)
		И ЗначениеЗаполнено(Объект.ДатаМодификацииУниверсальная) Тогда
		ВладелецОбъект.ДатаИзмененияСтатуса = МестноеВремя(Объект.ДатаМодификацииУниверсальная, ЧасовойПоясСеанса());
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(ВладелецОбъект.Статус)
		ИЛИ ЭлектронныеДокументыЭДО.Обновление_ДокументооборотЗавершенДоОбновления(
			СвойстваДокумента.УдалитьСостояниеЭДО) Тогда
		ВладелецОбъект.Состояние = Перечисления.СостоянияСообщенийЭДО.Хранение;
	ИначеЕсли ДанныеДляЗаполнения.ИспользоватьУтверждение
		И ТипЭлементаРегламента = Перечисления.ТипыЭлементовРегламентаЭДО.ИнформацияОтправителя
		И ВладелецОбъект.Направление = Перечисления.НаправленияЭДО.Входящий
		И СвойстваДокумента.УдалитьСостояниеЭДО = Перечисления.СостоянияДокументовЭДО.ТребуетсяУтверждение Тогда
		ВладелецОбъект.Состояние = Перечисления.СостоянияСообщенийЭДО.Утверждение;
	Иначе
		ВладелецОбъект.Состояние = РегламентыЭДО.СостояниеСообщения(ВладелецОбъект, СвойстваДокумента,
			ДанныеДляЗаполнения.ИспользоватьУтверждение);
	КонецЕсли;
	
	ОбновлениеИнформационнойБазы.ЗаписатьОбъект(ВладелецОбъект);
	
	Возврат ВладелецОбъект;
	
КонецФункции

Функция ОпределитьТипЭлементаРегламента(ТипЭлементаВерсииЭД, ТипЭлементаРодительскогоФайла)
	
	Результат = ТипЭлементаВерсииЭД;
	
	Если ТипЭлементаВерсииЭД = Перечисления.ТипыЭлементовРегламентаЭДО.УдалитьПервичныйЭД
		ИЛИ ТипЭлементаВерсииЭД = Перечисления.ТипыЭлементовРегламентаЭДО.УдалитьСЧФДОПУПД
		ИЛИ ТипЭлементаВерсииЭД = Перечисления.ТипыЭлементовРегламентаЭДО.УдалитьСЧФУПД
		ИЛИ ТипЭлементаВерсииЭД = Перечисления.ТипыЭлементовРегламентаЭДО.УдалитьДОПУПД
		ИЛИ ТипЭлементаВерсииЭД = Перечисления.ТипыЭлементовРегламентаЭДО.УдалитьДОП
		ИЛИ ТипЭлементаВерсииЭД = Перечисления.ТипыЭлементовРегламентаЭДО.УдалитьКСЧФДИСУКД
		ИЛИ ТипЭлементаВерсииЭД = Перечисления.ТипыЭлементовРегламентаЭДО.УдалитьКСЧФУКД
		ИЛИ ТипЭлементаВерсииЭД = Перечисления.ТипыЭлементовРегламентаЭДО.УдалитьДИСУКД
		ИЛИ ТипЭлементаВерсииЭД = Перечисления.ТипыЭлементовРегламентаЭДО.УдалитьЭСФ Тогда
		
		Результат = Перечисления.ТипыЭлементовРегламентаЭДО.ИнформацияОтправителя;
		
	ИначеЕсли ТипЭлементаВерсииЭД = Перечисления.ТипыЭлементовРегламентаЭДО.УдалитьСоглашениеОбИзмененииСтоимостиПолучатель
		ИЛИ ТипЭлементаВерсииЭД = Перечисления.ТипыЭлементовРегламентаЭДО.УдалитьИнформацияПокупателяУПД
		ИЛИ ТипЭлементаВерсииЭД = Перечисления.ТипыЭлементовРегламентаЭДО.УдалитьИнформацияПокупателяУКД
		ИЛИ ТипЭлементаВерсииЭД = Перечисления.ТипыЭлементовРегламентаЭДО.УдалитьТОРГ12Покупатель
		ИЛИ ТипЭлементаВерсииЭД = Перечисления.ТипыЭлементовРегламентаЭДО.УдалитьАктЗаказчик Тогда
		
		Результат = Перечисления.ТипыЭлементовРегламентаЭДО.ИнформацияПолучателя;
		
	ИначеЕсли ТипЭлементаВерсииЭД = Перечисления.ТипыЭлементовРегламентаЭДО.УдалитьИПЭСФ Тогда
		
		Результат = Перечисления.ТипыЭлементовРегламентаЭДО.ИОП;
		
	ИначеЕсли ТипЭлементаВерсииЭД = Перечисления.ТипыЭлементовРегламентаЭДО.УдалитьПДОЭСФ Тогда
		
		Результат = Перечисления.ТипыЭлементовРегламентаЭДО.ПДО;
		
	ИначеЕсли ТипЭлементаВерсииЭД = Перечисления.ТипыЭлементовРегламентаЭДО.УдалитьПДПЭСФ Тогда
		
		Результат = Перечисления.ТипыЭлементовРегламентаЭДО.ПДП;
		
	ИначеЕсли ТипЭлементаВерсииЭД = Перечисления.ТипыЭлементовРегламентаЭДО.УдалитьУУЭСФ Тогда
		
		Результат = Перечисления.ТипыЭлементовРегламентаЭДО.УОУ;
		
	ИначеЕсли ТипЭлементаВерсииЭД = Перечисления.ТипыЭлементовРегламентаЭДО.УОУ
		И ТипЭлементаРодительскогоФайла = Перечисления.ТипыЭлементовРегламентаЭДО.ПОА Тогда
		
		Результат = Перечисления.ТипыЭлементовРегламентаЭДО.ПОА_УОУ;
		
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

Функция ТипСлужебногоСообщенияПоТипуЭлементаРегламента(ТипЭлементаРегламента)
	
	ТипСообщения = Перечисления.ТипыДокументовЭДО.ПустаяСсылка();
	
	МодульОбменСГИСЭПД = Неопределено;
	Если ОбщегоНазначения.ПодсистемаСуществует("ЭлектронноеВзаимодействие.ОбменСГИСЭПД") Тогда
		МодульОбменСГИСЭПД = ОбщегоНазначения.ОбщийМодуль("ОбменСГИСЭПД");
	КонецЕсли;
	
	Если ТипЭлементаРегламента = Перечисления.ТипыЭлементовРегламентаЭДО.ПДП
		Или ТипЭлементаРегламента = Перечисления.ТипыЭлементовРегламентаЭДО.ПДО
		Или ТипЭлементаРегламента = Перечисления.ТипыЭлементовРегламентаЭДО.ИОП_ПДП
		Или ТипЭлементаРегламента = Перечисления.ТипыЭлементовРегламентаЭДО.ИнформацияПолучателя_ПДП Тогда
		
		ТипСообщения = Перечисления.ТипыДокументовЭДО.ПодтверждениеОператораЭДО;
		
	ИначеЕсли ТипЭлементаРегламента = Перечисления.ТипыЭлементовРегламентаЭДО.ИОП
		Или ТипЭлементаРегламента = Перечисления.ТипыЭлементовРегламентаЭДО.ПДП_ИОП
		Или ТипЭлементаРегламента = Перечисления.ТипыЭлементовРегламентаЭДО.ПДО_ИОП
		Или ТипЭлементаРегламента = Перечисления.ТипыЭлементовРегламентаЭДО.ИОП_ПДП_ИОП
		Или ТипЭлементаРегламента = Перечисления.ТипыЭлементовРегламентаЭДО.ИнформацияПолучателя_ПДП_ИОП
		Или ТипЭлементаРегламента = Перечисления.ТипыЭлементовРегламентаЭДО.УОУ_ИОП		
		Или (МодульОбменСГИСЭПД <> Неопределено И МодульОбменСГИСЭПД.ЭтоИОП(ТипЭлементаРегламента)) Тогда
		
		ТипСообщения = Перечисления.ТипыДокументовЭДО.ИзвещениеОПолучении;
		
	ИначеЕсли ТипЭлементаРегламента = Перечисления.ТипыЭлементовРегламентаЭДО.ПОА Тогда
		
		ТипСообщения = Перечисления.ТипыДокументовЭДО.ПредложениеОбАннулировании;
		
	ИначеЕсли ТипЭлементаРегламента = Перечисления.ТипыЭлементовРегламентаЭДО.УОУ
		Или ТипЭлементаРегламента = Перечисления.ТипыЭлементовРегламентаЭДО.ПОА_УОУ
		Или (МодульОбменСГИСЭПД <> Неопределено И МодульОбменСГИСЭПД.ЭтоУОУ(ТипЭлементаРегламента)) Тогда
		
		ТипСообщения = Перечисления.ТипыДокументовЭДО.УведомлениеОбУточнении;
		
	КонецЕсли;
	
	Возврат ТипСообщения;
	
КонецФункции

Процедура ЗаполнитьПолноеИмяФайла(Объект, Записать)
	
	Если ЗначениеЗаполнено(Объект.ПолноеИмяФайла) Тогда
		Возврат;
	КонецЕсли;
	
	ИмяБезРасширения = ?(ЗначениеЗаполнено(Объект.УдалитьНаименованиеФайла),
		Объект.УдалитьНаименованиеФайла, Объект.Наименование);
	Объект.ПолноеИмяФайла = ?(ПустаяСтрока(Объект.Расширение), ИмяБезРасширения,
		ИмяБезРасширения + "." + Объект.Расширение);
	
	Записать = Истина;
	
КонецПроцедуры

Процедура ЗаполнитьПризнакСлужебногоФайла(Объект, Записать)
	
	Если Объект.Служебный Тогда
		Возврат;
	КонецЕсли;
	
	Объект.Служебный = Истина;
	Записать = Истина;
	
КонецПроцедуры

Функция ДанныеДляЗаполненияВладельцев(ВыбранныеДанные)
	Запрос = Новый Запрос;
	Запрос.Текст =
		"ВЫБРАТЬ
		|	ВыбранныеДанные.Ссылка КАК Ссылка
		|ПОМЕСТИТЬ ВыбранныеФайлы
		|ИЗ
		|	&ВыбранныеДанные КАК ВыбранныеДанные
		|
		|ИНДЕКСИРОВАТЬ ПО
		|	Ссылка
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	ДанныеОсновныхФайлов.УдалитьВладелецФайла2 КАК УдалитьВладелецФайла2,
		|	ДанныеОсновныхФайлов.УдалитьТипЭлементаВерсииЭД КАК УдалитьТипЭлементаВерсииЭД
		|ПОМЕСТИТЬ ВыбранныеДокументы
		|ИЗ
		|	Справочник.СообщениеЭДОПрисоединенныеФайлы КАК ДанныеВыбранныхФайлов
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВыбранныеФайлы КАК ВыбранныеФайлы
		|		ПО ДанныеВыбранныхФайлов.Ссылка = ВыбранныеФайлы.Ссылка
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.СообщениеЭДОПрисоединенныеФайлы КАК ДанныеОсновныхФайлов
		|		ПО ДанныеВыбранныхФайлов.УдалитьВладелецФайла2 = ДанныеОсновныхФайлов.УдалитьВладелецФайла2
		|ГДЕ
		|	ДанныеОсновныхФайлов.УдалитьТипЭлементаВерсииЭД В(&ТипыЭлементовРегламентаИнформацииОтправителя)
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ДокументЭДО.Ссылка КАК Ссылка,
		|	ДокументЭДО.УдалитьВидДокумента КАК УдалитьВидДокумента,
		|	ДокументЭДО.УдалитьВидПрикладногоДокумента КАК УдалитьВидПрикладногоДокумента,
		|	ДокументЭДО.УдалитьТипДокумента КАК УдалитьТипДокумента,
		|	ДокументЭДО.ВидДокумента КАК ВидДокумента,
		|	ДокументЭДО.НомерДокумента КАК НомерДокумента,
		|	ДокументЭДО.ДатаДокумента КАК ДатаДокумента,
		|	ДокументЭДО.УдалитьПричинаОтклонения КАК УдалитьПричинаОтклонения,
		|	ДокументЭДО.ТребуетсяПодтверждение КАК ТребуетсяПодтверждение,
		|	ДокументЭДО.СпособОбмена КАК СпособОбмена,
		|	ДокументЭДО.ОбменБезПодписи КАК ОбменБезПодписи,
		|	ДокументЭДО.УдалитьСостояниеЭДО КАК УдалитьСостояниеЭДО,
		|	ДокументЭДО.ТипРегламента КАК ТипРегламента,
		|	ВыбранныеДокументы.УдалитьТипЭлементаВерсииЭД КАК УдалитьТипЭлементаВерсииЭД
		|ИЗ
		|	Документ.ЭлектронныйДокументВходящийЭДО КАК ДокументЭДО
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВыбранныеДокументы КАК ВыбранныеДокументы
		|		ПО ДокументЭДО.Ссылка = ВыбранныеДокументы.УдалитьВладелецФайла2
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	ДокументЭДО.Ссылка,
		|	ДокументЭДО.УдалитьВидДокумента,
		|	ДокументЭДО.УдалитьВидПрикладногоДокумента,
		|	ДокументЭДО.УдалитьТипДокумента,
		|	ДокументЭДО.ВидДокумента,
		|	ДокументЭДО.НомерДокумента,
		|	ДокументЭДО.ДатаДокумента,
		|	ДокументЭДО.УдалитьПричинаОтклонения,
		|	ДокументЭДО.ТребуетсяПодтверждение,
		|	ДокументЭДО.СпособОбмена,
		|	ДокументЭДО.ОбменБезПодписи,
		|	ДокументЭДО.УдалитьСостояниеЭДО,
		|	ДокументЭДО.ТипРегламента,
		|	ВыбранныеДокументы.УдалитьТипЭлементаВерсииЭД
		|ИЗ
		|	Документ.ЭлектронныйДокументИсходящийЭДО КАК ДокументЭДО
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВыбранныеДокументы КАК ВыбранныеДокументы
		|		ПО ДокументЭДО.Ссылка = ВыбранныеДокументы.УдалитьВладелецФайла2
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	ВыбранныеФайлы.Ссылка КАК Ссылка,
		|	СообщениеЭДОПрисоединенныеФайлыВладельцы.УдалитьТипЭлементаВерсииЭД КАК УдалитьТипЭлементаВерсииЭД
		|ИЗ
		|	ВыбранныеФайлы КАК ВыбранныеФайлы
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.СообщениеЭДОПрисоединенныеФайлы КАК СообщениеЭДОПрисоединенныеФайлы
		|		ПО ВыбранныеФайлы.Ссылка = СообщениеЭДОПрисоединенныеФайлы.Ссылка
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.СообщениеЭДОПрисоединенныеФайлы КАК СообщениеЭДОПрисоединенныеФайлыВладельцы
		|		ПО (СообщениеЭДОПрисоединенныеФайлы.УдалитьЭлектронныйДокументВладелец = СообщениеЭДОПрисоединенныеФайлыВладельцы.Ссылка)
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ВыбранныеДокументы.УдалитьВладелецФайла2 КАК УдалитьВладелецФайла2
		|ИЗ
		|	ВыбранныеДокументы КАК ВыбранныеДокументы
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.СообщениеЭДОПрисоединенныеФайлы КАК СообщениеЭДОПрисоединенныеФайлы
		|		ПО ВыбранныеДокументы.УдалитьВладелецФайла2 = СообщениеЭДОПрисоединенныеФайлы.УдалитьВладелецФайла2
		|			И (СообщениеЭДОПрисоединенныеФайлы.УдалитьТипЭлементаВерсииЭД = ЗНАЧЕНИЕ(Перечисление.ТипыЭлементовРегламентаЭДО.УОУ))
		|ГДЕ
		|	СообщениеЭДОПрисоединенныеФайлы.УдалитьТипЭлементаВерсииЭД = ЗНАЧЕНИЕ(Перечисление.ТипыЭлементовРегламентаЭДО.УОУ)
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ВыбранныеФайлы.Ссылка КАК Ссылка
		|ИЗ
		|	ВыбранныеФайлы КАК ВыбранныеФайлы
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.СостояниеПодписанияЭД КАК СостояниеПодписанияЭД
		|		ПО ВыбранныеФайлы.Ссылка = СостояниеПодписанияЭД.Объект
		|ГДЕ
		|	НЕ СостояниеПодписанияЭД.Объект ЕСТЬ NULL
		|
		|СГРУППИРОВАТЬ ПО
		|	ВыбранныеФайлы.Ссылка";
	Запрос.УстановитьПараметр("ВыбранныеДанные", ВыбранныеДанные);
	
	ТипыЭлементовРегламента = Новый Массив;
	ТипыЭлементовРегламента.Добавить(Перечисления.ТипыЭлементовРегламентаЭДО.УдалитьДОПУПД);
	ТипыЭлементовРегламента.Добавить(Перечисления.ТипыЭлементовРегламентаЭДО.УдалитьСЧФУПД);
	ТипыЭлементовРегламента.Добавить(Перечисления.ТипыЭлементовРегламентаЭДО.УдалитьСЧФДОПУПД);
	ТипыЭлементовРегламента.Добавить(Перечисления.ТипыЭлементовРегламентаЭДО.УдалитьДИСУКД);
	ТипыЭлементовРегламента.Добавить(Перечисления.ТипыЭлементовРегламентаЭДО.УдалитьКСЧФУКД);
	ТипыЭлементовРегламента.Добавить(Перечисления.ТипыЭлементовРегламентаЭДО.УдалитьКСЧФДИСУКД);
	ТипыЭлементовРегламента.Добавить(Перечисления.ТипыЭлементовРегламентаЭДО.УдалитьЭСФ);
	ТипыЭлементовРегламента.Добавить(Перечисления.ТипыЭлементовРегламентаЭДО.УдалитьДОП);
	ТипыЭлементовРегламента.Добавить(Перечисления.ТипыЭлементовРегламентаЭДО.УдалитьПервичныйЭД);
	Запрос.УстановитьПараметр("ТипыЭлементовРегламентаИнформацииОтправителя", ТипыЭлементовРегламента);
	
	РезультатыЗапроса = Запрос.ВыполнитьПакет();
	
	ДанныеДляЗаполнения = Новый Структура;
	ДанныеДляЗаполнения.Вставить("СвойстваДокументов", РезультатыЗапроса[2].Выгрузить());
	
	ТипыЭлементовРодительскихФайлов = Новый Соответствие;
	Выборка = РезультатыЗапроса[3].Выбрать();
	Пока Выборка.Следующий() Цикл
		ТипыЭлементовРодительскихФайлов.Вставить(Выборка.Ссылка, Выборка.УдалитьТипЭлементаВерсииЭД);
	КонецЦикла;
	ДанныеДляЗаполнения.Вставить("ТипыЭлементовРодительскихФайлов", ТипыЭлементовРодительскихФайлов);
	
	ДанныеДляЗаполнения.Вставить("ИспользоватьУтверждение", НастройкиЭДО.ОтправлятьВходящиеДокументыНаУтверждение());
	
	ОтклоненныеДокументы = Новый Соответствие;
	Выборка = РезультатыЗапроса[4].Выбрать();
	Пока Выборка.Следующий() Цикл
		ОтклоненныеДокументы.Вставить(Выборка.УдалитьВладелецФайла2, Истина);
	КонецЦикла;
	ДанныеДляЗаполнения.Вставить("ОтклоненныеДокументы", ОтклоненныеДокументы);
	
	ЕстьСостояниеПодписания = Новый Соответствие;
	Выборка = РезультатыЗапроса[5].Выбрать();
	Пока Выборка.Следующий() Цикл
		ЕстьСостояниеПодписания.Вставить(Выборка.Ссылка, Истина);
	КонецЦикла;
	ДанныеДляЗаполнения.Вставить("ЕстьСостояниеПодписания", ЕстьСостояниеПодписания);
	
	Возврат ДанныеДляЗаполнения;
	
КонецФункции

Функция ОсновнойФайлВладельца(ОбъектДополнительногоФайла)
	
	Если ЗначениеЗаполнено(ОбъектДополнительногоФайла.УдалитьЭлектронныйДокументВладелец) Тогда
		Возврат ОбъектДополнительногоФайла.УдалитьЭлектронныйДокументВладелец;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст =
		"ВЫБРАТЬ
		|	СообщениеЭДОПрисоединенныеФайлы.Ссылка
		|ИЗ
		|	Справочник.СообщениеЭДОПрисоединенныеФайлы КАК СообщениеЭДОПрисоединенныеФайлы
		|ГДЕ
		|	СообщениеЭДОПрисоединенныеФайлы.УдалитьВладелецФайла2 = &УдалитьВладелецФайла2
		|	И СообщениеЭДОПрисоединенныеФайлы.УдалитьТипЭлементаВерсииЭД = &УдалитьТипЭлементаВерсииЭД
		|	И СообщениеЭДОПрисоединенныеФайлы.УдалитьНаправлениеЭД = &УдалитьНаправлениеЭД";
	
	Запрос.УстановитьПараметр("УдалитьВладелецФайла2", ОбъектДополнительногоФайла.УдалитьВладелецФайла2);
	Запрос.УстановитьПараметр("УдалитьТипЭлементаВерсииЭД", Перечисления.ТипыЭлементовРегламентаЭДО.УдалитьПервичныйЭД);
	Запрос.УстановитьПараметр("УдалитьНаправлениеЭД", Перечисления.НаправленияЭДО.Исходящий);
	
	РезультатЗапроса = Запрос.Выполнить();
	Если РезультатЗапроса.Пустой() Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Выборка = РезультатЗапроса.Выбрать();
	Выборка.Следующий();
	Возврат Выборка.Ссылка;
	
КонецФункции

#КонецОбласти

#КонецОбласти

#КонецЕсли