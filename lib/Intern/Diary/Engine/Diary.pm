package Intern::Diary::Engine::Diary;
use strict;
use warnings;
use Intern::Diary::Engine -Base;
use Intern::Diary::MoCo;
use Statistics::PCA;
use utf8;
use HTML::Entities;
use Statistics::Lite qw(mean);
use JSON::XS;
use GD::Graph::points;
use Jcode;

sub default : Public {
    my ($self, $r) = @_;
    my $id = $r->req->param('id');
    my $user = moco("User")->find(id => $id);
    my $diarys = $user->diarys;
    

    $r->stash->param(
        user    => $user,
        diarys => $diarys,
    );
}

sub add : Public {
    my ($self, $r) = @_;

    my $id = $r->req->param('id');
    my $entry = $id ? moco("Entry")->find(id => $id) : undef;#$id があったら、$entry = $id、なかったら、moco("Entry")->find(id => $id) : undef
    #print Data::Dumper::Dumper $entry;
    my $diary = $entry ? $r->user->diary_on_entry($entry) : undef;

    $r->stash->param(
        entry => $entry,
        diary => $diary,
    );

    $r->follow_method;
}

sub _add_get {
}

sub _add_post {
    my ($self, $r) = @_;
    my $id = $r->req->param('id');
    #print Data::Dumper::Dumper $id;
    my $title = $r->req->param('title');
    my $content = $r->req->param('content');#textareaに書かれたコンテンツ
    my $main_content = $r->req->param('main_content');#textareaに書かれたコンテンツ
    #idを取得する
    my $status;
    moco("Entry")->db->execute("show table status where name = ?",\$status,['entry']);
    $id=$status->[0]->{'Auto_increment'};
    #print $id,"\n";
    
    #ここは、titleがundefのときにする。空白だとうまくいかない。
    if ($title==""){
        $title="■";
    }
    
    
    my $result_content = pca($id,$content);
    
    
    my $diary = $r->user->add_diary(
            title => $title,
            content => $content,
            main_content => $main_content,
            result_content => $result_content,
        );
    $r->res->redirect('/');
}


sub edit : Public {
    my ($self, $r) = @_;

    my $id = $r->req->param('id');
    my $entry = $id ? moco("Entry")->find(id => $id) : undef;#$id があったら、$entry = $id、なかったら、moco("Entry")->find(id => $id) : undef
    my $diary = $entry ? $r->user->diary_on_entry($entry) : undef;
    
    $r->stash->param(
        entry => $entry,
        diary => $diary,
    );

    $r->follow_method;
}

sub _edit_get {
}

sub _edit_post {
    my ($self, $r) = @_;
    my $title = $r->req->param('title');
    my $content = $r->req->param('content');
    my $main_content = $r->req->param('main_content');
    my $id = $r->req->param('id');
    
    my $result_content = pca($id,$content);#エラーが起きた時にリダイレクトする
    
    my $entry = $id ? moco("Entry")->find(id => $id) : undef;
    $entry->title($title);
    $entry->content($content);
    $entry->main_content($main_content);
    $entry->result_content($result_content);
    
    
    $r->res->redirect('/');
}




sub delete : Public {
    my ($self, $r) = @_;

    my $id = $r->req->param('id');
    my $entry = $id ? moco("Entry")->find(id => $id) : undef;
    my $diary = $entry ? $r->user->diary_on_entry($entry) : undef;

    $r->stash->param(
        entry => $entry,
        diary => $diary,
    );

    $r->follow_method;
}

sub _delete_get {
}

sub _delete_post {
    my ($self, $r) = @_;

    $r->user->delete_diary($r->stash->param('entry'));

    $r->res->redirect('/');
}

