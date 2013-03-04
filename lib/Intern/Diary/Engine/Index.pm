package Intern::Diary::Engine::Index;
use strict;
use warnings;
use Intern::Diary::Engine -Base;
use Intern::Diary::MoCo;


sub default : Public {
    my ($self, $r) = @_;    
    
    
    my $user = moco('User')->retrieve_by_name('infinity_th4');# || moco('User')->create(name => 'infinity_th4');
    my $page = $r->req->param('page') || 1;#page番号を受け取る、なかったら1にする
    my $limit = 30;
    my $offset = ($page - 1) * $limit;
    
    my $user_id = $user->id;
    
    #次のダイアリーを取得する
    my $diarys = moco("Entry")->search(#moco("Entry")でenterテーブルを参照。
      where => { user_id => $user_id },#columnのuser_idを参照し、
      offset => $offset,
      limit    => $limit,
      order   => 'created_on DESC',#columnのuser_idで降順にする
    );
    
    $r->stash->param(#htmlにdiaryとpageを渡す
        diarys => $diarys,
        page    => $page,
    );
}

1;
