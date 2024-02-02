﻿
////////////////////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС
#Область ПрограммныйИнтерфейс

// Выполнить HTTP запрос
//
// Параметры:
//  ТранспортныйМодуль - Структура - параметры подключения к серверу
//    * Адрес   - Строка - адрес сервера без указания протокола
//    * Порт    - Число  - порт сервера
//    * Таймаут - Число  - таймаут ожидания ответа сервера
//    * ЗащищенноеСоединение - Булево, ЗащищенноеСоединениеOpenSSL - если Истина, то будет создан новый объект ЗащищенноеСоединениеOpenSSL.
//  ДанныеЗапроса - Структура - Параметры запроса на сервере
//    * ТипЗапроса - Строка - метод HTTP запроса
//    * АдресЗапроса - Строка - адрес на сервере
//    * Заголовки - Соответствие - заголовки HTTP запроса
//    * ТелоЗапроса - Строка, ДвоичныеДанные - тело HTTP запроса
//
// Возвращаемое значение:
//  Структура - результат выполнения запроса
//
Функция ВыполнитьHTTPЗапрос(ТранспортныйМодуль, ДанныеЗапроса, Перенаправления = Неопределено) Экспорт
	
	#Если ВебКлиент Тогда
		Возврат ОбменССервисомМинздраваРФВызовСервера.ВыполнитьHTTPЗапрос(ТранспортныйМодуль, ДанныеЗапроса);
	#Иначе
		
		HTTPЗапрос = Новый HTTPЗапрос(ДанныеЗапроса.АдресЗапроса, ДанныеЗапроса.Заголовки);
		
		Если ТипЗнч(ДанныеЗапроса.ТелоЗапроса) = Тип("Строка") И Не ПустаяСтрока(ДанныеЗапроса.ТелоЗапроса) Тогда
			HTTPЗапрос.УстановитьТелоИзСтроки(ДанныеЗапроса.ТелоЗапроса);
		ИначеЕсли ТипЗнч(ДанныеЗапроса.ТелоЗапроса) = Тип("ДвоичныеДанные") И ДанныеЗапроса.ТелоЗапроса.Размер() > 0 Тогда
			HTTPЗапрос.УстановитьТелоИзДвоичныхДанных(ДанныеЗапроса.ТелоЗапроса);
		КонецЕсли;
		
		Адрес = СокрЛП(ТранспортныйМодуль.Адрес);
		Порт  = ТранспортныйМодуль.Порт;
		Логин = ОбщегоНазначенияКлиентСервер.СвойствоСтруктуры(ТранспортныйМодуль, "Логин", "");
		Пароль = ОбщегоНазначенияКлиентСервер.СвойствоСтруктуры(ТранспортныйМодуль, "Пароль", "");
		
		ЗащищенноеСоединение = ОбщегоНазначенияКлиентСервер.СвойствоСтруктуры(ТранспортныйМодуль, "ЗащищенноеСоединение", Ложь);
		Если ЗащищенноеСоединение = Истина Тогда
			ЗащищенноеСоединение = ОбщегоНазначенияКлиентСервер.НовоеЗащищенноеСоединение();
		ИначеЕсли ЗащищенноеСоединение = Ложь Тогда
			ЗащищенноеСоединение = Неопределено;
			// Иначе параметр ЗащищенноеСоединение был задан в явном виде.
		КонецЕсли;
		
		Если ЗащищенноеСоединение = Неопределено Тогда
			Протокол = "HTTP";
		Иначе
			Протокол = "HTTPS";
		КонецЕсли;
		
		ИнтернетПрокси = ПолучениеФайловИзИнтернетаКлиентСервер.ПолучитьПрокси(Протокол);
		
		Попытка
			Соединение = Новый HTTPСоединение(Адрес, Порт, Логин, Пароль, ИнтернетПрокси, ТранспортныйМодуль.Таймаут, ЗащищенноеСоединение);
			HTTPОтвет = Соединение.ВызватьHTTPМетод(ДанныеЗапроса.ТипЗапроса, HTTPЗапрос);
		Исключение
			URL = СтрШаблон("%1://%2:%3%4", Протокол, Адрес, Формат(Порт, "ЧГ="), ДанныеЗапроса.АдресЗапроса);
			РезультатДиагностики = ОбщегоНазначенияКлиентСервер.ДиагностикаСоединения(URL);
			
			ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Не удалось установить HTTP-соединение с сервером %1:%2
				           |по причине:
				           |%3
				           |
				           |Результат диагностики:
				           |%4'"),
				Адрес,
				Формат(Порт, "ЧГ="),
				ОбработкаОшибок.КраткоеПредставлениеОшибки(ИнформацияОбОшибке()),
				РезультатДиагностики.ОписаниеОшибки);
			
			ДописатьПредставлениеПеренаправлений(Перенаправления, ТекстОшибки);
			
			Результат = РезультатВыполненияОперации();
			Результат.Статус = "Ошибка";
			Результат.ОписаниеОшибки = ТекстОшибки;
			
			ОбменССервисомМинздраваРФВызовСервера.ЗаписатьОшибкуВЖурналРегистрации(ТекстОшибки, СобытиеЖурналаРегистрации());
			
			Возврат Результат;
		КонецПопытки;
		
		Если HTTPОтвет.КодСостояния = 301 // 301 Moved Permanently
		 Или HTTPОтвет.КодСостояния = 302 // 302 Found, 302 Moved Temporarily
		 Или HTTPОтвет.КодСостояния = 303 // 303 See Other by GET
		 Или HTTPОтвет.КодСостояния = 307 // 307 Temporary Redirect
		 Или HTTPОтвет.КодСостояния = 308 Тогда // 308 Permanent Redirect
			
			Попытка
				
				Если Перенаправления = Неопределено Тогда
					Перенаправления = Новый Массив;
				КонецЕсли;
				
				Если Перенаправления.Количество() > 7 Тогда
					ВызватьИсключение
						НСтр("ru = 'Превышено количество перенаправлений.'");
				КонецЕсли;
				
				НовыйURL = ЗначениеПараметраОбъекта(HTTPОтвет.Заголовки, "Location");
				Если НовыйURL = Неопределено Тогда 
					ВызватьИсключение
						НСтр("ru = 'Некорректное перенаправление, отсутствует HTTP-заголовок ответа ""Location"".'");
				КонецЕсли;
				
				Если ПустаяСтрока(НовыйURL) Тогда
					ВызватьИсключение
						НСтр("ru = 'Некорректное перенаправление, пустой HTTP-заголовок ответа ""Location"".'");
				КонецЕсли;
				
				НовыйURL = СокрЛП(НовыйURL);
				Если Перенаправления.Найти(НовыйURL) <> Неопределено Тогда
					ВызватьИсключение СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
						НСтр("ru = 'Циклическое перенаправление.
						           |Попытка перейти на %1 уже выполнялась ранее.'"),
						НовыйURL);
				КонецЕсли;
				
				Перенаправления.Добавить(НовыйURL);
				
				Если Не СтрНачинаетсяС(НовыйURL, "http") Тогда
					// Локальное перенаправление
					ПутьНаСервере = НовыйURL;
					НовыеПараметрыПодключения = ТранспортныйМодуль;
				Иначе
					СтруктураURI = ОбщегоНазначенияКлиентСервер.СтруктураURI(НовыйURL);
					НовыеПараметрыПодключения = ОбщегоНазначенияКлиентСервер.СкопироватьСтруктуру(ТранспортныйМодуль);
					НовыеПараметрыПодключения.Адрес = СтруктураURI.Хост;
					НовыеПараметрыПодключения.Порт = СтруктураURI.Порт;
					Если СтруктураURI.Схема = "https" Тогда
						ЗащищенноеСоединение = ОбщегоНазначенияКлиентСервер.СвойствоСтруктуры(НовыеПараметрыПодключения, "ЗащищенноеСоединение", Ложь);
						Если ЗащищенноеСоединение = Ложь Тогда
							НовыеПараметрыПодключения.Вставить("ЗащищенноеСоединение", Истина);
						КонецЕсли;
					Иначе
						НовыеПараметрыПодключения.Вставить("ЗащищенноеСоединение", Ложь);
					КонецЕсли;
					ПутьНаСервере = "/" + СтруктураURI.ПутьНаСервере;
				КонецЕсли;
				
				НовыеДанныеЗапроса = ОбщегоНазначенияКлиентСервер.СкопироватьСтруктуру(ДанныеЗапроса);
				НовыеДанныеЗапроса.АдресЗапроса = ПутьНаСервере;
				
			Исключение
				
				ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru = 'Не удалось установить HTTP-соединение с сервером %1:%2
					           |по причине:
					           |%3'"),
					Адрес,
					Формат(Порт, "ЧГ="),
					ОбработкаОшибок.КраткоеПредставлениеОшибки(ИнформацияОбОшибке()));
				
				ДописатьПредставлениеПеренаправлений(Перенаправления, ТекстОшибки);
				
				Результат = РезультатВыполненияОперации();
				Результат.Статус = "Ошибка";
				Результат.ОписаниеОшибки = ТекстОшибки;
				
				ОбменССервисомМинздраваРФВызовСервера.ЗаписатьОшибкуВЖурналРегистрации(ТекстОшибки, СобытиеЖурналаРегистрации());
				
				Возврат Результат;
				
			КонецПопытки;
			
			Возврат ВыполнитьHTTPЗапрос(НовыеПараметрыПодключения, НовыеДанныеЗапроса, Перенаправления)
			
		КонецЕсли;
		
		Результат = ПрочитатьОтветТранспортногоМодуля(HTTPОтвет.КодСостояния, HTTPОтвет.ПолучитьТелоКакСтроку(КодировкаТекста.UTF8), Перенаправления);
		
		ЛогироватьЗапрос(Соединение, ДанныеЗапроса.ТипЗапроса, HTTPЗапрос, HTTPОтвет);
		
		Если Результат.Статус = "Ошибка" И Не Результат.ТребуетсяАвторизация Тогда
			ТекстОшибки = НСтр("ru = 'Ошибка при выполнении %1-запроса по адресу %2'");
			ТекстОшибки = СтрЗаменить(ТекстОшибки, "%1", ДанныеЗапроса.ТипЗапроса);
			ТекстОшибки = СтрЗаменить(ТекстОшибки, "%2", ДанныеЗапроса.АдресЗапроса);
			ТекстОшибки = ТекстОшибки + Символы.ПС + Результат.ОписаниеОшибки;
			Результат.ОписаниеОшибки = ТекстОшибки;
			ОбменССервисомМинздраваРФВызовСервера.ЗаписатьОшибкуВЖурналРегистрации(ТекстОшибки, СобытиеЖурналаРегистрации());
		КонецЕсли;
		
		Возврат Результат;
	#КонецЕсли
	
КонецФункции

Функция ДанныеHTTPЗапроса(ТипЗапроса) Экспорт
	
	Результат = Новый Структура;
	Результат.Вставить("ТипЗапроса"  , ВРег(ТипЗапроса));
	Результат.Вставить("АдресЗапроса", "");
	Результат.Вставить("ТелоЗапроса" , "");
	Результат.Вставить("Заголовки"   , Новый Соответствие);
	
	Если Результат.ТипЗапроса = "POST" Или Результат.ТипЗапроса = "PUT" Тогда
		Результат.Заголовки.Вставить("Content-Type", "application/json");
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

Функция ПолучитьПараметрыСервера(АдресСервера) Экспорт
	
	СтруктураАдреса = ОбщегоНазначенияКлиентСервер.СтруктураURI(АдресСервера);
	
	ПараметрыСервера = Новый Структура;
	ПараметрыСервера.Вставить("Адрес", СтруктураАдреса.Хост);
	ПараметрыСервера.Вставить("Порт", СтруктураАдреса.Порт);
	ПараметрыСервера.Вставить("Логин", СтруктураАдреса.Логин);
	ПараметрыСервера.Вставить("Пароль", СтруктураАдреса.Пароль);
	ПараметрыСервера.Вставить("Таймаут");
	ЗащищенноеСоединение = Не ЗначениеЗаполнено(СтруктураАдреса.Схема) Или СтруктураАдреса.Схема = "https";
	ПараметрыСервера.Вставить("ЗащищенноеСоединение", ЗащищенноеСоединение);
	
	Возврат ПараметрыСервера;
	
