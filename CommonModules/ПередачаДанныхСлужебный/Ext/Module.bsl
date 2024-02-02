﻿#Область СлужебныйПрограммныйИнтерфейс

Процедура ПриОпределенииПоддерживаемыхВерсийПрограммныхИнтерфейсов(Знач СтруктураПоддерживаемыхВерсий) Экспорт
	
	МассивВерсий = Новый Массив;
	МассивВерсий.Добавить("1.0.1.1");
	СтруктураПоддерживаемыхВерсий.Вставить("DataTransfer", МассивВерсий);
	
КонецПроцедуры

Функция Получить(ПараметрыДоступа, ИзФизическогоХранилища = Ложь, ИдентификаторХранилища, Идентификатор, Диапазон = Неопределено, ИмяФайла = Неопределено) Экспорт
	
	Доступ = ПолучитьДоступКФайлу(ПараметрыДоступа, ИзФизическогоХранилища, ИдентификаторХранилища, Идентификатор);
	
	Если Доступ = Неопределено Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Доступ.АдресS3) Тогда
		Возврат ПолучитьS3(Доступ.АдресS3, Диапазон, ИмяФайла);
	Иначе
		Возврат ПолучитьDT(ПараметрыДоступа, Доступ.Адрес, Доступ.Куки, Диапазон, ИмяФайла);	
	КонецЕсли;
	
КонецФункции

Функция ПолучитьРазмерФайла(ПараметрыДоступа, ИзФизическогоХранилища = Ложь, ИдентификаторХранилища, Идентификатор) Экспорт
	
	Доступ = ПолучитьДоступКФайлу(ПараметрыДоступа, ИзФизическогоХранилища, ИдентификаторХранилища, Идентификатор);
	
	Если Доступ = Неопределено Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Если Доступ.Размер = Неопределено Тогда
		Если ЗначениеЗаполнено(Доступ.АдресS3) Тогда
			СтруктураURI = СтруктураURI(Доступ.АдресS3);
			Соединение = СоединениеS3(СтруктураURI);
			Запрос = Новый HTTPЗапрос(СтруктураURI.ПутьНаСервере);
			Запрос.Заголовки.Вставить("Range", "bytes=0-0");
			Ответ = Соединение.Получить(Запрос);
			Если Ответ.КодСостояния <> 206 Тогда
				ОшибкаПриПолученииДанных(Ответ);
				Возврат Неопределено;
			КонецЕсли;
			Возврат Число(СтрРазделить(ПолучитьЗаголовок(Ответ, "Content-Range"), "/")[1]);
		Иначе
		    СтруктураURI = СтруктураURI(Доступ.Адрес);
			Соединение = СоединениеDT(СтруктураURI, ПараметрыДоступа.UserName, ПараметрыДоступа.Password);
			ЗапросДанных = Новый HTTPЗапрос(СтруктураURI.ПутьНаСервере);
			Если ЗначениеЗаполнено(Доступ.Куки) Тогда
				ЗапросДанных.Заголовки.Вставить("Cookie", Доступ.Куки);
			КонецЕсли;
			
			ЗапросДанных.Заголовки.Вставить("Range", "bytes=0-0");
			Ответ = Соединение.Получить(ЗапросДанных);
			Если Ответ.КодСостояния <> 206 Тогда
				ОшибкаПриПолученииДанных(Ответ);
				Возврат Неопределено;
			КонецЕсли;
			Возврат Число(СтрРазделить(ПолучитьЗаголовок(Ответ, "Content-Range"), "/")[1]);			
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат Доступ.Размер;
	
КонецФункции

