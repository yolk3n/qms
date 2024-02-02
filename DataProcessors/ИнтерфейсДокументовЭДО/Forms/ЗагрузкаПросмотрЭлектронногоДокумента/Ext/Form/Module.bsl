﻿

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	СтруктураЭД = "";
	НаправлениеЭД = "";
	 
	Если Параметры.Свойство("СтруктураЭД", СтруктураЭД) И ТипЗнч(СтруктураЭД) = Тип("Структура") И СтруктураЭД.Свойство(
		"НаправлениеЭД", НаправлениеЭД) Тогда

		ЗагрузкаЭД = (НаправлениеЭД = Перечисления.НаправленияЭДО.Входящий);

		СтруктураЭД.Свойство("ВладелецЭД", ДокументИБ);
		Если ЗагрузкаЭД И ЗначениеЗаполнено(ДокументИБ) Тогда
			СпособЗагрузкиДокумента = 1;
		КонецЕсли;
	КонецЕсли;


	ДанныеФайлаРазбора = СтруктураЭД.АдресХранилищаФайла;	
	
	ОписаниеФайла = РаботаСФайламиБЭД.НовоеОписаниеФайла();
	ОписаниеФайла.ДвоичныеДанные = ПолучитьИзВременногоХранилища(ДанныеФайлаРазбора);
	ОписаниеФайла.ИмяФайла = СтруктураЭД.ИмяФайла;

	ИмяФайла = СтруктураЭД.ИмяФайла;
	
	Если Не ЗагрузкаЭД Тогда
		Заголовок = НСтр("ru = 'Электронный документ'");
	КонецЕсли;
	
	ПараметрыФайла = ЭлектронныеДокументыЭДО.СодержаниеСообщения(ОписаниеФайла);

	ПерезаполнитьТабличныйДокумент();
	
	Если НЕ (ПараметрыФайла = Неопределено Или ПараметрыФайла.ОтражениеВУчете = Неопределено) Тогда
		ТипДокумента = ПараметрыФайла.ТипДокумента;
		ВидДокумента = ЭлектронныеДокументыЭДО.ВидДокументаПоТипу(ТипДокумента);
		Контрагент = ИнтеграцияЭДО.СсылкаНаОбъектПоИННКПП("Контрагенты", ПараметрыФайла.Отправитель.ИНН,
			ПараметрыФайла.Отправитель.КПП);
		СписокТипов = ЭлектронныеДокументыЭДО.СписокОперацийВидаДокумента(ВидДокумента);
	
		Если ТипДокумента = Перечисления.ТипыДокументовЭДО.УПД Тогда
	
			ДополнительныеВиды = ЭлектронныеДокументыЭДО.ДополнительныеВидыДокументовУПД(ОписаниеФайла);
			Для Каждого ДополнительныйВид Из ДополнительныеВиды Цикл
				ДополнительныйСписок = ЭлектронныеДокументыЭДО.СписокОперацийВидаДокумента(ДополнительныйВид);
				Для Каждого Элемент Из ДополнительныйСписок Цикл
					Если СписокДополнительныхТипов.НайтиПоЗначению(Элемент.Значение) = Неопределено Тогда
						СписокДополнительныхТипов.Добавить(Элемент.Значение, Элемент.Представление);
					КонецЕсли;
				КонецЦикла;
			КонецЦикла;
	
		ИначеЕсли ТипДокумента = Перечисления.ТипыДокументовЭДО.УКД Тогда
	
			ДополнительныйСписок = ЭлектронныеДокументыЭДО.СписокОперацийВидаДокумента(ЭлектронныеДокументыЭДО.ВидДокументаПоТипу(
					Перечисления.ТипыДокументовЭДО.СоглашениеОбИзмененииСтоимости));
			Для Каждого Элемент Из ДополнительныйСписок Цикл
				Если СписокДополнительныхТипов.НайтиПоЗначению(Элемент.Значение) = Неопределено Тогда
					СписокДополнительныхТипов.Добавить(Элемент.Значение, Элемент.Представление);
				КонецЕсли;
			КонецЦикла;
		КонецЕсли;
		Для Каждого ЭлементСписка Из СписокТипов Цикл
			Если ЗначениеЗаполнено(СписокДополнительныхТипов) Тогда
				Для Каждого ЭлементСпискаДоп Из СписокДополнительныхТипов Цикл
					Элементы.ТипОбъекта.СписокВыбора.Добавить(
								ЭлементСписка.Значение + "_И_" + ЭлементСпискаДоп.Значение, ЭлементСписка.Представление
						+ "; " + ЭлементСпискаДоп.Представление);
				КонецЦикла;
			Иначе
				Элементы.ТипОбъекта.СписокВыбора.Добавить(ЭлементСписка.Значение, ЭлементСписка.Представление);
			КонецЕсли;
		КонецЦикла;
	
		Если ЗначениеЗаполнено(Элементы.ТипОбъекта.СписокВыбора) Тогда
			ТипОбъекта = Элементы.ТипОбъекта.СписокВыбора[0].Значение;
		КонецЕсли;
	КонецЕсли;

	ИзменитьВидимостьДоступность();
	
КонецПроцедуры

&НаСервере
Процедура ПриЗагрузкеДанныхИзНастроекНаСервере(Настройки)
	
	Элементы.КомандаОтображатьДополнительнуюИнформацию.Пометка = Не ОтключитьВыводДопДанных;
	Элементы.КомандаОтображатьОбластьКопияВерна.Пометка = Не ОтключитьВыводКопияВерна;
	
	Если ОтключитьВыводДопДанных ИЛИ ОтключитьВыводКопияВерна Тогда
		ПерезаполнитьТабличныйДокумент();
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура СпособЗагрузкиДокументаПриИзменении(Элемент)
	
	ИзменитьВидимостьДоступность();
	
КонецПроцедуры

&НаКлиенте
Процедура ТипОбъектаПриИзменении(Элемент)
	
	ОбработатьВыборТипаОбъекта();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ВыполнитьДействие(Команда)
	
	Если ЗагрузкаЭД И МожноЗагрузитьЭДВида(ВидДокумента) Тогда
		
		ОчиститьСообщения();
		ЗагрузитьДокументЭДО();
		
	Иначе
		СообщитьНевозможноЗагрузитьВидЭД(ВидДокумента);		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОтображатьДополнительнуюИнформацию(Команда)
	
	ОтключитьВыводДопДанных = Не ОтключитьВыводДопДанных;
	ПерезаполнитьТабличныйДокумент();
	ОбновитьОтображениеДанных();
	Элементы.КомандаОтображатьДополнительнуюИнформацию.Пометка = Не ОтключитьВыводДопДанных;
	
КонецПроцедуры

&НаКлиенте
Процедура ОтображатьОбластьКопияВерна(Команда)
	
	ОтключитьВыводКопияВерна = Не ОтключитьВыводКопияВерна;
	ПерезаполнитьТабличныйДокумент();
	ОбновитьОтображениеДанных();
	Элементы.КомандаОтображатьОбластьКопияВерна.Пометка = Не ОтключитьВыводКопияВерна;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ПерезаполнитьТабличныйДокумент()

	Если ЗначениеЗаполнено(ДанныеФайлаРазбора) Тогда
		ДанныеФайла = ПолучитьИзВременногоХранилища(ДанныеФайлаРазбора);
		
		ПараметрыПредставления = ЭлектронныеДокументыЭДО.НовыеПараметрыВизуализацииДокумента();
		ПараметрыПредставления.ВыводитьДопДанные = Не ОтключитьВыводДопДанных;;
		ПараметрыПредставления.ВыводитьКопияВерна = Не ОтключитьВыводКопияВерна;
		
		Если ЗначениеЗаполнено(ПараметрыФайла) Тогда
			Если ПараметрыФайла.ТипДокумента = Перечисления.ТипыДокументовЭДО.Прикладной Тогда
				ВидДокумента = ЭлектронныеДокументыЭДО.ВидДокументаПоПрикладномуТипу(ПараметрыФайла.ПрикладнойТипДокумента);
			Иначе
				ВидДокумента = ЭлектронныеДокументыЭДО.ВидДокументаПоТипу(ПараметрыФайла.ТипДокумента);
			КонецЕсли;
			ТабличныйДокументФормы = ЭлектронныеДокументыЭДО.ПредставлениеДанныхСообщения(ВидДокумента, ДанныеФайла, ,
				ПараметрыПредставления).ПредставлениеДокумента;
		КонецЕсли;
	КонецЕсли;

КонецПроцедуры

&НаСервере
Процедура ИзменитьВидимостьДоступность()
	
	Элементы.ДокументИБ.Доступность = (СпособЗагрузкиДокумента = 1);
	Элементы.ДокументИБ2.Доступность = (СпособЗагрузкиДокумента = 1);	
	Элементы.Контрагент.Доступность = ((СпособЗагрузкиДокумента = 1) 
		И ТипДокумента = Перечисления.ТипыДокументовЭДО.РеквизитыОрганизации) 
		Или ТипДокумента <> Перечисления.ТипыДокументовЭДО.РеквизитыОрганизации;
	
	Если ЗагрузкаЭД Тогда

		Элементы.ГруппаКнопок.Видимость = Истина;
		Элементы.ГруппаГиперссылка.Видимость = Ложь;

		Заголовок = НСтр("ru = 'Загрузка документа из файла'");

		Если ЗначениеЗаполнено(ТипОбъекта) Тогда
			ВыбранныеСпособыОбработки = ВыбранныеСпособыОбработки();

			ОписаниеТипа = ИнтеграцияЭДО.ОписаниеТипаОбъектаПоСпособуОбработки(ВыбранныеСпособыОбработки[0]);
			ПустаяСсылкаТипа = ОписаниеТипа.ПривестиЗначение();
			
			Если ПустаяСсылкаТипа = Неопределено Тогда
				Элементы.СпособЗагрузкиДокумента.Видимость = Ложь;
				Элементы.ДокументИБ.Видимость = Ложь;
				Элементы.ДокументИБ2.Видимость = Ложь;
				СпособЗагрузкиДокумента = 0;
				Возврат;
			КонецЕсли;
			
			Элементы.ДокументИБ.Заголовок = Метаданные.НайтиПоТипу(ТипЗнч(ПустаяСсылкаТипа)).Синоним;
			ДокументИБ = ПустаяСсылкаТипа;

			ОписаниеТипа = ИнтеграцияЭДО.ОписаниеТипаОбъектаПоСпособуОбработки(ВыбранныеСпособыОбработки[0]);
			ПустаяСсылкаТипа = ОписаниеТипа.ПривестиЗначение();
			Элементы.ДокументИБ.Заголовок = Метаданные.НайтиПоТипу(ТипЗнч(ПустаяСсылкаТипа)).Синоним;
			Элементы.ДокументИБ.ОграничениеТипа = ИнтеграцияЭДО.ОписаниеТипаОбъектаПоСпособуОбработки(
				ВыбранныеСпособыОбработки[0]);
			ДокументИБ = ПустаяСсылкаТипа;
			
			Если ВыбранныеСпособыОбработки.Количество() = 2 Тогда
				ОписаниеТипа = ИнтеграцияЭДО.ОписаниеТипаОбъектаПоСпособуОбработки(ВыбранныеСпособыОбработки[1]);
				ПустаяСсылкаТипа = ОписаниеТипа.ПривестиЗначение();
				Если ПустаяСсылкаТипа <> Неопределено Тогда
					Элементы.ДокументИБ2.Заголовок = Метаданные.НайтиПоТипу(ТипЗнч(ПустаяСсылкаТипа)).Синоним;
					Элементы.ДокументИБ2.ОграничениеТипа = ИнтеграцияЭДО.ОписаниеТипаОбъектаПоСпособуОбработки(
						ВыбранныеСпособыОбработки[1]);
					ДокументИБ2 = ПустаяСсылкаТипа;
				КонецЕсли;
			КонецЕсли;

			Элементы.ДокументИБ2.Видимость = ВыбранныеСпособыОбработки.Количество() = 2;
		ИначеЕсли ЭтотОбъект.ВидДокумента = ЭлектронныеДокументыЭДО.ВидДокументаПоТипу(Перечисления.ТипыДокументовЭДО.РеквизитыОрганизации) Тогда
			Элементы.СпособЗагрузкиДокумента.Видимость = Ложь;
			Элементы.ДокументИБ.Видимость = Ложь;
			Элементы.ДокументИБ2.Видимость = Ложь;
			Элементы.ТипОбъекта.Видимость = Ложь;
			Элементы.СпособЗагрузкиДокумента.Видимость = Истина;
		Иначе
			Элементы.ГруппаНастроекДокументы.Видимость = Ложь;
			Элементы.КомандаВыполнить.Видимость = Ложь;
		КонецЕсли;

	Иначе
		 
		Элементы.ГруппаИнформация.Видимость = Ложь;
		Элементы.ГруппаНастроекДокументы.Видимость = Ложь;
		Элементы.КомандаВыполнить.Видимость = Ложь; 
		 
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция МожноЗагрузитьЭДВида(Знач ВидДокумента)

	ИспользуемыеВидыДокументовВходящие = ЭлектронныеДокументыЭДО.ИспользуемыеВидыДокументовВходящие();
	ИспользуемыеВидыДокументовИнтеркампани = ЭлектронныеДокументыЭДО.ИспользуемыеВидыДокументовИнтеркампани();
	МожноЗагрузить = ИспользуемыеВидыДокументовВходящие.Найти(ВидДокумента) <> Неопределено
		Или ИспользуемыеВидыДокументовИнтеркампани.Найти(ВидДокумента) <> Неопределено
		Или ВидДокумента = ЭлектронныеДокументыЭДО.ВидДокументаПоТипу(Перечисления.ТипыДокументовЭДО.РеквизитыОрганизации);

	Возврат МожноЗагрузить;

