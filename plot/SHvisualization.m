function hh = SHvisualization(pp,theta,phi,Y)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% hh = SHvisualization(pp,theta,phi,Y) 
%
% Function plotting a given spherical harmonic on the grid theta/phi. 3
% different types of plots are available :
%   - classical 3D plot 
%   - projection of the harmonic on a sphere
%   - projection of the spherical harmonic on the 3 2D planes of the space.
%
% Inputs :
%   * pp    = structure containing parameters to plot. See default
%   parameters and their sigi=nification below.
%   * theta = grid of elevation angle
%   * phi   = grid of azimuthal angle
%   * Y     = complex spherical harmonic values associated with each angle
%   location. 
%
% Default parameters :
%
%   pp = struct('pltype','3Dplot',...
%               'valtype','real',...
%               'orders',[n m],...
%               'fontsize',12)
% 
% pltype   : plot type ('3Dplot','3Dsphere','2Dplot')
% valtype  : type of value plotted ('real' or 'imaginary' parts) 
% order of plotted spherical harmonic (only for figure title) [n m]
% fontsize : font size for plots
%
% Outputs :
%   *hh    = figure handle containing spherical harmonic.
%
% Th�o Mariotte - 10/2019 - ENSIM (SNAH project)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


if nargin == 1
    if exist('pp','var')
        % Get the order of the current harmonic
        n = pp.orders(1);
        m = pp.orders(2);
        % distance bewteen each angle
        dx = pi/200;
        elev = 0 : dx : pi;
        az = 0 : dx*2 : 2*pi;
        % grid building
        [phi,theta] = meshgrid(az,elev); 
        Y = getSphericalHarmonics(theta,phi,n,m);
    end
end  

% Set interpreter to LaTeX
set(groot, 'defaultAxesTickLabelInterpreter','latex'); set(groot, 'defaultLegendInterpreter','latex');

if nargout == 0
   error('Please specify an output figure handle.') 
end

% Get the order of the current harmonic
n = pp.orders(1);
m = pp.orders(2);


% Select the part of the complex spherical harmonic to plot
switch pp.valtype
    case 'real'
        Y2plot = real(Y);
    case 'imag'
        Y2plot = imag(Y);
    otherwise
        warning('Wrong part type. Real() case choosen by default.')
        Y2plot = real(Y);
end

%%% Ploting part

% main figure
hh = figure('Name','Spherical Harmonics visualization');

% select the type of plot

switch pp.pltype
    case '3Dplot';
        
        % cartesian frame
        theta = theta - pi/2;
        [Xsh,Ysh,Zsh] = sph2cart(phi,theta,Y2plot);
        
        surf(Xsh,Ysh,Zsh,Y2plot)
        shading('interp')
        title(sprintf('Spherical harmonic (%s) : $Y_{%d}^{%d}$',pp.valtype,n,m),'interpreter','latex')
        xlabel('X')
        ylabel('Y')
        zlabel('Z')
        colormap('jet')
        axis('equal')
        set(gca,'fontsize',pp.fontsize)
        
    case '3Dsphere'
        
        % cartesian frame
        [Xsh,Ysh,Zsh] = sph2cart(phi,theta,Y2plot);
        
        % draw a unit sphere
        [xs,ys,zs]=sphere(max(size(Y2plot))-1);
        xs = xs(1:size(Xsh,1),1:size(Xsh,2));
        ys = ys(1:size(Ysh,1),1:size(Ysh,2));
        zs = zs(1:size(Zsh,1),1:size(Zsh,2));
        surf(xs,ys,zs,Y2plot);
        axis equal
        shading interp     
        title(sprintf('Spherical harmonics projection (%s) : $Y_{%d}^{%d}$',pp.valtype,n,m),'interpreter','latex')
        xlabel('X')
        ylabel('Y')
        zlabel('Z')
        colormap('jet')
        set(gca,'fontsize',pp.fontsize)
        
    case '2Dplot'
        
        % cartesian frame
        [Xsh,Ysh,Zsh] = sph2cart(phi,theta,Y2plot);
        
        % plane dimensions
        [xs,ys,zs]=sphere(max(size(Y2plot))-1);
        xs = xs(1:size(Xsh,1),1:size(Xsh,2));
        ys = ys(1:size(Ysh,1),1:size(Ysh,2));
        zs = zs(1:size(Zsh,1),1:size(Zsh,2));
        
        % plots        
        ax1 = subplot(2,2,1);        
        pcolor(xs,ys,Y2plot)
        shading('interp')
        colormap('jet');
        xlabel('x','interpreter','latex')
        ylabel('y','interpreter','latex')
        title('XY plane projection','interpreter','latex');
        axis('equal')
        set(ax1,'fontsize',pp.fontsize)
        
        ax2 = subplot(2,2,2);
        pcolor(ys,zs,Y2plot)
        shading('interp')
        colormap('jet');
        xlabel('y','interpreter','latex')
        ylabel('z','interpreter','latex')
        set(ax2,'fontsize',pp.fontsize)
        title('YZ plane projection','interpreter','latex');
        axis('equal')
        
        ax3 = subplot(2,2,3);
        pcolor(xs,zs,Y2plot)
        shading('interp')
        colormap('jet');
        xlabel('x','interpreter','latex')
        ylabel('z','interpreter','latex')
        set(ax3,'fontsize',pp.fontsize)
        title('XZ plane projection','interpreter','latex');
        axis('equal')
        
    otherwise
        close(hh);
        fprintf('--------------------------------------------------------\n');
        fprintf('No plot configuration found. Please try one of these :\n');
        fprintf('   -> Classical 3D plot    : <%s>\n','3Dplot');
        fprintf('   -> 3D sphere projection : <%s>\n','3Dsphere');
        fprintf('   -> 2D plane projection  : <%s>\n','2Dplot');
        fprintf('--------------------------------------------------------\n');
end 

end