﻿#Область ПрограммныйИнтерфейс

// Возвращает структуру параметров для отправки сообщения об ошибке в техническую поддержку
//
// Возвращаемое значение:
//  Структура:
//   * ИдентификаторОборудования - СправочникСсылка.ПодключаемоеОборудование, Неопределено - ссылка на элемент 
//       подключаемого оборудования.
//   * ТекстОшибки - Строка - Текст ошибки который будет добавлен в письмо.
//   * ДополнительныеДанные - Структура, Массив из Структура, Неопределено - Дополнительные данные которые будут 
//       преобразованы в текст и добавлены в файл "Сведения о драйвере.txt".
//   * ЗадатьВопрос - Булево - Если установлена Истина, тогда будет задан вопрос об отправке сообщения
//   * ТекстВопроса - Строка - Текст вопроса который будет выведен пользователю
//
Функция ПараметрыОтправкиСообщенияОбОшибке() Экспорт
	
	Параметры = Новый Структура();
	Параметры.Вставить("ИдентификаторОборудования", Неопределено);
	Параметры.Вставить("ТекстОшибки", "");
	Параметры.Вставить("ДополнительныеДанные", Неопределено);
	Параметры.Вставить("ЗадатьВопрос", Ложь);
	Параметры.Вставить("ТекстВопроса", НСтр("ru = 'Отправить сообщение об ошибке разработчику?'"));
	
	Возврат Параметры;
	
КонецФункции

// Начинает отправку сообщения об ошибке, на сайт фирмы 1С. 
// Добавив в сообщение информацию о драйвере, а так же лог файлы если они существуют.
// Лог файлы отправляются в формате BASE64.
// 
// Параметры:
//  ОповещениеОЗавершении - ОписаниеОповещения, Неопределено - Метод, в который должен быть
//                          передан результат отправки сообщения. В метод передается значение типа
//                          Структура - результат отправки сообщения:
//                            КодОшибки - Строка - идентификатор ошибки при отправки
//                                                  <Пустая строка> - отправка выполнена успешно;
//                                                  "НеверныйФорматЗапроса" - переданы некорректные параметры
//                                                    сообщения сообщения в техническую поддержку;
//                                                  "ПревышенМаксимальныйРазмер" - превышен максимальный
//                                                     размер вложения;
//                                                  "НеизвестнаяОшибка" - при отправке сообщения возникли ошибки.
//                            СообщениеОбОшибке - Строка, ФорматированнаяСтрока - сообщение об ошибке
//                                                 для пользователя.
//  Параметры - См. ПараметрыОтправкиСообщенияОбОшибке
//
Процедура НачатьОтправкуСообщенияОбОшибке(ОповещениеОЗавершении, Параметры) Экспорт
	
	РезультатОперации = РезультатОперации();
	
	Если Не ОтправлятьСообщенияВТехПоддержку() Тогда
		РезультатОперации.КодОшибки = "НеИспользуется";
		РезультатОперации.СообщениеОбОшибке = НСтр("ru = 'Сообщения об ошибке в службу тех.поддержки не используется'");
		ВыполнитьОбработкуОповещения(ОповещениеОЗавершении, РезультатОперации);
		Возврат;
	КонецЕсли;
	
	Если Не ОбщегоНазначенияКлиент.ПодсистемаСуществует("ИнтернетПоддержкаПользователей.СообщенияВСлужбуТехническойПоддержки") Тогда
		РезультатОперации.КодОшибки = "ОтсутствуетПодсистема";
		РезультатОперации.СообщениеОбОшибке = НСтр("ru = 'Подсистема Сообщения в службу технической поддержки отсутствует'");
		ВыполнитьОбработкуОповещения(ОповещениеОЗавершении, РезультатОперации);
		Возврат;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Параметры.ИдентификаторОборудования) Тогда
		РезультатОперации.КодОшибки = "ОтсутствуетИдентификатор";
		РезультатОперации.СообщениеОбОшибке = НСтр("ru = 'Отсутствует идентификатор оборудования'");
		ВыполнитьОбработкуОповещения(ОповещениеОЗавершении, РезультатОперации);
		Возврат;
	КонецЕсли;
	
	Параметры.Вставить("ОповещениеОЗавершении", ОповещениеОЗавершении);
	Если Параметры.ЗадатьВопрос Тогда
		Оповещение = Новый ОписаниеОповещения("ПоказатьВопросОтправкиСообщенияОбОшибке_Завершение", ЭтотОбъект, Параметры);
		ПоказатьВопрос(Оповещение, Параметры.ТекстВопроса, РежимДиалогаВопрос.ДаНет);
	Иначе
		ВыполнитьОтправкуСообщенияОбОшибке(Параметры);
	КонецЕсли;
	
