﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2019, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// Подсистема "Интернет-поддержка пользователей".
// ОбщийМодуль.ИнтернетПоддержкаПользователейКлиентСервер.
//
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Возвращает номер версии библиотеки.
//
// Возвращаемое значение:
//  Строка - номер версии библиотеки.
//
Функция ВерсияБиблиотеки() Экспорт
	
	Возврат "2.4.1.36";
	
КонецФункции

// Возвращает идентификатор поставщика услуг "Портал 1С:ИТС"
// для интеграции с подсистемой "Управление тарифами в модели
// сервиса" библиотеки "Технология сервиса".
//
// Возвращаемое значение:
//	Строка - идентификатор поставщика услуг.
//
Функция ИдентификаторПоставщикаУслугПортал1СИТС() Экспорт
	
	Возврат "Portal1CITS";
	
КонецФункции

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

#Область ОбщегоНазначения

// Подставляет в текст домен серверов ИПП в соответствии с текущими
// настройками подключения к серверам.
//
Функция ПодставитьДомен(Текст, Знач ДоменнаяЗона = Неопределено) Экспорт

	Если ДоменнаяЗона = 1 Тогда
		Результат = СтрЗаменить(Текст, "webits-info@1c.ru", "webits-info@1c.ua");
		Возврат СтрЗаменить(Результат, ".1c.ru", ".1c.eu");
	Иначе
		Возврат Текст;
	КонецЕсли;

КонецФункции

// Возвращает строковое представление размера файла.
//
Функция ПредставлениеРазмераФайла(Знач Размер) Экспорт

	Если Размер < 1024 Тогда
		Возврат Формат(Размер, "ЧДЦ=1") + " " + НСтр("ru = 'байт'");
	ИначеЕсли Размер < 1024 * 1024 Тогда
		Возврат Формат(Размер / 1024, "ЧДЦ=1") + " " + НСтр("ru = 'КБ'");
	ИначеЕсли Размер < 1024 * 1024 * 1024 Тогда
		Возврат Формат(Размер / (1024 * 1024), "ЧДЦ=1") + " " + НСтр("ru = 'МБ'");
	Иначе
		Возврат Формат(Размер / (1024 * 1024 * 1024), "ЧДЦ=1") + " " + НСтр("ru = 'ГБ'");
	КонецЕсли;

КонецФункции

// Преобразует переданную строку:
// в форматированную строку, если строка начинается с "<body>" и заканчивается "</body>";
// В противном случае строка остается без изменений.
//
Функция ФорматированныйЗаголовок(ТекстСообщения) Экспорт

	Если Лев(ТекстСообщения, 6) <> "<body>" Тогда
		Возврат ТекстСообщения;
	Иначе
		#Если ВебКлиент Тогда
		Возврат ИнтернетПоддержкаПользователейВызовСервера.ФорматированнаяСтрокаИзHTML(ТекстСообщения);
		#Иначе
		Возврат ФорматированнаяСтрокаИзHTML(ТекстСообщения);
		#КонецЕсли
	КонецЕсли;

КонецФункции

Функция URLСтраницыСервисаLogin(Путь = "", Знач НастройкиСоединения = Неопределено) Экспорт
	
	Если НастройкиСоединения = Неопределено Тогда
		Домен = 0;
	Иначе
		Домен = НастройкиСоединения.ДоменРасположенияСерверовИПП;
	КонецЕсли;
	Возврат "https://"
		+ ХостСервисаLogin(Домен)
		+ Путь;
	
КонецФункции

Функция URLСтраницыПорталаПоддержки(Путь = "", Знач Домен = Неопределено) Экспорт
	
	Если Домен = Неопределено Тогда
		Домен = 0;
	КонецЕсли;
	Возврат "https://"
		+ ХостПорталаПоддержки(Домен)
		+ Путь;
	
КонецФункции

Функция ПредставлениеРасписания(Расписание) Экспорт

	Если Расписание = Неопределено Тогда
		Возврат НСтр("ru = 'Настроить расписание'");
	Иначе
		Если ТипЗнч(Расписание) = Тип("Структура") Тогда
			Возврат Строка(ОбщегоНазначенияКлиентСервер.СтруктураВРасписание(Расписание));
		Иначе
			Возврат Строка(Расписание);
		КонецЕсли;
	КонецЕсли;

КонецФункции

Функция НормализованнаяСтрокаXML(Знач Текст) Экспорт
	
	Результат = СтрЗаменить(Текст,     "&",  "&amp;");
	Результат = СтрЗаменить(Результат, """", "&quot;");
	Результат = СтрЗаменить(Результат, "'",  "&apos;");
	Результат = СтрЗаменить(Результат, "<",  "&lt;");
	Результат = СтрЗаменить(Результат, ">",  "&gt;");
	Возврат Результат;
	
КонецФункции

#КонецОбласти

#Область ОбработкаСтрок

// Функция приводит переданную строку к внутреннему формату версии:
//  - приводит к формату 99.99.999.9999;
//  - заменяет пробелы на нули;
//  - если пробел в конце, то сдвигает число направо (" 17 ", "  17", "17  " -> "0017").
//
// Параметры:
//  Версия  - Строка - Строка, которую необходимо преобразовать.
//
// Возвращаемое значение:
//   Строка - версия правильного вида, формата 99.99.999.9999.
//
Функция ВнутреннееПредставлениеНомераВерсии(Версия) Экспорт

	НовыйМассивЧиселВерсии = Новый Массив(4);
	МассивЧиселВерсии = СтрРазделить(Версия, ".", Истина);
	Для С=1 По 4 Цикл
		НовыйМассивЧиселВерсии[С-1] = 0;
		Если МассивЧиселВерсии.Количество() >= С Тогда
			// Преобразование "Число" выполняется без попытки/исключения, а значит если в номере версии есть символы, отличные от цифр,
			//  то будет исключение.
			НовыйМассивЧиселВерсии[С-1] = ?(ПустаяСтрока(МассивЧиселВерсии[С-1]), 0, Число(СокрЛП(МассивЧиселВерсии[С-1])));
		КонецЕсли;
	КонецЦикла;

	НоваяВерсия = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		"%1.%2.%3.%4",
		Формат(НовыйМассивЧиселВерсии[0], "ЧЦ=2; ЧН=00; ЧВН=; ЧГ=0"),
		Формат(НовыйМассивЧиселВерсии[1], "ЧЦ=2; ЧН=00; ЧВН=; ЧГ=0"),
		Формат(НовыйМассивЧиселВерсии[2], "ЧЦ=3; ЧН=000; ЧВН=; ЧГ=0"),
		Формат(НовыйМассивЧиселВерсии[3], "ЧЦ=4; ЧН=0000; ЧВН=; ЧГ=0"));

	Возврат НоваяВерсия;

КонецФункции

// Функция из версии формата 99.99.999.9999 удаляет лидирующие нули, чтобы 08.02.019.0080 выглядело как 8.2.19.80.
//
// Параметры:
//  Версия - Строка - строка формата 99.99.999.9999, в которой необходимо удалить лидирующие нули;
//  СокращатьРазрядностьВерсии - Булево - разрешить сокращать версию (завершающуюся на 0000/000/00 или 9999/999/99) в следующих случаях:
//                    А.00.000.0000 = А,
//                    А.Б.000.0000 = А.Б,
//                    А.Б.В.0000 = А.Б.В,
//                    А.99.999.9999 = А.*,
//                    А.Б.999.9999 = А.Б.*,
//                    А.Б.В.9999 = А.Б.В.*.
//
// Возвращаемое значение:
//   Строка - удобочитаемое представление версии.
//
Функция ПользовательскоеПредставлениеНомераВерсии(Версия, СокращатьРазрядностьВерсии = Ложь) Экспорт

	Результат = "";

	Если СокращатьРазрядностьВерсии = Истина Тогда

		Версии = СтрЗаменить(Версия, ".", Символы.ПС);
		Если СтрЧислоСтрок(Версии) <> 4 Тогда
			Результат = Версия; // оставить как есть
		Иначе
			Версия1 = СтрПолучитьСтроку(Версии, 1);
			Версия2 = СтрПолучитьСтроку(Версии, 2);
			Версия3 = СтрПолучитьСтроку(Версии, 3);
			Версия4 = СтрПолучитьСтроку(Версии, 4);
			Если (Версия2 = "00") И (Версия3 = "000") И (Версия4 = "0000") Тогда
				// А.00.000.0000 = А
				Результат =
					Формат(Число(Версия1), "ЧЦ=4; ЧДЦ=0; ЧН=0; ЧГ=0");
			ИначеЕсли (СтрПолучитьСтроку(Версии, 3) = "000") И (СтрПолучитьСтроку(Версии, 4) = "0000") Тогда
				// А.Б.000.0000 = А.Б
				Результат =
					Формат(Число(Версия1), "ЧЦ=4; ЧДЦ=0; ЧН=0; ЧГ=0")
					+ "." + Формат(Число(Версия2), "ЧЦ=4; ЧДЦ=0; ЧН=0; ЧГ=0");
			ИначеЕсли (СтрПолучитьСтроку(Версии, 4) = "0000") Тогда
				// А.Б.В.0000 = А.Б.В
				Результат =
					Формат(Число(Версия1), "ЧЦ=4; ЧДЦ=0; ЧН=0; ЧГ=0")
					+ "." + Формат(Число(Версия2), "ЧЦ=4; ЧДЦ=0; ЧН=0; ЧГ=0")
					+ "." + Формат(Число(Версия3), "ЧЦ=4; ЧДЦ=0; ЧН=0; ЧГ=0");
			ИначеЕсли (Версия2 = "99") И (Версия3 = "999") И (Версия4 = "9999") Тогда
				// А.99.999.9999 = А.*
				Результат =
					Формат(Число(Версия1), "ЧЦ=4; ЧДЦ=0; ЧН=0; ЧГ=0")
					+ ".*";
			ИначеЕсли (Версия3 = "999") И (Версия4 = "9999") Тогда
				// А.Б.999.9999 = А.Б.*
				Результат =
					Формат(Число(Версия1), "ЧЦ=4; ЧДЦ=0; ЧН=0; ЧГ=0")
					+ "." + Формат(Число(Версия2), "ЧЦ=4; ЧДЦ=0; ЧН=0; ЧГ=0")
					+ ".*";
			ИначеЕсли (Версия4 = "9999") Тогда
				// А.Б.В.9999 = А.Б.В.*
				Результат =
					Формат(Число(Версия1), "ЧЦ=4; ЧДЦ=0; ЧН=0; ЧГ=0")
					+ "." + Формат(Число(Версия2), "ЧЦ=4; ЧДЦ=0; ЧН=0; ЧГ=0")
					+ "." + Формат(Число(Версия3), "ЧЦ=4; ЧДЦ=0; ЧН=0; ЧГ=0")
					+ ".*";
			Иначе
				Результат = Формат(Число(Версия1), "ЧЦ=4; ЧДЦ=0; ЧН=0; ЧГ=0")
					+ "." + Формат(Число(Версия2), "ЧЦ=4; ЧДЦ=0; ЧН=0; ЧГ=0")
					+ "." + Формат(Число(Версия3), "ЧЦ=4; ЧДЦ=0; ЧН=0; ЧГ=0")
					+ "." + Формат(Число(Версия4), "ЧЦ=4; ЧДЦ=0; ЧН=0; ЧГ=0");
			КонецЕсли;
		КонецЕсли;

	Иначе

		НоваяВерсия = ВнутреннееПредставлениеНомераВерсии(Версия);

		НовыйМассивЧиселВерсии = Новый Массив(4);
		МассивЧиселВерсии = СтрРазделить(НоваяВерсия, ".", Истина);
		Для С=1 По 4 Цикл
			НовыйМассивЧиселВерсии[С-1] = 0;
			Если МассивЧиселВерсии.Количество() >= С Тогда
				Попытка
					НовыйМассивЧиселВерсии[С-1] = ?(ПустаяСтрока(МассивЧиселВерсии[С-1]), 0, Число(МассивЧиселВерсии[С-1]));
				Исключение
					НовыйМассивЧиселВерсии[С-1] = 0;
				КонецПопытки;
			КонецЕсли;
		КонецЦикла;

		Результат = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			"%1.%2.%3.%4",
			СокрЛП(Формат(НовыйМассивЧиселВерсии[0], "ЧЦ=4; ЧДЦ=; ЧН=0; ЧГ=0")),
			СокрЛП(Формат(НовыйМассивЧиселВерсии[1], "ЧЦ=4; ЧДЦ=; ЧН=0; ЧГ=0")),
			СокрЛП(Формат(НовыйМассивЧиселВерсии[2], "ЧЦ=4; ЧДЦ=; ЧН=0; ЧГ=0")),
			СокрЛП(Формат(НовыйМассивЧиселВерсии[3], "ЧЦ=4; ЧДЦ=; ЧН=0; ЧГ=0")));

	КонецЕсли;

	Возврат Результат;

КонецФункции

// Функция генерирует пользовательское представление интервала версий.
//
// Параметры:
//  ВерсияОТ - Строка - строка формата 99.99.999.9999, которая участвует в формировании интервала версий;
//  ВерсияДО - Строка - строка формата 99.99.999.9999, которая участвует в формировании интервала версий.
//
// Возвращаемое значение:
//   Строка - пользовательское представление интервала версий.
//
Функция ПользовательскоеПредставлениеИнтервалаВерсий(ВерсияОТ, ВерсияДО) Экспорт

	Результат = "";

	Если (ВерсияОТ = "00.00.000.0000") И (ВерсияДО = "99.99.999.9999") Тогда
		Результат = НСтр("ru='Любая версия'");
	ИначеЕсли (ВерсияОТ <> "00.00.000.0000") И (ВерсияДО <> "99.99.999.9999") Тогда
		Если ВерсияОТ = ВерсияДО Тогда // Точная версия
			Результат = ПользовательскоеПредставлениеНомераВерсии(ВерсияОТ, Истина);
		Иначе // Интервал версий
			Результат = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru='Интервал %1...%2'"),
				ПользовательскоеПредставлениеНомераВерсии(ВерсияОТ, Истина),
				ПользовательскоеПредставлениеНомераВерсии(ВерсияДО, Истина));
		КонецЕсли;
	ИначеЕсли (ВерсияОТ <> "00.00.000.0000") И (ВерсияДО = "99.99.999.9999") Тогда // От версии и выше
		Результат = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru='От %1 и выше'"),
			ПользовательскоеПредставлениеНомераВерсии(ВерсияОТ, Истина));
	ИначеЕсли (ВерсияОТ = "00.00.000.0000") И (ВерсияДО <> "99.99.999.9999") Тогда // До версии включительно
		Результат = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru='До версии %1 включительно'"),
			ПользовательскоеПредставлениеНомераВерсии(ВерсияДО, Истина));
	Иначе // Воспринимать как Интервал версий
		Результат = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru='Интервал %1...%2.'"),
			ПользовательскоеПредставлениеНомераВерсии(ВерсияОТ, Истина),
			ПользовательскоеПредставлениеНомераВерсии(ВерсияДО, Истина));
	КонецЕсли;

	Возврат Результат;

КонецФункции

// Функция возвращает строковое представление для произвольного значения.
//
// Параметры:
//  ОбрабатываемоеЗначение - Произвольный - значение произвольного типа, которое надо вывести в виде строки;
//  Разделитель1           - Строка - разделитель значений 1 (например, разделяет элементы массива или ключ и значение структуры или соответствия);
//  Разделитель2           - Строка - разделитель значений 2 (например, разделяет элементы структуры или соответствия);
//  Уровень                - Число  - Значение уровня, влияет на отступ.
//
// Возвращаемое значение:
//   Строка - строковое представление.
//
Функция ПредставлениеЗначения(ОбрабатываемоеЗначение, Разделитель1 = "", Разделитель2 = "", Знач Уровень = 0) Экспорт

	Результат = "";

	ТипЧисло                     = Тип("Число");
	ТипСтрока                    = Тип("Строка");
	ТипДата                      = Тип("Дата");
	ТипБулево                    = Тип("Булево");
	ТипСписокЗначений            = Тип("СписокЗначений");
	ТипМассив                    = Тип("Массив");
	ТипФиксированныйМассив       = Тип("ФиксированныйМассив");
	ТипСтруктура                 = Тип("Структура");
	ТипФиксированнаяСтруктура    = Тип("ФиксированнаяСтруктура");
	ТипСоответствие              = Тип("Соответствие");
	ТипФиксированноеСоответствие = Тип("ФиксированноеСоответствие");

	Если ТипЗнч(Уровень) <> ТипЧисло
			ИЛИ Уровень < 0 Тогда
		Уровень = 0;
	КонецЕсли;

	Если ТипЗнч(ОбрабатываемоеЗначение) = ТипСтрока Тогда
		Результат = СтроковыеФункцииКлиентСервер.СформироватьСтрокуСимволов("  ", Уровень) + ОбрабатываемоеЗначение;
	ИначеЕсли ТипЗнч(ОбрабатываемоеЗначение) = ТипДата Тогда
		Результат = СтроковыеФункцииКлиентСервер.СформироватьСтрокуСимволов("  ", Уровень) + Формат(ОбрабатываемоеЗначение, "ДЛФ=DT");
	ИначеЕсли ТипЗнч(ОбрабатываемоеЗначение) = ТипЧисло Тогда
		Результат = СтроковыеФункцииКлиентСервер.СформироватьСтрокуСимволов("  ", Уровень) + Формат(ОбрабатываемоеЗначение, "ЧЦ=15; ЧДЦ=4; ЧРД=,; ЧРГ=' '; ЧН=0,0000; ЧГ=3,0");
	ИначеЕсли ТипЗнч(ОбрабатываемоеЗначение) = ТипБулево Тогда
		Результат = СтроковыеФункцииКлиентСервер.СформироватьСтрокуСимволов("  ", Уровень) + Формат(ОбрабатываемоеЗначение, "БЛ=Ложь; БИ=Истина");
	ИначеЕсли ТипЗнч(ОбрабатываемоеЗначение) = ТипСписокЗначений Тогда
		Счетчик = 1;
		Для Каждого ТекущееЗначение Из ОбрабатываемоеЗначение Цикл
			Если Счетчик = ОбрабатываемоеЗначение.Количество() Тогда
				Результат = Результат
					+ СтроковыеФункцииКлиентСервер.СформироватьСтрокуСимволов("  ", Уровень)
					+ ПредставлениеЗначения(ТекущееЗначение.Значение, Разделитель1, Разделитель2, Уровень);
			Иначе
				Результат = Результат
					+ СтроковыеФункцииКлиентСервер.СформироватьСтрокуСимволов("  ", Уровень)
					+ ПредставлениеЗначения(ТекущееЗначение.Значение, Разделитель1, Разделитель2, Уровень) + Разделитель1;
			КонецЕсли;
			Счетчик = Счетчик + 1;
		КонецЦикла;
	ИначеЕсли (ТипЗнч(ОбрабатываемоеЗначение) = ТипМассив) ИЛИ (ТипЗнч(ОбрабатываемоеЗначение) = ТипФиксированныйМассив) Тогда
		Счетчик = 1;
		Для Каждого ТекущееЗначение Из ОбрабатываемоеЗначение Цикл
			Если Счетчик = ОбрабатываемоеЗначение.Количество() Тогда
				Результат = Результат
					+ СтроковыеФункцииКлиентСервер.СформироватьСтрокуСимволов("  ", Уровень)
					+ ПредставлениеЗначения(ТекущееЗначение, Разделитель1, Разделитель2, Уровень);
			Иначе
				Результат = Результат
					+ СтроковыеФункцииКлиентСервер.СформироватьСтрокуСимволов("  ", Уровень)
					+ ПредставлениеЗначения(ТекущееЗначение, Разделитель1, Разделитель2, Уровень) + Разделитель1;
			КонецЕсли;
			Счетчик = Счетчик + 1;
		КонецЦикла;
	ИначеЕсли (ТипЗнч(ОбрабатываемоеЗначение) = ТипСтруктура)
			ИЛИ (ТипЗнч(ОбрабатываемоеЗначение) = ТипФиксированнаяСтруктура) Тогда
		Для Каждого КлючЗначение Из ОбрабатываемоеЗначение Цикл
			Если (ТипЗнч(КлючЗначение.Значение) = ТипСтруктура)
					ИЛИ (ТипЗнч(КлючЗначение.Значение) = ТипФиксированнаяСтруктура) Тогда
				// Перед структурой вставить еще один разделитель.
				Результат =
					Результат
					+ СтроковыеФункцииКлиентСервер.СформироватьСтрокуСимволов("  ", Уровень)
					+ КлючЗначение.Ключ
					+ Разделитель1
					+ Символы.ПС
					+ ПредставлениеЗначения(КлючЗначение.Значение, Разделитель1, Разделитель2, Уровень + 1) // С отступом
					+ Разделитель2;
			Иначе
				Результат =
					Результат
					+ СтроковыеФункцииКлиентСервер.СформироватьСтрокуСимволов("  ", Уровень)
					+ КлючЗначение.Ключ
					+ Разделитель1
					+ ПредставлениеЗначения(КлючЗначение.Значение, Разделитель1, Разделитель2, 0) // Без отступа
					+ Разделитель2;
			КонецЕсли;
		КонецЦикла;
	ИначеЕсли (ТипЗнч(ОбрабатываемоеЗначение) = ТипСоответствие) ИЛИ (ТипЗнч(ОбрабатываемоеЗначение) = ТипФиксированноеСоответствие) Тогда
		Для Каждого КлючЗначение Из ОбрабатываемоеЗначение Цикл
			Если (ТипЗнч(КлючЗначение.Значение) = ТипСтруктура)
					ИЛИ (ТипЗнч(КлючЗначение.Значение) = ТипФиксированнаяСтруктура) Тогда
				// Перед структурой вставить еще один разделитель.
				Результат =
					Результат
					+ СтроковыеФункцииКлиентСервер.СформироватьСтрокуСимволов("  ", Уровень)
					+ ПредставлениеЗначения(КлючЗначение.Ключ, Разделитель1, Разделитель2, Уровень + 1)
					+ Разделитель1
					+ Символы.ПС
					+ ПредставлениеЗначения(КлючЗначение.Значение, Разделитель1, Разделитель2, Уровень + 1) // С отступом
					+ Разделитель2;
			Иначе
				Результат =
					Результат
					+ СтроковыеФункцииКлиентСервер.СформироватьСтрокуСимволов("  ", Уровень)
					+ ПредставлениеЗначения(КлючЗначение.Ключ, Разделитель1, Разделитель2, Уровень + 1)
					+ Разделитель1
					+ ПредставлениеЗначения(КлючЗначение.Значение, Разделитель1, Разделитель2, 0) // Без отступа
					+ Разделитель2;
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;

	Возврат Результат;

КонецФункции

// Функция удаляет последние символы, если они находятся в списке удаляемых.
// Полезно для приведения каталогов к виду "без слеша в конце".
//
// Параметры:
//  ОбрабатываемаяСтрока - Строка - строка для проверки;
//  УдаляемыеСимволы     - Строка - строка со списком символов, которые необходимо удалить.
//
// Возвращаемое значение:
//  Строка - преобразованная строка.
//
Функция УдалитьПоследнийСимвол(ОбрабатываемаяСтрока, УдаляемыеСимволы) Экспорт

	Результат = ОбрабатываемаяСтрока;

	Если НЕ ПустаяСтрока(УдаляемыеСимволы) Тогда
		БылиУдаления = Истина;
		Пока БылиУдаления = Истина Цикл
			БылиУдаления = Ложь;
			Если СтрДлина(Результат) > 0 Тогда
				ПроверяемыйСимвол = Прав(Результат, 1);
				Если СтрНайти(УдаляемыеСимволы, ПроверяемыйСимвол) > 0 Тогда
					Результат = Лев(Результат, СтрДлина(Результат) - 1);
					БылиУдаления = Истина;
				КонецЕсли;
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;

	Возврат Результат;

КонецФункции

// Возвращает строковое представление дня недели.
//
// Параметры:
//  НомерДняНедели - Число - номер для недели.
//
// Возвращаемое значение:
//   Строка - Строковое представление дня недели.
//
Функция ПредставлениеДняНедели(НомерДняНедели) Экспорт

	Результат = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru='Неопределено (%1)'"),
		НомерДняНедели);

	Если НомерДняНедели = 1 Тогда
		Результат = НСтр("ru='Понедельник'");
	ИначеЕсли НомерДняНедели = 2 Тогда
		Результат = НСтр("ru='Вторник'");
	ИначеЕсли НомерДняНедели = 3 Тогда
		Результат = НСтр("ru='Среда'");
	ИначеЕсли НомерДняНедели = 4 Тогда
		Результат = НСтр("ru='Четверг'");
	ИначеЕсли НомерДняНедели = 5 Тогда
		Результат = НСтр("ru='Пятница'");
	ИначеЕсли НомерДняНедели = 6 Тогда
		Результат = НСтр("ru='Суббота'");
	ИначеЕсли НомерДняНедели = 7 Тогда
		Результат = НСтр("ru='Воскресенье'");
	КонецЕсли;

	Возврат Результат;

КонецФункции

// Для многострочной строки добавляет отступ для каждой строки.
//
// Параметры:
//  МногострочнаяСтрока   - Строка, Массив - строка, которую необходимо преобразовать;
//  Отступ                - Строка - отступ, который надо добавить;
//  ОтступДляПервойСтроки - Булево - добавлять отступ для первой строки или нет;
//  СокращатьПробелы      - Булево - Истина, если для каждой строки надо предварительно удалять незначащие символы с концов строки.
//
// Возвращаемое значение:
//   Строка - отформатированная строка.
//
Функция ВставитьОтступВМногострочнуюСтроку(МногострочнаяСтрока, Отступ, ОтступДляПервойСтроки = Ложь, СокращатьПробелы = Ложь) Экспорт

	Результат = Новый Массив;

	ТипМассив = Тип("Массив");
	ТипСтрока = Тип("Строка");

	Если ТипЗнч(МногострочнаяСтрока) = ТипМассив Тогда
		СтрокиДляОбработки = МногострочнаяСтрока;
	ИначеЕсли ТипЗнч(МногострочнаяСтрока) = ТипСтрока Тогда
		СтрокиДляОбработки = СтрРазделить(МногострочнаяСтрока, Символы.ПС, Истина);
	Иначе
		СтрокиДляОбработки = Новый Массив;
	КонецЕсли;

	ЭтоПерваяСтрока = Истина;
	Для Каждого ТекущаяСтрока Из СтрокиДляОбработки Цикл
		Если СокращатьПробелы = Истина Тогда
			ТекущаяСтрока = СокрЛП(ТекущаяСтрока);
		КонецЕсли;
		Если (ЭтоПерваяСтрока = Истина) И (ОтступДляПервойСтроки = Ложь) Тогда
			Результат.Добавить(ТекущаяСтрока);
		Иначе
			Результат.Добавить(Отступ + ТекущаяСтрока);
		КонецЕсли;
		ЭтоПерваяСтрока = Ложь;
	КонецЦикла;

	Результат = СтрСоединить(Результат, Символы.ПС);

	Возврат Результат;

КонецФункции

#КонецОбласти

#Область ЛогИОтладка

// Возвращает структуру контекста выполнения для дальнейшей записи в журнал регистрации или вывод на экран.
// Это базовый функционал.
//
// Параметры:
//  Нет.
//
// Возвращаемое значение:
//   Структура - Структура с определенными ключами, см. код.
//
Функция НоваяЗаписьРезультатовВыполненияОпераций() Экспорт

	Результат = Новый Структура("ЛогШаговВыполнения, КодРезультата, ОписаниеРезультата",
		Новый Массив,
		0,
		"");

	Возврат Результат;

КонецФункции

// Регистрирует начало шага выполнения.
//
// Параметры:
//  КонтекстВыполнения - Структура - см. возврат ИнтернетПоддержкаПользователейКлиентСервер.НоваяЗаписьРезультатовВыполненияОпераций;
//  ИдентификаторШага - Строка - Произвольный идентификатор;
//  Шаг - Строка - Произвольное описание шага.
//
Процедура НачатьРегистрациюРезультатаВыполненияОперации(КонтекстВыполнения, ИдентификаторШага, Шаг) Экспорт

	// В начале регистрации записывается информация:
	//  ИдентификаторШага, Шаг, ВремяНачала.
	// В конце регистрации записывается информация:
	//  ВремяОкончания, КодРезультата, ОписаниеРезультата, ВложенныйКонтекстВыполнения.

	// Если в контексте выполнения уже существовало свойство "ТекущийШагВыполнения", то он будет перезаписан.

	ТекущийШагВыполнения = СтруктураШагаВыполнения();
	ТекущийШагВыполнения.Вставить("ИдентификаторШага", ИдентификаторШага);
	ТекущийШагВыполнения.Вставить("Шаг", Шаг);
	ТекущийШагВыполнения.Вставить("ВремяНачала", ТекущаяУниверсальнаяДатаВМиллисекундах());

	КонтекстВыполнения.Вставить("ТекущийШагВыполнения", ТекущийШагВыполнения);

КонецПроцедуры

// Регистрирует завершение шага выполнения и возвращает последний шаг.
//
// Параметры:
//  КонтекстВыполнения - Структура - см. возврат ИнтернетПоддержкаПользователейКлиентСервер.НоваяЗаписьРезультатовВыполненияОпераций;
//  КодРезультата - Число - Произвольный код описания возврата, 0 = нет ошибок;
//  ОписаниеРезультата - Строка, Массив - произвольное описание результата шага. Массив будет преобразован в строку с разделителями;
//  ВложенныйКонтекстВыполнения - Неопределено или Массив - массив вложенных шагов выполнения.
//
// Возвращаемое значение:
//   Структура - список ключей см. в ИнтернетПоддержкаПользователейКлиентСервер.СтруктураШагаВыполнения.
//
Функция ЗавершитьРегистрациюРезультатаВыполненияОперации(КонтекстВыполнения, КодРезультата, ОписаниеРезультата, ВложенныйКонтекстВыполнения = Неопределено) Экспорт

	// В начале регистрации записывается информация:
	//  ИдентификаторШага, Шаг, ВремяНачала.
	// В конце регистрации записывается информация:
	//  ВремяОкончания, КодРезультата, ОписаниеРезультата, ВложенныйКонтекстВыполнения.

	ТипМассив = Тип("Массив");

	ТекущийШагВыполнения = СтруктураШагаВыполнения();
	Если КонтекстВыполнения.Свойство("ТекущийШагВыполнения") Тогда
		ЗаполнитьЗначенияСвойств(ТекущийШагВыполнения, КонтекстВыполнения.ТекущийШагВыполнения, "ИдентификаторШага, Шаг, ВремяНачала");
	КонецЕсли;

	// Если не было зарегистрировано начало шага выполнения, то впоследствии могут быть ошибки при записи лога в журнал регистрации.
	Если ТипЗнч(ТекущийШагВыполнения.ВремяНачала) <> Тип("Число") Тогда
		ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru='Не зарегистрировано начало шага выполнения %1, %2.'"),
				ТекущийШагВыполнения.ИдентификаторШага,
				ТекущийШагВыполнения.Шаг);
		ВызватьИсключение ТекстСообщения;
	КонецЕсли;

	Если ТипЗнч(ОписаниеРезультата) = ТипМассив Тогда
		ОписаниеРезультатаСтрокой = СтрСоединить(ОписаниеРезультата, Символы.ПС);
	Иначе
		ОписаниеРезультатаСтрокой = ОписаниеРезультата;
	КонецЕсли;

	ТекущийШагВыполнения.Вставить("ВремяОкончания", ТекущаяУниверсальнаяДатаВМиллисекундах());
	ТекущийШагВыполнения.Вставить("КодРезультата", КодРезультата);
	ТекущийШагВыполнения.Вставить("ОписаниеРезультата", ОписаниеРезультатаСтрокой);
	ТекущийШагВыполнения.Вставить("ВложенныйКонтекстВыполнения", ВложенныйКонтекстВыполнения);

	КонтекстВыполнения.ЛогШаговВыполнения.Добавить(ТекущийШагВыполнения);

	КонтекстВыполнения.Удалить("ТекущийШагВыполнения"); // Удалить текущий шаг, т.к. он уже добавлен в "ЛогШаговВыполнения".

	Возврат ТекущийШагВыполнения;

КонецФункции

// Для случая, когда в лог необходимо записать единственное действие, без времени, то вместо комбинации
//  НачатьРегистрациюРезультатаВыполненияОперации ... ЗавершитьРегистрациюРезультатаВыполненияОперации можно использовать
//  только ЗарегистрироватьРезультатВыполненияОперации, тогда время выполнения будет равно 0.
//
// Параметры:
//  КонтекстВыполнения - Структура - см. возврат ИнтернетПоддержкаПользователейКлиентСервер.НоваяЗаписьРезультатовВыполненияОпераций;
//  ИдентификаторШага - Строка - Произвольный идентификатор;
//  Шаг - Строка - Произвольное описание шага.
//  КодРезультата - Число - Произвольный код описания возврата, 0 = нет ошибок;
//  ОписаниеРезультата - Строка - произвольное описание результата шага;
//  ВложенныйКонтекстВыполнения - Неопределено или Массив - массив вложенных шагов выполнения.
//
// Возвращаемое значение:
//   Структура - список ключей см. в ИнтернетПоддержкаПользователейКлиентСервер.СтруктураШагаВыполнения.
//
Функция ЗарегистрироватьРезультатВыполненияОперации(
			КонтекстВыполнения,
			ИдентификаторШага,
			Шаг,
			КодРезультата,
			ОписаниеРезультата,
			ВложенныйКонтекстВыполнения = Неопределено) Экспорт

	ТекущийШагВыполнения = СтруктураШагаВыполнения();
	ТекущийШагВыполнения.Вставить("ИдентификаторШага", ИдентификаторШага);
	ТекущийШагВыполнения.Вставить("Шаг", Шаг);
	ТекущийШагВыполнения.Вставить("ВремяНачала", ТекущаяУниверсальнаяДатаВМиллисекундах());
	ТекущийШагВыполнения.Вставить("ВремяОкончания", ТекущийШагВыполнения.ВремяНачала);
	ТекущийШагВыполнения.Вставить("КодРезультата", КодРезультата);
	ТекущийШагВыполнения.Вставить("ОписаниеРезультата", ОписаниеРезультата);
	ТекущийШагВыполнения.Вставить("ВложенныйКонтекстВыполнения", ВложенныйКонтекстВыполнения);

	КонтекстВыполнения.ЛогШаговВыполнения.Добавить(ТекущийШагВыполнения);

	Возврат ТекущийШагВыполнения;

КонецФункции

// Функция возвращает текстовое описание шагов выполнения.
//
// Параметры:
//  КонтекстВыполнения - Структура - Структура с ключами, описанными в Интернет.НоваяЗаписьРезультатовВыполненияОпераций();
//  ВключаяВложенные   - Булево - Истина, если надо включать вложенные контексты выполнения;
//  ВариантФормата     - Строка - в каком формате выводить текст. Возможные варианты:
//    * ТолькоТекстОписанияРезультата;
//    * ПодробноПоШагам.
//  УровеньВложенности - Число - Текущий уровень вложенности.
//
// Возвращаемое значение:
//   Строка - текстовое описание результата шага выполнения.
//
Функция ПредставлениеЗаписиРезультатовВыполненияОпераций(
			КонтекстВыполнения,
			ВключаяВложенные = Ложь,
			ВариантФормата = "",
			УровеньВложенности = 0) Экспорт

	ТипСтруктура = Тип("Структура");

	Результат = "";

	Для Каждого ТекущийШаг Из КонтекстВыполнения.ЛогШаговВыполнения Цикл

		Если ВариантФормата = "ТолькоТекстОписанияРезультата" Тогда
			Результат = Результат
				+ "#"
				+ СтроковыеФункцииКлиентСервер.СформироватьСтрокуСимволов("  ", УровеньВложенности)
				+ ТекущийШаг.ОписаниеРезультата
				+ "#";
		ИначеЕсли ВариантФормата = "ПодробноПоШагам" Тогда
			Отступ = СтроковыеФункцииКлиентСервер.СформироватьСтрокуСимволов("  ", УровеньВложенности);
			ШаблонШага = НСтр("ru='%1Шаг: %2
				|%1Длительность (мс): %3
				|%1Результат выполнения: %4'")
				+ Символы.ПС;
			Результат = Результат
				+ "#"
				+ СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					ШаблонШага,
						Отступ,
						ТекущийШаг.Шаг,
						ТекущийШаг.ВремяОкончания - ТекущийШаг.ВремяНачала, // Длительность.
						ВставитьОтступВМногострочнуюСтроку("(" + ТекущийШаг.КодРезультата + "), " + ТекущийШаг.ОписаниеРезультата, Отступ, Ложь))
				+ "#";
		КонецЕсли;

		Если ВключаяВложенные = Истина Тогда
			Если ТипЗнч(ТекущийШаг.ВложенныйКонтекстВыполнения) = ТипСтруктура Тогда
				Результат = Результат
					+ ПредставлениеЗаписиРезультатовВыполненияОпераций(
						ТекущийШаг.ВложенныйКонтекстВыполнения,
						ВключаяВложенные,
						ВариантФормата,
						УровеньВложенности + 1);
			КонецЕсли;
		КонецЕсли;

	КонецЦикла;

	Результат = СтрЗаменить(Результат, "##", Символы.ПС + Символы.ПС);
	Результат = СтрЗаменить(Результат, "#", "");

	Возврат Результат;

КонецФункции

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ОбщегоНазначения

Функция ХостПорталаПоддержки(Домен)


	Если Домен = 0 Тогда
		Возврат "portal.1c.ru";
	Иначе
		Возврат "portal.1c.eu";
	КонецЕсли;

КонецФункции

// Возвращает строковое представление типа платформы.
//
Функция ИмяТипПлатформыСтр(ПараметрТипПлатформы) Экспорт
	
	Если ПараметрТипПлатформы = ТипПлатформы.Linux_x86 Тогда
		Возврат "Linux_x86";
	ИначеЕсли ПараметрТипПлатформы = ТипПлатформы.Linux_x86_64 Тогда
		Возврат "Linux_x86_64";
	ИначеЕсли ПараметрТипПлатформы = ТипПлатформы.MacOS_x86 Тогда
		Возврат "MacOS_x86";
	ИначеЕсли ПараметрТипПлатформы = ТипПлатформы.MacOS_x86_64 Тогда
		Возврат "MacOS_x86_64";
	ИначеЕсли ПараметрТипПлатформы = ТипПлатформы.Windows_x86 Тогда
		Возврат "Windows_x86";
	ИначеЕсли ПараметрТипПлатформы = ТипПлатформы.Windows_x86_64 Тогда
		Возврат "Windows_x86_64";
	Иначе
		Возврат "";
	КонецЕсли;
	
КонецФункции

// Преобразует переданную строку:
// в форматированную строку, если строка начинается с "<body>" и заканчивается "</body>";
// В противном случае строка остается без изменений.
//
Функция ФорматированнаяСтрокаИзHTML(ТекстСообщения) Экспорт
	
	ФДок = Новый ФорматированныйДокумент;
	ФДок.УстановитьHTML("<html>" + ТекстСообщения + "</html>", Новый Структура);
	Возврат ФДок.ПолучитьФорматированнуюСтроку();
	
КонецФункции

#Область БСПНастройкиПрограммы

// Отображает состояние подключения ИПП на панели
// "Интернет-поддержка и сервисы" (БСП).
//
Процедура ОтобразитьСостояниеПодключенияИПП(Форма) Экспорт
	
	Элементы = Форма.Элементы;
	Если Форма.БИПДанныеАутентификации = Неопределено Тогда
		Элементы.ДекорацияЛогинИПП.Заголовок = НСтр("ru = 'Подключение к Интернет-поддержке не выполнено.'");
		Элементы.ВойтиИлиВыйтиИПП.Заголовок = НСтр("ru = 'Подключить'");
		Элементы.ВойтиИлиВыйтиИПП.ОтображениеПодсказки = ОтображениеПодсказки.Нет;
	Иначе
		ШаблонЗаголовка = ПодставитьДомен(
			НСтр("ru = '<body>Подключена Интернет-поддержка для пользователя <a href=""action:openUsersSite"">%1</body>'"));
		Элементы.ДекорацияЛогинИПП.Заголовок =
			ФорматированныйЗаголовок(
				СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					ШаблонЗаголовка,
					Форма.БИПДанныеАутентификации.Логин));
		Элементы.ВойтиИлиВыйтиИПП.Заголовок = НСтр("ru = 'Отключить'");
		Элементы.ВойтиИлиВыйтиИПП.ОтображениеПодсказки = ОтображениеПодсказки.ОтображатьСнизу;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область АутентификацияВСервисахИнтернетПоддержки

Функция ХостСервисаLogin(Домен) Экспорт


	Если Домен = 0 Тогда
		Возврат "login.1c.ru";
	Иначе
		Возврат "login.1c.eu";
	КонецЕсли;

КонецФункции

#КонецОбласти

#Область ЛогИОтладка

// Возвращает структуру шага выполнения для дальнейшей записи в журнал регистрации или вывод на экран.
//
// Параметры:
//  Нет.
//
// Возвращаемое значение:
//   Структура - Структура с определенными ключами, см. код.
//
Функция СтруктураШагаВыполнения()

	Результат = Новый Структура("
		|ИдентификаторШага, Шаг,
		|ВремяНачала, ВремяОкончания,
		|КодРезультата, ОписаниеРезультата,
		|ВложенныйКонтекстВыполнения");

	Возврат Результат;

КонецФункции

#КонецОбласти

#КонецОбласти
