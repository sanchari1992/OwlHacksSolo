% Timer to read full csv file to table of 1,360,635 records
tic

% Read csv file to table
phillyCrime = readtable('phillyCrime.csv');

% Stop the timer and display the elapsed time
elapsed_time = toc;
fprintf('Time to read full csv file to table of 1,360,635 records: %.2f seconds\n', elapsed_time);

% Timer to find out the rest of the time the program takes
tic

% Use "disp(phillyCrime)" anywhere you wish to look at full current data
% Use "disp(head(phillyCrime))" anywhere you wish to look at first few rows of current data
% Basic CleanUp
% Drop any missing values
phillyCrime=phillyCrime(~any(ismissing(phillyCrime),2),:);
% Drop unwanted columns
phillyCrime=phillyCrime(:,[1 4 5 7 8 9 10 11 13 14]);
%disp(head(phillyCrime))

% Changing value to integer for dc_dist
phillyCrime.Police_Districts = int8(phillyCrime.Police_Districts);
% Adding datetime columns for later calculation
phillyCrime.Dispatch_Date.Format = 'uuuu.MM.dd HH:mm:ss';
phillyCrime.Dispatch_Time = phillyCrime.Dispatch_Date + phillyCrime.Dispatch_Time;
% Sorting the rows by date time
phillyCrime = sortrows(phillyCrime,'Dispatch_Time');
%disp(head(phillyCrime))

% Extract Months and Years to separate columns in table to plot
phillyCrime.Year = year(phillyCrime.Dispatch_Date);
phillyCrime.Month = month(phillyCrime.Dispatch_Date);
disp(head(phillyCrime))

% Removing the year 2017 because incomplete data
phillyCrime = phillyCrime(phillyCrime.Year ~= 2017, :);

% Let's start with a cool map
% Let's create a map of the district locations from the table

% Create a geographic axes
figure(1)
ax = geoaxes;

% Plot the latitude and longitude data on the map
geoscatter(ax, phillyCrime.Lat, phillyCrime.Lon, 'r', 'filled'); % 'r' for red markers
title('Latitude and Longitude Plot');

% We see that this basically covers Philadelphia extensively.

% Sort into a separate table all crimes committed in Temple University
templeCrime = phillyCrime(phillyCrime.Dc_Dist == 22, :);


% Display the filtered data
disp(head(templeCrime))

% First we plot crimes in the Temple University 22nd district by year
distinctYears = unique(templeCrime.Year);
counts = zeros(size(distinctYears));

for i = 1:numel(distinctYears)
    counts(i) = sum(templeCrime.Year == distinctYears(i));
end

% Create the plot
figure(2)

% Create the bar plot with custom pastel colors
bar(distinctYears, counts, 'FaceColor',[0 .5 .5],'EdgeColor',[0 .9 .9],'LineWidth',1.5);


xlabel('Distinct Years');
ylabel('Count');
title('Count of Rows for Distinct Years');

% Create a plot by month to figure out if there is any trend throughout the
% year of change of crime rate
distinctMonths = unique(templeCrime.Month);
counts = zeros(size(distinctMonths));

for i = 1:numel(distinctMonths)
    counts(i) = sum(templeCrime.Month == distinctMonths(i));
end

% Create the incremental plot
figure(3)
bar(distinctMonths, counts, 'FaceColor',[.5 0 .5],'EdgeColor',[.9 0 .9],'LineWidth',1.5);
xlabel('Distinct Months');
ylabel('Count');
title('Count of Rows for Distinct Months');

% Number of Times a specific crime was committed
distinctCrimes = unique(templeCrime.Text_General_Code);
counts = zeros(size(distinctCrimes));

for i = 1:numel(distinctCrimes)
    counts(i) = sum(strcmp(templeCrime.Text_General_Code, distinctCrimes(i)));
end

% Create the incremental plot
figure(4)
bar(counts, 'FaceColor',[.5 .5 0],'EdgeColor',[.9 .9 0],'LineWidth',1.5);
xticks(1:numel(distinctCrimes));
xticklabels(distinctCrimes);
xlabel('Distinct Crimes');
ylabel('Count');
title('Count of Rows for Distinct Crimes');

% It will also be very informational to plot the top 5 crimes

% Sort counts in descending order and get the indices
[sortedCounts, sortedIndices] = sort(counts, 'descend');

% Select the top 5 counts and corresponding values
top5Counts = sortedCounts(1:5);
top5Values = distinctCrimes(sortedIndices(1:5));

% Create a bar plot for the top 5 counts
figure(5)
bar(top5Counts, 'FaceColor',[.5 .5 0],'EdgeColor',[.9 .9 0],'LineWidth',1.5);
xticks(1:5);
xticklabels(top5Values);
xlabel('Distinct Crimes (Top 5)');
ylabel('Count');
title('Top 5 Counts of Rows for Distinct Crimes');


% Now, we try to pinpoint areas with specific type of crimes
% within the 22nd District
% Let's start with Thefts
specificCrimeType = 'Thefts';

% Filter the data to select rows with the specific crime type
filteredData = phillyCrime(strcmp(phillyCrime.Text_General_Code, specificCrimeType), :);

% Create a geographic map
figure(6)
ax = geoaxes;

% Plot the filtered locations on the map
geoplot(ax, filteredData.Lat, filteredData.Lon, 'bo', 'MarkerSize', 8);
title(['Locations with ' specificCrimeType]);

% In Conclusion
lovePhilly = imread("Credit-City-of-Philadelphia.jpeg");
imshow(lovePhilly)

% Stop the timer and display the elapsed time
elapsed_time = toc;
fprintf('Time to execute the rest of the MATLAB program: %.2f seconds\n', elapsed_time);
