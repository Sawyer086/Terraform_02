# Домашнее задание к занятию «Основы Terraform. Yandex Cloud»

### Цели задания

1. Создать свои ресурсы в облаке Yandex Cloud с помощью Terraform.
2. Освоить работу с переменными Terraform.


### Чек-лист готовности к домашнему заданию

1. Зарегистрирован аккаунт в Yandex Cloud. Использован промокод на грант.
2. Установлен инструмент Yandex CLI.
3. Исходный код для выполнения задания расположен в директории [**02/src**](https://github.com/netology-code/ter-homeworks/tree/main/02/src).


### Задание 0

1. Ознакомьтесь с [документацией к security-groups в Yandex Cloud](https://cloud.yandex.ru/docs/vpc/concepts/security-groups?from=int-console-help-center-or-nav). 
Этот функционал понадобится к следующей лекции.

------
### Внимание!! Обязательно предоставляем на проверку получившийся код в виде ссылки на ваш github-репозиторий!
------

### Задание 1
В качестве ответа всегда полностью прикладывайте ваш terraform-код в git.
Убедитесь что ваша версия **Terraform** ~>1.8.4

1. Изучите проект. В файле variables.tf объявлены переменные для Yandex provider.
2. Создайте сервисный аккаунт и ключ. [service_account_key_file](https://terraform-provider.yandexcloud.net).
4. Сгенерируйте новый или используйте свой текущий ssh-ключ. Запишите его открытую(public) часть в переменную **vms_ssh_public_root_key**.
5. Инициализируйте проект, выполните код. Исправьте намеренно допущенные синтаксические ошибки. Ищите внимательно, посимвольно. Ответьте, в чём заключается их суть.
6. Подключитесь к консоли ВМ через ssh и выполните команду ``` curl ifconfig.me```.
Примечание: К OS ubuntu "out of a box, те из коробки" необходимо подключаться под пользователем ubuntu: ```"ssh ubuntu@vm_ip_address"```. Предварительно убедитесь, что ваш ключ добавлен в ssh-агент: ```eval $(ssh-agent) && ssh-add``` Вы познакомитесь с тем как при создании ВМ создать своего пользователя в блоке metadata в следующей лекции.;
8. Ответьте, как в процессе обучения могут пригодиться параметры ```preemptible = true``` и ```core_fraction=5``` в параметрах ВМ.

В качестве решения приложите:

- скриншот ЛК Yandex Cloud с созданной ВМ, где видно внешний ip-адрес;
- скриншот консоли, curl должен отобразить тот же внешний ip-адрес;
- ответы на вопросы.


### Задание 2

1. Замените все хардкод-**значения** для ресурсов **yandex_compute_image** и **yandex_compute_instance** на **отдельные** переменные. К названиям переменных ВМ добавьте в начало префикс **vm_web_** .  Пример: **vm_web_name**.
2. Объявите нужные переменные в файле variables.tf, обязательно указывайте тип переменной. Заполните их **default** прежними значениями из main.tf. 
3. Проверьте terraform plan. Изменений быть не должно. 


### Задание 3

1. Создайте в корне проекта файл 'vms_platform.tf' . Перенесите в него все переменные первой ВМ.
2. Скопируйте блок ресурса и создайте с его помощью вторую ВМ в файле main.tf: **"netology-develop-platform-db"** ,  ```cores  = 2, memory = 2, core_fraction = 20```. Объявите её переменные с префиксом **vm_db_** в том же файле ('vms_platform.tf').  ВМ должна работать в зоне "ru-central1-b"
3. Примените изменения.


### Задание 4

1. Объявите в файле outputs.tf **один** output , содержащий: instance_name, external_ip, fqdn для каждой из ВМ в удобном лично для вас формате.(без хардкода!!!)
2. Примените изменения.

В качестве решения приложите вывод значений ip-адресов команды ```terraform output```.


### Задание 5

1. В файле locals.tf опишите в **одном** local-блоке имя каждой ВМ, используйте интерполяцию ${..} с НЕСКОЛЬКИМИ переменными по примеру из лекции.
2. Замените переменные внутри ресурса ВМ на созданные вами local-переменные.
3. Примените изменения.


### Задание 6

1. Вместо использования трёх переменных  ".._cores",".._memory",".._core_fraction" в блоке  resources {...}, объедините их в единую map-переменную **vms_resources** и  внутри неё конфиги обеих ВМ в виде вложенного map(object).  
   ```
   пример из terraform.tfvars:
   vms_resources = {
     web={
       cores=2
       memory=2
       core_fraction=5
       hdd_size=10
       hdd_type="network-hdd"
       ...
     },
     db= {
       cores=2
       memory=4
       core_fraction=20
       hdd_size=10
       hdd_type="network-ssd"
       ...
     }
   }
   ```
3. Создайте и используйте отдельную map(object) переменную для блока metadata, она должна быть общая для всех ваших ВМ.
   ```
   пример из terraform.tfvars:
   metadata = {
     serial-port-enable = 1
     ssh-keys           = "ubuntu:ssh-ed25519 AAAAC..."
   }
   ```  
  
5. Найдите и закоментируйте все, более не используемые переменные проекта.
6. Проверьте terraform plan. Изменений быть не должно.
   
---

## Ответ:

## Задание 1:

### 1-3

![1](https://github.com/Sawyer086/Terraform_02/blob/main/1/4.jpg)
![2](https://github.com/Sawyer086/Terraform_02/blob/main/1/5.jpg)
![3](https://github.com/Sawyer086/Terraform_02/blob/main/1/3.jpg)

### 4

```
Error: Invalid function argument  
on providers.tf line 15, in provider "yandex":  
15:   service_account_key_file = file("~/.authorized_key.json")
```
Необходимо прописать правильный путь расположения файла key с авторизованным ключом в "providers.tf".

В моем случае исправляем service_account_key_file = file("~/.authorized_key.json") на service_account_key_file = file("/home/sergey/authorized_key.json")

  
```
Error: Error getting zone while creating instance: cannot determine zone: please set 'zone' key in this resource or at provider level  
with yandex_compute_instance.platform,
on main.tf line 15, in resource "yandex_compute_instance" "platform":  
15: resource "yandex_compute_instance" "platform" {  
```  
В "main.tf" необходимо указать 'zone' для resource "yandex_compute_instance" "platform"  

zone = var.default_zone

 
```
Error: Error while requesting API to create instance: server-request-id = 977f3a20-8cba-45db-aa73-0b21c9a8d2ea server-trace-id = 6202ad1949a277c1:cd23bee50c70ea28:6202ad1949a277c1:1 client-request-id = 84c11257-acb0-4aa7-81c4-fe3aa3b2f003 client-trace-id = a219bef6-028b-4e0c-b816-73828b045169 rpc error: code = FailedPrecondition desc = Platform "standart-v4" not found  
with yandex_compute_instance.platform,
on main.tf line 15, in resource "yandex_compute_instance" "platform":  
15: resource "yandex_compute_instance" "platform" {  
```
Неверный идентификатор платформы для resource "yandex_compute_instance" "platform"  

Источник: [https://yandex.cloud/en/docs/compute/concepts/vm-platforms](https://yandex.cloud/en/docs/compute/concepts/vm-platforms)  

Исправляем на platform_id = "standard-v3"

  
```
Error: Error while requesting API to create instance: server-request-id = 97a5b7b5-859a-4494-ba51-d5b9f6166d07 server-trace-id = d26c6754f6cd3021:910909cfe8a764b6:d26c6754f6cd3021:1 client-request-id = 7747d459-8a38-4136-bf03-60336058c6b7 client-trace-id = fe820e36-8c47-4ed2-91dd-c310315f2191 rpc error: code = InvalidArgument desc = the specified core fraction is not available on platform "standard-v3"; allowed core fractions: 20, 50, 100   
with yandex_compute_instance.platform,  
on main.tf line 15, in resource "yandex_compute_instance" "platform":  
15: resource "yandex_compute_instance" "platform" {  
```

Неверное значение фракции ядра для resource "yandex_compute_instance" "platform"  

Исправляем на core_fraction = 20

  
```

Error: Error while requesting API to create instance: server-request-id = daf09046-5b9c-474c-a81e-3c1ef7fcb2eb server-trace-id = 404e96bd67081154:97ad46e02cd8f36b:404e96bd67081154:1 client-request-id = 31ac8a87-388e-42ce-b0e4-154bfdb694b7 client-trace-id = 717e8c82-0d88-4e0e-bc16-2992ee4d97e6 rpc error: code = InvalidArgument desc = the specified number of cores is not available on platform "standard-v3"; allowed core number: 2, 4  
with yandex_compute_instance.platform,  
on main.tf line 15, in resource "yandex_compute_instance" "platform":  
15: resource "yandex_compute_instance" "platform" {  
```

Неверное значение числа ядер для resource "yandex_compute_instance" "platform".

Исправляем на cores = 2

### 5
![1](https://github.com/Sawyer086/Terraform_02/blob/main/1/1.jpg)
![2](https://github.com/Sawyer086/Terraform_02/blob/main/1/2.jpg)

### 6 
Параметры preemptible = true и core_fraction = 5 в Yandex Cloud могут существенно помочь в обучении и экономии ресурсов:

### preemptible = true
1. Экономичность:
   - Преemptible (прерываемая) ВМ стоит значительно дешевле обычной;
   - Идеально для учебных проектов с ограниченным бюджетом.
2. Особенности использования:
   - Может быть прервана провайдером в любой момент (обычно через 24 часа);
   - Подходит для временных сред разработки;
   - Отлично работает для тестирования кода.
3. Сценарии применения в обучении:
   - Разработка и тестирование небольших проектов;
   - Эксперименты с новыми технологиями;
   - Обучение работе с облачными сервисами;
   - Создание временных сред для практических заданий.
     
### core_fraction = 5
1. Базовые характеристики:
   - Определяет минимальную гарантированную производительность процессора;
   - Значение от 5 до 100 (где 100 - полная мощность);
   - 5% - минимальная гарантированная производительность.
2. Преимущества для обучения:
   - Существенная экономия при длительной работе;
   - Достаточно для большинства учебных задач;
   - Подходит для работы с простыми приложениями.
3. Сценарии применения:
   - Разработка на начальных этапах;
   - Тестирование простых сервисов;
   - Изучение основ DevOps;
   - Работа с небольшими базами данных.
     
### Задание 2:
![1](https://github.com/Sawyer086/Terraform_02/tree/main/2)
