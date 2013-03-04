package Intern::Diary;
use strict;
use warnings;
use base qw/Ridge/;
use Intern::Diary::MoCo;

__PACKAGE__->configure;

sub user {
    my ($self) = @_;
    my $user = moco('User')->find(name => 'infinity_th4') || moco('User')->create(name => 'infinity_th4');
    $user;
}


1;
