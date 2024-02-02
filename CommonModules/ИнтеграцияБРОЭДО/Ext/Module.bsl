﻿#Область СлужебныйПрограммныйИнтерфейс

// Проверяет необходимость переиздания указанного сертификата для использования в ЭДО.
//
// Параметры:
//  Организация - ОпределяемыйТип.Организация - организация для проверки.
//  Сертификат - СертификатКриптографии - сертификат для проверки.
//  ТребуетсяПереиздание - Булево - признак необходимости переиздать сертификат для ЭДО.
//
Процедура ТребуетсяПереизданиеСертификатаЭДО(Знач Организация, Знач Сертификат, ТребуетсяПереиздание) Экспорт
	
	СсылкаНаСертификат = ЭлектроннаяПодпись.СсылкаНаСертификат(Сертификат);
	
	Если ЗначениеЗаполнено(СсылкаНаСертификат) Тогда
		Запрос = Новый Запрос;
		Запрос.Текст =
		"ВЫБРАТЬ ПЕРВЫЕ 1
		|	СертификатыУчетныхЗаписей.ИдентификаторЭДО КАК ИдентификаторОрганизации
		|ИЗ
		|	СертификатыУчетныхЗаписей КАК СертификатыУчетныхЗаписей";
		
		Отбор = СинхронизацияЭДО.НовыйОтборСертификатовУчетныхЗаписей();
		Отбор.Сертификат = "&Сертификат";
		ЗапросСертификатов = СинхронизацияЭДО.ЗапросСертификатовУчетныхЗаписей("СертификатыУчетныхЗаписей", Отбор);
		
		Запросы = Новый Массив;
		Запросы.Добавить(ЗапросСертификатов);
		
		ИтоговыйЗапрос = ОбщегоНазначенияБЭД.СоединитьЗапросы(Запрос, Запросы);
		ИтоговыйЗапрос.УстановитьПараметр("Сертификат", СсылкаНаСертификат);
		
		УстановитьПривилегированныйРежим(Истина);
		Результат = ИтоговыйЗапрос.Выполнить();
		УстановитьПривилегированныйРежим(Ложь);
		
		ТребуетсяПереиздание = Не Результат.Пустой();
	Иначе
		ТребуетсяПереиздание = Ложь;
	КонецЕсли;
	
КонецПроцедуры

// Инициализирует настройки подключения ЭДО.
//
// Параметры:
//  Организация - ОпределяемыйТип.Организация - организация для подключения ЭДО.
//  КодФНС - Строка - код налогового органа организации.
//  Настройки - Строка - инициализированные настройки.
//
Процедура ИнициализироватьНастройкиПодключенияЭДО(Знач Организация, Знач КодФНС, Настройки) Экспорт
	
	Параметры = СинхронизацияЭДОКлиентСервер.НовыеПараметрыПодключенияЭДО();
	Параметры.Организация = Организация;
	Параметры.КодНалоговогоОргана = КодФНС;
	Параметры.ОператорЭДО = "2AE"; // Калуга Астрал.
	Параметры.СпособОбменаЭД = Перечисления.СпособыОбменаЭД.ЧерезСервис1СЭДО;
	Параметры.НаименованиеУчетнойЗаписи = СтрШаблон(НСтр("ru = '%1, %2'"), Параметры.Организация, Параметры.СпособОбменаЭД);
	Параметры.НазначениеУчетнойЗаписи = НСтр("ru = 'Основная'");
	Параметры.ПринятыУсловияИспользования = Истина;
	
	КонтактнаяИнформация = ИнтеграцияБСПБЭД.КонтактнаяИнформацияОбъекта(Организация, "ЮрАдресОрганизации");
	Параметры.АдресОрганизации         = КонтактнаяИнформация.Представление;
	Параметры.АдресОрганизацииЗначение = КонтактнаяИнформация.Значение;
		
	Операция = СинхронизацияЭДОКлиентСервер.НоваяОперацияПодключенияЭДО(Параметры);
	
	Настройки = ИнтеграцияБРОЭДОСлужебный.ОперацияЭДОВСтроку(Операция);
	
КонецПроцедуры

// Инициализирует настройки переиздания сертификата криптографии.
//
// Параметры:
//  Организация - ОпределяемыйТип.Организация - организация для переиздания сертификата.
//  КодФНС - Строка - код налогового органа организации.
//  Сертификат - СертификатКриптографии - сертификат для переиздания.
//  Настройки - Строка - инициализированные настройки.
//
Процедура ИнициализироватьНастройкиПереизданияСертификатаЭДО(Знач Организация, Знач КодФНС, Знач Сертификат, Настройки) Экспорт
	
	СсылкаНаСертификат = ЭлектроннаяПодпись.СсылкаНаСертификат(Сертификат);
	
	Параметры = СинхронизацияЭДОКлиентСервер.НовыеПараметрыОбновленияСертификата();
	Параметры.Организация = Организация;
	Параметры.Сертификат  = СсылкаНаСертификат;
	
	Операция = СинхронизацияЭДОКлиентСервер.НоваяОперацияОбновленияСертификата(Параметры);
	
	Настройки = ИнтеграцияБРОЭДОСлужебный.ОперацияЭДОВСтроку(Операция);
	
КонецПроцедуры

// Проверяет корректность настроек операции ЭДО (подключение ЭДО, переиздание сертификата).
//
// Параметры:
//  Настройки - Строка - настройки для проверки.
//                       См. ИнициализироватьНастройкиПодключенияЭДО.
//                       См. ИнициализироватьНастройкиПереизданияСертификатаЭДО.
//  НастройкиКорректны - Булево - результат проверки настроек.
//
Процедура ПроверитьНастройкиРегистрацииЭДО(Знач Настройки, НастройкиКорректны) Экспорт
	
	Операция = ИнтеграцияБРОЭДОСлужебный.ОперацияЭДОИзСтроки(Настройки);
	
	НастройкиКорректны = ИнтеграцияБРОЭДОСлужебный.ОперацияЭДОКорректна(Операция);
	
КонецПроцедуры

// Выгружает электронные документы для предоставления в ФНС.
// Предназначена для использования совместно с библиотекой "Регламентированная отчетность".
//
// Параметры:
//  УчетныеДокументы - Массив - массив ссылок на документы информационной базы.
//  УникальныйИдентификатор - УникальныйИдентификатор - будет использован для помещения файлов выгрузки во временное хранилище.
//
// Возвращаемое значение:
//  Соответствие - соответствие документов ИБ:
//    * Ключ     - ДокументСсылка - ссылка на документ-владелец электронного документа.
//    * Значение - Массив Из Структура - параметры электронных документов, с ключами:
//       * ТипФайла - Строка - возможные значения: "ФайлВыгрузки", "ЭЦП", "ФайлПодтверждения", "ЭЦППодтверждения".
//       * КНД      - Строка - КНД выгружаемого электронного документа, заполняется только для файла выгрузки и файла подтверждения.
//       * ИмяФайла - Строка - имя выгружаемого файла.
//       * АдресВременногоХранилища - Строка - адрес временного хранилища с данными файлов выгрузки.
//
Функция ВыгрузкаДокументовДляПередачиВФНС(УчетныеДокументы, УникальныйИдентификатор) Экспорт
	
	ДанныйФайлов = ЭлектронныеДокументыЭДО.ДанныеФайловЭлектронныхДокументовДляВыгрузкиВФНС(
		УчетныеДокументы, УникальныйИдентификатор);
	
	КонверторТипов = Новый Соответствие;
	КонверторТипов.Вставить("ОсновнойТитул", "ФайлВыгрузки");
	КонверторТипов.Вставить("ОтветныйТитул", "ФайлПодтверждения");
	КонверторТипов.Вставить("ОсновнаяПодпись", "ЭЦП");
	КонверторТипов.Вставить("ОтветнаяПодпись", "ЭЦППодтверждения");
		
	Результат = Новый Соответствие;
	
	Для каждого Данные Из ДанныйФайлов Цикл
		
		НаборОписанийФайлов = Новый Массив;
		
		Для каждого Файл Из Данные.Значение Цикл
		
			ОписаниеФайла = Новый Структура;
			ОписаниеФайла.Вставить("ТипФайла", КонверторТипов[Файл.Тип]);
			ОписаниеФайла.Вставить("ИмяФайла", Файл.Имя);
			ОписаниеФайла.Вставить("КНД", Файл.КНД);
			ОписаниеФайла.Вставить("АдресВременногоХранилища", Файл.Данные);
			
			НаборОписанийФайлов.Добавить(ОписаниеФайла);
		
		КонецЦикла;
		
		Результат.Вставить(Данные.Ключ, НаборОписанийФайлов);
	
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

// Выгружает электронные документы для предоставления в ФНС.
//
// Параметры:
//  ЭлектронныеДокументы - Массив - Электронные документы, которые необходимо выгрузить.
//  ИдентификаторФормы - УникальныйИдентификатор - Для передачи в ПоместитьВоВременноеХранилище().
//
// Возвращаемое значение:
//  Соответствие - Данные о выгруженных файлах:
//   * Ключ - Структура - Данные файла:
//    ** ИмяФайла - Строка
//    ** ИмяБезРасширения - Строка
//    ** Расширение - Строка
//    ** Размер - Число
//   * Значение - Строка - Адрес во временном хранилище, куда помещен файл.
//
Функция СформироватьФайлыВыгрузкиЭДДляФНС(Знач ЭлектронныеДокументы) Экспорт
	
	СоответствиеДанныеФайлаАдресВХранилище = Новый Соответствие;
	
	Если ЭлектронныеДокументы.Количество() = 0 Тогда
		Возврат СоответствиеДанныеФайлаАдресВХранилище;
	КонецЕсли;
	
	ДанныеОбъектовУчета = ДанныеОбъектовУчетаДляВыгрузкиЭДДляФНС(ЭлектронныеДокументы);
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ЭлектронныеДокументы", ЭлектронныеДокументы);
	Запрос.УстановитьПараметр("ТипыДокументовЭДОВыгрузкиДляФНС", ТипыДокументовЭДОВыгрузкиДляФНС());
	Запрос.Текст = ЭлектронныеДокументыЭДО.ТекстЗапросаДляВыгрузкиЭДДляФНС();
	ВыборкаПоОрганизации = Запрос.Выполнить().Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	
	Пока ВыборкаПоОрганизации.Следующий() Цикл
		
		ТЗОписи = НоваяТаблицаОписиВыгрузкиЭДДляФНС();
		Организация = ВыборкаПоОрганизации.Организация;
		АдресКаталога = РаботаСФайламиБЭД.ВременныйКаталог();
		РаботаСФайламиБЭД.УдалитьВременныеФайлы(АдресКаталога, "*");
		ВыгруженныеЭлектронныеДокументы = Новый Массив;
		
		Выборка = ВыборкаПоОрганизации.Выбрать();
		
		Пока Выборка.Следующий() Цикл
			
			Если Выборка.ТипДокументаНеПодходитДляВыгрузки Тогда
				ШаблонСообщения =
					НСтр("ru = 'Документ ""%1"" не выгружен: тип ""%2"" не предназначен для предоставления в ФНС.'");
				ТекстСообщения = СтрШаблон(ШаблонСообщения, Выборка.ЭлектронныйДокумент, Выборка.ТипДокумента);
				ОбщегоНазначения.СообщитьПользователю(ТекстСообщения, Выборка.ЭлектронныйДокумент);
				Продолжить;
			КонецЕсли;
			
			ДанныеОбъектаУчета = ДанныеОбъектовУчета.Найти(Выборка.ЭлектронныйДокумент, "ЭлектронныйДокумент");
			
			Если ДанныеОбъектаУчета = Неопределено
				Или Не ЗначениеЗаполнено(ДанныеОбъектаУчета.ОбъектУчета) Тогда
				ШаблонСообщения = НСтр("ru = 'Документ ""%1"" не выгружен: не указан документ учета.'");
				ТекстСообщения = СтрШаблон(ШаблонСообщения, Выборка.ЭлектронныйДокумент);
				ОбщегоНазначения.СообщитьПользователю(ТекстСообщения, Выборка.ЭлектронныйДокумент);
				Продолжить;
			КонецЕсли;
			
			НомерДокументаОснования = ДанныеОбъектаУчета.НомерДоговора;
			ДатаДокументаОснования = ДанныеОбъектаУчета.ДатаДоговора;
			
			Если Выборка.ПроверятьДокументОснование
				И Не ЗначениеЗаполнено(НомерДокументаОснования)
				И Не ЗначениеЗаполнено(ДатаДокументаОснования) Тогда
				ТекстСообщения = НСтр("ru = 'Не заполнен реквизит документа-основания (номер, дата) у документа ""%1""'");
				ТекстСообщения = СтрЗаменить(ТекстСообщения, "%1", Выборка.ЭлектронныйДокумент);
				ОбщегоНазначения.СообщитьПользователю(ТекстСообщения, Выборка.ЭлектронныйДокумент);
				Продолжить;
			КонецЕсли;
			
			СтрокаТЗОписи = ТЗОписи.Добавить();
			ЗаполнитьЗначенияСвойств(СтрокаТЗОписи, Выборка);
			
			СтрокаТЗОписи.НомерДокументаОснования = НомерДокументаОснования;
			СтрокаТЗОписи.ДатаДокументаОснования = ДатаДокументаОснования;
			
			ДанныеФайла = ЭлектронныеДокументыЭДО.ДанныеФайлаИнформацииОтправителяДляВыгрузкиФНС(Выборка.ЭлектронныйДокумент);
			СтрокаТЗОписи.ИмяФайлаДанных = ДанныеФайла.ИмяФайла;
			СтрокаТЗОписи.РазмерФайлаДанных = ДанныеФайла.Размер;
			СтрокаТЗОписи.КНД = ДанныеФайла.КНД;
			МассивСтруктурПодписей = ДанныеФайла.УстановленныеПодписи;
			
			ДанныеЭД = ДанныеФайла.ДвоичныеДанные;
			ДанныеЭД.Записать(АдресКаталога + ДанныеФайла.ИмяФайла);
			
			Если ТипЗнч(МассивСтруктурПодписей) = Тип("Массив") И МассивСтруктурПодписей.Количество() > 0 Тогда
				СтруктураПодписи = МассивСтруктурПодписей[0];
				ИмяФайлаПодписи = ДанныеФайла.ИмяФайла + "SGN.sgn";
				СтруктураПодписи.Подпись.Записать(АдресКаталога + ИмяФайлаПодписи);
				СтрокаТЗОписи.ИмяФайлаПодписи = ИмяФайлаПодписи;
				СтрокаТЗОписи.РазмерФайлаПодписи = ДанныеЭД.Размер();
			Иначе
				ТекстСообщения = НСтр("ru = 'Не удалось выгрузить подпись по документу ""%1"".'");
				ТекстСообщения = СтрЗаменить(ТекстСообщения, "%1", Выборка.ЭлектронныйДокумент);
				ОбщегоНазначения.СообщитьПользователю(ТекстСообщения, Выборка.ЭлектронныйДокумент);
				РаботаСФайламиБЭД.УдалитьВременныеФайлы(АдресКаталога);
				Продолжить;
			КонецЕсли;
			
			ДанныеФайла = ЭлектронныеДокументыЭДО.ДанныеФайлаИнформацииПолучателяДляВыгрузкиФНС(Выборка.ЭлектронныйДокумент);
			Если ЗначениеЗаполнено(ДанныеФайла.ИмяФайла) Тогда
				СтрокаТЗОписи.ИмяФайлаДанныхПодтверждения = ДанныеФайла.ИмяФайла;
				СтрокаТЗОписи.РазмерФайлаДанныхПодтверждения = ДанныеФайла.Размер;
				ДанныеЭД = ДанныеФайла.ДвоичныеДанные;
				ДанныеЭД.Записать(АдресКаталога + ДанныеФайла.ИмяФайла);
				МассивСтруктурПодписей = ДанныеФайла.УстановленныеПодписи;
				
				СтрокаТЗОписи.КНДПодтверждения = ДанныеФайла.КНД;
				
				Если ТипЗнч(МассивСтруктурПодписей) = Тип("Массив") И МассивСтруктурПодписей.Количество() > 0 Тогда
					СтруктураПодписи = МассивСтруктурПодписей[0];
					ИмяФайлаПодписиПодтверждения = ДанныеФайла.ИмяФайла + "SGN.sgn";
					СтруктураПодписи.Подпись.Записать(АдресКаталога + ИмяФайлаПодписиПодтверждения);
					СтрокаТЗОписи.ИмяФайлаПодписиПодтверждения = ИмяФайлаПодписиПодтверждения;
					СтрокаТЗОписи.РазмерФайлаПодписиПодтверждения = ДанныеЭД.Размер();
				Иначе
					ТекстСообщения = НСтр("ru = 'Не удалось выгрузить ответную подпись по документу ""%1"".'");
					ТекстСообщения = СтрЗаменить(ТекстСообщения, "%1", Выборка.ЭлектронныйДокумент);
					ОбщегоНазначения.СообщитьПользователю(ТекстСообщения, Выборка.ЭлектронныйДокумент);
					РаботаСФайламиБЭД.УдалитьВременныеФайлы(АдресКаталога);
					Продолжить;
				КонецЕсли;
			КонецЕсли;
			
			ВыгруженныеЭлектронныеДокументы.Добавить(Выборка.ЭлектронныйДокумент);
			
		КонецЦикла;
		
		Файлы = НайтиФайлы(АдресКаталога, "*");
		Если Файлы.Количество() = 0 Тогда
			ТекстСообщения = НСтр("ru = 'Не удалось выгрузить документы по Организации ""%1"".'");
			ТекстСообщения = СтрЗаменить(ТекстСообщения, "%1", Организация);
			ОбщегоНазначения.СообщитьПользователю(ТекстСообщения);
			РаботаСФайламиБЭД.УдалитьВременныеФайлы(АдресКаталога);
			Продолжить;
		КонецЕсли;
		
		ИмяФайлаОписания = АдресКаталога + "описание.xml";
		Если Не СформироватьФайлОписанияВыгрузкиЭДДляФНС(Организация, ТЗОписи, ИмяФайлаОписания) Тогда
			Продолжить;
		КонецЕсли;
		
		ИмяРеквизитаИНН = ЭлектронноеВзаимодействие.ИмяНаличиеОбъектаРеквизитаВПрикладномРешении("ИННОрганизации");
		ИмяРеквизитаКПП = ЭлектронноеВзаимодействие.ИмяНаличиеОбъектаРеквизитаВПрикладномРешении("КППОрганизации");
		ИменаПолучаемыхРеквизитов = СтрШаблон("%1, %2", ИмяРеквизитаИНН, ИмяРеквизитаКПП);
		
		РеквизитыОрганизации = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Организация, ИменаПолучаемыхРеквизитов);
		ИНН = СокрЛП(РеквизитыОрганизации[ИмяРеквизитаИНН]);
		ИДОтправителя = ИНН + ?(СтрДлина(ИНН) = 12, "", СокрЛП(РеквизитыОрганизации[ИмяРеквизитаКПП]));
		ИДВыгрузки = Формат(ТекущаяДатаСеанса(), "ДФ=yyyyMMddЧЧммсс");
		
		ИмяФайла = "EDI_" + ИДОтправителя + "_" + ИДВыгрузки;
		ИмяФайла = ОбщегоНазначенияКлиентСервер.ЗаменитьНедопустимыеСимволыВИмениФайла(ИмяФайла);
		ИмяФайлаКонтейнера = АдресКаталога + ИмяФайла + ".zip";
		
		МассивФайлов = Новый Массив;
		Для Каждого Файл Из Файлы Цикл
			МассивФайлов.Добавить(Файл.ПолноеИмя);
		КонецЦикла;
		МассивФайлов.Добавить(ИмяФайлаОписания);
		
		РаботаСФайламиБЭД.СформироватьАрхивФайлов(МассивФайлов, ИмяФайлаКонтейнера);
		
		ДвоичныеДанныеКонтейнера = Новый ДвоичныеДанные(ИмяФайлаКонтейнера);
		ДанныеФайла = РаботаСФайламиБЭД.ДанныеФайла(ИмяФайлаКонтейнера);
		ДанныеФайла.Вставить("ЭлектронныеДокументы", ВыгруженныеЭлектронныеДокументы);
		АдресВХранилище = ПоместитьВоВременноеХранилище(ДвоичныеДанныеКонтейнера, Организация.УникальныйИдентификатор());
		
		СоответствиеДанныеФайлаАдресВХранилище.Вставить(ДанныеФайла, АдресВХранилище);
		
		РаботаСФайламиБЭД.УдалитьВременныеФайлы(АдресКаталога);
		
	КонецЦикла;
	
	Возврат СоответствиеДанныеФайлаАдресВХранилище;
	
