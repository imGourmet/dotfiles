#!/bin/bash

memory_used=$(free | grep Mem | awk '{printf("%d", $3/$2 * 100.0)}')

echo "${memory_used}%"
