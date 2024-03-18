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

Функция СоздатьЗаписатьВXMLОбъектEnvelopeXDTO(ТипEnvelope, ОбъектBodyXDTO)
	ОбъектEnvelopeXDTO = ФабрикаXDTO.Создать(ТипEnvelope);
	ОбъектEnvelopeXDTO.Body.Добавить(ОбъектBodyXDTO);
	
	ИмяПромежуточногоФайла = ПолучитьИмяВременногоФайла("xml"); 

	ЗаписьXML = Новый ЗаписьXML();
	ЗаписьXML.ОткрытьФайл(ИмяПромежуточногоФайла, "UTF-8");
	ФабрикаXDTO.ЗаписатьXML(ЗаписьXML, ОбъектEnvelopeXDTO);
	ЗаписьXML.Закрыть();
	
	ФайлXML = Новый Файл(ИмяПромежуточногоФайла);
	
	Возврат ФайлXML; 
КонецФункции

Функция ПолучитьСтруктуруТиповEnvelopeBody()	
	ТипEnvelope = ФабрикаXDTO.Тип("http://schemas.xmlsoap.org/soap/envelope/", "Envelope"); 
	ТипBody = ТипEnvelope.Свойства.Получить("Body").Тип;
	СтруктураТиповEnvelopeBody = Новый Структура;
	СтруктураТиповEnvelopeBody.Вставить("ТипEnvelope", ТипEnvelope);
	СтруктураТиповEnvelopeBody.Вставить("ТипBody", ТипBody);
	Возврат СтруктураТиповEnvelopeBody;
КонецФункции

#Область ВыгрузкаДанных

Функция ПолучитьXMLДляCreateUpdateProductWMHS(Номенклатура)  
	
	СтруктураТиповEnvelopeBody = ПолучитьСтруктуруТиповEnvelopeBody();
	ТипCreateUpdateProductWMHS = СтруктураТиповEnvelopeBody.ТипBody.Свойства.Получить("CreateUpdateProductWMHS").Тип;
	ТипProduct = ТипCreateUpdateProductWMHS.Свойства.Получить("Product").Тип;
	
	НоменклатураXDTO = ФабрикаXDTO.Создать(ТипProduct);
	
	НоменклатураРЛС = Номенклатура.ЭлементКАТ;
	
	НоменклатураXDTO.BarcodeMain = НоменклатураРЛС.Штрихкоды[0].Штрихкод;
																																							
	НоменклатураXDTO.ESKLP = НоменклатураРЛС.АТХ.КодЕСКЛП;
	НоменклатураXDTO.Name = НоменклатураРЛС.Наименование;
	Если НоменклатураРЛС.ГруппаПКУ.Наименование = "Лекарственные препараты неподлежащие ПКУ" Тогда 
		НоменклатураXDTO.PKU = 0;
	Иначе
		НоменклатураXDTO.PKU = 1;
	КонецЕсли;
	НоменклатураXDTO.ProductCode = НоменклатураРЛС.Код;
	НоменклатураXDTO.ProductGroup = Номенклатура.ВидНоменклатуры.ГруппаБухгалтерскогоУчета.Наименование;
	НоменклатураXDTO.RLS = НоменклатураРЛС.НомерРЛС;
	НоменклатураXDTO.Ration = НоменклатураРЛС.Упаковка.Коэффициент;
	НоменклатураXDTO.Category = КодОбъекта(Номенклатура.ВидНоменклатуры);
	НоменклатураXDTO.SubCategory = КодОбъекта(Номенклатура.ВидНоменклатуры);
	НоменклатураXDTO.UnitCodeMax = НоменклатураРЛС.Упаковка.Наименование;
	НоменклатураXDTO.UnitCodeMin = НоменклатураРЛС.Упаковка.БазоваяЕдиницаИзмерения.Наименование;
	
	ОбъектXDTOCreateUpdateProductWMHS = ФабрикаXDTO.Создать(ТипCreateUpdateProductWMHS);
	
	ОбъектXDTOCreateUpdateProductWMHS.Product = НоменклатураXDTO;
	ОбъектXDTOCreateUpdateProductWMHS.RequestName = "";
	ОбъектXDTOCreateUpdateProductWMHS.pIDo = "Хадасса"; 
	
	ОбъектBodyXDTO = ФабрикаXDTO.Создать(СтруктураТиповEnvelopeBody.ТипBody); 
	ОбъектBodyXDTO.CreateUpdateProductWMHS = ОбъектXDTOCreateUpdateProductWMHS;
	 
	Возврат СоздатьЗаписатьВXMLОбъектEnvelopeXDTO(СтруктураТиповEnvelopeBody.ТипEnvelope, ОбъектBodyXDTO)
		
КонецФункции

Функция ПолучитьXMLДляVerifyChangeUnitRatioWMHS(НоменклатураВладельца) 
	
	СтруктураТиповEnvelopeBody = ПолучитьСтруктуруТиповEnvelopeBody();
	ТипVerifyChangeUnitRatioWMHS = СтруктураТиповEnvelopeBody.ТипBody.Свойства.Получить("VerifyChangeUnitRatioWMHS").Тип;
	
	ПроверкаУпаковкиXDTO = ФабрикаXDTO.Создать(ТипVerifyChangeUnitRatioWMHS); 
	
	ПроверкаУпаковкиXDTO.pIDo = "Хадасса";
	ПроверкаУпаковкиXDTO.ProductCode = НоменклатураВладельца.ЭлементКАТ.Код;
	ПроверкаУпаковкиXDTO.RequestName = "";  
															  
																														   
														 
	
	ОбъектBodyXDTO = ФабрикаXDTO.Создать(СтруктураТиповEnvelopeBody.ТипBody); 
	ОбъектBodyXDTO.VerifyChangeUnitRatioWMHS = ПроверкаУпаковкиXDTO;
	 
	Возврат СоздатьЗаписатьВXMLОбъектEnvelopeXDTO(СтруктураТиповEnvelopeBody.ТипEnvelope, ОбъектBodyXDTO)
	
						 

 

																																								   
 
																																						  
																																																																					 
 
																																	 
 
	   
 

																																										
																	 
