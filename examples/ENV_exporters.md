## Описание экспортеров

### Роли
| Название роли | Выполняемые функции|
|---------------|--------------------|
| **`tf_operator`**   | Занимается настройкой деплоя и конфигурированием системы мониторинга. Файлы конфигараций меняются в зависимости от окружения |
| *tf_developer* |  Занимается разработкой модулей  Terraformи и структуры конфигураций. Файлы тиражируются по окружениям без изменений. |
| tf_robot | Автоматическое создание конфигов точек сбора мониторинга, при необходимости файлы могут редактироваться в ручном режиме. |

``` bash

├── c.container_resources.tf
├── c.variables_oracle.tf
├── h-0-exporter-jmx-modules.tf
├── h-<Тип Hadoop Кластера>-<Короткое_имя_кластера [a-z-]+>-exporter-jmx.tf
├── h-<Тип Hadoop Кластера>-<Короткое_имя_кластера [a-z-]+>-exporter-yarn-rm.tf
├── infra-<Имя Системы>-exporter-<тип экспортера>.tf
├── main.tf
├── secrets
│   ├── secrets.tfvars
│   └── u_itcm_s_mcap_greenplum.keytab
├── terraform.tfvars.json
└── variables.tf

```

 | Файл | Описание |Кто редактирует|
|:-------|:---------|---------------|
| **c.container_resources.tf** | Задание лимитов ресурсов контейнеров для экспортеров. | *tf_developer* |
| **h-<Тип Hadoop кластера>-<Короткое_имя_кластера [a-z-]+>-exporter-jmx.tf** |  Конфигурационный файл содержащий список точек сбора по JMX для соответствующего кластера. | tf_robot |
| **h-<Тип Hadoop кластера>--<Короткое_имя_кластера [a-z-]+>-exporter-yarn-rm.tf** | Конфигурационный файл содержащий список точек сбора по yarn-rm api для соответствующего кластера | tf_robot |
| **infra-<Имя Системы>-exporter-sql.tf** | Конфигурационный файл содержащий параметры деплоя exporter-sql и параметры соединения по SQL |**`tf_operator`**  |
| **infra-<Имя Системы>-exporter-oracle.tf** | Конфигурационный файл содержащий параметры деплоя exporter-oracle и параметры соединения по SQL, ссылается на переменные в c.variables_oracle.tf |**`tf_operator`**  |
| **main.tf** | Конфигурация и версия Terraform для работы с Kubernetes. | *tf_developer* |
| **terraform.tfvars.json** | Задание значений переменных окружений в json: окружение, неймспейс, пути к образам в registry. | **`tf_operator`** |
| **variables.tf** |  Описание окружений и определение значений по умолчанию. | *tf_developer* |
| **variables_oracle.tf** | Переменные окружения для exporter-oracle | *tf_operator* |
| **secrets/secrets.tfvars** | Шифрованный файл с секретами | **`tf_operator`**  |
| **secrets/<Имя keytab>.keytab** | Шифрованный файл для Kerberos аутентификации | **`tf_operator`**  |

## Глобальные конфигурации
### Дерево конфигураций  

```bash
configs
configs-exporters
├── exporter-oracle
├── exporter-sql
├── <другие конфиги экспортеров>
└── krb5.conf
```

### ../global/configs-exporters/ - шаблоны конфигов и конфиги экспортеров

| Файл | Описание |Кто редактирует|
|:-------|:---------|---------------|
| **exporter-oracle** | Директория для конфигурации экспортера exporter-oracle| *tf_developer* |
| **exporter-sql** | Директория для конфигурации экспортера exporter-sql| *tf_developer* |
| **krb5.conf** | конфигурационный файл kerberos | *tf_developer* |