sub pca{
    my ($id,$content)=@_;
    #$contentの表は、第１列は標本名、第1行は変数とする
    #$contentを下の形式にする

    my @lines = split(/\r?\n/, $content);
    #print @lines;
    my @table_data=();
    my @tmp=();



    my $i=0;
    my $j;
    #データを行列の形にする
    foreach my $line (@lines){
        @tmp=split /,/, $line;#$lineは一行
            #warn @tmp;
            for($j=0;$j<scalar(@tmp);$j++){
                
                $table_data[$i][$j]=$tmp[$j];
            }
            $i++;
    }
    
    #print Data::Dumper::Dumper \@data;
    
    my $pca = Statistics::PCA->new;
    #@dataの観測名と変数名を除く
    my $row=$i;
    my $col=$j;
    
    my @data=();#解析用データ
    my @names=();#標本名（行）
    my @variables=();#変数名（列）
    
    for ($i=0;$i<$row-1;$i++){
            for ($j=0;$j<$col-1;$j++){
                $data[$i][$j]=$table_data[$i+1][$j+1]
            }
    }
    #$@dataを標準化する。
    
#=comment
    #sub Xvar{
        my @mean;
        for(my $j=0;$j<$col-1;$j++){
            for(my $i=0;$i<$row-1;$i++){
                $mean[$j]+=$data[$i][$j];
        
            }
            $mean[$j]=$mean[$j]/($row-1);
        }
        
        #return((1/n)*rowSums(X))#各行の和
    #}
#=cut
    #print Data::Dumper::Dumper \@mean;

    #標本分散
    my @uvari;
    
    for ($j=0;$j<$col-1;$j++){
        for ($i=0;$i<$row-1;$i++){
            $uvari[$j]+=($data[$i][$j]-$mean[$j])*($data[$i][$j]-$mean[$j]);
        }
        $uvari[$j]=$uvari[$j]/($row-1);
    }
#=cut

    
    #print Data::Dumper::Dumper \@data;
    for($i=0;$i<$row-1;$i++){
        for($j=0;$j<$col-1;$j++){
            $data[$i][$j]=($data[$i][$j]-$mean[$j])/sqrt $uvari[$j];
        }
    }
    
    #print Data::Dumper::Dumper \@data;

    for($i=0;$i<$row-1;$i++){#標本名
        $names[$i]=$table_data[$i+1][0];
    }
    
    #print Data::Dumper::Dumper \@names;
    for($i=0;$i<$col;$i++){#変数名
            $variables[$i]=$table_data[0][$i];
    }
    
    #print Data::Dumper::Dumper \@variables;
    
    my $data=\@data;
    #print Data::Dumper::Dumper $data;
    #my $data=\@data;
    
=comment
    #                       Var1    Var2    Var3    Var4 ...
    my $data  =   [   
                    [qw/    32      26      51      12    /],     # Obs1
                    [qw/    17      13      34      35    /],     # Obs2
                    [qw/    10      94      83      45    /],     # Obs3
                    [qw/    3       72      72      67    /],     # Obs4
                    [qw/    10      63      35      34    /],     # Obs5 ...
                ];
=cut
    #warn $data->[0][0];
    
    $pca->load_data ( { format => 'table', data => $data, } );
    
    $pca->pca();   
    #$pca->pca( { eigen => 'M' } );
    #$pca->pca( { eigen => 'C' } );

    #$pca->results;
    
    my @proportion = $pca->results('proportion');#寄与率
    #print Data::Dumper::Dumper @proportion,"\n";
    my @cumulative = $pca->results('cumulative');#累積寄与率
    #print Data::Dumper::Dumper @cumulative,"\n";
    my @stdev = $pca->results('stdev');#standard deviation
    #print Data::Dumper::Dumper @stdev,"\n";
    my @eigenvalue = $pca->results('eigenvalue');
    #print Data::Dumper::Dumper @eigenvalue,"\n";
    my @eigenvector = $pca->results('eigenvector');
    #print Data::Dumper::Dumper @eigenvector,"\n";
    my @full = $pca->results('full');

    #tableをつくる

    my $tag_table_st="<table border='1' cellspacing='0' cellpadding='5' bordercolor='#a0a0a0'>";
    my $tag_table_ed="</table>";
    my $tag_tr_st="<tr>";
    my $tag_tr_ed="</tr>";
    my $tag_td_st="<td>";
    my $tag_td_ed="</td>";
    my $tag_th_st="<th bgcolor='#98fb98'>";
    my $tag_th_ed="</th>";
    my $table_pc="<th></th>";
    my $table_proportion="<td bgcolor='#b0c4de'>Proportion(寄与率)</td>";
    my $table_cumulative="<td bgcolor='#b0c4de'>Cumulative(累積寄与率)</td>";
    my $table_stdev="<td bgcolor='#b0c4de'>Standard Deviation(標準偏差)</td>";
    my $table_eigenvalue="<td bgcolor='#b0c4de'>固有値</td>";
    my $table_eigenvector="";
    
    for ($i=0;$i<$col-1;$i++){#$col-1は変数の数
        $table_pc=$table_pc.$tag_th_st."第".($i+1)."主成分".$tag_th_ed;
        $table_proportion=$table_proportion.$tag_td_st.sprintf( "%-5.5f", $proportion[$i] ).$tag_td_ed;
        $table_cumulative=$table_cumulative.$tag_td_st.sprintf( "%-5.5f", $cumulative[$i] ).$tag_td_ed;
        $table_stdev=$table_stdev.$tag_td_st.sprintf( "%-5.5f", $stdev[$i] ).$tag_td_ed;
        $table_eigenvalue=$table_eigenvalue.$tag_td_st.sprintf( "%-5.5f", $eigenvalue[$i] ).$tag_td_ed;
        #$table_eigenvector=$table_eigenvector.$tag_td_st.$eigenvector[$i].$tag_td_ed;
    
    }
    
    #print $table_proportion;
    $table_proportion = $tag_tr_st.$table_proportion.$tag_tr_ed;
    $table_cumulative = $tag_tr_st.$table_cumulative.$tag_tr_ed;
    $table_stdev = $tag_tr_st.$table_stdev.$tag_tr_ed;
    $table_eigenvalue = $tag_tr_st.$table_eigenvalue.$tag_tr_ed;
    #$table_eigenvector = $tag_tr_st.$table_eigenvector.$tag_tr_ed;
    $table_pc = $tag_tr_st.$table_pc.$tag_tr_ed;
    #print "======\n";
    #print scalar(@eigenvector),"\n";
    my $table_eigen;
    for ($i=0;$i < $col-1 ;$i++){#変数の数
        $table_eigenvector = $table_eigenvector."<tr><td bgcolor='#ffb6c1'>$variables[$i+1]</td>";
        for ($j=0;$j<scalar(@eigenvector);$j++){#$col-1はPCの数

            if($j==0){
                $table_eigenvector=$table_eigenvector.$tag_td_st.sprintf( "%-5.5f", $eigenvector[$j][$i] ).$tag_td_ed;#列がPCの数、行が変数名

            }elsif($j==scalar(@eigenvector)-1){

                $table_eigenvector=$table_eigenvector.$tag_td_st.sprintf( "%-5.5f", $eigenvector[$j][$i] ).$tag_td_ed."</tr>";#列がPCの数、行が変数名

            }else{
                $table_eigenvector=$table_eigenvector.$tag_td_st.sprintf( "%-5.5f", $eigenvector[$j][$i] ).$tag_td_ed;#列がPCの数、行が変数名
                
            }
            

        }
    }
    
    
    my @neweigenvector=();
    
    for ($i=0;$i<$col-1;$i++){
        for ($j=0;$j<$col-1;$j++){
            $neweigenvector[$j][$i]=$eigenvector[$i][$j];
        }
    }
    
    #標本に対する第i主成分を計算する(i=1..標本数)
    my @pc=();#
    #標本に対する第1主成分を計算する
    
    #内積
    $j=0;
    for ($j=0;$j<$col-1;$j++ ){#各標本
        for (my $k=0;$k<$row-1;$k++){
            for ($i=0;$i<$col-1;$i++){
                #print Data::Dumper::Dumper $eigenvector[$j][$i];
                #print Data::Dumper::Dumper $data[$k][$i];
                
                
                $pc[$j][$k]+=$eigenvector[$j][$i]*$data[$k][$i];
                $pc[$j][$k]=sprintf( "%-.4f",$pc[$j][$k]); 
                
            }
        }
    }
    
 
    
    my $result_content = "主成分分析の結果だよ！簡単でしょ？<br>".$tag_table_st.$table_pc.$table_proportion.$table_cumulative.$table_stdev.$table_eigenvalue.$tag_table_ed;
    $result_content=$result_content."<br><br>固有ベクトル<br><font color='#f0f0f0'>*</font>第1主成分のなかで、2つ最大または最小のものを探して、その2つの変数が何を表しているか解釈してみよう！<br>次の第2主成分でも同じ事をして解釈してみよう!".$tag_table_st.$table_pc.$table_eigenvector.$tag_table_ed;
    
    #$result_content = $tag_table_st."<br>".$table_pc.$table_proportion.$table_cumulative.$table_stdev.$table_eigenvalue.$table_eigenvector.$tag_table_ed;
    



    
    sub matmax{#最大値を取得
        my (@mat)=@_;
        my $matmax = $mat[0][0];
        for ($i=1;$i<$#{$mat[0]};$i++){
            if($matmax<$mat[0][$i]){
                $matmax = $mat[0][$i];
            }
        }
        return $matmax;
    }
    
    sub matmin{#最小値を取得
        my (@mat)=@_;
        my $matmin = $mat[0][0];
        for ($i=1;$i<$#{$mat[0]};$i++){
            if($matmin>$mat[0][$i]){
                $matmin = $mat[0][$i];
            }
        }
        return $matmin;
    }
    sub randcolor {
        my $length = $_[0];

        my @char_tmp=();

        # 配列にランダム生成する対象の文字列を格納
        # (以下は、小文字のa～z、大文字のA～Z、数字の0～9)
        push @char_tmp, ('a'..'f');
        #push @char_tmp, ('A'..'F');
        push @char_tmp, (0..9);

        # 指定文字数分、ランダム文字列を生成する
        my $rand_str_tmp = '';
        my $i;
        for ($i=1; $i<=$length; $i++) {
            $rand_str_tmp .= $char_tmp[int(rand($#char_tmp+1))];
        }

        return $rand_str_tmp;
    }
    
    
    #第i主成分で累積寄与率が95%以上なら、そこまででの組み合わせの画像を表示する。
    #0.90以上である主成分の番号を見つける
    my $limit_pcnum=0;
    my $cnt=0;
    for ($i=0;$i<$col-1;$i++){
        if(0.90>$cumulative[$i]){
            $limit_pcnum=$i;
            #print "$cumulative[$i]\n";
            
        }
    }
    
    if($limit_pcnum==0){
        $limit_pcnum=1;
    }
    #print Data::Dumper::Dumper @names;
    #print Data::Dumper::Dumper $limit_pcnum,"\n";
    
    my @pc_part=();
    
    my $tag_image_pc="";
    my $k=0;
    
    for ($j=0;$j<$limit_pcnum+1;$j++){
                #print "=======\n";
                #print $j.",".$k,"\n";
        #for ($i=0;$i<$limit_pcnum+1;$i++){
        for ($k=0;$k<$limit_pcnum+1;$k++){
            
            #print $j.",".$k,"\n";
#=comment
            #print $limit_pcnum,"\n";
            if($j<=$k||$j!=$limit_pcnum){
                @pc_part =($pc[$j],$pc[$j+$k+1]);
                #print Data::Dumper::Dumper \@pc_part;
            }
            #print $j.",".$k,"\n";
            
            
            
            if($j<$k){
                
                my $graph = GD::Graph::points->new(500,500);
                my $a=$j+1;
                my $b=$k+1;
                $graph->set(
                    markers => [7],#形
                    x_min_value => &matmin(@pc_part[0])-0.5,#x軸の最小値
                    x_max_value => &matmax(@pc_part[0])+0.5,#最大値
                    y_min_value => &matmin(@pc_part[1])-0.5,#x軸の最小値
                    y_max_value => &matmax(@pc_part[1])+0.5,#最大値
                    x_tick_number => 10,
                    title   => "PC$a - PC$b",
                    bgclr       => "white",
                    fgclr => "bule",
                    
                );

            my $image = $graph->plot(\@pc_part)or die;
                #print "====a==\n";
                #print $j.",".$k,"\n";
                #ファイル名は、id+pc$j$k
                open(OUT, ">static/images/$id"."pc$a$b.png") or die;#単純に.pngとかにするとIntern-Diaryの直下に置かれる
                
                binmode OUT;
                print OUT $image->png();
                close(OUT);
                $tag_image_pc=$tag_image_pc."<img src='images/$id"."pc$a$b.png'>";
            
            }
#=cut
        }
        
    }
    
    $result_content=$result_content.$tag_image_pc;
    
    
    use HTML::Entities;
    
    foreach (@names) {
        
        $_ = encode_entities($_,qw(&<>'"));
    }
    
    foreach (@variables) {
        $_ = encode_entities($_,qw(&<>'"));
    }
    
    #print Data::Dumper::Dumper @names;
    #print Data::Dumper::Dumper @variables;
    
    #標本に対する、主成分を表にする。
    #print Data::Dumper::Dumper \@pc;
    #print $table_pc;
    my $table_pc_value;
    for ($i=0;$i < $row-1 ;$i++){#変数の数
        $table_pc_value = $table_pc_value."<tr><td bgcolor='#ffb6c1'>$names[$i]</td>";
        for ($j=0;$j<$col-1;$j++){#$col-1はPCの数

            if($j==0){
                $table_pc_value=$table_pc_value.$tag_td_st.sprintf( "%-5.5f", $pc[$j][$i] ).$tag_td_ed;#列がPCの数、行が変数名

            }elsif($j==$col-1){

                $table_pc_value=$table_pc_value.$tag_td_st.sprintf( "%-5.5f", $pc[$j][$i] ).$tag_td_ed."</tr>";#列がPCの数、行が変数名

            }else{
                $table_pc_value=$table_pc_value.$tag_td_st.sprintf( "%-5.5f", $pc[$j][$i] ).$tag_td_ed;#列がPCの数、行が変数名
                
            }
            

        }
    }
    
    $result_content=$result_content."<br><br>各標本に対する主成分".$tag_table_st.$table_pc.$table_pc_value."</table>";
    
    
    return $result_content;
    
    
}



1;
