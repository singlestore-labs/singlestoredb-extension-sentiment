# Sentiment

## Overview

This extension provides a UDF and TVF that perform sentiment analysis using VADER.

## Contents

### `sentiment`

**Usage:**
`sentiment(input TEXT)`

**Parameters:**
- *input*:  The text to analyze.

**Returns:**
A record four fields, each representing a certain sentiment score as a `DOUBLE`:  `compound`, `positive`, `negative`, and `neutral`.

**Description:**
This function will return a record with four sentiment scores for the given input.

**Example:**
```sql
select to_json(sentiment("i like ice cream"));
```
```console
+---------------------------------------------------------------------------------------------------------+
| to_json(sentiment("i like ice cream"))                                                                  |
+---------------------------------------------------------------------------------------------------------+
| {"compound":0.3611575592573076,"negative":0,"neutral":0.4444444444444444,"positive":0.5555555555555556} |
+---------------------------------------------------------------------------------------------------------+
```

### `sentiment_tvf`

**Usage:**
`sentiment_tvf(input TEXT)`

**Parameters:**
- *input*:  The text to analyze.

**Returns:**
A table with four columns, each representing a certain sentiment score as a `DOUBLE`:  `compound`, `positive`, `negative`, and `neutral`.

**Description:**
This function is identical to the UDF above, except that it will return a table with the four sentiment scores as columns.

**Example:**
```sql
select * from sentiment_tvf('i like ice cream');
```
```console
+--------------------+--------------------+----------+--------------------+
| compound           | positive           | negative | neutral            |
+--------------------+--------------------+----------+--------------------+
| 0.3611575592573076 | 0.5555555555555556 |        0 | 0.4444444444444444 |
+--------------------+--------------------+----------+--------------------+
```

## Deployment to SingleStore

To install these functions using the MySQL CLI, you can use the following command.  Replace `$DBUSER`, `$DBHOST`, `$DBPORT`, and `$DBNAME` with, respectively, your database username, hostname, port, and the name of the database where you want to deploy the functions.
```bash
mysql -u $DBUSER -h $DBHOST -P $DBPORT -D $DBNAME -p < load_standalone.sql
```

## Additional Examples

The `example` directory provides a data set (YouTube trending data from 2020) that can be used to explore this function.  To load it, simply source the `examples/load.sql` file.

Then, you can run sentiment analysis like this:

```sql
select y.video_description, s.compound from youtube y, sentiment_tvf(y.video_description) s;
```

## Building

The `load_*` scripts in this repo should be sufficient to load the pre-built extension into SingleStore.  However, if you wish to rebuild it, do the following.

1. Install Rust and Cargo
2. Install the Rust `wasm32-wasi` target
3. Run `cargo build --target wasm32-wasi`

To build the extension from the Wasm locally, run the following.

```bash
cp ./target/wasm32-wasi/release/json-flatten.wasm ./json-flatten.wasm
tar cvf json-flatten.tar json-flatten.sql json-flatten.wasm json-flatten.wit 
```

## Testing

There are automated script tests in the `db-tests` directory.
They are run against the `singlestoredb-dev-image`.

In order to run the tests

1. Install Python 3
2. Install `singlestoredb[pytest]` (and optionally `pytest-xdist`) using pip
3. Set the `SINGLESTORE_LICENSE` environment variable
4. Run the `pytest` command

If you installed `pytest-xdist`, you can also distribute the tests to multiple workers
by running `pytest -n auto` or giving a specific number instead of `auto`
