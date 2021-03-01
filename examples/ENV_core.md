## Описание ролей
### Роли
| Название роли | Выполняемые функции|
|---------------|--------------------|
| **`tf_operator`**   | Занимается настройкой деплоя и конфигурированием системы мониторинга. Файлы конфигараций меняются в зависимости от окружения |
| *tf_developer* |  Занимается разработкой модулей  Terraformи и структуры конфигураций. Файлы тиражируются по окружениям без изменений. |
| tf_robot | Автоматическое создание конфигов точек сбора мониторинга, при необходимости файлы могут редактироваться в ручном режиме. |


## Модули ядра
### Дерево модулей

``` bash
├── 0.prometheus-h-targets.tf.json
├── 0.prometheus-infra-targets.tf.json
├── a.alertmanager.tf
├── a.exporter-blackbox.tf
├── a.prometheus-h.tf
├── a.prometheus-infra.tf
├── a.prometheus-pg.tf
├── a.pushgateway.tf
├── b.grafana.tf
├── c.container_resources.tf
├── c.nginx-ingress.tf
├── c.thanos.tf
├── main.tf
├── prometheus-targets-h
│   └── <Тип Hadoop Кластера>-<Короткое_имя_кластера [a-z-]+>.json
├── prometheus-targets-infra
│   └── <Имя Системы>-<Environment dev|stage|prod >.json
├── secrets
│   ├── <Имя_HTTPS сертификата>.crt
│   ├── <Имя_HTTPS ключа>.key
│   ├── ipa.pem
│   ├── secrets.tfvars
│   ├── u_cm_s_mcap_grafana.key
│   └── u_cm_s_mcap_grafana.pem
├── terraform.tfvars
├── terraform.tfvars.json
└── variables.tf

```


| Файл | Описание |Кто редактирует|
|:-------|:---------|---------------|
| **0.prometheus-h-targets.tf.json** | Конфигурация(мапа имен прометеусов) того какой Hadoop кластер каким prometheus мониторится. | **`tf_operator`** |
| **0.prometheus-infra-targets.tf.json** | Конфигурация того какая система каким prometheus мониториться. | **`tf_operator`** |
| **a.alertmanager.tf** | Параметры деплоя модулей alertmanager. | *tf_developer* |
| **a.exporter-blackbox.tf** | Параметры деплоя модулей exporter-blackbox | *tf_developer* |
| **a.prometheus-h.tf** | Параметры деплоя модулей prometheus-h. | *tf_developer* |
| **a.prometheus-infra.tf** | Параметры деплоя модулей prometheus-infra. | *tf_developer* |
| **a.prometheus-pg.tf** | Параметры деплоя модулей prometheus-pg. | *tf_developer* |
| **a.pushgateway.tf** |  Параметры деплоя модулей pushgateway. | *tf_developer* |
| **b.grafana.tf**| Параметры деплоя модулей grafana. | *tf_developer* |
| **c.container_resources.tf** | Задание лимитов ресурсов контейнеров в зависимости от среды. | *tf_developer* |
| **c.nginx-ingress.tf** | Параметры деплоя модулей nginx-ingress. | *tf_developer* |
| **c.thanos.tf** |  Параметры деплоя модулей thanos. | *tf_developer* |
| **main.tf** | Конфигурация и версия Terraform для работы с Kubernetes. | *tf_developer* |
| **terraform.tfvars** | Задание значений переменных окружений. | **`tf_operator`** |
| **terraform.tfvars.json** | Задание значений переменных окружений в json: окружение, неймспейс, пути к образам в registry. | **`tf_operator`** |
| **variables.tf** | Описание окружений и определение значений по умолчанию. | *tf_developer* |
| **prometheus-targets-h/<Имя_кластера>.json** | Конфигурационный файл содержащий список внешних таргетов мониторинга данного Hadoop кластера | tf_robot |
| **prometheus-targets-infra/<Имя Системы>-<"ENV">.json** |  Конфигурационный файл содержащий список внешних таргетов мониторинга данной Системы. | **`tf_operator`** |
| **secrets/<Имя_HTTPS_сертификата>.crt** | Сертификат для доступа к сервису по HTTPS протоколу. | **`tf_operator`** |
| **secrets/<Имя_HTTPS_ключа>.key** | Ключ сертификата для доступа к сервису по HTTPS протоколу. | **`tf_operator`** |
| **secrets/ipa.pem** | Сертификат для интеграции Grafana c IPA | **`tf_operator`** |
|**secrets.tfvars** |  Шифрованный файл значений секретов переменных | **`tf_operator`** |
| **secrets/u_cm_s_mcap_grafana.pem** |  Сертификат для интеграции Grafana c IPA | **`tf_operator`** |
| **secrets/u_cm_s_mcap_grafana.key** | Ключ сертификата для интеграции  Grafana c IPA | **`tf_operator`** |  



## Глобальные конфигурации
### Дерево конфигураций  

