function simpplot(p,t,expr,bcol,icol,nodes,tris)

%   Copyright (C) 2004-2012 Per-Olof Persson. See COPYRIGHT.TXT for details.
figure
dim=size(p,2);
switch dim
 case 2
  if nargin<4 | isempty(bcol), bcol=[1 0.9 0]; end %bcol=[1 0.9 0]  [.8,.9,1]
  if nargin<5 | isempty(icol), icol=[0,0,0]; end
  if nargin<6, nodes=0; end
  if nargin<7, tris=0; end
  
  trimesh(t,p(:,1),p(:,2),0*p(:,1),'facecolor',bcol,'edgecolor','k');
  if nodes==1
    line(p(:,1),p(:,2),'linest','none','marker','.','col',icol,'markers',24);
  elseif nodes==2
    for ip=1:size(p,1)
      txtpars={'fontname','times','fontsize',12};
      text(p(ip,1),p(ip,2),num2str(ip),txtpars{:});
    end
  end
  if tris==2
    for it=1:size(t,1)
      pmid=mean(p(t(it,:),:),1);
      txtpars={'fontname','times','fontsize',12,'horizontala','center'};
      text(pmid(1),pmid(2),num2str(it),txtpars{:});
    end
  end
  view(2)
  axis equal
  axis off
  ax=axis;axis(ax*1.001);
 case 3
  if nargin<4 | isempty(bcol), bcol=[1 0.9 0]; end  %[1 0.9 0]  [.3,.9,1]
  if nargin<5 | isempty(icol), icol=[.7,.6,0.8]; end
  
  if size(t,2)==4
    tri1=surftri(p,t); %% find EToV of original boundary elements (triangles)
    if nargin>2 & ~isempty(expr)
      incl=find(eval(expr)); %% find all vertices satisfy the expr
      t=t(any(ismember(t,incl),2),:);  %% find all elements (including volume elements and intersection elements)satisfy the expr
      tri1=tri1(any(ismember(tri1,incl),2),:);%% find EToV of original boundary elements (triangles) satisfy the expr
      tri2=surftri(p,t); %% find EToV of current boundary elements (triangles) (including original and intersection boundary faces)
      tri2=setdiff(tri2,tri1,'rows');  % returns the data in tri2 that is not in tri1,
      h=trimesh(tri2,p(:,1),p(:,2),p(:,3));
      set(h,'facecolor',icol,'edgecolor','k');
      hold on
    end
  else
    tri1=t;
    if nargin>2 & ~isempty(expr)
      incl=find(eval(expr));
      tri1=tri1(any(ismember(tri1,incl),2),:);
    end
  end
  h=trimesh(tri1,p(:,1),p(:,2),p(:,3));
  hold off
  set(h,'facecolor',bcol,'edgecolor','k');
  axis equal
%   cameramenu
 otherwise
  error('Unimplemented dimension.');
end
