﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2021, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если НЕ ЗначениеЗаполнено(Объект.Ссылка)
	   И Параметры.ЗначенияЗаполнения.Свойство("Наименование") Тогда
		
		Объект.Наименование = Параметры.ЗначенияЗаполнения.Наименование;
	КонецЕсли;
	
	Если НЕ Параметры.СкрытьВладельца Тогда
		Элементы.Владелец.Видимость = Истина;
	КонецЕсли;
	
	УстановитьЗаголовок();
	
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.Мультиязычность") Тогда
		МодульМультиязычностьСервер = ОбщегоНазначения.ОбщийМодуль("МультиязычностьСервер");
		МодульМультиязычностьСервер.ПриСозданииНаСервере(ЭтотОбъект, Объект);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.Мультиязычность") Тогда
		МодульМультиязычностьСервер = ОбщегоНазначения.ОбщийМодуль("МультиязычностьСервер");
		МодульМультиязычностьСервер.ПередЗаписьюНаСервере(ТекущийОбъект);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)

	// СтандартныеПодсистемы.УправлениеДоступом
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.УправлениеДоступом") Тогда
		МодульУправлениеДоступом = ОбщегоНазначения.ОбщийМодуль("УправлениеДоступом");
		МодульУправлениеДоступом.ПослеЗаписиНаСервере(ЭтотОбъект, ТекущийОбъект, ПараметрыЗаписи);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.УправлениеДоступом

	УстановитьЗаголовок();
	
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.Мультиязычность") Тогда
		МодульМультиязычностьСервер = ОбщегоНазначения.ОбщийМодуль("МультиязычностьСервер");
		МодульМультиязычностьСервер.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	// СтандартныеПодсистемы.УправлениеДоступом
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.УправлениеДоступом") Тогда
		МодульУправлениеДоступом = ОбщегоНазначения.ОбщийМодуль("УправлениеДоступом");
		МодульУправлениеДоступом.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.Мультиязычность") Тогда
		МодульМультиязычностьСервер = ОбщегоНазначения.ОбщийМодуль("МультиязычностьСервер");
		МодульМультиязычностьСервер.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура Подключаемый_Открытие(Элемент, СтандартнаяОбработка)
	
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.Мультиязычность") Тогда
		МодульМультиязычностьКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("МультиязычностьКлиент");
		МодульМультиязычностьКлиент.ПриОткрытии(ЭтотОбъект, Объект, Элемент, СтандартнаяОбработка);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьЗаголовок()
	
	ЗначенияРеквизитов = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(
		Объект.Владелец, "Заголовок, ЗаголовокФормыЗначения");
	
	ИмяСвойства = СокрЛП(ЗначенияРеквизитов.ЗаголовокФормыЗначения);
	
	Если НЕ ПустаяСтрока(ИмяСвойства) Тогда
		Если ЗначениеЗаполнено(Объект.Ссылка) Тогда
			Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = '%1 (%2)'"),
				Объект.Наименование,
				ИмяСвойства);
		Иначе
			Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = '%1 (Создание)'"), ИмяСвойства);
		КонецЕсли;
	Иначе
		ИмяСвойства = Строка(ЗначенияРеквизитов.Заголовок);
		
		Если ЗначениеЗаполнено(Объект.Ссылка) Тогда
			Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = '%1 (Группа значений свойства %2)'"),
				Объект.Наименование,
				ИмяСвойства);
		Иначе
			Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Группа значений свойства %1 (Создание)'"), ИмяСвойства);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти