﻿#Область СлужебныйПрограммныйИнтерфейс

// Размещает команды ЭДО на форме.
//
// Параметры:
//   ПараметрыРазмещенияКоманд - см. ПодключаемыеКомандыЭДО.ПараметрыРазместитьНаФормеКомандыЭДО
//
Процедура РазместитьНаФормеКомандыЭДО(ПараметрыРазмещенияКоманд) Экспорт

	Форма = ПараметрыРазмещенияКоманд.Форма;
	МестоРазмещенияКомандПоУмолчанию = ПараметрыРазмещенияКоманд.МестоРазмещенияКоманд;

	КомандыЭДО = ПодключаемыеКомандыЭДОСлужебныйПовтИсп.КомандыЭДОФормы(Форма.ИмяФормы,
		ПараметрыРазмещенияКоманд.Направление, Ложь).Скопировать();
	ОпределитьВидимостьКомандЭДОПоФункциональнымОпциям(КомандыЭДО, Форма);

	Если МестоРазмещенияКомандПоУмолчанию <> Неопределено Тогда
		Для Каждого КомандаЭДО Из КомандыЭДО Цикл
			Если ПустаяСтрока(КомандаЭДО.МестоРазмещения) Тогда
				КомандаЭДО.МестоРазмещения = МестоРазмещенияКомандПоУмолчанию.Имя;
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;

	КомандыЭДО.Колонки.Добавить("ИмяКомандыНаФорме", Новый ОписаниеТипов("Строка"));

	ТаблицаКоманд = КомандыЭДО.Скопировать( , "МестоРазмещения");
	ТаблицаКоманд.Свернуть("МестоРазмещения");
	МестаРазмещения = ТаблицаКоманд.ВыгрузитьКолонку("МестоРазмещения");

	Если МестоРазмещенияКомандПоУмолчанию = Неопределено Тогда
		МестоРазмещенияКоманд = Форма.КоманднаяПанель;
		ПодменюЭДО = Форма.Элементы.Добавить(МестоРазмещенияКоманд.Имя + "КомандыЭДО", Тип("ГруппаФормы"),
			МестоРазмещенияКоманд);
		ПодменюЭДО.Вид = ВидГруппыФормы.Подменю;
		ПодменюЭДО.Заголовок = НСтр("ru = 'ЭДО'");
		МестоРазмещенияКомандПоУмолчанию = ПодменюЭДО;
	КонецЕсли;

	КартинкаОповещений = БиблиотекаКартинок.ЭмблемаСервиса1СЭДО;
	Если СинхронизацияЭДО.ЕстьСобытияЭДО() Тогда
		КартинкаОповещений = БиблиотекаКартинок.ВосклицательныйЗнакКрасный;
	КонецЕсли;
	МестоРазмещенияКомандПоУмолчанию.Картинка = КартинкаОповещений;

	Если КомандыЭДО.Количество() = 1 Тогда
		МестоРазмещенияКомандПоУмолчанию.Вид = ВидГруппыФормы.ГруппаКнопок;
	КонецЕсли;

	Для Каждого МестоРазмещения Из МестаРазмещения Цикл
		НайденныеКоманды = КомандыЭДО.НайтиСтроки(
			Новый Структура("МестоРазмещения,СкрытаФункциональнымиОпциями,Отключена", МестоРазмещения, Ложь, Ложь));
		ЭлементФормыДляРазмещения = Форма.Элементы.Найти(МестоРазмещения);
		Если ЭлементФормыДляРазмещения = Неопределено Тогда
			ЭлементФормыДляРазмещения = МестоРазмещенияКомандПоУмолчанию;
		КонецЕсли;

		Если НайденныеКоманды.Количество() > 0 Тогда
			ДобавитьКомандыЭДО(Форма, НайденныеКоманды, ЭлементФормыДляРазмещения,
				ПараметрыРазмещенияКоманд.ИсточникКомандЭДО);
		КонецЕсли;
	КонецЦикла;

	АдресКомандЭДОВоВременномХранилище = "АдресКомандЭДОВоВременномХранилище";
	КомандаФормы = Форма.Команды.Найти(АдресКомандЭДОВоВременномХранилище);
	Если КомандаФормы = Неопределено Тогда
		КомандаФормы = Форма.Команды.Добавить(АдресКомандЭДОВоВременномХранилище);
		КомандаФормы.Действие = ПоместитьВоВременноеХранилище(КомандыЭДО, Форма.УникальныйИдентификатор);
	Иначе
		ОбщийСписокКомандЭДОФормы = ПолучитьИзВременногоХранилища(КомандаФормы.Действие);
		Для Каждого КомандаЭДО Из КомандыЭДО Цикл
			ЗаполнитьЗначенияСвойств(ОбщийСписокКомандЭДОФормы.Добавить(), КомандаЭДО);
		КонецЦикла;
		КомандаФормы.Действие = ПоместитьВоВременноеХранилище(ОбщийСписокКомандЭДОФормы, Форма.УникальныйИдентификатор);
	КонецЕсли;

КонецПроцедуры

// Возвращает список команд ЭДО для указанной формы.
//
// Параметры:
//  Форма - ФормаКлиентскогоПриложения, Строка - форма или полное имя формы
//  НаправлениеЭД - ПеречислениеСсылка.НаправленияЭДО - направление документа, для которого выполняется команда;
//  ТолькоВМенюЕще - Булево
//
// Возвращаемое значение:
//  ТаблицаЗначений - см. СоздатьКоллекциюКомандЭДО
//
Функция КомандыЭДОФормы(Форма, НаправлениеЭД, ТолькоВМенюЕще) Экспорт
	
	Если ТипЗнч(Форма) = Тип("ФормаКлиентскогоПриложения") Тогда
		ИмяФормы = Форма.ИмяФормы;
	Иначе
		ИмяФормы = Форма;
	КонецЕсли;
	
	КомандыЭДО = СоздатьКоллекциюКомандЭДО();
	
	ОбъектМетаданных = Метаданные.НайтиПоПолномуИмени(ИмяФормы);
	Если ОбъектМетаданных <> Неопределено 
		И Не Метаданные.ОбщиеФормы.Содержит(ОбъектМетаданных) Тогда
		ОбъектМетаданных = ОбъектМетаданных.Родитель();
	КонецЕсли;
	
	ДобавляемыеКомандыЭДО = СоздатьКоллекциюКомандЭДО();
	СформироватьКомандыЭДО(ОбъектМетаданных.ПолноеИмя(), ДобавляемыеКомандыЭДО, НаправлениеЭД, ТолькоВМенюЕще);
	
	Для Каждого КомандаЭДО Из ДобавляемыеКомандыЭДО Цикл
		Если КомандыЭДО.Найти(КомандаЭДО.Идентификатор, "Идентификатор") = Неопределено Тогда
			ЗаполнитьЗначенияСвойств(КомандыЭДО.Добавить(), КомандаЭДО);	
		КонецЕсли;
	КонецЦикла;
	
	КомандыЭДО.Сортировать("Порядок Возр, Представление Возр");
	
	ЧастиИмени = СтрРазделить(ИмяФормы, ".");
	КраткоеИмяФормы = ЧастиИмени[ЧастиИмени.Количество()-1];
	
	// фильтр по именам форм
	Для НомерСтроки = -КомандыЭДО.Количество() + 1 По 0 Цикл
		КомандаЭДО = КомандыЭДО[-НомерСтроки];
		СписокФорм = СтрРазделить(КомандаЭДО.СписокФорм, ",", Ложь);
		Если СписокФорм.Количество() > 0 И СписокФорм.Найти(КраткоеИмяФормы) = Неопределено Тогда
			КомандыЭДО.Удалить(КомандаЭДО);
		КонецЕсли;
	КонецЦикла;
	
	ОпределитьВидимостьКомандЭДОПоФункциональнымОпциям(КомандыЭДО, Форма);
	
	Возврат КомандыЭДО;
	
КонецФункции

// Проверяет, доступна ли команда выгрузки данных в файл для переданных объектов.
//
// Параметры:
//  МассивОбъектов - Массив - объекты, для которых вызвана команда.
//
// Возвращаемое значение:
//  Булево - Истина, если команда выгрузки доступна.
//
Функция ВыгрузкаДанныхВФайлДоступнаДляОбъектов(МассивОбъектов) Экспорт
	
	Если Не ЗначениеЗаполнено(МассивОбъектов) Тогда
		Возврат Ложь;
	КонецЕсли;
	
	СоставКоманд = КомандыЭДО();
	ПодключаемыеКомандыЭДОСобытия.ПриОпределенииСоставаКомандЭДО(СоставКоманд);
	
	ПроверенныеВиды = Новый Соответствие;
	Для каждого ТекущийОбъект Из МассивОбъектов Цикл
		ПолноеИмя = ТекущийОбъект.Метаданные().ПолноеИмя();
		Если ПроверенныеВиды[ПолноеИмя] <> Неопределено Тогда
			Продолжить;
		КонецЕсли;
		Если СоставКоманд.Исходящие.Найти(ПолноеИмя) = Неопределено
			И СоставКоманд.БезПодписи.Найти(ПолноеИмя) = Неопределено
			И СоставКоманд.Организации.Найти(ПолноеИмя) = Неопределено Тогда
			Возврат Ложь;
		КонецЕсли;
		ПроверенныеВиды.Вставить(ПолноеИмя, Истина);
	КонецЦикла;
	
	Возврат Истина;
	
КонецФункции
 
// Параметры управления видимостью команд ЭДО.
// 
// Возвращаемое значение:
//  Структура:
// * ЕстьУсловияВидимости - Булево
// * КомандыСУсловиямиВидимости - Массив Из см. УсловиеВидимости
// * УсловияВидимостиВТаблицеФормы - Булево
//
Функция ПараметрыУправленияВидимостьюЭДО() Экспорт
	ПараметрыУправленияВидимостьюЭДО = Новый Структура;
	ПараметрыУправленияВидимостьюЭДО.Вставить("ЕстьУсловияВидимости", Ложь);
	ПараметрыУправленияВидимостьюЭДО.Вставить("КомандыСУсловиямиВидимости", Новый Массив);
	ПараметрыУправленияВидимостьюЭДО.Вставить("УсловияВидимостиВТаблицеФормы", Ложь);
	Возврат ПараметрыУправленияВидимостьюЭДО;
КонецФункции

// Вычислить значение алгоритма.
// 
// Параметры:
//  Алгоритм - Строка 
//  ПараметрАлгоритма - Массив из ЛюбаяСсылка
// 
// Возвращаемое значение:
//  Произвольный
//
Функция ВычислитьЗначениеАлгоритма(Знач Алгоритм, Знач ПараметрАлгоритма) Экспорт
	СтрокаВычисления = СтрШаблон("%1(Параметры)", Алгоритм);
	Возврат ОбщегоНазначения.ВычислитьВБезопасномРежиме(СтрокаВычисления, ПараметрАлгоритма);
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Формирование команд ЭДО.
//
// Параметры:
//  ПолноеИмя - Строка - имя объекта, например "Документ.РеализацияТоваровУслуг".
//  КомандыЭДО - см. СоздатьКоллекциюКомандЭДО
//  НаправлениеЭД - ПеречислениеСсылка.НаправленияЭДО - параметр отбора входящих или исходящих документов.
//  ТолькоВМенюЕще - Булево
//
Процедура СформироватьКомандыЭДО(ПолноеИмя, КомандыЭДО, НаправлениеЭД = Неопределено, ТолькоВМенюЕще = Ложь)
	
	СоставКоманд = КомандыЭДО();	
	
	ПодключаемыеКомандыЭДОСобытия.ПриОпределенииСоставаКомандЭДО(СоставКоманд);	
	ПодключаемыеКомандыЭДОСобытия.ПриОпределенииСпискаКомандЭДО(СоставКоманд, ПолноеИмя, НаправлениеЭД, КомандыЭДО);
	
КонецПроцедуры


// Возвращает структуру, используемых в БЭД команд.
// 
// Возвращаемое значение:
//  Структура - пустая структура массивов:
// * Исходящие - Массив Из Строка
// * Входящие - Массив Из Строка
// * Внутренние - Массив Из Строка
// * БезПодписи - Массив Из Строка
// * Интеркампани - Массив Из Строка
// * Контрагенты - Массив Из Строка
// * Организации - Массив Из Строка
// * Договоры - Массив Из Строка
//
Функция КомандыЭДО() Экспорт
	
	Команды = Новый Структура;
	Команды.Вставить("Исходящие", Новый Массив);
	Команды.Вставить("Входящие", Новый Массив);
	Команды.Вставить("Внутренние", Новый Массив);
	Команды.Вставить("БезПодписи", Новый Массив);
	Команды.Вставить("Интеркампани", Новый Массив);
	Команды.Вставить("Контрагенты", Новый Массив);
	Команды.Вставить("Организации", Новый Массив);
	Команды.Вставить("Договоры", Новый Массив);
	
	Возврат Команды;
	
