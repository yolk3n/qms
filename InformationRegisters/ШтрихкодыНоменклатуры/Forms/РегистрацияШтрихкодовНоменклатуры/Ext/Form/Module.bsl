﻿
////////////////////////////////////////////////////////////////////////////////
// ОПИСАНИЕ ПЕРЕМЕННЫХ
#Область ОписаниеПеременных

&НаКлиенте
Перем КэшированныеЗначения;

#КонецОбласти // ОписаниеПеременных

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьУсловноеОформлениеФормы();
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	// ПодключаемоеОборудование
	ПодключаемоеОборудованиеСервер.НастроитьФормуДляИспользованияПодключаемогоОборудования(ЭтотОбъект);
	// Конец ПодключаемоеОборудование
	
	// ЭлектронноеВзаимодействие.РаботаСНоменклатурой
	ИспользуетсяСервис1СНоменклатура = РаботаСНоменклатурой.ДоступнаФункциональностьПодсистемы()
		И ИнтернетПоддержкаПользователей.ЗаполненыДанныеАутентификацииПользователяИнтернетПоддержки();
	
	Элементы.ШтрихкодыНоменклатурыНоменклатураСервиса.Видимость                       = ИспользуетсяСервис1СНоменклатура;
	Элементы.ШтрихкодыНоменклатурыКонтекстноеМенюСоздатьНоменклатуруСервиса.Видимость = ИспользуетсяСервис1СНоменклатура И РаботаСНоменклатурой.РазрешеноПакетноеСозданиеНоменклатуры();
	// Конец ЭлектронноеВзаимодействие.РаботаСНоменклатурой
	
	ОбработатьШтрихкоды(Параметры.НеизвестныеШтрихкоды);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// ПодключаемоеОборудование
	МенеджерОборудованияКлиент.НачатьПодключениеОборудованиеПриОткрытииФормы(Неопределено, ЭтотОбъект, "СканерШтрихкода");
	// Конец ПодключаемоеОборудование
	
	ПолучитьНоменклатуруСервиса();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	// ПодключаемоеОборудование
	Если ПодключаемоеОборудованиеКлиент.ОбрабатыватьОповещение(ЭтотОбъект, Источник) Тогда
		Если ПодключаемоеОборудованиеКлиент.ОбработатьПолучениеДанныхОтСканераШтрихкода(ЭтотОбъект, ИмяСобытия, Параметр) Тогда
			ДанныеШтрихкода = ОбщегоНазначенияБольничнаяАптекаКлиентСервер.ПолучитьДанныеШтрихкода(Параметр, 1);
			ОбработатьШтрихкоды(ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(ДанныеШтрихкода));
			ПолучитьНоменклатуруСервиса();
		КонецЕсли;
	КонецЕсли;
	// Конец ПодключаемоеОборудование
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	
	// ПодключаемоеОборудование
	МенеджерОборудованияКлиент.НачатьОтключениеОборудованиеПриЗакрытииФормы(Неопределено, ЭтотОбъект);
	// Конец ПодключаемоеОборудование
	
	
	Если ЗавершениеРаботы Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыЗакрытия = Новый Структура;
	
	ЗарегистрированныеШтрихкоды = Новый Массив;
	ЗарегистрированыОбработкой = ШтрихкодыНоменклатуры.НайтиСтроки(Новый Структура("ЗарегистрированОбработкой", Истина));
	Для Каждого СтрокаШтрихкода Из ЗарегистрированыОбработкой Цикл
		ЗарегистрированныеШтрихкоды.Добавить(СтрокаШтрихкода.Штрихкод);
	КонецЦикла;
	
	ЗарегистрированыРанее = ШтрихкодыНоменклатуры.НайтиСтроки(Новый Структура("Зарегистрирован", Истина));
	Для Каждого СтрокаШтрихкода Из ЗарегистрированыРанее Цикл
		ЗарегистрированныеШтрихкоды.Добавить(СтрокаШтрихкода.Штрихкод);
	КонецЦикла;
	
	ПараметрыЗакрытия.Вставить("ЗарегистрированныеШтрихкоды", ЗарегистрированныеШтрихкоды);
	ПараметрыЗакрытия.Вставить("КлючВладельца", ВладелецФормы.УникальныйИдентификатор);
	
	Оповестить("ЗарегистрированыШтрихкоды", ПараметрыЗакрытия, "РегистрацияШтрихкодов");
	
КонецПроцедуры

#КонецОбласти // ОбработчикиСобытийФормы

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ
#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура СоздатьНоменклатуруСервиса(Команда)
	
	Идентификаторы = Новый Массив;
	Для Каждого ИдентификаторСтроки Из Элементы.ШтрихкодыНоменклатуры.ВыделенныеСтроки Цикл
		Строка = ШтрихкодыНоменклатуры.НайтиПоИдентификатору(ИдентификаторСтроки);
		Если Не ЗначениеЗаполнено(Строка.Номенклатура) И Не Строка.НоменклатураСервисаЗаписана Тогда
			Идентификаторы.Добавить(Новый Структура("ИдентификаторНоменклатуры, ИдентификаторХарактеристики", Строка.ИдентификаторНоменклатурыСервиса));
		КонецЕсли;
	КонецЦикла;
	
	Если Не ЗначениеЗаполнено(Идентификаторы) Тогда
		ПоказатьПредупреждение(, НСтр("ru='Нет данных для загрузки из сервиса 1С:Номенклатура.'"));
		Возврат;
	КонецЕсли;
	
	Оповестить = Новый ОписаниеОповещения("ОбработатьСозданиеНоменклатурыСервиса", ЭтотОбъект, Новый Структура);
	РаботаСНоменклатуройКлиент.ЗагрузитьНоменклатуруИХарактеристики(Оповестить, Идентификаторы, ЭтотОбъект,, ИдентификаторЗадания);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаписатьИЗакрыть(Команда)
	
	ЗаписатьДанныеШтрихкодов();
	
	ЗарегистрированоОбработкой = ШтрихкодыНоменклатуры.НайтиСтроки(Новый Структура("ЗарегистрированОбработкой", Истина)).Количество();
	ШтрихкодовБезРегистрации = ШтрихкодыНоменклатуры.НайтиСтроки(Новый Структура("Зарегистрирован, ЗарегистрированОбработкой", Ложь, Ложь)).Количество();
	
	ТекстОповещений = НСтр("ru='Зарегистрировано новых штрихкодов: %1
								|Штрихкодов без регистрации: %2'");
	
	ПоказатьОповещениеПользователя(
		НСтр("ru='Регистрация штрихкодов'"),
		,
		СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстОповещений, ЗарегистрированоОбработкой, ШтрихкодовБезРегистрации),
		БиблиотекаКартинок.Информация32);
	
	Закрыть();
	
КонецПроцедуры

#КонецОбласти // ОбработчикиКомандФормы

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ФОРМЫ
#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура ШтрихкодыНоменклатурыВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	Если Поле = Элементы.ШтрихкодыНоменклатурыНоменклатураСервиса Тогда
		
		СтандартнаяОбработка = Ложь;
		
		ТекущиеДанные = ШтрихкодыНоменклатуры.НайтиПоИдентификатору(ВыбраннаяСтрока);
		Если ТекущиеДанные = Неопределено Или Не ЗначениеЗаполнено(ТекущиеДанные.ИдентификаторНоменклатурыСервиса) Тогда
			Возврат;
		КонецЕсли;
		
		ПараметрыФормы = Новый Структура;
		ПараметрыФормы.Вставить("ИдентификаторыНоменклатуры", ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(ТекущиеДанные.ИдентификаторНоменклатурыСервиса));
		ПараметрыФормы.Вставить("ЭтоРежимПросмотра"         , ЗначениеЗаполнено(ТекущиеДанные.Номенклатура) И Не ТекущиеДанные.НоменклатураСервисаЗаписана);
		
		Оповестить = Новый ОписаниеОповещения("ОбработатьЗакрытиеФормыКарточкиНоменклатурыСервиса", ЭтотОбъект, ТекущиеДанные.ИдентификаторНоменклатурыСервиса);
		РаботаСНоменклатуройКлиент.ОткрытьФормуКарточкиНоменклатурыСервиса(ПараметрыФормы, ЭтотОбъект, Оповестить);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ШтрихкодыНоменклатурыПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	Отказ = Истина;
КонецПроцедуры

&НаКлиенте
Процедура ШтрихкодыНоменклатурыПередУдалением(Элемент, Отказ)
	Отказ = Истина;
КонецПроцедуры

&НаКлиенте
Процедура ШтрихкодыНоменклатурыНоменклатураПриИзменении(Элемент)
	
	ОбработатьИзменениеНоменклатуры(Элементы.ШтрихкодыНоменклатуры.ТекущиеДанные);
	
КонецПроцедуры

#КонецОбласти // ОбработчикиСобытийЭлементовФормы

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ
#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформлениеФормы()
	
	// Только просмотр поля ШтрихкодыНоменклатуры
	Элемент = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ШтрихкодыНоменклатуры.Имя);
	
	ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(Элемент.Отбор,
		"ШтрихкодыНоменклатуры.Зарегистрирован", ВидСравненияКомпоновкиДанных.Равно, Истина);
	
	Элемент.Оформление.УстановитьЗначениеПараметра("ТолькоПросмотр", Истина);
	
	// Шрифт, Текст поля ШтрихкодыНоменклатурыСостояние
	Элемент = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ШтрихкодыНоменклатурыСостояние.Имя);
	
	ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(Элемент.Отбор,
		"ШтрихкодыНоменклатуры.Зарегистрирован", ВидСравненияКомпоновкиДанных.Равно, Ложь);
	
	Элемент.Оформление.УстановитьЗначениеПараметра("Шрифт", Новый Шрифт(ШрифтыСтиля.ШрифтТекста,,, Истина));
	Элемент.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru = 'Новый'"));
	
	// Текст поля ШтрихкодыНоменклатурыСостояние
	Элемент = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ШтрихкодыНоменклатурыСостояние.Имя);
	
	ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(Элемент.Отбор,
		"ШтрихкодыНоменклатуры.Зарегистрирован", ВидСравненияКомпоновкиДанных.Равно, Истина);
	
	Элемент.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru = 'Зарегистрирован'"));
	
	// ЭлектронноеВзаимодействие.РаботаСНоменклатурой
	
	// Цвет текста гиперссылки поля ШтрихкодыНоменклатурыНоменклатураСервиса
	Элемент = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ШтрихкодыНоменклатурыНоменклатураСервиса.Имя);
	
	ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(Элемент.Отбор,
		"ШтрихкодыНоменклатуры.НоменклатураСервисаЗаписана", ВидСравненияКомпоновкиДанных.Равно, Истина);
	
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ЦветГиперссылкиБЭД);
	
	// Цвет текста гиперссылки поля ШтрихкодыНоменклатурыНоменклатураСервиса
	Элемент = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ШтрихкодыНоменклатурыНоменклатураСервиса.Имя);
	
	ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(Элемент.Отбор,
		"ШтрихкодыНоменклатуры.НоменклатураСервисаЗаписана", ВидСравненияКомпоновкиДанных.Равно, Ложь);
	
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ЦветТекстаНесопоставленногоОбъектаБЭД);
	
	// Конец ЭлектронноеВзаимодействие.РаботаСНоменклатурой
	
КонецПроцедуры

&НаСервере
Процедура ОбработатьШтрихкоды(ДанныеШтрихкодов)
	
	ДобавленныеСтроки = Новый Массив;
	Для Каждого ЭлементДанных Из ДанныеШтрихкодов Цикл
		НайденныеСтроки = ШтрихкодыНоменклатуры.НайтиСтроки(Новый Структура("Штрихкод", ЭлементДанных.Штрихкод));
		Если НайденныеСтроки.Количество() = 0 Тогда
			
			НовыйШтрихкод = ШтрихкодыНоменклатуры.Добавить();
			НовыйШтрихкод.Штрихкод = ЭлементДанных.Штрихкод;
			ДобавленныеСтроки.Добавить(НовыйШтрихкод);
			
		КонецЕсли;
	КонецЦикла;
	
	Если ДобавленныеСтроки.Количество() > 0 Тогда
		ЗаполнитьДанныеПоШтрихкодам(ДобавленныеСтроки);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьДанныеПоШтрихкодам(СтрокиШтрихкодовНоменклатуры)
	
	Штрихкоды = Новый Массив;
	Для Каждого Строка Из СтрокиШтрихкодовНоменклатуры Цикл
		Штрихкоды.Добавить(Строка.Штрихкод);
	КонецЦикла;
	
	ДанныеПоШтрихкодам = ПолучитьДанныеПоШтрихкодам(Штрихкоды);
	
	Для Каждого Строка Из СтрокиШтрихкодовНоменклатуры Цикл
		ДанныеШтрихкода = ДанныеПоШтрихкодам[Строка.Штрихкод];
		Если Не ДанныеШтрихкода.НеизвестныйШтрихкод Тогда
			ЗаполнитьЗначенияСвойств(Строка, ДанныеШтрихкода);
			Строка.Зарегистрирован = Истина;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьДанныеПоШтрихкодам(Штрихкоды)
	
	ДанныеПоШтрихкодам = РегистрыСведений.ШтрихкодыНоменклатуры.ПолучитьДанныеПоШтрихкодам(Штрихкоды);
	
	НенайденныеШтрихкоды = Новый Массив;
	Для Каждого ДанныеШтрихкода Из ДанныеПоШтрихкодам Цикл
		
		Если ДанныеШтрихкода.Значение.НеизвестныйШтрихкод Тогда
			НенайденныеШтрихкоды.Добавить(ДанныеШтрихкода.Ключ);
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат ДанныеПоШтрихкодам;
	
