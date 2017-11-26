%{
% .dcm son imagenes en formato "médico"
% ponemos el nombre del folder donde se van a 
% jalar todas las imágenes del MRI
%}

mriFolder = fullfile(pwd, 'VRIEs');

%{
% jalamos cada una de las imagenes 
% con terminación o extensión .dcm
%}
imagenes = dir(fullfile(mriFolder, '*.dcm'));

nombreImagenes = {imagenes.name};

%{
% una vez que tenemos estas direcciones
% guardemoslas en un arreglo
% sin embargo, debemos saber la cantidad de imagenes
%}
I = squeeze(dicomread(fullfile(mriFolder, nombreImagenes{1})));
classI = class(I);
% almacenamos el tipo de dato que se usara

informacion = dicominfo(fullfile(mriFolder, nombreImagenes{1}));

sizeI = size(I);
totalImagenes = length(nombreImagenes);

%Reservemos la memoria necesaria para poder tener las imagenes

info = dicominfo(fullfile(mriFolder, nombreImagenes{1}));
estudioMRI = zeros(info.Rows,info.Columns, totalImagenes, classI);
estudioIfase = zeros(info.Rows,info.Columns, totalImagenes, classI);
estudioIamp = zeros(info.Rows,info.Columns, totalImagenes, classI);
estudioIfaseBW = zeros(info.Rows,info.Columns, totalImagenes, classI);


%{
% verifiquemos que todas las imagenes estén ahi
% leyendolas
%}
for i = totalImagenes:-1:1
    nombreImagen = fullfile(mriFolder, nombreImagenes{i});
    imagen = squeeze(dicomread(nombreImagen));
    estudioMRI(:,:,1) = uint16(imagen(:,:,1));
    
    k=fspecial('gaussian',[ 9 9], 0.9);
    VRIEf=imfilter(imagen,k,'same');
    [Ifase,Iamp]=fIfase(double(VRIEf),15);
    estudioIfase(:,:,i) = Ifase;
    estudioIamp(:,:,i) = Iamp;
    %figure, imshow(Iamp,[]), colormap(jet);
    %figure, imshow(Ifase,[]), colormap(jet);
    
    %Umbralizando
    idx=find(Iamp>(.2*max(max(Iamp))));
    BW=zeros(size(Iamp));
    BW(idx)=1;
    estudioIfaseBW(:,:,i) = Ifase.*BW;
    %%figure, imshow(Ifase.*BW,[])

    
    h = waitbar((length(nombreImagenes)-i+1)/length(nombreImagenes));
    if (i == 1)
        close(h);
    end   
end

examGUI2();