КонецФункции

// Получает свойства объектов учета, которые будут отражаться в едином списке документов, представляемых по требованию ФНС.
// Для объекта учета должны существовать электронные документы по завершенным обменам, не помеченные на удаление и 
// имеющие один из следующих типов:
// УПД, СчетФактура, ТоварнаяНакладная, АктВыполненныхРабот, АктНаПередачуПрав,
// УКД, КорректировочныйСчетФактура, СоглашениеОбИзмененииСтоимости,
// АктОРасхождениях.
//
// Параметры:
//  ОбъектыУчета - Массив - массив ссылок на объекты учета электронных документов.
//                       Если параметр указан, требуется заполнить свойства только указанных объектов.
//                       Если параметр не указан или массив пустой, тогда требуется заполнить свойства
//                       для всех объектов учета, по которым ЭДО завершен.
//
// Возвращаемое значение:
//   Соответствие - Соответствие объектов учета и видов электронных документов:
//    * Ключ     - ДокументСсылка - ссылка на документ учета.
//    * Значение - Строка - тип электронного документа, который следует преобразовать
//                 к строковому представлению определенного формата.
//                 Возможные значения:
//                 УПД, СчетФактура, ТоварнаяНакладнаяТОРГ12, АктПриемкиСдачиРабот, АктНаПередачуПрав,
//                 УКД, КорректировочныйСчетФактура, ДокументОбИзмененииСтоимости,
//                 ПередачаТоваров, ПередачаУслуг, АктОРасхождениях.
Функция СвойстваОбъектовУчетаЭлектронныхДокументовДляВыгрузкиВФНС(ОбъектыУчета = Неопределено) Экспорт

	СвойстваДокументов = ЭлектронныеДокументыЭДО.СвойстваЭлектронныхДокументовДляВыгрузкиВФНС(ОбъектыУчета);
	
	КонверторКНД = Новый Соответствие;
	КонверторКНД.Вставить("1175010", "ПередачаТоваров");
	КонверторКНД.Вставить("1175012", "ПередачаУслуг");
	
	КонверторТипов = Новый Соответствие;
	КонверторТипов.Вставить(Перечисления.ТипыДокументовЭДО.УПД, "УПД");
	КонверторТипов.Вставить(Перечисления.ТипыДокументовЭДО.СчетФактура, "СчетФактура");
	КонверторТипов.Вставить(Перечисления.ТипыДокументовЭДО.ТоварнаяНакладная, "ТоварнаяНакладнаяТОРГ12");
	КонверторТипов.Вставить(Перечисления.ТипыДокументовЭДО.АктВыполненныхРабот, "АктПриемкиСдачиРабот");
	КонверторТипов.Вставить(Перечисления.ТипыДокументовЭДО.АктНаПередачуПрав, "АктНаПередачуПрав");
	КонверторТипов.Вставить(Перечисления.ТипыДокументовЭДО.УКД, "УКД");
	КонверторТипов.Вставить(Перечисления.ТипыДокументовЭДО.КорректировочныйСчетФактура, "КорректировочныйСчетФактура");
	КонверторТипов.Вставить(Перечисления.ТипыДокументовЭДО.СоглашениеОбИзмененииСтоимости, "ДокументОбИзмененииСтоимости");
	КонверторТипов.Вставить(Перечисления.ТипыДокументовЭДО.АктОРасхождениях, "АктОРасхождениях");
	
	Результат = Новый Соответствие;
	
	Для каждого Свойство Из СвойстваДокументов Цикл
	
		Тип = КонверторКНД[Свойство.КНД];
		
		Если Не ЗначениеЗаполнено(Тип) Тогда
			
			Тип = КонверторТипов[Свойство.Тип];
		
		КонецЕсли;
		
		Если Тип = Неопределено Тогда
			Тип = "";
		КонецЕсли;
		
		Результат.Вставить(Свойство.ОбъектУчета, Тип);
		
	КонецЦикла;
	
	Возврат Результат
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ВыгрузкаЭлектронныхДокументовДляФНС

