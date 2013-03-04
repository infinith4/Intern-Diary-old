package Intern::Diary::Engine::Api::Index;
use strict;
use warnings;
use Intern::Diary::Engine -Base;
use Intern::Diary::MoCo;
use JSON::XS;
use Data::Dumper;
use utf8;

sub default : Public {#/api/ #最後に/がいる
    my ($self, $r) = @_;
    my $id = $r->req->param('id') || 1;#user_id
    my $user = moco("User")->find(id => $id);
    my $diarys = $user->diarys;
    
    my $page = $r->req->param('page') || 1;#page番号を受け取る、なかったら1にする
    my $limit = 30;
    my $offset = ($page - 1) * $limit;#何番目からみるか
    my $user_id = $user->id;
    
    #次のダイアリーを取得する
    my $diarys = moco("Entry")->search(#moco("Entry")でenterテーブルを参照。
      where => { user_id => $user_id },#columnのuser_idを参照し、
      offset => $offset,
      limit    => $limit,
      order   => 'created_on DESC',#columnのuser_idで降順にする
    );
    
    $r->res->content_type('application/json');
    #warn "=---------------";
    #warn $diarys->[0]->updated_on;
    
    my $entrys=[
        map{
            {
            title => $_->title,
            content => $_->content,
            result_content => $_->result_content,
            
            #updated_on => $_ -> updated_on,
            }
        } @$diarys];
    
    $r->res->content(encode_json $entrys);#static/js/diary.jsのresに渡す
    
    
    

}

#sub up

1;