КонецФункции

// Создает пустую таблицу для размещения в нее команд ЭДО.
// 
// Возвращаемое значение:
//  ТаблицаЗначений - описание команд ЭДО:
//
//  * Идентификатор - Строка - Идентификатор команды ЭДО, по которому менеджер ЭДО определяет печатную
//                             форму, которую необходимо сформировать.
//                             Пример: "СчетЗаказ".
//                  - Массив - список идентификаторов команд ЭДО.
//
//  * Представление - Строка            - Представление команды в меню ЭДО. 
//                                         Пример: "Просмотр документа".
//
//  * Обработчик    - Строка            - (необязательный) Клиентский обработчик команды, в который необходимо передать
//                                        управление.
//
//  * Порядок       - Число             - (необязательный) Значение от 1 до 100, указывающее порядок размещения команды
//                                        по отношению к другим командам. Сортировка команд меню ЭДО осуществляется
//                                        сначала по полю Порядок, затем по представлению.
//                                        Значение по умолчанию: 50.
//
//  * Картинка      - Картинка          - (необязательный) Картинка, которая отображается возле команды в меню ЭДО.
//                                         Пример: БиблиотекаКартинок.ФорматPDF.
//
//  * СписокФорм    - Строка            - (необязательный) Имена форм через запятую, в которых должна отображаться
//                                        команда. Если параметр не указан, то команда ЭДО будет отображаться во
//                                        всех формах объекта, где встроена подсистема ЭДО.
//                                         Пример: "ФормаДокумента".
//
//  * МестоРазмещения - Строка          - (необязательный) Имя командной панели формы, в которую необходимо разместить
//                                        команду ЭДО. Параметр необходимо использовать только в случае, когда на
//                                        форме размещается более одного подменю "ЭДО". В остальных случаях место
//                                        размещения необходимо задавать в модуле формы при вызове метода.
//                                        
//  * ФункциональныеОпции - Строка      - (необязательный) Имена функциональных опций через запятую, от которых зависит
//                                        доступность команды ЭДО.
//
Функция СоздатьКоллекциюКомандЭДО()
	
	Результат = Новый ТаблицаЗначений;
	
	// описание
	Результат.Колонки.Добавить("Идентификатор", Новый ОписаниеТипов("Строка"));
	Результат.Колонки.Добавить("Представление", Новый ОписаниеТипов("Строка"));
	
	//////////
	// Опции (необязательные параметры).
	
	// Альтернативный обработчик команды.
	Результат.Колонки.Добавить("Обработчик", Новый ОписаниеТипов("Строка"));
	
	// представление
	Результат.Колонки.Добавить("Порядок", Новый ОписаниеТипов("Число"));
	Результат.Колонки.Добавить("Картинка", Новый ОписаниеТипов("Картинка"));
	Результат.Колонки.Добавить("Отображение", Новый ОписаниеТипов("ОтображениеКнопки"));
	
	// Имена форм для размещения команд, разделитель - запятая.
	Результат.Колонки.Добавить("СписокФорм", Новый ОписаниеТипов("Строка"));
	Результат.Колонки.Добавить("МестоРазмещения", Новый ОписаниеТипов("Строка"));
	// Имена функциональных опций, влияющих на видимость команды, разделитель - запятая.
	Результат.Колонки.Добавить("ФункциональныеОпции", Новый ОписаниеТипов("Строка"));
	
	Результат.Колонки.Добавить("РежимИспользованияПараметра", Новый ОписаниеТипов("РежимИспользованияПараметраКоманды"));
	
	// дополнительные параметры
	Результат.Колонки.Добавить("ДополнительныеПараметры", Новый ОписаниеТипов("Структура"));
	
	// Специальный режим выполнения команды
	// по умолчанию выполняется запись модифицированного объекта перед выполнением команды.
	Результат.Колонки.Добавить("НеВыполнятьЗаписьВФорме", Новый ОписаниеТипов("Булево"));
	
	// Для служебного использования.
	Результат.Колонки.Добавить("СкрытаФункциональнымиОпциями", Новый ОписаниеТипов("Булево"));
	Результат.Колонки.Добавить("УникальныйИдентификатор", Новый ОписаниеТипов("Строка"));
	Результат.Колонки.Добавить("Отключена", Новый ОписаниеТипов("Булево"));
	Результат.Колонки.Добавить("УправлениеВидимостью", Новый ОписаниеТипов("Структура"));
	
	Результат.Колонки.Добавить("ТолькоВоВсехДействиях", Новый ОписаниеТипов("Булево"));
	Результат.Колонки.Добавить("Недоступна", Новый ОписаниеТипов("Булево"));
	
	Возврат Результат;
	
