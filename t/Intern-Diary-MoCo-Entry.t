package t::Intern::Diary::MoCo::Entry;
use strict;
use warnings;
use base 'Test::Class';
use Test::More;
use t::Diary;


sub startup : Test(startup => 1) {
    use_ok 'Intern::Diary::MoCo::Entry';
    t::Diary->truncate_db;
}


sub as_string : Tests {

    ok my $entry = Intern::Diary::MoCo::Entry->create(id => '1',user_id => '1', title => 'test_title' ,content => 'content_test'), 'create entry';
    is $entry->as_string,"[1] ; test_title : content_test",'$entry->as_string,"[1] ; test_title : content_test"';
    
}




__PACKAGE__->runtests;
