﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2023, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Открыть стандартную форму ожидания завершения длительной операции или использовать собственную форму
// и подключить обработчик оповещения о завершении и прогрессе выполнения процедуры длительной операции.
// 
//  Применяется совместно с функцией ДлительныеОперации.ВыполнитьВФоне для повышения отзывчивости
// пользовательского интерфейса, заменяя длительный серверный вызов на запуск фонового задания.
// 
// Параметры:
//  ДлительнаяОперация     - см. ДлительныеОперации.ВыполнитьВФоне
//  ОповещениеОЗавершении  - ОписаниеОповещения - оповещение, которое вызывается при завершении фонового задания. 
//                           Параметры процедуры-обработчика оповещения: 
//   * Результат - Структура
//               - Неопределено - структура со свойствами или Неопределено, если задание было отменено:
//     ** Статус           - Строка - "Выполнено", если задание было успешно выполнено;
//	                                  "Ошибка", если задание завершено с ошибкой.
//     ** АдресРезультата  - Строка - адрес временного хранилища, в которое будет
//	                                  помещен (или уже помещен) результат работы процедуры.
//     ** АдресДополнительногоРезультата - Строка - если установлен параметр ДополнительныйРезультат, 
//	                                     содержит адрес дополнительного временного хранилища,
//	                                     в которое будет помещен (или уже помещен) результат работы процедуры.
//     ** КраткоеПредставлениеОшибки   - Строка - краткая информация об исключении, если Статус = "Ошибка".
//     ** ПодробноеПредставлениеОшибки - Строка - подробная информация об исключении, если Статус = "Ошибка".
//     ** Сообщения        - ФиксированныйМассив - массив объектов СообщениеПользователю, 
//                                         сформированных в процедуре-обработчике длительной операции.
//                                         Массив будет пустым, когда в параметре ПараметрыОжидания
//                                         свойство ВыводитьОкноОжидания = Истина или
//                                         заполнено свойство ОповещениеОПрогрессеВыполнения.
//   * ДополнительныеПараметры - Произвольный - произвольные данные, переданные в описании оповещения. 
//  ПараметрыОжидания      - см. ДлительныеОперацииКлиент.ПараметрыОжидания
//
Процедура ОжидатьЗавершение(Знач ДлительнаяОперация, Знач ОповещениеОЗавершении = Неопределено, 
	Знач ПараметрыОжидания = Неопределено) Экспорт
	
	ПроверитьПараметрыОжидатьЗавершение(ДлительнаяОперация, ОповещениеОЗавершении, ПараметрыОжидания);
	
	РасширенныеПараметры = ПараметрыОжидания(Неопределено);
	Если ПараметрыОжидания <> Неопределено Тогда
		ЗаполнитьЗначенияСвойств(РасширенныеПараметры, ПараметрыОжидания);
	КонецЕсли;
	Если ДлительнаяОперация.Свойство("АдресРезультата") Тогда
		РасширенныеПараметры.Вставить("АдресРезультата", ДлительнаяОперация.АдресРезультата);
	КонецЕсли;
	Если ДлительнаяОперация.Свойство("АдресДополнительногоРезультата") Тогда
		РасширенныеПараметры.Вставить("АдресДополнительногоРезультата", ДлительнаяОперация.АдресДополнительногоРезультата);
	КонецЕсли;
	РасширенныеПараметры.Вставить("ИдентификаторЗадания", ДлительнаяОперация.ИдентификаторЗадания);
	
	Если ДлительнаяОперация.Статус <> "Выполняется" Тогда
		РасширенныеПараметры.Вставить("НакопленныеСообщения", Новый Массив(ДлительнаяОперация.Сообщения));
		РасширенныеПараметры.Вставить("ОповещениеОЗавершении", ОповещениеОЗавершении);
		ЗавершитьДлительнуюОперацию(РасширенныеПараметры, ДлительнаяОперация);
		Возврат;
	КонецЕсли;
	
	Если РасширенныеПараметры.ВыводитьОкноОжидания Тогда
		РасширенныеПараметры.Удалить("ФормаВладелец");
		
		Контекст = Новый Структура;
		Контекст.Вставить("Результат");
		Контекст.Вставить("ИдентификаторЗадания", РасширенныеПараметры.ИдентификаторЗадания);
		Контекст.Вставить("ОповещениеОЗавершении", ОповещениеОЗавершении);
		ОповещениеОЗакрытии = Новый ОписаниеОповещения("ПриЗакрытииФормыДлительнаяОперация",
			ЭтотОбъект, Контекст);
		
		ОткрытьФорму("ОбщаяФорма.ДлительнаяОперация", РасширенныеПараметры, 
			?(ПараметрыОжидания <> Неопределено, ПараметрыОжидания.ФормаВладелец, Неопределено),
			,,,ОповещениеОЗакрытии);
	Иначе
		РасширенныеПараметры.Вставить("НакопленныеСообщения", Новый Массив);
		РасширенныеПараметры.Вставить("ОповещениеОЗавершении", ОповещениеОЗавершении);
		РасширенныеПараметры.Вставить("ТекущийИнтервал", ?(РасширенныеПараметры.Интервал <> 0, РасширенныеПараметры.Интервал, 1));
		РасширенныеПараметры.Вставить("Контроль", ТекущаяДата() + РасширенныеПараметры.ТекущийИнтервал); // АПК:143 Дата сеанса не используется для проверки интервалов
		РасширенныеПараметры.Вставить("ВремяОтправкиПоследнегоПрогресса", 0);
		
		Операции = АктивныеДлительныеОперации();
		Операции.Список.Вставить(РасширенныеПараметры.ИдентификаторЗадания, РасширенныеПараметры);
		СерверныеОповещенияКлиент.ПодключитьОбработчикПроверкиПолученияСерверныхОповещений();
	КонецЕсли;
	
КонецПроцедуры

// Возвращает пустую структуру для параметра ПараметрыОжидания процедуры ДлительныеОперацииКлиент.ОжидатьЗавершение.
//
// Параметры:
//  ФормаВладелец - ФормаКлиентскогоПриложения
//                - Неопределено - форма, из которой вызывается длительная операция.
//
// Возвращаемое значение:
//  Структура              - параметры выполнения задания: 
//   * ФормаВладелец          - ФормаКлиентскогоПриложения
//                            - Неопределено - форма, из которой вызывается длительная операция.
//   * Заголовок              - Строка - заголовок окна, выводимый на форме ожидания. Если не задан, то не выводится.
//   * ТекстСообщения         - Строка - текст сообщения, выводимый на форме ожидания.
//                                       Если не задан, то выводится "Пожалуйста, подождите...".
//   * ВыводитьОкноОжидания   - Булево - если Истина, то открыть окно ожидания с визуальной индикацией длительной операции. 
//                                       Если используется собственный механизм индикации, то следует указать Ложь.
//   * ВыводитьПрогрессВыполнения - Булево - выводить прогресс выполнения в процентах на форме ожидания.
//                                      Процедура-обработчик длительной операции может сообщить о ходе своего выполнения
//                                      с помощью вызова процедуры ДлительныеОперации.СообщитьПрогресс.
//   * ОповещениеОПрогрессеВыполнения - ОписаниеОповещения - оповещение, которое периодически вызывается при 
//                                      проверке готовности фонового задания, если ВыводитьОкноОжидания = Ложь.
//                                      Параметры процедуры-обработчика оповещения:
//      # ДлительнаяОперация - Структура, Неопределено - структура со свойствами или Неопределено, если задание было
//      отменено. Свойства: ## Статус               - Строка - "Выполняется", если задание еще не завершилось;
//                                           "Выполнено", если задание было успешно выполнено;
//	                                         "Ошибка", если задание завершено с ошибкой;
//                                           "Отменено", если задание отменено пользователем или администратором.
//	     ## ИдентификаторЗадания - УникальныйИдентификатор - идентификатор запущенного фонового задания.
//	     ## Прогресс             - Структура, Неопределено - результат функции ДлительныеОперации.ПрочитатьПрогресс.
//	     ## Сообщения            - ФиксированныйМассив, Неопределено - массив объектов СообщениеПользователю, 
//                                  очередная порция сообщений, сформированных в процедуре-обработчике длительной операции.
//      # ДополнительныеПараметры - Произвольный - произвольные данные, переданные в описании оповещения. 
//
//   * ВыводитьСообщения      - Булево - выводить на форме ожидания сообщения,
//                                       сформированные в процедуре-обработчике длительной операции.
//   * Интервал               - Число  - интервал в секундах между проверками готовности длительной операции.
//                                       По умолчанию 0 - после каждой проверки интервал увеличивается с 1 до 15 секунд
//                                       с коэффициентом 1.4.
//   * ОповещениеПользователя - Структура:
//     ** Показать            - Булево - если Истина, то по завершении длительной операции вывести оповещение пользователя.
//     ** Текст               - Строка - текст оповещения пользователя.
//     ** НавигационнаяСсылка - Строка - навигационная ссылка оповещения пользователя.
//     ** Пояснение           - Строка - пояснение оповещения пользователя.
//     ** Картинка            - Картинка - картинка, которая будет показана в окне оповещения. Если Неопределено, то
//                                         картинка не выводится.
//     ** Важное              - Булево - если Истина, то оповещение после автоматического закрытия будет добавлено в
//                                       центр оповещений.
//   
//   * ПолучатьРезультат - Булево - служебный параметр. Не предназначен для использования.
//
Функция ПараметрыОжидания(ФормаВладелец) Экспорт
	
	Результат = Новый Структура;
	Результат.Вставить("ФормаВладелец", ФормаВладелец);
	Результат.Вставить("ТекстСообщения", "");
	Результат.Вставить("Заголовок", "");
	Результат.Вставить("ВыводитьОкноОжидания", Истина);
	Результат.Вставить("ВыводитьПрогрессВыполнения", Ложь);
	Результат.Вставить("ОповещениеОПрогрессеВыполнения", Неопределено);
	Результат.Вставить("ВыводитьСообщения", Ложь);
	Результат.Вставить("Интервал", 0);
	Результат.Вставить("ПолучатьРезультат", Ложь);
	Результат.Вставить("ОтменятьПриЗакрытииФормыВладельца",
		ТипЗнч(ФормаВладелец) = Тип("ФормаКлиентскогоПриложения") И ФормаВладелец.Открыта());
	
	ОповещениеПользователя = Новый Структура;
	ОповещениеПользователя.Вставить("Показать", Ложь);
	ОповещениеПользователя.Вставить("Текст", Неопределено);
	ОповещениеПользователя.Вставить("НавигационнаяСсылка", Неопределено);
	ОповещениеПользователя.Вставить("Пояснение", Неопределено);
	ОповещениеПользователя.Вставить("Картинка", Неопределено);
	ОповещениеПользователя.Вставить("Важное", Неопределено);
	Результат.Вставить("ОповещениеПользователя", ОповещениеПользователя);
	
	Возврат Результат;
	