```bash
configs
│   ├── alertmanager-{ENV}.yml
│   ├── grafana-dashboards.yml
│   ├── grafana-datasources.yml
│   ├── grafana-ldap.toml
│   ├── grafana-plugins.yml
│   ├── prometheus-h.yml
│   ├── prometheus-infra.yml
│   ├── prometheus-pg.yml
│   ├── thanos-query-sd.yml
│   └── prometheus-rules
|       ├── prometheus-rules-jmx.yml
|       ├── prometheus-rules-os.yml
|       └── prometheus-rules-service-<Имя_сервиса>.yml
dashboards
├── main
│   ├── mcap-exporters.json
│   ├── node-jmx.json
│   ├── node-os.json
│   ├── node-win.json
│   ├── template-jmx.json
│   └── template-os.json
├── services
│   └── service-<Имя сервиса>.json
└── systems
    ├── system-iogk-lxd.json
    ├── system-kapts.json
    └── system-sdpcontrol.json

```
### ../global/configs/ - шаблоны конфигов и конфиги ядра системы мониторинга
| Файл | Описание |Кто редактирует|
|:-------|:---------|---------------|
| **alertmanager-${ENV}.yml** | Конфигурационный темплейт для alertmanager в зависимости от окружения, описание каналов отправки (email). | *tf_operator* |
| **grafana-dashboards.yml** | Шаблон конфигурационного файла для инициализации дашбордов в Grafana. | *tf_developer* |
| **grafana-datasources.yml** | Шаблон конфигурационного файла для инициализации источников данных для grafana. | *tf_developer* |
| **grafana-ldap.toml** | Шаблон конфигурационного файла интеграции Grafana и LDAP. | *tf_developer* |
| **grafana-plugins.yml** | Шаблон конфигурационного файла инициализации плагинов в Grafana. | *tf_developer* |
| **prometheus-h.yml** | Шаблон конфигурационного файла prometheus-h. | *tf_developer* |
| **prometheus-infra.yml** | Шаблон конфигурационный для сбора метрик с различных Систем. | *tf_developer* |
| **prometheus-pg.yml** | Шаблон конфигурационный для prometheus-pg | *tf_developer* |
| **configs/thanos-query-sd.yml** | Шаблон список prometheus для Thanos | *tf_developer* |
| **prometheus-rules/prometheus-rules-jmx.yml** | Правило алертинга стандартных jmx метрик | **`tf_operator`** |
| **prometheus-rules/prometheus-rules-os.yml** |  Правило алертинга стандартных метрик ОС | **`tf_operator`** |
| **prometheus-rules/prometheus-rules-service-${Имя_сервиса}.yml** | Правило алертинга технических сервисов | **`tf_operator`** |

### ../global/dashboards/ дашборды grafana
| Файл | Описание |Кто редактирует|
|:-------|:---------|---------------|
| **main/mcap-exporters.json** | Дашборд (Панель) для [MCAP] EXPORTERS | *tf_developer* |
| **main/node-jmx.json** | Дашборд (Панель) для [NODE] JMX | *tf_developer* |
| **main/node-os.json** | Дашборд (Панель) для [NODE] OS | *tf_developer* |
| **main/node-win.json** | Дашборд (Панель) для [NODE] WIN | *tf_developer* |
| **main/template-jmx.json** | Шаблон дашборда (панели) основные JMX-метрики собираемые exporter-jmx | *tf_developer* |
| **main/template-os.json** | Шаблон дашборда (панели) основные метрики операционной системы | *tf_developer* |
| **services/service-<Имя сервиса>.json** | Дашборд (Панель) для отображения метрик сервиса | *tf_developer* |
| **systems/system-<Имя системы>.json** | Дашборд (Панель) для отображения системных метрик с iogk-lxd | *tf_developer* |
| **systems/system-kapts.json** | Дашборд (Панель) для отображения системных метрик с iogk-kapts | *tf_developer* |
| **systems/system-sdpcontrol.json** | Дашборд (Панель) для отображения системных метрик с sdpcontrol | *tf_developer* |        




## Создание правил тревоги
Правила оповещения задаются в виде файла для каждого сервиса и/или системы в ```global/configs/prometheus-rules```

Правило именования файлов `prometheus-rules-<system|service>-<имя системы /сервиса>.yml`

В файле следующая структура

``` yaml
groups: #Группируем правила
- name: #Имя группы
  rules:
  - alert:  #Название события тревоги
      expr:  # Правило по которому будет срабатывать тревога
      for: #Продолжительность, что бы исключить ложные минимальные срабатывания.
      labels: #Объявляем лейблы которые будут проставляться
        severity: # Цифровой Уровень события ( 0 - Nodata, 1 - Info, 2 - Warning, 3 - Critical)
        severityText: # Текстовый уровень события (NODATA, INFO, WARNING, CRITICAL)
        summary:  # Короткое название события
        alertid: # ИД события по тригеру
      annotations: # Объявляем блок описание события.
        summary:  # Короткое сообщение
        description:  # Информатировное описание события
  ```
  ### Шаблон отсутствия данных `NODATA`
  ``` yaml
  groups:
- name: < Имя сервиса | системы >  

    rules:
##################################### NODATA ######################################

    - alert:  <System{ИмяCистемы}MetricsStatusNull | Service{ИмяCервиса}MetricsStatusNull>
      expr: < up{ system=~"<ИмяСистемы>.*"} == 0 | up{ system=~"<ИмяСервиса>.*"} == 0 >  

      for: 60m
      labels:
        severity: 0
        severityText: NODATA
        summary: Node Exporter Metrics Scrape Error
        alertid: "{{ $labels.system }}-{{ $labels.instance }}-ExporterMetricsStatusNull"
      annotations:
        summary: Node Exporter Metrics Scrape Error [{{ $labels.system }}] [{{ $labels.instance }}]
        description: There are no metrics for node-exporter [{{ $labels.instance }}]

  ```

  *Проверяем каждое expression в prometheus страница Graph.*  


  После окончания создания файла правила тревоги добавляем его в файл окружение `<ИмяОкружения>/core/a.prometheus-<Тип Прометеуса который мониторим>.tf` в параметр `rules_data`,
  формат строки `"<system-{ИмяCистемы} | service-{ИмяCервиса}.yml" = file("${var.path_configs}/prometheus-rules/<Имя файла созданного ранее>")`


  После окончание заполнения всех файлов, применяем TF plan. Через 5 минут проверяем в prometheus что появились новые правила, если правила не появились проверяем логи prometheus.
