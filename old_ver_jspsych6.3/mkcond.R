
img_idx <- seq(0,624)
img_coord <- t(outer(seq(-12,12), seq(-12,12), function(x,y){paste(x,'_',y, sep="")}))
img_coord_list <- matrix(outer(seq(-12,12), seq(-12,12), function(x,y){paste(x,'_',y, sep="")}))


## 1-dimension ---------------------------------------------------------------
distance <- c(11)
set_size <- c(3,4,6,8)
target_ox <- c(0,1) # 0=target absent, 1=target present
dimension <- c(-1,1) 
direction <- c(-1,1)
target_coord <- '0_0'
jitter <-seq(-1,1,1)

## 1. homogeneous distractors
cond_1d_single <- c()
for(dist in distance){
  for(dir in direction){ 
    # get reference non-target dist
    nt1 <- round(sqrt(dist*dist/2))*dir
    for(dim in dimension){ # dim=1: +45deg, dim=-1: -45deg
      for(s in set_size){
        # get jittered distractors
        nt_coords=c()
        for(ss in seq(1,s)){
          if(dim==-1){
            nt = paste(nt1+sample(jitter,1),'_',nt1+sample(jitter,1), sep='')
          }else{
            nt = paste(nt1+sample(jitter,1),'_',nt1*-1+sample(jitter,1), sep='')
          }
          nt_coords=cbind(nt_coords,nt)
        }
        # add target for target present trials
        for(ox in target_ox){
          t_nts <- nt_coords
          if(ox==1){ # target present
            t_nts <- c(target_coord, t_nts[1:s-1])
          }
          # get img index
          img_number <- lapply(1:length(t_nts), 
                               function(n){which(img_coord_list==t_nts[n])})
          # formatting into webp
          img_number <- lapply(unlist(img_number), 
                              function(n){paste('stimuli/bedroom5_ver4/',
                                                sprintf("%06d",n), '.webp', sep='')})
          ## add NAs
          if(length(t_nts) < max(set_size)){
            t_nts <- c(t_nts, rep(NA, max(set_size) - length(t_nts)))
            img_number <- c(img_number, rep(NA, max(set_size) - length(img_number)))
          }
          cond_1d_single <-rbind(cond_1d_single, 
                                 c(dist,dir,dim,s,ox,t_nts,unlist(img_number)))
        }
      }
    }
  }
}

colnames(cond_1d_single) <- 
  c('distance', 'direction', 'dimension', 'set_size', 'target_ox', 
   'stim1', 'stim2', 'stim3', 'stim4','stim5','stim6','stim7','stim8',
   'i_idx1','i_idx2','i_idx3','i_idx4','i_idx5','i_idx6','i_idx7','i_idx7')

# 2-dimension ------------------------------------------------------------------

# 1. feature search
cond_2d_feature <-c()
for(dist in distance){
  dist2 <- round(sqrt(dist*dist/2))
  for(dir in direction){ #dir=1: 
    # get two non-target coord
    nt1 <- c(dist2*dir,dist2)
    nt2 <- c(dist2*dir,dist2*-1)
    for(dim in dimension){
      for(s in set_size){
        nt_coords<-c()
        for(ss in seq(1,ceiling(s/2))){
          if(dim==1){
            nt1_coord = paste(nt1[1]+sample(jitter,1),'_',nt1[2]+sample(jitter,1), sep='')
            nt2_coord = paste(nt2[1]+sample(jitter,1),'_',nt2[2]+sample(jitter,1), sep='')
          }else{
            nt1_coord = paste(nt1[2]+sample(jitter,1),'_',nt1[1]+sample(jitter,1), sep='')
            nt2_coord = paste(nt2[2]+sample(jitter,1),'_',nt2[1]+sample(jitter,1), sep='')
          }
          nt_coords=cbind(nt_coords,nt1_coord,nt2_coord)
        }
        # add target
        for(ox in target_ox){
          t_nts <- nt_coords[1:s]
          if(ox==1){ # target present
            t_nts <- c(target_coord, nt_coords[1:(s-1)])
          }
          # get img index
          img_number <- lapply(1:length(t_nts), 
                               function(n){which(img_coord_list==t_nts[n])})
          # formatting into webp
          img_number <- lapply(unlist(img_number), 
                               function(n){paste('stimuli/bedroom5_ver4/',
                                                 sprintf("%06d",n), '.webp', sep='')})
          ## add NAs
          if(length(t_nts) < max(set_size)){
            t_nts <- c(t_nts, rep(NA, max(set_size) - length(t_nts)))
            img_number <- c(img_number, rep(NA, max(set_size) - length(img_number)))
          }
          cond_2d_feature <-rbind(cond_2d_feature, c(dist,dir,dim,s,ox,t_nts, unlist(img_number)))
        }
      }
    }
  }
}
colnames(cond_2d_feature) <- 
  c('distance', 'direction', 'dimension', 'set_size', 'target_ox', 
    'stim1', 'stim2', 'stim3', 'stim4','stim5','stim6','stim7','stim8',
    'i_idx1','i_idx2','i_idx3','i_idx4','i_idx5','i_idx6','i_idx7','i_idx8')


# 2. conjunction search
cond_2d_conjunction <-c()
for(dist in distance){
  for(dir in direction){
    for(dim in dimension){
      if(dim==1){
        nt1 <- c(dist*dir,0)
        nt2 <- c(0, dist*dir*-1)
      }else{
        nt1 <- c(dist*dir,0)
        nt2 <- c(0,dist*dir)
      }
      for(s in set_size){
        nt_coords<-c()
        for(ss in seq(1,ceiling(s/2))){
          nt1_coord = paste(nt1[1]+sample(jitter,1),'_',nt1[2]+sample(jitter,1), sep='')
          nt2_coord = paste(nt2[1]+sample(jitter,1),'_',nt2[2]+sample(jitter,1), sep='')
          nt_coords <- cbind(nt_coords,nt1_coord,nt2_coord)
        }
        # add target
        for(ox in target_ox){
          t_nts <- nt_coords[1:s]
          if(ox==1){ # target present
            t_nts <- c(target_coord, nt_coords[1:(s-1)])
          }
          # get img index
          img_number <- lapply(1:length(t_nts), 
                               function(n){which(img_coord_list==t_nts[n])})
          # formatting into webp
          img_number <- lapply(unlist(img_number), 
                               function(n){paste('stimuli/bedroom5_ver4/',
                                                 sprintf("%06d",n), '.webp', sep='')})
          ## add NAs
          if(length(t_nts) < max(set_size)){
            t_nts <- c(t_nts, rep(NA, max(set_size) - length(t_nts)))
            img_number <- c(img_number, rep(NA, max(set_size) - length(img_number)))
          }
          cond_2d_conjunction <-rbind(cond_2d_conjunction, 
                                      c(dist,dir,dim,s,ox,t_nts, unlist(img_number)))
        }
      }
    }
  }
}
colnames(cond_2d_conjunction) <- 
  c('distance', 'direction', 'dimension', 'set_size', 'target_ox', 
    'stim1', 'stim2', 'stim3', 'stim4','stim5','stim6','stim7','stim8',
    'i_idx1','i_idx2','i_idx3','i_idx4','i_idx5','i_idx6','i_idx7','i_idx8')

# 2-d diagonal --------------------------------------------------------------------

# 4. middle target
cond_2d_midtarg <-c()
for(dist in distance){
  dist2 <- round(sqrt(dist*dist/2))
  for(dir in direction){
    nt1=dist2*dir
    nt2=dist2*dir*-1
    for(dim in dimension){
      for(s in set_size){
        nt_coords=c()
        for(ss in seq(1,ceiling(s/2))){
          if(dim==1){
            nt1_coord = paste(nt1+sample(jitter,1),'_',nt1+sample(jitter,1),sep="")
            nt2_coord = paste(nt2+sample(jitter,1),'_',nt2+sample(jitter,1),sep="")
          }else{
            nt1_coord = paste(nt1+sample(jitter,1),'_',nt1*-1+sample(jitter,1),sep="")
            nt2_coord = paste(nt2+sample(jitter,1),'_',nt2*-1+sample(jitter,1),sep="")
          }
          nt_coords=cbind(nt_coords,nt1_coord,nt2_coord)
        }
        # target
        for(ox in target_ox){
          t_nts <- nt_coords[1:s]
          if(ox==1){ # target present
            t_nts <- c(target_coord, nt_coords[1:(s-1)])
          }
          # get img index
          img_number <- lapply(1:length(t_nts), 
                               function(n){which(img_coord_list==t_nts[n])})
          # formatting into webp
          img_number <- lapply(unlist(img_number), 
                               function(n){paste('stimuli/bedroom5_ver4/',
                                                 sprintf("%06d",n), '.webp', sep='')})
          # add NAs
          if(length(t_nts) < max(set_size)){
            t_nts <- c(t_nts, rep(NA, max(set_size) - length(t_nts)))
            img_number <- c(img_number, rep(NA, max(set_size) - length(img_number)))
          }
          cond_2d_midtarg <-rbind(cond_2d_midtarg,
                                  c(dist,dir,dim,s,ox,t_nts,unlist(img_number)))
        }
      }
    }
  }
}
colnames(cond_2d_midtarg) <- 
  c('distance', 'direction', 'dimension', 'set_size', 'target_ox', 
    'stim1', 'stim2', 'stim3', 'stim4','stim5','stim6','stim7','stim8',
    'i_idx1','i_idx2','i_idx3','i_idx4','i_idx5','i_idx6','i_idx7','i_idx8')

# Merge all--------------------------------------------------------------------------
condition <- rbind(
  cbind('1d_single', cond_1d_single),
  cbind('2d_feature', cond_2d_feature),
  cbind('2d_conjunction', cond_2d_conjunction),
  cbind('2d_mid_target', cond_2d_midtarg)
)
colnames(condition)[1] <- "type" 
condition <- as.data.frame(condition) 


