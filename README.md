# ovld_infra

ovld Infra repository

### cloud-bastion
```
pritunl_web_address = https://35-210-253-198.sslip.io/
pritunl_web_username = otus
pritunl_web_password = H0U1DZVKVc8T
bastion_IP = 35.210.253.198
someinternalhost_IP = 10.132.0.5
```


### Настройка локального SSH для работы в GCP с помощью ProxyJump

#### Пример конфигурации ~/.ssh/config

```
Host bastion
  HostName 35.210.253.198
  User vld
  IdentityFile ~/.ssh/air.id_rsa

Host someinternalhost
  HostName 10.132.0.5
  ProxyJump bastion
  User vld
  IdentityFile ~/.ssh/air.id_rsa
```
[Reference](https://wiki.gentoo.org/wiki/SSH_jump_host)



### cloud-testapp

```
testapp_IP = 104.155.71.88
testapp_port = 9292

```

### Создание вм с консоли для cloud-testapp

Создать вм с из папки проекта c стартапскриптом:

```
gcloud compute instances create reddit-app \
--boot-disk-size 10GB \
--image-family ubuntu-1604-lts \
--image-project ubuntu-os-cloud \
--machine-type g1-small \
--tags puma-server \
--restart-on-failure \
--zone europe-west1-d \
--metadata-from-file startup-script=startup-script.sh
```

Создать файрвол правило чтобы открыть доступ через внешку приле:

```
gcloud compute firewall-rules create default-puma-server --allow tcp:9292 --target-tags puma-server
```

Также созданы скрипты для автоматизации установки прилы:
```
install_ruby.sh     # Проверяет наличие пакетов в системе и в случае их отсутствия устанавливает их
install_mongodb.sh  # Проверяет наличие пакета бд в системе и в случае отсутствия устанавливает его
deploy.sh           # Ставить прилу
```
Также все скрипты покрыты небольшими тестами и проверками