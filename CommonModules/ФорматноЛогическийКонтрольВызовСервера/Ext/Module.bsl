﻿
#Область ПрограммныйИнтерфейс    

// Выполняет проверку обязательности заполняет тэгов
// 
// Параметры:
//  Параметры - Структура - Структура анализируемых параметров.
//  ИдентификаторУстройства - СправочникСсылка.ПодключаемоеОборудование - Устройство, фискализирующее чек
//  ОписаниеОшибки - Строка - описание ошибки для возврата в случае нахождения ошибки
//
// Возвращаемое значение:
//  Булево - Истина когда обязательные данные консистентны
Функция ВыполненаПроверкаОбязательностиИПравильностиЗаполненияТэгов(Параметры, ИдентификаторУстройства, ОписаниеОшибки) Экспорт
	
	Если ЗначениеЗаполнено(ИдентификаторУстройства) Тогда
		ИспользуетсяФН36 = ИдентификаторУстройства.ИспользуетсяФН36; 
		ТипОборудования  = ИдентификаторУстройства.ТипОборудования;
	Иначе
		ОписаниеОшибки = НСтр("ru = 'Не выбрано устройство'");
		Возврат Ложь;
	КонецЕсли;
	
	СтруктураДанныхФорматноЛогическогоКонтроля = СтруктураДанныхФорматноЛогическогоКонтроля(ИдентификаторУстройства);
	
	ФорматФД = СтруктураДанныхФорматноЛогическогоКонтроля.ФорматФД;
	Параметры.Вставить("ФорматФД", ФорматФД);
	
	МассивФФД = МассивПроверяемыхФорматовФД(ФорматФД);
	
	СоответствиеРеквизитов = Новый Соответствие;
	ПроверяемыеРеквизиты = ПроверяемыеРеквизиты(МассивФФД, СоответствиеРеквизитов);
	
	ПараметрыРегистрацииУстройства = ОборудованиеЧекопечатающиеУстройстваВызовСервера.ПараметрыРегистрацииУстройства(ИдентификаторУстройства);
	ЗаполнитьРеквизитовИзРегистрационныхДанных(Параметры, ПроверяемыеРеквизиты.РеквизитыЗаполняемыеИзРегистрационныхДанных, ПараметрыРегистрацииУстройства);
	
	Если НЕ ЗаполненыРеквизитыШапки(Параметры, ПроверяемыеРеквизиты.РеквизитыШапки, ОписаниеОшибки, СоответствиеРеквизитов) Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Если НЕ ЗаполненыРеквизитыПозицийЧека(Параметры.ПозицииЧека, ПроверяемыеРеквизиты.РеквизитыПозицийЧека, ОписаниеОшибки, СоответствиеРеквизитов) Тогда
		Возврат Ложь;
	КонецЕсли;
	
	// Проверка системы налогообложения
	Если Параметры.Свойство("СистемаНалогообложения") И ТипОборудования = Перечисления.ТипыПодключаемогоОборудования.ККТ Тогда
		// Пользователи, переходящие с 01.01.2021 с ЕНВД на ОСН  могут не менять систему налогообложения 
		// в настройках кассы, если используют фискальный накопитель со сроком действия 36 мес.
		// Подробнее см. Письмо ФНС России от 03.12.2020 № АБ-4-20/19907@.
		Если Параметры.СистемаНалогообложения = Перечисления.ТипыСистемНалогообложенияККТ.ОСН И ИспользуетсяФН36 Тогда
			// Если в фискализируемом в чеке приходит – ОСН и для ККТ установлена галка «Используется ФН 36 мес.(ЕНВД)» меняем ОСН на ЕНВД.
			Параметры.СистемаНалогообложения = Перечисления.ТипыСистемНалогообложенияККТ.ЕНВД
		КонецЕсли;
		КодыНалогообложения = СтрРазделить(ПараметрыРегистрацииУстройства.КодыСистемыНалогообложения, ",");
		СистемаНалогообложения = ОборудованиеЧекопечатающиеУстройстваКлиентСервер.КодСистемыНалогообложенияККТ(Параметры.СистемаНалогообложения);
		Если КодыНалогообложения.Найти(Строка(СистемаНалогообложения)) = Неопределено Тогда
			ОписаниеОшибки = НСтр("ru = 'ККТ не зарегистрирована с указанной системой налогообложения.'"); 
			Возврат Ложь;
		КонецЕсли;
	КонецЕсли;
	
	// Проверка признака предмета расчета и его коррекция  
	Если ФорматФД <> "1.2" Тогда
		Для Каждого ПозицияЧека Из Параметры.ПозицииЧека Цикл     
			Если ПозицияЧека.Свойство("ФискальнаяСтрока") Тогда
				// Значения доступные только в ФФД 1.2 преобразуем в значения доступные в ФФД 1.1, 1.05
				Если ПозицияЧека.ПризнакПредметаРасчета = Перечисления.ПризнакиПредметаРасчета.ПодакцизныйТоварМаркируемыйСИНеИмеющийКМ
					Или ПозицияЧека.ПризнакПредметаРасчета = Перечисления.ПризнакиПредметаРасчета.ПодакцизныйТоварМаркируемыйСИИмеющийКМ Тогда
					   ПозицияЧека.ПризнакПредметаРасчета = Перечисления.ПризнакиПредметаРасчета.ПодакцизныйТовар;
				КонецЕсли;    
				// Значения доступные только в ФФД 1.2 преобразуем в значения доступные в ФФД 1.1, 1.05
				Если ПозицияЧека.ПризнакПредметаРасчета = Перечисления.ПризнакиПредметаРасчета.ТоварМаркируемыйСИНеИмеющийКМ
					Или ПозицияЧека.ПризнакПредметаРасчета = Перечисления.ПризнакиПредметаРасчета.ТоварМаркируемыйСИИмеющийКМ Тогда
					   ПозицияЧека.ПризнакПредметаРасчета = Перечисления.ПризнакиПредметаРасчета.Товар;
				КонецЕсли;    
			КонецЕсли;
		КонецЦикла;       
	КонецЕсли;
	
	// Дополнительные условия проверки
	
	// Соответствие сумм товарных позиций и сумм оплаты.
	СуммаПозицийЧека = 0;
	СуммаВсехОплат   = 0;
	СуммаОплатыНаличными = 0;
	
	Для Каждого ПозицияЧека Из Параметры.ПозицииЧека Цикл
		Если ПозицияЧека.Свойство("ФискальнаяСтрока") Тогда
			СуммаПозицийЧека = СуммаПозицийЧека + ПозицияЧека.Сумма;
		КонецЕсли;
	КонецЦикла;
	
	Для Каждого ЭлементаОплаты Из Параметры.ТаблицаОплат Цикл
		// Проверка заполненности реквизитов таблицы оплат
		Если НЕ ЗначениеЗаполнено(ЭлементаОплаты.ТипОплаты) Тогда
			ОписаниеОшибки = НСтр("ru = 'Тэг ""%Реквизит%"" не заполнен.'");
			ОписаниеОшибки = СтрЗаменить(ОписаниеОшибки, "%Реквизит%", НСтр("ru = 'Тип оплаты'"));
			Возврат Ложь;
		КонецЕсли;
		
		СуммаВсехОплат = СуммаВсехОплат + ЭлементаОплаты.Сумма;
		Если ЭлементаОплаты.ТипОплаты = Перечисления.ТипыОплатыККТ.Наличные Тогда
			СуммаОплатыНаличными = СуммаОплатыНаличными + ЭлементаОплаты.Сумма;
		КонецЕсли;
	КонецЦикла;
	
	Если СуммаПозицийЧека > СуммаВсехОплат Тогда
		ОписаниеОшибки = НСтр("ru = 'Сумма товарных позиций больше суммы оплат'"); 
		Возврат Ложь;
	ИначеЕсли СуммаВсехОплат > СуммаПозицийЧека Тогда
		Если (СуммаВсехОплат - СуммаОплатыНаличными) > СуммаПозицийЧека Тогда
			ОписаниеОшибки = НСтр("ru = 'Сумма безналичных оплат больше суммы товарных позиций'"); 
			Возврат Ложь;
		КонецЕсли;
	КонецЕсли;
	
	// Электронный чек
	Электронно = Параметры.Электронно;
	Отправляет1СEmail = Параметры.Отправляет1СEmail;
	Отправляет1СSMS   = Параметры.Отправляет1СSMS;
	ПокупательEmail   = Параметры.ПокупательEmail;
	ПокупательНомер   = Параметры.ПокупательНомер;
	
	Если Электронно И НЕ ЗначениеЗаполнено(ПокупательEmail) И НЕ ЗначениеЗаполнено(ПокупательНомер) Тогда
		ОписаниеОшибки = НСтр("ru = 'Для электронного чека нужно указать либо Email, либо телефон.'") ;
		Возврат Ложь;
	КонецЕсли;
	
	Если Отправляет1СEmail И НЕ ЗначениеЗаполнено(ПокупательEmail) Тогда
		ОписаниеОшибки = НСтр("ru = 'Не заполнен E-mail'") ;
		Возврат Ложь;
	КонецЕсли;
	
	Если Отправляет1СSMS И НЕ ЗначениеЗаполнено(ПокупательНомер) Тогда
		ОписаниеОшибки = НСтр("ru = 'Не заполнен номер телефона'") ;
		Возврат Ложь;
	КонецЕсли;
	
	Если НЕ ПустаяСтрока(Параметры.КассирИНН) Тогда
		Если НЕ ОборудованиеЧекопечатающиеУстройстваКлиентСервер.ИННСоответствуетТребованиям(Параметры.КассирИНН, Ложь, ОписаниеОшибки) Тогда
			Сообщение = НСтр("ru = 'ИНН кассира некорректен (%Ошибка%)'");
			ОписаниеОшибки = СтрЗаменить(Сообщение, "%Ошибка%", ОписаниеОшибки);
			Возврат Ложь;
		КонецЕсли;
	КонецЕсли;
	
	Если НЕ ПустаяСтрока(Параметры.Кассир) И СтрДлина(Параметры.Кассир) > 64 Тогда
		ОписаниеОшибки = НСтр("ru = 'Длинна реквизита (Кассир) превышает 64 символа'");
		Возврат Ложь;
	КонецЕсли;
	
	// Реквизиты платежного агента.
	ПризнакАгента = Перечисления.ПризнакиАгента.ПустаяСсылка();
	Если Параметры.Свойство("ПризнакАгента", ПризнакАгента) 
		И ЗначениеЗаполнено(ПризнакАгента) Тогда
		Если НЕ Параметры.Свойство("ДанныеАгента") Тогда
			ОписаниеОшибки = НСтр("ru = 'Не заданы данные платежного агента'");
			Возврат Ложь;
		КонецЕсли;
	КонецЕсли;
	
	// Реквизиты покупателя
	ОписаниеОшибки = "";
	Если Не СведенияОПокупателеКорректны(Параметры, ОписаниеОшибки) Тогда
		Возврат Ложь;
	КонецЕсли;
	
	НомерПозиции = 0;
	Для Каждого ПозицияЧека Из Параметры.ПозицииЧека Цикл
		Если ПозицияЧека.Свойство("ФискальнаяСтрока") Тогда
			НомерПозиции = НомерПозиции + 1;
			НомерПозицииСтрока = Формат(НомерПозиции, "ЧГ=0");
			
			Если ПозицияЧека.Количество > 1 Тогда
				РеквизитКодаТовара = ПозицияЧека.ДанныеКодаТоварнойНоменклатуры.РеквизитКодаТовара;
				КодТовараИдентифицируетЭкземпляр = ОборудованиеЧекопечатающиеУстройстваВызовСервера.КодТовараИдентифицируетЭкземпляр(РеквизитКодаТовара, ПозицияЧека.Штрихкод);
				Если КодТовараИдентифицируетЭкземпляр Тогда
					ОписаниеОшибки = НСтр("ru = 'Код товара содержит в своем составе код, позволяющий идентифицировать экземпляр товара. Количество должно иметь значение равное единице в строке №%Позиция%.'");
					ОписаниеОшибки = СтрЗаменить(ОписаниеОшибки, "%Позиция%", НомерПозицииСтрока);
					Возврат Ложь;
				КонецЕсли;
			КонецЕсли;
			
			Если ПозицияЧека.ОбъемноСортовойУчет И НЕ ПараметрыРегистрацииУстройства.ПризнакОптовойТорговлиСОрганизациями Тогда
				ОписаниеОшибки = НСтр("ru = 'Строка содержит товар объемно сортового учета. ККТ не зарегистрирована с признаком оптовой торговли с организациями и ИП.'");
				Возврат Ложь;
			КонецЕсли;
			
			ПризнакАгентаПоПредметуРасчета = Перечисления.ПризнакиАгента.ПустаяСсылка();
			Если ПозицияЧека.Свойство("ПризнакАгентаПоПредметуРасчета", ПризнакАгентаПоПредметуРасчета) И ЗначениеЗаполнено(ПризнакАгентаПоПредметуРасчета) Тогда
				
				Если ПризнакАгентаПоПредметуРасчета = Перечисления.ПризнакиАгента.БанковскийПлатежныйАгент
					Или ПризнакАгентаПоПредметуРасчета = Перечисления.ПризнакиАгента.БанковскийПлатежныйСубагент Тогда
					
					Если Параметры.Свойство("ДанныеАгента") Или ПозицияЧека.Свойство("ДанныеАгента") Тогда
						
						Если Параметры.ДанныеАгента.Свойство("ОператорПеревода")
							Или ПозицияЧека.ДанныеАгента.Свойство("ОператорПеревода") Тогда
							
							ЗначениеПараметров = Неопределено;
							ЗначениеПозицииЧека = Неопределено;
							
							Параметры.ДанныеАгента.ОператорПеревода.Свойство("Телефон", ЗначениеПараметров);
							ПозицияЧека.ДанныеАгента.ОператорПеревода.Свойство("Телефон", ЗначениеПозицииЧека);
							Если ЗначениеПараметров = Неопределено И ЗначениеПозицииЧека = Неопределено Тогда
								ОписаниеОшибки = НСтр("ru = 'Не установлен телефон оператора перевода банковского платежного агента.'") ;
								Возврат Ложь;
							КонецЕсли;
							
							Параметры.ДанныеАгента.ОператорПеревода.Свойство("Наименование", ЗначениеПараметров);
							ПозицияЧека.ДанныеАгента.ОператорПеревода.Свойство("Наименование", ЗначениеПозицииЧека);
							Если ЗначениеПараметров = Неопределено И ЗначениеПозицииЧека = Неопределено Тогда
								ОписаниеОшибки = НСтр("ru = 'Не установлено наименование оператора перевода банковского платежного агента.'") ;
								Возврат Ложь;
							КонецЕсли;
							
							Параметры.ДанныеАгента.ОператорПеревода.Свойство("Адрес", ЗначениеПараметров);
							ПозицияЧека.ДанныеАгента.ОператорПеревода.Свойство("Адрес", ЗначениеПозицииЧека);
							Если ЗначениеПараметров = Неопределено И ЗначениеПозицииЧека = Неопределено Тогда
								ОписаниеОшибки = НСтр("ru = 'Не установлен адрес оператора перевода банковского платежного агента.'") ;
								Возврат Ложь;
							КонецЕсли;
							
							Параметры.ДанныеАгента.ОператорПеревода.Свойство("ИНН", ЗначениеПараметров);
							ПозицияЧека.ДанныеАгента.ОператорПеревода.Свойство("ИНН", ЗначениеПозицииЧека);
							Если ЗначениеПараметров = Неопределено И ЗначениеПозицииЧека = Неопределено Тогда
								ОписаниеОшибки = НСтр("ru = 'Не установлен ИНН оператора перевода банковского платежного агента.'") ;
								Возврат Ложь;
							КонецЕсли;
							
						Иначе
							ОписаниеОшибки = НСтр("ru = 'Данные оператора перевода должны быть заполнены.'");
							Возврат Ложь;
						КонецЕсли;

						Если Параметры.ДанныеАгента.Свойство("ПлатежныйАгент")
							Или ПозицияЧека.ДанныеАгента.Свойство("ПлатежныйАгент") Тогда
							
							ЗначениеПараметров = Неопределено;
							ЗначениеПозицииЧека = Неопределено;
							
							Параметры.ДанныеАгента.ПлатежныйАгент.Свойство("Телефон", ЗначениеПараметров);
							ПозицияЧека.ДанныеАгента.ПлатежныйАгент.Свойство("Телефон", ЗначениеПозицииЧека);
							Если ЗначениеПараметров = Неопределено И ЗначениеПозицииЧека = Неопределено Тогда
								ОписаниеОшибки = НСтр("ru = 'Не установлен телефон банковского платежного агента.'") ;
								Возврат Ложь;
							КонецЕсли;
							
							Параметры.ДанныеАгента.ПлатежныйАгент.Свойство("Операция", ЗначениеПараметров);
							ПозицияЧека.ДанныеАгента.ПлатежныйАгент.Свойство("Операция", ЗначениеПозицииЧека);
							Если ЗначениеПараметров = Неопределено И ЗначениеПозицииЧека = Неопределено Тогда
								ОписаниеОшибки = НСтр("ru = 'Не установлена операция банковского платежного агента.'") ;
								Возврат Ложь;
							КонецЕсли;
						Иначе
							ОписаниеОшибки = НСтр("ru = 'Данные платежного агента должны быть заполнены.'");
							Возврат Ложь;
						КонецЕсли;
						
					Иначе
						ОписаниеОшибки = НСтр("ru = 'Данные банковского платежного агента должны быть заполнены.'");
						Возврат Ложь;
					КонецЕсли;
					
				Иначе
					Если ПозицияЧека.Свойство("ДанныеПоставщика") И ПозицияЧека.ДанныеПоставщика.Свойство("ИНН")
						И ПустаяСтрока(ПозицияЧека.ДанныеПоставщика.ИНН) Тогда
							ОписаниеОшибки = НСтр("ru = 'ИНН поставщика для предмета расчета в строке №%Позиция% не указан.'") ;
							ОписаниеОшибки = СтрЗаменить(ОписаниеОшибки, "%Позиция%", НомерПозицииСтрока);
						Возврат Ложь;
					КонецЕсли;
				КонецЕсли;
				
			КонецЕсли;
			
			// Реквизиты платежного агента по предмету расчета
			Если ЗначениеЗаполнено(ПризнакАгента) Тогда
				Если ПозицияЧека.Свойство("ПризнакАгентаПоПредметуРасчета", ПризнакАгентаПоПредметуРасчета) 
					И ЗначениеЗаполнено(ПризнакАгентаПоПредметуРасчета) Тогда
					Если НЕ ПризнакАгента = ПризнакАгентаПоПредметуРасчета Тогда
						// Тег 1222 должен быть равен тегу 1057
						ОписаниеОшибки = НСтр("ru = 'Признак платежного агента в шапке не совпадает с признаком платежного агента по предмету расчета в строке №%Позиция%.'");
						ОписаниеОшибки = СтрЗаменить(ОписаниеОшибки, "%Позиция%", НомерПозицииСтрока);
						Возврат Ложь;
					КонецЕсли;
					Если ПозицияЧека.Свойство("ДанныеАгента") Тогда
						Если Параметры.ДанныеАгента.Свойство("ОператорПеревода")
							И ПозицияЧека.ДанныеАгента.Свойство("ОператорПеревода") Тогда
							ЗначениеПараметров = Неопределено;
							ЗначениеПозицииЧека = Неопределено;
							Если Параметры.ДанныеАгента.ОператорПеревода.Свойство("Адрес", ЗначениеПараметров)
								И ПозицияЧека.ДанныеАгента.ОператорПеревода.Свойство("Адрес", ЗначениеПозицииЧека) 
								И НЕ ЗначениеПараметров = ЗначениеПозицииЧека Тогда
								ОписаниеОшибки = НСтр("ru = 'Адрес оператора перевода в строке №%Позиция% не равен адресу оператора перевода в шапке.'") ;
								ОписаниеОшибки = СтрЗаменить(ОписаниеОшибки, "%Позиция%", НомерПозицииСтрока);
								Возврат Ложь;
							КонецЕсли;
							Если Параметры.ДанныеАгента.ОператорПеревода.Свойство("ИНН", ЗначениеПараметров)
								И ПозицияЧека.ДанныеАгента.ОператорПеревода.Свойство("ИНН", ЗначениеПозицииЧека) 
								И НЕ ЗначениеПараметров = ЗначениеПозицииЧека Тогда
								ОписаниеОшибки = НСтр("ru = 'ИНН оператора перевода в строке №%Позиция% не равен ИНН оператора перевода в шапке.'") ;
								ОписаниеОшибки = СтрЗаменить(ОписаниеОшибки, "%Позиция%", НомерПозицииСтрока);
								Возврат Ложь;
							КонецЕсли;
							Если Параметры.ДанныеАгента.ОператорПеревода.Свойство("Наименование", ЗначениеПараметров)
								И ПозицияЧека.ДанныеАгента.ОператорПеревода.Свойство("Наименование", ЗначениеПозицииЧека) 
								И НЕ ЗначениеПараметров = ЗначениеПозицииЧека Тогда
								ОписаниеОшибки = НСтр("ru = 'Наименование оператора перевода в строке №%Позиция% не равно наименованию оператора перевода в шапке.'") ;
								ОписаниеОшибки = СтрЗаменить(ОписаниеОшибки, "%Позиция%", НомерПозицииСтрока);
								Возврат Ложь;
							КонецЕсли;
							Если Параметры.ДанныеАгента.ОператорПеревода.Свойство("Телефон", ЗначениеПараметров)
								И ПозицияЧека.ДанныеАгента.ОператорПеревода.Свойство("Телефон", ЗначениеПозицииЧека) 
								И НЕ ЗначениеПараметров = ЗначениеПозицииЧека Тогда
								ОписаниеОшибки = НСтр("ru = 'Телефон оператора перевода в строке №%Позиция% не равен телефон оператора перевода в шапке.'") ;
								ОписаниеОшибки = СтрЗаменить(ОписаниеОшибки, "%Позиция%", НомерПозицииСтрока);
								Возврат Ложь;
							КонецЕсли;
						КонецЕсли;
						Если ПозицияЧека.ДанныеАгента.Свойство("ОператорПоПриемуПлатежей") Тогда
							Если Параметры.ДанныеАгента.ОператорПоПриемуПлатежей.Свойство("Телефон", ЗначениеПараметров)
								И ПозицияЧека.ДанныеАгента.ОператорПоПриемуПлатежей.Свойство("Телефон", ЗначениеПозицииЧека) 
								И НЕ ЗначениеПараметров = ЗначениеПозицииЧека Тогда
								ОписаниеОшибки = НСтр("ru = 'Телефон оператора по приему платежей в строке №%Позиция% не равен телефон оператора приему платежей в шапке.'") ;
								ОписаниеОшибки = СтрЗаменить(ОписаниеОшибки, "%Позиция%", НомерПозицииСтрока);
								Возврат Ложь;
							КонецЕсли;
						КонецЕсли;
						Если ПозицияЧека.ДанныеАгента.Свойство("ПлатежныйАгент") Тогда
							Если Параметры.ДанныеАгента.ПлатежныйАгент.Свойство("Операция", ЗначениеПараметров)
								И ПозицияЧека.ДанныеАгента.ПлатежныйАгент.Свойство("Операция", ЗначениеПозицииЧека) 
								И НЕ ЗначениеПараметров = ЗначениеПозицииЧека Тогда
								ОписаниеОшибки = НСтр("ru = 'Операция платежного агента в строке №%Позиция% не равна операции оператора платежного агента в шапке.'") ;
								ОписаниеОшибки = СтрЗаменить(ОписаниеОшибки, "%Позиция%", НомерПозицииСтрока);
								Возврат Ложь;
							КонецЕсли;
							
							Если Параметры.ДанныеАгента.ПлатежныйАгент.Свойство("Телефон", ЗначениеПараметров)
								И ПозицияЧека.ДанныеАгента.ПлатежныйАгент.Свойство("Телефон", ЗначениеПозицииЧека) 
								И НЕ ЗначениеПараметров = ЗначениеПозицииЧека Тогда
								ОписаниеОшибки = НСтр("ru = 'Телефон платежного агента в строке №%Позиция% не равен телефон оператора платежного агента в шапке.'") ;
								ОписаниеОшибки = СтрЗаменить(ОписаниеОшибки, "%Позиция%", НомерПозицииСтрока);
								Возврат Ложь;
							КонецЕсли;
						КонецЕсли;
					КонецЕсли;
					
					Если ПозицияЧека.Свойство("ДанныеПоставщика") Тогда
						Если Параметры.ДанныеПоставщика.Свойство("ИНН", ЗначениеПараметров)
							И ПозицияЧека.ДанныеПоставщика.Свойство("ИНН", ЗначениеПозицииЧека) 
							И НЕ ЗначениеПараметров = ЗначениеПозицииЧека Тогда
							ОписаниеОшибки = НСтр("ru = 'ИНН поставщика в строке №%Позиция% не равен ИНН поставщика в шапке.'") ;
							ОписаниеОшибки = СтрЗаменить(ОписаниеОшибки, "%Позиция%", НомерПозицииСтрока);
							Возврат Ложь;
						КонецЕсли;
						Если Параметры.ДанныеПоставщика.Свойство("Наименование", ЗначениеПараметров)
							И ПозицияЧека.ДанныеПоставщика.Свойство("Наименование", ЗначениеПозицииЧека) 
							И НЕ ЗначениеПараметров = ЗначениеПозицииЧека Тогда
							ОписаниеОшибки = НСтр("ru = 'Наименование поставщика в строке №%Позиция% не равно наименованию поставщика в шапке.'") ;
							ОписаниеОшибки = СтрЗаменить(ОписаниеОшибки, "%Позиция%", НомерПозицииСтрока);
							Возврат Ложь;
						КонецЕсли;
						Если Параметры.ДанныеПоставщика.Свойство("Телефон", ЗначениеПараметров)
							И ПозицияЧека.ДанныеПоставщика.Свойство("Телефон", ЗначениеПозицииЧека) 
							И НЕ ЗначениеПараметров = ЗначениеПозицииЧека Тогда
							ОписаниеОшибки = НСтр("ru = 'Телефон поставщика в строке №%Позиция% не равен телефон поставщика в шапке.'") ;
							ОписаниеОшибки = СтрЗаменить(ОписаниеОшибки, "%Позиция%", НомерПозицииСтрока);
							Возврат Ложь;
						КонецЕсли;
					КонецЕсли;
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
	Возврат Истина;
	
