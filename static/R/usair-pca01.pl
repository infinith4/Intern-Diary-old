use strict;
use warnings;
use Statistics::PCA;


my $pca = Statistics::PCA->new;
my $data  =   [
[qw/                10    -70.3   213  582  6.0   7.05   36/],
[qw/            13    -61.0    91  132  8.2  48.52  100/],
[qw/         12    -56.7   453  716  8.7  20.66   67/],
[qw/                17    -51.9   454  515  9.0  12.95   86/],
[qw/           56    -49.1   412  158  9.0  43.37  127/],
[qw/             36    -54.0    80   80  9.0  40.25  114/],
[qw/            29    -57.3   434  757  9.3  38.89  111/],
[qw/           14    -68.4   136  529  8.8  54.47  116/],
[qw/                  10    -75.5   207  335  9.0  59.80  128/],
[qw/               24    -61.5   368  497  9.1  48.34  115/],
[qw/              110    -50.6  3344 3369 10.4  34.44  122/],
[qw/           28    -52.3   361  746  9.7  38.74  121/],
[qw/             17    -49.0   104  201 11.2  30.85  103/],
[qw/                 8    -56.6   125  277 12.7  30.58   82/],
[qw/             30    -55.6   291  593  8.3  43.11  123/],
[qw/             9    -68.3   204  361  8.4  56.77  113/],
[qw/              47    -55.0   625  905  9.6  41.31  111/],
[qw/                35    -49.9  1064 1513 10.1  30.96  129/],
[qw/   29    -43.5   699  744 10.6  25.94  137/],
[qw/            14    -54.5   381  507 10.0  37.00   99/],
[qw/              56    -55.9   775  622  9.5  35.89  105/],
[qw/                  14    -51.5   181  347 10.9  30.18   98/],
[qw/          11    -56.8    46  244  8.9   7.77   58/],
[qw/                 46    -47.6    44  116  8.8  33.36  135/],
[qw/                11    -47.1   391  463 12.4  36.11  166/],
[qw/             23    -54.0   462  453  7.1  39.04  132/],
[qw/              65    -49.7  1007  751 10.9  34.99  155/],
[qw/               26    -51.5   266  540  8.6  37.01  134/],
[qw/           69    -54.6  1692 1950  9.6  39.93  115/],
[qw/             61    -50.4   347  520  9.4  36.22  147/],
[qw/             94    -50.0   343  179 10.6  42.75  125/],
[qw/                10    -61.6   337  624  9.2  49.10  105/],
[qw/              18    -59.4   275  448  7.9  46.00  119/],
[qw/                  9    -66.2   641  844 10.9  35.94   78/],
[qw/                10    -68.9   721 1233 10.8  48.19  103/],
[qw/        28    -51.0   137  176  8.7  15.17   89/],
[qw/                31    -59.3    96  308 10.6  44.68  116/],
[qw/               26    -57.8   197  299  7.6  42.59  115/],
[qw/                29    -51.1   379  531  9.4  38.79  164/],
[qw/             31    -55.2    35   71  6.5  40.75  148/],
[qw/              16    -45.7   569  717 11.8  29.07  123/]
];

$pca->load_data ( { format => 'table', data => $data, } );

$pca->pca();   
$pca->pca( { eigen => 'M' } );
$pca->pca( { eigen => 'C' } );

$pca->results;
 
 my @list = $pca->results('eigenvalue');
    print qq{\nOrdered list of individual proportions of variance: @list};
    
    
    
 
