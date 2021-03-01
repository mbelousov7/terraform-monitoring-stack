# Инструкции по работе

## TERRAFROM
### Описание ролей
| Название роли | Выполняемые функции|
|---------------|--------------------|
| **`tf_operator`**   | Занимается настройкой деплоя и конфигурированием системы мониторинга. Файлы конфигараций меняются в зависимости от окружения |
| *tf_developer* |  Занимается разработкой модулей  Terraformи и структуры конфигураций. Файлы тиражируются по окружениям без изменений. |
| tf_robot | Автоматическое создание конфигов точек сбора мониторинга, при необходимости файлы могут редактироваться в ручном режиме. |

## Инструкция для **`tf_operator`**

- Описание структуры `<ENV>/core` см. `ENV_core.md`
- Описание структуры `<ENV>/exporters` см. `ENV_exporters.md`


### Запуск terraform на локальном хосте

### Приреквизиты
1. terraform бинарник в  PATH
2. директория с плагинами terrraform, нужной структуры
	 <path>/registry.terraform.io/hashicorp/<имя плагина>											
3. git с модулями terraform https://github.com/mbelousov7/terraform-monitoring-stack												
4. kubernetes_host и kubernetes_token
их можно найти в Copy Login Command в консоли OpenShift, отображаются в готовом виде в команде
oc login --token=<kubernetes_token> --server=<kubernetes_host>

5. конфигурация terraform backend-config(папаметры соединения базой)

### Запуск terraform

#### 1. клонируем необходимые репозитории
```
git clone git@github.com:mbelousov7/terraform-monitoring-stack.git
cd ci02406377_mcap_env/<Envirometn name>/<task name>
```

#### 2. Управление секретами
Все секреты хранятся в директории secrets и шифруются ansible-vault.

Перед запуском terraform необходимо скопировать все секреты в отдельную директорию **secrets-decrypt** и расшифровать.

Для удобства можно использовать скрипт **vault.sh**:
```
examples/vault.sh <directory_path> <decrypt|encrypt> [vault password file]
```
который:
- копирует директорию с секретами *<directory_path>* в *<directory_path>-decrypt*
- дешифрует секрты в *<directory_path>-decrypt*

Секреты в незашифрованном виде храним в директории **secrets-decrypt**, она добавлена в *.gitignore*

Пример запуска
```
./vault.sh DEV/core/secrets decrypt
```

**!!!ВАЖНО файлы в <Envirometn PATH>/secrets не изменяем**

#### 3. Инициализация необходимых плагинов, модулей, переменных terraform-backend.
Например для бэкэнда в pg  будет
```
export TF_VAR_kubernetes_token=<kubernetes_token>
terraform init  -plugin-dir=<full path to plugins/providers>
terraform workspace select <{ENV}-core|{ENV}-exporters>
```
**!!!!ВАЖНО: обязаьельно определить workspace, должен совпадать с окружение+директория_терраформа
проверить имена воркспейсов можно командой**

```
terraform workspace list
```


#### 5. Запуск и применение плана
```
terraform plan -var-file="./secrets-decrypt/secrets.tfvars"
terraform apply -var-file="./secrets-decrypt/secrets.tfvars"
```

### FAQ
+ 1. Поиск имени ресурсов командой terraform state list
например
```
terraform state list
terraform state list | grep <host-sentry-server>
```
+ 2. Точеное удаление ресурсов
находим точное название ресурса командой terraform state list
запускаем команду terraform destroy
```
terraform destroy -var-file="./secrets-decrypt/secrets.tfvars" -auto-approve -target='module.exporter-jmx-clustername["host-sentry-server"].kubernetes_deployment.exporter'
```
+ 3. Точечное создание,пересоздание
находим точное название ресурса командой terraform state list
помечаем ресурс terraform taint (он будет пересоздан при следующем apply) и запускаем apply
```
terraform taint 'module.exporter-jmx-clustername["host-sentry-server"].kubernetes_deployment.exporter'
terraform apply -var-file="./secrets-decrypt/secrets.tfvars" -auto-approve
```
 Точечный apply модуля
```
terraform apply -var-file="./secrets-decrypt/secrets.tfvars" -auto-approve -target='module.exporter-jmx-clustername["host-sentry-server"]'
```
+ 4. Обновление статуса деплоя ресурсов
```
terraform refresh -var-file="./secrets-decrypt/secrets.tfvars"
```