КонецФункции

// Структура данных форматно-логического контроля
// 
// Параметры:
//  ПодключаемоеОборудование - СправочникСсылка.ПодключаемоеОборудование - Устройство, фискализирующее чек
// 
// Возвращаемое значение:
//  Структура - Структура данных форматно логического контроля:
//   * СпособФорматноЛогическогоКонтроля - Неопределено -
//   * ДопустимоеРасхождениеФорматноЛогическогоКонтроля - Число -
//   * ФорматФД - Строка -
//   * ФорматФД - Строка, Произвольный -
//
Функция СтруктураДанныхФорматноЛогическогоКонтроля(ПодключаемоеОборудование) Экспорт
	
	ФорматФД = "1.0";
	
	ВозвращаемаяСтруктура = Новый Структура;
	ВозвращаемаяСтруктура.Вставить("СпособФорматноЛогическогоКонтроля"               , Неопределено);
	ВозвращаемаяСтруктура.Вставить("ДопустимоеРасхождениеФорматноЛогическогоКонтроля", 0.01);
	ВозвращаемаяСтруктура.Вставить("ФорматФД", ФорматФД);
		
	СтандартнаяОбработка = Истина;
	ФорматноЛогическийКонтрольКлиентСерверПереопределяемый.ПолучитьСтруктуруДанныхФорматноЛогическогоКонтроля(ПодключаемоеОборудование, ВозвращаемаяСтруктура, СтандартнаяОбработка);
	
	Если Не СтандартнаяОбработка Тогда
		Возврат ВозвращаемаяСтруктура;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ПодключаемоеОборудование.ДопустимоеРасхождениеФорматноЛогическогоКонтроля КАК ДопустимоеРасхождениеФорматноЛогическогоКонтроля,
	|	ПодключаемоеОборудование.СпособФорматноЛогическогоКонтроля КАК СпособФорматноЛогическогоКонтроля
	|ИЗ
	|	Справочник.ПодключаемоеОборудование КАК ПодключаемоеОборудование
	|ГДЕ
	|	ПодключаемоеОборудование.Ссылка = &Ссылка";
	
	Запрос.УстановитьПараметр("Ссылка", ПодключаемоеОборудование);
	
	Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать();
	
	Если Выборка.Следующий() Тогда
		ВозвращаемаяСтруктура.СпособФорматноЛогическогоКонтроля = Выборка.СпособФорматноЛогическогоКонтроля;
		ВозвращаемаяСтруктура.ДопустимоеРасхождениеФорматноЛогическогоКонтроля = Выборка.ДопустимоеРасхождениеФорматноЛогическогоКонтроля;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	|	ПодключаемоеОборудованиеПараметрыРегистрации.ЗначениеПараметра КАК ЗначениеПараметра
	|ИЗ
	|	Справочник.ПодключаемоеОборудование.ПараметрыРегистрации КАК ПодключаемоеОборудованиеПараметрыРегистрации
	|ГДЕ
	|	ПодключаемоеОборудованиеПараметрыРегистрации.Ссылка = &Ссылка
	|	И ПодключаемоеОборудованиеПараметрыРегистрации.НаименованиеПараметра = &НаименованиеПараметра";
	
	Запрос.УстановитьПараметр("Ссылка", ПодключаемоеОборудование);
	Запрос.УстановитьПараметр("НаименованиеПараметра", "ВерсияФФДККТ");
	
	Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать();
	
	Если Выборка.Следующий() Тогда
		ФорматФД = Выборка.ЗначениеПараметра;
	КонецЕсли;
	
	ВозвращаемаяСтруктура.Вставить("ФорматФД", ФорматФД);
	
	Возврат ВозвращаемаяСтруктура;
	
