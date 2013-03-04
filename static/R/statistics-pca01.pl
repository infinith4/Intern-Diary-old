use strict;
use warnings;
use Statistics::PCA;


my $pca = Statistics::PCA->new;



#                       Var1    Var2    Var3    Var4 ...
my $data  =   [   
                [qw/    32      26      51      12    /],     # Obs1
                [qw/    17      13      34      35    /],     # Obs2
                [qw/    10      94      83      45    /],     # Obs3
                [qw/    3       72      72      67    /],     # Obs4
                [qw/    10      63      35      34    /],     # Obs5 ...
            ];

$pca->load_data ( { format => 'table', data => $data, } );

$pca->pca();   
$pca->pca( { eigen => 'M' } );
$pca->pca( { eigen => 'C' } );

$pca->results;
 
 my @list = $pca->results('proportion');
    print qq{\nOrdered list of individual proportions of variance: @list};

 
