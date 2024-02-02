﻿
////////////////////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС
#Область ПрограммныйИнтерфейс

Функция ПараметрыСервераАПИ() Экспорт
	
	Адрес = Константы.АдресСервисаРаботаСНоменклатуройБольничнаяАптека.Получить();
	ПараметрыПодключения = ПолучитьПараметрыСервера(Адрес);
	
	Возврат ПараметрыПодключения;
	
КонецФункции

Функция ПолучитьПараметрыАутентификацииНаСервереАПИ(Знач ПараметрыПодключения, Знач ТипАутентификации = "bearer", ПолучатьКлючСессииИзКеша = Истина) Экспорт
	
	Результат = Новый Соответствие;
	
	Если НРег(ТипАутентификации) = "bearer" Тогда
		
		РезультатПолученияКлючаСессии = ПолучитьКлючСессии(ПараметрыПодключения, Неопределено, ПолучатьКлючСессииИзКеша);
		Если РезультатПолученияКлючаСессии.Статус = "Ошибка" Тогда
			ТекстОшибки = НСтр("ru = 'Не удалось получить ключ сессии по причине:'");
			ТекстОшибки = ТекстОшибки + Символы.ПС + РезультатПолученияКлючаСессии.ОписаниеОшибки;
			ЗаписатьОшибкуВЖурналРегистрации(ТекстОшибки);
			Возврат Результат;
		КонецЕсли;
		
		Результат.Вставить("Authorization", "Bearer " + РезультатПолученияКлючаСессии.КлючСессии);
		
	Иначе
		
		УстановитьПривилегированныйРежим(Истина);
		ТикетАутентификацииИТС = ИнтернетПоддержкаПользователей.ТикетАутентификацииНаПорталеПоддержки("1C-Bn");
		УстановитьПривилегированныйРежим(Ложь);
		
		Если ЗначениеЗаполнено(ТикетАутентификацииИТС.КодОшибки) Тогда
			ТекстОшибки = НСтр("ru = 'Не удалось подключиться к порталу интернет-поддержки по причине:'");
			ТекстОшибки = ТекстОшибки + Символы.ПС + ТикетАутентификацииИТС.ИнформацияОбОшибке;
			ЗаписатьОшибкуВЖурналРегистрации(ТекстОшибки);
			Возврат Результат;
		КонецЕсли;
		
		Результат.Вставить("Authorization", "Basic " + СтрокаBase64БезBOM("AUTH_TOKEN:" + ТикетАутентификацииИТС.Тикет));
		
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

Функция ВыполнитьМетодАПИ(Знач ПараметрыПодключения, Знач ИмяМетода, Знач Параметры = Неопределено) Экспорт
	
	Если ТипЗнч(Параметры) <> Тип("Массив") И ТипЗнч(Параметры) <> Тип("ФиксированныйМассив") Тогда
		Параметры = Новый Массив;
	КонецЕсли;
	
	СписокПараметров = "";
	Для Индекс = 0 По Параметры.ВГраница() Цикл
		СписокПараметров = СписокПараметров + ", Параметры[" + Формат(Индекс, "ЧН=0; ЧГ=") + "]";
	КонецЦикла;
	
	Выражение = СтрШаблон("ОблачныеКлассификаторыБольничнаяАптекаКлиентСервер.%1(ПараметрыПодключения%2)", ИмяМетода, СписокПараметров);
	
	Возврат Вычислить(Выражение);
	
КонецФункции

Функция ВыполнитьHTTPЗапрос(Знач ПараметрыПодключения, Знач ДанныеЗапроса) Экспорт
	
	Возврат ОблачныеКлассификаторыБольничнаяАптекаКлиентСервер.ВыполнитьHTTPЗапрос(ПараметрыПодключения, ДанныеЗапроса);
	
КонецФункции

#КонецОбласти

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ
#Область СлужебныеПроцедурыИФункции

Функция ПолучитьПараметрыСервера(АдресСервера)
	
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