КонецФункции

#Область УстаревшиеПроцедурыИФункции

// Устарела. Следует использовать ОжидатьЗавершение с параметром ПараметрыОжидания.ВыводитьОкноОжидания = Истина.
// Заполняет структуру параметров значениями по умолчанию.
// 
// Параметры:
//  ПараметрыОбработчикаОжидания - Структура - заполняется значениями по умолчанию. 
//
// 
Процедура ИнициализироватьПараметрыОбработчикаОжидания(ПараметрыОбработчикаОжидания) Экспорт
	
	ПараметрыОбработчикаОжидания = Новый Структура;
	ПараметрыОбработчикаОжидания.Вставить("МинимальныйИнтервал", 1);
	ПараметрыОбработчикаОжидания.Вставить("МаксимальныйИнтервал", 15);
	ПараметрыОбработчикаОжидания.Вставить("ТекущийИнтервал", 1);
	ПараметрыОбработчикаОжидания.Вставить("КоэффициентУвеличенияИнтервала", 1.4);
	
КонецПроцедуры

// Устарела. Следует использовать ОжидатьЗавершение с параметром ПараметрыОжидания.ВыводитьОкноОжидания = Истина.
// Заполняет структуру параметров новыми расчетными значениями.
// 
// Параметры:
//  ПараметрыОбработчикаОжидания - Структура - заполняется расчетными значениями. 
//
// 
Процедура ОбновитьПараметрыОбработчикаОжидания(ПараметрыОбработчикаОжидания) Экспорт
	
	ПараметрыОбработчикаОжидания.ТекущийИнтервал = ПараметрыОбработчикаОжидания.ТекущийИнтервал * ПараметрыОбработчикаОжидания.КоэффициентУвеличенияИнтервала;
	Если ПараметрыОбработчикаОжидания.ТекущийИнтервал > ПараметрыОбработчикаОжидания.МаксимальныйИнтервал Тогда
		ПараметрыОбработчикаОжидания.ТекущийИнтервал = ПараметрыОбработчикаОжидания.МаксимальныйИнтервал;
	КонецЕсли;
		
КонецПроцедуры

// Устарела. Следует использовать ОжидатьЗавершение с параметром ПараметрыОжидания.ВыводитьОкноОжидания = Истина.
// Открывает форму-индикатор длительной операции.
// 
// Параметры:
//  ВладелецФормы        - ФормаКлиентскогоПриложения - форма, из которой производится открытие. 
//  ИдентификаторЗадания - УникальныйИдентификатор - идентификатор фонового задания.
//
// Возвращаемое значение:
//  ФормаКлиентскогоПриложения     - ссылка на открытую форму.
// 
Функция ОткрытьФормуДлительнойОперации(Знач ВладелецФормы, Знач ИдентификаторЗадания) Экспорт
	
	Возврат ОткрытьФорму("ОбщаяФорма.ДлительнаяОперация",
		Новый Структура("ИдентификаторЗадания", ИдентификаторЗадания), 
		ВладелецФормы);
	
КонецФункции

// Устарела. Следует использовать ОжидатьЗавершение с параметром ПараметрыОжидания.ВыводитьОкноОжидания = Истина.
// Закрывает форму-индикатор длительной операции.
// 
// Параметры:
//  ФормаДлительнойОперации - ФормаКлиентскогоПриложения - ссылка на форму-индикатор длительной операции. 
//
Процедура ЗакрытьФормуДлительнойОперации(ФормаДлительнойОперации) Экспорт
	
	Если ТипЗнч(ФормаДлительнойОперации) = Тип("ФормаКлиентскогоПриложения") Тогда
		Если ФормаДлительнойОперации.Открыта() Тогда
			ФормаДлительнойОперации.Закрыть();
		КонецЕсли;
	КонецЕсли;
	ФормаДлительнойОперации = Неопределено;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

////////////////////////////////////////////////////////////////////////////////
// Обработчики событий подсистем конфигурации.

// Параметры:
//  Параметры - см. ОбщегоНазначенияПереопределяемый.ПередПериодическойОтправкойДанныхКлиентаНаСервер.Параметры
//  ОбсужденияАктивны - Булево - для доставки сообщений используется подсистема взаимодействия.
//  Интервал - Число - уточняемое значение - число секунд до следующей проверки.
//
Процедура ПередПериодическойОтправкойДанныхКлиентаНаСервер(Параметры, ОбсужденияАктивны, Интервал) Экспорт
	
	Результат = ПараметрыПроверкиДлительныхОпераций(ОбсужденияАктивны, Интервал);
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Параметры.Вставить("СтандартныеПодсистемы.БазоваяФункциональность.ПараметрыПроверкиДлительныхОпераций", Результат)
	
КонецПроцедуры

// Параметры:
//  Результаты - см. ОбщегоНазначенияПереопределяемый.ПриПериодическомПолученииДанныхКлиентаНаСервере.Результаты
//  ОбсужденияАктивны - Булево - для доставки сообщений используется подсистема взаимодействия.
//  Интервал - Число - уточняемое значение - число секунд до следующей проверки.
//
Процедура ПослеПериодическогоПолученияДанныхКлиентаНаСервере(Результаты, ОбсужденияАктивны, Интервал) Экспорт
	
	РезультатыОпераций = Результаты.Получить( // см. ДлительныеОперации.РезультатПроверкиДлительныхОпераций
		"СтандартныеПодсистемы.БазоваяФункциональность.РезультатПроверкиДлительныхОпераций");
	
	Если РезультатыОпераций = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ТекущиеДлительныеОперации = АктивныеДлительныеОперации();
	АктивныеДлительныеОперации = ТекущиеДлительныеОперации.Список;
	КонтролируемыеОперации     = ТекущиеДлительныеОперации.КонтролируемыеОперации;
	
	Для Каждого РезультатОперации Из РезультатыОпераций Цикл
		Операция = КонтролируемыеОперации[РезультатОперации.Ключ];
		Результат = РезультатОперации.Значение; // Структура
		Результат.Вставить("ФоновоеЗаданиеЗавершено");
		Результат.Вставить("КонтрольДлительныхОперацийБезСистемыВзаимодействия");
		ОбработатьРезультатОперации(АктивныеДлительныеОперации, Операция, Результат);
	КонецЦикла;
	
	ТекущиеДлительныеОперации.КонтролируемыеОперации = Новый Соответствие;

	Если АктивныеДлительныеОперации.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	УточнитьИнтервалОбработчикаОжидания(Интервал, АктивныеДлительныеОперации, ОбсужденияАктивны);
	
КонецПроцедуры

// Параметры:
//  Результат - Неопределено
//  Контекст - Структура:
//   * Результат - Структура
//               - Неопределено
//   * ИдентификаторЗадания  - УникальныйИдентификатор
//                           - Неопределено
//   * ОповещениеОЗавершении - ОписаниеОповещения
//                           - Неопределено
//
Процедура ПриЗакрытииФормыДлительнаяОперация(Результат, Контекст) Экспорт
	
	Если Контекст.ОповещениеОЗавершении <> Неопределено Тогда
		ОповеститьОЗавершенииДлительнойОперации(Контекст.ОповещениеОЗавершении,
			Контекст.Результат, Контекст.ИдентификаторЗадания);
	КонецЕсли;
	
КонецПроцедуры

