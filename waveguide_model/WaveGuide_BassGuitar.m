function [ Output, Wave_mov ] = WaveGuide_BassGuitar(instr, note, sNumber, fs)
% This function contains a waveguide model which synthesizes the tone of a 
% bass string allowing the use of five different plucking styles and six 
% different expression styles.
% 
% REFERENCES:
% "Entwurf und Test eines einfachen Instrumentencoders" by Mirko Arnold,
% 2008
%
% "Physical Modeling using Digital Waveguides" by Julius O. Smith III, 1992
%
% "Feature-based extraction of plucking and expression styles of the
% electric bass guitar" by Jakob Abe�er, Hanna Lukashevich and Gerald
% Schuller, 2010
%
% INPUT:
%       instr:          instrument to use ('BA', 'GU')
%       note:          	note structure defined by the function
%                       "CreateNotesStructure"
%       sNumber:        string number (1-4)
%       fs:             sampling frequency (Hz)
%
% OUTPUT:
%       Output:       	audio signal of resulting tone
%       Wave_mov:       matlab movie of a string vibration cycle
%
% FUNCTION CALLS:
%



%close all;
tic;

%% setting up visualization parameters

plot_excitation = 0;
visualize = 0;
vis_startsample = 1;
vis_swing_num = 1;  %number of swings to visualize

%% initializing fretboard as OFF
fretboard = 0;

%% initializing loss filters as ON
loss_filt_on = 1;

%% setting up string deflection for different plucking styles
deflection_NO = 1 -((rand)*0.15);
deflection_SP = 6 +((rand-rand)*2);
deflection_ST = 4 +((rand-rand)*1);
deflection_HO = 3 +((rand-rand)*1); %4

%% loading instrument-related measurements from m-file
measure = eval(strcat('Measurements', instr));

%% reading pluck-positions from struct
FingerPluckPos = measure.FingerPluckPos;
PickPluckPos = measure.PickPluckPos;
DampPluckPos = measure.DampPluckPos;
slapPluckPos = measure.slapPluckPos;
slapPos = measure.slapPos;
slapWidth = measure.slapWidth; % 30

%% setting up pick strength for PK style
pick_strength = 0.15 +((rand-rand)*0.1); % Value between 0 and 1

%% setting up pickup positions from struct
PickupPosB=measure.PickupPosB; %J-Bass bridge PU position in %
PickupPosN=measure.PickupPosN; %J-Bass Neck

%% setting up filter positions
FilterPos = 90;
FilterPos2 = 75;
FilterPos3 = 60;
FilterPos4 = 5;
FilterPos5 = 10;
FilterPos6 = 15;
FilterPos7 = 20;
FilterPos8 = 25;
FilterPos9 = 30;


%% setting up fret positions and distances
FretPos = CalcFretPositions( 100 );
FretDistance = [1 1 1 1 1 1 1 1 1 1 1 1 1 0.99 0.99 0.98 0.97 0.91 0.8 0.7 0];

%% getting note parameters from note structure
f0 = note.f0;
dB = note.dB;
note_decay_rate = note.decay_rate;
time = note.t_end - note.t_start;
pluck_style = note.pluck_style;
expr_style = note.expr_style;
f_vib = note.vib.frq;
VBS_cent = note.svb.cent;

%% declaring missing input variables
if nargin < 2
    [ sNumber ] = Frq2BassString(instr, f0);
end
if nargin < 3
    fs = 44100;
end

%% getting harmonic parameters
if strcmp(expr_style, 'HA')
    HarmFret = note.harm.fret;
    f0 = Fret_Tone(instr, note.harm.str, 0);
    [HarmPos, Harmonic] = FretNum_HarmFact(HarmFret);
    HarmPos = HarmPos*100;
    HarmPluckPos = (1/Harmonic)*0.5;
end

%% dead note parameters
DeadPos_1 = 70+((rand-rand)*5);
DeadPos_2 = DeadPos_1+7;

