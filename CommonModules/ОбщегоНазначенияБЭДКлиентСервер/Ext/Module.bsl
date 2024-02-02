﻿#Область СлужебныйПрограммныйИнтерфейс

// Возвращает имена подсистем для использования в см. ЗаписатьВЖурналРегистрации.
// 
// Возвращаемое значение:
// 	Структура:
// * ЭлектронноеВзаимодействие - Строка
// * ОбменСБанками - Строка
// * ОбменСКонтрагентами - Строка
// * ОбменССайтами - Строка
// * РегламентныеЗадания - Строка
// * БизнесСеть - Строка
// * ТорговыеПредложения - Строка
// * ИнтеграцияСЯндексКассой - Строка
// * СопоставлениеНоменклатурыКонтрагентов - Строка
// * Криптография - Строка
// * СервисДоставки - Строка
// * ЭлектронноеАктированиеЕИС - Строка
// * КоммерческиеПредложения - Строка
Функция ПодсистемыБЭД() Экспорт
	
	Подсистемы = Новый Структура;
	Подсистемы.Вставить("ЭлектронноеВзаимодействие", "ЭлектронноеВзаимодействие");
	Подсистемы.Вставить("ОбменСБанками", "ЭлектронноеВзаимодействие.ОбменСБанками");
	Подсистемы.Вставить("ОбменСКонтрагентами", "ЭлектронноеВзаимодействие.ОбменСКонтрагентами");
	Подсистемы.Вставить("ОбменССайтами", "ЭлектронноеВзаимодействие.ОбменССайтами");
	Подсистемы.Вставить("РегламентныеЗадания", "РегламентныеЗадания");
	Подсистемы.Вставить("БизнесСеть", "ЭлектронноеВзаимодействие.БизнесСеть");
	Подсистемы.Вставить("ТорговыеПредложения", "ЭлектронноеВзаимодействие.ТорговыеПредложения");
	Подсистемы.Вставить("ИнтеграцияСЯндексКассой", "ЭлектронноеВзаимодействие.ИнтеграцияСЯндексКассой");
	Подсистемы.Вставить("СопоставлениеНоменклатурыКонтрагентов",
		"ЭлектронноеВзаимодействие.СопоставлениеНоменклатурыКонтрагентов");
	Подсистемы.Вставить("Криптография", "ЭлектронноеВзаимодействие.БазоваяФункциональность.Криптография");
	Подсистемы.Вставить("ИнтернетСоединение", "ЭлектронноеВзаимодействие.БазоваяФункциональность.ИнтернетСоединение");
	Подсистемы.Вставить("РаботаСФайлами", "ЭлектронноеВзаимодействие.БазоваяФункциональность.РаботаСФайлами");
	Подсистемы.Вставить("СервисДоставки", "ЭлектронноеВзаимодействие.СервисДоставки");
	Подсистемы.Вставить("ЭлектронноеАктированиеЕИС", "ЭлектронноеАктированиеЕИС");	
	Подсистемы.Вставить("КоммерческиеПредложения", "ЭлектронноеВзаимодействие.КоммерческиеПредложения");
	
	Возврат Подсистемы;
	
КонецФункции

//++ Локализация

// Определяет, содержит ли строка только определенные символы.
// 
// Параметры:
// 	ИсходнаяСтрока - Строка - строка для проверки
// 	СимволДляПроверки - Строка - символ для проверки
// 	УчитыватьПробелы - Булево - если Истина и в строке помимо указанного символа содержатся пробелы, будет возвращено
// 	                            значение Ложь.
// Возвращаемое значение:
// 	Булево - Истина, если строка содержит только указанные символы
Функция ТолькоСимволыВСтроке(Знач ИсходнаяСтрока, СимволДляПроверки, УчитыватьПробелы = Ложь) Экспорт

	ИсходнаяСтрока = СтрЗаменить(ИсходнаяСтрока, СимволДляПроверки, "");
	
	Возврат УчитыватьПробелы И ИсходнаяСтрока = "" ИЛИ НЕ УчитыватьПробелы И ПустаяСтрока(ИсходнаяСтрока);

