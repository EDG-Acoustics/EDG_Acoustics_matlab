function plot_mesh3DLTS(p,etov,expr,k_fine,bcol,icol,ifcol)

%   Copyright (C) Huiqing Wang h.wang6@tue.nl

  if nargin<5 | isempty(bcol), bcol=[1 0.9 0]; end
  if nargin<6 | isempty(icol), icol=[0 1 1]; end
  if nargin<7 | isempty(ifcol), ifcol=[0.9010, 0.0, 0.9330]; end
  
    tri_b=surftri(p,etov); %% find EToV of original boundary elements (triangles)
    etov_f=etov(k_fine,:);
      incl=find(eval(expr)); %% find all vertices satisfy the expr
      etov=etov(any(ismember(etov,incl),2),:);  %% find all elements (including volume elements and intersection elements)satisfy the expr
      tri_b=tri_b(any(ismember(tri_b,incl),2),:);%% find EToV of original boundary elements (triangles) satisfy the expr
      tri_inter=surftri(p,etov); %% find EToV of current boundary elements (triangles) (including original and intersection boundary faces)
      tri_inter=setdiff(tri_inter,tri_b,'rows');  % returns the data in tri_inter that is not in tri_b,
      figure
      h=trimesh(tri_inter,p(:,1),p(:,2),p(:,3));
      set(h,'facecolor',icol,'edgecolor','k');
      hold on
      etov_f=etov_f(any(ismember(etov_f,incl),2),:);
      tri_inter_f=surftri(p,etov_f); 
      tri_inter_f=tri_inter_f(ismember(tri_inter_f,tri_inter,'rows'),:);  % returns the data in tri_inter that is not in tri_b,
      h=trimesh(tri_inter_f,p(:,1),p(:,2),p(:,3));
      set(h,'facecolor',ifcol,'edgecolor','k');
      
  h=trimesh(tri_b,p(:,1),p(:,2),p(:,3));
  hold off
  set(h,'facecolor',bcol,'edgecolor','k');
  axis equal
%   cameramenu

