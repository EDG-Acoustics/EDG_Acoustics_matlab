This folder contains the developements/MATLAB codes programmed by Dr. Huiqing Wang during his PhD study at Building Acoustics group of Department of the Built Environment, Eindhoven University of Technology.  All the derivations and mathematical details can be found in Huiqing's PhD thesis (https://research.tue.nl/nl/publications/room-acoustic-modeling-with-the-time-domain-discontinuous-galerki).
 The codes are supposed to serve for education and research purposes. In case there is any question, please contact Huiqing Wang (h.wang6@tue.nl) or Prof. Maarten Hornikx (m.c.j.hornikx@tue.nl).

The main code is mainEAS.m, which performs a 3D room acoustic time-domain simulation of a real open plan office. The first few lines are related with parameter setting (with explanatory comments). As commented in the code, the main computational cost come from lines 116-120, which essentially involves matrix multiplication, so there is a great potential of acceleration by using advance parallel computing techiniques.

Folder DG_source contains the necessary source codes from Huiqing and other open-source codes made by Jan Hesthaven et.al (accessible from https://github.com/tcew/nodal-dg).This folder should be added to the MATLAB path (it has been done automatically in mainEAS.m)

