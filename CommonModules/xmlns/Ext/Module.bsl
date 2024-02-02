#Область ПрограммныйИнтерфейс

/// Пространство имен http://www.fss.ru/integration/types/eln/v01
Функция com() Экспорт
	
	Возврат "http://www.fss.ru/integration/types/eln/v01";
	
КонецФункции

/// Пространство имен http://www.w3.org/2000/09/xmldsig#
Функция ds() Экспорт
	
	Возврат "http://www.w3.org/2000/09/xmldsig#";
	
КонецФункции

/// Пространство имен для ЭЛН
Функция eln(ЭЛНПоКарантину = Ложь) Экспорт
	
	Если ЭЛНПоКарантину = Истина Тогда
		Возврат "http://www.fss.ru/integration/types/eln/quarantine/statement/v01";
	КонецЕсли;
	
	Возврат "http://www.fss.ru/integration/types/eln/mo/v01";
	
КонецФункции

/// Пространство имен для ЭЛН
Функция eln11(ЭЛНПоКарантину = Ложь) Экспорт
	
	Если ЭЛНПоКарантину = Истина Тогда
		Возврат "http://www.fss.ru/integration/types/eln/quarantine/statement/v01";
	КонецЕсли;
	
	Возврат "http://ru/ibs/fss/ln/ws/FileOperationsLn.wsdl";
	
КонецФункции

/// Пространство имен http://gtw.ws.fss.ru/openservice/ers
Функция ers() Экспорт
	
	Возврат "http://gtw.ws.fss.ru/openservice/ers";
	
КонецФункции

// Простанство имен http://egisz.rosminzdrav.ru
// 
// Возвращаемое значение:
//  Строка - http://egisz.rosminzdrav.rul
//
Функция egisz() Экспорт
	
	Возврат "http://egisz.rosminzdrav.ru";
	
КонецФункции

/// Пространство имен http://gtw.ws.fss.ru/openservice/ers
Функция ns2() Экспорт
	
	Возврат "http://ws.fss.ru/services/ers";
	
КонецФункции

/// Пространство имен для ГосУслуг
Функция gu(Версия = "СМЭВ2") Экспорт
	
	Если Версия = "СМЭВ2" Тогда
		Возврат "http://smev.gosuslugi.ru/rev120315";
	ИначеЕсли Версия = "СМЭВ3" Тогда
		Возврат "urn://x-artefacts-smev-gov-ru/supplementary/commons/1.0.1";
	КонецЕсли;
	
	__ПРОВЕРКА__(Ложь, "Пространство имен XML для ГосУслуг не определено.");
	
КонецФункции

/// Пространство имен urn://x-artefacts-smev-gov-ru/services/message-exchange/types/1.1
Функция gu_types() Экспорт
	Возврат "urn://x-artefacts-smev-gov-ru/services/message-exchange/types/1.1";
КонецФункции

/// Пространство имен urn://x-artefacts-smev-gov-ru/services/message-exchange/types/basic/1.1
Функция gu_types_basic() Экспорт
	Возврат "urn://x-artefacts-smev-gov-ru/services/message-exchange/types/basic/1.1";
КонецФункции

/// Пространство имен urn://x-artefacts-smev-gov-ru/services/message-exchange/types/faults/1.1
Функция gu_types_faults() Экспорт
	Возврат "urn://x-artefacts-smev-gov-ru/services/message-exchange/types/faults/1.1";
КонецФункции

/// Пространство имен http://gost34.ibs.ru/WrapperService/Schema
Функция sch() Экспорт
	
	Возврат "http://gost34.ibs.ru/WrapperService/Schema";
	
КонецФункции

/// Пространство имен http://snils-by-data.skmv.rstyle.com
Функция snils() Экспорт
	
	Возврат "http://snils-by-data.skmv.rstyle.com";
	
КонецФункции

/// Пространство имен XML soap
Функция soap(Версия = "1.1") Экспорт
	
	Если Версия = "1.1" Тогда
		Возврат "http://schemas.xmlsoap.org/soap/envelope/";
		
	ИначеЕсли Версия = "1.2" Тогда
		Возврат "http://www.w3.org/2003/05/soap-envelope";
		
	КонецЕсли;
	
	__ПРОВЕРКА__(Ложь, "Пространство имен XML soap Версии %1 не определено.", Версия);
	
КонецФункции

/// Пространство имен XML pfr
Функция pfr(Версия = "СМЭВ2") Экспорт
	
	Если Версия = "СМЭВ2" Тогда
		Возврат "http://pfr.skmv.rstyle.com";
	ИначеЕсли Версия = "СМЭВ3" Тогда
		Возврат "http://common.kvs.pfr.com/1.0.0";
	КонецЕсли;
	
	__ПРОВЕРКА__(Ложь, "Пространство имен XML pfr Версии %1 не определено.", Версия);
	
КонецФункции

/// Пространство имен "http://kvs.pfr.com/snils-by-additionalData/1.0.1"
Функция tns() Экспорт
	
	Возврат "http://kvs.pfr.com/snils-by-additionalData/1.0.1";
	
КонецФункции
/// Пространство имен http://www.w3.org/2005/08/addressing
Функция wsa() Экспорт
	
	Возврат "http://www.w3.org/2005/08/addressing";
	
КонецФункции

/// Пространство имен http://schemas.xmlsoap.org/wsdl/
Функция wsdl() Экспорт
	
	Возврат "http://schemas.xmlsoap.org/wsdl/";
	
КонецФункции

/// Пространство имен http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd
Функция wsse() Экспорт
	
	Возврат "http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd";
	
КонецФункции

/// Пространство имен http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd
Функция wsu() Экспорт
	
	Возврат "http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd";
	
КонецФункции

/// Пространство имен http://www.w3.org/2001/XMLSchema
Функция xs() Экспорт
	
	Возврат "http://www.w3.org/2001/XMLSchema";
	
КонецФункции

/// Пространство имен http://www.w3.org/2001/XMLSchema-instance
Функция xsi() Экспорт
	
	Возврат "http://www.w3.org/2001/XMLSchema-instance";
	
КонецФункции


#КонецОбласти
