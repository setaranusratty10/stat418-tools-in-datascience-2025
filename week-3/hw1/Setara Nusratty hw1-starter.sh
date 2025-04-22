#!/bin/bash

#the following fetch both NASA log files from the corresponding urls and write. Write them to your local hw1 directory and create a NEW .sh file that can be run on files named:
# NASA_Jul95.log
# NASA_Aug95.log

curl -s https://atlas.cs.brown.edu/data/web-logs/NASA_Jul95.log > NASA_Jul95.log

curl -s https://atlas.cs.brown.edu/data/web-logs/NASA_Aug95.log > NASA_Aug95.log

#1
NASA_Jul95.log | grep -v ' 404 ' | awk '{print $1}' | sort | uniq -c | sort -nr | head -10
NASA_Aug95.log | grep -v ' 404 ' | awk '{print $1}' | sort | uniq -c | sort -nr | head -10

#2
#a for july 95 log
awk '{print $1}' NASA_Jul95.log | \
awk '{
  if ($1 ~ /^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$/) ip++
  else host++
}
END {
  total = ip + host
  printf("IP: %.2f%%\nHost: %.2f%%\n", (ip/total)*100, (host/total)*100)
}'

#b for august 95 log
awk '{print $1}' NASA_Aug95.log | \
awk '{
  if ($1 ~ /^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$/) ip++
  else host++
}
END {
  total = ip + host
  printf("IP: %.2f%%\nHost: %.2f%%\n", (ip/total)*100, (host/total)*100)
}'

#3
iconv -c -f utf-8 -t ascii NASA_Jul95.log > NASA_Jul95_clean.log
iconv -c -f utf-8 -t ascii NASA_Aug95.log > NASA_Aug95_clean.log
NASA_Jul95_clean.log | awk '$9 != 404 {print $7}' | sort | uniq -c | sort -nr | head -10
NASA_Aug95_clean.log | awk '$9 != 404 {print $7}' | sort | uniq -c | sort -nr | head -10

#4
#july
NASA_Jul95.log | \
iconv -c -f utf-8 -t ascii | \
awk -F\" '{print $2}' | \
awk '{print $1}' | \
grep -E '^(GET|POST|HEAD|PUT|DELETE|OPTIONS|CONNECT|TRACE|PATCH)$' | \
sort | uniq -c | sort -nr

#august
NASA_Aug95.log | \
iconv -c -f utf-8 -t ascii | \
awk -F\" '{print $2}' | \
awk '{print $1}' | \
grep -E '^(GET|POST|HEAD|PUT|DELETE|OPTIONS|CONNECT|TRACE|PATCH)$' | \
sort | uniq -c | sort -nr

#5
#july
NASA_Jul95.log | awk '$9 == 404' | wc -l
#august
NASA_Aug95.log | awk '$9 == 404' | wc -l

#6
#july
awk '{print $9}' NASA_Jul95.log | grep -E '^[0-9]{3}$' | sort | uniq -c | sort -nr | \
awk 'NR==1 { max=$1; code=$2 } { total += $1 } END {
  printf("JULY:\nMost frequent status code: %s\n", code);
  printf("Count: %d\n", max);
  printf("Percentage: %.2f%%\n\n", (max / total) * 100);
}'

#august
awk '{print $9}' NASA_Aug95.log | grep -E '^[0-9]{3}$' | sort | uniq -c | sort -nr | \
awk 'NR==1 { max=$1; code=$2 } { total += $1 } END {
  printf("AUGUST:\nMost frequent status code: %s\n", code);
  printf("Count: %d\n", max);
  printf("Percentage: %.2f%%\n", (max / total) * 100);
}'

#7
#july
awk -F'[:[]' '{print $3}' NASA_Jul95.log | \
grep -E '^[0-9]{2}$' | \
sort | uniq -c | \
awk '
BEGIN { max = -1; min = 1e9 }
{
  count[$2] = $1
  if ($1 > max) { max = $1; max_hour = $2 }
  if ($1 < min) { min = $1; min_hour = $2 }
}
END {
  for (h in count) printf("Hour %s: %d requests\n", h, count[h])
  print "\nJULY SUMMARY:"
  print "Most active hour: " max_hour " with " max " requests"
  print "Quietest hour: " min_hour " with " min " requests"
}'

#august
awk -F'[:[]' '{print $3}' NASA_Aug95.log | \
grep -E '^[0-9]{2}$' | \
sort | uniq -c | \
awk '
BEGIN { max = -1; min = 1e9 }
{
  count[$2] = $1
  if ($1 > max) { max = $1; max_hour = $2 }
  if ($1 < min) { min = $1; min_hour = $2 }
}
END {
  for (h in count) printf("Hour %s: %d requests\n", h, count[h])
  print "\nAUGUST SUMMARY:"
  print "Most active hour: " max_hour " with " max " requests"
  print "Quietest hour: " min_hour " with " min " requests"
}'

#8
#july
awk '$10 ~ /^[0-9]+$/ {sum += $10; if ($10 > max) max = $10; count++} 
END {
  print "JULY:"
  print "Max response size: " max " bytes"
  print "Average response size: " int(sum / count) " bytes"
}' NASA_Jul95.log

#august
awk '$10 ~ /^[0-9]+$/ {sum += $10; if ($10 > max) max = $10; count++} 
END {
  print "AUGUST:"
  print "Max response size: " max " bytes"
  print "Average response size: " int(sum / count) " bytes"
}' NASA_Aug95.log
