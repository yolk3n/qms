﻿#Если Сервер Тогда

#Область ПрограммныйИнтерфейс

// Функция - Отправить XML
//
// Параметры:
//  ИмяСервиса - Строка	 - Имя веб-сервиса
//  XML				 - Строка	 - XML для отправки
// 
// Возвращаемое значение:
//  Строка - 
//
Функция ОтправитьXML(ИмяСервиса, XML) Экспорт
	Запрос_ = СформироватьЗапрос(ИмяСервиса);
	
	Запрос_.HTTPМетод = "POST";
	Запрос_.ТелоКакСтрока = XML;
	
	HTTPОтвет_ = ФедеральныеВебСервисы.ОбработатьЗапросHTTPСервиса(Запрос_);
	Ответ_ = ПолучитьОтвет(HTTPОтвет_);
	ПроверитьОтвет(Ответ_);
	
	Возврат Ответ_.Тело;
КонецФункции

// Возвращает информацию о пациенте
//
// Параметры:
//  Пациент	 - СправочникСсылка.Картотека	 - Пациент
// 
// Возвращаемое значение:
//  Структура - Заполненная структура, возвращаемая функцией ДанныеПациента()
//
Функция ИнформацияОПациенте(Пациент) Экспорт
	Результат_ = ДанныеПациента();
	
	Если Истина = ЭтоМИС() Тогда
		МодульРегистратура_ = Вычислить("Регистратура");
		ДанныеПациента_ = МодульРегистратура_.ПолучитьДанныеПациента(Пациент);
		Если ДанныеПациента_ = Неопределено Тогда 
			ВызватьИсключение("Не удалось получить информацию по пациенту из ИБ МИС");
		КонецЕсли;
		
	
		Для Каждого Полис_ Из ДанныеПациента_.Полисы Цикл
			Если Истина = Полис_.ЭтоОМС
				И ЗначениеЗаполнено(Полис_.НомерПолиса)
			Тогда
				Результат_.НомерПолиса = Полис_.НомерПолиса;
				Прервать;
			КонецЕсли;
		КонецЦикла;

		Результат_.Фамилия      = ДанныеПациента_.ФИО.Фамилия;
		Результат_.Имя          = ДанныеПациента_.ФИО.Имя;
		Результат_.Отчество     = ДанныеПациента_.ФИО.Отчество;
		Результат_.ДатаРождения = ДанныеПациента_.ФИО.ДатаРождения;
		Результат_.Пол          = ДанныеПациента_.ФИО.Пол;
		Результат_.СНИЛС        = ДанныеПациента_.ФИО.СтраховойНомерПФР;
	Иначе
		Запрос_ = Новый Запрос(
			"ВЫБРАТЬ
			|	Картотека.Фамилия КАК Фамилия,
			|	Картотека.Имя КАК Имя,
			|	Картотека.Отчество КАК Отчество,
			|	Картотека.ДатаРождения КАК ДатаРождения,
			|	Картотека.Пол КАК Пол,
			|	Картотека.СтраховойНомерПФР КАК СтраховойНомерПФР,
			|	Картотека.ПолисОМС КАК ПолисОМС
			|ИЗ
			|	Справочник.Картотека КАК Картотека
			|ГДЕ
			|	Картотека.Ссылка = &Пациент"
		);
		Запрос_.УстановитьПараметр("Пациент", Пациент);
		Выборка_ = Запрос_.Выполнить().Выбрать();
		Если НЕ Выборка_.Следующий() Тогда 
			ВызватьИсключение("Не удалось получить информацию по пациенту из ИБ РМИС");
		КонецЕсли;
		
		Результат_.Фамилия      = Выборка_.Фамилия;
		Результат_.Имя          = Выборка_.Имя;
		Результат_.Отчество     = Выборка_.Отчество;
		Результат_.ДатаРождения = Выборка_.ДатаРождения;
		Результат_.Пол          = Выборка_.Пол;
		Результат_.СерияПолиса  = "";
		Результат_.НомерПолиса  = Выборка_.ПолисОМС;
		Результат_.СНИЛС        = Выборка_.СтраховойНомерПФР;
	КонецЕсли;

	Возврат Результат_;
КонецФункции

// Возвращает структуру для хранения данных пациента
// 
// Возвращаемое значение:
//  Структура - Структура для хранения данных пациента
//
Функция ДанныеПациента() Экспорт
	Возврат Новый Структура(
		"Фамилия, Имя, Отчество, ДатаРождения, Пол, СерияПолиса, НомерПолиса, СНИЛС",
		"", "", "", Неопределено, Неопределено, "", "", ""
	);
КонецФункции

