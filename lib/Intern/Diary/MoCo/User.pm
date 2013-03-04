package Intern::Diary::MoCo::User;
use strict;
use warnings;
use base 'Intern::Diary::MoCo';
use Intern::Diary::MoCo;
use Carp qw(croak);
use HTML::Entities;

__PACKAGE__->table('user');

sub diarys {
    my $self = shift;
    
    return moco('Entry')->search(
        where => { user_id => $self->id },
        order => 'created_on DESC',#降順
    );
}

#diary上のentryを見つける
sub diary_on_entry {
    my ($self, $entry) = @_;
    return moco('Entry')->find(
        user_id => $self->id,
        id => $entry->id,
    );
}

#diaryを追加する
sub add_diary {
    my ($self, %args) = @_;
    my $title = $args{title} or croak q(add_diary: parameter 'title' required);
    my $content = $args{content};
    my $main_content = $args{main_content};
    my $result_content = $args{result_content};
    #$content = Text::Xslate::mark_raw( $content);
    my $entry = moco('Entry')->create(title => $title,content=> $content,main_content => $main_content,result_content => $result_content,user_id=>$self->id);

    return $entry;
}

#diaryを削除する
sub delete_diary {
    my ($self, $entry) = @_;
    my $diary = $self->diary_on_entry($entry) or return;
    $diary->delete;
    return $diary;
}

1;