КонецФункции

Функция ЭтоФормаОбъекта(Форма)
	Возврат ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(Форма, "Объект");
КонецФункции

Процедура ДобавитьКомандуФормы(Форма, ОписаниеКомандыЭДО)
	КомандаФормы = Форма.Команды.Добавить(ОписаниеКомандыЭДО.ИмяКомандыНаФорме);
	КомандаФормы.Действие = "Подключаемый_ВыполнитьКомандуЭДО";
	КомандаФормы.Заголовок = ОписаниеКомандыЭДО.Представление;
	КомандаФормы.ИзменяетСохраняемыеДанные = Ложь;
	
	Если ЗначениеЗаполнено(ОписаниеКомандыЭДО.Отображение) Тогда 
		КомандаФормы.Отображение = ОписаниеКомандыЭДО.Отображение;
	Иначе 
		КомандаФормы.Отображение = ОтображениеКнопки.КартинкаИТекст;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ОписаниеКомандыЭДО.Картинка) Тогда
		КомандаФормы.Картинка = ОписаниеКомандыЭДО.Картинка;
	КонецЕсли;
КонецПроцедуры

Функция СформироватьИмяКоманды(ОписаниеКомандыЭДО, МестоРазмещенияКоманд)
	Возврат СтрШаблон("%1%2%3", МестоРазмещенияКоманд.Имя, ОписаниеКомандыЭДО.Идентификатор,
		ОписаниеКомандыЭДО.Владелец().Индекс(ОписаниеКомандыЭДО));
КонецФункции

Процедура ДобавитьКнопкуФормы(Форма, ОписаниеКомандыЭДО, МестоРазмещения, Видимость)
	НовыйЭлемент = Форма.Элементы.Добавить(ОписаниеКомандыЭДО.ИмяКомандыНаФорме, Тип("КнопкаФормы"), МестоРазмещения);
	НовыйЭлемент.Вид = ВидКнопкиФормы.КнопкаКоманднойПанели;
	НовыйЭлемент.ИмяКоманды = ОписаниеКомандыЭДО.ИмяКомандыНаФорме;
	НовыйЭлемент.Видимость = Видимость;
	НовыйЭлемент.ТолькоВоВсехДействиях = ОписаниеКомандыЭДО.ТолькоВоВсехДействиях;
КонецПроцедуры

Функция УсловиеВидимости(ОписаниеКомандыЭДО)
	УсловияВидимости = Новый Структура;
	УсловияВидимости.Вставить("ИмяВФорме", ОписаниеКомандыЭДО.ИмяКомандыНаФорме);
	УсловияВидимости.Вставить("ИмяРеквизитаУсловия", Неопределено);
	УсловияВидимости.Вставить("ИмяАлгоритмаПроверкиУсловия", Неопределено);
	УсловияВидимости.Вставить("ЗначениеУсловия", Неопределено);
	ЗаполнитьЗначенияСвойств(УсловияВидимости, ОписаниеКомандыЭДО.УправлениеВидимостью);
	Возврат УсловияВидимости;
КонецФункции

