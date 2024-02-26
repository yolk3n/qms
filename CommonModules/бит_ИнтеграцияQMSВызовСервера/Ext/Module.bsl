﻿// Процедура - Записать в журнал регистрации
//
// Параметры:
//  СтруктураСообщения	 - Структура:
//	           * ИмяСобытия  - Строка - "Интеграция QMS".
//             * ПредставлениеУровня  - Строка - "Информация"
//                                       Доступные значения: "Информация", "Ошибка", "Предупреждение", "Примечание".
//             * Комментарий - Строка - комментарий события.
//             * ДатаСобытия - Дата   - текущая дата сеанса
Процедура ЗаписатьВЖурналРегистрации(СтруктураСообщения) Экспорт

	СобытияЖурнала = Новый СписокЗначений;
	СобытияЖурнала.Добавить(СтруктураСообщения);
	ЖурналРегистрации.ЗаписатьСобытияВЖурналРегистрации(СобытияЖурнала);
	
КонецПроцедуры 

Функция НоваяСтруктураСообщенияЖурнала() Экспорт 
	
	СтруктураСообщения = Новый Структура;
	СтруктураСообщения.Вставить("ИмяСобытия", "Интеграция QMS");
	СтруктураСообщения.Вставить("ПредставлениеУровня", "Информация");
	СтруктураСообщения.Вставить("Комментарий", Неопределено);
	СтруктураСообщения.Вставить("ДатаСобытия", ТекущаяДатаСеанса());	
	Возврат СтруктураСообщения; 	

КонецФункции

Функция ПолучитьXMLДляCreateUpdateProductWMHS(Номенклатура) Экспорт 
	
	ЗаписьXML = Новый ЗаписьXML();
    ЗаписьXML.УстановитьСтроку();
	
	ТипEnvelope = ФабрикаXDTO.Тип("http://schemas.xmlsoap.org/soap/envelope/", "Envelope"); 
	ТипBody = ТипEnvelope.Свойства.Получить("Body").Тип;
	ТипCreateUpdateProductWMHS = ТипBody.Свойства.Получить("CreateUpdateProductWMHS").Тип;
	ТипProduct = ТипCreateUpdateProductWMHS.Свойства.Получить("Product").Тип;
	
	НоменклатураXDTO = ФабрикаXDTO.Создать(ТипProduct);
	
	НоменклатураРЛС = Номенклатура.ЭлементКАТ;
	
	НоменклатураXDTO.BarcodeMain = НоменклатураРЛС.Штрихкоды[0].Штрихкод;
	НоменклатураXDTO.Category = НоменклатураРЛС.АТХ.Наименование;
	НоменклатураXDTO.ESKLP = НоменклатураРЛС.АТХ.КодЕСКЛП;
	НоменклатураXDTO.Name = НоменклатураРЛС.Наименование;
	Если НоменклатураРЛС.ГруппаПКУ.Наименование = "Лекарственные препараты неподлежащие ПКУ" Тогда 
		НоменклатураXDTO.PKU = 0;
	Иначе
		НоменклатураXDTO.PKU = 1;
	КонецЕсли;
	НоменклатураXDTO.ProductCode = НоменклатураРЛС.Код;
	НоменклатураXDTO.ProductGroup = 244;
	НоменклатураXDTO.RLS = НоменклатураРЛС.НомерРЛС;
	НоменклатураXDTO.Ration = НоменклатураРЛС.Упаковка.Коэффициент;
	НоменклатураXDTO.SubCategory = "SubCategory";
	НоменклатураXDTO.UnitCodeMax = НоменклатураРЛС.Упаковка.Наименование;
	НоменклатураXDTO.UnitCodeMin = НоменклатураРЛС.Упаковка.БазоваяЕдиницаИзмерения.Наименование;
	
	ОбъектXDTOCreateUpdateProductWMHS = ФабрикаXDTO.Создать(ТипCreateUpdateProductWMHS);
	
	ОбъектXDTOCreateUpdateProductWMHS.Product = НоменклатураXDTO;
	ОбъектXDTOCreateUpdateProductWMHS.RequestName = "";
	ОбъектXDTOCreateUpdateProductWMHS.pIDo = "Хадасса"; 
	
	ОбъектBodyXDTO = ФабрикаXDTO.Создать(ТипBody); 
	ОбъектBodyXDTO.CreateUpdateProductWMHS = ОбъектXDTOCreateUpdateProductWMHS;
	 
	ОбъектEnvelopeXDTO = ФабрикаXDTO.Создать(ТипEnvelope);
	ОбъектEnvelopeXDTO.Body.Добавить(ОбъектBodyXDTO);
	
	ФабрикаXDTO.ЗаписатьXML(ЗаписьXML, ОбъектEnvelopeXDTO);
	ДанныеXML = ЗаписьXML.Закрыть();
	
	Возврат ДанныеXML;
	
