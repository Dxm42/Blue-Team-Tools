![[analyzerb.png]]

### Programas que utilizei como base.
- Nmap scan padrão
- nikto
- ffuf
- dirb

#### O intuito desse script é para fins de estudos
O script realiza uma filtragem simples a fim de monitorar o arquivo de logs do servidor apache, informando ao SysAdmin sobre o volume de acessos  suspeitos de um determinado IP que possa ser mal intencionado ou não.

#### Modo de uso

#### Dar permissão ao arquivo para que possa ser executado

```shell
$ chmod +x apache_log_monitor.sh
```

#### Executando o script

```shell
$ ./apache_log_monitor.sh access.log
```


![[analyzerc.png]]



