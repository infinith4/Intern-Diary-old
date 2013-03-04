#!/bin/sh
mysql -uroot -e 'DROP DATABASE IF EXISTS intern_diary_test_infinity_th4'
mysql -uroot -e 'CREATE DATABASE intern_diary_test_infinity_th4'
mysql -uroot intern_diary_test_infinity_th4 < db/schema.sql
