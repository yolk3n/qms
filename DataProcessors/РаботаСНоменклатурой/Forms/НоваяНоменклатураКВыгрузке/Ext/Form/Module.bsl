﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ЗаполнитьСписокОрганизаций(Отказ);
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	ЗаполнитьРеквизитыФормы();
	УстановитьПараметрыДинамическихСписков();
	УстановитьУсловноеОформление();
	
	ДлительнаяОперация = НоваяНоменклатураПоОрганизациям(УникальныйИдентификатор);
	Элементы.ГруппаДлительнаяОперация.Видимость = Ложь;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ОбновитьЗаголовкиЗакладок();
	Элементы.ДекорацияОтбор.Заголовок = РаботаСНоменклатуройСлужебныйКлиент.ЗаголовокДекорацииУсловияОтбора(НастройкиОтбора);
	
	Если ДлительнаяОперация.Статус = "Выполнено" Тогда
		ОбновитьПараметрыПоОрганизациям(ДлительнаяОперация, Неопределено);
		Возврат
	КонецЕсли;
	
	ОповещениеОЗавершении = Новый ОписаниеОповещения("ОбновитьПараметрыПоОрганизациям", ЭтотОбъект);
	ПараметрыОжидания     = ДлительныеОперацииКлиент.ПараметрыОжидания(ЭтаФорма);
	ПараметрыОжидания.ВыводитьОкноОжидания = Ложь;
	
	ДлительныеОперацииКлиент.ОжидатьЗавершение(ДлительнаяОперация, ОповещениеОЗавершении, ПараметрыОжидания);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(СписокНовая, "Организация", Организация);
	ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(СписокОжидаетВыгрузки, "Организация", Организация);
	ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(СписокВыгрузкаЗапрещена, "Организация", Организация);
КонецПроцедуры

&НаКлиенте
Процедура ОрганизацияОчистка(Элемент, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
КонецПроцедуры

&НаКлиенте
Процедура ОрганизацияОткрытие(Элемент, СтандартнаяОбработка)
	Если ЗначениеЗаполнено(Организация) Тогда
		СтандартнаяОбработка = Ложь;
		РаботаСНоменклатуройКлиент.ОткрытьПомощникВыгрузки(Организация);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ДекорацияОтборОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)

	СтандартнаяОбработка = Ложь;
	ПараметрыОткрытия    = РаботаСНоменклатуройКлиент.ПараметрыФормыУсловияОтбораНоменклатуры();
	ПараметрыОткрытия.НастройкиОтбора = НастройкиОтбора;
	РаботаСНоменклатуройКлиент.ОткрытьФормуУсловияОтбораНоменклатуры(ПараметрыОткрытия, ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура СписокНоваяВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Если Элемент.ТекущиеДанные.ИндексКартинки = 0 Тогда
		ОписаниеОповещения = Новый ОписаниеОповещения("ПослеУстраненияПроблем", ЭтотОбъект);
		ПараметрыОткрытия  = РаботаСНоменклатуройКлиент.ПараметрыФормыСопоставленияНоменклатурыСРубрикатором();
		ПараметрыОткрытия.Заголовок             = НСтр("ru = 'Подготовка номенклатуры к выгрузке'");
		ПараметрыОткрытия.ЗаголовокКатегории    = НСтр("ru = 'Категория 1С:Номенклатура'");
		ПараметрыОткрытия.ЗаголовокРеквизита    = НСтр("ru = 'Реквизит 1С:Номенклатура'");
		ПараметрыОткрытия.ЗаголовокТипа         = НСтр("ru = 'Тип 1С:Номенклатура'");
		ПараметрыОткрытия.ИнформацияСписок      = НСтр("ru = 'Необходимо сопоставить категории рубрикатора 1С:Номенклатура.'");
		ПараметрыОткрытия.ИнформацияРеквизиты   = НСтр("ru = 'Необходимо сопоставить реквизиты номенклатуры с реквизитами сервиса 1С:Номенклатура.'");
		ПараметрыОткрытия.СценарийИспользования = "УстранениеПроблемЗаполнения";
		
		ПараметрыОткрытия.Вставить("КлючЗаписиРегистра", ВыбраннаяСтрока);
		ПараметрыОткрытия.Вставить("СостояниеВыгрузки", ПредопределенноеЗначение("Перечисление.СостоянияВыгрузкиНоменклатуры.ОжидаетИсправления"));
		
		РаботаСНоменклатуройКлиент.ОткрытьФормуСопоставленияНоменклатурыСРубрикатором(ПараметрыОткрытия, ЭтотОбъект, 
			ОписаниеОповещения, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	Иначе 
		ОбработатьВыделенные();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ДобавитьВыделенные(Команда)
	ОбработатьВыделенные();
КонецПроцедуры

&НаКлиенте
Процедура УдалитьВыделенные(Команда)
	ОбработатьВыделенные(Ложь);
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьВсе(Команда)
	ОбработатьВсеНаКлиенте();
КонецПроцедуры

&НаКлиенте
Процедура УдалитьВсе(Команда)
	ОбработатьВсеНаКлиенте(Ложь);
КонецПроцедуры

&НаКлиенте
Процедура ЗапуститьВыгрузку(Команда)
	
	ОчиститьСообщения();
	
	Если Организация.Пустая() Тогда
		ОбщегоНазначенияКлиент.СообщитьПользователю(НСтр("ru = 'Не выбрана настройка'"),, "Организация");
		Возврат;
	КонецЕсли;
	
	ЭлементСписка = Элементы.Организация.СписокВыбора.НайтиПоЗначению(Организация);
	Если ЭлементСписка = Неопределено Тогда
		ОбщегоНазначенияКлиент.СообщитьПользователю(НСтр("ru = 'Ошибка чтения параметров'"));
		Возврат;
	КонецЕсли;
	
	Если КоличествоВыгружается = 0 Тогда
		ОбщегоНазначенияКлиент.СообщитьПользователю(НСтр("ru = 'Выберите номенклатуру для выгрузки'"));
		Возврат;
	КонецЕсли;
	
	ВыгрузкаНоменклатуры    = ВыгрузитьНоменклатуру(УникальныйИдентификатор, Организация, ДатаОткрытияФормы);
	ДополнительныеПараметры = Новый Структура("Организация", Организация);
	Если ВыгрузкаНоменклатуры.Статус = "Выполнено" Тогда
		ПослеЗавершенияВыгрузки(ВыгрузкаНоменклатуры, ДополнительныеПараметры);
		Возврат
	КонецЕсли;
	
	ЭлементСписка.Картинка = БиблиотекаКартинок.ДлительнаяОперацияСиняяСНоменклатурой;
	ЭлементСписка.Пометка  = Истина;
	
	Элементы.ГруппаДлительнаяОперация.Видимость = ЭлементСписка.Пометка;
	Элементы.ДлительнаяОперация16.Видимость     = ЭлементСписка.Пометка;
	Элементы.ВыполненоУспешно.Видимость         = НЕ ЭлементСписка.Пометка;
	
	ОповещениеОЗавершении = Новый ОписаниеОповещения("ПослеЗавершенияВыгрузки", ЭтотОбъект, ДополнительныеПараметры);
	ПараметрыОжидания     = ДлительныеОперацииКлиент.ПараметрыОжидания(ЭтаФорма);
	ПараметрыОжидания.ВыводитьОкноОжидания = Ложь;
	
	ДлительныеОперацииКлиент.ОжидатьЗавершение(ВыгрузкаНоменклатуры, ОповещениеОЗавершении, ПараметрыОжидания);
	
КонецПроцедуры

&НаКлиенте
Процедура УбратьИзВыгрузки(Команда)
	
	НоменклатураДляУдаления = Элементы.СписокНовая.ВыделенныеСтроки;
	ВыбраноСтрок            = НоменклатураДляУдаления.Количество();
	
	Если ВыбраноСтрок = 0 Тогда
		ОчиститьСообщения();
		ОбщегоНазначенияКлиент.СообщитьПользователю(НСтр("ru = 'Не выбрана номенклатура'"));
		Возврат;
	КонецЕсли;
	
	ДлительнаяОперация = УдалитьЗаписиРегистра(УникальныйИдентификатор, Организация, НоменклатураДляУдаления);
	Если ДлительнаяОперация.Статус = "Выполнено" Тогда
		ПослеУдаленияЗаписейРегистра(ДлительнаяОперация, ВыбраноСтрок);
		Возврат
	КонецЕсли;
	
	ОповещениеОЗавершении = Новый ОписаниеОповещения("ПослеУдаленияЗаписейРегистра", ЭтотОбъект, ВыбраноСтрок);
	ПараметрыОжидания     = ДлительныеОперацииКлиент.ПараметрыОжидания(ЭтаФорма);
	ПараметрыОжидания.ВыводитьОкноОжидания = Ложь;
	
	ДлительныеОперацииКлиент.ОжидатьЗавершение(ДлительнаяОперация, ОповещениеОЗавершении, ПараметрыОжидания);
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеУдаленияЗаписейРегистра(Результат, ДополнительныеПараметры) Экспорт 
	
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если НЕ (Результат.Свойство("Статус") И Результат.Статус = "Выполнено") Тогда 
		Возврат
	КонецЕсли;
	
	Элементы.СписокНовая.Обновить();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ОбновитьЗаголовкиЗакладок(ОбновитьВыгружается = Истина, ОбновитьИсключения = Истина)
	
	СтрокаДостигнутЛимит = СтрШаблон(НСтр("ru = '(более %1)'"), ЛимитСтрока);
	
	Если ОбновитьВыгружается = Истина Тогда
		ВыгружаетсяПредставление = "";
		Если КоличествоВыгружается >= ЛимитЧисло Тогда
			ВыгружаетсяПредставление = СтрокаДостигнутЛимит;
		ИначеЕсли КоличествоВыгружается > 0 Тогда
			ВыгружаетсяПредставление = СтрШаблон("(%1)", КоличествоВыгружается);
		КонецЕсли;
		Элементы.СтраницаВыгружаются.Заголовок = СтрШаблон(НСтр("ru = 'Будет выгружено %1'"), ВыгружаетсяПредставление);
		Элементы.ЗапуститьВыгрузку.Заголовок   = СтрШаблон(НСтр("ru = 'Выгрузить сейчас %1'"), ВыгружаетсяПредставление);
		
		Если ОбновитьВыгружается <> ОбновитьИсключения Тогда
			Элементы.СписокОжидаетВыгрузки.Обновить();
		КонецЕсли;
	КонецЕсли;
	
	Если ОбновитьИсключения = Истина Тогда
		ИсключенияПредставление = "";
		Если КоличествоИсключения >= ЛимитЧисло Тогда
			ИсключенияПредставление = СтрокаДостигнутЛимит;
		ИначеЕсли КоличествоИсключения > 0 Тогда
			ИсключенияПредставление = СтрШаблон("(%1)", КоличествоИсключения);
		КонецЕсли;
		Элементы.СтраницаИсключения.Заголовок = СтрШаблон(НСтр("ru = 'Исключения %1'"), ИсключенияПредставление);
		
		Если ОбновитьВыгружается <> ОбновитьИсключения Тогда
			Элементы.СписокВыгрузкаЗапрещена.Обновить();
		КонецЕсли;
	КонецЕсли;
	
	Если ОбновитьВыгружается <> ОбновитьИсключения Тогда
		Элементы.СписокНовая.Обновить();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработатьВыделенные(Добавление = Истина)
	
	ОчиститьСообщения();
	Если НЕ ЗначениеЗаполнено(Организация) Тогда
		ОбщегоНазначенияКлиент.СообщитьПользователю(НСтр("ru = 'Не выбрана настройка'"),, "Организация");
		Возврат;
	КонецЕсли;
	
	Если Добавление = Истина Тогда
		СписокИсточник = Элементы.СписокНовая;
		Если Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.СтраницаВыгружаются Тогда
			СписокПриемник  = Элементы.СписокОжидаетВыгрузки;
			Состояние = ПредопределенноеЗначение("Перечисление.СостоянияВыгрузкиНоменклатуры.ОжидаетВыгрузки");
		Иначе 
			СписокПриемник  = Элементы.СписокВыгрузкаЗапрещена;
			Состояние = ПредопределенноеЗначение("Перечисление.СостоянияВыгрузкиНоменклатуры.ВыгрузкаЗапрещена");
		КонецЕсли;
	Иначе 
		СписокПриемник  = Элементы.СписокНовая;
		Если Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.СтраницаВыгружаются Тогда
			СписокИсточник  = Элементы.СписокОжидаетВыгрузки;
			Состояние = ПредопределенноеЗначение("Перечисление.СостоянияВыгрузкиНоменклатуры.ОжидаетПодтверждения");
		Иначе 
			СписокИсточник  = Элементы.СписокВыгрузкаЗапрещена;
			Состояние = ПредопределенноеЗначение("Перечисление.СостоянияВыгрузкиНоменклатуры.ОжидаетПроверки");
		КонецЕсли;
	КонецЕсли;
	
	ВыделенныеСтроки = СписокИсточник.ВыделенныеСтроки;
	КоличествоСтрок  = ВыделенныеСтроки.Количество();
	
	Если КоличествоСтрок = 0 Тогда
		ОбщегоНазначенияКлиент.СообщитьПользователю(НСтр("ru = 'Не выбрана номенклатура для обработки'"));
		Возврат;
	КонецЕсли;
	
	Если СписокИсточник = Элементы.СписокНовая 
		И СписокПриемник  = Элементы.СписокОжидаетВыгрузки Тогда
		Для ОбратныйИндекс = 1 По КоличествоСтрок Цикл
			ДанныеСтроки = СписокИсточник.ДанныеСтроки(ВыделенныеСтроки[КоличествоСтрок - ОбратныйИндекс]);
			Если ДанныеСтроки.ИндексКартинки = 0 Тогда
				ВыделенныеСтроки.Удалить(КоличествоСтрок - ОбратныйИндекс);
			КонецЕсли;
		КонецЦикла;
		
		Если ВыделенныеСтроки.Количество() = 0 Тогда
			ОбщегоНазначенияКлиент.СообщитьПользователю(НСтр("ru = 'Отметить к выгрузке можно только корректно заполненную номенклатуру'"));
			Возврат;
		КонецЕсли;
	КонецЕсли;
	
	Если Состояние = ПредопределенноеЗначение("Перечисление.СостоянияВыгрузкиНоменклатуры.ОжидаетПроверки") Тогда
		ДлительнаяОперация = ПроверкаГотовности(УникальныйИдентификатор, Организация, ВыделенныеСтроки);
		Если ДлительнаяОперация = Неопределено Тогда
			Возврат;
		КонецЕсли;
	Иначе 
		ДлительнаяОперация = РаботаСНоменклатуройСлужебныйВызовСервера.ИзменитьЗаписиРегистраПоСписку(УникальныйИдентификатор,
			Организация, ВыделенныеСтроки, Состояние);
	КонецЕсли;
	
	ДополнительныеПараметры = Новый Структура();
	ДополнительныеПараметры.Вставить("КоличествоИзменение", ?(Добавление = Истина, 1, -1) * ВыделенныеСтроки.Количество());
	ДополнительныеПараметры.Вставить("ОбновитьВыгружается", Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.СтраницаВыгружаются);
	
	Если ДлительнаяОперация.Статус = "Выполнено" Тогда
		ПослеОбновленияЗаписейРегистра(ДлительнаяОперация, ДополнительныеПараметры);
		Возврат
	КонецЕсли;
	
	ОповещениеОЗавершении = Новый ОписаниеОповещения("ПослеОбновленияЗаписейРегистра", ЭтотОбъект, ДополнительныеПараметры);
	ПараметрыОжидания     = ДлительныеОперацииКлиент.ПараметрыОжидания(ЭтаФорма);
	ПараметрыОжидания.ВыводитьОкноОжидания = Ложь;
	
	ДлительныеОперацииКлиент.ОжидатьЗавершение(ДлительнаяОперация, ОповещениеОЗавершении, ПараметрыОжидания);
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПроверкаГотовности(УникальныйИдентификатор, Организация, ВыделенныеСтроки)
	
	Состояние = Перечисления.СостоянияВыгрузкиНоменклатуры.ОжидаетПроверки;
	Обработки.РаботаСНоменклатурой.ЗаписатьДанныеВРегистрНоменклатураКВыгрузке(Организация, ВыделенныеСтроки, Состояние);
	
	Возврат РаботаСНоменклатуройСлужебныйВызовСервера.ПроверитьГотовностьНоменклатурнойПозиции(УникальныйИдентификатор,
		Организация, ВыделенныеСтроки, Состояние);

КонецФункции

&НаКлиенте
Процедура ПослеОбновленияЗаписейРегистра(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат.Статус <> "Выполнено" Тогда 
		Возврат
	КонецЕсли;
	
	Если ДополнительныеПараметры.ОбновитьВыгружается Тогда
		КоличествоВыгружается = КоличествоВыгружается + ДополнительныеПараметры.КоличествоИзменение;
		ОбновитьЗаголовкиЗакладок(Истина, Ложь);
	Иначе 
		КоличествоИсключения = КоличествоИсключения + ДополнительныеПараметры.КоличествоИзменение;
		ОбновитьЗаголовкиЗакладок(Ложь, Истина);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработатьВсеНаКлиенте(Добавить = Истина)
	
	ДлительнаяОперация = ОбработатьВсе(УникальныйИдентификатор, Организация, ДатаОткрытияФормы, Добавить);
	Если ДлительнаяОперация.Статус = "Выполнено" Тогда
		ОбработатьВсеЗавершение(ДлительнаяОперация, Добавить);
		Возврат
	КонецЕсли;
	
	ОповещениеОЗавершении = Новый ОписаниеОповещения("ОбработатьВсеЗавершение", ЭтотОбъект, Добавить);
	ПараметрыОжидания     = ДлительныеОперацииКлиент.ПараметрыОжидания(ЭтаФорма);
	ПараметрыОжидания.ВыводитьОкноОжидания = Ложь;
	
	ДлительныеОперацииКлиент.ОжидатьЗавершение(ДлительнаяОперация, ОповещениеОЗавершении, ПараметрыОжидания);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработатьВсеЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если НЕ (Результат.Статус = "Выполнено" 
		И Результат.Свойство("АдресРезультата")
		И ТипЗнч(Результат.АдресРезультата) = Тип("Строка") 
		И ЭтоАдресВременногоХранилища(Результат.АдресРезультата)) Тогда 
		Возврат
	КонецЕсли;
	
	ОбработаноЗаписей     = ПолучитьИзВременногоХранилища(Результат.АдресРезультата);
	КоличествоВыгружается = КоличествоВыгружается + ОбработаноЗаписей * ?(ДополнительныеПараметры = Истина, 1, -1);
	ОбновитьЗаголовкиЗакладок(Истина, Ложь);
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ОбработатьВсе(Знач УникальныйИдентификатор, Знач Организация, Знач ДатаОткрытияФормы, Знач Добавить)
	
	НаименованиеЗадания = НСтр("ru = 'Работа с номенклатурой. Обновление состояний новой номенклатуры.'");
	ИмяМетода           = "Обработки.РаботаСНоменклатурой.ОбновитьСостоянияНовойНоменклатуры";
	ПараметрыВыполнения = ДлительныеОперации.ПараметрыВыполненияВФоне(УникальныйИдентификатор);
	ПараметрыВыполнения.НаименованиеФоновогоЗадания = НаименованиеЗадания;
	
	Возврат ДлительныеОперации.ВыполнитьФункцию(ПараметрыВыполнения, ИмяМетода, Организация, ДатаОткрытияФормы, Добавить);
	
КонецФункции

&НаСервереБезКонтекста
Функция НоваяНоменклатураПоОрганизациям(Знач УникальныйИдентификатор)
	
	НаименованиеЗадания = НСтр("ru = 'Работа с номенклатурой. Вычисление количества новой номенклатуры по организациям'");
	ИмяМетода           = "Обработки.РаботаСНоменклатурой.НоваяНоменклатураПоОрганизациям";
	ПараметрыВыполнения = ДлительныеОперации.ПараметрыВыполненияВФоне(УникальныйИдентификатор);
	ПараметрыВыполнения.НаименованиеФоновогоЗадания = НаименованиеЗадания;
	
	Возврат ДлительныеОперации.ВыполнитьФункцию(ПараметрыВыполнения, ИмяМетода);
	
КонецФункции

&НаКлиенте
Процедура ОбновитьПараметрыПоОрганизациям(Результат, ДополнительныеПараметры) Экспорт
	
	Если НЕ (Результат.Статус = "Выполнено" 
		И Результат.Свойство("АдресРезультата")
		И ТипЗнч(Результат.АдресРезультата) = Тип("Строка") 
		И ЭтоАдресВременногоХранилища(Результат.АдресРезультата)) Тогда 
		Возврат
	КонецЕсли;
	
	КоличествоПоОрганизациям = ПолучитьИзВременногоХранилища(Результат.АдресРезультата);
	
	Для каждого ЭлементСписка Из Элементы.Организация.СписокВыбора Цикл
		Количество = КоличествоПоОрганизациям.Получить(ЭлементСписка.Значение);
		ЭлементСписка.Представление = СтрШаблон("%1 (%2)", Строка(ЭлементСписка.Значение), Количество);
	КонецЦикла;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ВыгрузитьНоменклатуру(Знач УникальныйИдентификатор, Знач Организация, Знач ДатаОткрытияФормы)
	
	НастройкаВыгрузки = РаботаСНоменклатуройСлужебный.НастройкаВыгрузкиНоменклатуры(Организация);
	ПараметрыЗапроса  = Новый Структура("ДатаОткрытияФормы", ДатаОткрытияФормы);
	УсловиеСоединения = "СостоянияВыгрузкиНоменклатуры.Организация = &Организация
	|	И %1 = СостоянияВыгрузкиНоменклатуры.Номенклатура
	|	И СостоянияВыгрузкиНоменклатуры.Состояние = ЗНАЧЕНИЕ(Перечисление.СостоянияВыгрузкиНоменклатуры.ОжидаетВыгрузки)
	|	И СостоянияВыгрузкиНоменклатуры.ДатаСостояния > &ДатаОткрытияФормы";
	
	НастройкаВыгрузки.Вставить("УсловиеСоединения", УсловиеСоединения);
	НастройкаВыгрузки.Вставить("ПараметрыЗапроса", ПараметрыЗапроса);
	
	НаименованиеЗадания = НСтр("ru = 'Работа с номенклатурой. Выгрузка номенклатуры'");
	ИмяМетода           = "РаботаСНоменклатуройСлужебный.ВыгрузитьДанныеНоменклатуры";
	ПараметрыВыполнения = ДлительныеОперации.ПараметрыВыполненияВФоне(УникальныйИдентификатор);
	ПараметрыВыполнения.НаименованиеФоновогоЗадания = НаименованиеЗадания;
	
	Возврат ДлительныеОперации.ВыполнитьПроцедуру(ПараметрыВыполнения, ИмяМетода, НастройкаВыгрузки);
	
КонецФункции

&НаКлиенте
Процедура ПослеЗавершенияВыгрузки(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат.Статус <> "Выполнено" Тогда 
		Возврат
	КонецЕсли;
	
	ЭлементСписка = Элементы.Организация.СписокВыбора.НайтиПоЗначению(ДополнительныеПараметры.Организация);
	Если ЭлементСписка = Неопределено Тогда
		Возврат
	КонецЕсли;
	
	ЭлементСписка.Картинка = БиблиотекаКартинок.Успешно;
	ЭлементСписка.Пометка  = Ложь;
	
	Элементы.ГруппаДлительнаяОперация.Видимость = ЭлементСписка.Пометка;
	Элементы.ДлительнаяОперация16.Видимость     = ЭлементСписка.Пометка;
	Элементы.ВыполненоУспешно.Видимость         = НЕ ЭлементСписка.Пометка;
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеУстраненияПроблем(Результат, ДополнительныеПараметры) Экспорт
	Элементы.СписокНовая.Обновить();
	Элементы.СписокОжидаетВыгрузки.Обновить();
КонецПроцедуры

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	ЭлементУсловногоОформления = УсловноеОформление.Элементы.Добавить();
	ПолеЭлемента = ЭлементУсловногоОформления.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.СписокНоваяСостояние.Имя);
	ОтборЭлемента = ЭлементУсловногоОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("СписокНовая.ИндексКартинки");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = -1;
	ЭлементУсловногоОформления.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.НедоступныеДанныеЭДЦвет);
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция УдалитьЗаписиРегистра(Знач УникальныйИдентификатор, Знач Организация, Знач МассивДанных)
	
	НаименованиеЗадания = НСтр("ru = 'Работа с номенклатурой. Удаление записей из регистра ""Состояния выгрузки"".'");
	ИмяМетода           = "РаботаСНоменклатуройСлужебный.УдалитьПроблемы";
	ПараметрыВыполнения = ДлительныеОперации.ПараметрыВыполненияВФоне(УникальныйИдентификатор);
	ПараметрыВыполнения.НаименованиеФоновогоЗадания = НаименованиеЗадания;
	
	Возврат ДлительныеОперации.ВыполнитьФункцию(ПараметрыВыполнения, ИмяМетода, Организация, МассивДанных);
	
КонецФункции

&НаСервере
Процедура ЗаполнитьСписокОрганизаций(Отказ)

	ИмяТаблицыОрганизация = РаботаСНоменклатурой.ИмяТаблицыПоТипу(Метаданные.ОпределяемыеТипы.Организация.Тип);

	Если ИмяТаблицыОрганизация = "" Тогда
		ОбщегоНазначения.СообщитьПользователю(
		НСтр(
			"ru = 'Не удалось определить имя таблицы определяемого типа ""Организация"". Форма не может быть открыта.'"),
			, , , Отказ);
		Возврат;
	КонецЕсли;

	ТекстЗапроса = "ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	СправочникОрганизации.Ссылка КАК Организация,
	|	ПРЕДСТАВЛЕНИЕ(СправочникОрганизации.Ссылка) КАК Представление
	|ИЗ
	|	Справочник.Организации КАК СправочникОрганизации
	|ГДЕ
	|	ИСТИНА В
	|		(ВЫБРАТЬ ПЕРВЫЕ 1
	|			ИСТИНА
	|		ИЗ
	|			РегистрСведений.СостоянияВыгрузкиНоменклатуры КАК СостоянияВыгрузкиНоменклатуры
	|		ГДЕ
	|			СостоянияВыгрузкиНоменклатуры.Организация = СправочникОрганизации.Ссылка
	|			И
	|				СостоянияВыгрузкиНоменклатуры.Состояние = ЗНАЧЕНИЕ(Перечисление.СостоянияВыгрузкиНоменклатуры.ОжидаетПодтверждения)
	|
	|		ОБЪЕДИНИТЬ ВСЕ
	|
	|		ВЫБРАТЬ
	|			ИСТИНА
	|		ИЗ
	|			РегистрСведений.СостоянияВыгрузкиНоменклатуры КАК СостоянияВыгрузкиНоменклатуры
	|		ГДЕ
	|			СостоянияВыгрузкиНоменклатуры.Организация = СправочникОрганизации.Ссылка
	|			И
	|				СостоянияВыгрузкиНоменклатуры.Состояние = ЗНАЧЕНИЕ(Перечисление.СостоянияВыгрузкиНоменклатуры.ОжидаетИсправления))";

	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "Справочник.Организации", ИмяТаблицыОрганизация);
	Запрос       = Новый Запрос(ТекстЗапроса);

	Организации = Запрос.Выполнить().Выгрузить();
	Если Организации.Количество() = 0 Тогда
		ОбщегоНазначения.СообщитьПользователю(
			НСтр("ru = 'Новая номенклатура не найдена, форма не может быть открыта'"),
			, , , Отказ);
		Возврат;
	КонецЕсли;
	Для Каждого ОписаниеОрганизации Из Организации Цикл
		Элементы.Организация.СписокВыбора.Добавить(ОписаниеОрганизации.Организация,
			ОписаниеОрганизации.Представление, ,
			БиблиотекаКартинок.Пустая);
	КонецЦикла;
	Организация = Организации[0].Организация;

КонецПроцедуры

&НаСервере
Процедура УстановитьПараметрыДинамическихСписков()
	
	ПустаяХарактеристика         = РаботаСНоменклатурой.ПустаяСсылкаНаХарактеристику();
	ДатаОткрытияФормы            = ТекущаяДатаСеанса();
	ВедетсяУчетПоХарактеристикам = (РаботаСНоменклатурой.ВедетсяУчетПоХарактеристикам() = Истина);
	
	СписокСостояний = Новый СписокЗначений;
	СписокСостояний.Добавить(Перечисления.СостоянияВыгрузкиНоменклатуры.ОжидаетПодтверждения);
	СписокСостояний.Добавить(Перечисления.СостоянияВыгрузкиНоменклатуры.ОжидаетИсправления);
	
	ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(СписокНовая, "Организация", Организация);
	ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(СписокОжидаетВыгрузки, "Организация", Организация);
	ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(СписокВыгрузкаЗапрещена, "Организация", Организация);
	
	ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(СписокНовая, 
		"ВедетсяУчетПоХарактеристикам", ВедетсяУчетПоХарактеристикам);
	ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(СписокОжидаетВыгрузки,
		"ВедетсяУчетПоХарактеристикам", ВедетсяУчетПоХарактеристикам);
	ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(СписокВыгрузкаЗапрещена,
		"ВедетсяУчетПоХарактеристикам", ВедетсяУчетПоХарактеристикам);
	
	ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(СписокНовая, 
		"ПустаяХарактеристика", ПустаяХарактеристика);
	ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(СписокОжидаетВыгрузки,
		"ПустаяХарактеристика", ПустаяХарактеристика);
	ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(СписокВыгрузкаЗапрещена,
		"ПустаяХарактеристика", ПустаяХарактеристика);
	
	ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(СписокОжидаетВыгрузки, "ДатаОткрытияФормы", ДатаОткрытияФормы);
	ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(СписокВыгрузкаЗапрещена, "ДатаОткрытияФормы", ДатаОткрытияФормы);
	
	ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(СписокНовая, "ДобавитьКВыгрузке", НСтр("ru = 'Добавить к выгрузке >'"));
	ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(СписокНовая, "СписокСостояний", СписокСостояний);
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьРеквизитыФормы()
	
	ЛимитЧисло  = РаботаСНоменклатуройСлужебныйКлиентСервер.РазмерПорции();
	ЛимитСтрока = Формат(ЛимитЧисло, "ЧГ=");
	НастройкаВыгрузки = РаботаСНоменклатуройСлужебный.НастройкаВыгрузкиНоменклатуры(Организация);
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, НастройкаВыгрузки, "НастройкиОтбора");
	
КонецПроцедуры

#КонецОбласти