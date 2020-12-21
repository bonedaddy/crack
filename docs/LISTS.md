# Word Lists

Word lists provide data to use when cracking hashing, and are essentially giant lists of potential passwords


# Filtering

Ignore passwords that are less than N character

```shell
$> awk -v n=8 '{ line = $0; gsub("[^[:graph:]]", "") } length >= n { print line }' some_dict.txt # n=8 so passwords that are 7 characters or less in length will be ignored
```