﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2023, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Вызывается в форме добавления заявления на новый сертификат для заполнения реквизитов организации и при ее выборе.
//
// Параметры:
//  Параметры - Структура:
//
//    * ТипОрганизации - ОписаниеТипов - возвращаемое значение. Содержит ссылочные типы, из которых
//                       можно сделать выбор. Начальное значение ОпределяемыйТип.Организация.
//                     - Неопределено  - возвращаемое значение. Выбор организации не поддерживается.
//
//    * Организация - СправочникСсылка - организация из ТипОрганизации, которую нужно заполнить.
//                    Если организация уже заполнена, требуется перезаполнить ее свойства - например,
//                    при повтором вызове, когда пользователь выбрал другую организацию.
//                  - Неопределено - если ТипОрганизации не настроен.
//                    Пользователю недоступен выбор организации.
//
//    * ЭтоИндивидуальныйПредприниматель - Булево - возвращаемое значение:
//                    Ложь   - начальное значение - указанная организация является юридическим лицом;
//                    Истина - указанная организация является индивидуальным предпринимателем.
//
//    * ЭтоИностраннаяОрганизация - Булево - возвращаемое значение, когда Истина ОГРН не заполняется.
//                                - Неопределено - значение не указано, не изменять имеющееся значение.
//
//    * НаименованиеСокращенное  - Строка - возвращаемое значение. Краткое наименование организации.
//                               - Неопределено - значение не указано, не изменять имеющееся значение.
//
//    * НаименованиеПолное       - Строка - возвращаемое значение. Краткое наименование организации.
//                               - Неопределено - значение не указано, не изменять имеющееся значение.
//
//    * ИНН                      - Строка - возвращаемое значение. ИНН организации.
//                               - Неопределено - значение не указано, не изменять имеющееся значение.
//
//    * КПП                      - Строка - возвращаемое значение. КПП организации.
//                               - Неопределено - значение не указано, не изменять имеющееся значение.
//
//    * ОГРН                     - Строка - возвращаемое значение. ОГРН организации (кроме иностранных).
//                               - Неопределено - значение не указано, не изменять имеющееся значение.
//
//    * РасчетныйСчет            - Строка - возвращаемое значение. Основной расчетный счет организации для договора.
//                               - Неопределено - значение не указано, не изменять имеющееся значение.
//
//    * БИК                      - Строка - возвращаемое значение. БИК банка расчетного счета.
//                               - Неопределено - значение не указано, не изменять имеющееся значение.
//
//    * КорреспондентскийСчет    - Строка - возвращаемое значение. Корреспондентский счет банка расчетного счета.
//                               - Неопределено - значение не указано, не изменять имеющееся значение.
//
//    * Телефон                  - Строка - возвращаемое значение. Телефон организации в формате JSON, как его
//                                 возвращает функция КонтактнаяИнформацияОбъекта общего модуля УправлениеКонтактнойИнформацией.
//
//    * ЮридическийАдрес - Строка - возвращаемое значение. Юридический адрес организации в формате JSON, как его
//                         возвращает функция КонтактнаяИнформацияОбъекта общего модуля УправлениеКонтактнойИнформацией.
//                       - Неопределено - значение не указано, не изменять имеющееся значение.
//
Процедура ПриЗаполненииРеквизитовОрганизацииВЗаявленииНаСертификат(Параметры) Экспорт
	
	// БольничнаяАптека
	Если Не ЗначениеЗаполнено(Параметры.Организация) Тогда
		ОрганизацияПоУмолчанию = Справочники.Организации.ОрганизацияПоУмолчанию();
		Если ЗначениеЗаполнено(ОрганизацияПоУмолчанию) Тогда
			Параметры.Организация = ОрганизацияПоУмолчанию;
		КонецЕсли;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Параметры.Организация) Тогда
		Возврат; // Реквизиты организации нельзя заполнить, если организация не выбрана.
	КонецЕсли;
	
	Если ТипЗнч(Параметры.Организация) <> Тип("СправочникСсылка.Организации") Тогда
		Возврат;
	КонецЕсли;
	
	РеквизитыОрганизации = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Параметры.Организация, "ЮрФизЛицо, ИндивидуальныйПредприниматель, ОГРН");
	Параметры.ЭтоИндивидуальныйПредприниматель = РеквизитыОрганизации.ЮрФизЛицо = Перечисления.ЮрФизЛицо.ИндивидуальныйПредприниматель;
	
	ДанныеОбОрганизации = ФормированиеПечатныхФорм.СведенияОЮрФизЛице(Параметры.Организация, ТекущаяДатаСеанса());
	Параметры.НаименованиеСокращенное = ДанныеОбОрганизации.СокращенноеНаименование;
	Параметры.НаименованиеПолное      = ДанныеОбОрганизации.ПолноеНаименование;
	Параметры.ИНН                     = ДанныеОбОрганизации.ИНН;
	Параметры.КПП                     = ДанныеОбОрганизации.КПП;
	Параметры.ОГРН                    = РеквизитыОрганизации.ОГРН;
	Параметры.РасчетныйСчет           = ДанныеОбОрганизации.НомерСчета;
	Параметры.БИК                     = ДанныеОбОрганизации.БИК;
	Параметры.КорреспондентскийСчет   = ДанныеОбОрганизации.КоррСчет;
	
	//Заполним контактную информацию
	Если Параметры.ЭтоИндивидуальныйПредприниматель Тогда
		
		ВидыКИ = Новый Массив;
		ВидыКИ.Добавить(Справочники.ВидыКонтактнойИнформации.АдресПоПропискеФизическиеЛица);
		ВидыКИ.Добавить(Справочники.ВидыКонтактнойИнформации.ТелефонДомашнийФизическиеЛица);
		
		Объекты = Новый Массив();
		Объекты.Добавить(РеквизитыОрганизации.ИндивидуальныйПредприниматель);
		КонтактнаяИнформация = УправлениеКонтактнойИнформацией.КонтактнаяИнформацияОбъектов(Объекты, , ВидыКИ, ТекущаяДатаСеанса());
		
		ВидКонтактнойИнформации = Справочники.ВидыКонтактнойИнформации.АдресПоПропискеФизическиеЛица;
		Строка = КонтактнаяИнформация.Найти(ВидКонтактнойИнформации, "Вид");
		Если Строка <> Неопределено Тогда
			Параметры.ЮридическийАдрес = Строка.Значение;
			Параметры.ФактическийАдрес = Строка.Значение;
		КонецЕсли;
		
		ВидКонтактнойИнформации = Справочники.ВидыКонтактнойИнформации.ТелефонДомашнийФизическиеЛица;
		Строка = КонтактнаяИнформация.Найти(ВидКонтактнойИнформации, "Вид");
		Если Строка <> Неопределено Тогда
			Параметры.Телефон = Строка.Значение;
		КонецЕсли;
		
	Иначе
		
		ВидыКИ = Новый Массив;
		ВидыКИ.Добавить(Справочники.ВидыКонтактнойИнформации.ЮрАдресОрганизации);
		ВидыКИ.Добавить(Справочники.ВидыКонтактнойИнформации.ФактАдресОрганизации);
		ВидыКИ.Добавить(Справочники.ВидыКонтактнойИнформации.ТелефонОрганизации);
		
		Объекты = Новый Массив();
		Объекты.Добавить(Параметры.Организация);
		КонтактнаяИнформация = УправлениеКонтактнойИнформацией.КонтактнаяИнформацияОбъектов(Объекты, , ВидыКИ, ТекущаяДатаСеанса());
		
		ВидКонтактнойИнформации = Справочники.ВидыКонтактнойИнформации.ЮрАдресОрганизации;
		Строка = КонтактнаяИнформация.Найти(ВидКонтактнойИнформации, "Вид");
		Если Строка <> Неопределено Тогда
			Параметры.ЮридическийАдрес = Строка.Значение;
		КонецЕсли;
		
		ВидКонтактнойИнформации = Справочники.ВидыКонтактнойИнформации.ФактАдресОрганизации;
		Строка = КонтактнаяИнформация.Найти(ВидКонтактнойИнформации, "Вид");
		Если Строка <> Неопределено Тогда
			Параметры.ФактическийАдрес = Строка.Значение;
		КонецЕсли;
		
		ВидКонтактнойИнформации = Справочники.ВидыКонтактнойИнформации.ТелефонОрганизации;
		Строка = КонтактнаяИнформация.Найти(ВидКонтактнойИнформации, "Вид");
		Если Строка <> Неопределено Тогда
			Параметры.Телефон = Строка.Значение;
		КонецЕсли;
		
	КонецЕсли;
	// Конец БольничнаяАптека
	
