% evaluate upwind flux
        cn1s=-c0*nx.^2/2; cn2s=-c0*ny.^2/2;
        cn1n2=-c0*nx.*ny/2;
        n1rho=nx/(2*rho0); n2rho=ny/(2*rho0);
        csn1rho=c0^2*rho0/2*nx;csn2rho=c0^2*rho0/2*ny;