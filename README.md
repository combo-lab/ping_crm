# PingCRM

A demo application to illustrate how [Inertia.js](https://inertiajs.com/) works with [Combo](https://github.com/combo-lab/combo) and [React](https://react.dev/).

It's a slightly-enhanced port of the [pingcrm-react](https://github.com/liorocks/pingcrm-react), and it uses:

- Elixir, Combo, Ecto, PostgreSQL.
- TypeScript, Node.js, pnpm, Vite, Inertia, React, TailwindCSS.

## Highlights

The type-safe communication protocol between backend and frontend:

- backend - the serializer module at [`lib/ping_crm/web/serializer.ex`](lib/ping_crm/web/serializer.ex) and all the implementations at [`lib/ping_crm/web/serializers`](lib/ping_crm/web/serializers).
- frontend - the TypeScript types at [`assets/src/types/index.d.ts`](assets/src/types/index.d.ts)

## Quick start

### Clone the repo

```
$ git clone https://github.com/combo-lab/ping_crm.git
$ cd ping_crm
```

### Setup environments

```
$ mix setup
```

### Run dev server

```
$ iex -S mix combo.serve
```

Now you can visit `http://localhost:4000` from web browser.

### Build the release

```
$ mix deps.get --only prod
$ mix assets.deploy
$ MIX_ENV=prod mix release
```

Here are some useful release commands you can run:

```
# To start your system with the Combo server running
$ _build/prod/rel/ping_crm/bin/serve

# To run migrations
$ _build/prod/rel/ping_crm/bin/migrate

# Connect to the release remotely, once it is running:
$ _build/prod/rel/ping_crm/bin/ping_crm remote

# To list all available commands
$ _build/prod/rel/ping_crm/bin/demo
```

See [Mix.Tasks.Release](https://hexdocs.pm/mix/Mix.Tasks.Release.html) for more information about Elixir releases.

### Run the release in production

> No deployment tools are used here. Only essential setup and steps are covered.

```
$ export SECRET_KEY_BASE=<a very long secret>
$ export DB_URL=ecto://postgres:postgres@127.0.0.1/ping_crm
$ export NODE_ENV=production
$ _build/prod/rel/ping_crm/bin/migrate
$ _build/prod/rel/ping_crm/bin/serve
```

## Credits

- Original work by Jonathan Reinink ([@reinink](https://github.com/reinink)) and contributors
- Port to Ruby on Rails by Georg Ledermann ([@ledermann](https://github.com/ledermann))
- Port to React by Lio ([@liorocks](https://github.com/liorocks))
- Port to Combo by Zeke Dou ([@zekedou](https://github.com/zekedou))

## License

MIT
