﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2021, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область СлужебныеПроцедурыИФункции

// См. СтандартныеПодсистемыКлиент.ПараметрыРаботыКлиентаПриЗапуске().
Функция ПараметрыРаботыКлиентаПриЗапуске() Экспорт
	
	ПроверитьПорядокЗапускаПрограммыПередНачаломРаботыСистемы();
	
	ПараметрыПриЗапускеПрограммы = ПараметрыПриложения["СтандартныеПодсистемы.ПараметрыПриЗапускеПрограммы"];
	
	Параметры = Новый Структура;
	Параметры.Вставить("ПолученныеПараметрыКлиента", Неопределено);
	
	Если ПараметрыПриЗапускеПрограммы.Свойство("ПолученныеПараметрыКлиента")
		И ТипЗнч(ПараметрыПриЗапускеПрограммы.ПолученныеПараметрыКлиента) = Тип("Структура") Тогда
		
		Параметры.Вставить("ПолученныеПараметрыКлиента", ОбщегоНазначенияКлиент.СкопироватьРекурсивно(
			ПараметрыПриЗапускеПрограммы.ПолученныеПараметрыКлиента));
	КонецЕсли;
	
	Если ПараметрыПриЗапускеПрограммы.Свойство("ПропуститьОчисткуСкрытияРабочегоСтола") Тогда
		Параметры.Вставить("ПропуститьОчисткуСкрытияРабочегоСтола");
	КонецЕсли;
	
	Если ПараметрыПриЗапускеПрограммы.Свойство("ОпцииИнтерфейса")
	   И ТипЗнч(Параметры.ПолученныеПараметрыКлиента) = Тип("Структура") Тогда
		
		Параметры.ПолученныеПараметрыКлиента.Вставить("ОпцииИнтерфейса");
	КонецЕсли;
	
	СтандартныеПодсистемыКлиент.ЗаполнитьПараметрыРаботыКлиентаНаСервере(Параметры);
	
	ПараметрыКлиента = СтандартныеПодсистемыВызовСервера.ПараметрыРаботыКлиентаПриЗапуске(Параметры);
	
	Если ПараметрыПриЗапускеПрограммы.Свойство("ПолученныеПараметрыКлиента")
		И ПараметрыПриЗапускеПрограммы.ПолученныеПараметрыКлиента <> Неопределено
		И Не ПараметрыПриЗапускеПрограммы.Свойство("ОпцииИнтерфейса") Тогда
		
		ПараметрыПриЗапускеПрограммы.Вставить("ОпцииИнтерфейса", ПараметрыКлиента.ОпцииИнтерфейса);
	КонецЕсли;
	
	СтандартныеПодсистемыКлиент.ЗаполнитьПараметрыКлиента(ПараметрыКлиента);
	
	// Обновление состояния скрытия рабочего стола на клиенте по состоянию на сервере.
	СтандартныеПодсистемыКлиент.СкрытьРабочийСтолПриНачалеРаботыСистемы(
		Параметры.СкрытьРабочийСтолПриНачалеРаботыСистемы, Истина);
	
	Возврат ПараметрыКлиента;
	
КонецФункции

// См. СтандартныеПодсистемыКлиент.ПараметрыРаботыКлиента().
Функция ПараметрыРаботыКлиента() Экспорт
	
	ПроверитьПорядокЗапускаПрограммыПередНачаломРаботыСистемы();
	ПроверитьПорядокЗапускаПрограммыПриНачалеРаботыСистемы();
	
	СвойстваКлиента = Новый Структура;
	СтандартныеПодсистемыКлиент.ЗаполнитьПараметрыРаботыКлиентаНаСервере(СвойстваКлиента);
	
	Возврат СтандартныеПодсистемыВызовСервера.ПараметрыРаботыКлиента(СвойстваКлиента);
	
КонецФункции

#Область ПредопределенныйЭлемент

// См. СтандартныеПодсистемыПовтИсп.СсылкиПоИменамПредопределенных
Функция СсылкиПоИменамПредопределенных(ПолноеИмяОбъектаМетаданных) Экспорт
	
	Возврат СтандартныеПодсистемыВызовСервера.СсылкиПоИменамПредопределенных(ПолноеИмяОбъектаМетаданных);
	
КонецФункции

#КонецОбласти

Процедура ПроверитьПорядокЗапускаПрограммыПередНачаломРаботыСистемы()
	
	ИмяПараметра = "СтандартныеПодсистемы.ЗапускПрограммыЗавершен";
	Если ПараметрыПриложения[ИмяПараметра] = Неопределено Тогда
		ВызватьИсключение
			НСтр("ru = 'Ошибка порядка запуска программы.
			           |Первой процедурой, которая вызывается из обработчика события ПередНачаломРаботыСистемы
			           |должна быть процедура БСП СтандартныеПодсистемыКлиент.ПередНачаломРаботыСистемы.'");
	КонецЕсли;
	
КонецПроцедуры

Процедура ПроверитьПорядокЗапускаПрограммыПриНачалеРаботыСистемы()
	
	Если Не СтандартныеПодсистемыКлиент.ЗапускПрограммыЗавершен() Тогда
		ВызватьИсключение
			НСтр("ru = 'Ошибка порядка запуска программы.
			           |Перед получением параметров работы клиента запуск программы должен быть завершен.'");
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Для справочника ИдентификаторыОбъектовМетаданных.

// Только для внутреннего использования.
Функция ПредставлениеИдентификатораОбъектаМетаданных(Ссылка) Экспорт
	
	Возврат СтандартныеПодсистемыВызовСервера.ПредставлениеИдентификатораОбъектаМетаданных(Ссылка);
	
КонецФункции

#КонецОбласти
