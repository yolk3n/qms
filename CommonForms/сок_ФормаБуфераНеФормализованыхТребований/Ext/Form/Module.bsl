﻿&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Элементы.Список.ОбновлениеПриИзмененииДанных=ОбновлениеПриИзмененииДанных.Авто;
КонецПроцедуры



&НаСервере
Процедура ИзменитьПолеРегистраНаСервере(КлючЗаписи,Имяполя,Значение)
	
	Если НЕ Метаданные.РегистрыСведений.сок_БуферНеформальныхТребований.Измерения.Найти(Имяполя)=Неопределено
		 ИЛИ НЕ Метаданные.РегистрыСведений.сок_БуферНеформальныхТребований.Ресурсы.Найти(Имяполя)=Неопределено 
		 ИЛИ НЕ Метаданные.РегистрыСведений.сок_БуферНеформальныхТребований.Реквизиты.Найти(Имяполя)=Неопределено Тогда
		 
		НачатьТранзакцию();
		
		Рег = РегистрыСведений.сок_БуферНеформальныхТребований.СоздатьМенеджерЗаписи();
		ЗаполнитьЗначенияСвойств(Рег,КлючЗаписи);
		Рег.Прочитать();
		Рег[ИмяПоля]=Значение;
		Если ИмяПоля="Пометка" И Значение=Истина Тогда
			Рег.Менеджер=Параметрысеанса.ТекущийПользователь;
		КонецЕсли;	
		
		Рег.Записать(Истина);
		Если ИмяПоля="Номенклатура" Тогда
			Элемент = Рег.Требование.ПолучитьОбъект();
			СтрН=Элемент.Товары.Найти(Рег.ИдентификаторСтроки,"ИдентификаторСтроки");
			СтрН.Номенклатура=Значение;
			Элемент.ОбменДанными.Загрузка=Истина;
			Элемент.Записать();
			РегТ = РегистрыСведений.СостоянияТребованийОтделений.СоздатьНаборЗаписей();
			РегТ.Отбор.ИдентификаторСтроки.Установить(Рег.ИдентификаторСтроки);
			РегТ.Прочитать();
			РегТ[0].Номенклатура=Значение;
			РегТ.Записать(Истина);
		КонецЕсли;	
		
		ЗафиксироватьТранзакцию();
	КонецЕсли;	 
	
КонецПроцедуры	
&НаКлиенте
Процедура ИзменитьПолеОднимНажатием(КлючЗаписи,ИмяПоля,Значение)
	ИзменитьПолеРегистраНаСервере(КлючЗаписи,ИмяПоля,Значение);
КонецПроцедуры

&НаСервереБезКонтекста
Процедура ОбновитьСписокБезКонтекста(Форма)
	ТС = Форма.Элементы.Список.ТекущаяСтрока;
	Форма.Элементы.Список.Обновить();
	Форма.Элементы.Список.ТекущаяСтрока=ТС;
КонецПроцедуры	

&НаСервере
Процедура ОбновитьСписокНаСервере()
	ОбновитьСписокБезКонтекста(Этаформа);
КонецПроцедуры	



&НаКлиенте
Процедура СписокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	Если Поле.Имя="СписокПометка" Тогда
		ИзменитьПолеОднимНажатием(Элементы.Список.ТекущаяСтрока,"Пометка",НЕ Элементы.Список.ТекущиеДанные.Пометка);
		ОбновитьСписокНаСервере();
	ИначеЕсли Поле.Имя="СписокНоменклатура" Тогда
		ОписаниеОповещенияОЗакрытии=Новый ОписаниеОповещения("ВыборНоменклатурыЗавершение",Этаформа,Новый структура("КлючЗаписи",Элементы.Список.ТекущаяСтрока));
		Открытьформу("Справочник.Номенклатура.ФормаВыбора",Новый структура("ТекущаяСтрока",Элементы.Список.ТекущиеДанные.Номенклатура),Этаформа,,,,ОписаниеОповещенияОЗакрытии);
	ИначеЕсли Поле.Имя="СписокМенеджер" Тогда			
		ОписаниеОповещенияОЗакрытии=Новый ОписаниеОповещения("ВыборМенеджераЗавершение",Этаформа,Новый структура("КлючЗаписи",Элементы.Список.ТекущаяСтрока));
		Открытьформу("Справочник.Пользователи.ФормаВыбора",Новый структура("ТекущаяСтрока",Элементы.Список.ТекущиеДанные.Номенклатура),Этаформа,,,,ОписаниеОповещенияОЗакрытии);
	Иначе
		Открытьформу("Документ.сок_НеФормализованноеТребованиеОтделения.ФормаОбъекта",Новый структура("Ключ",Элементы.Список.ТекущиеДанные.Требование),Этаформа);
	КонецЕсли;	
