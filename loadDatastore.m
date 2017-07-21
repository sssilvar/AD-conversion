function a = loadDatastore(dataDir, ext)

cdir_ = dir(dataDir);
cdir = cdir_(3:numel(cdir_));

k = numel(cdir);
a.Categories = categorical(zeros(1,k));

for i = 1: k
    a.Categories(i) = cdir(i).name;
end

ni = 1;
for i = 1: k
    d= dir([dataDir, filesep, char(a.Categories(i)), filesep, '*.', ext]);
    nc = numel(d);
    nf= ni+nc-1;
    n = nf - ni + 1;
    
    fprintf('from %d to %d belongs to %s\n', ni, nf , char(a.Categories(i)));
    t = strrep(strsplit(repmat([cdir(i).name, ';'], [1, n]), ';'), ';', '');
    a.Labels(ni:nf) = categorical(t(1:n));
    
    for j = 1:n
        a.Files{ni+j-1, 1} = [dataDir, filesep, cdir(i).name, filesep, d(j).name];
    end
    
    ni = ni + nc;
end
a.Labels = a.Labels';

end