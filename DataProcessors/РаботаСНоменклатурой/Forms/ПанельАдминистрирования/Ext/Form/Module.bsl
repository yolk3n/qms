﻿#Область ОписаниеПеременных

&НаКлиенте
Перем ОбновитьИнтерфейс;

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	РазделениеВключено = ОбщегоНазначения.РазделениеВключено();
	ЦветНадписи = ЦветаСтиля.ГиперссылкаЦвет;
	
	// Настройки регламентных заданий.
	УстановитьНастройкиЗаданий();
	
	// Обновление состояния элементов.
	ПрочитатьУстановитьДоступность();
	
	ПодсистемаОблачныеКлассификаторы = "ЭлектронноеВзаимодействие.РаботаСНоменклатурой.ОблачныеКлассификаторы";
	
	Если ОбщегоНазначения.ПодсистемаСуществует(ПодсистемаОблачныеКлассификаторы) Тогда
		
		// Проверка наличия текущего задания по обновлению ТН ВЭД
		ВыполняетсяОбновлениеТНВЭД = ПроверитьОбновлениеТНВЭДНаСервере(РазделениеВключено).Свойство("Активно");
		
		// Проверка наличия текущего задания по обновлению ОКПД 2
		ВыполняетсяОбновлениеОКПД2 = ПроверитьОбновлениеОКПД2НаСервере(РазделениеВключено).Свойство("Активно");
		
		Если Не ВыполняетсяОбновлениеТНВЭД Тогда
			АктуализироватьСостояниеОбновленияТНВЭД();
		КонецЕсли;
		
		Если Не ВыполняетсяОбновлениеОКПД2 Тогда
			АктуализироватьСостояниеОбновленияОКПД2();
		КонецЕсли;
	Иначе
		Элементы.ГруппаРаботаСОблачнымиКлассификаторами.Видимость = Ложь;
	КонецЕсли;

	РаботаСНоменклатуройПереопределяемый.ПриСозданииНаСервереФормаПанельАдминистрирования(ЭтотОбъект);	
	
	ВыбранныйРаздел = "";
	ОписаниеРаздела = "";
	ЗаголовокФормы  = "";
	
	Параметры.Свойство("Раздел",          ВыбранныйРаздел);
	Параметры.Свойство("ОписаниеРаздела", ОписаниеРаздела);
	Параметры.Свойство("Заголовок",       ЗаголовокФормы);
	
	Если ЗначениеЗаполнено(ВыбранныйРаздел) Тогда 
		
		ОтображатьРаботаСНоменклатурой	 = Элементы.ГруппаРаботаСНоменклатурой.Видимость 	         И ВыбранныйРаздел = "НастройкиРаботаСНоменклатурой";
		ОтображатьОблачныйКлассификатор  = Элементы.ГруппаРаботаСОблачнымиКлассификаторами.Видимость И ВыбранныйРаздел = "НастройкиОблачныйКлассификатор";
		
		Элементы.ГруппаРаботаСНоменклатурой.Видимость 		       = ОтображатьРаботаСНоменклатурой;
		Элементы.ГруппаРаботаСОблачнымиКлассификаторами.Видимость  = ОтображатьОблачныйКлассификатор;
		
		Если Не ОтображатьРаботаСНоменклатурой
			И ОтображатьОблачныйКлассификатор Тогда 
			
			Элементы.ГруппаРаботаСОблачнымиКлассификаторами.Поведение = ПоведениеОбычнойГруппы.Обычное;
			Элементы.ГруппаРаботаСОблачнымиКлассификаторами.ОтображатьЗаголовок = Ложь;
		КонецЕсли;

	КонецЕсли;
	
	Если ЗначениеЗаполнено(ЗаголовокФормы) Тогда 
		АвтоЗаголовок = Ложь;
		Заголовок = ЗаголовокФормы;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ОписаниеРаздела) Тогда
		Элементы.ОписаниеРаздела.Заголовок = ОписаниеРаздела;
	Иначе
		// размещение гиперссылок в заголовках элементов
		ГиперссылкаНаПромоСайтНоменклатура = РаботаСНоменклатурой.ГиперссылкаНаПромоСайтНоменклатура();
		ОписаниеШаблон = НСтр("ru = 'Настройка параметров работы с сервисом <a href = ""%1"">1С:Номенклатура</a>.'");
		Элементы.ОписаниеРаздела.Заголовок = СтроковыеФункции.ФорматированнаяСтрока(ОписаниеШаблон,
			ГиперссылкаНаПромоСайтНоменклатура);
	КонецЕсли;
	
	ВыгрузкаНоменклатурыДоступна = РаботаСНоменклатурой.ВыгрузкаНоменклатурыИспользуется()
		И ПравоДоступа("Просмотр", Метаданные.Обработки.РаботаСНоменклатурой.Команды.ВыгрузитьНоменклатуру);
	Элементы.ГруппаВыгрузка.Видимость = ВыгрузкаНоменклатурыДоступна;
	Если ВыгрузкаНоменклатурыДоступна Тогда
		Элементы.ВыгрузитьНоменклатуруРасширеннаяПодсказка.Заголовок = СтроковыеФункции.ФорматированнаяСтрока(
			"Выгрузка данных номенклатуры в сервис <a href = ""%1"">1С:Номенклатура</a> и в электронные каталоги партнеров фирмы 1С",
			ГиперссылкаНаПромоСайтНоменклатура);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ПроверитьСостояниеСервиса();
	
	Если ВыполняетсяОбновлениеТНВЭД Тогда
		Элементы.ДлительнаяОперацияОбновлениеТНВЭД.Видимость = Истина;
		Элементы.СостояниеОбновленияТНВЭД.Заголовок = НСтр("ru = 'Выполняется обновление'");
		Элементы.ОбновитьТНВЭД.Доступность = Ложь;
		ПодключитьОбработчикОжидания("ПроверитьОбновлениеТНВЭД", 2);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	ПараметрыЗакрытия = Новый Структура;
	ПараметрыЗакрытия.Вставить("ИспользоватьСервисРаботаСНоменклатурой", Константа_ИспользоватьСервисРаботаСНоменклатурой);
	ПараметрыЗакрытия.Вставить("ИспользоватьАвтоматическоеОбновлениеНоменклатуры", ИспользоватьАвтоматическоеОбновлениеНоменклатуры);
	Закрыть(ПараметрыЗакрытия);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	
	Если Не ЗавершениеРаботы Тогда
		ОбновитьИнтерфейсПрограммы();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