КонецФункции

Функция ЗначениеПараметраОбъекта(Объект, ИмяПараметра) Экспорт
	
	Для Каждого КлючЗначение Из Объект Цикл
		Если СтрСравнить(СокрЛП(КлючЗначение.Ключ), ИмяПараметра) = 0 Тогда
			Возврат КлючЗначение.Значение;
		КонецЕсли;
	КонецЦикла;
	
	Возврат Неопределено;
	
КонецФункции

Функция РезультатВыполненияОперации(РезультатОснование = Неопределено) Экспорт
	
	Результат = Новый Структура();
	Результат.Вставить("Статус"              , "Успешно");
	Результат.Вставить("КодОшибки");
	Результат.Вставить("ОписаниеОшибки"      , "");
	Результат.Вставить("ТребуетсяАвторизация", Ложь);
	Результат.Вставить("НедостаточноПрав"    , Ложь);
	
	Если РезультатОснование <> Неопределено Тогда
		ЗаполнитьЗначенияСвойств(Результат, РезультатОснование);
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти // ПрограммныйИнтерфейс

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ
#Область СлужебныеПроцедурыИФункции

Функция ПрочитатьОтветТранспортногоМодуля(КодСостояния, ОтветТранспортногоМодуля, Перенаправления)
	
	Результат = РезультатВыполненияОперации();
	Результат.Вставить("ОтветТранспортногоМодуля", ОтветТранспортногоМодуля);
	
	Если КодСостояния >= 200 И КодСостояния < 300 Тогда
		
		Результат.Статус = "Успешно";
		
	Иначе
		
		Результат.Статус = "Ошибка";
		Результат.КодОшибки = КодСостояния;
		Если ЗначениеЗаполнено(КодСостояния) Тогда
			Результат.ОписаниеОшибки = РасшифровкаКодаСостоянияHTTP(КодСостояния);
			Результат.ТребуетсяАвторизация = (КодСостояния = 401);
			Результат.НедостаточноПрав     = (КодСостояния = 403);
		Иначе
			Результат.ОписаниеОшибки = НСтр("ru = 'Запрос не отправлен.'");
		КонецЕсли;
		
		Если ЗначениеЗаполнено(ОтветТранспортногоМодуля) Тогда
			Результат.ОписаниеОшибки = Результат.ОписаниеОшибки + Символы.ПС + ОтветТранспортногоМодуля;
		КонецЕсли;
		
		ДописатьПредставлениеПеренаправлений(Перенаправления, Результат.ОписаниеОшибки);
		
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

Процедура ДописатьПредставлениеПеренаправлений(Перенаправления, ТекстОшибки)
	
	Если Перенаправления <> Неопределено И Перенаправления.Количество() > 0 Тогда 
		ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = '%1
			           |
			           |Выполненные перенаправления (%2):
			           |%3'"),
			ТекстОшибки,
			Перенаправления.Количество(),
			СтрСоединить(Перенаправления, Символы.ПС));
	КонецЕсли;
	
КонецПроцедуры

Функция РасшифровкаКодаСостоянияHTTP(КодСостояния)
	
	Если КодСостояния = 304 Тогда // Not Modified
		Расшифровка = НСтр("ru = 'Нет необходимости повторно передавать запрошенные ресурсы.'");
	ИначеЕсли КодСостояния = 400 Тогда // Bad Request
		Расшифровка = НСтр("ru = 'Запрос не может быть исполнен.'");
	ИначеЕсли КодСостояния = 401 Тогда // Unauthorized
		Расшифровка = НСтр("ru = 'Требуется авторизация на сервере.'");
	ИначеЕсли КодСостояния = 402 Тогда // Payment Required
		Расшифровка = НСтр("ru = 'Требуется оплата.'");
	ИначеЕсли КодСостояния = 403 Тогда // Forbidden
		Расшифровка = НСтр("ru = 'Недостаточно прав для выполнения операции.'");
	ИначеЕсли КодСостояния = 404 Тогда // Not Found
		Расшифровка = НСтр("ru = 'Запрашиваемый ресурс не найден на сервере.'");
	ИначеЕсли КодСостояния = 405 Тогда // Method Not Allowed
		Расшифровка = НСтр("ru = 'Метод запроса не поддерживается сервером.'");
	ИначеЕсли КодСостояния = 406 Тогда // Not Acceptable
		Расшифровка = НСтр("ru = 'Запрошенный формат данных не поддерживается сервером.'");
	ИначеЕсли КодСостояния = 407 Тогда // Proxy Authentication Required
		Расшифровка = НСтр("ru = 'Ошибка аутентификации на прокси-сервере'");
	ИначеЕсли КодСостояния = 408 Тогда // Request Timeout
		Расшифровка = НСтр("ru = 'Время ожидания сервером передачи от клиента истекло.'");
	ИначеЕсли КодСостояния = 409 Тогда // Conflict
		Расшифровка = НСтр("ru = 'Запрос не может быть выполнен из-за конфликтного обращения к ресурсу.'");
	ИначеЕсли КодСостояния = 410 Тогда // Gone
		Расшифровка = НСтр("ru = 'Ресурс на сервере был перемешен.'");
	ИначеЕсли КодСостояния = 411 Тогда // Length Required
		Расшифровка = НСтр("ru = 'Сервер требует указание ""Content-length."" в заголовке запроса.'");
	ИначеЕсли КодСостояния = 412 Тогда // Precondition Failed
		Расшифровка = НСтр("ru = 'Запрос не применим к ресурсу'");
	ИначеЕсли КодСостояния = 413 Тогда // Request Entity Too Large
		Расшифровка = НСтр("ru = 'Сервер отказывается обработать, слишком большой объем передаваемых данных.'");
	ИначеЕсли КодСостояния = 414 Тогда // Request-URL Too Long
		Расшифровка = НСтр("ru = 'Сервер отказывается обработать, слишком длинный URL.'");
	ИначеЕсли КодСостояния = 415 Тогда // Unsupported Media-Type
		Расшифровка = НСтр("ru = 'Сервер заметил, что часть запроса была сделана в неподдерживаемом формате'");
	ИначеЕсли КодСостояния = 416 Тогда // Requested Range Not Satisfiable
		Расшифровка = НСтр("ru = 'Часть запрашиваемого ресурса не может быть предоставлена'");
	ИначеЕсли КодСостояния = 417 Тогда // Expectation Failed
		Расшифровка = НСтр("ru = 'Сервер не может предоставить ответ на указанный запрос.'");
	ИначеЕсли КодСостояния = 429 Тогда // Too Many Requests
		Расшифровка = НСтр("ru = 'Слишком много запросов за короткое время.'");
	ИначеЕсли КодСостояния = 500 Тогда // Internal Server Error
		Расшифровка = НСтр("ru = 'Внутренняя ошибка сервера.'");
	ИначеЕсли КодСостояния = 501 Тогда // Not Implemented
		Расшифровка = НСтр("ru = 'Сервер не поддерживает метод запроса.'");
	ИначеЕсли КодСостояния = 502 Тогда // Bad Gateway
		Расшифровка = НСтр("ru = 'Сервер, выступая в роли шлюза или прокси-сервера, 
		                         |получил недействительное ответное сообщение от вышестоящего сервера.'");
	ИначеЕсли КодСостояния = 503 Тогда // Server Unavailable
		Расшифровка = НСтр("ru = 'Сервер временно не доступен.'");
	ИначеЕсли КодСостояния = 504 Тогда // Gateway Timeout
		Расшифровка = НСтр("ru = 'Сервер в роли шлюза или прокси-сервера 
		                         |не дождался ответа от вышестоящего сервера для завершения текущего запроса.'");
	ИначеЕсли КодСостояния = 505 Тогда // HTTP Version Not Supported
		Расшифровка = НСтр("ru = 'Сервер не поддерживает указанную в запросе версию протокола HTTP'");
	ИначеЕсли КодСостояния = 506 Тогда // Variant Also Negotiates
		Расшифровка = НСтр("ru = 'Сервер настроен некорректно, и не способен обработать запрос.'");
	ИначеЕсли КодСостояния = 507 Тогда // Insufficient Storage
		Расшифровка = НСтр("ru = 'На сервере недостаточно места для выполнения запроса.'");
	ИначеЕсли КодСостояния = 509 Тогда // Bandwidth Limit Exceeded
		Расшифровка = НСтр("ru = 'Сервер превысил отведенное ограничение на потребление трафика.'");
	ИначеЕсли КодСостояния = 510 Тогда // Not Extended
		Расшифровка = НСтр("ru = 'Сервер требует больше информации о совершаемом запросе.'");
	ИначеЕсли КодСостояния = 511 Тогда // Network Authentication Required
		Расшифровка = НСтр("ru = 'Требуется авторизация на сервере.'");
	Иначе 
		Расшифровка = НСтр("ru = '<Неизвестный код состояния>.'");
	КонецЕсли;
	
	Возврат СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru = '[%1] %2'"), 
		КодСостояния, 
		Расшифровка);
	
КонецФункции

Функция СобытиеЖурналаРегистрации()
	
	Возврат НСтр("ru = 'Транспорт обмена с сервисом Минздрава РФ'", ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка());
	
КонецФункции

#Если Не ВебКлиент Тогда

Функция ПреобразоватьЗначениеВJSON(Значение, НастройкиСериализации = Неопределено) Экспорт
	
	Запись = Новый ЗаписьJSON;
	Запись.УстановитьСтроку();
	ЗаписатьJSON(Запись, Значение, НастройкиСериализации);
	Возврат Запись.Закрыть();
	
КонецФункции

Функция ПреобразоватьJSONВЗначение(Строка, ПрочитатьВСоответствие = Истина, ИменаСвойствСоЗначениямиДата = Неопределено) Экспорт
	
	Если Не ЗначениеЗаполнено(Строка) Тогда
		Возврат Строка;
	КонецЕсли;
	
	Чтение = Новый ЧтениеJSON;
	Чтение.УстановитьСтроку(Строка);
	Значение = ПрочитатьJSON(Чтение, ПрочитатьВСоответствие, ИменаСвойствСоЗначениямиДата);
	
	Возврат Значение;
	
КонецФункции

Процедура ЛогироватьЗапрос(Соединение, Метод, Запрос, Ответ)
	
	ЛогЗапроса = "";
	
	ЛогЗапроса = ЛогЗапроса + СтрШаблон("%1 %2", Метод, Запрос.АдресРесурса) + Символы.ПС;
	Порт = ?(ЗначениеЗаполнено(Соединение.Порт), Соединение.Порт, ?(Соединение.ЗащищенноеСоединение = Неопределено, 80, 443));
	ЛогЗапроса = ЛогЗапроса + СтрШаблон("Host: %1:%2", Соединение.Сервер, Формат(Порт, "ЧГ=")) + Символы.ПС;
	Для Каждого КлючЗначение Из Запрос.Заголовки Цикл
		ЛогЗапроса = ЛогЗапроса + СтрШаблон("%1: %2", КлючЗначение.Ключ, КлючЗначение.Значение) + Символы.ПС;
	КонецЦикла;
	ТелоЗапроса = Запрос.ПолучитьТелоКакСтроку();
	Если ЗначениеЗаполнено(ТелоЗапроса) Тогда
		ЛогЗапроса = ЛогЗапроса + Символы.ПС + ТелоЗапроса + Символы.ПС;
	КонецЕсли;
	
	ЛогЗапроса = ЛогЗапроса + Символы.ПС;
	
	ЛогЗапроса = ЛогЗапроса + СтрШаблон("%1", Ответ.КодСостояния) + Символы.ПС;
	Для Каждого КлючЗначение Из Ответ.Заголовки Цикл
		ЛогЗапроса = ЛогЗапроса + СтрШаблон("%1: %2", КлючЗначение.Ключ, КлючЗначение.Значение) + Символы.ПС;
	КонецЦикла;
	
	ТелоОтвета = Ответ.ПолучитьТелоКакСтроку();
	Если ЗначениеЗаполнено(ТелоОтвета) Тогда
		ЛогЗапроса = ЛогЗапроса + Символы.ПС + ТелоОтвета + Символы.ПС;
	КонецЕсли;
	
	ЛогЗапроса = СокрЛП(ЛогЗапроса);
	
	ОбменССервисомМинздраваРФВызовСервера.ЗаписатьСобытиеВЖурналРегистрации(ЛогЗапроса, СобытиеЖурналаРегистрации());
	
КонецПроцедуры

#КонецЕсли

#КонецОбласти // СлужебныеПроцедурыИФункции