%% subtracting rise time from total time
[out1, rise_time] = SinRise(f0, 1, fs);
time = time-rise_time;
time_samples = floor(time*fs);

%% calculating delay line length
% deactivated for polyphonical playing
% f0 = Fret_Tone(sNumber, FNumber);
sLength = 0.5*fs/f0;
sLength_double = 2*sLength;
sLength_floor = floor(sLength);

%% getting string parameters & "string length"

switch instr
    case('BA')
        [ f_String, decay_rate, beta, CR ] = BassStrParameters( sNumber );
    case('GU')
        [ f_String, decay_rate, beta, CR ] = GuitarStrParameters( sNumber );
end
        
sLength_String = 0.5*fs/f_String;

if note_decay_rate ~= 0
    decay_rate = note_decay_rate;
end

%% shortening decay time & adding more damping to filters for MU style
if strcmp(pluck_style, 'MU')
    if note_decay_rate == 0
        decay_rate = 4*decay_rate;
    end
    beta = beta + 0.3*beta;
end

%% setting up resolution for input signal
resolution = sLength_floor;

%% calculating delay line positions
PickupPosB = PickupPosB/100*sLength_String;
PickupPosN = PickupPosN/100*sLength_String;
PickupPosN_round = round(PickupPosN);
FilterPos = FilterPos/100*sLength;
FilterPos2 = FilterPos2/100*sLength;
FilterPos3 = FilterPos3/100*sLength;
FilterPos4 = FilterPos4/100*sLength;
FilterPos5 = FilterPos5/100*sLength;
FilterPos6 = FilterPos6/100*sLength;
FilterPos7 = FilterPos7/100*sLength;
FilterPos8 = FilterPos8/100*sLength;
FilterPos9 = FilterPos9/100*sLength;
FretPos = FretPos./100.*sLength;

%% finding the fret on the string to f0
FretIndex = Tone_Fret(instr, sNumber, f0);

%% setting up loss filter parameters, coefficients & gain factor
M = 13;
g_times = 24;
g = time2decay(f0, fs, (2*g_times)*(60/decay_rate));
LF_coeff = NtapFIR(beta, M);

%% initial setting damping points & frequency variation OFF
DampPoint_1 = 0;
DampPoint_2 = 0;
VBS_on = 0;

%% setting up expression style parameters
switch expr_style
    case('NO') % 'normal'
        %% setting excitation end to max
        excit_end = resolution;

    case('HA') % 'harmonic'
        %% setting damping point ON
        DampPoint_1 = 1;
        
        %% calculating delay line positions
        HarmPluckPos = round(HarmPluckPos*resolution);
        length_fact_HarmDead = (resolution*2-2)/(sLength_double);
        DampPos_1 = HarmPos;
        DampPos_1 = DampPos_1/100*sLength;
        DampPos_1_excit = round(DampPos_1*length_fact_HarmDead);
        
        %% setting excitation end to damping position
        excit_end = DampPos_1_excit;
        
        %% setting damping point impedances & width
        Damp_Pos_1_Z1 = 1;
        Damp_Pos_1_Z2 = 1;
        Damp_Pos_1_Z3 = 1;
        Damp_Pos_1_Width = 0;
        
    case('DN') % 'dead note'
        %% setting damping points ON
        DampPoint_1 = 1;
        DampPoint_2 = 1;
        
        %% calculating delay line positions
        length_fact_HarmDead = (resolution*2-2)/(sLength_double);
        DampPos_1 = DeadPos_1;
        DampPos_2 = DeadPos_2;
        DampPos_1 = DampPos_1/100*sLength;
        DampPos_2 = DampPos_2/100*sLength;
        DampPos_1_excit = round(DampPos_1*length_fact_HarmDead);
        
        %% setting excitation end to damping position 1
        excit_end = DampPos_1_excit;
        
        %% setting damping point impedances & width
        Damp_Pos_1_Z1 = 5;
        Damp_Pos_1_Z2 = 5;
        Damp_Pos_1_Z3 = 2;
        Damp_Pos_1_Width = 5; %5
        Damp_Pos_2_Z1 = 5;
        Damp_Pos_2_Z2 = 5;
        Damp_Pos_2_Z3 = 2;
        Damp_Pos_2_Width = 5; %5
        
    case('VI')% 'vibrato'
        %% setting frequency variation ON
        VBS_on = 1;
        
        %% initializing count variable
        VBS_count = 0;
        
        %% setting up start time & duration
        VBS_start_time = 0;
        VBS_startsample = floor(VBS_start_time*fs);
        VBS_time_sec = time;
        VBS_timesample = floor(VBS_time_sec*fs);
        
        %% calculating delay line length variation
        [f_change, out1] = VBS_modSin(expr_style, f0, VBS_cent, VBS_time_sec, fs, f_vib);
