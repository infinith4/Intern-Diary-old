package t::Intern::Diary::MoCo::User;
use strict;
use warnings;
use base 'Test::Class';
use Test::More;
use t::Diary;

sub startup : Test(startup => 1) {
    use_ok 'Intern::Diary::MoCo::User';
    t::Diary->truncate_db;
}


sub diarys : Tests {

    my $user = Intern::Diary::MoCo::User->create(name => 'test_user_1'), 'create user';
    my $entry = $user->add_diary(title => 'hello', content => 'hello!');
    
    is_deeply
        $user->diarys->map(sub { $_->title })->to_a,
        [ 'hello' ],
        '$user->diarys';
}

sub diary_on_entry : Tests {

    my $user = Intern::Diary::MoCo::User->create(name => 'test_user_2'), 'create user';
    my $entry = $user->add_diary(title => 'hello', content => 'hello!');
    ok my $diary = $user->diary_on_entry($entry);
    is $diary->user_id, '2','$diary->user_id, 2';
    is $diary->id, '2','$diary->id, 2';
}



sub add_diary : Tests {
    
    ok my $user = Intern::Diary::MoCo::User->create(name => 'test_user_3'), 'create user';
    is_deeply $user->diarys->to_a, [];
    my $entry = $user->add_diary(title => 'hello', content => 'hello!');
    isa_ok $entry, 'Intern::Diary::MoCo::Entry';
    is $entry->title, 'hello', '$entry title';
    is_deeply
        $user->diarys->map(sub { $_->title })->to_a,
        [ 'hello' ],
        '$user->diarys';
}




sub delete_diary : Tests {
    
    ok my $user = Intern::Diary::MoCo::User->find(id => '1'), 'user1';
    ok my $entry = Intern::Diary::MoCo::Entry->find(id => '1'), 'user1 entry ';
    my $diary = $user->delete_diary($entry);#User.pm のdelete_diaryで削除する
    
    is_deeply $user->diarys->to_a, [];
    
}



__PACKAGE__->runtests;
