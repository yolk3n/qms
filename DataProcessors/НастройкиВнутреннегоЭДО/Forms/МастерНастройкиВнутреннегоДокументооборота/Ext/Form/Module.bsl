﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ОписаниеВидаВнутреннегоДокумента = Неопределено;
	
	Параметры.Свойство("Организация", Организация);
	Параметры.Свойство("ВидВнутреннегоДокумента", ОписаниеВидаВнутреннегоДокумента);
	
	Если ТипЗнч(ОписаниеВидаВнутреннегоДокумента) = Тип("СправочникСсылка.ВидыДокументовЭДО") Тогда
		ВидВнутреннегоДокумента = ОписаниеВидаВнутреннегоДокумента;
		ДанныеВидовВнутреннихДокументов = НастройкиВнутреннегоЭДОСлужебный.ДанныеВидовВнутреннихДокументов(
			ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(ВидВнутреннегоДокумента));
		Если ДанныеВидовВнутреннихДокументов.НайтиСледующий(ВидВнутреннегоДокумента, "Ссылка") Тогда
			ИдентификаторОбъектаУчета = ДанныеВидовВнутреннихДокументов.ИдентификаторОбъектаУчета;
			МетаданныеОбъектаУчета = ОбщегоНазначения.ОбъектМетаданныхПоИдентификатору(ИдентификаторОбъектаУчета);
			ПечатнаяФорма = ДанныеВидовВнутреннихДокументов.ИдентификаторКомандыПечати;
		КонецЕсли;
	Иначе
		ОписаниеВидаВнутреннегоДокумента.Свойство("ИдентификаторКомандыПечати", ПечатнаяФорма);
		ОписаниеОбъектаУчета = Неопределено;
		ОписаниеВидаВнутреннегоДокумента.Свойство("ОбъектУчета", ОписаниеОбъектаУчета);
		Если ТипЗнч(ОписаниеОбъектаУчета) = Тип("СправочникСсылка.ИдентификаторыОбъектовМетаданных") Тогда
			ИдентификаторОбъектаУчета = ОписаниеОбъектаУчета;
			МетаданныеОбъектаУчета = ОбщегоНазначения.ОбъектМетаданныхПоИдентификатору(ИдентификаторОбъектаУчета);
		Иначе 
			ОбъектУчета = ОписаниеОбъектаУчета;
			МетаданныеОбъектаУчета = ОбъектУчета.Метаданные();
			ИдентификаторОбъектаУчета = ОбщегоНазначения.ИдентификаторОбъектаМетаданных(МетаданныеОбъектаУчета.ПолноеИмя());
		КонецЕсли;
	КонецЕсли;
	
	ПредставлениеОбъектаУчета = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ИдентификаторОбъектаУчета, "Синоним");
	Элементы.ЗаголовокНастройкаМаршрутаПодписания.РасширеннаяПодсказка.Заголовок =
		СтрШаблон(НСтр("ru = 'Выберите вариант определения подписантов для документа ""%1""'"), ПредставлениеОбъектаУчета);
	
	КомандыПечати = ЭлектронныеДокументыЭДО.КомандыПечатиДляВнутреннегоЭДО(МетаданныеОбъектаУчета);
	КоличествоКомандПечати = КомандыПечати.Количество();
	
	Если КоличествоКомандПечати = 0 Тогда
		Элементы.ДекорацияНетПечатныхФорм.Заголовок =
			НастройкиВнутреннегоЭДОСлужебныйКлиентСервер.СообщениеОбОтсутствииПечатныхФормДляВнутреннегоЭДО();
		ДобавитьСтрокуТаблицыПереходов("НетПечатныхФорм", "СтраницаНавигацииНачало");
		Элементы.ГруппаКнопокМастера.Доступность = Ложь;
		Возврат;
	КонецЕсли;
	
	Для каждого КомандаПечати Из КомандыПечати Цикл
		Элементы.ПечатнаяФорма.СписокВыбора.Добавить(КомандаПечати.Идентификатор, КомандаПечати.Представление);
	КонецЦикла;
	
	Элементы.ПечатнаяФорма.Видимость = Не ЗначениеЗаполнено(ПечатнаяФорма) И КоличествоКомандПечати > 1;
	Элементы.ИспользоватьПечатнуюФормуПоУмолчанию.Видимость = КоличествоКомандПечати > 1;
	
	Если Не ЗначениеЗаполнено(ПечатнаяФорма) Тогда
		Если Элементы.ПечатнаяФорма.СписокВыбора.Количество() > 0 Тогда
			ПечатнаяФорма = Элементы.ПечатнаяФорма.СписокВыбора[0].Значение;
		КонецЕсли;
	КонецЕсли;
	
	ВидВнутреннегоДокумента = ЭлектронныеДокументыЭДО.НайтиСоздатьВидВнутреннегоДокумента(
		ИдентификаторОбъектаУчета, КомандаПечати);
	Настройка = НастройкаВнутреннегоЭДО(ВидВнутреннегоДокумента);
	ЕстьНастройка = Настройка <> Неопределено;
	
	ЕстьВозможностьПодключенияОбсуждений = ИнтеграцияБСПБЭД.ЕстьВозможностьПодключенияОбсуждений();
	
	ЕстьПравоПодключенияОбсуждений = ПравоДоступа("РегистрацияИнформационнойБазыСистемыВзаимодействия", Метаданные);
	Если ЕстьПравоПодключенияОбсуждений Тогда
		Элементы.ПанельПодключенияОбсуждений.ТекущаяСтраница = Элементы.ЕстьПравоПодключенияОбсуждений;
	Иначе
		Элементы.ПанельПодключенияОбсуждений.ТекущаяСтраница = Элементы.НетПраваПодключенияОбсуждений;
	КонецЕсли;
	
	ВидЭлектроннойПодписиПоОрганизации = НастройкиВнутреннегоЭДОСлужебный.ВидПодписиВнутреннегоЭДО(Организация);
	Если ВидЭлектроннойПодписиПоОрганизации = Перечисления.ВидыЭлектронныхПодписей.Простая
		Или ВидЭлектроннойПодписиПоОрганизации = Перечисления.ВидыЭлектронныхПодписей.УсиленнаяКвалифицированная Тогда
		
		ВидЭлектроннойПодписи = ВидЭлектроннойПодписиПоОрганизации;
		ПропуститьШагВыбораВидаЭлектроннойПодписи = Истина;
		ПропуститьШагФормированияСоглашенийССотрудниками =
			ВидЭлектроннойПодписиПоОрганизации = Перечисления.ВидыЭлектронныхПодписей.Простая; 
	Иначе
		ВидЭлектроннойПодписи = Перечисления.ВидыЭлектронныхПодписей.Простая;
	КонецЕсли;

	ЗаполнитьТаблицуПереходов();
	ВариантНастройки = "Подписание";
	ПриИзмененииВидаЭлектроннойПодписиВариантаНастройки(ЭтаФорма);
	
	СпособНастройкиМаршрута = "СписокПодписантов";
	ПриИзмененииСпособаНастройкиМаршрута(ЭтаФорма);
	
	Если Не ЕстьНастройка Или Не Настройка.ЭтоОсновнойВидДокумента Или Не Элементы.ИспользоватьПечатнуюФормуПоУмолчанию.Видимость Тогда
		ИспользоватьПечатнуюФормуПоУмолчанию = Истина;
	КонецЕсли;
	
	ОбновитьЗаголовокФлагаИспользоватьПечатнуюФормуПоУмолчанию(ЭтаФорма);
	ОбновитьОтображениеПредупрежденияПаденияПроизводительности();

КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	УстановитьПорядковыйНомерПерехода(1);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = ИнтеграцияБСПБЭДКлиент.ИмяСобытияЗаписьСертификата()
		И Элементы.ПанельОсновная.ТекущаяСтраница = Элементы.УстановкаСертификатов Тогда
		НайтиСертификатыКриптографии();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ВидЭлектроннойПодписиПростаяПриИзменении(Элемент)
	
	ПриИзмененииВидаЭлектроннойПодписиВариантаНастройки(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ВидЭлектроннойПодписиУсиленнаяКвалифицированнаяПриИзменении(Элемент)
	
	ПриИзмененииВидаЭлектроннойПодписиВариантаНастройки(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ВариантНастройкиПриИзменении(Элемент)
	
	ПриИзмененииВидаЭлектроннойПодписиВариантаНастройки(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ДекорацияСписокСертификатовНажатие(Элемент)
	
	ЭлектроннаяПодписьКлиент.ОткрытьНастройкиЭлектроннойПодписиИШифрования("Сертификаты");
	
КонецПроцедуры

&НаКлиенте
Процедура СпособНастройкиМаршрутаСписокПодписантовПриИзменении(Элемент)
	
	ПриИзмененииСпособаНастройкиМаршрута(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура СпособНастройкиМаршрутаМаршрутПодписанияПриИзменении(Элемент)
	
	ПриИзмененииСпособаНастройкиМаршрута(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаголовокФормированиеСоглашенийССотрудникамиРасширеннаяПодсказкаОбработкаНавигационнойСсылки(Элемент,
		НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	Если НавигационнаяСсылкаФорматированнойСтроки = "СформироватьУведомление" Тогда
		СтандартнаяОбработка = Ложь;
		СписокПользователей = ПолучитьПользователейЛистаОзнакомленияПЭП();
		НастройкиВнутреннегоЭДОСлужебныйКлиент.ОткрытьФормуФормированияУведомленияОбИспользованииПЭП(Организация,
			СписокПользователей, ЭтаФорма);
	ИначеЕсли НавигационнаяСсылкаФорматированнойСтроки = "СформироватьПоложение" Тогда
		СтандартнаяОбработка = Ложь;
		НастройкиВнутреннегоЭДОСлужебныйКлиент.ОткрытьФормуФормированияПоложенияОбИспользованииПЭП(Организация,
			ЭтаФорма);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПечатнаяФормаПриИзменении(Элемент)
	
	ОбновитьЗаголовокФлагаИспользоватьПечатнуюФормуПоУмолчанию(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ПечатнаяФормаОчистка(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
КонецПроцедуры

&НаКлиенте
Процедура МаршрутПодписанияНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)

	СтандартнаяОбработка = Ложь;;
	
	ОписаниеОповещения = Новый ОписаниеОповещения("МаршрутПодписанияЗавершениеВыбора", ЭтотОбъект);
	Отбор = МаршрутыПодписанияБЭДКлиент.НовыйОтборМаршрутовПодписания();
	Отбор.Организация = Организация;
	Если ВидЭлектроннойПодписи <> ПредопределенноеЗначение("Перечисление.ВидыЭлектронныхПодписей.Простая") Тогда
		Отбор.СхемыПодписания.Добавить(ПредопределенноеЗначение("Перечисление.СхемыПодписанияЭД.ОднойДоступнойПодписью"));
	КонецЕсли;
	Отбор.СхемыПодписания.Добавить(ПредопределенноеЗначение("Перечисление.СхемыПодписанияЭД.ПоПравилам"));
	Отбор.ВидПодписи = ВидЭлектроннойПодписи;
	
	МаршрутыПодписанияБЭДКлиент.ВыбратьМаршрутПодписания(Отбор, МаршрутПодписания, УникальныйИдентификатор, ОписаниеОповещения);

КонецПроцедуры

&НаКлиенте
Процедура МаршрутПодписанияЗавершениеВыбора(Результат, ДополнительныеПараметры) Экспорт

	Если ЗначениеЗаполнено(Результат) Тогда 
		МаршрутПодписания = Результат;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура УстановитьCryptoPRO(Команда)
	
	ОповещениеОЗавершении = Новый ОписаниеОповещения("ПовторныйПоискПрограммКриптографии", ЭтотОбъект);
	КриптографияБЭДКлиент.УстановитьCryptoPRO(ОповещениеОЗавершении, ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьVipNet(Команда)
	
	ОповещениеОЗавершении = Новый ОписаниеОповещения("ПовторныйПоискПрограммКриптографии", ЭтотОбъект);
	КриптографияБЭДКлиент.УстановитьVipNet(ОповещениеОЗавершении, ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаказатьСертификат(Команда)
	
	Оповещение = Новый ОписаниеОповещения("ПовторныйПоискСертификатов", ЭтотОбъект);
	
	ПараметрыДобавления = ЭлектроннаяПодписьКлиент.ПараметрыДобавленияСертификата();
	ПараметрыДобавления.Организация = Организация;
	ПараметрыДобавления.СоздатьЗаявление = Истина;
	ПараметрыДобавления.ИзЛичногоХранилища = Ложь;
	ЭлектроннаяПодписьКлиент.ДобавитьСертификат(Оповещение, ПараметрыДобавления);
	
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьСертификат(Команда)
	
	Оповещение = Новый ОписаниеОповещения("ПовторныйПоискСертификатов", ЭтотОбъект);
	
	ПараметрыДобавления = ЭлектроннаяПодписьКлиент.ПараметрыДобавленияСертификата();
	ПараметрыДобавления.Организация = Организация;
	ПараметрыДобавления.СоздатьЗаявление = Ложь;
	ПараметрыДобавления.ИзЛичногоХранилища = Истина;
	ЭлектроннаяПодписьКлиент.ДобавитьСертификат(Оповещение, ПараметрыДобавления);
	
КонецПроцедуры

&НаКлиенте
Процедура ПодключитьОбсуждения(Команда)
	
	ОписаниеЗавершения = Новый ОписаниеОповещения("ПодключитьОбсужденияЗавершение", ЭтотОбъект);
	ИнтеграцияБСПБЭДКлиент.ПодключитьОбсуждения(ОписаниеЗавершения);
	
КонецПроцедуры

&НаКлиенте
Процедура Далее(Команда)
	
	ВыполнитьПереходДалее();
	
КонецПроцедуры

&НаКлиенте
Процедура Назад(Команда)
	
	ИзменитьПорядковыйНомерПерехода(-1);
	
КонецПроцедуры

&НаКлиенте
Процедура Готово(Команда)
	
	Если Не ПроверитьЗаполнениеМаршрута(Ложь) Тогда
		Возврат;
	КонецЕсли;
	
	ЗавершитьНастройкуНаСервере();
	
	КлючНастройки = Новый Структура;
	КлючНастройки.Вставить("Организация", Организация);
	КлючНастройки.Вставить("ВидВнутреннегоДокумента", ВидВнутреннегоДокумента);
	
	РезультатЗакрытия = Новый Структура;
	РезультатЗакрытия.Вставить("КлючНастройки", КлючНастройки);
	РезультатЗакрытия.Вставить("Подписанты", Новый Массив);
	РезультатЗакрытия.Вставить("Маршрут", МаршрутПодписания);
	РезультатЗакрытия.Вставить("ВидЭлектроннойПодписи", ВидЭлектроннойПодписи);
	
	Закрыть(РезультатЗакрытия);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ЗаполнениеШаблоновДокументов

&НаСервере
Функция ПолучитьПользователейЛистаОзнакомленияПЭП()
	
	СписокПользователей = Новый Массив;
	
	Если СпособНастройкиМаршрута = "МаршрутПодписания" Тогда 
		СписокПользователей = МаршрутыПодписанияБЭД.ВозможныеПодписантыМаршрута(МаршрутПодписания);
	КонецЕсли;
	
	Возврат СписокПользователей;
		
КонецФункции 

#КонецОбласти

#Область РаботаСПомощником

#Область ПоставляемаяЧасть

&НаКлиенте
Функция ПолучитьКнопкуФормыПоИмениКоманды(ЭлементФормы, ИмяКоманды)
	
	Для Каждого Элемент Из ЭлементФормы.ПодчиненныеЭлементы Цикл
		
		Если ТипЗнч(Элемент) = Тип("ГруппаФормы") Тогда
			
			ЭлементФормыПоИмениКоманды = ПолучитьКнопкуФормыПоИмениКоманды(Элемент, ИмяКоманды);
			
			Если ЭлементФормыПоИмениКоманды <> Неопределено Тогда
				
				Возврат ЭлементФормыПоИмениКоманды;
				
			КонецЕсли;
			
		ИначеЕсли ТипЗнч(Элемент) = Тип("КнопкаФормы")
			И Элемент.ИмяКоманды = ИмяКоманды Тогда
			
			Возврат Элемент;
			
		Иначе
			
			Продолжить;
			
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат Неопределено;
	
КонецФункции

&НаКлиенте
Процедура ВыполнитьПереходДалее()
	
	ИзменитьПорядковыйНомерПерехода(+1);
	
КонецПроцедуры

&НаКлиенте
Процедура ИзменитьПорядковыйНомерПерехода(Итератор)
	
	ОчиститьСообщения();
	
	УстановитьПорядковыйНомерПерехода(ПорядковыйНомерПерехода + Итератор);
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьПорядковыйНомерПерехода(Знач Значение)
	
	ЭтоПереходДалее = (Значение > ПорядковыйНомерПерехода);
	
	ПорядковыйНомерПерехода = Значение;
	
	Если ПорядковыйНомерПерехода < 0 Тогда
		
		ПорядковыйНомерПерехода = 0;
		
	КонецЕсли;
	
	ПорядковыйНомерПереходаПриИзменении(ЭтоПереходДалее);
	
КонецПроцедуры

&НаКлиенте
Процедура ПорядковыйНомерПереходаПриИзменении(Знач ЭтоПереходДалее)
	
	// Выполняем обработчики событий перехода.
	ВыполнитьОбработчикиСобытийПерехода(ЭтоПереходДалее);
	
	// Устанавливаем отображение страниц.
	СтрокиПереходаТекущие = ТаблицаПереходов.НайтиСтроки(ОтборТаблицыПереходов(ПорядковыйНомерПерехода));
	
	Если СтрокиПереходаТекущие.Количество() = 0 Тогда
		ВызватьИсключение НСтр("ru = 'Не определена страница для отображения.'");
	КонецЕсли;
	
	ОбновитьЗаголовокФормы(ЭтаФорма);
	
	СтрокаПереходаТекущая = СтрокиПереходаТекущие[0];
	
	Элементы.ПанельОсновная.ТекущаяСтраница  = Элементы[СтрокаПереходаТекущая.ИмяОсновнойСтраницы];
	Элементы.ПанельНавигации.ТекущаяСтраница = Элементы[СтрокаПереходаТекущая.ИмяСтраницыНавигации];
	
	Элементы.ПанельНавигации.ТекущаяСтраница.Доступность = Не (ЭтоПереходДалее И СтрокаПереходаТекущая.ДлительнаяОперация);
	
	// Устанавливаем текущую кнопку по умолчанию.
	КнопкаДалее = ПолучитьКнопкуФормыПоИмениКоманды(Элементы.ПанельНавигации.ТекущаяСтраница, "Далее");
	
	Если КнопкаДалее <> Неопределено Тогда
		
		КнопкаДалее.КнопкаПоУмолчанию = Истина;
		
	Иначе
		
		КнопкаГотово = ПолучитьКнопкуФормыПоИмениКоманды(Элементы.ПанельНавигации.ТекущаяСтраница, "Готово");
		
		Если КнопкаГотово <> Неопределено Тогда
			
			КнопкаГотово.КнопкаПоУмолчанию = Истина;
			
		КонецЕсли;
		
	КонецЕсли;
	
	Если ЭтоПереходДалее И СтрокаПереходаТекущая.ДлительнаяОперация Тогда
		
		ПодключитьОбработчикОжидания("ВыполнитьОбработчикДлительнойОперации", 0.1, Истина);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьОбработчикиСобытийПерехода(Знач ЭтоПереходДалее)
	
	// Обработчики событий переходов.
	Если ЭтоПереходДалее Тогда
		СтрокиПерехода = ТаблицаПереходов.НайтиСтроки(ОтборТаблицыПереходов(ПорядковыйНомерПерехода - 1));
		
		Если СтрокиПерехода.Количество() > 0 Тогда
			СтрокаПерехода = СтрокиПерехода[0];
		
			// Обработчик ПриПереходеДалее.
			Если Не ПустаяСтрока(СтрокаПерехода.ИмяОбработчикаПриПереходеДалее)
				И Не СтрокаПерехода.ДлительнаяОперация Тогда
				
				ИмяПроцедуры = "Подключаемый_[ИмяОбработчика](Отказ)";
				ИмяПроцедуры = СтрЗаменить(ИмяПроцедуры, "[ИмяОбработчика]", СтрокаПерехода.ИмяОбработчикаПриПереходеДалее);
				
				Отказ = Ложь;
				
				//@skip-warning
				Результат = Вычислить(ИмяПроцедуры);
				
				Если Отказ Тогда
					
					УстановитьПорядковыйНомерПерехода(ПорядковыйНомерПерехода - 1);
					
					Возврат;
					
				КонецЕсли;
				
			КонецЕсли;
		КонецЕсли;
		
	Иначе
		
		СтрокиПерехода = ТаблицаПереходов.НайтиСтроки(ОтборТаблицыПереходов(ПорядковыйНомерПерехода + 1));
		
		Если СтрокиПерехода.Количество() = 0 Тогда
			Возврат;
		КонецЕсли;
		
	КонецЕсли;
	
	СтрокиПереходаТекущие = ТаблицаПереходов.НайтиСтроки(ОтборТаблицыПереходов(ПорядковыйНомерПерехода));
	
	Если СтрокиПереходаТекущие.Количество() = 0 Тогда
		ВызватьИсключение НСтр("ru = 'Не определена страница для отображения.'");
	КонецЕсли;
	
	СтрокаПереходаТекущая = СтрокиПереходаТекущие[0];
	
	Если СтрокаПереходаТекущая.ДлительнаяОперация И Не ЭтоПереходДалее Тогда
		
		УстановитьПорядковыйНомерПерехода(ПорядковыйНомерПерехода - 1);
		Возврат;
	КонецЕсли;
	
	// обработчик ПриОткрытии
	Если Не ПустаяСтрока(СтрокаПереходаТекущая.ИмяОбработчикаПриОткрытии) Тогда
		
		ИмяПроцедуры = "Подключаемый_[ИмяОбработчика](Отказ, ПропуститьСтраницу, ЭтоПереходДалее)";
		ИмяПроцедуры = СтрЗаменить(ИмяПроцедуры, "[ИмяОбработчика]", СтрокаПереходаТекущая.ИмяОбработчикаПриОткрытии);
		
		Отказ = Ложь;
		ПропуститьСтраницу = Ложь;
		
		//@skip-warning
		РезультатВычисления = Вычислить(ИмяПроцедуры);
		
		Если Отказ Тогда
			
			УстановитьПорядковыйНомерПерехода(ПорядковыйНомерПерехода - 1);
			
			Возврат;
			
		ИначеЕсли ПропуститьСтраницу Тогда
			
			Если ЭтоПереходДалее Тогда
				
				УстановитьПорядковыйНомерПерехода(ПорядковыйНомерПерехода + 1);
				
				Возврат;
				
			Иначе
				
				УстановитьПорядковыйНомерПерехода(ПорядковыйНомерПерехода - 1);
				
				Возврат;
				
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьОбработчикДлительнойОперации()
	
	СтрокиПереходаТекущие = ТаблицаПереходов.НайтиСтроки(ОтборТаблицыПереходов(ПорядковыйНомерПерехода));
	
	Если СтрокиПереходаТекущие.Количество() = 0 Тогда
		ВызватьИсключение НСтр("ru = 'Не определена страница для отображения.'");
	КонецЕсли;
	
	СтрокаПереходаТекущая = СтрокиПереходаТекущие[0];
	
	// Обработчик ОбработкаДлительнойОперации.
	Если Не ПустаяСтрока(СтрокаПереходаТекущая.ИмяОбработчикаДлительнойОперации) Тогда
		
		ИмяПроцедуры = "Подключаемый_[ИмяОбработчика](Отказ, ПерейтиДалее)";
		ИмяПроцедуры = СтрЗаменить(ИмяПроцедуры, "[ИмяОбработчика]", СтрокаПереходаТекущая.ИмяОбработчикаДлительнойОперации);
		
		Отказ = Ложь;
		ПерейтиДалее = Истина;
		
		//@skip-warning
		РезультатВычисления = Вычислить(ИмяПроцедуры);
		
		Если Отказ Тогда
			
			УстановитьПорядковыйНомерПерехода(ПорядковыйНомерПерехода - 1);
			
			Возврат;
			
		ИначеЕсли ПерейтиДалее Тогда
			
			УстановитьПорядковыйНомерПерехода(ПорядковыйНомерПерехода + 1);
			
			Возврат;
			
		КонецЕсли;
		
	Иначе
		
		УстановитьПорядковыйНомерПерехода(ПорядковыйНомерПерехода + 1);
		
		Возврат;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ДобавитьСтрокуТаблицыПереходов(ИмяОсновнойСтраницы, ИмяСтраницыНавигации, ИмяОбработчикаПриОткрытии = "", ИмяОбработчикаПриПереходеДалее = "")
	
	СтрокаПереходов = ТаблицаПереходов.Добавить();
	СтрокаПереходов.Видимость = Истина;
	СтрокаПереходов.ПорядковыйНомерПерехода = ТаблицаПереходов.Количество();
	СтрокаПереходов.ИмяОсновнойСтраницы = ИмяОсновнойСтраницы;
	СтрокаПереходов.ИмяСтраницыНавигации = ИмяСтраницыНавигации;
	СтрокаПереходов.ИмяОбработчикаПриОткрытии = ИмяОбработчикаПриОткрытии;
	СтрокаПереходов.ИмяОбработчикаПриПереходеДалее = ИмяОбработчикаПриПереходеДалее;
	
	Возврат СтрокаПереходов;
	
КонецФункции

#КонецОбласти

#Область ПереопределяемаяЧасть

#Область ОбработчикиСобытийПереходов

//@skip-warning
&НаКлиенте
Функция Подключаемый_СтраницаВыборВариантаНастройки_ПриОткрытии(Отказ, ПропуститьСтраницу, ЭтоПереходДалее)
	
	Если ПропуститьСтраницуВыборВариантаНастройки(ЭтаФорма) Тогда
		ПропуститьСтраницу = Истина;
	КонецЕсли;
	
	Возврат Неопределено;
	
КонецФункции

//@skip-warning
&НаКлиенте
Функция Подключаемый_СтраницаФормированияСоглашенияССотрудниками_ПриОткрытии(Отказ, ПропуститьСтраницу, ЭтоПереходДалее)
	
	Если Не ВидЭлектроннойПодписи = ПредопределенноеЗначение("Перечисление.ВидыЭлектронныхПодписей.Простая") Тогда
		ПропуститьСтраницу = Истина;
	КонецЕсли;
	
	Возврат Неопределено;
	
КонецФункции

//@skip-warning
&НаКлиенте
Функция Подключаемый_СтраницаУстановкаПрограммыКриптографии_ПриОткрытии(Отказ, ПропуститьСтраницу, ЭтоПереходДалее)
	
	Элементы.ПанельУстановкаПрограммыКриптографии.ТекущаяСтраница = Элементы.УстановкаПрограммыКриптографииОжидание;
	Если ВидЭлектроннойПодписи = ПредопределенноеЗначение("Перечисление.ВидыЭлектронныхПодписей.Простая")
		Или ВариантНастройки = "НастройкаПодписания" Тогда
		ПропуститьСтраницу = Истина;
	Иначе 
		ТекущееНаправлениеПереходаДалее = ЭтоПереходДалее;
		Элементы.ГруппаКнопокМастера.Доступность = Ложь;
		ПодключитьОбработчикОжидания("НайтиПрограммыКриптографии", 1, Истина);
	КонецЕсли;
	
	Возврат Неопределено;
	
КонецФункции

//@skip-warning
&НаКлиенте
Функция Подключаемый_СтраницаУстановкаСертификатов_ПриОткрытии(Отказ, ПропуститьСтраницу, ЭтоПереходДалее)
	
	Элементы.ПанельУстановкаСертификатов.ТекущаяСтраница = Элементы.УстановкаСертификатовПоиск;
	Если ВидЭлектроннойПодписи = ПредопределенноеЗначение("Перечисление.ВидыЭлектронныхПодписей.Простая")
		Или ВариантНастройки = "НастройкаПодписания" Тогда
		ПропуститьСтраницу = Истина;
	Иначе 
		ТекущееНаправлениеПереходаДалее = ЭтоПереходДалее;
		Элементы.ГруппаКнопокМастера.Доступность = Ложь;
		ПодключитьОбработчикОжидания("НайтиСертификатыКриптографии", 1, Истина);
	КонецЕсли;
	
	Возврат Неопределено;
	
КонецФункции

//@skip-warning
&НаКлиенте
Функция Подключаемый_УстановкаПрограммыКриптографии_ПриПереходеДалее(Отказ) 
	
	Если ТребуетсяНастройкаКриптографии(ЭтаФорма)
		И Не ПрограммаКриптографииУстановлена Тогда
		ТекстСообщения = НСтр("ru = 'Необходимо установить программу криптографии'");
		ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения,,,, Отказ);
	КонецЕсли;
	
	Возврат Неопределено;
	
КонецФункции 

//@skip-warning
&НаКлиенте
Функция Подключаемый_УстановкаСертификатов_ПриПереходеДалее(Отказ) 
	
	Если ТребуетсяНастройкаКриптографии(ЭтаФорма)
		И Не СертификатКриптографииУстановлен Тогда
		ТекстСообщения = НСтр("ru = 'Необходимо установить сертификат криптографии'");
		ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения,,,, Отказ);
	КонецЕсли;
	
	Возврат Неопределено;
	
КонецФункции

//@skip-warning
&НаКлиенте
Функция Подключаемый_НастройкаМаршрутаПодписания_ПриОткрытии(Отказ, ПропуститьСтраницу, ЭтоПереходДалее) 
	
	ОтборВидимость = Новый Структура;
	ОтборВидимость.Вставить("Видимость", Истина);
	ВидимыеСтрокиПерехода = ТаблицаПереходов.НайтиСтроки(ОтборВидимость);
	Если ВидимыеСтрокиПерехода.Количество() Тогда
		ПоследняяСтрока = ВидимыеСтрокиПерехода[ВидимыеСтрокиПерехода.ВГраница()];
		ОтборТекущаяСтрока = Новый Структура;
		ОтборТекущаяСтрока.Вставить("ИмяОсновнойСтраницы", "НастройкаМаршрутаПодписания");
		Строки = ТаблицаПереходов.НайтиСтроки(ОтборТекущаяСтрока);
		Если Строки.Количество() > 0 Тогда
			ТекущаяСтрока = Строки[0];
			Если ПоследняяСтрока.ИмяОсновнойСтраницы = "НастройкаМаршрутаПодписания" Тогда
				ТекущаяСтрока.ИмяСтраницыНавигации = "СтраницаНавигацииОкончание";
			Иначе 
				ПерваяСтрока = ВидимыеСтрокиПерехода[0];
				Если ПерваяСтрока.ИмяОсновнойСтраницы = "НастройкаМаршрутаПодписания" Тогда
					ТекущаяСтрока.ИмяСтраницыНавигации = "СтраницаНавигацииНачало";
				Иначе 
					ТекущаяСтрока.ИмяСтраницыНавигации = "СтраницаНавигацииПродолжение";
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
	Возврат Неопределено;
	
КонецФункции

//@skip-warning
&НаКлиенте
Функция Подключаемый_НастройкаМаршрутаПодписания_ПриПереходеДалее(Отказ) 
	
	ПроверитьЗаполнениеМаршрута(Отказ);
	
	Возврат Неопределено;
	
КонецФункции

#КонецОбласти

&НаСервере
Процедура ЗаполнитьТаблицуПереходов()
	
	ТаблицаПереходов.Очистить();
	
	Если Не ЕстьНастройка И Не ПропуститьШагВыбораВидаЭлектроннойПодписи Тогда
		ДобавитьСтрокуТаблицыПереходов("ВыборВидаЭлектроннойПодписи", "СтраницаНавигацииНачало");
	КонецЕсли;
	
	Если ПропуститьШагФормированияСоглашенийССотрудниками Тогда
		Элементы.СтраницаНавигацииОкончаниеНазад.Видимость = Ложь;
	Иначе
		ДобавитьСтрокуТаблицыПереходов("ФормированиеСоглашенийССотрудниками", "СтраницаНавигацииПродолжение",
			"СтраницаФормированияСоглашенияССотрудниками_ПриОткрытии");
	КонецЕсли;
	
	ДобавитьСтрокуТаблицыПереходов("ВыборВариантаНастройки",
		?(ТаблицаПереходов.Количество() = 0, "СтраницаНавигацииНачало", "СтраницаНавигацииПродолжение"),
		"СтраницаВыборВариантаНастройки_ПриОткрытии");
	
	ДобавитьСтрокуТаблицыПереходов("УстановкаПрограммыКриптографии",
		?(ТаблицаПереходов.Количество() = 0, "СтраницаНавигацииНачало", "СтраницаНавигацииПродолжение"),
		"СтраницаУстановкаПрограммыКриптографии_ПриОткрытии", "УстановкаПрограммыКриптографии_ПриПереходеДалее");
	
	ДобавитьСтрокуТаблицыПереходов("УстановкаСертификатов", "СтраницаНавигацииПродолжение", 
		"СтраницаУстановкаСертификатов_ПриОткрытии", "УстановкаСертификатов_ПриПереходеДалее");
	
	Если ЕстьВозможностьПодключенияОбсуждений Тогда
		ДобавитьСтрокуТаблицыПереходов("НастройкаМаршрутаПодписания", "СтраницаНавигацииПродолжение", "НастройкаМаршрутаПодписания_ПриОткрытии",
			"НастройкаМаршрутаПодписания_ПриПереходеДалее");
		ДобавитьСтрокуТаблицыПереходов("ПодключениеОбсуждений", "СтраницаНавигацииОкончание");
	Иначе
		ДобавитьСтрокуТаблицыПереходов("НастройкаМаршрутаПодписания", "СтраницаНавигацииОкончание", "НастройкаМаршрутаПодписания_ПриОткрытии",
			"НастройкаМаршрутаПодписания_ПриПереходеДалее");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Функция ОтборТаблицыПереходов(НомерПерехода) 
	
	Отбор = Новый Структура;
	Отбор.Вставить("ПорядковыйНомерПерехода", НомерПерехода);
	
	Возврат Отбор;
	
КонецФункции 

&НаКлиентеНаСервереБезКонтекста
Процедура СкрытьПоказатьСтрокиТаблицыПереходов(Форма, ИмяОсновнойСтраницы, Видимость) 
	
	Отбор = Новый Структура;
	Отбор.Вставить("ИмяОсновнойСтраницы", ИмяОсновнойСтраницы);
	СтрокиПерехода = Форма.ТаблицаПереходов.НайтиСтроки(Отбор);
	Для каждого СтрокаПерехода Из СтрокиПерехода Цикл
		СтрокаПерехода.Видимость = Видимость;
	КонецЦикла;
	
	Счетчик = 1;
	Для Каждого Строка Из Форма.ТаблицаПереходов Цикл
		Если Строка.Видимость Тогда
			Строка.ПорядковыйНомерПерехода = Счетчик;
			Если Строка.ПорядковыйНомерПерехода = 1 Тогда
				Строка.ИмяСтраницыНавигации = "СтраницаНавигацииНачало";
			КонецЕсли;
			
			Счетчик = Счетчик + 1;
		Иначе
			Строка.ПорядковыйНомерПерехода = 0;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область ПрограммыКриптографии

&НаКлиенте
Процедура НайтиПрограммыКриптографии() 
	
	Описание = Новый ОписаниеОповещения("ПослеПоискаПрограммКриптографии", ЭтотОбъект);
	ЭлектроннаяПодписьКлиент.НайтиУстановленныеПрограммы(Описание, Неопределено, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеПоискаПрограммКриптографии(Результат, Контекст) Экспорт
	
	Элементы.ГруппаКнопокМастера.Доступность = Истина;
	
	ПрограммаКриптографииУстановлена = Ложь;
	Если Не ЗначениеЗаполнено(Результат) Тогда
		Возврат;
	КонецЕсли;
	
	Для Каждого Программа Из Результат Цикл
		
		Если Программа.Установлена И ЗначениеЗаполнено(Программа.Ссылка) Тогда
			ПрограммаКриптографииУстановлена = Истина;
			Прервать; 
		КонецЕсли;
		
	КонецЦикла;
	
	Если ПрограммаКриптографииУстановлена Тогда
		ИзменитьПорядковыйНомерПерехода(?(ТекущееНаправлениеПереходаДалее, +1, -1));
	Иначе 
		Элементы.ПанельУстановкаПрограммыКриптографии.ТекущаяСтраница = Элементы.УстановкаПрограммыКриптографииУстановка;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПовторныйПоискПрограммКриптографии(Результат, ДополнительныеПараметры) Экспорт
	
	Если ЗначениеЗаполнено(Результат) И Результат.Выполнено Тогда
		Элементы.УстановитьVipNet.Доступность = Ложь;
		Элементы.УстановитьCryptoPRO.Доступность = Ложь;
	КонецЕсли;
	
	НайтиПрограммыКриптографии();
	
КонецПроцедуры

#КонецОбласти

#Область Сертификаты

&НаКлиенте
Процедура НайтиСертификатыКриптографии() 
	
	Если ВыполняетсяПоискСертификатов Тогда
		// Для защиты от повторного запуска процедуры.
		Возврат;
	КонецЕсли;
	
	ВыполняетсяПоискСертификатов = Истина;
	Элементы.ГруппаКнопокМастера.Доступность = Ложь;
	
	Оповещение = Новый ОписаниеОповещения("ПослеПолученияОтпечатковСертификатов", ЭтотОбъект);
	КриптографияБЭДКлиент.ПолучитьОтпечаткиСертификатов(Оповещение);
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеПолученияОтпечатковСертификатов(РезультатПолучения, ДополнительныеПараметры) Экспорт
	
	ДанныеОСертификатах = ПолучитьДанныеОСертификатах(Организация, РезультатПолучения);
	
	ВыполняетсяПоискСертификатов = Ложь;
	Элементы.ГруппаКнопокМастера.Доступность = Истина;
		
	Если ДанныеОСертификатах.ЕстьДоступныеСертификаты Тогда
		СертификатКриптографииУстановлен = Истина;
		ИзменитьПорядковыйНомерПерехода(?(ТекущееНаправлениеПереходаДалее, +1, -1));
	ИначеЕсли ДанныеОСертификатах.ОжидаетсяВыпускСертификата Тогда
		Элементы.ПанельУстановкаСертификатов.ТекущаяСтраница = Элементы.УстановкаСертификатовОжидание;
	Иначе
		Элементы.ПанельУстановкаСертификатов.ТекущаяСтраница = Элементы.УстановкаСертификатовДобавление;
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьДанныеОСертификатах(Организация, ОтпечаткиСертификатов)
	
	ВидОперации = НСтр("ru = 'Настройка внутреннего электронного документооборота: получение доступных сертификатов'");
	Отпечатки = КриптографияБЭД.ПолучитьОтпечаткиСертификатов(ВидОперации, Неопределено, ОтпечаткиСертификатов);
	
	Возврат КриптографияБЭД.ПользователюДоступенСертификатИлиЗаявлениеНаВыпуск(Организация, Отпечатки);
	
КонецФункции

&НаКлиенте
Процедура ПовторныйПоискСертификатов(Результат, ДополнительныеПараметры) Экспорт
	
	НайтиСертификатыКриптографии();
	
КонецПроцедуры

#КонецОбласти

&НаКлиентеНаСервереБезКонтекста
Процедура ОбновитьЗаголовокФормы(Форма) 
	
	ШаблонЗаголовка = НСтр("ru = 'Настройка электронного документооборота (шаг %1 из %2)'");
	Отбор = Новый Структура;
	Отбор.Вставить("Видимость", Истина);
	КоличествоВидимыхПереходов = Форма.ТаблицаПереходов.НайтиСтроки(Отбор).Количество();
	
	Отбор.Видимость = Ложь;
	КоличествоНевидимыхПереходов = 0;
	Для каждого СтрокаПерехода Из Форма.ТаблицаПереходов Цикл
		Если Не СтрокаПерехода.Видимость Тогда
			КоличествоНевидимыхПереходов = КоличествоНевидимыхПереходов + 1;
		КонецЕсли;
		Если СтрокаПерехода.ПорядковыйНомерПерехода = Форма.ПорядковыйНомерПерехода Тогда
			Прервать; 
		КонецЕсли;
	КонецЦикла; 
	Если Форма.ПорядковыйНомерПерехода > КоличествоВидимыхПереходов Тогда
		ТекущийШаг = Форма.ПорядковыйНомерПерехода - КоличествоНевидимыхПереходов;
	Иначе 
		ТекущийШаг = Форма.ПорядковыйНомерПерехода;
	КонецЕсли;
	
	Форма.Заголовок = СтрШаблон(ШаблонЗаголовка, ТекущийШаг, КоличествоВидимыхПереходов);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ПриИзмененииВидаЭлектроннойПодписиВариантаНастройки(Форма) 
	
	СкрытьПоказатьСтрокиТаблицыПереходов(Форма, "ВыборВариантаНастройки",
		Не ПропуститьСтраницуВыборВариантаНастройки(Форма));
	СкрытьПоказатьСтрокиТаблицыПереходов(Форма, "УстановкаПрограммыКриптографии",
		ТребуетсяНастройкаКриптографии(Форма));
	СкрытьПоказатьСтрокиТаблицыПереходов(Форма, "УстановкаСертификатов",
		ТребуетсяНастройкаКриптографии(Форма));
	СкрытьПоказатьСтрокиТаблицыПереходов(Форма, "ФормированиеСоглашенийССотрудниками",
		Форма.ВидЭлектроннойПодписи = ПредопределенноеЗначение("Перечисление.ВидыЭлектронныхПодписей.Простая"));
	ОбновитьЗаголовокФормы(Форма);
	
	Форма.МаршрутПодписания = ПредопределенноеЗначение("Справочник.МаршрутыПодписания.ПустаяСсылка");
		
	Форма.Элементы.ГруппаВариантНастройки.Видимость = 
		Форма.ВидЭлектроннойПодписи = ПредопределенноеЗначение("Перечисление.ВидыЭлектронныхПодписей.УсиленнаяКвалифицированная");
	
КонецПроцедуры

&НаСервере
Процедура СоздатьНастройку() 
	
	Если СпособНастройкиМаршрута = "СписокПодписантов" Тогда
		МаршрутПодписания = Справочники.МаршрутыПодписания.УказыватьПриСоздании;
	КонецЕсли;
	
	ЭлементСпискаЗначений = Элементы.ПечатнаяФорма.СписокВыбора.НайтиПоЗначению(ПечатнаяФорма);
	КомандаПечати = Новый Структура;
	КомандаПечати.Вставить("Идентификатор", ЭлементСпискаЗначений.Значение);
	КомандаПечати.Вставить("Представление", ЭлементСпискаЗначений.Представление);
	
	ТаблицаНастроек = НастройкиВнутреннегоЭДОСлужебный.НоваяТаблицаНастроекВнутреннегоЭДО();
	Настройка = ТаблицаНастроек.Добавить();
	Настройка.Организация = Организация;
	Настройка.ВидПодписи = ВидЭлектроннойПодписи;
	Настройка.МаршрутПодписания = МаршрутПодписания;
	Настройка.ЭтоОсновнойВидДокумента = ИспользоватьПечатнуюФормуПоУмолчанию;
	Настройка.ИдентификаторОбъектаУчета = ИдентификаторОбъектаУчета;
	Настройка.КомандаПечати = КомандаПечати;
	НоваяНастройка = НастройкиВнутреннегоЭДОСлужебный.ДобавитьНастройкуВнутреннегоЭДО(Настройка);
	Если ЗначениеЗаполнено(НоваяНастройка.ВидВнутреннегоДокумента) Тогда
		ВидВнутреннегоДокумента = НоваяНастройка.ВидВнутреннегоДокумента;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция ТребуетсяНастройкаКриптографии(Форма) 
	
	Возврат Форма.ВидЭлектроннойПодписи = ПредопределенноеЗначение("Перечисление.ВидыЭлектронныхПодписей.УсиленнаяКвалифицированная")
		И Форма.ВариантНастройки = "Подписание";
	
КонецФункции 

&НаКлиентеНаСервереБезКонтекста
Функция ПропуститьСтраницуВыборВариантаНастройки(Форма) 
		
	Возврат Форма.КоличествоКомандПечати = 1 И Форма.ВидЭлектроннойПодписи = ПредопределенноеЗначение("Перечисление.ВидыЭлектронныхПодписей.Простая");
	
КонецФункции 

&НаКлиентеНаСервереБезКонтекста
Процедура ПриИзмененииСпособаНастройкиМаршрута(Форма) 
	
	Форма.Элементы.ГруппаНастройкаМаршрутаПодписанияМаршрутПодписания.Доступность = Форма.СпособНастройкиМаршрута = "МаршрутПодписания";
	
КонецПроцедуры

&НаСервере
Процедура ЗавершитьНастройкуНаСервере() 
	
	СоздатьНастройку();
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ОбновитьЗаголовокФлагаИспользоватьПечатнуюФормуПоУмолчанию(Форма) 
	
	ШаблонЗаголовка = НСтр("ru = 'Использовать форму ""%1"" по умолчанию'");
	ЭлементСпискаЗначений = Форма.Элементы.ПечатнаяФорма.СписокВыбора.НайтиПоЗначению(Форма.ПечатнаяФорма);
	Если ЭлементСпискаЗначений <> Неопределено Тогда
		ПредставлениеПечатнойФормы = ЭлементСпискаЗначений.Представление;
	Иначе 
		ПредставлениеПечатнойФормы = "";
	КонецЕсли;
	Форма.Элементы.ИспользоватьПечатнуюФормуПоУмолчанию.Заголовок = СтрШаблон(ШаблонЗаголовка, ПредставлениеПечатнойФормы);
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьОтображениеПредупрежденияПаденияПроизводительности()
	
	Элементы.ПредупреждениеВозможногоПаденияПроизводительности.Видимость = ПорядковыйНомерПерехода = 0
		И Не НастройкиЭДО.ЕстьНастройкиВнутреннегоЭДО();

КонецПроцедуры

&НаСервере
Функция НастройкаВнутреннегоЭДО(ВидВнутреннегоДокумента) 
	
	Возврат НастройкиВнутреннегоЭДОСлужебный.НастройкаВнутреннегоЭДО(Организация, ВидВнутреннегоДокумента);
	
КонецФункции 

&НаКлиенте
Процедура ПодключитьОбсужденияЗавершение(ОбсужденияПодключены, ДополнительныеПараметры) Экспорт
	
	Если ОбсужденияПодключены Тогда
		Элементы.ПанельПодключенияОбсуждений.ТекущаяСтраница = Элементы.ПодключениеОбсужденийВыполнено;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Функция ПроверитьЗаполнениеМаршрута(Отказ)
	
	Результат = Истина;
	
	Если СпособНастройкиМаршрута = "МаршрутПодписания" И Не ЗначениеЗаполнено(МаршрутПодписания) Тогда
		ТекстСообщения = НСтр("ru = 'Необходимо указать маршрут подписания'");
		ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения,, "МаршрутПодписания",, Отказ);
		Результат = Ложь;
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти
