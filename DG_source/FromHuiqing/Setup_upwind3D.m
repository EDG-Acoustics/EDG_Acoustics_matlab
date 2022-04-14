
% Purpose: evaluate upwind flux
%
% By Huiqing Wang.  h.wang6@tue.nl
        cn1s=-c0*nx.^2/2; cn2s=-c0*ny.^2/2;  cn3s=-c0*nz.^2/2;
        cn1n2=-c0*nx.*ny/2; cn1n3=-c0*nx.*nz/2; cn2n3=-c0*ny.*nz/2;
        n1rho=nx/(2*rho0); n2rho=ny/(2*rho0); n3rho=nz/(2*rho0);
        csn1rho=c0^2*rho0/2*nx; csn2rho=c0^2*rho0/2*ny; csn3rho=c0^2*rho0/2*nz;