КонецПроцедуры

// Показывает вопрос отправки сообщения об ошибке, и отправляет сообщение на сайт фирмы 1С
// если получено подтверждение.
// Добавив в сообщение информацию о драйвере, а так же лог файлы если они существуют.
// Лог файлы отправляются в формате BASE64.
// 
// Параметры:
//  ОповещениеОЗавершении - ОписаниеОповещения, Неопределено - Метод, в который должен быть
//                          передан результат отправки сообщения. В метод передается значение типа
//                          Структура - результат отправки сообщения:
//                            *КодОшибки - Строка - идентификатор ошибки при отправки:
//                                                   <Пустая строка> - отправка выполнена успешно;
//                                                   "НеверныйФорматЗапроса" - переданы некорректные параметры
//                                                     сообщения сообщения в техническую поддержку;
//                                                   "ПревышенМаксимальныйРазмер" - превышен максимальный
//                                                     размер вложения;
//                                                   "НеизвестнаяОшибка" - при отправке сообщения возникли ошибки.
//                            *СообщениеОбОшибке - Строка, ФорматированнаяСтрока - сообщение об ошибке
//                                                 для пользователя.
//  Параметры - Структура - см. ПараметрыОтправкиСообщенияОбОшибке()
//
//  @skip-check doc-comment-description-ends-on-dot
Процедура ПоказатьВопросОправкиСообщенияОбОшибке(ОповещениеОЗавершении, Параметры) Экспорт
	
	Параметры.Вставить("ЗадатьВопрос", Истина);
	НачатьОтправкуСообщенияОбОшибке(ОповещениеОЗавершении, Параметры);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

// Возвращает необходимость отправки сообщений в тех.поддержку
// 
// Возвращаемое значение:
//  Булево.
//
Функция ОтправлятьСообщенияВТехПоддержку() Экспорт
	
	Если Не МенеджерОборудованияВызовСервера.ЗаполненыДанныеАутентификацииПользователяИнтернетПоддержки() Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Результат  = Ложь;
	Отправлять = Ложь;
	СтандартнаяОбработка = Истина;
	МенеджерОборудованияКлиентПереопределяемый.ОтправлятьСообщенияВТехПоддержку(Отправлять, СтандартнаяОбработка);
	Результат = ?(СтандартнаяОбработка, Результат, Отправлять); 
	Возврат Результат; 
	
КонецФункции 

// Процедура обработки оповещения ответа на вопрос.
// 
// Параметры:
//  РезультатВопроса - КодВозвратаДиалога - результат выбора пользователя: значение системного перечисления или значение, 
//                     связанное с нажатой кнопкой. 
//  Параметры - Структура:
//    * ОповещениеПриЗавершении - ОписаниеОповещения, Неопределено - 
//    * ИдентификаторОборудования - СправочникСсылка.ПодключаемоеОборудование - Ссылка на элемент подключаемого оборудования
//    * ТекстОшибки - Строка - Текст ошибки который будет добавлен в письмо.
Процедура ПоказатьВопросОтправкиСообщенияОбОшибке_Завершение(РезультатВопроса, Параметры) Экспорт
	
	Если РезультатВопроса = КодВозвратаДиалога.Да Тогда
		ВыполнитьОтправкуСообщенияОбОшибке(Параметры);
	Иначе
		РезультатОперации = РезультатОперации();
		РезультатОперации.КодОшибки = "ОтрицательныйОтвет";
		ВыполнитьОбработкуОповещения(Параметры.ОповещениеОЗавершении, РезультатОперации);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Начинает отправку сообщения об ошибке, на сайт фирмы 1С. 
// Добавив в сообщение информацию о драйвере, а так же лог файлы если они существуют.
// Лог файлы отправляются в формате BASE64.
// 
// Параметры:
//  Параметры - Структура:
//    * ОповещениеПриЗавершении - ОписаниеОповещения, Неопределено - 
//    * ИдентификаторОборудования - СправочникСсылка.ПодключаемоеОборудование - Ссылка на элемент подключаемого оборудования
//    * ТекстОшибки - Строка - Текст ошибки который будет добавлен в письмо.
Процедура ВыполнитьОтправкуСообщенияОбОшибке(Параметры)
	
	ТекстОшибки               = Параметры.ТекстОшибки;
	ИдентификаторОборудования = Параметры.ИдентификаторОборудования;
	
	Контекст = Новый Структура();
	Контекст.Вставить("Параметры",                 Параметры);
	Контекст.Вставить("ИдентификаторОборудования", ИдентификаторОборудования);
	Контекст.Вставить("ОповещениеОЗавершении",     Параметры.ОповещениеОЗавершении);
	Контекст.Вставить("ДополнительныеДанные",      Параметры.ДополнительныеДанные);
	
	ТекстСообщения  = ТекстСообщенияВТехПоддержку(ТекстОшибки);
	ДанныеСообщения = Новый Структура();
	ДанныеСообщения.Вставить("Получатель", "v8");
	ДанныеСообщения.Вставить("Тема",       НСтр("ru = 'Сообщение об ошибке БПО'"));
	ДанныеСообщения.Вставить("Сообщение",  ТекстСообщения);
	ДанныеСообщения.Вставить("ИспользоватьСтандартныйШаблон", Ложь);
	Контекст.Вставить("ДанныеСообщения", ДанныеСообщения);
	
	ДанныеВложений = Новый Массив();
	Контекст.Вставить("ДанныеВложений", ДанныеВложений);
	
	ПараметрыЖурналаРегистрации = Новый Структура();
	ПараметрыЖурналаРегистрации.Вставить("ДатаНачала",    МенеджерОборудованияКлиент.ДатаСеанса() - 60*60);
	ПараметрыЖурналаРегистрации.Вставить("ДатаОкончания", МенеджерОборудованияКлиент.ДатаСеанса());
	ПараметрыЖурналаРегистрации.Вставить("События",       ФильтрСобытийЖурналаРегистрацииБПО());
	ПараметрыЖурналаРегистрации.Вставить("Метаданные",    Новый Массив());
	ПараметрыЖурналаРегистрации.Вставить("Уровень",       НСтр("ru = 'Предупреждение'"));
	Контекст.Вставить("ПараметрыЖурналаРегистрации", ПараметрыЖурналаРегистрации);
	
	Оповещение = Новый ОписаниеОповещения("ВыполнитьОтправкуСообщенияОбОшибке_ПодготовитьСообщение", ЭтотОбъект, Контекст);
	ДанныеДрайвера = Неопределено;
	МенеджерОборудованияКлиент.НачатьПолучениеОписанияОборудования(Оповещение, ИдентификаторОборудования);
	
КонецПроцедуры

// Процедура обработки оповещения после получения описания оборудования
Процедура ВыполнитьОтправкуСообщенияОбОшибке_ПодготовитьСообщение(Результат, Контекст) Экспорт
	
	Контекст.Вставить("ОписаниеДрайвера", Результат.ОписаниеДрайвера);
	
	Сведения = Новый Массив();
	Сведения.Добавить(НСтр("ru = 'ОПИСАНИЕ ДРАЙВЕРА:'"));
	Сведения.Добавить(ПредставлениеСтруктуры(Контекст.ОписаниеДрайвера, Истина));
	
	Сведения.Добавить(НСтр("ru = 'ДАННЫЕ УСТРОЙСТВА:'"));
	ДанныеУстройства = МенеджерОборудованияВызовСервера.ДанныеУстройства(Контекст.ИдентификаторОборудования);
	Сведения.Добавить(ПредставлениеСтруктуры(ДанныеУстройства, Истина));
	
	Сведения.Добавить(НСтр("ru = 'ПАРАМЕТРЫ УСТРОЙСТВА В БАЗЕ ДАННЫХ:'"));
	ПараметрыУстройства = МенеджерОборудованияВызовСервера.ПараметрыУстройства(Контекст.ИдентификаторОборудования);
	Сведения.Добавить(ПредставлениеСтруктуры(ПараметрыУстройства, Ложь));
	
	ДополнительныеДанные = Контекст.ДополнительныеДанные;
	Если Контекст.ДополнительныеДанные <> Неопределено Тогда
		Если ТипЗнч(ДополнительныеДанные) = Тип("Массив") Тогда
			Для Индекс = 0 По ДополнительныеДанные.ВГраница() Цикл
				Сведения.Добавить(СтрШаблон(НСтр("ru = 'ДОПОЛНИТЕЛЬНЫЕ ДАННЫЕ %1:'"), Индекс + 1));
				Сведения.Добавить(ПредставлениеСтруктуры(ДополнительныеДанные[Индекс], Истина));
			КонецЦикла
		Иначе
			Сведения.Добавить(НСтр("ru = 'ДОПОЛНИТЕЛЬНЫЕ ДАННЫЕ:'"));
			Сведения.Добавить(ПредставлениеСтруктуры(ДополнительныеДанные, Истина));
		КонецЕсли
	КонецЕсли;
	
	СистемнаяИнформация = Новый СистемнаяИнформация();
	Сведения.Добавить(НСтр("ru = 'СИСТЕМНАЯ ИНФОРМАЦИЯ:'"));
	Сведения.Добавить(СтрШаблон(НСтр("ru = 'Версия ОС: %1'"),                      СистемнаяИнформация.ВерсияОС));
	Сведения.Добавить(СтрШаблон(НСтр("ru = 'Версия приложения: %1'"),              СистемнаяИнформация.ВерсияПриложения));
	Сведения.Добавить(СтрШаблон(НСтр("ru = 'Информация программы просмотра: %1'"), СистемнаяИнформация.ИнформацияПрограммыПросмотра));
	Сведения.Добавить(СтрШаблон(НСтр("ru = 'Оперативная память: %1'"),             СистемнаяИнформация.ОперативнаяПамять));
	Сведения.Добавить(СтрШаблон(НСтр("ru = 'Процессор: %1'"),                      СистемнаяИнформация.Процессор));
	Сведения.Добавить(СтрШаблон(НСтр("ru = 'Тип платформы: %1'"),                  СистемнаяИнформация.ТипПлатформы ));
	
	ПараметрыВложения = Новый Структура;
	ПараметрыВложения.Вставить("ВидДанных",     "Текст");
	ПараметрыВложения.Вставить("Представление", НСтр("ru = 'Сведения о драйвере.txt'"));
	ПараметрыВложения.Вставить("Данные",        СтрСоединить(Сведения, Символы.ПС));
	Контекст.ДанныеВложений.Добавить(ПараметрыВложения);
	
	Оповещение = Новый ОписаниеОповещения("ВыполнитьОтправкуСообщенияОбОшибке_РаботаСФайламиДоступна", ЭтотОбъект, Контекст);
	#Если ВебКлиент Тогда
		МодульФайловаяСистемаКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ФайловаяСистемаКлиент");
		Если МодульФайловаяСистемаКлиент <> Неопределено Тогда
			МодульФайловаяСистемаКлиент.ПодключитьРасширениеДляРаботыСФайлами(Оповещение,, Истина);
		КонецЕсли;
	#Иначе
		ВыполнитьОбработкуОповещения(Оповещение, Истина);
	#КонецЕсли
	
	
КонецПроцедуры

// Процедура обработки оповещения после получения описания оборудования
Процедура ВыполнитьОтправкуСообщенияОбОшибке_РаботаСФайламиДоступна(РасширениеПодключено, Контекст) Экспорт
	
	Оповещение = Новый ОписаниеОповещения("ВыполнитьОтправкуСообщенияОбОшибке_ОтправкаСообщения", ЭтотОбъект, Контекст);
	Если РасширениеПодключено Тогда
		НачатьДобавлениеФайловЛогов(Оповещение, Контекст.ОписаниеДрайвера, Контекст.ДанныеВложений);
	Иначе
		ВыполнитьОбработкуОповещения(Оповещение, Истина);
	КонецЕсли;
	
КонецПроцедуры

// Процедура обработки оповещения после получения формирования сообщения
Процедура ВыполнитьОтправкуСообщенияОбОшибке_ОтправкаСообщения(Результат, Контекст) Экспорт
	
	МодульСообщенияВСлужбуТехническойПоддержкиКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("СообщенияВСлужбуТехническойПоддержкиКлиент");
	Если МодульСообщенияВСлужбуТехническойПоддержкиКлиент <> Неопределено Тогда
		МодульСообщенияВСлужбуТехническойПоддержкиКлиент.ОтправитьСообщение(
			Контекст.ДанныеСообщения, 
			Контекст.ДанныеВложений, 
			Контекст.ПараметрыЖурналаРегистрации, 
			Контекст.ОповещениеОЗавершении);
	КонецЕсли;
	
КонецПроцедуры

// Создает новый результат операции отправки сообщения
// в службу технической поддержки.
//
// Возвращаемое значение:
//  Структура - результат отправки сообщения:
//   * КодОшибки - Строка - идентификатор ошибки при отправки:
//   * СообщениеОбОшибке - Строка, ФорматированнаяСтрока - сообщение об ошибке для пользователя.
//
Функция РезультатОперации() Экспорт
	
	Результат = Новый Структура;
	Результат.Вставить("КодОшибки",         "");
	Результат.Вставить("СообщениеОбОшибке", "");
	
	Возврат Результат;
	
КонецФункции

// Возвращает текст сообщения в тех. поддержку
// 
// Параметры:
//  ТекстОшибки - Строка - текст сообщения об ошибке
// 
// Возвращаемое значение:
//  Строка - текст сообщения
//
Функция ТекстСообщенияВТехПоддержку(ТекстОшибки)
	
	ТекстСообщения = СтрШаблон(
		НСтр("ru = 'Здравствуйте.
			|
			|%1
			|<Опишите ситуацию, которая привела к ошибке>
			|
			|Номер обращения: <Укажите номер, при повторном обращении>;
			|Регистрационный номер программного продукта: <Укажите рег. номер>;
			|Организация: <Укажите название организации>;
			|ИНН организации: <Укажите ИНН организации>.
			|С уважением,
			|.'"),
		ТекстОшибки);
	МенеджерОборудованияКлиентПереопределяемый.ПодготовитьТекстСообщенияВТехПоддержку(ТекстСообщения, ТекстОшибки);
	Возврат ТекстСообщения; 
	
КонецФункции 

// Добавляет в массив Вложения файл преобразованный в BASE64 и разбивает его на части если файл превышает 
// допустимый размер.
//
// Параметры:
//  Вложения - Массив из Структура - массив структур содержащих вложения
//  ДвоичныеДанные - ДвоичныеДанные - данные которые требуется добавить во вложения
//  ИмяФайла - Строка - имя файла вложения
Процедура ДобавитьФайлВложения(Вложения, ДвоичныеДанные, ИмяФайла)
	
	МаксимальныйРазмерФайлаBASE64 = МаксимальныйРазмерФайлаБИП();
	// Уменьшение максимального размера файла на символов переноса, два символа переноса на каждые 80
	МаксимальныйРазмерФайла = МаксимальныйРазмерФайлаBASE64 - МаксимальныйРазмерФайлаBASE64 / 80 * 2;
	// Уменьшение максимального размера файла из-за перекодирования
	МаксимальныйРазмерФайла = МаксимальныйРазмерФайла * 3/4;
	
	Если МаксимальныйРазмерФайла > ДвоичныеДанные.Размер() Тогда
		Вложение = Новый Структура();
		Вложение.Вставить("ИмяФайла", ИмяФайла);
		Вложение.Вставить("Данные",   ПолучитьBase64СтрокуИзДвоичныхДанных(ДвоичныеДанные));
		Вложения.Добавить(Вложение);
	Иначе
		МассивДвоичныхДанных = РазделитьДвоичныеДанные(ДвоичныеДанные, МаксимальныйРазмерФайла);
		Для Номер = 0 По МассивДвоичныхДанных.ВГраница() Цикл
			Вложение = Новый Структура();
			Вложение.Вставить("ИмяФайла", Лев(ИмяФайла, СтрДлина(ИмяФайла) - 2) + Прав("00" + Номер, 2));
			Вложение.Вставить("Данные",   ПолучитьBase64СтрокуИзДвоичныхДанных(МассивДвоичныхДанных[Номер]));
			Вложения.Добавить(Вложение);
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры

// Начинает добавление файлов логов в сообщение
Процедура НачатьДобавлениеФайловЛогов(ОповещениеЗавершения, ОписаниеДрайвера, ДанныеВложений)
	
	Если ОписаниеДрайвера.ЛогДрайвераВключен = Неопределено Тогда
		ОписаниеДрайвера.ЛогДрайвераВключен = Ложь;
	КонецЕсли;
	Если ОписаниеДрайвера.ЛогДрайвераПутьКФайлу = Неопределено Тогда
		ОписаниеДрайвера.ЛогДрайвераПутьКФайлу = "";
	КонецЕсли;
	
	// лог файлы не используются
	Если Не ОписаниеДрайвера.ЛогДрайвераВключен Тогда
		ВыполнитьОбработкуОповещения(ОповещениеЗавершения, Истина);
		Возврат;
	КонецЕсли;

	Контекст = Новый Структура();
	Контекст.Вставить("ОповещениеЗавершения", ОповещениеЗавершения);
	Контекст.Вставить("Вложения", Новый Массив());
	Контекст.Вставить("ОписаниеДрайвера", ОписаниеДрайвера);
	Контекст.Вставить("ДанныеВложений", ДанныеВложений);

	Файл = Новый Файл(ОписаниеДрайвера.ЛогДрайвераПутьКФайлу);
	Контекст.Вставить("Файл", Файл);
	
	Оповещение = Новый ОписаниеОповещения("НачатьДобавлениеФайловЛогов_ФайлСуществуетЗавершение", ЭтотОбъект, Контекст);
	Файл.НачатьПроверкуСуществования(Оповещение);
	
КонецПроцедуры

// Продолжает добавление файлов логов в сообщение
Процедура НачатьДобавлениеФайловЛогов_ФайлСуществуетЗавершение(Результат, Контекст) Экспорт
	
	Если Не Результат Тогда
		ВыполнитьОбработкуОповещения(Контекст.ОповещениеЗавершения, Истина);
		Возврат;
	КонецЕсли;
	
	Оповещение = Новый ОписаниеОповещения("НачатьДобавлениеФайловЛогов_ЭтоКаталогЗавершение", ЭтотОбъект, Контекст);
	Контекст.Файл.НачатьПроверкуЭтоКаталог(Оповещение);
	
КонецПроцедуры

// Продолжает добавление файлов логов в сообщение
Процедура НачатьДобавлениеФайловЛогов_ЭтоКаталогЗавершение(Результат, Контекст) Экспорт
	
	Оповещение = Новый ОписаниеОповещения("НачатьДобавлениеФайловЛогов_ПоискФайловЗавершение", ЭтотОбъект, Контекст);
	Если Результат Тогда
		// Лог файлы хранятся в каталоге
		НайденныеФайлы  = СокрЛП(Контекст.ОписаниеДрайвера.ЛогДрайвераПутьКФайлу);
		РазделительПути = ПолучитьРазделительПути();
		Если Прав(НайденныеФайлы, 1) <> РазделительПути Тогда
			НайденныеФайлы = НайденныеФайлы + РазделительПути;
		КонецЕсли;
		ВыполнитьОбработкуОповещения(Оповещение, НайденныеФайлы + ПолучитьМаскуВсеФайлы());
		
	Иначе
		// Лог файлы хранятся в одном файле
		НайденныеФайлы = Контекст.Файл.ПолноеИмя;
		ВыполнитьОбработкуОповещения(Оповещение, НайденныеФайлы);
		
	КонецЕсли;
		
КонецПроцедуры

// Продолжает добавление файлов логов в сообщение
Процедура НачатьДобавлениеФайловЛогов_ПоискФайловЗавершение(НайденныеФайлы, Контекст) Экспорт

	#Если Не ВебКлиент И Не МобильныйКлиент И Не МобильноеПриложениеКлиент Тогда 
		
		Вложения       = Контекст.Вложения;
		
		Архив = Новый ЗаписьZipФайла();
		Архив.Добавить(НайденныеФайлы, 
			РежимСохраненияПутейZIP.СохранятьОтносительныеПути, 
			РежимОбработкиПодкаталоговZIP.ОбрабатыватьРекурсивно);
		ДвоичныеДанные = Архив.ПолучитьДвоичныеДанные();
		ДобавитьФайлВложения(Вложения, ДвоичныеДанные, "logs.b64");
		
		Для Каждого Вложение Из Вложения Цикл
			Представление = ?(Прав(Вложение.ИмяФайла,4) = ".txt", Вложение.ИмяФайла, Вложение.ИмяФайла + ".txt");
			ПараметрыВложения = Новый Структура;
			ПараметрыВложения.Вставить("ВидДанных",     "Текст");
			ПараметрыВложения.Вставить("Представление", Представление);
			ПараметрыВложения.Вставить("Данные",        Вложение.Данные);
			Контекст.ДанныеВложений.Добавить(ПараметрыВложения);
		КонецЦикла;
		ВыполнитьОбработкуОповещения(Контекст.ОповещениеЗавершения);
		
	#КонецЕсли
	
КонецПроцедуры

// Определяет максимальный размер файла вложения.
//
// Возвращаемое значение:
//  Число - максимальный размер файла в байтах.
//
Функция МаксимальныйРазмерФайлаБИП()
	
	Возврат 10485760; // 10 МБ.
	
КонецФункции

// Формирует текстовое представление структуры
//
// Параметры:
//  Значение - Структура - структура которую требуется преобразовать в текст
//  ФормироватьЧитаемыйИдентификатор - Булево - преобразовать идентификатор в читаемый вид
//  Уровень - Число - 
//
// Возвращаемое значение:
//  Строка - преобразованная в текст структура
Функция ПредставлениеСтруктуры(Значение, ФормироватьЧитаемыйИдентификатор = Ложь, Знач Уровень = 0)
	
	ПредставлениеСтруктуры = "";
	Если ТипЗнч(Значение) <> Тип("Структура") Тогда
		Возврат ПредставлениеСтруктуры;
	КонецЕсли;
	
	Отступ = "";
	Для Индекс = 0 По Уровень Цикл
		Отступ = Отступ + " ";
	КонецЦикла;
		
	Для Каждого Элемент Из Значение Цикл
		
		Если ФормироватьЧитаемыйИдентификатор Тогда
			ПредставлениеКлюча = ПредставлениеИдентификатора(Элемент.Ключ);
		Иначе
			ПредставлениеКлюча = Элемент.Ключ;
		КонецЕсли;
		
		Если ТипЗнч(Элемент.Значение) = Тип("Строка") 
			Или ТипЗнч(Элемент.Значение) = Тип("Число") 
			Или ТипЗнч(Элемент.Значение) = Тип("Булево") Тогда
			
			ПредставлениеСтруктуры = 
				ПредставлениеСтруктуры
				+ СтрШаблон("%1%2: %3", Отступ, ПредставлениеКлюча, Строка(Элемент.Значение))
				+ Символы.ПС;
		ИначеЕсли ТипЗнч(Элемент.Значение) = Тип("Структура") Тогда
			Представление = ПредставлениеСтруктуры(Элемент.Значение, ФормироватьЧитаемыйИдентификатор, Уровень + 1);
			ПредставлениеСтруктуры = 
				ПредставлениеСтруктуры
				+ СтрШаблон("%1%2:", Отступ, ПредставлениеКлюча) + Символы.ПС + Представление;
		Иначе
			ПредставлениеСтруктуры = 
				ПредставлениеСтруктуры
				+ СтрШаблон("%1%2: %3", Отступ, ПредставлениеКлюча, ТипЗнч(Элемент.Значение))
				+ Символы.ПС;
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат ПредставлениеСтруктуры;
	
КонецФункции

// Преобразовать идентификатор в строку с пробелами
//
// Параметры:
//  Идентификатор - Строка - идентификатор который требуется преобразовать
//
// Возвращаемое значение:
//  Строка - идентификатор преобразованный в читаемый вид
Функция ПредставлениеИдентификатора(Идентификатор)
	
	РазмерСтроки = СтрДлина(Идентификатор);
	Результат = "";
	Для Номер=1 По РазмерСтроки Цикл
		КодСимвола = КодСимвола(Идентификатор, Номер);
		КодСледующегоСимвола = КодСимвола(Идентификатор, Номер + 1);
		КлассСимвола = "";
		Если КодСимвола >= КодСимвола("А") И КодСимвола <= КодСимвола("Я") Тогда
			Если Номер > 1 Тогда
				Результат = Результат + " " + НРег(Символ(КодСимвола));
			Иначе
				Результат = Результат + Символ(КодСимвола);
			КонецЕсли;
		ИначеЕсли КодСимвола >= КодСимвола("а") И КодСимвола <= КодСимвола("я") Тогда
				Результат = Результат + Символ(КодСимвола);
		ИначеЕсли КодСимвола >= КодСимвола("A") И КодСимвола <= КодСимвола("Z") Тогда
			Если Номер > 1 Тогда
				КодПредыдущегоСимвола = КодСимвола(Идентификатор, Номер - 1);
				Если КодПредыдущегоСимвола >= КодСимвола("A") И КодПредыдущегоСимвола <= КодСимвола("Z") Тогда
					Результат = Результат + Символ(КодСимвола);
				ИначеЕсли КодПредыдущегоСимвола = КодСимвола("_") Тогда
					Результат = Результат + Символ(КодСимвола);
				Иначе
					Результат = Результат + " " + Символ(КодСимвола);
				КонецЕсли;
			Иначе
				Результат = Результат + Символ(КодСимвола);
			КонецЕсли;
		ИначеЕсли КодСимвола >= КодСимвола("a") И КодСимвола <= КодСимвола("z") Тогда
			Результат = Результат + Символ(КодСимвола);
		ИначеЕсли КодСимвола >= КодСимвола("0") И КодСимвола <= КодСимвола("9") Тогда
			Если Номер > 1 Тогда
				КодПредыдущегоСимвола = КодСимвола(Идентификатор, Номер - 1);
				Если КодПредыдущегоСимвола >= КодСимвола("0") И КодПредыдущегоСимвола <= КодСимвола("9") Тогда
					Результат = Результат + Символ(КодСимвола);
				ИначеЕсли КодПредыдущегоСимвола >= КодСимвола("A") И КодПредыдущегоСимвола <= КодСимвола("Z") Тогда
					Результат = Результат + Символ(КодСимвола);
				ИначеЕсли КодПредыдущегоСимвола >= КодСимвола("А") И КодПредыдущегоСимвола <= КодСимвола("Я") Тогда
					Результат = Результат + Символ(КодСимвола);
				Иначе
					Результат = Результат + " " + Символ(КодСимвола);
				КонецЕсли;
			Иначе
				Результат = Результат + Символ(КодСимвола);
			КонецЕсли;
		ИначеЕсли КодСимвола = КодСимвола("_") Тогда
			Результат = Результат + Символ(КодСимвола);
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

Функция ФильтрСобытийЖурналаРегистрацииБПО()
	
	События = Новый Массив();
	
	События.Добавить("_$Access$_.AccessDenied");
	
	События.Добавить(НСтр("ru = 'Ошибка генерации штрихкода'"));
	События.Добавить(НСтр("ru = 'Ошибка системы взаимодействия'"));
	События.Добавить(НСтр("ru = 'Обмен с офлайн-оборудованием'"));
	События.Добавить(НСтр("ru = 'Обновление информационной базы'"));
	События.Добавить(НСтр("ru = 'Ошибка добавления чека в очередь'"));
	События.Добавить(НСтр("ru = 'Запись статуса чека в очереди'"));
	События.Добавить(НСтр("ru = 'Подключение внешней компоненты на сервере'"));
	События.Добавить(НСтр("ru = 'Безопасное выполнение метода'"));
	События.Добавить(НСтр("ru = 'Очередь отправки электронных писем'"));
	События.Добавить(НСтр("ru = 'Рассылка электронных чеков'"));
	События.Добавить(НСтр("ru = 'Ошибка компоненты НСПК'"));
	События.Добавить(НСтр("ru = 'Заполнение предопределенных элементов драйвера'"));
	События.Добавить(НСтр("ru = 'Заполнение предопределенных элементов'"));
	События.Добавить(НСтр("ru = 'Печать этикеток'"));
	События.Добавить(НСтр("ru = 'Ошибка заполнения предопределенных элементов ЕМРЦ.'"));
	События.Добавить(НСтр("ru = 'Добавление пакета ошибки данных в очередь'"));
	События.Добавить(НСтр("ru = 'Добавление пакета данных в очередь.'"));
	События.Добавить(НСтр("ru = 'Очистка очереди сообщений.'"));
	События.Добавить(НСтр("ru = 'Сброс флага отправки в очереди обмена'"));
	События.Добавить(НСтр("ru = 'Очистка платежных операций'"));
	События.Добавить(НСтр("ru = 'Платежные операции'"));
	События.Добавить(НСтр("ru = 'Загрузка товаров из ККТ.'"));
	События.Добавить(НСтр("ru = 'Выгрузка товаров на ККТ.'"));
	События.Добавить(НСтр("ru = 'Очистка товаров на ККТ.'"));
	События.Добавить(НСтр("ru = 'Загрузка кассовых документов на ККТ.'"));
	События.Добавить(НСтр("ru = 'Загрузка магазинов Эвотор.'"));
	События.Добавить(НСтр("ru = 'Загрузка товаров из ККТ.'"));
	События.Добавить(НСтр("ru = 'НТТР запрос к облаку Эвотор.'"));
	События.Добавить(НСтр("ru = 'Ответ сервера Эвотор.'"));
	События.Добавить(НСтр("ru = 'Чтение JSON.'"));
	События.Добавить(НСтр("ru = 'Запись JSON.'"));
	События.Добавить(НСтр("ru = 'Ошибка выполнения'"));
	
	Возврат События;
	
КонецФункции

#КонецОбласти