КонецФункции

Процедура ДополнитьСписокЗначений(Приемник, Источник) Экспорт
	
	Для Каждого ЭлементСписка Из Источник Цикл
		Приемник.Добавить(ЭлементСписка.Значение, ЭлементСписка.Представление, ЭлементСписка.Пометка, ЭлементСписка.Картинка);
	КонецЦикла;
	
КонецПроцедуры

// Формирует текст сообщения, подставляя значения параметров в шаблоны сообщений.
//
// Параметры:
//  ВидПоля        - Строка - может принимать значения: "Поле", "Колонка", "Список";
//  ВидСообщения   - Строка - может принимать значения: "Заполнение", "Корректность";
//  ИмяПоля        - Строка - имя поля;
//  НомерСтроки    - Строка - номер строки;
//  ИмяСписка      - Строка - имя списка;
//  ТекстСообщения - Строка - текст сообщения о некорректности заполнения.
//
// Возвращаемое значение:
//   Строка - текст сообщения.
//
Функция ТекстСообщения(ВидПоля = "Поле", ВидСообщения = "Заполнение", ИмяПоля = "", НомерСтроки = "", ИмяСписка = "", ТекстСообщения = "") Экспорт

	ТекстСообщения = "";

	Если ВРег(ВидПоля) = "ПОЛЕ" Тогда
		Если ВРег(ВидСообщения) = "ЗАПОЛНЕНИЕ" Тогда
			Шаблон = НСтр("ru = 'Поле ""%1"" не заполнено.'");
		ИначеЕсли ВРег(ВидСообщения) = "КОРРЕКТНОСТЬ" Тогда
			Шаблон = НСтр("ru = 'Поле ""%1"" заполнено некорректно.
                           |
                           |%4'");
		КонецЕсли;
	ИначеЕсли ВРег(ВидПоля) = "КОЛОНКА" Тогда
		Если ВРег(ВидСообщения) = "ЗАПОЛНЕНИЕ" Тогда
			Шаблон = НСтр("ru = 'Не заполнена колонка ""%1"" в строке %2 списка ""%3"".'");
		ИначеЕсли ВРег(ВидСообщения) = "КОРРЕКТНОСТЬ" Тогда
			Шаблон = НСтр("ru = 'Некорректно заполнена колонка ""%1"" в строке %2 списка ""%3"".
                           |
                           |%4'");
		КонецЕсли;
	ИначеЕсли ВРег(ВидПоля) = "СПИСОК" Тогда
		Если ВРег(ВидСообщения) = "ЗАПОЛНЕНИЕ" Тогда
			Шаблон = НСтр("ru = 'Не введено ни одной строки в список ""%3"".'");
		ИначеЕсли ВРег(ВидСообщения) = "КОРРЕКТНОСТЬ" Тогда
			Шаблон = НСтр("ru = 'Некорректно заполнен список ""%3"".
                           |
                           |%4'");
		КонецЕсли;
	КонецЕсли;

	Возврат СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(Шаблон, ИмяПоля, НомерСтроки, ИмяСписка, ТекстСообщения);

КонецФункции

// Формирует служебную структуру, которая может быть использована для указания параметров обработки ошибок для
// реквизитов дерева данных электронного документа.
//
// Параметры:
//  КлючДанных			 - ЛюбаяСсылка - ключ данных для обработки через сообщение пользователю (см. СообщениеПользователю).
//  ПутьКДанным			 - Строка - путь к данным для обработки через сообщение пользователю (см. СообщениеПользователю).
//  НавигационнаяСсылка	 - Строка - навигационная ссылка, по которой нужно перейти при клике на ошибку.
//  ИмяФормы			 - Строка - имя формы, которую нужно открыть при клике на ошибку.
//  ПараметрыФормы		 - Структура - параметры, передаваемые в форму, открываемую при клике на ошибку.
//  ТекстОшибки			 - Строка - используется для переопределения стандартного текста ошибки.
// 
// Возвращаемое значение:
//  Структура:
//    * КлючСообщения - ЛюбаяСсылка - заполняется из параметра "КлючДанных".
//    * ПутьКДаннымСообщения - Строка - заполняется из параметра "ПутьКДанным".
//    * НавигационнаяСсылка - Строка - заполняется из параметра "НавигационнаяСсылка".
//    * ИмяФормы - Строка - заполняется из параметра "ИмяФормы".
//    * ПараметрыФормы - Структура - заполняется из параметра "ПараметрыФормы".
//    * ТекстОшибки - Строка - заполняется из параметра "ТекстОшибки".
//
Функция НовыеПараметрыОшибки(КлючДанных = Неопределено, ПутьКДанным = "", НавигационнаяСсылка = "", ИмяФормы = "",
	ПараметрыФормы = Неопределено, ТекстОшибки = "") Экспорт

	ДанныеОшибки = Новый Структура;
	ДанныеОшибки.Вставить("КлючСообщения", КлючДанных);
	ДанныеОшибки.Вставить("ПутьКДаннымСообщения", ПутьКДанным);
	ДанныеОшибки.Вставить("НавигационнаяСсылка", НавигационнаяСсылка);
	ДанныеОшибки.Вставить("ИмяФормы", ИмяФормы);
	ДанныеОшибки.Вставить("ПараметрыФормы", ПараметрыФормы);
	ДанныеОшибки.Вставить("ТекстОшибки", ТекстОшибки);
	
	Возврат ДанныеОшибки;

КонецФункции

Процедура УстановитьСвойствоСтруктуры(Структура, Знач ИерархияСвойств, Знач Значение) Экспорт
	
	Если ТипЗнч(ИерархияСвойств) = Тип("Строка") Тогда
		ИерархияСвойств = СтрРазделить(ИерархияСвойств, ".");
	КонецЕсли;
	
	ТекущееСвойство = ИерархияСвойств[0];
	
	Если ИерархияСвойств.Количество() = 1 Тогда
		
		Структура.Вставить(ТекущееСвойство, Значение);
		
	Иначе
		
		ТекущееЗначение = Неопределено;
		Если Не Структура.Свойство(ТекущееСвойство, ТекущееЗначение) Тогда
			ТекущееЗначение = Новый Структура;
		КонецЕсли;
		ИерархияСвойств.Удалить(0);
		УстановитьСвойствоСтруктуры(ТекущееЗначение, ИерархияСвойств, Значение);
		Структура.Вставить(ТекущееСвойство, ТекущееЗначение);
		
	КонецЕсли;
	
КонецПроцедуры

// Преобразует ключи и значения элементов структуры в строку.
//
// Параметры:
//	Структура - Структура - структура, ключи и значения которой преобразуются в строку.
//	РазделительКлючЗначение - Строка - разделитель, который вставляется в строку между ключом и значением структуры.
//	РазделительЭлементов - Строка - разделитель, который вставляется в строку между элементами структуры.
//
// Возвращаемое значение:
//	Строка - строка, содержащая ключи и значения элементов структуры разделенные разделителем.
//
Функция СтруктураВСтроку(Структура, РазделительКлючЗначение = "=", РазделительЭлементов = ";") Экспорт
	
	МассивСтрок = Новый Массив;
	
	Для Каждого Элемент Из Структура Цикл
		МассивСтрок.Добавить(Элемент.Ключ + РазделительКлючЗначение + Элемент.Значение);
	КонецЦикла;
	
	Возврат СтрСоединить(МассивСтрок, РазделительЭлементов);
	
КонецФункции

// Возвращает форматированную дату+время без секунд.
// 
// Параметры:
//  ДатаВремя - Дата
// 
// Возвращаемое значение:
//  Строка - Форматированная дата
//  
Функция ДатаВремяБезСекунд(ДатаВремя) Экспорт
	
	ЛокализованныйФорматДаты = НСтр("ru = 'ДФ=''dd.MM.yyyy HH:mm'''"); 
	Возврат Формат(ДатаВремя, ЛокализованныйФорматДаты);
	
КонецФункции

//-- Локализация

#КонецОбласти