%         [f_change] = BendVib_Segments(f0, segm_cents, segm_times, fs);
        sLength_double_VBS = fs./(f0+f_change);
        
        %% setting excitation end to max
        excit_end = resolution;
        
    case('BE')% 'bending'
        %% setting frequency variation ON
        VBS_on = 1;
        
        %% initializing count variable
        VBS_count = 0;
        
        %% setting up start time & duration
        VBS_start_time = 0;
        VBS_startsample = floor(VBS_start_time*fs);
        VBS_time_sec = time;
        VBS_timesample = floor(VBS_time_sec*fs);
        
        %% calculating delay line length variation
        [f_change, out1] = VBS_modSin(expr_style, f0, VBS_cent, VBS_time_sec, fs, f_vib);
%         [f_change] = BendVib_Segments(f0, segm_cents, segm_times, fs);
        sLength_double_VBS = fs./(f0+f_change);
        
        %% setting excitation end to max
        excit_end = resolution;
        
	case('SL') % 'slide'
        %% setting frequency variation ON
        VBS_on = 1;
        
        %% initializing count variable
        VBS_count = 0;
        
        %% setting up start time & duration
        VBS_start_time = 0;
        VBS_startsample = floor(VBS_start_time*fs);
        VBS_time_sec = time;
        VBS_timesample = floor(VBS_time_sec*fs);
        
        %% calculating delay line length variation
%         [f_change, ~] = VBS_Sin(expr_style, f0, VBS_cent, VBS_time_sec, fs);
        [f_change, out1] = Slide_model( f0, VBS_cent, VBS_time_sec, fs );
        sLength_double_VBS = fs./(f0+f_change);
        
        %% setting excitation end to max
        excit_end = resolution;
        
end

