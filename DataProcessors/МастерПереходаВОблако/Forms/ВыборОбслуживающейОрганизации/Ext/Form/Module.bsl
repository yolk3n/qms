﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	АдресСервиса = Параметры.АдресОблачногоСервиса;
	ОбработкаОбъект = РеквизитФормыВЗначение("Объект");
	ПараметрыЗапроса = Новый Структура;
	ПараметрыЗапроса.Вставить("Ключ", УникальныйИдентификатор);
	ПараметрыЗапроса.Вставить("Адрес", АдресСервиса);
	ПараметрыЗапроса.Вставить("АдресСервиса", АдресСервиса);
	ПараметрыЗапроса.Вставить("Метод", "search-terms");
	
	АдресРезультата = ПоместитьВоВременноеХранилище(Неопределено, УникальныйИдентификатор);
	Результат = ОбработкаОбъект.ПолучитьДанные(ПараметрыЗапроса, АдресРезультата);
	
	СписокВыбора = Элементы.КритерийПоиска.СписокВыбора;
	Для Каждого Элемент Из Результат.Данные.searchTerms Цикл
		СписокВыбора.Добавить(Элемент.id, Элемент.name);	
	КонецЦикла; 	
	
	Если СписокВыбора.Количество() > 0 Тогда
		КритерийПоиска = СписокВыбора[0].Значение;
	КонецЕсли; 
	Элементы.ЗначениеПоиска.Доступность = Не КритерийПоиска = КритерийПоискаВсе();
	
	ПараметрыЗапроса.Вставить("Метод", "support-companies");
	НачатьВыполнениеФоновогоЗаданияНаСервере("ПолучитьДанные", ПараметрыЗапроса, АдресХранилища, ИдентификаторЗадания);	
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ПодключитьОбработчикОжидания("ПроверитьПолучениеДанных", 0.1, Истина);
	
КонецПроцедуры

#КонецОбласти 

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ОбслуживающиеОрганизацииВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)

	Если Поле.Имя = "ОбслуживающиеОрганизацииСайт" Тогда
		СтандартнаяОбработка = Ложь;
		СсылкаНаСайт = Элементы.ОбслуживающиеОрганизации.ТекущиеДанные.Сайт;
		ПерейтиПоНавигационнойСсылке(?(Лев(СсылкаНаСайт, 4) = "http", СсылкаНаСайт, СтрШаблон("http://%1", СсылкаНаСайт)));
		Возврат;
	КонецЕсли; 
	
	ДанныеВыбора = Элементы.ОбслуживающиеОрганизации.ТекущиеДанные;
	РезультатВыбора = Новый Структура("Наименование, Код, Город, Телефон, Почта, Сайт");
	ЗаполнитьЗначенияСвойств(РезультатВыбора, ДанныеВыбора);
	Закрыть(РезультатВыбора);
	
КонецПроцедуры

&НаКлиенте
Процедура КритерийПоискаПриИзменении(Элемент)
	
	Элементы.ЗначениеПоиска.Доступность = Не КритерийПоиска = КритерийПоискаВсе();
	Если КритерийПоиска = КритерийПоискаВсе() Тогда
		ЗначениеПоиска = "";
		НачатьПоискОрганизаций();	
	КонецЕсли; 
	
КонецПроцедуры

#КонецОбласти 

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура НайтиОрганизации(Команда)
	
	НачатьПоискОрганизаций();

КонецПроцедуры

#КонецОбласти 

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура НачатьПоискОрганизаций()
	
	Элементы.Страницы.ТекущаяСтраница = Элементы.СтраницаОжидание;
	ПараметрыЗапроса = Новый Структура;
	ПараметрыЗапроса.Вставить("Ключ", УникальныйИдентификатор);
	ПараметрыЗапроса.Вставить("Адрес", АдресСервиса);
	ПараметрыЗапроса.Вставить("АдресСервиса", АдресСервиса);
	ПараметрыЗапроса.Вставить("КритерийПоиска", КритерийПоиска);
	ПараметрыЗапроса.Вставить("ЗначениеПоиска", ЗначениеПоиска);
	НачатьЗапросПоиска(ПараметрыЗапроса, АдресХранилища, ИдентификаторЗадания);
	ПодключитьОбработчикОжидания("ПроверитьПолучениеДанных", 1, Истина);

КонецПроцедуры

&НаСервереБезКонтекста
Процедура НачатьЗапросПоиска(ПараметрыЗапроса, АдресХранилища, ИдентификаторЗадания)
	
	ПараметрыЗапроса.Вставить("Метод", СтрШаблон("support-companies?term=%1&value=%2", 
		ПараметрыЗапроса.КритерийПоиска, ПараметрыЗапроса.ЗначениеПоиска));
	НачатьВыполнениеФоновогоЗаданияНаСервере("ПолучитьДанные", ПараметрыЗапроса, АдресХранилища, ИдентификаторЗадания);	
	
КонецПроцедуры
	