КонецФункции 



Функция ПолучитьXMLДляCreatePresenceAPTOSTWMHS(НоменклатураВладельца) 
	
	СтруктураТиповEnvelopeBody = ПолучитьСтруктуруТиповEnvelopeBody();
	ТипCreatePresenceAPTOSTWMHS = СтруктураТиповEnvelopeBody.ТипBody.Свойства.Получить("pCreatePresenceAPTOSTWMHS").Тип;
																																																																							
																																																									 
	
	ОстаткиXDTO = ФабрикаXDTO.Создать(ТипCreatePresenceAPTOSTWMHS); 
																		  
	
	//... 
	
	ОбъектBodyXDTO = ФабрикаXDTO.Создать(СтруктураТиповEnvelopeBody.ТипBody); 
	ОбъектBodyXDTO.pCreatePresenceAPTOSTWMHS = ОстаткиXDTO;
	 
	Возврат СоздатьЗаписатьВXMLОбъектEnvelopeXDTO(СтруктураТиповEnvelopeBody.ТипEnvelope, ОбъектBodyXDTO)
  
 
 
																																																																																																							   
																														 
   
   
 
 
   
 
  
 
  
						

															
																															   
																																										
																																					  
	
КонецФункции

Функция ПолучитьXMLДляCreateUpdateFinanceWMHS(ИсточникФинансирования) 
	
	СтруктураТиповEnvelopeBody = ПолучитьСтруктуруТиповEnvelopeBody();
	ТипCreateUpdateFinanceWMHS = СтруктураТиповEnvelopeBody.ТипBody.Свойства.Получить("CreateUpdateFinanceWMHS").Тип;	
	ТипFinance = ТипCreateUpdateFinanceWMHS.Свойства.Получить("Finance").Тип;
	
	ИсточникФинансированияXDTO = ФабрикаXDTO.Создать(ТипFinance); 
	
	ИсточникФинансированияXDTO.FinanceName = ИсточникФинансирования.Наименование;
	ИсточникФинансированияXDTO.FinanceCode = ИсточникФинансирования.Код; 
																																																																																														  
	
	ОбъектXDTOCreateUpdateFinanceWMHS = ФабрикаXDTO.Создать(ТипCreateUpdateFinanceWMHS);
																														 
   
 
  
							   
					
						

 

 
																														 
   
   
																																			 
   
 
  
 
  
   
																														 
 
 
  
   

															  
																															   
																																										
																																					  
																																							  
																		  
																																					 
																							  
																		
																				   
													
																																	  
																																																												
																																																										
	
	ОбъектXDTOCreateUpdateFinanceWMHS.Finance = ИсточникФинансированияXDTO;
	ОбъектXDTOCreateUpdateFinanceWMHS.RequestName = "";
	ОбъектXDTOCreateUpdateFinanceWMHS.pIDo = "Хадасса";
	
	ОбъектBodyXDTO = ФабрикаXDTO.Создать(СтруктураТиповEnvelopeBody.ТипBody); 
	ОбъектBodyXDTO.CreateUpdateFinanceWMHS = ОбъектXDTOCreateUpdateFinanceWMHS;
   
  
  
   
	
	Возврат СоздатьЗаписатьВXMLОбъектEnvelopeXDTO(СтруктураТиповEnvelopeBody.ТипEnvelope, ОбъектBodyXDTO)

КонецФункции

Функция ПолучитьXMLДляCloseDepartmentPeriodIWMHS(КодПодразделения, ДатаЗапрета) 
	СтруктураТиповEnvelopeBody = ПолучитьСтруктуруТиповEnvelopeBody();
	ТипCloseDepartmentPeriodIWMHS = СтруктураТиповEnvelopeBody.ТипBody.Свойства.Получить("CloseDepartmentPeriodIWMHS").Тип;
	
	CloseDepartmentPeriodIWMHSXDTO = ФабрикаXDTO.Создать(ТипCloseDepartmentPeriodIWMHS); 
 
   
  
  
   
 
																														 
   
																														 
 
  
  
   
																																																																																														  
   
																																																																				  
					   
					 
	   
					   
	
	CloseDepartmentPeriodIWMHSXDTO.pIDo = "Хадасса";
	CloseDepartmentPeriodIWMHSXDTO.DepCode = КодПодразделения;
	CloseDepartmentPeriodIWMHSXDTO.Date = ДатаЗапрета;
	CloseDepartmentPeriodIWMHSXDTO.RequestName = "";
  
   
 
  
   
   
																														 
  
   
   
	
	ОбъектBodyXDTO = ФабрикаXDTO.Создать(СтруктураТиповEnvelopeBody.ТипBody); 
	ОбъектBodyXDTO.CloseDepartmentPeriodIWMHS = CloseDepartmentPeriodIWMHSXDTO;
	 
	Возврат СоздатьЗаписатьВXMLОбъектEnvelopeXDTO(СтруктураТиповEnvelopeBody.ТипEnvelope, ОбъектBodyXDTO)	
   
  
																																																																																														  
  
   
   
   
  
 
  
																																			 
																														 
																																						  
   
   
   
																																																																																																			 
 
																																			 
  
 
   
КонецФункции

