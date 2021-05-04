﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2018, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// Подсистема "Интернет-поддержка пользователей".
// ОбщийМодуль.ИнтернетПоддержкаПользователейКлиентПереопределяемый.
//
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Переопределяет открытие Интернет-страницы в конфигурации, если для открытия
// Интернет-страниц в конфигурации предусмотрены собственные механизмы.
// Если в конфигурации не используются собственные механизмы для открытия
// Интернет-страниц, тогда необходимо оставить тело процедуры пустым, в
// противном случае параметру СтандартнаяОбработка необходимо присвоить
// значение Ложь.
//
// Параметры:
//	АдресСтраницы - Строка - URL-адрес открываемой Интернет-страницы;
//	ЗаголовокОкна - Строка - заголовок окна, в котором отображается
//		Интернет-страница, если для открытия Интернет-страницы
//		используется внутренняя форма конфигурации;
//	СтандартнаяОбработка - Булево - в параметре возвращается признак
//		необходимости открытия Интернет-страницы стандартным способом.
//		Значение по умолчанию - Истина.
//
Процедура ОткрытьИнтернетСтраницу(АдресСтраницы, ЗаголовокОкна, СтандартнаяОбработка) Экспорт
	
	
	
КонецПроцедуры

#КонецОбласти
