//= include_foreman javascripts/charts.js

//write extra js to override

function expanded_pie(target, data){
    $.plot(target, data, {
        colors: ['#0099d3', '#393f44','#00618a','#505459','#057d9f','#025167'],
        series: {
            pie: {
                show: true,
                innerRadius: 0.8*3/4,
                radius: 0.8,
                labels: {
                    show:true,
                    radius: 1
                }
            }
        },
        legend: {
            show: false
        },
        grid: {
            hoverable: true,
            clickable: true
        }
    });

    target.bind("plotclick", function (event, pos, item) {
        //this is the override part
        console.log("overriden");
    });
}
