$(function (res){
        
            var plot = function() {
            var canvas = document.getElementById('graph');
            var ctx = canvas.getContext('2d');
            ctx.clearRect(0, 0, 10, 10);
            /* 枠を書く */
            ctx.strokeRect(0, 0, 10, 10);
            /* パスの初期化 */
            ctx.beginPath();
            /* 初期配置 */
            ctx.moveTo(0, 250);
            /* 線を引く */
            ctx.lineTo(500, 250);
            ctx.closePath();
            
            
            //res.forEach(function(data){
            
                ctx.beginPath();
                ctx.strokeStyle = '#00F'; // 線の色を青にセット
                ctx.arc(10, 80, 3, 0, Math.PI * 2, false);
                ctx.fill();
                ctx.stroke();
            //)};
            var plotCurve = function(ctx, period) {
                for(var x = 0; x <= 500; x += 0.1) {
                //ctx.lineTo(x, 250 * (1 - Math.pow(Math.E, -0.005 * x) * Math.sin(((2 * period) * Math.PI) * x / 500)));
                }
            };

            init();
            };
        };
    });
});