// Возвращает новую таблицу для описи электронных документов для выгрузки в ФНС.
//
// Возвращаемое значение:
//  ТаблицаЗначений - Пустая таблица описи.
//
Функция НоваяТаблицаОписиВыгрузкиЭДДляФНС()
	
	ТЗ = Новый ТаблицаЗначений;
	
	ТЗ.Колонки.Добавить("Документ");
	ТЗ.Колонки.Добавить("Контрагент");
	ТЗ.Колонки.Добавить("ТипДокументаЭДО");
	ТЗ.Колонки.Добавить("ТипЭлементаРегламента");
	ТЗ.Колонки.Добавить("ТипРегламента");
	ТЗ.Колонки.Добавить("КНД");
	ТЗ.Колонки.Добавить("НаправлениеЭДО");
	ТЗ.Колонки.Добавить("НомерДокумента");
	ТЗ.Колонки.Добавить("ДатаДокумента");
	ТЗ.Колонки.Добавить("НомерДокументаОснования");
	ТЗ.Колонки.Добавить("ДатаДокументаОснования");
	ТЗ.Колонки.Добавить("ИмяФайлаДанных");
	ТЗ.Колонки.Добавить("ИмяФайлаПодписи");
	ТЗ.Колонки.Добавить("РазмерФайлаДанных");
	ТЗ.Колонки.Добавить("РазмерФайлаПодписи");
	ТЗ.Колонки.Добавить("КНДПодтверждения");
	ТЗ.Колонки.Добавить("ИмяФайлаДанныхПодтверждения");
	ТЗ.Колонки.Добавить("ИмяФайлаПодписиПодтверждения");
	ТЗ.Колонки.Добавить("РазмерФайлаДанныхПодтверждения");
	ТЗ.Колонки.Добавить("РазмерФайлаПодписиПодтверждения");
	
	Возврат ТЗ;
	
КонецФункции

// Возвращает данные объектов учета по электронным документам. Используется в выгрузке для ФНС.
//
// Параметры:
//  ЭлектронныеДокументы - Массив - Электронные документы, по которым нужны данные.
//
// Возвращаемое значение:
//  ТаблицаЗначений - Данные объектов учета электронных документов:
//   * ОбъектУчета - ОпределяемыйТип.ОснованияЭлектронныхДокументовЭДО
//   * ВидДокумента - СправочникСсылка.ВидыДокументовЭДО
//   * ЭлектронныйДокумент - ДокументСсылка.ЭлектронныйДокументВходящийЭДО,
//                           ДокументСсылка.ЭлектронныйДокументИсходящийЭДО
//   * НомерДоговора - Строка
//   * ДатаДоговора - Дата
//
Функция ДанныеОбъектовУчетаДляВыгрузкиЭДДляФНС(Знач ЭлектронныеДокументы)
	
	ДанныеОбъектовУчета = ИнтеграцияЭДО.ОбъектыУчетаАктуальныхЭлектронныхДокументов(ЭлектронныеДокументы);
	ДанныеОбъектовУчета.Колонки.Добавить("НомерДоговора", Новый ОписаниеТипов("Строка"));
	ДанныеОбъектовУчета.Колонки.Добавить("ДатаДоговора", Новый ОписаниеТипов("Дата"));
	
	ОбъектыУчета = ДанныеОбъектовУчета.ВыгрузитьКолонку("ОбъектУчета");
	ДанныеДокументовОснований = ИнтеграцияЭДО.ПолучитьНомерДатаДоговораДокументов(ОбъектыУчета);
	
	Если ТипЗнч(ДанныеДокументовОснований) = Тип("Соответствие") Тогда
		
		Для каждого ДанныеОбъектаУчета Из ДанныеОбъектовУчета Цикл
			ДанныеДокументаОснования = ДанныеДокументовОснований.Получить(ДанныеОбъектаУчета.ОбъектУчета);
			Если ТипЗнч(ДанныеДокументаОснования) <> Тип("Структура") Тогда
				ДанныеДокументаОснования = Новый Структура;
			КонецЕсли;
			ДанныеДокументаОснования.Свойство("НомерДоговора", ДанныеОбъектаУчета.НомерДоговора);
			ДанныеДокументаОснования.Свойство("ДатаДоговора", ДанныеОбъектаУчета.ДатаДоговора);
		КонецЦикла;
		
	КонецЕсли;
	
	ДанныеОбъектовУчета.Индексы.Добавить("ЭлектронныйДокумент");
	
	Возврат ДанныеОбъектовУчета;
	
КонецФункции

// Формирует файл описания выгрузки электронных документов для ФНС по заполненной таблице описи, сохраняет в каталог.
//
// Параметры:
//  Организация - ОпределяемыйТип.Организация - Организация, по документам которой составлена опись.
//  ТЗОписи - ТаблицаЗначений - См. ИнтерфейсДокументовЭДО.НоваяТаблицаОписиВыгрузкиЭДДляФНС().
//  ИмяФайла - Строка - Адрес, куда нужно сохранить файл.
//
// Возвращаемое значение:
//  Булево - Истина, если файл сформирован.
//
Функция СформироватьФайлОписанияВыгрузкиЭДДляФНС(Знач Организация, Знач ТЗОписи, Знач ИмяФайла)
	
	Ошибки = Неопределено; // Служебная переменная для хранения списка возникших ошибок
	
	ИмяРеквизитаНаименование = ЭлектронноеВзаимодействие.ИмяНаличиеОбъектаРеквизитаВПрикладномРешении("НаименованиеКонтрагентаДляСообщенияПользователю");
	ИмяРеквизитаИНН = ЭлектронноеВзаимодействие.ИмяНаличиеОбъектаРеквизитаВПрикладномРешении("ИННКонтрагента");
	ИмяРеквизитаКПП = ЭлектронноеВзаимодействие.ИмяНаличиеОбъектаРеквизитаВПрикладномРешении("КППКонтрагента");
	
	ШаблонСтрокиПолучаемыхРеквизитов = "%1, %2, %3";
	ИменаПолучаемыхРеквизитов = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		ШаблонСтрокиПолучаемыхРеквизитов, ИмяРеквизитаНаименование, ИмяРеквизитаИНН, ИмяРеквизитаКПП);
	
	РеквизитыОрганизации = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Организация, ИменаПолучаемыхРеквизитов);
	
	ПространствоИменСхемы = "Upload2Statements";
	
	Попытка
		
		Файл = РаботаСФайламиБЭД.ПолучитьОбъектТипаCML("Файл", ПространствоИменСхемы);
		
		ДатаВыгрузки = ТекущаяДатаСеанса();
		РаботаСФайламиБЭД.ЗаполнитьСвойствоXDTO(Файл, "ВерсФорм", "1.03", Истина, Ошибки);
		РаботаСФайламиБЭД.ЗаполнитьСвойствоXDTO(Файл, "ДатаВыгрузки", Формат(ДатаВыгрузки, "ДФ=dd.MM.yyyy"), Истина, Ошибки);
		РаботаСФайламиБЭД.ЗаполнитьСвойствоXDTO(Файл, "ВремяВыгрузки", Формат(ДатаВыгрузки, "ДФ=HH:mm:ss"), Истина, Ошибки);
		
		СвОрганизация = РаботаСФайламиБЭД.ПолучитьОбъектТипаCML("Файл.Организация", ПространствоИменСхемы);
		РаботаСФайламиБЭД.ЗаполнитьСвойствоXDTO(СвОрганизация, "Наименование", РеквизитыОрганизации[ИмяРеквизитаНаименование], Истина, Ошибки);
		РаботаСФайламиБЭД.ЗаполнитьСвойствоXDTO(СвОрганизация, "ИНН", РеквизитыОрганизации[ИмяРеквизитаИНН], Истина, Ошибки);
		Если СтрДлина(РеквизитыОрганизации[ИмяРеквизитаИНН]) = 10 Тогда
			РаботаСФайламиБЭД.ЗаполнитьСвойствоXDTO(СвОрганизация, "КПП", РеквизитыОрганизации[ИмяРеквизитаКПП], Истина, Ошибки);
		КонецЕсли;
		РаботаСФайламиБЭД.ЗаполнитьСвойствоXDTO(Файл, "Организация", СвОрганизация, Истина, Ошибки);
		
		СвКонтрагенты = РаботаСФайламиБЭД.ПолучитьОбъектТипаCML("Файл.Контрагенты", ПространствоИменСхемы);
		ИДКонтрагентов = Новый Соответствие;
		
		Для Каждого СтрокаОписи Из ТЗОписи Цикл
			
			Если ИДКонтрагентов[СтрокаОписи.Контрагент] = Неопределено Тогда
				
				РеквизитыКонтрагента = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(СтрокаОписи.Контрагент, ИменаПолучаемыхРеквизитов);
				ИДКонтрагента = РеквизитыКонтрагента[ИмяРеквизитаИНН] + РеквизитыКонтрагента[ИмяРеквизитаКПП];
				ИДКонтрагентов.Вставить(СтрокаОписи.Контрагент, ИДКонтрагента);
				
				СвКонтрагент = РаботаСФайламиБЭД.ПолучитьОбъектТипаCML("Файл.Контрагенты.Контрагент", ПространствоИменСхемы);
				РаботаСФайламиБЭД.ЗаполнитьСвойствоXDTO(СвКонтрагент, "Идентификатор", ИДКонтрагента, Истина, Ошибки);
				РаботаСФайламиБЭД.ЗаполнитьСвойствоXDTO(СвКонтрагент, "Наименование", РеквизитыКонтрагента[ИмяРеквизитаНаименование], Истина, Ошибки);
				РаботаСФайламиБЭД.ЗаполнитьСвойствоXDTO(СвКонтрагент, "ИНН", РеквизитыКонтрагента[ИмяРеквизитаИНН], Истина, Ошибки);
				Если СтрДлина(РеквизитыКонтрагента[ИмяРеквизитаИНН]) = 10 Тогда
					РаботаСФайламиБЭД.ЗаполнитьСвойствоXDTO(СвКонтрагент, "КПП", РеквизитыКонтрагента[ИмяРеквизитаКПП], Истина, Ошибки);
				КонецЕсли;
				СвКонтрагенты.Контрагент.Добавить(СвКонтрагент);
				
			КонецЕсли;
			
			СвДокумент = РаботаСФайламиБЭД.ПолучитьОбъектТипаCML("Файл.Документ", ПространствоИменСхемы);
			
			КодВидаДокументаБРО = КодВидаДокументаБРОПоСвойствамЭДО(СтрокаОписи.ТипРегламента,
				СтрокаОписи.ТипДокументаЭДО, СтрокаОписи.ТипЭлементаРегламента);
			РаботаСФайламиБЭД.ЗаполнитьСвойствоXDTO(СвДокумент, "Вид", КодВидаДокументаБРО, Истина, Ошибки);
			РаботаСФайламиБЭД.ЗаполнитьСвойствоXDTO(СвДокумент, "КНД", СтрокаОписи.КНД, Истина, Ошибки);
			Направление = ?(СтрокаОписи.НаправлениеЭДО = Перечисления.НаправленияЭДО.Входящий, "0", "1");
			РаботаСФайламиБЭД.ЗаполнитьСвойствоXDTO(СвДокумент, "Направление", Направление, Истина, Ошибки);
			РаботаСФайламиБЭД.ЗаполнитьСвойствоXDTO(СвДокумент, "Номер", СтрокаОписи.НомерДокумента, Истина, Ошибки);
			ДатаДок = Формат(СтрокаОписи.ДатаДокумента, "ДФ=dd.MM.yyyy");
			РаботаСФайламиБЭД.ЗаполнитьСвойствоXDTO(СвДокумент, "Дата", ДатаДок, Истина, Ошибки);
			Если ЗначениеЗаполнено(СтрокаОписи.ДатаДокументаОснования)
				И ЗначениеЗаполнено(СтрокаОписи.НомерДокументаОснования) Тогда
				РаботаСФайламиБЭД.ЗаполнитьСвойствоXDTO(СвДокумент, "НомерДокОсн", СтрокаОписи.НомерДокументаОснования, , Ошибки);
				ДатаДок = Формат(СтрокаОписи.ДатаДокументаОснования, "ДФ=dd.MM.yyyy");
				РаботаСФайламиБЭД.ЗаполнитьСвойствоXDTO(СвДокумент, "ДатаДокОсн", ДатаДок, , Ошибки);
			КонецЕсли;
			РаботаСФайламиБЭД.ЗаполнитьСвойствоXDTO(СвДокумент, "ИдКонтрагента", ИДКонтрагентов[СтрокаОписи.Контрагент], Истина, Ошибки);
			
			СвФайл = РаботаСФайламиБЭД.ПолучитьОбъектТипаCML("Файл.Документ.ФайлДок", ПространствоИменСхемы);
			РаботаСФайламиБЭД.ЗаполнитьСвойствоXDTO(СвФайл, "Имя", СтрокаОписи.ИмяФайлаДанных, Истина, Ошибки);
			РаботаСФайламиБЭД.ЗаполнитьСвойствоXDTO(СвФайл, "Размер", СтрокаОписи.РазмерФайлаДанных, Истина, Ошибки);
			РаботаСФайламиБЭД.ЗаполнитьСвойствоXDTO(СвФайл, "КНД", СтрокаОписи.КНД, Истина, Ошибки);
			РаботаСФайламиБЭД.ЗаполнитьСвойствоXDTO(СвДокумент, "ФайлДок", СвФайл, Истина, Ошибки);
			
			СвФайл = РаботаСФайламиБЭД.ПолучитьОбъектТипаCML("Файл.Документ.ФайлЭЦП", ПространствоИменСхемы);
			РаботаСФайламиБЭД.ЗаполнитьСвойствоXDTO(СвФайл, "Имя", СтрокаОписи.ИмяФайлаПодписи, Истина, Ошибки);
			РаботаСФайламиБЭД.ЗаполнитьСвойствоXDTO(СвФайл, "Размер", СтрокаОписи.РазмерФайлаПодписи, Истина, Ошибки);
			РаботаСФайламиБЭД.ЗаполнитьСвойствоXDTO(СвДокумент, "ФайлЭЦП", СвФайл, Истина, Ошибки);
			
			Если ЗначениеЗаполнено(СтрокаОписи.ИмяФайлаДанныхПодтверждения) Тогда
				
				СвФайл = РаботаСФайламиБЭД.ПолучитьОбъектТипаCML("Файл.Документ.ФайлДокПодтверждения", ПространствоИменСхемы);
				РаботаСФайламиБЭД.ЗаполнитьСвойствоXDTO(СвФайл, "Имя", СтрокаОписи.ИмяФайлаДанныхПодтверждения, Истина, Ошибки);
				РаботаСФайламиБЭД.ЗаполнитьСвойствоXDTO(СвФайл, "Размер", СтрокаОписи.РазмерФайлаДанныхПодтверждения, Истина, Ошибки);
				РаботаСФайламиБЭД.ЗаполнитьСвойствоXDTO(СвФайл, "КНД", СтрокаОписи.КНДПодтверждения, Истина, Ошибки);
				РаботаСФайламиБЭД.ЗаполнитьСвойствоXDTO(СвДокумент, "ФайлДокПодтверждения", СвФайл, , Ошибки);
				
				СвФайл = РаботаСФайламиБЭД.ПолучитьОбъектТипаCML("Файл.Документ.ФайлЭЦППодтверждения", ПространствоИменСхемы);
				РаботаСФайламиБЭД.ЗаполнитьСвойствоXDTO(СвФайл, "Имя", СтрокаОписи.ИмяФайлаПодписиПодтверждения, Истина, Ошибки);
				РаботаСФайламиБЭД.ЗаполнитьСвойствоXDTO(СвФайл, "Размер", СтрокаОписи.РазмерФайлаПодписиПодтверждения, Истина, Ошибки);
				РаботаСФайламиБЭД.ЗаполнитьСвойствоXDTO(СвДокумент, "ФайлЭЦППодтверждения", СвФайл, , Ошибки);
				
			КонецЕсли;
			
			Файл.Документ.Добавить(СвДокумент);
			
		КонецЦикла;
		
		РаботаСФайламиБЭД.ЗаполнитьСвойствоXDTO(Файл, "Контрагенты", СвКонтрагенты, Истина, Ошибки);
		
		Файл.Проверить();
		Если ЗначениеЗаполнено(Ошибки) Тогда
			ТекстОшибки = ОбщегоНазначенияБЭД.СоединитьОшибки(Ошибки);
			ВызватьИсключение ТекстОшибки;
		КонецЕсли;
		
		РаботаСФайламиБЭД.СохранитьXDTO(Файл, ИмяФайла, Ложь, "windows-1251");
		
		Возврат Истина;
		
	Исключение
		
		ТекстОшибки = ОбщегоНазначенияБЭД.СоединитьОшибки(Ошибки);
		ТекстСообщения = ?(ЗначениеЗаполнено(ТекстОшибки), ТекстОшибки, КраткоеПредставлениеОшибки(ИнформацияОбОшибке()));
		ТекстСообщения = НСтр("ru = 'Не удалось создать файл описания выгрузки:'") + Символы.ПС + ТекстСообщения;
		ЭлектронноеВзаимодействие.ОбработатьОшибку(НСтр("ru = 'Формирование выгрузки ЭД в 1С-Отчетность'"),
			ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()), ТекстСообщения);
		
		Возврат Ложь;
		
	КонецПопытки;
	
