﻿
////////////////////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС
#Область ПрограммныйИнтерфейс

// Создает каркас фильтров и добавляет его на форму с установкой начальных настроек.
//
// Параметры:
//  Форма                                      - ФормаКлиентскогоПриложения - форма, где используются фильтры.
//  Фильтры                                    - Массив - описания фильтров (см. функцию ОписаниеФильтра).
//  ИмяГруппыРазмещенияФильтров                - Строка - имя группы на форме, в которой будет размещаться фильтр.
//  ИмяФильтруемогоСписка                      - Строка - имя списка на форме, в котором будут фильтроваться элементы.
//  ИспользуетсяРасширенныйИлиСтандартныйПоиск - Булево - признак использования расширенного или стандартного поиска.
//  СохранятьНастройкиПриЗакрытии              - Булево - признак необходимости сохранять настройки формы.
//
Процедура ПриСозданииНаСервере(Форма, Фильтры, ИмяГруппыРазмещенияФильтров, ИмяФильтруемогоСписка, ИспользуетсяРасширенныйИлиСтандартныйПоиск, СохранятьНастройки = Истина) Экспорт
	
	ИнициализироватьКаркасФильтров(Форма, ИмяГруппыРазмещенияФильтров);
	
	Префикс = ФильтрыСписковКлиентСервер.Префикс();
	Форма[Префикс + "ИмяФильтруемогоСписка"] = ИмяФильтруемогоСписка;
	Форма[Префикс + "ИспользуетсяРасширенныйИлиСтандартныйПоиск"] = ИспользуетсяРасширенныйИлиСтандартныйПоиск;
	Форма[Префикс + "СохранятьНастройки"] = СохранятьНастройки;
	
	СписокФильтров = Форма.Элементы[Префикс + "ВариантФильтра"].СписокВыбора;
	Для Каждого ДанныеФильтра Из Фильтры Цикл
		Фильтр = ОбщегоНазначения.ОбщийМодуль(ДанныеФильтра.ИмяФильтра);
		СписокФильтров.Добавить(ДанныеФильтра.ИмяФильтра, Фильтр.ПредставлениеФильтра());
		Фильтр.ДобавитьФильтрНаФорму(Форма);
		Фильтр.УстановитьНачальныеНастройки(Форма, ДанныеФильтра.Параметры);
	КонецЦикла;
	
	УстановитьНачальныеНастройки(Форма);
	Форма[Префикс + "ОтображаемыйВариантФильтра"] = ФильтрыСписковКлиентСервер.ТекущийФильтр(Форма);
	
КонецПроцедуры

// Анализирует необходимость сохранения и сохраняет настройки формы.
//
// Параметры:
//  Форма - ФормаКлиентскогоПриложения - форма, где используются фильтры.
//
Процедура СохранитьНастройкиФормы(Форма) Экспорт
	
	Префикс = ФильтрыСписковКлиентСервер.Префикс();
	Если Форма[Префикс + "СохранятьНастройки"] Тогда
		Фильтры = ФильтрыСписковКлиентСервер.Фильтры(Форма);
		Для Каждого ИмяФильтра Из Фильтры Цикл
			Фильтр = ОбщегоНазначения.ОбщийМодуль(ИмяФильтра);
			Фильтр.СохранитьНастройки(Форма);
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры

// Возвращает имя группы фильтров, вида "Страницы".
//
// Возвращаемое значение:
//  Строка - имя группы фильтров.
//
Функция СтраницаФильтров() Экспорт
	
	Возврат ФильтрыСписковКлиентСервер.Префикс() + "ГруппаФильтры";
	
КонецФункции

// Анализирует и изменяет признак использования фильтров.
//
// Параметры:
//  Форма               - ФормаКлиентскогоПриложения - форма, где используются фильтры.
//  ИспользоватьФильтры - Булево - признак использования фильтров.
//
Процедура УстановитьИспользоватьФильтры(Форма, ИспользоватьФильтры) Экспорт
	
	Если ФильтрыСписковКлиентСервер.ИспользоватьФильтры(Форма) <> ИспользоватьФильтры Тогда
		Форма[ФильтрыСписковКлиентСервер.ИмяРеквизитаИспользоватьФильтры()] = ИспользоватьФильтры;
		ИспользоватьФильтрыПриИзменении(Форма);
	КонецЕсли;
	
