function make_condition(cond_list, jitter, target_coord, n_block) {

    // prepare the base cell coord
    var cell_coord = [];  
    for(y=-12; y<=12; y++){
        for(x=-12; x<=12; x++){
            cell_coord.push(x+"_"+y);
        }        
    };
    
    // ***** 1-D feature ***** //
    var oneDim_ftr = [];
    for(i=0; i<cond_list.length; i++){
        // target_coord
        if(cond_list[i].target_ox==0){
            var target = [];
            var target_path = [];
        }else{
            var target = target_coord;
            var target_path = 'stimuli/bedroom5_ver4/'+
            ('000000'+cell_coord.indexOf(target)).slice(-6)+'.webp';
        }
        // get foil coords
        var distance = Math.round(Math.sqrt(cond_list[i].dist*cond_list[i].dist/2));
        var nt1 = distance*cond_list[i].direction;        
        var nt_coords = [];
        for(ss in _.range(cond_list[i].set_size)){
            if(cond_list[i].dimension==-1){
                var nt = (nt1+_.sample(jitter,1)[0])+'_'+(nt1+_.sample(jitter,1)[0]);
            }else{
                var nt = (nt1+_.sample(jitter,1)[0])+'_'+(nt1*-1+_.sample(jitter,1)[0]);
            }
            nt_coords.push(nt);
        }
        nt_coords= nt_coords.slice(0,cond_list[i].set_size-cond_list[i].target_ox);
        
        oneDim_ftr.push({
            type:'oneDim-feature',
            set_size: cond_list[i].set_size,
            target_ox: cond_list[i].target_ox,
            dimension: cond_list[i].dimension,
            direction: cond_list[i].direction,
            target: target, 
            target_path: target_path,
            nts: nt_coords,
            nt_path: _.map(nt_coords, function(x){
                var y='stimuli/bedroom5_ver4/'+('000000'+cell_coord.indexOf(x)).slice(-6)+'.webp';
                return y;})
        })
    }

    // ***** 2-D feature ***** //
    var twoDim_ftr = [];
    for(i=0; i<cond_list.length; i++){
        // target_coord
        if(cond_list[i].target_ox==0){
            var target = [];
            var target_path = [];
        }else{
            var target = target_coord;
            var target_path = 'stimuli/bedroom5_ver4/'+
            ('000000'+cell_coord.indexOf(target)).slice(-6)+'.webp';
        }
        // get foil coords
        var distance = Math.round(Math.sqrt(cond_list[i].dist*cond_list[i].dist/2));
        var nt1 = [distance*cond_list[i].direction, distance];     
        var nt2 = [distance*cond_list[i].direction, distance*-1];   
        var nt_coords = [];
        for(ss in _.range(Math.ceil(cond_list[i].set_size/2))){
            if(cond_list[i].dimension==-1){
                var nt1_coord = (nt1[0]+_.sample(jitter,1)[0])+'_'+(nt1[1]+_.sample(jitter,1)[0]);
                var nt2_coord = (nt2[0]+_.sample(jitter,1)[0])+'_'+(nt2[1]+_.sample(jitter,1)[0]);
            }else{
                var nt1_coord = (nt1[1]+_.sample(jitter,1)[0])+'_'+(nt1[0]+_.sample(jitter,1)[0]);
                var nt2_coord = (nt2[1]+_.sample(jitter,1)[0])+'_'+(nt2[0]+_.sample(jitter,1)[0]);
            }
            nt_coords.push(nt1_coord);
            nt_coords.push(nt2_coord);
        }
        nt_coords= nt_coords.slice(0,cond_list[i].set_size-cond_list[i].target_ox);
        
        twoDim_ftr.push({
            type:'twoDim-feature',
            set_size: cond_list[i].set_size,
            target_ox: cond_list[i].target_ox,
            dimension: cond_list[i].dimension,
            direction: cond_list[i].direction,
            target: target, 
            target_path: target_path,
            nts: nt_coords,
            nt_path: _.map(nt_coords, function(x){
                var y='stimuli/bedroom5_ver4/'+('000000'+cell_coord.indexOf(x)).slice(-6)+'.webp';
                return y;})
        })
    }

    // ***** 2-D conjunction ***** //
    var twoDim_cnj = [];
    for(i=0; i<cond_list.length; i++){
        // target_coord
        if(cond_list[i].target_ox==0){
            var target = [];
            var target_path = [];
        }else{
            var target = target_coord;
            var target_path = 'stimuli/bedroom5_ver4/'+
            ('000000'+cell_coord.indexOf(target)).slice(-6)+'.webp';
        }
        // get foil coords
        var distance = cond_list[i].dist;
        if(cond_list[i].dimension==1){
            nt1 = [distance*cond_list[i].direction, 0]
            nt2 = [0, distance*cond_list[i].direction*-1]
        }else{
            nt1 = [distance*cond_list[i].direction, 0]
            nt2 = [0, distance*cond_list[i].direction]
        }          
        var nt_coords = [];
        for(ss in _.range(Math.ceil(cond_list[i].set_size/2))){
            nt1_coord = (nt1[0]+_.sample(jitter,1)[0])+'_'+(nt1[1]+_.sample(jitter,1)[0])
            nt2_coord = (nt2[0]+_.sample(jitter,1)[0])+'_'+(nt2[1]+_.sample(jitter,1)[0])            
            nt_coords.push(nt1_coord);
            nt_coords.push(nt2_coord);
        }
        nt_coords= nt_coords.slice(0,cond_list[i].set_size-cond_list[i].target_ox);
        
        twoDim_cnj.push({
            type:'twoDim-conjunction',
            set_size: cond_list[i].set_size,
            target_ox: cond_list[i].target_ox,
            dimension: cond_list[i].dimension,
            direction: cond_list[i].direction,
            target: target, 
            target_path: target_path,
            nts: nt_coords,
            nt_path: _.map(nt_coords, function(x){
                var y='stimuli/bedroom5_ver4/'+('000000'+cell_coord.indexOf(x)).slice(-6)+'.webp';
                return y;})
        })
    }

    // ***** 2-D diagonal ***** //
    var twoDim_dgn = [];
    for(i=0; i<cond_list.length; i++){
        // target_coord
        if(cond_list[i].target_ox==0){
            var target = [];
            var target_path = [];
        }else{
            var target = target_coord;
            var target_path = 'stimuli/bedroom5_ver4/'+
            ('000000'+cell_coord.indexOf(target)).slice(-6)+'.webp';
        }
        // get foil coords
        var distance = Math.round(Math.sqrt(cond_list[i].dist*cond_list[i].dist/2));
        var nt1=distance*cond_list[i].direction;
        var nt2=distance*cond_list[i].direction*-1;                
        var nt_coords = [];
        for(ss in _.range(Math.ceil(cond_list[i].set_size/2))){
            if(cond_list[i].dimension==1){
                nt1_coord = (nt1+_.sample(jitter,1)[0])+'_'+(nt1+_.sample(jitter,1)[0]);
                nt2_coord = (nt2+_.sample(jitter,1)[0])+'_'+(nt2+_.sample(jitter,1)[0]);
            }else{
                nt1_coord = (nt1+_.sample(jitter,1)[0])+'_'+(nt1*-1+_.sample(jitter,1)[0]);
                nt2_coord = (nt2+_.sample(jitter,1)[0])+'_'+(nt2*-1+_.sample(jitter,1)[0]);
            }                    
            nt_coords.push(nt1_coord);
            nt_coords.push(nt2_coord);
        }
        nt_coords= nt_coords.slice(0,cond_list[i].set_size-cond_list[i].target_ox);
        
        twoDim_dgn.push({
            type:'twoDim-diagnoal',
            set_size: cond_list[i].set_size,
            target_ox: cond_list[i].target_ox,
            dimension: cond_list[i].dimension,
            direction: cond_list[i].direction,
            target: target, 
            target_path: target_path,
            nts: nt_coords,
            nt_path: _.map(nt_coords, function(x){
                var y='stimuli/bedroom5_ver4/'+('000000'+cell_coord.indexOf(x)).slice(-6)+'.webp';
                return y;})
        })
    }

    // merge all
    var exp_cond = [];
    exp_cond.push(oneDim_ftr)
    exp_cond.push(twoDim_ftr)
    exp_cond.push(twoDim_cnj)
    exp_cond.push(twoDim_dgn)
    exp_cond = _.flatten(exp_cond)

    exp_cond = _.shuffle(exp_cond);
    var b_len = exp_cond.length/n_block;
    var condition = [];
    for(b=0; b<n_block; b++){
        condition.push(exp_cond.slice(b_len*b, b_len*(b+1)));
    };

    return condition;
}