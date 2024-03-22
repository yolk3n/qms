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
	
	ИмяПромежуточногоФайла = "D:\Для загрузки.xml";//ПолучитьИмяВременногоФайла("xml"); 

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

Функция ПолучитьXMLДляCreateUpdateProductWMHS(Номенклатура) Экспорт  
	
	СтруктураТиповEnvelopeBody = ПолучитьСтруктуруТиповEnvelopeBody();
	ТипCreateUpdateProductWMHS = СтруктураТиповEnvelopeBody.ТипBody.Свойства.Получить("CreateUpdateProductWMHS").Тип;
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
	
	ОбъектBodyXDTO = ФабрикаXDTO.Создать(СтруктураТиповEnvelopeBody.ТипBody); 
	ОбъектBodyXDTO.CreateUpdateProductWMHS = ОбъектXDTOCreateUpdateProductWMHS;
	 
	Возврат СоздатьЗаписатьВXMLОбъектEnvelopeXDTO(СтруктураТиповEnvelopeBody.ТипEnvelope, ОбъектBodyXDTO)
		
КонецФункции

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
			ПараметрыОтбора = Новый Структура("DocNum,DocDate,DocOTD",СтрокаДок.DocNum,СтрокаДок.DocDate,СтрокаДок.DocOTD);
			МассивСтрокСНоменклатурой = ТаблицаВыгрузки.НайтиСтроки(ПараметрыОтбора);
			СоздатьОбновитьДокумент(СтрокаДок, МассивСтрокСНоменклатурой);
		КонецЦикла;	
	КонецЕсли;
	
КонецПроцедуры

Функция ХэшДанных(ОбъектДанных) Экспорт
	
	Возврат ОбщегоНазначения.КонтрольнаяСуммаСтрокой(ОбъектДанных);
	
КонецФункции 

Функция НайтиДокумент(ИмяДокумента,НомерДокумента,ДатаДокумента,Отделение,ХэшДокумента)
	
	ПустаяСсылка = Документы[ИмяДокумента].ПустаяСсылка();
	СтруктураДанные = Новый Структура("ДокументСсылка, ХэшИзменен",ПустаяСсылка,Истина);
	Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(ПустаяСсылка,"НомерQMS") Тогда
		Запрос = Новый Запрос;
		Запрос.Текст = 
		"ВЫБРАТЬ ПЕРВЫЕ 1
		|	Документ.Ссылка КАК ДокументСсылка,
		|	ЕСТЬNULL(ДополнительныеСведения.Значение, """") КАК Хэш
		|ИЗ
		|	Документ."+ИмяДокумента+" КАК Документ
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ДополнительныеСведения КАК ДополнительныеСведения
		|		ПО Документ.Ссылка = ДополнительныеСведения.Объект
		|			И (ДополнительныеСведения.Свойство.Имя = ""ХэшДокументаQMS"")
		|ГДЕ
		|	Документ.НомерQMS = &НомерДокумента
		|	И НАЧАЛОПЕРИОДА(Документ.Дата, ДЕНЬ) = НАЧАЛОПЕРИОДА(&ДатаДокумента, ДЕНЬ)
		|	И Документ.Отделение = &Отделение"; 
		                                                       
		Запрос.УстановитьПараметр("НомерДокумента", НомерДокумента);
		Запрос.УстановитьПараметр("ДатаДокумента", СтроковыеФункцииКлиентСервер.СтрокаВДату(ДатаДокумента));
		Запрос.УстановитьПараметр("Отделение",ОбъектПоКоду(Отделение));
		
		РезультатЗапроса = Запрос.Выполнить();
		
		Выборка = РезультатЗапроса.Выбрать();
		
		Пока Выборка.Следующий() Цикл
			СтруктураДанные.ДокументСсылка = Выборка.ДокументСсылка;
			Если ХэшДокумента = Выборка.Хэш Тогда
				 СтруктураДанные.ХэшИзменен = Ложь;
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	Возврат СтруктураДанные;
	
КонецФункции 

Функция ПолучитьИмяДокумента(DocType) Экспорт
	
	Мэп = Новый Соответствие;
	
	Мэп.Вставить("списание без назначения","ВнутреннееПотреблениеТоваровВОтделении");
	Мэп.Вставить("акт списания","ВнутреннееПотреблениеТоваровВОтделении");
	Мэп.Вставить("списание на отделении","ВозвратТоваровИзОтделения");
	
	Возврат Мэп[DocType];
	
КонецФункции

Процедура СоздатьОбновитьДокумент(Шапка, ТаблицаНоменклатуры)
	
	//вычисление хэша
	ТаблицаДляХэша = СоздатьТаблицуДляХэша();
	Для Каждого Элемент Из ТаблицаНоменклатуры Цикл
		НовСтр = ТаблицаДляХэша.Добавить();
		ЗаполнитьЗначенияСвойств(НовСтр,Элемент);
		НовСтр.CategoryCode = Элемент.Category.ProductCode;
		НовСтр.FinanceCode = Элемент.Finance.FinanceCode;
		Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(НовСтр,"ProductSerial") И ТипЗнч(НовСтр.ProductSerial) = Тип("Строка") Тогда 
			НовСтр.ProductSerialString = НовСтр.ProductSerial;
		КонецЕсли;
	КонецЦикла;
	ХэшДокументаQMS = ХэшДанных(ТаблицаДляХэша);
	ИмяДокумента = ПолучитьИмяДокумента(Шапка.DocType);
	СтруктураПоиска = НайтиДокумент(ИмяДокумента,Шапка.DocNum,Шапка.DocDate,Шапка.DocOTD, ХэшДокументаQMS);
	
	Если ЗначениеЗаполнено(СтруктураПоиска.ДокументСсылка) Тогда 
		Если СтруктураПоиска.ХэшИзменен Тогда
			//обновляем документ
			ДокОбъект = СтруктураПоиска.ДокументСсылка.ПолучитьОбъект();
		Иначе
			Возврат;
		КонецЕсли;
	Иначе //создаем документ
		ДокОбъект = Документы[ИмяДокумента].СоздатьДокумент();
	КонецЕсли;

	Склад = ОбъектПоКоду(Шапка.DocSKL);
	Если ИмяДокумента = "ВнутреннееПотреблениеТоваровВОтделении" Тогда
		ДокОбъект.Склад = Склад;
		ДокОбъект.ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.СписаниеТоваровПоТребованию;
		ДокОбъект.ВидЦены = Справочники.ВидыЦен.НайтиПоНаименованию("Закупочная");
	ИначеЕсли ИмяДокумента = "ВозвратТоваровИзОтделения" Тогда
		ДокОбъект.СкладОтправитель = Склад;
		ДокОбъект.СкладПолучатель = Справочники.бит_НастройкиИнтеграцииQMS.СкладАптеки.Значение;
		ДокОбъект.ПодразделениеОрганизации = сок_Сервер.ПолучитьПодразделениеАптека();
	КонецЕсли;
	Организация = Справочники.бит_НастройкиИнтеграцииQMS.Организация.Значение;
	ДокОбъект.Организация = Организация;
	ДокОбъект.Отделение = ОбъектПоКоду(Шапка.DocOTD);
	ДокОбъект.НомерQMS = Шапка.DocNum;
	ДокОбъект.Дата = СтроковыеФункцииКлиентСервер.СтрокаВДату(Шапка.DocDate);
	ДокОбъект.Ответственный = ПараметрыСеанса.ТекущийПользователь;
	ДокОбъект.Автор = ПараметрыСеанса.ТекущийПользователь;
		
	ДокОбъект.Товары.Очистить();
	ИсточникФинансирования = Неопределено;
	Номенлатура1С = Неопределено;
	Для Каждого Строка Из ТаблицаНоменклатуры Цикл 
		СтруктураНоменклатура = СоздатьСтруктуруCategory();
		ЗаполнитьЗначенияСвойств(СтруктураНоменклатура,Строка.Category);
		НовСтр = ДокОбъект.Товары.Добавить();
		
		Номенлатура1С = Неопределено;
		МассивШтрихкодов = Новый Массив;
		Если ТипЗнч(СтруктураНоменклатура.BarcodeMain) = Тип("Строка") И СтруктураНоменклатура.BarcodeMain <> "" Тогда
			МассивШтрихкодов = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(СтрЗаменить(СтруктураНоменклатура.BarcodeMain,"_",""));
		Иначе
			Номенлатура1С = НайтиНоменклатуру("",СтруктураНоменклатура.ProductCode);
		КонецЕсли;
		
		Для Каждого Элемент Из МассивШтрихкодов Цикл
			Если ЗначениеЗаполнено(Номенлатура1С) Тогда
				Прервать;
			Иначе
				Номенлатура1С = НайтиНоменклатуру(Элемент,СтруктураНоменклатура.ProductCode);
			КонецЕсли;
		КонецЦикла;
								
		НовСтр.Номенклатура = Номенлатура1С;
		Если ЗначениеЗаполнено(Номенлатура1С) Тогда
			НовСтр.ЕдиницаИзмерения = Номенлатура1С.ОсновнаяЕдиницаУчета;
		КонецЕсли;
		НовСтр.КоличествоВЕдиницахИзмерения = СтроковыеФункцииКлиентСервер.СтрокаВЧисло(Строка.NumMax); 
		НовСтр.Количество =  СтроковыеФункцииКлиентСервер.СтрокаВЧисло(Строка.NumMin);
		НовСтр.Коэффициент = ?(НовСтр.КоличествоВЕдиницахИзмерения = 0, 0,
								НовСтр.Количество / НовСтр.КоличествоВЕдиницахИзмерения);
		НовСтр.СтатусУказанияСерий = 6;
		НовСтр.СтатусУказанияПартий = 4;
		Если ИмяДокумента = "ВнутреннееПотреблениеТоваровВОтделении" Тогда
			НовСтр.СтатьяРасходов = ?(Номенлатура1С.ЭтоЛекарственноеСредство,ПланыВидовХарактеристик.СтатьиРасходов.НайтиПоКоду("202"),
											ПланыВидовХарактеристик.СтатьиРасходов.НайтиПоКоду("203")); 
			НовСтр.АналитикаРасходов = Организация;
		ИначеЕсли ИмяДокумента = "ВозвратТоваровИзОтделения" Тогда
			НовСтр.СтатусУказанияПартийОтправитель = 4;
			НовСтр.СтатусУказанияПартийПолучатель = 4;
			НовСтр.СтатусУказанияСерийОтправитель = 6;
			НовСтр.СтатусУказанияСерийПолучатель = 6;
		КонецЕсли;
								
		Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(Строка,"ProductSerial") И ТипЗнч(Строка.ProductSerial) = Тип("Строка") Тогда
			НовСтр.СерияНоменклатуры = Справочники.СерииНоменклатуры.НайтиПоРеквизиту("Номер",Строка.ProductSerial);
			Если Не ЗначениеЗаполнено(НовСтр.СерияНоменклатуры) И ЗначениеЗаполнено(НовСтр.Номенклатура) Тогда
				 НовСтр.СерияНоменклатуры = СоздатьСериюНоменклатуры(НовСтр.Номенклатура,Строка.ProductSerial,Строка.ValidityPeriod);
			КонецЕсли;
		КонецЕсли;
		Если ИсточникФинансирования = Неопределено Тогда
			СтруктураИсточникФинансирования = СоздатьСтруктуруFinance();
			ЗаполнитьЗначенияСвойств(СтруктураИсточникФинансирования,Строка.Finance);
			ИсточникФинансирования = Справочники.ИсточникиФинансирования.НайтиПоКоду(СтруктураИсточникФинансирования.FinanceCode);
			ДокОбъект.ИсточникФинансирования = ИсточникФинансирования; 
		КонецЕсли;
		НовСтр.ИсточникФинансирования = ИсточникФинансирования;
		//подбор партии
		НовСтр.Партия = ПодобратьПартию(НовСтр.Номенклатура,НовСтр.СерияНоменклатуры,НовСтр.ЕдиницаИзмерения,НовСтр.КоличествоВЕдиницахИзмерения,
						Организация,Склад,ДокОбъект.Дата);
	КонецЦикла;
	СтруктураСообщенияЖурнала = бит_ИнтеграцияQMSВызовСервера.НоваяСтруктураСообщенияЖурнала();
	Попытка
		ДокОбъект.Записать(РежимЗаписиДокумента.Запись);
	Исключение
		СтруктураСообщенияЖурнала.Комментарий = ОписаниеОшибки();
		бит_ИнтеграцияQMSВызовСервера.ЗаписатьВЖурналРегистрации(СтруктураСообщенияЖурнала);
	КонецПопытки;
	
	МассивДокументов = Новый Массив;
	МассивДокументов.Добавить(ДокОбъект.Ссылка);
	Непроведенные = ОбщегоНазначения.ПровестиДокументы(МассивДокументов);
	Для Каждого Элемент Из Непроведенные Цикл
		СтруктураСообщенияЖурнала.Комментарий = Элемент.ОписаниеОшибки;
		бит_ИнтеграцияQMSВызовСервера.ЗаписатьВЖурналРегистрации(СтруктураСообщенияЖурнала);
	КонецЦикла;
		
	Если ДокОбъект.Проведен Тогда
		ЗаписатьХэшДокумента(ДокОбъект.Ссылка,ХэшДокументаQMS);
	КонецЕсли;
	
КонецПроцедуры 

Функция ПодобратьПартию(Номенклатура,СерияНоменклатуры,ЕдиницаИзмерения,Количество,Организация,Склад,ДатаДокумента)
	
	Запрос = Новый Запрос;
	ТекстЗапроса = "ВЫБРАТЬ ПЕРВЫЕ 1
	               |	Товары.Партия КАК Партия,
	               |	АналитикаПартий.ДокументОприходования КАК Документ,
	               |	АналитикаПартий.Поставщик КАК Поставщик,
	               |	Товары.ВНаличииОстаток / ЕСТЬNULL(ЕдиницыИзмерения.Коэффициент, 1) КАК Остаток
	               |ИЗ
	               |	РегистрНакопления.СвободныеОстатки.Остатки(
	               |			&КонецПериода,
	               |			Партия <> ЗНАЧЕНИЕ(Справочник.ПартииНоменклатуры.ПустаяСсылка)
	               |				И Организация = &Организация
	               |				И Номенклатура = &Номенклатура
	               |				И СерияНоменклатуры В (&СерияНоменклатуры, ЗНАЧЕНИЕ(Справочник.СерииНоменклатуры.ПустаяСсылка))
	               |				И Склад = &Склад) КАК Товары
	               |		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.АналитикаУчетаПартий КАК АналитикаПартий
	               |		ПО Товары.Партия = АналитикаПартий.КлючАналитики
	               |		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ЕдиницыИзмеренияНоменклатуры КАК ЕдиницыИзмерения
	               |		ПО (ЕдиницыИзмерения.Номенклатура = &Номенклатура)
	               |			И (ЕдиницыИзмерения.ЕдиницаИзмерения = &ЕдиницаИзмерения)
	               |ГДЕ
	               |	Товары.ВНаличииОстаток / ЕСТЬNULL(ЕдиницыИзмерения.Коэффициент, 1) >= &Количество
	               |
	               |УПОРЯДОЧИТЬ ПО
	               |	Товары.Партия.ДокументОприходования.Дата";
	
	Запрос.Текст = ТекстЗапроса;
	Запрос.УстановитьПараметр("КонецПериода", ДатаДокумента);
	Запрос.УстановитьПараметр("Организация", Организация);
	Запрос.УстановитьПараметр("Склад", Склад);
	Запрос.УстановитьПараметр("Номенклатура", Номенклатура);
	Запрос.УстановитьПараметр("СерияНоменклатуры", СерияНоменклатуры);
	Запрос.УстановитьПараметр("ЕдиницаИзмерения", ЕдиницаИзмерения);
	Запрос.УстановитьПараметр("Количество", Количество);
	
	Выборка = Запрос.Выполнить().Выбрать();
	Возврат ?(Выборка.Следующий(),Выборка.Партия,Неопределено);
	
КонецФункции     

Функция НайтиНоменклатуру(Штрихкод, Код)
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	Номенклатура.Ссылка КАК Номенклатура
		|ИЗ
		|	Справочник.РегистрЛекарственныхСредств КАК РегистрЛекарственныхСредств
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.Номенклатура КАК Номенклатура
		|		ПО РегистрЛекарственныхСредств.Ссылка = Номенклатура.ЭлементКАТ
		|ГДЕ
		|	&Штрихкод <> """"
		|	И ВЫРАЗИТЬ(РегистрЛекарственныхСредств.Штрихкод КАК СТРОКА(300)) ПОДОБНО ""%"" + &Штрихкод + ""%""
		|
		|ОБЪЕДИНИТЬ
		|
		|ВЫБРАТЬ
		|	ШтрихкодыНоменклатуры.Номенклатура
		|ИЗ
		|	РегистрСведений.ШтрихкодыНоменклатуры КАК ШтрихкодыНоменклатуры
		|ГДЕ
		|	(ВЫРАЗИТЬ(ШтрихкодыНоменклатуры.Штрихкод КАК СТРОКА(50))) = &Штрихкод
		|
		|ОБЪЕДИНИТЬ
		|
		|ВЫБРАТЬ
		|	Номенклатура.Ссылка
		|ИЗ
		|	Справочник.Номенклатура КАК Номенклатура
		|ГДЕ
		|	Номенклатура.Код = &Код";
	
	Запрос.УстановитьПараметр("Штрихкод", Штрихкод);
	Запрос.УстановитьПараметр("Код", Код);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Выборка = РезультатЗапроса.Выбрать();
	
	Если Выборка.Следующий() Тогда 
		Возврат Выборка.Номенклатура;
	Иначе
		Возврат Неопределено;
	КонецЕсли;
	
КонецФункции

Функция СоздатьСериюНоменклатуры(Номенклатура, НомерСерии, ГоденДо)
	
	СпрОбъект = Справочники.СерииНоменклатуры.СоздатьЭлемент();
	СпрОбъект.Владелец = Номенклатура;
	СпрОбъект.Номер = НомерСерии;
	СпрОбъект.ГоденДо = СтроковыеФункцииКлиентСервер.СтрокаВДату(ГоденДо);
	Попытка
		СпрОбъект.Записать();
	Исключение
		
	КонецПопытки;
	
	Возврат СпрОбъект.Ссылка;
	
КонецФункции

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
    ТЗ.Колонки.Добавить("ProductSerialString");
	ТЗ.Колонки.Добавить("NumMin");
    ТЗ.Колонки.Добавить("NumMax");
	ТЗ.Колонки.Добавить("Barcode");
    ТЗ.Колонки.Добавить("ValidityPeriod");
	ТЗ.Колонки.Добавить("DocNum");
    ТЗ.Колонки.Добавить("DocDate");
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
		//Выгрузка номенклатуры в QMS
		Если ТипЗнч(ОбъектКОбмену) = Тип("СправочникОбъект.Номенклатура") Тогда  
			ФайлXML = ПолучитьXMLДляCreateUpdateProductWMHS(ОбъектКОбмену.Ссылка); 
			Ответ = КлиентHTTPКлиентСервер.ОтправитьФайл(АдресСервераQMS, ФайлXML, ДополнительныеПараметры);
			ТелоОтвета = Ответ.Тело.Body.CreateUpdateProductWMHSResponse.Response;
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
КонецПроцедуры

// Функция - Получает код объекта 
// Параметры:
//  Объект - 	 СправочникСсылка.ОтделенияОрганизаций, СправочникСсылка.Склады, СправочникСсылка.ПодразделенияОрганизаций, СправочникСсылка.Организации 
// Возвращаемое значение:
//   -    Строка - Код объектаQMS
//
Функция КодОбъекта(Объект) Экспорт
	
	Возврат РегистрыСведений.бит_СоответствияОбъектовУчетаQMS.ПолучитьКодОбъекта(Объект)

КонецФункции 

Функция ОбъектПоКоду(Код) Экспорт
	
	Возврат РегистрыСведений.бит_СоответствияОбъектовУчетаQMS.ПолучитьОбъектПоКоду(Код);
КонецФункции

Процедура ЗаписатьХэшДокумента(ДокументСсылка,СтрокаХэша)

	МЗ = РегистрыСведений.ДополнительныеСведения.СоздатьМенеджерЗаписи();
	МЗ.Объект = ДокументСсылка;
	МЗ.Свойство = ПланыВидовХарактеристик.ДополнительныеРеквизитыИСведения.НайтиПоРеквизиту("Имя","ХэшДокументаQMS");
	МЗ.Значение = СтрокаХэша;
	МЗ.Записать(Истина);
	
КонецПроцедуры

//тест