// Параметры:
//  ОбсужденияАктивны - Булево - для доставки сообщений используется подсистема взаимодействия.
//  Интервал - Число - уточняемое значение - число секунд до следующей проверки.
//
// Возвращаемое значение:
//  Неопределено - проверка не требуется.
//  Структура:
//   * ЗаданияДляПроверки - Массив из УникальныйИдентификатор
//   * ЗаданияДляОтмены - Массив из УникальныйИдентификатор
//
Функция ПараметрыПроверкиДлительныхОпераций(ОбсужденияАктивны, Интервал)
	
	ТекущаяДата = ТекущаяДата(); // АПК:143 Дата сеанса не используется для проверки интервалов времени
	
	КонтролируемыеОперации = Новый Соответствие;
	ЗаданияДляПроверки = Новый Массив;
	ЗаданияДляОтмены = Новый Массив;
	
	ТекущиеДлительныеОперации = АктивныеДлительныеОперации();
	АктивныеДлительныеОперации = ТекущиеДлительныеОперации.Список;
	ТекущиеДлительныеОперации.КонтролируемыеОперации = КонтролируемыеОперации;
	
	Если Не ЗначениеЗаполнено(АктивныеДлительныеОперации) Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Для Каждого ДлительнаяОперация Из АктивныеДлительныеОперации Цикл
		
		ДлительнаяОперация = ДлительнаяОперация.Значение;
		
		Если ДлительнаяОперацияОтменена(ДлительнаяОперация) Тогда
			КонтролируемыеОперации.Вставить(ДлительнаяОперация.ИдентификаторЗадания, ДлительнаяОперация);
			ЗаданияДляОтмены.Добавить(ДлительнаяОперация.ИдентификаторЗадания);
		Иначе
			ИнтервалКонтроляОбсуждений = ИнтервалКонтроляОбсуждений();
			ДатаКонтроля = ДлительнаяОперация.Контроль
				+ ?(Не ОбсужденияАктивны Или ДлительнаяОперация.ТекущийИнтервал > ИнтервалКонтроляОбсуждений,
					0, ИнтервалКонтроляОбсуждений - ДлительнаяОперация.ТекущийИнтервал);
			
			Если ДатаКонтроля <= ТекущаяДата Тогда
				КонтролируемыеОперации.Вставить(ДлительнаяОперация.ИдентификаторЗадания, ДлительнаяОперация);
				ЗаданияДляПроверки.Добавить(ДлительнаяОперация.ИдентификаторЗадания);
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
	Если Не ЗначениеЗаполнено(ЗаданияДляПроверки)
	   И Не ЗначениеЗаполнено(ЗаданияДляОтмены) Тогда
		
		УточнитьИнтервалОбработчикаОжидания(Интервал, АктивныеДлительныеОперации, ОбсужденияАктивны);
		Возврат Неопределено;
	КонецЕсли;
	
	Результат = Новый Структура;
	Результат.Вставить("ЗаданияДляПроверки", ЗаданияДляПроверки);
	Результат.Вставить("ЗаданияДляОтмены",   ЗаданияДляОтмены);
	
	Возврат Результат;
	
КонецФункции

Функция ДлительнаяОперацияОтменена(ДлительнаяОперация)
	
	Возврат ДлительнаяОперация.ОтменятьПриЗакрытииФормыВладельца
	    И ДлительнаяОперация.ФормаВладелец <> Неопределено
		И Не ДлительнаяОперация.ФормаВладелец.Открыта();
	
КонецФункции

Процедура ОбработатьРезультатОперации(АктивныеДлительныеОперации, Операция, Результат)
	
	Если АктивныеДлительныеОперации.Получить(Операция.ИдентификаторЗадания) = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Попытка
		Если ОбработатьРезультатАктивнойОперации(Операция, Результат) Тогда
			АктивныеДлительныеОперации.Удалить(Операция.ИдентификаторЗадания);
		КонецЕсли;
	Исключение
		// далее не отслеживаем
		АктивныеДлительныеОперации.Удалить(Операция.ИдентификаторЗадания);
		ВызватьИсключение;
	КонецПопытки;
	
КонецПроцедуры

Процедура УточнитьИнтервалОбработчикаОжидания(Интервал, АктивныеДлительныеОперации, ОбсужденияАктивны)
	
	ТекущаяДата = ТекущаяДата(); // АПК:143 Дата сеанса не используется для проверки интервалов времени
	НовыйИнтервал = 120; 
	Для каждого Операция Из АктивныеДлительныеОперации Цикл
		НовыйИнтервал = Макс(Мин(НовыйИнтервал, Операция.Значение.Контроль - ТекущаяДата), 1);
	КонецЦикла;
	
	ИнтервалКонтроляОбсуждений = ИнтервалКонтроляОбсуждений();
	Если ОбсужденияАктивны И НовыйИнтервал < ИнтервалКонтроляОбсуждений Тогда
		НовыйИнтервал = ИнтервалКонтроляОбсуждений;
	КонецЕсли;
	
	Если Интервал > НовыйИнтервал Тогда
		Интервал = НовыйИнтервал;
	КонецЕсли;
	
КонецПроцедуры

// Возвращаемое значение:
//  Число - число секунд контроля длительной операции
//          через общий серверный вызов, когда обсуждения
//          активны, но сообщений не поступило, например,
//          при операции дольше указанного числа секунд
//          или когда произошло аварийное завершение фонового задания и
//          сообщение через систему взаимодействия не было отправлено.
//
Функция ИнтервалКонтроляОбсуждений()
	
	Возврат 30;
	
КонецФункции

