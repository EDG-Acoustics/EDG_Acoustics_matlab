function meshdemo_3d_03 ( iteration_max )

%*****************************************************************************80
%
%% MESHDEMO_3D_03 runs 3D sample problem #3.
%
%  Modified:
%
%    19 September 2005
%
%  Author:
%
%    John Burkardt
%
%  Reference:
%
%    Per-Olof Persson and Gilbert Strang,
%    A Simple Mesh Generator in MATLAB,
%    SIAM Review,
%    Volume 46, Number 2, June 2004, pages 329-345.
%
%  Parameters:
%
%    Input, integer ITERATION_MAX, the maximum number of iterations that DISTMESH
%    should take.  (The program might take fewer iterations if it detects convergence.)
%
  timestamp ( );
  fprintf ( 1, '\n' );
  fprintf ( 1, 'MESHDEMO_3D_03\n' );
  fprintf ( 1, '  3D example 03: the unit cube.\n' );
%
%  Put the random number generator into a fixed initial state.
%
  rand ( 'state', 111 );
%
%  Set the rendering method for the current figure to OpenGL.
%
  set ( gcf, 'rend', 'z' );

  iteration_max=100;
  h = 0.5;
  
  box = [ 
      0.0, 0.0, 0.0;
      1.0, 1.0, 1.0 ];
  
% iteration_max = 200;

  pfix = [
      0.0, 0.0, 0.0;
      0.0, 0.0, 1.0;
      0.0, 1.0, 0.0;
      0.0, 1.0, 1.0;
      1.0, 0.0, 0.0;
      1.0, 0.0, 1.0;
      1.0, 1.0, 0.0;
      1.0, 1.0, 1.0 ];

  [ p, t ] = distmesh_3d ( @fd03, @huniform, h, box, iteration_max, pfix );
  
  VX = p(:,1)';
VY = p(:,2)';
Nv = p(:,3)';
K = size(t,1);
EToV=t;

  post_3d ( p, t )
  [ node_num, junk ] = size ( p );
  [ tetra_num, junk ] = size ( t );
%
%  Write a text file containing the nodes.
%
  r8mat_write ( 'p03_nodes.txt', 3, node_num, p' );
%
%  Write a text file containing the tetrahedrons.
%
  i4mat_write ( 'p03_elements.txt', 4, tetra_num, t' );

  fprintf ( 1, '\n' );
  fprintf ( 1, 'MESHDEMO_3D_03\n' );
  fprintf ( 1, '  Normal end of execution.\n' );

  fprintf ( 1, '\n' );
  timestamp ( );

  return
end
