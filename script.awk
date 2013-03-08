#!/usr/bin/gawk -f

function trim(v) 
{ 
  gsub(/^[ \t]+|[ \t]+$/, "", v)
  return v
}

function remove_boundaries(v)
{
  if (substr(v, 1, 1) == "(") {
    len = length(v)
    v = substr(v, 2, len-2)
  }
  return v;
}

function escape_chars(v)
{
  gsub(/[$]/, "\\\\$", v)
  return v
}

function replace_double_quotes(v)
{
  gsub(/["]/, "'", v)
  return v
}

BEGIN {
  FPAT = "(^[^(]+)|\\((.+)\\)$"
  print "{"
  print "\"scope\": \"source.sass - meta.property-value\","
  print "\"completions\": ["
}

{
  printf("{\n\"trigger\": \"%s\",\n\"contents\": \"%s", $1, $1)

  if (NF == 2) {
    printf("(")

    $2 = remove_boundaries($2)
    split($2, arguments, ",")
    for(i=1; i <= length(arguments); i++) {
      argument = trim(replace_double_quotes(escape_chars(arguments[i])))
      printf(" ${%d:%s}", i, argument)
      if (i<length(arguments))
        printf(",")
    }

    printf (" )")
  }

  printf("\"\n},\n")
}

END {
  print "]"
  print "}"
}