// См. СтандартныеПодсистемыКлиент.ПриПолученииСерверногоОповещения
Процедура ПриПолученииСерверногоОповещения(ИмяОповещения, Результат) Экспорт
	
	АктивныеДлительныеОперации = АктивныеДлительныеОперации().Список;
	Операция = АктивныеДлительныеОперации.Получить(Результат.ИдентификаторЗадания);
	Если Операция = Неопределено
	 Или ДлительнаяОперацияОтменена(Операция) Тогда
		Возврат;
	КонецЕсли;
	
	Если Результат.ВидОповещения = "Прогресс" Тогда
		Если Операция.ВремяОтправкиПоследнегоПрогресса < Результат.ВремяОтправки Тогда
			Операция.ВремяОтправкиПоследнегоПрогресса = Результат.ВремяОтправки;
		Иначе
			Возврат; // Устаревшее сообщение прогресса пропускается.
		КонецЕсли;
	КонецЕсли;
	
	ОбработатьРезультатОперации(АктивныеДлительныеОперации, Операция, Результат.Результат);
	
КонецПроцедуры

// Параметры:
//  ДлительнаяОперация - Структура:
//   * ФормаВладелец          - ФормаКлиентскогоПриложения
//                            - Неопределено
//   * Заголовок              - Строка
//   * ТекстСообщения         - Строка
//   * ВыводитьОкноОжидания   - Булево
//   * ВыводитьПрогрессВыполнения - Булево
//   * ОповещениеОПрогрессеВыполнения - ОписаниеОповещения
//                                    - Неопределено
//   * ВыводитьСообщения      - Булево
//   * Интервал               - Число
//   * ОповещениеПользователя - Структура:
//     ** Показать            - Булево
//     ** Текст               - Строка
//     ** НавигационнаяСсылка - Строка
//     ** Пояснение           - Строка
//     ** Картинка            - Картинка
//     ** Важное              - Булево
//    
//   * ОтменятьПриЗакрытииФормыВладельца - Булево
//   * ПолучатьРезультат
//   
//   * ИдентификаторЗадания  - УникальныйИдентификатор
//   * НакопленныеСообщения  - Массив
//   * ОповещениеОЗавершении - ОписаниеОповещения
//                           - Неопределено
//   * ТекущийИнтервал       - Число
//   * Контроль              - Дата
//    
//   * ВремяОтправкиПоследнегоПрогресса - Число - универсальная дата в миллисекундах
//
//  Результат - см. ДлительныеОперации.НовыйРезультатВыполненияОперации
//
Функция ОбработатьРезультатАктивнойОперации(ДлительнаяОперация, Результат)
	
	Если Результат.Статус <> "Отменено" Тогда
		Если ДлительнаяОперация.ОповещениеОПрогрессеВыполнения <> Неопределено Тогда
			Прогресс = Новый Структура;
			Прогресс.Вставить("Статус", Результат.Статус);
			Прогресс.Вставить("ИдентификаторЗадания", ДлительнаяОперация.ИдентификаторЗадания);
			Прогресс.Вставить("Прогресс", Результат.Прогресс);
			Прогресс.Вставить("Сообщения", Результат.Сообщения);
			Попытка
				ВыполнитьОбработкуОповещения(ДлительнаяОперация.ОповещениеОПрогрессеВыполнения, Прогресс);
			Исключение
				ИнформацияОбОшибке = ИнформацияОбОшибке();
				ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru = 'При вызове оповещения о прогрессе длительной операции
					           |%1 возникла ошибка:
					           |%2'"),
					Строка(ДлительнаяОперация.ИдентификаторЗадания),
					ПодробноеПредставлениеОшибки(ИнформацияОбОшибке));
				ЖурналРегистрацииКлиент.ДобавитьСообщениеДляЖурналаРегистрации(
					НСтр("ru = 'Длительные операции.Ошибка вызова обработчика события'",
						ОбщегоНазначенияКлиент.КодОсновногоЯзыка()),
					"Ошибка",
					ТекстОшибки);
			КонецПопытки;
		ИначеЕсли Результат.Сообщения <> Неопределено Тогда
			Для Каждого Сообщение Из Результат.Сообщения Цикл
				ДлительнаяОперация.НакопленныеСообщения.Добавить(Сообщение);
			КонецЦикла;
		КонецЕсли;
	КонецЕсли;
	
	Если Результат.Статус <> "Выполняется" Тогда
		Если Результат.Статус <> "Выполнено"
		 Или Результат.Свойство("ФоновоеЗаданиеЗавершено")
		 Или Не (  ДлительнаяОперация.Свойство("АдресРезультата")
		         И ЗначениеЗаполнено(ДлительнаяОперация.АдресРезультата)
		       Или ДлительнаяОперация.Свойство("АдресДополнительногоРезультата")
		         И ЗначениеЗаполнено(ДлительнаяОперация.АдресДополнительногоРезультата))
		 // Требуется проверка, так как оповещение отправляется в конце фонового задания
		 // до его завершения и данные результата еще недоступны по адресу временного хранилища.
		 Или ДлительныеОперацииВызовСервера.ФоновоеЗаданиеЗавершено(ДлительнаяОперация.ИдентификаторЗадания) Тогда
			
			ЗавершитьДлительнуюОперацию(ДлительнаяОперация, Результат);
			Возврат Истина;
		КонецЕсли;
	КонецЕсли;
	
	ИнтервалОжидания = ДлительнаяОперация.ТекущийИнтервал;
	Если ДлительнаяОперация.Интервал = 0
	   И Результат.Свойство("КонтрольДлительныхОперацийБезСистемыВзаимодействия") Тогда
		ИнтервалОжидания = ИнтервалОжидания * 1.4;
		Если ИнтервалОжидания > 15 Тогда
			ИнтервалОжидания = 15;
		КонецЕсли;
		ДлительнаяОперация.ТекущийИнтервал = ИнтервалОжидания;
	КонецЕсли;
	ДлительнаяОперация.Контроль = ТекущаяДата() + ИнтервалОжидания; // АПК:143 Дата сеанса не используется для проверки интервалов
	Возврат Ложь;
	
КонецФункции

Процедура ЗавершитьДлительнуюОперацию(Знач ДлительнаяОперация, Знач Статус)
	
	Если Статус.Статус = "Выполнено" Тогда
		ПоказатьОповещение(ДлительнаяОперация.ОповещениеПользователя);
	КонецЕсли;
	
	Если ДлительнаяОперация.ОповещениеОЗавершении = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если Статус.Статус = "Отменено" Тогда
		Результат = Неопределено;
	Иначе
		Результат = Новый Структура;
		Результат.Вставить("Статус",    Статус.Статус);
		Если ДлительнаяОперация.Свойство("АдресРезультата") Тогда
			Результат.Вставить("АдресРезультата", ДлительнаяОперация.АдресРезультата);
		КонецЕсли;
		Если ДлительнаяОперация.Свойство("АдресДополнительногоРезультата") Тогда
			Результат.Вставить("АдресДополнительногоРезультата", ДлительнаяОперация.АдресДополнительногоРезультата);
		КонецЕсли;
		Результат.Вставить("КраткоеПредставлениеОшибки", Статус.КраткоеПредставлениеОшибки);
		Результат.Вставить("ПодробноеПредставлениеОшибки", Статус.ПодробноеПредставлениеОшибки);
		Результат.Вставить("Сообщения", Новый ФиксированныйМассив(ДлительнаяОперация.НакопленныеСообщения));
	КонецЕсли;
	
	ОповеститьОЗавершенииДлительнойОперации(ДлительнаяОперация.ОповещениеОЗавершении,
		Результат, ДлительнаяОперация.ИдентификаторЗадания);
	
КонецПроцедуры

Процедура ОповеститьОЗавершенииДлительнойОперации(ОповещениеОЗавершении, Результат, ИдентификаторЗадания)
	
	Попытка
		ВыполнитьОбработкуОповещения(ОповещениеОЗавершении, Результат);
	Исключение
		ИнформацияОбОшибке = ИнформацияОбОшибке();
		ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'При вызове оповещения о завершении длительной операции
			           |%1 возникла ошибка:
			           |%2'"),
			Строка(ИдентификаторЗадания),
			ПодробноеПредставлениеОшибки(ИнформацияОбОшибке));
		ЖурналРегистрацииКлиент.ДобавитьСообщениеДляЖурналаРегистрации(
			НСтр("ru = 'Длительные операции.Ошибка вызова обработчика события'",
				ОбщегоНазначенияКлиент.КодОсновногоЯзыка()),
			"Ошибка", ТекстОшибки,, Истина);
		ПоказатьИнформациюОбОшибке(ИнформацияОбОшибке);
	КонецПопытки;
	
КонецПроцедуры

// Возвращаемое значение:
//   Структура:
//    * Список - Соответствие из КлючИЗначение:
//       ** Ключ - УникальныйИдентификатор - идентификатор фонового задания.
//       ** Значение - см. ОбработатьРезультатАктивнойОперации.ДлительнаяОперация
//    * КонтролируемыеОперации - Соответствие из КлючИЗначение:
//       ** Ключ - УникальныйИдентификатор - идентификатор фонового задания.
//       ** Значение - см. ОбработатьРезультатАктивнойОперации.ДлительнаяОперация
//
Функция АктивныеДлительныеОперации()
	
	ИмяПараметра = "СтандартныеПодсистемы.АктивныеДлительныеОперации";
	Если ПараметрыПриложения[ИмяПараметра] = Неопределено Тогда
		Операции = Новый Структура;
		Операции.Вставить("Список", Новый Соответствие);
		Операции.Вставить("КонтролируемыеОперации", Новый Соответствие);
		ПараметрыПриложения.Вставить(ИмяПараметра, Операции);
	КонецЕсли;
	
	Возврат ПараметрыПриложения[ИмяПараметра];