Функция ОпределитьВидимостьКоманды(ПараметрыУправленияВидимостьюЭДО, ОписаниеКомандыЭДО)
	Видимость = Не ОписаниеКомандыЭДО.Недоступна;		
	Если ОписаниеКомандыЭДО.УправлениеВидимостью.Свойство("Использовать")
		И ОписаниеКомандыЭДО.УправлениеВидимостью.Использовать
		И Видимость Тогда
		
		УсловиеВидимости = УсловиеВидимости(ОписаниеКомандыЭДО);
		ПараметрыУправленияВидимостьюЭДО.КомандыСУсловиямиВидимости.Добавить(УсловиеВидимости);
		Видимость = Ложь;
	КонецЕсли;
	Возврат Видимость;
КонецФункции

Функция НайтиСоздатьМестоРазмещения(Форма, ОписаниеКомандыЭДО, МестоРазмещения, МестоРазмещенияКоманд)
	// Для платформенной команды ввода на основании не добавляем префикс, чтобы команды не отделялись чертой.
	Если ОписаниеКомандыЭДО.МестоРазмещения = "ФормаСоздатьНаОсновании" Тогда
		МестоРазмещенияИмя = ОписаниеКомандыЭДО.МестоРазмещения;
	Иначе
		МестоРазмещенияИмя = МестоРазмещенияКоманд.Имя + ОписаниеКомандыЭДО.МестоРазмещения;
	КонецЕсли;

	Если Форма.Элементы.Найти(МестоРазмещенияИмя) = Неопределено Тогда
		МестоРазмещения = Форма.Элементы.Добавить(МестоРазмещенияИмя, Тип("ГруппаФормы"), МестоРазмещения);
		МестоРазмещения.Вид = ВидГруппыФормы.ГруппаКнопок;
		МестоРазмещения.Заголовок = СтрЗаменить(ОписаниеКомандыЭДО.МестоРазмещения, "КомандыЭДО", "");
	КонецЕсли;
	Возврат МестоРазмещения;
КонецФункции

Процедура ДополнитьПараметрыУправленияВидимостьюНаФорме(Форма, ПараметрыУправленияВидимостьюЭДО, ИсточникКомандЭДО)
	Если ЗначениеЗаполнено(ПараметрыУправленияВидимостьюЭДО.КомандыСУсловиямиВидимости) Тогда
		ПараметрыУправленияВидимостьюЭДО.ЕстьУсловияВидимости = Истина;
		Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(Форма, "ПараметрыУправленияВидимостьюЭДО") Тогда
			Если ТипЗнч(Форма.ПараметрыУправленияВидимостьюЭДО) = Тип("Структура")
				И Форма.ПараметрыУправленияВидимостьюЭДО.КомандыСУсловиямиВидимости <> Неопределено Тогда
				ОбщегоНазначенияКлиентСервер.ДополнитьМассив(ПараметрыУправленияВидимостьюЭДО.КомандыСУсловиямиВидимости,
					Форма.ПараметрыУправленияВидимостьюЭДО.КомандыСУсловиямиВидимости, Истина);
			КонецЕсли;
		Иначе
			Реквизит = Новый РеквизитФормы("ПараметрыУправленияВидимостьюЭДО", Новый ОписаниеТипов);
			ДобавляемыеРеквизиты = ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(Реквизит);
			Форма.ИзменитьРеквизиты(ДобавляемыеРеквизиты);
		КонецЕсли;
		Форма.ПараметрыУправленияВидимостьюЭДО = ПараметрыУправленияВидимостьюЭДО;
		Если ТипЗнч(ИсточникКомандЭДО) = Тип("ДинамическийСписок") Тогда
			РазместитьПараметрыУправленияВидимостьюВДинамическомСписке(ИсточникКомандЭДО,
				ПараметрыУправленияВидимостьюЭДО);
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

// Размещает параметры видимости в настройках компоновки динамического списка,
// чтобы они были видны в событии ПриПолученииДанныхНаСервере
// 
// Параметры:
//  ИсточникКомандЭДО - ДинамическийСписок
//  ПараметрыУправленияВидимостьюЭДО - см. ПараметрыУправленияВидимостьюЭДО
//
Процедура РазместитьПараметрыУправленияВидимостьюВДинамическомСписке(ИсточникКомандЭДО,
	ПараметрыУправленияВидимостьюЭДО)
	ПолеСоЗначениямиВидимости = ПодключаемыеКомандыЭДОКлиентСервер.ИмяПоляЗначенийВидимостиКомандЭДО();
	ОбщегоНазначенияБЭД.ДобавитьСлужебноеПолеВДинамическийСписок(ИсточникКомандЭДО, ПолеСоЗначениямиВидимости);
	ИсточникКомандЭДО.КомпоновщикНастроек.Настройки.ДополнительныеСвойства.Вставить(
		"ПараметрыУправленияВидимостьюЭДО", ПараметрыУправленияВидимостьюЭДО);
КонецПроцедуры

// Размещает на форме команды, кнопки ЭДО, а также параметры управления видимостью
// 
// Параметры:
//  Форма - ФормаКлиентскогоПриложения
//  КомандыЭДО - см. СформироватьИмяКоманды
//  МестоРазмещенияКоманд - РасширениеГруппыФормыДляПодменю
//  ИсточникКомандЭДО - ДинамическийСписок
//
Процедура ДобавитьКомандыЭДО(Форма, КомандыЭДО, Знач МестоРазмещенияКоманд = Неопределено, ИсточникКомандЭДО = Неопределено)

	ПараметрыУправленияВидимостьюЭДО = ПараметрыУправленияВидимостьюЭДО();
	ПараметрыУправленияВидимостьюЭДО.УсловияВидимостиВТаблицеФормы = ТипЗнч(ИсточникКомандЭДО) = Тип("ДинамическийСписок");
	ЭтоФормаОбъекта = ЭтоФормаОбъекта(Форма);

	МестоРазмещения = МестоРазмещенияКоманд;
	Для Каждого ОписаниеКомандыЭДО Из КомандыЭДО Цикл
		// Отключение команды загрузки ЭД без ЭП в формах документов.
		Если ОписаниеКомандыЭДО.Идентификатор = "ЗагрузитьЧерезБизнесСеть" И ЭтоФормаОбъекта Тогда
			Продолжить;
		КонецЕсли;
		ОписаниеКомандыЭДО.ИмяКомандыНаФорме = СформироватьИмяКоманды(ОписаниеКомандыЭДО, МестоРазмещенияКоманд);
		ДобавитьКомандуФормы(Форма, ОписаниеКомандыЭДО);
		// Если видимость команды условная, то заполняется ПараметрыУправленияВидимостьюЭДО 
		НачальнаяВидимость = ОпределитьВидимостьКоманды(ПараметрыУправленияВидимостьюЭДО, ОписаниеКомандыЭДО);
		МестоРазмещения = НайтиСоздатьМестоРазмещения(Форма, ОписаниеКомандыЭДО, МестоРазмещения, МестоРазмещенияКоманд);
		ДобавитьКнопкуФормы(Форма, ОписаниеКомандыЭДО, МестоРазмещения, НачальнаяВидимость);
	КонецЦикла;
	ДополнитьПараметрыУправленияВидимостьюНаФорме(Форма, ПараметрыУправленияВидимостьюЭДО, ИсточникКомандЭДО);

КонецПроцедуры

Процедура ОпределитьВидимостьКомандЭДОПоФункциональнымОпциям(КомандыЭДО, Форма = Неопределено)
	
	Для НомерКоманды = -КомандыЭДО.Количество() + 1 По 0 Цикл
		
		ОписаниеКомандыЭДО = КомандыЭДО[-НомерКоманды];
		ФункциональныеОпцииКомандыЭДО = СтрРазделить(ОписаниеКомандыЭДО.ФункциональныеОпции, ", ", Ложь);
		ВидимостьКоманды = ФункциональныеОпцииКомандыЭДО.Количество() = 0;
		
		Для Каждого ФункциональнаяОпция Из ФункциональныеОпцииКомандыЭДО Цикл
			
			Если ТипЗнч(Форма) = Тип("ФормаКлиентскогоПриложения") Тогда
				ВидимостьКоманды = ВидимостьКоманды Или Форма.ПолучитьФункциональнуюОпциюФормы(ФункциональнаяОпция);
			Иначе
				ВидимостьКоманды = ВидимостьКоманды Или ПолучитьФункциональнуюОпцию(ФункциональнаяОпция);
			КонецЕсли;
			
			Если ВидимостьКоманды Тогда
				Прервать;
			КонецЕсли;
			
		КонецЦикла;
		
		ОписаниеКомандыЭДО.СкрытаФункциональнымиОпциями = Не ВидимостьКоманды;
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти