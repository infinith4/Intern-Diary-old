$(function() {
    
    $('#sampledata1').on('click', function() {
        var sampledata1="number,face,style,talk,response\n\
1,8,10,2,1\n\
2,8,7,1,3\n\
3,9,10,1,2\n\
4,10,10,3,2\n\
5,9,9,3,3\n\
6,9,10,2,1\n\
7,8,7,1,2\n\
8,8,9,2,1\n\
9,1,2,10,7\n\
10,1,2,8,8\n\
11,2,2,9,9\n\
12,3,1,10,9\n\
13,2,3,8,9\n\
14,3,3,9,10\n\
15,4,1,7,8\n\
16,3,2,8,8";
        //alert(sampledata1);
        //textSampledata1Node    = document.createTextNode(sampledata1);//タイトル
        //var elementNode = document.getElementById("content");
        //elementNode.appendChild(textSampledata1Node);
        $(".text").text(sampledata1);
    });
    $('#sampledata2').on('click', function() {
        var sampledata2="Area ,SO2 ,Neg.Temp ,Manuf  ,Pop ,Wind ,Precip ,Days\n\
Phoenix               ,10    ,-70.3   ,213  ,582  ,6.0   ,7.05   ,36\n\
LittleRock           ,13    ,-61.0    ,91  ,132  ,8.2  ,48.52  ,100\n\
SanFrancisco        ,12    ,-56.7   ,453  ,716  ,8.7  ,20.66   ,67\n\
Denver                ,17    ,-51.9   ,454  ,515  ,9.0  ,12.95   ,86\n\
Hartford              ,56    ,-49.1   ,412  ,158  ,9.0  ,43.37  ,127\n\
Wilmington            ,36    ,-54.0    ,80   ,80  ,9.0 , 40.25  ,114\n\
Washington           , 29   , -57.3  , 434  ,757 , 9.3 , 38.89 , 111\n\
Jacksonville          ,14   , -68.4 ,  136 , 529 , 8.8 , 54.47  ,116\n\
Miami                , 10  ,  -75.5 ,  207 , 335 , 9.0 , 59.80 , 128\n\
Atlanta              , 24   , -61.5  , 368 , 497  ,9.1  ,48.34 , 115\n\
Chicago             , 110  ,  -50.6 , 3344, 3369 ,10.4 , 34.44 , 122\n\
Indianapolis         , 28   , -52.3 ,  361 , 746 , 9.7 , 38.74 , 121\n\
DesMoines           , 17   , -49.0  , 104 , 201 ,11.2 , 30.85 , 103\n\
Wichita             ,   8  ,  -56.6 ,  125 , 277, 12.7 , 30.58  , 82\n\
Louisville           , 30  ,  -55.6  , 291,  593 , 8.3  ,43.11 , 123\n\
NewOrleans           , 9   , -68.3  , 204 , 361 , 8.4  ,56.77 , 113\n\
Baltimore            , 47  ,  -55.0 ,  625 , 905  ,9.6 , 41.31 , 111\n\
Detroit               ,35  ,  -49.9,  1064, 1513, 10.1 , 30.96 , 129\n\
Minneapolis-St.Paul,  29   , -43.5  , 699  ,744 ,10.6 , 25.94 , 137\n\
KansasCity         ,  14  ,  -54.5 ,  381 , 507 ,10.0 , 37.00 ,  99\n\
St.Louis            , 56   , -55.9 ,  775 , 622 , 9.5 , 35.89  ,105\n\
Omaha                 ,14   , -51.5  , 181 , 347 ,10.9 , 30.18  , 98\n\
Alburquerque        , 11  ,  -56.8  ,  46,  244,  8.9  , 7.77 ,  58\n\
Albany              ,  46  ,  -47.6  ,  44  ,116,  8.8,  33.36 , 135\n\
Buffalo             ,  11  ,  -47.1 ,  391 , 463 ,12.4 , 36.11 , 166\n\
Cincinnati          ,  23 ,   -54.0 ,  462 , 453 , 7.1 , 39.04  ,132\n\
Cleveland            , 65   , -49.7 , 1007  ,751 ,10.9 , 34.99  ,155\n\
Columbus              ,26  ,  -51.5 ,  266,  540 , 8.6  ,37.01 , 134\n\
Philadelphia         , 69  ,  -54.6 , 1692 ,1950 , 9.6 , 39.93  ,115\n\
Pittsburgh           , 61   , -50.4 ,  347 , 520 , 9.4 , 36.22  ,147\n\
Providence            ,94   , -50.0 ,  343,  179 ,10.6 , 42.75 , 125\n\
Memphis              , 10  ,  -61.6 ,  337 , 624 , 9.2 , 49.10  ,105\n\
Nashville          ,   18 ,   -59.4 ,  275 , 448  ,7.9  ,46.00  ,119\n\
Dallas                 ,9   , -66.2 ,  641 , 844, 10.9  ,35.94   ,78\n\
Houston             ,  10   , -68.9  , 721, 1233 ,10.8 , 48.19  ,103\n\
SaltLakeCity        ,28   , -51.0  , 137 , 176 , 8.7 , 15.17 ,  89\n\
Norfolk             ,  31  ,  -59.3   , 96 , 308 ,10.6  ,44.68 , 116\n\
Richmond             , 26  ,  -57.8  , 197 , 299 , 7.6 , 42.59  ,115\n\
Seattle              , 29   , -51.1   ,379 , 531 , 9.4 , 38.79  ,164\n\
Charleston           , 31   , -55.2   , 35  , 71  ,6.5 , 40.75  ,148\n\
Milwaukee             ,16   , -45.7  , 569 , 717 ,11.8 , 29.07 , 123";
        //alert(sampledata1);
        //textSampledata1Node    = document.createTextNode(sampledata1);//タイトル
        //var elementNode = document.getElementById("content");
        //elementNode.appendChild(textSampledata1Node);
        $(".text").text(sampledata2);
    });
    
    var page = +$('#page').attr('page')+1;
    
    $('#bottom').on('click', function() {
    $.ajax({
        type: "GET",
        url: "/api/",
        dataType: "JSON",
        data: {page: page++},//dataのpage,idがないと、エラーになる。コンソールを見て確認する。
        success :function (res){//resは、Intern::Diary::Engine::Api::Indexの$entrysのこと。local:3000/api/で確認できる。
            //$('#nextpage').remove();//id=nextpageを削除
            var elementNode = document.getElementById("nextpage");
            
            //next page を削除して、diaryを表示する。
            
            res.forEach(function(diary){//diaryがresの一つ一つの要素
                var titleElementNode = document.createElement("h2");
                var elm = document.createElement("div");

                //var editdeleteTextNode = document.createTextNode("[% diary.created_on.strftime('%Y-%m-%d') | html %]<a href='/diary.edit?id=[% diary.id | html %]'>編集</a><a href='/diary.delete?id=[% diary.id | html %]'>削除</a>");

                var brElementNode = document.createElement('br');
                
                //var editElementNode = document.createElement("a");
                
                textTitleNode    = document.createTextNode(diary.title);//タイトル
                textContentNode    = document.createTextNode(diary.content);//内容
                
                //textUpdateNode    = document.createTextNode("[% diary.created_on.strftime('%Y-%m-%d') | html %]");//更新時間
                
                elm.appendChild(titleElementNode);
                titleElementNode.appendChild(textTitleNode);//<h2>内にタイトルを入力
                elm.appendChild(brElementNode);
                elm.appendChild(textContentNode);
                //elm.appendChild(textUpdateNode);
                //elm.appendChild(editElementNode);
                elementNode.appendChild(elm);
                //elm.appendChild(editdeleteTextNode;
                
            });
            
        }
    });
    
    
    });
});



