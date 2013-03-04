package Intern::Diary::DataBase;
use strict;
use warnings;
use base 'DBIx::MoCo::DataBase';

#DB の接続情報を設定
__PACKAGE__->dsn('dbi:mysql:dbname=intern_diary_infinity_th4');

__PACKAGE__->username('root');
__PACKAGE__->password('');

1;