КонецПроцедуры

// Вызывается в форме добавления заявления на новый сертификат для заполнении реквизитов владельца и при его выборе.
//
// Параметры:
//  Параметры - Структура:
//    * ЭтоФизическоеЛицо - Булево - если Истина, тогда заявление заполняется для физического лица, иначе для организации.
// 
//    * Организация  - СправочникСсылка - выбранная организация из ТипОрганизации, на которую оформляется сертификат.
//                   - Неопределено - если ТипОрганизации не настроен или составной и тип организации не выбран.
//
//    * ТипВладельца  - ОписаниеТипов - возвращаемое значение. Содержит ссылочные типы, из которых можно сделать выбор.
//                    - Неопределено  - возвращаемое значение. Выбор владельца не поддерживается.
//
//    * Сотрудник    - СправочникСсылка - возвращаемое значение. Владелец сертификата из ТипВладельца,
//                     которого нужно заполнить. Если уже заполнен (выбран пользователем), его не следует изменять.
//                   - Неопределено - если ТипВладельца не определен, тогда реквизит не доступен пользователю.
//
//    * Директор     - СправочникСсылка - возвращаемое значение. Директор из ТипВладельца, который может быть
//                     выбран, как владелец сертификата. Не учитывается, если заявление для ИП или физического лица.
//                   - Неопределено - начальное значение - скрыть директора из списка выбора.
//
//    * ГлавныйБухгалтер - СправочникСсылка - возвращаемое значение. Главный бухгалтер из ТипВладельца, который может
//                     быть выбран как владелец сертификата. Не учитывается, если заявление для ИП или физического лица.
//                   - Неопределено - начальное значение - скрыть главного бухгалтера из списка выбора.
//
//    * Пользователь - СправочникСсылка.Пользователи - возвращаемое значение. Пользователь - владелец сертификата.
//                     В общем случае может быть не заполнено. Рекомендуется заполнить, если есть возможность.
//                     Записывается в сертификат в поле Пользователь, может быть изменено в дальнейшем.
//
//    * Фамилия            - Строка - возвращаемое значение. Фамилия сотрудника.
//                         - Неопределено - значение не указано, не изменять имеющееся значение.
//
//    * Имя                - Строка - возвращаемое значение. Имя сотрудника.
//                         - Неопределено - значение не указано, не изменять имеющееся значение.
//
//    * Отчество           - Строка - возвращаемое значение. Отчество сотрудника.
//                         - Неопределено - значение не указано, не изменять имеющееся значение.
//
//    * ДатаРождения       - Дата   - возвращаемое значение. Дата рождения сотрудника.
//                         - Неопределено - значение не указано, не изменять имеющееся значение.
//
//    * Пол                - Строка - возвращаемое значение. Пол сотрудника "Мужской" или "Женский".
//                         - Неопределено - значение не указано, не изменять имеющееся значение.
//
//    * МестоРождения      - Строка - возвращаемое значение. Описание места рождения сотрудника.
//                         - Неопределено - значение не указано, не изменять имеющееся значение.
//
//    * Гражданство        - СправочникСсылка.СтраныМира - возвращаемое значение. Гражданство сотрудника.
//                         - Неопределено - значение не указано, не изменять имеющееся значение.
//
//    * ИНН                - Строка - возвращаемое значение. ИНН физического лица.
//                           Учитывается только в заявлении для физического лица.
//                         - Неопределено - значение не указано, не изменять имеющееся значение.
//
//    * СтраховойНомерПФР  - Строка - возвращаемое значение. СНИЛС сотрудника.
//                         - Неопределено - значение не указано, не изменять имеющееся значение.
//
//    * Должность          - Строка - возвращаемое значение. Должность сотрудника в организации.
//                           Не учитывается, если заявление для ИП или физического лица.
//                         - Неопределено - значение не указано, не изменять имеющееся значение.
//
//    * Подразделение      - Строка - возвращаемое значение. Обособленное подразделение организации, в котором
//                           работает сотрудник. Не учитывается, если заявление для ИП или физического лица.
//                         - Неопределено - значение не указано, не изменять имеющееся значение.
//
//
//    * ДокументВид        - Строка - возвращаемое значение. Строки "21" или "91". 21 - паспорт гражданина РФ,
//                           91 - иной документ, предусмотренный законодательством РФ (по СПДУЛ).
//                         - Неопределено - значение не указано, не изменять имеющееся значение.
//
//    * ДокументНомер      - Строка - возвращаемое значение. Номер документа сотрудника (серия и
//                           номер для паспорта гражданина РФ).
//                         - Неопределено - значение не указано, не изменять имеющееся значение.
//
//    * ДокументКемВыдан   - Строка - возвращаемое значение. Кем выдан документ сотрудника.
//                         - Неопределено - значение не указано, не изменять имеющееся значение.
//
//    * ДокументКодПодразделения - Строка - возвращаемое значение. Код подразделения, если вид документа 21.
//                               - Неопределено - значение не указано, не изменять имеющееся значение.
//
//    * ДокументДатаВыдачи - Дата   - возвращаемое значение. Дата выдачи документа сотрудника.
//                         - Неопределено - значение не указано, не изменять имеющееся значение.
//
//    * АдресРегистрации   - Строка - возвращаемое значение. Адрес постоянной или временной регистрации
//                           физического лица (минимум регион, населенный пункт) в формате JSON, как его возвращает
//                           функция КонтактнаяИнформацияОбъекта общего модуля УправлениеКонтактнойИнформацией.
//                           Учитывается только в заявлении для физического лица.
//                         - Неопределено - значение не указано, не изменять имеющееся значение.
//
//    * ЭлектроннаяПочта   - Строка - возвращаемое значение. Адрес электронной почты сотрудника в формате JSON, как его
//                           возвращает функция КонтактнаяИнформацияОбъекта общего модуля УправлениеКонтактнойИнформацией.
//                         - Неопределено - значение не указано, не изменять имеющееся значение.
//
//    * Телефон            - Строка - возвращаемое значение. Телефон физического лица в формате JSON, как его
//                           возвращает функция КонтактнаяИнформацияОбъекта общего модуля УправлениеКонтактнойИнформацией.
//                           Учитывается только в заявлении для физического лица.
//
//
Процедура ПриЗаполненииРеквизитовВладельцаВЗаявленииНаСертификат(Параметры) Экспорт
	
	// БольничнаяАптека
	МассивТипов = Новый Массив;
	МассивТипов.Добавить(Тип("СправочникСсылка.ФизическиеЛица"));
	
	Параметры.ТипВладельца = Новый ОписаниеТипов(МассивТипов);
	
	РеквизитыОрганизации = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Параметры.Организация, "ЮрФизЛицо, ИндивидуальныйПредприниматель");
	
	ОтветственныеЛица = ОтветственныеЛицаСервер.ПолучитьОтветственныеЛицаОрганизации(Параметры.Организация, ТекущаяДатаСеанса());
	
	Если РеквизитыОрганизации.ЮрФизЛицо = Перечисления.ЮрФизЛицо.ИндивидуальныйПредприниматель Тогда
		Если Не ЗначениеЗаполнено(Параметры.Сотрудник) Тогда
			Параметры.Сотрудник = РеквизитыОрганизации.ИндивидуальныйПредприниматель;
		КонецЕсли;
	Иначе
		Параметры.Директор         = ОтветственныеЛица.Руководитель;
		Параметры.ГлавныйБухгалтер = ОтветственныеЛица.ГлавныйБухгалтер;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Параметры.Сотрудник) Тогда
		// Начальное значение для сотрудника.
		Если ЗначениеЗаполнено(Параметры.Директор) Тогда
			Параметры.Сотрудник = Параметры.Директор;
		ИначеЕсли ЗначениеЗаполнено(Параметры.ГлавныйБухгалтер) Тогда
			Параметры.Сотрудник = Параметры.ГлавныйБухгалтер;
		КонецЕсли;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Параметры.Сотрудник) Тогда
		Возврат; // Поля можно заполнить только, если сотрудник указан.
	КонецЕсли;
	
	РеквизитыВладельца = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Параметры.Сотрудник, "Наименование, ДатаРождения, Пол, ИНН, СНИЛС");
	
	Если Параметры.Сотрудник = Параметры.Директор Тогда
		Параметры.Должность = ОтветственныеЛица.РуководительДолжность;
	ИначеЕсли Параметры.Сотрудник = Параметры.ГлавныйБухгалтер Тогда
		Параметры.Должность = ОтветственныеЛица.ГлавныйБухгалтерДолжность;
	КонецЕсли;
	
	Параметры.ДатаРождения      = РеквизитыВладельца.ДатаРождения;
	Параметры.ИНН               = РеквизитыВладельца.ИНН;
	Параметры.СтраховойНомерПФР = РеквизитыВладельца.СНИЛС;
	Параметры.Пол = ?(ЗначениеЗаполнено(РеквизитыВладельца.Пол), ОбщегоНазначения.ИмяЗначенияПеречисления(РеквизитыВладельца.Пол), "");
	
	// ФИО
	ЗаполнитьЗначенияСвойств(Параметры, ФизическиеЛицаКлиентСервер.ЧастиИмени(РеквизитыВладельца.Наименование));
	
	// Документ, удостоверяющий личность
	ДокументФизическогоЛица = ДокументУдостоверяющийЛичностьФизлица(Параметры.Сотрудник);
	
	ВидДокумента = ОбщегоНазначенияКлиентСервер.СвойствоСтруктуры(ДокументФизическогоЛица, "ВидДокумента");
	
	Если ВидДокумента = Справочники.ВидыДокументовФизическихЛиц.ПаспортРФ Тогда
		Параметры.ДокументВид = "21";
		Параметры.Гражданство = Справочники.СтраныМира.Россия;
	Иначе
		Параметры.ДокументВид = "91";
	КонецЕсли;
	
	Параметры.ДокументКемВыдан         = ОбщегоНазначенияКлиентСервер.СвойствоСтруктуры(ДокументФизическогоЛица, "КемВыдан");
	Параметры.ДокументДатаВыдачи       = ОбщегоНазначенияКлиентСервер.СвойствоСтруктуры(ДокументФизическогоЛица, "ДатаВыдачи");
	Параметры.ДокументКодПодразделения = ОбщегоНазначенияКлиентСервер.СвойствоСтруктуры(ДокументФизическогоЛица, "КодПодразделения");
	Параметры.ДокументНомер            = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru = '%1 %2'"),
		ОбщегоНазначенияКлиентСервер.СвойствоСтруктуры(ДокументФизическогоЛица, "Серия"),
		ОбщегоНазначенияКлиентСервер.СвойствоСтруктуры(ДокументФизическогоЛица, "Номер"));
	
	Объекты = Новый Массив;
	Объекты.Добавить(Параметры.Сотрудник);
	
	ВидыКИ = Новый Массив;
	ВидыКИ.Добавить(УправлениеКонтактнойИнформацией.ВидКонтактнойИнформацииПоИмени("EmailФизическогоЛица"));
	ВидыКИ.Добавить(УправлениеКонтактнойИнформацией.ВидКонтактнойИнформацииПоИмени("АдресПоПропискеФизическиеЛица"));
	ВидыКИ.Добавить(УправлениеКонтактнойИнформацией.ВидКонтактнойИнформацииПоИмени("ТелефонДомашнийФизическиеЛица"));
	
	КонтактнаяИнформация = УправлениеКонтактнойИнформацией.КонтактнаяИнформацияОбъектов(Объекты, , ВидыКИ, ТекущаяДатаСеанса());
	
	Строка = КонтактнаяИнформация.Найти(УправлениеКонтактнойИнформацией.ВидКонтактнойИнформацииПоИмени("EmailФизическогоЛица"), "Вид");
	Если Строка <> Неопределено Тогда
		Параметры.ЭлектроннаяПочта = Строка.Значение;
	КонецЕсли;
	
	Строка = КонтактнаяИнформация.Найти(УправлениеКонтактнойИнформацией.ВидКонтактнойИнформацииПоИмени("АдресПоПропискеФизическиеЛица"), "Вид");
	Если Строка <> Неопределено Тогда
		Параметры.АдресРегистрации = Строка.Значение;
	КонецЕсли;
	
	Строка = КонтактнаяИнформация.Найти(УправлениеКонтактнойИнформацией.ВидКонтактнойИнформацииПоИмени("ТелефонДомашнийФизическиеЛица"), "Вид");
	Если Строка <> Неопределено Тогда
		Параметры.Телефон = Строка.Значение;
	КонецЕсли;
	// Конец БольничнаяАптека
	