Функция ПроверитьДвиженияНоменклатурыВQMS(Номенклатура) Экспорт
	СтруктураПараметровЗапроса = ПолучитьСтруктуруПараметровЗапроса();
	АдресСервераQMS = СтруктураПараметровЗапроса.АдресСервераQMS;
	ДополнительныеПараметры = СтруктураПараметровЗапроса.ДополнительныеПараметры;
	СтруктураСообщенияЖурнала = СтруктураПараметровЗапроса.СтруктураСообщенияЖурнала;
	
	ФайлXML = ПолучитьXMLДляVerifyChangeUnitRatioWMHS(Номенклатура); 
	Ответ = КлиентHTTPКлиентСервер.ОтправитьФайл(АдресСервераQMS, ФайлXML, ДополнительныеПараметры);
	ТелоОтвета = Ответ.Тело.Body.VerifyChangeUnitRatioWMHSResponse.Response;
	СтатусОтвета = Лев(ТелоОтвета, 1);
	Если СтатусОтвета = "0" Тогда
		СтруктураСообщенияЖурнала.Комментарий = ТелоОтвета;
		бит_ИнтеграцияQMSВызовСервера.ЗаписатьВЖурналРегистрации(СтруктураСообщенияЖурнала);
		Возврат Ложь;
	ИначеЕсли СтатусОтвета = "1" Тогда

															  
 
																																																																						  
						

 


		  
 
   
 
  
 













		Возврат Истина;	

	КонецЕсли;
КонецФункции

#КонецОбласти
																						  
																						  
																						  
																						  
																						  
																						  
																						  
																						  
																						  
																						  
																						  
																						  
																						  
																						  
																						  
																						  
																						  

#Область ЗагрузкаДанных
																						  
																						  
																						  
																						  

Функция ПолучитьXMLДляGetFinanceListWMHS() 
																						  
																						  
																						  
																						  

																						  
																						  
	СтруктураТиповEnvelopeBody = ПолучитьСтруктуруТиповEnvelopeBody();
	ТипGetFinanceListWMHS = СтруктураТиповEnvelopeBody.ТипBody.Свойства.Получить("GetFinanceListWMHS").Тип;	

	ОбъектXDTOGetFinanceListWMHS = ФабрикаXDTO.Создать(ТипGetFinanceListWMHS); 

	ОбъектXDTOGetFinanceListWMHS.RequestName = "";
	ОбъектXDTOGetFinanceListWMHS.pIDo = "Хадасса";

																						  
	ОбъектBodyXDTO = ФабрикаXDTO.Создать(СтруктураТиповEnvelopeBody.ТипBody); 
	ОбъектBodyXDTO.GetFinanceListWMHS = ОбъектXDTOGetFinanceListWMHS;

	Возврат СоздатьЗаписатьВXMLОбъектEnvelopeXDTO(СтруктураТиповEnvelopeBody.ТипEnvelope, ОбъектBodyXDTO);

КонецФункции

Функция ПолучитьXMLДляGetDepartmentListWMHS() 

																						  
																						  
	СтруктураТиповEnvelopeBody = ПолучитьСтруктуруТиповEnvelopeBody();
	ТипGetDepartmentListWMHS = СтруктураТиповEnvelopeBody.ТипBody.Свойства.Получить("GetDepartmentListWMHS").Тип;	

	ОбъектXDTOGetDepartmentListWMHS = ФабрикаXDTO.Создать(ТипGetDepartmentListWMHS); 

	ОбъектXDTOGetDepartmentListWMHS.RequestName = "";
	ОбъектXDTOGetDepartmentListWMHS.pIDo = "Хадасса";

	ОбъектBodyXDTO = ФабрикаXDTO.Создать(СтруктураТиповEnvelopeBody.ТипBody); 
	ОбъектBodyXDTO.GetDepartmentListWMHS = ОбъектXDTOGetDepartmentListWMHS;

	Возврат СоздатьЗаписатьВXMLОбъектEnvelopeXDTO(СтруктураТиповEnvelopeBody.ТипEnvelope, ОбъектBodyXDTO);

КонецФункции

Функция ЗагрузитьПодразделенияИзQMS() Экспорт
	СтруктураПараметровЗапроса = ПолучитьСтруктуруПараметровЗапроса();
	АдресСервераQMS = СтруктураПараметровЗапроса.АдресСервераQMS;
	ДополнительныеПараметры = СтруктураПараметровЗапроса.ДополнительныеПараметры;
	СтруктураСообщенияЖурнала = СтруктураПараметровЗапроса.СтруктураСообщенияЖурнала;
																						  
	
	ФайлXML = ПолучитьXMLДляGetDepartmentListWMHS(); 
	Ответ = КлиентHTTPКлиентСервер.ОтправитьФайл(АдресСервераQMS, ФайлXML, ДополнительныеПараметры);
	СписокПодразделенийИзQMS = Ответ.Тело.Body.GetDepartmentListWMHSResponse.DepartmentList.DepartmentStructure;
	ТелоОтвета = Ответ.Тело.Body.GetDepartmentListWMHSResponse.Response;
	СтатусОтвета = Лев(ТелоОтвета, 1);
	Если СтатусОтвета = "0" Тогда
		СтруктураСообщенияЖурнала.Комментарий = ТелоОтвета;
		бит_ИнтеграцияQMSВызовСервера.ЗаписатьВЖурналРегистрации(СтруктураСообщенияЖурнала);
		Возврат Ложь;
	ИначеЕсли СтатусОтвета = "1" Тогда
		Для Каждого ПодразделениеQMS Из СписокПодразделенийИзQMS Цикл  
			Если Справочники.ПодразделенияОрганизаций.НайтиПоКоду(ПодразделениеQMS.DepartmentCode) = Справочники.ПодразделенияОрганизаций.ПустаяСсылка() Тогда
				НовоеПодразделение = Справочники.ПодразделенияОрганизаций.СоздатьЭлемент();
				НовоеПодразделение.Код = ПодразделениеQMS.DepartmentCode;
				НовоеПодразделение.Наименование = ПодразделениеQMS.DepartmentName;
				НовоеПодразделение.Владелец = ОбъектПоКоду("Хадасса");
				НовоеПодразделение.ОбменДанными.Загрузка = Истина;
				НовоеПодразделение.Записать();
			КонецЕсли;
		КонецЦикла;
		Возврат Истина;	
	КонецЕсли;
КонецФункции

Функция ЗагрузитьИсточникиФинансированияИзQMS() Экспорт
	СтруктураПараметровЗапроса = ПолучитьСтруктуруПараметровЗапроса();
	АдресСервераQMS = СтруктураПараметровЗапроса.АдресСервераQMS;
	ДополнительныеПараметры = СтруктураПараметровЗапроса.ДополнительныеПараметры;
	СтруктураСообщенияЖурнала = СтруктураПараметровЗапроса.СтруктураСообщенияЖурнала;
	
	ФайлXML = ПолучитьXMLДляGetFinanceListWMHS(); 
	Ответ = КлиентHTTPКлиентСервер.ОтправитьФайл(АдресСервераQMS, ФайлXML, ДополнительныеПараметры);
	СписокИсточниковФинансированияИзQMS = Ответ.Тело.Body.GetFinanceListWMHSResponse.FinanceList.FinanceStructure;
	ТелоОтвета = Ответ.Тело.Body.GetFinanceListWMHSResponse.Response;
	СтатусОтвета = Лев(ТелоОтвета, 1);
	Если СтатусОтвета = "0" Тогда
		СтруктураСообщенияЖурнала.Комментарий = ТелоОтвета;
		бит_ИнтеграцияQMSВызовСервера.ЗаписатьВЖурналРегистрации(СтруктураСообщенияЖурнала);
		Возврат Ложь;
	ИначеЕсли СтатусОтвета = "1" Тогда
		Для Каждого ИсточникФинансированияQMS Из СписокИсточниковФинансированияИзQMS Цикл  
			Если Справочники.ИсточникиФинансирования.НайтиПоКоду(ИсточникФинансированияQMS.FinanceCode) = Справочники.ИсточникиФинансирования.ПустаяСсылка() Тогда
				НовыйИсточникФинансирования = Справочники.ИсточникиФинансирования.СоздатьЭлемент();
				НовыйИсточникФинансирования.Код = ИсточникФинансированияQMS.FinanceCode;
				НовыйИсточникФинансирования.Наименование = ИсточникФинансированияQMS.FinanceName;
				НовыйИсточникФинансирования.Записать();
			КонецЕсли;
		КонецЦикла;
		Возврат Истина;	
	КонецЕсли;
КонецФункции

#КонецОбласти

Функция ПолучитьСтруктуруПараметровЗапроса()
	АдресСервераQMS = бит_ИнтеграцияQMSСерверПовтИсп.НастройкиПодключения().АдресСервера;
	ДополнительныеПараметры = КлиентHTTPКлиентСервер.НовыеДополнительныеПараметры();
	КлиентHTTPКлиентСервер.ТелоОтветаКакXML(ДополнительныеПараметры);
	СтруктураСообщенияЖурнала = бит_ИнтеграцияQMSВызовСервера.НоваяСтруктураСообщенияЖурнала();
	Узел = ПланыОбмена.бит_ПланОбменаQMS.НайтиПоКоду("001");
	
	СтруктураПараметров = Новый Структура();
	
	СтруктураПараметров.Вставить("АдресСервераQMS", АдресСервераQMS);
	СтруктураПараметров.Вставить("ДополнительныеПараметры", ДополнительныеПараметры);
	СтруктураПараметров.Вставить("СтруктураСообщенияЖурнала", СтруктураСообщенияЖурнала);
	СтруктураПараметров.Вставить("Узел", Узел);
	
	Возврат СтруктураПараметров; 
КонецФункции

Процедура ЗаданиеОбмена() Экспорт
	СтруктураПараметровЗапроса = ПолучитьСтруктуруПараметровЗапроса();
	АдресСервераQMS = СтруктураПараметровЗапроса.АдресСервераQMS;
	ДополнительныеПараметры = СтруктураПараметровЗапроса.ДополнительныеПараметры;
	СтруктураСообщенияЖурнала = СтруктураПараметровЗапроса.СтруктураСообщенияЖурнала;
	Узел = СтруктураПараметровЗапроса.Узел;
	ВыборкаИзменений = ПланыОбмена.ВыбратьИзменения(Узел, Узел.НомерОтправленного);
	//Проходим все зарегистрированные к обмену объекты
	Пока ВыборкаИзменений.Следующий() Цикл
		ОбъектКОбмену = ВыборкаИзменений.Получить();
		//Выгрузка номенклатуры
		Если ТипЗнч(ОбъектКОбмену) = Тип("СправочникОбъект.Номенклатура") Тогда  
			ФайлXML = ПолучитьXMLДляCreateUpdateProductWMHS(ОбъектКОбмену.Ссылка); 
			Ответ = КлиентHTTPКлиентСервер.ОтправитьФайл(АдресСервераQMS, ФайлXML, ДополнительныеПараметры);
			ТелоОтвета = Ответ.Тело.Body.CreateUpdateProductWMHSResponse.Response;
			СтатусОтвета = Лев(ТелоОтвета, 1);
			Если СтатусОтвета = "0" Тогда
				СтруктураСообщенияЖурнала.Комментарий = ТелоОтвета;
				бит_ИнтеграцияQMSВызовСервера.ЗаписатьВЖурналРегистрации(СтруктураСообщенияЖурнала);
			ИначеЕсли СтатусОтвета = "1" Тогда
				ПланыОбмена.УдалитьРегистрациюИзменений(Узел, Узел.НомерОтправленного);
				Узел.НомерОтправленного = Узел.НомерОтправленного + 1;
				Узел.Записать();
			КонецЕсли;	
		КонецЕсли;
		//Выгрузка источников финансирования
		Если ТипЗнч(ОбъектКОбмену) = Тип("СправочникОбъект.ИсточникиФинансирования") Тогда  
			ФайлXML = ПолучитьXMLДляCreateUpdateFinanceWMHS(ОбъектКОбмену.Ссылка); 
			Ответ = КлиентHTTPКлиентСервер.ОтправитьФайл(АдресСервераQMS, ФайлXML, ДополнительныеПараметры);
			ТелоОтвета = Ответ.Тело.Body.CreateUpdateFinanceWMHSResponse.Response;
			СтатусОтвета = Лев(ТелоОтвета, 1);
			Если СтатусОтвета = "0" Тогда
				СтруктураСообщенияЖурнала.Комментарий = ТелоОтвета;
				бит_ИнтеграцияQMSВызовСервера.ЗаписатьВЖурналРегистрации(СтруктураСообщенияЖурнала);
			ИначеЕсли СтатусОтвета = "1" Тогда
				ПланыОбмена.УдалитьРегистрациюИзменений(Узел, Узел.НомерОтправленного);
				Узел.НомерОтправленного = Узел.НомерОтправленного + 1;
				Узел.Записать();
			КонецЕсли;	
		КонецЕсли;
		//Выгрузка источников финансирования
		Если ТипЗнч(ОбъектКОбмену) = Тип("СправочникОбъект.ИсточникиФинансирования") Тогда  
			ФайлXML = ПолучитьXMLДляCreateUpdateFinanceWMHS(ОбъектКОбмену.Ссылка); 
			Ответ = КлиентHTTPКлиентСервер.ОтправитьФайл(АдресСервераQMS, ФайлXML, ДополнительныеПараметры);
			ТелоОтвета = Ответ.Тело.Body.CreateUpdateFinanceWMHSResponse.Response;
			СтатусОтвета = Лев(ТелоОтвета, 1);
			Если СтатусОтвета = "0" Тогда
				СтруктураСообщенияЖурнала.Комментарий = ТелоОтвета;
				бит_ИнтеграцияQMSВызовСервера.ЗаписатьВЖурналРегистрации(СтруктураСообщенияЖурнала);
			ИначеЕсли СтатусОтвета = "1" Тогда
				ПланыОбмена.УдалитьРегистрациюИзменений(Узел);	
			КонецЕсли;	
		КонецЕсли;
		//...
	КонецЦикла;
	//Выгрузка даты запрета изменения данных
		Если ТипЗнч(ОбъектКОбмену) = Тип("РегистрСведенийНаборЗаписей.ДатыЗапретаИзменения") Тогда	
			Запрос = Новый Запрос;
			Запрос.Текст = 
				"ВЫБРАТЬ
				|	ДатыЗапретаИзменения.Объект КАК Объект,
				|	ДатыЗапретаИзменения.ОписаниеДатыЗапрета КАК ОписаниеДатыЗапрета,
				|	ДатыЗапретаИзменения.Пользователь КАК Пользователь,
				|	ДатыЗапретаИзменения.ДатаЗапрета КАК ДатаЗапрета
				|ИЗ
				|	РегистрСведений.ДатыЗапретаИзменения КАК ДатыЗапретаИзменения,
				|	РегистрСведений.ДатыЗапретаИзменения.Изменения КАК ДатыЗапретаИзмененияИзменения
				|ГДЕ
				|	ДатыЗапретаИзменения.Пользователь = &Пользователь";
			
			Запрос.УстановитьПараметр("Пользователь", Перечисления.ВидыНазначенияДатЗапрета.ДляВсехПользователей);
			
			РезультатЗапроса = Запрос.Выполнить();
			
			Выборка = РезультатЗапроса.Выбрать();
			
			Пока Выборка.Следующий() Цикл
				ДатаЗапрета = ДатыЗапретаИзмененияСлужебный.ДатаЗапретаПоОписанию(Выборка.ОписаниеДатыЗапрета, Выборка.ДатаЗапрета);
				ДатаЗапрета =  Формат(ДатаЗапрета, "ДФ=yyyy-MM-dd");
				КодПодразделения = КодОбъекта(Выборка.Объект);
				Если ЗначениеЗаполнено(Выборка.Объект) Тогда
					КодПодразделения = КодОбъекта(Выборка.Объект);
				Иначе
					КодПодразделения = "000001";
				КонецЕсли;
				ФайлXML = ПолучитьXMLДляCloseDepartmentPeriodIWMHS(КодПодразделения, ДатаЗапрета); 
				Ответ = КлиентHTTPКлиентСервер.ОтправитьФайл(АдресСервераQMS, ФайлXML, ДополнительныеПараметры);
				ТелоОтвета = Ответ.Тело.Body.CloseDepartmentPeriodIWMHSResponse.Response;
				СтатусОтвета = Лев(ТелоОтвета, 1);
				Если СтатусОтвета = "0" Тогда
					СтруктураСообщенияЖурнала.Комментарий = ТелоОтвета;
					бит_ИнтеграцияQMSВызовСервера.ЗаписатьВЖурналРегистрации(СтруктураСообщенияЖурнала);
				ИначеЕсли СтатусОтвета = "1" Тогда
					ПланыОбмена.УдалитьРегистрациюИзменений(Узел, Узел.НомерОтправленного);
					УзелОбъект = Узел.ПолучитьОбъект();
					УзелОбъект.НомерОтправленного = Узел.НомерОтправленного + 1;
					УзелОбъект.Записать();
				КонецЕсли;
			КонецЦикла;
			
		КонецЕсли;
КонецПроцедуры

// Функция - Получает код объекта 
// Параметры:
//  Объект - 	 СправочникСсылка.ОтделенияОрганизаций, СправочникСсылка.Склады, СправочникСсылка.ПодразделенияОрганизаций, СправочникСсылка.Организации 
// Возвращаемое значение:
//   -    Строка - Код объектаQMS
//
Функция КодОбъекта(Объект) Экспорт
	
	Возврат РегистрыСведений.бит_СоответствияОбъектовУчетаQMS.ПолучитьКодОбъекта(Объект);

КонецФункции 

Функция ОбъектПоКоду(Код) Экспорт 
	
	Возврат РегистрыСведений.бит_СоответствияОбъектовУчетаQMS.ПолучитьОбъектПоКоду(Код);
																						  

КонецФункции 

Процедура бит_ДатаЗапретаQMSПриЗаписиПриЗаписи(Источник, Отказ, Замещение) Экспорт 
	Если Источник.Отбор.Пользователь.Значение = Перечисления.ВидыНазначенияДатЗапрета.ДляВсехПользователей Тогда
		СтруктураПараметровЗапроса = ПолучитьСтруктуруПараметровЗапроса();
		Узел = СтруктураПараметровЗапроса.Узел;
		ПланыОбмена.ЗарегистрироватьИзменения(Узел, Источник);
	КонецЕсли;
КонецПроцедуры





Функция ПолучитьXMLДляGetAPTRWMHS(ДатаНачала,ДатаОкончания) Экспорт
	
	СтруктураТиповEnvelopeBody = ПолучитьСтруктуруТиповEnvelopeBody();
	ТипGetAPTRWMHS = СтруктураТиповEnvelopeBody.ТипBody.Свойства.Получить("GetAPTRWMHS").Тип;
	
	ОбъектXDTOGetAPTRWMHS = ФабрикаXDTO.Создать(ТипGetAPTRWMHS);
	
	ОбъектXDTOGetAPTRWMHS.pIDo = "Хадасса"; 	
	ОбъектXDTOGetAPTRWMHS.DateBegin = Формат(ДатаНачала,"ДФ=yyyy-MM-dd");
	ОбъектXDTOGetAPTRWMHS.DateEnd = Формат(ДатаОкончания,"ДФ=yyyy-MM-dd");
	ОбъектXDTOGetAPTRWMHS.sdstDoc = "1";
	ОбъектXDTOGetAPTRWMHS.DepCodeFrom = "";
	ОбъектXDTOGetAPTRWMHS.RequestName = "";
	
	ОбъектBodyXDTO = ФабрикаXDTO.Создать(СтруктураТиповEnvelopeBody.ТипBody); 
	ОбъектBodyXDTO.GetAPTRWMHS = ОбъектXDTOGetAPTRWMHS;
	
	Возврат СоздатьЗаписатьВXMLОбъектEnvelopeXDTO(СтруктураТиповEnvelopeBody.ТипEnvelope, ОбъектBodyXDTO)
	
КонецФункции 

Функция СвойстваXDTOВСоответствие(СписокСвойствXDTO) Экспорт  
	
	Мэп = Новый Соответствие;
	Если ТипЗнч(СписокСвойствXDTO) = Тип("ОбъектXDTO") Тогда
		Для Каждого Свойство Из СписокСвойствXDTO.Свойства() Цикл
			Мэп.Вставить(Свойство.Имя);
		КонецЦикла;
	ИначеЕсли ТипЗнч(СписокСвойствXDTO) = Тип("СписокXDTO") Тогда
		Для Каждого Свойство Из СписокСвойствXDTO[0].Свойства() Цикл
			Мэп.Вставить(Свойство.Имя);
		КонецЦикла;
	КонецЕсли;
	Возврат Мэп;
	
КонецФункции 

Процедура ВыгрузкаИзQMSРасходныхДокументов() Экспорт
	
	АдресСервераQMS = бит_ИнтеграцияQMSСерверПовтИсп.НастройкиПодключения().АдресСервера;
	СтруктураСообщенияЖурнала = бит_ИнтеграцияQMSВызовСервера.НоваяСтруктураСообщенияЖурнала(); 
	ДополнительныеПараметры = КлиентHTTPКлиентСервер.НовыеДополнительныеПараметры();
	КлиентHTTPКлиентСервер.ТелоОтветаКакXML(ДополнительныеПараметры);
	
	//ИмяФайлаСОтветом = "D:\Результат.xml";
	//КлиентHTTPКлиентСервер.УстановитьИмяВыходногоФайла(ДополнительныеПараметры,ИмяФайлаСОтветом);
	
	ФайлXML = ПолучитьXMLДляGetAPTRWMHS(Дата(2024,1,1),Дата(2024,12,1));
	
 	Ответ = КлиентHTTPКлиентСервер.ОтправитьФайл(АдресСервераQMS, ФайлXML, ДополнительныеПараметры);
		
	ТелоОтвета = Ответ.Тело.Body.GetAPTRWMHSResponse.Response;
	СтатусОтвета = Лев(ТелоОтвета, 1);
	Если СтатусОтвета = "0" Тогда
		СтруктураСообщенияЖурнала.Комментарий = ТелоОтвета;
		бит_ИнтеграцияQMSВызовСервера.ЗаписатьВЖурналРегистрации(СтруктураСообщенияЖурнала);
	ИначеЕсли СтатусОтвета = "1" Тогда
		//успешно
		ТаблицаВыгрузки = СоздатьТаблицуВыгрузки();
		СписокXDTO = Ответ.Тело.Body.GetAPTRWMHSResponse.Product.ProductTransferStructure;
		Для Каждого ЭлементСписка Из СписокXDTO Цикл
			СтрокаТаблицы = ТаблицаВыгрузки.Добавить();
			ЗаполнитьЗначенияСвойств(СтрокаТаблицы,ЭлементСписка);
		КонецЦикла;
		
		ТаблицаВыгрузкиПослеСвертки = ТаблицаВыгрузки.Скопировать();
		ТаблицаВыгрузкиПослеСвертки.Свернуть("DocType,DocNum,DocDate,DocOTD,DocSKL");
		Для Каждого СтрокаДок Из ТаблицаВыгрузкиПослеСвертки Цикл 
			ПараметрыОтбора = Новый Структура("DocNum,DocDate",СтрокаДок.DocNum,СтрокаДок.DocDate);
			МассивСтрокСНоменклатурой = ТаблицаВыгрузки.НайтиСтроки(ПараметрыОтбора);
			СоздатьОбновитьДокумент(СтрокаДок, МассивСтрокСНоменклатурой);
		КонецЦикла;	
	КонецЕсли;
	
КонецПроцедуры

Функция ХэшДанных(ОбъектДанных) Экспорт
 
													
																																																			 
												  
	
	Возврат ОбщегоНазначения.КонтрольнаяСуммаСтрокой(ОбъектДанных);
	
КонецФункции 

Функция ПодготовитьМассивДанныхДокумента(НомерДокумента,ДатаДокумента,ИмяДокумента)
	
	СтруктураДанные = Новый Структура("ДокументСсылка, МассивСтрок",,Новый Массив);
	ТаблицаЗначений = СоздатьТаблицуДляХэша();
	Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(Документы[ИмяДокумента],"НомерQMS") Тогда
		Запрос = Новый Запрос;
		Запрос.Текст = 
		"ВЫБРАТЬ ПЕРВЫЕ 1
		|	ДокументТовары.Ссылка КАК ДокументСылка,
		|	ДокументТовары.Ссылка.Отделение КАК Отделение,
		|	ДокументТовары.Ссылка.ИсточникФинансирования.Код КАК FinanceCode,
		|	ДокументТовары.Ссылка.НомерQMS КАК DocNum,
		|	ДокументТовары.Ссылка.Склад КАК Склад,
		|	ДокументТовары.Номенклатура.Код КАК CategoryCode,
		|	ДокументТовары.КоличествоВЕдиницахИзмерения КАК NumMax,
		|	ДокументТовары.Количество КАК NumMin,
		|	ДокументТовары.Штрихкод КАК Barcode
		|ИЗ
		|	Документ."+ИмяДокумента+".Товары КАК ДокументТовары
		|ГДЕ
		|	ДокументТовары.Ссылка.НомерQMS = &НомерДокумента
		|	И НАЧАЛОПЕРИОДА(ДокументТовары.Ссылка.Дата, ДЕНЬ) = НАЧАЛОПЕРИОДА(&ДатаДокумента, ДЕНЬ)"; 
		                                                       
		Запрос.УстановитьПараметр("НомерДокумента", НомерДокумента);
		Запрос.УстановитьПараметр("ДатаДокумента", СтроковыеФункцииКлиентСервер.СтрокаВДату(ДатаДокумента));
		
		Если ИмяДокумента = "ВозвратТоваровИзОтделения" Тогда
			Запрос.Текст = СтрЗаменить(Запрос.Текст,"ДокументТовары.Ссылка.Склад","ДокументТовары.Ссылка.СкладОтправитель");
		КонецЕсли;
		
		РезультатЗапроса = Запрос.Выполнить();
		
		Выборка = РезультатЗапроса.Выбрать();
		
		Пока Выборка.Следующий() Цикл
			НовСтр = ТаблицаЗначений.Добавить();
			ЗаполнитьЗначенияСвойств(НовСтр,Выборка);
			НовСтр.DocOTD = КодОбъекта(Выборка.Отделение);
			НовСтр.DocSKL = КодОбъекта(Выборка.Склад);
			СтруктураДанные.ДокументСсылка = Выборка.ДокументСсылка;
			СтруктураДанные.МассивСтрок.Добавить(НовСтр);
		КонецЦикла;
	КонецЕсли;
	Возврат СтруктураДанные;
	
КонецФункции 

Функция ПолучитьИмяДокумента(DocType) Экспорт
	
	Если DocType = "списание без назначения" ИЛИ DocType = "акт списания" Тогда
		ИмяДокумента = "ВнутреннееПотреблениеТоваровВОтделении";
	ИначеЕсли DocType = "списание на отделении" Тогда
		ИмяДокумента = "ВозвратТоваровИзОтделения";
	КонецЕсли;
	Возврат ИмяДокумента;
	
																																																			 

КонецФункции

Процедура СоздатьОбновитьДокумент(Шапка, ТаблицаНоменклатуры)
													
																																																					
	
	//вычисление хэша
	ТаблицаДляХэша = СоздатьТаблицуДляХэша();
	Для Каждого Элемент Из ТаблицаНоменклатуры Цикл
		  НовСтр = ТаблицаДляХэша.Добавить();
		  ЗаполнитьЗначенияСвойств(НовСтр,Элемент);
		  НовСтр.CategoryCode = Элемент.Category.ProductCode;
		  НовСтр.FinanceCode = Элемент.Finance.FinanceCode;
		  //НовСтр.ProductSerialCode = Элемент.ProductSerial.Code;
	КонецЦикла;
	ХэшДокументаQMS = ХэшДанных(ТаблицаДляХэша);
	ИмяДокумента = ПолучитьИмяДокумента(Шапка.DocType);
	СтруктураДанныеДокумента = ПодготовитьМассивДанныхДокумента(Шапка.DocNum,Шапка.DocDate,ИмяДокумента);
	Если СтруктураДанныеДокумента.МассивСтрок.Количество() > 0 Тогда 
		ХэшДокумента1С = ХэшДанных(СтруктураДанныеДокумента.МассивСтрок);
		Если ХэшДокументаQMS <> ХэшДокумента1С Тогда
			//обновляем документ
			ДокОбъект = СтруктураДанныеДокумента.ДокументСсылка.ПолучитьОбъект();
		КонецЕсли;
	Иначе //создаем документ
		ДокОбъект = Документы[ИмяДокумента].СоздатьДокумент();
	КонецЕсли;
	
	Если ИмяДокумента = "ВнутреннееПотреблениеТоваровВОтделении" Тогда
		ДокОбъект.Склад = ОбъектПоКоду(Шапка.DocSKL);
	ИначеЕсли ИмяДокумента = "ВозвратТоваровИзОтделения" Тогда
		ДокОбъект.СкладОтправитель = ОбъектПоКоду(Шапка.DocSKL);
		ДокОбъект.СкладПолучатель = Справочники.Склады.НайтиПоНаименованию("Склад Общий Аптека");
	КонецЕсли;
	ДокОбъект.Организация = Справочники.Организации.НайтиПоНаименованию("Филиал компании ""Хадасса Медикал ЛТД""");
	ДокОбъект.Отделение = ОбъектПоКоду(Шапка.DocOTD);
	ДокОбъект.НомерQMS = Шапка.DocNum;
	ДокОбъект.Дата = СтроковыеФункцииКлиентСервер.СтрокаВДату(Шапка.DocDate);
	ДокОбъект.Ответственный = ПараметрыСеанса.ТекущийПользователь;
	//СтруктураИсточникФинансирования = СоздатьСтруктуруFinance();
	//ЗаполнитьЗначенияСвойств(СтруктураИсточникФинансирования,Шапка.Finance);
	//ДокОбъект.ИсточникФинансирования = Справочники.ИсточникиФинансирования.НайтиПоКоду(СтруктураИсточникФинансирования.FinanceCode);
	
	ДокОбъект.Товары.Очистить();
	Номенлатура1С = Неопределено;
	Для Каждого Строка Из ТаблицаНоменклатуры Цикл 
		СтруктураНоменклатура = СоздатьСтруктуруCategory();
		ЗаполнитьЗначенияСвойств(СтруктураНоменклатура,Строка.Category);
		НовСтр = ДокОбъект.Товары.Добавить();
		Номенлатура1С = Справочники.Номенклатура.НайтиПоКоду(СтруктураНоменклатура.ProductCode);
		Если Не ЗначениеЗаполнено(Номенлатура1С) Тогда
			Номенлатура1С = Справочники.Номенклатура.НайтиПоНаименованию(СтрЗаменить(СтруктураНоменклатура.Name,"_"," "));
		КонецЕсли;
		НовСтр.Номенклатура = Номенлатура1С;
		Если ЗначениеЗаполнено(Номенлатура1С) Тогда
			НовСтр.ЕдиницаИзмерения = Номенлатура1С.ЕдиницаИзмерения;
		КонецЕсли;
		НовСтр.КоличествоВЕдиницахИзмерения = СтроковыеФункцииКлиентСервер.СтрокаВЧисло(Строка.NumMax); 
		НовСтр.Количество =  СтроковыеФункцииКлиентСервер.СтрокаВЧисло(Строка.NumMin);
	КонецЦикла;
	Попытка
		ДокОбъект.Записать(РежимЗаписиДокумента.Запись);
	Исключение
		СтруктураСообщенияЖурнала = бит_ИнтеграцияQMSВызовСервера.НоваяСтруктураСообщенияЖурнала();
		СтруктураСообщенияЖурнала.Комментарий = ОписаниеОшибки();
		бит_ИнтеграцияQMSВызовСервера.ЗаписатьВЖурналРегистрации(СтруктураСообщенияЖурнала);
	КонецПопытки;
	
	
КонецПроцедуры

Функция СоздатьТаблицуВыгрузки() Экспорт
																
	
	ТЗ = Новый ТаблицаЗначений;    
    ТЗ.Колонки.Добавить("Category");
    ТЗ.Колонки.Добавить("PST");
    ТЗ.Колонки.Добавить("Finance");
	ТЗ.Колонки.Добавить("MDLP");
    ТЗ.Колонки.Добавить("ProductSerial");
    ТЗ.Колонки.Добавить("Price");
	ТЗ.Колонки.Добавить("NumMin");
    ТЗ.Колонки.Добавить("NumMax");
    ТЗ.Колонки.Добавить("ValidityPeriod");
	ТЗ.Колонки.Добавить("Barcode");
    ТЗ.Колонки.Добавить("KSU");
    ТЗ.Колонки.Добавить("DocType");
	ТЗ.Колонки.Добавить("DocNum");
    ТЗ.Колонки.Добавить("DocDate");
    ТЗ.Колонки.Добавить("DocSKL");
	ТЗ.Колонки.Добавить("DocOTD");
    ТЗ.Колонки.Добавить("GUIDs41");
    ТЗ.Колонки.Добавить("uCode");
	ТЗ.Колонки.Добавить("uName");
	ТЗ.Колонки.Добавить("num174");
    ТЗ.Колонки.Добавить("Finance174");
    ТЗ.Колонки.Добавить("dat174b");
	ТЗ.Колонки.Добавить("dat174e");
    ТЗ.Колонки.Добавить("GUID174");
    ТЗ.Колонки.Добавить("DocSKLTO");	
	ТЗ.Колонки.Добавить("DocOTDTO");
	ТЗ.Колонки.Добавить("Doctor");
	ТЗ.Колонки.Добавить("Nurse");
    ТЗ.Колонки.Добавить("fio");
    ТЗ.Колонки.Добавить("pB");
	ТЗ.Колонки.Добавить("birthday");
    ТЗ.Колонки.Добавить("pstName");
    ТЗ.Колонки.Добавить("pstINN");
	ТЗ.Колонки.Добавить("ContractNum");
	ТЗ.Колонки.Добавить("ContractDate");
	
	Возврат ТЗ;
	
КонецФункции  
						

Функция СоздатьТаблицуДляХэша() Экспорт
	
	ТЗ = Новый ТаблицаЗначений;    
    ТЗ.Колонки.Добавить("CategoryCode");
    ТЗ.Колонки.Добавить("FinanceCode");
    //ТЗ.Колонки.Добавить("ProductSerialCode");
	ТЗ.Колонки.Добавить("NumMin");
    ТЗ.Колонки.Добавить("NumMax");
	ТЗ.Колонки.Добавить("Barcode");
    //ТЗ.Колонки.Добавить("KSU");
	ТЗ.Колонки.Добавить("DocNum");
    //ТЗ.Колонки.Добавить("DocDate");
    ТЗ.Колонки.Добавить("DocSKL");
	ТЗ.Колонки.Добавить("DocOTD");
	
	Возврат ТЗ;
	
КонецФункции  

Функция СоздатьСтруктуруCategory() Экспорт
	
	Возврат Новый Структура("pIDo,ProductCode,Name,Category,SubCategory,Ration,UnitCodeMin,UnitCodeMax,RLS,ESKLP,BarcodeMain,ProductGroup,PKU,FederalCode,RegionalCode");
	
КонецФункции 

Функция СоздатьСтруктуруFinance() Экспорт
	
	Возврат Новый Структура("FinanceCode,FinanceName");
	
КонецФункции 








