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

#### Пример конфигурации ~/ssh/config

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