КонецПроцедуры

// Вызывается в форме добавления заявления на новый сертификат для заполнения реквизитов руководителя и при его выборе.
// Только для юридического лица. Для индивидуального предпринимателя и физического лица не требуется.
//
// Параметры:
//  Параметры - Структура:
//    * Организация   - СправочникСсылка - выбранная организация из ТипОрганизации, на которую оформляется сертификат.
//                    - Неопределено - если ТипОрганизации не настроен.
//
//    * ТипРуководителя - ОписаниеТипов - возвращаемое значение. Содержит ссылочные типы, из которых можно сделать выбор.
//                      - Неопределено  - возвращаемое значение. Выбор партнера не поддерживается.
//
//    * Руководитель  - СправочникСсылка - это значение из ТипРуководителя, выбранное пользователем,
//                      по которому нужно заполнить должность.
//                    - Неопределено - ТипРуководителя не определен.
//                    - ЛюбаяСсылка - возвращаемое значение. Руководитель, который будет подписывать документы.
//
//    * Представление - Строка - возвращаемое значение. Представление руководителя.
//                    - Неопределено - получить представление от значения Руководитель.
//
//    * Должность     - Строка - возвращаемое значение. Должность руководителя, который будет подписывать документы.
//                    - Неопределено - значение не указано, не изменять имеющееся значение.
//
//    * Основание     - Строка - возвращаемое значение. Основание на котором действует
//                      должностное лицо (устав, доверенность, ...).
//                    - Неопределено - значение не указано, не изменять имеющееся значение.
//
Процедура ПриЗаполненииРеквизитовРуководителяВЗаявленииНаСертификат(Параметры) Экспорт
	
	// БольничнаяАптека
	Параметры.ТипРуководителя = Новый ОписаниеТипов("СправочникСсылка.ФизическиеЛица");
	
	ОтветственныеЛица = ОтветственныеЛицаСервер.ПолучитьОтветственныеЛицаОрганизации(Параметры.Организация, ТекущаяДатаСеанса());
	
	Если Не ЗначениеЗаполнено(Параметры.Руководитель) Тогда
		Параметры.Руководитель = ОтветственныеЛица.Руководитель;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Параметры.Руководитель) Тогда
		Возврат; // Поля можно заполнить только, если руководитель указан.
	КонецЕсли;
	
	Если Параметры.Руководитель = ОтветственныеЛица.Руководитель Тогда
		Параметры.Должность = ОтветственныеЛица.РуководительДолжность;
		Параметры.Основание = НСтр("ru = 'Устав'");
	КонецЕсли;
	// Конец БольничнаяАптека
	
