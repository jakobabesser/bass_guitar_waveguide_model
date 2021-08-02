function [ notes ] = CreateNotesStructure( f0, pluck_style, expr_style, cent, f_vib, harm_str_fret, t_start, t_end, dB, decay_rate)
% This function creates a structure representing a note played on an
% electric bass, containing the informations about the fundamental
% frequency, plucking style, expression style, start time, end time,
% dynamic and expression parameters.
% 
% REFERENCES:
%
% INPUT:
%       f0:          	fundamental frequncy (Hz)
%       pluck_style:    plucking style (FS, PK, MU, ST, SP)
%       expr_style:     expression style (NO, VI, BE, HA, DN, SL)
%       cent:           cent for frequency varying expression style
%       f_vib:          frequency of vibrato (Hz)
%       harm_str_fret:  vector containing string and fretposition of
%                       harmonic
%       t_start:        start time of note (s)
%       t_end:          end time of note (s)
%       dB:             dynamic of note (dB)
%       decay_rate:     decay rate of note (dB/s)
%
% OUTPUT:
%       notes:          resulting note structure
%
% FUNCTION CALLS:
%


%% filling missing input variables
if nargin < 1
    f0 = 41.2;
end
if nargin < 2
    pluck_style = 'FS';
end
if nargin < 3
    expr_style = 'NO';
end
if nargin < 4
    cent = 0;
end
if nargin < 5
    f_vib = 0;
end
if nargin < 6
    harm_str_fret(1) = 0;
    harm_str_fret(2) = 0;
end
if nargin < 7
    t_start = 0;
end
if nargin < 8
    t_end = t_start+1;
end
if nargin < 9
    dB = 0;
end

if nargin < 10
    decay_rate = 0;
end

%% creating note structure
notes.f0 = f0;
notes.dB = dB;
notes.decay_rate = decay_rate;
notes.t_start = t_start;
notes.t_end = t_end;
notes.pluck_style = pluck_style;
notes.expr_style = expr_style;

notes.vib.frq = f_vib;
notes.svb.cent = cent;
notes.harm.str = harm_str_fret(1);
notes.harm.fret = harm_str_fret(2);

end