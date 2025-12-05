% Define string length
L_actual = 65; % normalized length (you can use real length if you have it)

% Define fret positions (example: 19 frets evenly spaced)
% Replace this with your actual fret positions:
fret_pos = [21.7, 23, 24.4, 25.9, 27.4, 29, 30.7, 32.6, 34.5, 36.6, 38.7, 41, 43.4, 46, 48.7, 51.6, 54.7, 58, 61.4, 65];
fret_pos = fret_pos/L_actual;
L=1;

% Initialize harmonic quality array
num_frets = length(fret_pos);
num_modes = 10;
harmonic_quality = zeros(1, num_frets);

% Loop over each fret
for i = 1:num_frets
    x_fret = fret_pos(i);
    total_dist = 0;
    
    % Loop over each mode n
    for n = 1:num_modes
        % Node positions for this mode
        nodes = (0:n) * L / n;
        
        % Distance to nearest node
        min_dist = min(abs(nodes - x_fret));
        
        % Add to total
        total_dist = total_dist + min_dist;
    end
    
    % Store total for this fret
    harmonic_quality(i) = total_dist;
end

harmonic_quality = max(harmonic_quality) - harmonic_quality;

figure;
plot(1:num_frets, harmonic_quality, '-o', 'LineWidth', 1.5);
xlabel('Fret number (position)');
ylabel('Harmonic Quality (higher = more harmonic)');
title('Inverted Harmonic Quality of Each Fret');
grid on;

% Create reversed fret numbers (19 -> 0)
fret_numbers = (num_frets-1):-1:0;

% Assign tick marks normally, but labels reversed
xticks(1:num_frets);
xticklabels( arrayfun(@(i) sprintf('%d (%.3f)', fret_numbers(i), fret_pos(i)), 1:num_frets, 'UniformOutput', false) );



d = 0.005;   % proximity threshold (normalized distance) – adjust this value
num_modes = 10;

% Preallocate
harmonic_quality = zeros(1, num_frets);
node_count = zeros(1, num_frets);

for i = 1:num_frets
    x_fret = fret_pos(i);
    total_dist = 0;
    count_close = 0;
    
    for n = 1:num_modes
        % Node positions for mode n
        nodes = (0:n) * L / n;
        
        % Distance to nearest node (for harmonic quality)
        min_dist = min(abs(nodes - x_fret));
        total_dist = total_dist + min_dist;
        
        % Count how many nodes are within distance d
        close_nodes = sum(abs(nodes - x_fret) < d);
        count_close = count_close + close_nodes;
    end
    
    % Store results
    harmonic_quality(i) = total_dist;
    node_count(i) = count_close;
end

% Invert harmonic quality (so higher = more harmonic)
harmonic_quality = max(harmonic_quality) - harmonic_quality;

% Plot harmonic quality
figure;
subplot(2,1,1);
plot(1:num_frets, harmonic_quality, '-o', 'LineWidth', 1.5);
xlabel('Fret number (position)');
ylabel('Harmonic Quality');
title('Inverted Harmonic Quality of Each Fret');
grid on;

xticks(1:num_frets);
fret_numbers = (num_frets-1):-1:0;
xticklabels( arrayfun(@(i) sprintf('%d (%.3f)', fret_numbers(i), fret_pos(i)), 1:num_frets, 'UniformOutput', false) );

% Plot node proximity count
subplot(2,1,2);
bar(1:num_frets, node_count);
xlabel('Fret number (position)');
ylabel(['# of nodes within d = ' num2str(d)]);
title('Node Proximity Count per Fret');
grid on;

xticks(1:num_frets);
xticklabels( arrayfun(@(i) sprintf('%d', fret_numbers(i)), 1:num_frets, 'UniformOutput', false) );