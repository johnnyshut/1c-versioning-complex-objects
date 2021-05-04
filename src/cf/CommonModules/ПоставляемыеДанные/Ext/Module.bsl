﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2021, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Инициировать уведомление о всех имеющихся в МС поставляемых данных (за исключением тех,
// у которых стоит пометка "Запрет уведомления".
// @skip-warning ПустойМетод - особенность реализации.
//
Процедура ЗапроситьВсеДанные() Экспорт
КонецПроцедуры

// Получить дескрипторы данных по заданным условиям.
// @skip-warning ПустойМетод - особенность реализации.
//
// Параметры:
//  ВидДанных - Строка - имя вида поставляемых данных.
//  Фильтр - Массив - элементы должны содержать поля Код (строка) и Значение (строка).
//
// Возвращаемое значение:
//    ОбъектXDTO - типа ArrayOfDescriptor.
//
Функция ДескрипторыПоставляемыхДанныхИзМенеджера(Знач ВидДанных, Знач Фильтр = Неопределено) Экспорт  
КонецФункции

// Инициирует обработку данных.
//
// Может использоваться в связке с ДескрипторыПоставляемыхДанныхИзМенеджера для 
// ручной инициации процесса обработки данных. После вызова метода система поведет 
// себя так, как будто она только что получила уведомление о доступности новых данных, 
// с указанным дескриптором - будет вызван ДоступныНовыеДанные, а затем, при необходимости, 
// ОбработатьНовыеДанные для соответствующих обработчиков.
// @skip-warning ПустойМетод - особенность реализации.
//
// Параметры:
//   Дескриптор - ОбъектXDTO - Descriptor.
//
Процедура ЗагрузитьИОбработатьДанные(Знач Дескриптор) Экспорт
КонецПроцедуры
	
// Помещает данные в справочник ПоставляемыеДанные.
//
// Данные сохраняются либо в том на диске, либо в поле таблицы ПоставляемыеДанные в 
// зависимости от константы ХранитьФайлыВТомахНаДиске и наличия свободных томов. Данные 
// могут быть позднее извлечены при помощи поиска по реквизитам, либо путем указания 
// уникального идентификатора, который передавался в поле Дескриптор.FileGUID. Если в базе 
// уже есть данные с тем же видом данных и набором ключевых характеристик - новые данные 
// замещают старые. При это используется обновление существующего элемента справочника, а 
// не удаление и создание нового.
// @skip-warning ПустойМетод - особенность реализации.
//
// Параметры:
//   Дескриптор - ОбъектXDTO - Descriptor или структура с полями.
//	 	"ВидДанных, ДатаДобавления, ИдентификаторФайла, Характеристики",
//    	где Характеристики - массив структур с полями "Код, Значение, Ключевая".
//   ПутьКФайлу - Строка - полное имя извлеченного файла.
//
Процедура СохранитьПоставляемыеДанныеВКэш(Знач Дескриптор, Знач ПутьКФайлу) Экспорт
КонецПроцедуры

// Удаляет файл из кэша.
// @skip-warning ПустойМетод - особенность реализации.
//
// Параметры:
//  СсылкаИлиИдентификатор - СправочникСсылка.ПоставляемыеДанные - ссылка на поставляемые данные,
//                         - УникальныйИдентификатор - уникальный идентификатор.
//
Процедура УдалитьПоставляемыеДанныеИзКэша(Знач СсылкаИлиИдентификатор) Экспорт
КонецПроцедуры

// Получает дескриптор данных из кэша.
// @skip-warning ПустойМетод - особенность реализации.
//
// Параметры:
//  СсылкаИлиИдентификатор - СправочникСсылка.ПоставляемыеДанные - ссылка на поставляемые данные,
//                         - УникальныйИдентификатор - уникальный идентификатор,
//  ВВидеXDTO - Булево - в каком виде возвращать значения.
//
// Возвращаемое значение:
//    ОбъектXDTO - типа ArrayOfDescriptor.
//
Функция ДескрипторПоставляемыхДанныхИзКэша(Знач СсылкаИлиИдентификатор, Знач ВВидеXDTO = Ложь) Экспорт
КонецФункции

// Возвращает двоичные данные присоединенного файла.
// @skip-warning ПустойМетод - особенность реализации.
//
// Параметры:
//  СсылкаИлиИдентификатор - СправочникСсылка.ПоставляемыеДанные - ссылка на поставляемые данные,
//                         - УникальныйИдентификатор - уникальный идентификатор.
//
// Возвращаемое значение:
//  ДвоичныеДанные - двоичные данные поставляемых данных.
//
Функция ПоставляемыеДанныеИзКэша(Знач СсылкаИлиИдентификатор) Экспорт
КонецФункции

// Проверяет наличие данных с указанными ключевыми характеристиками в кэше.
// @skip-warning ПустойМетод - особенность реализации.
//
// Параметры:
//   Дескриптор - ОбъектXDTO - Descriptor.
//
// Возвращаемое значение:
//  Булево - наличие дескриптора в кэше.
//
Функция ЕстьВКеше(Знач Дескриптор) Экспорт
КонецФункции

// Возвращает массив ссылок на данные, удовлетворяющие заданным условиям.
//
// Параметры:
//  ВидДанных - Строка - имя вида поставляемых данных.
//  Фильтр - Массив - элементы должны содержать поля Код (строка) и Значение (строка).
//
// Возвращаемое значение:
//    Массив - массив ссылок на данные.
//
Функция СсылкиПоставляемыхДанныхИзКэша(Знач ВидДанных, Знач Фильтр = Неопределено) Экспорт

	Возврат Новый Массив();
	
КонецФункции

// Получить данные по заданным условиям.
// @skip-warning ПустойМетод - особенность реализации.
//
// Параметры:
//  ВидДанных - Строка - имя вида поставляемых данных.
//  Фильтр - Массив - элементы должны содержать поля Код (строка) и Значение (строка).
//  ВВидеXDTO - Булево - в каком виде возвращать значения.
//
// Возвращаемое значение:
//    ОбъектXDTO - типа ArrayOfDescriptor или
//    Массив из Структура - с полями "ВидДанных, ДатаДобавления, ИдентификаторФайла, Характеристики":
//    где Характеристики - Массив из Структура - с полями "Код, Значение, Ключевая".
//      Для получения самого файла необходимо вызвать ПолучитьПоставляемыеДанныеИзКэша.
//
//
Функция ДескрипторыПоставляемыхДанныхИзКэша(Знач ВидДанных, Знач Фильтр = Неопределено, Знач ВВидеXDTO = Ложь) Экспорт
КонецФункции	

// Возвращает пользовательское представление дескриптора поставляемых данных.
// Может быть использовано при выводе сообщений в журнал регистрации.
// @skip-warning ПустойМетод - особенность реализации.
//
// Параметры:
//  Дескриптор - ОбъектXDTO - типа Descriptor или  структура с полями.
//	 	"ВидДанных, ДатаДобавления, ИдентификаторФайла, Характеристики",
//    	где Характеристики - массив структур с полями "Код, Значение".
//  ДескрипторJSON - Булево - признак того, что дескриптор в формате JSON
//
// Возвращаемое значение:
//  Строка - пользовательское представление дескриптора.
//
Функция ПолучитьОписаниеДанных(Знач Дескриптор, Знач ДескрипторJSON = Ложь) Экспорт
КонецФункции

// Возвращает зарегистрированные обработчики поставляемых данных.
// Используется для запуска процедур проверки и загрузки новых поставляемых данных. Так же может
// быть использована для получения списка поддерживаемых видов поставляемых данных.
//
// Возвращаемое значение:
//  ТаблицаЗначений:
//    * ВидДанных - Строка - код вида данных, обрабатываемый обработчиком.
//    * КодОбработчика - Строка - используется при восстановлении обработки данных после сбоя.
//    * Обработчик - ОбщийМодуль - модуль, содержащий следующие экспортные процедуры:
//			ДоступныНовыеДанные(Дескриптор, Загружать)  
//			ОбработатьНовыеДанные(Дескриптор, ПутьКФайлу)
//			ОбработкаДанныхОтменена(Дескриптор)
//
Функция ПолучитьОбработчики() Экспорт
	
	Обработчики = Новый ТаблицаЗначений;
	Обработчики.Колонки.Добавить("ВидДанных");
	Обработчики.Колонки.Добавить("Обработчик");
	Обработчики.Колонки.Добавить("КодОбработчика");
	
	ИнтеграцияПодсистемБТС.ПриОпределенииОбработчиковПоставляемыхДанных(Обработчики);
	ПоставляемыеДанныеПереопределяемый.ПолучитьОбработчикиПоставляемыхДанных(Обработчики);
	
	Возврат Обработчики;
	
КонецФункции	

///////////////////////////////////////////////////////////////////////////////////
// Обновление информации в областях данных.

// Возвращает список областей данных, в которые еще не были скопированы поставляемые данные.
// @skip-warning ПустойМетод - особенность реализации.
//
// В случае первого вызова функции возвращается полный набор доступных областей.
// При последующем вызове, при восстановлении после сбоя, будут возвращены только
// необработанные области. После копирования данных в область следует вызвать ОбластьОбработана.
//
// Параметры:
//  ИдентификаторФайла - УникальныйИдентификатор - идентификатор файла поставляемых данных,
//  КодОбработчика - Строка - код обработчика,
//  ВключаяНеразделенную - Булево - если Истина, ко всем имеющимся областям добавится область с кодом -1.
// 
// Возвращаемое значение:
//  Массив - области требующие обработки.
//
Функция ОбластиТребующиеОбработки(Знач ИдентификаторФайла, Знач КодОбработчика, Знач ВключаяНеразделенную = Ложь) Экспорт
КонецФункции

// Удаляет область из списка необработанных. Выключает разделение сеанса (если оно было включено),
// поскольку при включенном разделении запись в неразделенный регистр запрещена.
// @skip-warning ПустойМетод - особенность реализации.
//
// Параметры:
//  ИдентификаторФайла - УникальныйИдентификатор - файла поставляемых данных,
//  КодОбработчика - Строка - код обработчика,
//  ОбластьДанных - Число - идентификатор обработанной области.
// 
Процедура ОбластьОбработана(Знач ИдентификаторФайла, Знач КодОбработчика, Знач ОбластьДанных) Экспорт
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Обработчики событий подсистем конфигурации.

// См. ОчередьЗаданийПереопределяемый.ПриОпределенииПсевдонимовОбработчиков
// @skip-warning ПустойМетод - особенность реализации.
//
Процедура ПриОпределенииПсевдонимовОбработчиков(СоответствиеИменПсевдонимам) Экспорт
КонецПроцедуры

// См. ОбменСообщениямиПереопределяемый.ПолучитьОбработчикиКаналовСообщений
// @skip-warning ПустойМетод - особенность реализации.
//
Процедура ПриОпределенииОбработчиковКаналовСообщений(Обработчики) Экспорт
КонецПроцедуры

// См. ВыгрузкаЗагрузкаДанныхПереопределяемый.ПриЗаполненииТиповИсключаемыхИзВыгрузкиЗагрузки.
Процедура ПриЗаполненииТиповИсключаемыхИзВыгрузкиЗагрузки(Типы) Экспорт
	
	Типы.Добавить(Метаданные.РегистрыСведений.ПоставляемыеДанныеТребующиеОбработкиВОбластях);
	
КонецПроцедуры

#КонецОбласти