КонецФункции

// Возвращает типы документов ЭДО, подходящих для выгрузки для предоставления в ФНС.
//
// Возвращаемое значение:
//  Массив Из ПеречислениеСсылка.ТипыДокументовЭДО - Типы документов ЭДО, подходящие для выгрузки в ФНС
//
Функция ТипыДокументовЭДОВыгрузкиДляФНС()

	МассивТипов = Новый Массив;
	МассивТипов.Добавить(Перечисления.ТипыДокументовЭДО.ТоварнаяНакладная);
	МассивТипов.Добавить(Перечисления.ТипыДокументовЭДО.АктВыполненныхРабот);
	МассивТипов.Добавить(Перечисления.ТипыДокументовЭДО.АктНаПередачуПрав);
	МассивТипов.Добавить(Перечисления.ТипыДокументовЭДО.СчетФактура);
	МассивТипов.Добавить(Перечисления.ТипыДокументовЭДО.КорректировочныйСчетФактура);
	МассивТипов.Добавить(Перечисления.ТипыДокументовЭДО.СоглашениеОбИзмененииСтоимости);
	МассивТипов.Добавить(Перечисления.ТипыДокументовЭДО.УПД);
	МассивТипов.Добавить(Перечисления.ТипыДокументовЭДО.УКД);
	МассивТипов.Добавить(Перечисления.ТипыДокументовЭДО.АктОРасхождениях);
	МассивТипов.Добавить(Перечисления.ТипыДокументовЭДО.АктСверкиВзаиморасчетов);
	МассивТипов.Добавить(Перечисления.ТипыДокументовЭДО.АктПриемкиСтроительныхРаботУслуг);
	Возврат МассивТипов;