Функция Отправить(ПараметрыДоступа, ВФизическоеХранилище = Ложь, ИдентификаторХранилища, Данные, Знач ИмяФайла, ДополнительныеПараметры = Неопределено) Экспорт
	
	ПараметрыОтправки = НачатьОтправку(ПараметрыДоступа, ВФизическоеХранилище, ИдентификаторХранилища, Данные, ИмяФайла, ДополнительныеПараметры);
	
	Если ПараметрыОтправки = Неопределено Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	РазмерБлокаОтправкиДанных = РазмерБлокаОтправкиДанных();	
	
	Адрес = ?(ЗначениеЗаполнено(ПараметрыОтправки.АдресS3), ПараметрыОтправки.АдресS3, ПараметрыОтправки.Location);
	
	СтруктураURI = СтруктураURI(Адрес);
	
	Если ЗначениеЗаполнено(ПараметрыОтправки.АдресS3) Тогда
		Соединение = СоединениеS3(СтруктураURI);
	Иначе
		Соединение = СоединениеDT(СтруктураURI, ПараметрыДоступа.UserName, ПараметрыДоступа.Password);
	КонецЕсли;
	
	ЗапросДанных = Новый HTTPЗапрос(СтруктураURI.ПутьНаСервере);
	Если ЗначениеЗаполнено(ПараметрыОтправки.SetCookie) Тогда
		ЗапросДанных.Заголовки.Вставить("Cookie", ПараметрыОтправки.SetCookie);
	КонецЕсли;
	
	Если РазмерБлокаОтправкиДанных > 0 
		И ПараметрыОтправки.ПередачаЧастями Тогда
		
		Возврат ОтправитьЧастьФайла(ПараметрыДоступа, ПараметрыОтправки, Данные, Истина, 0);
		
	Иначе
		
		Если ЭтоАдресВременногоХранилища(Данные) Тогда
			
			ДвоичныеДанные = ПолучитьИзВременногоХранилища(Данные);
			РазмерФайла = ДвоичныеДанные.Размер();
			ЗапросДанных.УстановитьТелоИзДвоичныхДанных(ДвоичныеДанные);
			
		ИначеЕсли ТипЗнч(Данные) = Тип("Строка") Тогда
			
			Файл = Новый Файл(Данные);
			РазмерФайла = Файл.Размер();
			ЗапросДанных.УстановитьИмяФайлаТела(Данные);
			
		ИначеЕсли ТипЗнч(Данные) = Тип("Файл") Тогда
			
			РазмерФайла = Данные.Размер();
			ЗапросДанных.УстановитьИмяФайлаТела(Данные.ПолноеИмя);
			
		ИначеЕсли ТипЗнч(Данные) = Тип("ДвоичныеДанные") Тогда
			
			РазмерФайла = Данные.Размер();
			ЗапросДанных.УстановитьТелоИзДвоичныхДанных(Данные);
			
		КонецЕсли;
		
		Если ЗначениеЗаполнено(ПараметрыОтправки.SetCookie) Тогда
			ЗапросДанных.Заголовки.Вставить("IBSession", "finish");
		КонецЕсли;
		
		ЗапросДанных.Заголовки.Вставить("Content-Length", Формат(РазмерФайла, "ЧГ=0"));
		ЗапросДанных.Заголовки.Вставить("Transfer-Encoding", Неопределено);
		
		ОтветНаЗапросДанных = Соединение.Записать(ЗапросДанных);
		
		Результат = Неопределено;
		
		Если ОтветНаЗапросДанных.КодСостояния = 201 Тогда
			
			ЧтениеJSON = Новый ЧтениеJSON;
			ЧтениеJSON.УстановитьСтроку(ОтветНаЗапросДанных.ПолучитьТелоКакСтроку());
			ДанныеОтвета = ПрочитатьJSON(ЧтениеJSON);
			
			Если ДанныеОтвета.Количество() = 1 И ДанныеОтвета.Свойство("id") Тогда
				
				Результат = ДанныеОтвета.id;
				
			Иначе
				
				Результат = ДанныеОтвета;
				
			КонецЕсли;
			
		ИначеЕсли ОтветНаЗапросДанных.КодСостояния = 200 Тогда
			
			Результат = ПараметрыОтправки.ИдентификаторФайлаS3;
			
		Иначе
			
			ОшибкаПриОтправкеДанных(ОтветНаЗапросДанных);
			
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

Функция НачатьОтправку(ПараметрыДоступа, ВФизическоеХранилище = Ложь, ИдентификаторХранилища, Данные, Знач ИмяФайла, ДополнительныеПараметры = Неопределено) Экспорт
	
	СтруктураURIДоступа = СтруктураURI(ПараметрыДоступа.URL);
	Соединение = СоединениеDT(СтруктураURIДоступа, ПараметрыДоступа.UserName, ПараметрыДоступа.Password);
	
	Если ВФизическоеХранилище Тогда
		
		АдресРесурсаШаблон = "/hs/dt/volume/%1/%2";
		
	Иначе
		
		АдресРесурсаШаблон = "/hs/dt/storage/%1/%2";
		
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(ИмяФайла) И ТипЗнч(Данные) = Тип("Файл") Тогда
		
		ИмяФайла = Данные.Имя;
		
	ИначеЕсли НЕ ЗначениеЗаполнено(ИмяФайла) Тогда
		
		ФайлОбъект = Новый Файл(ПолучитьИмяВременногоФайла());
		ИмяФайла = ФайлОбъект.Имя;
		
	КонецЕсли;
	
	АдресРесурса = СтруктураURIДоступа.ПутьНаСервере + СтрШаблон(АдресРесурсаШаблон, ИдентификаторХранилища, ИмяФайла);
	
	ЗапросРесурса = Новый HTTPЗапрос(АдресРесурса);
	ЗапросРесурса.Заголовки.Вставить("IBSession", "start");
	
	Если ДополнительныеПараметры <> Неопределено Тогда
		ЗаписьJSON = Новый ЗаписьJSON;
		ЗаписьJSON.УстановитьСтроку();
		ЗаписатьJSON(ЗаписьJSON, ДополнительныеПараметры);
		Тело = ЗаписьJSON.Закрыть();
		ЗапросРесурса.УстановитьТелоИзСтроки(Тело);
	КонецЕсли;
	
	ОтветНаЗапросРесурса = Соединение.ОтправитьДляОбработки(ЗапросРесурса);
	
	Если ОтветНаЗапросРесурса.КодСостояния = 400 Тогда
		
		ЗапросРесурса.Заголовки.Удалить("IBSession");
		ОтветНаЗапросРесурса = Соединение.ОтправитьДляОбработки(ЗапросРесурса);
		
	КонецЕсли;
	
	Если ОтветНаЗапросРесурса.КодСостояния <> 200 Тогда
		ОшибкаПриОтправкеДанных(ОтветНаЗапросРесурса);
		Возврат Неопределено;
	КонецЕсли;
	
	Доступ = Новый Структура;
	Доступ.Вставить("Location", ПолучитьЗаголовок(ОтветНаЗапросРесурса, "Location"));
	Доступ.Вставить("SetCookie", ПолучитьЗаголовок(ОтветНаЗапросРесурса, "Set-Cookie"));
	Доступ.Вставить("АдресS3", ПолучитьЗаголовок(ОтветНаЗапросРесурса, "x-url-s3"));
	Доступ.Вставить("ИдентификаторФайлаS3", ПолучитьЗаголовок(ОтветНаЗапросРесурса, "x-file-id"));
	Доступ.Вставить("ПередачаЧастями", ПолучитьЗаголовок(ОтветНаЗапросРесурса, "Accept-Ranges") = "bytes" И Не ЗначениеЗаполнено(Доступ.АдресS3));
	
	Возврат Доступ;
		