КонецФункции

Процедура ПроверитьПараметрыОжидатьЗавершение(Знач ДлительнаяОперация, Знач ОповещениеОЗавершении, Знач ПараметрыОжидания)
	
	ОбщегоНазначенияКлиентСервер.ПроверитьПараметр("ДлительныеОперацииКлиент.ОжидатьЗавершение",
		"ДлительнаяОперация", ДлительнаяОперация, Тип("Структура"));
	
	Если ОповещениеОЗавершении <> Неопределено Тогда
		ОбщегоНазначенияКлиентСервер.ПроверитьПараметр("ДлительныеОперацииКлиент.ОжидатьЗавершение",
			"ОповещениеОЗавершении", ОповещениеОЗавершении, Тип("ОписаниеОповещения"));
	КонецЕсли;
	
	Если ПараметрыОжидания <> Неопределено Тогда
		
		ТипыСвойств = Новый Структура;
		Если ПараметрыОжидания.ФормаВладелец <> Неопределено Тогда
			ТипыСвойств.Вставить("ФормаВладелец", Тип("ФормаКлиентскогоПриложения"));
		КонецЕсли;
		ТипыСвойств.Вставить("ТекстСообщения", Тип("Строка"));
		ТипыСвойств.Вставить("Заголовок",      Тип("Строка"));
		ТипыСвойств.Вставить("ВыводитьОкноОжидания", Тип("Булево"));
		ТипыСвойств.Вставить("ВыводитьПрогрессВыполнения", Тип("Булево"));
		ТипыСвойств.Вставить("ВыводитьСообщения", Тип("Булево"));
		ТипыСвойств.Вставить("Интервал", Тип("Число"));
		ТипыСвойств.Вставить("ОповещениеПользователя", Тип("Структура"));
		ТипыСвойств.Вставить("ПолучатьРезультат", Тип("Булево"));
		
		ОбщегоНазначенияКлиентСервер.ПроверитьПараметр("ДлительныеОперацииКлиент.ОжидатьЗавершение",
			"ПараметрыОжидания", ПараметрыОжидания, Тип("Структура"), ТипыСвойств);
			
		СообщениеПроверки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Параметр %1 должен быть больше или равен 1'"), "ПараметрыОжидания.Интервал");
		
		ОбщегоНазначенияКлиентСервер.Проверить(ПараметрыОжидания.Интервал = 0 Или ПараметрыОжидания.Интервал >= 1,
			СообщениеПроверки, "ДлительныеОперацииКлиент.ОжидатьЗавершение");
			
		СообщениеПроверки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Если параметр %1 установлен в %2, то параметр %3 не поддерживается'"),
			"ПараметрыОжидания.ВыводитьОкноОжидания",
			"Истина",
			"ПараметрыОжидания.ОповещениеОПрогрессеВыполнения");
			
		ОбщегоНазначенияКлиентСервер.Проверить(Не (ПараметрыОжидания.ОповещениеОПрогрессеВыполнения <> Неопределено И ПараметрыОжидания.ВыводитьОкноОжидания), 
			СообщениеПроверки, "ДлительныеОперацииКлиент.ОжидатьЗавершение");
			
	КонецЕсли;

КонецПроцедуры

Процедура ПоказатьОповещение(ОповещениеПользователя, ВладелецФормы = Неопределено) Экспорт
	
	Оповещение = ОповещениеПользователя;
	Если Не Оповещение.Показать Тогда
		Возврат;
	КонецЕсли;
	
	НавигационнаяСсылкаОповещения = Оповещение.НавигационнаяСсылка;
	ПояснениеОповещения = Оповещение.Пояснение;
	
	Если ВладелецФормы <> Неопределено И ВладелецФормы.Окно <> Неопределено Тогда
		Если НавигационнаяСсылкаОповещения = Неопределено Тогда
			НавигационнаяСсылкаОповещения = ВладелецФормы.Окно.ПолучитьНавигационнуюСсылку();
		КонецЕсли;
		Если ПояснениеОповещения = Неопределено Тогда
			ПояснениеОповещения = ВладелецФормы.Окно.Заголовок;
		КонецЕсли;
	КонецЕсли;
	
	СтатусОповещения = Неопределено;
	Если ТипЗнч(Оповещение.Важное) = Тип("Булево") Тогда
		СтатусОповещения = ?(Оповещение.Важное, СтатусОповещенияПользователя.Важное, СтатусОповещенияПользователя.Информация);
	КонецЕсли;
	
	ПоказатьОповещениеПользователя(?(Оповещение.Текст <> Неопределено, Оповещение.Текст, НСтр("ru = 'Действие выполнено'")), 
		НавигационнаяСсылкаОповещения, ПояснениеОповещения, Оповещение.Картинка, СтатусОповещения);

КонецПроцедуры

#КонецОбласти