КонецПроцедуры

// Вызывается в форме добавления заявления на новый сертификат для заполнения реквизитов партнера и при его выборе.
//
// Параметры:
//  Параметры - Структура:
//    * ЭтоФизическоеЛицо - Булево - если Истина, тогда заявление заполняется для физического лица, иначе для организации.
//
//    * Организация   - СправочникСсылка - выбранная организация из ТипОрганизации, на которую оформляется сертификат.
//                    - Неопределено - если ТипОрганизации не настроен.
//
//    * ТипПартнера   - ОписаниеТипов - содержит ссылочные типы из которых можно сделать выбор.
//                    - Неопределено - выбор партнера не поддерживается.
//
//    * Партнер       - СправочникСсылка - это контрагент (обслуживающая организация) из ТипПартнера,
//                      выбранный пользователем, по которому нужно заполнить реквизиты, описанные ниже.
//                    - Неопределено - ТипПартнера не определен.
//                    - ЛюбаяСсылка - возвращаемое значение. Значение, сохраняемое в заявке для истории.
//
//    * Представление - Строка - возвращаемое значение. Представление партнера.
//                    - Неопределено - получить представление от значения Партнер.
//
//    * ЭтоИндивидуальныйПредприниматель - Булево - возвращаемое значение:
//                      Ложь   - начальное значение - указанный партнер является юридическим лицом,
//                      Истина - указанный партнер является индивидуальным предпринимателем.
//
//    * ИНН           - Строка - возвращаемое значение. ИНН партнера.
//                    - Неопределено - значение не указано, не изменять имеющееся значение.
//
//    * КПП           - Строка - возвращаемое значение. КПП партнера.
//                    - Неопределено - значение не указано, не изменять имеющееся значение.
//
Процедура ПриЗаполненииРеквизитовПартнераВЗаявленииНаСертификат(Параметры) Экспорт
	
	// БольничнаяАптека
	Параметры.ТипПартнера = Новый ОписаниеТипов("СправочникСсылка.Контрагенты");
	
	Если Не ЗначениеЗаполнено(Параметры.Партнер) Тогда
		Возврат; // Поля можно заполнить только, если партнер указан.
	КонецЕсли;
	
	Реквизиты = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Параметры.Партнер, "ИНН, КПП, ЮрФизЛицо");
	
	Если Реквизиты.ЮрФизЛицо = Перечисления.ЮрФизЛицо.ИндивидуальныйПредприниматель Тогда
		Параметры.ЭтоИндивидуальныйПредприниматель = Истина;
	КонецЕсли;
	
	Параметры.ИНН = Реквизиты.ИНН;
	Параметры.КПП = Реквизиты.КПП;
	// Конец БольничнаяАптека
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// БольничнаяАптека

// Функция возвращает данные документа, удостоверяющего личность физического лица, действующие на указанную.
//
// Параметры
//  Физлицо - физическое лицо, для которого необходимо получить документ
//  Дата    - дата, на которую необходимо получить документ
//
// Возвращаемое значение
//  Структура - данные документа, удостоверяющего личность физического лица.
//
Функция ДокументУдостоверяющийЛичностьФизлица(Знач Физлицо, Знач Дата = Неопределено)
	
	Запрос = Новый Запрос("
	|ВЫБРАТЬ ПЕРВЫЕ 1
	|	*
	|ИЗ
	|	РегистрСведений.ДокументыФизическихЛиц КАК ДокументыФизическихЛиц
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ (ВЫБРАТЬ
	|			МАКСИМУМ(ДокументыФизическихЛиц.Период) КАК Период,
	|			ДокументыФизическихЛиц.Физлицо КАК Физлицо
	|		ИЗ
	|			РегистрСведений.ДокументыФизическихЛиц КАК ДокументыФизическихЛиц
	|		ГДЕ
	|			ДокументыФизическихЛиц.ЯвляетсяДокументомУдостоверяющимЛичность
	|			И ДокументыФизическихЛиц.Физлицо = &Физлицо
	|			И ДокументыФизическихЛиц.Период <= &ДатаСреза
	|		
	|		СГРУППИРОВАТЬ ПО
	|			ДокументыФизическихЛиц.Физлицо) КАК ДокументыСрез
	|		ПО ДокументыФизическихЛиц.Период = ДокументыСрез.Период
	|			И ДокументыФизическихЛиц.Физлицо = ДокументыСрез.Физлицо
	|			И (ДокументыФизическихЛиц.ЯвляетсяДокументомУдостоверяющимЛичность)
	|");
	
	Запрос.УстановитьПараметр("Физлицо"  , Физлицо);
	Запрос.УстановитьПараметр("ДатаСреза", ?(ЗначениеЗаполнено(Дата), Дата, ТекущаяДатаСеанса()));
	
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		Возврат ОбщегоНазначения.СтрокаТаблицыЗначенийВСтруктуру(Выборка);
	Иначе
		Возврат Новый Структура;
	КонецЕсли;
	
КонецФункции

// Конец БольничнаяАптека

#КонецОбласти

