﻿
////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьУсловноеОформлениеФормы();
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	ИспользоватьДатуИВремяВСрокахЗадач = ПолучитьФункциональнуюОпцию("ИспользоватьДатуИВремяВСрокахЗадач");
	Элементы.ДеревоЗадачСрокИсполнения.Формат = ?(ИспользоватьДатуИВремяВСрокахЗадач, "ДФ='дд.ММ.гггг ЧЧ:мм'", "ДЛФ=D");
	
	ЗаполнитьДеревоЗадач();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "ЗадачаИзменена" Или ИмяСобытия = "ЗадачаВыполнена" Или ИмяСобытия = "БизнесПроцессИзменен" Тогда 
		ЗаполнитьДеревоЗадач();
		Для Каждого Строка Из ДеревоЗадач.ПолучитьЭлементы() Цикл
			Элементы.ДеревоЗадач.Развернуть(Строка.ПолучитьИдентификатор(), Истина);
		КонецЦикла;
	КонецЕсли;
	
	Для Каждого Строка Из ДеревоЗадач.ПолучитьЭлементы() Цикл
		Элементы.ДеревоЗадач.Развернуть(Строка.ПолучитьИдентификатор(), Истина);
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти // ОбработчикиСобытийФормы

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ
#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Обновить(Команда)
	
	ОбновитьДеревоЗадач();
	
КонецПроцедуры

&НаКлиенте
Процедура Изменить(Команда)
	
	ОткрытьТекущуюСтрокуДереваЗадач();
	
КонецПроцедуры

&НаКлиенте
Процедура ПринятьКИсполнению(Команда)
	
	МассивЗадач = Новый Массив;
	Для каждого Эл Из Элементы.ДеревоЗадач.ВыделенныеСтроки Цикл
		Строка = ДеревоЗадач.НайтиПоИдентификатору(Эл);
		МассивЗадач.Добавить(Строка.Ссылка);
	КонецЦикла;
	
	БизнесПроцессыИЗадачиКлиент.ПринятьЗадачиКИсполнению(МассивЗадач);
	ОбновитьДеревоЗадач();
	
КонецПроцедуры

&НаКлиенте
Процедура ОтменитьПринятиеКИсполнению(Команда)
	
	МассивЗадач = Новый Массив;
	Для каждого Эл Из Элементы.ДеревоЗадач.ВыделенныеСтроки Цикл
		Строка = ДеревоЗадач.НайтиПоИдентификатору(Эл);
		МассивЗадач.Добавить(Строка.Ссылка);
	КонецЦикла;
	
	БизнесПроцессыИЗадачиКлиент.ОтменитьПринятиеЗадачКИсполнению(МассивЗадач);
	ОбновитьДеревоЗадач();
	
КонецПроцедуры

#КонецОбласти // ОбработчикиКомандФормы

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ФОРМЫ
#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура ДеревоЗадачВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ОткрытьТекущуюСтрокуДереваЗадач();
	
КонецПроцедуры

&НаКлиенте
Процедура ДеревоЗадачПриАктивизацииСтроки(Элемент)
	
	Если Элементы.ДеревоЗадач.ТекущиеДанные <> Неопределено Тогда
		ТекущаяСтрокаВДереве = Элементы.ДеревоЗадач.ТекущиеДанные.Ссылка;	
	КонецЕсли;	
	
КонецПроцедуры

#КонецОбласти // ОбработчикиСобытийЭлементовФормы

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ
#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформлениеФормы()
	
	// Шрифт поля ДеревоЗадачНаименование
	Элемент = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ДеревоЗадачНаименование.Имя);
	
	ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(Элемент.Отбор,
		"ДеревоЗадач.ПринятаКИсполнению", ВидСравненияКомпоновкиДанных.Равно, Ложь);
	
	Элемент.Оформление.УстановитьЗначениеПараметра("Шрифт", Новый Шрифт(ШрифтыСтиля.ШрифтТекста,,, Истина));
	
	// Цвет текста поля ДеревоЗадачСрокИсполнения
	Элемент = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ДеревоЗадачСрокИсполнения.Имя);
	
	ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(Элемент.Отбор,
		"ДеревоЗадач.Просрочена", ВидСравненияКомпоновкиДанных.Равно, Истина);
	
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ПросроченныеДанныеЦвет);
	
	// Цвет текста полей ДеревоЗадачНаименование, ДеревоЗадачИсполнитель
	Элемент = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ДеревоЗадачНаименование.Имя);
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ДеревоЗадачИсполнитель.Имя);
	
	ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(Элемент.Отбор,
		"ДеревоЗадач.Выполнена", ВидСравненияКомпоновкиДанных.Равно, Истина);
	
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ВыполненнаяЗадача);
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьДеревоЗадач()
	
	Дерево = РеквизитФормыВЗначение("ДеревоЗадач");
	Дерево.Строки.Очистить();
	
	ДобавитьЗадачиПоПредмету(Дерево, Параметры.Предмет);
	
	ЗначениеВДанныеФормы(Дерево, ДеревоЗадач);
	
	УстановитьТекущуюСтроку(ДеревоЗадач.ПолучитьЭлементы());
	
КонецПроцедуры	

&НаСервере
Процедура УстановитьТекущуюСтроку(ЭлементыДерева)
	
	Если Элементы.Количество() > 0 Тогда
		Для каждого Эл Из ЭлементыДерева Цикл
			Если Эл.Ссылка = ТекущаяСтрокаВДереве Тогда
				Элементы.ДеревоЗадач.ТекущаяСтрока = Эл.ПолучитьИдентификатор();
				Возврат;
			Иначе	
				УстановитьТекущуюСтроку(Эл.ПолучитьЭлементы());
			КонецЕсли;	
		КонецЦикла;	
	КонецЕсли;
	
КонецПроцедуры	

&НаСервере
Процедура ДобавитьЗадачиПоПредмету(Дерево, Предмет)
	
	Для каждого МетаданныеБизнесПроцесса Из Метаданные.БизнесПроцессы Цикл
		
		Запрос = Новый Запрос;
		Запрос.Текст = "
		|ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	БизнесПроцессы.Ссылка,
		|	БизнесПроцессы.Наименование,
		|	БизнесПроцессы.Завершен,
		|	ВЫБОР
		|		КОГДА БизнесПроцессы.Важность = ЗНАЧЕНИЕ(Перечисление.ВариантыВажностиЗадачи.Низкая)
		|			ТОГДА 0
		|		КОГДА БизнесПроцессы.Важность = ЗНАЧЕНИЕ(Перечисление.ВариантыВажностиЗадачи.Высокая)
		|			ТОГДА 2
		|		ИНАЧЕ 1
		|	КОНЕЦ КАК Важность,
		|	ВЫБОР
		|		КОГДА БизнесПроцессы.Состояние = ЗНАЧЕНИЕ(Перечисление.СостоянияБизнесПроцессов.Остановлен)
		|			ТОГДА ИСТИНА
		|		ИНАЧЕ ЛОЖЬ
		|	КОНЕЦ КАК Остановлен
		|ИЗ
		|	%БизнесПроцесс% КАК БизнесПроцессы
		|ГДЕ
		|	БизнесПроцессы.Предмет = &Предмет
		|	И БизнесПроцессы.ГлавнаяЗадача = ЗНАЧЕНИЕ(Задача.ЗадачаИсполнителя.ПустаяСсылка)
		|	И БизнесПроцессы.ПометкаУдаления = ЛОЖЬ
		|
		|УПОРЯДОЧИТЬ ПО
		|	БизнесПроцессы.Дата
		|";
			
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "%БизнесПроцесс%", МетаданныеБизнесПроцесса.ПолноеИмя());
		Запрос.УстановитьПараметр("Предмет", Предмет);
		
		Результат = Запрос.Выполнить();
		
		ВыборкаДетальныеЗаписи = Результат.Выбрать();
		
		Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
			
			Строка = Дерево.Строки.Добавить();
			
			Строка.Наименование = ВыборкаДетальныеЗаписи.Наименование;
			Строка.Важность = ВыборкаДетальныеЗаписи.Важность;
			Строка.Остановлен = ВыборкаДетальныеЗаписи.Остановлен;
			Строка.Ссылка = ВыборкаДетальныеЗаписи.Ссылка;
			Строка.Выполнена = ВыборкаДетальныеЗаписи.Завершен;
			Строка.ПринятаКИсполнению = Истина;
			Строка.Тип = 0;
			
			ДобавитьЗадачиПодчиненногоБизнесПроцесса(Дерево, ВыборкаДетальныеЗаписи.Ссылка, Неопределено);
			
		КонецЦикла;
		
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ДобавитьПодчиненныеБизнесПроцессы(Дерево, ЗадачаСсылка)
	
	Ветвь = Дерево.Строки.Найти(ЗадачаСсылка, "Ссылка", Истина);
	
	Для каждого МетаданныеБизнесПроцесса Из Метаданные.БизнесПроцессы Цикл
		
		Запрос = Новый Запрос;
		Запрос.Текст = "
		|ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	БизнесПроцессы.Ссылка,
		|	БизнесПроцессы.Наименование,
		|	БизнесПроцессы.Завершен,
		|	ВЫБОР
		|		КОГДА БизнесПроцессы.Важность = ЗНАЧЕНИЕ(Перечисление.ВариантыВажностиЗадачи.Низкая)
		|			ТОГДА 0
		|		КОГДА БизнесПроцессы.Важность = ЗНАЧЕНИЕ(Перечисление.ВариантыВажностиЗадачи.Высокая)
		|			ТОГДА 2
		|		ИНАЧЕ 1
		|	КОНЕЦ КАК Важность,
		|	ВЫБОР
		|		КОГДА БизнесПроцессы.Состояние = ЗНАЧЕНИЕ(Перечисление.СостоянияБизнесПроцессов.Остановлен)
		|			ТОГДА ИСТИНА
		|		ИНАЧЕ ЛОЖЬ
		|	КОНЕЦ КАК Остановлен
		|ИЗ
		|	%БизнесПроцесс% КАК БизнесПроцессы
		|ГДЕ
		|	БизнесПроцессы.ГлавнаяЗадача = &ГлавнаяЗадача
		|	И БизнесПроцессы.ПометкаУдаления = ЛОЖЬ
		|";
		
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "%БизнесПроцесс%", МетаданныеБизнесПроцесса.ПолноеИмя());
		Запрос.УстановитьПараметр("ГлавнаяЗадача", ЗадачаСсылка);
		
		Результат = Запрос.Выполнить();
		
		ВыборкаДетальныеЗаписи = Результат.Выбрать();
		
		Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
			
			Строка = Ветвь.Строки.Добавить();
			
			Строка.Наименование = ВыборкаДетальныеЗаписи.Наименование;
			Строка.Важность = ВыборкаДетальныеЗаписи.Важность;
			Строка.Остановлен = ВыборкаДетальныеЗаписи.Остановлен;
			Строка.Ссылка = ВыборкаДетальныеЗаписи.Ссылка;
			Строка.Выполнена = ВыборкаДетальныеЗаписи.Завершен;
			Строка.ПринятаКИсполнению = Истина;
			Строка.Тип = 0;
			
			ДобавитьЗадачиПодчиненногоБизнесПроцесса(Дерево, ВыборкаДетальныеЗаписи.Ссылка, ЗадачаСсылка);
			
		КонецЦикла;
		
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ДобавитьЗадачиПодчиненногоБизнесПроцесса(Дерево, БизнесПроцессСсылка, ЗадачаСсылка)
	
	Ветвь = Дерево.Строки.Найти(БизнесПроцессСсылка, "Ссылка", Истина);
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	Задачи.Ссылка,
		|	Задачи.Наименование,
		|	Задачи.Исполнитель,
		|	Задачи.РольИсполнителя,
		|	Задачи.СрокИсполнения,
		|	ВЫБОР
		|		КОГДА Задачи.Выполнена
		|			ТОГДА Задачи.ДатаИсполнения
		|		ИНАЧЕ ДАТАВРЕМЯ(1, 1, 1)
		|	КОНЕЦ КАК ДатаВыполнения,
		|	Задачи.Выполнена,
		|	Задачи.РезультатВыполнения,
		|	Задачи.ПринятаКИсполнению,
		|	ВЫБОР
		|		КОГДА Задачи.Важность = ЗНАЧЕНИЕ(Перечисление.ВариантыВажностиЗадачи.Низкая)
		|			ТОГДА 0
		|		КОГДА Задачи.Важность = ЗНАЧЕНИЕ(Перечисление.ВариантыВажностиЗадачи.Высокая)
		|			ТОГДА 2
		|		ИНАЧЕ 1
		|	КОНЕЦ КАК Важность,
		|	ВЫБОР
		|		КОГДА Задачи.СостояниеБизнесПроцесса = ЗНАЧЕНИЕ(Перечисление.СостоянияБизнесПроцессов.Остановлен)
		|			ТОГДА ИСТИНА
		|		ИНАЧЕ ЛОЖЬ
		|	КОНЕЦ КАК Остановлен
		|ИЗ
		|	Задача.ЗадачаИсполнителя КАК Задачи
		|ГДЕ
		|	Задачи.БизнесПроцесс = &БизнесПроцесс
		|	И Задачи.ПометкаУдаления = ЛОЖЬ
		|
		|УПОРЯДОЧИТЬ ПО
		|	Задачи.Дата";
		
	Запрос.УстановитьПараметр("БизнесПроцесс", БизнесПроцессСсылка);
	
	Результат = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = Результат.Выбрать();
	
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		
		НайденнаяВетвь = Дерево.Строки.Найти(ВыборкаДетальныеЗаписи.Ссылка, "Ссылка", Истина);
		Если НайденнаяВетвь <> Неопределено Тогда
			Дерево.Строки.Удалить(НайденнаяВетвь);
		КонецЕсли;
			
		Строка = Неопределено;
		Если Ветвь = Неопределено Тогда
			Строка = Дерево.Строки.Добавить();
		Иначе
			Строка = Ветвь.Строки.Добавить();
		КонецЕсли;
		
		Строка.Наименование = ВыборкаДетальныеЗаписи.Наименование;
		Строка.Важность = ВыборкаДетальныеЗаписи.Важность;
		Строка.Тип = 1;
		Строка.Остановлен = ВыборкаДетальныеЗаписи.Остановлен;
		Строка.Ссылка = ВыборкаДетальныеЗаписи.Ссылка;
		Строка.СрокИсполнения = ВыборкаДетальныеЗаписи.СрокИсполнения;
		Строка.ДатаВыполнения = ВыборкаДетальныеЗаписи.ДатаВыполнения;
		Строка.Выполнена = ВыборкаДетальныеЗаписи.Выполнена;
		Строка.РезультатВыполнения = ВыборкаДетальныеЗаписи.РезультатВыполнения;
		Строка.ПринятаКИсполнению = ВыборкаДетальныеЗаписи.ПринятаКИсполнению;
		
		Если ЗначениеЗаполнено(ВыборкаДетальныеЗаписи.СрокИсполнения)
		   И ВыборкаДетальныеЗаписи.СрокИсполнения < ТекущаяДатаСеанса() Тогда
			Строка.Просрочена = Не ЗначениеЗаполнено(ВыборкаДетальныеЗаписи.ДатаВыполнения)
				Или ВыборкаДетальныеЗаписи.ДатаВыполнения > КонецДня(ВыборкаДетальныеЗаписи.СрокИсполнения);
		КонецЕсли;
		
		Если Не ЗначениеЗаполнено(ВыборкаДетальныеЗаписи.Исполнитель) Тогда
			Строка.Исполнитель = ВыборкаДетальныеЗаписи.РольИсполнителя;
		Иначе
			Строка.Исполнитель = ВыборкаДетальныеЗаписи.Исполнитель;
		КонецЕсли;
		
		ДобавитьПодчиненныеБизнесПроцессы(Дерево, ВыборкаДетальныеЗаписи.Ссылка);
		
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьДеревоЗадач()
	
	ЗаполнитьДеревоЗадач();
	Для Каждого Строка Из ДеревоЗадач.ПолучитьЭлементы() Цикл
		Элементы.ДеревоЗадач.Развернуть(Строка.ПолучитьИдентификатор(), Истина);
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьТекущуюСтрокуДереваЗадач()
	
	Если Элементы.ДеревоЗадач.ТекущиеДанные <> Неопределено Тогда
		ПоказатьЗначение(, Элементы.ДеревоЗадач.ТекущиеДанные.Ссылка);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти // СлужебныеПроцедурыИФункции
