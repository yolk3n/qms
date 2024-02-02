﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	РазмерПриложений.ПроверитьПоддержкуРасчетаРазмераПриложений();
	
	ОбновитьВидимостьГруппыРазмераПриложения();
	ОбновитьИнформациюОРасчетеРазмераПриложения();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ПодключитьОбработчикОжиданияВыполненияРасчета();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура СформироватьОтчет(Команда)
	
	Если ВыполняетсяРасчет Или ЕстьДанныеДляФормированияОтчета() Тогда
		
		СформироватьОтчетПродолжение();
		
	Иначе
		
		ТекстВопроса = НСтр("ru = 'Расчет размера приложения не выполнялся.
							|Выполнить сейчас?'");
		Обработчик = Новый ОписаниеОповещения("ОбработчикВопросаВыполненияРасчета", ЭтотОбъект);
		ПоказатьВопрос(Обработчик, ТекстВопроса, РежимДиалогаВопрос.ДаНет);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура РасcчитатьРазмерПриложения(Команда)
	
	Если Не ДоступенРасчетПриложения() Тогда
		ВызватьИсключение НСтр("ru = 'В неразделенном сеансе недоступен расчет размера приложения'");
	КонецЕсли;
	
	ВыполнитьРасчетРазмераПриложения();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура СформироватьОтчетПродолжение()
	
	СформироватьОтчетПослеВыполненияРасчета = Ложь;
	ЭтотОбъект.СкомпоноватьРезультат(РежимКомпоновкиРезультата.Фоновый);
	
КонецПроцедуры

#Область РасчетРазмераПриложения

&НаКлиенте
Процедура ПодключитьОбработчикОжиданияВыполненияРасчета(УвеличитьИнтервал = 0)
	
	Если Не ВыполняетсяРасчет Тогда
		Возврат;
	КонецЕсли;
	
	ИнтервалОжиданияВыполненияРасчета = Макс(5 + УвеличитьИнтервал, 300);
	ПодключитьОбработчикОжидания("ПроверитьРезультатЗаданияРасчетаРазмераПриложения",
		ИнтервалОжиданияВыполненияРасчета, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ПроверитьРезультатЗаданияРасчетаРазмераПриложения()
	
	Если ЕстьЗапланированноеЗаданиеРасчетаРазмераПриложения() Тогда
		
		ПодключитьОбработчикОжиданияВыполненияРасчета(ИнтервалОжиданияВыполненияРасчета);
		
	Иначе
		
		ОбновитьИнформациюОРасчетеРазмераПриложения();
		
		Если СформироватьОтчетПослеВыполненияРасчета Тогда
			СформироватьОтчетПродолжение();
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработчикВопросаВыполненияРасчета(РезультатВопроса, ДополнительныеПараметры) Экспорт
	
	Если РезультатВопроса = КодВозвратаДиалога.Да Тогда
		
		СформироватьОтчетПослеВыполненияРасчета = Истина;
		ВыполнитьРасчетРазмераПриложения();
		
	Иначе
		
		СформироватьОтчетПродолжение();
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьРасчетРазмераПриложения()
	
	Если ЭтоРазделенныйСеанс() Тогда
		
		ЗапланироватьРасчетРазмераПриложения();
		ПодключитьОбработчикОжиданияВыполненияРасчета();
		
	Иначе
		
		ДлительнаяОперация = ЗапуститьФоновыйРасчетРазмераПриложения(ЭтаФорма.УникальныйИдентификатор);
		
		ПараметрыОжидания = ДлительныеОперацииКлиент.ПараметрыОжидания(ЭтаФорма);
		ПараметрыОжидания.ТекстСообщения = НСтр("ru = 'Выполняется расчет размера приложения'");
		
		ОповещениеОЗавершении = Новый ОписаниеОповещения("РасчетРазмераПриложенияЗавершение", ЭтотОбъект);
		ДлительныеОперацииКлиент.ОжидатьЗавершение(ДлительнаяОперация, ОповещениеОЗавершении, ПараметрыОжидания);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура РасчетРазмераПриложенияЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	 
	Если Результат.Статус = "Ошибка" Тогда
		ВызватьИсключение Результат.КраткоеПредставлениеОшибки;
	ИначеЕсли Результат.Статус = "Выполнено" Тогда
		
		ОбновитьИнформациюОРасчетеРазмераПриложения();
		
		Если СформироватьОтчетПослеВыполненияРасчета Тогда
			СформироватьОтчетПродолжение();
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ЗапуститьФоновыйРасчетРазмераПриложения(Знач ИдентификаторФормы)
	
	ПараметрыВыполнения = ДлительныеОперации.ПараметрыВыполненияВФоне(ИдентификаторФормы);
	ПараметрыВыполнения.ОжидатьЗавершение = 0;
	ПараметрыВыполнения.НаименованиеФоновогоЗадания = НСтр("ru = 'Расчет размера приложения'");
	ПараметрыВыполнения.КлючФоновогоЗадания = Строка(Новый УникальныйИдентификатор);
	
	Возврат ДлительныеОперации.ВыполнитьВФоне(
		"Отчеты.ИсторияРазмераПриложения.РассчитатьРазмерПриложения",
		Неопределено,
		ПараметрыВыполнения);
	
КонецФункции

&НаСервере
Процедура ЗапланироватьРасчетРазмераПриложения()
	
	РазмерПриложений.ЗапланироватьРасчетРазмераПриложения();
	ОбновитьВыполнениеРасчетаПриложения();
	
КонецПроцедуры

#КонецОбласти

#Область ОбновлениеИнтерфейса

&НаСервере
Процедура ОбновитьВидимостьГруппыРазмераПриложения()
	
	ДоступенРасчет = ДоступенРасчетПриложения();
	Элементы.ГруппаРазмерПриложения.Видимость = ДоступенРасчет;
	
	Если Не ДоступенРасчет Тогда
		Возврат;
	КонецЕсли;
	
	МинимальныйШагИзменений = РазмерПриложений.ЗначениеНастройкиРасчета("МинимальныйШагИзменений", 0);
	Если МинимальныйШагИзменений > 0 Тогда
		
		Элементы.РасcчитатьРазмерПриложения.ОтображениеПодсказки = ОтображениеПодсказки.Кнопка;
		Элементы.РасcчитатьРазмерПриложенияРасширеннаяПодсказка.Заголовок = СтрШаблон(
			НСтр("ru = 'Изменения в размере объекта метаданных меньше %1 Мб не отображаются'"),
			МинимальныйШагИзменений / 1024 / 1024);
		
	Иначе 
		
		Элементы.РасcчитатьРазмерПриложения.ОтображениеПодсказки = ОтображениеПодсказки.Нет;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьИнформациюОРасчетеРазмераПриложения()
	
	ОбновитьАктуальностьРасчетаПриложения();
	ОбновитьВыполнениеРасчетаПриложения();
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьВыполнениеРасчетаПриложения()
	
	Если Не ДоступенРасчетПриложения() Тогда
		Возврат;
	КонецЕсли;
	
	ВыполняетсяРасчет = ?(ЭтоРазделенныйСеанс(), ЕстьЗапланированноеЗаданиеРасчетаРазмераПриложения(), Ложь);

	Элементы.РасcчитатьРазмерПриложения.Видимость = Не ВыполняетсяРасчет; 
	Элементы.ГруппаВыполняетсяРасчетПриложения.Видимость = ВыполняетсяРасчет;
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьАктуальностьРасчетаПриложения()
	
	Если Не ДоступенРасчетПриложения() Тогда
		Возврат;
	КонецЕсли;
	
	ДатаРасчета = РазмерПриложений.АктуальностьРасчетаРазмераПриложения();
	ИнфоАктуальностьРасчета = ?(ЗначениеЗаполнено(ДатаРасчета),
		СтрШаблон(НСтр("ru = 'Расчет размера приложения выполнен: %1'"), Формат(ДатаРасчета, НСтр("ru = 'ДФ=dd.MM.yyyy;'"))),
		НСтр("ru = 'Расчет размера приложения не выполнялся'"));

КонецПроцедуры

#КонецОбласти

#Область Прочее

&НаСервереБезКонтекста
Функция ЕстьЗапланированноеЗаданиеРасчетаРазмераПриложения()
	
	Возврат РазмерПриложений.ЕстьЗапланированноеЗаданиеРасчетаРазмераПриложения();
	
КонецФункции

&НаСервереБезКонтекста
Функция ДоступенРасчетПриложения()
	
	Если РаботаВМоделиСервиса.РазделениеВключено()
		И Не РаботаВМоделиСервиса.ДоступноИспользованиеРазделенныхДанных() Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Возврат Истина;
	
КонецФункции

&НаСервереБезКонтекста
Функция ЭтоРазделенныйСеанс()
	
	Возврат РаботаВМоделиСервиса.РазделениеВключено() И РаботаВМоделиСервиса.ДоступноИспользованиеРазделенныхДанных();
	
КонецФункции

&НаСервереБезКонтекста
Функция ЕстьДанныеДляФормированияОтчета()
	
	Если Не ДоступенРасчетПриложения() Тогда
		Возврат Истина;
	КонецЕсли;
	
	ДатаРасчета = РазмерПриложений.АктуальностьРасчетаРазмераПриложения();
	Возврат ЗначениеЗаполнено(ДатаРасчета);
	
КонецФункции

#КонецОбласти

#КонецОбласти
