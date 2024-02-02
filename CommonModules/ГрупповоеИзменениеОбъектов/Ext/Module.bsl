﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2023, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

#Область ДляВызоваИзДругихПодсистем

// См. ПодключаемыеКомандыПереопределяемый.ПриОпределенииВидовПодключаемыхКоманд
Процедура ПриОпределенииВидовПодключаемыхКоманд(ВидыПодключаемыхКоманд) Экспорт
	
	Если ВидыПодключаемыхКоманд.Найти("Администрирование", "Имя") = Неопределено Тогда
	
		Вид = ВидыПодключаемыхКоманд.Добавить();
		Вид.Имя         = "Администрирование";
		Вид.ИмяПодменю  = "Сервис";
		Вид.Заголовок   = НСтр("ru = 'Сервис'");
		Вид.Порядок     = 80;
		Вид.Картинка    = БиблиотекаКартинок.ПодменюСервис;
		Вид.Отображение = ОтображениеКнопки.КартинкаИТекст;	
	
	КонецЕсли;
	
КонецПроцедуры

// См. ПодключаемыеКомандыПереопределяемый.ПриОпределенииКомандПодключенныхКОбъекту
Процедура ПриОпределенииКомандПодключенныхКОбъекту(НастройкиФормы, Источники, ПодключенныеОтчетыИОбработки, Команды) Экспорт

	ПодключенныеОбъекты = Новый Массив;
	ГрупповоеИзменениеОбъектовПереопределяемый.ПриОпределенииОбъектовСКомандойГрупповогоИзмененияОбъектов(ПодключенныеОбъекты);
	Для каждого ПодключенныйОбъект Из ПодключенныеОбъекты Цикл
					
		Если ПравоДоступа("Изменение", ПодключенныйОбъект) 
			И Источники.Строки.Найти(ПодключенныйОбъект, "Метаданные") <> Неопределено Тогда
				
			Команда = Команды.Добавить();
			Команда.Вид = "Администрирование";
			Команда.Важность = "СмТакже";
			Команда.Представление = НСтр("ru = 'Изменить выделенные...'");
			Команда.РежимЗаписи = "НеЗаписывать";
			Команда.ВидимостьВФормах = "ФормаСписка";
			Команда.МножественныйВыбор = Истина;
			Команда.Обработчик = "ГрупповоеИзменениеОбъектовКлиент.ОбработчикКоманды";
			Команда.ТолькоВоВсехДействиях = Истина;
			Команда.Порядок = 20;
			
		КонецЕсли;	
	
	КонецЦикла;	

КонецПроцедуры

#КонецОбласти

#КонецОбласти