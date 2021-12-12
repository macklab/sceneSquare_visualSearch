
img_idx <- seq(0,624)
img_coord <- t(outer(seq(-12,12), seq(-12,12), function(x,y){paste(x,'_',y, sep="")}))
img_coord_list <- matrix(outer(seq(-12,12), seq(-12,12), function(x,y){paste(x,'_',y, sep="")}))


## 1-dimension ---------------------------------------------------------------
distance <- c(17)
set_size <- c(3,4,6,8)
target_ox <- c(0,1) # 0=target absent, 1=target present
dimension <- c(-1,1) 
direction <- c(-1,1)
target_coord <- '0_0'

## 1. homogeneous distractors
cond_1d_single <- c()
for(dist in distance){
  for(dir in direction){ 
    # get singleton non-target coord
    nt1 <- dist*dir
    for(dim in dimension){ # dim=1: +45deg, dim=-1: -45deg
      if(dim==-1){
        nt_coord = paste(nt1,'_',nt1, sep='')
      }else{
        nt_coord = paste(nt1,'_',nt1*-1, sep='')
      }
      # repeat it based on set size 
      for(s in set_size){
        for(ox in target_ox){
          t_nts <- rep(nt_coord, s-ox)
          if(ox==1){ # target present
            t_nts <- c(target_coord, t_nts)
          }
          # get img index
          img_number <- lapply(1:length(t_nts), 
                               function(n){which(img_coord_list==t_nts[n])})
          # formatting into webp
          img_number <- lapply(unlist(img_number), 
                              function(n){paste(sprintf("%06d",n), '.webp', sep='')})
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

# 2. transition distractors
cond_1d_trans <- c()
for(dist in distance){
  for(dir in direction){
    # get transient non-target coords
    nts <- unlist(lapply(1:max(set_size), function(i){(dist+i-1)*dir}))
    nts <- nts[abs(nts) <13]
    for(dim in dimension){
      if(dim==1){
        nt_coord = unlist(lapply(nts, function(i){paste(i,'_','0', sep='')}))
      }else{
        nt_coord = unlist(lapply(nts, function(i){paste('0','_',i, sep='')}))
      }
      # repeat it based on set size 
      for(s in set_size){
        if(length(nt_coord)<s){
          nt_coord <- rep(nt_coord, 3)
        }
        for(ox in target_ox){
          t_nts <- nt_coord[1:s]
          if(ox==1){ # target present
            t_nts <- c(target_coord, t_nts[1:s-1])
          }
          # get img index
          img_number <- lapply(1:length(t_nts), 
                               function(n){which(img_coord_list==t_nts[n])})
          # formatting into jpg
          img_number <- lapply(unlist(img_number), 
                               function(n){paste(sprintf("%06d",n), '.jpg', sep='')})
          ## add NAs
          if(length(t_nts) < max(set_size)){
            t_nts <- c(t_nts, rep(NA, max(set_size) - length(t_nts)))
            img_number <- c(img_number, rep(NA, max(set_size) - length(img_number)))
          }
          cond_1d_trans <-rbind(cond_1d_trans,
                                c(dist,dir,dim,s,ox,t_nts,unlist(img_number)))
        }
      }
    }
  }
}

colnames(cond_1d_trans) <- 
  c('distance', 'direction', 'dimension', 'set_size', 'target_ox', 
    'stim1', 'stim2', 'stim3', 'stim4','stim5','stim6','stim7',
    'i_idx1','i_idx2','i_idx3','i_idx4','i_idx5','i_idx6','i_idx7')

# 2-dimension ------------------------------------------------------------------

# 3. feature search
cond_2d_feature <-c()
for(dist in distance){
  dist2 <- round(sqrt(dist*dist/2))
  for(dir in direction){
    # get two non-target coord
    nt1 <- c(dist2*dir,dist2)
    nt2 <- c(dist2*dir,dist2*-1)
    for(dim in dimension){
      if(dim==1){
        nt1_coord = paste(nt1[1],'_',nt1[2], sep='')
        nt2_coord = paste(nt2[1],'_',nt2[2], sep='')
      }else{
        nt1_coord = paste(nt1[2],'_',nt1[1], sep='')
        nt2_coord = paste(nt2[2],'_',nt2[1], sep='')
      }
      nts <- c(nt1_coord, nt2_coord)
      # repeat it based on set size 
      for(s in set_size){
        nts <- rep(sample(nts), ceiling(s/length(nts)))
        for(ox in target_ox){
          t_nts <- nts[1:s]
          if(ox==1){ # target present
            t_nts <- c(target_coord, nts[1:(s-1)])
          }
          # get img index
          img_number <- lapply(1:length(t_nts), 
                               function(n){which(img_coord_list==t_nts[n])})
          # formatting into jpg
          img_number <- lapply(unlist(img_number), 
                               function(n){paste(sprintf("%06d",n), '.jpg', sep='')})
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
    'stim1', 'stim2', 'stim3', 'stim4','stim5','stim6','stim7',
    'i_idx1','i_idx2','i_idx3','i_idx4','i_idx5','i_idx6','i_idx7')


# 4. conjunction search
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
      nt1_coord = paste(nt1[1],'_',nt1[2], sep='')
      nt2_coord = paste(nt2[1],'_',nt2[2], sep='')
      nts <- c(nt1_coord, nt2_coord)
      # repeat it based on set size 
      for(s in set_size){
        nts <- rep(sample(nts), ceiling(s/length(nts)))
        for(ox in target_ox){
          t_nts <- nts[1:s]
          if(ox==1){ # target present
            t_nts <- c(target_coord, nts[1:(s-1)])
          }
          # get img index
          img_number <- lapply(1:length(t_nts), 
                               function(n){which(img_coord_list==t_nts[n])})
          # formatting into jpg
          img_number <- lapply(unlist(img_number), 
                               function(n){paste(sprintf("%06d",n), '.jpg', sep='')})
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
    'stim1', 'stim2', 'stim3', 'stim4','stim5','stim6','stim7',
    'i_idx1','i_idx2','i_idx3','i_idx4','i_idx5','i_idx6','i_idx7')

# 2-d diagonal --------------------------------------------------------------------

# 5. outer target (singleton)
cond_2d_outtarg <-c()
for(dist in distance){
  dist2 <- round(sqrt(dist*dist/2))
  for(dir in direction){ # making no differnece now
    for(dim in dimension){
      if(dim==1){
        nt1 <- c(dist2*dir, dist2*dir*-1)
        nt2 <- c(dist2*dir*-1, dist2*dir)
      }else{
        nt1 <- c(dist2*dir, dist2*dir)
        nt2 <- c(dist2*dir*-1, dist2*dir*-1)
      }
      nt1_coord = paste(nt1[1],'_',nt1[2], sep='')
      nt2_coord = paste(nt2[1],'_',nt2[2], sep='')
      nts <- c(nt1_coord, nt2_coord)
      # repeat it based on set size 
      for(s in set_size){
        nts <- rep(sample(nts), ceiling(s/length(nts)))
        for(ox in target_ox){
          t_nts <- nts[1:s]
          if(ox==1){ # target present
            t_nts <- c(target_coord, nts[1:(s-1)])
          }
          # get img index
          img_number <- lapply(1:length(t_nts), 
                               function(n){which(img_coord_list==t_nts[n])})
          # formatting into jpg
          img_number <- lapply(unlist(img_number), 
                               function(n){paste(sprintf("%06d",n), '.jpg', sep='')})
          ## add NAs
          if(length(t_nts) < max(set_size)){
            t_nts <- c(t_nts, rep(NA, max(set_size) - length(t_nts)))
            img_number <- c(img_number, rep(NA, max(set_size) - length(img_number)))
          }
          cond_2d_outtarg <-rbind(cond_2d_outtarg, 
                                   c(dist,dir,dim,s,ox,t_nts, unlist(img_number)))
        }
      }
    }
  }
}
colnames(cond_2d_outtarg) <- 
  c('distance', 'direction', 'dimension', 'set_size', 'target_ox', 
    'stim1', 'stim2', 'stim3', 'stim4','stim5','stim6','stim7',
    'i_idx1','i_idx2','i_idx3','i_idx4','i_idx5','i_idx6','i_idx7')

# 6. middle target
cond_2d_midtarg <-c()
for(dist in distance){
  dist2 <- round(sqrt(dist*dist/2))
  for(dir in direction){
    # get transient non-target coords
    nts <- unlist(lapply(1:max(set_size), function(i){(dist2+i-1)*dir}))
    nts <- nts[abs(nts) <13]
    for(dim in dimension){
      if(dim==1){
        nt_coord = unlist(lapply(nts, function(i){paste(i,'_', i*-1, sep='')}))
      }else{
        nt_coord = unlist(lapply(nts, function(i){paste(i,'_',i, sep='')}))
      }
      # repeat it based on set size 
      for(s in set_size){
        if(length(nt_coord)<s){
          nt_coord <- rep(nt_coord, 3)
        }
        for(ox in target_ox){
          t_nts <- nt_coord[1:s]
          if(ox==1){ # target present
            t_nts <- c(target_coord, nt_coord[1:(s-1)])
          }
          # get img index
          img_number <- lapply(1:length(t_nts), 
                               function(n){which(img_coord_list==t_nts[n])})
          # formatting into jpg
          img_number <- lapply(unlist(img_number), 
                               function(n){paste(sprintf("%06d",n), '.jpg', sep='')})
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
    'stim1', 'stim2', 'stim3', 'stim4','stim5','stim6','stim7',
    'i_idx1','i_idx2','i_idx3','i_idx4','i_idx5','i_idx6','i_idx7')

# Merge all--------------------------------------------------------------------------
condition <- rbind(
  cbind('1d_single', cond_1d_single),
  cbind('1d_tansient', cond_1d_trans),
  cbind('2d_feature', cond_2d_feature),
  cbind('2d_conjunction', cond_2d_conjunction),
  cbind('2d_outer_target', cond_2d_outtarg),
  cbind('2d_mid_target', cond_2d_midtarg)
)
colnames(condition)[1] <- "type" 
condition <- as.data.frame(condition)

write_csv(condition, '~/Documents/GitHub/sceneSquare_visualSearch/pilot_condition.csv')