КонецФункции

&НаСервере
Процедура ЗаписатьДанныеШтрихкодов()
	
	Для Каждого СтрокаШтрихкода Из ШтрихкодыНоменклатуры Цикл
		
		Если СтрокаШтрихкода.Зарегистрирован
		 Или Не ЗначениеЗаполнено(СтрокаШтрихкода.Номенклатура)
		 Или Не ЗначениеЗаполнено(СтрокаШтрихкода.ЕдиницаИзмерения) Тогда
			Продолжить;
		КонецЕсли;
		
		МенеджерЗаписи = РегистрыСведений.ШтрихкодыНоменклатуры.СоздатьМенеджерЗаписи();
		МенеджерЗаписи.Штрихкод = СтрокаШтрихкода.Штрихкод;
		МенеджерЗаписи.Номенклатура = СтрокаШтрихкода.Номенклатура;
		МенеджерЗаписи.ЕдиницаИзмерения = СтрокаШтрихкода.ЕдиницаИзмерения;
		МенеджерЗаписи.Записать();
		
		СтрокаШтрихкода.ЗарегистрированОбработкой = Истина;
		
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработатьИзменениеНоменклатуры(ТекущаяСтрока)
	
	Действия = ОбработкаТабличнойЧастиКлиентСервер;
	
	СтруктураДействий = Новый Структура;
	СтруктураДействий.Вставить(Действия.Действие_ПроверитьУпаковкуПоВладельцу(), ТекущаяСтрока.ЕдиницаИзмерения);
	СтруктураДействий.Вставить(Действия.Действие_ЗаполнитьЕдиницуИзмерения(), НоменклатураКлиентСервер.ВидЕдиницы_ПотребительскаяУпаковка());
	
	ОбработкаТабличнойЧастиКлиент.ОбработатьСтрокуТабличнойЧасти(ТекущаяСтрока, СтруктураДействий, КэшированныеЗначения);
	
	ПолучитьНоменклатуруСервиса();
	
КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
// Работа с номенклатурой сервиса 1С:Номенклатура
#Область РаботаСНоменклатуройСервиса

&НаКлиенте
Процедура ПолучитьНоменклатуруСервиса()
	
	Если Не ИспользуетсяСервис1СНоменклатура Тогда
		Возврат;
	КонецЕсли;
	
	ПолучитьНоменклатуруСервисаНаСервере();
	
	Штрихкоды = Новый Массив;
	Для Каждого Строка Из ШтрихкодыНоменклатуры Цикл
		Если Не ЗначениеЗаполнено(Строка.ИдентификаторНоменклатурыСервиса) Тогда
			Штрихкоды.Добавить(Строка.Штрихкод);
		КонецЕсли;
	КонецЦикла;
	
	Если Штрихкоды.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	Оповестить = Новый ОписаниеОповещения("ЗавершитьПолучениеНоменклатурыСервиса", ЭтотОбъект, Новый Структура);
	РаботаСНоменклатуройКлиент.ПолучитьНоменклатуруПоШтрихкодам(Оповестить, Штрихкоды, ЭтотОбъект, ИдентификаторЗадания);
	
КонецПроцедуры

