﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2021, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Возвращает данные объекта из Менеджера сервиса по правилу трансляции.
// @skip-warning ПустойМетод - особенность реализации.
//
// Параметры:
//  ИдентификаторПравила - Строка - идентификатор правила трансляции с типом "Чтение". 
//  КлючОбъекта - Строка, Число - ключ объекта, определенный в правиле.
// 
// Возвращаемое значение:
//  Структура - данные объекта или Неопределено, если данные не получены.
//
Функция ПолучитьДанныеОбъектаПоПравилу(ИдентификаторПравила, КлючОбъекта) Экспорт
КонецФункции 

// Отправляет данные в Менеджер сервиса.
// @skip-warning ПустойМетод - особенность реализации.
//
// Параметры:
//  ИдентификаторПравила - Строка - идентификатор правила трансляции с типом "Загрузка". 
//  Данные - Структура - данные для отправки в менеджер сервиса. 
// 
// Возвращаемое значение:
//  Структура - результат выполнения запроса:
//   * КодСостояния - Число - код состояния ответа.
//   * ТелоОтвета - Строка - тело ответа в виде строки.
//   * ДанныеОтвета - Структура, Неопределено - если ответ содержит заголовок "Content-Type: application/json"
//                                              возвращается Структура.
//
Функция ОтправитьДанныеОбъектаПоПравилу(ИдентификаторПравила, Данные = Неопределено) Экспорт
КонецФункции

// Изменяет объект в Менеджере сервиса по правилу трансляции.
// @skip-warning ПустойМетод - особенность реализации.
//
// Параметры:
//  ИдентификаторПравила - Строка - идентификатор правила трансляции с типом "Загрузка". 
//  КлючОбъекта - Строка, Число - ключ объекта, определенный в правиле.
//  Данные - Структура - данные для отправки в менеджер сервиса. 
// 
// Возвращаемое значение:
//  Структура:
//   * КодСостояния - Число - код состояния ответа.
//   * ТелоОтвета - Строка - тело ответа.
//   * ДанныеОтвета - Структура, Неопределено - если ответ содержит заголовок Content-Type: application/json
//                                              возвращается Структура.
//
Функция ИзменитьДанныеОбъектаПоПравилу(ИдентификаторПравила, КлючОбъекта, Данные = Неопределено) Экспорт
КонецФункции

// Метод позволяет подписаться на оповещения об изменении объектов в менеджере сервиса.
// @skip-warning ПустойМетод - особенность реализации.
//
// Параметры:
//  ИдентификаторПравила - Строка - идентификатор правила трансляции. 
//  КлючОбъекта - Строка - ключ объекта интеграции на обновления которого подписываемся.
//
Процедура ПодписатьсяНаОповещенияОбИзменении(ИдентификаторПравила, КлючОбъекта) Экспорт
КонецПроцедуры

// Метод позволяет отписаться от оповещений об изменении объектов в менеджере сервиса.
// @skip-warning ПустойМетод - особенность реализации.
//
// Параметры:
//  ИдентификаторПравила - Строка - идентификатор правила трансляции
//  КлючОбъекта - Строка - ключ объекта, по которому отписываемся от оповещений об обновлениях.
//
Процедура ОтписатьсяОтОповещенийНаИзменения(ИдентификаторПравила, КлючОбъекта) Экспорт
КонецПроцедуры

// Функция позволяет прочитать полученные данные объекта по ключу полученных данных.
// @skip-warning ПустойМетод - особенность реализации.
//
// Параметры:
//  ИдентификаторПравила - Строка - идентификатор правила трансляции.
//  КлючОбъекта - Строка - ключ объекта.
// 
// Возвращаемое значение:
//   Структура - прочитанные полученные данные объекта.
//
Функция ПрочитатьПолученныеДанныеОбъекта(ИдентификаторПравила, КлючОбъекта) Экспорт
КонецФункции
 
#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

// Процедура позволяет записать или заранее инициализировать полученные данные объекта
// по ключу полученных данных.
// @skip-warning ПустойМетод - особенность реализации.
//
// Параметры:
//  ИдентификаторПравила - Строка -идентификатор правила трансляции
//  КлючОбъекта - Строка - ключ объекта.
//  Данные - Структура - сохраняемые полученные данные объекта.
//
Процедура ЗаписатьПолученныеДанныеОбъекта(ИдентификаторПравила, КлючОбъекта, Данные) Экспорт
КонецПроцедуры

#КонецОбласти 
