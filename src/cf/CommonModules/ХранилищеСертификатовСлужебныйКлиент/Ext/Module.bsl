﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2021, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область СлужебныйПрограммныйИнтерфейс

Процедура Добавить(ОповещениеОЗавершении, Сертификат, ТипХранилища) Экспорт

	РезультатВыполнения = Новый Структура("Выполнено");
	Попытка
		ХранилищеСертификатовСлужебныйВызовСервера.Добавить(Сертификат, ТипХранилища);
		РезультатВыполнения.Выполнено = Истина;
	Исключение
		РезультатВыполнения.Выполнено = Ложь;
		РезультатВыполнения.Вставить("ИнформацияОбОшибке", ИнформацияОбОшибке());
	КонецПопытки;
	
	ВыполнитьОбработкуОповещения(ОповещениеОЗавершении, РезультатВыполнения);
	
КонецПроцедуры

Процедура Получить(ОповещениеОЗавершении, ТипХранилища = Неопределено) Экспорт
	
	РезультатВыполнения = Новый Структура("Выполнено");
	Попытка
		Сертификаты = ХранилищеСертификатовСлужебныйВызовСервера.Получить(ТипХранилища);
		РезультатВыполнения.Выполнено = Истина;
		РезультатВыполнения.Вставить("Сертификаты", Сертификаты);
	Исключение
		РезультатВыполнения.Выполнено = Ложь;
		РезультатВыполнения.Вставить("ИнформацияОбОшибке", ИнформацияОбОшибке());
	КонецПопытки;
	
	ВыполнитьОбработкуОповещения(ОповещениеОЗавершении, РезультатВыполнения);
	
КонецПроцедуры

Процедура НайтиСертификат(ОповещениеОЗавершении, Сертификат) Экспорт
	
	РезультатВыполнения = Новый Структура("Выполнено");
	Попытка
		НайденныйСертификат = ХранилищеСертификатовСлужебныйВызовСервера.НайтиСертификат(Сертификат);
		РезультатВыполнения.Выполнено = Истина;
		РезультатВыполнения.Вставить("Сертификат", НайденныйСертификат);
	Исключение
		РезультатВыполнения.Выполнено = Ложь;
		РезультатВыполнения.Вставить("ИнформацияОбОшибке", ИнформацияОбОшибке());
	КонецПопытки;
	
	ВыполнитьОбработкуОповещения(ОповещениеОЗавершении, РезультатВыполнения);
	
КонецПроцедуры

#КонецОбласти