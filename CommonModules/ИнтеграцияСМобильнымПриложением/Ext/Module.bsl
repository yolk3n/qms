﻿
////////////////////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС
#Область ПрограммныйИнтерфейс

// Формирует настройки обмена для мобильного приложения.
//
// Параметры:
//  АдресИнформационнойБазы - Строка - адрес в формате адреса на веб-сервере.
//
// Возвращаемое значение:
//  НастройкиИнтеграции - Структура:
//   * ДанныеПодключения         - Структура - параметры подключения мобильного приложения к информационной базе.
//   * ИдентификаторПользователя - Строка - уникальный идентификатор текущего пользователя.
//
Функция СформироватьНастройкиОбменаСМобильнымПриложением(АдресИнформационнойБазы) Экспорт
	
	Если Не ЗначениеЗаполнено(АдресИнформационнойБазы) Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	ДанныеПодключения = ОбщегоНазначенияКлиентСервер.СтруктураURI(АдресИнформационнойБазы);
	
	Если Не СтрНачинаетсяС(ДанныеПодключения.Схема, "http") Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	ДанныеПодключения.Вставить("КорневойURL", Метаданные.HTTPСервисы.MobileAppExchange.КорневойURL);
	
	ЗаполнитьЗначенияСвойств(ДанныеПодключения, ДанныеАвторизацииПользователяОбменаСМобильнымПриложением());
	
	НастройкиПодключения = Новый Структура;
	НастройкиПодключения.Вставить("ДанныеПодключения"        , ДанныеПодключения);
	НастройкиПодключения.Вставить("ИдентификаторПользователя", ИдентификаторПользователяИнформационнойБазы());
	
	Возврат НастройкиПодключения;
	
КонецФункции

// Создание или изменение служебного пользователя (и его настроек) обмена с мобильным приложением.
//
Процедура ОбновитьНастройкиИнтеграцииСМобильнымПриложением() Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	НачатьТранзакцию();
	Попытка
		
		// Создание пользователя обмена с мобильным приложением.
		НастройкиАвторизации = Новый Структура;
		НастройкиАвторизации.Вставить("Используется", Истина);
		НастройкиАвторизации.Вставить("Логин"       , ИнтеграцияСМобильнымПриложениемКлиентСервер.ЛогинПользователяОбменаСМобильнымПриложением());
		НастройкиАвторизации.Вставить("Пароль"      , Строка(Новый УникальныйИдентификатор));
		
		ЗаписатьНастройкиАвторизацииДляОбменаСМобильнымПриложением(НастройкиАвторизации);
		
		ПользовательОбмена = Константы.ПользовательИнтеграцииСМобильнымПриложением.Получить();
		
		// Запись данных пользователя обмена с мобильным приложением в безопасное хранилище.
		ОбщегоНазначения.УдалитьДанныеИзБезопасногоХранилища(ПользовательОбмена);
		ОбщегоНазначения.ЗаписатьДанныеВБезопасноеХранилище(ПользовательОбмена, НастройкиАвторизации.Логин, "login");
		ОбщегоНазначения.ЗаписатьДанныеВБезопасноеХранилище(ПользовательОбмена, НастройкиАвторизации.Пароль, "password");
		
		ЗафиксироватьТранзакцию();
		
	Исключение
		ОтменитьТранзакцию();
		ИмяСобытия = НСтр("ru = 'Создание настроек обмена с мобильным приложением'", ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка());
		Текст = НСтр("ru = 'При создании настроек обмена с мобильным приложением возникла ошибка:'");
		Текст = Текст + Символы.ПС + ОбработкаОшибок.ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
		ЗаписьЖурналаРегистрации(ИмяСобытия, УровеньЖурналаРегистрации.Ошибка,,, Текст);
		ВызватьИсключение;
	КонецПопытки;
	
КонецПроцедуры

// Создает команду загрузки данных из мобильного приложения.
// Реализацию обработчика выполнения команды
// см. в процедуре ИнтеграцияСМобильнымПриложениемКлиент.ВыполнитьКомандуЗагрузкиДанныхИзМобильногоПриложения.
//
// Параметры:
//  Форма - форма, из обработчика события которой происходит вызов процедуры.
//          см. справочную информацию по событиям управляемой формы.
//  РодительЭлемента - родительский элемент, в который нужно добавить кнопку формы.
//
Процедура СоздатьКомандуЗагрузкиДанныхИзМобильногоПриложенияНаФорме(Форма, ИмяТабличнойЧасти, ИмяРодительскогоЭлемента) Экспорт
	
	Если ПолучитьФункциональнуюОпцию("ИспользоватьИнтеграциюСМобильнымПриложением") Тогда
		
		Если Форма.Элементы.Найти(ИмяТабличнойЧасти) = Неопределено Тогда
			Возврат;
		КонецЕсли;
		
		РодительскийЭлемент = Форма.Элементы.Найти(ИмяРодительскогоЭлемента);
		Если РодительскийЭлемент = Неопределено Тогда
			Возврат;
		КонецЕсли;
		
		СвойстваКоманды = ИнтеграцияСМобильнымПриложениемКлиентСервер.СвойстваКомандыЗагрузкиШтрихкодовИзМобильногоПриложения();
		
		Команда = Форма.Команды.Добавить(ИмяТабличнойЧасти + СвойстваКоманды.Имя);
		ЗаполнитьЗначенияСвойств(Команда, СвойстваКоманды,, "Имя");
		
		Кнопка = Форма.Элементы.Добавить(Команда.Имя, Тип("КнопкаФормы"), РодительскийЭлемент);
		Кнопка.ИмяКоманды = Команда.Имя;
		Кнопка.Высота = 1;
		
	КонецЕсли;
	
КонецПроцедуры

// Получает данные мобильного приложения из очереди.
//
// Параметры:
//  Свойства          - Строка - (необязательный) набор свойств, перечисленных через запятую, которые нужно получить из очереди.
//  Пользователь      - СправочникСсылка.Пользователи - (необязательный) пользователь, от имени которого были сформированы данные.
//                      Если не установлен, будут получены данные текущего пользователя.
//
// Возвращаемое значение:
//  Массив - состоящий из структур с элементами переданных свойств.
//
Функция ПолучитьДанныеМобильногоПриложенияИзОчереди(Свойства = "", Пользователь = Неопределено) Экспорт
	
	Возврат РегистрыСведений.ОчередьЗагрузкиШтрихкодовИзМобильногоПриложения.ПолучитьШтрихкодыИзОчереди(Свойства, Пользователь);
	
КонецФункции

// Преобразует переданные данные в строку JSON.
//
// Параметры:
//  Данные - Структура - данные для преобразования в строку JSON.
//
// Возвращаемое значение:
//  Строка - в формате JSON.
//
Функция СтрокаJSONИзДанных(Данные) Экспорт
	
	ЗаписьJSON = Новый ЗаписьJSON;
	ЗаписьJSON.УстановитьСтроку();
	ЗаписатьJSON(ЗаписьJSON, Данные);
	Возврат ЗаписьJSON.Закрыть();
	
КонецФункции

#КонецОбласти // ПрограммныйИнтерфейс

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ
#Область СлужебныеПроцедурыИФункции

////////////////////////////////////////////////////////////////////////////////
// Обновление настроек обмена с мобильным приложением
#Область ОбновлениеНастроекОбменаСМобильнымПриложением

