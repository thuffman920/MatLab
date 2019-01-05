alphabet = zeros(1,44);
for i = 1:44
    alphabet(i) = i;
end
prompt = 'Message: ';
phrase = lower(input(prompt, 's'));
if (isempty(phrase))
    error('You need to have a message!')
end
N = length(phrase);
encrypt = zeros(1,N);
for i = 1:N
    if (uint8(phrase(i)) >= 97 & uint8(phrase(i)) <= 122)
        encrypt(i) = alphabet(uint8(phrase(i)) - 96);
    elseif (uint8(phrase(i)) >= 48 & uint8(phrase(i)) <= 57)
        encrypt(i) = alphabet(uint8(phrase(i)) - 21);
    elseif (uint8(phrase(i)) == 32)
        encrypt(i) = alphabet(37);
    elseif (uint8(phrase(i)) == 46)
        encrypt(i) = alphabet(38);
    elseif (uint8(phrase(i)) == 33)
        encrypt(i) = alphabet(39);
    elseif (uint8(phrase(i)) == 40)
        encrypt(i) = alphabet(40);
    elseif (uint8(phrase(i)) == 41)
        encrypt(i) = alphabet(41);
    elseif (uint8(phrase(i)) == 58)
        encrypt(i) = alphabet(42);
    elseif (uint8(phrase(i)) == 59)
        encrypt(i) = alphabet(43);
    elseif (uint8(phrase(i)) == 63)
        encrypt(i) = alphabet(44);
    end
end
dt = 0.001;
dx = 1/44;
encrypt2 = zeros(1,N);
x0 = rand;
y0 = rand;
z0 = rand;
len = zeros(1,N);
for i = 1:N
    tf = double((dt * i) / (encrypt(i) * dx));
    [t,y] = ode45(@RealChua, [0 tf], [x0 y0 z0]);
    len(i) = length(y);
    encrypt2(1,i) = y(length(y), 1);
end
decrypt = zeros(1,N);
index = zeros(1,N);
for i = 1:1
    tf = double((dt * i) / dx);
    [t,y] = ode45(@RealChua, [0 tf], [x0 y0 z0]);
    diff = zeros(1,length(y));
    for j=1:length(y)
        if(encrypt2(1,i) - y(j,1) < .025 & encrypt2(1,i) - y(j,1) > -.025)
            diff(j) = 1/(abs(t(j)) * dx / (dt * i));
        else
            diff(j) = inf;
        end
    end
    for j = 1:length(y)
        if (abs(diff(j) - uint8(diff(j))) >= .1)
            abs(diff(j) - uint8(diff(j)))
            diff(j) = inf;
        end
    end
    [y, index(i)] = min(diff);
    new_diff = sort(diff);
    elem = find(new_diff < inf);
    average = mean(new_diff(1:max(elem)))
    decrypt(i) = y;
end
% plot3(y(:,1),y(:,2),y(:,3))