КонецФункции

#КонецОбласти

// Возвращает код вида документа по свойствам ЭДО
// 
// Параметры:
// 	ТипРегламента - ПеречислениеСсылка.ТипыРегламентовЭДО
// 	ТипДокумента - ПеречислениеСсылка.ТипыДокументовЭДО
// 	ТипЭлементаРегламента - ПеречислениеСсылка.ТипыЭлементовРегламентаЭДО
// Возвращаемое значение:
// 	- Строка
// 	- Неопределено
//
Функция КодВидаДокументаБРОПоСвойствамЭДО(ТипРегламента, ТипДокумента, ТипЭлементаРегламента)
	
	КодВидДокумента = Неопределено;
	Если ТипДокумента = Перечисления.ТипыДокументовЭДО.СчетФактура
		Или ТипДокумента = Перечисления.ТипыДокументовЭДО.УПД Тогда
		Если ТипРегламента = Перечисления.ТипыРегламентовЭДО.Формализованный Тогда
			КодВидДокумента = "01";
		Иначе
			КодВидДокумента = "07";
		КонецЕсли;
		
	ИначеЕсли ТипДокумента = Перечисления.ТипыДокументовЭДО.АктВыполненныхРабот Тогда
		Если ТипЭлементаРегламента = Перечисления.ТипыЭлементовРегламентаЭДО.ИнформацияОтправителя Тогда
			КодВидДокумента = "02";
		Иначе
			КодВидДокумента = "06";
		КонецЕсли;
		
	ИначеЕсли ТипДокумента = Перечисления.ТипыДокументовЭДО.ТоварнаяНакладная Тогда
		Если ТипЭлементаРегламента = Перечисления.ТипыЭлементовРегламентаЭДО.ИнформацияОтправителя Тогда
			КодВидДокумента = "03";
		Иначе
			КодВидДокумента = "05";
		КонецЕсли;
		
	ИначеЕсли ТипДокумента = Перечисления.ТипыДокументовЭДО.КорректировочныйСчетФактура
		Или ТипДокумента = Перечисления.ТипыДокументовЭДО.УКД Тогда
		Если ТипРегламента = Перечисления.ТипыРегламентовЭДО.Формализованный Тогда
			КодВидДокумента = "04";
		Иначе
			КодВидДокумента = "08";
		КонецЕсли;
		
	ИначеЕсли ТипДокумента = Перечисления.ТипыДокументовЭДО.СоглашениеОбИзмененииСтоимости Тогда
		
		КодВидДокумента = "08";
		
	ИначеЕсли ТипДокумента = Перечисления.ТипыДокументовЭДО.АктНаПередачуПрав Тогда
		
		КодВидДокумента = "07";
		
	ИначеЕсли ТипДокумента = Перечисления.ТипыДокументовЭДО.АктОРасхождениях Тогда
		
		КодВидДокумента = "09";
	ИначеЕсли ТипДокумента = Перечисления.ТипыДокументовЭДО.АктСверкиВзаиморасчетов Тогда
		Если ТипЭлементаРегламента = Перечисления.ТипыЭлементовРегламентаЭДО.ИнформацияОтправителя Тогда
			КодВидДокумента = "10";
		Иначе
			КодВидДокумента = "11";
		КонецЕсли;
	ИначеЕсли ТипДокумента = Перечисления.ТипыДокументовЭДО.АктПриемкиСтроительныхРаботУслуг Тогда
		Если ТипЭлементаРегламента = Перечисления.ТипыЭлементовРегламентаЭДО.ИнформацияОтправителя Тогда
			КодВидДокумента = "12";
		Иначе
			КодВидДокумента = "13";
		КонецЕсли;
	КонецЕсли;
	
	Возврат КодВидДокумента;
	
КонецФункции

#КонецОбласти