КонецФункции

// Процедура приводит к формату согласованному с ФНС.
// Для старта преобразования данных нужно.
//
//  Параметры:
//    ОсновныеПараметры - см. ОборудованиеЧекопечатающиеУстройстваКлиентСервер.ПараметрыОперацииФискализацииЧека
//    Отказ - Булево
//    ОписаниеОшибки - Строка
//    ИсправленыОсновныеПараметры - Булево
//
Процедура ПривестиДанныеКТребуемомуФормату(ОсновныеПараметры, Отказ, ОписаниеОшибки, ИсправленыОсновныеПараметры) Экспорт
	
	ФорматноЛогическийКонтрольКлиентСервер.ПривестиДанныеКТребуемомуФормату(ОсновныеПараметры, Отказ, ОписаниеОшибки, ИсправленыОсновныеПараметры);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Все существующие форматы ФД, упорядоченные по возрастанию
// 
// Возвращаемое значение:
//  Массив
//
Функция ПолныйМассивФорматовФД()
	
	ПолныйМассив = Новый Массив;
	ПолныйМассив.Добавить("1.0");
	ПолныйМассив.Добавить("1.05");
	ПолныйМассив.Добавить("1.1");
	
	Возврат ПолныйМассив;
КонецФункции 

// Массив проверяемых форматов ФД
// 
// Параметры:
//  ФорматФД - Строка
// 
// Возвращаемое значение:
//  Массив
//
Функция МассивПроверяемыхФорматовФД(ФорматФД)
	
	ПолныйМассив = ПолныйМассивФорматовФД();
	
	ВозвращаемыйМассив = Новый Массив;
	
	Для Каждого ЭлементМассива Из ПолныйМассив Цикл
		
		ВозвращаемыйМассив.Добавить(ЭлементМассива);
		Если ЭлементМассива = ФорматФД Тогда
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
	Возврат ВозвращаемыйМассив;
КонецФункции

// Структуру из двух массивов: реквизиты шапки и реквизиты позиций чека
// 
// Параметры:
//  МассивФФД - Массив - Массив проверяемых ФФД
//  СоответствиеРеквизитов - Структура -Соответствие проверяемых реквизитов и их текстового представления в ошибке.
// 
// Возвращаемое значение:
//  Структура
//
Функция ПроверяемыеРеквизиты(МассивФФД, СоответствиеРеквизитов)
	
	ПроверяемыеРеквизиты = Новый Структура;
	ПроверяемыеРеквизиты.Вставить("РеквизитыШапки", ПроверяемыеРеквизитыШапки(МассивФФД, СоответствиеРеквизитов));
	ПроверяемыеРеквизиты.Вставить("РеквизитыПозицийЧека", ПроверяемыеРеквизитыПозицийЧека(МассивФФД, СоответствиеРеквизитов));
	ПроверяемыеРеквизиты.Вставить("РеквизитыЗаполняемыеИзРегистрационныхДанных", РеквизитыЗаполняемыеИзРегистрационныхДанных(МассивФФД));
	
	Возврат ПроверяемыеРеквизиты;
	
КонецФункции

// Массив проверяемых реквизитов шапки
// 
// Параметры:
//  МассивФФД - Массив - Массив проверяемых ФФД
//  СоответствиеРеквизитов - Соответствие - соответствие проверяемых реквизитов и их текстового представления в ошибке
// 
// Возвращаемое значение:
//  Массив. 
//
Функция ПроверяемыеРеквизитыШапки(МассивФФД, СоответствиеРеквизитов)
	
	МассивРеквизитов = Новый Массив;
	
	Для Каждого ФорматФД Из МассивФФД Цикл
		
		Если ФорматФД = "1.0" Тогда
			МассивРеквизитов.Добавить("ОрганизацияНазвание"); // тег 1048
			СоответствиеРеквизитов.Вставить("ОрганизацияНазвание", НСтр("ru = 'Наименование организации'"));
			
			МассивРеквизитов.Добавить("ОрганизацияИНН"); // тег 1018
			СоответствиеРеквизитов.Вставить("ОрганизацияИНН", НСтр("ru = 'ИНН организации'"));
			
			МассивРеквизитов.Добавить("ТипРасчета"); // тег 1054
			СоответствиеРеквизитов.Вставить("ТипРасчета", НСтр("ru = 'Тип расчета'"));
			
			МассивРеквизитов.Добавить("СистемаНалогообложения"); // тег 1055
			СоответствиеРеквизитов.Вставить("СистемаНалогообложения", НСтр("ru = 'Система налогообложения'"));
			
			МассивРеквизитов.Добавить("Кассир"); // тег 1021
			СоответствиеРеквизитов.Вставить("Кассир", НСтр("ru = 'Кассир'"));
			
			МассивРеквизитов.Добавить("ПозицииЧека"); // тег 1059
			СоответствиеРеквизитов.Вставить("ПозицииЧека", НСтр("ru = 'Позиции чека'"));
			
		ИначеЕсли ФорматФД = "1.05" Тогда
			
		ИначеЕсли ФорматФД = "1.1" Тогда
			
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат МассивРеквизитов;
	
