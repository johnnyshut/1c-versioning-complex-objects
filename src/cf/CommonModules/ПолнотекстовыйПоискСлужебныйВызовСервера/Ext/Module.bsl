﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2021, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область СлужебныеПроцедурыИФункции

// Устанавливает режим полнотекстового поиска
// Выполняет:
//   - изменяет режим платформенного механизма полнотекстового поиска
//   - установку значение в константу ИспользоватьПолнотекстовыйПоиск
//   - изменяет значение функциональной опции ИспользоватьПолнотекстовыйПоиск
//   - изменяется режим регламентного задание ОбновлениеИндексаППД
//   - изменяется режим регламентного задание СлияниеИндексаППД
//   - изменяется режим регламентного задание ИзвлечениеТекста подсистемы РаботаСФайлами
//
Функция УстановитьРежимПолнотекстовогоПоиска(ИспользоватьПолнотекстовыйПоиск) Экспорт
	
	Если Не Пользователи.ЭтоПолноправныйПользователь(,, Ложь) Тогда
		ВызватьИсключение НСтр("ru = 'Недостаточно прав для совершения операции.'");
	КонецЕсли;
	
	Попытка
		Константы.ИспользоватьПолнотекстовыйПоиск.Установить(ИспользоватьПолнотекстовыйПоиск);	
	Исключение
		Возврат Ложь;
	КонецПопытки;
	
	Возврат Истина;
	
КонецФункции

// (См. ПолнотекстовыйПоискСервер.ЗначениеФлажкаИспользоватьПоиск)
//
Функция ЗначениеФлажкаИспользоватьПоиск() Экспорт

	Возврат ПолнотекстовыйПоискСервер.ЗначениеФлажкаИспользоватьПоиск();

КонецФункции

#КонецОбласти

