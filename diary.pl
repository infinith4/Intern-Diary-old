#!/usr/bin/perl -I./lib
#use v5.14
use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/lib", glob "$FindBin::Bin/modules/*/lib";
use Intern::Diary::MoCo;
use Pod::Usage; # for pod2usage()
use Encode::Locale;
use utf8;

binmode STDOUT, ':encoding(console_out)';

my %HANDLERS = (
    add  => \&add_diary,        #diary を加える
    list => \&list_diarys,      #listを表示する
    delete => \&delete_diary,   #diaryを削除する
    edit => \&edit_diary,       #diaryを編集する
);

my $command = shift @ARGV || 'list';#先頭を取り出す
my $user = moco('User')->find(name => $ENV{USER}) || moco('User')->create(name => $ENV{USER});
my $handler = $HANDLERS{ $command } or pod2usage;

$handler->($user, @ARGV);

exit 0;



sub add_diary {
    my ($user, $title) = @_;
    print "内容を入力してください: \n";
    my $content =<STDIN>;
    chomp($content);
    
    my $diary = $user->add_diary(
        title => $title,
        content => $content,
    );
    print 'posted ', $diary->as_string, "\n";
}

sub list_diarys {
    my ($user) = @_;

    printf " *** %s's diarys ***\n", $user->name;

    my $diarys = $user->diarys;
    foreach my $diary (@$diarys) {
        print $diary->as_string, "\n";
    }
}


sub edit_diary {#内容を表示して、上書きする

    my ($user, $entry_id) = @_;
    my $entry = moco('Entry')->find(id => $entry_id) or die "entry id=$entry_id not found";#edit するidを見つける
    #内容を表示
    print "title: ",$entry->title,"\n";
    print "content: ",$entry->content,"\n";
    
    #titleを編集する
    print "新しいタイトルを入力してください: \n";
    my $title =<STDIN>;
    chomp($title);
    $entry->title($title);
    
    #contentを編集する
    print "新しい内容を入力してください: \n";
    my $content =<STDIN>;
    chomp($content);
    $entry->content($content);

}

sub delete_diary {
    my ($user, $entry_id) = @_;
    die 'entry_id required' unless defined $entry_id;
    my $entry = moco('Entry')->find(id => $entry_id) or die "entry id=$entry_id not found";#delete するidを見つける
    my $diary = $user->delete_diary($entry);#User.pm のdelete_diaryで削除する
    
    if ($diary) {
        print 'deleted ', $diary->as_string, "\n";
    }
}
