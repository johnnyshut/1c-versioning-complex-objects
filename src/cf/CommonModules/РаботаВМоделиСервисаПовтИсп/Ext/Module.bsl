﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2021, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область СлужебныйПрограммныйИнтерфейс

// Возвращает признак наличия в конфигурации общих реквизитов-разделителей.
//
// Возвращаемое значение:
//   Булево - Истина, если это разделенная конфигурация.
//
Функция ЭтоРазделеннаяКонфигурация() Экспорт
	
	ЕстьРазделители = Ложь;
	Для каждого ОбщийРеквизит Из Метаданные.ОбщиеРеквизиты Цикл
		Если ОбщийРеквизит.РазделениеДанных = Метаданные.СвойстваОбъектов.РазделениеДанныхОбщегоРеквизита.Разделять Тогда
			ЕстьРазделители = Истина;
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
	Возврат ЕстьРазделители;
	
КонецФункции

// Возвращает признак того, что объект метаданных используется в общих реквизитах-разделителях.
//
// Параметры:
//   ПолноеИмяОбъектаМетаданных - Строка - имя объекта метаданных.
//   Разделитель - Строка - имя общего реквизита-разделителя, на разделение которыми проверяется объект метаданных.
//
// Возвращаемое значение:
//   Булево - Истина, если это разделенный объект.
//
Функция ЭтоРазделенныйОбъектМетаданных(Знач ПолноеИмяОбъектаМетаданных, Знач Разделитель = Неопределено) Экспорт
	
	Если Разделитель = Неопределено Тогда
		РазделениеПоОсновномуРеквизиту = РаботаВМоделиСервиса.РазделенныеОбъектыМетаданных(РаботаВМоделиСервиса.РазделительОсновныхДанных());
		РазделениеПоВспомогательномуРеквизиту = РаботаВМоделиСервиса.РазделенныеОбъектыМетаданных(РаботаВМоделиСервиса.РазделительВспомогательныхДанных());
		Результат = РазделениеПоОсновномуРеквизиту.Получить(ПолноеИмяОбъектаМетаданных) <> Неопределено
			Или РазделениеПоВспомогательномуРеквизиту.Получить(ПолноеИмяОбъектаМетаданных) <> Неопределено;
		Возврат Результат;
	Иначе
		РазделенныеОбъектыМетаданных = РаботаВМоделиСервиса.РазделенныеОбъектыМетаданных(Разделитель);
		Возврат РазделенныеОбъектыМетаданных.Получить(ПолноеИмяОбъектаМетаданных) <> Неопределено;
	КонецЕсли;
	
КонецФункции

// Возвращает признак работы в режиме разделения данных по областям
// (технически это признак условного разделения).
// 
// Возвращает Ложь, если конфигурация не может работать в режиме разделения данных
// (не содержит общих реквизитов, предназначенных для разделения данных).
//
// Возвращаемое значение:
//  Булево - Истина, если разделение включено.
//         - Ложь,   если разделение выключено или не поддерживается.
//
Функция РазделениеВключено() Экспорт
	
	Если Не ЭтоРазделеннаяКонфигурация() Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Если Не ПолучитьФункциональнуюОпцию("РаботаВМоделиСервиса") Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Возврат Истина;
	
КонецФункции

// Возвращает массив сериализуемых структурных типов, поддерживаемых в настоящее время.
//
// Возвращаемое значение:
//   ФиксированныйМассив из Тип - элементы Тип.
//
Функция СериализуемыеСтруктурныеТипы() Экспорт
	
	МассивТипов = Новый Массив;
	
	МассивТипов.Добавить(Тип("Структура"));
	МассивТипов.Добавить(Тип("ФиксированнаяСтруктура"));
	МассивТипов.Добавить(Тип("Массив"));
	МассивТипов.Добавить(Тип("ФиксированныйМассив"));
	МассивТипов.Добавить(Тип("Соответствие"));
	МассивТипов.Добавить(Тип("ФиксированноеСоответствие"));
	МассивТипов.Добавить(Тип("КлючИЗначение"));
	МассивТипов.Добавить(Тип("ТаблицаЗначений"));
	
	Возврат Новый ФиксированныйМассив(МассивТипов);
	
КонецФункции

// Возвращает конечную точку для отправки сообщений в менеджер сервиса.
//
// Возвращаемое значение:
//  ПланОбменаСсылка.ОбменСообщениями - узел соответствующий менеджеру сервиса.
//
Функция КонечнаяТочкаМенеджераСервиса() Экспорт
	
	Возврат РаботаВМоделиСервисаБТС.КонечнаяТочкаМенеджераСервиса();
	
