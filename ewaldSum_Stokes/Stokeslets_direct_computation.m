clear;
close all;

eta = 1;
% N = 2; % number of stokeslets

% grid points
nX = 3;
nY = 3;
nZ = 3;
nPoints = nX*nY*nZ;
lim = 1;
rx = linspace(-lim,lim,nX);
ry = linspace(-lim,lim,nY);
rz = linspace(-lim,lim,nZ);
rVec = zeros(3,nPoints);
for kk=1:nZ
    for ii=1:nX
        for jj=1:nY
            pointNum = (ii-1)*nX + jj + (kk-1)*nX*nY;
            rVec(:,pointNum) = [rx(jj); ry(ii); rz(kk)];
        end
    end
end





% get i,j,k back from pointNum
for pointNum=1:nPoints
    kk = floor((pointNum-1)/(nX*nY)) + 1;
    ii = rem(pointNum-1,nX*nY) + 1;
    jj = rem(pointNum-1,nX) + 1;
end

% % 3D plot to check if point numbers have been assigned correctly
% for kk=1:nZ
%     for ii=1:nX
%         for jj=1:nY
%             pointNum = (ii-1)*nX + jj + (kk-1)*nX*nY;
%             rVec(:,pointNum) = [rx(jj); ry(ii); rz(kk)];
%             
%             scatter3(rVec(1,pointNum), rVec(2,pointNum), rVec(3,pointNum),...
%                 'filled', 'markerfacecolor', [0.3*(kk-1) 0.3*(kk-1) 0.3*(kk-1)]);
%             string = strcat(num2str(ii), num2str(jj), num2str(kk), ':', num2str(pointNum));
%             text(rVec(1,pointNum), rVec(2,pointNum), rVec(3,pointNum), string);
%             hold on;
%         end
%     end
% end
% xlabel('X-axis'); ylabel('Y-axis'); zlabel('Z-axis');





% point force location
fVec = zeros(3,nPoints);
% fVec(:,(nPoints+1)/2) = [1; 0];
fLoc = [(nPoints+1)/2 + 2, (nPoints+1)/2 - 2];

fVec(:,fLoc(1)) = [1; 0];
fVec(:,fLoc(2)) = [-1; 0];

% Compute flowfield
uVec = zeros(2,nPoints);
for ii=1:nPoints
    rVecI = rVec(:,ii);
    sum = 0;
    for jj=1:nPoints
        rVecJ = rVec(:,jj);
        rij = rVecI - rVecJ;
        
        if norm(rij)~=0
            hiMat = calcOseenTensor(rij,eta);
            sum = sum + hiMat *fVec(:,jj);
        end
    end
    uVec(:,ii) = sum;
end

%% Plotting
%----------------
scale = 500;
set(figure, 'Position', [2700, 1000, 1000, 700]);
title('Streamlines for slow past a Stokeslet');
for ii=1:length(fLoc)
    plot(rVec(1,fLoc(ii)), rVec(2,fLoc(ii)), 'markersize', 5);
    hold on;
end

% Convert to format appropriate for plotting
for pointNum=1:nPoints
    ii = floor((pointNum-1)/nX) + 1;
    jj = rem(pointNum-1,nX) + 1;
    kk = floor((pointNum-1)/(nX*nY));
    u(ii,jj) = uVec(1,pointNum);
    v(ii,jj) = uVec(2,pointNum);
end

% Plot flowfield
q = quiver(rx,ry,u*scale,v*scale);
q.Color = 'blue';
q.LineWidth = 1.5;

% starty = linspace(-0.9,1.1,nCols);
% startx = -1*ones(size(starty));
% h = streamline(rx,ry,u,v,startx,starty);
% set(h, 'LineWidth', 2, 'Color', 'red');
axis equal;
grid minor;

%% Verification Lines
dummy = rVec';
dummy2 = fVec';
