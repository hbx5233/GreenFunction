function [M,MA,MB]=Mfun(X,Y,H)

% Calculates function M and its partial derivatives based on Chebyshev approximation
% Inputs are:
%   X = N x 6 array of powers of x=2*A-1, where column n is x^(n-1)
%   Y = N x 8 array of powers of y=B-1, where column n is y^(n-1)
%   H = K*h, where K is deep-water wavenumber and h is water depth

% get polynomial coefficients
b=get_coeff(H);

% calculate value of z
z=get_z(H);

% perform summation over k
c=zeros(size(b,1),size(b,2));
for k=1:size(b,3)
    c=c+b(:,:,k)*z^(k-1);
end

% calculate M and partial derivatives
M=zeros(size(X,1),1);
MA=zeros(size(X,1),1);
MB=zeros(size(X,1),1);
for n1=0:(size(b,1)-1)
    for n2=0:(size(b,2)-1)
        M=M+c(n1+1,n2+1).*X(:,n1+1).*Y(:,n2+1);
        if n1>0
            MA=MA+2*n1*c(n1+1,n2+1).*X(:,n1).*Y(:,n2+1);
        end
        if n2>0
            MB=MB+n2*c(n1+1,n2+1).*X(:,n1+1).*Y(:,n2);
        end
    end
end

% correct for singularity when 0<H<=0.1
if 0<H && H<=0.1 
    M=M+log(H).*(4*H-0.5);