// Возвращает массив структура с данными для автотеста из XML
//
// Параметры:
//  XML	 - Строка	 - XML с данными для автотеста
// 
// Возвращаемое значение:
//  Массив - Массив стурктур
//
Функция ПрочитатьДанныеXMLАвтотеста(XML) Экспорт
	Результат_ = Новый Массив();
	
	DOM_ = ФедеральныеВебСервисыСервер.ПостроитьDOM(XML);
	ПИ_ = Новый РазыменовательПространствИменDOM(DOM_);

	ШаблонXPath_ = "/*/Appointment[%1]/%2/text()";
	
	Для Номер_ = 1 По 10000 Цикл
		
		Фамилия_  = ФедеральныеВебСервисыСервер.ПолучитьСтрокуПоXPath(DOM_, ПИ_, СтрШаблон(ШаблонXPath_, Номер_, "Patient/Last_Name"));
		Имя_      = ФедеральныеВебСервисыСервер.ПолучитьСтрокуПоXPath(DOM_, ПИ_, СтрШаблон(ШаблонXPath_, Номер_, "Patient/First_Name"));
		Отчество_ = ФедеральныеВебСервисыСервер.ПолучитьСтрокуПоXPath(DOM_, ПИ_, СтрШаблон(ШаблонXPath_, Номер_, "Patient/Middle_Name"));
		ДР_       = ФедеральныеВебСервисыСервер.ПолучитьСтрокуПоXPath(DOM_, ПИ_, СтрШаблон(ШаблонXPath_, Номер_, "Patient/Birth_Date"));
		Пол_      = ФедеральныеВебСервисыСервер.ПолучитьСтрокуПоXPath(DOM_, ПИ_, СтрШаблон(ШаблонXPath_, Номер_, "Patient/Sex"));
		Полис_    = ФедеральныеВебСервисыСервер.ПолучитьСтрокуПоXPath(DOM_, ПИ_, СтрШаблон(ШаблонXPath_, Номер_, "Patient/OMS_Number"));
		СНИЛС_    = ФедеральныеВебСервисыСервер.ПолучитьСтрокуПоXPath(DOM_, ПИ_, СтрШаблон(ШаблонXPath_, Номер_, "Patient/SNILS"));

		OIDПодразделения_ = ФедеральныеВебСервисыСервер.ПолучитьСтрокуПоXPath(DOM_, ПИ_, СтрШаблон(ШаблонXPath_, Номер_, "OIDSubMO"));

		Если НЕ ЗначениеЗаполнено(Фамилия_) Тогда
			Прервать;
		КонецЕсли;
		
		ДанныеПациента_ = ДанныеПациента();
		ДанныеПациента_.Фамилия       = Фамилия_;
		ДанныеПациента_.Имя           = Имя_;
		ДанныеПациента_.Отчество      = Отчество_;
		ДанныеПациента_.ДатаРождения  = Дата(СтрЗаменить(ДР_, "-", ""));
		ДанныеПациента_.Пол           = ?(Пол_ = "M", Перечисления.ПолПациентов.Мужской, Перечисления.ПолПациентов.Женский);
		ДанныеПациента_.СерияПолиса   = "";
		ДанныеПациента_.НомерПолиса   = Полис_;
		ДанныеПациента_.СНИЛС         = СНИЛС_;
		
		Результат_.Добавить(
			Новый Структура("Пациент, OIDПодразделения", ДанныеПациента_, OIDПодразделения_)
		);
		
	КонецЦикла;

	Возврат Результат_;
КонецФункции

// Проверка в какой конфигурации находимся МИС
// 
// Возвращаемое значение:
//  Булево - Истина, если в МИС
//
Функция ЭтоМИС() Экспорт
	Если Метаданные.ОбщиеМодули.Найти("Регистратура") = Неопределено Тогда
		Возврат Ложь;
	Иначе 
		Возврат Истина;
	КонецЕсли;
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция СформироватьЗапрос(ИмяСервиса)
	Результат_ = Новый Структура("ПараметрыЗапроса, БазовыйURL, ОтносительныйURL, Заголовки, HTTPМетод, ПараметрыURL, ТелоКакСтрока");
	
	ПараметрыЗапроса_ = Новый Соответствие();
	ПараметрыЗапроса_.Вставить("wsdl", "");
		
	Заголовки_ = Новый Соответствие();
	// Заголовки_.Вставить("Content-Type", "text/xml;charset=UTF-8");
	Заголовки_.Вставить("Content-Type", "text/xml");
	// Заголовки_.Вставить("SOAPAction", "sendDocument");
	Заголовки_ = Новый ФиксированноеСоответствие(Заголовки_);
		
	СтрокаСоединения_ = СтрокаСоединенияИнформационнойБазы();
	СтрокаСоединения_ = СтрЗаменить(СтрокаСоединения_, """", "");
	СтрокаСоединения_ = СтрЗаменить(СтрокаСоединения_, ";", "");
	Поз_ = СтрНайти(СтрокаСоединения_, "/", НаправлениеПоиска.СКонца);
	Если Не Поз_ = 0 Тогда
		СтрокаСоединения_ = Сред(СтрокаСоединения_, Поз_ + 1);
	КонецЕсли;
	Поз_ = СтрНайти(СтрокаСоединения_, "\", НаправлениеПоиска.СКонца);
	Если Не Поз_ = 0 Тогда
		СтрокаСоединения_ = Сред(СтрокаСоединения_, Поз_ + 1);
	КонецЕсли;
		
	БазовыйURL_ = "http://localhost/" + СтрокаСоединения_ + "/hs/fws";
	ОтносительныйURL_ = "/" + ИмяСервиса;
		
	Результат_.ПараметрыЗапроса = ПараметрыЗапроса_;
	Результат_.БазовыйURL = БазовыйURL_;
	Результат_.ОтносительныйURL = ОтносительныйURL_;
	Результат_.Заголовки = Заголовки_;
	Результат_.HTTPМетод = "POST";
	Результат_.ПараметрыURL = Новый Соответствие();
	Результат_.ТелоКакСтрока = "";
	
	Возврат Результат_;
КонецФункции

Функция ПолучитьОтвет(HTTPОтвет)
	Результат_ = Новый Структура(
		"КодСостояния, Тело, Заголовок", 
		HTTPОтвет.КодСостояния,
		"", 
		""
	);
	
	Если HTTPОтвет.КодСостояния = 200 Тогда
		
		ТелоКакСтрока_ = HTTPОтвет.ПолучитьТелоКакСтроку();
		
		ДокументDOM_ = ФедеральныеВебСервисыСервер.ПостроитьDOM(ТелоКакСтрока_);
		
		// Для начала с помощью XPath определим версию SOAP. Для этого нам потребуется какой-нибудь
		soap_ = ФедеральныеВебСервисыСервер.ПолучитьСтрокуПоXPath(ДокументDOM_, , "namespace-uri(/*)");
		
		__ПРОВЕРКА__(soap_ = xmlns.soap() Или soap_ = xmlns.soap("1.2"), СтрШаблон("c6065752-49fb-11e8-913f-080027536468 Неожиданное пространство имен SOAP: %1.", soap_));
		
		// Выполим запрос XPath.
		РезультатXPath_ = ДокументDOM_.ВычислитьВыражениеXPath(
			"/soap:Envelope/soap:Body/*",
			ДокументDOM_,
			Новый РазыменовательПространствИменDOM("soap", soap_),
			ТипРезультатаDOMXPath.ПервыйУпорядоченныйУзел
		);
		// Из результата берем первый найденный узел.
		ПараметрыSOAP_ = РезультатXPath_.ОдиночныйУзелЗначение;
		
		// Получим параметры SOAP в строковом виде.
		Результат_.Тело = ФедеральныеВебСервисыСервер.ЗаписатьDOM(ПараметрыSOAP_);
		
		// Выполим запрос XPath.
		РезультатXPath_ = ДокументDOM_.ВычислитьВыражениеXPath(
			"/soap:Envelope/soap:Header",
			ДокументDOM_,
			Новый РазыменовательПространствИменDOM("soap", soap_),
			ТипРезультатаDOMXPath.ПервыйУпорядоченныйУзел
		);
		// Из результата берем первый найденный узел.
		Заголовок_ = РезультатXPath_.ОдиночныйУзелЗначение;
		// Заголовок может оказаться незаполненным.
		Если Заголовок_ <> Неопределено Тогда
			Результат_.Заголовок = ФедеральныеВебСервисыСервер.ЗаписатьDOM(Заголовок_);
		КонецЕсли;
		
	Иначе
		Результат_.Тело = HTTPОтвет.ПолучитьТелоКакСтроку();
	КонецЕсли;

	Возврат Результат_;
КонецФункции

Процедура ПроверитьОтвет(Ответ)
	ТелоОтвета_ = Ответ.Тело;
	
	Если Ответ.КодСостояния <> 200 Тогда 
		ВызватьИсключениеПоИмениСообщения(
			"ФедеральныеВебСервисы_ПолученНеожиданныйОтвет", 
			Новый Структура("Ответ", ТелоОтвета_)
		);
	КонецЕсли;
	
	Версия_ = ВерсияXML(ТелоОтвета_);
	
	DOM_ = ФедеральныеВебСервисыСервер.ПостроитьDOM(ТелоОтвета_);
	ПИ_ = ФедеральныеВебСервисыПовтИсп.РазыменовательПИЗаписьНаПрием();

	Если Версия_ = 2 Тогда 
		ОбработатьОшибкуВерсии2(DOM_, ПИ_);
	Иначе
		ОбработатьОшибкуВерсии0(DOM_, ПИ_);
	КонецЕсли;
	
	
КонецПроцедуры

Процедура ОбработатьОшибкуВерсии2(DOM, ПИ)
	КодОшибки_ = ФедеральныеВебСервисыСервер.ПолучитьСтрокуПоXPath(DOM, ПИ, "/*/er2:Error/er2:Error_Code/text()");
	Сообщение_ = ФедеральныеВебСервисыСервер.ПолучитьСтрокуПоXPath(DOM, ПИ, "/*/er2:Error/er2:Error_Message/text()");
	
	Если ЗначениеЗаполнено(КодОшибки_) Тогда 
		ВызватьИсключениеПоИмениСообщения(
			"ФедеральныеВебСервисы_ПолученПакетСКодомИСообщением", 
			Новый Структура("КодОшибки, Сообщение", КодОшибки_, Сообщение_)
		);
	КонецЕсли;
КонецПроцедуры

Процедура ОбработатьОшибкуВерсии0(DOM, ПИ)
	КодОшибки_ = ФедеральныеВебСервисыСервер.ПолучитьСтрокуПоXPath(DOM, ПИ, "/*/Error/errorDetail/errorCode/text()");
	СтрокаОшибки_ = ФедеральныеВебСервисыСервер.ПолучитьСтрокуПоXPath(DOM, ПИ, "/*/Error/errorDetail/errorMessage/text()");
	
	Если Не (КодОшибки_ = "0" Или КодОшибки_ = "") Тогда
		Если НЕ ЗначениеЗаполнено(СтрокаОшибки_) Тогда 
			СтрокаОшибки_ = СтрокаОшибкиПоКоду(КодОшибки_);
		КонецЕсли;
		
		ВызватьИсключениеПоИмениСообщения(
			"ФедеральныеВебСервисы_ПолученПакетСКодомИСообщением", 
			Новый Структура("КодОшибки, Сообщение", КодОшибки_, СтрокаОшибки_)
		);
	КонецЕсли;
	
КонецПроцедуры

Функция ВызватьИсключениеПоИмениСообщения(ИмяСообщения, Параметры)
	Если Истина = ЭтоМИС() Тогда 
		МодульСообщенияПользователю_ = Вычислить("СообщенияПользователю");
		Сообщение_ = МодульСообщенияПользователю_.Получить(
			ИмяСообщения,
			Параметры
		);
		ВызватьИсключение(Сообщение_);
	КонецЕсли;
	
	// РМИС
	Сообщение_ = ИмяСообщения;
	Если ИмяСообщения = "ФедеральныеВебСервисы_ПолученПакетСКодомИСообщением" Тогда 
		Сообщение_ = "На запрос получен пакет с кодом #КодОшибки# и сообщением: #Сообщение#.  Изучите журнал регистрации.";
	ИначеЕсли ИмяСообщения = "ФедеральныеВебСервисы_ПолученНеожиданныйОтвет" Тогда 
		Сообщение_ = "На запрос получен неожиданный ответ: #Ответ#. Изучите журнал регистрации.";
	КонецЕсли;
	
	Если ТипЗнч(Параметры) = Тип("Структура") Тогда 
		Для Каждого КлючЗначение_ Из Параметры Цикл 
			Сообщение_ = СтрЗаменить(Сообщение_, "#" + КлючЗначение_.Ключ + "#", КлючЗначение_.Значение);
		КонецЦикла;
	КонецЕсли;
	
	ВызватьИсключение(Сообщение_);
КонецФункции

Функция СтрокаОшибкиПоКоду(КодОшибки)
	Если НЕ ЗначениеЗаполнено(КодОшибки) ИЛИ КодОшибки = "0" Тогда 
		Возврат "";
	ИначеЕсли КодОшибки = "1" Тогда 
		Возврат "Данные не найдены. Изучите журнал регистрации.";
	ИначеЕсли КодОшибки = "2" Тогда 
		Возврат "Внутренняя ошибка системы. Изучите журнал регистрации.";
	ИначеЕсли КодОшибки = "3" Тогда 
		Возврат "Истекло время ожидания сессии.";
	КонецЕсли;
	
	Возврат "Неизвестная ошибка. Изучите журнал регистрации.";
КонецФункции

Функция ВерсияXML(XML)
	Если СтрНайти(XML, ФедеральныеВебСервисыПовтИсп.ПространстваИменЗаписьНаПрием().er2) > 0 Тогда 
		Возврат 2;
	КонецЕсли;
	Возврат 0;
КонецФункции

#КонецОбласти

#КонецЕсли