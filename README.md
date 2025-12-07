# Домашнее задание к занятию «Использование Terraform в команде»

### Цели задания

1. Научиться использовать remote state с блокировками.
2. Освоить приёмы командной работы.


### Чек-лист готовности к домашнему заданию

1. Зарегистрирован аккаунт в Yandex Cloud. Использован промокод на грант.
2. Установлен инструмент Yandex CLI.
3. Любые ВМ, использованные при выполнении задания, должны быть прерываемыми, для экономии средств.

------
### Внимание!! Обязательно предоставляем на проверку получившийся код в виде ссылки на ваш github-репозиторий!
Убедитесь что ваша версия **Terraform** ~>1.12.0
Пишем красивый код, хардкод значения не допустимы!

------
### Задание 0
1. Прочтите статью: https://neprivet.com/
2. Пожалуйста, распространите данную идею в своем коллективе.

------

### Задание 1

1. Возьмите код:
- из [ДЗ к лекции 4](https://github.com/netology-code/ter-homeworks/tree/main/04/src),
- из [демо к лекции 4](https://github.com/netology-code/ter-homeworks/tree/main/04/demonstration1).
2. Проверьте код с помощью tflint и checkov. Вам не нужно инициализировать этот проект.
3. Перечислите, какие **типы** ошибок обнаружены в проекте (без дублей).

------

### Задание 2

1. Возьмите ваш GitHub-репозиторий с **выполненным ДЗ 4** в ветке 'terraform-04' и сделайте из него ветку 'terraform-05'.
2. Настройте remote state с встроенными блокировками:
   - Создайте S3 bucket в Yandex Cloud для хранения state (если еще не создан)
   - Создайте service account с правами на чтение/запись в bucket
   - Настройте backend в providers.tf с использованием нового механизма блокировок:
     ```hcl
     terraform {
       required_version = "~>1.12.0"
       
       backend "s3" {
         bucket  = "ваш-bucket-name"
         key     = "terraform.tfstate"
         region  = "ru-central1"
         
         # Встроенный механизм блокировок (Terraform >= 1.6)
         # Не требует отдельной базы данных!
         use_lockfile = true
         
         endpoints = {
           s3 = "https://storage.yandexcloud.net"
         }
         
         skip_region_validation      = true
         skip_credentials_validation = true
         skip_requesting_account_id  = true
         skip_s3_checksum            = true
       }
     }
     ```
   - Выполните `terraform init -migrate-state` для миграции state в S3
   - Предоставьте скриншоты процесса настройки и миграции
3. Закоммитьте в ветку 'terraform-05' все изменения.
4. Откройте в проекте terraform console, а в другом окне из этой же директории попробуйте запустить terraform apply.
5. Пришлите ответ об ошибке доступа к state (блокировка должна сработать автоматически).
6. Принудительно разблокируйте state командой `terraform force-unlock <LOCK_ID>`. Пришлите команду и вывод.

**Примечание:** В Terraform >= 1.6 появился встроенный механизм блокировок через `use_lockfile = true`. 
Это упрощает настройку - больше не нужно создавать отдельную базу данных (YDB в режиме DynamoDB) для хранения блокировок.
Lock-файл создается автоматически в том же S3 bucket рядом с state-файлом с именем `<key>.lock.info`.


------
### Задание 3  

1. Сделайте в GitHub из ветки 'terraform-05' новую ветку 'terraform-hotfix'.
2. Проверье код с помощью tflint и checkov, исправьте все предупреждения и ошибки в 'terraform-hotfix', сделайте коммит.
3. Откройте новый pull request 'terraform-hotfix' --> 'terraform-05'. 
4. Вставьте в комментарий PR результат анализа tflint и checkov, план изменений инфраструктуры из вывода команды terraform plan.
5. Пришлите ссылку на PR для ревью. Вливать код в 'terraform-05' не нужно.

------
### Задание 4

1. Напишите переменные с валидацией и протестируйте их, заполнив default верными и неверными значениями. Предоставьте скриншоты проверок из terraform console. 

- type=string, description="ip-адрес" — проверка, что значение переменной содержит верный IP-адрес с помощью функций cidrhost() или regex(). Тесты:  "192.168.0.1" и "1920.1680.0.1";
- type=list(string), description="список ip-адресов" — проверка, что все адреса верны. Тесты:  ["192.168.0.1", "1.1.1.1", "127.0.0.1"] и ["192.168.0.1", "1.1.1.1", "1270.0.0.1"].

## Дополнительные задания (со звёздочкой*)

**Настоятельно рекомендуем выполнять все задания со звёздочкой.** Их выполнение поможет глубже разобраться в материале.   
Задания со звёздочкой дополнительные, не обязательные к выполнению и никак не повлияют на получение вами зачёта по этому домашнему заданию. 
------
### Задание 5*
1. Напишите переменные с валидацией:
- type=string, description="любая строка" — проверка, что строка не содержит символов верхнего регистра;
- type=object — проверка, что одно из значений равно true, а второе false, т. е. не допускается false false и true true:
```
variable "in_the_end_there_can_be_only_one" {
    description="Who is better Connor or Duncan?"
    type = object({
        Dunkan = optional(bool)
        Connor = optional(bool)
    })

    default = {
        Dunkan = true
        Connor = false
    }

    validation {
        error_message = "There can be only one MacLeod"
        condition = <проверка>
    }
}
```
------
### Задание 6*

1. Настройте любую известную вам CI/CD-систему. Если вы ещё не знакомы с CI/CD-системами, настоятельно рекомендуем вернуться к этому заданию после изучения Jenkins/Teamcity/Gitlab.
2. Скачайте с её помощью ваш репозиторий с кодом и инициализируйте инфраструктуру.
3. Уничтожьте инфраструктуру тем же способом.


------
### Задание 7*
1. Настройте отдельный terraform root модуль, который будет создавать инфраструктуру для remote state:
   - S3 bucket для tfstate с версионированием
   - Сервисный аккаунт с необходимыми правами (storage.editor)
   - Static access key для сервисного аккаунта
2. Output должен содержать:
   - Имя bucket
   - Access key ID и Secret key (sensitive)
   - Пример конфигурации backend для использования
3. После создания инфраструктуры используйте outputs для настройки backend в основном проекте.

**Примечание:** Так как используется `use_lockfile = true`, создавать YDB/DynamoDB больше не требуется.
Блокировки реализованы встроенным механизмом Terraform и хранятся в том же S3 bucket. 

### Правила приёма работы

Ответы на задания и необходимые скриншоты оформите в md-файле в ветке terraform-05.

В качестве результата прикрепите ссылку на ветку terraform-05 в вашем репозитории.

**Важно.** Удалите все созданные ресурсы.

### Критерии оценки

Зачёт ставится, если:

* выполнены все задания,
* ответы даны в развёрнутой форме,
* приложены соответствующие скриншоты и файлы проекта,
* в выполненных заданиях нет противоречий и нарушения логики.

На доработку работу отправят, если:

* задание выполнено частично или не выполнено вообще,
* в логике выполнения заданий есть противоречия и существенные недостатки. 


------
# Решение

### Задание 1

Установка `tflint`:

``` curl -s https://raw.githubusercontent.com/terraform-linters/tflint/master/install_linux.sh | bash  ```

или используя docker
``` docker run --rm -v $(pwd):/data -t ghcr.io/terraform-linters/tflint ```

Установка `checkov`:

``` pip install checkov ```

или используя docker
``` docker pull bridgecrew/checkov ```


Результат запуска `tflint`:

``` tflint ```

![tflint](./img/tf-05.1.1.png)
Ошибки в основном связанные с неиспользованием переменных. Одна ошибка по версии провайдера yandex. Ктати странно, пришлось добпавить поле `version = ">= 0.13"` в `required_providers` в `providers.tf`


Результат запуска `checkov`:

``` checkov ```
или 
``` checkov -d . ```

![checkov](./img/tf-05.1.2.png)

Результаты запуска `tflint` и `checkov` показывают, что в проекте нет критических ошибок.


### Задание 2

В чём трудность с ``` s3 bucket backend ```. 
Во-первых, сложность в том, что происходит циклическая зависимость. Дело в том, что нам нужно создать S3 bucket для state, но если сам state нужен для его создания!

Для этого в ` terraform -> backend ` мы указываем необходимые для **terraform** настройки:
[вот хорошая статья у yandex](https://yandex.cloud/ru/docs/tutorials/infrastructure-management/terraform-state-storage#create-service-account)

```hcl
  backend "s3" {
    endpoints = {
      s3 = "https://storage.yandexcloud.net"
    }
    bucket = "s3-core"
    region = "ru-central1"
    key    = "prod/terraform.tfstate"

    skip_region_validation      = true
    skip_credentials_validation = true
    skip_requesting_account_id  = true # Необходимая опция Terraform для версии 1.6.1 и старше.
    skip_s3_checksum            = true # Необходимая опция при описании бэкенда для Terraform версии 1.6.3 и старше.

  }
```
Во-вторых, есть много способов как это всё настроить и сделать.

Вообще для работы с s3 рекомендуют заводить отдельный SA аккаунт. Что мы и сделаем.
Создадим аккаунт:
```bash
yc iam service-account create --name s3-robot
```
Накидываем ему прав:
```bash
yc resource-manager folder add-access-binding <folder-id>  
--role storage.editor --subject serviceAccount:<sa-id>
```
<folder-id> и <sa-id> можно взять из вывода предыдущей команды.

и генерируем [`статический ключ доступа`](https://yandex.cloud/ru/docs/iam/operations/authentication/manage-access-keys#create-access-key):
```bash
yc iam access-key create --service-account-name s3-robot > s3.key
```
Для дальнейшей работы с s3 terraform нужны **access_key** и **secret_key**. 
Отформатируем файл таким образом:
```
ACCESS_KEY="YCAJES-5zgVnkRsBoxl******"  # значение поля key_id
SECRET_KEY="YCMsLcqCIeI5MaMKBahEBBJJVgQSv1ud5G******"  # значение поля secret
```

Добавляем аутентификационные данные в переменные окружения:
```bash
source ./cloud-key/s3.key
```
и инициализируем наш проект заново:
```bash
 terraform init -reconfigure -backend-config="access_key=$ACCESS_KEY" -backend-config="secret_key=$SECRET_KEY"
```

Если будет ошибка, используй префикс ``` TF_LOG=TRACE ... ```

![answer](./img/tf-05.3.1.png)


Вариант с блокировкой state файла.

![answer](./img/tf-05.3.2.png)

Кстати, в описании задания написано, что:

> Lock-файл создается автоматически в том же S3 bucket рядом с state-файлом с именем `<key>.lock.info`.

Вот скриншот того что хранится в s3 bucket:

![answer](./img/tf-05.3.3.png)

Как видно, никакого lock-файла нет. В локальной папке с проектом файл `.terraform.lock.hcl` присутствует.


### Задание 3

```bash
# Создаём новую ветку terraform-hotfix:
git checkout -b terraform-hotfix

# Запушиваем её на GitHub
git push -u origin terraform-hotfix
```