&НаСервереБезКонтекста
Процедура НачатьВыполнениеФоновогоЗаданияНаСервере(ИмяМетода, ПараметрыЗапроса, АдресХранилища, ИдентификаторЗадания)
	
	ПараметрыВыполненияОбработки = Новый Структура;
	ПараметрыВыполненияОбработки.Вставить("Адрес", ПараметрыЗапроса.АдресСервиса);
	ПараметрыВыполненияОбработки.Вставить("Метод", ПараметрыЗапроса.Метод);
	
	ИмяОбработки = "МастерПереходаВОблако";
	
	ПараметрыЗадания = Новый Структура;
	ПараметрыЗадания.Вставить("ИмяОбработки",		ИмяОбработки);
	ПараметрыЗадания.Вставить("ИмяМетода",			ИмяМетода);
	ПараметрыЗадания.Вставить("ПараметрыВыполнения", ПараметрыВыполненияОбработки);
	ПараметрыЗадания.Вставить("ЭтоВнешняяОбработка", Ложь);
	
	ПараметрыВыполнения = ДлительныеОперации.ПараметрыВыполненияВФоне(ПараметрыЗапроса.Ключ);
	ПараметрыВыполнения.НаименованиеФоновогоЗадания = СтрШаблон("МастерПереходаВОблако.%1", ИмяМетода);
	ПараметрыВыполнения.ЗапуститьВФоне = Истина;
	ПараметрыВыполнения.Вставить("ИдентификаторФормы", ПараметрыЗапроса.Ключ); 
	
	ВыполняемыйМетод = "ДлительныеОперации.ВыполнитьПроцедуруМодуляОбъектаОбработки"; // Выполняем процедуру из модуля объекта
	Результат =  ДлительныеОперации.ВыполнитьВФоне(ВыполняемыйМетод, ПараметрыЗадания, ПараметрыВыполнения);
	
	АдресХранилища = Результат.АдресРезультата;
	ИдентификаторЗадания = Результат.ИдентификаторЗадания;
	
КонецПроцедуры

&НаКлиенте
Процедура ПроверитьПолучениеДанных()
    
    Если Не ПроверитьПолучениеДанныхНаСервере() Тогда
        ПодключитьОбработчикОжидания("ПроверитьПолучениеДанных", 1, Истина);
    Иначе 
        Элементы.Страницы.ТекущаяСтраница = Элементы.СтраницаСписок;
    КонецЕсли;
    
КонецПроцедуры

&НаСервере
Функция ПроверитьПолучениеДанныхНаСервере()
	
	Результат = ПроверитьРезультатЗапросаНаСервере(ИдентификаторЗадания, АдресХранилища);
    Если Результат = Неопределено Тогда
    	Возврат Ложь;
    Иначе
        ЗаполнитьФорму(Результат);
        Возврат Истина;
    КонецЕсли; 

КонецФункции

&НаСервере
Процедура ЗаполнитьФорму(Результат)
	
	ОбслуживающиеОрганизации.Очистить();
	Если Результат.Ошибка Тогда
		Возврат;
	КонецЕсли; 
	
	Данные = Результат.Данные.supportCompanies;
	Для Каждого Строка Из Данные Цикл
		НоваяСтрока = ОбслуживающиеОрганизации.Добавить();
		НоваяСтрока.Код = Строка.id;
		НоваяСтрока.Наименование = Строка.name;
		НоваяСтрока.Город = Строка.city;
		НоваяСтрока.Телефон = Строка.phone;
		НоваяСтрока.Сайт = Строка.site;
		НоваяСтрока.Почта = Строка.email;
	КонецЦикла; 
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция КритерийПоискаВсе()
	
	Возврат "all";
	
КонецФункции

&НаСервереБезКонтекста
Функция ПроверитьРезультатЗапросаНаСервере(ИдентификаторЗадания, АдресХранилища)
	
    ФоновоеЗадание = ФоновыеЗадания.НайтиПоУникальномуИдентификатору(ИдентификаторЗадания);
	
	Если ФоновоеЗадание <> Неопределено И ФоновоеЗадание.Состояние = СостояниеФоновогоЗадания.Активно Тогда
        Возврат Неопределено;
        
    ИначеЕсли ФоновоеЗадание <> Неопределено И ФоновоеЗадание.Состояние = СостояниеФоновогоЗадания.Завершено Тогда
        Возврат ПолучитьИзВременногоХранилища(АдресХранилища);
    ИначеЕсли ФоновоеЗадание <> Неопределено И ФоновоеЗадание.Состояние = СостояниеФоновогоЗадания.ЗавершеноАварийно Тогда
        ТекстОшибки = ПодробноеПредставлениеОшибки(ФоновоеЗадание.ИнформацияОбОшибке);
        Сообщения = ФоновоеЗадание.ПолучитьСообщенияПользователю();
        Для Каждого Сообщение Из Сообщения Цикл
            ТекстОшибки = Сообщение.Текст + Символы.ПС + ТекстОшибки;	
        КонецЦикла;  
        ВызватьИсключение ТекстОшибки;    
    Иначе
        Возврат Неопределено;
    КонецЕсли; 
	 
КонецФункции

#КонецОбласти 
