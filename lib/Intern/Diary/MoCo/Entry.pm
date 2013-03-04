package Intern::Diary::MoCo::Entry;
use strict;
use warnings;
use base 'Intern::Diary::MoCo';
use Intern::Diary::MoCo;


__PACKAGE__->table('entry');

__PACKAGE__->utf8_columns(qw(title content));



sub as_string {#list diary の表示
    my $self = shift;
    
    print "entry_id ; title : content\n";
    return sprintf '[%d] ; %s : %s', (
        $self->id,
        $self->title,
        $self->result_content,
        
    );
}


1;