Функция ПолучитьКлючСессии(Знач ПараметрыПодключения, Знач КодАутентификации, Знач ПолучатьКлючСессииИзКеша = Истина)
	
	Результат = ОблачныеКлассификаторыБольничнаяАптекаКлиентСервер.РезультатВыполненияОперации();
	
	ПолучитьНовыеПараметрыАвторизацииКлючемОбновления = Ложь;
	
	Если ПолучатьКлючСессииИзКеша Тогда
		
		ПараметрыАвторизации = ПолучитьПараметрыАвторизацииИзКеша();
		
		РезультатПроверки = ПроверитьПараметрыАвторизацииИзКеша(ПараметрыАвторизации);
		
		ПолучитьНовыеПараметрыАвторизации =
			РезультатПроверки.ПараметрыАвторизацииНеЗаполнены
			Или РезультатПроверки.ПараметрыКлючаСессииНеЗаполнены
			Или РезультатПроверки.ДанныеАутентификацииИзменились
			Или РезультатПроверки.СрокЖизниКлючаСессииИстек;
		
		Если Не ПолучитьНовыеПараметрыАвторизации Тогда
			ОбщегоНазначенияКлиентСервер.ДополнитьСтруктуру(Результат, ПараметрыАвторизации, Истина);
			Возврат Результат;
		КонецЕсли;
		
		ПолучитьНовыеПараметрыАвторизацииКлючемОбновления =
			РезультатПроверки.ПараметрыКлючаОбновленияЗаполнены
			И Не РезультатПроверки.СрокЖизниКлючаОбновленияИстек;
		
	КонецЕсли;
	
	Если ПолучитьНовыеПараметрыАвторизацииКлючемОбновления Тогда
		
		РезультатПолученияКлючаСессии = ОблачныеКлассификаторыБольничнаяАптекаКлиентСервер.ПолучитьКлючСессииПоКлючуОбновления(ПараметрыПодключения, ПараметрыАвторизации.КлючОбновления);
		Если РезультатПолученияКлючаСессии.Статус <> "Ошибка" Тогда
			
			ПараметрыАвторизации = СформироватьПараметрыАвтаризацииДляЗаписиВКеш(РезультатПолученияКлючаСессии);
			
			РезультатПроверки = ПроверитьПараметрыАвторизацииИзКеша(ПараметрыАвторизации);
			
			ПолучитьНовыеПараметрыАвторизации =
				РезультатПроверки.ПараметрыАвторизацииНеЗаполнены
				Или РезультатПроверки.ПараметрыКлючаСессииНеЗаполнены
				Или РезультатПроверки.ДанныеАутентификацииИзменились
				Или РезультатПроверки.СрокЖизниКлючаСессииИстек;
			
			Если Не ПолучитьНовыеПараметрыАвторизации Тогда
				ЗаписатьПараметрыАвторизацииВКеш(ПараметрыАвторизации);
				ОбщегоНазначенияКлиентСервер.ДополнитьСтруктуру(Результат, ПараметрыАвторизации, Истина);
				Возврат Результат;
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	ТикетАутентификацииИТС = ИнтернетПоддержкаПользователей.ТикетАутентификацииНаПорталеПоддержки("1C-Bn");
	УстановитьПривилегированныйРежим(Ложь);
	
	Если ЗначениеЗаполнено(ТикетАутентификацииИТС.КодОшибки) Тогда
		
		РазделениеВключено = ОбщегоНазначения.РазделениеВключено();
		Если Не РазделениеВключено Тогда
			
			УстановитьПривилегированныйРежим(Истина);
			НовыеДанныеАутентификации = ИнтернетПоддержкаПользователей.ДанныеАутентификацииПользователяИнтернетПоддержки();
			УстановитьПривилегированныйРежим(Ложь);
			
			РезультатПолученияКлючаСессии = ОблачныеКлассификаторыБольничнаяАптекаКлиентСервер.ПолучитьКлючСессииПоЛогинуИПаролю(ПараметрыПодключения, НовыеДанныеАутентификации);
			
		Иначе
			
			РезультатПолученияКлючаСессии = ОблачныеКлассификаторыБольничнаяАптекаКлиентСервер.РезультатВыполненияОперации();
			РезультатПолученияКлючаСессии.Статус         = "Ошибка";
			РезультатПолученияКлючаСессии.КодОшибки      = ТикетАутентификацииИТС.КодОшибки;
			РезультатПолученияКлючаСессии.ОписаниеОшибки = ТикетАутентификацииИТС.ИнформацияОбОшибке;
			
		КонецЕсли;
		
	Иначе
		РезультатПолученияКлючаСессии = ОблачныеКлассификаторыБольничнаяАптекаКлиентСервер.ПолучитьКлючСессииПоТикету(ПараметрыПодключения, ТикетАутентификацииИТС.Тикет);
	КонецЕсли;
	
	Если РезультатПолученияКлючаСессии.Статус <> "Ошибка" Тогда
		ПараметрыАвторизации = СформироватьПараметрыАвтаризацииДляЗаписиВКеш(РезультатПолученияКлючаСессии);
		ЗаписатьПараметрыАвторизацииВКеш(ПараметрыАвторизации);
		ОбщегоНазначенияКлиентСервер.ДополнитьСтруктуру(Результат, ПараметрыАвторизации, Истина);
		Возврат Результат;
	КонецЕсли;
	
	ОбщегоНазначенияКлиентСервер.ДополнитьСтруктуру(Результат, РезультатПолученияКлючаСессии, Истина);
	Возврат Результат;
	
КонецФункции

Функция ПолучитьПараметрыАвторизацииИзКеша()
	
	УстановитьПривилегированныйРежим(Истина);
	ПараметрыАвторизации = ОбщегоНазначения.ПрочитатьДанныеИзБезопасногоХранилища(Пользователи.ТекущийПользователь(), "РаботаСНоменклатуройБольничнаяАптекаКлючСессии");
	УстановитьПривилегированныйРежим(Ложь);
	
	Возврат ПараметрыАвторизации;
	
КонецФункции

Функция СформироватьПараметрыАвтаризацииДляЗаписиВКеш(РезультатПолученияКлючаСессии)
	
	ПараметрыАвторизации = Новый Структура;
	
	Если РезультатПолученияКлючаСессии.Данные["access_token"] <> Неопределено Тогда
		ПараметрыАвторизации.Вставить("КлючСессии", РезультатПолученияКлючаСессии.Данные["access_token"]);
	КонецЕсли;
	
	Если РезультатПолученияКлючаСессии.Данные["access_token_expires"] <> Неопределено Тогда
		ПараметрыАвторизации.Вставить("СрокЖизни" , ТекущаяУниверсальнаяДатаВМиллисекундах() + РезультатПолученияКлючаСессии.Данные["access_token_expires"] * 1000);
	ИначеЕсли РезультатПолученияКлючаСессии.Данные["expires"] <> Неопределено Тогда
		ПараметрыАвторизации.Вставить("СрокЖизни" , ТекущаяУниверсальнаяДатаВМиллисекундах() + РезультатПолученияКлючаСессии.Данные["expires"] * 1000);
	КонецЕсли;
	
	Если РезультатПолученияКлючаСессии.Данные["refresh_token"] <> Неопределено Тогда
		ПараметрыАвторизации.Вставить("КлючОбновления", РезультатПолученияКлючаСессии.Данные["refresh_token"]);
	КонецЕсли;
	
	Если РезультатПолученияКлючаСессии.Данные["refresh_token_expires"] <> Неопределено Тогда
		ПараметрыАвторизации.Вставить("СрокЖизниКлючаОбновления", ТекущаяУниверсальнаяДатаВМиллисекундах() + РезультатПолученияКлючаСессии.Данные["refresh_token_expires"] * 1000);
	КонецЕсли;
	
	РазделениеВключено = ОбщегоНазначения.РазделениеВключено();
	Если Не РазделениеВключено Тогда
		
		УстановитьПривилегированныйРежим(Истина);
		НовыеДанныеАутентификации = ИнтернетПоддержкаПользователей.ДанныеАутентификацииПользователяИнтернетПоддержки();
		УстановитьПривилегированныйРежим(Ложь);
		
		ПараметрыАвторизации.Вставить("ДанныеАутентификации", НовыеДанныеАутентификации);
		
	КонецЕсли;
	
	Возврат ПараметрыАвторизации;
	
КонецФункции