КонецФункции

// Массив проверяемых реквизитов позиций чека
// 
// Параметры:
//  МассивФФД - Массив - Массив проверяемых ФФД
//  СоответствиеРеквизитов - Соответствие - соответствие проверяемых реквизитов и их текстового представления в ошибке.
// 
// Возвращаемое значение:
//  Массив
//
Функция ПроверяемыеРеквизитыПозицийЧека(МассивФФД, СоответствиеРеквизитов)
	
	МассивРеквизитов = Новый Массив;
	
	Для Каждого ФорматФД Из МассивФФД Цикл
		Если ФорматФД = "1.0" Тогда
			
		МассивРеквизитов.Добавить("Количество"); // тег 1023
		СоответствиеРеквизитов.Вставить("Количество", НСтр("ru = 'Количество'"));
			
		МассивРеквизитов.Добавить("СтавкаНДС"); // тег 1199
		СоответствиеРеквизитов.Вставить("СтавкаНДС", НСтр("ru = 'Ставка НДС'"));
		
		ИначеЕсли ФорматФД = "1.05" Тогда
			МассивРеквизитов.Добавить("ПризнакСпособаРасчета"); // тег 1214
			СоответствиеРеквизитов.Вставить("ПризнакСпособаРасчета", НСтр("ru = 'Признак способа расчета'"));
		ИначеЕсли ФорматФД = "1.1" Тогда
			МассивРеквизитов.Добавить("ПризнакПредметаРасчета"); // тег 1212
			СоответствиеРеквизитов.Вставить("ПризнакПредметаРасчета", НСтр("ru = 'Признак предмета расчета'"));
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат МассивРеквизитов;
	