КонецПроцедуры

// Устанавливает вариант фильтра по идентификатору.
//
// Параметры:
//  Форма          - ФормаКлиентскогоПриложения - форма, где используются фильтры.
//  ВариантФильтра - Строка - идентификатор фильтра.
//
Процедура УстановитьВариантФильтра(Форма, ВариантФильтра) Экспорт
	
	ТекущийФильтр = ФильтрыСписковКлиентСервер.ТекущийФильтр(Форма);
	Если ФильтрыСписковКлиентСервер.ИспользоватьФильтры(Форма) И ТекущийФильтр <> ВариантФильтра Тогда
		Фильтр = ОбщегоНазначения.ОбщийМодуль(ТекущийФильтр);
		Фильтр.ОбработатьОтменуФильтра(Форма);
	КонецЕсли;
	
	Если ТекущийФильтр <> ВариантФильтра Тогда
		Форма[ФильтрыСписковКлиентСервер.Префикс() + "ВариантФильтра"] = ВариантФильтра;
		ВариантФильтраПриИзменении(Форма);
	КонецЕсли;
	
	Если Не ФильтрыСписковКлиентСервер.ИспользоватьФильтры(Форма) Тогда
		УстановитьИспользоватьФильтры(Форма, Истина);
	КонецЕсли;
	
КонецПроцедуры

// Устанавливает настройки формы по текущему фильтру.
//
// Параметры:
//  Форма - ФормаКлиентскогоПриложения - форма, где используются фильтры.
//
Процедура ВариантФильтраПриИзменении(Форма) Экспорт
	
	Префикс = ФильтрыСписковКлиентСервер.Префикс();
	ПредыдущийФильтр = Форма[префикс + "ОтображаемыйВариантФильтра"];
	
	Если Не ПустаяСтрока(ПредыдущийФильтр) Тогда
		ОбщегоНазначения.ОбщийМодуль(ПредыдущийФильтр).ОбработатьОтменуФильтра(Форма);
	КонецЕсли;
	
	ТекущийФильтр = ФильтрыСписковКлиентСервер.ТекущийФильтр(Форма);
	Фильтр = ОбщегоНазначения.ОбщийМодуль(ТекущийФильтр);
	
	Форма.Элементы[СтраницаФильтров()].ТекущаяСтраница = Фильтр.СтраницаФильтра(Форма);
	Фильтр.ОбработатьВыборФильтра(Форма);
	Фильтр.УстановитьДоступность(Форма);
	Форма[Префикс + "ОтображаемыйВариантФильтра"] = ТекущийФильтр;
	
	СохранитьНастройки(Форма);
	
КонецПроцедуры

// Включает или выключает использование текущего фильтра.
// Устанавливает доступность элементов фильтра.
//
// Параметры:
//  Форма - ФормаКлиентскогоПриложения - форма, где используются фильтры.
//
Процедура ИспользоватьФильтрыПриИзменении(Форма) Экспорт
	
	Фильтр = ОбщегоНазначения.ОбщийМодуль(ФильтрыСписковКлиентСервер.ТекущийФильтр(Форма));
	ИспользоватьФильтры = ФильтрыСписковКлиентСервер.ИспользоватьФильтры(Форма);
	Если ИспользоватьФильтры Тогда
		Фильтр.УстановитьФильтр(Форма);
	Иначе
		Фильтр.СброситьФильтр(Форма);
	КонецЕсли;
	Фильтр.УстановитьДоступность(Форма);
	
	Форма.Элементы[ФильтрыСписковКлиентСервер.Префикс() + "ВариантФильтра"].Доступность = ИспользоватьФильтры;
	
	СохранитьНастройки(Форма);
	
КонецПроцедуры

// Изменяет текст запроса списка отбора.
//
// Параметры:
//  Форма              - ФормаКлиентскогоПриложения - форма, где используются фильтры.
//  ОписанияПолей      - Структура - описание выбираемых полей запроса.
//  ОписанияСоединений - Массив - список соединений запросов.
//
Процедура ДобавитьДополнительнуюИнформациюВЗапрос(Форма, ОписанияПолей, ОписанияТаблиц = Неопределено) Экспорт
	
	СписокТоваров = ФильтрыСписковКлиентСервер.ФильтруемыйСписок(Форма);
	
	СхемаЗапроса = Новый СхемаЗапроса;
	СхемаЗапроса.УстановитьТекстЗапроса(СписокТоваров.ТекстЗапроса);
	
	ТекстыСоединений = Новый Массив;
	ТекстыПолей = Новый Массив;
	
	ПоследнийЗапрос = СхемаЗапроса.ПакетЗапросов[СхемаЗапроса.ПакетЗапросов.Количество() - 1];
	ИндексПоля = ПоследнийЗапрос.Колонки.Количество();
	Для Каждого Оператор Из ПоследнийЗапрос.Операторы Цикл
		Если ЗначениеЗаполнено(ОписанияТаблиц) Тогда
			Для Каждого Таблица Из ОписанияТаблиц Цикл
				Источник = Оператор.Источники.Добавить(Таблица.Источник.Таблица, Таблица.Источник.Псевдоним);
				ТекстСоединения = Источник.Источник.ИмяТаблицы + " КАК " + Источник.Источник.Псевдоним;
				Если Таблица.Свойство("Соединение") Тогда
					ГлавнаяТаблица = Оператор.Источники.НайтиПоПсевдониму(Таблица.Соединение.ГлавнаяТаблица);
					ГлавнаяТаблица.Соединения.Добавить(Источник, Таблица.Соединение.Условие);
					Соединение = ГлавнаяТаблица.Соединения[ГлавнаяТаблица.Соединения.Количество() - 1];
					ТекстСоединения = ТекстСоединения + " ПО (" + Соединение.Условие + ")";
					Если Таблица.Соединение.Свойство("ТипСоединения") Тогда
						Соединение.ТипСоединения = Таблица.Соединение.ТипСоединения;
						Если Соединение.ТипСоединения = ТипСоединенияСхемыЗапроса.Внутреннее Тогда
							ТипСоединения = "ВНУТРЕННЕЕ СОЕДИНЕНИЕ";
						ИначеЕсли Соединение.ТипСоединения = ТипСоединенияСхемыЗапроса.ЛевоеВнешнее Тогда
							ТипСоединения = "ЛЕВОЕ СОЕДИНЕНИЕ";
						ИначеЕсли Соединение.ТипСоединения = ТипСоединенияСхемыЗапроса.ПолноеВнешнее Тогда
							ТипСоединения = "ПОЛНОЕ СОЕДИНЕНИЕ";
						ИначеЕсли Соединение.ТипСоединения = ТипСоединенияСхемыЗапроса.ПравоеВнешнее Тогда
							ТипСоединения = "ПРАВОЕ СОЕДИНЕНИЕ";
						КонецЕсли;
					Иначе
						ТипСоединения = "ЛЕВОЕ СОЕДИНЕНИЕ";
					КонецЕсли;
					ТекстСоединения = ТипСоединения + " " + ТекстСоединения;
					ТекстыСоединений.Вставить(0, "{" + ТекстСоединения + "}");
				Иначе
					ТекстыСоединений.Добавить("," + Символы.ПС + ТекстСоединения);
				КонецЕсли;
			КонецЦикла;
		КонецЕсли;
		Для Каждого Поле Из ОписанияПолей Цикл
			Оператор.ВыбираемыеПоля.Добавить(Поле.Значение);
			ТекстыПолей.Добавить(Поле.Значение + " КАК " + Поле.Ключ);
		КонецЦикла;
	КонецЦикла;
	
	Для Каждого Поле Из ОписанияПолей Цикл
		ПоследнийЗапрос.Колонки[ИндексПоля].Псевдоним = Поле.Ключ;
		ИндексПоля = ИндексПоля + 1;
	КонецЦикла;
	
	Если СтрНайти(СписокТоваров.ТекстЗапроса, "//ПОЛЯ_ДЛЯ_ОТБОРА") > 0 Тогда
		ТекстПолей = СтрСоединить(ТекстыПолей, "," + Символы.ПС);
		СписокТоваров.ТекстЗапроса = СтрЗаменить(СписокТоваров.ТекстЗапроса, "//ПОЛЯ_ДЛЯ_ОТБОРА", "," + Символы.ПС + ТекстПолей + "//ПОЛЯ_ДЛЯ_ОТБОРА");
		Если ТекстыСоединений.Количество() > 0 Тогда
			ТекстСоединений = СтрСоединить(ТекстыСоединений, Символы.ПС);
			СписокТоваров.ТекстЗапроса = СтрЗаменить(СписокТоваров.ТекстЗапроса, "//СОЕДИНЕНИЯ", Символы.ПС + ТекстСоединений + "//СОЕДИНЕНИЯ");
		КонецЕсли;
	Иначе
		СписокТоваров.ТекстЗапроса = СхемаЗапроса.ПолучитьТекстЗапроса();
	КонецЕсли;
	
КонецПроцедуры

// Создает описание фильтра по идентификатору фильтра и его параметрам.
//
// Параметры:
//  ИмяФильтра       - Строка - строка идентифицирующая фильтр.
//  ПараметрыФильтра - Произвольный - дополнительные параметры фильтра.
//
// Возвращаемое значение:
//  Описание - Структура
//   * ИмяФильтра - Строка - строка идентифицирующая фильтр.
//   * Параметры  - Произвольный - дополнительные параметры фильтра.
//
Функция ОписаниеФильтра(ИмяФильтра, ПараметрыФильтра = Неопределено) Экспорт
	
	Описание = Новый Структура;
	Описание.Вставить("ИмяФильтра", ИмяФильтра);
	Описание.Вставить("Параметры" , ПараметрыФильтра);
	
	Возврат Описание;
	
КонецФункции

#КонецОбласти // ПрограммныйИнтерфейс

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ
#Область СлужебныеПроцедурыИФункции

Процедура ИнициализироватьКаркасФильтров(Форма, ИмяГруппыДляРазмещения)
	
	Описание = УправляемаяФорма.ПрочитатьОписаниеФормыИзСтроки(ОписаниеЭлементовФормы(ИмяГруппыДляРазмещения));
	УправляемаяФорма.СоздатьЭлементы(Форма, Описание);
	
КонецПроцедуры

Процедура УстановитьНачальныеНастройки(Форма)
	
	Префикс = ФильтрыСписковКлиентСервер.Префикс();
	
	Если Форма[Префикс + "СохранятьНастройки"] Тогда
		Настройки = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить(Префикс, Форма.КодФормы);
		Если Настройки <> Неопределено Тогда
			
			ВариантФильтра = Неопределено;
			Если Настройки.Свойство("ВариантФильтра", ВариантФильтра)
			   И Форма.Элементы[Префикс + "ВариантФильтра"].СписокВыбора.НайтиПоЗначению(ВариантФильтра) <> Неопределено Тогда
				Форма[Префикс + "ВариантФильтра"] = ВариантФильтра;
			КонецЕсли;
			
			Если Настройки.Свойство("ИспользоватьФильтры") Тогда
				Форма[Префикс + "ИспользоватьФильтры"] = Настройки.ИспользоватьФильтры;
			КонецЕсли;
			
		КонецЕсли;
	КонецЕсли;
	
	Фильтры = ФильтрыСписковКлиентСервер.Фильтры(Форма);
	Если ПустаяСтрока(Форма[Префикс + "ВариантФильтра"]) Тогда
		Форма[Префикс + "ВариантФильтра"] = Фильтры[0];
	КонецЕсли;
	
	Форма.Элементы[Префикс + "ВариантФильтра"].Доступность = ФильтрыСписковКлиентСервер.ИспользоватьФильтры(Форма);
	ВариантФильтраПриИзменении(Форма);
	
КонецПроцедуры

Процедура СохранитьНастройки(Форма)
	
	Префикс = ФильтрыСписковКлиентСервер.Префикс();
	Если Форма[Префикс + "СохранятьНастройки"] Тогда
		
		Настройки = Новый Структура;
		Настройки.Вставить("ИспользоватьФильтры", ФильтрыСписковКлиентСервер.ИспользоватьФильтры(Форма));
		Настройки.Вставить("ВариантФильтра", ФильтрыСписковКлиентСервер.ТекущийФильтр(Форма));
		
		ОбщегоНазначения.ХранилищеОбщихНастроекСохранить(Префикс, Форма.КодФормы, Настройки);
		
	КонецЕсли;
	
КонецПроцедуры

Функция ОписаниеЭлементовФормы(ИмяГруппыДляРазмещения)
	
	Описание =
	"<Форма>
	|	<Реквизиты>
	|		<Реквизит Имя='%1ИспользоватьФильтры' Заголовок='" + НСтр("ru='Фильтр по'") + "'>
	|			<Типы>
	|				<Тип>Булево</Тип>
	|			</Типы>
	|		</Реквизит>
	|		<Реквизит Имя='%1ВариантФильтра'>
	|			<Типы>
	|				<Тип>Строка</Тип>
	|			</Типы>
	|		</Реквизит>
	|		<Реквизит Имя='%1ОтображаемыйВариантФильтра'>
	|			<Типы>
	|				<Тип>Строка</Тип>
	|			</Типы>
	|		</Реквизит>
	|		<Реквизит Имя='%1ИмяФильтруемогоСписка'>
	|			<Типы>
	|				<Тип>Строка</Тип>
	|			</Типы>
	|		</Реквизит>
	|		<Реквизит Имя='%1ИспользуетсяРасширенныйИлиСтандартныйПоиск'>
	|			<Типы>
	|				<Тип>Булево</Тип>
	|			</Типы>
	|		</Реквизит>
	|		<Реквизит Имя='%1СохранятьНастройки'>
	|			<Типы><Тип>Булево</Тип></Типы>
	|		</Реквизит>
	|	</Реквизиты>
	|	<Элементы>
	|		<ГруппаФормы Имя='%1ГруппаВыборФильтра' Родитель='%2'>
	|				<Свойство Имя='Вид'>ОбычнаяГруппа</Свойство>
	|				<Свойство Имя='ОтображатьЗаголовок'>Ложь</Свойство>
	|				<Свойство Имя='Отображение'>Нет</Свойство>
	|				<Свойство Имя='Группировка'>Горизонтальная</Свойство>
	|			<ПолеФормы Имя='%1ИспользоватьФильтры'>
	|					<Свойство Имя='ПутьКДанным'>%1ИспользоватьФильтры</Свойство>
	|					<Свойство Имя='Вид'>ПолеФлажка</Свойство>
	|					<Свойство Имя='ПоложениеЗаголовка'>Право</Свойство>
	|				<События>
	|					<ПриИзменении Действие='Подключаемый_ФильтрыСписков_ИспользоватьФильтрыПриИзменении' />
	|				</События>
	|			</ПолеФормы>
	|			<ПолеФормы Имя='%1ВариантФильтра'>
	|					<Свойство Имя='ПутьКДанным'>%1ВариантФильтра</Свойство>
	|					<Свойство Имя='Вид'>ПолеВвода</Свойство>
	|					<Свойство Имя='ПоложениеЗаголовка'>Нет</Свойство>
	|					<Свойство Имя='РежимВыбораИзСписка'>Истина</Свойство>
	|					<Свойство Имя='РедактированиеТекста'>Ложь</Свойство>
	|					<Свойство Имя='АвтоМаксимальнаяШирина'>Ложь</Свойство>
	|					<Свойство Имя='МаксимальнаяШирина'>19</Свойство>
	|				<События>
	|					<ПриИзменении Действие='Подключаемый_ФильтрыСписков_ВариантФильтраПриИзменении' />
	|					<Очистка Действие='Подключаемый_ФильтрыСписков_ВариантФильтраОчистка' />
	|				</События>
	|			</ПолеФормы>
	|		</ГруппаФормы>
	|		<ГруппаФормы Имя='%1ГруппаФильтры' Родитель='%2'>
	|				<Свойство Имя='Вид'>Страницы</Свойство>
	|				<Свойство Имя='ОтображениеСтраниц'>Нет</Свойство>
	|				<Свойство Имя='РастягиватьПоВертикали'>Истина</Свойство>
	|				<Свойство Имя='СочетаниеКлавиш'>Alt+_2</Свойство>
	|		</ГруппаФормы>
	|	</Элементы>
	|</Форма>
	|";
	
	Описание = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(Описание, ФильтрыСписковКлиентСервер.Префикс(), ИмяГруппыДляРазмещения);
	Возврат Описание;
	
КонецФункции

#КонецОбласти // СлужебныеПроцедурыИФункции