КонецФункции

&НаКлиенте
Процедура ОбработатьВыборТипаОбъекта()
	
	Если ЗначениеЗаполнено(ТипОбъекта) Тогда
		ИзменитьВидимостьДоступность()
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьДокументЭДО()
	
	Отказ = Ложь;
	ТекстСообщения = "";
	
	Если Не ЗначениеЗаполнено(Контрагент) 
		И (ЭтотОбъект.ТипДокумента <> ПредопределенноеЗначение("Перечисление.ТипыДокументовЭДО.РеквизитыОрганизации")
		Или СпособЗагрузкиДокумента = 1 И ЭтотОбъект.ТипДокумента = ПредопределенноеЗначение("Перечисление.ТипыДокументовЭДО.РеквизитыОрганизации")) Тогда
		ТекстСообщения = НСтр("ru = 'Не указан контрагент.'");
		ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения);
		Отказ = Истина;
	КонецЕсли;
	
	ВыбранныеСпособыОбработки = ВыбранныеСпособыОбработки();
	
	Если ЭтотОбъект.ТипДокумента = ПредопределенноеЗначение("Перечисление.ТипыДокументовЭДО.РеквизитыОрганизации") Тогда 
	
	ИначеЕсли СпособЗагрузкиДокумента = 1 Тогда
		
		Если Не ЗначениеЗаполнено(ДокументИБ) Тогда
			ТекстСообщения = НСтр("ru = 'Не указан документ для перезаполнения.'");
			ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения);
			Отказ = Истина;
			
		ИначеЕсли Не ЗначениеЗаполнено(ДокументИБ2) И ВыбранныеСпособыОбработки.Количество() = 2 Тогда
			ТекстСообщения = НСтр("ru = 'Не указан документ для перезаполнения.'");
			ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения);
			Отказ = Истина;
		Иначе
			Если ДокументПроведен() Тогда
				Шаблон = НСтр("ru = 'Обработка документа %1.
							|Операция возможна только для непроведенных документов.'");
				ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(Шаблон, ДокументИБ);
				ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения);
				Отказ = Истина;
			КонецЕсли;
		КонецЕсли;
		
	КонецЕсли;
	
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	ДанныеДокументооборота = ИнтеграцияЭДОКлиентСервер.НовыеДанныеЭлектронногоДокументаДляОтраженияВУчете();		
	ДанныеДокументооборота.ВидДокумента = ВидДокумента;
	ДанныеДокументооборота.ТипДокумента = ТипДокумента;
	ДанныеДокументооборота.ДанныеОсновногоФайла.ИмяФайла = ИмяФайла;
	ДанныеДокументооборота.ДанныеОсновногоФайла.ДвоичныеДанные = ПолучитьИзВременногоХранилища(ДанныеФайлаРазбора);
	ДанныеДокументооборота.Направление = ПредопределенноеЗначение("Перечисление.НаправленияЭДО.Входящий");
	ДанныеДокументооборота.Отправитель = Контрагент;
		
	ОповещениеОкончанияОтраженияВУчете = Новый ОписаниеОповещения("ПослеЗавершенияОтраженияВУчете", ЭтотОбъект);
	
	ОбъектыУчета = Новый Массив;	
	
	Если ЭтотОбъект.ТипДокумента = ПредопределенноеЗначение("Перечисление.ТипыДокументовЭДО.РеквизитыОрганизации") 
		И СпособЗагрузкиДокумента = 1 Тогда 
		Если ЗначениеЗаполнено(Контрагент) Тогда
			ОбъектыУчета.Добавить(Контрагент);
		КонецЕсли;	
	ИначеЕсли СпособЗагрузкиДокумента = 1 Тогда
		Если ЗначениеЗаполнено(ДокументИБ) Тогда
			ОбъектыУчета.Добавить(ДокументИБ);
		КонецЕсли;	
		
		Если ЗначениеЗаполнено(ДокументИБ2) Тогда
			ОбъектыУчета.Добавить(ДокументИБ2);
		КонецЕсли;	
	КонецЕсли;
	
	Если ВыбранныеСпособыОбработки.Количество() = 2 Тогда
		ВыбранныеСпособыОбработки = Новый Структура("СчетФактура, ПервичныйДокумент", ВыбранныеСпособыОбработки[0],
			ВыбранныеСпособыОбработки[1]);
	ИначеЕсли ЭтотОбъект.ТипДокумента <> ПредопределенноеЗначение("Перечисление.ТипыДокументовЭДО.РеквизитыОрганизации") Тогда 
		ВыбранныеСпособыОбработки = ВыбранныеСпособыОбработки[0];
	КонецЕсли;
	
	ИнтеграцияЭДОКлиент.НачатьОтражениеДокументаВУчете(ОповещениеОкончанияОтраженияВУчете, ДанныеДокументооборота,
		ОбъектыУчета, ВыбранныеСпособыОбработки);

КонецПроцедуры

&НаКлиенте
Процедура ПослеЗавершенияОтраженияВУчете(Результат, ДополнительныеПараметры) Экспорт
	
	Если ЗначениеЗаполнено(Результат) Тогда
		Для Каждого ОбъектУчета Из Результат Цикл
			ПоказатьЗначение(Неопределено, ОбъектУчета);
		КонецЦикла;	
	КонецЕсли;
		
КонецПроцедуры

&НаСервере
Функция ДокументПроведен()
	
	Проведен = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ДокументИБ, "Проведен");
	Возврат Проведен;
	
КонецФункции

&НаКлиенте
Процедура СообщитьНевозможноЗагрузитьВидЭД(ТипЭД)
	
	ТекстСообщения = НСтр("ru = 'Не поддерживается загрузка электронных документов вида ""%1"".'");
	ТекстСообщения = СтрЗаменить(ТекстСообщения, "%1", ВидДокумента);
	ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения);
	
КонецПроцедуры

&НаСервере
Функция ВыбранныеСпособыОбработки()
	
	СпособыОбработки = Новый Массив;
	
	Если ЗначениеЗаполнено(ТипОбъекта) Тогда
		СпособыОбработки = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(ТипОбъекта, "_И_");
	КонецЕсли;
	
	Возврат СпособыОбработки;
	
КонецФункции

#КонецОбласти