КонецФункции

// Возвращает соответствие видов контактной информации пользователя видам.
// КИ используемой в XDTO модели сервиса.
//
// Возвращаемое значение:
//  Соответствие - соответствие видов КИ.
//
Функция СоответствиеВидовКИПользователяXDTO() Экспорт
	
	Соответствие = Новый Соответствие;
	Соответствие.Вставить(Справочники.ВидыКонтактнойИнформации.EmailПользователя, "UserEMail");
	Соответствие.Вставить(Справочники.ВидыКонтактнойИнформации.ТелефонПользователя, "UserPhone");
	
	Возврат Новый ФиксированноеСоответствие(Соответствие);
	
КонецФункции

// Возвращает соответствие видов контактной информации XDTO видам.
// КИ пользователя.
//
// Возвращаемое значение:
//  Соответствие - соответствие видов КИ.
//
Функция СоответствиеВидовКИXDTOВидамКИПользователя() Экспорт
	
	Соответствие = Новый Соответствие;
	Для каждого КлючИЗначение Из СоответствиеВидовКИПользователяXDTO() Цикл
		Соответствие.Вставить(КлючИЗначение.Значение, КлючИЗначение.Ключ);
	КонецЦикла;
	
	Возврат Новый ФиксированноеСоответствие(Соответствие);
	
КонецФункции

// Возвращает соответствие прав XDTO используемым в модели сервиса возможным
// действиям с пользователем сервиса.
// 
// Возвращаемое значение:
//  Соответствие - соответствие прав действиям.
//
Функция СоответствиеПравXDTOДействиямСПользователемСервиса() Экспорт
	
	Соответствие = Новый Соответствие;
	Соответствие.Вставить("ChangePassword", "ИзменениеПароля");
	Соответствие.Вставить("ChangeName", "ИзменениеИмени");
	Соответствие.Вставить("ChangeFullName", "ИзменениеПолногоИмени");
	Соответствие.Вставить("ChangeAccess", "ИзменениеДоступа");
	Соответствие.Вставить("ChangeAdmininstrativeAccess", "ИзменениеАдминистративногоДоступа");
	
	Возврат Новый ФиксированноеСоответствие(Соответствие);
	
КонецФункции

// Возвращает описание модели данных, относящихся к области данных.
//
// Возвращаемое значение:
//  ФиксированноеСоответствие из КлючИЗначение:
//    * Ключ - ОбъектМетаданных - объект метаданных,
//    * Значение - Строка - имя общего реквизита-разделителя.
//
Функция ПолучитьМодельДанныхОбласти() Экспорт
	
	Результат = Новый Соответствие();
	
	РазделительОсновныхДанных = РаботаВМоделиСервиса.РазделительОсновныхДанных();
	ОсновныеДанныеОбласти = РазделенныеОбъектыМетаданных(
		РазделительОсновныхДанных);
	Для Каждого ЭлементОсновныхДанныхОбласти Из ОсновныеДанныеОбласти Цикл
		Результат.Вставить(ЭлементОсновныхДанныхОбласти.Ключ, ЭлементОсновныхДанныхОбласти.Значение);
	КонецЦикла;
	
	РазделительВспомогательныхДанных = РаботаВМоделиСервиса.РазделительВспомогательныхДанных();
	ВспомогательныеДанныеОбласти = РаботаВМоделиСервиса.РазделенныеОбъектыМетаданных(
		РазделительВспомогательныхДанных);
	Для Каждого ЭлементВспомогательныхДанныхОбласти Из ВспомогательныеДанныеОбласти Цикл
		Результат.Вставить(ЭлементВспомогательныхДанныхОбласти.Ключ, ЭлементВспомогательныхДанныхОбласти.Значение);
	КонецЦикла;
	
	Возврат Новый ФиксированноеСоответствие(Результат);
	
КонецФункции

// Возвращает массив существующих в конфигурации разделителей.
//
// Возвращаемое значение:
//   ФиксированныйМассив - массив имен общих реквизитов, которые
//     являются разделителями.
//
Функция РазделителиКонфигурации() Экспорт
	
	МассивРазделителей = Новый Массив;
	
	Для Каждого ОбщийРеквизит Из Метаданные.ОбщиеРеквизиты Цикл
		Если ОбщийРеквизит.РазделениеДанных = Метаданные.СвойстваОбъектов.РазделениеДанныхОбщегоРеквизита.Разделять Тогда
			МассивРазделителей.Добавить(ОбщийРеквизит.Имя);
		КонецЕсли;
	КонецЦикла;
	
	Возврат Новый ФиксированныйМассив(МассивРазделителей);
	
КонецФункции

// Возвращает состав общего реквизита с заданным именем.
//
// Параметры:
//   Имя - Строка - имя общего реквизита.
//
// Возвращаемое значение:
//   СоставОбщегоРеквизита - список объектов метаданных, в которые входит общий реквизит.
//
Функция СоставОбщегоРеквизита(Знач Имя) Экспорт
	
	Возврат Метаданные.ОбщиеРеквизиты[Имя].Состав;
	
КонецФункции

// Возвращает список полных имен всех объектов метаданных, использующихся в общем реквизите-разделителе,
//  имя которого передано в качестве значения параметра Разделитель, и значения свойств объекта метаданных,
//  которые могут потребоваться для дальнейшей его обработки в универсальных алгоритмах.
// Для последовательностей и журналов документов определяет разделенность по входящим документам: любому из.
//
// Параметры:
//  Разделитель - Строка - имя общего реквизита.
//
// Возвращаемое значение:
//   ФиксированноеСоответствие из КлючИЗначение:
//   * Ключ - Строка - полное имя объекта метаданных,
//   * Значение - ФиксированнаяСтруктура:
//    * Имя - Строка - имя объекта метаданных,
//    * Разделитель - Строка - имя разделителя, которым разделен объект метаданных,
//    * УсловноеРазделение - Строка - полное имя объекта метаданных, выступающего в качестве условия использования
//      разделения объекта метаданных данным разделителем.
//
Функция РазделенныеОбъектыМетаданных(Знач Разделитель) Экспорт
	
	Результат = Новый Соответствие;
	
	// I. Перебрать состав всех общих реквизитов.
	
	МетаданныеОбщегоРеквизита = Метаданные.ОбщиеРеквизиты.Найти(Разделитель);
	Если МетаданныеОбщегоРеквизита = Неопределено Тогда
		ВызватьИсключение СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Общий реквизит %1 не обнаружен в конфигурации.'"), Разделитель);
	КонецЕсли;
	
	Если МетаданныеОбщегоРеквизита.РазделениеДанных = Метаданные.СвойстваОбъектов.РазделениеДанныхОбщегоРеквизита.Разделять Тогда
		
		СоставОбщегоРеквизита = СоставОбщегоРеквизита(МетаданныеОбщегоРеквизита.Имя);
		
		ИспользоватьОбщийРеквизит = Метаданные.СвойстваОбъектов.ИспользованиеОбщегоРеквизита.Использовать;
		АвтоИспользоватьОбщийРеквизит = Метаданные.СвойстваОбъектов.ИспользованиеОбщегоРеквизита.Авто;
		АвтоИспользованиеОбщегоРеквизита = 
			(МетаданныеОбщегоРеквизита.АвтоИспользование = Метаданные.СвойстваОбъектов.АвтоИспользованиеОбщегоРеквизита.Использовать);
		
		Для Каждого ЭлементСостава Из СоставОбщегоРеквизита Цикл
			
			Если (АвтоИспользованиеОбщегоРеквизита И ЭлементСостава.Использование = АвтоИспользоватьОбщийРеквизит)
				ИЛИ ЭлементСостава.Использование = ИспользоватьОбщийРеквизит 
				ИЛИ (ЭлементСостава.Использование = АвтоИспользоватьОбщийРеквизит И ЭлементСостава.Метаданные.РасширениеКонфигурации() <> Неопределено) Тогда
				
				ДополнительныеДанные = Новый Структура("Имя,Разделитель,УсловноеРазделение", ЭлементСостава.Метаданные.Имя, Разделитель, Неопределено);
				Если ЭлементСостава.УсловноеРазделение <> Неопределено Тогда
					ДополнительныеДанные.УсловноеРазделение = ЭлементСостава.УсловноеРазделение.ПолноеИмя();
				КонецЕсли;
				
				Результат.Вставить(ЭлементСостава.Метаданные.ПолноеИмя(), Новый ФиксированнаяСтруктура(ДополнительныеДанные));
				
				// По регистрам расчета дополнительно определяется разделенность подчиненных им перерасчетов.
				Если ОбщегоНазначения.ЭтоРегистрРасчета(ЭлементСостава.Метаданные) Тогда
					
					Перерасчеты = ЭлементСостава.Метаданные.Перерасчеты;
					Для Каждого Перерасчет Из Перерасчеты Цикл
						
						ДополнительныеДанные.Имя = Перерасчет.Имя;
						Результат.Вставить(Перерасчет.ПолноеИмя(), Новый ФиксированнаяСтруктура(ДополнительныеДанные));
						
					КонецЦикла;
					
				КонецЕсли;
				
			КонецЕсли;
			
		КонецЦикла;
		
	Иначе
		
		ВызватьИсключение СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Для общего реквизита %1 не используется разделение данных.'"), Разделитель);
		
	КонецЕсли;
	
	// II. Для последовательностей и журналов определять разделенность по входящим документам.
	
	// 1) Последовательности. Перебор с проверкой первого входящего документа. Если документов нет, считаем разделенной.
	Для Каждого МетаданныеПоследовательности Из Метаданные.Последовательности Цикл
		
		ДополнительныеДанные = Новый Структура("Имя,Разделитель,УсловноеРазделение", МетаданныеПоследовательности.Имя, Разделитель, Неопределено);
		
		Если МетаданныеПоследовательности.Документы.Количество() = 0 Тогда
			
			ШаблонСообщения = НСтр("ru = 'В последовательность %1 не включено ни одного документа.'");
			ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ШаблонСообщения, МетаданныеПоследовательности.Имя);
			ЗаписьЖурналаРегистрации(НСтр("ru = 'Получение разделенных объектов метаданных'", 
				ОбщегоНазначения.КодОсновногоЯзыка()), УровеньЖурналаРегистрации.Ошибка, 
				МетаданныеПоследовательности, , ТекстСообщения);
			
			Результат.Вставить(МетаданныеПоследовательности.ПолноеИмя(), Новый ФиксированнаяСтруктура(ДополнительныеДанные));
			
		Иначе
			
			Для Каждого МетаданныеДокумента Из МетаданныеПоследовательности.Документы Цикл
				
				ДополнительныеДанныеОтДокумента = Результат.Получить(МетаданныеДокумента.ПолноеИмя());
				
				Если ДополнительныеДанныеОтДокумента <> Неопределено Тогда
					ЗаполнитьЗначенияСвойств(ДополнительныеДанные, ДополнительныеДанныеОтДокумента, "Разделитель,УсловноеРазделение");
					Результат.Вставить(МетаданныеПоследовательности.ПолноеИмя(), Новый ФиксированнаяСтруктура(ДополнительныеДанные));
				КонецЕсли;
				
				Прервать;
				
			КонецЦикла;
			
		КонецЕсли;
		
	КонецЦикла;
	
	// 2) Журналы. Перебор с проверкой первого входящего документа. Если документов нет, считаем разделенным.
	Для Каждого МетаданныеЖурналаДокументов Из Метаданные.ЖурналыДокументов Цикл
		
		ДополнительныеДанные = Новый Структура("Имя,Разделитель,УсловноеРазделение", МетаданныеЖурналаДокументов.Имя, Разделитель, Неопределено);
		
		Если МетаданныеЖурналаДокументов.РегистрируемыеДокументы.Количество() = 0 Тогда
			
			ШаблонСообщения = НСтр("ru = 'В журнал %1 не включено ни одного документа.'");
			ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ШаблонСообщения, МетаданныеЖурналаДокументов.Имя);
			ЗаписьЖурналаРегистрации(НСтр("ru = 'Получение разделенных объектов метаданных'", 
				ОбщегоНазначения.КодОсновногоЯзыка()), УровеньЖурналаРегистрации.Ошибка, 
				МетаданныеЖурналаДокументов, , ТекстСообщения);
			
			Результат.Вставить(МетаданныеЖурналаДокументов.ПолноеИмя(), Новый ФиксированнаяСтруктура(ДополнительныеДанные));
			
		Иначе
			
			Для Каждого МетаданныеДокумента Из МетаданныеЖурналаДокументов.РегистрируемыеДокументы Цикл
				
				ДополнительныеДанныеОтДокумента = Результат.Получить(МетаданныеДокумента.ПолноеИмя());
				
				Если ДополнительныеДанныеОтДокумента <> Неопределено Тогда
					ЗаполнитьЗначенияСвойств(ДополнительныеДанные, ДополнительныеДанныеОтДокумента, "Разделитель,УсловноеРазделение");
					Результат.Вставить(МетаданныеЖурналаДокументов.ПолноеИмя(), Новый ФиксированнаяСтруктура(ДополнительныеДанные));
				КонецЕсли;
				
				Прервать;
				
			КонецЦикла;
			
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат Новый ФиксированноеСоответствие(Результат);
	
КонецФункции

#КонецОбласти