КонецПроцедуры

&НаКлиенте
Процедура ВыборНоменклатурыЗавершение(Рез,Парам) Экспорт
	Если НЕ Рез = Неопределено Тогда
		 ИзменитьПолеРегистраНаСервере(Парам.КлючЗаписи,"Номенклатура",Рез);
		 ТС = Элементы.Список.ТекущаяСтрока;
		 ОбновитьСписокНаСервере();
		 Элементы.Список.ТекущаяСтрока=ТС;
	КонецЕсли;	
КонецПроцедуры

&НаСервере
Функция ПолучитьТекстСообщенияМенеджеру(КлючЗаписи)
	
	
	Рег = РегистрыСведений.сок_БуферНеформальныхТребований.СоздатьМенеджерЗаписи();
	ЗаполнитьЗначенияСвойств(Рег,КлючЗаписи);
	Рег.Прочитать();
	
	ТекстСоощения="Вам назначена позиция в буфере неформализованых требований. "+Рег.НоменклатураЗаказа+" требование "+Рег.Требование+" Ссылка на документ: "+ПолучитьНавигационнуюСсылку(Рег.Требование);
	Возврат ТекстСоощения;
КонецФункции	

&НаКлиенте
Процедура ВыборМенеджераЗавершение(Рез,Парам) Экспорт
	Если НЕ Рез = Неопределено Тогда
		 ИзменитьПолеРегистраНаСервере(Парам.КлючЗаписи,"Менеджер",Рез);
		 ТС = Элементы.Список.ТекущаяСтрока;
		 ОбновитьСписокНаСервере();
		 Элементы.Список.ТекущаяСтрока=ТС;
		 
		 сок_Сервер.ОтправитьОповещениеПоПочте(Рез,ПолучитьТекстСообщенияМенеджеру(Парам.КлючЗаписи));
	КонецЕсли;	
КонецПроцедуры



&НаКлиенте
Процедура СписокПередНачаломИзменения(Элемент, Отказ)
	Отказ=Истина;
КонецПроцедуры


&НаКлиенте
Процедура СписокПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	Отказ=Истина;
КонецПроцедуры


&НаКлиенте
Процедура СписокПередУдалением(Элемент, Отказ)
	//Вернуть отказ
//	Отказ=Истина;
КонецПроцедуры

&НаСервере
Процедура ПометкаУстановитьНаСервере(Значение)
	
	Для Каждого Стр Из Элементы.Список.ВыделенныеСтроки Цикл
		
		Запрос=Новый Запрос;
		Запрос.Текст="ВЫБРАТЬ
		             |	сок_БуферДляЗакупки.НоменклатураЗаказа КАК НоменклатураЗаказа,
		             |	сок_БуферДляЗакупки.Номенклатура КАК Номенклатура,
		             |	сок_БуферДляЗакупки.ДатаЗаказа КАК ДатаЗаказа,
		             |	сок_БуферДляЗакупки.Требование КАК Требование,
		             |	сок_БуферДляЗакупки.ИдентификаторСтроки КАК ИдентификаторСтроки,
		             |	сок_БуферДляЗакупки.КодСтроки КАК КодСтроки,
		             |	сок_БуферДляЗакупки.Количество КАК Количество,
		             |	сок_БуферДляЗакупки.Пометка КАК Пометка,
		             |	сок_БуферДляЗакупки.Менеджер КАК Менеджер,
		             |	сок_БуферДляЗакупки.Поставщик КАК Поставщик,
		             |	сок_БуферДляЗакупки.ЦенаЗакупки КАК ЦенаЗакупки
		             |ИЗ
		             |	РегистрСведений.сок_БуферДляЗакупки КАК сок_БуферДляЗакупки
		             |ГДЕ
		             |	сок_БуферДляЗакупки.ИдентификаторСтроки = &ИдентификаторСтроки
		             |	И сок_БуферДляЗакупки.КодСтроки = &КодСтроки";
		Запрос.УстановитьПараметр("ИдентификаторСтроки",Стр.ИдентификаторСтроки);
		Запрос.УстановитьПараметр("КодСтроки",Стр.КодСтроки);
		
		Выборка=Запрос.Выполнить().Выбрать();
		Если Выборка.Следующий() Тогда
			МенеджерЗаписи=РегистрыСведений.сок_БуферДляЗакупки.СоздатьМенеджерЗаписи();
			ЗаполнитьЗначенияСвойств(МенеджерЗаписи,Выборка);
			МенеджерЗаписи.Прочитать();
			МенеджерЗаписи.Удалить();
			
			МенеджерЗаписи=РегистрыСведений.сок_БуферДляЗакупки.СоздатьМенеджерЗаписи();
			ЗаполнитьЗначенияСвойств(МенеджерЗаписи,Выборка);
			МенеджерЗаписи.Пометка=Значение;
			Если Значение=Истина Тогда
				МенеджерЗаписи.Менеджер=ПараметрыСеанса.ТекущийПользователь;
			КонецЕсли;	
			МенеджерЗаписи.Записать(Истина);
			
		КонецЕсли;
		
	КонецЦикла;
	
	Элементы.Список.Обновить();
	
КонецПроцедуры

&НаСервере
Процедура ПометкаСнятьНаСервере()
	
	Для Каждого Стр Из Элементы.Список.ВыделенныеСтроки Цикл
		
		Запрос=Новый Запрос;
		Запрос.Текст="ВЫБРАТЬ
		             |	сок_БуферДляЗакупки.НоменклатураЗаказа КАК НоменклатураЗаказа,
		             |	сок_БуферДляЗакупки.Номенклатура КАК Номенклатура,
		             |	сок_БуферДляЗакупки.ДатаЗаказа КАК ДатаЗаказа,
		             |	сок_БуферДляЗакупки.Требование КАК Требование,
		             |	сок_БуферДляЗакупки.ИдентификаторСтроки КАК ИдентификаторСтроки,
		             |	сок_БуферДляЗакупки.КодСтроки КАК КодСтроки,
		             |	сок_БуферДляЗакупки.Количество КАК Количество,
		             |	сок_БуферДляЗакупки.Пометка КАК Пометка,
		             |	сок_БуферДляЗакупки.Менеджер КАК Менеджер,
		             |	сок_БуферДляЗакупки.Поставщик КАК Поставщик,
		             |	сок_БуферДляЗакупки.ЦенаЗакупки КАК ЦенаЗакупки
		             |ИЗ
		             |	РегистрСведений.сок_БуферДляЗакупки КАК сок_БуферДляЗакупки
		             |ГДЕ
		             |	сок_БуферДляЗакупки.ИдентификаторСтроки = &ИдентификаторСтроки
		             |	И сок_БуферДляЗакупки.КодСтроки = &КодСтроки";
		Запрос.УстановитьПараметр("ИдентификаторСтроки",Стр.ИдентификаторСтроки);
		Запрос.УстановитьПараметр("КодСтроки",Стр.КодСтроки);
		
		Выборка=Запрос.Выполнить().Выбрать();
		Если Выборка.Следующий() Тогда
			МенеджерЗаписи=РегистрыСведений.сок_БуферДляЗакупки.СоздатьМенеджерЗаписи();
			ЗаполнитьЗначенияСвойств(МенеджерЗаписи,Выборка);
			МенеджерЗаписи.Прочитать();
			МенеджерЗаписи.Удалить();
			
			МенеджерЗаписи=РегистрыСведений.сок_БуферДляЗакупки.СоздатьМенеджерЗаписи();
			ЗаполнитьЗначенияСвойств(МенеджерЗаписи,Выборка);
			МенеджерЗаписи.Пометка=Ложь;
			МенеджерЗаписи.Записать(Истина);
		КонецЕсли;
		
	КонецЦикла;
	
	Элементы.Список.Обновить();
	