Процедура ЗаписатьПараметрыАвторизацииВКеш(ПараметрыАвторизации)
	
	УстановитьПривилегированныйРежим(Истина);
	ОбщегоНазначения.ЗаписатьДанныеВБезопасноеХранилище(Пользователи.ТекущийПользователь(), ПараметрыАвторизации, "РаботаСНоменклатуройБольничнаяАптекаКлючСессии");
	УстановитьПривилегированныйРежим(Ложь);
	
КонецПроцедуры

Функция ПроверитьПараметрыАвторизацииИзКеша(ПараметрыАвторизации)
	
	РезультатПроверки = Новый Структура;
	РезультатПроверки.Вставить("ПараметрыАвторизацииНеЗаполнены"    , Ложь);
	РезультатПроверки.Вставить("ПараметрыКлючаСессииНеЗаполнены"    , Ложь);
	РезультатПроверки.Вставить("ДанныеАутентификацииИзменились"     , Ложь);
	РезультатПроверки.Вставить("СрокЖизниКлючаСессииИстек"          , Ложь);
	РезультатПроверки.Вставить("ПараметрыКлючаОбновленияЗаполнены"  , Ложь);
	РезультатПроверки.Вставить("СрокЖизниКлючаОбновленияИстек"      , Ложь);
	
	Если ПараметрыАвторизации = Неопределено Тогда
		РезультатПроверки.ПараметрыАвторизацииНеЗаполнены = Истина;
		Возврат РезультатПроверки;
	КонецЕсли;
	
	Если ПараметрыКлючаСессииНеЗаполнены(ПараметрыАвторизации) Тогда
		РезультатПроверки.ПараметрыКлючаСессииНеЗаполнены = Ложь;
		Возврат РезультатПроверки;
	КонецЕсли;
	
	Если ДанныеАутентификацииИзменились(ПараметрыАвторизации) Тогда
		РезультатПроверки.ДанныеАутентификацииИзменились = Истина;
		Возврат РезультатПроверки;
	КонецЕсли;
	
	Если СрокЖизниКлючаСессииИстек(ПараметрыАвторизации) Тогда
		
		РезультатПроверки.СрокЖизниКлючаСессииИстек = Истина;
		
		РезультатПроверки.ПараметрыКлючаОбновленияЗаполнены = ПараметрыКлючаОбновленияЗаполнены(ПараметрыАвторизации);
		Если РезультатПроверки.ПараметрыКлючаОбновленияЗаполнены Тогда
			РезультатПроверки.СрокЖизниКлючаОбновленияИстек = СрокЖизниКлючаОбновленияИстек(ПараметрыАвторизации);
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат РезультатПроверки;
	
КонецФункции

Функция ПараметрыКлючаСессииНеЗаполнены(ПараметрыАвторизации)
	
	КлючСессии = ОбщегоНазначенияКлиентСервер.СвойствоСтруктуры(ПараметрыАвторизации, "КлючСессии");
	СрокЖизни = ОбщегоНазначенияКлиентСервер.СвойствоСтруктуры(ПараметрыАвторизации, "СрокЖизни");
	
	Возврат Не (ЗначениеЗаполнено(КлючСессии) И ЗначениеЗаполнено(СрокЖизни));
	
КонецФункции

Функция ДанныеАутентификацииИзменились(ПараметрыАвторизации)
	
	ДанныеАутентификацииИзменились = Ложь;
	
	РазделениеВключено = ОбщегоНазначения.РазделениеВключено();
	Если Не РазделениеВключено Тогда
		
		УстановитьПривилегированныйРежим(Истина);
		НовыеДанныеАутентификации = ИнтернетПоддержкаПользователей.ДанныеАутентификацииПользователяИнтернетПоддержки();
		УстановитьПривилегированныйРежим(Ложь);
		
		СтарыеДанныеАутентификации = ОбщегоНазначенияКлиентСервер.СвойствоСтруктуры(ПараметрыАвторизации, "ДанныеАутентификации");
		
		Если Не ДанныеАутентификацииИдентичны(НовыеДанныеАутентификации, СтарыеДанныеАутентификации) Тогда
			ДанныеАутентификацииИзменились = Истина;
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат ДанныеАутентификацииИзменились;
	
КонецФункции

Функция СрокЖизниКлючаСессииИстек(ПараметрыАвторизации)
	
	СрокЖизниИстек = Ложь;
	
	СрокЖизни = ОбщегоНазначенияКлиентСервер.СвойствоСтруктуры(ПараметрыАвторизации, "СрокЖизни", 0);
	Если СрокЖизни < ТекущаяУниверсальнаяДатаВМиллисекундах() Тогда
		СрокЖизниИстек = Истина;
	КонецЕсли;
	
	Возврат СрокЖизниИстек;
	
КонецФункции

Функция ПараметрыКлючаОбновленияЗаполнены(ПараметрыАвторизации)
	
	КлючОбновления = ОбщегоНазначенияКлиентСервер.СвойствоСтруктуры(ПараметрыАвторизации, "КлючОбновления");
	СрокЖизниКлючаОбновления = ОбщегоНазначенияКлиентСервер.СвойствоСтруктуры(ПараметрыАвторизации, "СрокЖизниКлючаОбновления");
	
	Возврат ЗначениеЗаполнено(КлючОбновления) И ЗначениеЗаполнено(СрокЖизниКлючаОбновления);
	
КонецФункции

Функция СрокЖизниКлючаОбновленияИстек(ПараметрыАвторизации)
	
	СрокЖизниИстек = Ложь;
	
	СрокЖизни = ОбщегоНазначенияКлиентСервер.СвойствоСтруктуры(ПараметрыАвторизации, "СрокЖизниКлючаОбновления", 0);
	Если СрокЖизни < ТекущаяУниверсальнаяДатаВМиллисекундах() Тогда
		СрокЖизниИстек = Истина;
	КонецЕсли;
	
	Возврат СрокЖизниИстек;
	
КонецФункции

Функция СтрокаBase64БезBOM(СтрокаДанных)

	ПотокВПамяти = Новый ПотокВПамяти();
	Текст = Новый ЗаписьТекста(ПотокВПамяти, КодировкаТекста.UTF8, , Символы.ПС);
	Текст.Записать(СтрокаДанных);
	Текст.Закрыть();
	ДвоичныеДанные = ПотокВПамяти.ЗакрытьИПолучитьДвоичныеДанные();
	СтрокаФорматBase64 = Base64Строка(ДвоичныеДанные);
	
	СтрокаФорматBase64 = СтрЗаменить(СтрокаФорматBase64, Символы.ВК, "");
	СтрокаФорматBase64 = СтрЗаменить(СтрокаФорматBase64, Символы.ПС, "");
	
	Возврат СтрокаФорматBase64;

КонецФункции

Функция ДанныеАутентификацииИдентичны(НовыеДанныеАутентификации, СтарыеДанныеАутентификации)
	
	Если Не ЗначениеЗаполнено(НовыеДанныеАутентификации) Или Не ЗначениеЗаполнено(СтарыеДанныеАутентификации) Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Если НовыеДанныеАутентификации.Количество() <> СтарыеДанныеАутентификации.Количество() Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Для Каждого КлючИЗначение Из НовыеДанныеАутентификации Цикл
		Значение = Неопределено;
		Если Не СтарыеДанныеАутентификации.Свойство(КлючИЗначение.Ключ, Значение) Или КлючИЗначение.Значение <> Значение Тогда
			Возврат Ложь;
		КонецЕсли;
	КонецЦикла;
	
	Возврат Истина;
	
КонецФункции

Процедура ЗаписатьОшибкуВЖурналРегистрации(Знач Текст, Знач ИмяСобытия = "") Экспорт
	
	ОблачныеКлассификаторыБольничнаяАптека.ЗаписатьОшибкуВЖурналРегистрации(Текст, ИмяСобытия);
	
КонецПроцедуры

Процедура ЗаписатьИнформациюВЖурналРегистрации(Знач Текст, Знач ИмяСобытия = "") Экспорт
	
	ОблачныеКлассификаторыБольничнаяАптека.ЗаписатьИнформациюВЖурналРегистрации(Текст, ИмяСобытия);
	
КонецПроцедуры

Процедура Таймаут(Миллисекунды = 1000) Экспорт
	
	ОблачныеКлассификаторыБольничнаяАптекаКлиентСервер.Таймаут(Миллисекунды);
	
КонецПроцедуры

#КонецОбласти // СлужебныеПроцедурыИФункции
