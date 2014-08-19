function [name,data] = ExtractData(values, name)

    switch lower(name)
        case {'t','temperature','temp'}
            data = DimVar(values,'K');
            name = 'Temperature';
			
        case {'p','pressure','press','pres'}
            data = DimVar(values,'bar');
            name = 'Pressure';
			
        case {'rho','density','dens'}
            data = DimVar(values,'kg/m^3');
            name = 'Density';
			
        case {'h','enthalpy','enth','enthalp'}
            data= DimVar(values,'kJ/kg');
            name = 'Enthalpy';
			
        case {'g','gibbs','gibb','gibbs_energy','gibbs_free_energy'}
            data = DimVar(values,'kJ/kg');
            name = 'Gibbs';
			
        case {'s','entropy','entr'}
            data = DimVar(values,'kJ/kg');
            name = 'Entropy';
			
        case {'m','mw'}
            data = DimVar(values,'g/mol');
            name = 'MolarMass';
			
        case {'cp','specific_heat'}
            data = DimVar(values,'kJ/kg-K');
			
        case {'son','sonic_velocity'}
            data = DimVar(values,'m/s');
			
        case {'vis','visc','viscosity'}
            data = DimVar(values,'mP');
			
        case {'cond','conductivity'}
            data = DimVar(values,'mW/cm-K');
			
        case {'cond_fz','condfz','conductivity_frozen'}
            data = DimVar(values,'mW/cm-K');
			
        case {'isp','specific_impulse'}
            data = DimVar(values./9.81,'s');
			
        case 'son1'
            data = DimVar(values,'m/s');
			
        case 'h1'
            data = DimVar(values,'kJ/kg');
			
        case 't1'
            data = DimVar(values,'K');
			
        case 'p1'
            data = DimVar(values,'bar');
			
        case {'vel','detvel'}
            data = DimVar(values,'m/s');
			
        otherwise % All dimensionless or unexpected outputs go here
            data = values;
    end
