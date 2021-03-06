
# 1c-versioning-complex-objects

Подсистема сложносочиненного версионирования

## Вступление

Статья описывает мою личную боль при работе в Управление холдингом, редакция 3.0, и может не совпадать с вашими ощущениями. Прощу учитывать, что это лишь мысленный эксперимент.

В качестве эксперимента поставил себе задачу: "Как отслеживать изменения, для объектов, которые состоят из нескольких других объектов?".

## Рассмотрим несколько примеров

Справочник "Валюты" и его реквизиты:

![Картинка](/images/SharedScreenshot1.jpg)

На форме видим элементы ссылающиеся только на значения реквизитов объекта:

![Картинка](/images/SharedScreenshot2.jpg)

т.е. у нас полный гештальт, то, что хранится в объекте под названием валюта, совпадает с тем, что видит бухгалтер на форме объекта.

Соответственно, мы можем взять подсистему "Версионирование объектов" из комплекта "Библиотеки стандартных подсистем" от 1С, включить отслеживание изменений при записи для валют и быть уверенными, что всегда сможем увидеть предыдущие версии объекта и что было изменено.

Рассмотрим другой пример, справочник "Шаблоны трансформационных корректировок" и его реквизиты:

![Картинка](/images/SharedScreenshot3.jpg)

Обратите внимание на то, что у справочника отсутствует табличная часть в дереве конфигурации.

Форма справочника содержит табличную часть "Шаблоны проводок", которой нет в дереве конфигурации:

![Картинка](/images/SharedScreenshot4.jpg)

Путь к данным у табличной части "ШаблоныПроводок":

![Картинка](/images/SharedScreenshot5.jpg)

"ШаблоныПроводок" - это таблица значений, которая собирается при открытии формы и записывается соответственно при записи формы.
Данные выбираются запросом:

![Картинка](/images/SharedScreenshot6.jpg)

И из запроса понятно, что почти все элементы формы не являются реквизитами объекта справочника "Шаблоны трансформационных корректировок".

Здесь у пользователя случается древний ужас.
Чтобы получить целостную картину, по одному объекту справочника, нужно прошерстить несколько разных таблиц, преодолеть когнитивное сопротивление и возможно даже построить график связей.

![Картинка](/images/SharedScreenshot7.jpg)

Но ведь! Это один объект, почему же так сложно? - потому что произошла протечка абстракции.

## Решение, подсистема "Версионирование сложносочиненных объектов"

90% кода, это подсистема "Версионирования объектов", спасибо 1С за отличную подсистему. Я только скопировал объекты и код, адаптировав под свой эксперимент, чтобы решения не пересекались.

1. Добавил подсистему "Версионирование сложносочиненных объектов".
Состав подсистемы и пример работы можно самостоятельно посмотреть в демо примере на базе "Библиотека стандартных подсистем", редакция 3.1. т.е. Я скопировал общую команду для вызова формы истории хранимых объектов, регистр сведений для хранения версий, общие модули и так далее. Все переименовал и чуть-чуть изменил под себя. По-этому не буду подробно описывать каждую процедуру, все есть в моем демо примере на [GitHub](https://github.com/johnnyshut/1c-versioning-complex-objects) или в этой статье;

2. В форму объект который требуется контролировать, добавил код перед записью на сервере;

![Картинка](/images/SharedScreenshot8.jpg)

1. В Регистре сведений и в общей команде установил объектами мой справочник, который хочу контролировать;

2. В предприятии открыл подсистему "Дополнительные служебные подсистемы", открыл форму "Дополнительная форма настройки" и установил флаг "Использовать версионирование сложносочиненных объектов". Готово.

Кнопка вызове версий

![Картинка](/images/SharedScreenshot9.jpg)

Информация о версии

![Картинка](/images/SharedScreenshot10.jpg)

Сравнение версий

![Картинка](/images/SharedScreenshot11.jpg)

Демо пример реализовал на основе конфигурации "Демо БСП", добавил "Справочник для проверки системы сложносочиненного версионирования" и "Регистр сведений для проверки системы сложносочиненного версионирования" для показа работы механизма.

### PS

Коллеги, я согласен со всеми вашими доводами, за то, что мое решение не до конца решает задачу, по этому это лишь эксперимент. Буду рад вашей критике и идеям как лучше реализовать такое версионирование.

### Минусы

- Пользователь может зайти в регистр сведений и внести правки в него. В таком случаи факт изменения зафиксируется только при следующей записи (Но! Много таких пользователей вы знаете? Кроме программистов);
- Если реализована сложная логика при записи, то при групповом изменении объекта (Обработкой) могут быть изменены записи реестров, при этом новая версия не зафиксируется, потому что запись версии я вызываю из формы объекта, а как по другому? Мне ведь нужен универсальный механизм, который бы записывал данные, которые инициализируются только в открытой форме;
- А в УХ если забыть расставить везде признаки модификации, то даже из формы пользователь сможет сохранить данные в регистр, без записи объекта. Но это скорее минус разработчиков УХ, данную проблему можно обойти - записывая связанные регистры только вместе с записью объекта.