// Записывает настройки авторизации для обмена с мобильным приложением (в модели сервиса).
//
// Параметры:
//  НастройкиАвторизации - Структура, поля:
//                        * Используется - Булево - флаг включения авторизации для доступа
//                                         к обмену с мобильным приложением,
//                        * Логин - Строка - логин пользователя для авторизации при доступе
//                                         к обмену с мобильным приложением,
//                        * Пароль - Строка - пароль пользователя для авторизации при доступе
//                                         к обмену с мобильным приложением. Значение передается
//                                         в составе структуры только в тех случаях, когда требуется
//                                         изменить пароль.
//
Процедура ЗаписатьНастройкиАвторизацииДляОбменаСМобильнымПриложением(Знач НастройкиАвторизации)
	
	СвойстваПользователя = СвойстваПользователяОбменаСМобильнымПриложением();
	
	Если НастройкиАвторизации.Используется Тогда
		
		// Требуется создать или обновить пользователя ИБ
		
		ОписаниеПользователяИБ = Новый Структура();
		ОписаниеПользователяИБ.Вставить("Действие", "Записать");
		ОписаниеПользователяИБ.Вставить("Имя", НастройкиАвторизации.Логин);
		ОписаниеПользователяИБ.Вставить("АутентификацияСтандартная", Истина);
		ОписаниеПользователяИБ.Вставить("АутентификацияОС", Ложь);
		ОписаниеПользователяИБ.Вставить("АутентификацияOpenID", Ложь);
		ОписаниеПользователяИБ.Вставить("ПоказыватьВСпискеВыбора", Ложь);
		Если НастройкиАвторизации.Свойство("Пароль") Тогда
			ОписаниеПользователяИБ.Вставить("Пароль", НастройкиАвторизации.Пароль);
		КонецЕсли;
		ОписаниеПользователяИБ.Вставить("ЗапрещеноИзменятьПароль", Истина);
		ОписаниеПользователяИБ.Вставить("Роли",
			ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(
			РольДляОбменаСМобильнымПриложением().Имя));
		
		Если ЗначениеЗаполнено(СвойстваПользователя.Пользователь) Тогда
			ПользовательОбмена = СвойстваПользователя.Пользователь.ПолучитьОбъект();
		Иначе
			ПользовательОбмена = Справочники.Пользователи.СоздатьЭлемент();
		КонецЕсли;
		
		ПользовательОбмена.Наименование = НСтр("ru = 'Обмен с мобильным приложением'");
		ПользовательОбмена.Служебный = Истина;
		ПользовательОбмена.ДополнительныеСвойства.Вставить("ОписаниеПользователяИБ", ОписаниеПользователяИБ);
		
		НачатьТранзакцию();
		
		Попытка
			
			ПользовательОбмена.Записать();
			
			Константы.ПользовательИнтеграцииСМобильнымПриложением.Установить(
				ПользовательОбмена.Ссылка);
			
			ОписаниеПользователяИБ.Удалить("Пароль");
			
			СокращенноеОписание = Новый Структура;
			ОбщегоНазначенияКлиентСервер.ДополнитьСтруктуру(СокращенноеОписание, ОписаниеПользователяИБ);
			СокращенноеОписание.Удалить("ПользовательИБ");
			
			Комментарий = СтрШаблон(
				НСтр("ru = 'Выполнена запись пользователя для обмена с мобильным приложением.
                      |
                      |Описание пользователя ИБ:
                      |-------------------------------------------
                      |%1
                      |-------------------------------------------
                      |
                      |Результат:
                      |-------------------------------------------
                      |%2
                      |-------------------------------------------'"),
				ОбщегоНазначения.ЗначениеВСтрокуXML(СокращенноеОписание),
				ПользовательОбмена.ДополнительныеСвойства.ОписаниеПользователяИБ.РезультатДействия
			);
			
			ЗаписьЖурналаРегистрации(
				ИмяСобытияЖурналаРегистрации(НСтр("ru = 'ЗаписьПользователя'", ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка())),
				УровеньЖурналаРегистрации.Информация,
				Метаданные.Справочники.Пользователи,
				,
				Комментарий
			);
			
			ЗафиксироватьТранзакцию();
			
		Исключение
			
			ОтменитьТранзакцию();
			ОписаниеПользователяИБ.Удалить("Пароль");
			
			Комментарий = СтрШаблон(
				НСтр("ru = 'При записи пользователя для обмена с мобильным приложением произошла ошибка.
                      |
                      |Описание пользователя ИБ:
                      |-------------------------------------------
                      |%1
                      |-------------------------------------------
                      |
                      |Текст ошибки:
                      |-------------------------------------------
                      |%2
                      |-------------------------------------------'"),
				ОбщегоНазначения.ЗначениеВСтрокуXML(ОписаниеПользователяИБ),
				ОбработкаОшибок.ПодробноеПредставлениеОшибки(ИнформацияОбОшибке())
			);
			
			ЗаписьЖурналаРегистрации(
				ИмяСобытияЖурналаРегистрации(НСтр("ru = 'ЗаписьПользователя'", ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка())),
				УровеньЖурналаРегистрации.Ошибка,
				Метаданные.Справочники.Пользователи,
				,
				Комментарий
			);
			
			ВызватьИсключение;
			
		КонецПопытки;
		
	Иначе
		
		Если ЗначениеЗаполнено(СвойстваПользователя.Пользователь) Тогда
			
			// Требуется заблокировать пользователя ИБ
			
			ОписаниеПользователяИБ = Новый Структура();
			ОписаниеПользователяИБ.Вставить("Действие", "Записать");
			
			ОписаниеПользователяИБ.Вставить("ВходВПрограммуРазрешен", Ложь);
			
			ПользовательОбмена = СвойстваПользователя.Пользователь.ПолучитьОбъект();
			ПользовательОбмена.ДополнительныеСвойства.Вставить("ОписаниеПользователяИБ", ОписаниеПользователяИБ);
			ПользовательОбмена.Служебный = Истина;
			ПользовательОбмена.Записать();
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

Функция СвойстваПользователяОбменаСМобильнымПриложением()
	
	Если Не ПравоДоступа("АдминистрированиеДанных", Метаданные) Тогда
		ВызватьИсключение НСтр("ru = 'Недостаточно прав доступа для настройки обмена с мобильным приложением.'");
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	
	Результат = Новый Структура("Пользователь, Идентификатор, Имя, Аутентификация", Справочники.Пользователи.ПустаяСсылка(), Неопределено, "", Ложь);
	
	Пользователь = Константы.ПользовательИнтеграцииСМобильнымПриложением.Получить();
	
	Если ЗначениеЗаполнено(Пользователь) Тогда
		
		Результат.Пользователь = Пользователь;
		
		Идентификатор = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Пользователь, "ИдентификаторПользователяИБ");
		
		Если ЗначениеЗаполнено(Идентификатор) Тогда
			
			Результат.Идентификатор = Идентификатор;
			
			ПользовательИБ = ПользователиИнформационнойБазы.НайтиПоУникальномуИдентификатору(Идентификатор);
			
			Если ПользовательИБ <> Неопределено Тогда
				
				Результат.Имя = ПользовательИБ.Имя;
				Результат.Аутентификация = ПользовательИБ.АутентификацияСтандартная;
				
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

// Возвращает роль, предназначенную для назначения пользователю информационной базы,
// логин и пароль которого будет использоваться при подключении к стандартному интерфейсу
// OData (в модели сервиса).
//
// Возвращаемое значение: ОбъектМетаданных (роль).
//
Функция РольДляОбменаСМобильнымПриложением()
	
	Возврат Метаданные.Роли.ИспользованиеИнтеграцииСМобильнымПриложением;
	
КонецФункции

Функция ИмяСобытияЖурналаРегистрации(Знач Суффикс)
	
	Возврат НСтр("ru = 'НастройкаОбменаСМобильнымПриложением.'") + СокрЛП(Суффикс);
	
КонецФункции

#КонецОбласти // ОбновлениеНастроекОбменаСМобильнымПриложением

////////////////////////////////////////////////////////////////////////////////
// Формирование настроек обмена
#Область ФормированиеНастроекОбмена

Функция ДанныеАвторизацииПользователяОбменаСМобильнымПриложением()
	
	УстановитьПривилегированныйРежим(Истина);
	
	ПользовательОбмена = Константы.ПользовательИнтеграцииСМобильнымПриложением.Получить();
	Если Не ЗначениеЗаполнено(ПользовательОбмена) Тогда
		ОбновитьНастройкиИнтеграцииСМобильнымПриложением();
	Иначе
		ИдентификаторПользователяИБ = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ПользовательОбмена, "ИдентификаторПользователяИБ");
		Если Не ЗначениеЗаполнено(ИдентификаторПользователяИБ) Тогда
			ОбновитьНастройкиИнтеграцииСМобильнымПриложением();
		Иначе
			СвойстваПользователяИБ = Пользователи.СвойстваПользователяИБ(ИдентификаторПользователяИБ);
			Если СвойстваПользователяИБ = Неопределено Тогда
				ОбновитьНастройкиИнтеграцииСМобильнымПриложением();
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	ПользовательОбмена = Константы.ПользовательИнтеграцииСМобильнымПриложением.Получить();
	
	ДанныеАвторизации = Новый Структура;
	ДанныеАвторизации.Вставить("Логин" , ОбщегоНазначения.ПрочитатьДанныеИзБезопасногоХранилища(ПользовательОбмена, "login"));
	ДанныеАвторизации.Вставить("Пароль", ОбщегоНазначения.ПрочитатьДанныеИзБезопасногоХранилища(ПользовательОбмена, "password"));
	
	Возврат ДанныеАвторизации;
	
КонецФункции

Функция ИдентификаторПользователяИнформационнойБазы()
	
	УстановитьПривилегированныйРежим(Истина);
	
	Возврат Строка(Пользователи.ТекущийПользователь().УникальныйИдентификатор());
	
КонецФункции

#КонецОбласти // ФормированиеНастроекОбмена

#КонецОбласти // СлужебныеПроцедурыИФункции
