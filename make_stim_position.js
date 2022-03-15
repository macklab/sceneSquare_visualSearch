function make_stim_position(max_set_size, radius, stim_size, base_arena){

    // #basic_arena {
    //     position: relative;
    //     margin: auto;              
    //     left: 0;
    //     top: 0;
    //     right: 0;
    //     bottom: 0;
    //     width: 800px;
    //     height: 600px;                
    //     display: flex;
    //     align-items: center;                
    //     border: 1px solid grey;
    // } 
    // define 8 positions on the circle   
    var arena = document.querySelector('base_arena');
    console.log(arena);
    var rect = arena.getBoundingClientRect();      
    var container_centerX = rect.left + rect.width/2;
    var container_centerY = rect.top + rect.height/2;
    var angles = _.range(0, 2*Math.PI, max_set_size);
    var start_XYs = [];
    for (var i in angles){
        var x = container_centerX + Math.cos(i)*radius - (stim_size/2);
        var y = container_centerY + Math.sin(i)*radius - (stim_size/2);
        start_XYs.push([x,y]);
    }

    return start_XYs;

}