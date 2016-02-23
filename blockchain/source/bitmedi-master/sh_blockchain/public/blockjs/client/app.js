/**
 * Created by kimi on 15/7/5.
 */

//console.log(client_name );


var d3 = require('d3');


var _ = require('lodash');



console.log(data);

//var svg3 = d3.select("#p3");
var svg2 = d3.select("#p2");

function getlistdata() {
    return function(notify) {


        $.getJSON("http://139.196.190.15:3000/login/1?callback=?",
            function(data) {
                entries = data.entries;
                console.log(entries);
                notify(null, entries);

            });



    };
}




function co(gen) {
    var g = gen();
    function next(err, data) {
        var res;
        if(err) {
            return g.throw(err);
        } else {
            res = g.next(data);
        }
        if(!res.done) {
            res.value(next)
        }
    }
    next();
}

function * withYield() {

    var list = yield getlistdata();
    //console.log("list");
    //console.log(list);

    var svg1 = d3.select("#p1");

    var svg11 = svg1
        .append("g")
        .attr("transform", "translate(0,0)");

    svg11.append("rect")
        .attr("x", 240)
        .attr("y", 0)
        .attr("width", 900)
        .attr("height", 20)
        .style("fill", "gray");


    svg11.append("image")
        .attr("xlink:href", "blockjs/man369.png")
        .attr("x", "10")
        .attr("y", "20")
        .attr("width", "200")
        .attr("height", "200");





    var mul = 300;


    svg11.append("text")
        .attr("x", 75)
        .attr("y", 270)
        .text( "Icon made by Freepik")
        .attr("font-family", "sans-serif")
        .attr("font-size", "10px")
        .attr("fill", "blue");

    svg11.append("text")
        .attr("x", 75)
        .attr("y", 250)
        .text( "Patient")
        .attr("font-family", "sans-serif")
        .attr("font-size", "20px")
        .attr("fill", "blue");

    svg11.append("text")
        .attr("x", 250)
        .attr("y", 50)
        .text( "Medical electronics record")
        .attr("font-family", "sans-serif")
        .attr("font-size", "20px")
        .attr("fill", "black");

    svg11.selectAll("text2")
        .data(data)
        .enter()
        .append("text")
        .attr("x", function(d) { return 250; })
        .attr("y", function(d,i) {
            console.log(i);
            console.log(d);
            return 100+i*mul; })
        .text( function (d) { return "_id : "+d._id; })
        .attr("font-family", "sans-serif")
        .attr("font-size", "20px")
        .attr("fill", "blue");

    svg11.selectAll("rect_e")
        .data(data)
        .enter()
        .append("rect")

        .attr("x", function(d) { return 250-10; })
        .attr("y", function(d,i) {
            console.log(i);
            console.log(d);
            return 80+i*mul; })
        .style("fill", "none")
.attr("width", 650)
        .attr("stroke", "black")
        .attr("height", 250);


    svg11.selectAll("text_age")
        .data(data)
        .enter()
        .append("text")
        .attr("x", function(d) { return 250; })
        .attr("y", function(d,i) {
            console.log(i);
            console.log(d);
            return 100+i*mul+30; })
        .text( function (d) { return "Age : "+d.age; })
        .attr("font-family", "sans-serif")
        .attr("font-size", "20px")
        .attr("fill", "black");


    svg11.selectAll("text_gender")
        .data(data)
        .enter()
        .append("text")
        .attr("x", function(d) { return 250; })
        .attr("y", function(d,i) {
            console.log(i);
            console.log(d);
            return 100+i*mul+60; })
        .text( function (d) { return "gender : "+d.gender; })
        .attr("font-family", "sans-serif")
        .attr("font-size", "20px")
        .attr("fill", "black");

    svg11.selectAll("text_job")
        .data(data)
        .enter()
        .append("text")
        .attr("x", function(d) { return 250; })
        .attr("y", function(d,i) {
            console.log(i);
            console.log(d);
            return 100+i*mul+90; })
        .text( function (d) { return "job : "+d.job; })
        .attr("font-family", "sans-serif")
        .attr("font-size", "20px")
        .attr("fill", "black");

    svg11.selectAll("text_sympton")
        .data(data)
        .enter()
        .append("text")
        .attr("x", function(d) { return 250; })
        .attr("y", function(d,i) {
            console.log(i);
            console.log(d);
            return 100+i*mul+120; })
        .text( function (d) { return "sympton : "+d.sympton; })
        .attr("font-family", "sans-serif")
        .attr("font-size", "20px")
        .attr("fill", "black");

    svg11.selectAll("text_weight")
        .data(data)
        .enter()
        .append("text")
        .attr("x", function(d) { return 250; })
        .attr("y", function(d,i) {
            console.log(i);
            console.log(d);
            return 100+i*mul+150; })
        .text( function (d) { return "weight : "+d.weight; })
        .attr("font-family", "sans-serif")
        .attr("font-size", "20px")
        .attr("fill", "black");



    svg11.selectAll("image2")
        .data(data)
        .enter()
        .append("image")
        .attr("xlink:href", "blockjs/Body_cavities.jpg")
        .attr("x", function(d) { return 550; })
        .attr("y", function(d,i) {
            console.log(i);
            console.log(d);
            return 100+i*mul-40; })
        .attr("width", "300")
        .attr("height", "300");

    svg11.selectAll("text_source")
        .data(data)
        .enter()
        .append("text")
        .attr("x", function(d) { return 630; })
        .attr("y", function(d,i) {
            console.log(i);
            console.log(d);
            return 100+i*mul+190; })
        .text( function (d) { return "Author:Connexions"; })
        .attr("font-family", "sans-serif")
        .attr("font-size", "12px")
        .attr("fill", "black");

    svg11.selectAll("circle1")
        .data(data)
        .enter()
        .append("circle")
        .attr("cx", function(d) {
            if (d.sympton =='1')
            {return 610; }
            if (d.sympton =='2')
            {return 730; }
            if (d.sympton =='3')
            {return 730; }
            if (d.sympton =='4')
            {return 730; }
            if (d.sympton =='5')
            {return 730; }

        })
        .attr("cy", function(d,i) {
            if (d.sympton =='1')
            {return 100+i*mul+50+90; }
            if (d.sympton =='2')
            {return 100+i*mul+100; }
            if (d.sympton =='3')
            {return 100+i*mul+50+116; }
            if (d.sympton =='4')
            {return 100+i*mul+50; }
            if (d.sympton =='5')
            {return 100+i*mul+50; }

        })
        .attr("r", function (d) { return 10; })
        .style("fill", function(d) { return "red"; });





}

co(withYield);

$('#myModal').modal('show');












