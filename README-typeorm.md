# AccAnt doc for `typeorm`

This document describes the usage of `typeorm` for the project **AccAnt**.


## About `typeorm`

Link to typeorm: https://github.com/typeorm/typeorm

The [typeorm Readme](https://github.com/typeorm/typeorm/blob/master/README.md) describes the project: 
> TypeORM is an ORM that can run in NodeJS, Browser, Cordova, PhoneGap, Ionic, 
> React Native, NativeScript, Expo, and Electron platforms and can be used with 
> TypeScript and JavaScript (ES5, ES6, ES7, ES8).



## Migrations

To automatically generate the database migration(s) *TypeScript* must be installed (more in [Issue #1561](https://github.com/typeorm/typeorm/issues/1561#issuecomment-363562251) ):
```sh
npm install -g ts-node typescript
```

Then you can generate the migration (change `TestMigration` to your desired classname):
```sh
npx typeorm migration:generate -n TestMigration
```

## Entities

For automatic entity generation from the old Laravel database we utilise [typeorm-model-generator](https://github.com/Kononnable/typeorm-model-generator). 

To generate the enties from my the existing database. Adjusted command for Postgres with user/password + changed output directory.
For info about the parameters see [Readme >> Usage](https://github.com/Kononnable/typeorm-model-generator#usage)

```sh
npx typeorm-model-generator -h localhost -d accant -u postgres -x 123 -e postgres -s public --ssl -o ./src/database/entities --noConfig 
```

## Misc

### Npx
> Thanks to npx you can use npm modules without polluting global installs. So nothing to do here :)