КонецФункции

Функция ОтправитьЧастьФайла(ПараметрыДоступа, ПараметрыОтправки, Данные, ПоследняяЧасть = Истина, Смещение = 0) Экспорт

	SetCookie = ПараметрыОтправки.SetCookie;
	СтруктураURI = СтруктураURI(ПараметрыОтправки.Location);
	Соединение = СоединениеDT(СтруктураURI, ПараметрыДоступа.UserName, ПараметрыДоступа.Password);
	ЗапросДанных = Новый HTTPЗапрос(СтруктураURI.ПутьНаСервере);
	Если ЗначениеЗаполнено(SetCookie) Тогда
		ЗапросДанных.Заголовки.Вставить("Cookie", SetCookie);
	Иначе
		ЗапросДанных.Заголовки.Вставить("IBSession", "start");
	КонецЕсли;
	
	РазмерБлока = РазмерБлокаОтправкиДанных();

	Если ЭтоАдресВременногоХранилища(Данные) Тогда

		ПотокДанных = ПолучитьИзВременногоХранилища(Данные).ОткрытьПотокДляЧтения();

	ИначеЕсли ТипЗнч(Данные) = Тип("Строка") Тогда

		ПотокДанных = ФайловыеПотоки.Открыть(Данные, РежимОткрытияФайла.Открыть, ДоступКФайлу.Чтение);

	ИначеЕсли ТипЗнч(Данные) = Тип("Файл") Тогда

		ПотокДанных = ФайловыеПотоки.Открыть(Данные.ПолноеИмя, РежимОткрытияФайла.Открыть, ДоступКФайлу.Чтение);

	ИначеЕсли ТипЗнч(Данные) = Тип("ДвоичныеДанные") Тогда

		ПотокДанных = Данные.ОткрытьПотокДляЧтения();

	КонецЕсли;
	
	Размер = Смещение + ПотокДанных.Размер();

	ОтправляемыйДиапазон = Новый Структура;
	ОтправляемыйДиапазон.Вставить("Начало", Смещение);
	ОтправляемыйДиапазон.Вставить("Конец", Смещение + Мин(РазмерБлока - 1, Размер - 1));

	Пока Истина Цикл

		Буфер = Новый БуферДвоичныхДанных(ОтправляемыйДиапазон.Конец - ОтправляемыйДиапазон.Начало + 1);
		Прочитано = ПотокДанных.Прочитать(Буфер, 0, Буфер.Размер);
		ЗапросДанных.УстановитьТелоИзДвоичныхДанных(ПолучитьДвоичныеДанныеИзБуфераДвоичныхДанных(Буфер));

		ЗапросДанных.Заголовки.Вставить("Content-Range", 
			СтрШаблон("bytes %1-%2/%3", 
				Формат(ОтправляемыйДиапазон.Начало, "ЧН=0; ЧГ=0"), 
				Формат(ОтправляемыйДиапазон.Начало + Прочитано - 1, "ЧН=0; ЧГ=0"), 
				Формат(Размер + ?(ПоследняяЧасть, 0, 1), "ЧН=0; ЧГ=0")));

		Если ОтправляемыйДиапазон.Конец = Размер - 1 И ЗначениеЗаполнено(SetCookie) Тогда

			ЗапросДанных.Заголовки.Вставить("IBSession", "finish");

		КонецЕсли;

		ОтветНаЗапросДанных = Соединение.Записать(ЗапросДанных);
		
		Если ОтветНаЗапросДанных.КодСостояния = 400 Тогда
			ЗапросДанных.Заголовки.Удалить("IBSession");
			ОтветНаЗапросДанных = Соединение.Записать(ЗапросДанных);
		КонецЕсли;
		
		Если ОтветНаЗапросДанных.КодСостояния = 201 Тогда

			ЧтениеJSON = Новый ЧтениеJSON;
			ЧтениеJSON.УстановитьСтроку(ОтветНаЗапросДанных.ПолучитьТелоКакСтроку());
			ДанныеОтвета = ПрочитатьJSON(ЧтениеJSON);
			
			ПотокДанных.Закрыть();
			
			Если ДанныеОтвета.Количество() = 1 И ДанныеОтвета.Свойство("id") Тогда

				Возврат ДанныеОтвета.id;

			Иначе

				Возврат ДанныеОтвета;

			КонецЕсли;

		ИначеЕсли ОтветНаЗапросДанных.КодСостояния <> 202 Тогда
			
			ПотокДанных.Закрыть();
			ОшибкаПриОтправкеДанных(ОтветНаЗапросДанных);
			Возврат Неопределено;

		КонецЕсли;
		
		ОтправляемыйДиапазон.Начало = ОтправляемыйДиапазон.Конец + 1;
		ОтправляемыйДиапазон.Конец = Мин(ОтправляемыйДиапазон.Конец + РазмерБлока, Размер - 1);
		
		Если ОтправляемыйДиапазон.Начало > ОтправляемыйДиапазон.Конец Тогда
			// все передано
			Возврат Размер;
		КонецЕсли;
		
		Если ЗначениеЗаполнено(ПолучитьЗаголовок(ОтветНаЗапросДанных, "Set-Cookie")) Тогда
			SetCookie = ПолучитьЗаголовок(ОтветНаЗапросДанных, "Set-Cookie");
			ЗапросДанных.Заголовки.Вставить("Cookie", SetCookie);
		КонецЕсли;

	КонецЦикла;
	
	Возврат Размер;

КонецФункции

Функция ПолученныйДиапазон(Запрос) Экспорт
	
	ContentRange = ПолучитьЗаголовок(Запрос, "Content-Range");
	
	Диапазон = Неопределено;
	ContentRange = СокрЛП(ContentRange);
	
	Если НЕ ПустаяСтрока(ContentRange) И СтрНачинаетсяС(ContentRange, "bytes ") Тогда
		
		ContentRange = Прав(ContentRange, СтрДлина(ContentRange) - СтрДлина("bytes "));
		МассивПодстрок = СтрРазделить(ContentRange, "/");
		Range = МассивПодстрок[0];
		Size = МассивПодстрок[1];
		МассивПодстрок = СтрРазделить(Range, "-");
		
		Попытка
			
			Начало = Число(МассивПодстрок[0]);
			Конец = Число(МассивПодстрок[1]);
			Размер = Число(Size);
			
			Диапазон = Новый Структура("Начало, Конец, Размер", Начало, Конец, Размер);
			
		Исключение
			
			Диапазон = Неопределено;
			
		КонецПопытки;
		
	КонецЕсли;
		
	Возврат Диапазон;
	
КонецФункции

Функция ПериодДействияВременногоИдентификатора() Экспорт
	
	ПериодДействияВременногоИдентификатора = 600; // 10 минут
	
	ПередачаДанныхВстраивание.ПериодДействияВременногоИдентификатора(ПериодДействияВременногоИдентификатора);
	ПередачаДанныхПереопределяемый.ПериодДействияВременногоИдентификатора(ПериодДействияВременногоИдентификатора);
	
	Возврат ПериодДействияВременногоИдентификатора;
	
КонецФункции

Функция РазмерБлокаПолученияДанных() Экспорт
	
	РазмерБлокаПолученияДанных = 1024 * 1024;
	
	ПередачаДанныхВстраивание.РазмерБлокаПолученияДанных(РазмерБлокаПолученияДанных);
	ПередачаДанныхПереопределяемый.РазмерБлокаПолученияДанных(РазмерБлокаПолученияДанных);
	
	Возврат РазмерБлокаПолученияДанных;

КонецФункции

Функция РазмерБлокаОтправкиДанных() Экспорт
	
	РазмерБлокаОтправкиДанных = 1024 * 1024;
	
	ПередачаДанныхВстраивание.РазмерБлокаОтправкиДанных(РазмерБлокаОтправкиДанных);
	ПередачаДанныхПереопределяемый.РазмерБлокаОтправкиДанных(РазмерБлокаОтправкиДанных);
	
	Возврат РазмерБлокаОтправкиДанных;

КонецФункции

Процедура ОшибкаПриПолученииДанных(Ответ) Экспорт
	
	ПередачаДанныхВстраивание.ОшибкаПриПолученииДанных(Ответ);
	ПередачаДанныхПереопределяемый.ОшибкаПриПолученииДанных(Ответ);
	
КонецПроцедуры

Процедура ОшибкаПриОтправкеДанных(Ответ) Экспорт
	
	ПередачаДанныхВстраивание.ОшибкаПриОтправкеДанных(Ответ);
	ПередачаДанныхПереопределяемый.ОшибкаПриОтправкеДанных(Ответ);
	
КонецПроцедуры

Функция ИмяВременногоФайла(Расширение = Неопределено, ДополнительныеПараметры = Неопределено) Экспорт
	
	ИмяВременногоФайла = ПолучитьИмяВременногоФайла(Расширение);
	ПередачаДанныхВстраивание.ПриПолученииИмениВременногоФайла(ИмяВременногоФайла, Расширение);
	ПередачаДанныхПереопределяемый.ПриПолученииИмениВременногоФайла(ИмяВременногоФайла, Расширение, ДополнительныеПараметры);
	
	Возврат ИмяВременногоФайла;
	
КонецФункции

Процедура ПриПродленииДействияВременногоИдентификатора(Идентификатор, МенеджерЗаписи) Экспорт
	
	ЧтениеJSON = Новый ЧтениеJSON;
	ЧтениеJSON.УстановитьСтроку(МенеджерЗаписи.Запрос.Получить());
	Запрос = ПрочитатьJSON(ЧтениеJSON, Истина);
	
	ПередачаДанныхВстраивание.ПриПродленииДействияВременногоИдентификатора(Идентификатор, МенеджерЗаписи.Дата, Запрос);
	ПередачаДанныхПереопределяемый.ПриПродленииДействияВременногоИдентификатора(Идентификатор, МенеджерЗаписи.Дата, Запрос);
	
КонецПроцедуры

Функция ПолучитьДвоичныеДанныеИзS3(Адрес, Начало = Неопределено, Конец = Неопределено) Экспорт
	
	СтруктураURI = СтруктураURI(Адрес);
	Соединение = СоединениеS3(СтруктураURI);
	
	Запрос = Новый HTTPЗапрос(СтруктураURI.ПутьНаСервере);
	Если Начало <> Неопределено Тогда
		Запрос.Заголовки.Вставить("Range", СтрШаблон("bytes=%1-%2", Формат(Начало, "ЧН=0; ЧГ=0"), Формат(Конец, "ЧН=0; ЧГ=0")));
	КонецЕсли;
	
	Ответ = Соединение.Получить(Запрос);
	
	Если Ответ.КодСостояния <> 200 И Ответ.КодСостояния <> 206 Тогда
		ВызватьИсключение СтрШаблон("%1: %2 %3", Ответ.КодСостояния, Символы.ПС, Лев(Ответ.ПолучитьТелоКакСтроку(), 128));
	КонецЕсли;
	
	Возврат Ответ.ПолучитьТелоКакДвоичныеДанные(); 
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция СтруктураURI(Знач СтрокаURI)
	
	СтрокаURI = СокрЛП(СтрокаURI);
	
	// Схема.
	Схема = "";
	Позиция = СтрНайти(СтрокаURI, "://");
	
	Если Позиция > 0 Тогда
		
		Схема = НРег(Лев(СтрокаURI, Позиция - 1));
		СтрокаURI = Сред(СтрокаURI, Позиция + 3);
		
	КонецЕсли;

	// Строка соединения и путь на сервере.
	СтрокаСоединения = СтрокаURI;
	ПутьНаСервере = "";
	Позиция = СтрНайти(СтрокаСоединения, "/");
	
	Если Позиция > 0 Тогда
		
		ПутьНаСервере = Сред(СтрокаСоединения, Позиция + 1);
		СтрокаСоединения = Лев(СтрокаСоединения, Позиция - 1);
		
	КонецЕсли;
		
	// Информация пользователя и имя сервера.
	СтрокаАвторизации = "";
	ИмяСервера = СтрокаСоединения;
	Позиция = СтрНайти(СтрокаСоединения, "@");
	
	Если Позиция > 0 Тогда
		
		СтрокаАвторизации = Лев(СтрокаСоединения, Позиция - 1);
		ИмяСервера = Сред(СтрокаСоединения, Позиция + 1);
		
	КонецЕсли;
	
	// Логин и пароль.
	Логин = СтрокаАвторизации;
	Пароль = "";
	Позиция = СтрНайти(СтрокаАвторизации, ":");
	
	Если Позиция > 0 Тогда
		
		Логин = Лев(СтрокаАвторизации, Позиция - 1);
		Пароль = Сред(СтрокаАвторизации, Позиция + 1);
		
	КонецЕсли;
	
	// Хост и порт.
	Хост = ИмяСервера;
	Порт = "";
	Позиция = СтрНайти(ИмяСервера, ":");
	
	Если Позиция > 0 Тогда
		
		Хост = Лев(ИмяСервера, Позиция - 1);
		Порт = Сред(ИмяСервера, Позиция + 1);
		
		Если Не ТолькоЦифрыВСтроке(Порт) Тогда
			Порт = "";
		ИначеЕсли Порт = "80" И Схема = "http" Тогда
			Порт = "";
		ИначеЕсли Порт = "443" И Схема = "https" Тогда
			Порт = "";
		КонецЕсли;
		
	КонецЕсли;
	
	Результат = Новый Структура;
	Результат.Вставить("Схема", Схема);
	Результат.Вставить("Логин", Логин);
	Результат.Вставить("Пароль", Пароль);
	Результат.Вставить("Хост", Хост);
	Результат.Вставить("Порт", ?(ПустаяСтрока(Порт), Неопределено, Число(Порт)));
	Результат.Вставить("ПутьНаСервере", ПутьНаСервере);
	
	Возврат Результат;
	
КонецФункции

Функция ТолькоЦифрыВСтроке(Знач СтрокаПроверки)
	
	Если ТипЗнч(СтрокаПроверки) <> Тип("Строка") Тогда
		
		Возврат Ложь;
		
	КонецЕсли;
	
	СтрокаПроверки = СтрЗаменить(СтрокаПроверки, " ", "");
		
	Если ПустаяСтрока(СтрокаПроверки) Тогда
		
		Возврат Истина;
		
	КонецЕсли;
	
	Цифры = "0123456789";
	
	Возврат СтрРазделить(СтрокаПроверки, Цифры, Ложь).Количество() = 0;
	
КонецФункции

Функция Соединение(СтруктураURI, Пользователь, Пароль, Таймаут)
	
	Возврат ПередачаДанныхПовтИсп.Соединение(СтруктураURI, Пользователь, Пароль, Таймаут);
	
КонецФункции

Функция СоединениеS3(СтруктураURI)
	
	Возврат Соединение(СтруктураURI, Неопределено, Неопределено, 7200);
	
КонецФункции

Функция СоединениеDT(СтруктураURI, Пользователь, Пароль)
	
	Возврат Соединение(СтруктураURI, Пользователь, Пароль, 180);
	
КонецФункции

Процедура УдалитьВременныйФайл(ИмяФайла)
	
	Файл = Новый Файл(ИмяФайла);
	Если Не Файл.Существует() Тогда
		Возврат;
	КонецЕсли;
	
	Попытка
		УдалитьФайлы(ИмяФайла);
	Исключение
		ЗаписьЖурналаРегистрации(НСтр("ru = 'ПередачаДанных'", ОбщегоНазначения.КодОсновногоЯзыка()), УровеньЖурналаРегистрации.Ошибка,,, ПередачаДанныхКлиентСервер.ПодробныйТекстОшибки(ИнформацияОбОшибке()));
	КонецПопытки;
	
КонецПроцедуры

Функция ПолучитьДоступКФайлу(ПараметрыДоступа, ИзФизическогоХранилища, ИдентификаторХранилища, Идентификатор)
	
	СтруктураURIДоступа = СтруктураURI(ПараметрыДоступа.URL);
	
	Если ИзФизическогоХранилища Тогда
		АдресРесурсаШаблон = "/hs/dt/volume/%1/%2";
	Иначе
		АдресРесурсаШаблон = "/hs/dt/storage/%1/%2";
	КонецЕсли;
	
	АдресРесурса = СтруктураURIДоступа.ПутьНаСервере + СтрШаблон(АдресРесурсаШаблон, ИдентификаторХранилища, Строка(Идентификатор));
	
	Если ПараметрыДоступа.Свойство("Кэш") Тогда
		Доступ = ПараметрыДоступа.Кэш.Получить(АдресРесурса);
		Если Доступ <> Неопределено И Доступ.Истекает > ТекущаяУниверсальнаяДата() Тогда
			Возврат Доступ;
		КонецЕсли;
	КонецЕсли;
	
	ЗапросРесурса = Новый HTTPЗапрос(АдресРесурса);
	ЗапросРесурса.Заголовки.Вставить("IBSession", "start");
	
	Соединение = СоединениеDT(СтруктураURIДоступа, ПараметрыДоступа.UserName, ПараметрыДоступа.Password);
	ОтветНаЗапросРесурса = Соединение.Получить(ЗапросРесурса);
	
	Если ОтветНаЗапросРесурса.КодСостояния = 400 Тогда
		
		ЗапросРесурса.Заголовки.Удалить("IBSession");
		ОтветНаЗапросРесурса = Соединение.Получить(ЗапросРесурса);
		
	КонецЕсли;
	
	Если ОтветНаЗапросРесурса.КодСостояния <> 302 Тогда
		ОшибкаПриПолученииДанных(ОтветНаЗапросРесурса);
		Возврат Неопределено;
	КонецЕсли;
		
	Доступ = Новый Структура;
	Доступ.Вставить("АдресS3", ПолучитьЗаголовок(ОтветНаЗапросРесурса, "x-url-s3"));
	Доступ.Вставить("Адрес", ПолучитьЗаголовок(ОтветНаЗапросРесурса, "Location"));
	Доступ.Вставить("Куки", ПолучитьЗаголовок(ОтветНаЗапросРесурса, "Set-Cookie"));
	Доступ.Вставить("Размер", ПолучитьЗаголовок(ОтветНаЗапросРесурса, "x-file-length"));
	Если Доступ.Размер <> Неопределено Тогда
		Доступ.Размер = Число(Доступ.Размер);
	КонецЕсли;
	Доступ.Вставить("ИмяФайла", ПолучитьЗаголовок(ОтветНаЗапросРесурса, "x-file-name"));
	
	Если ПараметрыДоступа.Свойство("Кэш") Тогда
		
		Если ЗначениеЗаполнено(Доступ.АдресS3) Тогда
			ПутьНаСервереS3 = СтруктураURI(Доступ.АдресS3).ПутьНаСервере;
			ПараметрыЗапроса = ПараметрыИзКодировкиURL(Сред(ПутьНаСервереS3, СтрНайти(ПутьНаСервереS3, "?")+1));
			ДатаПодписи = Дата(СтрЗаменить(СтрЗаменить(ПараметрыЗапроса["X-Amz-Date"], "T", ""), "Z", ""));
			СрокЖизни = Число(ПараметрыЗапроса["X-Amz-Expires"]);
			Истекает = ДатаПодписи + СрокЖизни - 900; // 15 минут погрешность в s3
			Доступ.Вставить("Истекает", Истекает);
			ПараметрыДоступа.Кэш.Вставить(АдресРесурса, Доступ);
		ИначеЕсли Не ЗначениеЗаполнено(Доступ.Куки) Тогда
			// Кэш используется только если не используется явное управление сеансами
			Доступ.Вставить("Истекает", ТекущаяУниверсальнаяДата() + 300); // В МС 10 минут, тут чтобы не было просрочен будет 5 минут.
			ПараметрыДоступа.Кэш.Вставить(АдресРесурса, Доступ);
		КонецЕсли;
	
	КонецЕсли;
	
	Возврат Доступ;
	
КонецФункции

Функция ПолучитьS3(АдресS3, Диапазон, ИмяФайла = Неопределено)
	
	СтруктураURI = СтруктураURI(АдресS3);
	Соединение = СоединениеS3(СтруктураURI);
	Запрос = Новый HTTPЗапрос(СтруктураURI.ПутьНаСервере);
	Если Диапазон <> Неопределено Тогда
		Если Диапазон.Начало >= 0 Тогда
			Запрос.Заголовки.Вставить("Range", СтрШаблон("bytes=%1-%2", Формат(Диапазон.Начало, "ЧН=0; ЧГ=0"), Формат(Диапазон.Конец, "ЧН=0; ЧГ=0")));
		Иначе
			Запрос.Заголовки.Вставить("Range", "bytes=0-0");
			Ответ = Соединение.Получить(Запрос);
			Если Ответ.КодСостояния <> 206 Тогда
				ОшибкаПриПолученииДанных(Ответ);
				Возврат Неопределено;
			КонецЕсли;
			РазмерФайла = Число(СтрРазделить(ПолучитьЗаголовок(Ответ, "Content-Range"), "/")[1]);	
			Запрос.Заголовки.Вставить("Range", СтрШаблон("bytes=%1-%2", Формат(РазмерФайла - 1 + Диапазон.Начало, "ЧН=0; ЧГ=0"), Формат(РазмерФайла - 1 + Диапазон.Конец, "ЧН=0; ЧГ=0")));
		КонецЕсли;
	КонецЕсли;
	
	Если ИмяФайла = Неопределено Тогда
		ИмяФайла = ПолучитьИмяВременногоФайла();
	КонецЕсли;
	
	ОтветНаЗапросДанных = Соединение.Получить(Запрос, ИмяФайла);
	
	Если ОтветНаЗапросДанных.КодСостояния = 200 Или ОтветНаЗапросДанных.КодСостояния = 206 Тогда
		СвойстваФайла = Новый Файл(ИмяФайла);
		Возврат Новый Структура("Имя, ПолноеИмя", СвойстваФайла.Имя, СвойстваФайла.ПолноеИмя);
	КонецЕсли;
	
	УдалитьВременныйФайл(ИмяФайла);
	ОшибкаПриПолученииДанных(ОтветНаЗапросДанных);
		
КонецФункции

Функция ПолучитьDT(ПараметрыДоступа, Адрес, Куки, Диапазон, ИмяФайла = Неопределено)
	
	ЗапрашиваемыйДиапазон = Неопределено;
	
	СтруктураURI = СтруктураURI(Адрес);
	Соединение = СоединениеDT(СтруктураURI, ПараметрыДоступа.UserName, ПараметрыДоступа.Password);
	ЗапросДанных = Новый HTTPЗапрос(СтруктураURI.ПутьНаСервере);
	Если ЗначениеЗаполнено(Куки) Тогда
		ЗапросДанных.Заголовки.Вставить("Cookie", Куки);
	КонецЕсли;
	
	РазмерБлокаПолученияДанных = РазмерБлокаПолученияДанных();
			
	Если РазмерБлокаПолученияДанных > 0 Или Диапазон <> Неопределено Тогда
		
		Если Диапазон = Неопределено Тогда
			ЗапрашиваемыйДиапазон = Новый Структура("Начало, Конец", 0, РазмерБлокаПолученияДанных - 1);
		Иначе
			ЗапрашиваемыйДиапазон = Новый Структура("Начало, Конец", Диапазон.Начало, Мин(Диапазон.Начало + РазмерБлокаПолученияДанных - 1, Диапазон.Конец));
		КонецЕсли;
		ЗапросДанных.Заголовки.Вставить("Range", СтрШаблон("bytes=%1-%2", Формат(ЗапрашиваемыйДиапазон.Начало, "ЧН=0; ЧГ=0"), Формат(ЗапрашиваемыйДиапазон.Конец, "ЧН=0; ЧГ=0")));	
	КонецЕсли;
		
	ОтветНаЗапросДанных = Соединение.Получить(ЗапросДанных);
	
	Если ОтветНаЗапросДанных.КодСостояния <> 200 И ОтветНаЗапросДанных.КодСостояния <> 206 Тогда
		ОшибкаПриПолученииДанных(ОтветНаЗапросДанных);
		Возврат Неопределено;
	КонецЕсли;
	
	Если ИмяФайла = Неопределено Тогда
		ИмяФайла = ПолучитьИмяВременногоФайла();
	КонецЕсли;	

	ПотокДанных = ФайловыеПотоки.Открыть(ИмяФайла, РежимОткрытияФайла.СоздатьНовый, ДоступКФайлу.Запись);
	Поток = ОтветНаЗапросДанных.ПолучитьТелоКакПоток();
	
	Если ОтветНаЗапросДанных.КодСостояния = 200 Тогда
		
		Поток.КопироватьВ(ПотокДанных);
		
	Иначе // ОтветНаЗапросДанных.КодСостояния = 206
		
		ПолученныйДиапазон = ПолученныйДиапазон(ОтветНаЗапросДанных);
		Если Диапазон <> Неопределено Тогда
			ПолученныйДиапазон.Размер = Диапазон.Конец + 1;
		КонецЕсли;
		Поток.КопироватьВ(ПотокДанных);
		
		Пока ПолученныйДиапазон.Конец < ПолученныйДиапазон.Размер - 1 Цикл
			
			ЗапрашиваемыйДиапазон = Новый Структура("Начало, Конец", ПолученныйДиапазон.Конец + 1, Мин(ПолученныйДиапазон.Конец + РазмерБлокаПолученияДанных, ПолученныйДиапазон.Размер - 1));
			
			Если ЗапрашиваемыйДиапазон.Конец = ПолученныйДиапазон.Размер - 1 И ЗначениеЗаполнено(Куки) Тогда
				
				ЗапросДанных.Заголовки.Вставить("IBSession", "finish");
				
			КонецЕсли;
			
			ЗапросДанных.Заголовки.Вставить("Range", СтрШаблон("bytes=%1-%2", Формат(ЗапрашиваемыйДиапазон.Начало, "ЧН=0; ЧГ=0"), Формат(ЗапрашиваемыйДиапазон.Конец, "ЧН=0; ЧГ=0")));
			ОтветНаЗапросДанных = Соединение.Получить(ЗапросДанных);
			
			Если ОтветНаЗапросДанных.КодСостояния = 206 Тогда
				
				Поток = ОтветНаЗапросДанных.ПолучитьТелоКакПоток();
				
				ПолученныйДиапазон = ПолученныйДиапазон(ОтветНаЗапросДанных);
				Если Диапазон <> Неопределено Тогда
					ПолученныйДиапазон.Размер = Диапазон.Конец + 1;
				КонецЕсли;
				
				Поток.КопироватьВ(ПотокДанных);
				
			Иначе
				
				УдалитьВременныйФайл(ИмяФайла);
				ОшибкаПриПолученииДанных(ОтветНаЗапросДанных);
				Возврат Неопределено;
				
			КонецЕсли;
			
		КонецЦикла;
		
	КонецЕсли;
	
	Поток.Закрыть();
	ПотокДанных.Закрыть();
	
	СвойстваФайла = Новый Файл(ИмяФайла);
	
	Возврат Новый Структура("Имя, ПолноеИмя", СвойстваФайла.Имя, СвойстваФайла.ПолноеИмя);
	
КонецФункции

Функция ПолучитьЗаголовок(ЗапросОтвет, Знач Заголовок)
	
	Заголовок = НРег(Заголовок);
	Для Каждого КлючИЗначение Из ЗапросОтвет.Заголовки Цикл
		Если НРег(КлючИЗначение.Ключ) = Заголовок Тогда
			Возврат КлючИЗначение.Значение;
		КонецЕсли;
	КонецЦикла;
	
	Возврат Неопределено;
	
КонецФункции

Функция ПараметрыИзКодировкиURL(СтрокаПараметров) 
	
	Параметры = Новый Соответствие;
	
	Если Не ПустаяСтрока(СтрокаПараметров) Тогда
		Для Каждого Параметр Из СтрРазделить(СтрокаПараметров, "&", Ложь) Цикл
			Части = СтрРазделить(Параметр, "=");
			Если Части.Количество() = 2 Тогда
				Параметры.Вставить(Части[0], РаскодироватьСтроку(Части[1], СпособКодированияСтроки.КодировкаURL));
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
	Возврат Параметры;
	
КонецФункции

#КонецОбласти