// Обработчик оповещения формы.
//
// Параметры:
//  ИмяСобытия - Строка - обрабатывается только событие Запись_НаборКонстант, генерируемое панелями администрирования.
//  Параметр   - Структура - содержит имена констант, подчиненных измененной константе, "вызвавшей" оповещение.
//  Источник   - Строка - имя измененной константы, вызвавшей оповещение.
//
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "Запись_НаборКонстант" Тогда
		
		ТребуетсяОбновление = Ложь;
		Если ТипЗнч(Источник) = Тип("Строка") Тогда
			ТребуетсяОбновление = Элементы.Найти(Источник) <> Неопределено;
		ИначеЕсли ТипЗнч(Источник) = Тип("Структура") Тогда
			Для Каждого ЭлементСтруктуры Из Источник Цикл
				ТребуетсяОбновление = Элементы.Найти(ЭлементСтруктуры.Ключ) <> Неопределено;
				Если ТребуетсяОбновление Тогда
					Прервать;
				КонецЕсли;
			КонецЦикла;
		КонецЕсли;
		
		Если ТребуетсяОбновление Тогда
			ПрочитатьУстановитьДоступность();
		КонецЕсли;
		
		Если Источник = "ИспользоватьСервисРаботаСНоменклатурой" Тогда 
			ПроверитьСостояниеСервиса();
		КонецЕсли;
		
	ИначеЕсли ИмяСобытия = "АвтоматическоеОбновлениеНоменклатуры_ПриИзменении"
		Или ИмяСобытия = "ИспользоватьАвтоматическоеОбновлениеТНВЭД_ПриИзменении" Тогда
		
		УстановитьНастройкиЗаданий();
		
	ИначеЕсли ИмяСобытия = "ИнтернетПоддержкаПодключена"
		ИЛИ ИмяСобытия = "ИнтернетПоддержкаОтключена" Тогда
		
		ПроверитьСостояниеСервиса();
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ИспользоватьСервисРаботаСНоменклатуройПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент);
	ОтображатьВыгрузку = Константа_ИспользоватьСервисРаботаСНоменклатурой И ВыгрузкаНоменклатурыДоступна;
	Если Элементы.ГруппаВыгрузка.Видимость <> ОтображатьВыгрузку Тогда
		Элементы.ГруппаВыгрузка.Видимость = ОтображатьВыгрузку;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьАвтоматическоеОбновлениеНоменклатурыПриИзменении(Элемент)
	
	ИзменитьИспользованиеЗадания("ОбновлениеНоменклатурыРаботаСНоменклатурой", ИспользоватьАвтоматическоеОбновлениеНоменклатуры, "ОбновлениеНоменклатуры");
	Элементы.ОбновлениеНоменклатуры.Доступность = ИспользоватьАвтоматическоеОбновлениеНоменклатуры;
	Оповестить("АвтоматическоеОбновлениеНоменклатуры_ПриИзменении");
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

#Область НастройкаРасписания

&НаКлиенте
Процедура НастроитьРасписаниеОбновленияНоменклатуры(Команда)
	
	ОткрытьНастройкуРасписания("ОбновлениеНоменклатурыРаботаСНоменклатурой", "ОбновлениеНоменклатуры");
	
КонецПроцедуры

#КонецОбласти

#Область ОбработкаКомандУведомлений

&НаКлиенте
Процедура ГруппаУведомленияСервисаКонтекстКомандаНажатие(Элемент)
	
	Если Не ПодключенаИнтернетПоддержка Тогда 
		
		ПодключитьИнтернетПоддержкуПользователейНажатие();
		
	ИначеЕсли Не ЕстьДоступныеОпции И ДоступенСтартовыйПакет Тогда 
		
		ПодключитьСтартовыйПакет();
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ПодключениеИнтернетПоддержки

&НаКлиенте
Процедура ПодключитьИнтернетПоддержкуПользователейНажатие()
	
	ПодключитьИнтернетПоддержкуПользователейНажатиеПродолжение = Новый ОписаниеОповещения(
		"ПодключитьИнтернетПоддержкуПользователейНажатиеПродолжение", ЭтотОбъект);
	
	ИнтернетПоддержкаПользователейКлиент.ПодключитьИнтернетПоддержкуПользователей(
			ПодключитьИнтернетПоддержкуПользователейНажатиеПродолжение,
			ЭтотОбъект);

