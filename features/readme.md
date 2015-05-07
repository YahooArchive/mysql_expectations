The `mysqldum_expectations` gem contains rspec matchers to help you test your database by making assertions on the structure and data of your database using the `mysqldump` of that database.

This gem operates on a xml dump of the database as returned from the following `mysqldump` command:

```
mysqldump --xml --no-data --all-databases \
  --host=${host} --port=${port} \
  --user=${user} -p > mysqldump.xml
```

The option `--no-data` is optional, but you should include it if you are only planning to make expectations on the structure of your database.

If you are only going to make expectations for a particular database, you could replace the `--all_databases` option with the name of one or more database.

## Reading this documentation

As you browse this documentation, you will find a template for a complete rspec file in the Background section of each feature. Use this template to get started with your own rspec expectations on your database.
