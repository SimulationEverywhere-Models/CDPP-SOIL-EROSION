%please look at the explanation before reading the ma fail it will clarify a lot of things

%throughout this .ma file you will find that there are checks that neighbouring cells are not undefined
%every time this check is made its purpose is to ensure that the neighbouring cell which is being checked
%is not delegated to receive any soil or water as no soil or water should be transferred outside the box of
%earth being modeled it may seem that the check for undefined is redundant

[top]
components : Erosion 
generator@Generator

link : out@generator rainInput@Erosion

[Erosion]
in : rainInput

%fourth dimension=0 means water
link : rainInput in@Erosion(0,0,0,0)
link : rainInput in@Erosion(0,3,0,0)
link : rainInput in@Erosion(0,6,0,0)
link : rainInput in@Erosion(0,9,0,0)
link : rainInput in@Erosion(3,0,0,0)
link : rainInput in@Erosion(3,3,0,0)
link : rainInput in@Erosion(3,6,0,0)
link : rainInput in@Erosion(3,9,0,0)
link : rainInput in@Erosion(6,0,0,0)
link : rainInput in@Erosion(6,3,0,0)
link : rainInput in@Erosion(6,6,0,0)
link : rainInput in@Erosion(6,9,0,0)
link : rainInput in@Erosion(6,0,0,0)
link : rainInput in@Erosion(9,0,0,0)
link : rainInput in@Erosion(9,3,0,0)
link : rainInput in@Erosion(9,6,0,0)
link : rainInput in@Erosion(9,9,0,0)

portInTransition : in@Erosion(0,0,0,0) setRain
portInTransition : in@Erosion(0,3,0,0) setRain
portInTransition : in@Erosion(0,6,0,0) setRain
portInTransition : in@Erosion(0,9,0,0) setRain
portInTransition : in@Erosion(3,0,0,0) setRain
portInTransition : in@Erosion(3,3,0,0) setRain
portInTransition : in@Erosion(3,6,0,0) setRain
portInTransition : in@Erosion(3,9,0,0) setRain
portInTransition : in@Erosion(6,0,0,0) setRain
portInTransition : in@Erosion(6,3,0,0) setRain
portInTransition : in@Erosion(6,6,0,0) setRain
portInTransition : in@Erosion(6,9,0,0) setRain
portInTransition : in@Erosion(6,0,0,0) setRain
portInTransition : in@Erosion(9,0,0,0) setRain
portInTransition : in@Erosion(9,3,0,0) setRain
portInTransition : in@Erosion(9,6,0,0) setRain
portInTransition : in@Erosion(9,9,0,0) setRain

type : cell
dim : (10,10,5,2)
delay : inertial
defaultDelayTime : 10
border : nowrapped

%This is for water cells
neighbors :                   Erosion(-1,0,0,0)
neighbors : Erosion(0,-1,0,0) Erosion(0,0,0,0) Erosion(0,1,0,0)
neighbors :                   Erosion(1,0,0,0)
neighbors :                   Erosion(0,0,1,0) Erosion(0,0,-1,0)

%water cell must be able to see it's own soil equivalent
neighbors : Erosion(0,0,0,1)

%soil cell must be able to see their water world equivalent and
%soil cells must be able to see any cells in the
%water world that might be giving water to their water world equivalent
neighbors : Erosion(0,-1,0,-1) Erosion(0,0,0,-1) Erosion(0,1,0,-1)
neighbors :                    Erosion(1,0,0,-1) Erosion(-1,0,0,-1)
neighbors :                    Erosion(0,0,-1,-1)

initialValue : 0
%erosion.val initializes all water cells to 0 and all soil cells to 10
initialCellsValue : erosion.val

localtransition : waterMove

%this is the soil zone
zone : soil { (0,0,0,1)..(9,9,4,1) }

[waterMove]
%if someone is sending me water translates to
% if my (-1,0,0,0) has as fractional value 0.1 OR
% if my (0,-1,0,0) has as fractional value 0.2 OR
% if my (1,0,0,0) has as fractional value 0.3 OR
% if my (0,1,0,0) has as fractional value 0.4 OR
% if my (0,0,-1,0) has as fractional value 0.5 OR