КонецФункции

Функция ПолучитьXMLДляVerifyChangeUnitRatioWMHS(НоменклатураВладельца) Экспорт
	
	ЗаписьXML = Новый ЗаписьXML();
    ЗаписьXML.УстановитьСтроку();
	
	ТипEnvelope = ФабрикаXDTO.Тип("http://schemas.xmlsoap.org/soap/envelope/", "Envelope"); 
	ТипBody = ТипEnvelope.Свойства.Получить("Body").Тип;
	ТипVerifyChangeUnitRatioWMHS = ТипBody.Свойства.Получить("VerifyChangeUnitRatioWMHS").Тип;
	
	ПроверкаУпаковкиXDTO = ФабрикаXDTO.Создать(ТипVerifyChangeUnitRatioWMHS); 
	
	ПроверкаУпаковкиXDTO.pIDo = "Хадасса";
	ПроверкаУпаковкиXDTO.ProductCode = НоменклатураВладельца.ЭлементКАТ.Код;
	ПроверкаУпаковкиXDTO.RequestName = "";  
	
	ОбъектBodyXDTO = ФабрикаXDTO.Создать(ТипBody); 
	ОбъектBodyXDTO.VerifyChangeUnitRatioWMHS = ПроверкаУпаковкиXDTO;
	 
	ОбъектEnvelopeXDTO = ФабрикаXDTO.Создать(ТипEnvelope);
	ОбъектEnvelopeXDTO.Body.Добавить(ОбъектBodyXDTO);
	
	ФабрикаXDTO.ЗаписатьXML(ЗаписьXML, ОбъектEnvelopeXDTO);
	ДанныеXML = ЗаписьXML.Закрыть();
	
	Возврат ДанныеXML;
	
КонецФункции 

Функция ПолучитьXMLДляCreatePresenceAPTOSTWMHS(НоменклатураВладельца) Экспорт
	
	ЗаписьXML = Новый ЗаписьXML();
    ЗаписьXML.УстановитьСтроку();
	
	ТипEnvelope = ФабрикаXDTO.Тип("http://schemas.xmlsoap.org/soap/envelope/", "Envelope"); 
	ТипBody = ТипEnvelope.Свойства.Получить("Body").Тип;
	ТипCreatePresenceAPTOSTWMHS = ТипBody.Свойства.Получить("pCreatePresenceAPTOSTWMHS").Тип;
	
	ОстаткиXDTO = ФабрикаXDTO.Создать(ТипCreatePresenceAPTOSTWMHS); 
	
	//... 
	
	ОбъектBodyXDTO = ФабрикаXDTO.Создать(ТипBody); 
	ОбъектBodyXDTO.pCreatePresenceAPTOSTWMHS = ОстаткиXDTO;
	 
	ОбъектEnvelopeXDTO = ФабрикаXDTO.Создать(ТипEnvelope);
	ОбъектEnvelopeXDTO.Body.Добавить(ОбъектBodyXDTO);
	
	ФабрикаXDTO.ЗаписатьXML(ЗаписьXML, ОбъектEnvelopeXDTO);
	ДанныеXML = ЗаписьXML.Закрыть();
	
	Возврат ДанныеXML;
	
КонецФункции





