end

    function z=get_z(H)
        % map from H to z
        if H<=0.1
            z=20*(H-0.05);
        elseif H<=10
            LH=log10(H);
            if LH<=-0.5
                z=4*(LH+0.75);
            elseif LH<=0
                z=4*(LH+0.25);
            elseif LH<=0.5
                z=4*(LH-0.25);
            else
                z=4*(LH-0.75);
            end
        else
            Hinv=1/H;
            z=20*(Hinv-0.05);
        end
    end

    function b=get_coeff(H)
        % polynomial coefficients for various ranges of H
        if H<=0.1
            b = reshape(single([-1.37342954 -0.0215211194 -0.0102501642 0.000512252504 ...
                0.000159752599 0.142142147 -0.0111624319 -0.00490669208 ...
                0.000547879084 0.000143950761 0.0838891119 -0.00837514456 ...
                -0.00343220588 0.000542284281 0 0.0140717896 -0.00346888253 ...
                -0.00143396168 0.000581265253 0 0.00520595489 -0.00174078124 ...
                -0.000623357249 0.000354521559 0 0.00127755245 -0.000776636531 ...
                0 0 0 0.000407089363 -0.00032135009 0 0 0 0.298556507 ...
                -0.0014315052 -0.000630164403 0.000106963467 0 0.00404004799 ...
                -0.00283123087 -0.00126547494 0.000121301913 0 0.00555599155 ...
                -0.00180890691 -0.000890261552 9.78555618E-5 0 0.0035682614 ...
                -0.000536064967 -0.000219309644 0 0 0.00118384953 -0.000225984651 ...
                0 0 0 0.000183455981 0 0 0 0 0 0 0 0 0 0.0136530669 ...
                0.00216878508 0.00099016889 0 0 -0.0183336549 -0.00020686991 ...
                -9.35734E-5 0 0 -0.00987331197 -0.000146288439 0 0 ...
                0 0.000234005594 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ...
                0 0 -0.00503593823 -0.00102911051 2.40715826E-6 0 0 ...
                0.000121380908 8.07863E-5 0 0 0 5.29223735E-6 0 0 0 ...
                0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0.00201424863 ...
                0.00136400573 0.000401083933 0 0 -0.0196945667 0 0 ...
                0 0 0.00465078186 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ...
                0 0 0 0 0 0 0 -0.013222211 0.00125441432 -0.00041013927 ...
                0 0 0.0676578358 0 0 0 0 0.00998515822 0 0 0 0 0 0 ...
                0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 -0.000873817771 ...
                -0.00222293613 0 0 0 0.15899843 0 0 0 0 -0.019433232 ...
                0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0.0294199 ...
                -0.00118518167 0 0 0 -0.464268804 0 0 0 0 -0.0152591709 ...
                0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0.0015807678 ...
                0.00158379797 0 0 0 -0.701545775 0 0 0 0 0.0260362905 ...
                0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 -0.0299876034 ...
                0 0 0 0 1.71466625 0 0 0 0 0.00889170635 0 0 0 0 0 ...
                0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 -0.000592010038 ...
                0 0 0 0 1.66085434 0 0 0 0 -0.0129511794 0 0 0 0 0 ...
                0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0.0109708756 ...
                0 0 0 0 -3.56941247 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ...
                0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 -2.17168546 0 0 ...
                0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ...
                0 0 0 0 0 0 4.21818 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ...
                0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1.47405016 0 0 ...
                0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ...
                0 0 0 0 0 0 -2.63786936 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ...
                0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 -0.406329632 ...
                0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ...
                0 0 0 0 0 0 0 0 0.678614616 0 0 0 0 0 0 0 0 0 0 0 0 ...
                0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0]), 5, 7, 18);
        elseif H<=10
            LH=log10(H);
            if LH<=-0.5
                b = reshape(single([-0.96175909 -0.0147067606 -0.0065154382 0.000784824486 ...
                    0.000172908403 0.0680374801 -0.0184465013 -0.00827569701 ...
                    0.000791770755 0.000233739949 0.0554609373 -0.0134594264 ...
                    -0.00573557755 0.000814378902 0.000176413901 0.0232134778 ...
                    -0.00499568088 -0.00214711367 0.000765099481 0 0.0083509367 ...
                    -0.00237764535 -0.000961693586 0.000452103646 0 0.00200860295 ...
                    -0.00103414478 0 0 0 0.000603719091 -0.000412974128 ...
                    0 0 0 0.00742023671 0.011547694 0.00601755921 0.000217492168 ...
                    0 -0.105774947 -0.00526685175 -0.00225196895 0.000419261574 ...
                    8.11678619E-5 -0.0470694825 -0.00394805 -0.00155060063 ...
                    0.000327081798 0 0.00652239 -0.00143247261 -0.000795953791 ...
                    0 0 0.00260240189 -0.000768935715 -0.000304973306 0 ...
                    0 0.000657664321 -0.000224378091 0 0 0 0 0 0 0 0 0.159047678 ...
                    0.00676441845 0.00348130404 9.85197912E-5 0 -0.0550261363 ...
                    -0.000426415674 -1.14078503E-5 0.000176569083 0 -0.0273193 ...
                    -0.000717178918 -0.000284797745 0 0 0.000762681942 ...
                    -0.000797081331 -0.000336501456 0 0 0.00036719098 -0.000326681591 ...
                    0 0 0 0 0 0 0 0 0 0 0 0 0 0.0255812109 0.00160823669 ...
                    0.000860656437 0 0 -0.0115120355 0.000745872268 0.000446410355 ...
                    0 0 -0.00700239697 0.000213911087 0 0 0 -0.00124610565 ...
                    -0.000237526809 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ...
                    -0.00272826012 2.80948971E-5 0 0 0 0.000685625069 0.000506528071 ...
                    0.000263783935 0 0 -0.000186399717 0.000221912691 0 ...
                    0 0 -0.000709731888 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ...
                    0 0 0 -0.0017509046 0 0 0 0 0.00123465748 0.000181547672 ...
                    0 0 0 0.000409565371 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ...
                    0 0 0 0 0 0 0 0 0 0 0 0 0 0 0.000399651 0 0 0 0 0 0 ...
                    0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0]), 5, 7, 7);
            elseif LH<=0
                b = reshape(single([-0.213238508 0.0443768948 0.0231763665 0.000906540838 ...
                    0.000158181545 0 -0.372075409 -0.00928318221 -0.00247617485 ...
                    0.00226901821 0.000589871721 -0.000165306628 -0.181630686 ...
                    -0.0149832387 -0.00513781467 0.00181428983 0.000413574162 ...
                    0 0.00863256678 -0.0124312714 -0.00444982527 0.00164391892 ...
                    0 0 0.00875799451 -0.00575439353 -0.00244066422 0.00106154848 ...
                    0 0 0.00520252809 -0.00229164236 -0.000830081 0 0 0 ...
                    0.00132914423 -0.000993248308 0 0 0 0 0.700345397 0.0443612039 ...
                    0.0212904867 -0.00098452263 -0.000309201772 0 -0.244862631 ...
                    0.0366944894 0.0195157956 0.000774209911 0 0 -0.173787907 ...
                    0.0150621077 0.00906963088 0.00103877648 0 0 -0.05039021 ...
                    -0.00492656603 -0.00143440638 0.00118763465 0 0 -0.0105386311 ...
                    -0.00335829868 -0.0013649282 0.000655311393 0 0 0.00201248052 ...
                    -0.0016532623 -0.000547973905 0 0 0 0.000459958217 ...
                    -0.000623645086 0 0 0 0 0.0821283 -0.00171547744 -0.00225948496 ...
                    -0.00135278399 -0.000371883914 0 0.108061843 0.0336398035 ...
                    0.0168742165 -0.000491456653 -0.000275095255 0 0.0126148118 ...
                    0.0204397347 0.0101484219 0 0 0 -0.04274863 0.00241794623 ...
                    0.00159143936 0.000530694437 0 0 -0.0141744977 -0.000718752504 ...
                    0.000583855668 0 0 0 -0.00233800896 -0.000698182033 ...
                    0 0 0 0 0 0 0 0 0 0 -0.0748788565 -0.0107037378 -0.00609684968 ...
                    -0.000514734827 0 0 0.109025724 0.0102950521 0.00360242883 ...
                    -0.00107950764 0 0 0.0444722623 0.00961219147 0.00427174242 ...
                    -0.000550067343 0 0 -0.0120735811 0.0047548688 0.00298403297 ...
                    0 0 0 -0.00585630536 0.00160508335 0.000915037468 0 ...
                    0 0 -0.00231799157 0 0 0 0 0 0 0 0 0 0 0 -0.016527731 ...
                    -0.00424272567 -0.00181676273 0 0 0 0.022968784 -0.00263313646 ...
                    -0.00297391764 -0.000652913062 0 0 0.0163681954 0.00116596301 ...
                    0 0 0 0 0.00291393185 0.00317434245 0.00147680694 0 ...
                    0 0 0 0.00121611624 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ...
                    0.00167498237 -0.000128807937 1.72582495E-5 0 0 0 -0.00838923547 ...
                    -0.00383674027 -0.00178905833 0 0 0 0.00113500969 -0.00101434125 ...
                    -0.000702548365 0 0 0 0.00491792336 0.000869778276 ...
                    0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0.000569466385 ...
                    0.00038113934 0 0 0 0 -0.00592617784 -0.00122677104 ...
                    0 0 0 0 -0.00113893277 -0.00076227868 0 0 0 0 0.0015564143 ...
                    0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ...
                    0 0 0 -0.000952332106 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ...
                    0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0]), 6, 7, 8);
            elseif LH<=0.5
                b = reshape(single([0.765475273 0.00686877407 -0.00261473376 -0.00589672802 ...
                    -0.0010529412 0.000350884628 0.140619829 0.0837933198 ...
                    0.030710144 -0.0105828727 -0.00211018091 8.63024834E-5 ...
                    -0.00371428439 0.0924812928 0.0376807339 -0.00899903569 ...
                    -0.00211312738 -0.000131500841 -0.0971003249 0.0579298213 ...
                    0.0264366735 -0.00330885337 -0.00155905692 0 -0.0552543662 ...
                    0.0229286607 0.0115714455 0.000872436736 -0.000648965244 ...
                    0 -0.0222975165 0.00425501494 0.00371711212 0.00110139046 ...
                    0 0 -0.0067358017 -0.000347215391 0.00115703954 0 0 ...
                    0 -0.000952589617 -0.000599676743 0 0 0 0 -0.0614277087 ...
                    -0.1075911 -0.0527104586 0.00225223508 0.00140688219 ...
                    4.46383492E-5 0.490644276 -0.119115442 -0.0717539936 ...
                    -0.00957105402 -0.000470763 0.000374750205 0.424213797 ...
                    -0.0268956907 -0.0325654335 -0.0179907419 -0.00300562428 ...
                    0.00118242356 0.173536211 0.0572593212 0.0128031839 ...
                    -0.0154305175 -0.00400355598 0.00092658808 0.0330925472 ...
                    0.0471067131 0.014901395 -0.00735521782 -0.00107040652 ...
                    0 -0.0161727183 0.0259795748 0.0113133686 -0.00393744418 ...
                    0 0 -0.0135971708 0.0112245455 0.00479589216 -0.00161073613 ...
                    0 0 -0.00420713611 0.00270231767 0 0 0 0 -0.329286098 ...
                    0.00208455324 0.0126727764 0.0110100107 0.00212919363 ...
                    -0.000533364 -0.370611161 -0.152938515 -0.0598515049 ...
                    0.0151091712 0.00402089301 0.000653853291 -0.049348481 ...
                    -0.167509317 -0.0845708251 0.004828854 0.0031220133 ...
                    0.00106672803 0.185815185 -0.0864174962 -0.0557619 ...
                    -0.00856327079 0.00127189 0 0.106836587 -0.0069300225 ...
                    -0.0112545453 -0.0128717972 0 0 0.0364679024 0.0192122255 ...
                    0.00125700119 -0.00459108967 0 0 0.00622555474 0.0117157884 ...
                    0 0 0 0 0 0.00293529686 0 0 0 0 0.104880467 0.0711008236 ...
                    0.0390774161 0.00139553461 -0.000831626123 0 -0.28754288 ...
                    0.0727637336 0.0581338 0.0163962897 0.0036196725 0 ...
                    -0.293664038 -0.0400347747 0.00146376959 0.0186596531 ...
                    0.00415048841 0 -0.116751336 -0.104102112 -0.0463127978 ...
                    0.0102950465 0.00355596864 0 0.0112433955 -0.0555734672 ...
                    -0.0273156036 0.0028535903 0 0 0.0325376242 -0.0170966871 ...
                    -0.00993337668 0 0 0 0.0168553814 -0.00395671185 -0.00358479144 ...
                    0 0 0 0.00310820364 0 0 0 0 0 0.100574806 0.0150615303 ...
                    -0.00157055887 -0.00623731269 -0.00102567289 0 0.174910948 ...
                    0.112756215 0.0516185947 -0.00061610539 -0.00106030854 ...
                    0 -0.0392025784 0.0871671438 0.0605791286 0.00953315105 ...
                    0 0 -0.150159791 0.0141108474 0.023876844 0.0108552584 ...
                    0 0 -0.0590900928 -0.0276316032 -0.010195558 0.00724723283 ...
                    0 0 -0.0102371816 -0.0270486884 -0.00493061077 0 0 ...
                    0 0 -0.0073291068 0 0 0 0 0 0 0 0 0 0 -0.0115207816 ...
                    -0.0264770016 -0.0170422811 -0.00163919281 0 0 0.138117358 ...
                    -0.00214701938 -0.0170270726 -0.00712122815 -0.00246449793 ...
                    0 0.114287421 0.0520575233 0.0201377664 -0.00429507 ...
                    0 0 0.0112385526 0.0598790571 0.0367183387 0 0 0 -0.0306580309 ...
                    0.0162856486 0.0119655458 0 0 0 -0.0147149479 0 0 0 ...
                    0 0 -0.00539921224 0 0 0 0 0 0 0 0 0 0 0 -0.0336124785 ...
                    -0.0136109442 -0.00115114846 0.00150894502 0 0 -0.0373306535 ...
                    -0.047143098 -0.0221928582 -0.00404045684 0 0 0.0477175117 ...
                    -0.0112628182 -0.0165078565 -0.00603411114 0 0 0.0637968704 ...
                    0.0181686431 0 0 0 0 0.0109882783 0.0146013433 0.00679703848 ...
                    0 0 0 0 0.00830551423 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ...
                    0 -0.00201058108 0.00508525642 0.00371705042 0 0 0 ...
                    -0.0447626263 -0.0133469384 0.00127212633 0 0 0 -0.0209606681 ...
                    -0.0170908924 -0.0100363279 0 0 0 0.00933684874 -0.0114508411 ...
                    -0.00861371122 0 0 0 0.0112711722 0 0 0 0 0 0 0 0 0 ...
                    0 0 0 0 0 0 0 0 0 0 0 0 0 0 0.00689231651 0.00396895222 ...
                    0 0 0 0 0.00261337077 0.010280529 0.00324525824 0 0 ...
                    0 -0.013784633 -0.00395496748 0 0 0 0 -0.0120363235 ...
                    -0.00888965 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ...
                    0 0 0 0 0 0 0 0 0 0 0 0 0 0 0.00591782061 0.00468608877 ...
                    0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ...
                    0 0 0 0 0 0 0 0 0 0 0 0 0 0]), 6, 8, 10);
            else
                b = reshape(single([0.414246738 -0.0195039865 -0.00821172167 0.0013256761 ...
                    0.000179188777 2.15566729E-6 0.101524875 -0.0223255474 ...
                    -0.00752743892 0.00280694058 -7.58005117E-5 -0.000158954092 ...
                    0.0721450672 -0.0227514822 -0.00669628708 0.00393161 ...
                    9.08961229E-5 -0.000801457965 0.0249583926 -0.0157425907 ...
                    -0.00369717437 0.00422861194 0.000955468684 -0.000688182 ...
                    0.0113513367 -0.0116980178 -0.00185409386 0.004751537 ...
                    0.000800667331 0 0.00511153 -0.00816962 -0.0016973 ...
                    0.00269139768 0 0 0.00299186679 -0.00413573859 -0.00122884661 ...
                    0 0 0 0.000798809109 -0.00109469821 0 0 0 0 -0.064946048 ...
                    0.011895475 0.00429042941 -0.00166119263 -0.000277759391 ...
                    0.000104321291 -0.0458215587 0.0209387243 0.00559145259 ...
                    -0.00355103961 -0.000199258226 3.7710066E-5 -0.0391489193 ...
                    0.0262026023 0.00554454466 -0.00500445394 -0.00114957232 ...
                    -0.00114962994 -0.0203301571 0.0249533337 0.0078919325 ...
                    -0.00803366117 -0.00417141 -0.00118620892 -0.0137025435 ...
                    0.0194177609 0.0095390277 -0.00356559874 -0.00305760116 ...
                    0 -0.0113399709 0.00967829209 0.00817779731 0.00437293714 ...
                    0 0 -0.00538669201 -0.000188860708 0.00434572203 0.00253606867 ...
                    0 0 0 -0.00269889878 0 0 0 0 0.0328592695 -0.0102415215 ...
                    -0.00349167711 0.00150829775 0.000260516128 -4.31133458E-6 ...
                    0.0322704762 -0.0211935733 -0.00953812338 0.00326390075 ...
                    0.00351104559 0.00177187333 0.0300679673 -0.0275946334 ...
                    -0.0119618848 0.00646800688 0.00448979577 0.00160291593 ...
                    0.0244786702 -0.0255509317 -0.0143906567 -0.00276569137 ...
                    0.00144441496 0.00137636403 0.0265195724 -0.00490867626 ...
                    -0.0216162335 -0.0197572391 -0.00160133466 0 0.0132572483 ...
                    0.0186206605 -0.0108184749 -0.0151292719 0 0 -0.000764919 ...
                    0.014838744 0.00245769322 0 0 0 -0.00159761822 0.0037642275 ...
                    0 0 0 0 -0.0156156383 0.00597969489 0.00221472909 -0.000214435102 ...
                    7.77495279E-6 0 -0.022153018 0.0169875659 0.0104710655 ...
                    0.000580268679 -0.000537885295 0 -0.0344085582 0.0115278764 ...
                    0.0251900628 0.0095855752 0.000131484543 0 -0.0326469764 ...
                    -0.0185473226 0.0130288322 0.0256963558 0.0046629007 ...
                    0 -0.012593301 -0.0343168341 -0.00812002644 0.0169891641 ...
                    0.00407680171 0 0.00829420332 -0.0337820053 -0.00953049585 ...
                    0 0 0 0.00718225585 -0.0174082238 -0.00579429604 0 ...
                    0 0 0 0 0 0 0 0 0.00742860464 -0.00149899977 -0.0025885806 ...
                    -0.00160107692 -5.43890164E-5 0 0.0187965091 0.00331804412 ...
                    -0.0034854922 -0.0106159681 -0.00542902341 -0.00145613053 ...
                    0.0285870545 0.0200471207 -0.0034754097 -0.0174313076 ...
                    -0.00370104914 0 0.00767934788 0.0549815297 0.00859662425 ...
                    -0.00495952182 -0.00284582749 0 -0.0270291809 0.0492208637 ...
                    0.0344678424 0.00993595179 0 0 -0.0204383433 0.00353346951 ...
                    0.0244099293 0.00942893606 0 0 -0.00325371302 -0.00620813062 ...
                    0 0 0 0 0 0 0 0 0 0 -0.00689914823 0.00194880099 0.0022942659 ...
                    0.000896366953 0 0 -0.0128880097 -0.0262073558 -0.00399755407 ...
                    0.00308651221 0 0 0.014618448 -0.0464998 -0.0317458957 ...
                    -0.00068150583 0 0 0.0354894176 -0.0163688045 -0.0274927132 ...
                    -0.0137033984 0 0 0.0218591578 0.00950727426 0 -0.0110104922 ...
                    0 0 0.00355816423 0.0160644241 0 0 0 0 0 0.0102724601 ...
                    0 0 0 0 0 0 0 0 0 0 0.00400752202 0.00292121409 0.00152362732 ...
                    0.000209947946 0 0 -0.00799627 0.0155710531 0.00859063864 ...
                    0.00561472401 0.00290159648 0 -0.0289363507 0.017314272 ...
                    0.00858311355 0.00603154674 0 0 -0.0230127908 -0.0246718731 ...
                    0.00304529606 0 0 0 0.00669453526 -0.0386217721 -0.0133890705 ...
                    0 0 0 0.00558177661 -0.00909023266 -0.0111635532 0 ...
                    0 0 0 0 0 0 0 0 0 0 0 0 0 0 0.00313579501 -0.00753854355 ...
                    -0.00193997251 0 0 0 0.015304001 0.010515742 -0.00168542273 ...
                    0 0 0 0.00115331158 0.0258534942 0.010923109 0 0 0 ...
                    -0.0103780562 0.00873075612 0.0116116973 0 0 0 -0.0066148662 ...
                    0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 -0.00292497268 ...
                    -2.78382431E-5 0 0 0 0 -0.000967902306 -0.00704654865 ...
                    -0.00339949317 0 0 0 0.00584994536 -0.0103012659 0 ...
                    0 0 0 0.00725077139 0.00697411271 0 0 0 0 0 0.0103012659 ...
                    0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0.0029183689 ...
                    0 0 0 0 -0.00315976492 -0.00304181967 0 0 0 0 0 -0.00583673781 ...
                    0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ...
                    0 0 0 0 0 0 0 0]), 6, 8, 10);
            end
        else
            b = reshape(single([0.348657578 -0.0107565895 -0.00493082451 0.000470025872 ...
                0.000138528121 0.0628402457 -0.00890055206 -0.00361452857 ...
                0.000522127608 0.00013953101 0.0410101637 -0.00761617254 ...
                -0.00280508609 0.000579659303 0 0.0108088767 -0.00402778108 ...
                -0.00158724189 0.00100576994 0 0.00446141139 -0.00223065913 ...
                -0.000711745466 0.000668672903 0 0.00157821854 -0.00130040024 ...
                0 0 0 0.00056559121 -0.000592843 0 0 0 0.0211499333 ...
                -0.00214661914 -0.000878736784 0.000159421761 0 0.0104458686 ...
                -0.002626898 -0.000938734389 0.00022487645 0 0.00764585845 ...
                -0.00248993887 -0.000849148 0.000290828117 0 0.00309036067 ...
                -0.00170683127 -0.00052979996 0.000582657638 0 0.00184323918 ...
                -0.00116625754 -0.000227051642 0.000419334072 0 0.00065785239 ...
                -0.00072952034 0 0 0 0 -0.000365424203 0 0 0 0.00139153865 ...
                -0.000298197119 -0.000107615459 1.42791878E-5 0 0.00122704892 ...
                -0.000539096945 -0.000217357185 0.000205436081 0 0.00104373845 ...
                -0.000614276563 -0.000175316498 0.000237110376 0 0.000710732536 ...
                -0.000658461591 0 0 0 0.000386299478 -0.000444071105 ...
                0 0 0 0 0 0 0 0 0 0 0 0 0 9.58563105E-5 -2.46048949E-5 ...
                0 0 0 0.000224340271 -5.59134387E-5 0 0 0 0.000206041164 ...
                -0.000206743716 0 0 0 0 -0.000176061672 0 0 0 0 0 0 ...
                0 0 0 0 0 0 0 0 0 0 0 0]), 5, 7, 4);
        end
    end
end