&НаСервере
Процедура ПолучитьНоменклатуруСервисаНаСервере()
	
	СсылкиНоменклатуры = Новый Массив;
	Для Каждого Строка Из ШтрихкодыНоменклатуры Цикл
		Если ЗначениеЗаполнено(Строка.Номенклатура) Тогда
			СсылкиНоменклатуры.Добавить(Строка.Номенклатура);
		КонецЕсли;
	КонецЦикла;
	
	ТаблицаСоответствий = РаботаСНоменклатурой.ПолучитьСоответствиеНоменклатурыПоСсылкамНоменклатуры(СсылкиНоменклатуры);
	Для Каждого Строка Из ШтрихкодыНоменклатуры Цикл
		Если ЗначениеЗаполнено(Строка.Номенклатура) Тогда
			СтрокаСоответствия = ТаблицаСоответствий.Найти(Строка.Номенклатура, "Номенклатура");
			Если СтрокаСоответствия <> Неопределено Тогда
				Строка.ИдентификаторНоменклатурыСервиса = СтрокаСоответствия.ИдентификаторНоменклатурыСервиса;
				Строка.НоменклатураСервиса              = СтрокаСоответствия.ПредставлениеНоменклатурыСервиса;
				Строка.НоменклатураСервисаЗаписана      = Истина;
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗавершитьПолучениеНоменклатурыСервиса(РезультатЗадания, ДополнительныеПараметры) Экспорт
	
	Если РезультатЗадания = Неопределено Или Не ЭтоАдресВременногоХранилища(РезультатЗадания.АдресРезультата) Тогда
		Возврат;
	КонецЕсли;
	
	ЗавершитьПолучениеНоменклатурыСервисаНаСервере(РезультатЗадания);
	
КонецПроцедуры

&НаСервере
Процедура ЗавершитьПолучениеНоменклатурыСервисаНаСервере(РезультатЗадания)
	
	ДанныеПоНоменклатуреСервиса = ПолучитьИзВременногоХранилища(РезультатЗадания.АдресРезультата);
	Если ТипЗнч(ДанныеПоНоменклатуреСервиса) <> Тип("ТаблицаЗначений") Тогда
		Возврат;
	КонецЕсли;
	
	Для Каждого Строка Из ШтрихкодыНоменклатуры Цикл
		
		Для Каждого ДанныеНоменклатурыСервиса Из ДанныеПоНоменклатуреСервиса Цикл
			Если ДанныеНоменклатурыСервиса.Штрихкоды.Найти(Строка.Штрихкод) <> Неопределено Тогда
				Строка.ИдентификаторНоменклатурыСервиса = ДанныеНоменклатурыСервиса.Идентификатор;
				Строка.НоменклатураСервиса              = ДанныеНоменклатурыСервиса.Наименование;
				Прервать;
			КонецЕсли;
		КонецЦикла;
		
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработатьЗакрытиеФормыКарточкиНоменклатурыСервиса(Результат, ИдентификаторНоменклатурыСервиса) Экспорт
	
	СозданнаяНоменклатура = ОбщегоНазначенияКлиентСервер.СвойствоСтруктуры(Результат, "СозданнаяНоменклатура");
	Если ЗначениеЗаполнено(СозданнаяНоменклатура) Тогда
		НайденныеСтроки = ШтрихкодыНоменклатуры.НайтиСтроки(Новый Структура("ИдентификаторНоменклатурыСервиса", ИдентификаторНоменклатурыСервиса));
		Если ЗначениеЗаполнено(НайденныеСтроки) Тогда
			НайденныеСтроки[0].Номенклатура = СозданнаяНоменклатура[0];
			ОбработатьИзменениеНоменклатуры(НайденныеСтроки[0]);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработатьСозданиеНоменклатурыСервиса(Результат, ДополнительныеПараметры) Экспорт
	
	СозданнаяНоменклатура = ОбщегоНазначенияКлиентСервер.СвойствоСтруктуры(Результат, "НовыеЭлементы");
	Если ЗначениеЗаполнено(СозданнаяНоменклатура) Тогда
		Для Каждого СтрокаСозданнойНоменклатуры Из СозданнаяНоменклатура Цикл
			НайденныеСтроки = ШтрихкодыНоменклатуры.НайтиСтроки(Новый Структура("ИдентификаторНоменклатурыСервиса", СтрокаСозданнойНоменклатуры.ИдентификаторНоменклатуры));
			Если ЗначениеЗаполнено(НайденныеСтроки) Тогда
				НайденныеСтроки[0].Номенклатура = СтрокаСозданнойНоменклатуры.Номенклатура;
				ОбработатьИзменениеНоменклатуры(НайденныеСтроки[0]);
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти // РаботаСНоменклатуройСервиса

#КонецОбласти // СлужебныеПроцедурыИФункции

