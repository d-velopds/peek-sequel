# Peek::Sequel

Take a peek into Sequel SQL queries made during your application's requests.

This peek view provides:

- The total number of Sequel queries executed during a request.
- The duration of queries executed during a request.

**Note:** This monkey patches Sequel and it's only been tested against Sequel
4.49.0!

## Usage

Add the following line to your `config/initalizers/peek.rb`:

```
Peek.into Peek::Views::Sequel
```