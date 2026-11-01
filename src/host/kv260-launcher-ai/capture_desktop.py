"""Capture this board's 16-bit X11 desktop using libX11 and installed Pillow."""
import ctypes as c
import os
from pathlib import Path
import struct
from PIL import Image


class XImage(c.Structure):
    _fields_ = [('width', c.c_int), ('height', c.c_int), ('xoffset', c.c_int),
                ('format', c.c_int), ('data', c.c_void_p), ('byte_order', c.c_int),
                ('bitmap_unit', c.c_int), ('bitmap_bit_order', c.c_int),
                ('bitmap_pad', c.c_int), ('depth', c.c_int), ('bytes_per_line', c.c_int),
                ('bits_per_pixel', c.c_int), ('red_mask', c.c_ulong),
                ('green_mask', c.c_ulong), ('blue_mask', c.c_ulong)]


def capture(path):
    lib = c.CDLL('libX11.so.6')
    lib.XOpenDisplay.argtypes = [c.c_char_p]
    lib.XOpenDisplay.restype = c.c_void_p
    lib.XDefaultRootWindow.argtypes = [c.c_void_p]
    lib.XDefaultRootWindow.restype = c.c_ulong
    lib.XGetImage.argtypes = [c.c_void_p, c.c_ulong, c.c_int, c.c_int, c.c_uint, c.c_uint, c.c_ulong, c.c_int]
    lib.XGetImage.restype = c.POINTER(XImage)
    lib.XDestroyImage.argtypes = [c.POINTER(XImage)]
    lib.XCloseDisplay.argtypes = [c.c_void_p]
    display = lib.XOpenDisplay(os.environ.get('DISPLAY', ':0').encode())
    if not display:
        raise RuntimeError('Cannot open X display')
    ptr = None
    try:
        window = lib.XDefaultRootWindow(display)
        ptr = lib.XGetImage(display, window, 0, 0, 1920, 1080, c.c_ulong(-1), 2)
        if not ptr:
            raise RuntimeError('XGetImage failed')
        image = ptr.contents
        raw = c.string_at(image.data, image.bytes_per_line*image.height)
        if image.bits_per_pixel != 16 or (image.red_mask, image.green_mask, image.blue_mask) != (0xf800, 0x7e0, 0x1f):
            raise RuntimeError('Expected the board RGB565 desktop')
        output = bytearray(image.width*image.height*3)
        endian = '<H' if image.byte_order == 0 else '>H'
        position = 0
        for y in range(image.height):
            for x in range(image.width):
                pixel = struct.unpack_from(endian, raw, y*image.bytes_per_line+x*2)[0]
                r, g, b = (pixel>>11)&31, (pixel>>5)&63, pixel&31
                output[position:position+3] = bytes(((r*255+15)//31, (g*255+31)//63, (b*255+15)//31))
                position += 3
        Image.frombytes('RGB', (image.width, image.height), bytes(output)).save(path)
    finally:
        if ptr:
            lib.XDestroyImage(ptr)
        lib.XCloseDisplay(display)


if __name__ == '__main__':
    capture('/home/ubuntu/kv260_B3136/logs/vision-live-desktop.png')