КонецПроцедуры
	
&НаКлиенте
Процедура ПодключитьИнтернетПоддержкуПользователейНажатиеПродолжение(Результат, ДополнительныеПараметры) Экспорт 
	
	ПроверитьСостояниеСервиса();
	
КонецПроцедуры

#КонецОбласти

#Область ПодключениеСтартовогоПакета

&НаКлиенте
Процедура ПодключитьСтартовыйПакет()
	
	ОбработчикЗавершения = Новый ОписаниеОповещения(
		"ПодключитьСтартовыйПакетЗавершение",
		ЭтотОбъект);
	
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("ОбработчикЗавершения", ОбработчикЗавершения);
	
	РаботаСНоменклатуройКлиент.ПодключитьТестовыйПериод(ЭтотОбъект, ДополнительныеПараметры);
	
КонецПроцедуры

&НаКлиенте
Процедура ПодключитьСтартовыйПакетЗавершение(Результат, ДополнительныеПараметры) Экспорт 
	
	Если Результат = Неопределено Тогда 
		Возврат;
	КонецЕсли;
	
	ПроверитьСостояниеСервиса();
	
КонецПроцедуры

#КонецОбласти

#Область ТНВЭД

&НаКлиенте
Процедура ОбновитьТНВЭД(Команда)
	
	Отказ = Ложь;
	
	ОчиститьСообщения();
	
	ЗапуститьОбновлениеТНВЭД(РазделениеВключено, Отказ);
	
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	Элементы.ДлительнаяОперацияОбновлениеТНВЭД.Видимость = Истина;
	Элементы.СостояниеОбновленияТНВЭД.Заголовок = НСтр("ru = 'Выполняется обновление'");
	Элементы.ОбновитьТНВЭД.Доступность = Ложь;
	
	ПодключитьОбработчикОжидания("ПроверитьОбновлениеТНВЭД", 2);
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура ЗапуститьОбновлениеТНВЭД(РазделениеВключено, Отказ)
	
	ПодсистемаОблачныеКлассификаторы = "ЭлектронноеВзаимодействие.РаботаСНоменклатурой.ОблачныеКлассификаторы";
	
	Если Не ОбщегоНазначения.ПодсистемаСуществует(ПодсистемаОблачныеКлассификаторы) Тогда
		Возврат;
	КонецЕсли;
	
	ЭлементыТНВЭД = Новый Массив;
	МодульПодсистемы = ОбщегоНазначения.ОбщийМодуль("ОблачныеКлассификаторыПереопределяемый");
	МодульПодсистемы.ОпределитьЗагруженныеЭлементыТНВЭД(ЭлементыТНВЭД);
	
	Если Не ЭлементыТНВЭД.Количество() Тогда
		ТекстСообщения = НСтр("ru = 'Ошибка обновления: в базе отсутствуют элементы классификатора.'");
		ОбщегоНазначения.СообщитьПользователю(ТекстСообщения,,,, Отказ);
		Возврат;
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	
	Если РазделениеВключено Тогда
		КлючЗадания = "ОбновлениеТНВЭД" + Строка(ПараметрыСеанса.ОбластьДанныхЗначение);
	Иначе
		КлючЗадания = "ОбновлениеТНВЭД";
	КонецЕсли;
	
	Задания = ФоновыеЗадания.ПолучитьФоновыеЗадания(Новый Структура("Ключ, Состояние", КлючЗадания, СостояниеФоновогоЗадания.Активно)); 
	
	Если Задания.Количество() Тогда
		Возврат;
	КонецЕсли;
	
	ФоновоеЗадание = ФоновыеЗадания.Выполнить("ОблачныеКлассификаторы.ОбновитьКлассификаторТНВЭД",,
		КлючЗадания, НСтр("ru = 'Обновление классификатора ТН ВЭД'"));
	
	УстановитьПривилегированныйРежим(Ложь);
	
КонецПроцедуры

&НаКлиенте
Процедура ПроверитьОбновлениеТНВЭД()
	
	Результат = ПроверитьОбновлениеТНВЭДНаСервере(РазделениеВключено);

	Если Результат.Свойство("Успешно") Тогда
		ПоказатьОповещениеПользователя(НСтр("ru = 'Обновление ТН ВЭД'"),, НСтр("ru = 'Данные классификатора успешно обновлены'"));
	ИначеЕсли Результат.Свойство("Ошибка") Тогда
		ПоказатьОповещениеПользователя(НСтр("ru = 'Обновление ТН ВЭД'"),, НСтр("ru = 'Не удалось обновить данные классификатора'"));
	Иначе
		Возврат;
	КонецЕсли;
		
	Элементы.ДлительнаяОперацияОбновлениеТНВЭД.Видимость = Ложь;
	Элементы.ОбновитьТНВЭД.Доступность = Истина;
	АктуализироватьСостояниеОбновленияТНВЭД();
	
	ОтключитьОбработчикОжидания("ПроверитьОбновлениеТНВЭД");
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПроверитьОбновлениеТНВЭДНаСервере(РазделениеВключено)
	
	УстановитьПривилегированныйРежим(Истина);
	
	Если РазделениеВключено Тогда
		КлючЗадания = "ОбновлениеТНВЭД" + Строка(ПараметрыСеанса.ОбластьДанныхЗначение);
	Иначе
		КлючЗадания = "ОбновлениеТНВЭД";
	КонецЕсли;
	
	Задания = ФоновыеЗадания.ПолучитьФоновыеЗадания(Новый Структура("Ключ", КлючЗадания));
	
	Результат = Новый Структура;
	
	Если Не Задания.Количество() 
		Или Задания[0].Состояние = СостояниеФоновогоЗадания.ЗавершеноАварийно Тогда
		Результат.Вставить("Ошибка");
	ИначеЕсли Задания[0].Состояние <> СостояниеФоновогоЗадания.Активно Тогда
		Результат.Вставить("Успешно");
	ИначеЕсли Задания[0].Состояние = СостояниеФоновогоЗадания.Активно Тогда
		Результат.Вставить("Активно");
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Ложь);
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти

#Область ОКПД2

&НаКлиенте
Процедура ОбновитьОКПД2(Команда)
	
	Отказ = Ложь;
	
	ОчиститьСообщения();
	
	ЗапуститьОбновлениеОКПД2(РазделениеВключено, Отказ);
	
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	Элементы.ДлительнаяОперацияОбновлениеОКПД2.Видимость = Истина;
	Элементы.СостояниеОбновленияОКПД2.Заголовок = НСтр("ru = 'Выполняется обновление'");
	Элементы.ОбновитьОКПД2.Доступность = Ложь;
	
	ПодключитьОбработчикОжидания("ПроверитьОбновлениеОКПД2", 2);

КонецПроцедуры

&НаСервереБезКонтекста
Процедура ЗапуститьОбновлениеОКПД2(РазделениеВключено, Отказ)
	
	ПодсистемаОблачныеКлассификаторы = "ЭлектронноеВзаимодействие.РаботаСНоменклатурой.ОблачныеКлассификаторы";
	
	Если Не ОбщегоНазначения.ПодсистемаСуществует(ПодсистемаОблачныеКлассификаторы) Тогда
		Возврат;
	КонецЕсли;
	
	ЭлементыКлассификаторы = Новый Массив;
	
	МодульПодсистемы = ОбщегоНазначения.ОбщийМодуль("ОблачныеКлассификаторыПереопределяемый");
	МодульПодсистемы.ОпределитьЗагруженныеЭлементыОКПД2(ЭлементыКлассификаторы);
	
	Если ЭлементыКлассификаторы.Количество() = 0 Тогда
		ОбщегоНазначения.СообщитьПользователю
			(НСтр("ru = 'Ошибка обновления: в базе отсутствуют элементы классификатора.'"));
		Отказ = Истина;
		Возврат;
	КонецЕсли;	
	
	УстановитьПривилегированныйРежим(Истина);
	
	Если РазделениеВключено Тогда
		КлючЗадания = "ОбновлениеОКПД2" + Строка(ПараметрыСеанса.ОбластьДанныхЗначение);
	Иначе
		КлючЗадания = "ОбновлениеОКПД2";
	КонецЕсли;
	
	Задания = ФоновыеЗадания.ПолучитьФоновыеЗадания(Новый Структура("Ключ, Состояние", КлючЗадания, СостояниеФоновогоЗадания.Активно)); 
	
	Если Задания.Количество() Тогда
		Возврат;
	КонецЕсли;
	
	ФоновоеЗадание = ФоновыеЗадания.Выполнить("ОблачныеКлассификаторы.ОбновитьКлассификаторОКПД2",,
		КлючЗадания, НСтр("ru = 'Обновление классификатора ОКПД 2'"));
	
	УстановитьПривилегированныйРежим(Ложь);
	
КонецПроцедуры

&НаКлиенте
Процедура ПроверитьОбновлениеОКПД2()
	
	Результат = ПроверитьОбновлениеОКПД2НаСервере(РазделениеВключено);

	Если Результат.Свойство("Успешно") Тогда
		ПоказатьОповещениеПользователя(НСтр("ru = 'Обновление ОКПД 2'"),, НСтр("ru = 'Данные классификатора успешно обновлены'"));
	ИначеЕсли Результат.Свойство("Ошибка") Тогда
		ПоказатьОповещениеПользователя(НСтр("ru = 'Обновление ОКПД 2'"),, НСтр("ru = 'Не удалось обновить данные классификатора'"));
	Иначе
		Возврат;
	КонецЕсли;
		
	Элементы.ДлительнаяОперацияОбновлениеОКПД2.Видимость = Ложь;
	Элементы.ОбновитьОКПД2.Доступность = Истина;
	АктуализироватьСостояниеОбновленияОКПД2();
	
	ОтключитьОбработчикОжидания("ПроверитьОбновлениеОКПД2");
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПроверитьОбновлениеОКПД2НаСервере(РазделениеВключено)
	
	УстановитьПривилегированныйРежим(Истина);
	
	Если РазделениеВключено Тогда
		КлючЗадания = "ОбновлениеОКПД2" + Строка(ПараметрыСеанса.ОбластьДанныхЗначение);
	Иначе
		КлючЗадания = "ОбновлениеОКПД2";
	КонецЕсли;
	
	Задания = ФоновыеЗадания.ПолучитьФоновыеЗадания(Новый Структура("Ключ", КлючЗадания));
	
	Результат = Новый Структура;
	
	Если Не Задания.Количество() 
		Или Задания[0].Состояние = СостояниеФоновогоЗадания.ЗавершеноАварийно Тогда
		Результат.Вставить("Ошибка");
	ИначеЕсли Задания[0].Состояние <> СостояниеФоновогоЗадания.Активно Тогда
		Результат.Вставить("Успешно");
	ИначеЕсли Задания[0].Состояние = СостояниеФоновогоЗадания.Активно Тогда
		Результат.Вставить("Активно");
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Ложь);
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ПроверкаСостоянияСервисИОтображениеУведомлений

&НаКлиенте
Процедура ПроверитьСостояниеСервиса()
	
	ПараметрыЗавершения = Новый Структура;
	ПараметрыЗавершения.Вставить("ИдентификаторЗадания",    ИдентификаторЗадания);
	
	ПроверитьСостояниеСервисаЗавершение = Новый ОписаниеОповещения("ПроверитьСостояниеСервисаЗавершение",
		ЭтотОбъект, ПараметрыЗавершения);
		
	Если Константа_ИспользоватьСервисРаботаСНоменклатурой Тогда 
		
		РаботаСНоменклатуройКлиент.ПроверитьСостояниеСервиса(ПроверитьСостояниеСервисаЗавершение, ЭтотОбъект, ИдентификаторЗадания);
	Иначе
		
		ВыполнитьОбработкуОповещения(ПроверитьСостояниеСервисаЗавершение,
			РаботаСНоменклатуройСлужебныйКлиентСервер.ОписаниеСостоянияСервиса());
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПроверитьСостояниеСервисаЗавершение(Результат, ДополнительныеПараметры = Неопределено) Экспорт 
	
	Если ИдентификаторЗадания <> ДополнительныеПараметры.ИдентификаторЗадания Тогда 
		Возврат;
	КонецЕсли;
	ИдентификаторЗадания = Неопределено;
	
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, Результат);
	ПоказатьСкрытьУведомленияСервисаРаботаСНоменклатурой(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ПоказатьСкрытьУведомленияСервисаРаботаСНоменклатурой(Форма)
	
	Элементы = Форма.Элементы;
	ОтобразитьУведомление = Ложь;
	
	Если Не Форма.ПодключенаИнтернетПоддержка Тогда 
		
		Элементы.ГруппаУведомленияСервисаИзображение.Картинка = БиблиотекаКартинок.Предупреждение32;
		Элементы.ГруппаУведомленияСервисаКонтекстЗаголовок.Заголовок = НСтр("ru = 'Не подключена Интернет-поддержка пользователей'");
		Элементы.ГруппаУведомленияСервисаКонтекстИнформация.Заголовок = НСтр("ru = 'Для работы с сервисом 1С:Номенклатура нужно подключить Интернет-поддержку пользователей.'");
		Элементы.ГруппаУведомленияСервисаКонтекстКоманда.Видимость = Истина;
		Элементы.ГруппаУведомленияСервисаКонтекстКоманда.Заголовок = НСтр("ru = 'Подключить Интернет-поддержку пользователей'");
		Элементы.ГруппаУведомленияСервисаКонтекстКоманда.ОтображениеПодсказки = ОтображениеПодсказки.Нет;
		Элементы.ГруппаУведомленияСервисаУсловияИспользованияСервиса.Видимость = Ложь;
		
		ОтобразитьУведомление = Истина;
		
	ИначеЕсли Не Форма.ЕстьДоступныеОпции И Форма.ДоступенСтартовыйПакет Тогда 
		
		Элементы.ГруппаУведомленияСервисаИзображение.Картинка = БиблиотекаКартинок.ИнформацияРаботаСНоменклатурой32;
		Элементы.ГруппаУведомленияСервисаКонтекстЗаголовок.Заголовок = НСтр("ru = 'Доступен бесплатный пакет'");
		
		Информация = Новый Массив;
		Информация.Добавить(НСтр("ru = 'Для начала работы с сервисом можно подключить бесплатный стартовый пакет карточек 1С:Номенклатуры.'"));
		
		Если Форма.РазделениеВключено Тогда 
			Информация.Добавить(Символы.ПС);
			Информация.Добавить(Символы.ПС);
			Информация.Добавить(НСтр("ru = 'Для подключения'") + " ");
			Информация.Добавить(Новый ФорматированнаяСтрока(НСтр("ru = 'стартового пакета'"),, Форма.ЦветНадписи));
			Информация.Добавить(" " + НСтр("ru = 'обратитесь к обслуживающему Вас партнеру фирмы ""1С"".'"));
			Элементы.ГруппаУведомленияСервисаКонтекстКоманда.Видимость = Ложь;
			Элементы.ГруппаУведомленияСервисаУсловияИспользованияСервиса.Видимость = Ложь;
		Иначе
			Элементы.ГруппаУведомленияСервисаКонтекстКоманда.Видимость = Истина;
			Элементы.ГруппаУведомленияСервисаКонтекстКоманда.Заголовок = НСтр("ru = 'Подключить бесплатный стартовый пакет'");
			Элементы.ГруппаУведомленияСервисаКонтекстКоманда.РасширеннаяПодсказка.Заголовок = НСтр("ru = 'Когда пакет закончится, нужно будет приобрести платный пакет у обслуживающего Вас партнера фирмы ""1С"".'");
			Элементы.ГруппаУведомленияСервисаКонтекстКоманда.ОтображениеПодсказки = ОтображениеПодсказки.ОтображатьСнизу;
			
			Элементы.ГруппаУведомленияСервисаУсловияИспользованияСервиса.Видимость = Истина;
			АдресУсловийИспользованияСервиса = "https://catalog-api.1c.ru/agreement/";
			ЗаголовокУсловияИспользования = Новый Массив;
			ЗаголовокУсловияИспользования.Добавить(НСтр("ru = 'Нажатие ""Подключить бесплатный стартовый пакет"" означает согласие с'") + " ");
			ЗаголовокУсловияИспользования.Добавить(Новый ФорматированнаяСтрока(НСтр("ru = 'Условиями использования сервиса'"),,,,АдресУсловийИспользованияСервиса));
			Элементы.ГруппаУведомленияСервисаУсловияИспользованияСервиса.Заголовок = Новый ФорматированнаяСтрока(ЗаголовокУсловияИспользования);
		КонецЕсли;
		
		Элементы.ГруппаУведомленияСервисаКонтекстИнформация.Заголовок = Новый ФорматированнаяСтрока(Информация);
		
		ОтобразитьУведомление = Истина;
		
	ИначеЕсли Не Форма.ЕстьДоступныеОпции Тогда 
		
		Элементы.ГруппаУведомленияСервисаИзображение.Картинка = БиблиотекаКартинок.Предупреждение32;
		Элементы.ГруппаУведомленияСервисаКонтекстЗаголовок.Заголовок = НСтр("ru = 'Отсутствуют подключенные пакеты'");
		Элементы.ГруппаУведомленияСервисаКонтекстКоманда.Видимость = Ложь;
		Элементы.ГруппаУведомленияСервисаУсловияИспользованияСервиса.Видимость = Ложь;
		
		Информация = Новый Массив;
		Информация.Добавить(НСтр("ru = 'Лимит карточек исчерпан или срок активных пакетов истек, необходимо приобрести платный пакет у обслуживающего Вас партнера фирмы ""1С"".'"));
		Информация.Добавить(Символы.ПС);
		Информация.Добавить(Символы.ПС);
		Информация.Добавить(НСтр("ru = 'Если у Вас нет обслуживающего партнера, Вы можете выбрать его из'") + " ");
		Адрес = "http://its.1c.ru/news/redirect?utm_medium=prog&url=http://its.1c.ru/partners/";
		Информация.Добавить(Новый ФорматированнаяСтрока(НСтр("ru = 'списка партнеров в Вашем регионе'"),,,,Адрес));
		Информация.Добавить(".");
		Элементы.ГруппаУведомленияСервисаКонтекстИнформация.Заголовок = Новый ФорматированнаяСтрока(Информация);
		
		
		ОтобразитьУведомление = Истина;
		
	КонецЕсли;
	
	Элементы.ГруппаУведомленияСервиса.Видимость = 
		(ОтобразитьУведомление И Форма.Константа_ИспользоватьСервисРаботаСНоменклатурой И Не Форма.ОшибкаОпределенияСостояния);
	
КонецПроцедуры

#КонецОбласти

#Область СтандартныйФункционал

&НаКлиенте
Процедура Подключаемый_ПриИзмененииРеквизита(Элемент, ОбновлятьИнтерфейс = Истина)
	
	Результат = ПриИзмененииРеквизитаСервер(Элемент.Имя);
	
	Если ОбновлятьИнтерфейс Тогда
		
		ОбновитьИнтерфейс = Истина;
		ПодключитьОбработчикОжидания("ОбновитьИнтерфейсПрограммы", 1, Истина);
		
	КонецЕсли;
	
	Если Результат.Свойство("ОповещениеФорм") Тогда
		Оповестить(Результат.ОповещениеФорм.ИмяСобытия, Результат.ОповещениеФорм.Параметр,
			Результат.ОповещениеФорм.Источник);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьИнтерфейсПрограммы()
	
	Если ОбновитьИнтерфейс = Истина Тогда
		ОбновитьИнтерфейс = Ложь;
		ОбновитьИнтерфейс();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ПриИзмененииРеквизитаСервер(ИмяЭлемента)
	
	Результат = Новый Структура;
	
	РеквизитПутьКДанным = Элементы[ИмяЭлемента].ПутьКДанным;
	
	СохранитьЗначениеРеквизита(РеквизитПутьКДанным, Результат);
	
	ПрочитатьУстановитьДоступность(РеквизитПутьКДанным);
	
	ОбновитьПовторноИспользуемыеЗначения();
	
	Возврат Результат;
	
КонецФункции

&НаСервере
Процедура СохранитьЗначениеРеквизита(РеквизитПутьКДанным, Результат)
	
	// Сохранение значений реквизитов, не связанных с константами напрямую (в отношении один-к-одному).
	Если РеквизитПутьКДанным = "" Тогда
		Возврат;
	КонецЕсли;
	
	// Определение имени константы.
	КонстантаИмя = "";
	Если НРег(Лев(РеквизитПутьКДанным, 10)) = НРег("Константа_") Тогда
		// Если путь к данным реквизита указан через "НаборКонстант".
		КонстантаИмя = Сред(РеквизитПутьКДанным, 11);
	Иначе
		// Определение имени и запись значения реквизита в соответствующей константе из "НаборКонстант".
		// Используется для тех реквизитов формы, которые связаны с константами напрямую (в отношении один-к-одному).
	КонецЕсли;
	
	// Сохранения значения константы.
	Если КонстантаИмя <> "" Тогда
		КонстантаМенеджер = Константы[КонстантаИмя];
		КонстантаЗначение = Константы[КонстантаИмя].Получить();
		
		Если Константы[КонстантаИмя].Получить() <> ЭтотОбъект[РеквизитПутьКДанным] Тогда
			Константы[КонстантаИмя].Установить(ЭтотОбъект[РеквизитПутьКДанным]);
		КонецЕсли;
		
		ОповещениеФорм = Новый Структура(
			"ИмяСобытия, Параметр, Источник",
			"Запись_НаборКонстант", Неопределено, КонстантаИмя);
		Результат.Вставить("ОповещениеФорм", ОповещениеФорм);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПрочитатьУстановитьДоступность(РеквизитПутьКДанным = "")
	
	ЭтоПолноправныйПользователь = Пользователи.ЭтоПолноправныйПользователь();
	
	УстановитьПривилегированныйРежим(Истина);
	
	Если РеквизитПутьКДанным = "Константа_ИспользоватьСервисРаботаСНоменклатурой" ИЛИ РеквизитПутьКДанным = "" Тогда
		
		Константа_ИспользоватьСервисРаботаСНоменклатурой = Константы["ИспользоватьСервисРаботаСНоменклатурой"].Получить();
		
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы,
			"ГруппаРаботаСНоменклатуройАвтоматическоеОбновление", "Доступность", Константа_ИспользоватьСервисРаботаСНоменклатурой);
		
		Если Не Константа_ИспользоватьСервисРаботаСНоменклатурой И Не РазделениеВключено Тогда
			ИзменитьИспользованиеЗадания("ОбновлениеНоменклатурыРаботаСНоменклатурой", Константа_ИспользоватьСервисРаботаСНоменклатурой, "ОбновлениеНоменклатуры");
			ИспользоватьАвтоматическоеОбновлениеНоменклатуры = Ложь;
		КонецЕсли;
		
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Ложь);
	
КонецПроцедуры

&НаСервере
Процедура ИзменитьИспользованиеЗадания(ИмяЗадания, Использование, ИмяЭлементаФормы)
	
	ПараметрыЗадания = Новый Структура;
	ПараметрыЗадания.Вставить("Использование", Использование);
	УстановитьПривилегированныйРежим(Истина);
	РегламентноеЗадание = РегламентноеЗаданиеПоНаименованию(ИмяЗадания);
	РегламентныеЗаданияСервер.ИзменитьЗадание(РегламентноеЗадание.УникальныйИдентификатор, ПараметрыЗадания);
	УстановитьПривилегированныйРежим(Ложь);
	
	Элемент = Элементы[ИмяЭлементаФормы];
	Если Элемент <> Неопределено Тогда
		Элемент.Заголовок = ТекстРасписанияРегламентногоЗадания(РегламентноеЗадание);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ИзменитьРасписаниеЗадания(ИмяЗадания, РасписаниеРегламентногоЗадания, ЭлементФормыГиперссылка)
	
	// Перевод обновления на 1 раз в день, независимо от выбора пользователя.
	
	РасписаниеРегламентногоЗадания.ПериодПовтораВТечениеДня = 0;
	РасписаниеРегламентногоЗадания.ПаузаПовтора             = 0;
	РасписаниеРегламентногоЗадания.ИнтервалЗавершения       = 0;
	РасписаниеРегламентногоЗадания.ДетальныеРасписанияДня   = Новый Массив;
	
	Идентификатор = РегламентноеЗаданиеПоНаименованию(ИмяЗадания);
	РегламентныеЗаданияСервер.УстановитьРасписаниеРегламентногоЗадания(Идентификатор, РасписаниеРегламентногоЗадания);
	
	Элемент = Элементы[ЭлементФормыГиперссылка];
	Если Элемент <> Неопределено Тогда
		Элемент.Заголовок = РасписаниеРегламентногоЗадания;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьНастройкуРасписания(ИмяЗадания, ЭлементФормыГиперссылка)
	
	Расписание = ПолучитьПараметрРегламентногоЗадания(ИмяЗадания, "Расписание", Новый РасписаниеРегламентногоЗадания);
	
	ДиалогРасписания = Новый ДиалогРасписанияРегламентногоЗадания(Расписание);
	ОписаниеОповещения = Новый ОписаниеОповещения("НастроитьРасписаниеЗавершение",
		ЭтотОбъект, Новый Структура("ИмяЗадания, ЭлементФормыГиперссылка", ИмяЗадания, ЭлементФормыГиперссылка));
	ДиалогРасписания.Показать(ОписаниеОповещения);
	
