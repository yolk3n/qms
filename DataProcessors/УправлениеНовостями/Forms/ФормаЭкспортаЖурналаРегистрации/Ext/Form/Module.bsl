﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2022, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	// Текст сообщения пустой, вывести его на передний план.
	Элементы.СтраницыПрогресса.ТекущаяСтраница = Элементы.СтраницаГотово;

	лкКаталогВременныхФайлов = КаталогВременныхФайлов();
	Если СтрЗаканчиваетсяНа(лкКаталогВременныхФайлов, ПолучитьРазделительПутиСервера()) Тогда
		ЭтотОбъект.ИмяКаталогаЭкспорта = лкКаталогВременныхФайлов;
	Иначе
		ЭтотОбъект.ИмяКаталогаЭкспорта = лкКаталогВременныхФайлов + ПолучитьРазделительПутиСервера();
	КонецЕсли;

	ЭтотОбъект.ПериодДень = ТекущаяДатаСеанса();

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура КомандаЭкспорт(Команда)

	Если ПроверитьЗаполнение() Тогда

		Элементы.СтраницыПрогресса.ТекущаяСтраница = Элементы.СтраницаПрогресс;
		ЭтотОбъект.РезультатЭкспорта = "";
		ЭтотОбъект.ОбновитьОтображениеДанных();

		ДатаСтрокой = Формат(ЭтотОбъект.ПериодДень,"ДФ=yyyy-MM-dd");

		ПараметрыФайлаВыгрузки = Новый Структура;
			ПараметрыФайлаВыгрузки.Вставить("Архивировать", ЭтотОбъект.СжиматьФайл);

		// 1. События подсистемы
		ВсеСобытияПодсистемы = ОбработкаНовостейКлиент.ПолучитьСписокВсехСобытийЖурналаРегистрации();
		ПараметрыОтбора = Новый Структура;
			ПараметрыОтбора.Вставить("ДатаНачала"   , НачалоДня(ЭтотОбъект.ПериодДень));
			ПараметрыОтбора.Вставить("ДатаОкончания", КонецДня(ЭтотОбъект.ПериодДень));
			ПараметрыОтбора.Вставить("Событие"      , ВсеСобытияПодсистемы);
		РезультатСобытия = ОбработкаНовостейВызовСервера.ВыгрузитьВсеСобытияЖурналаРегистрации(
			ПараметрыОтбора,
			ПараметрыФайлаВыгрузки);

		Если ПустаяСтрока(РезультатСобытия.ТекстОшибки) Тогда
			Если ПустаяСтрока(РезультатСобытия.АдресВременногоХранилищаФайла) Тогда
				ТекстСообщения = НСтр("ru='Не удалось экспортировать события журнала регистрации (события подсистемы) в файл.
					|Данные не удалось поместить во временное хранилище.'");
				ЭтотОбъект.РезультатЭкспорта = ЭтотОбъект.РезультатЭкспорта + ТекстСообщения + Символы.ПС;
			Иначе
				// Попробовать записать файл.
				ДвоичныеДанныеФайла = ПолучитьИзВременногоХранилища(РезультатСобытия.АдресВременногоХранилищаФайла);
				Если ТипЗнч(ДвоичныеДанныеФайла) = Тип("ДвоичныеДанные") Тогда
					ЛокальныйИмяКаталогаЭкспорта = ОбработкаНовостейКлиентСервер.УдалитьПоследнийСимвол(
						ЭтотОбъект.ИмяКаталогаЭкспорта, "\/")
						+ ПолучитьРазделительПути();
					Если ЭтотОбъект.СжиматьФайл Тогда
						ИмяФайла = ЛокальныйИмяКаталогаЭкспорта + ДатаСтрокой + "(SubSystem).zip";
					Иначе
						ИмяФайла = ЛокальныйИмяКаталогаЭкспорта + ДатаСтрокой + "(SubSystem).xml";
					КонецЕсли;
					Попытка
						ДвоичныеДанныеФайла.Записать(ИмяФайла); // Метод "Записать" не работает в веб-клиенте.
						ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
							НСтр("ru='Журнал событий подсистемы успешно экспортирован в файл с именем
								|%1'"),
							ИмяФайла);
						ЭтотОбъект.РезультатЭкспорта = ЭтотОбъект.РезультатЭкспорта + ТекстСообщения + Символы.ПС;
					Исключение
						ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
							НСтр("ru='Не удалось записать файл событий подсистемы по причине:
								|%1'"),
							ОбработкаОшибок.ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
						ЭтотОбъект.РезультатЭкспорта = ЭтотОбъект.РезультатЭкспорта + ТекстСообщения + Символы.ПС;
					КонецПопытки;
				Иначе
					ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
						НСтр("ru='Не удалось экспортировать события подсистемы журнала регистрации в файл.
							|Во временное хранилище помещены данные неправильного типа %1.'"),
						?(ДвоичныеДанныеФайла = Неопределено, "Неопределено", ТипЗнч(ДвоичныеДанныеФайла)));
					ЭтотОбъект.РезультатЭкспорта = ЭтотОбъект.РезультатЭкспорта + ТекстСообщения;
				КонецЕсли;
			КонецЕсли;
		Иначе
			ЭтотОбъект.РезультатЭкспорта = ЭтотОбъект.РезультатЭкспорта + РезультатСобытия.ТекстОшибки + Символы.ПС;
		КонецЕсли;

		// 2. События изменения данных подсистемы
		ВсеСобытияИзмененияДанных = ОбработкаНовостейКлиент.ПолучитьСписокВсехСобытийИзмененияДанныхЖурналаРегистрации();
		СписокМетаданныхПодсистемы = ОбработкаНовостейВызовСервера.ПолучитьСписокМетаданныхПодсистемы();
		ПараметрыОтбора = Новый Структура;
			ПараметрыОтбора.Вставить("ДатаНачала"   , НачалоДня(ЭтотОбъект.ПериодДень));
			ПараметрыОтбора.Вставить("ДатаОкончания", КонецДня(ЭтотОбъект.ПериодДень));
			ПараметрыОтбора.Вставить("Событие"      , ВсеСобытияИзмененияДанных);
			ПараметрыОтбора.Вставить("Метаданные"   , СписокМетаданныхПодсистемы);
		РезультатИзмененияДанных = ОбработкаНовостейВызовСервера.ВыгрузитьВсеСобытияЖурналаРегистрации(
			ПараметрыОтбора,
			ПараметрыФайлаВыгрузки);

		Если ПустаяСтрока(РезультатИзмененияДанных.ТекстОшибки) Тогда
			Если ПустаяСтрока(РезультатИзмененияДанных.АдресВременногоХранилищаФайла) Тогда
				ТекстСообщения = НСтр("ru='Не удалось экспортировать события журнала регистрации (изменения данных) в файл.
					|Данные не удалось поместить во временное хранилище.'");
				ЭтотОбъект.РезультатЭкспорта = ЭтотОбъект.РезультатЭкспорта + ТекстСообщения + Символы.ПС;
			Иначе
				// Попробовать записать файл.
				ДвоичныеДанныеФайла = ПолучитьИзВременногоХранилища(РезультатИзмененияДанных.АдресВременногоХранилищаФайла);
				Если ТипЗнч(ДвоичныеДанныеФайла) = Тип("ДвоичныеДанные") Тогда
					ЛокальныйИмяКаталогаЭкспорта = ОбработкаНовостейКлиентСервер.УдалитьПоследнийСимвол(
						ЭтотОбъект.ИмяКаталогаЭкспорта, "\/")
						+ ПолучитьРазделительПути();
					Если ЭтотОбъект.СжиматьФайл Тогда
						ИмяФайла = ЛокальныйИмяКаталогаЭкспорта + ДатаСтрокой + "(DataChanges).zip";
					Иначе
						ИмяФайла = ЛокальныйИмяКаталогаЭкспорта + ДатаСтрокой + "(DataChanges).xml";
					КонецЕсли;
					Попытка
						ДвоичныеДанныеФайла.Записать(ИмяФайла); // Метод "Записать" не работает в веб-клиенте.
						ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
							НСтр("ru='Журнал событий изменения данных успешно экспортирован в файл с именем
								|%1'"),
							ИмяФайла);
						ЭтотОбъект.РезультатЭкспорта = ЭтотОбъект.РезультатЭкспорта + ТекстСообщения + Символы.ПС;
					Исключение
						ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
							НСтр("ru='Не удалось записать файл событий изменения данных по причине:
								|%1'"),
							ОбработкаОшибок.ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
						ЭтотОбъект.РезультатЭкспорта = ЭтотОбъект.РезультатЭкспорта + ТекстСообщения + Символы.ПС;
					КонецПопытки;
				Иначе
					ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
						НСтр("ru='Не удалось экспортировать события изменения данных журнала регистрации в файл.
							|Во временное хранилище помещены данные неправильного типа %1.'"),
						?(ДвоичныеДанныеФайла = Неопределено, "Неопределено", ТипЗнч(ДвоичныеДанныеФайла)));
					ЭтотОбъект.РезультатЭкспорта = ЭтотОбъект.РезультатЭкспорта + ТекстСообщения + Символы.ПС;
				КонецЕсли;
			КонецЕсли;
		Иначе
			ЭтотОбъект.РезультатЭкспорта = ЭтотОбъект.РезультатЭкспорта + РезультатИзмененияДанных.ТекстОшибки + Символы.ПС;
		КонецЕсли;

		Элементы.СтраницыПрогресса.ТекущаяСтраница = Элементы.СтраницаГотово;

	КонецЕсли;

КонецПроцедуры

#КонецОбласти
