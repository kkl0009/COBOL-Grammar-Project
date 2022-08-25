#!/bin/bash

bison testCobol.y
cc -o testCobol testCobol.tab.c
./testCobol < statements