%if someone is sending me water and if I have no soil indicate that the reciever is beneath me
rule : {trunc((0,0,0,0))+0.5} 10 {(fractional((-1,0,0,0))=0.1 OR fractional((0,-1,0,0))=0.2 
		OR fractional((1,0,0,0))=0.3 OR fractional((0,1,0,0))=0.4 OR fractional((0,0,-1,0))=0.5) 
		AND (0,0,0,1)=0 AND (0,0,1,0)!=?}

%if someone is sending me water and my (0,0,1,0) should recieve
rule : {trunc((0,0,0,0))+0.5} 10 {(fractional((-1,0,0,0))=0.1 OR fractional((0,-1,0,0))=0.2 
		OR fractional((1,0,0,0))=0.3 OR fractional((0,1,0,0))=0.4 OR fractional((0,0,-1,0))=0.5) 
		AND ((0,0,0,0) - (0,0,1,0) >= 4) AND (0,0,1,0)!=?}

%if someone is sending me water and my (1,0,0,0) should recieve
rule : {trunc((0,0,0,0))+0.1} 10 {(fractional((-1,0,0,0))=0.1 OR fractional((0,-1,0,0))=0.2 
		OR fractional((1,0,0,0))=0.3 OR fractional((0,1,0,0))=0.4 OR fractional((0,0,-1,0))=0.5) 
		AND ((0,0,0,0) - (1,0,0,0) >= 4) AND (1,0,0,0)!=?}

%if someone is sending me water and my (0,1,0,0) should recieve
rule : {trunc((0,0,0,0))+0.2} 10 {(fractional((-1,0,0,0))=0.1 OR fractional((0,-1,0,0))=0.2 
		OR fractional((1,0,0,0))=0.3 OR fractional((0,1,0,0))=0.4 OR fractional((0,0,-1,0))=0.5) 
		AND ((0,0,0,0) - (0,1,0,0) >= 4) AND (0,1,0,0)!=?}

%if someone is sending me water and my (-1,0,0,0) should recieve
rule : {trunc((0,0,0,0))+0.3} 10 {(fractional((-1,0,0,0))=0.1 OR fractional((0,-1,0,0))=0.2 
		OR fractional((1,0,0,0))=0.3 OR fractional((0,1,0,0))=0.4 OR fractional((0,0,-1,0))=0.5) 
		AND ((0,0,0,0) - (-1,0,0,0) >= 4) AND (-1,0,0,0)!=?}

%if someone is sending me water and my (0,-1,0,0) should recieve
rule : {trunc((0,0,0,0))+0.4} 10 {(fractional((-1,0,0,0))=0.1 OR fractional((0,-1,0,0))=0.2 
		OR fractional((1,0,0,0))=0.3 OR fractional((0,1,0,0))=0.4 OR fractional((0,0,-1,0))=0.5) 
		AND ((0,0,0,0) - (0,-1,0,0) >= 4) AND (0,-1,0,0)!=?}

%if someone is sending me water and no one should receive then increment myself
rule : {trunc((0,0,0,0))+1} 10 {(fractional((-1,0,0,0))=0.1 OR fractional((0,-1,0,0))=0.2 
		OR fractional((1,0,0,0))=0.3 OR fractional((0,1,0,0))=0.4 OR fractional((0,0,-1,0))=0.5)}

%it is necessary to transfer water to those neighbors whose water decreased causing me to trigger
%and have sufficiently less water than me to justy my transferring water to them

%if no-one is sending me water and my (0,0,1,0) should recieve and is not already indicated as a receiver
%this ensures the water count is not decremented twice
rule : {trunc((0,0,0,0))+0.5+(-1)} 10 { (0,0,0,0) - (0,0,1,0) >= 5 AND fractional((0,0,0,0))!=0.5 
		AND (0,0,1,0)!=?}

%if no-one is sending me water and my (1,0,0,0) should recieve and is not already indicated as a receiver
%this ensures the water count is not decremented twice
rule : {trunc((0,0,0,0))+0.1+(-1)} 10 {(0,0,0,0) - (1,0,0,0) >= 5 AND fractional((0,0,0,0))!=0.1
		 AND (1,0,0,0)!=?}

%if no-one is sending me water and my (0,1,0,0) should recieve and is not already indicated as a receiver
%this ensures the water count is not decremented twice
rule : {trunc((0,0,0,0))+0.2+(-1)} 10 {(0,0,0,0) - (0,1,0,0) >= 5 AND fractional((0,0,0,0))!=0.2
 		AND (0,1,0,0)!=?}

%if  no-one is sending me water and my (-1,0,0,0) should recieve and is not already indicated as a receiver
%this ensures the water count is not decremented twice
rule : {trunc((0,0,0,0))+0.3+(-1)} 10 {(0,0,0,0) - (-1,0,0,0) >= 5 AND fractional((0,0,0,0))!=0.3
 		AND (-1,0,0,0)!=?}

%if no-one is sending me water and my (0,-1,0,0) should recieve and is not already indicated as a receiver
%this ensures the water count is not decremented twice
rule : {trunc((0,0,0,0))+0.4+(-1)} 10 {(0,0,0,0) - (0,-1,0,0) >= 5 AND fractional((0,0,0,0))!=0.4
 		AND (0,-1,0,0)!=?}

%if no-one is sending me water but I have water and no soil so I should give a water to the cell beneath me
rule : {trunc((0,0,0,0))+0.5+(-1)} 10 {(0,0,0,1)=0 AND trunc((0,0,0,0)) >0 AND (0,0,1,0)!=?}

%no-one is sending me water and no-one is eligible to recieve water from me I must set my fractional part
%to zero to indicate that no cell should recieve from me
rule : {trunc((0,0,0,0))} 10 {t}

[soil]
%if my water world equivalent is transfering water and I have soil I will decrement my soil
rule : {(0,0,0,0)+(-1)} 10 {fractional((0,0,0,-1)) > 0 AND (0,0,0,0) >0}

%if someone is sending water to my water world cell
%if the sender's soil world equivalent has soil take one soil
rule : {(0,0,0,0)+1} 10 {(fractional((-1,0,0,-1))=0.1 AND (-1,0,0,0) >0) OR 
		 	(fractional((0,-1,0,-1))=0.2 AND (0,-1,0,0) >0) OR
		     	(fractional((1,0,0,-1))=0.3 AND (1,0,0,0) >0) OR 
			(fractional((0,1,0,-1))=0.4 AND (0,1,0,0) >0) OR
			(fractional((0,0,-1,-1))=0.5 AND (0,0,-1,0) >0)}

%no is sending me anything and I am not giving anything
rule : {(0,0,0,0)} 10 {t}

[setRain]
%if I recieved a rain droplet and I have no soil I must pass down
rule : {trunc((0,0,0,0))+0.5} 10 {portValue(thisPort)=1  AND (0,0,0,1)=0 AND (0,0,1,0)!=?}

%if I did not recieve a rain droplet and I have no soil and I have water I must pass down one of my own waters
rule : {trunc((0,0,0,0))+0.5+(-1)} 10 {portValue(thisPort)=0  AND (0,0,0,1)=0 AND (0,0,1,0)!=? AND (0,0,0,0)!=0}

%if I recieved a rain droplet and one of my possible receiving water cell neighbours are eligible to receive
rule : {trunc((0,0,0,0))+0.5} 10 {(0,0,0,0) - (0,0,1,0) >= 4 AND portValue(thisPort)=1
					AND (0,0,1,0)!=?}
rule : {trunc((0,0,0,0))+0.1} 10 {(0,0,0,0) - (1,0,0,0) >= 4 AND portValue(thisPort)=1
					AND (1,0,0,0)!=?}
rule : {trunc((0,0,0,0))+0.2} 10 {(0,0,0,0) - (0,1,0,0) >= 4 AND portValue(thisPort)=1
					AND (0,1,0,0)!=?}
rule : {trunc((0,0,0,0))+0.3} 10 {(0,0,0,0) - (-1,0,0,0) >= 4 AND portValue(thisPort)=1
 					AND (-1,0,0,0)!=?}
rule : {trunc((0,0,0,0))+0.4} 10 {(0,0,0,0) - (0,-1,0,0) >= 4 AND portValue(thisPort)=1
 					AND (0,-1,0,0)!=?}

%I recieved a rain droplet but none of my possible receiving water cells are eligible to receive
rule : {trunc((0,0,0,0))+1} 10 {portValue(thisPort) > 0.5}

%I was triggered by the generator but the value I recieved indicated that I should not recieve a rain droplet
rule : {trunc((0,0,0,0))} 10 {t}

%there is a bug in the simu.exe file it does not prodvide an
%error statement if an input file does not exist.  It just never finishes
%simulating
%if you set the cell value to become something-1 it will not work must write something+(-1)