КонецПроцедуры

&НаКлиенте
Процедура ПометкаСнять(Команда)
	
	ПометкаУстановитьНаСервере(Ложь);
	
КонецПроцедуры

&НаКлиенте
Процедура ПометкаУстановить(Команда)
	
	ПометкаУстановитьНаСервере(Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаменитьНоменклатуру(Команда)
	ОписаниеОповещения=Новый ОписаниеОповещения("ПослеВыбораНоменклатуры",ЭтотОбъект);
	ОткрытьФорму("Справочник.Номенклатура.ФормаВыбора",,,,,,ОписаниеОповещения,РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
КонецПроцедуры

&НаКлиенте
Процедура ПослеВыбораНоменклатуры(Результат, ДопПараметры) Экспорт
	
	Если Результат=Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ЗаменитьНоменклатуруНаСервере(Результат);
	
КонецПроцедуры

&НаСервере
Процедура ЗаменитьНоменклатуруНаСервере(Номенклатура)
	
	Для Каждого Стр Из Элементы.Список.ВыделенныеСтроки Цикл
			ИзменитьПолеРегистраНаСервере(Стр,"Номенклатура",Номенклатура);			
	КонецЦикла;
	
	Элементы.Список.Обновить();
	
КонецПроцедуры

&НаСервере
Функция ИдентификаторыВеделеныхСтрокСовпадают()
	
	УИД=Элементы.Список.ВыделенныеСтроки[0].ИдентификаторСтроки;
	
	Для Каждого Стр Из Элементы.Список.ВыделенныеСтроки Цикл
		Если НЕ Стр.ИдентификаторСтроки=УИД Тогда
			Возврат Ложь;
		КонецЕсли;
	КонецЦикла;
	
	Возврат Истина;
	
КонецФункции

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	Если ИмяСобытия="ТребуетсяПерерисоватьБуферНеформальныхТребований"	Тогда
		Элементы.Список.Обновить();
	КонецЕсли;	
КонецПроцедуры


&НаСервере
Процедура УстановитьМенеджераНаСервере(Результат)
	Для Каждого Стр Из Элементы.Список.ВыделенныеСтроки Цикл
		ИзменитьПолеРегистраНаСервере(Стр,"Менеджер",Результат);			
	КонецЦикла;
КонецПроцедуры


&НаКлиенте
Процедура УстановитьМенеджера(Команда)
	ОписаниеОповещения=Новый ОписаниеОповещения("УстановитьМенеджераЗавершение",ЭтотОбъект);
	ОткрытьФорму("Справочник.Пользователи.ФормаВыбора",,,,,,ОписаниеОповещения,РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
КонецПроцедуры

&НаКлиенте
Процедура УстановитьМенеджераЗавершение(Результат,Параметры) Экспорт
	Если НЕ Результат = Неопределено Тогда
		УстановитьМенеджераНаСервере(Результат);
	КонецЕсли;
КонецПроцедуры



&НаСервере
Процедура ПоместитьВСтатусОтменаНаСервере(Описание)
	
	НачатьТранзакцию();
	
	Для Каждого Стр Из Элементы.Список.ВыделенныеСтроки Цикл
		Рег = РегистрыСведений.СостоянияТребованийОтделений.СоздатьМенеджерЗаписи();
		ЗаполнитьЗначенияСвойств(Рег,Стр);
		Рег.Прочитать();
		Рег.Описание=Описание;
		Рег.Состояние=Перечисления.СостоянияТребований.Отменено;
		Рег.Записать(Истина);
		Элемент = Рег.Требование.ПолучитьОбъект();
		СтрН=Элемент.Товары.Найти(Рег.ИдентификаторСтроки,"ИдентификаторСтроки");
		СтрН.Отменено=Истина;
		СтрН.ПричинаОтмены=Описание;
		Элемент.ОбменДанными.Загрузка=Истина;
		Элемент.Записать();
		
		
		
		РегБ = РегистрыСведений.сок_БуферНеформальныхТребований.СоздатьМенеджерЗаписи();
		ЗаполнитьЗначенияСвойств(РегБ,Стр);
		РегБ.Прочитать();
		РегБ.Удалить();
	КонецЦикла;
	
	ЗафиксироватьТранзакцию();
	
КонецПроцедуры

&НаКлиенте
Процедура ПоместитьВСтатусОтмена(Команда)
	
	ОписаниеОповещения=Новый ОписаниеОповещения("ПослеВводаОписанияДляПометкиВСтатусУдаление",ЭтотОбъект);
	ПоказатьВводСтроки(ОписаниеОповещения,,"Установите описание",,Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеВводаОписанияДляПометкиВСтатусУдаление(Результат,ДопПараметры) Экспорт
	
	Если Результат=Неопределено ИЛИ ПустаяСтрока(Результат) Тогда
		Возврат;
	КонецЕсли;
	
	ПоместитьВСтатусОтменаНаСервере(Результат);
	
	Элементы.Список.Обновить();
	
КонецПроцедуры

&НаСервере
Процедура ВЗакупкуНаСервере()
	НачатьТранзакцию();        
	Запрос = новый Запрос;
	Запрос.Текст=
	"ВЫБРАТЬ
	|	сок_БуферНеформальныхТребований.НоменклатураЗаказа КАК НоменклатураЗаказа,
	|	сок_БуферНеформальныхТребований.Номенклатура КАК Номенклатура,
	|	сок_БуферНеформальныхТребований.Требование КАК Требование,
	|	сок_БуферНеформальныхТребований.ИдентификаторСтроки КАК ИдентификаторСтроки,
	|	сок_БуферНеформальныхТребований.КодСтроки КАК КодСтроки,
	|	сок_БуферНеформальныхТребований.Количество КАК Количество,
	|	сок_БуферНеформальныхТребований.Менеджер КАК Менеджер,
	|	сок_БуферНеформальныхТребований.Коммментарий КАК Коммментарий,
	|	сок_БуферНеформальныхТребований.ДатаЗаказа КАК ДатаЗаказа,
	|	сок_БуферНеформальныхТребований.Пометка КАК Пометка
	|ИЗ
	|	РегистрСведений.сок_БуферНеформальныхТребований КАК сок_БуферНеформальныхТребований
	|ГДЕ
	|	сок_БуферНеформальныхТребований.Пометка";
	Выборка = Запрос.Выполнить().Выгрузить();
	Для Каждого Стр из Выборка Цикл
		
			Рег = РегистрыСведений.СостоянияТребованийОтделений.СоздатьМенеджерЗаписи();
			ЗаполнитьЗначенияСвойств(Рег,Стр);
			Рег.Прочитать();
			Рег.Состояние=Перечисления.СостоянияТребований.ВЗакупке;
			Рег.Записать(Истина);
			
			РегБЗ=РегистрыСведений.сок_БуферДляЗакупки.СоздатьМенеджерЗаписи();
			ЗаполнитьЗначенияСвойств(РегБЗ,Стр);
			РегБЗ.Записать(Истина);
			
			
			РегБ = РегистрыСведений.сок_БуферНеформальныхТребований.СоздатьМенеджерЗаписи();
			ЗаполнитьЗначенияСвойств(РегБ,Стр);
			РегБ.Прочитать();
			РегБ.Удалить();
		
	КонецЦикла;	
	ЗафиксироватьТранзакцию();
КонецПроцедуры

&НаКлиенте
Процедура ВЗакупку(Команда)
	ВЗакупкуНаСервере();
	Элементы.Список.Обновить();
КонецПроцедуры





         











