﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2021, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область СлужебныйПрограммныйИнтерфейс

// См. ВыгрузкаЗагрузкаДанныхПереопределяемый.ПослеЗагрузкиДанных
// @skip-warning ПустойМетод - особенность реализации.
//
Процедура ПослеЗагрузкиДанных(Контейнер) Экспорт
КонецПроцедуры

// См. ОбновлениеИнформационнойБазыБСП.ПриДобавленииОбработчиковОбновления
// @skip-warning ПустойМетод - особенность реализации.
//
Процедура ПриДобавленииОбработчиковОбновления(Обработчики) Экспорт
КонецПроцедуры

// Создает в текущей области данных задания по шаблонам.
// @skip-warning ПустойМетод - особенность реализации.
//
Процедура СоздатьЗаданияОчередиПоШаблонамВТекущейОбласти() Экспорт
КонецПроцедуры

// См. РаботаВМоделиСервисаПереопределяемый.ПриВключенииРазделенияПоОбластямДанных
// @skip-warning ПустойМетод - особенность реализации.
//
Процедура ПриВключенииРазделенияПоОбластямДанных() Экспорт
КонецПроцедуры

// См. ВыгрузкаЗагрузкаДанныхПереопределяемый.ПриЗаполненииТиповИсключаемыхИзВыгрузкиЗагрузки
Процедура ПриЗаполненииТиповИсключаемыхИзВыгрузкиЗагрузки(Типы) Экспорт
	
	Типы.Добавить(Метаданные.Справочники.ОчередьЗаданийОбластейДанных);
	
КонецПроцедуры

#КонецОбласти
