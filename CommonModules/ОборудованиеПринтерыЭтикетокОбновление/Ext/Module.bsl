﻿
#Область СлужебныйПрограммныйИнтерфейс

// Добавляет в список поставляемые драйверы в составе конфигурации.
// 
// Параметры:
//  ДрайвераОборудования - см. МенеджерОборудования.НоваяТаблицаПоставляемыхДрайверовОборудования
//
Процедура ОбновитьПоставляемыеДрайвера(ДрайвераОборудования) Экспорт
	
	Драйвер = ДрайвераОборудования.Добавить();
	Драйвер.ТипОборудования = Перечисления.ТипыПодключаемогоОборудования.ПринтерЭтикеток;
	Драйвер.ИмяДрайвера  = "ДрайверГексагонПринтераЭтикеток";
	Драйвер.Наименование = НСтр("ru = 'Гексагон:Принтера этикеток Zebra,Proton,Toshiba-TEC,Datamax-O neil'", ОбщегоНазначения.КодОсновногоЯзыка());
	Драйвер.ИдентификаторОбъекта = "HexagonLabelPrinterDriver"; 
	Драйвер.ВерсияДрайвера = "3.3.1"; 
	
	Драйвер = ДрайвераОборудования.Добавить();
	Драйвер.ТипОборудования = Перечисления.ТипыПодключаемогоОборудования.ПринтерЭтикеток;
	Драйвер.ИмяДрайвера  = "ДрайверСканситиПринтераЭтикеток";
	Драйвер.Наименование = НСтр("ru = 'Скансити:Принтер печати этикеток TSC'", ОбщегоНазначения.КодОсновногоЯзыка());
	Драйвер.ИдентификаторОбъекта = "ScanCityTSC1C"; 
	Драйвер.ВерсияДрайвера = "1.0.0.42"; 
	
	Драйвер = ДрайвераОборудования.Добавить();
	Драйвер.ТипОборудования = Перечисления.ТипыПодключаемогоОборудования.ПринтерЭтикеток;
	Драйвер.ИмяДрайвера  = "ДрайверСканкодПринтераЭтикетокGodexEZPL8Native";
	Драйвер.Наименование = НСтр("ru = 'Сканкод:Принтера этикеток Godex EZPL8 (Native API)'", ОбщегоНазначения.КодОсновногоЯзыка());
	Драйвер.ИдентификаторОбъекта = "GodexEZPL8"; 
	Драйвер.ВерсияДрайвера = "1.0.0.46"; 
	
	Драйвер = ДрайвераОборудования.Добавить();
	Драйвер.ТипОборудования = Перечисления.ТипыПодключаемогоОборудования.ПринтерЭтикеток;
	Драйвер.ИмяДрайвера  = "ДрайверАтолПринтераЭтикеток";
	Драйвер.Наименование = НСтр("ru = 'АТОЛ:Принтера этикеток'", ОбщегоНазначения.КодОсновногоЯзыка());
	Драйвер.ИдентификаторОбъекта = "lp_atol1c8x3n"; 
	Драйвер.ВерсияДрайвера = "1.1.6.38"; 
	
КонецПроцедуры

#КонецОбласти
