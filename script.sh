#!/bin/bash

for i in {1..20}
do
	touch text$i
	git add .
	git commit -m "test"
done
