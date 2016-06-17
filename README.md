# TP4 Scraper OTP+Supervisión en Elixir

## Scraper

Para instalar dependencias y levantar una consola interactiva:

```
$ cd scraper
$ mix deps.get
$ iex -S mix
```

Utiliza mismo server nodejs de:
https://github.com/arquitecturas-concurrentes/iasc-supervision-elixir-scraper/tree/master/content_server

Para probar los test: mix test

Una vez en la consola se debe levantar el supevisor y ya estamos listos para hacer pedidos:

```
> Scraper.Supervisor.start_link
> {:ok, titles} = Scraper.titles "http://localhost:3000/foo"
```

Si se quieren observar los procesor ejecutando en la Erlang VIM:

```
> :observer.start()
```
