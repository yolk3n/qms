﻿////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ
#Область ОбработчикиСобытий

Процедура ОбработкаПолученияФормы(ВидФормы, Параметры, ВыбраннаяФорма, ДополнительнаяИнформация, СтандартнаяОбработка)
	
	Если ВидФормы = "ФормаОбъекта" Тогда
		
		СтандартнаяОбработка = Ложь;
		ЭтоГруппаШаблонов = Ложь;
		ШаблонПроводки = Неопределено;
		Если Параметры.Свойство("Ключ", ШаблонПроводки) И ЗначениеЗаполнено(ШаблонПроводки)
		 Или Параметры.Свойство("ЗначениеКопирования", ШаблонПроводки) И ЗначениеЗаполнено(ШаблонПроводки) Тогда
			Запрос = Новый Запрос("ВЫБРАТЬ ЭтоГруппаШаблонов ИЗ Справочник.ШаблоныСводныхПроводокДляОбменаСБухгалтерией ГДЕ Ссылка = &Ссылка");
			Запрос.УстановитьПараметр("Ссылка", ШаблонПроводки);
			Выборка = Запрос.Выполнить().Выбрать();
			Выборка.Следующий();
			ЭтоГруппаШаблонов = Выборка.ЭтоГруппаШаблонов;
		ИначеЕсли Параметры.Свойство("ДополнительныеПараметры") Тогда
			Если Параметры.ДополнительныеПараметры.Свойство("ЭтоГруппаШаблонов") Тогда
				ЭтоГруппаШаблонов = Параметры.ДополнительныеПараметры.ЭтоГруппаШаблонов;
			КонецЕсли;
		КонецЕсли;
		
		ВыбраннаяФорма = ?(ЭтоГруппаШаблонов, "ФормаГруппы", "ФормаЭлемента");
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти // ОбработчикиСобытий

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

////////////////////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС
#Область ПрограммныйИнтерфейс

// Инициализирует компоновщик настроек дополнительного отбора
// данных шаблонов сводных проводок схемой компоновки данных,
// полученной из настроек хозяйственных операций.
//
// Параметры:
//  Форма    - ФормаКлиентскогоПриложения - форма-владелец компоновщика дополнительного отбора шаблона сводных проводок.
//  Операция - СправочникСсылка.НастройкиХозяйственныхОпераций - найтройка хозяйственной операции,
//             по которой будет инициализирован компоновщик дополнительного отбора данных шаблона сводных проводок.
//
Процедура ИнициализироватьКомпоновщик(Форма, Операция) Экспорт
	
	СхемаКомпоновкиДанных = Справочники.НастройкиХозяйственныхОпераций.СхемаПолученияДанных(Операция);
	Если СхемаКомпоновкиДанных <> Неопределено Тогда
		АдресСКД = ПоместитьВоВременноеХранилище(СхемаКомпоновкиДанных, Форма.УникальныйИдентификатор);
		Форма.Компоновщик.Инициализировать(Новый ИсточникДоступныхНастроекКомпоновкиДанных(АдресСКД));
	КонецЕсли;
	
КонецПроцедуры

// Загружает настройки дополнительного отбора данных шаблонов сводных проводок.
//
// Параметры:
//  Форма     - ФормаКлиентскогоПриложения - форма-владелец компоновщика дополнительного отбора шаблона сводных проводок.
//  Настройки - НастройкиКомпоновкиДанных - настройки дополнительного отбора данных,
//              которые будут загружены в компоновщик.
//
Процедура ЗагрузитьНастройки(Форма, Настройки) Экспорт
	
	Если Настройки <> Неопределено Тогда
		Форма.Компоновщик.ЗагрузитьНастройки(Настройки);
		Форма.Компоновщик.Восстановить();
	КонецЕсли;
	
КонецПроцедуры

// Записывает дополнительный отбор данных шаблонов сводных проводок
// в справочник ШаблоныСводныхПроводокДляОбменаСБухгалтерией.
//
// Параметры:
//  Форма  - ФормаКлиентскогоПриложения - форма-владелец компоновщика дополнительного отбора шаблона сводных проводок.
//  Объект - СправочникОбъект.ШаблоныСводныхПроводокДляОбменаСБухгалтерией - объект,
//                  в который записывается дополнительный отбор данных шаблонов сводных проводок.
//
Процедура ЗаписатьДополнительныйОтбор(Форма, Объект) Экспорт
	
	Объект.ДополнительныйОтбор           = Новый ХранилищеЗначения(Форма.Компоновщик.ПолучитьНастройки());
	Объект.УстановленДополнительныйОтбор = Форма.Компоновщик.Настройки.Отбор.Элементы.Количество() > 0;
	Объект.ПредставлениеОтбора           = Строка(Форма.Компоновщик.Настройки.Отбор);
	
КонецПроцедуры

// Меняет настройку хозяйственной операции для иерархии переданного шаблона сводных проводок.
//
// Параметры:
//  ШаблонПроводки - СправочникСсылка.ШаблоныСводныхПроводокДляОбменаСБухгалтерией - шаблон проводки,
//                   для иерархии которого будет изменена настройка хозяйственной операции.
//  Операция       - СправочникСсылка.НастройкиХозяйственныхОпераций - устанавливаемая настройка хозяйственной операции.
//
Процедура ПоменятьОперациюШаблонаПроводки(ШаблонПроводки, Операция) Экспорт
	
	Запрос = Новый Запрос("
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ШаблоныПроводок.Ссылка КАК Ссылка
	|ИЗ
	|	Справочник.ШаблоныСводныхПроводокДляОбменаСБухгалтерией КАК ШаблоныПроводок
	|ГДЕ
	|	ШаблоныПроводок.Ссылка В ИЕРАРХИИ(&Ссылка)
	|	И ШаблоныПроводок.Операция <> &Операция
	|");
	
	Запрос.УстановитьПараметр("Ссылка"  , ШаблонПроводки);
	Запрос.УстановитьПараметр("Операция", Операция);
	
	РезультатЗапроса = Запрос.Выполнить();
	Если РезультатЗапроса.Пустой() Тогда
		Возврат;
	КонецЕсли;
	
	НачатьТранзакцию();
	
	Попытка
		
		Блокировка = Новый БлокировкаДанных;
		ЭлементБлокировки = Блокировка.Добавить(ШаблонПроводки.Метаданные().ПолноеИмя());
		ЭлементБлокировки.ИсточникДанных = РезультатЗапроса;
		ЭлементБлокировки.ИспользоватьИзИсточникаДанных("Ссылка", "Ссылка");
		ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
		Блокировка.Заблокировать();
		
		Выборка = РезультатЗапроса.Выбрать();
		Пока Выборка.Следующий() Цикл
			
			ШаблонОбъект = Выборка.Ссылка.ПолучитьОбъект();
			ШаблонОбъект.Операция = Операция;
			
			Если Выборка.Ссылка = ШаблонПроводки Тогда
				ШаблонОбъект.Родитель = Неопределено;
			КонецЕсли;
			
			ОбновитьРеквизитыЗависящиеОтОперации(ШаблонОбъект);
			
			ШаблонОбъект.Записать();
			
		КонецЦикла;
		
		ЗафиксироватьТранзакцию();
		
	Исключение
		
		ОтменитьТранзакцию();
		ВызватьИсключение;
		
	КонецПопытки;
	
КонецПроцедуры

#КонецОбласти // ПрограммныйИнтерфейс

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ
#Область СлужебныеПроцедурыИФункции

Процедура ОбновитьРеквизитыЗависящиеОтОперации(ШаблонОбъект)
	
	Компоновщик = Новый КомпоновщикНастроекКомпоновкиДанных;
	
	СхемаКомпоновкиДанных = Справочники.НастройкиХозяйственныхОпераций.СхемаПолученияДанных(ШаблонОбъект.Операция);
	Если СхемаКомпоновкиДанных <> Неопределено Тогда
		Компоновщик.Инициализировать(Новый ИсточникДоступныхНастроекКомпоновкиДанных(ПоместитьВоВременноеХранилище(СхемаКомпоновкиДанных)));
		Если ШаблонОбъект.УстановленДополнительныйОтбор Тогда
			Компоновщик.ЗагрузитьНастройки(ШаблонОбъект.ДополнительныйОтбор.Получить());
			Компоновщик.Восстановить();
		КонецЕсли;
	КонецЕсли;
	
	ШаблонОбъект.ДополнительныйОтбор           = Новый ХранилищеЗначения(Компоновщик.ПолучитьНастройки());
	ШаблонОбъект.УстановленДополнительныйОтбор = Компоновщик.Настройки.Отбор.Элементы.Количество() > 0;
	ШаблонОбъект.ПредставлениеОтбора           = Строка(Компоновщик.Настройки.Отбор);
	
	ОбновитьВидыСубконто(ШаблонОбъект, Компоновщик.Настройки.Выбор.ДоступныеПоляВыбора);
	
	ОбновитьАналитическиеПоказатели(ШаблонОбъект);
	
КонецПроцедуры

Процедура ОбновитьВидыСубконто(ШаблонОбъект, ДоступныеПоляВыбора)
	
	СоставОбмена = ОбщегоНазначения.ОбъектМетаданныхПоИдентификатору(ШаблонОбъект.ПланОбмена).Состав;
	ДоступныеСубконто = Метаданные.ОпределяемыеТипы.Субконто.Тип.Типы();
	
	ИменаВидовСубконто = Новый Массив;
	ИменаВидовСубконто.Добавить("СубконтоСчетаДебета1");
	ИменаВидовСубконто.Добавить("СубконтоСчетаДебета2");
	ИменаВидовСубконто.Добавить("СубконтоСчетаДебета3");
	ИменаВидовСубконто.Добавить("СубконтоСчетаКредита1");
	ИменаВидовСубконто.Добавить("СубконтоСчетаКредита2");
	ИменаВидовСубконто.Добавить("СубконтоСчетаКредита3");
	
	Для Каждого ИмяВидаСубконто Из ИменаВидовСубконто Цикл
		
		ВидСубконто = ШаблонОбъект[ИмяВидаСубконто];
		
		Если Не ЗначениеЗаполнено(ВидСубконто) Тогда
			Продолжить;
		КонецЕсли;
		
		ТипСубконто = ТипЗнч(ВидСубконто);
		
		Если ОбщегоНазначения.ЭтоСсылка(ТипСубконто) Тогда
			
			Если Не СоставОбмена.Содержит(Метаданные.НайтиПоТипу(ТипСубконто))
			 Или Не ДоступныеСубконто.Найти(ТипСубконто) Тогда
				ШаблонОбъект[ИмяВидаСубконто] = Неопределено;
			КонецЕсли;
			
		Иначе
			
			ПолеВыбора = ДоступныеПоляВыбора.НайтиПоле(Новый ПолеКомпоновкиДанных(ВидСубконто));
			Если ПолеВыбора = Неопределено Тогда
				ШаблонОбъект[ИмяВидаСубконто] = Неопределено;
			Иначе
				
				ВходитВСоставОбмена = Ложь;
				Для Каждого Тип Из ПолеВыбора.Тип.Типы() Цикл
					Если ОбщегоНазначения.ЭтоСсылка(Тип) И СоставОбмена.Содержит(Метаданные.НайтиПоТипу(Тип)) Тогда
						ВходитВСоставОбмена = Истина;
						Прервать;
					КонецЕсли;
				КонецЦикла;
				
				Если Не ВходитВСоставОбмена Тогда
					ШаблонОбъект[ИмяВидаСубконто] = Неопределено;
				КонецЕсли;
				
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

Процедура ОбновитьАналитическиеПоказатели(ШаблонОбъект)
	
	Запрос = Новый Запрос("
	|ВЫБРАТЬ
	|	ПоказателиРегистра.Показатель КАК Показатель
	|ИЗ
	|	Справочник.НастройкиХозяйственныхОпераций.ПоказателиРегистра КАК ПоказателиРегистра
	|ГДЕ
	|	ПоказателиРегистра.Ссылка = &Операция
	|	И ПоказателиРегистра.Использование
	|");
	
	Запрос.УстановитьПараметр("Операция", ШаблонОбъект.Операция);
	АналитическиеПоказатели = Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Показатель");
	
	Если Не ШаблонОбъект.ИсточникКоличестваДебета.Пустая()
	   И АналитическиеПоказатели.Найти(ШаблонОбъект.ИсточникКоличестваДебета) = Неопределено Тогда
		ШаблонОбъект.ИсточникКоличестваДебета = Неопределено;
	КонецЕсли;
	
	Если Не ШаблонОбъект.ИсточникКоличестваКредита.Пустая()
	   И АналитическиеПоказатели.Найти(ШаблонОбъект.ИсточникКоличестваКредита) = Неопределено Тогда
		ШаблонОбъект.ИсточникКоличестваКредита = Неопределено;
	КонецЕсли;
	
	ОбщегоНазначенияКлиентСервер.УдалитьЗначениеИзМассива(АналитическиеПоказатели, Перечисления.ПоказателиАналитическихРегистров.Количество);
	ОбщегоНазначенияКлиентСервер.УдалитьЗначениеИзМассива(АналитическиеПоказатели, Перечисления.ПоказателиАналитическихРегистров.КоличествоВОсновныхЕдиницахУчета);
	ОбщегоНазначенияКлиентСервер.УдалитьЗначениеИзМассива(АналитическиеПоказатели, Перечисления.ПоказателиАналитическихРегистров.КорКоличество);
	ОбщегоНазначенияКлиентСервер.УдалитьЗначениеИзМассива(АналитическиеПоказатели, Перечисления.ПоказателиАналитическихРегистров.КорКоличествоВОсновныхЕдиницахУчета);
	
	Если Не ШаблонОбъект.ИсточникБалансовойСуммы.Пустая()
	   И АналитическиеПоказатели.Найти(ШаблонОбъект.ИсточникБалансовойСуммы) = Неопределено Тогда
		ШаблонОбъект.ИсточникБалансовойСуммы = Неопределено;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти // СлужебныеПроцедурыИФункции

#КонецЕсли