function trans = find_transform(nPoints, destination)
% sources is nPoints of size 5x2
% destination is also of size 5x2
% over determined (constrained) linear equations - solve LS (LeastSquares) using SVD
	A1 = [nPoints(:,1) zeros(size(nPoints,1),1) nPoints(:,2) zeros(size(nPoints,1),1) ones(size(nPoints,1),1) zeros(size(nPoints,1),1)];
    A2 = [zeros(size(nPoints,1),1) nPoints(:,1) zeros(size(nPoints,1),1) nPoints(:,2) zeros(size(nPoints,1),1) ones(size(nPoints,1),1)];
	A = [A1; A2];
	destination = [destination(:,1); destination(:,2)];
	sol = inv(A'*A)*A'*destination;
	trans = [sol(1) sol(2) 0; sol(3) sol(4) 0; sol(5) sol(6) 1];
end