КонецФункции

// Массив реквизитов заполняемые из регистрационных данных
// 
// Параметры:
//  МассивФФД - Массив - Массив проверяемых ФФД.
// 
// Возвращаемое значение:
//  Массив
//
Функция РеквизитыЗаполняемыеИзРегистрационныхДанных(МассивФФД)
	
	МассивРеквизитов = Новый Массив;
	
	Для Каждого ФорматФД Из МассивФФД Цикл
		Если ФорматФД = "1.0" Тогда
			МассивРеквизитов.Добавить("АдресРасчетов"); // тег 1009
		ИначеЕсли ФорматФД = "1.05" Тогда
			МассивРеквизитов.Добавить("МестоРасчетов"); // тег 1187
		ИначеЕсли ФорматФД = "1.1" Тогда
			
		КонецЕсли;
	КонецЦикла;
	
	Возврат МассивРеквизитов;
	
КонецФункции

// Проверка заполненности реквизитов шапки
// 
// Параметры:
//  ВходящиеДанные - Структура -  структура данных чека
//  МассивРеквизитов - Массив - массив имен реквизитов
//  ОписаниеОшибки - Строка - строка заполняемая в случае ошибки
//  СоответствиеРеквизитов - Соответствие - соответствие проверяемых реквизитов и их текстового представления в ошибке
// 
// Возвращаемое значение:
//  Булево
//
Функция ЗаполненыРеквизитыШапки(ВходящиеДанные, МассивРеквизитов, ОписаниеОшибки, СоответствиеРеквизитов)
Перем ЗначениеДанных;
	
	Для Каждого ИмяРеквизита Из МассивРеквизитов Цикл
		Если ВходящиеДанные.Свойство(ИмяРеквизита, ЗначениеДанных) Тогда
			Если НЕ ЗначениеЗаполнено(ЗначениеДанных) Тогда
				ИмяРеквизитаВОшибку = СоответствиеРеквизитов[ИмяРеквизита];
				ОписаниеОшибки = НСтр("ru = 'Тэг ""%Реквизит%"" не заполнен.'");
				ОписаниеОшибки = СтрЗаменить(ОписаниеОшибки, "%Реквизит%", ИмяРеквизитаВОшибку);
				Возврат Ложь;
			КонецЕсли;
		Иначе
			ИмяРеквизитаВОшибку = СоответствиеРеквизитов[ИмяРеквизита];
			ОписаниеОшибки = НСтр("ru = 'Тэг ""%Реквизит%"" отсутствует.'");
			ОписаниеОшибки = СтрЗаменить(ОписаниеОшибки, "%Реквизит%", ИмяРеквизитаВОшибку);
			Возврат Ложь;
		КонецЕсли;
	КонецЦикла;
	
	Возврат Истина;
КонецФункции

// Проверка заполненности реквизитов позиций чека
// 
// Параметры:
//  ПозицииЧека - Массив - Массив структур позиций чека
//  МассивРеквизитов - Массив - массив имен реквизитов
//  ОписаниеОшибки - Строка - Строка, заполняемая в случае ошибки
//  СоответствиеРеквизитов - Соответствие - соответствие проверяемых реквизитов и их текстового представления в ошибке
// 
// Возвращаемое значение:
//  Булево
//
Функция ЗаполненыРеквизитыПозицийЧека(ПозицииЧека, МассивРеквизитов, ОписаниеОшибки, СоответствиеРеквизитов)
Перем ЗначениеДанных;

	НДС18 = Ложь;
	НДС20 = Ложь;
	
	НомерПозиции = 0;
	Для Каждого ПозицияЧека Из ПозицииЧека Цикл
		
		Если ПозицияЧека.Свойство("ФискальнаяСтрока") Тогда
			НомерПозиции = НомерПозиции + 1;
			НомерПозицииСтрока = Формат(НомерПозиции, "ЧГ=0");
			Для Каждого ИмяРеквизита Из МассивРеквизитов Цикл
				Если ПозицияЧека.Свойство(ИмяРеквизита, ЗначениеДанных) Тогда
					Если ИмяРеквизита = "СтавкаНДС" Тогда
						Если ЗначениеДанных = НСтр("ru = 'не указана'") Тогда // АПК: 1391 Локальное законодательство
							ИмяРеквизитаВОшибку = СоответствиеРеквизитов[ИмяРеквизита];
							ОписаниеОшибки = НСтр("ru = 'Тэг ""%Реквизит%"" в строке №%Позиция% не заполнен.'");
							ОписаниеОшибки = СтрЗаменить(ОписаниеОшибки, "%Реквизит%", ИмяРеквизитаВОшибку);
							ОписаниеОшибки = СтрЗаменить(ОписаниеОшибки, "%Позиция%" , НомерПозицииСтрока);
							Возврат Ложь;
						ИначеЕсли ЗначениеДанных = 18 Или ЗначениеДанных = 118 Тогда 
							НДС18 = Истина;
						ИначеЕсли ЗначениеДанных = 20 Или ЗначениеДанных = 120 Тогда 
							НДС20 = Истина;
						КонецЕсли;
					ИначеЕсли НЕ ЗначениеЗаполнено(ЗначениеДанных) Тогда
						ИмяРеквизитаВОшибку = СоответствиеРеквизитов[ИмяРеквизита];
						ОписаниеОшибки = НСтр("ru = 'Тэг ""%Реквизит%"" в строке №%Позиция% не заполнен.'");
						ОписаниеОшибки = СтрЗаменить(ОписаниеОшибки, "%Реквизит%", ИмяРеквизитаВОшибку);
						ОписаниеОшибки = СтрЗаменить(ОписаниеОшибки, "%Позиция%" , НомерПозицииСтрока);
						Возврат Ложь;
					КонецЕсли;
				Иначе
					ИмяРеквизитаВОшибку = СоответствиеРеквизитов[ИмяРеквизита];
					ОписаниеОшибки = НСтр("ru = 'Тэг ""%Реквизит%"" в строке №%Позиция% отсутствует.'");
					ОписаниеОшибки = СтрЗаменить(ОписаниеОшибки, "%Реквизит%", ИмяРеквизитаВОшибку);
					ОписаниеОшибки = СтрЗаменить(ОписаниеОшибки, "%Позиция%" , НомерПозицииСтрока);
					Возврат Ложь;
				КонецЕсли;
			КонецЦикла;
		КонецЕсли;
	КонецЦикла;
	
	Если НДС18 И НДС20 Тогда
		ОписаниеОшибки = НСтр("ru = 'Ставки НДС 20% и НДС 18% в одном чеке не допустимы.'");
		Возврат Ложь;
	КонецЕсли;
	
	Возврат Истина;
	
КонецФункции

// Заполняет реквизиты из регистрационных данных
//
// Параметры:
//  ВходящиеДанные - Структура - структура данных чека
//  МассивРеквизитов - Массив - массив имен реквизитов
//
Процедура ЗаполнитьРеквизитовИзРегистрационныхДанных(ВходящиеДанные, МассивРеквизитов, ПараметрыРегистрацииУстройства)
Перем ЗначениеДанных;
	
	МассивНеЗаполненныхРеквизитов = Новый Массив;
	Для Каждого ИмяРеквизита Из МассивРеквизитов Цикл
		Если ВходящиеДанные.Свойство(ИмяРеквизита, ЗначениеДанных) Тогда
			Если НЕ ЗначениеЗаполнено(ЗначениеДанных) Тогда
				МассивНеЗаполненныхРеквизитов.Добавить(ИмяРеквизита);
			КонецЕсли;
		Иначе
			МассивНеЗаполненныхРеквизитов.Добавить(ИмяРеквизита);
		КонецЕсли;
	КонецЦикла;
	
	Если МассивНеЗаполненныхРеквизитов.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	Для Каждого ИмяРеквизита Из МассивНеЗаполненныхРеквизитов Цикл
		Если ИмяРеквизита = "АдресРасчетов" Тогда
			ВходящиеДанные.Вставить(ИмяРеквизита, ПараметрыРегистрацииУстройства.АдресПроведенияРасчетов);
		ИначеЕсли ИмяРеквизита = "МестоРасчетов" Тогда
			ВходящиеДанные.Вставить(ИмяРеквизита, ПараметрыРегистрацииУстройства.МестоПроведенияРасчетов);
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

// Выполняется проверка корректности занесения сведений о покупателе, 
// если поле "Покупатель" заполнено, тогда должно быть заполнено либо поле "ИНН", 
// либо персональные сведения о покупателе.
// Реквизиты "дата рождения покупателя (клиента)" (тег 1243), "код вида документа, удостоверяющего личность" (тег 
// 1245), "данные документа, удостоверяющего личность" (тег 1246) включаются в состав ФД в случае не включения в 
// состав ФД реквизита "ИНН покупателя (клиента)" (тег 1228).
// 
// Параметры:
//   Параметры - см. ОборудованиеЧекопечатающиеУстройстваКлиентСервер.ПараметрыОперацииФискализацииЧека
//   ФорматФД - Строка - версия формата фискальных документов
//   ОписаниеОшибки - Строка
//
// Возвращаемое значение:
//   Булево
Функция СведенияОПокупателеКорректны(Параметры, ОписаниеОшибки)
	
	ФорматФД = Параметры.ФорматФД;
	 // при формате 1.05 реквизит необязателен
	Если ФорматФД = "1.05" Тогда 
		Возврат Истина;
	КонецЕсли;
	
	СведенияОПокупателе = Параметры.СведенияОПокупателе;
	Если ПустаяСтрока(Параметры.Получатель) И ПустаяСтрока(СведенияОПокупателе.Покупатель) Тогда
		Возврат Истина;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Параметры.ПолучательИНН) Или ЗначениеЗаполнено(СведенияОПокупателе.ПокупательИНН) Тогда
		Возврат Истина;
	КонецЕсли;
	
	Если Параметры.ЕстьПерсональныеДанные Тогда
		ПерсональныеДанные    = ОборудованиеЧекопечатающиеУстройстваКлиентСервер.ПараметрыПерсональныеДанныеПокупателя();
		ТипПерсональныхДанных = Параметры.ТипПерсональныхДанных;
		
		МенеджерОборудованияВызовСервераПереопределяемый.ОбработкаЗаполненияПерсональныхДанных(
			ПерсональныеДанные, 
			Параметры.СубъектПерсональныхДанных, 
			ТипПерсональныхДанных, 
			?(ПустаяСтрока(Параметры.ДатаВремя), МенеджерОборудованияВызовСервера.ДатаСеанса(), Параметры.ДатаВремя));
				
		Если ТипПерсональныхДанных = Перечисления.ТипыПерсональныхДанныхККТ.ИНН И ЗначениеЗаполнено(ПерсональныеДанные.ИНН)  Тогда
			Возврат Истина;
		ИначеЕсли ТипПерсональныхДанных = Перечисления.ТипыПерсональныхДанныхККТ.ПаспортныеДанные 
				И ЗначениеЗаполнено(ПерсональныеДанные.ДатаРождения) 
				И ЗначениеЗаполнено(ПерсональныеДанные.ВидДокумента) 
				И ЗначениеЗаполнено(ПерсональныеДанные.ДанныеДокумента) Тогда
			Возврат Истина;
		КонецЕсли;
	КонецЕсли;
	
	ОписаниеОшибки = НСтр("ru = 'Не указан ИНН или дата рождения и реквизиты документа удостоверяющего личность покупателя.'");
	Возврат Ложь;
	
КонецФункции

#КонецОбласти