КонецПроцедуры

&НаСервере
Функция ТекстРасписанияРегламентногоЗадания(ИдентификаторЗадания)
	
	Расписание = ИдентификаторЗадания.Расписание;
	Если Расписание = Неопределено Тогда
		Возврат НСтр("ru = 'Настроить расписание'")
	Иначе
		Возврат Строка(Расписание);
	КонецЕсли;
	
КонецФункции

&НаСервере
Процедура УстановитьНастройкиЗаданий()
	
	УстановитьПривилегированныйРежим(Истина);
	
	ЭтоАдминистраторСистемы = Пользователи.ЭтоПолноправныйПользователь(, Истина, Ложь);
		
	РегламентноеЗадание = РегламентноеЗаданиеПоНаименованию("ОбновлениеНоменклатурыРаботаСНоменклатурой");
	ЭлементНастройкиРасписания = Элементы.ОбновлениеНоменклатуры;
	ВидимостьФлажка = (РегламентноеЗадание <> Неопределено);
	Если ВидимостьФлажка Тогда
		ИспользоватьАвтоматическоеОбновлениеНоменклатуры = РегламентноеЗадание.Использование;
		ЭлементНастройкиРасписания.Заголовок = ТекстРасписанияРегламентногоЗадания(РегламентноеЗадание);
		ЭлементНастройкиРасписания.Доступность = РегламентноеЗадание.Использование;
	КонецЕсли;
	ВидимостьРасписания = ВидимостьФлажка И Не РазделениеВключено И ЭтоАдминистраторСистемы;
	ЭлементНастройкиРасписания.Видимость = ВидимостьРасписания;
	
КонецПроцедуры

&НаКлиенте
Процедура НастроитьРасписаниеЗавершение(РасписаниеЗадания, ДополнительныеПараметры) Экспорт
	
	Если РасписаниеЗадания = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ИзменитьРасписаниеЗадания(ДополнительныеПараметры.ИмяЗадания, РасписаниеЗадания, ДополнительныеПараметры.ЭлементФормыГиперссылка);
	
КонецПроцедуры

&НаСервере
Функция РегламентноеЗаданиеПоНаименованию(ИмяЗадания)
	
	Отбор = Новый Структура("Метаданные", ИмяЗадания);
	Найденные = РегламентныеЗаданияСервер.НайтиЗадания(Отбор);
	Задание = ?(Найденные.Количество() = 0, Неопределено, Найденные[0]);
	
	Возврат Задание;
	
КонецФункции

&НаСервере
Функция ПолучитьПараметрРегламентногоЗадания(ИмяЗадания, ИмяПараметра, ЗначениеПоУмолчанию)
	
	// Проверка отсутствие поставляемого регламентного задания в конфигурации.
	РегламентноеЗадание = Метаданные.РегламентныеЗадания[ИмяЗадания];
	Если РегламентноеЗадание = Неопределено Тогда
		Возврат ЗначениеПоУмолчанию;
	КонецЕсли;
	
	// Поиск задания.
	ПараметрыЗадания = Новый Структура;
	ПараметрыЗадания.Вставить("Метаданные", РегламентноеЗадание);
	Если Не РазделениеВключено Тогда
		ПараметрыЗадания.Вставить("ИмяМетода", РегламентноеЗадание.ИмяМетода);
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	
	СписокЗаданий = РегламентныеЗаданияСервер.НайтиЗадания(ПараметрыЗадания);
	Если СписокЗаданий.Количество() Тогда
		Возврат СписокЗаданий[0][ИмяПараметра];
	Иначе
		Возврат ЗначениеПоУмолчанию;
	КонецЕсли;
	
КонецФункции

&НаСервере
Процедура АктуализироватьСостояниеОбновленияТНВЭД()
	
	ПодсистемаОблачныеКлассификаторы = "ЭлектронноеВзаимодействие.РаботаСНоменклатурой.ОблачныеКлассификаторы";
	
	Если Не ОбщегоНазначения.ПодсистемаСуществует(ПодсистемаОблачныеКлассификаторы) Тогда
		Возврат;
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	
	ДатаПоследнегоОбновленияТНВЭД = Константы["ДатаСинхронизацииТНВЭД"].Получить();
	
	УстановитьПривилегированныйРежим(Ложь);
	
	Если ЗначениеЗаполнено(ДатаПоследнегоОбновленияТНВЭД) Тогда
		ДатаПоследнегоОбновленияТНВЭД = МестноеВремя(ДатаПоследнегоОбновленияТНВЭД, ЧасовойПоясСеанса());
		Элементы.СостояниеОбновленияТНВЭД.Заголовок = СтрШаблон(НСтр("ru = 'Последнее обновление %1'"), Формат(ДатаПоследнегоОбновленияТНВЭД, "ДЛФ=DDT"));
	Иначе
		Элементы.СостояниеОбновленияТНВЭД.Заголовок = НСтр("ru = 'Обновление не выполнялось'");
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура АктуализироватьСостояниеОбновленияОКПД2()
	
	ПодсистемаОблачныеКлассификаторы = "ЭлектронноеВзаимодействие.РаботаСНоменклатурой.ОблачныеКлассификаторы";
	
	Если Не ОбщегоНазначения.ПодсистемаСуществует(ПодсистемаОблачныеКлассификаторы) Тогда
		Возврат;
	КонецЕсли;
	
	МодульПодсистемы = ОбщегоНазначения.ОбщийМодуль("ОблачныеКлассификаторы");
	ДатаПоследнегоОбновленияОКПД2 = МодульПодсистемы.ДатаПоследнегоОбновленияОКПД2();
	
	Если ЗначениеЗаполнено(ДатаПоследнегоОбновленияОКПД2) Тогда
		Элементы.СостояниеОбновленияОКПД2.Заголовок = СтрШаблон(НСтр("ru = 'Последнее обновление %1'"), Формат(ДатаПоследнегоОбновленияОКПД2, "ДЛФ=DDT"));
	Иначе
		Элементы.СостояниеОбновленияОКПД2.Заголовок = НСтр("ru = 'Обновление не выполнялось'");
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти