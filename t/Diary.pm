package t::Diary;
use strict;
use warnings;
use lib 'lib', glob 'modules/*/lib';
use Intern::Diary::DataBase;

Intern::Diary::DataBase->dsn('dbi:mysql:dbname=intern_diary_test_infinity_th4');

sub truncate_db {
    Intern::Diary::DataBase->execute("TRUNCATE TABLE $_") for qw(user entry diary);
}

1;