%% setting plucking style parameters
switch pluck_style
    case ('PK') % 'pick pluck' 
        %% assigning deflection
        deflection = deflection_NO;
        
        %% assigning plucking position
        if strcmp(expr_style, 'HA') == 1
            PluckPos = HarmPluckPos;
        else
            PickPluckPos = round((PickPluckPos/100*sLength_String)/sLength*resolution);
            PluckPos = PickPluckPos;
        end
        
        %% setting up parameters for a peak in the excitation signal
        peak_start = 1;
        peak_width = 4;
        peak_end = 1.05 + pick_strength;
        peak_width = round(peak_width/100*sLength_String);
        peak_start_low = peak_start-(peak_start/(PluckPos-floor(peak_width/2)));
        
        %% setting up parameters for randomness in excitation signal
        rand_width = 5; % 11 20    
        rand_value = 0; % 0.2
        rand_width = round(rand_width/100*sLength_String);
        
        %% creating excitation signal
        excitation = zeros(1, resolution);
        excitation(1:excit_end)=[linspace(0,peak_start_low,PluckPos-floor(peak_width/2)) linspace(peak_start,peak_end,floor(peak_width/2)) linspace(peak_end,peak_start,ceil(peak_width/2)) linspace(peak_start_low,0,excit_end-PluckPos-ceil(peak_width/2))];

        %% adding some randomness to excitation signal
        excitation(PluckPos-floor(rand_width/2):PluckPos+floor(rand_width/2)-1) = excitation(PluckPos-floor(rand_width/2):PluckPos+floor(rand_width/2)-1)+rand_value*(rand(1,2*floor(rand_width/2))-rand(1,2*floor(rand_width/2)));
        
        %% creating left and right travelling waves
        Wave_left = deflection/2*[excitation -excitation(end-1:-1:1)];
        Wave_right = Wave_left;
        
        %% setting reflection parameter low
        CR = 0.1*CR;
        
    case ('FS') % 'finger style'
        %% assigning deflection
        deflection = deflection_NO;
        
        %% assigning plucking position
        if strcmp(expr_style, 'HA') == 1
            PluckPos = HarmPluckPos;
        else
            FingerPluckPos = round((FingerPluckPos/100*sLength_String)/sLength*resolution);
            PluckPos = FingerPluckPos;
        end
        
        %% setting up parameters for summit of excitation signal
        summit_width = 4+(rand-rand);
        summit_width = round(summit_width/100*sLength_String);
        knot_value1 = 0.95;
        knot_value2 = 0.98;
        
        %% creating summit of excitation signal
        sp = spline(1:3,[knot_value1 1 knot_value2],1:(1/summit_width):3);
        
        %% creating excitation signal
        excitation = zeros(1, resolution);
        excitation(1:excit_end) = [linspace(0,knot_value1*1,PluckPos-(floor(summit_width)-1)) sp(2:end-1) linspace(knot_value2*1,0,excit_end-PluckPos-ceil(summit_width))];
        
        %% creating left and right travelling waves
        Wave_left = deflection/2*[excitation -excitation(end-1:-1:1)];
        Wave_right = Wave_left;
        
        %% setting reflection parameter low
        CR = 0.1*CR;
        
    case ('ST') % 'slap thumb'
        %% setting fretboard to ON
        fretboard = 1;

        %% assigning slap position and width
        slapPos = round((slapPos/100*sLength_String)/sLength*resolution);
        slapWidth = round((slapWidth/100*sLength_floor));
        
        %% creating velocity excitation signal
        slap_velocity = (((deflection_ST)/1.5147e-004)*100)/sLength_String;
        sr = slap_velocity*(0.5*sin(2*pi*(1:1:slapWidth)*(1/slapWidth)+(-pi/2))+0.5);
        string_vel = zeros(1, resolution);
        string_vel(slapPos-ceil(slapWidth/2):slapPos+floor(slapWidth/2)-1) = -sr;
        
        %% converting velocity signal to displacement signal
        excitation = cumsum(string_vel)*1/fs/2;
        excitation_b = -excitation;
        deflection = -min(excitation);
        
        %% creating left and right travelling waves
        Wave_left = [excitation excitation(end-1:-1:1)];
        Wave_right = [excitation_b excitation_b(end-1:-1:1)];
        
    case ('SP') % 'slap pluck'
        %% setting fretboard to ON
        fretboard = 1;
        
        %% assigning deflection
        deflection = deflection_SP;
        
        %% assigning plucking position
        if strcmp(expr_style, 'HA') == 1
            PluckPos = HarmPluckPos;
        else
            slapPluckPos = round((slapPluckPos/100*sLength_String)/sLength*resolution);
            PluckPos = slapPluckPos;
        end
        
        %% setting up parameters for summit of excitation signal
        summit_width = 1;
        summit_width = round(summit_width/100*sLength_String);
        knot_value1 = 0.98;
        knot_value2 = 0.98;
        
        %% creating summit of excitation signal
        sp = spline(1:3,[knot_value1 1 knot_value2],1:(1/summit_width):3);
        
        %% creating excitation signal
        excitation = zeros(1, resolution);
        excitation(1:excit_end) = [linspace(0,knot_value1*1,PluckPos-(floor(summit_width)-1)) sp(2:end-1) linspace(knot_value2*1,0,excit_end-PluckPos-ceil(summit_width))];
        
        %% creating left and right travelling waves
        Wave_left = deflection/2*[excitation -excitation(end-1:-1:1)];
        Wave_right = Wave_left;
        
	case ('MU') % muted pluck        
        %% assigning deflection
        deflection = deflection_NO;
        
        %% assigning plucking position
        if strcmp(expr_style, 'HA') == 1
            PluckPos = HarmPluckPos;
        else
            DampPluckPos = round((DampPluckPos/100*sLength_String)/sLength*resolution);
            PluckPos = DampPluckPos;
        end
        
         %% setting up parameters for a peak in the excitation signal
        peak_start = 1;
        peak_width = 1;
        peak_end = 5;
        peak_width = round(peak_width/100*sLength_String);
        peak_start_low = peak_start-(peak_start/(PluckPos-floor(peak_width/2)));
        
        %% creating excitation signal
        excitation = zeros(1, resolution);
        excit_temp = [linspace(0,peak_start_low,PluckPos-floor(peak_width/2)) linspace(peak_start,peak_end,floor(peak_width/2)) linspace(peak_end,peak_start+((peak_end-peak_start)/2),ceil(peak_width/2)-1) linspace(peak_start,0,excit_end-PluckPos-ceil(peak_width/2)+1)];
        excitation(1:length(excit_temp))= excit_temp;
        
        %% filtering excitation signal
        coeff = 71;
        tief = fir1(coeff, 2/sLength_String);
		nMinLexcitation = min(length(excitation),50);
        excitation = conv([-excitation(nMinLexcitation:-1:1) excitation -excitation(end:-1:end-nMinLexcitation+1)], tief);
        excitation = excitation(nMinLexcitation+ceil(coeff/2):end-(nMinLexcitation+floor(coeff/2)));
        resolution = resolution+1;
        
        %% creating left and right travelling waves
        Wave_left = deflection/2*[excitation -excitation(end-1:-1:1)];
        Wave_right = Wave_left;
        
        %% setting reflection parameter low
        CR = 0.1*CR;
        
    case ('EXP')
        %% experimental style
        deflection = deflection_NO;
        excit_width = excit_end/2;
        knot_value = 0;
        sp = spline(1:3,[knot_value 1 knot_value],1:(1/excit_width):3);
        excitation = sp;
        resolution = resolution+1;
        Wave_left = deflection/2*[excitation -excitation(end-1:-1:1)];
        Wave_right = Wave_left;
        loss_filt_on=0;
        
    case ('HO') % Hammer-On
       
        %% setting fretboard to ON
        fretboard = 1;
        %FretPos = [50 100]./100 * sLength;
        %FretDistance = [1 0.01];
        FretDistance(:)=1; % apply higher distance to all frets, so that they won't get hit
        FretDistance(21)=0; % set distance of last fret to 0, so he will be hit
        
        %FretPos = round((FretPos/100*sLength_String)/sLength*resolution);
        slapPos=100;
        slapWidth=32;
        
        
        %% assigning slap position and width, assure slapWidth is an even number
        slapPos = slapPos./100.*sLength_floor;
        %slapPos = round((slapPos/100*sLength_String)/sLength*resolution);
        slapWidth = round((slapWidth/100*sLength_floor)/2)*2;
        
        
        %% creating velocity excitation signal
        slap_velocity = (((deflection_HO)/1.5147e-004)*100)/sLength_String;
        sr = slap_velocity*(0.5*sin(2*pi*(1:1:slapWidth)*(1/slapWidth)+(-pi/2))+0.5);
        string_vel = zeros(1, resolution);
        string_vel(slapPos-ceil(slapWidth/2)+1:slapPos) = -sr(1:slapWidth/2);
        
        
        %% converting velocity signal to displacement signal
        excitation = cumsum(string_vel)*1/fs/2;
        excitation_b = -excitation;
        deflection = -min(excitation);
        
        %% creating left and right travelling waves
        Wave_left = [excitation excitation(end-1:-1:1)];
        Wave_right = [excitation_b excitation_b(end-1:-1:1)];
        
     
        case ('PO') % Pull-Off
            
        %% assigning deflection
        deflection = deflection_NO;
  
        %% set plucking position right in the middle of the first two frets
        FingerPluckPos = floor((FretPos(end)+FretPos(end-1))/2)
                
        PluckPos = FingerPluckPos;

        %% setting up parameters for summit of excitation signal
        summit_width = 2;  %+(rand-rand);
        summit_width = round(summit_width/100*sLength_String);
        knot_value1 = 0.98;
        knot_value2 = 0.98;
        
        %% creating summit of excitation signal
        sp = spline(1:3,[knot_value1 1 knot_value2],1:(1/summit_width):3);
        
        %% creating excitation signal
        excitation = zeros(1, resolution);
        excitation(1:excit_end) = [linspace(0,knot_value1*1,PluckPos-(floor(summit_width)-1)) sp(2:end-1) linspace(knot_value2*1,0,excit_end-PluckPos-ceil(summit_width))];
        
        %% creating left and right travelling waves
        Wave_left = deflection/2*[excitation -excitation(end-1:-1:1)];
        Wave_right = Wave_left;
        
        %% setting reflection parameter low
        CR = 0.1*CR;
            
        
end

%% calculating length factor parameters
sp_Samples = resolution*2-1-1;
length_fact = (sp_Samples)/(sLength_double);

%% calculating length factors for frequency variation
if strcmp(expr_style, 'VI') || strcmp(expr_style, 'BE') || strcmp(expr_style, 'SL') || strcmp(expr_style, 'HO')
    VBS_length_fact = (sp_Samples)./(sLength_double_VBS);
end

%% creating vector for MATLAB interpolation
% x = 1:sp_Samples+1;

%% plotting the excitation signal
if plot_excitation == 1
    if strcmp(pluck_style, 'ST') || strcmp(pluck_style, 'HO')
        figure('Position', [150 150 1000 180]), plot(string_vel/max(-string_vel), 'color','k');
        axis([0,length(string_vel),-1.01,1.01]);
        xlabel('Ort [Samples]');
        ylabel('normierte Geschwindigkeit');
    else
%         figure('Position', [150 150 1000 200]), plot(FretPos(FretIndex+1:end-1)*length_fact, -FretDistance(FretIndex+1:end-1),'o', 1:length(excitation), excitation/max(excitation), 'color','k');
        figure('Position', [150 150 1000 180]), plot(1:length(excitation), excitation/max(excitation), 'color','k');
        axis([0,length(excitation),-0.05,1.02]);
        xlabel('Ort [Samples]');
        ylabel('normierte Auslenkung');
    end
    set(gcf,'color', 'white');
end
    
%% initialization of loop parameters
m = 1;
t = 1;

%% creating variables
first_hit = zeros(1, 20);
hit_time = zeros(1, 20);
FretValue_last_sample = zeros(1,20);
Output_B = zeros(1, time_samples);
Output_N = zeros(1, time_samples);
W_left_vis = zeros(length(Wave_left), sLength_floor*2*vis_swing_num);
W_right_vis = zeros(length(Wave_right), sLength_floor*2*vis_swing_num);

%% waveguide delay loop
while t <= time_samples
    %% frequency loss filtering
    if loss_filt_on == 1
        [Wave_left, Wave_right] = loss_filter( Wave_left, Wave_right, FilterPos, length_fact, LF_coeff, m, sp_Samples);
    end
    
    %% frequency loss filtering for plucking style MU
    if loss_filt_on == 1 && strcmp(pluck_style, 'MU')
        [Wave_left, Wave_right] = loss_filter( Wave_left, Wave_right, FilterPos2, length_fact, LF_coeff, m, sp_Samples);
        [Wave_left, Wave_right] = loss_filter( Wave_left, Wave_right, FilterPos3, length_fact, LF_coeff, m, sp_Samples);
        [Wave_left, Wave_right] = loss_filter( Wave_left, Wave_right, FilterPos4, length_fact, LF_coeff, m, sp_Samples);
        [Wave_left, Wave_right] = loss_filter( Wave_left, Wave_right, FilterPos5, length_fact, LF_coeff, m, sp_Samples);
        [Wave_left, Wave_right] = loss_filter( Wave_left, Wave_right, FilterPos6, length_fact, LF_coeff, m, sp_Samples);
        [Wave_left, Wave_right] = loss_filter( Wave_left, Wave_right, FilterPos7, length_fact, LF_coeff, m, sp_Samples);
        [Wave_left, Wave_right] = loss_filter( Wave_left, Wave_right, FilterPos8, length_fact, LF_coeff, m, sp_Samples);
        [Wave_left, Wave_right] = loss_filter( Wave_left, Wave_right, FilterPos9, length_fact, LF_coeff, m, sp_Samples);
    end

    %% multipling gain factor for decay
    if mod(PickupPosN_round+t, round(sLength_floor/g_times))+1 == 1
        Wave_left = g*Wave_left;
        Wave_right = g*Wave_right;
    end
    
    %% vibrato/bending/slide - changing delay line length
    if VBS_on == 1
        if  t > (VBS_startsample) && t<=(VBS_startsample+VBS_timesample)
            VBS_count = VBS_count+1;
            sLength_double = sLength_double_VBS(VBS_count);
            length_fact = VBS_length_fact(VBS_count);
        end
        %% resetting pointer
        if m>=sLength_double
            m = m-sLength_double;
        end
    end    

    %% testing fretboard collision
    if fretboard == 1
        [Wave_left, Wave_right, first_hit, hit_time, FretValue_last_sample] = Fret_Collision(FretPos, FretDistance, FretIndex, m, Wave_left, Wave_right, length_fact, CR, t, first_hit, hit_time, FretValue_last_sample, deflection);
    end

    %% damping the string vibration
    if DampPoint_1 == 1
        [Wave_left, Wave_right] = Damping(DampPos_1, m, Wave_left, Wave_right, length_fact, Damp_Pos_1_Z1, Damp_Pos_1_Z2, Damp_Pos_1_Z3, Damp_Pos_1_Width, sp_Samples);
    end
    if DampPoint_2 == 1
        [Wave_left, Wave_right] = Damping(DampPos_2, m, Wave_left, Wave_right, length_fact, Damp_Pos_2_Z1, Damp_Pos_2_Z2, Damp_Pos_2_Z3, Damp_Pos_2_Width, sp_Samples);
    end
    
    %% interpolation of string state at pickup points (MATLAB function)
%     W_left_Values = interp1(x, Wave_left, [(((mod((PickupPosB+m)*length_fact, sp_Samples))+1)) (((mod((PickupPosN+m)*length_fact, sp_Samples))+1))], 'spline');
%     W_right_Values = interp1(x, Wave_right,[(((mod((PickupPosB-m)*length_fact, sp_Samples))+1)) (((mod((PickupPosN-m)*length_fact, sp_Samples))+1))], 'spline');

    %% interpolation of string state at pickup points (own function)
	PU_B_L = ((PickupPosB+m)*length_fact);
    PU_B_R = ((PickupPosB-m)*length_fact);
    PU_N_L = ((PickupPosN+m)*length_fact);
    PU_N_R = ((PickupPosN-m)*length_fact);
    W_left_Values(1) = LinInterpol(PU_B_L+1-floor(PU_B_L+1), Wave_left(floor((mod(PU_B_L, sp_Samples))+1)), Wave_left(ceil((mod(PU_B_L, sp_Samples))+1)));
    W_right_Values(1) = LinInterpol(PU_B_R+1-floor(PU_B_R+1), Wave_right(floor((mod(PU_B_R, sp_Samples))+1)), Wave_right(ceil((mod(PU_B_R, sp_Samples))+1)));
    W_left_Values(2) = LinInterpol(PU_N_L+1-floor(PU_N_L+1), Wave_left(floor((mod(PU_N_L, sp_Samples))+1)), Wave_left(ceil((mod(PU_N_L, sp_Samples))+1)));
    W_right_Values(2) = LinInterpol(PU_N_R+1-floor(PU_N_R+1), Wave_right(floor((mod(PU_N_R, sp_Samples))+1)), Wave_right(ceil((mod(PU_N_R, sp_Samples))+1)));
    
    %% adding left & right travelling wave
    Output_B(t) = W_left_Values(1) + W_right_Values(1);
    Output_N(t) = W_left_Values(2) + W_right_Values(2);
    
    %% saving one swing for visualisation
    if t > vis_startsample && t <= vis_startsample+2*sLength_floor*vis_swing_num && visualize == 1
        W_left_vis(:,t-vis_startsample) = [Wave_left(floor((mod(m-1, sLength_double)+1)*length_fact)+1:end) Wave_left(1:floor((mod(m-1, sLength_double)+1)*length_fact))];
        W_right_vis(:,t-vis_startsample) = [Wave_right(floor((mod(-m-1, sLength_double)+1)*length_fact)+1:end) Wave_right(1:floor((mod(-m-1, sLength_double)+1)*length_fact))];
    end
 
            
    
    %% incrementing pointer
    m = m+1;
    
    %% incrementing time samples
    t = t+1;
    
end
    
%% filterdesign of pickup response
PUfrq = [0 10/(fs/2) 100/(fs/2) 1000/(fs/2) 2000/(fs/2) 3377/(fs/2) 4158/(fs/2) 4777/(fs/2) 7000/(fs/2) 8000/(fs/2) 10000/(fs/2)  12000/(fs/2)  15500/(fs/2) 1];
PUmag = [db2mag(-2.92) db2mag(-2.92) db2mag(-2.98) db2mag(-2.58) db2mag(-1.4) db2mag(0) db2mag(-1.03) db2mag(-3.02) db2mag(-10) db2mag(-13.5) 0 0 0 0];
filter_pickup = fir2(100, PUfrq, PUmag);
% fvtool(filter_pickup);

%% adding rise of sinus to prevent popping
Output_B_final = [SinRise(f0, Output_B(1), fs) Output_B];
Output_N_final = [SinRise(f0, Output_N(1), fs) Output_N];

%% filtering output with pickup response
Output_B_final = conv(Output_B_final, filter_pickup);
Output_N_final = conv(Output_N_final, filter_pickup);

%% adding bridge pickup signal and neck pickup signal
% use this correction if convolution with PU filter is used
Output = 0.5*(Output_B_final(51:end-50) + Output_N_final(51:end-50));

% use no correction if PU filter is not applied
% Output = 0.5*(Output_B_final + Output_N_final);

%% adding damping of player at the end of the note
Output = Output-Output(1);
damp_time = 0.001*round(25 + (rand*5));
damp_time = min(damp_time, length(Output)/fs);
damp_sample = floor(damp_time*fs);
damp_curve = -(0.5*sin(0.5*2*pi*(1:1:fs*damp_time)*((1/damp_time)/fs)+(-pi/2))-0.5);

Output(end-damp_sample+1:end) = Output(end-damp_sample+1:end).*damp_curve;

%% normalizing output signal
Output = Output / max(abs(Output));

%% attenuating signal to dB level
dB_fact = 10^(dB/20);
Output = dB_fact*Output;

toc;

%% visualising one swing of the string
W_vis_double = W_left_vis + W_right_vis;
W_vis = W_vis_double(1:floor(size(W_vis_double,1)/2),:);

if visualize == 1
    FretPos_Plot = FretPos(FretIndex+1:end)*length_fact;
    PickupPos_Plot = [PickupPosB*length_fact PickupPosN*length_fact];
    FretDistance_Plot = -FretDistance(FretIndex+1:end);
    Wave_mov = PlotAnimation(W_vis, W_left_vis, W_right_vis, FretPos_Plot, FretDistance_Plot, PickupPos_Plot);
else
    Wave_mov = [];
end

end
