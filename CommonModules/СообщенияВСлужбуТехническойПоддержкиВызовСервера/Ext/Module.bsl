﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2022, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// Подсистема "Сообщения в службу технической поддержки".
// ОбщийМодуль.СообщенияВСлужбуТехническойПоддержкиВызовСервера.
//
// Серверные процедуры и функции отправки сообщений в 
// службу технической поддержки:
//  - отправка сообщений на Портал 1С:ИТС;
//
////////////////////////////////////////////////////////////////////////////////

#Область СлужебныеПроцедурыИФункции

// Формирует сообщение для отправки сообщения в службу технической
// поддержки. В параметрах передаются данные заполнения, вложения
// и параметры выгрузки журнала регистрации.
//
// Параметры:
//  ДанныеСообщения - Структура - данные для формирования сообщения:
//   *Тема - Строка - тема сообщения;
//   *Сообщение  - Строка - тело текст сообщения для отправки;
//   *ИспользоватьСтандартныйШаблон - Булево - признак использования стандартного шаблона сообщения в техподдержку;
//   *Получатель - Строка - условное имя получателя сообщения. Возможные значения:
//        - "v8" - соответствует адресу "v8@1c.ru";
//        - "webIts" - соответствует адресам "webits-info@1c.ru" и "webits-info@1c.ua",
//          необходимый адрес выбирается в соответствии с настройками доменной зоны
//          серверов Интернет-поддержки;
//        - "taxcom" - соответствует адресу "taxcom@1c.ru";
//        - "backup" - соответствует адресу "support.backup@1c.ru";
//  Вложения - Массив Из Структура, Неопределено - файлы вложений.  Важно: допускаются только
//              текстовые вложения (*.txt). Поля структуры элемента вложения:
//   *Представление - Строка - представление вложения. Например, "Вложение 1.txt";
//   *ВидДанных - Строка - определяет преобразование переданных данных.
//                Возможна передача одного из значений:
//                  - ИмяФайла - Строка - полное имя файла вложения;
//                  - Адрес - Строка - адрес во временном хранилище значения типа ДвоичныеДанные;
//                  - Текст - Строка - текст вложения;
//   *Данные - Строка - данные для формирования вложения;
//  ЖурналРегистрации - Структура, Неопределено - настройки выгрузки журнала регистрации:
//    *ДатаНачала    - Дата - начало периода журнала;
//    *ДатаОкончания - Дата - конец периода журнала;
//    *События       - Массив - список событий;
//    *Метаданные    - Массив, Неопределено - массив метаданных для отбора;
//    *Уровень       - Строка - уровень важности событий журнала регистрации. Возможные значения:
//       - "Ошибка" - будет выполнен отбор по событиям с УровеньЖурналаРегистрации.Ошибка;
//       - "Предупреждение" - будет выполнен отбор по событиям с УровеньЖурналаРегистрации.Предупреждение;
//       - "Информация" - будет выполнен отбор по событиям с УровеньЖурналаРегистрации.Информация;
//       - "Примечание" - будет выполнен отбор по событиям с УровеньЖурналаРегистрации.Примечание.
//
// Возвращаемое значение:
//  Структура - результат отправки сообщения:
//   *КодОшибки - Строка - идентификатор ошибки при отправки:
//                          - <Пустая строка> - отправка выполнена успешно;
//                          - "НеверныйФорматЗапроса" - переданы некорректные параметры сообщения
//                             сообщения в техническую поддержку;
//                          - "ПревышенМаксимальныйРазмер" - превышен максимальный размер вложения;
//                          - "НеизвестнаяОшибка" - при отправке сообщения возникли ошибки;
//   *СообщениеОбОшибке - Строка, ФорматированнаяСтрока - сообщение об ошибке для пользователя;
//   *URLСтраницы - Строка - URL страницы отправки сообщения.
//
Функция ПодготовитьСообщение(
		ДанныеСообщения,
		Вложения = Неопределено,
		ЖурналРегистрации = Неопределено) Экспорт
	
	Возврат СообщенияВСлужбуТехническойПоддержки.ПодготовитьСообщение(
		ДанныеСообщения,
		Вложения,
		ЖурналРегистрации);
	
КонецФункции

#КонецОбласти
