lut4 = [-1+i -1-i 1+i 1-i];

lut16 = [((real(lut4)-2) + (imag(lut4)+2)*i)...
        ((real(lut4)-2) - (imag(lut4)+2)*i)...
        (-(real(lut4)-2) + (imag(lut4)+2)*i)...
        (-(real(lut4)-2) - (imag(lut4)+2)*i)];

lut64 = [((real(lut16)-4) + (imag(lut16)+4)*i)...
         ((real(lut16)-4) - (imag(lut16)+4)*i)...
         (-(real(lut16)-4) + (imag(lut16)+4)*i)...
         (-(real(lut16)-4) - (imag(lut16)+4)*i)];