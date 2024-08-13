
# Cron Expression Parser

## Overview

The Cron Expression Parser is a command-line Ruby application that parses and expands cron expressions into their respective time fields. It helps to understand when a cron job will run by breaking down the expression into minutes, hours, days of the month, months, and days of the week. The script is designed to be simple, readable, and extendable.

## Features

- Parses standard cron expressions with five time fields (minute, hour, day of the month, month, day of the week) plus a command.
- Expands cron fields such as ranges (e.g., `1-5`), steps (e.g., `*/15`), and lists (e.g., `1,15`).
- Handles special cron strings like `@yearly`, `@monthly`, and more (if extended).
- Outputs the parsed fields in a human-readable table format.

## Example

Given the following cron expression:

```bash
*/15 0 1,15 * 1-5 /usr/bin/find
```

The output will be:

```
minute        0 15 30 45
hour          0
day of month  1 15
month         1 2 3 4 5 6 7 8 9 10 11 12
day of week   1 2 3 4 5
command       /usr/bin/find
```

## Installation

1. **Clone the Repository:**
   ```bash
   git clone https://github.com/raresroca05/cron_parser.git
   cd cron_parser
   ```

2. **Make the Script Executable:**
   ```bash
   chmod +x script/cron_parser.rb
   ```

3. **Run the Script:**
   ```bash
   script/cron_parser.rb "*/15 0 1,15 * 1-5 /usr/bin/find"
   ```

## Usage

To use the Cron Expression Parser, run the script with a cron expression as an argument:

```bash
./script/cron_parser.rb "<cron_expression>"
```

For example:

```bash
./script/cron_parser.rb "*/30 14 1,15 * 1-5 /path/to/command"
```

The script will parse the expression and print the times at which the command will run in a readable format.

## Extending the Solution

This project is designed to be easily extendable. Possible extensions include:

- **Handling Special Time Strings:** Add support for `@yearly`, `@monthly`, etc., by mapping these to their equivalent cron expressions.
- **More Complex Ranges:** Enhance the parser to handle more sophisticated cron expressions with combined ranges and steps.
- **Rails Integration:** Convert this script into a Rails service object or rake task for integration with a web application.

## Contributing

If you would like to contribute to this project:

1. Fork the repository.
2. Create a feature branch (`git checkout -b feature/my-new-feature`).
3. Commit your changes (`git commit -am 'Add some feature'`).
4. Push to the branch (`git push origin feature/my-new-feature`).
5. Create a new Pull Request.

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

## Contact

For any questions or suggestions, feel free to reach out to the project maintainer at [your-email@example.com](mailto:rares.roca05@gmail.com).
