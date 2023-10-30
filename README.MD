# CS 457: Database Management Systems

## Programming Assignment 3: Table Joins

### Luna Perez-Herrera

This is an SQL interpreter implemented in C++ that allows for creation and management of databases, tables, and records. While only a subset of the full suite of SQL commands are implemented, most major commands such as table creation and deletion, insertion, selection, and alterations are supported.

## Design

This interpreter uses a modular approach with each command separated into it's own function. Commands are matched to their respective function in a driving loop. From their commands are processed with the help of various auxillary function.

## Representation

Databases are stored as folders in the root directory of the program with the same name as that of the database. Tables are stored as files within their respective database folder, again with the same name as that of the table. Table attributes are stored on the first line, separated by commas. Records are stored in these same files on the following lines.

## Atomicity

When a transaction is started, a file with the same name as the table being modified with ".lock" appended to the file name is created. Changes made with the update command are saved in memory rather then immediately written to the file. When a user enters a commit command, the program checks for the existence of the lock file. If no such file is found, changes are written and the transaction concludes. If the lock file is found to exist, the transaction is aborted. The commit command only succeeds if an internal flag tracking whether any changes have been made is set to true.

## Entering Commands in Interactive Mode and Command Formatting

Due to how the program handles and parses input commands (by splitting them by whitespace), the interpreter can be quite picky about the exact format of a command and will not write data properly if commands don't adhere to the expected format. While I should have gone about parsing commands in a different way to support the addition and removal of whitespace much like in actual SQL, I did not. To avoid issues, refer to the commands as they are formatted in the included copy of the test script. Furthermore, the program expects a semicolon at the end of every command and will refuse to execute a command if it does not see a trailing command. Therefore refrain from placing comments at the end of a command.

## Executing the code

An already compiled executable ("driver") and test file ("PA_test.sql) are included for convenience. To run the interpreter, simply execute `driver` and specify an input file with the commands you wish to execute as a command line argument.

## Compiling the code

While an already compiled executable is includes, should you wish to compile the code yourself, a make file is included. Notably, the command used to actually create the executable is "g++ -std=c++17 driver.cpp -lstdc++fs -o driver". I ran into strange issues with the library I was using for file manipulation which where only solved with using that specific compilation commands.

## Functions

- main():
  Determines and validates if the user supplied a command line argument for an input file. Enables or disables an interactive mode flag respectively. Uses this flag to call a main loop for an interactive move or for processing an input file.

- inputModeLoop():
  Performs a second check on the existence of the input file. Reads lines one by one from the input file, discarding empty lines, lines that contain a comment, and lines that lack a trailing semicolon. Performs brief preprocessing of the commands via auxiliary functions (splits the string into its individual tokens, removes any trailing invisible characters, removes semicolons, and capitalizes all characters). The preprocessed string is then passed to processCommands() for execution

- interactiveModeLoop():
  Handles the logic for an interactive mode should the user not specify an input file. Not implemented in this release.

- processCommands():
  Matches an input vector containing the tokens of an input commands to the respective function to execute the appropriate commands.

- createDatabase():
  Creates a database with the specified name. Performs a check to ensure the database does not already exist.

- createTable():
  Creates a table with the specified name. Performs a check to ensure the specified databases exist and that the table does not already exists. Table fields are written to the first line of the file.

- deleteDatabase():
  Deletes a specified database.

- deleteTable():
  Deletes a specified table

- selectData():
  Handles SELECT commands. A simple SELECT \* is displayed by printing all lines of a table file. Joins are identified and passed to another function for execution. Conditional selects are identified and their conditions are identified. The table is read from the file and loaded into memory. Then the memory representation of the table is iterated over, checking for records that satisfy the specified condition. Records that match are displayed.

- alterTable():
  Handles ALTER commands. Only supports appending of fields to a table. Specified fields to be added are combined into one string. These fields are then appended to the first line of the table file.

- insertData():
  Handles INSERT commands for insertion of records. The existing table and its data are loaded into memory as a 2D vector. The new record is appended to the end of this 2D vector. The data is then written back to the table file, overwriting it.

- updateTable():
  Handles UPDATE commands. Loads the table into memory as a 2D vector. Iterates over the table to match the specified condition and then updates the relevant data. The new table is then written back to the table file, overwriting it.

- deleteData():
  Handles DELETE commands. Loads table into memory, matches condition, and then deletes records the match the specified conditions. New table is written back to the table file.

- reconstructFields():
  Takes a vector of string and 2 bounds. Intended to take the fields specified in a command and place them all into a single string. Doing so makes it much easier to add those fields to an existing table.

- getTableData():
  Returns a vector containing every line of a table file. Not used for recreating a table in memory. That functionality comes from another function.

- splitTableFirstField():
  Returns a vector with the fields from the first line of a table file. Data types of the fields are discarded. This representation is useful for matching conditions of various commands.

- splitTableData():
  Splits a single line of table file into a vector with each token, stripping commas and quotes in the process.

- reconstructTableData():
  Primarily used for constructing a table in memory from its table file for use in command execution. Iterates over each line, splitting it into its tokens. Output is a 2D vector. Notably data types are excluded from the first line so that the representation is more useful.

- writeTableData():
  Takes a 2D vector and writes it to a table file. Intended to write back the changes of a command.

- getTableFieldIndex():
  Used in condition matching. Attempts to match the fields of a table to a specified input field, returning the index of where the check succeeds.

- joinSelectData():
  Matches a join command to one of three cases by checking for the position of keywords. Once the correct case is identified, the relevant tokens of the command are extracted, preprocessed, and passed to the relevant function for execution.

- innerJoinSelectData():
  Handles inner joins. Loads the table into memory, identifies conditions, and then iterates over the table, displaying records that satisfy the join.

- outerJoinSelectData():
  Handles outer joins. Loads the table into memory, identifies conditions, and the iterates over the table, displaying records that satisfy the join.

- checkIfUsingDatabase():
  Validates that the specified database to use does exists.

- removeTrailingSemicolon():
  Removes any trailing semicolons from a vector of strings.

- capitalizeStringVector():
  Capitalizes every character of a vector of strings

- capitalizeString():
  Capitalizes all characters in a string

- splitStringByWhiteSpace():
  Splits the tokens of an input string by their whitespace. Returns a vector of strings.

- removeTrailingAndLeadingInvisibleCharacters():
  Removes and trailing or leading invisible characters if the exists in a string.

- removeTrailingInvisibleCharacters():
  Removes any trailing invisible characters from a string

- removeLeadingInvisibleCharacters():
  Removes any leading invisible characters from a string.

- removeTrailingAndLeadingParenthesis():
  Removes trailing and leading parenthesis from a string only if both exist in the string

- removeAllQuotes():
  Removes all single and double quotes from a string.

- removeAllCommas():
  Removes all commas from a string

- splitStringByDelimiter():
  Splits a string into a vector of strings according to the specified delimiter.
