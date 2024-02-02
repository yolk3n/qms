﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

////////////////////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС
#Область ПрограммныйИнтерфейс

// Процедура сообщает пользователю об ошибках проведения по регистру ЗаказыПоставщикам
//
// Параметры
//	Объект - проводимый документ
//	Отказ - признак отказа от проведения документа
//	РезультатЗапроса - информация об ошибках проведения по регистру
//
Процедура СообщитьОбОшибкахПроведения(Объект, Отказ, РезультатЗапроса) Экспорт
	
	ШаблонСообщения = НСтр("ru = 'Номенклатура %Номенклатура% - отрицательный остаток.
		|По строке %КодСтроки% оформлено больше, чем указано в распоряжении на оформление, на %Количество% %Единица%'");
	
	Выборка = РезультатЗапроса.Выбрать();
	Пока Выборка.Следующий() Цикл
		
		ТекстСообщения = СтрЗаменить(ШаблонСообщения, "%Номенклатура%", Выборка.Номенклатура);
		Если ЗначениеЗаполнено(Выборка.ЕдиницаИзмерения) Тогда
			ЕдиницаИзмерения = Выборка.ЕдиницаИзмерения;
			Коэффициент = ?(Выборка.Коэффициент = 0, 1, Выборка.Коэффициент);
		Иначе
			ЕдиницаИзмерения = НоменклатураСервер.ОсновнаяЕдиницаИзмерения(Выборка.Номенклатура, НоменклатураКлиентСервер.ВидЕдиницы_ПотребительскаяУпаковка());
			Коэффициент = НоменклатураСервер.КоэффициентЕдиницыИзмерения(Выборка.Номенклатура, ЕдиницаИзмерения, 1);
		КонецЕсли;
		Количество = ?(Выборка.ПоСпецификации = 0, Выборка.КОформлению, Выборка.ПоСпецификации) / Коэффициент;
		КодСтроки = ?(Выборка.ПоСпецификации = 0, Выборка.КодСтроки, Выборка.КодСтрокиСпецификации);
		ТекстСообщения = СтрЗаменить(ТекстСообщения, "%Количество%", Строка(-Количество));
		ТекстСообщения = СтрЗаменить(ТекстСообщения, "%КодСтроки%",  Строка(КодСтроки));
		ТекстСообщения = СтрЗаменить(ТекстСообщения, "%Единица%",    Строка(ЕдиницаИзмерения));
		
		ОбщегоНазначения.СообщитьПользователю(ТекстСообщения, Объект,,, Отказ);
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти // ПрограммныйИнтерфейс

#КонецЕсли